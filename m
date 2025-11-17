Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C01CCD19A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 02:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D928E0038; Sun, 16 Nov 2025 21:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23EED8E0002; Sun, 16 Nov 2025 21:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154E38E0038; Sun, 16 Nov 2025 21:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00DF68E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 21:31:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A10E89F53
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:31:45 +0000 (UTC)
X-FDA: 84118523370.07.63369FE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA00B1C0005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:31:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dPWmj2wz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763346703; a=rsa-sha256;
	cv=none;
	b=F9KPKzYb326B9++Eb3CdHc9Ju+El0jwrBQxglOaNTb0BjKZ5z2NarVVDVaY/Dk7slmI1WH
	5p19LutNbjzpORAKl3NvNSpTD0988k7PNEPZgNnRytcF81RjcsrrCUQrtlsLqBWSh2Dkgo
	Jvj8l1Bd9awTNl/+7WahE3fY8m5uh3E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dPWmj2wz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763346703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=wbzW1xXIgUSKX+pbaCN2H7cFBd/jqvcTfLH+QtWNWLU=;
	b=qrreE0WSKjEOhW16mXPN+Rx9b5XWvxuZq+It+AG2rZxsUzzabowpla38QucnEJgJDvx0+Q
	NybmwyfvkceMPogZuswkxy7PzBBpfNLl8yOBOAFJfQxPI3dZnFWS6GvBr/xJCWkSTtUQY1
	uwb5NMKDR+SqjE5KuVX31MLup3CEYzw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763346703; x=1794882703;
  h=date:from:to:cc:subject:message-id;
  bh=1MDzjqYY27HgaKpnZr+dQmtLSXwjMBONTTDy5LOy/dQ=;
  b=dPWmj2wzKmXbpEJwwWYK6tkDAohUD5C3ZJ+ngM4xbSMrSOI6WlHy7iOY
   VsGJV3CdPzvuxIASFQn1Bea3zRH17wMS5Crb7j6FAqSBrMFCma1KyIHXP
   Hr3eDFTUpKoGDF0fKC62eF7JnFzGwLpB1pGi/taJzUJT2QQZncVgssNBE
   tAGHWJ2amsHnS/tME0Rs16fnX0Ae2Rz6aDT23bJ5KtUKYDrVZmP0rJslH
   Yf3MftD1ZhqSw+W8O7EuqBsaxT4Kac0OzW5VDRcE1Sk1FiUOsjp2fgWn3
   aQio50jbYG1pjwT/93WOwHjxQvNGV/N9Mvap97kRdfxrIem1d7JcEnn7A
   Q==;
X-CSE-ConnectionGUID: mDfmIu1QRTqHNTz96UYRWg==
X-CSE-MsgGUID: dnvNOOKpTDOyf5pJsD39uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="76802994"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="76802994"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:31:42 -0800
X-CSE-ConnectionGUID: /jcpEpzCRPCQQyjbIP8iFA==
X-CSE-MsgGUID: U93MrFU/SoyI+O1ZxTmKSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="213725723"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 16 Nov 2025 18:31:40 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKp1m-00005b-1q;
	Mon, 17 Nov 2025 02:31:38 +0000
Date: Mon, 17 Nov 2025 10:31:01 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 c42af83c59b65d01c0f7a074e450bbbb43b22f0d
Message-ID: <202511171053.k8L5B0L9-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: DA00B1C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: apcx9g6ckoi8irr9s1zfo4n69o9rnxaf
X-Rspam-User: 
X-HE-Tag: 1763346702-872128
X-HE-Meta: U2FsdGVkX1/ZtXxzN19aJvzxJznfHuIQA5N/yCBvqhgcEsSF3KTus4qFX8o5azXlW1odGCee4JPaubQJ3C8QTBomMjXGuGc0q5Cw7s0i18gMdEv9LAfcyqE1wtoKLfQ3IRju82DdiSAk3Ft0sA2VV9edhkS5A1qoddwr1y2I0SgR+MfaOwR6Tsg1R4tzVCP7x/wkCIwxsegto+eMDnUNyOMDNzrujSjmf5xOHnnRhyFRKaS5GeDhk2myIcqlAgRTENyADku1Ne0JmQPN5tXCnL4UJsAcdbYyOZu8Dp8q4VIgEz9TUVDxnNayqrekSZebIj7MQd+ypfqvKNDRX3bDXr7dFjA9X/9kj1W4bHp3LjqFZrASIZnTLsFUT1ukJ15yeeOm0kVEgdMP6xhikJtwO/XZuz5FYGnGDgfsS//OzRnrUrN0lxXAcfU+k4QDtiZEE2ioZ9Zd/kB0Z8n4I2nmYctM/hthc9zYT6NwmtCr5ttEfb+tpTPNFt+wmOUV9bc+utgbgDLCBnJTXmz9+Nyr9Sd3Pzf+CYPMeCHLFqIcTWn+NzzLtvTgAn0ilTxdABc6bFcnYBrmNfGAZuqYKcBpv37QxeoULp+WsGa6Vfl5dbhnDVwKQ//sw73X5vFXdgmW6fBEVMAtMsqO9T8NVjpkwOce041FPzxRClMrHI0t5bYYDe7R61+42Hf8jJ8FsLQ6WszQKRiqcoAR/mXCcllrqWdjwveY5ISrcY1Vw1OhK5zDfTnJbu890mw2CY5ToYXxJqWu1ysFLxx3PhRnJ9oOE5NpKkoXZbNLKLea0cyJXuBwV3WYOEXwFbjw9qO7HcVjuAI4nbnci8oZdpCdP09PYz20PBN46ZnWaUyVdDslydMk/ITNoGzBbSFiBFJkYTZBH89QH/I4bLMJILwrZqzwKIY7KKe9RxHXk6MiTV+9PsCGyrTqPNUmTnHN4Uoyae8gwOJR59yARVbLyeYJx7H
 ffvAiw17
 JC8XvAxgKUy84w7zbLLKk14PuzhjJdN1ElW/Nk+hkqvtr4xiZ6vAIH9B1DIrpznkCYF/KqJa4x9XlIge/F8hjTXKtLOuKJm4q9Ma2vEh5XX9hVhZcwmf9wHdHW2VapMOVGWx1qqTLLMghp67nML4TWGFV5cLo+ZMHyOhj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: c42af83c59b65d01c0f7a074e450bbbb43b22f0d  memblock: fix memblock_estimated_nr_free_pages() for soft-reserved memory

