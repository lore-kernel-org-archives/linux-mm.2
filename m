Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D1CD277CE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 05:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346A06B0089; Sat, 10 Jan 2026 00:57:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4636B008A; Sat, 10 Jan 2026 00:57:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F39C6B008C; Sat, 10 Jan 2026 00:57:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 097D26B0089
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 00:57:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B903F160128
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:57:28 +0000 (UTC)
X-FDA: 84314996976.03.162FD82
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5A1E5A0009
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:57:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MQ1qcXKS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768024647; a=rsa-sha256;
	cv=none;
	b=boJ2/Y38Ax58AcajoiaidjmK6MtXdKJhP3w98i1EK+QqwbpEM2i912EhirxqpVE60JOT1T
	fkc/kN2RkwmJxcA4oRK+ADWvpV4EsfXcL8HtgADoW1Hhv2jjpa+nUWb3wTCdyQNo5FoFqk
	ouswK6GFunreaxHVI0etSydNYso8n2Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MQ1qcXKS;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768024647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=REF+u4YTsPHawUr3c4q3EL7vHCl7YHh8jLoPiwjnQGU=;
	b=G8UuHcNbbz1zx9O9lxY/k9WaGD8FW22Kj4PWplV8iJdcQNPD5DlZV/qHPMr0BfBzeVAr7r
	syiNGinnK7LQXRFCYwm5MgnnatuaX4JJzlK6gke+GAm6x0SudoIKIlvW/NxWOphGua2YgQ
	8QGg+Y9dKTa6ke/Uv0BJamVa0tYXqRk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768024646; x=1799560646;
  h=date:from:to:cc:subject:message-id;
  bh=a/+sgHTrX74Xx360QGLqYXNKPMSPEIP/0jGgPeJyLWU=;
  b=MQ1qcXKS69l2mkrTFLQeYBATYvd17Vj7TZl85zzk6T0raus2PtAl1OJ6
   eHvfptS3lGuHQEQms9dnw4R5O6dPf/5cb0jogJf6GOqpWp/1oAwnyFUqS
   63OE6H4zcp4k0eNDrwuCxt1z7Ya72kJ6DuIp/SAw2KESEQH9U3ayQNnuB
   Amz9edJudPnApyt5DCO/lpETEdWL2usVUVrAWYlBxLGt583ih8FEGFaSG
   oGlZ8L25uZEWmWkk5Ae2U5d5rqrZ7nP4Dparf5rByG1LdEcSnEyr+zeS5
   E0hdOqbyWPWjlgCt0xGaTmSkxFNF4o0Egl7jGX1KOi8QujvCB8NIwQFbx
   A==;
X-CSE-ConnectionGUID: 9fy0NKRkQPaucMRDsd/rmQ==
X-CSE-MsgGUID: 3SvvvynGS4KTB0gSYCg38Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="68597422"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="68597422"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 21:57:25 -0800
X-CSE-ConnectionGUID: bg21vR9oRZiWGdM0LdeGMA==
X-CSE-MsgGUID: tCMACqMpQG+xmj3V0lFC6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="208470740"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 09 Jan 2026 21:57:24 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1veRyT-000000008FZ-41Tu;
	Sat, 10 Jan 2026 05:57:21 +0000
