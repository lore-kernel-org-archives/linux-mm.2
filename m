Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01868606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 02:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NQV8AZyh
Received: by kanga.kvack.org (Postfix)
	id D777B6B06A6; Thu, 19 Nov 2026 21:32:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28276B06C0; Thu, 19 Nov 2026 21:32:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17206B0708; Thu, 19 Nov 2026 21:32:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9235A6B06A6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:32:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C7D61A0D0D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:32:55 +0000 (UTC)
X-FDA: 85453924710.27.69B42B3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37BE84000F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:32:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NQV8AZyh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795141973;
	b=BumDBXWmyxa+VwxGti2v+uQxtviXMcnBdGwzh0CDbbEyIs7wVZxROZ9RxljLIFgamai9Vr
	7yIGVZN9OSyFBs7HSDY0Zao3lubWJuAb/08OAWamsDjFysiYIxjW0/3uCxRSnc/aNyoYlY
	Af6NdLtiSFHFhkfMQ+x0iT8Q8TADP7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795141973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4wXbm+O9fevfK2Qx5G101XrVBE78mAE7FgUuBIBaz4=;
	b=DZtLp7VKKO22iqRyXwgyHT9XkPfcr8rP9THuvkUU1HUV2/5p6NedAOkDssbYk303Xzy9L9
	dVaXqRcOm9kxBkT081K4CGMYBqgo1nTcUI/IeNTNuTijZ6T8ZPp1PTmgHAZyIXSF05xz4O
	iK/e6UmyhzvEK0tvtVwXQXFtmFz05dk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NQV8AZyh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795141973; x=1826677973;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=elISg0j4CbGtr/3NgbR8Wu6oUDLUFQ25svm7SwkGMDY=;
  b=NQV8AZyhGofVHng8lSi3IhYIxos+6Y+b0gqW4MW53cKEGbTg/hffkSWA
   uGvGiStMNzPRRz2X7bKbYKBxp92LNVknMGw+61+rFlcvI/Qs0gB6QZk4O
   aeWjJiHF7SZHV3e1m2Lh/Mzn8h/w0xlggPyLu0gHsHw6LjoM3OD+G7a/3
   qvn9AGtslViF2O7NmFWGb4sZk7J/veRDgbeNW2BPdCehKlLt0NljFXeub
   RB2nrrCTsOjXCxDbvSg5aBq02K41EyoxWNar1d61oCb3w5TltmD3kVKXB
   n6vrY1Sr+6oDePYkuEBZXO142pTy4LHtUrs0gPFPzHE97eIofAMbHskoG
   w==;
X-CSE-ConnectionGUID: 0gWBWl5pSfGAVXL6k/8fiw==
X-CSE-MsgGUID: 7KXty699SpyyCeXRMHv2qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3906653"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="3906653"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 18:32:51 -0800
X-CSE-ConnectionGUID: GSdlH1DaSK22flRLpa/N+g==
X-CSE-MsgGUID: c3Yw6mbvRpyxP3Y5GxfaUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="10577917"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 19 Nov 2026 18:32:44 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUEQa-00000001GzH-0B6X;
	Fri, 20 Nov 2026 02:32:40 +0000
Date: Fri, 20 Nov 2026 10:32:04 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Williamson <alex@shazbot.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: oe-kbuild-all@lists.linux.dev, Alex Williamson <alex@shazbot.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Johan Hovold <johan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Lechner <dlechner@baylibre.com>, Armin Wolf <W_Armin@gmx.de>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Marco Elver <elver@google.com>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Petr Mladek <pmladek@suse.com>,
	Pnina Feder <pnina.feder@mobileye.com>,
	Mete Durlu <meted@linux.ibm.com>
