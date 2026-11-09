Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377BD606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BUxaAc+U
Received: by kanga.kvack.org (Postfix)
	id 5C6C46B05BA; Mon,  9 Nov 2026 09:55:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5776C6B05BB; Mon,  9 Nov 2026 09:55:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43EC76B05BC; Mon,  9 Nov 2026 09:55:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17CFC6B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:55:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A73691606B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:55:15 +0000 (UTC)
X-FDA: 85415878590.09.3DC73FA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id 072D4140008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:55:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BUxaAc+U;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794236113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ZCl+mkow6+RCbuttuNKbn/B0QKOEOsshATrGc/XDs3s=;
	b=8YgRLTceut2/MfxpSya6u13aFM2n4+jck7MBr15hbJ0ubnVV5VERdDkcI0z7dcqOqjnUTo
	r3Pk/jcDCkxHRHYB6cRPlyMU1sRQHwdX1FT493OmYeba+tfjWRMggN3z01IUYmstj/SeMG
	YVJNk8pbr18a7DRVkygmda633Obx4dA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BUxaAc+U;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794236113;
	b=Q161yEh3ZPBfCr/LaHcoFEA9xCgrtJt9by7kHLh2cNAqC5pdss0yAHiJXSdUAmrJYTO53a
	TJ/F6aHo72J40GzOMWNI5HE3QQcJfVQGQJtAshYMRjEGwjp2OBiblv1oBehsTs1UYdEKOe
	ExJ8QGEYGGrBZbdJ6oGZ3BkHqwT3bQI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794236113; x=1825772113;
  h=date:from:to:cc:subject:message-id;
  bh=sIuT5Ifn3MDZmMAGE1tMEVn+nuUHaTEO7Qqt0YR+YBE=;
  b=BUxaAc+UbxOyFvzLqdq3GGFRfnI2zYzHOX+gNoMmuznqq5Qeqh2EMqVg
   D70sX3IYFupDRpxYiZ9++/QPXF/NYtsw2vRPdZMyrYeyFPwg/1/lAIIRL
   MWISl9Scf9e7sOBY5/Ddd3u3RUanqhGfi/+iVony0UrmTJOeFNdu442Ea
   /efiCFlmzvJneGFm95sJe6jfnBgHVpB5mtzJWzDhvti1tvo3FvLhU/6Fp
   8x1dpBfL1+0H1BeFS9p48n7TVo9GX5j9AX2W4NLiY8ko3GZ3OrkEeqpPm
   THplwCH5DZ8t5xjfOvjQ16y3/TCjqNXzICft9xZGyftCIMpQd70S91D00
   g==;
X-CSE-ConnectionGUID: 37sxQ8zMSxm2zNhIQu2zxQ==
X-CSE-MsgGUID: xEq9WI1BTgizmIc7/m0mQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2947604"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="2947604"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 06:55:12 -0800
X-CSE-ConnectionGUID: GWJgpn/iQgClmZQZ3+x+zQ==
X-CSE-MsgGUID: 6lTrG5IsS5qZmxWMex9PBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="7895183"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 09 Nov 2026 06:55:10 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQQm3-00000000uhT-2iOX;
	Mon, 09 Nov 2026 14:55:07 +0000
