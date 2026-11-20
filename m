Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47DCD606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 02:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B9nu9pQG
Received: by kanga.kvack.org (Postfix)
	id 5D91E6B068C; Thu, 19 Nov 2026 21:14:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A9E6B06E1; Thu, 19 Nov 2026 21:14:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4784D6B06D6; Thu, 19 Nov 2026 21:14:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19E8F6B070D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:14:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 847BF40CC0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:14:48 +0000 (UTC)
X-FDA: 85453879056.04.2BC2455
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf04.hostedemail.com (Postfix) with ESMTP id 785E740007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:14:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B9nu9pQG;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795140886;
	b=M32Oppm7OuVy+6G2F5pKrcwYklN1KhXgP64creEqjYrKl6xxBkjAAmyFXQ6fIVKNVq3p25
	ZQC2mHVCTYFAYiQvf2ruvo51JjyGnbll8CCAlwBmOPLhEJBX3FwDCI0IdlHCnOnYhhG0FW
	e1gk98Zy0PuHO2vPoY1AWkwmHCgbz2o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795140886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdLagE20xckeK88G2jVV+nvgmytAhD6GFPZ4ISYn+ok=;
	b=6blbjbd4W0I84ThzvV4JcjobDPAWke6GZLxmpb1sembyR7RWOCUjT/WPtvGnfv5LGq1QQY
	DoKLux4KQ9k9mh78PbQyvIoxloSHiYqiSWY6KzmbRdT4yrkiUmvD5uJBaeF612afTVmt6A
	E9m1IsHFAbAzv/OvpkLOjVXp3SrkljY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B9nu9pQG;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795140886; x=1826676886;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T9Y4lim52oYCdSAIVMkmqTfqUDlfhPNGv2sRd4QoMNc=;
  b=B9nu9pQGJPZDjxeazLcHJxsJ6sZ7pNR+4V2qiW7bNa5Rrc5UBo+JRbEC
   zff+15QHfacnG2x9P1wedtXOJe5iKEm1zBAhA00YqxfaxFCQGn/i4VmRm
   R/op2G8Dp4uxe0vi8ould6YgZ5zujsNQF8ibggPo0bP0TYk0YhOQRSElO
   PClfwN0/fJP2I+lik4aLvt5A5oc7cFO3Bg16XIHBc9mammQYx2/8QWuM3
   RdHF7uGZGhZ+0BZ4c8UxBazLmiREEAkIgP1hTJNfeyMVMBumYHKEvY4Yk
   MULujcW2Mn46Mkrik2/qieQC/W0fYf96ILHvjzYC7gX8i0NbaHZuMSq32
   A==;
X-CSE-ConnectionGUID: Y2wrQEc1Qf6BZov9Wc2SNQ==
X-CSE-MsgGUID: bMZqOuv6T7WzFkKLY26yWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3912495"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="3912495"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 18:14:45 -0800
X-CSE-ConnectionGUID: snmrXm6GRDqVl7DgsoHI8g==
X-CSE-MsgGUID: gvmG+in/TbC0emdaGi1Lbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="10727124"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 19 Nov 2026 18:14:37 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUE93-00000001GxR-1lW1;
	Fri, 20 Nov 2026 02:14:33 +0000
