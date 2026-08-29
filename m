Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A450C61DC4
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 03:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78EB96B0088; Fri, 28 Aug 2026 23:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F22F6B008A; Fri, 28 Aug 2026 23:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0AF6B008C; Fri, 28 Aug 2026 23:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3622E6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:46:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C77AFA0632
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:46:51 +0000 (UTC)
X-FDA: 85152920622.30.5EFCD59
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2C50180003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:46:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Go+hhcgt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787975210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=8fxnAi36CxakzKmU2fHHvMwPwirjyz5dgSGaovBOkyE=;
	b=DhAbMRLOslk0dQ2ZERX/nDJg89+ETSWVoGF650M8YZjmOtNMqnzkjvsJ9qoyDYkkvl+0Fw
	2tH4+Bz8teKii/+IUrlro4xe3GObmIztCCfsgrwT+PpDTOtiAWRASoZ6vCu/u1pSWrZAA/
	91S/yKOAk+729wvEc56UsBrX2yMjI44=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787975210;
	b=5Zcj3pHLVBrC0OIdVmBWgAtXs6WOgV1WSxmnZyqsKXY8XTfijZQUju+duOJIUSttRqiuCp
	3mruVtGDDJ6oXZ8zeYkb1FaqRBlB69DKTaj/ZwYog64FuvDN+5PT0eRC/13HiO0x1OPJI+
	D6ndGnBtHW2uDUegnF6h4vAbuJoiGRs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Go+hhcgt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787975209; x=1819511209;
  h=date:from:to:cc:subject:message-id;
  bh=YPXV2j0gHNX5kjECiKi+VeMyw+i6MFQWhqUcoGF3NJc=;
  b=Go+hhcgtImsBlXAw2aciAICbPF9HOivCZrQ3ItlB2nul5i5tDi9IG1IH
   UdDMx+Q5Q6rfTH5zyP4HVUlDiwni/hOkHpndX3VHrXi8KeOBSx8iXQN5e
   44CWlkmIQgBxLVJEGPOabWIZyH3xp91SQnbukMyr/j1fFRf6B6139N8U9
   7b2cRFEUlfM8LY7kKgS3pdME42/4qBcm9eenlkgNoWOZ6tiSV+E8h5kGs
   T18NSIi1CwVmmpzlt8iCz30Rvdm649y0jcRJpiIdYuqHo/YTUGU7s7viR
   WiLPRijX+qszfziVCChaM0ErTBJLFXJR+dMdrVx5nq2TPQMFNj1hqWmDZ
   Q==;
X-CSE-ConnectionGUID: yA67xanaThixhIVVEzACpA==
X-CSE-MsgGUID: eOE3fMVpSd6YnrPhxBRWKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="92345536"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="92345536"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 20:46:48 -0700
X-CSE-ConnectionGUID: LY4N4t5zTgaq6Lh7sPNXyA==
X-CSE-MsgGUID: 8rNRtkWXRdWsMEZ4KlyVEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="271842182"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 28 Aug 2026 20:46:47 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0A1k-00000000CLY-1wBB;
	Sat, 29 Aug 2026 03:46:44 +0000
