Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA25CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 07:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B1E8E0140; Sat, 25 Oct 2025 03:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F62B8E0135; Sat, 25 Oct 2025 03:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9319F8E0140; Sat, 25 Oct 2025 03:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB3B8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:14:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBA5EC10BF
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 07:14:32 +0000 (UTC)
X-FDA: 84035773584.04.350DA65
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37066C0006
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 07:14:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F56TUXoF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761376471; a=rsa-sha256;
	cv=none;
	b=bYlix3LI7wLZzf2HqxsYYn71S/iQFwlzdZ8TwYCbLKqgMZnsK+MHaZMy5b3rl3qwi4SaCT
	ATbbU2tiuNE6vcGEwRE7bhKiI52R2+vykJT4lHv6gaK+8TpRD61WB/XBpIeo5xs4gNkApD
	/3MHus2eiAUITzBbWBWUcEBv3oW69dE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F56TUXoF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761376471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uEY/Z88Sj8Imaji8CdvpUc6DCmAYQHjOX+G6ntboanE=;
	b=n5piq7zp73Buv/tOWhLVQ6kf63ZfnzU7JQOQG2lbtwg90F+yxeJE/2bcS8BIG60CPlJ0Lr
	v1klXFpCiTpxPA6NQJa7O2JSd7KotVfwtFSovsepFea2LFyL2xdfrnqzRnvwlQBnQaqor+
	ZhRj/X/j46yb25VsZAyIP7r0XknklLs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761376471; x=1792912471;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=SxA2snzsuTpvs/SyvqN4o2OiF27KX3NrJq/pjhCTSqw=;
  b=F56TUXoFWjzqXcoN5fQI+Tc/L8bjybFxdVYzx5XfY+1Jpg5NrwyUJP1L
   6CUCtPsK7HbXCUTgh85pQWfGTwgAvpiIlqgorhiI+m8S7ZeqoqwMeXF0U
   uXo0WeurSDwQagzx0kPIXBvBhm4JIp0vnw3biv+t9Z+VxWn9cXSyFGkFC
   tmBCj65hku6I7EQU0u7VPQjiCzh7eSASbj5m2HtoEW5cCb9wzMM3BG2RR
   DGXcuS8Gz2gQ0mj1DjtMs3ENMgDv2GiUqquxxv5aYnTMA3Ux3JSLyAY3l
   vt+MQyboK54xVbcInviCAJjWqDpTP8eU+fxPn0G3u2xIKPHw5eaUgoWDT
   w==;
X-CSE-ConnectionGUID: LHWuVexBT8O7HCu+nJpQuA==
X-CSE-MsgGUID: qp0sdErjT9yE88f8tZB0Bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74989515"
X-IronPort-AV: E=Sophos;i="6.19,254,1754982000"; 
   d="scan'208";a="74989515"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2025 00:14:29 -0700
X-CSE-ConnectionGUID: KgzygAt1TWS8/xIgPGBnQA==
X-CSE-MsgGUID: qFXrV+q2SHi6Z7HzV/lfqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,254,1754982000"; 
   d="scan'208";a="184968493"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 25 Oct 2025 00:14:27 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vCYTp-000FAe-0M;
	Sat, 25 Oct 2025 07:14:25 +0000
Date: Sat, 25 Oct 2025 15:14:10 +0800
From: kernel test robot <lkp@intel.com>
To: Nico Pache <npache@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 173/182] mm/khugepaged.c:113:25: error: variably
 modified 'mthp_bitmap' at file scope
