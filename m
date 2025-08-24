Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67878CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 20:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A716B00D6; Sun, 24 Aug 2025 16:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD926B00D7; Sun, 24 Aug 2025 16:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5416B00D8; Sun, 24 Aug 2025 16:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32C106B00D6
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 16:12:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87B1FC0219
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 20:12:10 +0000 (UTC)
X-FDA: 83812747620.22.9A53506
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf30.hostedemail.com (Postfix) with ESMTP id D462780004
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 20:12:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AICkh77v;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756066328; a=rsa-sha256;
	cv=none;
	b=T71E5EBMaWiing/NqMMNl5NcHDP4Puc70SUYfVL6QtgJ9C6bPiOM3JE1TI51KhlQlf/GjM
	k/5rMAwi6EqL035GulqJiCXUT9MxVhV7Wzsag27nmF9fPKIic6e4m7MDA2X6fLcylxyzsF
	Qi3nCwAdynPk/99rKr0f/8XRlArQOyE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AICkh77v;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756066328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mY6WpmS4PjK2eksVLRAQuQoiaOlqmgzFEif5Yw7K/8Y=;
	b=pMNWIA1tARScKKnOkyakUqDCV8HeeZVWNHvO4aK6iLIvZzRxqFc21belj0nlEmZ3cC4JWI
	RUz4gMiCwNfb5F/A+D8l2ptazpjBdYbenhk9PwuWZqksdL4d6TlYqdz7ESYJEe0eeLqwEv
	DJ2FKf7BQ7ybrd9s4Qg+ks3pjj4Btus=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756066328; x=1787602328;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=x2cEs+FNvIqGxHrowKJq1taUXUtWyGXfpqi6uwPM2Rw=;
  b=AICkh77v5RpVbtuxEaaOabtSNgQ+VbLNRxkdplZMZ0jmEW/QiuoEGb6d
   EMHSbtgE/7OJvNYchr6b2euE1lnjqH2U7RnDxJDtsgwSl5ecAfKv5LmAx
   Kv545k4aSud5bfB1iKih852YegIOwrlZYKOIKZajL6qB30oR623qBb3U5
   qLcJa3Uj+5qeCq5Ym+jzmHCMvGws6ltuvidODDfAvefYngnZ3+34JgxOH
   mNQQiNhj7rEO98QUXQYPyALC+VMQJvpH6Ib850ew1ogXwZXTtJvQZkTGc
   VNSlbfsHg10XYyn1JpZx/kwbtQAY51DFPJrtgmfeVhkWCJdLi3gFI2UA7
   w==;
X-CSE-ConnectionGUID: JNt7cPT/R0W9+8Ekdye4Rg==
X-CSE-MsgGUID: fBW8E97EQnyZJExRHm3rZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11532"; a="75879145"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="75879145"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 13:12:06 -0700
X-CSE-ConnectionGUID: YtpgVaGjT1WQ+5K8F5umEQ==
X-CSE-MsgGUID: h/Okl1s7QAKSbyjZbimjjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="173320280"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 24 Aug 2025 13:12:04 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uqH3m-000NCF-19;
	Sun, 24 Aug 2025 20:11:46 +0000
Date: Mon, 25 Aug 2025 04:10:03 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [akpm-mm:mm-unstable 102/221] include/linux/pgtable.h:2000:17:
 error: implicit declaration of function 'VM_WARN_ON_ONCE'; did you mean
 'WARN_ON_ONCE'?
