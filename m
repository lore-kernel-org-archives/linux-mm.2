Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB8DCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 03:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA15E6B0088; Thu,  1 Oct 2026 23:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53246B008A; Thu,  1 Oct 2026 23:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45686B008C; Thu,  1 Oct 2026 23:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4E716B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:41:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BDCBC061A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:41:35 +0000 (UTC)
X-FDA: 85276286550.21.9F2E010
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8DF36120006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:41:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SvgIe+oT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790912493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/VH5FyCktp8PpzsBJl2pEm00RAakZ3MKDV9fHAkzrxE=;
	b=NN8FrEf7lRe8yZt3tCfyoIn15UtvZjrplwNcHa8DCxiwaZpq6Oq3FDp64tg+bgL6IuG89k
	y5hlZlmFe+ACjUKLysjMMuXtTLbfKIznAdP/naxwI2ABcxYmytBfuqL+LhNDWTFnbGUikg
	SUQNy7cXEumPniUZfbdsJ63Pr42b7X4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SvgIe+oT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790912493;
	b=Cuho3X8rn7msUfhM7lHaTMVN1eja0H8e2pAvNa+MS3py/uNa9L50hHLnSvotq0xKEgUgxT
	K9V0cgHfNtEPoQLO3bZo38+07lG9OmdMnptsw/tIFDwWJnDRazYBbTR8LTTXRDMWcSU2E1
	qmV0nJL1bBf/XikNW2qOO8VPPPPeGJk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790912493; x=1822448493;
  h=date:from:to:cc:subject:message-id;
  bh=c0DaZbITOuajcSNWCM8zpyYtyss46YRn2NudfMy31Lo=;
  b=SvgIe+oT69ADukXVtm4QvfdsWOryAsMbb4bReqitq4Zl2C2xbXYygjnJ
   UeO3tGSwGC1GGwQ93SzfZFcTCvd+yQ03rrLOrCvJuUNndbhZE2wXTdDFl
   dxriKui7oVPNF0qfw+RZ1Ex/56fM5Q3lkOrusNx6r6c9uQDJmsswrcrnt
   Rv7X9MSxjnKEGTpSoEhRS+gfeAG4YKRQL5jGai0BF11g12dK+Yj6U96DU
   uYQG76+Q0GuuiV6Aw6ndoWGB4wjiXJ7k8Zw0fBMSdnUyQ8zferZT9amqB
   E7nvJC50KHsMk7p3cMDHafaMb39ZrsmHPPKA5T9GC7uWReQPkwcO2r1bL
   A==;
X-CSE-ConnectionGUID: sAdlDhmqR6C5vXDB6Upe4w==
X-CSE-MsgGUID: 4UfSbUPpRESDz6Xe2wh/Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90818543"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="90818543"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 20:41:27 -0700
X-CSE-ConnectionGUID: 4rcMFL9HRZmIMtYX749d6A==
X-CSE-MsgGUID: JDqhaByISp20zI+SATsbrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="172709"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 01 Oct 2026 20:41:25 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xCU9C-00000000ScD-2DRv;
	Fri, 02 Oct 2026 03:41:22 +0000
Date: Fri, 02 Oct 2026 11:40:24 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 21c3620df8ad362e9f2069ac35577c2a2f782f33
Message-ID: <202610021120.LED8YkcD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 8DF36120006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i3uey6cjucp75p4r5xgybaruk6b6zbg5
X-HE-Tag: 1790912492-173226
X-HE-Meta: U2FsdGVkX1+kOPZHVGhFaZGNTimmqySSXfvKSPf7hJtucA/QnfeukgsTB2n/Xi8L0Hd17x2csAo9PdggN+lGt1g4rq3/hHthiBtKNcoNDDfbrKT6Ra5olcuMWzkD3m0JdI82ttAk0U/fad13eqSuJg0A01XcySM6zQHht4VLNdkfBGpFTm5VcY5d+8GOpQZy077lRJVjbpcRNxZZSUBlAy+P7veAx7LvwbL2bV6Ukp2bviwNo2/EIKupt8ACc8OZUpfi/wpp4Ea3+7yMscrPbvZhVyhVwV24WkAAm6kbCcACiyCux69ZOSCgi+vI8zQsrltpyrLraAdFqtzHz4I1IyAyYSeEW2fTQDokfzz9+r3yHbrlcsrHl/hw2P/Ck0PFnxzrVnbJnaxeEDYJFkjwtWqGB+emSJCGn7FQEYVulYtfKYqDwdNMRS8zhk8EPhI4fl5fsM3fjZZa5sVTx1PQjIswrAE9uk/IlOKrkbLh/eB0vnhduxbAyqd6HAtl4wYDZ8mLXPDofvUo4iAZVQU8xXCx2fn+YwV8JN0SPNaCG4mIuNliQCgSvmWoFiYCIqktM7p7s/zXpvqr9Jtshi1TMdmGNab2Aa4wFOG6fS7sDTA56UG/o2n/ZhOFrtpbkttN+XTvE/yBVPPnyTfUjp5B6NTitRWMzBHRsJ0WQrY+A2DBMy29yQBy0GuimX7Arj5C2FW98s/i+/NPsKk0VJyY886w5j3k3yvQY7eWbAPUiHJnmcqcLJOF9s82WHNkJxgSY2Y8jffs5EN9cXFWUgxnf+ysHQQZno8hTeo9KA8vJ7zmVkkpXr9nu+8QJsmIGNWvFoVtitGBpSgdqaHrM2HAOy8xOPMmFTlZf+HAtEfumlqykBaB9hcX/vU8lu6UYDT6mx4ubq4d1G119xzugklP8ItMf6RdEeb+qufaYeSBb949sQ872epi4odXsC3Ebmq+ehNA5um693p08Zmnf3O
 Dcd9LnDX
 pGzvdsTxr56sc4RzdoatxAbwADfJG/KLASmyzgDxuBXwRF2yTQ3sgn3/EqtC9xKuPYN7a5IDGRnozswK6kJW4P9li+m3iVSlEPY/2TcMQLQKTv95DCT9r4xmluuHjRja80LlyNaJ0IIEFCpcPIC/WH02U3UV5eWs9HWNc6qBNubZhhb/kUyGtFP/YRguNsd7fFoIDFaGYZrarIKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 21c3620df8ad362e9f2069ac35577c2a2f782f33  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 747m

