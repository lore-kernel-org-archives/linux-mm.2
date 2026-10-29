Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1556606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SPKOMHwK
Received: by kanga.kvack.org (Postfix)
	id B694C6B05B9; Wed, 28 Oct 2026 22:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19196B05BA; Wed, 28 Oct 2026 22:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08846B05BB; Wed, 28 Oct 2026 22:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE296B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:29:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCE461C2B4C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:29:11 +0000 (UTC)
X-FDA: 85374081702.06.2DE56C5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf13.hostedemail.com (Postfix) with ESMTP id 33D6D20005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:29:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SPKOMHwK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M72bklrIu09iEbCbSB40g8WJ8vZOUqKg09TgIo6oM7s=;
	b=AxaGh3T77Gy7GcRK4u7XVBt+F27l3D5F0i1PJIFkzE8gN+VLFqSUrqgzlEkop7QVd7bY8d
	xcYiM9hgKMw9nHpyzTcK0JCPRkIlejCowKL9Da9S07jeYqwemjMBefHjdBdmb3CWZXGIb4
	POAbbUMnzIcnLu/GwGadXSoLLdCshAw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SPKOMHwK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240949;
	b=5ziCntCMFjEkiXVoEXnumpwgrT6BM79Imq/aOkSxZvFLrK89WG60aK9jF9MJs2szpSDy24
	ebw7c+zZFeGQeWu0TYz7cEm7Y+VU1NIKxyqpcz0P2epEuEgtLGCZcMsW4Y4XIBSfOeq5sL
	vaztwv6nUNAtQgYjvSXrrVs3lZIqCFU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793240949; x=1824776949;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T9gdfsQMp6W/ayVj5uDJFH5wzK4XwY/ukHerPwjIVRU=;
  b=SPKOMHwK75TotAHOWWYERPKQJZWJ40Br4xa2HjKiwF5SMESHCL/Jvh0v
   k0uQgd0XsilAvwyIRVD46y/QFp0ZK6T7liZ+n+kXb78IlhTuCq4aJwX5M
   WYZlv3yfJjqaKSHHXMG9jcTfRMPO1itTj3JhEf+rZxeiS/HZIkFvPiZ+0
   9cLk/FarX0J2q5rBvCxz9+luA5kVfJIRInf+eKvsD8neGV+14r20zp3+9
   tUMom+Kh1jHUKQ7EHSH15fsU5jn8Nu5wl98omjWq2mwhVpZ9wSfRpfkba
   0l+Mk0xZ8fJjTWDqmuxNayC6hfF1Opxu9O34buOFu85App+1LYXE+g+Eg
   A==;
X-CSE-ConnectionGUID: luyWE7GITRiZ21j28c+kRw==
X-CSE-MsgGUID: Wk3j0JCBQvihUmTwJgxDdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1965868"
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="1965868"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 19:29:08 -0700
X-CSE-ConnectionGUID: rzefarvVSo+KCk5pir41Dw==
X-CSE-MsgGUID: M9dYC7nJRtiKJkrfwxub3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="5393002"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 28 Oct 2026 19:29:05 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMFsz-00000000ZVs-0VAF;
	Thu, 29 Oct 2026 02:29:01 +0000
Date: Thu, 29 Oct 2026 10:28:33 +0800
From: kernel test robot <lkp@intel.com>
To: Jackie Liu <liu.yun@linux.dev>, glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, dvyukov@google.com, elver@google.com,
	pjw@kernel.org, alex@ghiti.fr, aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org,
	kasan-dev@googlegroups.com, muchun.song@linux.dev,
	liu.yun@linux.dev
