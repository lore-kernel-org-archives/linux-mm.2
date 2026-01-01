Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228F4E9410C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 04:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD476B0005; Wed, 31 Dec 2025 23:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A216B0089; Wed, 31 Dec 2025 23:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CCA6B008A; Wed, 31 Dec 2025 23:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C70026B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 23:45:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49202B6066
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 04:45:32 +0000 (UTC)
X-FDA: 84282156504.21.3C0329A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5175E120004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 04:45:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JGQOZAoJ;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767242730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=AlX/hlP5zZiD9Hv2oaVW9Rg8lXNKm3DjPncxGEN8DGM=;
	b=csPcpp8u4adx/YonTkrFpTFAo1IeQbK9FlPEflubE0VLtpgkmq+FE6S8li7/V4u8LVsobw
	6n6mmKFMLNPM4jeTeGu8jtqQoEqtI6SxW5SV2IZdBeGLh+qy9dN5tbHfhsLDdxRmQWPdH9
	6SmnzTS7QVyzl/DFx3prhokNlzyW21o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JGQOZAoJ;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767242730; a=rsa-sha256;
	cv=none;
	b=C9RWkUCslw+O+nFhszavRB2jiJu4jKKoKhH9NumQFYhRBp0Xa+cQD7DB/IGAHCb8RTFJIA
	34S44VqsJrhzVh3+p82bOQ9mzU/nX/3PIiIp7pbUpr/VSf4DF6dw4h2bcOGUIj49cjZRo0
	XSBQccqzY/PD4mYaJCW4/E9ro+FKNTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767242730; x=1798778730;
  h=date:from:to:cc:subject:message-id;
  bh=Vv3G+g9l/ckNPnW6eaIiZMNE8Lcwlnq8k5tAcQuZEl8=;
  b=JGQOZAoJj6TrvfyKfd0SBLQuWL1qneEHYKLXk3sI9LQ7hPIHepiXl1x/
   Du+fM+HtHGkliquoH4FZFlmRnpm5S1TVGgkdO7SLVL2XnUyUUTSxWr9iz
   18TMNdqzLWIhZMtt6FW5G5jKStCuOiR/CgrvyzCGMMvY3NvY7MT4FU2B0
   hgNGJ0llxFVgbH+bDPicYYhLvxud/sjOKt2rnw+COgkUiaZSgr/UMoNYI
   u78mzY9pS9cQO97Ch+7yySOsQ9GhKTncR2u2D9d/kRinlDFlriBxuGxu7
   p4RCWHe+CLfZRjIIEEPESuc3Tc6yO/anABU7k28XIfLuicV/NQJCVgZ7W
   g==;
X-CSE-ConnectionGUID: pC/FqkFnTke2/qImoveJag==
X-CSE-MsgGUID: QTWC9ACaSBK3PydnSG48iQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11658"; a="91445280"
X-IronPort-AV: E=Sophos;i="6.21,193,1763452800"; 
   d="scan'208";a="91445280"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2025 20:45:28 -0800
X-CSE-ConnectionGUID: UyZG1jDJR52ywgs/JygOlA==
X-CSE-MsgGUID: mEKIH6L9SWSe4XNdUIutYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,193,1763452800"; 
   d="scan'208";a="206051585"
Received: from lkp-server01.sh.intel.com (HELO c9aa31daaa89) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 31 Dec 2025 20:45:26 -0800
Received: from kbuild by c9aa31daaa89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vbAYu-000000001gb-2LOL;
	Thu, 01 Jan 2026 04:45:24 +0000