elapsed time: 7749m

configs tested: 70
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha               allnoconfig    gcc-15.1.0
alpha              allyesconfig    gcc-15.1.0
arc                allmodconfig    gcc-15.1.0
arc                 allnoconfig    gcc-15.1.0
arc                allyesconfig    gcc-15.1.0
arm                allmodconfig    gcc-15.1.0
arm                 allnoconfig    clang-22
arm                allyesconfig    gcc-15.1.0
arm64              allmodconfig    clang-19
arm64               allnoconfig    gcc-15.1.0
arm64              allyesconfig    clang-22
csky                allnoconfig    gcc-15.1.0
csky               allyesconfig    gcc-15.1.0
hexagon            allmodconfig    clang-17
hexagon             allnoconfig    clang-22
hexagon            allyesconfig    clang-22
i386               allmodconfig    gcc-14
i386                allnoconfig    gcc-14
loongarch          allmodconfig    clang-19
loongarch           allnoconfig    clang-22
loongarch          allyesconfig    clang-22
m68k               allmodconfig    gcc-15.1.0
m68k                allnoconfig    gcc-15.1.0
m68k               allyesconfig    gcc-15.1.0
microblaze         allmodconfig    gcc-15.1.0
microblaze          allnoconfig    gcc-15.1.0
microblaze         allyesconfig    gcc-15.1.0
mips               allmodconfig    gcc-15.1.0
mips                allnoconfig    gcc-15.1.0
mips               allyesconfig    gcc-15.1.0
nios2              allmodconfig    gcc-11.5.0
nios2               allnoconfig    gcc-11.5.0
nios2              allyesconfig    gcc-11.5.0
openrisc           allmodconfig    gcc-15.1.0
openrisc            allnoconfig    gcc-15.1.0
openrisc           allyesconfig    gcc-15.1.0
parisc             allmodconfig    gcc-15.1.0
parisc              allnoconfig    gcc-15.1.0
parisc             allyesconfig    gcc-15.1.0
powerpc            allmodconfig    gcc-15.1.0
powerpc             allnoconfig    gcc-15.1.0
powerpc            allyesconfig    clang-22
riscv              allmodconfig    clang-22
riscv               allnoconfig    gcc-15.1.0
riscv              allyesconfig    clang-16
s390               allmodconfig    clang-18
s390                allnoconfig    clang-22
s390               allyesconfig    gcc-15.1.0
sh                 allmodconfig    gcc-15.1.0
sh                  allnoconfig    gcc-15.1.0
sh                 allyesconfig    gcc-15.1.0
sparc              allmodconfig    gcc-15.1.0
sparc               allnoconfig    gcc-15.1.0
sparc              allyesconfig    gcc-15.1.0
sparc64            allmodconfig    clang-22
sparc64            allyesconfig    gcc-15.1.0
um                 allmodconfig    clang-19
um                  allnoconfig    clang-22
um                 allyesconfig    gcc-14
x86_64              allnoconfig    clang-20
x86_64                    kexec    clang-20
x86_64                 rhel-9.4    clang-20
x86_64             rhel-9.4-bpf    gcc-14
x86_64            rhel-9.4-func    clang-20
x86_64      rhel-9.4-kselftests    clang-20
x86_64           rhel-9.4-kunit    gcc-14
x86_64             rhel-9.4-ltp    gcc-14
x86_64            rhel-9.4-rust    clang-20
xtensa              allnoconfig    gcc-15.1.0
xtensa             allyesconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

