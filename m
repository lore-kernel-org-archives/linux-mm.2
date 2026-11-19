Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D47606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 23:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=grYBvwgD
Received: by kanga.kvack.org (Postfix)
	id 9EA586B0699; Thu, 19 Nov 2026 18:17:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B3F6B06DB; Thu, 19 Nov 2026 18:17:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862E56B0701; Thu, 19 Nov 2026 18:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59A166B0699
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:17:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A95A3140C55
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:17:36 +0000 (UTC)
X-FDA: 85453432512.29.18B553B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id F0F86180003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:17:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=grYBvwgD;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795130254;
	b=uYMPWOExzjguPs5MrMBJ7dCUDec48rfs0pD77iB/nXClODSITC6k+eusVOEet9EJa0QbxS
	g4RutmNPKha0UAcCZ1lNU5cLm8ScI6gobetlQUb/0wCVj8cVaZtIb20e2Q8IdPp111/7pQ
	cpUkMdB/5kuJLEqlQSH7rYPhOoZ1BEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795130254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSoDlJexnx0K08l+2Qf6ZJZfvrTlP9o1+Zq+v2dVC5Q=;
	b=d0mXTjAz7hxfg8eDcSgCWqW8S1/dGMQ+C80h5GBxxv0ICgoIRFKdwNxBb4GsHr+lWExnOK
	5LBKwgilVld3GaA2oveXvTWehxPpI0NrwsE8D7fgRXuVepfchUlc/GFQIpK/wvHXWckMTw
	SD3S+DNDVpnrgGIcufm26R4CbG37u4g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=grYBvwgD;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795130254; x=1826666254;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nNP6wYTOo3X6rE/Zgy3P1nPZCzq06y4k5FBZ9GaAEJ4=;
  b=grYBvwgDAI5JkedKzILKPmXS+W0cUt+enW6Srazobor3DbUZQCLbDCPq
   rBxfnDWLTwgO50A2oeHuxpnylv/MRSdnQEz7+Y1dKNj63f3f2hCwwN1Qq
   l8t45ZWqPq6U0uBzpLAEMwL7EhnaXL2e+P70M5dzKjXGsIRLt7NR2X+id
   jTyPepSD5d9lGs3IU44CtXPg14VcDRU3dPaDCZjWmVUyGYVflILJpoV53
   oCZxHJuCeZYMLubnv2TplNch6XeOaiYLoTlWeLPrzPS4uNO0nldymYdyY
   3PxLCfvK5kIjmXn6CPpAfGq6sA6dcrirCwNkxPAlssq4XlwL7KD7Wx23I
   g==;
X-CSE-ConnectionGUID: f98wLmUuTZeKwv8bslaMMg==
X-CSE-MsgGUID: AEdP+NvISdy+FcEXlIF+YQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4008590"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="4008590"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 15:17:32 -0800
X-CSE-ConnectionGUID: fc2s4AyMQsStgMZGPMwArw==
X-CSE-MsgGUID: sL4FM2BYRxSiR6j7+Tddsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="12262871"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 19 Nov 2026 15:17:26 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUBNa-00000001Gjj-0x4P;
	Thu, 19 Nov 2026 23:17:22 +0000
