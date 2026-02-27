Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F8C104891E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 22:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0C86B00B0; Fri, 27 Feb 2026 17:56:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E486B00B1; Fri, 27 Feb 2026 17:56:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40576B00B3; Fri, 27 Feb 2026 17:56:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C14826B00B0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 749B68C872
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:56:32 +0000 (UTC)
X-FDA: 84491747424.17.3352944
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id 39B531C0002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:56:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TcMq55DD;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772232990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ek0Mzv1UK8N335lH2nTWNZGMwjB+aFaxAFp5rFNMzKA=;
	b=3e4YBknitvWx0rd0yWkwew8LNNtg4qKc5jg0FQH8r0f/hQXfFJf3h1CsqhxRvObAWdDPMb
	qDViJTDn0xdMowt/ZdKaEvwW4kzBufFO4YFYv8tpllFx1pM2ABtxxwqHjNhS6GGRFuYbx6
	+sYWE8JJQtTXlrfz56ROmw5NStWy7BQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772232990; a=rsa-sha256;
	cv=none;
	b=XtSGmVYRBLpbbfo5Ex/VtgOOBdSqSwENxrZ8dFhqm3ZT161qRVMbjWFxGtcMPd3v5H5b9Z
	jSnYNzUHWbyiN8vCD0VuYr1ezEElC543b7aI8mjEBDRegvmiAibcu6SAdsSnwzz7PcQZJp
	c5n1jT/1NXpX8nzQ4L8o54agl6XTeXk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TcMq55DD;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772232988; x=1803768988;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U0J17v32ksmWhx/78xpg+Nz3+Nk3kvxsdR51MuM0I70=;
  b=TcMq55DDh+cgOXREF3+p4qhe7sIlANRLPYgehrcXHEqDdzYXdYsvz0sG
   uJbtiukvFrEH4KayM480vsOBCuKotfRy3PACv+z9T8nx8VPzriPELNEMg
   i+Px5o9Yy9kQ2pjE2OgMZWFy3c7vzwuspgKX95UzSwGSZJ/+e6+Nn5tKM
   3nzm3Yyg13bRJn7P1JplcH6UrqSqgBMr9KtXnM2woFXH/FPKPY798VTLJ
   ojJXzCCzxHBo1/VKTebicIkhVTy3p/c1o7rq62+51A2TM45j7BK8vU91t
   LW1aEBCuQW3s5kvBkn2HgHLIpL0ve8+FgfIyi9fvf7igAPcLGzacniGwH
   Q==;
X-CSE-ConnectionGUID: og23EqtYSaqum6XScqwjhA==
X-CSE-MsgGUID: cGeJQ3M0QUKGGNtaepiTvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11714"; a="77190601"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="77190601"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 14:56:26 -0800
X-CSE-ConnectionGUID: Gj8OruRNS5+rloaJ2M5xNw==
X-CSE-MsgGUID: ehdBotFtTHOu+IA4PxmIIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="221172735"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 27 Feb 2026 14:56:19 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vw6kp-00000000B8V-2dsg;
	Fri, 27 Feb 2026 22:56:15 +0000
Date: Sat, 28 Feb 2026 06:56:15 +0800
From: kernel test robot <lkp@intel.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [PATCH v6 23/30] arm64: kpkeys: Ensure the linear map can be
 modified
