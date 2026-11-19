Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652A6606A330
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=WMDYvOsN
Received: by kanga.kvack.org (Postfix)
	id 4D4CC6B05DF; Thu, 19 Nov 2026 11:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E426B05FD; Thu, 19 Nov 2026 11:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D736B0691; Thu, 19 Nov 2026 11:52:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09E496B05DF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:52:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C586C0B63
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:52:01 +0000 (UTC)
X-FDA: 85452460842.14.E865190
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf03.hostedemail.com (Postfix) with ESMTP id 99CCC20007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:51:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WMDYvOsN;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795107119;
	b=2jlas/4FeJ+9Eh6qN13BEXn+xi3Hq6j/GhmmS127Y7bc9Svn3mQDMM0iSeOIW1GDEVFqJo
	WVO1WEHB33TX8IZwC/DlaP/qyPLxwz1bVnvMlAyqF4RxMJ8CokAhFWo6H2lwcYQY1RFF2g
	xOEkGUU+G2oAYLdv33rZ0Jjl3EQzf98=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/6DH3FFwvRnKAIbOA9Jvsbx865824E9HffR4ETwzIo=;
	b=zMj0vMYSNoGysCGEyGPx3TjUdnFT3EaKMGU83Xk4f1nCshQm4NCRcnT1hgqBaI00/3j6gw
	oCcozEXxwds7kCpuXRYSrds8M9EMyaPQPStAn7MY4dpRuL2G0ryWbJzZ9GLzssqo/SP8F9
	x8Q9jyJkvY7tzibw+Ba5I2Y388IHHDs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WMDYvOsN;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795107119; x=1826643119;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=alpKBfZVPL/sOG9hyOB2rfC3cwy67Mmj2pXdbSblBqE=;
  b=WMDYvOsN6EdZ4grMxPZPhZMgfhYK4xgHj6WfJqqW4lkTdQ9gl4NrnREY
   QYG2e2OOkp48y/HmXvz0w2DVTHYgqpmBZvXJGYQH7euI1pe7/KCQAMIZo
   Fdcj8wf9ebHsli9uXgMwe1iwiqCfyzbWhniDc5XosOu7yjqsXDTp3qWhn
   PMg8D9iMarJdJaP/adJLXwFE9S9b+GAevwPWDY/IuJEyf4+nEvi+tvA/W
   FV0PKNBuftntEcydKaITIcEO2NS7IvsNJ5+p+8/ia+CD8T7kOF13vVEAf
   kwm7/MlZsz4vL5x0Q5QFmDx/qO/BS1YDA/qXwUH9C99l7/wmTjydnz0dD
   w==;
X-CSE-ConnectionGUID: 4Hb7URJ/R6GeWENycLJa+Q==
X-CSE-MsgGUID: GqcgdvsMQcmMUFOmVQ5IHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3972915"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3972915"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 08:51:57 -0800
X-CSE-ConnectionGUID: ix55b9qhQo6NvrkZ3L/Vxw==
X-CSE-MsgGUID: cM8nOYnpT0+ilSSf+e7fkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10361290"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 19 Nov 2026 08:51:51 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xU5MR-00000001G9u-21E4;
	Thu, 19 Nov 2026 16:51:47 +0000
