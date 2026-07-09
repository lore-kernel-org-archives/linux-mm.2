Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49168C44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0CC66B008A; Thu,  9 Jul 2026 09:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995B96B0095; Thu,  9 Jul 2026 09:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882DF6B008A; Thu,  9 Jul 2026 09:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6343B6B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:34:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB7FBA0187
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:34:23 +0000 (UTC)
X-FDA: 84969332406.28.1BDE56C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1534C1C0006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:34:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JkR1qJnu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783604061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtrMMM37pb4qvc+Y6/GJwlGJ60d+a3IjyD8EGIoYf+o=;
	b=boHgVzZHQxkYocn74M3mCNX4iMt44GgTRWRVn0KNESNDSJoHq8Iw08BJhoUgRsZTBJyRhg
	nLAaZ3ao4iUb5hUmu8QKJzFXKPdpDTOVLWMua83Q+gsMR5AQTZr6fOw4k3RNp+7s4TUZlm
	g8UW7nmGRRSzy1KA0d2EhnEAPNz69KA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JkR1qJnu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783604061;
	b=wdiQsesOB8XTXNeRKoJ9yzdwbVrhMtjB+AxQ8HkTblwOJHLEvS8yf7yzqtJCSsjdLklddg
	l/xXdt1jaO/jTTscaGY3KPDrsyB6+ij9K1I/vqcgGm5MET0L/9yN49Ju4tRsP74pa2e3eZ
	Kwxqva6pBkOC1BIZt72gjSfwQTUQHG4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783604061; x=1815140061;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X3CwQbCqfrcNU9ZylJJlHJqkM//5I2Tgy37tgnnrNBo=;
  b=JkR1qJnuY5IFhoxwBFY0Mv5B6zMJxwN3Md5BFmWIY8osvo9VKX0KIkoF
   NHFXOh91kg6BbDcki/EjxYTzh1hITBWl/23BB0jTY3zvWCt6pGKah4Kr3
   jeSDuQsSZBn/joTcPeN2V5YlE0/6LB+f5UpWwIwxyrqmBi2C2QFuvtQ7e
   h/K3IWgxQHVxILBNSi1C1ELsKGrnq1x7o0h553ajAGYxaloRGEgjXcJ7J
   jyLeEuUdAUJ28VytVK4sqRlunWDoErSA34nkcUYfO77FG5doxWDE2bjEY
   BDoULx+YOkQTlqGszfEAC+Y5+4X1c1kauI3WZ67ypcbTyR6+4UOHHBfMG
   A==;
X-CSE-ConnectionGUID: oIEQEtQuQ7mii+28wbdXjg==
X-CSE-MsgGUID: Q7LChY8/QVKwsaBzMB1LOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="83258542"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="83258542"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 06:34:19 -0700
X-CSE-ConnectionGUID: 9cubGrFMQ5SZBjxcss1LVg==
X-CSE-MsgGUID: SZ4xYWHESIejiE1wEnNLhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="250188140"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 09 Jul 2026 06:34:15 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1whotI-00000000Hih-27Cs;
	Thu, 09 Jul 2026 13:34:12 +0000
Date: Thu, 9 Jul 2026 21:34:01 +0800
From: kernel test robot <lkp@intel.com>
To: Vivian Wang <wangruikang@iscas.ac.cn>, Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	Muchun Song <muchun.song@linux.dev>,
	Vivian Wang <wangruikang@iscas.ac.cn>
Subject: Re: [PATCH v5] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
Message-ID: <202607092128.yG6dYQOt-lkp@intel.com>
References: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3@iscas.ac.cn>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1534C1C0006
X-Stat-Signature: ienh7qsa59i6jj3m9k1c6d53mudksku3
X-Rspam-User: 
X-HE-Tag: 1783604060-428192
X-HE-Meta: U2FsdGVkX19rBGovWN7lQAsyuujCUXzRB5+grHKIXrmpmF2FhHpjzd+rW2knXV+BXzfDdf5KDdPUvz+QlYXoXoSVlg9FoKEaDFquEclOB/ziCJzYdP7yK/UNxLpHj1wTTL4K2223135N0ioapym4Zd6Dgt3BsEBCjV4pZOpv8UuS18l9/gKXRaIIuIeWLGSkY1+fh+qrHV2lu5KcIJpfDiHdSQ1kBIjMs1jVcBriUiFGpx704NfwxUPrr2S+u7hA370K6rfQtcR0ZLOSQeOuLz9CmulzVjjUmGmNVyVWy7exp4p4gf3PDVXfyD+Q9XvngUz7BfQJ62SUZhqt9LIQULhReVcf68cyEsQAINqwKxDek0RvkHzHAQdHN9+0HqmRhYJWGMO/mxyCKhUPq9dFLQlpcgM6vC76eozm15M5smZz+Q0A0drjHFNr0HeXZTxd2KYHNXOk5D1BudnidsjJeCdQtSEkArwYRS7WzD7c/n8cKlz6UnjOy+4Ze51dU9+2in16kP7ZSJGcyOhV7xkqrBOOfPslfr+O0QNAmp/pYT6HOAusAokHxfOGHG/cXNQkEa2h9gFbVqkUPrBfbQd1kLmloH/YFwC5hToUBXC0+V4Q3tgJQcc1KMAr8imOKb3YA2YKPSFlnAbVKu0NRteukn0ReEbDQLKscwQvSjanDohK4ULJQ8Qy6MNlpbG4VrsCERqo0p7iMrwRonsXJx7bus3ynxG97r3ASmvmUSv8pH90LYh9e0W0TVthMAwThcBxq4koqekhqNTiwyUORKm7Xako1cTglZPr1Pcwv3o0nHXiJmlKBoI9FJB3eg9G2Ma8eWGAj1oOGM0uCY7taQfOAx6+L0XXv7GgVQozvufCrH0Ux3xiC39IsErHIs4TprQSKC1YIUliFAOye3yMaAXKa32vidi81JpSMBbQM/uwzBbn+iQAgnTw6exkWhDVeobnnYKJShAPIvsJqxTE4aB
 VaO3lGSI
 ceffPNnEW7TDqzojEqp//rgW0yQblXmb3u3eaBb9hXz+UMoMiaqWBuVj9uMX+z1yCr3hvWOw6BRbERp3kI9VVoYZTqeTFBAdydhjn0dcwdKv1h1fXY6e+Qlq9aJNqPBi+xMArjX7xKNY1P71dvPf2ORLZbq1ZvUtdCOhzsXt8y0JV6jW0SL1EEBb/tkbV3S/lHtoQb2EbveTtChpWCqrNj41q0Itjj7IL0roXf2w5mjFrPVSofuHVIzpkeP2hP8gNA3LocmHfoQgv4wj++QyC1GXrtXiYaZtGlEfIUiOIVeuzQpldOO7jY2ZWhHolrLlMHU65Dkx7AJH8bBp6bbPbV9bywVT/9seGjavkQRp9MEiwwsTkY82zF8EQ+Zbubc107VeY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vivian,

