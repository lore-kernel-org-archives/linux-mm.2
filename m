Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DF0D78797
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 15:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FFB6B0088; Sat, 20 Dec 2025 10:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30BF6B0089; Sat, 20 Dec 2025 10:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959D16B008A; Sat, 20 Dec 2025 10:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 836A16B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 10:00:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1351A8B2BF
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:00:19 +0000 (UTC)
X-FDA: 84240160158.12.686209A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6EE061C0029
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:00:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RdfHEfQs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766242817; a=rsa-sha256;
	cv=none;
	b=wPZyrPNlYAfF1mZ9x5U+ZoYXk4o8eM/KcFq1OsoMRHBwwBx97YzdKvVRoaoPNOM7AjGgAP
	+h+NXPtGmUA8E5imokBhNmLYndpULOSvZKIra0fyYYId7B4rM6Iip78c4ah2shgVgKbn04
	1oVduQEGgyB+51uX/GyLfJd2EMj57DE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RdfHEfQs;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766242817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Saq2FZEcwQrd82YyfDDhi4uHhVd+/wspSeiOMWjVo4Y=;
	b=BHwpIZRhIGNV35GYGA3mld2XFCoX3000niEVwSoZKgC7g4yPGpTxVK1ggHwktHN0QAFOQX
	XqK+wlCC8WGFdR9WS+w0C25eLHMrFOpfLuWqlVnLhZtArY0OSVnGHBJftHIAupbsgoIPlR
	Dok5yYj2e+mPGjHUj2/Jn+n7atyDcLc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766242817; x=1797778817;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rGGeCKDnFHL0GTnnxjGkPdlPCh8x4R1AJTq8uQ540Vs=;
  b=RdfHEfQs4/VAybPeDEoyaodCuqmup+amRWm3UNz2udHdZ8/RGmRhZEJ+
   UclYnf30f3T2Hw94epOg5cnWZVIpVTmGb3LNQQFeGzFWH1k75o8DybSJk
   MxWmCR18UANMHuPfM825UjPUgSqUnt435yJ0Y98A5dNpBHzYkPM/bJIFB
   P2Y/e9XSofDob2jd/bZ1cW8oXlkJzKIOBJ5scJyzOha0IerhUhA5TeRhr
   ctpVekYCqwT+nETLJ6rNMaA2v24Q5SNsHeyJBBXjDMvWkrZKBV8Z+h9/v
   SkIKDxQ6o9YppW7oTl/BC4chf3ONd9XU0F5XHGXZKSg45PiNJZVAwBiRK
   g==;
X-CSE-ConnectionGUID: wbH8JOkgRVmeSLXfZALFSw==
X-CSE-MsgGUID: 0jAGG+G3Qb+I77gYCbeBag==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="72034854"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="72034854"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 07:00:15 -0800
X-CSE-ConnectionGUID: ysKCsu1NS7yg8Gtmsb+gbA==
X-CSE-MsgGUID: mUb9l548SkiLudHURCvl3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="198359998"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 20 Dec 2025 07:00:12 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWyRF-000000004hf-0nvW;
	Sat, 20 Dec 2025 15:00:09 +0000
Date: Sat, 20 Dec 2025 22:59:31 +0800
From: kernel test robot <lkp@intel.com>
To: yuan linyu <yuanlinyu@honor.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, kasan-dev@googlegroups.com,
	loongarch@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, yuan linyu <yuanlinyu@honor.com>
Subject: Re: [PATCH v2 2/2] kfence: allow change number of object by early
 parameter
