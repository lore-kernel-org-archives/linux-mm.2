Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6645BCEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0CB58E0010; Mon, 17 Nov 2025 09:30:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4768E0002; Mon, 17 Nov 2025 09:30:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B217A8E0010; Mon, 17 Nov 2025 09:30:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A104E8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:30:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F86D12CBDE
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:30:13 +0000 (UTC)
X-FDA: 84120333906.06.D6FFC07
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf18.hostedemail.com (Postfix) with ESMTP id 556F91C0004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:30:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ErkA6k3V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763389811; a=rsa-sha256;
	cv=none;
	b=NUwlDRgTbYlhSOwrounns5c6vizdmrcaOWJvaPqAZoc2dm3tV9FK3dMYcbHlhs34v7Nbc8
	GcjmU/nfLLoizEKfh6GrBBiB5ZBk4v5f3iarFvBCwy98MtDPp8jwJokKX9AE1W1NFZh9Kj
	+/f3u1xyOUHCQikhmCS3EHLCR1e8sto=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ErkA6k3V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763389811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JAmH+HL260u2ljM5Xf3dHjRVbhX/X88RtVnRsLk5IIk=;
	b=YDYerd3c7VcpWjWiLcgYvzIP8dmkgsHGiuwMmduH1hZqQuDtewysRh383UzG+qvt7PtW7P
	00RE1YCxZ6gVR7be88P52hNNrOFNze+9VUnRp+9+PSEWFw3vSLWNAe+FE028XDMz3agAiR
	PIpSj1QDdseRE6u7RJg8bSo7ycqA3z8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763389810; x=1794925810;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=PTbbaJoSZw2Ty/iJGv67pSMKbEpK04mxLQb2w4oEG3c=;
  b=ErkA6k3VTwujepUlrPAXBLIw7EjVXQytmSu+nY+IYVnro/a6d9WoNAYQ
   agK6iLpheLQRoNzvHuA0i8kpzdsKZEjJO8IEJzBRSpmH3stc4i47fgRwa
   EOW1cpeDdW6B/mpjl8/3RIdubzXKLuBlyG//doPuISRQhgVXGrPkGaNll
   2+5roMzTqMg0N3YUKtuW37GyWHyrYUF0kE/APhxzffonaGoVrt23q20eJ
   G0JHSqHxYCuLTK9Vufdi52tcWTyXXkeZdYPFZ23iqmnNxMkIa7HHgofmz
   nzfeC3mEYZrLUaaQsmEss22VEOzQAsgwUOjyYrB2x/kr06QhyeZYCpa8d
   Q==;
X-CSE-ConnectionGUID: dtzVHsrgSjStZyYMvmO6pw==
X-CSE-MsgGUID: lhlxTN1aRJmBgH2ZnN0zPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="90866824"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="90866824"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 06:30:09 -0800
X-CSE-ConnectionGUID: sWs9Nb5rRjKt3GCAR+eukQ==
X-CSE-MsgGUID: 20lk6izOTvur9YCCf4rLmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="195404100"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 17 Nov 2025 06:30:08 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vL0F3-0000fL-2b;
	Mon, 17 Nov 2025 14:30:05 +0000
Date: Mon, 17 Nov 2025 22:29:37 +0800
From: kernel test robot <lkp@intel.com>
To: SeongJae Park <sj@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 8868/9360] arch/m68k/include/asm/page.h:20:27:
 error: lvalue required as unary '&' operand
