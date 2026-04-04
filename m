Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA45E88D7A
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 04:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403C96B0005; Sat,  4 Apr 2026 00:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B4C06B0089; Sat,  4 Apr 2026 00:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3466B008A; Sat,  4 Apr 2026 00:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15F456B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 00:00:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A69EF8C3FC
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:00:10 +0000 (UTC)
X-FDA: 84619520580.28.C070DC0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5ECE81A0006
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:00:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RIJrwUUG;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775275208; a=rsa-sha256;
	cv=none;
	b=5A8IVzP1s4NHS77JiQEVjAaLMTBcgCdu8CIGEVsKSo5jhFp8NpGCpPdMuas1j9jT0SiiOO
	uGq6Phz0HgdnKIbssgL9H3MuIBsyEfPOMAs+ervbfITbOeijdTpjeJ7ewltc8FdwYHHuxM
	ZJVTSQyIOsChriTDRmWqdHLXLL0uI7I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RIJrwUUG;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775275208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Tc4sL9k4AhApMxI9qKavwqKQiaM5ORn3SNvfd8wL+gY=;
	b=2CBzm/JsOvtxHWH++72nUUhlB7HYl6RYZQX/kYHFvWZ48l5cvpFadOTW+D5AQx9bDYymLc
	OuriXng5EwDBHUtQ89nG0IdrpxB3dmKCHBwIZy0w8Al01nadCz/OMukr/lq51tyeBq33cG
	6qdDopbTnZjo0QtpMgiiD7qX3B7Uy8E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775275208; x=1806811208;
  h=date:from:to:cc:subject:message-id;
  bh=/m2FqjN12dn5JTUf5dEr6pTpsPWXVDl4tuzkicLr6qw=;
  b=RIJrwUUGscAFmCPsJ232YrisWW6Ylo7JeScB7XKssWu6gWlih4TOgP3w
   6goWW0/fUae4SLUHiSp4fuEmAJ/noNZeNNJ2m8GANZ+Jz9P9NsHAHqjpN
   vM/J1yIBLCeiPgCSCeQARXh0FqVBhr9DYaBNTAZPtonSZDyBdnEoMJzJS
   Eft7sTocwZyjV/JMEn8HLEEFmwLpWikQhERDVGq7r9OBByHKa51BBupe4
   uKqefZYu9tNj0tt/eY3oah05jp066R48h8w/lw6NxHFueNEZYZFI+dLcr
   j/GAlTFSRoi7WRFOEpgv2N5lptJDuvFL6ezIhsmvJfLdr1xSK+9jhYZVl
   A==;
X-CSE-ConnectionGUID: oy4mFEMkQtC+KyV8iodoUQ==
X-CSE-MsgGUID: xNLRd7DMRLKoVlHIexsEKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="63879154"
X-IronPort-AV: E=Sophos;i="6.23,159,1770624000"; 
   d="scan'208";a="63879154"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 21:00:06 -0700
X-CSE-ConnectionGUID: X/KaCaXmRcmpVFv4YnypxA==
X-CSE-MsgGUID: FcXHfSOTTp+VN96MtEolOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,159,1770624000"; 
   d="scan'208";a="250636899"
Received: from lkp-server01.sh.intel.com (HELO 3afb7d003cac) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 03 Apr 2026 21:00:04 -0700
Received: from kbuild by 3afb7d003cac with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w8sB0-000000000Tp-0cAz;
	Sat, 04 Apr 2026 04:00:02 +0000
Date: Sat, 04 Apr 2026 11:59:59 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH WARNING
 2febe6e6ee6e34c7754eff3c4d81aa7b0dcb7979
