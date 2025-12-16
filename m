Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22B4D5E370
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D336B0005; Tue, 16 Dec 2025 09:18:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99666B0089; Tue, 16 Dec 2025 09:18:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECFC6B008A; Tue, 16 Dec 2025 09:18:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CFD66B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:18:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B276136429
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:18:49 +0000 (UTC)
X-FDA: 84225540378.13.84B13E8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8ADB340002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:18:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XBz/mhbL";
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765894727; a=rsa-sha256;
	cv=none;
	b=MVgwoSp7ggl+XPgcDmGb/YlZ4CwvLyf2BQoFyE3LCEnsT2+g32R0itHgB8JuTDL7xreZzz
	h12RpLAq54KDdXUNtAF1d1ucyCCFMdPw9gsm+9xRuNwyu/qyJWoZgre+UKL0KbBkLcmINX
	cXreFZ6ojFZfY9+uagqsO/0I46zzQ6k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XBz/mhbL";
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765894727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=u0dc15TTqIQBGE3qLAwdacNDZPcneX3QP6YlYSPJ4oQ=;
	b=mVHImrXKlO8/wAMd3eyyc9yEocpEN4dWVXzex1CJ2YKrma3/bMH7vZ18ov7IZNS1bWxhRh
	Dnu+kdAcfkuVN05MsTPd0jyXKKCvcbFz/ITUlBanqROM/5o/pLWgaVpKEi44M67n5tFA07
	EErprsV8+1p+RoLb9F9oFsAjQ115C4I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765894727; x=1797430727;
  h=date:from:to:cc:subject:message-id;
  bh=znx+wvzT24WqgyPGmmilzwgzidgWAC532ma2FlNIIGk=;
  b=XBz/mhbLMSn8QR4YpAyVm3RbL6YBq6ePQHhay6JlIZvkbBcjl9Oleymt
   ruAq87TOLgcH2aSQvvpuWabhYLAQE3IyIeKac/eQe7XYPieuGzifWLLqC
   ByQhbb7IKcL0GW/BnIht644duK9d1detR7BEnJZLD5fq8VsBjhRbgl3Na
   dWrqqUYvKUgqW9CLCYezscafvwGK1yej3FjHfspeHjvooIsoFwbfjbPs+
   woy2Zk7oY02PClmUkWkUDJmLukVgvEDQXstn+4Mr+BANg/WEOSxKQuxJ7
   0GUvrxLcddEwggiFImahFU7DEPHCb63eDnYUCun47pCzsXpBwIDCp/uOH
   A==;
X-CSE-ConnectionGUID: Z5dTiiEyR1KCtfQGqGHpvA==
X-CSE-MsgGUID: giKh1nJrS4GOh+P1m5wF9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="67850944"
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="67850944"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 06:18:45 -0800
X-CSE-ConnectionGUID: xRGnp+2qQGqq/QkiybH4jQ==
X-CSE-MsgGUID: 1MfYSjGTQfKlg8h27QhZuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="197777419"
Received: from lkp-server02.sh.intel.com (HELO 034c7e8e53c3) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 16 Dec 2025 06:18:41 -0800
Received: from kbuild by 034c7e8e53c3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVVsr-000000003K4-04W9;
	Tue, 16 Dec 2025 14:18:37 +0000