Date: Sat, 29 Aug 2026 11:46:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 e30626823a406725ce29bc75cb8ec467d3e1e326
Message-ID: <202608291153.snZNwRZV-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C50180003
X-Stat-Signature: 6ketn7ig7uitz4cefgdzpouszaygu68x
X-Rspam-User: 
X-HE-Tag: 1787975208-639730
X-HE-Meta: U2FsdGVkX1+/9FHg3hGTCHuFOD+1ijkZYhDGk4wZehD1H0nZP7qxmvTOYKXEXU3flEaV0XQ0lIYUKPdIwDEoKhAF6o3PrKGUa6cqqzFRDwRCZ3xkbJ6+rBn2RKYGTOpbkmQ4+FPNIuWJ+xzxOeUty9DNkgis4f+18zifZE7nrjrhijgmoJ+X8z7ZSlpl7YU6Xnm3LD8IbulriExFvyxiOMyebj2lc5vZOYjzC8Arge+sXu6ye0MjdPVintoufDB12pVeqRVCoBB1gdHAAix6+v7a1RG0tCv0EGMT8qPRXv8VxNFgdJZutmtEY7qJt/tF8ru/1vLVpRxLDykTICUM7KDVRDoG986fKsPAKt8HmDGL0M9Out2nalJ4F/0OwTExSBxLHbilW+Y5W0OA9TiiPr2GkmXGQir/cV3jTuupfGtfjQ5FqN6zdIFdi4iy8Y628ivuP2q6LLrg8C6T4xQyPmgNUu45W3puuri8AMrK8sADvuv5kw+J10WHariq4/xYv9QU/lu+SP0hzHJU5p0TfAHvZF3b3FopcrpSPmrfRvG6xA+eRrlDrXZaUHK/6WgkUgRPxtZrceZWiSvJNT4Vdg8C765xni/HwQKFJnHY/8kYorj+q3xv/P3fNHDekTbNqqRI/RNWLBz3qIWzX48b+ssImV2wjMLo/xA/2Ko7cPYGD6vIlEWU8gaT78L2vpqc6f0dsqH2TVCecc8sZQ8BSiCSIzTDq4JgeNg8YqT1MiDOxzJ2bxmDbGT+E/t7pgN2ZAAV1gVLhOnXCO6ogSgAClpdvWl8pFl83LPhUgQENFacLTvZve8bU6BbRBujgfQ0SKsfFb6qGYin0xbMJFTYqsiMNBlUqMC9nT3ajMG5NfldltXLOITRhU+E9OygUDp4OkXQKDkRvPeYakyGNUCQpWFGiJkGegh6b6A65CbMhZF+F2gedOB/wr+xcRNkV77LgnGgaCbc7kJEs1GNPtB
 xIG1QOXR
 DCfRK+/JQ1Xkjj0rcKmUaGdpijRam6XypM7G4mhbuWzDKzu9NjMT8MY6+OGNTpGumn5vvfIcw2zoXpbBnKIw2cUtaZIVfSupBLEkUFsaoC0HMhIE9nlW9F36OIzduvE5ewN/2R0/yCxbyTbmHvA/o6OsklCA77H4J1a0+hv9yehTCB7xYOoHkr6ub393JY8u5CtPRjK80AMz6MFc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: e30626823a406725ce29bc75cb8ec467d3e1e326  Add linux-next specific files for 20260828

elapsed time: 754m

