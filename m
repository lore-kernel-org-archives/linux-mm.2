Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4929D78797
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2086F6B00C3; Fri, 19 Dec 2025 11:08:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EEE6B00CA; Fri, 19 Dec 2025 11:08:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4C16B00CE; Fri, 19 Dec 2025 11:08:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E950C6B00C3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:08:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A53E414018D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:08:01 +0000 (UTC)
X-FDA: 84236701962.03.D5555C4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0B164140019
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:07:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GOziWXx1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766160479; a=rsa-sha256;
	cv=none;
	b=8ErmS0NQ+yWNWnAlQZhAexIl0UQAmnbYrsNMFjchiqHT46XoctTssDymvKTBXFiki+M1Vd
	6dTx3+0OL32CKqiz4PSJ37LLccTARUcfdF2AjLwcWGFwg5HjB/n7N4ZhVaSGogg5kNmNRF
	sTUWwO77RuW8QTndGh6BwISEHzd5hS8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GOziWXx1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766160479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=sRq731e+IdtMR6XAqdL5sn3T+s4vBa722+7/txQMV44=;
	b=3VQcYCLXlyyIieAGPjeHlBrgLXpNxpDvrYHgeuIXp412eMQfUKJ1LzZMg//+vG7Jgn6KVA
	F+kRHMY6Si/fwcSkxpYAOQwerME53+Q2ydCyU7R0Q0kR4xACLcmiFnGIx5xCCW+iXAt9U2
	CipeuvhkSAq5sPQolEo4fertaRmWdlc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766160479; x=1797696479;
  h=date:from:to:cc:subject:message-id;
  bh=5fe5BiPE0InJ9QGUGmpUqLgCtH6YiOBfHS5sUzVDzKQ=;
  b=GOziWXx1ev6k0clSxc2DQAe7E9YksuWEl9IO3ijTLe4WNRk7woFaEJco
   WjvDiazIJo4DJ7Ykg4/GiOG5dQJs+dB89eEUTMa3GixtjxACdXMhGus2g
   RENiiU7i+cbzlsUuwcw4fg8JdVuQuPDV/7p8hM9OmxLJnHbmDg1334Agh
   UPRVuYvzeoUpJ9m9NfEF22kFVMjEZba7t5mSfNrezQ1wKIldoNaqtnGBf
   HZ/5AdT/uGt7JUftbKh+6gAhlFkN3I/+m2D6Nmq3yvH6b57dBAqC9vNM5
   tdQOtaGxcXXdE7O723hbbsU+8S2F6E4eWNTyXY0bN1azFmz2jrhdI4Wzo
   g==;
X-CSE-ConnectionGUID: MGXfxOAFS8qN9E8+4sbWmA==
X-CSE-MsgGUID: UiE+XSiJSJWl0zX6Ihu5oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11647"; a="79576953"
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="79576953"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 08:07:58 -0800
X-CSE-ConnectionGUID: 1fPVMPEfR4unu4fy2fGR/g==
X-CSE-MsgGUID: C6jfC38USu+OiI+zKgrC4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,161,1763452800"; 
   d="scan'208";a="198650568"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 19 Dec 2025 08:07:57 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWd1G-000000003iN-0Hp2;
	Fri, 19 Dec 2025 16:07:54 +0000
