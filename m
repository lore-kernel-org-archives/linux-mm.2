Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2F8606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 22:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NqenGUzL
Received: by kanga.kvack.org (Postfix)
	id 497006B05B0; Thu, 26 Nov 2026 17:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447B86B05B1; Thu, 26 Nov 2026 17:13:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30FDC6B05B2; Thu, 26 Nov 2026 17:13:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA7666B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:13:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C863C0135
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:13:44 +0000 (UTC)
X-FDA: 85478673168.18.E715BB9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id E63A2A0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:13:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NqenGUzL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795731222;
	b=tUp5pAIm/uFM23q9oydy38WvR4vS9pfnNtQ/dVfvGQ4vcPKGEOa4vkfQTVZ1CsRFvBaxNv
	nmLjOdn2y5Rqal78k/m/bB3C8FQopxmuaHepSqXLpHyrwPgiGDC0pTrawzK/YRdqZMyJZp
	GMsRfk1xlV7a0uTyKu6mouNG/D47tGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795731222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=YoJXnMTUFSyDOcNqnOU29iLtNayehLzVCQI83ZKpgd8=;
	b=M260i74Ezb9Z1c5eyqYDvl0Nc0trOGCVphnjFh5XcKmiGfJaEh7VoZEhfV5Wnqmrc0fN9u
	/1Mv/eqIdxw5UKFqMQgodfIRnT/EmSoTr/S57t9VpQya3cLZDDva669qm5w1wncpJUVdpa
	TH35D0o7NAVBtIIFYPFvOs96kl4qNOM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NqenGUzL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795731221; x=1827267221;
  h=date:from:to:cc:subject:message-id;
  bh=BJKauYG3n2EPwWXrOokhSSAOP3Y4jaiaY9L3bTO/25M=;
  b=NqenGUzL0MZhe8jzdqWAWqX7NSjzWt02k0bK90zJjfizMDdT3n6Q25R6
   Oldtdvd4hk2+XdQ/ImEgFEmBvl+I8LLOLDVVKCGrE2bzPANDTU2vzQYKB
   IzSPGvzp+K80jhSLNgHH+SlUBVyho2xu9zoDWVfVFJ+bOR0GRTXhfIEkh
   6N6C8ZjAgzXrhoMgydyfze+wOtRuSqE+QLqwsncXy0/M25Lpw6NtvUegA
   7m9Y1R50D6RmaZjOy+sLQT7Ljpi0P8nWHpLgFW8nIgcLrjeaY+zekNC7E
   T6xdrSE+OhmxZFx5g7RF6G9fTqfqdfwu89qshAS/VmjwozVHu8p+Zy/kL
   Q==;
X-CSE-ConnectionGUID: k4xcaM+3RKes5XO9wTij1A==
X-CSE-MsgGUID: VgWgLS10SIeBeNfLLsjaKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="4552110"
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="4552110"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 14:13:38 -0800
X-CSE-ConnectionGUID: 7SuZNcspSUWAfEdjrT8HWg==
X-CSE-MsgGUID: cWuQ7auOT1ywjKQgIKoGyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="12287348"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 26 Nov 2026 14:13:37 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWhig-00000001UyE-20oQ;
	Thu, 26 Nov 2026 22:13:34 +0000