configs tested: 120
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha               allnoconfig    gcc-16.1.0
alpha              allyesconfig    gcc-16.1.0
alpha                 defconfig    gcc-16.1.0
arc                allmodconfig    clang-24
arc                allmodconfig    gcc-16.1.0
arc                 allnoconfig    gcc-16.1.0
arc                allyesconfig    clang-24
arc                allyesconfig    gcc-16.1.0
arc                   defconfig    gcc-16.1.0
arm                 allnoconfig    clang-17
arm                 allnoconfig    gcc-16.1.0
arm                allyesconfig    clang-24
arm                allyesconfig    gcc-16.1.0
arm                   defconfig    clang-24
arm64              allmodconfig    clang-24
arm64               allnoconfig    gcc-16.1.0
arm64                 defconfig    gcc-16.1.0
csky               allmodconfig    gcc-16.1.0
csky                allnoconfig    gcc-16.1.0
csky                  defconfig    gcc-16.1.0
hexagon            allmodconfig    clang-24
hexagon            allmodconfig    gcc-16.1.0
hexagon             allnoconfig    clang-24
hexagon             allnoconfig    gcc-16.1.0
hexagon               defconfig    clang-24
i386               allmodconfig    clang-22
i386               allmodconfig    gcc-14
i386                allnoconfig    gcc-14
i386                allnoconfig    gcc-16.1.0
i386               allyesconfig    clang-22
i386               allyesconfig    gcc-14
i386                  defconfig    clang-22
loongarch          allmodconfig    clang-19
loongarch          allmodconfig    clang-24
loongarch           allnoconfig    clang-20
loongarch           allnoconfig    gcc-16.1.0
loongarch             defconfig    clang-24
m68k               allmodconfig    gcc-16.1.0
m68k                allnoconfig    gcc-16.1.0
m68k               allyesconfig    clang-24
m68k               allyesconfig    gcc-16.1.0
m68k                  defconfig    gcc-16.1.0
microblaze          allnoconfig    gcc-16.1.0
microblaze         allyesconfig    gcc-16.1.0
microblaze            defconfig    gcc-16.1.0
mips               allmodconfig    gcc-16.1.0
mips                allnoconfig    gcc-16.1.0
mips               allyesconfig    gcc-16.1.0
nios2              allmodconfig    clang-20
nios2              allmodconfig    gcc-11.5.0
nios2               allnoconfig    clang-24
nios2               allnoconfig    gcc-11.5.0
nios2                 defconfig    gcc-11.5.0
openrisc           allmodconfig    clang-20
openrisc           allmodconfig    gcc-16.1.0
openrisc            allnoconfig    clang-24
openrisc            allnoconfig    gcc-16.1.0
openrisc              defconfig    gcc-16.1.0
parisc             allmodconfig    gcc-16.1.0
parisc              allnoconfig    clang-24
parisc              allnoconfig    gcc-16.1.0
parisc             allyesconfig    clang-17
parisc             allyesconfig    gcc-16.1.0
parisc                defconfig    gcc-16.1.0
parisc64              defconfig    gcc-16.1.0
powerpc            allmodconfig    gcc-16.1.0
powerpc             allnoconfig    clang-24
powerpc             allnoconfig    gcc-16.1.0
riscv              allmodconfig    clang-24
riscv               allnoconfig    clang-24
riscv               allnoconfig    gcc-16.1.0
riscv              allyesconfig    clang-24
riscv                 defconfig    clang-24
s390               allmodconfig    clang-17
s390               allmodconfig    clang-24
s390                allnoconfig    clang-24
s390               allyesconfig    gcc-16.1.0
s390                  defconfig    clang-18
sh                 allmodconfig    gcc-16.1.0
sh                  allnoconfig    clang-24
sh                  allnoconfig    gcc-16.1.0
sh                 allyesconfig    clang-17
sh                 allyesconfig    gcc-16.1.0
sh                    defconfig    gcc-14
sh                    defconfig    gcc-16.1.0
sparc               allnoconfig    clang-24
sparc               allnoconfig    gcc-16.1.0
sparc64            allmodconfig    clang-20
sparc64               defconfig    clang-24
sparc64               defconfig    gcc-14
um                 allmodconfig    clang-17
um                  allnoconfig    clang-17
um                  allnoconfig    clang-24
um                 allyesconfig    gcc-14
um                 allyesconfig    gcc-16.1.0
um                    defconfig    clang-24
um                    defconfig    gcc-14
um               i386_defconfig    gcc-14
um             x86_64_defconfig    clang-24
um             x86_64_defconfig    gcc-14
x86_64             allmodconfig    clang-22
x86_64              allnoconfig    clang-22
x86_64              allnoconfig    clang-24
x86_64             allyesconfig    clang-22
x86_64                defconfig    gcc-14
x86_64                    kexec    clang-22
x86_64                 rhel-9.4    clang-22
x86_64                 rhel-9.4    gcc-14
x86_64             rhel-9.4-bpf    gcc-14
x86_64            rhel-9.4-func    clang-22
x86_64            rhel-9.4-func    gcc-14
x86_64      rhel-9.4-kselftests    clang-22
x86_64      rhel-9.4-kselftests    gcc-14
x86_64           rhel-9.4-kunit    gcc-14
x86_64             rhel-9.4-ltp    gcc-14
x86_64            rhel-9.4-rust    clang-22
xtensa              allnoconfig    clang-24
xtensa              allnoconfig    gcc-16.1.0
xtensa             allyesconfig    clang-20
xtensa             allyesconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

