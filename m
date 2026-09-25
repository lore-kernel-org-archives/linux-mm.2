Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA00C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 15:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E296B0088; Fri, 25 Sep 2026 11:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60FEF6B008A; Fri, 25 Sep 2026 11:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525596B008C; Fri, 25 Sep 2026 11:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 298856B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:39:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5C031A0689
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:39:55 +0000 (UTC)
X-FDA: 85252695150.13.EB5772C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0835B160010
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:39:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KN2seP5R;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790350793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pxm23xclC5KMWoXPZAitwvPxXCJfaf1VEiluJKMPmSk=;
	b=5wDDq6E90fcnrUCMnAwzo75ioYhzmC8wkErag9gMHlF4g9CIHh8z/ZLRENhxOnq1XcjLjm
	S3Upw8YnHKe3jG+6gzNejfnD4uFEBIlfweRBrgHXKlHw4G4m4szYUttHdi20FslLoqUGqm
	hDE/4iGCO322Ce99FkoTOiTuXGci0o0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KN2seP5R;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790350793;
	b=R45go6bfKOURUc6RseVcazDv1DYocKMFIxvhdywjRH7LstUhTqZDAaJMkLm8aAsyI2hkUE
	srcmLySkbZWq8uQcAqhmjbambPIhCt+aDufvWEFpIqnBVdPdXrDxFBUD6JvnNzPWwbRtnt
	CWYzGFlOJ6raD9Fch/dY7z3RWNJt1l4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790350793; x=1821886793;
  h=date:from:to:cc:subject:message-id;
  bh=oyfZc8QGmpTxZC9TZKNxXJleoBm39tCdAH6Z0Cndv6o=;
  b=KN2seP5RK9lqz9JxzzM1U1uZzaymN5xMKWZ1WE0PqcyHTpXVuak1zF6b
   wvoiHoRdITw0oh8I1ZU/lhwtTM3mlrBsMH851SWHb7bDxjFxZPA8tLT1S
   ZvZHamQ8UcwUPBqBUpToteiVVWBj+eSPr2dkwM9eXO27DB/jRWaHOVa1s
   htReUsVdYc953Gp/mdFjA3Czd1RZEIUQtYArZtE6jvyIzDrXWovj3Vz0O
   Fc1xhRvsDLzeN+KHHLtZ8iNnzr/xeigWeZZxKK2bUsthg1xhB/bmyhEMr
   97yPxWuwK17nPHSqzhSLARiwCnog8UFzhxvyG8MUArNAGQ2HRGv9IBZq/
   g==;
X-CSE-ConnectionGUID: ZINYjIusROOkEDdSEJCXqw==
X-CSE-MsgGUID: +ahknViKQ5K6A+jjYEUNKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="91155506"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="91155506"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 08:39:51 -0700
X-CSE-ConnectionGUID: ANmwTY+XTY2H3VDKycWS4A==
X-CSE-MsgGUID: eBDYurDMTGy3tEFYi9ORxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="277728605"
Received: from igk-lkp-server01.igk.intel.com (HELO a88263cc608e) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 25 Sep 2026 08:39:49 -0700
Received: from kbuild by a88263cc608e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xA81a-000000000ni-47ya;
	Fri, 25 Sep 2026 15:39:46 +0000
Date: Fri, 25 Sep 2026 17:38:47 +0200
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: [akpm-mm:mm-new 661/676] ld.lld: error: undefined symbol:
 __check_safe_pte_update
