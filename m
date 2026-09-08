Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B1EC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA396B008C; Tue,  8 Sep 2026 06:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BF26B0092; Tue,  8 Sep 2026 06:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA276B00A4; Tue,  8 Sep 2026 06:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65C546B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:02:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 029791C2116
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:02:58 +0000 (UTC)
X-FDA: 85190156478.16.145AA5D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id 020FF4000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:02:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ORm/0P/Q";
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861777;
	b=VJnpNJZayr93/YsBpjvv5kYevL0GJooLZglg4YeOfh8tz0mMti5N5hKYCNjb4P0uHFf2ML
	rFm1mkUdLHSGEE4PSkh462GlIv76xN/yF7e6VuwhzKaNhwdi5QvyiS7w5Bba0+MKpeOt8O
	2KJrkkVYd+jOaIwsZrf9MN3A8fs1HVA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ORm/0P/Q";
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UuKC4DMq3xslKnCBkWv0o/k3UCh4C/Q0S0CSXxs4Ybg=;
	b=Y566i0mfDzJxwg8cAxU82mC5JkzD9E58B8JaqrGep5tG4PJAE/xFD51OWJ3+cciTcpapoe
	RJcTQ13o7FbbvehbBFa8yRIkpeE0wxL1CRfb5vfZEH+kvwNJm8JEWJcwhzBGydToZ8Oep2
	866Ah9loAX3gOAFzEmXh1t2d8qbkotk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788861776; x=1820397776;
  h=date:from:to:cc:subject:message-id;
  bh=lOenf34xndDiZJzMvpI/y4dJR0P8wkP4cRibhZ8Cg3E=;
  b=ORm/0P/Qht9klfaVryermzPO6x0NWoTKs+GKDBY8s5bXH6C8IlmGCzf3
   5djSc3EhVIXBYHlDvr4Chceu20gVcE10S7ROybp+wNW1x3vv7xu2Ks+j/
   zwmS889waPUaWLyaiNDfbldIQCzCBVs/QBdJNZjepYefzPn3MgQJ5X+Gp
   tjtDO4oPktJ5JzCwI05YsUsUYLA/0zrFs1aJnlLuX23El+23RJFjHY+BN
   VgucUDdpRu3Enww7gJ1KQUH+Zxv9wt+1lLxaB7z8/Fe+HgNoL6fmE1kRu
   3+41kRzWxC6jvzUQFheN4+fT1C+R1c+4qYjv4rjNw63A8Yb60/nTVxcA4
   A==;
X-CSE-ConnectionGUID: 7HLBlUc4S5ettG7bSV4aGg==
X-CSE-MsgGUID: KMrPWyILR1KvSYqWX9iTlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="99852939"
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="99852939"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 03:02:54 -0700
X-CSE-ConnectionGUID: 69z3aZ3YQc6vTCP9kvNpNg==
X-CSE-MsgGUID: CvDo7uGIR6W/UNHeQIyZ3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,268,1779174000"; 
   d="scan'208";a="274470861"
Received: from lkp-server01.sh.intel.com (HELO dff15f1b2031) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 08 Sep 2026 03:02:53 -0700
Received: from kbuild by dff15f1b2031 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x3sfB-000000001xF-3ykp;
	Tue, 08 Sep 2026 10:02:49 +0000
