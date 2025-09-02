Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F05CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134AC8E000E; Tue,  2 Sep 2025 16:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B608E0001; Tue,  2 Sep 2025 16:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0482A8E000E; Tue,  2 Sep 2025 16:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E7CAB8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:10:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA77D119B1F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:10:45 +0000 (UTC)
X-FDA: 83845403250.08.FADB983
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf11.hostedemail.com (Postfix) with ESMTP id E53A540009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:10:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Asqa15kJ;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvGIsd/PEWRl4fnfgopJg9dmr0evm5GCYMMtcvV/vaI=;
	b=tn6Pmq/zz24q01U/LtComS4pI6sJz4CnweGOwi+cWKAD1qBD103fPE+VUQpzql7dxzy7sp
	T8AlLiz3yb6e7334rrrE50uDIF7ktHefUd0X9WbntT1XNQepk+2OaxRW184CjYC3hNBx1B
	/QZIrT2mlLHALvYunfP0zkTsLyCNZZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756843843; a=rsa-sha256;
	cv=none;
	b=x3fpDpulYxA3gTzCEL6w8BpJwpKfw4OntYNaxulb9Gqi/gLAmdjrLOmTFPutva61FnQHpc
	xeOL8a5n/Ubu1IzCJSRlGcPldtLjp/BTnEe/ai12B4BcPeuX9Lbj2qUn4K+LrCpke2dsjc
	PmUaQ/QaUXjvAYTjs2hcIPpsPIhPP0I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Asqa15kJ;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756843843; x=1788379843;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YSX3ayXvCq2CuS4CQ/bYGZn6jqqI1INvzwUeD7fjKTo=;
  b=Asqa15kJD/Bgyl0YwQv9+99FFAGFpMa69ZuJdT077nHncP9481DMzg+I
   I8AITMi1eNqg7TcUh9QxvnJjJkFsubpq8Nrw5DZNscQfqHuwFRjZh9C6k
   mieZwzN2lZMDKCXGqlmVVqbvoFRGMWCBoZ24c0MrvqedftTW1LlAdSPxf
   Jh24ZRCUsR0+wXMIoFddm+O1sLLcWSImMn05WU03/KjmkehZrmJWVAAXA
   5kLHA0nG9NZ4h2tQ6TPr603wIYLBRobRx35uLLjBBoqL4Qqz+SIp1Ic0V
   WSLuDuqsPAuEfXjPYbNJ2CgkkIHioX6ZiJPuVAWha87e6fV4Uz/OW5edl
   Q==;
X-CSE-ConnectionGUID: LuSsQgjsReqGAmBHe2pQQQ==
X-CSE-MsgGUID: eVGkuIJBTQSC9j7jgGANbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62968933"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62968933"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 13:10:42 -0700
X-CSE-ConnectionGUID: JqVyyvvhQ7m/l28TUMxOow==
X-CSE-MsgGUID: BlvYY114S769WpPW3JXOug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="202281602"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 02 Sep 2025 13:10:36 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utXJx-0002zX-0W;
	Tue, 02 Sep 2025 20:09:52 +0000
Date: Wed, 3 Sep 2025 04:09:08 +0800
From: kernel test robot <lkp@intel.com>
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	david@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
	peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
	tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
	ankur.a.arora@oracle.com