Message-ID: <202511172257.CjElDcRX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 556F91C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: n1xfgaa94mrya7kigpziwos6iytzyf64
X-Rspam-User: 
X-HE-Tag: 1763389810-908224
X-HE-Meta: U2FsdGVkX1+ZN48BzPMnBY+k15ijsxzKSwUBCrlPdH4Qck12pCsjnSfXaU1wwwichIG1YrBbao478CRJEH3nJvgkwOl6vIRtUJ+htSDaNFw9+/0FF/snqwhjT9zs0kB0zq/P3zcMR7gL+gjiB8KeNkAodVq5WrcbXKNUhBFVmleIZ1J2uWW3Xt7WBpb1R3j78wHCUOnuqtpSZJjke5i+XwHrdFqE9EZgB71ox1fGYAkva3O//cbyZhvz4LRAe277aztf/aXphR8rl8QCWvcOD5lHLoyEhnxnoH7kyczELLVNrhfzc43IDMsnWmkA5GSfUY8oVBMJWDAeBXTyg5BVK0kGJqsZvicGiHU6gE2vAzTdP3OTQlGGNyh7Qo0+8gGOFxfs6Z92jbeONaniwGlLk3ZgPsv3wrAPbMD2p4hP9JIqCUdGmYRm7nNEt7uLJGi9mI5PUUPR3ApFoDXRuPttq6m6NiCYImyCMco/M9dCHqoVQUAKaY50XKbNgHbNy9e12lMcA1I4IT5CLjF1SwhqWJnIoLblKg6n0yerqh2ehaOA32HkDIni+jTFQctSYI0nQXF++xcrrL8bb33rdpXkSUMSvb0AaBk7kAxx/RUXh1CqwKJmsPJEwL+lvz0vkzntXIm7jLAXG/6/7HX8xS05Qgy6osf9PKCmBQ/vUpbS06AE8AfKVFOh8M1TvHrtEW8EdRs706pVF6OmNzSvGZUgwksJWqyoaW0WWrKxpB5SyQBtGvNPUEU6/3Iz5JeQNKlpd/Ni+eA72ASDduvo3cNS8kwBip+zfAEKi8fi9AiS9/ehcKu4bpjapIRqo7E8f9J+CBUKRmf57c2nlYs31eqGywh/F5yQJJ+pGlk09U3Dw3MbPyTm9OvyxYUt8sKzWSCR3fRZL2Reoudlwi1264NaZMC9GhbdY1/QAjOwfqYmw0Bwc488MeLqyf5xctmz0rI7uSsVjT9oxl/gOTW1oW+
 HmFNJMEu
 r3PhBYlngqFvv7r7jXbRqZCbwszpblFpI7o59JkYbDBeuG0MC2QxRc6A9/Ukr9+/p9GGxIXwBkt4wso6voXSUc45GGxXtrQVv6QZ7+Hg1Jg1DnS2jD55NuysWlc/48mN/lGPxgKhaZyUKaF4SFlFHDfhTUFfqCeS3IsOPS94gqpK3oBp8nlnlKcUJ80zyYvSK/qq7NNgiuqbtB3yggMiGZwSAey7IcgwLKzcygakQh4rHKi6dYFN3m9XD6OZscI3W3iljlUSo7Js/LmEvoXAjVyIQjUB9iNni/FPnRXJUjzDWRDd9uSQiwUyw1zRYI9pb+vh/KoAUC4DjXXAuN1RkOI7z6BZdaNXSwu+JqZ0XBDZnzRrD8jcrIxhR6l6PlyZJz75CPT/SrC6cO2yubmmKa1I2ZA6pz1wdrnxvXcr0cAl4XZhJTlucbSTGHcebbKu0S2rx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   0c1c7a6a83feaf2cf182c52983ffe330ffb50280
commit: f54f0efb9d91fa2eee95a7eb29d0051f2176df47 [8868/9360] mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20251117/202511172257.CjElDcRX-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251117/202511172257.CjElDcRX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511172257.CjElDcRX-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/m68k/include/asm/thread_info.h:6,
                    from include/linux/thread_info.h:60,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/m68k/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/wait.h:9,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:7,
                    from include/linux/highmem.h:5,
                    from mm/damon/vaddr.c:10:
   mm/damon/vaddr.c: In function 'damon_mkold_pmd_entry':
>> arch/m68k/include/asm/page.h:20:27: error: lvalue required as unary '&' operand
      20 | #define pmd_val(x)      ((&x)->pmd)
         |                           ^
   arch/m68k/include/asm/motorola_pgtable.h:116:34: note: in expansion of macro 'pmd_val'
     116 | #define pmd_present(pmd)        (pmd_val(pmd) & _PAGE_TABLE)
         |                                  ^~~~~~~
   mm/damon/vaddr.c:314:21: note: in expansion of macro 'pmd_present'
     314 |                 if (pmd_present(pmdp_get(pmd)))
         |                     ^~~~~~~~~~~


vim +20 arch/m68k/include/asm/page.h

138ff3462f53a7 Greg Ungerer   2010-09-07  14  
138ff3462f53a7 Greg Ungerer   2010-09-07  15  /*
138ff3462f53a7 Greg Ungerer   2010-09-07  16   * These are used to make use of C type-checking..
138ff3462f53a7 Greg Ungerer   2010-09-07  17   */
60e50f34b13e9e Mike Rapoport  2019-12-04  18  #if !defined(CONFIG_MMU) || CONFIG_PGTABLE_LEVELS == 3
ef22d8abd876e8 Peter Zijlstra 2020-01-31  19  typedef struct { unsigned long pmd; } pmd_t;
ef22d8abd876e8 Peter Zijlstra 2020-01-31 @20  #define pmd_val(x)	((&x)->pmd)
ef22d8abd876e8 Peter Zijlstra 2020-01-31  21  #define __pmd(x)	((pmd_t) { (x) } )
60e50f34b13e9e Mike Rapoport  2019-12-04  22  #endif
60e50f34b13e9e Mike Rapoport  2019-12-04  23  

:::::: The code at line 20 was first introduced by commit
:::::: ef22d8abd876e805b604e8f655127de2beee2869 m68k: mm: Restructure Motorola MMU page-table layout

:::::: TO: Peter Zijlstra <peterz@infradead.org>
:::::: CC: Geert Uytterhoeven <geert@linux-m68k.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