Date: Fri, 27 Nov 2026 06:12:55 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 3d27e49eb905a5119e78fbe3d3890f376d15c728
Message-ID: <20261127061255.sXY6esvU-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: E63A2A0004
X-Stat-Signature: x3ndxwhqf3dbx676wehmm8drih933kr9
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795731220-376286
X-HE-Meta: U2FsdGVkX19BUVF8jvk14J1qey4MXVpCtSnvZXHLMo4FLRDcS3BS1wGGdexaASmmLtseQG7+X8lDREUuu991F3rmuIhsRpubnG1pTNh+7zKHU5/flON+8jXXcvXedZFEdOeG07cX8/Vd+q+c9UhcAmk+MgGKr9nymIXziNz68VhGaEqOCqjvAQDrsg7hwtiCFpdsB/dW1DOuHdlx2UMAM6w5NuoIX1ubwm4qxia7A/klb+iUykCqb9BrQGwAY5kDLru6MdHor7C1TiMDCASoTwib2xlAdgnFHkYW52BZHpz+APym2UtqDuSuFlgCHMZ3LD9YBb02DPwlYd7t5RtMJ7nc3Gkuu1eaHAF0upcuCJqRTuq0qwuVRoRGttIjZczo3XjfrD9q8T7d0JkpLiRR2Cg/5qyyOAW7MelN0Rw1zThjkpUZqELUqZvmm+SjTjx1ZG1MFJLfdQyvG8y+KLFHzp9TG/sMArEgEAR3og1J2Fl2Ulk2oH9PM0NEy9mhkoS1d1tXvzuz3kGAMnL0L6Wv0J5CjsXssZKpARu14pA3IFHzoEaFRZX415OFQAbeaz9X2xhRx3NBTSeZmuudsN8hsLOR6OQc4U7tUhprAQ+vUG5IYZoDOzzGpzOK+WlqV0k9To6cup+OMzmCR2yFnLO09Fxnn9DaxZh8GoTG1CZQbJFjjSwi8lRDj4udggaT+owtquoIFuNbsUZPW7WtoF3jld7StAbBCzc5A7ONYdrxvBUphTqbs/XtdapEuhaLle7n65nOkANEG2wt4uqq5xGro8cpiHEb0lLRqwY4N4rviuYSocUQO/tX/61CXXjwwjVNZYv0ghzHBcigkEB667khZY3AY9WFWV5DrEOiBWo56PN1i+eMYes90QZfgchtWszfCm+o4tDj0kLtlhPBhxTDPciR9HyeKwayVcXlHPCnkQTv9OYXNwMZlr8+Hd44b/kGR5YsNfUvtbqsSZ4CqiX
 2J+WRt1m
 ZT32I+W8UB2kJUI1ZJXYq39wyFyuH+FcoSYly+nljjPvL7zm9vOPW29by6UlfyY2xSpVbEVnESiiC35CrCtrEx7wa71LZpW4+K0uGBGyvhNP1IfmrnSvGgrfj+H8b+/GR6ktsQWLzuoS5oJk2FCBYbe2eItlNoXq2DGq08qA30ziSZsRnAwzxAUJ//4tswMcoLpQaBT9HCmWecrLbOEH7NqHz1ha6hlUkAetNzVDRRupQemOpXp/MsGXv7vq6bNNPUmYM9A8SxT+SYTpcXMqxrojAamg/AVOAA/kGxheHlsm3WgA7LO0aydhieW/mWQp1qZwcbfSk7p6gn7NVTF3ZLveLgALmlcdRYVn2v36XKLeHkZdLtNh1o/M3F8ucBHrzPxoOcdwCA0+o11tgftS2ERAAL5tAkwxJMdOgfq5cX9Bpnv0fsaeryd4QkIjjMWODedGAFSV7opkmwETtZn3JZGy70GfZtJZCIg0A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 3d27e49eb905a5119e78fbe3d3890f376d15c728  tools/mm: page-types: flush pending idle bitmap bits after walking

elapsed time: 1355m