configs tested: 220
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2105-20261001    gcc-15.2.0 cocci
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261001    gcc-15.2.0
arc                   randconfig-1001-20261001    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261001    gcc-13.4.0
arm                   randconfig-1001-20261001    clang-21
arm                   randconfig-1002-20261001    gcc-13.4.0
arm                   randconfig-1003-20261001    gcc-8.5.0
arm                         realview_defconfig    clang-17
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261001    gcc-8.5.0
arm64                 randconfig-1001-20261001    gcc-10.5.0
arm64                 randconfig-1002-20261001    gcc-8.5.0
arm64                 randconfig-1003-20261001    gcc-8.5.0
arm64                randconfig-r2201-20261001    gcc-16.1.0 smatch
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261001    gcc-15.2.0
csky                  randconfig-1001-20261001    gcc-9.5.0
csky                 randconfig-r2305-20261001    gcc-15.2.0 sparse
csky                 randconfig-r2309-20261001    clang-24   sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261001    clang-20
hexagon               randconfig-1001-20261001    clang-20
hexagon              randconfig-r2103-20261001    clang-24   cocci
hexagon              randconfig-r2304-20261001    gcc-15.2.0 sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261001    gcc-13
i386        buildonly-randconfig-1001-20261001    clang-22
i386        buildonly-randconfig-1002-20261001    gcc-14
i386        buildonly-randconfig-1003-20261001    clang-22
i386        buildonly-randconfig-1004-20261001    clang-22
i386        buildonly-randconfig-1005-20261001    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261001    gcc-13
i386                  randconfig-1001-20261001    gcc-14
i386                  randconfig-1002-20261001    clang-22
i386                  randconfig-1003-20261001    gcc-14
i386                  randconfig-1004-20261001    gcc-14
i386                  randconfig-1005-20261001    gcc-14
i386                  randconfig-1006-20261001    clang-22
i386                  randconfig-1007-20261002    gcc-14
i386                  randconfig-1008-20261002    clang-22
i386                  randconfig-1009-20261002    clang-22
i386                  randconfig-1010-20261002    clang-22
i386                  randconfig-1011-20261002    clang-22
i386                  randconfig-1012-20261002    gcc-14
i386                  randconfig-1013-20261002    clang-22
i386                  randconfig-2100-20261001    gcc-14     cocci
i386                  randconfig-2101-20261001    gcc-14     cocci
i386                  randconfig-2102-20261001    gcc-14     cocci
i386                  randconfig-2103-20261001    gcc-14     cocci
i386                  randconfig-2200-20261001    clang-22   smatch
i386                  randconfig-2300-20261001    gcc-14     sparse
i386                  randconfig-2301-20261001    gcc-14     sparse
i386                  randconfig-2302-20261001    gcc-14     sparse
i386                 randconfig-r2308-20261001    clang-24   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261001    clang-18
loongarch             randconfig-1001-20261001    clang-24
loongarch            randconfig-r2107-20261001    gcc-15.2.0 cocci
loongarch            randconfig-r2302-20261001    gcc-15.2.0 sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2202-20261001    gcc-8.5.0  smatch
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                       maltasmvp_defconfig    gcc-16.1.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261001    gcc-11.5.0
nios2                 randconfig-1001-20261001    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261001    gcc-13.4.0
parisc                randconfig-1001-20261001    gcc-15.2.0
parisc               randconfig-r2102-20261001    clang-24   cocci
parisc               randconfig-r2104-20261001    gcc-15.2.0 cocci
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                     amigaone_defconfig    gcc-16.1.0
powerpc                        eiger_defconfig    clang-24
powerpc                    lite5200b_defconfig    clang-24
powerpc                  mpc836x_rdk_defconfig    clang-24
powerpc               randconfig-1000-20261001    clang-24
powerpc               randconfig-1001-20261001    gcc-12.5.0
powerpc              randconfig-r2303-20261001    gcc-15.2.0 sparse
powerpc64             randconfig-1000-20261001    gcc-16.1.0
powerpc64             randconfig-1001-20261001    gcc-14.3.0
powerpc64            randconfig-r2307-20261001    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261001    gcc-14.3.0
riscv                 randconfig-1001-20261001    gcc-12.5.0
riscv                 randconfig-2000-20261001    gcc-10.5.0
riscv                 randconfig-2001-20261001    gcc-10.5.0
riscv                randconfig-r2300-20261001    gcc-15.2.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261001    gcc-10.5.0
s390                  randconfig-1001-20261001    clang-24
s390                  randconfig-2000-20261001    gcc-10.5.0
s390                  randconfig-2001-20261001    gcc-10.5.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                             hp6xx_defconfig    gcc-16.1.0
sh                    randconfig-1000-20261001    gcc-15.2.0
sh                    randconfig-1001-20261001    gcc-9.5.0
sh                    randconfig-2000-20261001    gcc-10.5.0
sh                    randconfig-2001-20261001    gcc-10.5.0
sh                   randconfig-r2301-20261001    gcc-15.2.0 sparse
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261002    gcc-12.5.0
sparc                 randconfig-1001-20261002    gcc-16.1.0
sparc                 randconfig-2000-20261001    clang-24
sparc                 randconfig-2001-20261001    clang-24
sparc                randconfig-r2101-20261001    clang-24   cocci
sparc                randconfig-r2106-20261001    gcc-15.2.0 cocci
sparc                randconfig-r2200-20261001    gcc-8.5.0  smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261002    gcc-8.5.0
sparc64               randconfig-1001-20261002    gcc-11.5.0
sparc64               randconfig-2000-20261001    clang-24
sparc64               randconfig-2001-20261001    clang-24
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261002    clang-24
um                    randconfig-1001-20261002    clang-24
um                    randconfig-2000-20261001    clang-24
um                    randconfig-2001-20261001    clang-24
um                   randconfig-r2100-20261001    clang-24   cocci
um                   randconfig-r2306-20261001    clang-24   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261001    clang-22
x86_64      buildonly-randconfig-1001-20261001    clang-22
x86_64      buildonly-randconfig-1002-20261001    gcc-13
x86_64      buildonly-randconfig-1003-20261001    clang-22
x86_64      buildonly-randconfig-1004-20261001    clang-22
x86_64      buildonly-randconfig-1005-20261001    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261001    clang-22
x86_64                randconfig-1001-20261001    clang-22
x86_64                randconfig-1002-20261001    gcc-14
x86_64                randconfig-1003-20261001    clang-22
x86_64                randconfig-1004-20261001    clang-22
x86_64                randconfig-1005-20261001    clang-22
x86_64                randconfig-1006-20261002    clang-22
x86_64                randconfig-1007-20261002    gcc-14
x86_64                randconfig-1008-20261002    gcc-14
x86_64                randconfig-1009-20261002    gcc-12
x86_64                randconfig-1010-20261002    clang-22
x86_64                randconfig-1011-20261002    clang-22
x86_64                randconfig-1012-20261001    clang-22
x86_64                randconfig-1013-20261001    gcc-14
x86_64                randconfig-1014-20261001    gcc-12
x86_64                randconfig-1015-20261001    clang-22
x86_64                randconfig-1016-20261001    clang-22
x86_64                randconfig-1017-20261001    clang-22
x86_64                randconfig-2100-20261001    gcc-14     cocci
x86_64                randconfig-2101-20261001    gcc-14     cocci
x86_64                randconfig-2102-20261001    gcc-14     cocci
x86_64                randconfig-2103-20261001    gcc-14     cocci
x86_64                randconfig-2200-20261001    clang-22   smatch
x86_64                randconfig-2300-20261001    gcc-14     sparse
x86_64                randconfig-2301-20261001    gcc-14     sparse
x86_64                randconfig-2302-20261001    gcc-14     sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261002    gcc-14.3.0
xtensa                randconfig-1001-20261002    gcc-8.5.0
xtensa                randconfig-2000-20261001    clang-24
xtensa                randconfig-2001-20261001    clang-24
xtensa                     xip_kc705_defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