Date: Mon, 09 Nov 2026 22:54:19 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 b95f8bb86713c860ce8536d22a988b949b884d5f
Message-ID: <20261109225419.Lrln0N7v-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 072D4140008
X-Stat-Signature: p9ccuw19uhwtbeoxdp1h1z69x3iz83bz
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794236112-730963
X-HE-Meta: U2FsdGVkX1/KqvP26mxXcpdDGfawhRmehWJnt8dV3I8GIINQdHspgy+VXJlAE/weN0Z/4BPJI1KGMZVFq6sTGxCF8NcRWvvRUGLFXyWLDrr9DhpFBNxjN9Ea8GsJd4auGjp9IfARmSdA5xcdB7qklckiViPvpbY/gmxMshe8HysvGPfLwO7m66O8gU7jq8f07YL9TvFUiYSEnZ50yiXtwh99ad7YsbmbI/3fOIEq3go+LTzCq2BNy6umdUgdhT2vIbewjKHHradwgUmok/Na4fEvTk31PO5QGUseMZVaZEIpbHGccZbthAm56zx706XPCL/7wupEI9pIQyYyflSq5PpdjGqKr1i12qIzlRvIQ6ozyA4KrdSEFtgpM2sQ1FM1dpKtCb1S7lnoPUdPp4StRdIDlWOWZyHqobQ69pNhMrOSsCRJRtrcW0ssZOYc3ApFmIWwFHy6VqEryEMC1X6cevK+gal45yo8il7ubPkCYAI3IxrilNTMl9WQReLIRDiqdxSrhGcfnShubinCBN5RmwqkBQuaYSdlpERsIfn8DHC9vep8hLDsCWplf1Ll5eeeKWhVTur/Vl3VZZCh/CE9KcE2RDpiEBQY/0wXeLAAi/H7WQQeRD+d8gt03hC7AxyhzP1p5jYCyccpwGiewLJ7hFzh3Wc1a/a+tyhFOb0o2c7aRJsIMovR5oVLo5Oeg+aG9pCuw12d5V6rPglUji9SPCGhZO2stugcMRSw8LKWEa1ZzkgFvBaz2P3pkU4s7aeVOsGp5NEmHF0bSwMa6N7PHtwMQLUhR0p2/lwoDhC2/9vVTJhIXs02voQjNt5KeDZ9epGGfJfSTx2Wspf+fKJhgVkcIYzDzWHhHOi5UfMVdg8TRSYMHUBX3K0ulpFzj/Cj590hvb4oqWMDYDs3cvtf+qbZxZol5nWIiK0RVYSWSBgGK9hq9zdtQW+/K8omrOrCqDlxLAb5FT6LeenyFav
 kbotHiZS
 pDsjMVjcGZd388AGaN8jbHkjEAwH94WYUp4gHss14mFZ8KhLv1SNEojZQ/hoS1z8po/t/gWoPbgz2fzs9ctc/m0xkrEgBokvIoSUwM3MTf1Zmy6EPFnUjZ6v12sTIEDqlDT29f2SM5U/xJ/1LsmwE9x7N5qC3LFdKJ/X+yMEOdCu0gA4KkwgcAAVR3+8aIR+DvVP0An+wjjFqAgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: b95f8bb86713c860ce8536d22a988b949b884d5f  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 910m

