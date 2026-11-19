Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E219606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=burPu0iL
Received: by kanga.kvack.org (Postfix)
	id 332BF6B06AC; Thu, 19 Nov 2026 17:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309B96B06FB; Thu, 19 Nov 2026 17:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220A96B070A; Thu, 19 Nov 2026 17:56:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB8C06B06AC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:56:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63E45140C2A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:56:27 +0000 (UTC)
X-FDA: 85453379214.28.4974F65
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0109F40004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:56:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=burPu0iL;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795128985;
	b=vhh+l6lenbQbHevZr6ONSbXaGtEJbRNYxwIyzD0VcMgyFVfq9cPKN0xTv7MjnNrQz2n3MN
	4HBoWZ5cf4AyFAv5OnBrzFgzt8XUQRpKUWmy8utjcq7KeDCS8piDKQwsIK10wrMfBPoYpz
	HCjr73qQ1+XYbf4MEqJJWTePsCbcChA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795128985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpGbjtqguZRyVAmxSdFOuwH2auGVhYrc8eDlQirRmwk=;
	b=gokFmQm8X0HmeQhZRy/8nMlPOJjZ2xUPpAItTybiT2MoiDnSBOEyVPCv/EaaAoujvVRV5+
	0rYekHQyngjhKl7MM8qrvlpaWFg5RGnvdCWp1VyArI3fC+RSkWTtFFECAs1gO3Qw0JptJE
	WIm5AKBj20/NWjlxao1Vz+jkONBhM3k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=burPu0iL;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795128984; x=1826664984;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BERqUxXIG6eb8qjmYCZHieE6/mV4PKmER+ojmsY9aW0=;
  b=burPu0iLNUcjTPtB+b2Fq/jyH8FR9NYXbM5YJw/tMSKWqc8/asJ/63iv
   gcm5nlwSDmP5IT9WcsFmBVQia1OoK5b37QtvH1jlPgoDfLQT/QfNfUCcs
   lXCmR53EX3mdMvLOyoF5o4Bh3gr4+buXY6zQiDSu70zKAao244Vis1DJA
   zQHiEGPj+f/Pem7HdFfSjnfM12DT+gFpa1UoNbbySu/dj18gp2WbnrYhn
   PyC+7P4qQ6vPnzuSw0ab7g8sa8fhrqlZa2Rlp35gCQR7hmdZ/5m9n9JEr
   yiVMjx5/IoGLtrteBYqqgd7ePCQIOvTEeOqeQxEMAWeKp/M5g1X7KCVHn
   g==;
X-CSE-ConnectionGUID: qwa63CkYSoKzZftHg8wj8w==
X-CSE-MsgGUID: qvsQXlmsSWSfJ1srjxaI7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3887607"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="3887607"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 14:56:22 -0800
X-CSE-ConnectionGUID: DhUYb+4nQNihgcpOEr9/gA==
X-CSE-MsgGUID: rkmUwII/Tu+oQsUJi6AZ/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10570485"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 19 Nov 2026 14:56:16 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUB36-00000001Ghr-2sUZ;
	Thu, 19 Nov 2026 22:56:12 +0000