Subject: Re: [PATCH] PCI: Allow untainted driver_override for PCI stub drivers
Message-ID: <202611201053.O40xQFuN-lkp@intel.com>
References: <20261118235645.2907908-1-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118235645.2907908-1-alex@shazbot.org>
X-Rspamd-Queue-Id: 37BE84000F
X-Stat-Signature: 7qaz4njeeq8e9u6kwsg5prrc4ku8qyjw
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795141971-100076
X-HE-Meta: U2FsdGVkX1+CIdiHNaM/0UwRJxIdtAs2Og40lmQao5z+Jv+rL/Tkyp3tf6qesYbtlXgdePRP9K6r7Vn4uPuWGI22CwDtLDjylHQJzQbH/qbsTS099CevpTKD4cRdNbqSJFsVc5LhKzBtaFgz5StAFq3MXiSi0CrkYB9CLESSpJJfJA3TW98sllteyVYLXmUczFQp0PbTnELMaRyQ9vsB9q+J3hWRCJCFQb9kociEZPJsteN1g+Xl8iJViRuDpnu+WiEdzFCeWh2Dki7j1L5PQxUoWdZr3Dhhjmzxk/X39yNayOVyrLlc9A3q7fyJ2qOqtoLcLN2tn3g8UIU3q+za9IUPe9BdBOKfaCetO0fZHHGFilIeLeGIbouiT8r4OObneNReL1EYQD7OYHoJJlAcfTVBEssWvCCT97q2JzIIzUmm4s/e41H0hd4FGoix/2HPXIHVSmWeCufxXWMiJlCRjpute9i7O6Mc1/SvPg9lT2Ufy4PbcGVh4jQIOng2zMxB/rl93J8qqs6/I8YjaMZB7TpTv4HjILSCaw2L2pg7eHuvrYJg68HnYK1e3oFhns8mbZJofB+EIld0e6XojneDxdjKVyRW/DEMRBeLkqYGgwgbSsfNcEI21ob6dK5k9FpVW8/F4YUDX2ZB6Z8RF2CNvltJX/Xd0xCemXcHMPQvMmKfZZpLSgny1jKXFk4m2+SCKa2Udq1D0UYd4q7eph7EzgEKDZb+PU8jZR4a+RwJoJnsj4LiCq3VeItrvNPtYdjH7xB/ZVXBu1gdogbcSOxKTHwWj3nsw51etqrazDDgJ+NF1mbLBxlQFvkfebynzZMS9nP9TwWKeXzXwD2er+fsZ/RhHas7Ny3DD2zz0VuOrNlv1iQVpVe4wfUqTIhUCPjh2DOM0LTg/DLMEb7C/H174CkwhBY5U1tE0VN6UKZPmTu9+xFFhLsMIXNb9xqPwD6aqE+tlp8/vzj2v6G+3gg
 uWJMOLuU
 8yXBmrkjcRVfd3k0eFqoEHuIvQGmf3CDKADbuNJkKK3UaEI2PvFRQTFp+q+ytxBsbyQVf1jlZTSejkr0r/oTZ66lBpipXjwiW+EvclsWTe3HqIHu9IbHEfBf5ezlwAQOApR+FuSHae+5oTW3B1mdcI5NvAHO+/HT2APYf8HczGRFjJUuB0lh4QUHV7ja0QDZvA3cImLCbuzuvVafFU1/ngDzhIsmwooCWE+lwiFmuugt0MkMWrxjw+3l19OV8PxRt3/V+5JOr7Yc83cQqM2JQNs6III3xoaMN5FsVhkk9un/BEBs5p1EEOkvnvnRzLjoeRXDt03TNwSVkRb7JyQ4bQ+Xovc2/iLLJkGc3Df/RIglnzSPqX7YnF5J88ibAa+pYddnfIJK2S9AL5NLadbXODlRzIHiBgm+NNAHRPYte7kDYevlh4ylxB6bBg+v8ClsshPN2jjiSGbrtysNKjItHgxYomSNrRcUh0G9wCCnal/on1LXUbrhuBI6BjuMsUKBKtYLiClcY/ky8WagzLnbz03ylNlNJHlJWLyg6wJ03VT8h8PZIJBeyU/zCGEnHsSFypOi7LjjCDMqIOcwfzmaAEdwlp5dgtSvZIZ9/1luy7GvXlSSIjqCTgEs0uySonZObCr+01G56g/FszavN5w/JTklexRNMsbyVfkMc+aOf8oq3k5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alex,

kernel test robot noticed the following build warnings:

[auto build test WARNING on pci/next]
[also build test WARNING on pci/for-linus linus/master v7.4-rc3 next-20261116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Williamson/PCI-Allow-untainted-driver_override-for-PCI-stub-drivers/20261118-165643
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/20261118235645.2907908-1-alex%40shazbot.org
patch subject: [PATCH] PCI: Allow untainted driver_override for PCI stub drivers
config: s390-randconfig-1000-20261120 (https://download.01.org/0day-ci/archive/20261120/202611201053.O40xQFuN-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611201053.O40xQFuN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611201053.O40xQFuN-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/pci/pci-pf-stub.c:39:17: error: 'struct device_driver' has no member named 'support_driver_override'
      39 |         .driver.support_driver_override = true,
         |                 ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/pci/pci-pf-stub.c:39:43: warning: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      39 |         .driver.support_driver_override = true,
         |                                           ^~~~
   drivers/pci/pci-pf-stub.c:39:43: note: (near initialization for 'pf_stub_driver.driver.name')


vim +39 drivers/pci/pci-pf-stub.c

    33	
    34	static struct pci_driver pf_stub_driver = {
    35		.name			= "pci-pf-stub",
    36		.id_table		= pci_pf_stub_whitelist,
    37		.probe			= pci_pf_stub_probe,
    38		.sriov_configure	= pci_sriov_configure_simple,
  > 39		.driver.support_driver_override = true,
    40	};
    41	module_pci_driver(pf_stub_driver);
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