Date: Tue, 08 Sep 2026 18:02:41 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 9d3243fc689fef444f87e0a703b4c99653137e1b
Message-ID: <202609081839.rwV5qR0y-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: jrenh6x8i13rsc1c6qdr4pf3qxp3gqna
X-Rspamd-Queue-Id: 020FF4000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1788861775-44754
X-HE-Meta: U2FsdGVkX1+A98xMDSAChFN0qRP/jo4acV7xFSt7zzj3+t6Qq/HyL4frjvuNVv735c+VZVXmro/C163xXTX9xiYj3+0hHxrJlytBJ6hklYWdFfEq8Ce4z44OqPVDIp21KI0EyWsrYd0k60awTf5+7zLtk8Ntl8ekxZsycctPTx/fNfOOH8lpX73K3JZtoSA2/wtue0LsYzB8RtG39ttAl0p/KhhmDNN/vzlmX6Za1Hx1JJHSTsQAf27JFiIAJfgPLoX+qq/GHhcMHafLFB4B48vIC1Q6Jr0hxS3ShzYHquffsf/7d7DG98AbxZPqYY8c+p9fw5PHeyAWUzKc98pPwZpAYeMpfPNSol4GjMz3Tp4XlkuXaQvR7gzTPgRP+aXFR3CAXxlkiGfovSN/rvLB1XPFRN/G4hJQ63icqA7Xluw7clVAm242+N/y1bxsySKEtRqwAJ8n1mHmkGl5adTf7eTAFudR2gN+G2w4D+1x4z603vM4o0mSeBWOrJjuQdlEIgvOs/hJN+RxVeGo2OcMkPv7tebkoWtrQ/MIxAx5gzvj7pPPmmyB4yR17Y6kmj37pq3Xu++uxVY7fE7/9wMFfRw8q79NuvT6fIq3iCWyJd1v1zlXWdBBUOvTXOHM21IgF4sU9JtfdumTL9mdvz/mRm2FkT/usdvxrnBMe5AbnI6n/BvFOeFN91R3jBX4//MnSh9Gft6flILzmqXDaXgfFQbc5NyHRmXJo3oroSj0wuIYnR6JQmj4jMXty4GxefnZ/wcgdkCl7/RqaKsXIsAEgZdTmMpoY4o3AH8qS15Aaef27GPQi9WbaR4cdECZ6u69H7N1UPpjFewxG9TH1O+uRX5RsqrTl7u7joxvXNS4UEeOCgNZOtDEwZ/NuCK1/e54+Z89xdYLcKNi1JrbBnfwBEu/iYaq7C8nTPXBLEONNaRZSNA+GRQ/OB7XbDtcn3JoqzXL8CP9DWTHbpmUCso
 s0FvME8z
 2wlfZM5tL3emwd2ae4nN2hwQUxpAODE7/P7+UuxpJ2S3jWey1TyYdE1kmw8k6r5SEIMHsWUa+kekpsYoi5ugceBFwn8r8Y++XwCLatwFj8nyUMG+uSFV9A8UrdtDm+EXI0qii6shhRi3JYUjVZAuu42k3sh4Ka89iqQR3tTrrhR4425OCj6tz9ooXfCEX8ek0kWr9FE0xJIoxgpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 9d3243fc689fef444f87e0a703b4c99653137e1b  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 1865m

configs tested: 79
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
arc          allmodconfig    clang-24
arc          allmodconfig    gcc-16.1.0
arc           allnoconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
arm           allnoconfig    clang-17
arm           allnoconfig    gcc-16.1.0
arm          allyesconfig    clang-24
arm64        allmodconfig    clang-24
arm64         allnoconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
csky          allnoconfig    gcc-16.1.0
hexagon      allmodconfig    clang-24
hexagon      allmodconfig    gcc-16.1.0
hexagon       allnoconfig    clang-24
hexagon       allnoconfig    gcc-16.1.0
i386         allmodconfig    clang-22
i386          allnoconfig    gcc-14
i386          allnoconfig    gcc-16.1.0
i386         allyesconfig    clang-22
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-20
loongarch     allnoconfig    gcc-16.1.0
m68k         allmodconfig    gcc-16.1.0
m68k          allnoconfig    gcc-16.1.0
m68k         allyesconfig    clang-24
m68k         allyesconfig    gcc-16.1.0
microblaze    allnoconfig    gcc-16.1.0
microblaze   allyesconfig    gcc-16.1.0
mips         allmodconfig    gcc-16.1.0
mips          allnoconfig    gcc-16.1.0
mips         allyesconfig    gcc-16.1.0
nios2        allmodconfig    clang-20
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    clang-24
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    clang-20
openrisc     allmodconfig    gcc-16.1.0
openrisc      allnoconfig    clang-24
openrisc      allnoconfig    gcc-16.1.0
parisc       allmodconfig    gcc-16.1.0
parisc        allnoconfig    clang-24
parisc        allnoconfig    gcc-16.1.0
parisc       allyesconfig    clang-17
parisc       allyesconfig    gcc-16.1.0
powerpc      allmodconfig    gcc-16.1.0
powerpc       allnoconfig    clang-24
powerpc       allnoconfig    gcc-16.1.0
riscv        allmodconfig    clang-24
riscv         allnoconfig    clang-24
riscv         allnoconfig    gcc-16.1.0
riscv        allyesconfig    clang-24
s390         allmodconfig    clang-17
s390         allmodconfig    clang-24
s390          allnoconfig    clang-24
s390         allyesconfig    gcc-16.1.0
sh           allmodconfig    gcc-16.1.0
sh            allnoconfig    clang-24
sh            allnoconfig    gcc-16.1.0
sh           allyesconfig    clang-17
sh           allyesconfig    gcc-16.1.0
sparc         allnoconfig    clang-24
sparc         allnoconfig    gcc-16.1.0
sparc64      allmodconfig    clang-20
um           allmodconfig    clang-17
um            allnoconfig    clang-17
um            allnoconfig    clang-24
um           allyesconfig    gcc-14
um           allyesconfig    gcc-16.1.0
x86_64       allmodconfig    clang-22
x86_64        allnoconfig    clang-22
x86_64        allnoconfig    clang-24
x86_64       allyesconfig    clang-22
x86_64      rhel-9.4-rust    clang-22
xtensa        allnoconfig    clang-24
xtensa        allnoconfig    gcc-16.1.0
xtensa       allyesconfig    clang-20
xtensa       allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