Date: Sat, 10 Jan 2026 13:56:49 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 f417b7ffcbef7d76b0d8860518f50dae0e7e5eda
Message-ID: <202601101343.opc6iPsU-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5A1E5A0009
X-Stat-Signature: fc6ybrz3ef4ouo1ygwwj4nns5xjf6gry
X-Rspam-User: 
X-HE-Tag: 1768024646-566888
X-HE-Meta: U2FsdGVkX18dWt+4qoA+qdN70M+54LZkk4zH0FBEOJEx+4pGaBsU7MqD7yci8uExDIDCx/oIud52x1nU/kpUTXVt/ms7/EsgLYJTvr8u0Fg5hMDKwWLijg8kJJtuRoCNHazab2P3EYK0i3BapZ2zA8oxCmjr9hHM1+wtPddyci2GGtwZ6z536xrbQfpd5XdOxjpTL3xmJBp7F8h1UqwHgAio4htXD5roSE6kHLPbhsDIjX1xlNrCvGaXbSmAAX1Q35QpHS/zwuDTrdLMG6TOf1pRojgMGmID22OLrVrWKjkeEcxw80gfQ8xTJdVGYWjXYF6LGbb8mvWj4I4Jg58wFLaVNOrP9GKhayNJ992AV1mw7fha98QxTIWr1YkCFsQOdlQJ+OqmrJ76/qDy5B488ORdHffbFaAdtwR5C04o7V3jw39kmEkU5h6luBqvTQ39h8RtizpsjHbR3lDaC8TvTx7ohSolmH7BEN04VfRS20CE3j0EcO5hZrO/li4JA65q1e62IZIQvWISeYR6QWamj7r5/b+GESUIMeAFBx4m3hrabfYp3cL2iEtBG4xWffDC6rf9NueZwvnPJWozRE3ODtnLtavdcYX0nooA9nm+Ye4e/ucwg043IMJPUb3rGrUs/x6Ks/F338P/zhS9k4qDNLdSAs4w0NluQD3rGLyzi1k75XC/KjcefAnisrOSf2e8t0MlkW4ogc3Ty4v3ex3BKvuL3hbPQ+s8Diu3E4DB1CtmDTRL9xN3TJ0ptM4RwWi58PAOEAEj/vR+iK40aWw4cTFXvUIOVv5CWG9fZdz6o76HpJBeJAUMVKTQQgcta4VaidVuvjOkBb75E7HZX6GpwkcZ3x0v3XrrNnTYhhKBoN/ohJaUSu3uHJXilukuka9ZOLoH0KcvhbV359vUnwFihd0+qtV5rei8UzgOQd8fraro4EVnMDTAryge2vyVBH53tEZeNDqn7GEVqIDPJLJ
 To+tcuWN
 Umep8ItH8cNAbVCDasB9Vjw/oZnzuTas9rRs2b9fM/PMk3Zswalq9kRDSGQhWFCxVMX35NAZF/5nHDO4zhMTpl623COnYYkrflLhHBCjYptfSU7o2lCAgn16dFw39DE4mKbuV5sJSZv1Ecz2kuy9oqnMQW/rtji3Z+W71
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: f417b7ffcbef7d76b0d8860518f50dae0e7e5eda  Add linux-next specific files for 20260109

