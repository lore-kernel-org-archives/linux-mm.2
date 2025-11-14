Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D11ACE8D40
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F19F8E0037; Fri, 14 Nov 2025 10:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9DE8E0002; Fri, 14 Nov 2025 10:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DFE98E0037; Fri, 14 Nov 2025 10:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B16C8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:25:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E66F413AD6F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:25:04 +0000 (UTC)
X-FDA: 84109585728.25.970C219
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA3994000F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:25:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EnVVrgyr;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrBMlcRWkP76NvLtiv4zt4gAuq/1nWU6Ofcx1+shtl8=;
	b=kEjM1h+Ntb9nLoLDfZ/44IX16fp6NdSRA0VF1oa1bFaR4QGnzQdH8yRDGf89DNuVj0qT2h
	yI5bufDn0LdpiO9RLdanXxTs36MtULFXZ3f8DjyTT9oQTyNOpWS8p8i4aIUabDQWDuQVXU
	FijqSlBJGgNJos98SMwC0sUfFZIJWtI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EnVVrgyr;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133901; a=rsa-sha256;
	cv=none;
	b=qltx2YbOqiQJCz2HfcBdRx2PtNVBqxogZtMICnu6yXtoidXXCI0Apqgmv1ad+D6d773APW
	4+3Gu0V8YbU6IvnJhkQ4bgp7wyXUXjr2s7qlWkCE7ZINVesRrdWCyFzMHb0HpAOoPcOJDR
	z8t/JnM/KT+LaEZyBpT81h5ys28GVE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763133901; x=1794669901;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aizLmedT0fRTy5zVNG9dpD+vEzYlQhCVBL04khAlSb4=;
  b=EnVVrgyrJQhJ/LDaociJbJU8JXPdylxDOIYgYmHmhcCsj3Y9OEdGPvFs
   b563asPltLhI70b92UMDMud0CelvHffXFhqD1Huwe76yrfN80Fy2HqAWc
   8b58Axgc55UiUo8a2WczIaNaTcVO+Q1JzaEwiYYgcZBmSW4N8gmWTok/H
   UqISUozyuFb839j6+OTqFtIJUCHSMrl82Ssz+4K+ZmHmivSUqZbQK/bZc
   7XetoG6Wbc4cCEMs5Ttj1FNi+KL7BJlVH7Pf4dlDavE7rSZfDjlrAyybC
   3pD7FbiU+8wZrLbWtFMcq7ZWVno85+OhcKwBa3q4kqNgmawiD/7U6fgQR
   Q==;
X-CSE-ConnectionGUID: R07VwT7mT2mLEdnLmc7bww==
X-CSE-MsgGUID: 3bAJoS8tRhGXXOXj2PFJDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="82861610"
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="82861610"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 07:24:57 -0800
X-CSE-ConnectionGUID: hfJjsgBhRaKfy7+Qo9s9Kg==
X-CSE-MsgGUID: YaJ0me8VRVeNlnuDFRvNsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="189990412"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 14 Nov 2025 07:24:50 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJvfL-0006i3-12;
	Fri, 14 Nov 2025 15:24:47 +0000
Date: Fri, 14 Nov 2025 23:23:56 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
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
Message-ID: <202511142237.yj4hppoj-lkp@intel.com>
References: <6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6289d60b6731ea7a111c87c87fb8486881151c25.1763126447.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA3994000F
X-Stat-Signature: xnp4twdpigeju75eokf44yck3og1rcom
X-Rspam-User: 
X-HE-Tag: 1763133901-856429
X-HE-Meta: U2FsdGVkX1/MbFEuo3odaS7gE4P6K2BJiQVIkT4/hNjLmXg7H+ylHcnXejUdEMkpHePj62amoEDijoVeRIlUtqsFr2Eeb/6qGGLAD45+qrw91JWRAuXwSL2wyimmndAqQSgPBfU9wxzY3eaaOWH0EP9W6NmZaprYw8CpERCxvpZaRIAb1IVehj1U4k2rg9eBJCu7zqIqlsS3WmVCdm/Zz7alI/sNqoU2091K9yjhn0mMzpehHqjyunWMEuPwUze1HXohGkJ5u5d3/BnyuCyQQQrJqjiaBllcTa4BQ/VViS1TKlujDcYYLuaFGxg8JXOas8lW4BF6lRm3XQORmO+sZAfC/646quyJxpCrdMfYUr+EwKHvHPc4/6qCV8VDoD4GtzYPtRsXSVQBY02tMzBcvSZj+7tbiGxdmTeM+Gfpozr5IhDySCCNlUyJQ3M0bFzuNDTqa9NcBFFv3ls+45AQ6tZv0u51g4fBbme5Ljv8bIVchoYgbDwaB/OSgF63YurZtbgmqPbQJ1tttfPyjdvGqCEwPhcieLGbjk6DZenPwl0CTOB5FjTU9wd6Qhyg+cpwR/GleSzbydc2CTrn6DMrLUUYTXogCYPVfGwBjUZCNTki07jcEv1U7J2/iZZt0KNx2nI8VxaGF1RqDXinVMNmO25IInXJ0muCaZR2NnMi/XeOIbGm7xoU9VW3E4xUPbnaDFR4A7uvONOVk1D+pWTIDl611aUMopmkqIBkGs5nysff/RBOgoAAfgGDGQsex9llqk/vUDEV7Y7tJIp/4xGh7eUrZyck2qEQazeF4yB6L6F2TIbNRnfW+ej6jwypITZrBleRd3jLMvnPvRfhhcR0Zjw5EAsZk0MyIlQd+a+BKp2+Q6ylpUaY0ZqvzkrXlxQSB6g2waGleZpmT5ZdCF/v4pni6ia9O7utvlguFU+WMVDVIrsNNUX1JM5NcByUZZ+7U2L/IGTFcUJXB95neZ4
 zQLDKBW1
 os7pvtvF88cHMNZuXexuNT7PUxwcypDcimFcMQZ1Fsr4kWZiUhwKHA4yM+7NpVfk1WIDuiXffP1BVSl/2fs9JHVoGaEXeWJmV3Yxkg0GzRsktuQ26IJHdFdap0C/z1Cp+1Won4G/kSdev8eaRtZ7yZeFdF7iYKXdijZS/n5QShKXhCqnTMyMjXqNp+3NkwXNNeHhOtCjsEpv4h7nK+JuzPKly6PCOqiH/ygls0LtCGMDIOzO2ZTvUSOgVnbJfGeBhD/QDmulxpFR46GhWRBM+EYfYzEmy0PygbCzkEMp68alOm6ONVo/s/6pIkMmSDhOT2jWwHTFfVcf1x0h/wisGefp041JQ3CvSb5WRRexRqTjO+incHG7YP3jQNb/3t8ClJzqpDxvXHKDtUInQRHTDqBTzC7LT/zmH+8tX
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
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251114/202511142237.yj4hppoj-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511142237.yj4hppoj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511142237.yj4hppoj-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm/kernel/asm-offsets.c:14:
>> include/linux/mm.h:1734:32: error: use of undeclared identifier 'VM_MAYOVERLAY'
    1734 |         return flags & (VM_MAYSHARE | VM_MAYOVERLAY);
         |                                       ^~~~~~~~~~~~~
   1 error generated.
   make[3]: *** [scripts/Makefile.build:182: arch/arm/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1280: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/VM_MAYOVERLAY +1734 include/linux/mm.h

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