Date: Fri, 20 Nov 2026 07:16:47 +0800
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
Message-ID: <202611200615.C2fWqXpC-lkp@intel.com>
References: <20261119051507.3306075-1-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119051507.3306075-1-alex@shazbot.org>
X-Stat-Signature: if5irwyahh5gydfcehss66ku9p9r9xig
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F0F86180003
X-HE-Tag: 1795130253-344422
X-HE-Meta: U2FsdGVkX18oWfsCZdh7AygYgKp2vS3EemwOtp0IIT2c335aO4/4+7mBkoXcMnaPoueJkV0pujWNXjPXJiPw8JJy1sf56JvbbmMErFNOcPLuyzcLlvjZjD6aZYUIfgE5/9Pc163sBhjZxka/kNTNmA8kusuDVfFpzLHpUeXhi5WGmktAl+gxb6G0Er3sI0mq8C43NM8RYlgL+ySDH4RcAvSUlV4gy1JnDA+GZ6Rf2ZGhCjMGs7wDSiptlXURCpE6CLfi6gUu63xxZAqxqVBRZnLZTF8SFqE3P+ApNQJXPviMLFQ0K23pV8kzOh597UxdG9B9Bbiu5/hDs32WjboD+/Ez8SOdBIKFFbq0tkafxE1qHAFj76nMugRvTVkYtcc7pKXql6pu4uK45nu49wjsDAmZcvaEvUdFww8aFpBc8R4l5WQIs/lVyFBFtFNm6pTnFV4R8P/FLwPtvEBvb3gQhrxCimnu6IZPIvAwi+vUDFFOO0Ifg0L0DDJm87cBUuk+bXwDo26MTJJNvTtDM0ro0hy/2yzYF9Uud047iwevaKzv3foR/pYaB5dGdp7psrmd5+hmlB79T68hyoSPaMIWDXvi23h6ibW3QBJ+aZklLCo+dWdRfAhADaCDBiKmq8HCnPH11MXXMtYdVFGkMmOVlru/RCI2i3ZPJbh7Dw5HPjHD5QCdBj9AduTSkSn1Q7/YPpWdLWB9wc9/IE0WPKhHHuFunJUuf09uRQZoRLyBi8Ekydj/bi2WgBjgCUi/RXVeTgA+EFMRyoN9xUmb/B98TTdiY+kytBNLfhmGP27DUHssy5xauBTpg2DOYhmkxHUa5Xaprx1MTzL/y66oPMNi7x4DuIrPpI0CB9/W76cMCrP1OHMJRv8yqJuhDEL9PjLvhXFbLIYlR7N6GjLtRjlxXLmNwL4Au0dwYrQ6jE2n3ogf8aheBV8282g9J3hSZcijt+mVlZawYJcod3kpVal
 0sSN2H0a
 AWcHKtoRUvrKzfk3uy0I/sxPB5xD1ZL/QeGdL6Mh/UigtY2c4ep3ZyhtkK9NnZ4uueBSxhYOCOA+7Bc2ukJEf/5w6wPK1IPcDcrtk24w24rXn8J/GhAKlEIAEnhpAENsvqaEwyXC5XqdrpIXGVwf0l2PPYNh1fdfmo+D8EGee7wscK0p9xGgbN5qdMxGrIg9h05bfdL4+RzjgPxIZqpsNVJIFmaww8pDeVyGkuLCqzyA+b0jR7ujdiKFPKEXJbLReQY/ek+RHUhaAWPr7QKiTWpBV5PAMak0Vc5jVzZTrjo6wP2TiGSPBK2fo/X/+DuhBRgYqMxguYROoJEgB6Q5UrxQUr0+f0GcZJaFCIMVtDbGmeztaUZ/O6v0kSyil8KDRDT/fsE3N4vsAtmBnaoVC/lC4IjgaHZYnQ9GGPKhUXUZAIPb6eTDlqJ61cZZQF4nTa2F/r9ML+KxWnUe1s1nk/wmP4r0YuBx1Y0NxfvMJ3Em6POUauvmxQ1lSrsGMJK+PBalJTHMpPYM43a46Dxa7PDXVYqBAddvIWqUw2yHW5lli3BC8a4VFkTkhrDUNXHaulWqe0Xl9ImhSRyW3gSzSkMHFOw8/dL7iCrsZEYhA/soCUSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alex,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvms390/next]
[also build test WARNING on awilliam-vfio/next soc/for-next awilliam-vfio/for-linus linus/master v7.4-rc3 next-20261116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Williamson/s390-vfio-Allow-untainted-use-of-driver_override/20261118-221504
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git next
patch link:    https://lore.kernel.org/r/20261119051507.3306075-1-alex%40shazbot.org
patch subject: [PATCH] s390/vfio: Allow untainted use of driver_override
config: s390-randconfig-1000-20261119 (https://download.01.org/0day-ci/archive/20261120/202611200615.C2fWqXpC-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611200615.C2fWqXpC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611200615.C2fWqXpC-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/s390/cio/vfio_ccw_drv.c:378:4: error: 'struct device_driver' has no member named 'support_driver_override'
      .support_driver_override = true,
       ^~~~~~~~~~~~~~~~~~~~~~~
>> drivers/s390/cio/vfio_ccw_drv.c:378:30: warning: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      .support_driver_override = true,
                                 ^~~~
   drivers/s390/cio/vfio_ccw_drv.c:378:30: note: (near initialization for 'vfio_ccw_sch_driver.drv.mod_name')


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