Subject: Re: [PATCH v6 11/15] mm: define clear_pages(), clear_user_pages()
Message-ID: <202509030338.DlQJTxIk-lkp@intel.com>
References: <20250902080816.3715913-12-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902080816.3715913-12-ankur.a.arora@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E53A540009
X-Stat-Signature: yb3n4kx4eeu79bssfm3ri7qm7jhsnzbq
X-HE-Tag: 1756843842-177631
X-HE-Meta: U2FsdGVkX1+a8v/aN4Kv+ihs52e+VmHnOJ++NSPdwZhfl0gZwJZBYg7tHMMir0ZfIJ2ZkmvF3bS5c/WA+0CiJUr5qxCdexqBcmQn1o0QCQ7aw/ZY4YGoHeSbQ6GISeD6M7q+nFhP4kBdFcD2BYGsKuDhSyXbCp2lzQyKznX1qzDCXFRuF0Z442dRzt0OUyKeDZT8cTy8QILusEttxmss4UBRlYKEv+JiAlosdtZvyCPv23Yaq4aDT0SXciIhmWtUXd+nFiQnzdmDC8xtyp2nChWMLYqUgPfRMwnWWMSsWXQzZ5IZpRY9pfnJpEQqbWQ1g9mU17GXLwZKr90TGFMYk3B97S7jkdEza7jZb4AODupqitAw047uCx0P2o69m6ZSCDF2Ew9jy6WzLBgui9TlLYWFFjzf29PcCeX9z0jC21h5d5/pDCZuJkFawD/Cl0FmAx492U79ctZUyuqOHxZtUprWCr4KXYaIVL6d5t00QsDsmqjjnAD5ETsCYkUVDP3mIOb0Wj0f6duah9UCNuyt9G39KG/vkMcwp+heH4YAkVVHykH+lomGX1ID32yxFud3++fLY93t6N9SRgxhvObt7d7Dc3ZOszCDRLdhDJ90uvClSqu0EOvzQDs0aiMnuEhJPottbu0yvee3CIqfU2vddydKrghR/CMBtyXMvPQyxHGBZJ074flEkIPZj5Wv9djNrXBSua87/c9s5sN7/ijPc/zwhGbaJxeIYr2uOidOa8QUepdTqdTRbL1QsQJr51nolofCFW/8Ne3hFKW773qmAT1IouNvqabam2rtaKnP/q8xMFtoWQy05SJsT9GnIEAa/dZ3i4yVIUIvyazaqeOZy/l7cZnlnlbLlMwu+wbpZCGQLkYz+4w+aIilLtQhcmws0Yw4aq0uAr19PXvGs0XNTBJvgZ9Zy1s162IyX/kOHwhBoidbg3w3riwlLI6FO0SpqFdtRfsicWnmHnMyome
 YAMymgKG
 U2/7IJ7D4PQoxi0ienr+NDmC8NCGQTvlGsNvnWGHUQcgE8nTIWl/NV23Wuxg0wiijXEC/lKzFUBlgj1UzKv99P658XFbfE3jeS/C5jL2ou/4itc0cJlnrIFOHfWLvtqsB+/gJllplNjS5xeK6nK3yk04JwhlWdXM2NzkXw6KjXPrUIZBS5bLCr/ihXH36jL3y+If0xgpKoXIFuiTNG+OCDbkwutjWRuFuWEIwenO9W0cS09k/8LUgV3KcZWKjL4UeoRGMikZrkhpYPifo38PEClSURJrs/9fCNwxYLeW/nVQKuMSTFoZkqj7yMgs7YJiw2njj8wIoP2R3tQ4i6BIgMwluaDBp8px7Arw/HK/TE7pczQBgkqcoE50pKamTPKkx6+ovzUvvmGDJzuz8XcAzv4R1YGkUH1qfW6k54+kxPgZUobrpP6elh7whmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ankur,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Ankur-Arora/perf-bench-mem-Remove-repetition-around-time-measurement/20250902-161417
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250902080816.3715913-12-ankur.a.arora%40oracle.com
patch subject: [PATCH v6 11/15] mm: define clear_pages(), clear_user_pages()
config: sparc-defconfig (https://download.01.org/0day-ci/archive/20250903/202509030338.DlQJTxIk-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509030338.DlQJTxIk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509030338.DlQJTxIk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/sparc/include/asm/page.h:8,
                    from arch/sparc/include/asm/string_32.h:13,
                    from arch/sparc/include/asm/string.h:7,
                    from include/linux/string.h:65,
                    from include/linux/bitmap.h:13,
                    from include/linux/cpumask.h:12,
                    from arch/sparc/include/asm/smp_32.h:15,
                    from arch/sparc/include/asm/smp.h:7,
                    from arch/sparc/include/asm/switch_to_32.h:5,
                    from arch/sparc/include/asm/switch_to.h:7,
                    from arch/sparc/include/asm/ptrace.h:120,
                    from arch/sparc/include/asm/thread_info_32.h:19,
                    from arch/sparc/include/asm/thread_info.h:7,
                    from include/linux/thread_info.h:60,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/sparc/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/umh.h:4,
                    from include/linux/kmod.h:9,
                    from include/linux/module.h:18,
                    from init/main.c:18:
   include/linux/mm.h: In function 'clear_user_pages':
   arch/sparc/include/asm/page_32.h:22:17: error: implicit declaration of function 'sparc_flush_page_to_ram' [-Wimplicit-function-declaration]
      22 |                 sparc_flush_page_to_ram(page);  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mm.h:3886:17: note: in expansion of macro 'clear_user_page'
    3886 |                 clear_user_page(addr + i * PAGE_SIZE,
         |                 ^~~~~~~~~~~~~~~
   In file included from arch/sparc/include/asm/cacheflush.h:11,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/writeback.h:13,
                    from include/linux/memcontrol.h:23,
                    from include/linux/bpf.h:31,
                    from include/linux/security.h:35,
                    from include/linux/perf_event.h:53,
                    from include/linux/trace_events.h:10,
                    from include/trace/syscall.h:7,
                    from include/linux/syscalls.h:95,
                    from init/main.c:22:
   arch/sparc/include/asm/cacheflush_32.h: At top level:
>> arch/sparc/include/asm/cacheflush_32.h:38:6: warning: conflicting types for 'sparc_flush_page_to_ram'; have 'void(struct page *)'
      38 | void sparc_flush_page_to_ram(struct page *page);
         |      ^~~~~~~~~~~~~~~~~~~~~~~
   arch/sparc/include/asm/page_32.h:22:17: note: previous implicit declaration of 'sparc_flush_page_to_ram' with type 'void(struct page *)'
      22 |                 sparc_flush_page_to_ram(page);  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mm.h:3886:17: note: in expansion of macro 'clear_user_page'
    3886 |                 clear_user_page(addr + i * PAGE_SIZE,
         |                 ^~~~~~~~~~~~~~~


vim +38 arch/sparc/include/asm/cacheflush_32.h

f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  19  
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  20  #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  21  	do {							\
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  22  		flush_cache_page(vma, vaddr, page_to_pfn(page));\
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  23  		memcpy(dst, src, len);				\
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  24  	} while (0)
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  25  #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  26  	do {							\
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  27  		flush_cache_page(vma, vaddr, page_to_pfn(page));\
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  28  		memcpy(dst, src, len);				\
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  29  	} while (0)
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  30  
5d83d66635bb16 arch/sparc/include/asm/cacheflush_32.h David S. Miller         2012-05-13  31  #define __flush_page_to_ram(addr) \
5d83d66635bb16 arch/sparc/include/asm/cacheflush_32.h David S. Miller         2012-05-13  32  	sparc32_cachetlb_ops->page_to_ram(addr)
5d83d66635bb16 arch/sparc/include/asm/cacheflush_32.h David S. Miller         2012-05-13  33  #define flush_sig_insns(mm,insn_addr) \
5d83d66635bb16 arch/sparc/include/asm/cacheflush_32.h David S. Miller         2012-05-13  34  	sparc32_cachetlb_ops->sig_insns(mm, insn_addr)
5d83d66635bb16 arch/sparc/include/asm/cacheflush_32.h David S. Miller         2012-05-13  35  #define flush_page_for_dma(addr) \
5d83d66635bb16 arch/sparc/include/asm/cacheflush_32.h David S. Miller         2012-05-13  36  	sparc32_cachetlb_ops->page_for_dma(addr)
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  37  
f05a68653e56ca arch/sparc/include/asm/cacheflush_32.h Sam Ravnborg            2014-05-16 @38  void sparc_flush_page_to_ram(struct page *page);
665f640294540a arch/sparc/include/asm/cacheflush_32.h Matthew Wilcox (Oracle  2023-08-02  39) void sparc_flush_folio_to_ram(struct folio *folio);
f5e706ad886b6a include/asm-sparc/cacheflush_32.h      Sam Ravnborg            2008-07-17  40  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

