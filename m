Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA980CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73036B00A7; Wed, 24 Jun 2026 10:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23136B00A9; Wed, 24 Jun 2026 10:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13786B00AA; Wed, 24 Jun 2026 10:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1116B00A7
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:36:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06BAA1A0365
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:36:00 +0000 (UTC)
X-FDA: 84915055680.22.81B6C46
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18195A0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:35:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HmIXxOUg;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782311757;
	b=XuvUFFm0CT7IwJnZuU6IYOO8deK2jAYzpuFIDfqhwDombj0BajLF4XgijsN72x1E9CoAYH
	0HaP4zu+nmMPIPvIg9zct/pnF22yhZcBNXaG3tC0vpi7UuI2qzcGJRcYOo4ZWyFkmO//8b
	4/OIt9KNoN4KA16fagmCNfQ+zHUhPaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yg/0jal3IrudsxPTqtT6ue0vsq7FD+0X1ETHBfZo6Ms=;
	b=rHjJgl+Ljgpqdc/horVmybFe6qmp5ECzjz1JXFcGex+bep14jkEuUQrLSDL6CTUlfrta09
	9K7OJ4X+5RlRMtH1Y1gq5v2QJVYVLsx+dyHbQ5Jk3F9aAN+ySOYOzYOV66fmtQKOHJdXR6
	upbX2RcpnKuScuHmT577Iz++lnhykeU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HmIXxOUg;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782311757; x=1813847757;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=smE+vXNsJ1nsQc7H0/zD4gyh0Xr8z3RUcm+dMyvDFd4=;
  b=HmIXxOUgTEILWKnh/x3XQswoeywbBawDPU7jo1sfHsf06YUV/wAvjJif
   XhzK4g0wPoEAZ9nnGVQHnFACZS6NssIb7Mnu4hUOqQ0VjRQmXyrcZQg6B
   hVVFOYrz+MxorDv71vrti4qPLgRCyV6gNMivRXxJ+PDeKeNztE2lhiWti
   KloqmmAmXfJ4ClQwf8d2Ls5fgN7VXhz722GsWj9NKRd7bjfL5K6MKOX6e
   E+YyGcdhLdE49nd5zSHjdBgFltRrfUhL6jNTZnvpO8tJO2aFOEnz7xBbo
   eq1oyUh9fHvVk0pQV84bnyxDna+SbkTRQ9+H2D5DqKVDpMq37pRs/S1fD
   A==;
X-CSE-ConnectionGUID: ghkgYUrJT/yxLVAJXOCMAw==
X-CSE-MsgGUID: befLiQkAQ5uUhrO0THKFAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="93434970"
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="93434970"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 07:35:54 -0700
X-CSE-ConnectionGUID: Lo+s5CNYTAWK2mQizzjKYQ==
X-CSE-MsgGUID: nIv/Lq4XS0Gf/8D4VUylsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,222,1774335600"; 
   d="scan'208";a="249912883"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 24 Jun 2026 07:35:46 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wcOhb-000000003Q1-0R48;
	Wed, 24 Jun 2026 14:35:43 +0000
