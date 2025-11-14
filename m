Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF35CE8D40
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9178E0036; Fri, 14 Nov 2025 10:25:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590DB8E0002; Fri, 14 Nov 2025 10:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6CB8E0036; Fri, 14 Nov 2025 10:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2488E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:25:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1F2358E3B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:25:01 +0000 (UTC)
X-FDA: 84109585602.22.9DFDB96
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCB8A4000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:24:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mp9xrJVd;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXCF3+EoXphSvLziu+dT9EKqywwUxlLqM+hyBrRN9TE=;
	b=TufBBYNzCKFEDE2sC/vV4aGyOAIfHqZNIE1N5keKh05SK4vcmKVpIjf3TqBIxDLvCGEiI6
	1Fh5VP3z7taAEXaffiIcFhrcV3pfyqDF/0VPfIszDnaYVmnl0iFWRwdJ5HKUSAYT1wsvGu
	7JkM4keiTs4uxyuUcoWDQ7mWTr5R0Nk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mp9xrJVd;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133899; a=rsa-sha256;
	cv=none;
	b=jPAAZVWhb5VVDvA/Smlcyx8Rn7OsWxeRFRseymiZEHQfWbII8urLXQC4Ds1pWg51E01QMd
	0kkEVog4Fn4SHkO3tkfUbplT/75fdWpOWQ4dYNFzbAerldqmdWnULVhwPAPkSmM9DzWG8p
	xAZmEja0G/pogGiMu34mkjrInJqPJm8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763133899; x=1794669899;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BiK+fqpRBTWp4mUrFhUYkAdEjCSI4//VP7gZQIis1tM=;
  b=mp9xrJVdqARaHvyWEAv7IgnxwSy0ivM7tNDDAthwZ/TL0YT2Q9pLogoZ
   nHxF3R8V+wfVDMRtA7u9pu/rkJ1pjZ2N4px99Ank+xR4JwH2skyWnF9fk
   eataGt3o1+pFN8jDm+IJ93CZUsWQIfKp6UzTBQCGtrLITTqWGZ/xLtCpY
   E5Q8SFViEks+X7e3yCC6mMblLEZhDA1lbcSEYncVOufZZsrYoWPihqELJ
   V6dlPqaMtPeYk1EL8pa5iFmqevbehrbM6zznzQhPDCAfcQTKKA0ysXA+K
   WlSFQkUdbCEHCO67VPFiare9mtcSpWvzkg8Bua87mo1+5+t5Hzkdn9KSc
   w==;
X-CSE-ConnectionGUID: LEpb8lwgQIq4+JhaIii5TA==
X-CSE-MsgGUID: ycJQUCZuSruVMMsdRnybcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="82861596"
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="82861596"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 07:24:56 -0800
X-CSE-ConnectionGUID: P4ubDkTKSKmCq1wPZrc8iA==
X-CSE-MsgGUID: lj8S5HHjS6e9N05+APrXRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="189990414"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 14 Nov 2025 07:24:50 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJvfL-0006i5-15;
	Fri, 14 Nov 2025 15:24:47 +0000
