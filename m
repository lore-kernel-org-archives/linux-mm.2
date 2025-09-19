Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6891CCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 11:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A118E00C3; Fri, 19 Sep 2025 07:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD91C8E0053; Fri, 19 Sep 2025 07:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16078E00C3; Fri, 19 Sep 2025 07:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9B68E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:33:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40BE6160660
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:33:35 +0000 (UTC)
X-FDA: 83905789590.25.A747342
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8DA8AA000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:33:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CKkJ6omF;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758281613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZUSPluAfOnwZSybIP1KqjVBMpEYlW95glA97BjTRhk=;
	b=X8RmT9rVEZxlNPuNS4HV0tTB0aiVuK4exiXqJ+Xc1FMR8eBzXJS+Te+Z6Q5ido+OS5wjnR
	kjC1cSo1ZyUy3pfGEHg/SElJfsEFb/ZTRR56DRXZ6fjSBSkY4PfldbCnW5+ZJ+yHYqJDE+
	CWkb/rDP0r8nEd663fFM8snzXVGtrjw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CKkJ6omF;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758281613; a=rsa-sha256;
	cv=none;
	b=t0f3K5o176dJpJ6fHeTwpaD9FR6tmEPpK5whNSV9lyUSIIVP5j550T2qVrNHQoonoWhoPS
	f1pSerVjWUs4RSNO9fgwcyCS92GRG89e0L1TjNA61XMCIB0YFds4LteCi5ZYvTpIzYsbsr
	pg1VxvaowvUB5rxmdvLuh7qR2YCngUw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758281613; x=1789817613;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QKhnnAL6BDX+xxQOeAiqNh0DHBoO9yCBDNo5Ke7f/P4=;
  b=CKkJ6omFD7gSVCluQA5S93e6WlqAIYI/xXyyMTu0T9rZBA1fBuen4TxF
   9xMCrpDCnQRQJPe6KjAS70A8AZIjiuo+q5cSyzL9O2EpZclLdYUFmfvYd
   EQYhlxKxB+hVl09Ii6+yOaNQ+jtjc7HPHbgVHYvR8U7WgBaE/Id7HkD91
   Q6vkU0/aVCZuYlFcBUXJFYmDNnMWJt0oYaxJmj370hHG3m5ehV1aBJyeS
   Bg/FgRjBIzsDifHohEsiuwyY3yqZUuDy9XcavKHbHaIFqYTQewVzJ6fwS
   j95ZZAIz9r+g41ty5VFRbFDowRzwd+Y1AUd/cLgwIvxDv5P3w7uUUo4Uc
   g==;
X-CSE-ConnectionGUID: iAtiZgTQQPaSUfYErjY13g==
X-CSE-MsgGUID: W5PpvrKwTSyQiTvDTNBdWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="83229924"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="83229924"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 04:33:31 -0700
X-CSE-ConnectionGUID: dXqTEXXpQJiNyfzl15ufyQ==
X-CSE-MsgGUID: 2qrvnKEFQ2SVC6rfZhfn4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="175372303"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 19 Sep 2025 04:33:26 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzZMh-0004Fv-1w;
	Fri, 19 Sep 2025 11:33:23 +0000