Date: Fri, 20 Nov 2026 10:12:57 +0800
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
Subject: Re: [PATCH] s390/vfio: Allow untainted use of driver_override
Message-ID: <202611200956.drD2v0r8-lkp@intel.com>
References: <20261119051507.3306075-1-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119051507.3306075-1-alex@shazbot.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 785E740007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pcxddi3ojuyz611fye4c1b96tp3b14ot
X-Rspam-User:
X-HE-Tag: 1795140885-994526
X-HE-Meta: U2FsdGVkX1+WsHJ930g9Iy++wGwq6VzibrQbhhkHKoeibVaVSgA/Wn+SupvDrjOJ9w+oPYjXksqpJhdT43G67QFM/TXbGoeRjKezABj1iZ0dMV4wbmGISjyXdJdtSEeQV2ZRlG7MqSSTMhFe6IEf0dDRUq1HfKzKFTjRTkPUK6m6MSB1LfjK6JwOLiy9H03VlchUhFTRMYdeSzx7HO/MD3zpU5PqGhEJxv1xjILG55kIN+pezvPn0jDaeF9prK7xBxD/0XqRgur+OQ4vUPjKBuDvRvHzc7wshnowP8xk8LiDr45+1lklwVqtsYJVTsgjTKuYVAGztA8HNHBzUM1D96BjDXPizO26tEMw4z28MDv8kKmFYDBHsn6BgnyFZ217Bni+463+QCD3h/8JKiGARLBTqCjJ/kN4H/ncEyd3dqwsGvv/vXVTgUEG154NGQ1OEJwYagRJKkVhZytW+gNKMLV7R93cW6hJ8l34ALuJegRzbWaK+yb5XKFe5DF7T/H9Vn+357p6EZ0mMvjskwK7i5lfsFndBTl6J3NRGBGlJE/3VJ2eGIW5yQpujOJOSm6Yz8py//eJXEQh/8lRC0jplyfCMbV2Xjnm89J0R++KX3B9XotVjTavZno/+CGO0+jqxSCxp9sHQCnQ/6lspnRFouf+mW71asy+JwAf2ndMcyXGxtifczRSDSzbu0jI++tgLuFqTYsJ03GqNp9D+Ve2e1AgZJHUggagNpWO+KWZSNlckL6GX4ca8oEZLK2hss39K9z3y7N6cld/VwmFYzkAfinUtkuoTBIom+lVjZGxzEt2R27TIFGMIA+ZLd1srH7iUCOUQAY99yXCVrkow21fkuH58DKgkg7DRTurOSiJgNSOt3dPd9FkQ+8LtLsUNC7UyWB3TUtq+ArJewoYnmUHgEOTHNNxU+wRXSXP72YzFvb+Dm7jq842OsE5i/EGWuxCi6VPIR3z/bP6hJWzrhC
 QQg6ZlEI
 Xp1Dfq0WOlZ6O0bbb//ISVtn+G/FBdKwUli3q3s7f8IUJzWRcVNDOkoChvkasF/kXUkAOIq/mG++z1AYNF0KsGq3xca2C88txsBQt281Go5fB2MDnmtbEsOLdjhcHKZwf7jzteNtRopRxIt0fz+MX7ylBK1f4jvbvf8kVxGYbfSblv9rdDY4RIf1TYKDnCknOuY9k2FcBAVIJeeb7mPFnZ1KrRA/6Yef/cOIZTdTnlxNZIv6v0SJoj2wrHwW/+VIQ8CMVeGwqoXHmN8QDE+3lrH38r0mTSFaHYVCGxDawQAs5hCXUO8byX0ePlQh2ml5/0j/QR3T7/yygRb2d9rc/eelJF4sM7P4OrMyYwk5TB18G4cviSZLTzwRAcB6WHyx9m0CFFta8+3av0CLlynfN/SJYtM/fzh0ccJY2A43O9DN99EpSOtVM1n497uQkW+n4tRt81DKNWHb0SW685tt4Ek7qnVjZTgW8Bj5ra80eePPKy/p/h34kH8dA0nJKZLGVjMRiCCnfB4t7p5dDS5hmcNRHiRakl0bg3HMRlFwurKxhBowhCGUvwqKAwR5slPvJEGvhxUlqzovTKyycl3paCFkuwnSOPjYM3gKrqG2rd80xugli2BYvtp7Vf3U77dQWvBw6dRprpln2tLXnnQLbYj64PpwvCdTjR/ktQRifJCY4vTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alex,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvms390/next]
[also build test ERROR on awilliam-vfio/next soc/for-next awilliam-vfio/for-linus linus/master v7.4-rc3 next-20261116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Williamson/s390-vfio-Allow-untainted-use-of-driver_override/20261118-221504
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git next
patch link:    https://lore.kernel.org/r/20261119051507.3306075-1-alex%40shazbot.org
patch subject: [PATCH] s390/vfio: Allow untainted use of driver_override
config: s390-defconfig (https://download.01.org/0day-ci/archive/20261120/202611200956.drD2v0r8-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611200956.drD2v0r8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611200956.drD2v0r8-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/s390/cio/vfio_ccw_drv.c:378:4: error: field designator 'support_driver_override' does not refer to any field in type 'struct device_driver'
     378 |                 .support_driver_override = true,
         |                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.
--
>> drivers/s390/crypto/vfio_ap_drv.c:65:10: error: field designator 'support_driver_override' does not refer to any field in type 'struct device_driver'
      65 |         .driver.support_driver_override = true,
         |         ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +378 drivers/s390/cio/vfio_ccw_drv.c

   373	
   374	static struct css_driver vfio_ccw_sch_driver = {
   375		.drv = {
   376			.name = "vfio_ccw",
   377			.owner = THIS_MODULE,
 > 378			.support_driver_override = true,
   379		},
   380		.subchannel_type = vfio_ccw_sch_ids,
   381		.irq = vfio_ccw_sch_irq,
   382		.probe = vfio_ccw_sch_probe,
   383		.remove = vfio_ccw_sch_remove,
   384		.shutdown = vfio_ccw_sch_shutdown,
   385		.sch_event = vfio_ccw_sch_event,
   386		.chp_event = vfio_ccw_chp_event,
   387	};
   388	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

