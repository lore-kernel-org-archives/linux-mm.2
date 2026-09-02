Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6EEC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821BA6B008C; Wed,  2 Sep 2026 14:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABAF6B0092; Wed,  2 Sep 2026 14:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6731B6B0095; Wed,  2 Sep 2026 14:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 378086B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:53:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB017A0353
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:53:53 +0000 (UTC)
X-FDA: 85169721546.24.D4C9DD4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1FE1FC0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:53:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g6x5xPqo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788375231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bIs54jhDfGzLO8DsAYZFXlemKbyiweW/asnZN19z2YE=;
	b=6LEUkqmtFE1NR74C8CjbcJIvZOTypfjaiBoxCqG7/2mIOovPsnP49iFs4a/MN5XvaksGXS
	Z0b4TpXYSAce7jgRgtbeC/bDuwlmf0N1TC2FOkpsnNgcljFkEcTV9UMCKbz60u/hW1qxaR
	F9jFRWRJ49axU9wDwjObzIOV2vud9gU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g6x5xPqo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788375231;
	b=kGiovILSSwihSOdjK5tLzDDyp7suXpjshQj87MDXICQWWvT9dnf+B5sOa+mM67BG8P4qZy
	cUMeeOCRpjJm5pU8z++H8Nr2BUiWrh9mxZKwO1PmBN6C+hfGWPu9V0SonOEyt5l6Ucuqb1
	d5Sf/JohAmtQSnZ2wjLRurZJCnD/xu0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788375232; x=1819911232;
  h=date:from:to:cc:subject:message-id;
  bh=tyqBvBhaitEafSk7IFlesfHWtTBrzO7CcS/spKtX6XM=;
  b=g6x5xPqoyHuhfDk4YMg3iB4Hjbt03Wu/NUW1GHs4uZMjnhwxmpCwj75T
   LWcHI6sNGH8q2q9injaPnz3ZBy/iOPzVSwbmREQ69Glmyp8+ZSfvTFHzv
   7jyrqvS+u6ES9hInIKY7uYjjExDWwm+1vV68vsRx42jgQ1rfg4IwIWL6N
   r1ZCIYIllX9q6WhMzYO96dDsC4NPcHaYSafQKco7HWYOeKQcrewVjy3MD
   SbKdzM6+s8sWxyUGCDTTGwpNjn2ucqBrzbYlvX/T7yL1lMPEJ7up296F4
   2JkaGXsQ06+YIdLIUCpfZCKHXThY/wap1Q9gfW9B33dLu1ms0Psxz7FkX
   g==;
X-CSE-ConnectionGUID: bJJrP8jNR4mzi7vG2AUsVA==
X-CSE-MsgGUID: KE8yMJq8RISiKTJ0HuKVFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="100359921"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="100359921"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 11:53:50 -0700
X-CSE-ConnectionGUID: J9AHT+yTSoqIutuyyWVedQ==
X-CSE-MsgGUID: D0CqvWLBTSCCfTY9H3a+IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="272995110"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 02 Sep 2026 11:53:47 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x1q5h-000000003AI-28ct;
	Wed, 02 Sep 2026 18:53:45 +0000
Date: Thu, 03 Sep 2026 02:53:11 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 178b3d97bf1f15f598ea7cc615a40c115e528e1c
Message-ID: <202609030205.mM0yURLh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1FE1FC0006
X-Stat-Signature: jrp5ara5zmh5dxg7hpxmggeatpn19jgd
X-Rspam-User: 
X-HE-Tag: 1788375230-748944
X-HE-Meta: U2FsdGVkX19qP+x0/oBzwGa/GunP41GmcWwAvNHNBfyJP0s+OigF+137d9A76w20YQ2BS4RHse1FDJosfHbd4aNzEY0K0qpRrUmTCNs+hjVLaNy+lk1Yx8HSoXbNiYIsAl1YfNsTCAT+wL3rP35vXq3EnSW5F9OWBVzxtHcbHnwsx1LpBm9kzERc3qx7LzCRDLSKkFTjzP8b+wOuoPJERWAouwyOghsyh6nzQaMyiqNtYWBa8+6NMQ6OBe/tUT73n8Mo5eOEHCujIGoKc4yE68rYugltByYaYUJMYP6ynm/Uf0xmOq3YoDiBYJOdn4NhVtr/UMfhhbLig/G0ay4/8CJirJSr9ReNurxSv4Xj4U5yIFW/Tyr4IytQgs4MvsxJ3o/qTAPDalOBxo3RrjnGqDaqbCIOI1ozqq6JGml8hkG3MMdb1SUewV4wjz3rxOj9/vf3Fot2OODhhY+vkSPvgOPuJJiBuKmDs6LE0+mJaL9Q9owsb72pNUrST+BYznkltSjNrhM9taBfzZ9vf0qRUsHK1QvIibtENgy5Ycfr6h6OYqXufC1eY+X1LXHon+FD4l/Oc7Id+JeZ0BYSUb6olES0dbZjaFRTJ7+7EvMJSis8dmicgl7GBT/ao0ilgBg4qOK3eGrLOsoOsFlQBru0teGj80dhdskIMOS122J2K3xcWXzTkdJ6L2EQqm3ph8IJXR13lpsBKXC3rSy4I8pGUj4PSH7M/1gTNPp8fSy/TQJCCYQtpny/xABSjlzEpETsrm88GRJ+asJ/3zfkjJNQxv/XYPV59jX9EbVK68w7kwu7aEf4fAT23ZwleGGMqrZuVQ8tmU+weoKrfB4pKWEfCqNJXBTXT5Zky7z5vSVdTKiSxbA6EtqenWwoUtnZ0NW+ZgnizGCRQY04NcEl89gkW0a/xE+7Ae6WF4u7IgcN2Az2x+HCbt3fFf7TFP7dkHdybVNz8DXKrq0RwWmq1ry
 vPCYAAq7
 fK2zSyQGvoERnjst8+K6poavTJnqK1/6wZMyoi0iEf16PEh7clutj1q8y6LqWzsdDnU2+OjRd62d8yrvIEVpmX09vX0cHosQYYAHL5Tqeu+9Q4viH8to3yXpqtJXtOwy926EWKdbh4+2BWlGe253NJWVAt0+T3ORlyCF9Trbbs+7mX+Le3zklhRDmNZYu9/7H5wmi03muAvOjIPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 178b3d97bf1f15f598ea7cc615a40c115e528e1c  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 896m