Message-ID: <202604041147.TNwsmsiW-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 4kubro6ijwdjpjugyd5q4inqiuanzzt6
X-Rspamd-Queue-Id: 5ECE81A0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775275207-972154
X-HE-Meta: U2FsdGVkX1+zkyKVgzMs+xEmuY0do7i2bgbwnZAj6+Pe+RCpS6Wdxlqau7Il/9cnhoosuI2fCFf5/KC4tAtZctq9eCa/pf3po5l1kSYMVGYxrAdHMJ/TdJ7/AYJPe/uBZgmCnbICTXe4wOqTathYmoJ9xVwjFFEJ6mpQZ5BDgZtWInetQ4kHw0L71D+BRq7kGno6Fjl/VjgcpTxByCa8UZvg+JpEvnywyadRZmrOdxJMSqAtVoEacuiEEMgko8DqZ668eix7wVODSSGpC4Gf5pj+55S3XG5x2cKUbqwcVA5U4ydiLql/U9Uh9G+z1vyxYqdWD2ifGtBVNs8fMR37ZHDGb7mwx/3cuVze4TYbd/cFay36ueO/A5MolWM946PZZ186QDx8ESRbq36o8uAwkuUfptMP3O61lOUvJ5MYf81kk+K7JpPTa4li02VWcOK3x5y0lm6E59ZuOWhTE7L4fNYrcAUed2BSAs6maas8odQCzI9TYuj9WrcXShGxSyknpa9SeF4SjQcNn+zWxLbYcRjDDJ1vT1IPRFHOzo96dLi+r368+jl7sk9u72rLf3YyvdpLOk+L+mCcRhHhXdS8MWpJPzWvfobzJ5T+7l4OaYx+Sr7OpmqnI5p7dD1bQfyZ0iUJ34kmEniYr1B1eA8u6qc+mFR70rymyzLcpXXyz1hn96o83QsGkADgJ6wq6B9ADheZIMIzQavosAIZAdkyFUmrmZ0CRsQ/BDlXYhduBx89SySLGTi8LpaYsTvJThzk161ulGncCr657bQkHC4P0TOttu6DGR0YqPxtFWxTZe+malY+vNStaWcx4CgFoZ9j7mIccCsxbBp8C6N6neTOSzvMPJJD/tzWqoDGqpU3WIu147un8pIx01Nj8R9BYREhHoPZX+8hd6nj3m12DqhyP07Nxx09JRt7zH/M7sQ+zvew+O/cEZWRhfOkZSCYv6J1rhd8CxyvSOB72mw8GKT
 xAaXelYN
 SdnE+KFO/WLVPUaUS041NxmaCM3S19n9H4MdlPwED6NqaoPsGgqiBtpwEEwZB4DHWHUfkl9fYsXplNOekvXx+q8AfWfGODQa+xL8vtAQcZeAm+rwbmT3VMftfRZUYZwI2aAQzNYMl/NyZp/Rx9zyqcwUeVdv+8B+qDkbY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 2febe6e6ee6e34c7754eff3c4d81aa7b0dcb7979  Add linux-next specific files for 20260403

Warning (recently discovered and may have been fixed):

    Warning: fs/fuse/dev.c:524 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst

Unverified Warning (likely false positive, kindly check if interested):

    drivers/usb/cdns3/cdnsp-gadget.c:158:16: sparse: sparse: cast to restricted __le32
    drivers/usb/cdns3/cdnsp-gadget.c:160:9: sparse: sparse: cast from restricted __le32
    drivers/usb/cdns3/cdnsp-gadget.c:160:9: sparse: sparse: incorrect type in argument 1 (different base types)

Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r133-20260403
|   |-- drivers-usb-cdns3-cdnsp-gadget.c:sparse:sparse:cast-from-restricted-__le32
|   |-- drivers-usb-cdns3-cdnsp-gadget.c:sparse:sparse:cast-to-restricted-__le32
|   `-- drivers-usb-cdns3-cdnsp-gadget.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-val-got-restricted-__le32-usertype
`-- i386-randconfig-141-20260403
    `-- Warning:fs-fuse-dev.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst

elapsed time: 765m

configs tested: 199
configs skipped: 4

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260404    gcc-8.5.0
arc                   randconfig-002-20260404    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260404    gcc-14.3.0
arm                   randconfig-002-20260404    gcc-15.2.0
arm                   randconfig-003-20260404    gcc-10.5.0
arm                   randconfig-004-20260404    gcc-12.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260403    gcc-8.5.0
arm64                 randconfig-002-20260403    clang-23
arm64                 randconfig-003-20260403    gcc-8.5.0
arm64                 randconfig-004-20260403    clang-17
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260403    gcc-9.5.0
csky                  randconfig-002-20260403    gcc-13.4.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260403    clang-23
hexagon               randconfig-002-20260403    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260403    gcc-14
i386        buildonly-randconfig-001-20260404    clang-20
i386        buildonly-randconfig-002-20260403    clang-20
i386        buildonly-randconfig-002-20260404    clang-20
i386        buildonly-randconfig-003-20260403    gcc-14
i386        buildonly-randconfig-003-20260404    clang-20
i386        buildonly-randconfig-004-20260403    gcc-14
i386        buildonly-randconfig-004-20260404    clang-20
i386        buildonly-randconfig-005-20260403    gcc-14
i386        buildonly-randconfig-005-20260404    clang-20
i386        buildonly-randconfig-006-20260403    gcc-14
i386        buildonly-randconfig-006-20260404    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260404    clang-20
i386                  randconfig-002-20260404    clang-20
i386                  randconfig-003-20260404    clang-20
i386                  randconfig-004-20260404    clang-20
i386                  randconfig-005-20260404    gcc-14
i386                  randconfig-006-20260404    clang-20
i386                  randconfig-007-20260404    clang-20
i386                  randconfig-011-20260404    clang-20
i386                  randconfig-012-20260404    clang-20
i386                  randconfig-013-20260404    clang-20
i386                  randconfig-014-20260404    clang-20
i386                  randconfig-015-20260404    gcc-14
i386                  randconfig-016-20260404    clang-20
i386                  randconfig-017-20260404    gcc-12
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260403    clang-23
loongarch             randconfig-002-20260403    gcc-15.2.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260403    gcc-8.5.0
nios2                 randconfig-002-20260403    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260403    gcc-11.5.0
parisc                randconfig-002-20260403    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260403    clang-23
powerpc               randconfig-002-20260403    gcc-13.4.0
powerpc64             randconfig-001-20260403    clang-23
powerpc64             randconfig-002-20260403    gcc-10.5.0
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260404    clang-19
riscv                 randconfig-002-20260404    clang-23
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260404    clang-20
s390                  randconfig-002-20260404    clang-23
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260404    gcc-15.2.0
sh                    randconfig-002-20260404    gcc-9.5.0
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260403    gcc-8.5.0
sparc                 randconfig-002-20260403    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260403    gcc-15.2.0
sparc64               randconfig-002-20260403    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260403    clang-20
um                    randconfig-002-20260403    gcc-14
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260403    clang-20
x86_64      buildonly-randconfig-001-20260404    clang-20
x86_64      buildonly-randconfig-002-20260403    gcc-14
x86_64      buildonly-randconfig-002-20260404    gcc-14
x86_64      buildonly-randconfig-003-20260403    clang-20
x86_64      buildonly-randconfig-003-20260404    gcc-13
x86_64      buildonly-randconfig-004-20260403    gcc-14
x86_64      buildonly-randconfig-004-20260404    clang-20
x86_64      buildonly-randconfig-005-20260403    clang-20
x86_64      buildonly-randconfig-005-20260404    clang-20
x86_64      buildonly-randconfig-006-20260403    gcc-12
x86_64      buildonly-randconfig-006-20260404    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260403    gcc-14
x86_64                randconfig-002-20260403    clang-20
x86_64                randconfig-003-20260403    gcc-13
x86_64                randconfig-004-20260403    clang-20
x86_64                randconfig-005-20260403    gcc-13
x86_64                randconfig-006-20260403    clang-20
x86_64                randconfig-011-20260403    gcc-14
x86_64                randconfig-012-20260403    gcc-14
x86_64                randconfig-013-20260403    gcc-14
x86_64                randconfig-014-20260403    gcc-14
x86_64                randconfig-015-20260403    gcc-14
x86_64                randconfig-016-20260403    gcc-14
x86_64                randconfig-071-20260403    gcc-14
x86_64                randconfig-071-20260404    gcc-13
x86_64                randconfig-072-20260404    clang-20
x86_64                randconfig-073-20260403    gcc-14
x86_64                randconfig-073-20260404    clang-20
x86_64                randconfig-074-20260403    gcc-14
x86_64                randconfig-074-20260404    gcc-14
x86_64                randconfig-075-20260404    clang-20
x86_64                randconfig-076-20260404    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260403    gcc-9.5.0
xtensa                randconfig-002-20260403    gcc-8.5.0
xtensa                    xip_kc705_defconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