Date: Wed, 24 Jun 2026 22:35:18 +0800
From: kernel test robot <lkp@intel.com>
To: Xuewen Wang <wangxuewen@kylinos.cn>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Xuewen Wang <wangxuewen@kylinos.cn>
Subject: Re: [PATCH v1] mm: fix data-race in folio_batch_count()
Message-ID: <202606242209.fM2W0efm-lkp@intel.com>
References: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
X-Rspam-User: 
X-Stat-Signature: sqine4j8uqztqss9p5c1a6no1qkhg7un
X-Rspamd-Queue-Id: 18195A0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782311756-376752
X-HE-Meta: U2FsdGVkX1/dPvHQKCBHm+N3vWh0fq8KR0lfzJ6/FwFbFkKcoTy25aTHEMYHLtCwcSuevvZgf/RK0EgvVJFKEkurw4LxvoaeLXr+Y4IS7rSOAtzCm+tPxxmqpBEV8q4n9r7vYrWon1xxdw3vX2dT6i4sjxGyit4586aY+qjtyGccWMZtbCbNmo8v75hYLz0QdpGxc59OL/53Klqq3qFRPdOYB2DAGY9e+hKebPtIwpa/6eQJwAQge9tKYSn8mB5KlfCDUp6Q/FhrWQ7/dEgOXuGK2IurnsRgfACZljW7/CNZ/kGKWPs1C4mWlhvNfAmKKyLWE+lztLYke7ccoc723L7/JPHY2FQp9YSfJU1nZPsIXS871McSysRlouUV5gicp1GmeU7VEGXLfdZf4IExVZiPM9deExyuV5M0FfHfnifcQO9d4YFQHe08V4nRFv+jKc5tlB0nouGh4HWkfxtDCv/5fJ98B57CAt/u9jGzBizevHkq1e1svhdWMEheyGCmFqpTSq3EDkJP9G310BVuNbSUg1FrHwKgQ1Y6FVP1k2od3LgC4uIOXCkKS30POCbaeB8k0usGZrqxKyj/y0ZY7lss9inBB3V/F9c5gmb9eZ1Up+yaFJvwNZLSkSFGlaJjIvmjSFck4O4U4LUkrkP4I348BnxvNGUtFWZrI6GcfHtWQW5l3woVGG1PkoHPNx4wlKw8LKVhiqh/ApQipg+VVHLEhWrkPaTl1P6JqHHSk+KdLVKvEZbCA0TKwkYpAgFRaM3D9fOV+MPaUXOdZe9TPKvFnODs9QiHY+PzlcH12MzGRI9QWBqZ2hWBvYkAMS0UEUnSg9SGvb4zXscGBxX3CUZbj0ZJZAPrspQ3MyltF8NE1j81BABVOI5shJu7NcDi2877rcusrF3nwUATnfF4y6jOrJDN6YreJtyHfcakvdfMgrtFP0nAtGKrUgsbdCHvdXLieYdWnMAfpQiuwDv
 R4BBu2yK
 GN1d+H2AEvV9GmMQnEGcy0HbFOO5mgxbDXsHAJpDZmHPH6IZ/H2PSlvNcbQGsJYL5mxHqFtHsIUDt0QxHP8dxXto/cFvN2kCFZ71+ws5JBYEn03PMlDRr9TXgzEt73E6egp3wPx1FiCr6nfgiOiB4fQPF4a4cDbx0H4E+u6l+h3bqEUznoFrpujJXGTz228zqVVUVqiZ/u5atqQiPbH1cVw8AjtzTOIGF5udnOZpFGnS6rcgzzCXbDeeFd8kdf3NVoQXP9vltTZdrsIsdLGRsOLc5xEpIaCKlfdAr0H57PWlCrjfOf6kLMgyGounQpi+Us373ihpwBF97f2VK4AsYs8RCuaCkmt84yRMe/GlB4nAmoCdKeHpjrvB9GSAe37SLZpc4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xuewen,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Xuewen-Wang/mm-fix-data-race-in-folio_batch_count/20260624-172724
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260624092606.1083449-1-wangxuewen%40kylinos.cn
patch subject: [PATCH v1] mm: fix data-race in folio_batch_count()
config: i386-defconfig (https://download.01.org/0day-ci/archive/20260624/202606242209.fM2W0efm-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260624/202606242209.fM2W0efm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606242209.fM2W0efm-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/gpu/drm/i915/gem/i915_gem_shmem.c:6:
>> include/linux/folio_batch.h:56:9: error: call to undeclared function 'READ_ONCE'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      56 |         return READ_ONCE(fbatch->nr);
         |                ^
   In file included from drivers/gpu/drm/i915/gem/i915_gem_shmem.c:7:
   In file included from include/linux/shmem_fs.h:6:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from drivers/gpu/drm/i915/gem/i915_gem_shmem.c:7:
   In file included from include/linux/shmem_fs.h:6:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from drivers/gpu/drm/i915/gem/i915_gem_shmem.c:7:
   In file included from include/linux/shmem_fs.h:6:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from drivers/gpu/drm/i915/gem/i915_gem_shmem.c:7:
   In file included from include/linux/shmem_fs.h:6:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from drivers/gpu/drm/i915/gem/i915_gem_shmem.c:7:
   In file included from include/linux/shmem_fs.h:6:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from drivers/gpu/drm/i915/gem/i915_gem_shmem.c:7:
   In file included from include/linux/shmem_fs.h:6:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&


vim +/READ_ONCE +56 include/linux/folio_batch.h

    53	
    54	static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
    55	{
  > 56		return READ_ONCE(fbatch->nr);
    57	}
    58	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

