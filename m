Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8DAFC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 21:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51AA96B0088; Sun, 30 Aug 2026 17:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2226B008A; Sun, 30 Aug 2026 17:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2216B008C; Sun, 30 Aug 2026 17:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 045576B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 17:25:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1E1B120225
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 21:25:13 +0000 (UTC)
X-FDA: 85159216506.30.B50C076
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8F640C0008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 21:25:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XavX/Hh+";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788125111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riGaItWsOIudCqyztEIcwxltWbMOSxVGVtpusuadBUc=;
	b=Faums6Ig24KGlLYBPKiszkt/jZpV3AY7bBn6Q87ZFApnNovxp6UoFY5iZIm8Ywkr1oWCuZ
	42VJTRcozDJnzC7tRIUhMC/p0ySI9dpKLwLulYchlrXVI2T3pD2/5ywwewOhN58lTMoRuG
	QUhu1KdtfJTkFimgKSAKJ8SjOlT3igk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XavX/Hh+";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788125111;
	b=CpniRj7QfZ9wd2NJJsJJz37RqLnA1WzpxVIvWzFRYvWOiSf9wA1J0YLdvtk7NEH5lAe/SE
	c5u4dVilP9nltMmmpDVGr3gDah+XASskLIchQP7pKYbog+qwlKNfpSFY5O3rre7YFKO5QA
	TpIACbvYHyXFuQkAUMDiXyQ3PXxXnzU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788125110; x=1819661110;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=e3DGhgfryeBvmyMQZklEG0R0wT6o3YGyy8gco7UnuL8=;
  b=XavX/Hh+uQ8rlAsyVgCsYRgblzAfliZxLzYv/9EFTCKgeL9+uKhECazb
   DN4hhJy5qpcae4mvgj9BdfdmqvJfYopqCspjJuEYZiCegOyFN16UdWfqL
   /4V/0QDaMeLq23h1R2AjBCETG0fxAPwmK46sBeMrHGj5gHBXYo3WDr+VL
   7Du6CmU4qxV3jqFKEuCi1fTElGWKcO7S9qwk4vIIYHYFNG3S9f/cTHzr2
   r49b/tGmHtBALVJ9t5NrvmcfCY212dkhiJl7iDFYkqdzdRp1gyPyRnf7k
   JtuQa0s8wyI6adBcqQfS9OvcIObY+y+sv4JyZhyZW6An41XvEbhpOjgQm
   Q==;
X-CSE-ConnectionGUID: sVCgGdAPSkCXEBF8DxLd+A==
X-CSE-MsgGUID: 3YSKMCm9ScqkWX3n3V1g3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="100047246"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="100047246"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 14:25:09 -0700
X-CSE-ConnectionGUID: KMlicqj9QYiOJSs2SPAA8w==
X-CSE-MsgGUID: qnUquIXZQEukjLDuvMohTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="268075473"
Received: from igk-lkp-server01.igk.intel.com (HELO 32268bdb9915) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 30 Aug 2026 14:25:05 -0700
Received: from kbuild by 32268bdb9915 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0n1S-000000000Dr-1DlD;
	Sun, 30 Aug 2026 21:25:02 +0000
Date: Sun, 30 Aug 2026 23:24:06 +0200
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>, willy@infradead.org,
	mathieu.desnoyers@efficios.com,
	David Laight <david.laight.linux@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, Yafang Shao <laoar.shao@gmail.com>,
	andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
	Petr Mladek <pmladek@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	kernel-dev@igalia.com, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH v5 6/6] selftests: prctl: Add test for long thread names
