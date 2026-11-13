Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E76606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 06:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PX74gO7D
Received: by kanga.kvack.org (Postfix)
	id 2935D6B05DF; Fri, 13 Nov 2026 01:20:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F396B05F9; Fri, 13 Nov 2026 01:20:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8226B05FA; Fri, 13 Nov 2026 01:20:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E96FE6B05DF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:20:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DB82C04D3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:20:33 +0000 (UTC)
X-FDA: 85429096746.20.ABFB033
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F4CA140002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:20:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PX74gO7D;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794550831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=nppQhoJvLuC+NtNKbr35Wsp7tGHj8BrmIsj1cEivs7s=;
	b=8MYT2JLsebLCrDNuFjw84g5R5xXNfe6c7tW7PpaNxQwWD/q00c2mr8kJzxneCIYEwdxB49
	kFL95vkbFcWLGegKzCVHDifyj0rfO3AeGrzXEuuoiyStLTWP+PawP1NiysaC8TsZJd4fqA
	pFl9dxsQ3/A2ESCB8KSURgf3vxO4asY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794550831;
	b=h5CpUaulQngmgYDav+BwdhayUHKbSQ63FU8HsmcdstLR7sRvD9rVIgcFaz9DIPsohXkZEx
	xqwLhbAYjcwrFWPSCB9rlyd2oLpWzjlxwv0jA3u/fUWLl02HTjZlDLxMyWJxj8MfaGvRkU
	v4mNrurQPJ0tLBABLrdhMV8L7wpEShY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PX74gO7D;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794550830; x=1826086830;
  h=date:from:to:cc:subject:message-id;
  bh=0bBRq8c1y/Dmqp0nbnH0nmHu3pcGBIoFuAiIXEqp3RU=;
  b=PX74gO7DHXQcFZuA0A4gCGh40nNFdC0DKchYgGJbVWZDhkcAVpIG4yHo
   XdtQZ0Rqh87uh0qSSbU3+3j4c2CTSGn9TybRl04OZPI63XXjx0JnrtKVk
   GL7d97MhwdSlnbgzh3LB0pSykQ+Br2T9NZZCdjbg+vtOx8SFx4BlrsLD6
   RlU9JrNnjyRIhSpaQy53olHL9pl1iurFrTt8gdJLuRHqVpEvtUBYr50a1
   O/Sl6IGhZfenF3jePOJd1b6/KlSZ9LUJKwdebNgAKwvKRb3A4ChTLxs9S
   rnt77QNE6T2oiLYdAOfN+kA2kJclnwSUEdnktBCzxMZbDCZ1L4JqzwoWB
   g==;
X-CSE-ConnectionGUID: VQA8EMZIQuCpSnYDtHVj7A==
X-CSE-MsgGUID: axmt2WWBRLWDWNHh+JIdXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3445791"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3445791"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 22:20:28 -0800
X-CSE-ConnectionGUID: zwIRvbw3Q4WPQtIEY30Gkg==
X-CSE-MsgGUID: Ld/dXD1nRh2zyrzE9jn3xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="8943438"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 12 Nov 2026 22:20:26 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRke8-000000012VC-2OLi;
	Fri, 13 Nov 2026 06:20:24 +0000
Date: Fri, 13 Nov 2026 14:19:24 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH WARNING
 aaa2f954c21b205a0bcd0961e5b2be4e82e58455