Message-ID: <202508250425.yEOYgcC5-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D462780004
X-Stat-Signature: 4ot33g41aijjagp6iraaq8a4tgq6yzd7
X-HE-Tag: 1756066327-746995
X-HE-Meta: U2FsdGVkX1/vBO4yw4oWDLy6UZbzoh/KMlBN10tjHIGSjj7PAEqw55PuSIXONS/UomEVfvzK+RR70u2t0oSAfbzJ8KqlRMpP71lAGFwN4IKOJEueRB3bMeh5MPMHNTYlcE8ZQ/0OQQqflvJ+fFjUfwSJs5/ByQPmvnoIVxbqW7QqyAL4n9Ntet51qaMbsq7hvdYdro+5g3l8qu836MCEXGVyvMmeokdE47HH2Yk/7KLCXjsFufYD+MaNBU0CUtKbCwIZfS6qqpCoNgf1BkJ/NlmH5MjuxS9TtVjyLSaUtfpm2b3wjz6+JPhvc8jFyEXaYFZIaWpdBx8R0DYg3q2MgeaRkBt8o8n3XAXUEWlENo/ofI+1qYVCe+JWYdWFNcATqq9ft7dWXbJ9k4UcsAWGCFla7q03mCiZM3Z0mEHBbhyAZYpjYyZ0q34CuTUPzNcXCh+EouZ+FVvphjCWp/G7Mv7IjNfJNWGFKUSJyqRjU9WSj18q436yaQjmOfxPDnenZBiP0lPCjSl1TLqL7Mjao2az0Cg45Fr22bRGHIgF0V8l1axjK8aEBTol7uXwzCe4Gm8l+gBPahGTfa9cXWcnOn7syi5kuOgytLOxEwOFu6Mbj2NpmWQxVetfNpAyUUOQ9sEtGPgjFYc9NeHK6ZcreGFvie95h8YPqvgkyfiX35fDGBSY5XAA3cMUo6IFkwHZhobi7uTYR6gavNIv4qWJ9GDKDyebpXxjjZPggXDo9zJozIhQ6CkvErL3CWICYQzzaexR1X6XKzH1rSygmSL6HBTU6rBt/I3atvb7UtmXY60DD8GRk4c7ZB4U+WFsFWAaHB+U1ljJi3SXIW3dfWrRNNdH9gDhe6RGuAI3pH0XxOGLyecbrpEDYHQJL9i2eSdOLvsZ8yolv+jF3qSTqsQaP0AAHyUALOygeArVw8SLwMpOxo9xB4vSIpGlMellrSZ5vHWaC5vxCUXUyO8O8RQ
 kF0B42sP
 eveCQTHWAR1v5IwpJQLXNKCUeWROmqSNG9iuIsC0jwY+M9cHzcF+kD7ZB4oRjjAG8s66R5//1wAtuYY5RKxizv7PiQs6cN2UDwCUXI6wPdI9Bu5zI9q6tkU8nwq+FdqZlOwctwMnyRKlobPgmWSFWwxaWDjVvfloNtWPfeQkodtmupcDmsbdJiUPaNVACA4wYphGiOn0emjLYFSWM6+6hBBFVFOCmPa90vf+otTJBlqNqgpQ2gYnFrFwzIx/Q15u7J26V782JDNRDnHuQ4LUP7vr4W39JYVVG591W3A7BPguejZPT4PCy+tWnyLRt46IWrPPhKpc9v4CJWpgQjvbpf+DQNJ7F6qOKMQuHZyEPa20dSIxnTy60hPMO8mBd6cU1VSkbEkE8HRoLJp1960RBrWWafgSOenhMC5fx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   3c3393d4b766eebdc475ea5bd6bbd3a221e2526e
commit: d2e502b0fe1166f68c7ca5815e73ad12bf87e74d [102/221] mm/memory: convert print_bad_pte() to print_bad_page_map()
config: xtensa-nommu_kc705_defconfig (https://download.01.org/0day-ci/archive/20250825/202508250425.yEOYgcC5-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250825/202508250425.yEOYgcC5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508250425.yEOYgcC5-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/xtensa/include/asm/io.h:19,
                    from include/linux/io.h:12,
                    from lib/iomem_copy.c:8:
   include/linux/pgtable.h: In function 'pgtable_level_to_str':
>> include/linux/pgtable.h:2000:17: error: implicit declaration of function 'VM_WARN_ON_ONCE'; did you mean 'WARN_ON_ONCE'? [-Wimplicit-function-declaration]
    2000 |                 VM_WARN_ON_ONCE(1);
         |                 ^~~~~~~~~~~~~~~
         |                 WARN_ON_ONCE


vim +2000 include/linux/pgtable.h

  1985	
  1986	static inline const char *pgtable_level_to_str(enum pgtable_level level)
  1987	{
  1988		switch (level) {
  1989		case PGTABLE_LEVEL_PTE:
  1990			return "pte";
  1991		case PGTABLE_LEVEL_PMD:
  1992			return "pmd";
  1993		case PGTABLE_LEVEL_PUD:
  1994			return "pud";
  1995		case PGTABLE_LEVEL_P4D:
  1996			return "p4d";
  1997		case PGTABLE_LEVEL_PGD:
  1998			return "pgd";
  1999		default:
> 2000			VM_WARN_ON_ONCE(1);
  2001			return "unknown";
  2002		}
  2003	}
  2004	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

