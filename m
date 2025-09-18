Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D54CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 09:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7FE08E00CE; Thu, 18 Sep 2025 05:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31208E0093; Thu, 18 Sep 2025 05:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E9B8E00CE; Thu, 18 Sep 2025 05:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0E648E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:53:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69C49BB50F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:53:50 +0000 (UTC)
X-FDA: 83901909420.30.17BEA6D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id C7798180015
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:53:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HRks+4Os;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758189227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6DEp+QOWOY3Vn1gCgNtgRJ8hVDlk5Yq7gJryTLQq+zQ=;
	b=Rq3pDk0VfDA2v1fuSeWi5OXu0WTAgF9ohM7U2VVrfCjnXItTVIUvyimgNBYSU76kRAPulz
	pQ+k1+BD94X73GXAzPd2ISVNGsklIu9VARhGuQlL7k1dTEQocnZV5SOaoaJAe7owZRQaYa
	zYzqtQqydH3E6lpaNp14cPAAzQ0Oh7c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HRks+4Os;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758189227; a=rsa-sha256;
	cv=none;
	b=GrWBae5NvOxwr2Io1nQEc0ZaPDegrzKRtBmAoeHbcFKI6f9iJmngseE24Lb2+7rB+gTSaB
	7R0atJj2oDPnYYXoE7H2tXZPDNgJhJQJ9czCrzL283P4kpX9rEJTwlNFHq5O4KT8PqOQ/I
	E9f7ub+hjOnLT7g4LD1ILFW/eW/bSWA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758189227; x=1789725227;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2cErqbyiBICWdnYTmDezVwO1MypxVA26NG2igApKHpY=;
  b=HRks+4OsRgBB5qginSydyDcpM4YvZ2LtQvKnzktOz7Vbt5AKy4ioAHLo
   rSZbqTUOZKwOPdmK/gzqtHqJad3UaROfaJSr9Isc/RiJH17b8ZRuSjZ3T
   V1J+3kus4u4F1tYg0K5aYOSEnYb48OMUV6OkWRs2UM0EKYloFB3Y8HhDz
   Is0pAGXfbzkRLF03nYVUKW+jxYj4gcwh4a0WjdL/RFJZEE5lAB3F0xbuK
   eQvt0FxWMMbTPhjOH5vYEQqW+CbBZqRxIMmLOoVG6twF0g4FwlGhB+MQz
   A2V34OdBjpp0v7HXioay9np3uxcICSr40GkuNH2fe1YmfWt0b9GueyfFp
   g==;
X-CSE-ConnectionGUID: kB8b98utSL6l9DDDMlaLGw==
X-CSE-MsgGUID: EIzaYrAGRFWXPO7mb7W1vA==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71882275"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="71882275"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 02:53:44 -0700
X-CSE-ConnectionGUID: 0R2XNC8kQWyvhlxETnCmGQ==
X-CSE-MsgGUID: NhOaMg56TBuoToW4ZqYi1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="180611959"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 02:53:43 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzBKd-00034z-32;
	Thu, 18 Sep 2025 09:53:39 +0000
Date: Thu, 18 Sep 2025 17:52:51 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [akpm-mm:mm-unstable 235/243] include/linux/mm.h:3679:16: error:
 incompatible types when returning type 'pgprot_t' but 'long unsigned int'
 was expected
