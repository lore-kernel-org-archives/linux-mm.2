Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D811DFC72CB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 18:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093696B0005; Sun, 22 Mar 2026 14:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044D56B0092; Sun, 22 Mar 2026 14:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9BFD6B0093; Sun, 22 Mar 2026 14:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D88E26B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:49:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 791C81608DC
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:49:30 +0000 (UTC)
X-FDA: 84574587300.21.C829E39
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 99C9014000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:49:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NJmE6W4h;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774205368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6lT8FFeC1t0Upw3IHv1LNx0I7k2laQ1uerAbtDp4zc=;
	b=kWVrkHU47tP1Qflo9krBX+1cDUp9etbtGjt20cO4Eyebk0BH+zPadPHynVfEhc6cHT+PFr
	Oe9/zhPcSTSXpmnA9+/nqTEjBZ/24xUWuFJJh6TMH+dVq8PWwvfrxiL4TicOFyWcVY1LiR
	y4Vk05482tCZNu5f4uMeBGC/+cu4rNA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NJmE6W4h;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774205368; a=rsa-sha256;
	cv=none;
	b=lbiHAC30/IM6wc/5+2HP0R+COyJ6j6tLu0A4iioLB0NCmnBfzN2Z0KJ0X+nR8Kl5IlZ9BW
	+bGI5U0P4Bx4vLi7LlUp1J066InRQwasKKserncQi4YISFumid8OE4Jn8vxtv5VZDco3G6
	7X7Hj1z2h87P+bjZXS3oPTPL9BImWis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774205368; x=1805741368;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1vckE067rrooH+dwUsH8wTlpDCxIWT6EjQbX/qQgntI=;
  b=NJmE6W4hQEDG7voyDlbsIQTCJzAox4WdOUbbCUrlgJiT7H1ykayO7wkZ
   ZHAC9eoJXIlIGsAKnELl8YgBO1gXXC3bG4NRrq9e2pbY/g+cVfUehlxhW
   tJuVpwYxEQp/HYz503ocMkvltGjVw3BiWf49PcaB10j2bEgSEd+wsIuQ1
   K+M/SgGW952yBScTYC6eXclc4zlLctQcFnlDn1BhNiYvwDAKmZkHQo7pj
   LKRDTC0ANWIGfbxpvrkFY2FFKx/h6apHnFub0mOGSg3DBeMsQwO613Cis
   MCsDFlPypMOmMPqZIrLmnI1RaJI928LZegvZs3ZpCMlrmSVoShwB2b5eo
   g==;
X-CSE-ConnectionGUID: BwN9mQppSlq0wcLr+rbELQ==
X-CSE-MsgGUID: PJlmzcJxQzWi/wukMYzDgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11737"; a="85842624"
X-IronPort-AV: E=Sophos;i="6.23,135,1770624000"; 
   d="scan'208";a="85842624"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2026 11:49:26 -0700
X-CSE-ConnectionGUID: 1KjNonLkR2OwZ4XYNc3Ybw==
X-CSE-MsgGUID: JTTbNXwhSmuxe0ix00J94Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,135,1770624000"; 
   d="scan'208";a="219504237"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 22 Mar 2026 11:49:21 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w4NqT-000000002Wn-00v9;
	Sun, 22 Mar 2026 18:48:27 +0000
Date: Mon, 23 Mar 2026 02:47:23 +0800
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: Change gfp_t to unsigned long
Message-ID: <202603230210.EgOkfYR4-lkp@intel.com>
References: <20260319-gfp64-v1-5-2c73b8d42b7f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319-gfp64-v1-5-2c73b8d42b7f@google.com>
X-Rspamd-Queue-Id: 99C9014000A
X-Stat-Signature: xkgxuh1s4dbeuw1mo14ocsoh91pfmkw1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774205367-544271
X-HE-Meta: U2FsdGVkX1+aYx8FviGLZ5H0oKYy8RPQnuUoqMrCg3vDxK/tl8osvgGfmNAUwR4t4JDGw83SK40U1krctOEDj9nASdZ/YN7xLuHHKFzwh5G64VMhdB/0i/hhPTICcBNPyoOIMpLuFPD1ZiQX2g+FvmMCDuicPLDYgDbioFrkkvJ8NdXIyBVzSjcAHZPXjD4yzMb+QIGLC/JdPve2lkRzPoCQKNe3ARXCNiAkUkmGNmP3mA+Q0mZC0Jf9L0V3OSJsfeVh22u/5S2eXrtYcHQNTFfBMFh9PxlFUEnaJKP/Vnq9naiDpZHSxOQ1QAQyjDPoiXe6UQq6H8bb7xEslpgT2GYf3FBX6G3Sr2jJgnXjMWnKDa+VnxhUyt3Us/Ou0IqgkniIrWBsf8phFnSw/dXToE+Rcz9BXWB03z4n8AlsIoSKnKTRiVuUYDWZhQS9r+oV+jLMPcGrjRd/agmPfCRl/65veU20dH2pm3UUCvrzHdCnTJWpEZ1xIqlAxMr9V1ZQnM2/p72tOfL7ED0mecwC3yW/q7wg7dPLWA8MxqTGLbg+RVlilXcjsGOz07/RFnEO9F+t9XoyCW10plZMAqU22wfxr9YQ65AjT3tGHKH3kdq7RH8hfLOaMsnZAa5uS/972wuo5lsaa8Tk0wvUi8MpJRfekCSkmJGSxjH72XzUq9oMp/TgV7bUGqMmyXdeQpm/NwUNeOwN7qFYDWZ80OBXN2I5viM2IUlV5A4clBV6pnnFLSHBP1i5ueApXEA8zc8RHcuqO0GrH21+Yn8SgRCSRIlAe7AVrtpNwKzUT2NTgkBbKL2k+x5vbkoRAqKPuvEYr5zAm224NFPA0e8WqH4BNFpM+FPkhrgtCxc/xyImmviLVam95OD2GVCvDz0GkIuu6vBryPMgYEFfT7iq0I8kuCifs7WfLRabzopSZW1yXdOTRp5x50yhbHxkdU1NQTGDZ9CvDnUayX8qxkTggWs
 AUCKB1QJ
 Zs9OXR4W4PF+X1QfJyQXeE6rUCUbaQDVR8+MrC0sGklgYiTPOT/XYiC6f9Ovu65Fx/539LXdiBcdhzLGhfHz263Y9md97Hn13iTpnqcsek1h86j4m9Fq9R8D0YmIezG0cFGW9Jd4psZCbBACntw6AbIWIghgOhliOz3Fmup5IDwfxT07VLky4gMY2fE4K1CpUZoDPnR1lsXU+jYURiYLb90HgyXn/xxaAWUwDgP/Hc1WU5irN1j0yxl3OtB2pZuN9pHBugpAopZYw9YqT0E0LtNR2QtVgZsAbacocLmBPT4Y0UhAAhc6axlbuXVwitdh/95JNxkNNpA8ie9zWXcuxlpJQ1wWVHItSYfehnPsAspkCJ1kOY1eLwlg/qMh9oG+PyRC76hrqWwimqCqJ3TuYLBzfiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/drm-managed-Use-special-gfp_t-format-specifier/20260322-145930
