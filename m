Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01C1606A334
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Mh330Ryd
Received: by kanga.kvack.org (Postfix)
	id B162F6B05FD; Thu, 19 Nov 2026 11:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78D56B06AB; Thu, 19 Nov 2026 11:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941036B06B4; Thu, 19 Nov 2026 11:52:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF6C6B05FD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:52:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E91C2A06F5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:52:01 +0000 (UTC)
X-FDA: 85452460842.20.6163845
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DDA91C0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:51:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mh330Ryd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOmSWaH0NoseM7eEQor0PCauI2FtvndXKKCrHJYdp5Y=;
	b=r0+F2XWWZcxLjdoCphBPzh4kodJsGxVXfHnshzl+sKhr1BC3ZWalF1UHsV0OGqIVHYcvYJ
	qqIOmpjP+b+ptX3KJYajGYaQESTfY1p3yufTNh916M92CDgfyJI+fPTomKZh9sN0xryjjb
	MhmfEyMImJ3NdtyjW1Rzcd1tizjky7c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mh330Ryd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795107120;
	b=38G/LzYnWOywEJ5mnFD6fIL23FN5nYXc5D3n/puoz5n6vK7qdWFpuCzuxzY16UiH5E7Q/5
	cAAHZN3tBOEbEwzAetYolkdNkCh9/xiMjX7epEM8EmLBaXLEejLnmUL4jviEmMBYVeBVVW
	bL89H94X1CttWGdXCneyzD786w8C3SE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795107120; x=1826643120;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Ypv7CUPwYDm+rPJoVRIsIBp43C79oWLpiPYtRb+HX8=;
  b=Mh330RydlqFFgeJ9bVjZUMaluTMjTciWqkIxnnOnEvsBvv8i344P4Sma
   z99bsWGHgvU+/gJppGy2cXJTw0oU34IDfI7S2jVPd13VWzAJOGIouZkao
   JeUiLn8RHfIe5U3FlN3yQp6H7QASTrn2sCmQxWxt4wvMBR28yvXp1KtyK
   VcrVs9wQSdBB0AWd5WaZSeQq4kc2xJB9nO3lRbr5j5rkP5vsa4XpP+QkD
   gv/kPykNtuCwq8CTujggh7cua3mK1DLOeBuQuQdD0HFDtOF7DVb7ZOxmN
   S6cbTDNNWGeE//gS/iQ6u7JXUa2IfvwVaUB7CsNJxen3NbJpLX6yQL8xu
   Q==;
X-CSE-ConnectionGUID: 5FGpxySNQdOXQCuY1r4EkQ==
X-CSE-MsgGUID: hLogkl3SQBuMsGXMaFV8ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3886053"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3886053"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 08:51:58 -0800
X-CSE-ConnectionGUID: 47DHlI57QH+bfQ+a9JbaIA==
X-CSE-MsgGUID: /NxNv2KZTm+aJAcr17dwOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10811352"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 19 Nov 2026 08:51:52 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xU5MR-00000001G9s-1vGF;
	Thu, 19 Nov 2026 16:51:47 +0000
