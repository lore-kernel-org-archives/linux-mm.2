Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44F32CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9067C6B0011; Tue,  2 Sep 2025 15:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE146B0012; Tue,  2 Sep 2025 15:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F49E6B0022; Tue,  2 Sep 2025 15:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A31C6B0011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:57:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D7C71A0379
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:57:53 +0000 (UTC)
X-FDA: 83845370826.29.341DE6A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf25.hostedemail.com (Postfix) with ESMTP id C79F9A0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:57:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="a+FWA+j/";
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fsu4mwSWGYv2jYPWWavuqjm6/2109SnUKZ+qkDn4qD4=;
	b=dGD84jsmltYyUxYS8igX07eO2ETYwQ8Zlmv1eVObYY7V4znCPtVjobVIfWUS55ogdVMDYk
	kH65/NXrmCPKA2GpQAvOBWxdHDZhWDmtUqxKOmHxbchsqSLcc56tK4ak/oREQdLq/c/Q9M
	k1Su3mMRRvuJagm0jew6N2bXFDC1164=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="a+FWA+j/";
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756843071; a=rsa-sha256;
	cv=none;
	b=WrgVqwCl6Xxs63/vN8bmF2SkEZHqHhiFJyqws1H21txzPksM4TWdzXVySQEcVmkonTkmjZ
	j/vrLLrGUEGFtErpHp9YMqc9LGJlEGxZaKKTjwSdz57qDdOyn47mzzRifZofAY4J9aJdYt
	6X0lhYoBu9LTnmvdexaCV7uTCiHtlO8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756843071; x=1788379071;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WG20E1PYl6zQTGosd4M112pEByXyuxZIRP6y1iHCS5I=;
  b=a+FWA+j/cWPStNlO6p61s0Bojqtt7zLzNOrXcFjIKuG3x2LAyO54i5Qh
   O0MO95VKPv6Zi+NDx1OR7hnnSVFjMCza5XXhRzPGq4hB+4hwDoYr0T3Zs
   A5wHVCRkjXdK1SesPpOYVrJdIXShTG6qlLeo4ar1IXCYMZpewMbB/6Rg+
   UI/1O1wTBsqfL+Uhh8GUXi/0cWew0UXnOx2d/+uC3+pW9qG4kvdMUgFkw
   ynVNQtFmwCZpJ3OR7cy706AvzKoqhRiWko2d83bUp/phPqoMAKANf+iP5
   M37RSk1UanpOugDtkXgvlIlKTiKLxC3bfWi0fcnKJkEL819pKoTGeOj/v
   Q==;
X-CSE-ConnectionGUID: iTaH3/vUSNCEkQzNrnq++Q==
X-CSE-MsgGUID: s9AGd8QDTw28ih++PGZeXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62967191"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62967191"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 12:57:50 -0700
X-CSE-ConnectionGUID: k62XfXQIQmuVDv1f8T8fmA==
X-CSE-MsgGUID: 4ImPeJBGRRiVYLHkJVP4Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="170647122"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 02 Sep 2025 12:57:45 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utX8Q-0002z7-08;
	Tue, 02 Sep 2025 19:57:42 +0000
Date: Wed, 3 Sep 2025 03:56:55 +0800
From: kernel test robot <lkp@intel.com>
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
	acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
	willy@infradead.org, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
	ankur.a.arora@oracle.com