Date: Tue, 16 Dec 2025 22:18:12 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 563c8dd425b59e44470e28519107b1efc99f4c7b
Message-ID: <202512162205.VUL8COjg-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 8ADB340002
X-Rspamd-Server: rspam04
X-Stat-Signature: 77nrnhnikymc5bwjtgqn4xbaarop39br
X-HE-Tag: 1765894726-495882
X-HE-Meta: U2FsdGVkX1/6PEHt0rT/jXe/rxXuyWbL7uTuvbN9oWeqrhfOY+Nioo8WCdJKlgGSGw3ew7bdPFCWAx1SGJw5nBCezS7rhgEjEcxSrWSAS+L2YEOMMvkmQ2ae8jSoA5+X5dDFly7HzVj2kAe9cRexyj++w55T9d3JchMYzky9ItNyt4lI2r7KSMWj9NWqq54PS6Z0W2/9XBVGK/YkTMfpsieLL9+wS3l8t7LFhZhMCWGIKuYIFOroCs4nxloQXgntYMwXqXHm3VxSo6VtIVYffMoS+JHuGkxnH37OhsFnDRUlJCRX3k5up1cseqylT6U1TJ3nMkOf8z3ZjgNF8hU3Piuyn2UW3eVZmCPx7mBMO7I41VrltBApxiR7XGXuWR5NVqlzBwkZ6lDVdR4giD1YMHfivCp7auLKEdG6BQwxcYjRzlEJbOrMgJHxD0Z2cZ7NDgkjaEU5VTAVwY0utkeHkdXLuoKHzz9OOIvB4yrmEteVi811XlkIRUl6VcZIKdDeeyI+UegQT5/xIZqoNg97nqPi0uxkWijTZze/1tRxk7ooZ4KV/1KY5GJg//yrqU45Hq6QaD2vSEhNwXUknuP6bz1M1NeUL0o49ZVFeQgMuY/JF17F1V+FSlYt8zBupdnkR3r17mjEZDyW1eGqdmbey8Fc65Z1+cmF9ydAFLZluvQULK2xAWCbuSglIdytaT49Ie55/elx1DPocx6rnVmcdQseoBlFbdtm0Ntav3ec4LtRMkQyfnBBrAH3ssnSyKz5u+ag7jvfmS/PKED7FWEH1UxT3oYaTqks4ptr7OJDZeIeNCHAiYBzcCrpaGxrAJxo0c5JvWUqCFpN9+QVTQV8E23WW90FYmTxgsbzXBARg3ZTjC8TK578NEAnV/smsKQlfRHNHik4IDro5fPjNzHfWJTu6qo89T3nun4Ok4v8AlJteg0ICTiI5xpfayauAbZ6YBD7qN+QkcbZBCo8XFt
 RxutP8h8
 73xvbE8kOtZT1vVWKzLjC2QbPEsoaOpKwv739BQNVmv2BjeWYlnZsJxMWERW3NXCoSc47eFeNZymVUE6r24WQa9WlgD3IkAQjAZfpXo4x3r5abN+OIjs7CQKaXm8fwgBkQcO7Dm4P86gNB725gGbth665aJ2C5D5HWHQ5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 563c8dd425b59e44470e28519107b1efc99f4c7b  Add linux-next specific files for 20251216

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/sitronix/st7571-spi.c:73:1: sparse: sparse: bad integer constant expression
    drivers/gpu/drm/sitronix/st7920.c:865:1: sparse: sparse: bad integer constant expression
    drivers/misc/lkdtm/lkdtm.o: warning: objtool: lkdtm_BUG_IN_HARDIRQ() falls through to next function lkdtm_WARNING()
    drivers/misc/lkdtm/lkdtm.o: warning: objtool: lkdtm_PANIC_IN_HARDIRQ() falls through to next function lkdtm_BUG()
    lib/tests/liveupdate.c:156:1: sparse: sparse: bad integer constant expression

Error/Warning ids grouped by kconfigs:

recent_errors
|-- loongarch-randconfig-r121-20251216
|   `-- drivers-gpu-drm-sitronix-st7920.c:sparse:sparse:bad-integer-constant-expression
|-- sparc64-randconfig-r113-20251216
|   `-- drivers-gpu-drm-sitronix-st7571-spi.c:sparse:sparse:bad-integer-constant-expression
|-- x86_64-randconfig-003-20251216
|   |-- drivers-misc-lkdtm-lkdtm.o:warning:objtool:lkdtm_BUG_IN_HARDIRQ-falls-through-to-next-function-lkdtm_WARNING()
|   `-- drivers-misc-lkdtm-lkdtm.o:warning:objtool:lkdtm_PANIC_IN_HARDIRQ-falls-through-to-next-function-lkdtm_BUG()
`-- x86_64-randconfig-123-20251216
    `-- lib-tests-liveupdate.c:sparse:sparse:bad-integer-constant-expression

elapsed time: 737m

configs tested: 175
configs skipped: 1

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                          axs103_defconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251216    gcc-12.5.0
arc                   randconfig-002-20251216    gcc-12.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                   milbeaut_m10v_defconfig    clang-19
arm                         nhk8815_defconfig    clang-22
arm                   randconfig-001-20251216    gcc-10.5.0
arm                   randconfig-002-20251216    gcc-8.5.0
arm                   randconfig-003-20251216    gcc-11.5.0
arm                   randconfig-004-20251216    clang-19
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251216    clang-16
arm64                 randconfig-002-20251216    gcc-8.5.0
arm64                 randconfig-003-20251216    gcc-10.5.0
arm64                 randconfig-004-20251216    gcc-14.3.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251216    gcc-15.1.0
csky                  randconfig-002-20251216    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251216    clang-22
hexagon               randconfig-002-20251216    clang-19
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251216    clang-20
i386        buildonly-randconfig-002-20251216    gcc-14
i386        buildonly-randconfig-003-20251216    gcc-14
i386        buildonly-randconfig-004-20251216    gcc-14
i386        buildonly-randconfig-005-20251216    clang-20
i386        buildonly-randconfig-006-20251216    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251216    clang-20
i386                  randconfig-002-20251216    clang-20
i386                  randconfig-003-20251216    gcc-14
i386                  randconfig-004-20251216    gcc-14
i386                  randconfig-005-20251216    gcc-14
i386                  randconfig-006-20251216    gcc-14
i386                  randconfig-007-20251216    clang-20
i386                  randconfig-011-20251216    gcc-13
i386                  randconfig-012-20251216    clang-20
i386                  randconfig-013-20251216    gcc-13
i386                  randconfig-014-20251216    gcc-13
i386                  randconfig-015-20251216    clang-20
i386                  randconfig-016-20251216    clang-20
i386                  randconfig-017-20251216    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251216    gcc-15.1.0
loongarch             randconfig-002-20251216    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                        m5272c3_defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
mips                           ip30_defconfig    gcc-15.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251216    gcc-8.5.0
nios2                 randconfig-002-20251216    gcc-11.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251216    gcc-11.5.0
parisc                randconfig-002-20251216    gcc-11.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                      bamboo_defconfig    clang-22
powerpc                      ep88xc_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251216    clang-22
powerpc               randconfig-002-20251216    clang-19
powerpc64             randconfig-001-20251216    clang-22
powerpc64             randconfig-002-20251216    clang-17
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251216    gcc-9.5.0
riscv                 randconfig-002-20251216    clang-17
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251216    clang-22
s390                  randconfig-002-20251216    clang-20
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251216    gcc-13.4.0
sh                    randconfig-002-20251216    gcc-12.5.0
sh                           se7712_defconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251216    gcc-8.5.0
sparc                 randconfig-002-20251216    gcc-14.3.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251216    clang-22
sparc64               randconfig-002-20251216    clang-22
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251216    gcc-12
um                    randconfig-002-20251216    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251216    clang-20
x86_64      buildonly-randconfig-002-20251216    gcc-14
x86_64      buildonly-randconfig-003-20251216    clang-20
x86_64      buildonly-randconfig-004-20251216    clang-20
x86_64      buildonly-randconfig-005-20251216    gcc-14
x86_64      buildonly-randconfig-006-20251216    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251216    gcc-14
x86_64                randconfig-002-20251216    clang-20
x86_64                randconfig-003-20251216    clang-20
x86_64                randconfig-004-20251216    gcc-14
x86_64                randconfig-005-20251216    clang-20
x86_64                randconfig-006-20251216    gcc-14
x86_64                randconfig-011-20251216    gcc-14
x86_64                randconfig-012-20251216    gcc-14
x86_64                randconfig-013-20251216    clang-20
x86_64                randconfig-014-20251216    clang-20
x86_64                randconfig-015-20251216    clang-20
x86_64                randconfig-016-20251216    clang-20
x86_64                randconfig-071-20251216    clang-20
x86_64                randconfig-072-20251216    gcc-14
x86_64                randconfig-073-20251216    gcc-14
x86_64                randconfig-074-20251216    gcc-12
x86_64                randconfig-075-20251216    clang-20
x86_64                randconfig-076-20251216    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251216    gcc-8.5.0
xtensa                randconfig-002-20251216    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

