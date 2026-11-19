Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55AAC606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EP+PIYaZ
Received: by kanga.kvack.org (Postfix)
	id 322306B066A; Thu, 19 Nov 2026 12:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB496B068C; Thu, 19 Nov 2026 12:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20FCE6B0690; Thu, 19 Nov 2026 12:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0420F6B066A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:49:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D373C0B96
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:49:40 +0000 (UTC)
X-FDA: 85452606120.27.8EF9CD4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id B5E12C0027
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795110563; x=1826646563;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A/J5nq/xKqdeWa+x6wK6TKgb+xxyzfQwFmtoS5NTXSY=;
  b=EP+PIYaZMhYvFVlEyzoaHxRCg4xkMYCboXxpL2uweTgjcdBq9dBcC3+E
   H1E4ECGuyG7Oq+N3muKlj7Ouph9YQetJFO35Pz36oVYj8Jf2kLEZZJZe8
   ZE68gXIg/uwrq1i5glXWMfZHX9LM+WTKO4QWRaLocHfLxsUSy16F7T+RB
   RKNMPcVHIcIIsTMgD/dGa8Ci0Z9e4HX6prrwhc+PCN9VzLjs3ewNlJTb/
   D7NwsnSzYnHptXBu6R7rjIwl0iOvJY1ZZ7475vLbqkEE0cKqfkKBbfrDx
   LJqqc27F4lLXm2eZ/Cpa4up7SycYxT07fqhBJeZjdEq8jxEYv/f1sJif+
   Q==;
X-CSE-ConnectionGUID: bDH9qJErT3K8MZAhgIx5kw==
X-CSE-MsgGUID: dp14sjrjQ9y04TAWTvA6gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3822063"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3822063"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 09:41:16 -0800
X-CSE-ConnectionGUID: 30vIl787TtuN+WjijE5STg==
X-CSE-MsgGUID: zruBp4AySZy2bNCTKELpPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10825046"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 19 Nov 2026 09:41:10 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xU68A-00000001GH0-0Dp9;
	Thu, 19 Nov 2026 17:41:06 +0000
Date: Fri, 20 Nov 2026 01:40:21 +0800
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
Subject: Re: [PATCH] vfio: Allow untainted use of driver_override
Message-ID: <202611200125.3szMlcTc-lkp@intel.com>
References: <20261118235645.2907908-2-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118235645.2907908-2-alex@shazbot.org>
X-HE-Tag: 1795110562-719536
X-HE-Meta: U2FsdGVkX187Th5PFai+iIZGmEzWG7nV4QCFTPRu9iaF+BkwO4mLzTPq6FFujr/0XVw2pPE7Han6DNqB8eUDkI4blkaAc5ABInag8aUAxOkkn4rn7lHMpO0HAKda71cCPThriQ+je6DbPJlJdahjoiRLgAGM8rb9EvwdDdXQ/AsdELgV1wl9nCd5iIXZ4soqyXv+ml4ChvvEkz3kCNirNj4PFfBMb95hGp5KPG0A+M0T6pWxcv5j/U0Hy6Thjb4nd/SZunQpZ337p26EsSfuKoBtHxWocaw7MoPFii5wMwP/jViP1NABfB9gr5TJwD3aMzltIfdqycnHnhf6hQsY2y/pLFSUUBWfdaLd2/v9QNRdjx/4J8yN3b6MgY+Vxi/vO3zbnAuthCp0nBwHEqz1QyAc1AdDHWehhv/pc4t7roOCr99jrwyO8+n8IvZuT3ff6OvPqwTBeHYolRnby0Aken8VkB7zcGApA7C8BVAluoQ+64hw4KR5rCrEuGRtt0uaniIuFFPeLD53PzEw5cqrqDFW+4sJy5B99hGMCGcKgu63yPISX6smOi4FmieAQ30sosMzmn6DGfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alex,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/next]
[also build test WARNING on linus/master v7.4-rc3 next-20261116]
[cannot apply to awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Williamson/vfio-Allow-untainted-use-of-driver_override/20261118-165644
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20261118235645.2907908-2-alex%40shazbot.org
patch subject: [PATCH] vfio: Allow untainted use of driver_override
config: sparc64-randconfig-1000-20261119 (https://download.01.org/0day-ci/archive/20261120/202611200125.3szMlcTc-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611200125.3szMlcTc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611200125.3szMlcTc-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/vfio/pci/pds/pci_drv.c:188:22: error: 'struct device_driver' has no member named 'support_driver_override'
     188 |                     .support_driver_override = true },
         |                      ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/vfio/pci/pds/pci_drv.c:188:48: warning: initialization of 'void (*)(struct device *)' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     188 |                     .support_driver_override = true },
         |                                                ^~~~
   drivers/vfio/pci/pds/pci_drv.c:188:48: note: (near initialization for 'pds_vfio_pci_driver.driver.coredump')


vim +188 drivers/vfio/pci/pds/pci_drv.c

   181	
   182	static struct pci_driver pds_vfio_pci_driver = {
   183		.name = KBUILD_MODNAME,
   184		.id_table = pds_vfio_pci_table,
   185		.probe = pds_vfio_pci_probe,
   186		.remove = pds_vfio_pci_remove,
   187		.driver = { .pm = pm_ptr(&pds_vfio_pm_ops),
 > 188			    .support_driver_override = true },
   189		.err_handler = &pds_vfio_pci_err_handlers,
   190		.driver_managed_dma = true,
   191	};
   192	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

