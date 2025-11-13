Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD30CD4F2F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 04:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC248E0005; Wed, 12 Nov 2025 23:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9CC98E0003; Wed, 12 Nov 2025 23:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B488E0005; Wed, 12 Nov 2025 23:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B3B3A8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:53:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A6611A05B9
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:53:32 +0000 (UTC)
X-FDA: 84104365464.09.17EF01B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id 46E5940007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:53:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RUTxCGG6;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763009610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Zglg3AgaokaKZ7TSYGgg5EupAcuNaf1hB5QpzSmH1E=;
	b=du6uzGpzHGjSX4GqlxRZBylMQoRgTEcRsXhekoJJ2fN+Mwr2wNIwurR8PZtxE1WQA/MY+f
	alEGzFvU5OK6aNovI2LTmVKmMb7TKxFi85kguzTiPkVfuDgFqbAIbWhKZ6ETRjpGDUqWhK
	DuOaZQC3v68ON6d3W47gbeN7PVsGieM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RUTxCGG6;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763009610; a=rsa-sha256;
	cv=none;
	b=V+nHH8QnfpwmZ1j4wnFvlF+uGHlAcraf74SfXqpPBbSqC+ecNm15IUmXjhg+748mZr/2HI
	MUKXsnTXDuagdQod5Lw/SusWzcbseRUY0QTYxhYLsYhCS21GeBSQ2UKMRsMNdRA3bEBNUe
	0G1qbxZUpt0sqWIV+RFVl7l870jAfr0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763009610; x=1794545610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/S+WjjUSEkVtvCHe8svQ+akEl//PD1NKJVfzgDfMQlE=;
  b=RUTxCGG6LgwYD70cRGUpY2uGMwn7QA4fXCo3c2ZF3mOQWwtzoHvaOksm
   lTq1Z/FxP52Nz1iKlSq8nFrXUIVlMzJON6fhfCil6tF+SmdYFWsgeikfP
   tW/xyZNgSk/FqQbAgy1PoFFHbrLG/24sq1IO2dXoBlaMZCSy+Kpgh20tb
   NwyQVwimPV6RQvtDAsq4H+4TeMrLqNWB7EDghctgSFDVo1oNMC/MbUPFw
   KKBf6YsYzA9ZWAnaM4AXT0gLqptH5yh7Z3W5kOfpZuLtfRwl7VrrZcKBv
   mtbdj/5FfmcX4V0UoeZQa+n1kcIT5g3bkNxlpvPT/efn3sUWGTTUjgDR9
   g==;
X-CSE-ConnectionGUID: rf//6KzTRtCzZweY1x6ZNA==
X-CSE-MsgGUID: e2VUv/i6Q6CNgbwJ2sJQzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="82480096"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="82480096"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:53:28 -0800
X-CSE-ConnectionGUID: de5TNagITzuMYBg/6vVGzA==
X-CSE-MsgGUID: 6ZLSdvckRpGmIxHl17leoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="189415465"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 12 Nov 2025 20:53:21 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJPKh-0004tx-1F;
	Thu, 13 Nov 2025 04:53:19 +0000
Date: Thu, 13 Nov 2025 12:53:18 +0800
From: kernel test robot <lkp@intel.com>
To: Samuel Holland <samuel.holland@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Message-ID: <202511131136.6CBuWpof-lkp@intel.com>
References: <20251113014656.2605447-7-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113014656.2605447-7-samuel.holland@sifive.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46E5940007
X-Stat-Signature: 1u9wb3ac4uyc4fdsun4s9dhje141ywzb
X-Rspam-User: 
X-HE-Tag: 1763009609-979748
X-HE-Meta: U2FsdGVkX187Io+d/mx9GQ0HEzgHjVWp+isW/cHkwdo5ctAW2LMIbwrbWD/nWBQyDFCT+ddOW/1HympC9DtO9fZP7JSAZ4rYFA5BehvK5xia+qeAu02DQ2E4iA/5MeEC9YeM0QFFlLlm0fFw1IXuUHo1L7A0FtCeKqbrEirvMqFz5mQkDs9mob/V3oUouqSPZYLCYfuKpgDXRT1luWYWvo332t293usAMeB9fq/Xh6plAROeC8y1uv71wjDMj3JozBb78sDgeEQIh1arZTaA4bDu4UluV18sf8sbkazm+D827Dxxwsi5ARRf6x4+oUcb0/gniPG4t3YNICtfanc8ZP3Ug3f/rfUfNA9fs+HbyHrzzyB997Jz3YWJAq4N+5oUO9BmfCAKYnmkCrdPHu85nNNy81rK1ARwwnBVNyN442qh8jCeX2jKWjbzzwj2tX3nI7RXzvpysXl1n1ysy3C8p4T954kZsfPbIF8uCg+bawfenqPt8tDtUzqpVrjfNtuhYgS4gO3nZd+ahGnBHJUTKKTNBqOxMcnP7A2m+FrG5G+UHQ17L4Ds9eLLCiCAv3neaCFHrpAbdVY0Co/itwcdm31TMnnxutnRo7BIBWc2RENYIWyuRGKMOCBA5OznYxsypMAXxXp4WqhAZx3bMbCtAlcQBqvzPrEYjjlfx5BYnwa7vfalgpmLjJ6rXgmeR5A4cqkHc2BDX8BfoMt++yzDZnxovbk9UL1lvcGYfJwz8NmV6iBhjMPZKQxCrqvoC9p7vZTY78NkoLr/V2DE86MdH+mRf+kGe7XIVlqMhTy9dLzERYnOczMFiupr5RVzHQBV50Gc42JXTyIYUGBGg6l6cqJPnFKwM9+OsdsZ7i4GqycalVaamm7KU7m9bEO2iwq72Ph8+99zt5INRcYR26AP01UiuQn+RlYv4AkhXr3Qn3pxkp06mGp/oM1YbY+8LcAfOEYt/9Cd2Y/NkS3yPdU
 glGo6kMB
 lLjyzZ7WDO7x36cNbpbjnq9HIpbxKU+aCKaagshxMZs4d6aBDY0THFqNZDzBLku/5P8ItUZuapaX2E5tCTPmAM/ELbBErruN7p2HZEJlD8W5tQLE9Lp4wATEGABrnAG3p1Ppp/FXEi265Jm+PRNuAa0qaxpUwQY2QxLN2cVkvTeHMfSjrN0/0rlok2lfv/YW3x7Svapz5QDAO4L4JZ+pvYjfxePPUGsgBgb7ktxLqwesfiSNrLs7Vcpy5g16+IMnIW0BFcHXXy2RUrhwXx3XRgrFKmeGkU1zE9P52Y/I8tHgPVjlvanoOOX9UMB5dEJ0Ep66Gix8U87kEEfpdzM491ohkO0QjrBNjgUpZyj2Y1vwLfOlhekloqFRIpzoCA1wex7XlyKMfmam6zaeP6hGn4RFoJqhVAQ0UOM4t6CLZcJM5WsdyxwXvaqETOLa4zG+Kl8f0yYkKt5iARSW0Ck9/n/j2VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Samuel,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24172e0d79900908cf5ebf366600616d29c9b417]