Message-ID: <202512202213.aA8qY41g-lkp@intel.com>
References: <20251218063916.1433615-3-yuanlinyu@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218063916.1433615-3-yuanlinyu@honor.com>
X-Rspamd-Queue-Id: 6EE061C0029
X-Rspamd-Server: rspam03
X-Stat-Signature: jtgruayn6bb7g9mahqeiii5usfir9pw4
X-Rspam-User: 
X-HE-Tag: 1766242816-7093
X-HE-Meta: U2FsdGVkX1+TtURdZXxp3rQRvv6ukqizciEpOYDApxRgWHb0vTT/6Y1PPMkUZiIZxJfU0JGr4Ue4a5x5vgxfG0VgghWp1Sm4L5Soz2H1tTT0tArRBGciggufzW1BzlD0KM/aYvJNB1Zx0tSlwTedxDGr80rciixUTUr+Q1+VPRYEevNl48pNqFsy6c1c/EbRcld2OJV8ervOuI7CMJn4HLVzX4YIW3E+mJeoAcKkeO5jiopC8Svt12/R86kgKCSOBN0zBQjdZ5RCiOK/dGYUMsqfr7X0NQjiFVhGntF0PTiM0oQPkYWsHbX/NMHwx3tS45Hs6v58OZvOv+RzANzyMv8fMhLVDTiN5LeC6zqCrn3C0jgMD0I2HI7MbKhrfnRgLb4vrz06iEY7QNUEmOcg/bX+XQQRqD6/NXZB3W1ISfuqYMUMxQXvZvqf/LF/XPDDkLhQGsA4YtK/GqMM1u3HMEZsT3XnOTkXvYNDnqAtAr07G6lq9VplHufLQlEGAM0wbnviQwOur0Zs1WS8/W0LqCBqeVy9N+eKFMkTOkC2E8Iqd/Wx3fmk/QBTkmtR1LRQg+hM+jhN3PCpIvEdhebnCXn5Gl5kA9g5XDkizDnjKzcVjD31P12nxAq5JFvVbRkC13N1i9jWdgQRSM/pBH9BUC8F2l++mtb7qW+x+HV5ImBaMTB+f44NkkYukRQSLg+OXqO8gM1Nyk4G36/R61QSu87JJLsIDbH3SGNlUIfdHaUBXB19l2VUetyrIq3jRg1KDrB7ipGiyGqBTmRtLQkG84mRPbqyazBEl+DQg5v2EBt/+zzsDh+J6PJ0XZE+cXJ6tg0v3LsGOsYT2X3RYpH2bIyqEQdx9kVNvXd4HH6i3vgJqrAPtUl6c5lRNsdPyUp3/Yn9ajUzM4crwv6mf9GyhRqejbjXYhAjq9dOo1I9lCF8Q1w6uq9lO0MuBPsbk2prNkjT3K8gJHK4Vr9RFGn
 iJJufT7A
 /ME1BiwgH8W2XjT02NuUJFzsl3xKt6yPFu/frXe897ht8dq93epqSug8fDw3uHXmHWih8GCh+a1Jrb/nObyqVi9Gpw2mIzmT9yhielPXkqRGUbahbDXg9jq4djzQxdh1yCTwvWxeIzcPHzz81+YjHonbEJhe/ITGqXtnY8vlLCTndMeQc6xnycU+O4Fggrw5W8aKYHAmo1husVJrcoFGCIMg3J6Ugn8AJp2tEEmPmVLOcaIm4t7bnehM34yGVbqCL13d/rU3JrP1i/ydZf7xZBnGcubVN/LsXqRA1MvVkrNyX/mDv/JQqmH0iieoDnGM9C0+Ly6RhIYn1/JbzC6XIM2sDzLN/e8xOscltCDDkxJ/gmbEipQ9b2SVC3nxPNll3qyes9Wigg063VAEjPlSgbL9X7swmjbXPb7hD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi yuan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on drm-misc/drm-misc-next linus/master v6.19-rc1 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/yuan-linyu/LoongArch-kfence-avoid-use-CONFIG_KFENCE_NUM_OBJECTS/20251218-144322
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251218063916.1433615-3-yuanlinyu%40honor.com
patch subject: [PATCH v2 2/2] kfence: allow change number of object by early parameter
config: i386-buildonly-randconfig-001-20251219 (https://download.01.org/0day-ci/archive/20251220/202512202213.aA8qY41g-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202213.aA8qY41g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202213.aA8qY41g-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/kfence/core.c:997:16: warning: variable 'nr_pages_covered' set but not used [-Wunused-but-set-variable]
     997 |         unsigned long nr_pages_covered, covered_size;
         |                       ^
   1 warning generated.


vim +/nr_pages_covered +997 mm/kfence/core.c

   991	
   992	static int kfence_init_late(void)
   993	{
   994		unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
   995		unsigned long addr = (unsigned long)__kfence_pool;
   996		unsigned long free_size = __kfence_pool_size;
 > 997		unsigned long nr_pages_covered, covered_size;
   998		int err = -ENOMEM;
   999	
  1000		kfence_alloc_covered_order = ilog2(__kfence_num_objects) + 2;
  1001		kfence_alloc_covered_mask = (1 << kfence_alloc_covered_order) - 1;
  1002		covered_size =  PAGE_ALIGN(KFENCE_COVERED_SIZE);
  1003		nr_pages_covered = (covered_size / PAGE_SIZE);
  1004	#ifdef CONFIG_CONTIG_ALLOC
  1005		struct page *pages;
  1006	
  1007		pages = alloc_contig_pages(__kfence_pool_pages, GFP_KERNEL, first_online_node,
  1008					   NULL);
  1009		if (!pages)
  1010			return -ENOMEM;
  1011	
  1012		__kfence_pool = page_to_virt(pages);
  1013		pages = alloc_contig_pages(nr_pages_covered, GFP_KERNEL, first_online_node,
  1014					   NULL);
  1015		if (!pages)
  1016			goto free_pool;
  1017		alloc_covered = page_to_virt(pages);
  1018		pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL, first_online_node,
  1019					   NULL);
  1020		if (pages)
  1021			kfence_metadata_init = page_to_virt(pages);
  1022	#else
  1023		if (__kfence_pool_pages > MAX_ORDER_NR_PAGES ||
  1024		    nr_pages_meta > MAX_ORDER_NR_PAGES) {
  1025			pr_warn("KFENCE_NUM_OBJECTS too large for buddy allocator\n");
  1026			return -EINVAL;
  1027		}
  1028	
  1029		__kfence_pool = alloc_pages_exact(__kfence_pool_size, GFP_KERNEL);
  1030		if (!__kfence_pool)
  1031			return -ENOMEM;
  1032	
  1033		alloc_covered = alloc_pages_exact(covered_size, GFP_KERNEL);
  1034		if (!alloc_covered)
  1035			goto free_pool;
  1036		kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE, GFP_KERNEL);
  1037	#endif
  1038	
  1039		if (!kfence_metadata_init)
  1040			goto free_cover;
  1041	
  1042		memzero_explicit(kfence_metadata_init, KFENCE_METADATA_SIZE);
  1043		addr = kfence_init_pool();
  1044		if (!addr) {
  1045			kfence_init_enable();
  1046			kfence_debugfs_init();
  1047			return 0;
  1048		}
  1049	
  1050		pr_err("%s failed\n", __func__);
  1051		free_size = __kfence_pool_size - (addr - (unsigned long)__kfence_pool);
  1052		err = -EBUSY;
  1053	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