Date: Fri, 20 Nov 2026 00:51:47 +0800
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
Message-ID: <202611200009.RQOE0yny-lkp@intel.com>
References: <20261118235645.2907908-2-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118235645.2907908-2-alex@shazbot.org>
X-Rspam-User:
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99CCC20007
X-Stat-Signature: hpk9ddyeu56j54iccoznw3jsuiq6spfu
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795107118-47585
X-HE-Meta: U2FsdGVkX1+OKH9+LwJESNCHhr5Te61fdVI8PZ4uR+GVmd2qvguwBMFG+GnvnuWt2dj1N5cmGBgvK5vcW6Nmfw4SCh44Zf4RVyXwYcgvWZl26btokHuKxggv0IELBSWVZ5UVzyFeBm7Sjg+Pp1jwnOZOhbYZ2rRv+lKNAw7vJu2gUq8DmJrhyPEMuW0W7twTQc9MrEkvu0AbYg5AO2ur0kCD34AdoG5BzJ7UjzPszdLKikk9nxjxLn9i8Z6EX81bO2Id7GeJLpclRa9+AxkKr+EcmYDCJUrQmW+FuL/JSA0BB04AsLZh+Krd3T8iy45Aow3BwgaZy3J2YdysS8OfHg6psgHmNXLAaXpWqtHIQGC0itxWfFLD2V0KqK4dYAPx7Iz3U8POAMPV/GghcI4YgAb07nhb1m8Xs0O9hkpMMYdXpCs3SsDAbaVkutONqj4gsy4xygUBpSfLGAbf0n4roEaL6M8HPjzmKv6i4R/I6ucl9QjYg7TPO9KY6KsoDf1TuAXlwVUK216YZWrnBTay7kX1edYiZjIof4edsIVf0qx8BcM4aVZNksvv+lCBwy88uos8YAaI4Jeyh8GcfqnTMib3FJ/JgE9X2o/RBJ7k4S8QsNkM8EP6mU3dkSNdOsdG9PRrZtGlYHmK3xccdl9m0giSJaSEUEC1cwHwLOZ26EJUY0vi2TBxRJB6rNM05Q/i6/tseMj2BB77QOtNdR3kRTLwHUQHaZSw0qeOMOM3fuBlVaFKoVHt05l/t5DMx683cd/P3Qg8xHYj+xUzak4iR7/oTwBRfq8QbRpcWvJxycxwOh8aUzk3Q/RPnXim4dlCRrbjDXeKlCyeGj4128OLQREtEGS/3+2rOGRlXTkd7k+tgC/DFewgTxuZVsaRS36pdERmjfq/QDOvcf32DKPMis2XVDlmhQAZ+LXePFWvNkzyuxJRaI2xqPsbqzlygntUWhXx1JhR/VHyWHNnjPL
 T+HnSJXM
 6TM9LPfUfcHtPbegOCaYzoPNjArmeX3j/6ChM79rhEKtgrqCNTgXCevzkbQUQXr6PQXDkNAOp/CTucEsg6JfvcyY4jI8X5IqMCoAZA2JN7ugCdExgoqeFVNoTKIGTEyVp4/HRUwDVN4SjDfDU2UKIyEBY7e84AIxwz9Hp8VClxtmW/lAYEvZBoz6v2lV3ADVG6WcEagwLf5rdFT52N6NSmUqAGo002mfVLd1NCsdchZxbYwMShlEnKZDW/6WuzYAAWyOHWE3Itkb9qI3rswpCRwnCoT0RozUBURvCDEioTGn64IHW5Hp/dA/RjkC00moMbH5HSuIPlf0TAyOQ5bhZhJpPKYgz/U/Oub25H2mll8X0NqHxRHa9Pm1xjStQrZjBnCsy8MTiIfUqGc57tYebfQxYSfMHh99YWzMtpPcw3IxT0D0k2WiDchVzz2BMBDIFDTZNBEXgSUdFDuOyGCxK6hC6/TfwYgo+XsQGXCASBfhbWE5lNbGFKSQZZz/2rlScRPSOU55MPGhaGROKCszhPfj5Iuh9NNs8ePEG6w/6EF7+1zkGSbKvxRzvq0/Ax9mrtLNRtKq54ZkdTiifC3OeX+q/c7+fP400jwPv5xnXYiecpas=
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
config: arm-randconfig-1000-20261119 (https://download.01.org/0day-ci/archive/20261120/202611200009.RQOE0yny-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611200009.RQOE0yny-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611200009.RQOE0yny-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/vfio/platform/vfio_platform.c:119:18: error: 'struct device_driver' has no member named 'support_driver_override'
     119 |                 .support_driver_override = true,
         |                  ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/vfio/platform/vfio_platform.c:119:44: error: initialization of 'const struct bus_type *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     119 |                 .support_driver_override = true,
         |                                            ^~~~
   drivers/vfio/platform/vfio_platform.c:119:44: note: (near initialization for 'vfio_platform_driver.driver.bus')


vim +119 drivers/vfio/platform/vfio_platform.c

   113	
   114	static struct platform_driver vfio_platform_driver = {
   115		.probe		= vfio_platform_probe,
   116		.remove		= vfio_platform_remove,
   117		.driver	= {
   118			.name	= "vfio-platform",
 > 119			.support_driver_override = true,
   120		},
   121		.driver_managed_dma = true,
   122	};
   123	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