Message-ID: <202510251530.eJulmicR-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: rkwmsfz13h5ytya4a3bh1sj5j9ape6ez
X-Rspamd-Queue-Id: 37066C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761376469-220996
X-HE-Meta: U2FsdGVkX1+Tck4qSxWy6AvcDFnJfyvP+VcWLAqmzzXmqHneAiaVAlPcvYXSJERQjeae29MJa8IJ9m0XfsjL+eUkoAxKILpk5L+WfSt+d6KhW4Dy5k0lQd8Mssq+SEaUW8c10qdsgjWKATPGruq8tWfhhnaqIGI5t5z8OQoqJ/61UxHaBm0AIi+UP5asCPRuXlC8AA7rDxrsLpZQQU7qOE43qlVbVIKiyx6UEbYyomJCVw9JYlHXGEJ2VCN0sBdbdoKZT8UNekvxrfTf0j2BUPPNVP0+RD+p0WcJFQrDQNdPdfgxqhiV5ZzFTfHWWjRnUJXjKf96wvAUUU+ljZOLUFEEJTtGW+2YGawDdbJKaiZpb4chnRjNFcmPinro/uTy4LuUthUjiOcacusbsNxUlOJzVPewtE81Kxv6nZ6pz+vHbt+NvDP/zB0qAUOepIs2WM7wtMoEnY3TesD2A3LdX+xobx5wd4cHf8JSonSJO9xqRdxL6kV8FKH72znGbR295O5piQ1D7rTnfH0PrNgb1rA9LdX/plVgJViyUmQbRSTor4IJtlOBcrFODcK87egB7M5WcuoMns01rXKtVbxC0RskylqDN56BpW0efDvd4SkS9HfdDQYVmIUCZr1oiNdROrGXYjjb8AQbepI4Jpzs4lVfymnmDEES5wdbtSpsBzFBjEX0y27JSCDraQptCs9HfueAFChTjEUM8augL3m6elSXFnsj1KbIlG+QVgAg/4RvbaMiOxCzKzQQVFekT2pAADF8FPseTXJ6XdfGklIW4fEzUs6w5M6aETyurvwrexfDdAxrQ8wJdvycSU8WvsABH8YvrueuTjL04LzzTTtDeOHQTWI+pt9VR+xYNr5u8MIgynorNBUtDb6hTCDOlfuHFvRbGNv6RjXRuprCZM5c+vC1U5fYH/EoERfMlE2pxRPhSDDNdhwBl2Zgkkn4TvN+zZyPjYSrpt69GCPmnjN
 jc+/fln7
 2667yYnGnjh6uk0xRfQpvQyieW/vbIpp1szHThBWyXXGYypF+uzEi5p95o0ajAYfYDUYRszmMu87Lr/1kYIFzEczCvpCKdfaKXSl/MZ0acfnS/uLR/2pDmdL85K1kzQPNKwSRHElCDteMomOCzK1EAgFSQfnPUcPTgFfUDBi91EYlvrZ3njs3zYeFbEzCaFYFoqwkDYkDAN8bCpWqR6zFqw0uwnd9qyt1+S8a+eyM08Ub2+YEdaYM+gMADpSaBKofZqJxxV9GVLjqic7UOw1CWeM9bnQpI+0bW4GyZptvDbOgCAgUj73Sd9c4FQLu+C1VPquR/aLu214xCTlgSxcTD1ht4DH2O4V0GUDcQOx3oBr2EmBtOd0WbcUE9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   752c460b5865d87117095c915addcce7a68296f2
commit: 8387af7962dd62a2a2cdb741e702b476da440ff0 [173/182] khugepaged: introduce mTHP collapse support
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20251025/202510251530.eJulmicR-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251025/202510251530.eJulmicR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510251530.eJulmicR-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kasan-checks.h:5,
                    from include/asm-generic/rwonce.h:26,
                    from ./arch/powerpc/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:382,
                    from include/asm-generic/bug.h:5,
                    from arch/powerpc/include/asm/bug.h:116,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from mm/khugepaged.c:4:
>> mm/khugepaged.c:113:25: error: variably modified 'mthp_bitmap' at file scope
     113 |          DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);
         |                         ^~~~~~~~~~~
   include/linux/types.h:11:23: note: in definition of macro 'DECLARE_BITMAP'
      11 |         unsigned long name[BITS_TO_LONGS(bits)]
         |                       ^~~~
>> mm/khugepaged.c:114:25: error: variably modified 'mthp_bitmap_mask' at file scope
     114 |          DECLARE_BITMAP(mthp_bitmap_mask, HPAGE_PMD_NR);
         |                         ^~~~~~~~~~~~~~~~
   include/linux/types.h:11:23: note: in definition of macro 'DECLARE_BITMAP'
      11 |         unsigned long name[BITS_TO_LONGS(bits)]
         |                       ^~~~


vim +/mthp_bitmap +113 mm/khugepaged.c

   100	
   101	struct collapse_control {
   102		bool is_khugepaged;
   103	
   104		/* Num pages scanned per node */
   105		u32 node_load[MAX_NUMNODES];
   106	
   107		/* nodemask for allocation fallback */
   108		nodemask_t alloc_nmask;
   109	
   110		/*
   111		 * bitmap used to collapse mTHP sizes.
   112		 */
 > 113		 DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);
 > 114		 DECLARE_BITMAP(mthp_bitmap_mask, HPAGE_PMD_NR);
   115		struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_STACK];
   116	};
   117	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

