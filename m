Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7C6CEACFD
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 01:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3BC8E001A; Fri, 14 Nov 2025 20:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB378E0005; Fri, 14 Nov 2025 20:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7BD8E001A; Fri, 14 Nov 2025 20:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7738E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 20:13:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0F6516058C
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:13:07 +0000 (UTC)
X-FDA: 84111067614.19.2E62855
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4556520005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:13:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dPqc7lYJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763169185; a=rsa-sha256;
	cv=none;
	b=Tzbs8/qzwZCwg+opYymLbDmMJQWqkAO3r17SZueBln0YZXf/H0h9Ic26lfe7aB8vId1yFX
	CRmj/xGAkdMzHTviWC+jYKOoi3RIcQ6XwrArgFHQYyek2bEfUIA9a8VMjWDFZ2gI3Bz8Cm
	aWqdbBR+kGC8rUz9QDuyZPUtH6XqzFM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dPqc7lYJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763169185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHiX1X/OH2B97KYDjNGeXl/+3uOQJEMtQdEIGNbLMqM=;
	b=OBAQx+3MeRdC0poq2Oqlj8jPxrMgA25H0xgOmisJX/c84WHOzneeXTAYrxnhVlsk8Id230
	jre5kO/YivE3ht70RMlgrXlikOlMfQTXoLMuGdrXudiB4XKPVZb+QsB+hvzjYB6j56OXDp
	acg61WOuOECgGVVm3REgAEkZ63jwluk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763169186; x=1794705186;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZYpyydEIKJdUZcKYOQA153wYBuCQw3r8OGWjWBD7bf0=;
  b=dPqc7lYJluAen6/03LeiCqZityRJO6jJ/yRTs4vS+1KkSQRt1ppG9TQh
   beTpnfmhE2Ilss+FmwiRb7cpDFXzLuN+UYZaCrDWGnTxq3Yhrsi3yh52d
   wsXwI5Nu0cdMu/+kRNvHhGK1Mo3eefKqiaokkjetqJCZznGweVFIaq0I3
   kdzxf4YumjRV+23zBfGAD/cseeemRfJ20iOwWlGXYdWEd5bz6Dp+AP/Qe
   DxaVfKZ2sCgryKFAeZzyLqocyYI+jkNz7SFDqTg20Tg2gFi13VJabP4nC
   AefZNA1nvrR1nv+yEeYrzZm9Y/XwVciytZJ074df4awS9at9t+WqdV4mM
   g==;
X-CSE-ConnectionGUID: vpIoNuaGQdizB+uxzsG+og==
X-CSE-MsgGUID: 8ey4m1MQTke7uXwstMx/3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="65152395"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="65152395"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 17:13:03 -0800
X-CSE-ConnectionGUID: OyXkE+18SIC4r9bUHnq2cQ==
X-CSE-MsgGUID: 7wNDei3wRnCT1vSqROvBmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="194228351"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 14 Nov 2025 17:12:59 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vK4qW-0007Zv-1X;
	Sat, 15 Nov 2025 01:12:56 +0000
Date: Sat, 15 Nov 2025 09:12:35 +0800
From: kernel test robot <lkp@intel.com>
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
	npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
	akpm@linux-foundation.org, david@redhat.com, ioworker0@gmail.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 7/7] mm: make PT_RECLAIM depend on
 MMU_GATHER_RCU_TABLE_FREE && 64BIT