Subject: Re: [PATCH 3/3] riscv: keep booting if KFENCE pool reservation fails
Message-ID: <202610290904.wbrEL97y-lkp@intel.com>
References: <58e3baebbf4e454725e6bde8b7a267fb71cfdaae.1793017074.git.liuyun01@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58e3baebbf4e454725e6bde8b7a267fb71cfdaae.1793017074.git.liuyun01@kylinos.cn>
X-Rspamd-Queue-Id: 33D6D20005
X-Stat-Signature: kjp1yrqxkogn58i4eq67zafgic3hzzhp
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793240948-461349
X-HE-Meta: U2FsdGVkX1/631AA66iX3hpyLxB7PoBs2SfI3Qt+e3ABnbFyvAZfl+lrG1alWabmevFWwR/F3Kflcd6f+ecvYen5YeLrzW/PCxBjwgBf+2eN7kWDCbs1SsGu2WbLWnrnh6+CCkuvPsip6njYJ10N+a56lQ5hJtc8wiG5+ZkcQ01crgZsMDyzWCxdtPNbNBc/+F2GAasXKFBPqyy16hnk/8yx+RIYaRvKb1+GhWjPxeISL3DibM5NNglcGNTuahofv+QF0yHsTgbX2CIEAnC2k1qQwUFzWiMThf30b9sA+RNJd48VB1ZTO+fr8QQSwf6gCZ8gJTenlM2Vk8H72R8B7YyME8k1ZNaY78mlNnuKquKqx9Ar/o1gGCLUozLO5sa+esEGr+4TR4SJuIAZWo+UiTmyfKB4v8v+NgqiSdQ0zqytGU6PJPx9EXlRACPf8G/s7r8kIU5hk9DfBzie2oArujeKasE0h1BaOzPkwzkS8ocvsGJ4FZdPyc33Am46tXcWBKHnCoygfZWwqPb6F8lwhZgEHuP3B1G3G51U6hvzA4lo2WP/VV9WgvvbLHmZ6umjsIXr55jOQPRsX0ksGchXkq1VbcGQxESAqgUKar1sXQwiP1hJM8zB1NQctG/DrsdC92yfDJGlcE2p0HZGw7Jmq2j0YJvCg95dTCuKt/w2Ssq0K+c4LWnfCeTqWQb6x/MmR9if5klcK0u1iibycAFEwZMe0aVO6HTdSWpzwWUy/IsaqnzFj71+ms96Pb3FUWikfg/9j9GmHBMByXusgY+oWRnrZDLcvCsot9q9eMPif4lYUh41JBWIaDQ4v9/Xori6OG+jVAEJmQq6L9EUQPKcul5mfy3KVmzQ6188ooZDxPfg4GbO7eg6lY/Hj6/y95IzZkbfnU1aG+N2tDeRntge1YvY8f4KZsjYHxBB9xqbFEX90LXnUjqhr4hdT7MwvjBGfBbjDSJraQVBGVv2+mF
 7LBUdkuE
 +Nds8eM9JML8VKFdnOS+t0YdaDvLYPG15TGK6EWhC7RbyX2cDhR0p31D2qjZ8iuJh98Jv3cigTUpwap+GiaRNn52aH+UPm/AVlv49NExAGxNCQJumFfroAgG9ScK4GEO109FyarS7X0JWuOv1lwUVoHH9kLeqNYrdYeqrouH+5NNscFnti2gkN2o70sM3zfTTCqLC43GVAlz3Wp5WbrIsryam2QPV1xeYbG8A79nKQ9EQlGKdkDteVs3pAqnU238sYP4twJcuSc17jsXoex5/HWto9RK2WQ2FYu7K0EVMVD5XSp8LGxGKxpFsuNN6FEWw9lUNixdYZP78T48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jackie,

kernel test robot noticed the following build errors:

[auto build test ERROR on 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614]