base:   8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
patch link:    https://lore.kernel.org/r/20260319-gfp64-v1-5-2c73b8d42b7f%40google.com
patch subject: [PATCH 5/5] mm: Change gfp_t to unsigned long
config: arm-randconfig-r131-20260322 (https://download.01.org/0day-ci/archive/20260323/202603230210.EgOkfYR4-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260323/202603230210.EgOkfYR4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603230210.EgOkfYR4-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:31,
                    from arch/arm/include/asm/bug.h:60,
                    from include/linux/bug.h:5,
                    from include/linux/instrumented.h:10,
                    from include/linux/atomic/atomic-instrumented.h:17,
                    from include/linux/atomic.h:82,
                    from include/asm-generic/bitops/lock.h:5,
                    from arch/arm/include/asm/bitops.h:245,
                    from include/linux/bitops.h:67,
                    from include/linux/kernel.h:23,
                    from include/linux/clk.h:13,
                    from drivers/usb/gadget/udc/atmel_usba_udc.c:7:
   drivers/usb/gadget/udc/atmel_usba_udc.c: In function 'usba_ep_alloc_request':
>> include/linux/kern_levels.h:5:25: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'gfp_t' {aka 'long unsigned int'} [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:134:25: note: in definition of macro 'no_printk'
     134 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ^~~
   include/linux/kern_levels.h:15:25: note: in expansion of macro 'KERN_SOH'
      15 | #define KERN_DEBUG      KERN_SOH "7"    /* debug-level messages */
         |                         ^~~~~~~~
   include/linux/printk.h:641:19: note: in expansion of macro 'KERN_DEBUG'
     641 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                   ^~~~~~~~~~
   drivers/usb/gadget/udc/atmel_usba_udc.h:233:25: note: in expansion of macro 'pr_debug'
     233 |                         pr_debug("udc: " fmt, ## __VA_ARGS__);  \
         |                         ^~~~~~~~
   drivers/usb/gadget/udc/atmel_usba_udc.c:703:9: note: in expansion of macro 'DBG'
     703 |         DBG(DBG_GADGET, "ep_alloc_request: %p, 0x%x\n", _ep, gfp_flags);
         |         ^~~
--
   In file included from include/asm-generic/bug.h:31,
                    from arch/arm/include/asm/bug.h:60,
                    from include/linux/bug.h:5,
                    from include/linux/instrumented.h:10,
                    from include/linux/atomic/atomic-instrumented.h:17,
                    from include/linux/atomic.h:82,
                    from include/asm-generic/bitops/lock.h:5,
                    from arch/arm/include/asm/bitops.h:245,
                    from include/linux/bitops.h:67,
                    from include/linux/kernel.h:23,
                    from include/linux/clk.h:13,
                    from atmel_usba_udc.c:7:
   atmel_usba_udc.c: In function 'usba_ep_alloc_request':
>> include/linux/kern_levels.h:5:25: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'gfp_t' {aka 'long unsigned int'} [-Wformat=]
       5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
         |                         ^~~~~~
   include/linux/printk.h:134:25: note: in definition of macro 'no_printk'
     134 |                 _printk(fmt, ##__VA_ARGS__);            \
         |                         ^~~
   include/linux/kern_levels.h:15:25: note: in expansion of macro 'KERN_SOH'
      15 | #define KERN_DEBUG      KERN_SOH "7"    /* debug-level messages */
         |                         ^~~~~~~~
   include/linux/printk.h:641:19: note: in expansion of macro 'KERN_DEBUG'
     641 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
         |                   ^~~~~~~~~~
   atmel_usba_udc.h:233:25: note: in expansion of macro 'pr_debug'
     233 |                         pr_debug("udc: " fmt, ## __VA_ARGS__);  \
         |                         ^~~~~~~~
   atmel_usba_udc.c:703:9: note: in expansion of macro 'DBG'
     703 |         DBG(DBG_GADGET, "ep_alloc_request: %p, 0x%x\n", _ep, gfp_flags);
         |         ^~~


vim +5 include/linux/kern_levels.h

314ba3520e513a Joe Perches 2012-07-30  4  
04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
04d2c8c83d0e3a Joe Perches 2012-07-30  7  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

