Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A53FCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA52D8E0018; Mon, 10 Nov 2025 12:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55AA8E0003; Mon, 10 Nov 2025 12:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44F18E0018; Mon, 10 Nov 2025 12:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96C7D8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:48:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CBF4140234
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:48:25 +0000 (UTC)
X-FDA: 84095431770.13.85BA45F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf01.hostedemail.com (Postfix) with ESMTP id 308A54000E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:48:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CwqKDNoZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762796903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wa7cCapGoiEarkJtZSzzNltAt8pz7Y3ed3r1weKUrZ4=;
	b=TKWopZd8xjPPoDZXQz9KHMzCLup0sRNmDSSzFbkq8e3RZUqQZOL1YW45mT7fAVGmclf49T
	RQyPgAiw8ZYPbnNUul9Cl70QWr6w62UvDoPcknvAGdzaxWphstg5tFwQm4jB/xeuJ83dBI
	T34IwoB1nRVU9GeUgapbW8xAwvOj61g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762796903; a=rsa-sha256;
	cv=none;
	b=FyHlDdGTuyI24A+9fwtaZXv2r5fhtRFTIiuTExRKSz4vQn+Bn3g1h/vm/qWqW08TKF7BNj
	6dZ+/qa94BjxdQHwYlf196/MvBFH8veFFDY3c52So/+ja1rTvr85b5OKGH3s7DsweaAYGI
	tyVX/JsDGyijj6uXnrLU2wz0dODKj8M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CwqKDNoZ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762796902; x=1794332902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PBhGYG1Welq8HIr6/Eg4O9bQLBhw9HZVRcUiW+PyXlo=;
  b=CwqKDNoZYpRDAxX4MZCInIVitlXvS+QiLbmNsvhzUJKU5l9GF4FVM7ZQ
   00m2sTX/mbgBp7s/KR8uefA9lices9539fFhc3SK+WJhiLgQD9tjPGS+6
   0zgq7gAML3uMzQ1g7bQNTL9i0gwYznFfp0IQyyrBaVhC1oO8MxLRljrMw
   KCLUog20zigzHPLZ/mWTqKOseB0Ll0eYwLBo09uQgpSACdsIADhBTTn/K
   o50Gza+Cz7pvEeXEIjbKQRtIPfOmBIW3cYggMjJTfUp/T2hFyRaH7Xb/O
   Uq1/Ibvkdd8u5M35irTeW4xQmayaDddlwOpGbSWmS0S21LNe1XLrKOSQt
   Q==;
X-CSE-ConnectionGUID: Y70BTmfIT6iyvwe4/R+RCQ==
X-CSE-MsgGUID: SMnfSJ6WT3qAsKMH3kTKOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="82479612"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="82479612"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 09:48:21 -0800
X-CSE-ConnectionGUID: j6X54M9WSKCVMnW4BeP3NA==
X-CSE-MsgGUID: 7Fg9QX7KRO2x1QPQxx978g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="193113288"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 10 Nov 2025 09:48:18 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIVzz-0000mZ-0L;
	Mon, 10 Nov 2025 17:48:15 +0000
Date: Tue, 11 Nov 2025 01:47:19 +0800
From: kernel test robot <lkp@intel.com>
To: Alejandro Colomar <alx@kernel.org>, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alejandro Colomar <alx@kernel.org>, Marco Elver <elver@google.com>,
	Kees Cook <kees@kernel.org>,
	Christopher Bazley <chris.bazley.wg14@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Michal Hocko <mhocko@suse.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v1 2/3] mm: Fix benign off-by-one bugs