Unverified Warning (likely false positive, kindly check if interested):

    drivers/i2c/busses/i2c-designware-slave.c:282:1: sparse: sparse: bad integer constant expression
    lib/tests/glob_kunit.c:121:1: sparse: sparse: bad integer constant expression

Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r113-20260109
|   `-- drivers-i2c-busses-i2c-designware-slave.c:sparse:sparse:bad-integer-constant-expression
`-- microblaze-randconfig-r123-20260109
    `-- lib-tests-glob_kunit.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 1536m

configs tested: 139
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260109    gcc-13.4.0
arc                   randconfig-002-20260109    gcc-9.5.0
arm                               allnoconfig    clang-22
arm                       aspeed_g4_defconfig    clang-22
arm                                 defconfig    clang-22
arm                   randconfig-001-20260109    gcc-10.5.0
arm                   randconfig-002-20260109    gcc-15.2.0
arm                   randconfig-003-20260109    gcc-8.5.0
arm                   randconfig-004-20260109    gcc-11.5.0
arm                           spitz_defconfig    gcc-15.2.0
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260109    clang-22
arm64                 randconfig-002-20260109    clang-22
arm64                 randconfig-003-20260109    gcc-11.5.0
arm64                 randconfig-004-20260109    gcc-8.5.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260109    gcc-9.5.0
csky                  randconfig-002-20260109    gcc-15.2.0
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20260109    clang-22
hexagon               randconfig-002-20260109    clang-17
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20260109    clang-20
i386        buildonly-randconfig-002-20260109    gcc-14
i386        buildonly-randconfig-003-20260109    gcc-14
i386        buildonly-randconfig-004-20260109    clang-20
i386        buildonly-randconfig-005-20260109    gcc-12
i386        buildonly-randconfig-006-20260109    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20260109    gcc-14
i386                  randconfig-002-20260109    gcc-14
i386                  randconfig-003-20260109    gcc-12
i386                  randconfig-004-20260109    gcc-14
i386                  randconfig-005-20260109    gcc-14
i386                  randconfig-006-20260109    clang-20
i386                  randconfig-007-20260109    gcc-14
i386                  randconfig-011-20260109    clang-20
i386                  randconfig-012-20260109    gcc-14
i386                  randconfig-013-20260109    clang-20
i386                  randconfig-014-20260109    gcc-14
i386                  randconfig-015-20260109    clang-20
i386                  randconfig-016-20260109    clang-20
i386                  randconfig-017-20260109    clang-20
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260109    clang-22
loongarch             randconfig-002-20260109    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                                defconfig    gcc-15.2.0
m68k                           sun3_defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                          defconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                     decstation_defconfig    gcc-15.2.0
mips                        vocore2_defconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260109    gcc-8.5.0
nios2                 randconfig-002-20260109    gcc-8.5.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260109    gcc-12.5.0
parisc                randconfig-002-20260109    gcc-15.2.0
parisc64                            defconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260109    clang-22
powerpc               randconfig-002-20260109    clang-22
powerpc                      tqm8xx_defconfig    clang-19
powerpc64             randconfig-001-20260109    gcc-15.2.0
powerpc64             randconfig-002-20260109    gcc-8.5.0
riscv                             allnoconfig    gcc-15.2.0
riscv                               defconfig    clang-22
riscv                 randconfig-001-20260109    gcc-14.3.0
riscv                 randconfig-002-20260109    gcc-8.5.0
s390                              allnoconfig    clang-22
s390                                defconfig    clang-22
s390                  randconfig-001-20260109    clang-22
s390                  randconfig-002-20260109    clang-22
s390                       zfcpdump_defconfig    clang-22
sh                                allnoconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                        dreamcast_defconfig    gcc-15.2.0
sh                    randconfig-001-20260109    gcc-14.3.0
sh                    randconfig-002-20260109    gcc-13.4.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260109    gcc-8.5.0
sparc                 randconfig-002-20260109    gcc-13.4.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260109    gcc-8.5.0
sparc64               randconfig-002-20260109    clang-20
um                                allnoconfig    clang-22
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260109    gcc-14
um                    randconfig-002-20260109    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64      buildonly-randconfig-001-20260109    clang-20
x86_64      buildonly-randconfig-002-20260109    gcc-14
x86_64      buildonly-randconfig-003-20260109    gcc-14
x86_64      buildonly-randconfig-004-20260109    gcc-14
x86_64      buildonly-randconfig-005-20260109    gcc-14
x86_64      buildonly-randconfig-006-20260109    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260109    clang-20
x86_64                randconfig-002-20260109    clang-20
x86_64                randconfig-003-20260109    gcc-14
x86_64                randconfig-004-20260109    clang-20
x86_64                randconfig-005-20260109    clang-20
x86_64                randconfig-006-20260109    gcc-14
x86_64                randconfig-011-20260109    gcc-12
x86_64                randconfig-012-20260109    clang-20
x86_64                randconfig-013-20260109    gcc-14
x86_64                randconfig-014-20260109    gcc-14
x86_64                randconfig-015-20260109    gcc-12
x86_64                randconfig-016-20260109    gcc-14
x86_64                randconfig-071-20260109    gcc-14
x86_64                randconfig-072-20260109    clang-20
x86_64                randconfig-073-20260109    gcc-14
x86_64                randconfig-074-20260109    gcc-14
x86_64                randconfig-075-20260109    gcc-14
x86_64                randconfig-076-20260109    gcc-12
x86_64                               rhel-9.4    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
xtensa                            allnoconfig    gcc-15.2.0
xtensa                randconfig-001-20260109    gcc-12.5.0
xtensa                randconfig-002-20260109    gcc-14.3.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