Subject: Re: [PATCH v6 11/15] mm: define clear_pages(), clear_user_pages()
Message-ID: <202509030341.jBuh7Fma-lkp@intel.com>
References: <20250902080816.3715913-12-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902080816.3715913-12-ankur.a.arora@oracle.com>
X-Rspamd-Queue-Id: C79F9A0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ddarsgif4nsx5fpijawxaf1gm11s9ge8
X-HE-Tag: 1756843070-416602
X-HE-Meta: U2FsdGVkX1/Np9MqZBoTgEE+mN5rFhVytiIElgnZhBUCbfHp58fDvoUXSLsUenBBEwj+TpgR0XHxwxRJo+bLGX35aHxo0ChKLcUC7y9UZkIqWVvmXvCQhbML5Lg2qXWvHY6g0/uTsmXkCC0uYsCDa46v50HZ1m4n4jNFyyfem3TrdVfkpvHA25SnIximWEN97BOLlTCrJacvGc5aAVMLgWfjDc0TC+A5eKsl7wyAvFq4OCQ/7IIfDCbEyt+8dnL7a8IR0GkvrlG4i5JFY5j8y8IoaLG/8jXdbnhw8EBU+Y8/w2fH6VAKwVDKWVsEZ/OFtwSa6kEDbR0k2BBxSjo1BHco7OeNkksKu1W22FiVPfFpFcT9p5NnEnSV+TBSK7QVTmFMUUL8kKaq+vGpBOxiiBSJNa+JWKWtLqHv4Accc9m1uL+GWXzu8Ux8PK4bhxHO44IMJtGNY+l0OIV9Im7Yg4O6nDe3La93CQcHaEwL+VyidN+cS+wogeQypFvcTMxXuKy/H7RKBWt8fTT7noYqCKzdtUs7R17R6rocPJKFEXmvVFf+QzNFE/k/4FczyKy3rQj2qRO0CPjjTdna6Je6tQY0D4OR6tyMVsvzmJLrmFemPYx72POhcgbfnZ8XXYYLkPuBVod4D+rzyWv4Pnw3EmZ0w6bnKWKWz3y5mO3gxGIf3wWmsBWAXqyjvflizCidUxp/BeeH8v4+vHzIkdEKmfxDHh9u+Q6PSmxReQ+yvbN2TmIgcwUvzuLHAg1f5haP+PQRuJLgHNSHPRCDVepWJSdqdg6T9OhZKC1tXpqDdoHTlkpJg5E/6qLtON74A9/Wu/CBeW6SHiLfGVo7wO30nnR/wWR6RSmx/dB9MmwooBKO8n07xXUVPGnOjyxIh2Ucm8p9QSvDGWwxZ3STOm5pCGbSFWRzCk4P0ud4CTP13/JbC4chtVaralqx3C9Os+KWzLhpaLUHpnkFzTOmQC9
 gCLJvMTv
 IIjnNZuYPcKQI6nbkE/48e6Eq4NLRfTOqAwOb1chJhGFFVBaLiq+5ucDCjDEd5z3DdeuqjPenOQmlbKb9xteDbimHlbO56nWDfEIUL71jG7sxGjdHspRJQlWPSklRzpjs2JAfO20HrvVwhmTarCX3ohFH9NOrJqIZGZRRxK7Bc3qMtU/NtZi0K/l7YT1ybpaZ+VmYRvCFh3xpHcIJts10YC18ZKXlBqbLk51VHwPRfaL5OaSQ1KGIQjYT+kQa1pTi0apgoG3q5JH8kjc7ywbxfhjkMrL9WwZshVqCk6ojPCrfsUKrIrChlILTxATYj14QS0+P6FvDN6xrEoW6fGpQBq9O2Ax/AQYRyHIX3CynMVi5nH0KcL/AwpI8Sd5IwgOGjabTaPbdM99M5c4H+MjRmaMQGy4bCUF+MnKbcs4BTZg+rM56PhyNktPDBA==
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

url:    https://github.com/intel-lab-lkp/linux/commits/Ankur-Arora/perf-bench-mem-Remove-repetition-around-time-measurement/20250902-161417
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250902080816.3715913-12-ankur.a.arora%40oracle.com
patch subject: [PATCH v6 11/15] mm: define clear_pages(), clear_user_pages()
config: arm-randconfig-002-20250903 (https://download.01.org/0day-ci/archive/20250903/202509030341.jBuh7Fma-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509030341.jBuh7Fma-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509030341.jBuh7Fma-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm/kernel/asm-offsets.c:12:
>> include/linux/mm.h:3886:3: error: call to undeclared function 'clear_user_page'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   clear_user_page(addr + i * PAGE_SIZE,
                   ^
   include/linux/mm.h:3886:3: note: did you mean 'clear_user_pages'?
   include/linux/mm.h:3882:20: note: 'clear_user_pages' declared here
   static inline void clear_user_pages(void *addr, unsigned long vaddr,
                      ^
   1 error generated.
   make[3]: *** [scripts/Makefile.build:182: arch/arm/kernel/asm-offsets.s] Error 1 shuffle=1003087465
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1282: prepare0] Error 2 shuffle=1003087465
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2 shuffle=1003087465
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2 shuffle=1003087465
   make: Target 'prepare' not remade because of errors.


vim +/clear_user_page +3886 include/linux/mm.h

  3880	
  3881	#ifndef clear_user_pages
  3882	static inline void clear_user_pages(void *addr, unsigned long vaddr,
  3883					    struct page *pg, unsigned int npages)
  3884	{
  3885		for (int i = 0; i < npages; i++)
> 3886			clear_user_page(addr + i * PAGE_SIZE,
  3887					vaddr + i * PAGE_SIZE, pg + i);
  3888	}
  3889	#endif
  3890	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