configs tested: 358
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                     allnoconfig    gcc-16.2.0
alpha                    allyesconfig    gcc-16.2.0
alpha                       defconfig    gcc-16.2.0
alpha        randconfig-2000-20261126    gcc-13.5.0
alpha        randconfig-2000-20261126    gcc-15.3.0
alpha        randconfig-2001-20261126    gcc-13.5.0
alpha        randconfig-2200-20261126    gcc-9.5.0  smatch
alpha       randconfig-r2100-20261126    gcc-10.5.0 cocci
alpha       randconfig-r2306-20261126    gcc-13.5.0 sparse
alpha       randconfig-r2310-20261126    gcc-10.5.0 sparse
arc                      allmodconfig    gcc-16.2.0
arc                       allnoconfig    gcc-16.2.0
arc                      allyesconfig    gcc-16.2.0
arc                         defconfig    gcc-16.2.0
arc          randconfig-2000-20261126    gcc-11.5.0
arc          randconfig-2000-20261126    gcc-9.5.0
arc          randconfig-2001-20261126    gcc-8.5.0
arc          randconfig-2001-20261126    gcc-9.5.0
arc          randconfig-2002-20261126    gcc-8.5.0
arc          randconfig-2002-20261126    gcc-9.5.0
arc          randconfig-2003-20261126    gcc-9.5.0
arc          randconfig-2004-20261126    gcc-15.3.0
arc          randconfig-2004-20261126    gcc-9.5.0
arc          randconfig-2005-20261126    gcc-9.5.0
arc          randconfig-2200-20261126    gcc-8.5.0  smatch
arc         randconfig-r2107-20261126    gcc-14.4.0 cocci
arc         randconfig-r2306-20261126    clang-18   sparse
arm                       allnoconfig    clang-17
arm                       allnoconfig    gcc-16.2.0
arm                      allyesconfig    gcc-16.2.0
arm                         defconfig    gcc-16.2.0
arm                  ep93xx_defconfig    clang-24
arm                  gemini_defconfig    clang-24
arm                  ixp4xx_defconfig    gcc-16.2.0
arm          randconfig-2000-20261126    gcc-11.5.0
arm          randconfig-2000-20261126    gcc-8.5.0
arm          randconfig-2001-20261126    gcc-11.5.0
arm          randconfig-2002-20261126    gcc-11.5.0
arm          randconfig-2002-20261126    gcc-13.5.0
arm          randconfig-2200-20261126    gcc-8.5.0  smatch
arm         randconfig-r2304-20261126    clang-22   sparse
arm64                    allmodconfig    clang-24
arm64                     allnoconfig    gcc-16.2.0
arm64                       defconfig    gcc-16.2.0
arm64        randconfig-1000-20261126    gcc-8.5.0
arm64        randconfig-1001-20261126    gcc-8.5.0
arm64        randconfig-1002-20261126    gcc-8.5.0
arm64        randconfig-1003-20261126    gcc-8.5.0
arm64        randconfig-2000-20261126    clang-24
arm64        randconfig-2000-20261126    gcc-11.5.0
arm64        randconfig-2001-20261126    clang-20
arm64        randconfig-2001-20261126    gcc-11.5.0
arm64        randconfig-2002-20261126    clang-24
arm64        randconfig-2002-20261126    gcc-11.5.0
arm64        randconfig-2200-20261126    clang-24   smatch
arm64       randconfig-r2301-20261126    clang-22   sparse
arm64       randconfig-r2302-20261126    clang-22   sparse
csky                     allmodconfig    gcc-16.2.0
csky                      allnoconfig    gcc-16.2.0
csky                        defconfig    gcc-16.2.0
csky         randconfig-1000-20261126    gcc-8.5.0
csky         randconfig-1001-20261126    gcc-8.5.0
csky         randconfig-2000-20261126    gcc-13.5.0
csky         randconfig-2000-20261126    gcc-16.2.0
csky         randconfig-2001-20261126    gcc-13.5.0
csky         randconfig-2200-20261126    gcc-13.5.0 smatch
csky        randconfig-r2104-20261126    gcc-14.4.0 cocci
csky        randconfig-r2300-20261126    gcc-12.5.0 sparse
hexagon                  allmodconfig    clang-24
hexagon                  allmodconfig    gcc-16.2.0
hexagon                   allnoconfig    clang-24
hexagon                   allnoconfig    gcc-16.2.0
hexagon                     defconfig    gcc-16.2.0
hexagon      randconfig-2000-20261126    clang-24
hexagon      randconfig-2000-20261126    gcc-13.5.0
hexagon      randconfig-2001-20261126    clang-17
hexagon      randconfig-2001-20261126    gcc-13.5.0
hexagon      randconfig-2200-20261126    clang-17   smatch
hexagon     randconfig-r2103-20261126    gcc-10.5.0 cocci
hexagon     randconfig-r2307-20261126    clang-18   sparse
hexagon     randconfig-r2309-20261126    clang-18   sparse
hexagon     randconfig-r2310-20261126    clang-24   sparse
i386                     allmodconfig    gcc-14
i386                      allnoconfig    gcc-14
i386                      allnoconfig    gcc-16.2.0
i386                        defconfig    gcc-16.2.0
i386         randconfig-1000-20261126    clang-22
i386         randconfig-1001-20261126    clang-22
i386         randconfig-1002-20261126    clang-22
i386         randconfig-1003-20261126    clang-22
i386         randconfig-1004-20261126    clang-22
i386         randconfig-1005-20261126    clang-22
i386         randconfig-1006-20261126    clang-22
i386         randconfig-2000-20261126    clang-22
i386         randconfig-2001-20261126    clang-22
i386         randconfig-2002-20261126    clang-22
i386         randconfig-2003-20261126    clang-22
i386         randconfig-2003-20261126    gcc-14
i386         randconfig-2004-20261126    clang-22
i386         randconfig-2005-20261126    clang-22
i386         randconfig-2100-20261126    clang-22   cocci
i386         randconfig-2101-20261126    clang-22   cocci
i386         randconfig-2102-20261126    clang-22   cocci
i386         randconfig-2102-20261126    gcc-14     cocci
i386         randconfig-2103-20261126    clang-22   cocci
i386         randconfig-2103-20261126    gcc-12     cocci
i386         randconfig-2104-20261126    clang-22   cocci
i386         randconfig-2105-20261126    clang-22   cocci
i386         randconfig-2105-20261126    gcc-14     cocci
i386         randconfig-2200-20261126    gcc-14     smatch
i386         randconfig-2300-20261126    gcc-14     sparse
i386         randconfig-2301-20261126    clang-22   sparse
i386         randconfig-2301-20261126    gcc-14     sparse
i386         randconfig-2302-20261126    gcc-14     sparse
i386        randconfig-r2109-20261126    clang-22   cocci
loongarch                allmodconfig    clang-19
loongarch                 allnoconfig    clang-20
loongarch                 allnoconfig    gcc-16.2.0
loongarch                   defconfig    clang-24
loongarch    randconfig-2000-20261126    gcc-12.5.0
loongarch    randconfig-2001-20261126    clang-18
loongarch    randconfig-2001-20261126    gcc-12.5.0
loongarch    randconfig-2200-20261126    gcc-14.4.0 smatch
loongarch   randconfig-r2300-20261126    clang-22   sparse
loongarch   randconfig-r2307-20261126    gcc-10.5.0 sparse
m68k                     allmodconfig    gcc-16.2.0
m68k                      allnoconfig    gcc-16.2.0
m68k                     allyesconfig    gcc-16.2.0
m68k                        defconfig    clang-24
m68k         randconfig-2000-20261126    gcc-13.5.0
m68k         randconfig-2000-20261126    gcc-8.5.0
m68k         randconfig-2001-20261126    gcc-13.5.0
m68k         randconfig-2001-20261126    gcc-8.5.0
m68k        randconfig-r2104-20261126    gcc-10.5.0 cocci
m68k        randconfig-r2308-20261126    gcc-9.5.0  sparse
microblaze                allnoconfig    gcc-16.2.0
microblaze               allyesconfig    gcc-16.2.0
microblaze                  defconfig    clang-24
microblaze   randconfig-2000-20261126    gcc-13.5.0
microblaze   randconfig-2000-20261126    gcc-15.3.0
microblaze   randconfig-2001-20261126    gcc-13.5.0
microblaze   randconfig-2001-20261126    gcc-8.5.0
microblaze   randconfig-2200-20261126    gcc-9.5.0  smatch
mips                     allmodconfig    gcc-16.2.0
mips                      allnoconfig    gcc-16.2.0
mips                     allyesconfig    gcc-16.2.0
mips         randconfig-2000-20261126    gcc-16.2.0
mips         randconfig-2000-20261126    gcc-8.5.0
mips         randconfig-2001-20261126    gcc-15.3.0
mips         randconfig-2001-20261126    gcc-16.2.0
mips         randconfig-2002-20261126    gcc-16.2.0
mips         randconfig-2002-20261126    gcc-9.5.0
mips        randconfig-r2303-20261126    clang-20   sparse
mips        randconfig-r2311-20261126    clang-24   sparse
nios2                    allmodconfig    gcc-11.5.0
nios2                     allnoconfig    clang-24
nios2                     allnoconfig    gcc-11.5.0
nios2                       defconfig    clang-24
nios2        randconfig-2000-20261126    gcc-11.5.0
nios2        randconfig-2000-20261126    gcc-12.5.0
nios2        randconfig-2001-20261126    gcc-12.5.0
nios2        randconfig-2001-20261126    gcc-9.5.0
nios2        randconfig-2200-20261126    gcc-9.5.0  smatch
nios2       randconfig-r2109-20261126    gcc-11.5.0 cocci
nios2       randconfig-r2111-20261126    clang-22   cocci
nios2       randconfig-r2308-20261126    gcc-10.5.0 sparse
openrisc                 allmodconfig    gcc-16.2.0
openrisc                  allnoconfig    clang-24
openrisc                  allnoconfig    gcc-16.2.0
openrisc                    defconfig    gcc-16.2.0
openrisc     randconfig-2000-20261126    gcc-16.2.0
openrisc     randconfig-2001-20261126    gcc-13.5.0
openrisc     randconfig-2001-20261126    gcc-16.2.0
openrisc     randconfig-2002-20261126    gcc-16.2.0
openrisc     randconfig-2200-20261126    gcc-9.5.0  smatch
openrisc    randconfig-r2102-20261126    gcc-12.5.0 cocci
openrisc    randconfig-r2105-20261126    gcc-10.5.0 cocci
openrisc    randconfig-r2306-20261126    gcc-10.5.0 sparse
openrisc    randconfig-r2309-20261126    gcc-12.5.0 sparse
openrisc    randconfig-r2311-20261126    gcc-10.5.0 sparse
parisc                   allmodconfig    gcc-16.2.0
parisc                    allnoconfig    clang-24
parisc                    allnoconfig    gcc-16.2.0
parisc                   allyesconfig    clang-17
parisc                   allyesconfig    gcc-16.2.0
parisc                      defconfig    gcc-16.2.0
parisc       randconfig-1000-20261126    gcc-13.5.0
parisc       randconfig-1001-20261126    gcc-13.5.0
parisc       randconfig-2000-20261126    gcc-12.5.0
parisc       randconfig-2000-20261126    gcc-8.5.0
parisc       randconfig-2001-20261126    gcc-12.5.0
parisc       randconfig-2001-20261126    gcc-8.5.0
parisc       randconfig-2200-20261126    gcc-15.3.0 smatch
parisc64                    defconfig    clang-24
powerpc             akebono_defconfig    clang-24
powerpc                  allmodconfig    gcc-16.2.0
powerpc                   allnoconfig    clang-24
powerpc                   allnoconfig    gcc-16.2.0
powerpc            ge_imp3a_defconfig    gcc-16.2.0
powerpc          mpc885_ads_defconfig    clang-24
powerpc      randconfig-1000-20261126    gcc-13.5.0
powerpc      randconfig-1001-20261126    gcc-13.5.0
powerpc      randconfig-2000-20261126    clang-24
powerpc      randconfig-2001-20261126    clang-24
powerpc      randconfig-2002-20261126    clang-24
powerpc      randconfig-2200-20261126    clang-24   smatch
powerpc     randconfig-r2303-20261126    clang-22   sparse
powerpc     randconfig-r2305-20261126    clang-22   sparse
powerpc64    randconfig-1000-20261126    gcc-13.5.0
powerpc64    randconfig-1001-20261126    gcc-13.5.0
powerpc64    randconfig-2000-20261126    clang-24
powerpc64    randconfig-2001-20261126    clang-24
powerpc64    randconfig-2002-20261126    clang-24
powerpc64    randconfig-2200-20261126    clang-24   smatch
powerpc64   randconfig-r2105-20261126    gcc-16.2.0 cocci
powerpc64   randconfig-r2106-20261126    clang-24   cocci
powerpc64   randconfig-r2308-20261126    clang-18   sparse
powerpc64   randconfig-r2311-20261126    clang-18   sparse
riscv                    allmodconfig    clang-24
riscv                     allnoconfig    clang-24
riscv                     allnoconfig    gcc-16.2.0
riscv                    allyesconfig    clang-24
riscv                       defconfig    gcc-16.2.0
riscv        randconfig-2000-20261126    gcc-10.5.0
riscv        randconfig-2001-20261126    clang-24
riscv        randconfig-2001-20261126    gcc-10.5.0
riscv        randconfig-2002-20261126    clang-20
riscv        randconfig-2002-20261126    gcc-10.5.0
riscv        randconfig-2003-20261126    gcc-10.5.0
riscv        randconfig-2003-20261126    gcc-16.2.0
riscv        randconfig-2004-20261126    gcc-10.5.0
riscv        randconfig-2005-20261126    clang-24
riscv        randconfig-2005-20261126    gcc-10.5.0
riscv        randconfig-2200-20261126    gcc-8.5.0  smatch
riscv       randconfig-r2102-20261126    gcc-10.5.0 cocci
riscv       randconfig-r2107-20261126    clang-22   cocci
s390                     allmodconfig    clang-17
s390                     allmodconfig    clang-24
s390                      allnoconfig    clang-24
s390                     allyesconfig    gcc-16.2.0
s390                        defconfig    gcc-16.2.0
s390         randconfig-2000-20261126    clang-18
s390         randconfig-2000-20261126    clang-24
s390         randconfig-2001-20261126    clang-24
s390         randconfig-2001-20261126    gcc-8.5.0
s390         randconfig-2002-20261126    clang-24
s390         randconfig-2003-20261126    clang-18
s390         randconfig-2003-20261126    clang-24
s390         randconfig-2004-20261126    clang-24
s390         randconfig-2004-20261126    gcc-10.5.0
s390         randconfig-2005-20261126    clang-21
s390         randconfig-2005-20261126    clang-24
s390         randconfig-2200-20261126    gcc-16.2.0 smatch
s390        randconfig-r2100-20261126    gcc-8.5.0  cocci
s390        randconfig-r2101-20261126    clang-24   cocci
sh                       allmodconfig    gcc-16.2.0
sh                        allnoconfig    clang-24
sh                        allnoconfig    gcc-16.2.0
sh                       allyesconfig    clang-17
sh                       allyesconfig    gcc-16.2.0
sh                          defconfig    gcc-14
sh           randconfig-2000-20261126    gcc-16.2.0
sh           randconfig-2000-20261126    gcc-9.5.0
sh           randconfig-2001-20261126    gcc-13.5.0
sh           randconfig-2001-20261126    gcc-9.5.0
sh           randconfig-2002-20261126    gcc-11.5.0
sh           randconfig-2002-20261126    gcc-9.5.0
sh           randconfig-2003-20261126    gcc-9.5.0
sh           randconfig-2004-20261126    gcc-16.2.0
sh           randconfig-2004-20261126    gcc-9.5.0
sh           randconfig-2005-20261126    gcc-16.2.0
sh           randconfig-2005-20261126    gcc-9.5.0
sh           randconfig-2200-20261126    gcc-16.2.0 smatch
sh          randconfig-r2103-20261126    gcc-16.2.0 cocci
sh          randconfig-r2304-20261126    gcc-9.5.0  sparse
sh              rts7751r2d1_defconfig    gcc-16.2.0
sh                   se7721_defconfig    gcc-16.2.0
sparc                     allnoconfig    clang-24
sparc                     allnoconfig    gcc-16.2.0
sparc                       defconfig    gcc-16.2.0
sparc        randconfig-2000-20261126    gcc-8.5.0
sparc        randconfig-2001-20261126    gcc-13.5.0
sparc        randconfig-2001-20261126    gcc-8.5.0
sparc        randconfig-2200-20261126    gcc-13.5.0 smatch
sparc       randconfig-r2101-20261126    gcc-10.5.0 cocci
sparc       randconfig-r2110-20261126    clang-22   cocci
sparc       randconfig-r2110-20261126    gcc-16.2.0 cocci
sparc       randconfig-r2307-20261126    clang-18   sparse
sparc64                  allmodconfig    clang-20
sparc64                     defconfig    gcc-14
sparc64      randconfig-2000-20261126    clang-24
sparc64      randconfig-2000-20261126    gcc-8.5.0
sparc64      randconfig-2001-20261126    gcc-8.5.0
sparc64      randconfig-2200-20261126    gcc-12.5.0 smatch
sparc64     randconfig-r2302-20261126    clang-20   sparse
sparc64     randconfig-r2310-20261126    clang-18   sparse
um                       allmodconfig    clang-17
um                        allnoconfig    clang-17
um                        allnoconfig    clang-24
um                       allyesconfig    gcc-14
um                       allyesconfig    gcc-16.2.0
um                          defconfig    gcc-14
um                     i386_defconfig    gcc-14
um           randconfig-2000-20261126    clang-17
um           randconfig-2000-20261126    gcc-8.5.0
um           randconfig-2001-20261126    clang-17
um           randconfig-2001-20261126    gcc-8.5.0
um           randconfig-2200-20261126    gcc-12     smatch
um          randconfig-r2108-20261126    clang-24   cocci
um          randconfig-r2305-20261126    clang-24   sparse
um                   x86_64_defconfig    gcc-14
x86_64                    allnoconfig    clang-22
x86_64                    allnoconfig    clang-24
x86_64                      defconfig    gcc-14
x86_64                          kexec    clang-22
x86_64       randconfig-2000-20261126    clang-22
x86_64       randconfig-2001-20261126    clang-22
x86_64       randconfig-2001-20261126    gcc-14
x86_64       randconfig-2002-20261126    clang-22
x86_64       randconfig-2003-20261126    clang-22
x86_64       randconfig-2004-20261126    clang-22
x86_64       randconfig-2005-20261126    clang-22
x86_64       randconfig-2100-20261126    clang-22   cocci
x86_64       randconfig-2100-20261126    gcc-14     cocci
x86_64       randconfig-2101-20261126    clang-22   cocci
x86_64       randconfig-2101-20261126    gcc-14     cocci
x86_64       randconfig-2102-20261126    gcc-14     cocci
x86_64       randconfig-2103-20261126    clang-22   cocci
x86_64       randconfig-2103-20261126    gcc-14     cocci
x86_64       randconfig-2104-20261126    gcc-14     cocci
x86_64       randconfig-2105-20261126    gcc-14     cocci
x86_64       randconfig-2200-20261126    clang-22   smatch
x86_64       randconfig-2300-20261126    gcc-12     sparse
x86_64       randconfig-2300-20261126    gcc-14     sparse
x86_64       randconfig-2301-20261126    gcc-14     sparse
x86_64       randconfig-2302-20261126    gcc-14     sparse
x86_64      randconfig-r2106-20261126    clang-22   cocci
x86_64      randconfig-r2108-20261126    clang-22   cocci
x86_64      randconfig-r2111-20261126    gcc-14     cocci
x86_64                       rhel-9.4    clang-22
x86_64                   rhel-9.4-bpf    clang-22
x86_64                   rhel-9.4-bpf    gcc-14
x86_64                  rhel-9.4-func    clang-22
x86_64            rhel-9.4-kselftests    clang-22
x86_64                 rhel-9.4-kunit    clang-22
x86_64                 rhel-9.4-kunit    gcc-14
x86_64                   rhel-9.4-ltp    clang-22
x86_64                   rhel-9.4-ltp    gcc-14
x86_64                  rhel-9.4-rust    clang-22
x86_64                  rhel-9.4-rust    clang-22
xtensa                    allnoconfig    clang-24
xtensa                    allnoconfig    gcc-16.2.0
xtensa                   allyesconfig    gcc-16.2.0
xtensa       randconfig-2000-20261126    gcc-13.5.0
xtensa       randconfig-2001-20261126    gcc-13.5.0
xtensa       randconfig-2001-20261126    gcc-15.3.0
xtensa       randconfig-2200-20261126    gcc-11.5.0 smatch
xtensa      randconfig-r2309-20261126    gcc-10.5.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