Message-ID: <202609251702.X00bYqkV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0835B160010
X-Stat-Signature: fntj9fw469t5h3sbttgj9zdfz98fer1i
X-Rspam-User: 
X-HE-Tag: 1790350792-867920
X-HE-Meta: U2FsdGVkX19RAK8tkznuqotNO09FCJoLfC4qDQkySXnzlYt3WDnwsPIXD9MUPB0OaHq2cQrQjBSRCLdfUHyerERBRSd2tNa0lvsyYfIDYA2IAkAXOJ2KfnMLRCG7UtA1Atn6vH353PoBGse8CjRzlTdKrphdx/tvOckN4nQWLb2hm8SICCmYh94WnKbOTMb7YRjjoDendLB2hp4VD53UH7XdecPpkml3HV8gzeuGeZl6JCbP/6BDtmlDWWdoC7TDbuEVJIdDTzZN6Tsz5w2zv1uNqw2yeC7pJRfnK0Ho6K6qRWB0aQH/R7tqzWyOdX+y78HbXkZbW83yUMjuOHOGDbVn/mBZJvpjbeI0OAc4KpVeXzdZuy7jQoc40adxTMd4aZaDqBe4DRCRZZtX9L0wpccEK7bmDJw09l8t5BUesAcU6zo02ez1SkL1M+o5c0zQe0MRIAPp82FimML1w0ujZLeipMLEVL42xu/waAAfDlrmh6CgthYbCi5P2ILfHsqUq6r6uv5NhLmO/GfT2aZlPLgo4sSfzhYlQ2LPt9W3GkBMQqESxj1uEwbawB8NxF+qzVyk7ca13ak4+uz4lU9hLroYMt+CuI/WQ6dE1w+BxaOTp3YAMCE73HLQxcRBB5vZwc6jlSj2cI6hN6ynOVvBZZlExuOKSy6HuvWJa/iov1GJgvef0Nwoi0KBSBKCsyl3zbO/HPpw62qVj2F3qpbXs4spFQvAyLAHfnohw30eiQmCP31hdDXklEXmSfi2YlKjpS9lxpv4R0WWOc5IF++VvNYiuQ2LgQxYLi8hqeKXA+TUUmg0+9yYyIenO0LZ2Ow+GqbbgfFZFnz+SvYRWd22kaLZviWvKRNpga+YfZF+irluWjHZ/ZNArgn2+7OzZSj/jQ4RwJ42inVbCvblVeyrw639bB0/vjC9ZTZgAW0u8ElTlyQSy8GmqFdoWx3ffhpLZecJwAeTv96IzFrqB91
 75+o4akh
 Nu9PN9+3kWPsYlvYZyuFj+BZvEbcoTHHrrt5opiSHAd6OhmUL2sforP4sgOkrSh2SKIqWmVnD7bTFtGRKGqk9M94DOAwIx4OeVNSCusMSeQTQB1QcoPrRzVI6S33UARrEYGPSAMU26h6WbbMmp3EvtFdc3pRd07LHjkvOz55N66mGZqGrowCiIoNKo2uEKN5c6gy72bHHph/WEWqaRPHHLMBlS07RJnbpACWqnAGhg43BZcgmEe+XvDsdUqzRDFQgiIpXNBInVmXJymTqdFU5YyqnthEfgCZ+yxX0rtVMrHe1UkDTy2oyEucuzYiSUp06pH2f/7/DumB7wvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   2589c5593c200e5146db848730baa1d7dd0c9f4e
commit: f0284d9baaf7144fa87bc9ef9f3c64ccfd9600e1 [661/676] arm64/mm: move __check_safe_pte_update()
config: arm64-randconfig-r2200-20260925 (https://download.01.org/0day-ci/archive/20260925/202609251702.X00bYqkV-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 7e4b8ae111298941e0c31052a7124ab36f5365b5)
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260925/202609251702.X00bYqkV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609251702.X00bYqkV-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __check_safe_pte_update
   >>> referenced by pgtable.h:659 (arch/arm64/include/asm/pgtable.h:659)
   >>>               arch/arm64/mm/mmu.o:(modify_prot_commit_ptes) in archive vmlinux.a
   >>> referenced by pgtable.h:659 (arch/arm64/include/asm/pgtable.h:659)
   >>>               arch/arm64/mm/mmu.o:(modify_prot_commit_ptes) in archive vmlinux.a
   >>> referenced by pgtable.h:659 (arch/arm64/include/asm/pgtable.h:659)
   >>>               kernel/bpf/arena.o:(apply_range_set_cb) in archive vmlinux.a
   >>> referenced 57 more times

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