Message-ID: <20261113141924.P6DYSoxB-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9F4CA140002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: my4r79if8zk6ettzfszoi5oef1tsq7s4
X-Rspam-User: 
X-HE-Tag: 1794550830-339736
X-HE-Meta: U2FsdGVkX1/VyGjmr9TlT9XwJRAAsahtzGdi4XviX0JNAJyt+UK/HUEVMWAA1dGoXHm9TWvkS+URjipuvML8vVEBuzzpg5oq3Le/KnlIpM3IjUXaslkwWzeEP93mT7pDtPQDA0psTbq6QUCLm3ljBUuTa7Isfn+yg21DOMkqpCu8mWcT1qGXUEpkv0U1KiRHqc8a+uXBNZ9cQdanY8hu+AUpPtcItdvnDMa6prI9EUGOV1GxLNUMlFhcmXRn/AUbI6qonujI+uhCTFTjbKJNClqHnEg7z6KlH8/FkV/XUFX+NChtNgQJAbyp/PMl2Syw61P5lKgSBFVRw/lIYiEAnJ8oq/aYQfJZcvOufzN4uemnB/4Ta9RupuphJNAEPxPXWYGK5BMyY0/4pCbrEpN2D1BO22Phjc4REvsdoC24uLQgqCUrgC8YDnLAWiHQtxVA4IJYKpeunCM78h3rvkiKlrZdvMaTGC1Hxa1OxOtlzfko1zf1eeS5I5HqUGWPTpRvhNsbZiE+xFPElfUOVaFVbUjuUPfVNK/YxilewOn02Iv2ATSMEeuyHb2yjiXGzjOdNAuNhs6PSnI3j3rERPx4+Rzm2pdHytrjbsycTLPkO9PoiFPt2L9bvCw0+hbIugWvnX4oDvSy8k/kSkdanSXq/YRHTq5UoUgEpzDyZAAnJp9fWOZyyeHfeJfDGHLXShIgGDYlAmtM/jLOW9ybT2a12y1iWKkvNjatP1nJgIh9K0elogiURM3oYDzk0G27tTvZiBMmZYV2PLPEBFar+JagEE/mnYPaW3DENB59sT+6/x7txLK9lvVI2EvZN8K+ZO4fUMrWDxCFhpwCvg8TcPjVXdVakM5glet+KhU0B2Y6fEA5LP56hiTel5tqiCgTJiWb1rwbzArP/5cxcYg37CsLRkz/IMXqZuX25ZwqoQfoaqzObb1vDHxt0UdlbOBhK6Fzzo/Lve/KMCKc3JTxTvj
 aNAGKAWi
 KCWKMyNzhwzvv56xODC2Yjl0Ksl3pVcFoO/BDSaxfdrQXBOA0fB75zVODqi2ezpGTeLboaZmBz9ayKvM0ApTQ69j3tDaI9x5ux0VYHbiyCAMK9CStJdqCkhj7Arbyys+Y8OSXodibammowoOwMNjXjFkq7HUeltUGcStmIdy4Wam/UA8zkmePTkLeTnw95TiE+mtpxhr/wBvX63kSEoiSjGuUxumbRH3vsO2w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: aaa2f954c21b205a0bcd0961e5b2be4e82e58455  Add linux-next specific files for 20261111

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202611122226.vTBpAmtr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202611122323.IvGv8FYK-lkp@intel.com

    WARNING: modpost: vmlinux: section mismatch in reference: seq_buf_terminate+0x20 (section: .text) -> bootup_event_seq (section: .init.data)
    WARNING: modpost: vmlinux: section mismatch in reference: seq_buf_terminate+0x2c (section: .text) -> bootup_event_buf (section: .init.data)

Warning ids grouped by kconfigs:

recent_errors
|-- arm64-randconfig-1000-20261112
|   `-- WARNING:modpost:vmlinux:section-mismatch-in-reference:seq_buf_terminate-(section:.text)-bootup_event_buf-(section:.init.data)
`-- loongarch-allmodconfig
    `-- WARNING:modpost:vmlinux:section-mismatch-in-reference:seq_buf_terminate-(section:.text)-bootup_event_seq-(section:.init.data)

elapsed time: 1329m

configs tested: 255
configs skipped: 13

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                      nsimosci_hs_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261113    gcc-10.5.0
arc                   randconfig-1001-20261113    gcc-10.5.0
arm                               alldefconfig    gcc-16.2.0
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                             dove_defconfig    gcc-16.2.0
arm                           gemini_defconfig    gcc-16.2.0
arm                            imxrt_defconfig    gcc-16.2.0
arm                       integrator_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261113    gcc-10.5.0
arm                   randconfig-1001-20261113    gcc-10.5.0
arm                   randconfig-1002-20261113    gcc-10.5.0
arm                   randconfig-1003-20261113    gcc-10.5.0
arm                          s3c6400_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261112    gcc-14.4.0
arm64                 randconfig-1001-20261112    gcc-14.4.0
arm64                 randconfig-1002-20261112    gcc-14.4.0
arm64                 randconfig-1003-20261112    gcc-14.4.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261112    gcc-14.4.0
csky                  randconfig-1001-20261112    gcc-14.4.0
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261112    clang-24
hexagon               randconfig-1000-20261113    clang-24
hexagon               randconfig-1001-20261112    clang-24
hexagon               randconfig-1001-20261113    clang-24
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261112    clang-22
i386        buildonly-randconfig-1000-20261113    clang-22
i386        buildonly-randconfig-1001-20261112    clang-22
i386        buildonly-randconfig-1001-20261113    clang-22
i386        buildonly-randconfig-1002-20261112    clang-22
i386        buildonly-randconfig-1002-20261113    clang-22
i386        buildonly-randconfig-1003-20261112    clang-22
i386        buildonly-randconfig-1003-20261113    clang-22
i386        buildonly-randconfig-1004-20261112    clang-22
i386        buildonly-randconfig-1004-20261113    clang-22
i386        buildonly-randconfig-1005-20261112    clang-22
i386        buildonly-randconfig-1005-20261113    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261112    gcc-14
i386                  randconfig-1000-20261113    clang-22
i386                  randconfig-1001-20261112    gcc-14
i386                  randconfig-1001-20261113    clang-22
i386                  randconfig-1002-20261112    gcc-14
i386                  randconfig-1002-20261113    clang-22
i386                  randconfig-1003-20261112    gcc-14
i386                  randconfig-1003-20261113    clang-22
i386                  randconfig-1004-20261112    gcc-14
i386                  randconfig-1004-20261113    clang-22
i386                  randconfig-1005-20261112    gcc-14
i386                  randconfig-1005-20261113    clang-22
i386                  randconfig-1006-20261112    gcc-14
i386                  randconfig-1006-20261113    clang-22
i386                  randconfig-1007-20261112    clang-22
i386                  randconfig-1007-20261113    clang-22
i386                  randconfig-1008-20261112    clang-22
i386                  randconfig-1008-20261113    clang-22
i386                  randconfig-1009-20261112    clang-22
i386                  randconfig-1009-20261113    clang-22
i386                  randconfig-1010-20261112    clang-22
i386                  randconfig-1010-20261113    clang-22
i386                  randconfig-1011-20261112    clang-22
i386                  randconfig-1011-20261113    clang-22
i386                  randconfig-1012-20261112    clang-22
i386                  randconfig-1012-20261113    clang-22
i386                  randconfig-1013-20261112    clang-22
i386                  randconfig-1013-20261113    clang-22
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch                 loongson64_defconfig    gcc-16.2.0
loongarch             randconfig-1000-20261112    clang-24
loongarch             randconfig-1000-20261113    clang-24
loongarch             randconfig-1001-20261112    clang-24
loongarch             randconfig-1001-20261113    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                          amcore_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                        m5249evb_defconfig    gcc-16.2.0
m68k                        m5282evb_defconfig    gcc-16.2.0
m68k                         mvme147_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           ath79_defconfig    gcc-16.2.0
mips                        bmips_be_defconfig    gcc-16.2.0
mips                      decstation_defconfig    gcc-16.2.0
mips                      eyeq6lplus_defconfig    gcc-16.2.0
mips                            gcw0_defconfig    gcc-16.2.0
mips                            ip28_defconfig    gcc-16.2.0
mips                           malta_defconfig    gcc-16.2.0
mips                   maltasmvp_eva_defconfig    gcc-16.2.0
mips                         maltaup_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261112    clang-24
nios2                 randconfig-1000-20261113    clang-24
nios2                 randconfig-1001-20261112    clang-24
nios2                 randconfig-1001-20261113    clang-24
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261113    gcc-13.5.0
parisc                randconfig-1001-20261113    gcc-13.5.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                         icon_defconfig    gcc-16.2.0
powerpc                       ppc6xx_defconfig    gcc-16.2.0
powerpc                      rainier_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261113    gcc-13.5.0
powerpc               randconfig-1001-20261113    gcc-13.5.0
powerpc                  xes_mpc85xx_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261113    gcc-13.5.0
powerpc64             randconfig-1001-20261113    gcc-13.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                     nommu_k210_defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261112    gcc-9.5.0
riscv                 randconfig-1000-20261113    gcc-12.5.0
riscv                 randconfig-1001-20261112    gcc-9.5.0
riscv                 randconfig-1001-20261113    gcc-12.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261112    gcc-9.5.0
s390                  randconfig-1000-20261113    gcc-12.5.0
s390                  randconfig-1001-20261112    gcc-9.5.0
s390                  randconfig-1001-20261113    gcc-12.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261112    gcc-9.5.0
sh                    randconfig-1000-20261113    gcc-12.5.0
sh                    randconfig-1001-20261112    gcc-9.5.0
sh                    randconfig-1001-20261113    gcc-12.5.0
sh                           rsk7269_defconfig    gcc-16.2.0
sh                         sh7757lcr_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261112    gcc-8.5.0
sparc                 randconfig-1000-20261113    gcc-8.5.0
sparc                 randconfig-1001-20261112    gcc-8.5.0
sparc                 randconfig-1001-20261113    gcc-8.5.0
sparc                        sparc32_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261112    gcc-8.5.0
sparc64               randconfig-1000-20261113    gcc-8.5.0
sparc64               randconfig-1001-20261112    gcc-8.5.0
sparc64               randconfig-1001-20261113    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261112    gcc-8.5.0
um                    randconfig-1000-20261113    gcc-8.5.0
um                    randconfig-1001-20261112    gcc-8.5.0
um                    randconfig-1001-20261113    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261112    gcc-14
x86_64      buildonly-randconfig-1000-20261113    clang-22
x86_64      buildonly-randconfig-1001-20261112    gcc-14
x86_64      buildonly-randconfig-1001-20261113    clang-22
x86_64      buildonly-randconfig-1002-20261112    gcc-14
x86_64      buildonly-randconfig-1002-20261113    clang-22
x86_64      buildonly-randconfig-1003-20261112    gcc-14
x86_64      buildonly-randconfig-1003-20261113    clang-22
x86_64      buildonly-randconfig-1004-20261112    gcc-14
x86_64      buildonly-randconfig-1004-20261113    clang-22
x86_64      buildonly-randconfig-1005-20261112    gcc-14
x86_64      buildonly-randconfig-1005-20261113    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261113    clang-22
x86_64                randconfig-1001-20261113    clang-22
x86_64                randconfig-1002-20261113    clang-22
x86_64                randconfig-1003-20261113    clang-22
x86_64                randconfig-1004-20261113    clang-22
x86_64                randconfig-1005-20261113    clang-22
x86_64                randconfig-1006-20261112    gcc-14
x86_64                randconfig-1006-20261113    clang-22
x86_64                randconfig-1007-20261112    gcc-14
x86_64                randconfig-1007-20261113    clang-22
x86_64                randconfig-1008-20261112    gcc-14
x86_64                randconfig-1008-20261113    clang-22
x86_64                randconfig-1009-20261112    gcc-14
x86_64                randconfig-1009-20261113    clang-22
x86_64                randconfig-1010-20261112    gcc-14
x86_64                randconfig-1010-20261113    clang-22
x86_64                randconfig-1011-20261112    gcc-14
x86_64                randconfig-1011-20261113    clang-22
x86_64                randconfig-1012-20261113    gcc-14
x86_64                randconfig-1013-20261113    gcc-14
x86_64                randconfig-1014-20261113    gcc-14
x86_64                randconfig-1015-20261113    gcc-14
x86_64                randconfig-1016-20261113    gcc-14
x86_64                randconfig-1017-20261113    gcc-14
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                randconfig-1000-20261112    gcc-8.5.0
xtensa                randconfig-1000-20261113    gcc-8.5.0
xtensa                randconfig-1001-20261112    gcc-8.5.0
xtensa                randconfig-1001-20261113    gcc-8.5.0
xtensa                     smp_lx200_defconfig    gcc-16.2.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