configs tested: 74
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                    allnoconfig    gcc-16.1.0
alpha                   allyesconfig    gcc-16.1.0
arc                     allmodconfig    gcc-16.1.0
arc                      allnoconfig    gcc-16.1.0
arc                     allyesconfig    gcc-16.1.0
arc         randconfig-r072-20260902    gcc-10.5.0
arm                      allnoconfig    clang-17
arm                     allyesconfig    gcc-16.1.0
arm64                   allmodconfig    clang-24
arm64                    allnoconfig    gcc-16.1.0
arm64       randconfig-r112-20260902    clang-24
csky                    allmodconfig    gcc-16.1.0
csky                     allnoconfig    gcc-16.1.0
hexagon                 allmodconfig    clang-24
hexagon                  allnoconfig    clang-24
i386                    allmodconfig    gcc-14
i386                     allnoconfig    gcc-14
i386                    allyesconfig    gcc-14
i386         randconfig-061-20260902    clang-22
i386         randconfig-062-20260902    gcc-14
i386         randconfig-063-20260902    gcc-14
i386         randconfig-141-20260902    clang-22
loongarch               allmodconfig    clang-19
loongarch                allnoconfig    clang-20
m68k                    allmodconfig    gcc-16.1.0
m68k                     allnoconfig    gcc-16.1.0
m68k                    allyesconfig    gcc-16.1.0
m68k        randconfig-r052-20260902    gcc-16.1.0
microblaze               allnoconfig    gcc-16.1.0
microblaze              allyesconfig    gcc-16.1.0
microblaze  randconfig-r071-20260902    gcc-12.5.0
microblaze  randconfig-r111-20260902    gcc-11.5.0
microblaze  randconfig-r113-20260902    gcc-11.5.0
mips                    allmodconfig    gcc-16.1.0
mips                     allnoconfig    gcc-16.1.0
mips                    allyesconfig    gcc-16.1.0
nios2                   allmodconfig    gcc-11.5.0
nios2                    allnoconfig    gcc-11.5.0
nios2       randconfig-r054-20260902    gcc-11.5.0
openrisc                allmodconfig    gcc-16.1.0
openrisc                 allnoconfig    gcc-16.1.0
parisc                  allmodconfig    gcc-16.1.0
parisc                   allnoconfig    gcc-16.1.0
parisc                  allyesconfig    gcc-16.1.0
parisc      randconfig-r121-20260902    gcc-9.5.0
powerpc                 allmodconfig    gcc-16.1.0
powerpc                  allnoconfig    gcc-16.1.0
riscv                   allmodconfig    clang-24
riscv                    allnoconfig    gcc-16.1.0
riscv                   allyesconfig    clang-24
s390                    allmodconfig    clang-24
s390                     allnoconfig    clang-24
s390                    allyesconfig    gcc-16.1.0
sh                      allmodconfig    gcc-16.1.0
sh                       allnoconfig    gcc-16.1.0
sh                      allyesconfig    gcc-16.1.0
sparc                    allnoconfig    gcc-16.1.0
sparc64                 allmodconfig    clang-20
um                      allmodconfig    clang-17
um                       allnoconfig    clang-17
um                      allyesconfig    gcc-14
um          randconfig-r051-20260902    gcc-12
x86_64                  allmodconfig    clang-22
x86_64                   allnoconfig    clang-22
x86_64                  allyesconfig    clang-22
x86_64       randconfig-121-20260902    clang-22
x86_64       randconfig-122-20260902    clang-22
x86_64       randconfig-123-20260902    clang-22
x86_64       randconfig-161-20260902    clang-22
x86_64      randconfig-r122-20260902    gcc-14
x86_64                 rhel-9.4-rust    clang-22
xtensa                   allnoconfig    gcc-16.1.0
xtensa                  allyesconfig    gcc-16.1.0
xtensa      randconfig-r123-20260902    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