kernel test robot noticed the following build errors:

[auto build test ERROR on dc59e4fea9d83f03bad6bddf3fa2e52491777482]

url:    https://github.com/intel-lab-lkp/linux/commits/Vivian-Wang/mm-sparse-vmemmap-flush_cache_vmap-after-hotplugging-vmemmap/20260707-121114
base:   dc59e4fea9d83f03bad6bddf3fa2e52491777482
patch link:    https://lore.kernel.org/r/20260707-mark-after-vmemmap-populate-v5-1-77d1ded3cae3%40iscas.ac.cn
patch subject: [PATCH v5] mm/sparse-vmemmap: flush_cache_vmap() after hotplugging vmemmap
config: riscv-randconfig-002-20260709 (https://download.01.org/0day-ci/archive/20260709/202607092128.yG6dYQOt-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260709/202607092128.yG6dYQOt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607092128.yG6dYQOt-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/writeback.h:13,
                    from include/linux/memcontrol.h:23,
                    from include/linux/swap.h:9,
                    from include/linux/suspend.h:5,
                    from arch/riscv/kernel/asm-offsets.c:12:
   arch/riscv/include/asm/cacheflush.h: In function 'flush_cache_vmap':
>> arch/riscv/include/asm/cacheflush.h:60:16: error: 'VMEMMAP_START' undeclared (first use in this function)
      60 |      (start >= VMEMMAP_START && end <= VMEMMAP_END))
         |                ^~~~~~~~~~~~~
   arch/riscv/include/asm/cacheflush.h:60:16: note: each undeclared identifier is reported only once for each function it appears in
>> arch/riscv/include/asm/cacheflush.h:60:40: error: 'VMEMMAP_END' undeclared (first use in this function); did you mean 'MEMREMAP_ENC'?
      60 |      (start >= VMEMMAP_START && end <= VMEMMAP_END))
         |                                        ^~~~~~~~~~~
         |                                        MEMREMAP_ENC
   make[3]: *** [scripts/Makefile.build:184: arch/riscv/kernel/asm-offsets.s] Error 1 shuffle=275821313
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1405: prepare0] Error 2 shuffle=275821313
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2 shuffle=275821313
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2 shuffle=275821313
   make: Target 'prepare' not remade because of errors.


vim +/VMEMMAP_START +60 arch/riscv/include/asm/cacheflush.h

    42	
    43	#ifdef CONFIG_64BIT
    44	/* This is accessed in assembly code. cpumask_var_t would be too complex. */
    45	extern DECLARE_BITMAP(new_valid_map_cpus, NR_CPUS);
    46	extern char _end[];
    47	static inline void mark_new_valid_map(void)
    48	{
    49		/*
    50		 * We don't care if concurrently a cpu resets this value since
    51		 * the only place this can happen is in handle_exception() where
    52		 * an sfence.vma is emitted.
    53		 */
    54		bitmap_fill(new_valid_map_cpus, NR_CPUS);
    55	}
    56	#define flush_cache_vmap flush_cache_vmap
    57	static inline void flush_cache_vmap(unsigned long start, unsigned long end)
    58	{
    59		if (is_vmalloc_or_module_addr((void *)start) ||
  > 60		    (start >= VMEMMAP_START && end <= VMEMMAP_END))
    61			mark_new_valid_map();
    62	}
    63	#define flush_cache_vmap_early(start, end)	local_flush_tlb_kernel_range(start, end)
    64	#endif
    65	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

