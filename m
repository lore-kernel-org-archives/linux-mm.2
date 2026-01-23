Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009A9D778B1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 01:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A036B009B; Fri, 23 Jan 2026 20:19:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6551F6B00A1; Fri, 23 Jan 2026 20:19:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559566B009F; Fri, 23 Jan 2026 20:19:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20BE26B0573
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:19:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A0AC1602D9
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:29:29 +0000 (UTC)
X-FDA: 84364368858.24.898BA14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf21.hostedemail.com (Postfix) with ESMTP id B47A81C000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:29:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c6WZghwi;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769200167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LZJd2zPS7VAVVSYILczKvcfSTL42n05v0H0TTSN66wI=;
	b=bFXguwpNPmkhE/Y1O5ftd7ex1oS9D3nJTuwEh4hs0mA6cD3bQlURIjk8Mo4KcWhzLN4mdi
	MoQpBz+moqsDknOkNMC73v8pCkVkp5Mjka+dpArAvayrGPb1XJ4vU/vtiwpH4XXr11WG5C
	F/HNWGUcMNpIYcaM454hDF7h3Gr3Q3g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769200167; a=rsa-sha256;
	cv=none;
	b=N+mFlqLZnTTxz8gNUHhrRrEnc7JdoQhyBn1F66g1dBVbgLXB5KBOiOW69i0QKuBVOUIb4H
	59giVYCge2H3u9ajjpjvyXgO+9D4wt+KF/6EtQLoPNxgnKYIEwQ6F89KVyt2gUBV91oFPz
	KP2xQ1L3I96g1kZtOBYeOB/d90XT1w4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c6WZghwi;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769200167; x=1800736167;
  h=date:from:to:cc:subject:message-id;
  bh=vOc/Zoka9Ymz7tzO3k14Ksu5+9P410R1+UPLRvofQVM=;
  b=c6WZghwi5iETrB8fifb/P2bSMpv/Ik2LTQJeyUIBVhqioUZ/q9r0qgCG
   ISowyQjY3B4zymnFzI45Mnsj7s/wI07Jth10NOP8WbH4OvKlZxS3B9fs0
   DC/swyzRFNUvtxI6+C702PzfEv/bntq5W/hvHMC0j8oHlvdeBO44tH86d
   koWtcgLy6bjVg59CVKmLUTNOSDJMTJwCTcRK1xJ8bXIbXSUWSGaOj02YT
   HAp7UyYhTqI5OKMK5S/eUBbc3N3dwSxmg+hxRdWnFb2lkC5KZsMnHnGRA
   Ems6PbFfXwYP9TYO8GjUTvz//cfzYPCAoJojb04JFwzwHjYcNDQsIhQCh
   Q==;
X-CSE-ConnectionGUID: f78ZtnRJR2mk4r/k1msp5g==
X-CSE-MsgGUID: D570ejTDRx62hHC+30jCWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="73046316"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="73046316"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 12:29:25 -0800
X-CSE-ConnectionGUID: +D2YCxtHRCe2RlGYvzE8jg==
X-CSE-MsgGUID: h/HOYLbEQFKwnWrbGB7juQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237768859"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 23 Jan 2026 12:29:23 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vjNmR-00000000UQy-2WpR;
	Fri, 23 Jan 2026 20:29:19 +0000
Date: Sat, 24 Jan 2026 04:29:00 +0800
From: kernel test robot <lkp@intel.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Raghavendra K T <raghavendra.kt@amd.com>
Subject: [linux-next:master 7919/9290]
 include/linux/compiler_types.h:631:38: error: call to
 '__compiletime_assert_639' declared with attribute error: clamp() low limit
 pg.start greater than high limit pg.end