Date: Fri, 20 Nov 2026 00:51:44 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Williamson <alex@shazbot.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>,
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
Message-ID: <202611200005.ynk0zwGb-lkp@intel.com>
References: <20261118235645.2907908-2-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118235645.2907908-2-alex@shazbot.org>
X-Rspamd-Queue-Id: 5DDA91C0003
X-Rspam-User: 
X-Stat-Signature: umz1yfwkozsxyyocq11se4sjdu4kqqw5
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795107119-778639
X-HE-Meta: U2FsdGVkX1+nuh0UxBbf3iqWXl+Nj5o2hMNGj5X8lt+EzTPaV3q+4rnmFgurhblUCSpADABSEYOL/sjWC1ilRB9veHOiyUzUhUhHX9OCe3rKVukwBxOqojzWEUYlVbHnYsbzMoDDNV6tcPaSwRsvehMhzG9sKb8nKu76cpnJVND+SOs1hNcCUYvq8GcTuff7U7QWR/cg2u8r/PEBgVTzuzdtM74ev26Xlsx9tOWpErxwoGFpX/ggU/WB5Xe4Qnyc89s+zQVpO0Kb92Ab0Ow4Mys6B8ytswLzg9iYVSg0E6nLmdl8F4Yk7pH6nByAj95hhqh1UxhZWo6glJX/OSTQG2Y5/B25lGZXa9SsMLipIJ3IjFJYcsDS3YRdJ7eE2nkQIcjCwCH2KF78Y7h+zWrQcceLoEwrPlcfEiF4sH/XFAo3DvkF3Im5M0SvnyMYmoMsvfFoPSvrsoteuMX1Gk0SbXikaPk3R1K1TCLBaheD4J0rgz94OLmUHWsNZ4E3qVo0oS1u7GznYC9yg2CY7Fa8ru+5tNuWJKH1hlTc9Nx2AyC4hBo5S2NcIptRUIGkKaw96GuUUnxgIfLt9cK2KYgVEOgwcUEPMP+yIL234HACwNfPXAa1Q6Y7QN0lFI7To8IO0mu3Lxy7gq++DouMtmZoer3vP+ecaFI+H5yVA7aP8iH8Pyr3HgOXTFDYvlfsh8dNLiArLmu45kxNNvCA5m+u+PLUwOa8dTu57k+UFMZTO8avj3ad0iE+4dVKqOh0nG2h9FjXUctPqBemMMW/kEICVIy+rF7/B0CIYshbKDFcoqj5Sci0oAG7uRzO2WM9kyNFU51SxAsmkN4ppvcKm4wV+DpvA2vgYVWdmxyKJsN0SQvhYxWE9VrjLsmYUMpZRboBqh4mtc3siewTLfWYcRd9VtZNCghN+Wvi8JsbH+4PxEA+T3v/m8aVJXacUajq5Na0ISQCkcOqdCd6iNlC6Bs
 wXo2ud4F
 pN87OKlCDz+yYcgr0Ecny4X0hRbYbeYuTvZ4JPs2exdAzqUN1AmKwmXft/f9SLuqfVjw+XHOGeKI4FUd1S36SCMFIBa5M8cVQSav6McbJWVxAgozvX2ASp+6qM8wizBhPZssO4Lhx3hRuedOS2k+gk4mhqG4Li4IbSkFZybLi9G8pPREzd5bECEliKibgEC4fSl6wFtFrHV+5NLB6guLVd0nPaP/prKqoGSuzGXf2meMkal4WMNs2t69242+msMxfN1PzeJRiTuD7AerXxSJXUSNxbqr+Bf0HUfNjAUoOhtN+QhymY/z3wDBfpQayfGa8ZN/bf+B6NWpWucuHSLEa6ebQek3xpm3wPPpcx77l5ZGIDRNVi1gdN7TYcLIlBiG4BWEJw7nqHD2wTSo442ZLU+V8EXMGoJ2IXK0gO2Fd+sGUnnQ34CKxZ8qLZq9XQLciudCla3Pw0RifrJdWRDkZs3l4zwli8NwobWSyz4DlABD8VuCjISaoZWRJjXgPACQpRa15W2QrSkp7PaGPc2fUiV5rcXx1FR2zOuGO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alex,

kernel test robot noticed the following build errors:

[auto build test ERROR on awilliam-vfio/next]
[also build test ERROR on linus/master v7.4-rc3 next-20261116]
[cannot apply to awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Williamson/vfio-Allow-untainted-use-of-driver_override/20261118-165644
base:   https://github.com/awilliam/linux-vfio.git next
patch link:    https://lore.kernel.org/r/20261118235645.2907908-2-alex%40shazbot.org
patch subject: [PATCH] vfio: Allow untainted use of driver_override
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20261120/202611200005.ynk0zwGb-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 3b14d7c370558b46e5f0c6494a05c492e59bf32c)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611200005.ynk0zwGb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611200005.ynk0zwGb-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/vfio/pci/vfio_pci.c:264:9: error: field designator 'support_driver_override' does not refer to any field in type 'struct device_driver'
     264 |                             .support_driver_override = true },
         |                             ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +264 drivers/vfio/pci/vfio_pci.c

   255	
   256	static struct pci_driver vfio_pci_driver = {
   257		.name			= "vfio-pci",
   258		.id_table		= vfio_pci_table,
   259		.probe			= vfio_pci_probe,
   260		.remove			= vfio_pci_remove,
   261		.sriov_configure	= vfio_pci_sriov_configure,
   262		.err_handler		= &vfio_pci_err_handlers,
   263		.driver		= { .pm = pm_ptr(&vfio_pci_pm_ops),
 > 264				    .support_driver_override = true },
   265		.driver_managed_dma	= true,
   266	};
   267	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

