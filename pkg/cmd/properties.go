/*
 * Copyright contributors to the Galasa project
 *
 * SPDX-License-Identifier: EPL-2.0
 */

package cmd

import (
	"github.com/spf13/cobra"
)

var (
	propertiesCmd = &cobra.Command{
		Use:   "properties",
		Short: "Manages properties in an ecosystem",
		Long:  "Allows interaction with the CPS to create, query and maintain properties in Galasa Ecosystem",
	}
	ecosystemBootstrap string
	namespace          string
	propertyName       string
)

func init() {
	cmd := propertiesCmd
	parentCmd := RootCmd

	cmd.PersistentFlags().StringVarP(&ecosystemBootstrap, "bootstrap", "b", "",
		"Bootstrap URL. Should start with 'http://' or 'file://'. "+
			"If it starts with neither, it is assumed to be a fully-qualified path. "+
			"If missing, it defaults to use the 'bootstrap.properties' file in your GALASA_HOME. "+
			"Example: http://example.com/bootstrap, file:///user/myuserid/.galasa/bootstrap.properties , file://C:/Users/myuserid/.galasa/bootstrap.properties")

	addNamespaceProperty(cmd, true)

	parentCmd.AddCommand(propertiesCmd)
}

func addNamespaceProperty(cmd *cobra.Command, isMandatory bool) {

	flagName := "namespace"
	cmd.PersistentFlags().StringVarP(&namespace, flagName, "s", "",
		"Namespace. A mandatory flag that describes the container for a collection of properties. "+
			"It has no default value.")

	if isMandatory {
		cmd.MarkPersistentFlagRequired(flagName)
	}
}

// Some sub-commands need a name field to be mandatory, some don't.
func addNameProperty(cmd *cobra.Command, isMandatory bool) {
	flagName := "name"
	cmd.PersistentFlags().StringVarP(&propertyName, flagName, "n", "",
		"Name of a property in the namespace. "+
			"It has no default value.")

	if isMandatory {
		cmd.MarkPersistentFlagRequired(flagName)
	}
}