Message-ID: <202509181744.SIHyVUMm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C7798180015
X-Stat-Signature: k8po9sbwzqhsrg1ihi7q9r83kcopzo71
X-HE-Tag: 1758189226-285665
X-HE-Meta: U2FsdGVkX1+WeJ0PBNXATna+fWIRsnIjn0+XMD5zes68GhaZVsWPnz3s2R0N84FHz8FiUhz67kMpfIeas9g8Tzczru5z1iaX73+62cjCpMawoIJL59cyiUs4aEpwyxGYSFoNxS1pr9zsfHsge/NgNVTLpu31kp8KIi7F7hx3NJspUrCmKBRbQcpYFjjQgf3PEpVQbOJyeKaJm4Ur5XL6uozaq2wiw9RA6UWoSdvE/iAgPvoN7PWufnyqv7kvc9xMCZtFg3PSjex8i+YE27emp6SloS4ealAhx1i/WoW8KAq0B5culg8DJgLrl+mf1Au+H6u5q4OShufkyvdU+JrmxChrIu/s+9BAdMGJMg47KUeNbbBY5jG4hvU1sNh9GTDVyPRJykubiAedAffUhzsF/5OuqwUO4rrLNvVK2bFBzZOoUL9Lnoh80DCt149N0zPazW63GoKE2bNeTWrYV3zjZCTramaIgkJD+doUT4RRSDKx2Utu/JFv5Ox8bSKHdUWzQoJ4a2P3TJpgpoRlnmPVS+0ItVirvHwdainMVNO2l1IW+YTcdewl59SmMesVezdH8Exk4rbHQLILDcV7d4gk3ruP0tQ262tOb3aXXtKpfZn19wjihGVQOyJJZ3RhY8apAheVWsWt3qZxTWBPHTYXP/kfNPMt7KEDk409EFDnFelwJ9rU75QNox/nHMgl2JKbi9b3WECnMXsF5Zau3HD+qwLNnWSWQO0keqaWVRFZ0K3ufwyp/ww+yRqgAgDyVojz+fwdDZU+F1c+3vSBbGkqSfndZtuP0sos0WiMTe65/TRFS9hpm36y/65XVK1vMlHNWgKiVkqdu3WVB/4/i3aD3N4riH9fCA3sdMc/RkCpG38CifUtByRNW6JHffZxAQyycdJWnZ8uzMt2CvKdNpioLuncqZj3jKhMKEIgbcdI8HgxaHqJBjWY5qAGz2CIPXL7hLruPEfU3h5u37vk4ht
 sG1vQE7K
 4JBPq7R5fvG5V0xWeO9rwEQkoFcpLeN1R6QfEf9yxaIF6jh7ysljqj+5mCxhzvDHd598NWzaQ163wgVk9XqawZ52YG1Ai7strmJhApLFJW/H/4c7/bh7cj94eTXGNBqYGRrmn08gs9hQSMakgP7imhQXesTYf0VrYr2pOgVzMSE6YdlSmkzUkQ9BKxckGMBnzHGGNYM3AnL0F3R0/WiSIRFzHyiESBQ7FGEhAFsMYsOPmWUuasS1H4QZqbJBLE7/F9qYbtgkdaUsLItCcJcKUPtKhuhzKfA2BDIod4pLpWiZ2Egtww/bI+UIVJKaVBUYbQZaHcflQnRjF+8+ihTBrIIdmTB+kJK3hwEkCZMAhLARY+PTqpde0E3X5OUix3BAhqmeVcIP3JUBte1QfoL5JZrr/jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   1f98191f08b46ad015d4480af96541b521fa2411
