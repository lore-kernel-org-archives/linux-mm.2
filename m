Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0017BCDE010
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F066B00A7; Fri, 26 Jun 2026 00:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA406B00AA; Fri, 26 Jun 2026 00:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA30B6B00AB; Fri, 26 Jun 2026 00:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1F16B00A7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:55:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E3C8A0383
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:55:03 +0000 (UTC)
X-FDA: 84920849286.09.B5F8963
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B432A0006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:55:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VPa5z2g7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782449701;
	b=vxvVpOof24nErL+tKqUDZcJ5B0Pf6DFX9tUbTHijaZOYJSkcBuYQUVYvsW//Yj9Tqn81xO
	OeF4KUKIyjeWL3bOFGMWJAv0i8zSklIdzupMasdlJ4edenDhv3wgnI/m6ESuoJdo2MTp5S
	O9ymLFlA74U9Qb7NZmZlf/2UqbFPh3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782449701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lP6UpwKkwuz9M05E3M2QCHhODdwvMMvuytw4RMj9Ay8=;
	b=AsCJOW4npbPA0tmEAn6A/RClQykWT5aB/CoMq53Uhuo+F2RIcBY7hH29LlQxwQzkAesy71
	T1tXrAKD3LaGN+6B+0LENk2TAilp84pum75GtWUZjcBDmY2Mt76554N2x+wgOEcWGke5Et
	xihrSrmiWLXDY8RhgR78lLDu4PLZFX8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VPa5z2g7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782449701; x=1813985701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ph97+QbvBbcufChYnurDSohcP22hoOVDdPb4UCqhVjo=;
  b=VPa5z2g7kw2VtQmhCrN6qgdAjj7rpjcF6kEJamaBEHCGSzaG6xd4WhOT
   CWwFojJdIw1T03mb10MWwDtFsd0mXePnvpF8cSNTUVUF9vPaSgJeZIvHf
   0MkRzc+eZKuY61kEkg8RenPICupab0Y3J5L247XE7Xia24PabBEtpLpq8
   xVmtPkqYOEOp2UapVrHQUqar4yGSAGt41IqaTMnrYI5EWHxdO23s64pKj
   99iWUGMqAmgDqTiwQTAJv3rz4/Z2kMNRNmOYoMgun+oZi58ce6EYzAHK/
   oXUmQ4MJTB/gi5i1k8Y639hH4Viehe4cgZYZ3Gm4LU8sihNSRow48JbC6
   A==;
X-CSE-ConnectionGUID: xtm3PT1ZRu6GMa7RqnEY6Q==
X-CSE-MsgGUID: iilsepOzTeedtCn9TIsPXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="100675481"
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="100675481"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 21:54:59 -0700
X-CSE-ConnectionGUID: MA5R9x/gT4O7EFxpR5rVbQ==
X-CSE-MsgGUID: usDeWcdXRIKMfkGZAwT0qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="251894018"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 25 Jun 2026 21:54:54 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wcyaY-000000004mL-3RQw;
	Fri, 26 Jun 2026 04:54:50 +0000