Message-ID: <202601240453.QCjgGdJa-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: B47A81C000A
X-Stat-Signature: 3qkytryop5rfsd14hteogaqcbx1snkyt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769200166-505496
X-HE-Meta: U2FsdGVkX1/E4L8Mu3RyRn67b4MjofMGAKPXm5pgAUxqSox1VjKJQsiADBT79UQenBwjuqKlq9wr5QGQsrq6qfMt8vcVMi35yNLY2Qw76EcV2F9ziUB6C1NqT7Tz4pW27dgcToZQJBZE2XPwRfGwbyfdcOAYUCrH+uAENg4rih5CSGaCvOwc5WlBPp8K9y0Qb8czU9uMJB0gh1NSJtnSluu/W3Um7l/BPSUSTCrX21Rklkhyd9CiybgI/2EzM2sqPB6obf1/4K52bShymJR0HAlgPP6o/D1V36YZHwOz3ZyddN/ueOMJUu424B/Y64El+suJKaHSKj7UAgbtVvFKrjb7QjvxX9PG6bvTdp4Mvd9oD0lFhvkw5ZSGxGUtXmNQXUOlujeroV50i76G5pcap5T+oXprVejthohGj14XfchnmQKAkTqCYQe0+YBid71RtmcwCc/2gm8kwcezz23CROW6hLBa55FfFPTLjRuMn8kH7pijAzniE4pC1HB1+tgmaCVrQoA+mhNcP/GE9OvxYP4RSFUnbmUJDSARZcFRY+LPB+lOJJ50Z+B3KniKHvEeta3UH8D+AJTzI12YxnbDO2LxAUvuF2yWn5a4tZWBQ+7uVi0WchFR6B85lBtSNDidCVZv69ygiOQHAa5XslA9VSSDhSczHVGZv2lUI3jkQROf0y8G1JcsofkJR5WaT4pKZbZIop+VKeLgvlo7HTCSamFfk6geJhHU6svVpiFxxZrNrKdMfRCmi4MOfhDoJOO0qPwg1Os/gIJSAY2/RLk+Fi4qJmRcXqS+EzPBpO2qlNI9qxfDBbwn3VO2aoesWtmMkjy7leRTl6x6Jrfd6jaksNIuJASdrJt1tjVTLJmCpaq6HIuuC0P4aItYkeAeE85YHdwJ5B4C9gRSQs95W97i0frFgvYhfpD2aWW1JMSwj10AUAcHnMJUrvs2usrj+iAtNwkT0GVbvdOXEZ5+d+a
 pkgPoCPn
 6K0l4a5YF2jRUAIgvqRGcCtIdXn+W045SQsw/NnBGc34KFhfHZSGpkGdev4yYdHid/1QNNwyGOWvRwHqLaYUr6y23fBeRijTr1JOjRZeADd6mQ3dxMe2Y2pu6mgICNWDOrq4A4e1gbP30fphxIWZhFQOvawICCRLSK0eefXCGcPBFjMkfDAmdr1xPVKiLzb9HWAks0MdfBh0SxDVj/hXf5rUn0H1d8XfQ4NIQZZKH5HjH0PTCCaoOKtjgL1S1e82QK0LBMKmbYUEtiE4LYLDO/Ghcb2gzbb3BZ7/S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   a0c666c25aeefd16f4b088c6549a6fb6b65a8a1d
commit: 93552c9a3350fff06543da18e4c80d3e804191ca [7919/9290] mm: folio_zero_user: cache neighbouring pages
config: riscv-randconfig-002-20260124 (https://download.01.org/0day-ci/archive/20260124/202601240453.QCjgGdJa-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260124/202601240453.QCjgGdJa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/mm.h:18,
                    from arch/riscv/include/asm/sections.h:9,
                    from include/linux/interrupt.h:22,
                    from include/linux/kernel_stat.h:8,
                    from mm/memory.c:42:
   mm/memory.c: In function 'folio_zero_user':
>> include/linux/compiler_types.h:631:38: error: call to '__compiletime_assert_639' declared with attribute error: clamp() low limit pg.start greater than high limit pg.end
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/range.h:46:11: note: in definition of macro 'DEFINE_RANGE'
      .end = (_end),   \
              ^~~~
   include/linux/compiler_types.h:619:2: note: in expansion of macro '__compiletime_assert'
     __compiletime_assert(condition, msg, prefix, suffix)
     ^~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:631:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:188:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(statically_true(ulo > uhi),    \
     ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:195:2: note: in expansion of macro '__clamp_once'
     __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
     ^~~~~~~~~~~~
   include/linux/minmax.h:218:36: note: in expansion of macro '__careful_clamp'
    #define clamp_t(type, val, lo, hi) __careful_clamp(type, val, lo, hi)
                                       ^~~~~~~~~~~~~~~
   mm/memory.c:7296:8: note: in expansion of macro 'clamp_t'
           clamp_t(s64, fault_idx + radius, pg.start, pg.end));
           ^~~~~~~


vim +/__compiletime_assert_639 +631 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  617  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  618  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  619  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  620  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  621  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  622   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  623   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  624   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  625   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  626   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  627   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  628   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  629   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  630  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @631  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  632  

:::::: The code at line 631 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