Message-ID: <202602280610.KQRFmbR3-lkp@intel.com>
References: <20260227175518.3728055-24-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227175518.3728055-24-kevin.brodsky@arm.com>
X-Stat-Signature: 3kiswh8uwjwhkqpkf1xfeo6fwcb4fje1
X-Rspam-User: 
X-Rspamd-Queue-Id: 39B531C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772232987-436495
X-HE-Meta: U2FsdGVkX19f6SYu0BUqFAdnIJhCTDzStRHVAhc97K6muvRWVFQPv9E9LAHmShL1+SxfWW4zvsFgKgqMgczgQqbtNxUp+wBBcVqMzOgRsME81wSQsqzOOFj4eMjS3tsPYCjvqDCYiwPFOHTmLnz/b2d2fNU2u9SiXs93j7BXLleLSWOZ9WDwHhw1LyfS3z2TmRoBljlnRUbylE5S7HkTz8doCJ7SqSLAaZ5nDRRLT1MMZJ4QS3yFAhfnruEZisQgsZJYhgbo94Xd6BvaE6lBQM3mVUt415womH7menmFdcT51q2/FE7dXCO11kyHw8NmTI8f8hcr1uEGHe03lERdIJzPnG8YyQdTbxfcYBq432WYAAvTc3joILPPwSK/uOnGLOBplT5S+8DD8U076HuXvpWkbeoI2wmsgzdHHqZwhglgs2ezYLAawT0iEE2lyvdknKNea5Y8Cq34G5fZIwZhpe25EsZRTTo5p0BzX4tAnPhopcrcRgwisI9TGzom5D5X/WcGdE05U59rZmVJQGguJwLTFDOjwvip+riaYqpsYLXUjS02tGDCE3pyfstoKE8AvT25BiQTsl2XOJT3dxWlbbMKq0BmJA34rFulHJNzc7g/KPiHLvimofyj0EsepVtb+0VPsTjv99E3tLgMF3Y0EIgPbXl4TnWyWSVo1Z+GXIE7sFpYZm5Oo/Dazr0qWIdbfLyEqbe9MfzJiOnPkK5+o1z8zQ02hTKI1E/TVJIdnhbQKyC4AMy4nMk5BvLIcwSQxClaJ/0LYDNEv/PgfLl4RKy/nFqccph77zIoGnW9kC3V5cdZb0sAdy8wc90/uDg6OQ8RJcLEj65bn1zyHQLi17Rte+GfZRnzvRKWLBL3J1rRdam/yBRMLRkg2Ucl8kC2CbPOiwB/SL+RXMlhsyFTWghzMRcd7/v3FW628HJWS7Z2z2FQV7R+D160gI6HuRhYYM/S5OlOZo6TCKfTQRO
 hsAFcnqs
 2ZqYQ2hL8XgEg1g8FbgYQNQVqDHu7i4qH4rzFpldnr1Wz3dL42IzauYOuUIbJ+UI9BOL6TvbH0HNwMkweaFSH4H4uo/vGOK2zXcgKSLb+dzIrgrz1WYumqrIhyPDMYjyCaEYWEJqIdannfsaqz4Gg5RvSs6g+HXkL/cK+uiMnJcfUg7ZhKjfihDIDTFKhany0f0w7mqBFEeUycRkcDowAXNuVk17PTqRuSOq9mZEVerHTgEuqKvuuE2uRKbC3VcNzq3T88XSiUKAy2dQ0QDqaxF+ax64oVl8w5IE2dyX0D4vwQ+U0OaN0R/H64Ws6wzhv0p0tMCNDR1mPx6aPQNto00dMcbHT72j89/aMwxD+XDBgWvvWyzEbWogBqcxnrwNa19ik06gQHofLQWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f]

url:    https://github.com/intel-lab-lkp/linux/commits/Kevin-Brodsky/mm-Introduce-kpkeys/20260228-020115
base:   6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
patch link:    https://lore.kernel.org/r/20260227175518.3728055-24-kevin.brodsky%40arm.com
patch subject: [PATCH v6 23/30] arm64: kpkeys: Ensure the linear map can be modified
config: arm64-randconfig-001-20260228 (https://download.01.org/0day-ci/archive/20260228/202602280610.KQRFmbR3-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9a109fbb6e184ec9bcce10615949f598f4c974a9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260228/202602280610.KQRFmbR3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602280610.KQRFmbR3-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/arm64/mm/pageattr.c:100:3: error: call to undeclared function 'arm64_supports_kpkeys_hardened_pgtables'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     100 |                 arm64_supports_kpkeys_hardened_pgtables();
         |                 ^
   1 error generated.
--
>> arch/arm64/mm/mmu.c:768:3: error: call to undeclared function 'arm64_supports_kpkeys_hardened_pgtables'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     768 |                 arm64_supports_kpkeys_hardened_pgtables();
         |                 ^
   1 error generated.


vim +/arm64_supports_kpkeys_hardened_pgtables +100 arch/arm64/mm/pageattr.c

    86	
    87	bool can_set_direct_map(void)
    88	{
    89		/*
    90		 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
    91		 * map to be mapped at page granularity, so that it is possible to
    92		 * protect/unprotect single pages.
    93		 *
    94		 * KFENCE pool requires page-granular mapping if initialized late.
    95		 *
    96		 * Realms need to make pages shared/protected at page granularity.
    97		 */
    98		return rodata_full || debug_pagealloc_enabled() ||
    99			arm64_kfence_can_set_direct_map() || is_realm_world() ||
 > 100			arm64_supports_kpkeys_hardened_pgtables();
   101	}
   102	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