Date: Fri, 26 Jun 2026 12:54:38 +0800
From: kernel test robot <lkp@intel.com>
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v7] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
Message-ID: <202606261253.X4CwKZZJ-lkp@intel.com>
References: <20260626032012.1049667-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626032012.1049667-1-hui.zhu@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B432A0006
X-Rspam-User: 
X-Stat-Signature: peq6k7ubitm9gd1rdn4k67ek85f9e5zt
X-HE-Tag: 1782449700-953554
X-HE-Meta: U2FsdGVkX1/yWGD+EKH1iWzRqwSglWIEr6doADHSVQiLd+SvOVwq4iRi6WIfUVA49SOaB2eiArJVkkiLOAnb4lbVm/25Kgy7ekRKhg3lCn5NHP5VMMFNDokzyd+HWlkLxsPtwzD7FUWRRpZmGmdn6VeRr3TGEz2l8kTyzqDzOIfVbL1PkDGOsuEvg7evIiYqB4a4jeqYDkQoDKjZZTK2nR6Wl3PN4TdAtsh057NPDp5ZpVY+To1pn6md7ylzYEHkCMpgkNck9aZpJG1d1bNHa5KBdoKQV+BCm4KZrrVFHwAXZUNgoGoULIS+SuM7vC3s0hIHG+6r56g0lzhMSH9kJmAtQ4BNJJjA8J5hUwsHMSbWcX9gmQG1VF+mXO056ZlmCL+z7k0Utv3DZ4hxViYt/FbVQ76xTBURuU2do1acd8trZpsadlaZjntjAbiKNL8Ik2DpxXdflKaekm6+zMzFOCpjjGYI85KKHMn88g56bBvVJIYNlt3aDfl0P4+2L7WIDVAe/AS3PqBF45WCyr+yC98oG7XyTliyXyC7R7xXtPZxEqRvAK7DOucYBBSwGzpckKeQCmrY9QbBOHN2smLWwFTdLDI/1nSBBmH0+YPv/1npdUUXRO0QgMkqpc+yW33iFWyhxnEB/7XUZW1xLUKJdld/yNlbGaq2h3UOBoJqHLOSY7lS4hhvG2I2wieF6mMfEpmOSI4MBtlP9rUNHLlgmMJqBTLMPnHqQywmM2vMgCO5XVtZsiuk2Bk+4HLw2lauAlWUgcMtjIiCifzlvORKTr8yCcmE7KkqXpIn50ZHTuJ/JPlVli1w79hkcfQ3KnqPHNyCRoNANIL5HffRUeJ9R9YYmxGbH7az7YeiVo/pS3SAyn/JVnO5o+U5Cf7B9xTIPoJ9p1euxctJAe/dY1jYFrMt9yHHQzykb0Y0+qYD9eMvu8aA/igMlaVmYbHMU5RGM/DDEy0qL4qha9JJnZE
 Q6piUw9l
 3uSWs3K5ahMm8bxO+sjx66ZMdgCYIX+S28NFGgn0c0WfPwglkvp19eX+SlEWUDZvlXwU9fpmynpbSn3AqCTEOu5JLAX8bBslwqT7x2MdiNzEngElmJCsWy++RHP/HUpl2PxqP1hFfuHqGKsW1FMNScQRf5N7uCgWfkAJb4q5O3w+uuMQeEnrT9Y4/cv/gZoIzJSwZTvxNdL7oNEeYAWusjZ8dGW/FLbjfLawcr7WtnDJHB/XRvpUjYHlFDluhehxtXAxL0Es2pr5kiMwInacqhcyLaAbhVs1f0/8BLN+HB3Y+b8kLVIaUAHPNO2hq3XUA8QB2PLPJlorA4B0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Hui-Zhu/mm-assert-exclusive-nid-zonenum-bits-at-the-page-folio-access-sites/20260626-112119
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260626032012.1049667-1-hui.zhu%40linux.dev
patch subject: [PATCH v7] mm: assert exclusive nid/zonenum bits at the page/folio access sites
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260626/202606261253.X4CwKZZJ-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260626/202606261253.X4CwKZZJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606261253.X4CwKZZJ-lkp@intel.com/

All errors (new ones prefixed by >>):

   WARN /zdci/src/lkp/lib/log.sh:131:in `log_warn': /opt/cross/rustc-1.96.0-bindgen-0.72.1 doesn't exist
     from /zdci/src/kernel-tests/lib/debug.sh:164: kbuild_log_warn
     from /zdci/src/kernel-tests/lib/kbuild.sh:3371: export_rust_path
     from /zdci/src/kernel-tests/lib/kbuild.sh:3361: export_compiler_path
     from /zdci/src/kernel-tests/lib/kbuild.sh:3840: invoke_make
     from /zdci/src/kernel-tests/lib/kbuild.sh:4022: make
     from /zdci/src/kernel-tests/common.sh:202: redirect_error_to_screen
     from /zdci/src/kernel-tests/common.sh:210: redirect_command_errors
     from /zdci/src/kernel-tests/lib/kbuild.sh:5680: make_prepare
     from /zdci/src/kernel-tests/lib/kbuild.sh:5909: test_kernel_build
     from /zdci/src/kernel-tests/lib/builder/base.sh:442: builder_execute_build
     from /zdci/src/kernel-tests/lib/kbuild.sh:6419: compile_one_config
     from /zdci/src/kernel-tests/lib/builder/base.sh:88: builder_compile
     from /zdci/src/kernel-tests/bisect-test-build-error.sh:102: main
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:21:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:23:
   In file included from include/linux/writeback.h:13:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/x86/include/asm/cacheflush.h:5:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:23:
   In file included from include/linux/writeback.h:13:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:10:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:13:
   In file included from include/linux/pagemap.h:8:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:13:
   In file included from include/linux/pagemap.h:17:
   In file included from include/linux/hugetlb_inline.h:5:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:9:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   6 errors generated.
   make[3]: *** [scripts/Makefile.build:184: arch/x86/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1390: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +2 include/linux/mm.h

^1da177e4c3f41 Linus Torvalds 2005-04-16 @2  #ifndef _LINUX_MM_H
^1da177e4c3f41 Linus Torvalds 2005-04-16  3  #define _LINUX_MM_H
^1da177e4c3f41 Linus Torvalds 2005-04-16  4  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