Message-ID: <202608302318.ORNqwjNf-lkp@intel.com>
References: <20260827-tonyk-long_name-v5-6-5fa843782a00@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260827-tonyk-long_name-v5-6-5fa843782a00@igalia.com>
X-Stat-Signature: 514ba5ho99axaecfbj3hbuo4t5pxjaz9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F640C0008
X-Rspam-User: 
X-HE-Tag: 1788125110-635292
X-HE-Meta: U2FsdGVkX1+dz9K1V4Wn5uGDvSAni2/19JjyWbd1STmrBflMaBgUioNyxQXvHBkWsp1cSHnt7UXEJjVfmVsBx/6LkcBppcOkaMwqajzQwpmhLe9ea+4smCQeghZUflr7AWdG1wTYXWnN5kZeC6QFjSwQY8KJ2iLsXmZg3ZO6kvDt1TFLJlz5G1Vqui18egqEbEAoUbVRe3mj08asDH6siL15XK5B0q2WfAyEXMnqZPSh1VwAGDfugdMmI8k6UKO4aJXMLxZLBU5O08T174ZkQ8usYE90gQliexVpQRN3/vzojpl91LjuwCOk+07c9dakaOh5OijFG8dXgiDXzsvD7v4RbuIQX93JGx653TBthjO8OaGULq7ViCfQQzdkjBHhfOU8PzCpFIc18o3mOKkLPt+/sXjeuzutoZvCHhO5+a8/2WTBn/oYSuBZZsmTDTN9AQSSgppd46p20vQnANPPtEpGXh/rekFMaNG6/bYvtya7go11ikdKbFQVP7U+V4uS+7CD3OVzw5VabdktewB6kX723iYnPU0p4VO3vTpnivTqrs4/ibGClEfWXi4zjOpodB2dISmiQ2hV6ViEyFqqm2yRI+JsmqGAWUbB8Cp36EcSmC1oIPAHnzkh2iGsyfi1JVLsu03x67jEUE54gXJSBXR34Y9skuGkIYWvTXuy/lT83eSokQcsA2HJi8AeYsyzBkwnaKiuBl/Ozq+535Sb3XEl0yWdxRyHgrQ3iYv3CPcNct9hUSJKOLE4OtJaLJfwUFA65kQmzU+6W0GlDdtKxXyhSh40Nd4WqS3PCctKo8fz8WG6KodE49tsCg9il1ICRDxKiRpcV0h/QVxco6XrKmAbSjB6dg+GnYdX+OPXjYH9gAzvh/t4sjuo1kX6hXLsT6AVm+2+52Wwz9k7BPLgdH74CFxe1TOA7mSlrMrQRFskwZK8p1QkS1CcQIV34GAymDF+pdgpfbWOSGWEept
 OF6NvpbO
 DY1Qe/hGcO6bs+2Tzqmc9sWGRQEq2mpMdVD/s85k8qp6ic5FGIVrPUGjJNC0vfyEWuQLMvj4jK8WJ+Onj6i7PJwRpUtKRrGLJ8p7gfrlirS1olt4P/c6XaqeLVcBx6/EWZhgE2V8D6w/MrHx7bIZJCgy5kOW63fkA4Oh5GvjfVx7GAJdg197jdW5P4TZyK2J5iK55Wqd1bua3GldF4TweA2aWJ57S3Kfc/dH1bkG5W3BbTXQFMYoHCyRajn7cECeomzgZPT5wbrabPjbVLx5yUU3aSDCuMZWPnRiwgJFqUdou2Rryu2z3eSgQRC2D0R3IacCcAsjh5Gvo5y387D79y2+zyMeY4CQ7DwOKmCHoSumeShMn8X0LigJBEBdHST6zvtAT3LSrwvEYrOhC7gFagJtUl3dgxD7tcoSpxtH60mBDGIK4fXvjQ+9x1wZoSUv0yeoBDkVOSrkj1nTMFaJFcVFJWyZu7h0rhNGdU7ED6AOTkQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi André,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 73e3f0710014fe6d4ed98cfc02292f6121db7558]

url:    https://github.com/intel-lab-lkp/linux/commits/Andr-Almeida/treewide-Get-rid-of-get_task_comm/20260827-152300
base:   73e3f0710014fe6d4ed98cfc02292f6121db7558
patch link:    https://lore.kernel.org/r/20260827-tonyk-long_name-v5-6-5fa843782a00%40igalia.com
patch subject: [PATCH v5 6/6] selftests: prctl: Add test for long thread names
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260830/202608302318.ORNqwjNf-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260830/202608302318.ORNqwjNf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608302318.ORNqwjNf-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:31,
                    from arch/m68k/include/asm/bug.h:32,
                    from include/linux/bug.h:5,
                    from include/linux/slab.h:15,
                    from include/linux/xattr.h:15,
                    from security/smack/smack_lsm.c:18:
   security/smack/smack_lsm.c: In function 'smk_bu_tsk_to_obj':
   security/smack/smack_lsm.c:150:22: error: implicit declaration of function 'get_task_comm'; did you mean 'set_task_comm'? [-Wimplicit-function-declaration]
     150 |                 acc, get_task_comm(comm, tsk), note);
         |                      ^~~~~~~~~~~~~
   include/linux/printk.h:483:33: note: in definition of macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   include/linux/printk.h:584:9: note: in expansion of macro 'printk'
     584 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   security/smack/smack_lsm.c:148:9: note: in expansion of macro 'pr_info'
     148 |         pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
         |         ^~~~~~~
>> include/linux/kern_levels.h:5:25: warning: format '%s' expects argument of type 'char *', but argument 6 has type 'int' [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:483:25: note: in definition of macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ^~~~
   include/linux/printk.h:584:9: note: in expansion of macro 'printk'
     584 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |         ^~~~~~
   include/linux/kern_levels.h:14:25: note: in expansion of macro 'KERN_SOH'
      14 | #define KERN_INFO       KERN_SOH "6"    /* informational */
         |                         ^~~~~~~~
   include/linux/printk.h:584:16: note: in expansion of macro 'KERN_INFO'
     584 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                ^~~~~~~~~
   security/smack/smack_lsm.c:148:9: note: in expansion of macro 'pr_info'
     148 |         pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
         |         ^~~~~~~


vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