Date: Fri, 19 Sep 2025 19:33:12 +0800
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
Subject: Re: [PATCH v7 13/16] mm: memory: support clearing page ranges
Message-ID: <202509191916.a0oRRfua-lkp@intel.com>
References: <20250917152418.4077386-14-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917152418.4077386-14-ankur.a.arora@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8DA8AA000A
X-Stat-Signature: r4dddrm9xzd9tiqebos9tmhcr4ryxnif
X-HE-Tag: 1758281612-208492
X-HE-Meta: U2FsdGVkX1/PSNPeTxT+ZGwD/YWvjcmsARatuHREjQZxcjmVX7pJGWF65ArXdfZvZVzU49rwLjAI8gHm3aHWBEdy/tAo79m7m8RNzXQBzkQ2y/1iyjf4TAg6tZomylx7AuumTufwirKd95w9eHmDCxlesEBY/V4NPyp4WqQz1e3III0UFV46+Qo4hrKhNL1vjXSy4BRUaZss/yKMk1kYweLtUa7nz8xNkYF0F3VSUWKgXGTfWPCIBDpy2uo2pXdgxdfgzVn9Sq4jmW51p1qZYyy/m/jCXomiJMhpAVSDEh0J2C7p9F7dGfbS5hc60x+DSoxUgn4tyvSkYIt9z+Ok7cBwCIt5x+2XF40QBB6S7JuWqGMkyNSEoVIY1T3Kx561/0CnEPCYTFqpkpgZ60MtO2hcRoD84BfLmMieYz4n/Kd0B6DudH68zEZkAjgJaNBzStMtYpWJR73hpTtPK17KFSpAg1xSwVqe8lyZuyB8A6DYckWQZKpqKTrk+2Ofjto1yA+P6Ycp46PtZjqgTTznVbatt2ixxRux5ecn33tXQYxCVWg5ItyzMi1K1wmd0SE9g9MsY1dujT9sFB8heqexs3qt3fEO+AYqRyi9O1VH+7bLGhw4a/umaUMYgyef1q/EQgagvhL88h/5fwrCJX/fJ9sw/z0QXN1nQyv+Ib20y2If/fdqGHI5KZPWFci2IVAE66g4heEawmyAe/oIXcAb4ZSUNEnbybtAOJJs6nUPCnTfiSwackjMI2vjc5MJSm9WAsnVxf1JDdAqF0sz42lTsJCf7QflK3zQOYoBFotLYfT+NzG6GAz60BQpR9WR2ARLHuQ2+TqZw9pTlwg70DgvHiBZLWcVrPMoJWSUi30zAsTVFFvV30HJp0VS98sCpu3nnMjuTwQoo3Zj91Z7y1OSV3HL0IecXGONjqJuC97w16ym+S5VagwT9Nz2aBjm1N8Y6EJxpix9EkmwILJYAK3
 SW9rWPyf
 EZHezjhZOLEbHtIJMse5fPKhdA2OkVPbI5ct7lU40eVotTGGNJVXOk6V3SyqZff5cskU5/8kg0FGFoVpoXYdPjPHjywKp0EtiepDVxMoZWsDG0TLxi9up9BOq4aFi4Bc7CBQnXxaLhI0VKeBLZ1ggaXzLkmFSaTgwiqaVVBiUjM2eZNDzXk1LGEv1+mrkmqcgOFxXXgQtSdsbQRXixv7MOtixHVXUsUXEqebzDmdMjglDBmbH+Dhwd5l9DpxhCUs1ygI2EnSXeKSDHDLNsM2dplY6Woqd7j2Y/pqOg00fl3vZchRnuofuK9vaICFZCavR9495FSOfFKzamPMPgLl6vink30C1uJuxI95k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ankur,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Ankur-Arora/perf-bench-mem-Remove-repetition-around-time-measurement/20250917-233045
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250917152418.4077386-14-ankur.a.arora%40oracle.com
patch subject: [PATCH v7 13/16] mm: memory: support clearing page ranges
config: arm-randconfig-001-20250919 (https://download.01.org/0day-ci/archive/20250919/202509191916.a0oRRfua-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250919/202509191916.a0oRRfua-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509191916.a0oRRfua-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/arm/include/asm/thread_info.h:14,
                    from include/linux/thread_info.h:60,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/arm/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/smp.h:116,
                    from include/linux/kernel_stat.h:5,
                    from mm/memory.c:42:
   mm/memory.c: In function 'clear_contig_highpages':
   mm/memory.c:7199:38: error: implicit declaration of function 'nth_page'; did you mean 'pte_page'? [-Werror=implicit-function-declaration]
    7199 |                 clear_user_highpages(nth_page(page, i),
         |                                      ^~~~~~~~
   arch/arm/include/asm/page.h:152:36: note: in definition of macro 'clear_user_highpage'
     152 |          __cpu_clear_user_highpage(page, vaddr)
         |                                    ^~~~
   mm/memory.c:7199:17: note: in expansion of macro 'clear_user_highpages'
    7199 |                 clear_user_highpages(nth_page(page, i),
         |                 ^~~~~~~~~~~~~~~~~~~~
>> mm/memory.c:7199:38: warning: passing argument 1 of 'cpu_user.cpu_clear_user_highpage' makes pointer from integer without a cast [-Wint-conversion]
    7199 |                 clear_user_highpages(nth_page(page, i),
         |                                      ^~~~~~~~~~~~~~~~~
         |                                      |
         |                                      int
   arch/arm/include/asm/page.h:152:36: note: in definition of macro 'clear_user_highpage'
     152 |          __cpu_clear_user_highpage(page, vaddr)
         |                                    ^~~~
   mm/memory.c:7199:17: note: in expansion of macro 'clear_user_highpages'
    7199 |                 clear_user_highpages(nth_page(page, i),
         |                 ^~~~~~~~~~~~~~~~~~~~
   mm/memory.c:7199:38: note: expected 'struct page *' but argument is of type 'int'
    7199 |                 clear_user_highpages(nth_page(page, i),
         |                                      ^~~~~~~~~~~~~~~~~
   arch/arm/include/asm/page.h:152:36: note: in definition of macro 'clear_user_highpage'
     152 |          __cpu_clear_user_highpage(page, vaddr)
         |                                    ^~~~
   mm/memory.c:7199:17: note: in expansion of macro 'clear_user_highpages'
    7199 |                 clear_user_highpages(nth_page(page, i),
         |                 ^~~~~~~~~~~~~~~~~~~~
>> arch/arm/include/asm/page.h:157:15: error: lvalue required as left operand of assignment
     157 |         vaddr += PAGE_SIZE;                             \
         |               ^~
   mm/memory.c:7199:17: note: in expansion of macro 'clear_user_highpages'
    7199 |                 clear_user_highpages(nth_page(page, i),
         |                 ^~~~~~~~~~~~~~~~~~~~
>> arch/arm/include/asm/page.h:158:13: error: lvalue required as increment operand
     158 |         page++;                                         \
         |             ^~
   mm/memory.c:7199:17: note: in expansion of macro 'clear_user_highpages'
    7199 |                 clear_user_highpages(nth_page(page, i),
         |                 ^~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +7199 mm/memory.c

  7185	
  7186	/*
  7187	 * Clear contiguous pages chunking them up when running under
  7188	 * non-preemptible models.
  7189	 */
  7190	static void clear_contig_highpages(struct page *page, unsigned long addr,
  7191					   unsigned int npages)
  7192	{
  7193		unsigned int i, count, unit;
  7194	
  7195		unit = preempt_model_preemptible() ? npages : PAGE_CONTIG_NR;
  7196	
  7197		for (i = 0; i < npages; ) {
  7198			count = min(unit, npages - i);
> 7199			clear_user_highpages(nth_page(page, i),
  7200					     addr + i * PAGE_SIZE, count);
  7201			i += count;
  7202			cond_resched();
  7203		}
  7204	}
  7205	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