commit: 322cdf975a863b1d694bfb2d4232eef49944b91f [235/243] mm: abstract io_remap_pfn_range() based on PFN
config: csky-randconfig-002-20250918 (https://download.01.org/0day-ci/archive/20250918/202509181744.SIHyVUMm-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509181744.SIHyVUMm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509181744.SIHyVUMm-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/csky/include/asm/cacheflush.h:6,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/buffer_head.h:12,
                    from fs/hfsplus/hfsplus_fs.h:22,
                    from fs/hfsplus/attributes.c:10:
   include/linux/mm.h: In function 'io_remap_pfn_range_prot':
>> include/linux/mm.h:3679:16: error: incompatible types when returning type 'pgprot_t' but 'long unsigned int' was expected
    3679 |         return prot;
         |                ^~~~
   include/linux/mm.h: In function 'io_remap_pfn_range':
>> include/linux/mm.h:3699:31: error: invalid initializer
    3699 |         const pgprot_t prot = io_remap_pfn_range_prot(orig_prot);
         |                               ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/thread_info.h:27,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/csky/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/wait.h:9,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:7,
                    from fs/hfsplus/hfsplus_fs.h:20:
   arch/csky/abiv2/inc/abi/cacheflush.h: In function 'flush_dcache_folio':
   arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'const_test_bit' from incompatible pointer type [-Wincompatible-pointer-types]
      23 |         if (test_bit(PG_dcache_clean, &folio->flags))
         |                                       ^~~~~~~~~~~~~
         |                                       |
         |                                       memdesc_flags_t *
   include/linux/bitops.h:47:24: note: in definition of macro 'bitop'
      47 |          const##op(nr, addr) : op(nr, addr))
         |                        ^~~~
   arch/csky/abiv2/inc/abi/cacheflush.h:23:13: note: in expansion of macro 'test_bit'
      23 |         if (test_bit(PG_dcache_clean, &folio->flags))
         |             ^~~~~~~~
   In file included from include/linux/bitops.h:28:
   include/asm-generic/bitops/generic-non-atomic.h:166:64: note: expected 'const volatile long unsigned int *' but argument is of type 'memdesc_flags_t *'
     166 | const_test_bit(unsigned long nr, const volatile unsigned long *addr)
         |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'generic_test_bit' from incompatible pointer type [-Wincompatible-pointer-types]
      23 |         if (test_bit(PG_dcache_clean, &folio->flags))
         |                                       ^~~~~~~~~~~~~
         |                                       |
         |                                       memdesc_flags_t *
   include/linux/bitops.h:47:39: note: in definition of macro 'bitop'
      47 |          const##op(nr, addr) : op(nr, addr))
         |                                       ^~~~
   arch/csky/abiv2/inc/abi/cacheflush.h:23:13: note: in expansion of macro 'test_bit'
      23 |         if (test_bit(PG_dcache_clean, &folio->flags))
         |             ^~~~~~~~
   include/asm-generic/bitops/generic-non-atomic.h:121:66: note: expected 'const volatile long unsigned int *' but argument is of type 'memdesc_flags_t *'
     121 | generic_test_bit(unsigned long nr, const volatile unsigned long *addr)
         |                                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   In file included from arch/csky/include/asm/cacheflush.h:7:
   arch/csky/abiv2/inc/abi/cacheflush.h:24:44: error: passing argument 2 of 'clear_bit' from incompatible pointer type [-Wincompatible-pointer-types]
      24 |                 clear_bit(PG_dcache_clean, &folio->flags);
         |                                            ^~~~~~~~~~~~~
         |                                            |
         |                                            memdesc_flags_t *
   In file included from include/asm-generic/bitops/atomic.h:68,
                    from arch/csky/include/asm/bitops.h:70,
                    from include/linux/bitops.h:67:
   include/asm-generic/bitops/instrumented-atomic.h:39:72: note: expected 'volatile long unsigned int *' but argument is of type 'memdesc_flags_t *'
      39 | static __always_inline void clear_bit(long nr, volatile unsigned long *addr)
         |                                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~
--
   In file included from include/linux/xattr.h:18,
                    from squashfs/xattr.c:16:
   include/linux/mm.h: In function 'io_remap_pfn_range_prot':
>> include/linux/mm.h:3679:16: error: incompatible types when returning type 'pgprot_t' but 'long unsigned int' was expected
    3679 |         return prot;
         |                ^~~~
   include/linux/mm.h: In function 'io_remap_pfn_range':
>> include/linux/mm.h:3699:31: error: invalid initializer
    3699 |         const pgprot_t prot = io_remap_pfn_range_prot(orig_prot);
         |                               ^~~~~~~~~~~~~~~~~~~~~~~


vim +3679 include/linux/mm.h

  3674	
  3675	#ifdef io_remap_pfn_range_pfn
  3676	static inline unsigned long io_remap_pfn_range_prot(pgprot_t prot)
  3677	{
  3678		/* We do not decrypt if arch customises PFN. */
> 3679		return prot;
  3680	}
  3681	#else
  3682	static inline unsigned long io_remap_pfn_range_pfn(unsigned long pfn,
  3683			unsigned long size)
  3684	{
  3685		return pfn;
  3686	}
  3687	
  3688	static inline pgprot_t io_remap_pfn_range_prot(pgprot_t prot)
  3689	{
  3690		return pgprot_decrypted(prot);
  3691	}
  3692	#endif
  3693	
  3694	static inline int io_remap_pfn_range(struct vm_area_struct *vma,
  3695					     unsigned long addr, unsigned long orig_pfn,
  3696					     unsigned long size, pgprot_t orig_prot)
  3697	{
  3698		const unsigned long pfn = io_remap_pfn_range_pfn(orig_pfn, size);
> 3699		const pgprot_t prot = io_remap_pfn_range_prot(orig_prot);
  3700	
  3701		return remap_pfn_range(vma, addr, pfn, size, prot);
  3702	}
  3703	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