url:    https://github.com/intel-lab-lkp/linux/commits/Jackie-Liu/kfence-fix-pool-cleanup-on-metadata-allocation-failure/20261026-202302
base:   7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
patch link:    https://lore.kernel.org/r/58e3baebbf4e454725e6bde8b7a267fb71cfdaae.1793017074.git.liuyun01%40kylinos.cn
patch subject: [PATCH 3/3] riscv: keep booting if KFENCE pool reservation fails
config: riscv-randconfig-1001-20261029 (https://download.01.org/0day-ci/archive/20261029/202610290904.wbrEL97y-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 15.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261029/202610290904.wbrEL97y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610290904.wbrEL97y-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/riscv/mm/init.c:30:
   arch/riscv/include/asm/kfence.h: In function 'kfence_protect_page':
>> arch/riscv/include/asm/kfence.h:21:22: error: implicit declaration of function 'virt_to_kpte'; did you mean 'virt_to_page'? [-Wimplicit-function-declaration]
      21 |         pte_t *pte = virt_to_kpte(addr);
         |                      ^~~~~~~~~~~~
         |                      virt_to_page
>> arch/riscv/include/asm/kfence.h:21:22: error: initialization of 'pte_t *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>> arch/riscv/include/asm/kfence.h:24:17: error: implicit declaration of function 'set_pte'; did you mean 'set_pgd'? [-Wimplicit-function-declaration]
      24 |                 set_pte(pte, __pte(pte_val(ptep_get(pte)) & ~_PAGE_PRESENT));
         |                 ^~~~~~~
         |                 set_pgd
   In file included from arch/riscv/include/asm/thread_info.h:11,
                    from include/linux/thread_info.h:62,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/riscv/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:107,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:8,
                    from arch/riscv/mm/init.c:10:
>> arch/riscv/include/asm/kfence.h:24:44: error: implicit declaration of function 'ptep_get' [-Wimplicit-function-declaration]
      24 |                 set_pte(pte, __pte(pte_val(ptep_get(pte)) & ~_PAGE_PRESENT));
         |                                            ^~~~~~~~
   arch/riscv/include/asm/page.h:75:37: note: in definition of macro '__pte'
      75 | #define __pte(x)        ((pte_t) { (x) })
         |                                     ^
   arch/riscv/include/asm/kfence.h:24:36: note: in expansion of macro 'pte_val'
      24 |                 set_pte(pte, __pte(pte_val(ptep_get(pte)) & ~_PAGE_PRESENT));
         |                                    ^~~~~~~
>> arch/riscv/include/asm/page.h:71:29: error: request for member 'pte' in something not a structure or union
      71 | #define pte_val(x)      ((x).pte)
         |                             ^
   arch/riscv/include/asm/page.h:75:37: note: in definition of macro '__pte'
      75 | #define __pte(x)        ((pte_t) { (x) })
         |                                     ^
   arch/riscv/include/asm/kfence.h:24:36: note: in expansion of macro 'pte_val'
      24 |                 set_pte(pte, __pte(pte_val(ptep_get(pte)) & ~_PAGE_PRESENT));
         |                                    ^~~~~~~
>> arch/riscv/include/asm/page.h:71:29: error: request for member 'pte' in something not a structure or union
      71 | #define pte_val(x)      ((x).pte)
         |                             ^
   arch/riscv/include/asm/page.h:75:37: note: in definition of macro '__pte'
      75 | #define __pte(x)        ((pte_t) { (x) })
         |                                     ^
   arch/riscv/include/asm/kfence.h:26:36: note: in expansion of macro 'pte_val'
      26 |                 set_pte(pte, __pte(pte_val(ptep_get(pte)) | _PAGE_PRESENT));
         |                                    ^~~~~~~
>> arch/riscv/include/asm/kfence.h:27:17: error: implicit declaration of function 'mark_new_valid_map' [-Wimplicit-function-declaration]
      27 |                 mark_new_valid_map();
         |                 ^~~~~~~~~~~~~~~~~~
>> arch/riscv/include/asm/kfence.h:31:9: error: implicit declaration of function 'local_flush_tlb_kernel_range'; did you mean 'local_flush_icache_range'? [-Wimplicit-function-declaration]
      31 |         local_flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |         local_flush_icache_range


vim +21 arch/riscv/include/asm/kfence.h

47513f243b452a Liu Shixin      2021-06-15  18  
47513f243b452a Liu Shixin      2021-06-15  19  static inline bool kfence_protect_page(unsigned long addr, bool protect)
47513f243b452a Liu Shixin      2021-06-15  20  {
47513f243b452a Liu Shixin      2021-06-15 @21  	pte_t *pte = virt_to_kpte(addr);
47513f243b452a Liu Shixin      2021-06-15  22  
8d6c8c40e733b3 Vivian Wang     2026-03-03  23  	if (protect) {
edf95564726942 Alexandre Ghiti 2023-12-13 @24  		set_pte(pte, __pte(pte_val(ptep_get(pte)) & ~_PAGE_PRESENT));
8d6c8c40e733b3 Vivian Wang     2026-03-03  25  	} else {
edf95564726942 Alexandre Ghiti 2023-12-13  26  		set_pte(pte, __pte(pte_val(ptep_get(pte)) | _PAGE_PRESENT));
8d6c8c40e733b3 Vivian Wang     2026-03-03 @27  		mark_new_valid_map();
8d6c8c40e733b3 Vivian Wang     2026-03-03  28  	}
47513f243b452a Liu Shixin      2021-06-15  29  
b3431a8bb336ce Alexandre Ghiti 2024-12-09  30  	preempt_disable();
b3431a8bb336ce Alexandre Ghiti 2024-12-09 @31  	local_flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
b3431a8bb336ce Alexandre Ghiti 2024-12-09  32  	preempt_enable();
47513f243b452a Liu Shixin      2021-06-15  33  
47513f243b452a Liu Shixin      2021-06-15  34  	return true;
47513f243b452a Liu Shixin      2021-06-15  35  }
47513f243b452a Liu Shixin      2021-06-15  36  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