Message-ID: <202511150832.iAyO0SAW-lkp@intel.com>
References: <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 4556520005
X-Rspamd-Server: rspam07
X-Stat-Signature: hayfichtsm9zdgnf5qut9aphwca1g6rn
X-Rspam-User: 
X-HE-Tag: 1763169185-202251
X-HE-Meta: U2FsdGVkX19EK0iIDDlE8X9j4bWgnA+MFLZ3hpwI6DjHzU8UjDG2Lh+OC8pglGB+JisSyJS5k3rNAHv086hXmjPqmGYDHTKc5/tAmhRUVXZhV1YoFfmaAjckomfP0J0aSwis5nXRKKfA2YrGVt4UqZGU69qe7Y8YBfHmwN2t2qFrguwPIE+jlPVnK/tNMuKLGoq4KI+lPEOZ9gle8l5jwpg0QoSp8cO/XSeJ34yz+Gc11gnBI6+p19U4eYAhl42LlX4Af2SMbTcN7y+soV3Zmh6w7cpjhvdxtfpzRXToIunnX/4NwX2j3/5RFgVkB9MRRUdqOFqA5vpP/zDpB/KN5+GbPE48xylTsNEY120/9yEJezSJLC9Wrc+QPSSNda7hYCgYH2aj5iGprFTWu5F2zeXoqAp6qZed1+8ZfrPvASL511ccnacvu4qazSfzGongKKTOFEcHPfn7dESYuBW4T5/ifG9tk3bnuRchoed8M9Sdi27wyY5GNU5wLVTw11+UkQePsw+IIP+H/7oGSKM5b6R4jAwXBHkXpeNts7wBX43MTbuRdELBI5kHBlmQcZuChvalEqxFIR0bR5Jhx8fObvbciP1TyFBwpftkG3ncUCb3r9vISvA/9kxwylKHUvFKEfnS+KfEqtkkicQOxKJADauNxzfcVlXcECEnSy4mwgFiRY3nEoRgXlj7eyUm16iBt9LmDV4vmFo106BcN8xG6v3Vv41TTT1fVZPcLMwbOu6c0SxYtFHNAHJdFJe2IRO+SQDqvM3L7ZEi32nWQ62DmwvkgozUJLpbjDsMVl8kU/F9O/4svgKA9WhoOQ25ebsrltXM3mO7qBd0l7sCNBjBO06nXBV3rFMczSAucTpiAxk49EclR9nvyBtXTjYqcTRGt512/ZO5bkmC4D3t54D/7TdjKONf5jQ43blyhpEZZeVaQjsyXlPC6xtQ7xV7dbVksQrCOS9XB+Mvsvn0WR9
 KHu+UPcQ
 ra3k0S1rrVAbjsyDiy0t9qLn45eaXrdVbeEKJN0y4wsTJNAEXpSHycxIuaM+Qp0RMZDQhSsbJHmCmSNouJGtjbv7r3gBJadNzMLjgjGdBC1IwVTyy8Q3+pnnYDpY0fssHXRvbT3uF1qcOv1QvQYXLdi8648tCToLFpaZ+aVlcWyTdrbRkmDmRiU0J7EH2kMYbh/qWwyaoGOIoQTbe0VHGJFf5K1LuBHmD4dbsw1GiTwmuGrLMY+MZwJ3a8BKZ6sOyiZ32DKTMeRr+lSskjAeajqDJ+b67iTROdMqAZwNxhnZ6+ryz9jeQJU32S8JXun8VAPPgdrh+mmgtSkaVSiAgKVd1+uqXPG2bWKSFqzLabulXpdawDtA0lbBbxIflxJweiiW4vkHpsgv7njmi9z8Udun65pd9rNyO2Sn2W5iUXixtWJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

kernel test robot noticed the following build errors:

[auto build test ERROR on deller-parisc/for-next]
[also build test ERROR on uml/next tip/x86/core akpm-mm/mm-everything linus/master v6.18-rc5 next-20251114]
[cannot apply to uml/fixes vgupta-arc/for-next vgupta-arc/for-curr]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/alpha-mm-enable-MMU_GATHER_RCU_TABLE_FREE/20251114-191543
base:   https://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git for-next
patch link:    https://lore.kernel.org/r/0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch%40bytedance.com
patch subject: [PATCH 7/7] mm: make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE && 64BIT
config: arm64-randconfig-002-20251115 (https://download.01.org/0day-ci/archive/20251115/202511150832.iAyO0SAW-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251115/202511150832.iAyO0SAW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511150832.iAyO0SAW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/pt_reclaim.c:31:2: error: call to undeclared function '__pte_free_tlb'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      31 |         pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
         |         ^
   include/asm-generic/tlb.h:731:3: note: expanded from macro 'pte_free_tlb'
     731 |                 __pte_free_tlb(tlb, ptep, address);             \
         |                 ^
   1 error generated.


vim +/__pte_free_tlb +31 mm/pt_reclaim.c

6375e95f381e3d Qi Zheng 2024-12-04  27  
6375e95f381e3d Qi Zheng 2024-12-04  28  void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
6375e95f381e3d Qi Zheng 2024-12-04  29  	      pmd_t pmdval)
6375e95f381e3d Qi Zheng 2024-12-04  30  {
6375e95f381e3d Qi Zheng 2024-12-04 @31  	pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
6375e95f381e3d Qi Zheng 2024-12-04  32  	mm_dec_nr_ptes(mm);
6375e95f381e3d Qi Zheng 2024-12-04  33  }
6375e95f381e3d Qi Zheng 2024-12-04  34  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