Date: Fri, 14 Nov 2025 23:23:57 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 1/4] mm: declare VMA flags by bit
Message-ID: <202511142325.rDmlXFxr-lkp@intel.com>
References: <6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DCB8A4000B
X-Stat-Signature: u7p71dusyywhanguzugyjszrs18wjtky
X-Rspam-User: 
X-HE-Tag: 1763133898-435472
X-HE-Meta: U2FsdGVkX1+ZJnl9zQE5rujRXhaFQiJYi2KYCBDt+H2GQSkQ0Sl38MGObatnSvkRtyclYjoTz74uk5SjDszLd/v0mRNy+d26Qat6XuHMKSqPXrO97i0HDKy8A4yhdry5OkJf2LGVkrw3xznqrZcF1THZ4GZ62oRu/60E4QNWPmaVoAnuACm4Kbq/Dy3oox+zrz7BNniI3SG65J2iR0gkYCkX+JQKdgYo+RaUWaslavJgG6IRY1zoYjbW2H2nDxBurpX2+cBr+ToPQZtlITHNfzX1OgK4lfVI9YZhuyOmGPjx2C710gn+ZDM+gmEiQeD9sQmYcXQTP/Vt2+Q0B69TUmB7gD8xh31gl+cKOeKxbPlrWxdwRynT1F8oZpfMDhpluGvg8jAFpaIG/u7w++EsABJLAcCCpY6S4bJkneP1SkufFcGmNLD6e0u0y6IBktSWoRMNNG44lUrWUt4xMxRP5VTHfhT/LWaud2z1Uz66yjc/BgpePxkR2vhQm9JDwyaVVI4GlZjzeh6K7LliAhdZzHnQsBVkMuKogZLuE0AKA1sOapZwVLgv6Jq3LfraSKLxqCS/uJlnqXleMLE969ur9bbqgNKBle7I6Hr5s/J0bsSMVssdJpE2NWaefb0rPXWMIuDEhZHGeeh6iCzOwxSInsuIOFcrJYGIw8LkoN9cMXD4QzxiJCNnz0DNp+4LuSqO0QMovdJbt9KM55oaFwFAl+l59eRXLZnC+iQmIXGcHXuKm5ESI++e+I9bHN6+Rlj7+4g4Uz38cRpAw4tGn390VoOwOLTewvU/PQsuyIx56zZ8R+1AOFtWR9tfo7FvYD5TiPUAWMVfVbcUK3To2UQJXY4PDViXQ/OdjZgi8GJS407aT1LHF4lb+mU6EoeJ1ttvRsv012N/76dTXoR4eK1ZSDyn3E+PsWgISx540m6/7Cyg706XUhqtEfsh9MxcAy7LGCT7AL3QnLoIlN/yhr/
 Yhs63Bso
 NG2IVAZetoAhxCuaHOkV2WwzGmZ/m+1Ujw4MD6e6YfTkhRmKwjGiC7rNcDO9IULN0pmKHr5CpTvugBoRMPAKi1AaDMsB22Qt9yBipzgPfQ2QFa7Q/+n3SdRqG6C9jZEOLE2RBw12dorhgf4jfb7qUhgWakltghss1caUfQF4kEUQX34WV4h+l8z8wV9zql8/udoSi87PWo+9eqkcdOXisf0F8a4RrOhSerBYYItOdjZ3jO2y0rK0m5h2/5t8CFePohH+IxJzbxVVo3S9xEJGcqm2EjekTV+oc9HKW3NviMzBNpFKvng9GxWfL+JotLUyHHSqvKo7wYpUpFWc04ULblqKfLFTeWdoZpW1uNYDzNb4ha3C1gTkka671vlfSU7psYd2iyHGINJYBENYe0sOceb1NeoNSCe4SkhBT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on next-20251114]
[cannot apply to rust/rust-next tip/sched/core brauner-vfs/vfs.all kees/for-next/execve linus/master v6.18-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-declare-VMA-flags-by-bit/20251114-213237
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes%40oracle.com
patch subject: [PATCH v2 1/4] mm: declare VMA flags by bit
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251114/202511142325.rDmlXFxr-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511142325.rDmlXFxr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511142325.rDmlXFxr-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/sched/sched.h:46,
                    from kernel/sched/rq-offsets.c:5:
   include/linux/mm.h: In function 'is_nommu_shared_mapping':
>> include/linux/mm.h:1734:39: error: 'VM_MAYOVERLAY' undeclared (first use in this function); did you mean 'VMA_MAYOVERLAY_BIT'?
    1734 |         return flags & (VM_MAYSHARE | VM_MAYOVERLAY);
         |                                       ^~~~~~~~~~~~~
         |                                       VMA_MAYOVERLAY_BIT
   include/linux/mm.h:1734:39: note: each undeclared identifier is reported only once for each function it appears in
   make[3]: *** [scripts/Makefile.build:182: kernel/sched/rq-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1280: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +1734 include/linux/mm.h

97a7e4733b9b22 Peter Xu          2021-03-12  1722  
fc4f4be9b5271e David Hildenbrand 2023-01-02  1723  #ifndef CONFIG_MMU
fc4f4be9b5271e David Hildenbrand 2023-01-02  1724  static inline bool is_nommu_shared_mapping(vm_flags_t flags)
fc4f4be9b5271e David Hildenbrand 2023-01-02  1725  {
fc4f4be9b5271e David Hildenbrand 2023-01-02  1726  	/*
fc4f4be9b5271e David Hildenbrand 2023-01-02  1727  	 * NOMMU shared mappings are ordinary MAP_SHARED mappings and selected
fc4f4be9b5271e David Hildenbrand 2023-01-02  1728  	 * R/O MAP_PRIVATE file mappings that are an effective R/O overlay of
fc4f4be9b5271e David Hildenbrand 2023-01-02  1729  	 * a file mapping. R/O MAP_PRIVATE mappings might still modify
fc4f4be9b5271e David Hildenbrand 2023-01-02  1730  	 * underlying memory if ptrace is active, so this is only possible if
fc4f4be9b5271e David Hildenbrand 2023-01-02  1731  	 * ptrace does not apply. Note that there is no mprotect() to upgrade
fc4f4be9b5271e David Hildenbrand 2023-01-02  1732  	 * write permissions later.
fc4f4be9b5271e David Hildenbrand 2023-01-02  1733  	 */
b6b7a8faf05c70 David Hildenbrand 2023-01-02 @1734  	return flags & (VM_MAYSHARE | VM_MAYOVERLAY);
fc4f4be9b5271e David Hildenbrand 2023-01-02  1735  }
fc4f4be9b5271e David Hildenbrand 2023-01-02  1736  #endif
fc4f4be9b5271e David Hildenbrand 2023-01-02  1737  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