Date: Thu, 01 Jan 2026 12:44:55 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 56b680254ce084bc7775c6bfe55c49e5f6d04e85
Message-ID: <202601011250.i1UKNRPU-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5175E120004
X-Stat-Signature: opfkqb37w9ou7c65dnfcqfmobhg8de88
X-HE-Tag: 1767242729-101358
X-HE-Meta: U2FsdGVkX1+0Ttq65oQNyD0tnT2Qw4u24N76ZPToPiAUyP6ZJlnEmNqtJJj0Hk2amSL6JVJDxLfNwxz0IYOAS0UzUZkZ0WB97mAnAPhLTp60LV4GQ/jHYg+7rrNR25tUf2Ltl0WBbxBJQqr+F6k2feho7o4M+YTgjEux3mKPJcdMp7MLMoAMRD9p8PdQFm/ymlnlsBIdomNVUjLEOGasUAH7f8CEvfOUTYEE9PeU/9bQd2CYethFF3UTW/IbvlfFZloCMLp+4zLPhRW9kgKWEnzrEmjiDvX8efi+P/NUxBGX8CCV1lODEhJdjw7DsMg9jn14ridrC+9qKRA2T9b444uZP/lTDg4DEMPuFOIEG65nBYtR4NJcskYQwBSIRmfB4mRzcW/ZT+6bgcERL+vDrB78KO3zdvLI+CRLf8aVuNuluGVV4GQEGljkErvhexKrOSkNySs5jehdHnyCjerMWIdMpOYNL73I+WF2N6PvCuCiHzZgenjURtorJamxwfm6obaYY0/HYFsJf9Kgy8BAhUvyLIJMLOE03pNabvgYj7hLVXnAC2imZBhDDbROzyGfFWNxCNql90qJCP7uzEx2bH07g03kQmiA490JsE8jM/sbtTIDfzr3A6NPr0jEgv2yN0yY2Q8f+FowNZRQnMF+BMw5VSitRVbOHahMa14eUL8/tl1iQVkiigVQqZs63d4NttpgpoWeEnIY/0kLZjWKa0nXIU8VBb82lfBP4GScMl+232ca1pBx+lLPnnuNaL/4GGY6KZz9qLpRwmYMdvoiEFUo6JfeXjjfrISd5mLr30bnCzra8sFzh9dOdjw4MKUPXdcAl29SRfQAIdlhc7PSLDEB1JgDV4DWbeH00rKk17L0a+0wfNX7Sfgxt5GvB+Cs0tqBUYb+PM2K7Wkz4uf0u2NZXncBY/6IVi7KdhPPwcOGQEODUh6hxK/Qa1N5/NIW4E9kBA+rhjL6yclIzfj
 lh9jdPFz
 JgPUSxDCYDtj2OCNPmmFvVtseJXa82Y3LjU1aubX1k6ljQR0/lgcY5N/Ha4UaykX3UpaA+ZEPFcVj+Q+DKPXokEsttNufHJvv/uMOXC1FhkpITnpXlmaiZAlKBBf8O12VMh0o9S1+aNtY4U1kBkU2g1Jz/WUvhsHXFt/R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 56b680254ce084bc7775c6bfe55c49e5f6d04e85  mm/memtest: add underflow detection for size calculation

elapsed time: 1208m

configs tested: 55
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-15.1.0
alpha        allyesconfig    gcc-15.1.0
arc          allmodconfig    gcc-15.1.0
arc           allnoconfig    gcc-15.1.0
arc          allyesconfig    gcc-15.1.0
arm           allnoconfig    clang-22
arm          allyesconfig    gcc-15.1.0
arm64        allmodconfig    clang-19
arm64         allnoconfig    gcc-15.1.0
csky         allmodconfig    gcc-15.1.0
csky          allnoconfig    gcc-15.1.0
hexagon      allmodconfig    clang-17
hexagon       allnoconfig    clang-22
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
i386         allyesconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-22
m68k         allmodconfig    gcc-15.1.0
m68k          allnoconfig    gcc-15.1.0
m68k         allyesconfig    gcc-15.1.0
microblaze    allnoconfig    gcc-15.1.0
microblaze   allyesconfig    gcc-15.1.0
mips         allmodconfig    gcc-15.1.0
mips          allnoconfig    gcc-15.1.0
mips         allyesconfig    gcc-15.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    gcc-11.5.0
openrisc     allmodconfig    gcc-15.1.0
openrisc      allnoconfig    gcc-15.1.0
parisc       allmodconfig    gcc-15.1.0
parisc        allnoconfig    gcc-15.1.0
parisc       allyesconfig    gcc-15.1.0
powerpc      allmodconfig    gcc-15.1.0
powerpc       allnoconfig    gcc-15.1.0
riscv        allmodconfig    clang-22
riscv         allnoconfig    gcc-15.1.0
riscv        allyesconfig    clang-16
s390         allmodconfig    clang-18
s390          allnoconfig    clang-22
s390         allyesconfig    gcc-15.1.0
sh           allmodconfig    gcc-15.1.0
sh            allnoconfig    gcc-15.1.0
sh           allyesconfig    gcc-15.1.0
sparc         allnoconfig    gcc-15.1.0
sparc64      allmodconfig    clang-22
um           allmodconfig    clang-19
um            allnoconfig    clang-22
um           allyesconfig    gcc-14
x86_64       allmodconfig    clang-20
x86_64        allnoconfig    clang-20
x86_64       allyesconfig    clang-20
x86_64      rhel-9.4-rust    clang-20
xtensa        allnoconfig    gcc-15.1.0
xtensa       allyesconfig    gcc-15.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