Message-ID: <202511110100.9uPtQqN1-lkp@intel.com>
References: <87445e701574058b142e036c3b8a0f505086ab64.1758806023.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87445e701574058b142e036c3b8a0f505086ab64.1758806023.git.alx@kernel.org>
X-Stat-Signature: cbgp6widm3sg6yodesxxe5uekjm9jt4q
X-Rspam-User: 
X-Rspamd-Queue-Id: 308A54000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1762796901-954755
X-HE-Meta: U2FsdGVkX1/qOTPZQP5rumwb45M1FEfnVD9Pa6oujNqc+OTAFswqkFtkVHPHIn1vq08hqoJne0mx6+PZHZqeIBd9qm87GdPCLh6S3glMBDtjXftLrW+xNDk/2jz6eXiVNsIFyHytWZnmag5nwYWFlAzk8z0eq0qFGpyrRr3HqWHG3LQttEbpcwjbHhnFUBRZFO0pmvictFU/FovtCVP+tFaxu92BeJxA3rwAC5cPGO2nzmo5sZHtQpUr8BYVHKq4yrzLLnPxlZldBONoWPE6d+D9BPajMeVMiZbpBnwl0kgFRlXCk01AyHDK52pQLaw8I9zsrPTm1HvgM5C3MgjoqrFLZPuEb13VY1qTeJ6WJQAPaNg1o+NxLKumIBT+ODnjoUdzUKTy2iwkRD/AM6EA0u3JMcAT++JYP4QDGCjZNgXGq9c3sACzekF0IZ1pxnTcTkg3ho4XIS9mP/ZFhTK9hG8S83MV3cvgGD9zdaaQY54hqoRPAlk1YjCAXEVqvZrCMaHVf/4KZfTFMDj265qARyjsEIm/udxfWMTTeM5YHZsgYvnwwlIx8dIMy7q/9BDJB1FYoOS4wnfIV74T9yeBzPMyB+pBnNp3cVvy9JS+hbXcoVGv18B+FF5ebVdDYM/kd/lUTk1ONTcjGarOTxOW7p22LHhyAsZSODkTlAyZS43VCn/+qifViKBH64DCDtbYcSKZdtuEgxfu7nHgwJLG9P/Cqaq28vhteIXkRwO2E1P5A72ziYIYSZQcm5pXkdJ2FPrYy6OPw2HgfNwSzv8o+W4rAaCuWHjtX0MyCmm/kwWl6/OaBeyaAgEM81irJoFmkla/G1XhTCZ0J9UpB+cIxYyPqV9Tm1OB8A/9yhUrCrL73KOB/ebxs97V9hk8OExRfjKXwS8zQr0meWEBmldh1OZqgZ5gMwo37dp+/l2JKNG+Q5gixL8gh7hFacACzGXfFlvlmSioeJaI8kLYSeg
 i+p10lOa
 CwbXkf1/Cc4ROYg6FDflQWCB36n6JRPvwaRJc1xQXQuQ0+2SHIgy5vA3zXM48j6d8IEprdxLqg7ebvp5BDJKW/i2AMWgHep09rHY3MWFw7dvfVZIuJBeHRqfm2dcDAvxb/8+L0YWTWwwaZXQzNaNu1hTY4ltHHJj0jkZFDPpqphzNJvnKUICYj/u0XG2NPV4NBtIN6muWz9QzPY1AKeUVIuIpeLQWxFuCkIqwAnepjXkObnXHxbqsddKC1YIzczTFsF0vKcC4i1QMYbrkYm8FiOMCootMOj+lfDHBR9dMibJAZJlIFIpTelDsx2VCtQH0x/IjJGwBy6qM217Oij/thUYY8J2zdAZJHriwhIBWaohF5TWI3TVeeGhZbKvfEOZDbEFCqhBYDYLgG1RBUDE3weWtjKslDJ4lzq3X7SoX+iEJ6Jc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alejandro,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on kees/for-next/pstore kees/for-next/kspp linus/master linux/master v6.18-rc5 next-20251110]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alejandro-Colomar/array_size-h-Add-ARRAY_END/20251110-075203
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/87445e701574058b142e036c3b8a0f505086ab64.1758806023.git.alx%40kernel.org
patch subject: [PATCH v1 2/3] mm: Fix benign off-by-one bugs
config: loongarch-randconfig-001-20251110 (https://download.01.org/0day-ci/archive/20251111/202511110100.9uPtQqN1-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 996639d6ebb86ff15a8c99b67f1c2e2117636ae7)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251111/202511110100.9uPtQqN1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511110100.9uPtQqN1-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/kfence/kfence_test.c:113:8: error: call to undeclared function 'ENDOF'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     113 |         end = ENDOF(expect[0]);
         |               ^
>> mm/kfence/kfence_test.c:113:6: error: incompatible integer to pointer conversion assigning to 'const char *' from 'int' [-Wint-conversion]
     113 |         end = ENDOF(expect[0]);
         |             ^ ~~~~~~~~~~~~~~~~
   mm/kfence/kfence_test.c:143:6: error: incompatible integer to pointer conversion assigning to 'const char *' from 'int' [-Wint-conversion]
     143 |         end = ENDOF(expect[1]);
         |             ^ ~~~~~~~~~~~~~~~~
   3 errors generated.


vim +/ENDOF +113 mm/kfence/kfence_test.c

    94	
    95	/* Check observed report matches information in @r. */
    96	static bool report_matches(const struct expect_report *r)
    97	{
    98		unsigned long addr = (unsigned long)r->addr;
    99		bool ret = false;
   100		unsigned long flags;
   101		typeof(observed.lines) expect;
   102		const char *end;
   103		char *cur;
   104	
   105		/* Doubled-checked locking. */
   106		if (!report_available())
   107			return false;
   108	
   109		/* Generate expected report contents. */
   110	
   111		/* Title */
   112		cur = expect[0];
 > 113		end = ENDOF(expect[0]);
   114		switch (r->type) {
   115		case KFENCE_ERROR_OOB:
   116			cur += scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
   117					 get_access_type(r));
   118			break;
   119		case KFENCE_ERROR_UAF:
   120			cur += scnprintf(cur, end - cur, "BUG: KFENCE: use-after-free %s",
   121					 get_access_type(r));
   122			break;
   123		case KFENCE_ERROR_CORRUPTION:
   124			cur += scnprintf(cur, end - cur, "BUG: KFENCE: memory corruption");
   125			break;
   126		case KFENCE_ERROR_INVALID:
   127			cur += scnprintf(cur, end - cur, "BUG: KFENCE: invalid %s",
   128					 get_access_type(r));
   129			break;
   130		case KFENCE_ERROR_INVALID_FREE:
   131			cur += scnprintf(cur, end - cur, "BUG: KFENCE: invalid free");
   132			break;
   133		}
   134	
   135		scnprintf(cur, end - cur, " in %pS", r->fn);
   136		/* The exact offset won't match, remove it; also strip module name. */
   137		cur = strchr(expect[0], '+');
   138		if (cur)
   139			*cur = '\0';
   140	
   141		/* Access information */
   142		cur = expect[1];
   143		end = ENDOF(expect[1]);
   144	
   145		switch (r->type) {
   146		case KFENCE_ERROR_OOB:
   147			cur += scnprintf(cur, end - cur, "Out-of-bounds %s at", get_access_type(r));
   148			addr = arch_kfence_test_address(addr);
   149			break;
   150		case KFENCE_ERROR_UAF:
   151			cur += scnprintf(cur, end - cur, "Use-after-free %s at", get_access_type(r));
   152			addr = arch_kfence_test_address(addr);
   153			break;
   154		case KFENCE_ERROR_CORRUPTION:
   155			cur += scnprintf(cur, end - cur, "Corrupted memory at");
   156			break;
   157		case KFENCE_ERROR_INVALID:
   158			cur += scnprintf(cur, end - cur, "Invalid %s at", get_access_type(r));
   159			addr = arch_kfence_test_address(addr);
   160			break;
   161		case KFENCE_ERROR_INVALID_FREE:
   162			cur += scnprintf(cur, end - cur, "Invalid free of");
   163			break;
   164		}
   165	
   166		cur += scnprintf(cur, end - cur, " 0x%p", (void *)addr);
   167	
   168		spin_lock_irqsave(&observed.lock, flags);
   169		if (!report_available())
   170			goto out; /* A new report is being captured. */
   171	
   172		/* Finally match expected output to what we actually observed. */
   173		ret = strstr(observed.lines[0], expect[0]) && strstr(observed.lines[1], expect[1]);
   174	out:
   175		spin_unlock_irqrestore(&observed.lock, flags);
   176		return ret;
   177	}
   178	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