Date: Sat, 20 Dec 2025 00:07:48 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
Message-ID: <202512200030.gmH3W7Sc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 0B164140019
X-Stat-Signature: py1ekp11ox6bmin8f4umbewr3e77jfwq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766160478-974793
X-HE-Meta: U2FsdGVkX19TYJVBQChkzHuzxR9PNCUOc5N4b2KfmBicwri3bvzBDbHfWZAFS7V4jxOeWSdMW5KKIxDIJuw5oAa6ADMc2zmh4CciTkgN8uhAbYbH66xZO4+q3qq0oRxA/0y1v1+DlQfm1KD6uY6VY91fHe5BgeEhh4uVOw32UO0h09ZYbkIRS+6Sup3O/0/CHjgd7Dz2zK6zRlVryXQ9nH8WYn3P3au/jXyoloVMTKiUbynetU+1YKs7tKuLnE29LuiUJLRlaWFHy9w/moEblWMPLbKZp3TkktA0pRqhWolZwANHX4KIvYLAdnKpa4MISegMX5GQdyVFVUgkyh30CFS6cdcx0BMxTBliBI6dNxmP9gP3lxib4x2DJthnj20OgDpsUENPMJYPvmVslcu1LdB1KhGXg3muiFC1VyqBQjZHG3ItBpK2/LPATngCIfDzBcHEQJ6Yaqhrw6HDx3Wt181uzT1blTfiXB0qvZLWig6qTc51oh/Ixmi+3cXBd6uO64xwEDnJ8gD8BsaHiXvnXXiX/09eilkj5q0P/H2gBOtUs7OqwEHEZkddd8xryugYuyUfLFj5k7Hmj8QfVyaKWPapI2cxCR635WmedPH7BkyRJaDAv+hNNbTTXrMkEwNKZ+igp40Ipn1UhgoEI8evfHUaULQFLBZR3+yavmtv6YIEUl78AkWAO+IDJYcS3tAAEcP0IUJQ8nx1jyDEU1198S6f/65KM/rcEKzu7l2ZuJ7YeLjbZVyDgHPF0xlJy0hXUkpDbARJAZ0Dg8d50Zh2bEmEA99Y0GEEJC6SArCCCgiG1fMYk+d1Yrz1Maf7cDxQExWwX0K4qsZaxmHGN4+U0MpnxC+TScm8Mx1ZzEasz8N3ASI4OZTILQNXh8nvzMoNTaPHqqRmK3foZ+UwCRKjMTULmciUCT3MuM5apmq7ctVyIiINY6aa6xrv3fBzxOvMXUqdek5bkO0yovbn44+
 asJJgy+i
 d9O+ASvt0idS/nMD5UL55gRtDjuXceNpVTX+yam2vM/epS9vZtCpFnHaJcG8SiBFcxCAsHgPulPe+CHwVU1wDPB0wUTVwMBYeUfsXlFbFeBYvvM9pRZ+eI56aLADwvnNLPreuWWGycNrikFJMFl+EY5u86+32UcNf0dTC65NNA2wONURtjs+Cq54nCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8  Add linux-next specific files for 20251219

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202512191521.RK0edKdX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512191711.wY6XU796-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512191744.khCpeoDu-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202512191554.OfSzrFrY-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202512192142.EvXWjPXf-lkp@intel.com

    ERROR: modpost: "__udivdi3" [sound/soc/codecs/snd-soc-rt1320-sdw.ko] undefined!
    ERROR: modpost: "__umoddi3" [sound/soc/codecs/snd-soc-rt1320-sdw.ko] undefined!
    ld: sound/soc/codecs/rt1320-sdw.c:1071:(.text+0x29ba): undefined reference to `__udivdi3'
    ld: sound/soc/codecs/rt1320-sdw.c:1095:(.text+0xaf4): undefined reference to `__udivmoddi4'
    sound/soc/codecs/rt1320-sdw.c:1070:(.text+0x299a): undefined reference to `__udivdi3'
    sound/soc/codecs/rt1320-sdw.c:1096:(.text+0xac4): undefined reference to `__udivmoddi4'
    sound/soc/codecs/rt1320-sdw.c:1389:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    sound/soc/codecs/rt1320-sdw.c:1488:49: warning: '%s' directive output may be truncated writing up to 127 bytes into a region of size 106 [-Wformat-truncation=]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/xe/xe_guc_tlb_inval.c:178 send_tlb_inval_ppgtt() error: buffer overflow 'action' 7 <= 7

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-001-20251219
|   |-- ERROR:__udivdi3-sound-soc-codecs-snd-soc-rt1320-sdw.ko-undefined
|   |-- ERROR:__umoddi3-sound-soc-codecs-snd-soc-rt1320-sdw.ko-undefined
|   `-- sound-soc-codecs-rt1320-sdw.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-true
|-- i386-randconfig-011-20251219
|   |-- ld:sound-soc-codecs-rt1320-sdw.c:(.text):undefined-reference-to-__udivdi3
|   |-- ld:sound-soc-codecs-rt1320-sdw.c:(.text):undefined-reference-to-__udivmoddi4
|   |-- sound-soc-codecs-rt1320-sdw.c:(.text):undefined-reference-to-__udivdi3
|   `-- sound-soc-codecs-rt1320-sdw.c:(.text):undefined-reference-to-__udivmoddi4
|-- x86_64-randconfig-122-20250509
|   `-- sound-soc-codecs-rt1320-sdw.c:warning:s-directive-output-may-be-truncated-writing-up-to-bytes-into-a-region-of-size
`-- x86_64-randconfig-161-20251218
    `-- drivers-gpu-drm-xe-xe_guc_tlb_inval.c-send_tlb_inval_ppgtt()-error:buffer-overflow-action

elapsed time: 746m

configs tested: 173
configs skipped: 1

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251219    gcc-11.5.0
arc                   randconfig-002-20251219    gcc-8.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                        neponset_defconfig    gcc-15.1.0
arm                   randconfig-001-20251219    clang-22
arm                   randconfig-002-20251219    gcc-11.5.0
arm                   randconfig-003-20251219    clang-22
arm                   randconfig-004-20251219    gcc-8.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251219    clang-22
arm64                 randconfig-002-20251219    clang-20
arm64                 randconfig-003-20251219    gcc-9.5.0
arm64                 randconfig-004-20251219    clang-22
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251219    gcc-12.5.0
csky                  randconfig-002-20251219    gcc-9.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251219    clang-18
hexagon               randconfig-002-20251219    clang-19
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251219    clang-20
i386        buildonly-randconfig-002-20251219    clang-20
i386        buildonly-randconfig-003-20251219    clang-20
i386        buildonly-randconfig-004-20251219    clang-20
i386        buildonly-randconfig-005-20251219    clang-20
i386        buildonly-randconfig-006-20251219    clang-20
i386                                defconfig    clang-20
i386                  randconfig-001-20251219    clang-20
i386                  randconfig-002-20251219    gcc-14
i386                  randconfig-003-20251219    clang-20
i386                  randconfig-004-20251219    clang-20
i386                  randconfig-005-20251219    clang-20
i386                  randconfig-006-20251219    clang-20
i386                  randconfig-007-20251219    gcc-14
i386                  randconfig-011-20251219    gcc-12
i386                  randconfig-012-20251219    clang-20
i386                  randconfig-013-20251219    clang-20
i386                  randconfig-014-20251219    gcc-14
i386                  randconfig-015-20251219    gcc-14
i386                  randconfig-016-20251219    gcc-14
i386                  randconfig-017-20251219    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251219    gcc-15.1.0
loongarch             randconfig-002-20251219    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                          multi_defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251219    gcc-11.5.0
nios2                 randconfig-002-20251219    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251219    gcc-13.4.0
parisc                randconfig-002-20251219    gcc-13.4.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                   bluestone_defconfig    clang-22
powerpc                     mpc5200_defconfig    clang-22
powerpc                 mpc832x_rdb_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251219    clang-22
powerpc               randconfig-002-20251219    gcc-8.5.0
powerpc                     tqm8541_defconfig    clang-22
powerpc64             randconfig-001-20251219    clang-22
powerpc64             randconfig-002-20251219    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251219    gcc-10.5.0
riscv                 randconfig-002-20251219    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251219    gcc-12.5.0
s390                  randconfig-002-20251219    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251219    gcc-15.1.0
sh                    randconfig-002-20251219    gcc-9.5.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251219    gcc-8.5.0
sparc                 randconfig-002-20251219    gcc-15.1.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251219    gcc-9.5.0
sparc64               randconfig-002-20251219    gcc-15.1.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251219    clang-22
um                    randconfig-002-20251219    gcc-13
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251219    clang-20
x86_64      buildonly-randconfig-002-20251219    gcc-13
x86_64      buildonly-randconfig-003-20251219    clang-20
x86_64      buildonly-randconfig-004-20251219    clang-20
x86_64      buildonly-randconfig-005-20251219    clang-20
x86_64      buildonly-randconfig-006-20251219    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251219    gcc-14
x86_64                randconfig-002-20251219    gcc-14
x86_64                randconfig-003-20251219    gcc-14
x86_64                randconfig-004-20251219    clang-20
x86_64                randconfig-005-20251219    clang-20
x86_64                randconfig-006-20251219    clang-20
x86_64                randconfig-011-20251219    clang-20
x86_64                randconfig-012-20251219    gcc-14
x86_64                randconfig-013-20251219    clang-20
x86_64                randconfig-014-20251219    gcc-14
x86_64                randconfig-015-20251219    gcc-14
x86_64                randconfig-016-20251219    clang-20
x86_64                randconfig-071-20251219    gcc-14
x86_64                randconfig-072-20251219    clang-20
x86_64                randconfig-073-20251219    gcc-14
x86_64                randconfig-074-20251219    clang-20
x86_64                randconfig-075-20251219    clang-20
x86_64                randconfig-076-20251219    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251219    gcc-8.5.0
xtensa                randconfig-002-20251219    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