Date: Fri, 20 Nov 2026 06:55:49 +0800
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
Subject: Re: [PATCH] s390/vfio: Allow untainted use of driver_override
Message-ID: <202611200633.VVreDSbc-lkp@intel.com>
References: <20261119051507.3306075-1-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119051507.3306075-1-alex@shazbot.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0109F40004
X-Rspam-User:
X-Stat-Signature: hcc7kp3sfq8t4oew4c5hxid1b7h39591
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795128983-805129
X-HE-Meta: U2FsdGVkX192fvSwjVI3DHTLOtDWmTKUI8/DMg9r8KLVDqwtDMgUphTb9g4S0gBT15jT+qHO3FLyyHBaBBOp8e4yIMQnW4fISvZsIRsRoxCNcs7FekITDJy6A6oTHmsLe4BUAhQhNlzhQz1PCYVaeCa5PAusqu8LvK7DoX85pbT+A3EF2XDzLqzGfKj3Nr0X15lJqX2f2Lp5I6TqUwIjl1J8IBovUF1XzY0E2Arc3zulkbAQUN9UEHAolsi+eLbCgtTSz1LU6BmcAcHlxf4vBLdmWDFcxJ5HIg9HDuG1KsAwV10RaPDxKTJw3eOvQilU24c0Ej6LYf4h8xKxEQ2FOnUjCERXpcT0CP2bCV6rbMGCCYcy9HduWmJSQe31uNkK2MyKxpgAqv9XpqW/pa7AZqAJNMQMaL+wLLDPpjbeMp35hx6z3zpaZwDIBDN/vK/DYuNYt8xFAa4OJpRkkd2A4wUC7YgB3I7BbgJqBzBldOfl+7pGuIxQMlQIK+AdpOZEyeU3nfMytZ99CfXMyCblA4d1ynVlOgYas+Eo7GG/9XORfk6u8qvr6/mGxsHQiW7MNjMKoyG+mkrgwNHEOyB+lHuePEQ8SMUNaICbxC7HiioyM0pXhLeLltziq78cTXvNMIqqqleV7UoloXID9n5ghVS+qEovBWxehx4WpI6ki/do4lGLCnau5GaEk3p9q/u9VPQ2j3urr843+OjVd6Jb/AJh91AUA+Vffv827c8UwxH4UlLdkXU8Whpk1T80v7d0eo+PFPwF/7w/aZ2Pwso4F5PIsVWAa2+Jm+anTCzAuBkh4QbPJ/GzKrDu2yDIOSvlyAtratXayAur/okhTJL1ovh9pNr6q4qGkxhWSZCFXbNlK8raGyxe2Griam8c0oTlsxPVEy8xX1nhRLZKOY/0BMkdGwQFboPoqK1w9XSRwq6WxnfvwrgoOF1G8294CNB+P/Yvkp4I5oSka3Pe1HW
 DMSVPHIV
 Q2FRl7jzWinWmfX073KmFiKSKSasdmB1biEFlaAwIM7SX/8TveDWxOmS0pZvOWMyFW5DPfGcbM5T9YZ8JYJs+AcrGgTw87Uw0dcNcJ5Q58179PwXaAZYYRiCp4OSch4SC7ieNrUKrGu0bPlWMx0fwDetxM+OhWXouWNlK3nsRX8Emco8qPwjhskRWYqpOoUjXy9coMKCuK95uHDmNlh5dZyCjiDhLbVFwndKuTy8TPiMqQu/bOk6M9HGgAeYWViTBgRX5AeF/T3XPLcirX0Hv+GFzdZqes5ujbwbIDqAOHjxQaxZasxAKZ/UuOtQOCmyvRNnwgMRLMFaMOmy/zcfB8sm3BmJnQdiUgZAhxUXuHSlurvIA7fgyqJXo8gnDILTuleKEenCevbNV83Rz4WVoXytscqstEraiNV/a2sQjXuyKkvSZm/A08Vi8jCDBqxmOIO+ZLVW+R4UMYk63xe7hZ/zcF1FqLFEeJly19yp7G6OZWHA2QOY99UInscpa5v3VXMjLCYrN2CUa00CUQ6igFsZ2HoCWCG8dsK9F0ozHB5+U6N2WCLuea6+2TaGSEi6FguYbzVAA+MPYmxsQSs7kAQHtVaZwphYfnIJ1wG7+60zEFfc=
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
config: s390-randconfig-1001-20261119 (https://download.01.org/0day-ci/archive/20261120/202611200633.VVreDSbc-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611200633.VVreDSbc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611200633.VVreDSbc-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/s390/cio/vfio_ccw_drv.c:378:18: error: 'struct device_driver' has no member named 'support_driver_override'
     378 |                 .support_driver_override = true,
         |                  ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/s390/cio/vfio_ccw_drv.c:378:44: error: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     378 |                 .support_driver_override = true,
         |                                            ^~~~
   drivers/s390/cio/vfio_ccw_drv.c:378:44: note: (near initialization for 'vfio_ccw_sch_driver.drv.mod_name')


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