configs tested: 214
configs skipped: 15

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                      haps_hs_smp_defconfig    gcc-16.2.0
arc                   randconfig-1000-20261109    clang-24
arc                   randconfig-1001-20261109    clang-24
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                        aspeed_g5_defconfig    clang-24
arm                          bcm2835_defconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                        imx_v4_v5_defconfig    gcc-16.2.0
arm                             mps2_defconfig    clang-24
arm                         multi_v7_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261109    clang-24
arm                   randconfig-1001-20261109    clang-24
arm                   randconfig-1002-20261109    clang-24
arm                   randconfig-1003-20261109    clang-24
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261109    gcc-13.5.0
arm64                 randconfig-1001-20261109    gcc-13.5.0
arm64                 randconfig-1002-20261109    gcc-13.5.0
arm64                 randconfig-1003-20261109    gcc-13.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261109    gcc-13.5.0
csky                  randconfig-1001-20261109    gcc-13.5.0
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261109    clang-19
hexagon               randconfig-1001-20261109    clang-19
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261109    clang-22
i386        buildonly-randconfig-1001-20261109    clang-22
i386        buildonly-randconfig-1002-20261109    clang-22
i386        buildonly-randconfig-1003-20261109    clang-22
i386        buildonly-randconfig-1004-20261109    clang-22
i386        buildonly-randconfig-1005-20261109    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1007-20261109    gcc-12
i386                  randconfig-1008-20261109    gcc-12
i386                  randconfig-1009-20261109    gcc-12
i386                  randconfig-1010-20261109    gcc-12
i386                  randconfig-1011-20261109    gcc-12
i386                  randconfig-1012-20261109    gcc-12
i386                  randconfig-1013-20261109    gcc-12
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261109    clang-19
loongarch             randconfig-1001-20261109    clang-19
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                           amiga_defconfig    clang-24
m68k                                 defconfig    clang-24
m68k                         m5307c3_defconfig    clang-24
m68k                        m5329evb_defconfig    gcc-16.2.0
m68k                          nettel_defconfig    clang-24
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           ath79_defconfig    clang-24
mips                       bmips_stb_defconfig    gcc-16.2.0
mips                          db1xxx_defconfig    gcc-16.2.0
mips                       fuloong2e_defconfig    gcc-16.2.0
mips                            gcw0_defconfig    gcc-16.2.0
mips                             gpr_defconfig    clang-24
mips                             gpr_defconfig    gcc-16.2.0
mips                            ip27_defconfig    gcc-16.2.0
mips                       loongson3_defconfig    gcc-16.2.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261109    clang-19
nios2                 randconfig-1001-20261109    clang-19
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                             defconfig    gcc-16.2.0
openrisc                   or1klitex_defconfig    gcc-16.2.0
openrisc                        virt_defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261109    gcc-8.5.0
parisc                randconfig-1001-20261109    gcc-8.5.0
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                        ebony_defconfig    clang-24
powerpc                           g5_defconfig    gcc-16.2.0
powerpc                  mpc837x_rdb_defconfig    clang-24
powerpc                       pmac32_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261109    gcc-8.5.0
powerpc               randconfig-1001-20261109    gcc-8.5.0
powerpc                      redwood_defconfig    gcc-16.2.0
powerpc                      taishan_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261109    gcc-8.5.0
powerpc64             randconfig-1001-20261109    gcc-8.5.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261109    gcc-8.5.0
riscv                 randconfig-1001-20261109    gcc-8.5.0
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-24
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261109    gcc-8.5.0
s390                  randconfig-1001-20261109    gcc-8.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                         apsh4ad0a_defconfig    clang-24
sh                                   defconfig    gcc-14
sh                           lboxre2_defconfig    gcc-16.2.0
sh                             migor_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261109    gcc-8.5.0
sh                    randconfig-1001-20261109    gcc-8.5.0
sh                           rsk7201_defconfig    clang-24
sh                       rts7751r2d1_defconfig    gcc-16.2.0
sh                           sdk7780_defconfig    clang-24
sh                           sdk7786_defconfig    gcc-16.2.0
sh                            se7751_defconfig    gcc-16.2.0
sh                              sh03_defconfig    gcc-16.2.0
sh                    sh7770_generic_defconfig    gcc-16.2.0
sparc                             alldefconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261109    gcc-8.5.0
sparc                 randconfig-1001-20261109    gcc-8.5.0
sparc                        sparc32_defconfig    gcc-16.2.0
sparc                        sparc64_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261109    gcc-8.5.0
sparc64               randconfig-1001-20261109    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261109    gcc-8.5.0
um                    randconfig-1001-20261109    gcc-8.5.0
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261109    clang-22
x86_64      buildonly-randconfig-1001-20261109    clang-22
x86_64      buildonly-randconfig-1002-20261109    clang-22
x86_64      buildonly-randconfig-1003-20261109    clang-22
x86_64      buildonly-randconfig-1004-20261109    clang-22
x86_64      buildonly-randconfig-1005-20261109    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261109    clang-22
x86_64                randconfig-1001-20261109    clang-22
x86_64                randconfig-1002-20261109    clang-22
x86_64                randconfig-1003-20261109    clang-22
x86_64                randconfig-1004-20261109    clang-22
x86_64                randconfig-1005-20261109    clang-22
x86_64                randconfig-1006-20261109    gcc-14
x86_64                randconfig-1007-20261109    gcc-14
x86_64                randconfig-1008-20261109    gcc-14
x86_64                randconfig-1009-20261109    gcc-14
x86_64                randconfig-1010-20261109    gcc-14
x86_64                randconfig-1011-20261109    gcc-14
x86_64                randconfig-1012-20261109    clang-22
x86_64                randconfig-1013-20261109    clang-22
x86_64                randconfig-1014-20261109    clang-22
x86_64                randconfig-1015-20261109    clang-22
x86_64                randconfig-1016-20261109    clang-22
x86_64                randconfig-1017-20261109    clang-22
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                   audio_kc705_defconfig    gcc-16.2.0
xtensa                 generic_kc705_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261109    gcc-8.5.0
xtensa                randconfig-1001-20261109    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