url:    https://github.com/intel-lab-lkp/linux/commits/Samuel-Holland/mm-ptdump-replace-READ_ONCE-with-standard-page-table-accessors/20251113-095117
base:   24172e0d79900908cf5ebf366600616d29c9b417
patch link:    https://lore.kernel.org/r/20251113014656.2605447-7-samuel.holland%40sifive.com
patch subject: [PATCH v3 06/22] mm: Always use page table accessor functions
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20251113/202511131136.6CBuWpof-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251113/202511131136.6CBuWpof-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511131136.6CBuWpof-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/pgtable-generic.c:27:2: error: cannot take the address of an rvalue of type 'pgd_t'
      27 |         pgd_ERROR(pgdp_get(pgd));
         |         ^         ~~~~~~~~~~~~~
   arch/x86/include/asm/pgtable_64.h:50:29: note: expanded from macro 'pgd_ERROR'
      50 |                __FILE__, __LINE__, &(e), pgd_val(e))
         |                                    ^ ~
   include/linux/printk.h:555:33: note: expanded from macro 'pr_err'
     555 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                                        ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
>> mm/pgtable-generic.c:34:2: error: cannot take the address of an rvalue of type 'p4d_t'
      34 |         p4d_ERROR(p4dp_get(p4d));
         |         ^         ~~~~~~~~~~~~~
   arch/x86/include/asm/pgtable_64.h:46:29: note: expanded from macro 'p4d_ERROR'
      46 |                __FILE__, __LINE__, &(e), p4d_val(e))
         |                                    ^ ~
   include/linux/printk.h:555:33: note: expanded from macro 'pr_err'
     555 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                                        ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
>> mm/pgtable-generic.c:42:2: error: cannot take the address of an rvalue of type 'pud_t'
      42 |         pud_ERROR(pudp_get(pud));
         |         ^         ~~~~~~~~~~~~~
   arch/x86/include/asm/pgtable_64.h:42:29: note: expanded from macro 'pud_ERROR'
      42 |                __FILE__, __LINE__, &(e), pud_val(e))
         |                                    ^ ~
   include/linux/printk.h:555:33: note: expanded from macro 'pr_err'
     555 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                                        ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
>> mm/pgtable-generic.c:54:2: error: cannot take the address of an rvalue of type 'pmd_t'
      54 |         pmd_ERROR(pmdp_get(pmd));
         |         ^         ~~~~~~~~~~~~~
   arch/x86/include/asm/pgtable_64.h:39:29: note: expanded from macro 'pmd_ERROR'
      39 |                __FILE__, __LINE__, &(e), pmd_val(e))
         |                                    ^ ~
   include/linux/printk.h:555:33: note: expanded from macro 'pr_err'
     555 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                                        ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                            ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                                 ^~~~~~~~~~~
   4 errors generated.


vim +/pgd_t +27 mm/pgtable-generic.c

    18	
    19	/*
    20	 * If a p?d_bad entry is found while walking page tables, report
    21	 * the error, before resetting entry to p?d_none.  Usually (but
    22	 * very seldom) called out from the p?d_none_or_clear_bad macros.
    23	 */
    24	
    25	void pgd_clear_bad(pgd_t *pgd)
    26	{
  > 27		pgd_ERROR(pgdp_get(pgd));
    28		pgd_clear(pgd);
    29	}
    30	
    31	#ifndef __PAGETABLE_P4D_FOLDED
    32	void p4d_clear_bad(p4d_t *p4d)
    33	{
  > 34		p4d_ERROR(p4dp_get(p4d));
    35		p4d_clear(p4d);
    36	}
    37	#endif
    38	
    39	#ifndef __PAGETABLE_PUD_FOLDED
    40	void pud_clear_bad(pud_t *pud)
    41	{
  > 42		pud_ERROR(pudp_get(pud));
    43		pud_clear(pud);
    44	}
    45	#endif
    46	
    47	/*
    48	 * Note that the pmd variant below can't be stub'ed out just as for p4d/pud
    49	 * above. pmd folding is special and typically pmd_* macros refer to upper
    50	 * level even when folded
    51	 */
    52	void pmd_clear_bad(pmd_t *pmd)
    53	{
  > 54		pmd_ERROR(pmdp_get(pmd));
    55		pmd_clear(pmd);
    56	}
    57	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

