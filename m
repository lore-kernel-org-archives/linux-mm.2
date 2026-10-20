Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD2F606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jKwgE6Nf
Received: by kanga.kvack.org (Postfix)
	id 644ED6B018C; Tue, 20 Oct 2026 18:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F4F56B018F; Tue, 20 Oct 2026 18:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B496B0191; Tue, 20 Oct 2026 18:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20C316B018C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:49:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8268D802D3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:49:10 +0000 (UTC)
X-FDA: 85344496860.11.F0F286D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 44D0B40002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:49:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jKwgE6Nf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792536548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=PvnA9UyYB09A3E004cKhj4DhYl5a/Iq2c25nOa9MoU4=;
	b=RgIg9flb+ciEhDkf4ZFqCe3JFooDypLutK1jx44uwei5+3hqejfcb63dscF57n0A3eywXf
	nRuzetUDUbGvbU0ThnBPAVGkhyF/+G46zTuo+gt++g+6E2iNNPyaQK4KjD3Dus0kwGXL0d
	QLt6UHWBsMLcGvot+/IZ8SsozSV25kE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jKwgE6Nf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792536548;
	b=ZNdZ9UJ4E3YiZuM2MsICvuzJWAWg4LSCXvsGrfFzUo2gO39+aWjdSsYoWCMfAzkMnRV9R6
	f0HHmhX6k04CKPfLdlMb1xIlBPeWfEEzQtfEdTNPO/DF04cz6SBfW3O5nlVAFLjR6AaXXd
	QC6W2H6vENWIyFlotD4O/VYk+RNs13o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792536549; x=1824072549;
  h=date:from:to:cc:subject:message-id;
  bh=LYOblehVC5QGAH9hfYsbb2HvSCv5rGDVxMrcoBtu05c=;
  b=jKwgE6NfTrmB/CUQm7FoDzjLXMVAa3Jwmu5uKX0yFVm1iJKvSO29COqW
   fn3SU+dGf+1TVNsn3KDyadlgDIhuWy+/MgJw6b5YFC3vGGXkcBU7tIp2m
   o/RzPeK1pXYnUy2EoRG1Z0Hci/V2tlMeaVaGl//JeZ6/xHV1GF1AXCGau
   emW/hJ5dQZ2JhuPjitoGrUTkEn7FvQJ6uNB/dnVEAFAbn3JZwIxdznO70
   7AOfM+wSC2mEEOyU7Lny0/9V2kve4qEQuSRoUHD5I8fp38pWmXtsNO4uC
   lAfjkfWgFejbwGB6KovVPNrpuGZIh4hwFO25iK7iKoaPxs+qQ+rtOqeS+
   Q==;
X-CSE-ConnectionGUID: ZCldhNKCTu6HNq11s5Do0g==
X-CSE-MsgGUID: uxQfI+r7SfCjL6VyhM7dDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1155363"
X-IronPort-AV: E=Sophos;i="6.27,169,1787036400"; 
   d="scan'208";a="1155363"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 15:49:07 -0700
X-CSE-ConnectionGUID: hE5r6CS3TWKLmx1NUQH7iQ==
X-CSE-MsgGUID: b/Rhp6ixSOanmJdK9QAFlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3272377"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 20 Oct 2026 15:49:06 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xJIdj-00000000OcY-0Ili;
	Tue, 20 Oct 2026 22:49:03 +0000
Date: Wed, 21 Oct 2026 06:48:33 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 59d7f9ec14ad4b6f38c04d254f8f2bfb991e888e
Message-ID: <202610210630.BGP4enpf-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 44D0B40002
X-Stat-Signature: dqt573zfdy51c51f9bzkf4j17ma7u3o8
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792536548-279800
X-HE-Meta: U2FsdGVkX18PhBnFF5Y1DD5NINs0m+23eKenmUMoiiXQW6kL+1t6Z03cnbvNdLzYZA8aSf31iJnxscXkIU7bckVSMgUd7TIvHAEsw4Dz9spSe7vOqccnFYWOuJMWOtyjihvU/OaTo1eeNnvekauhykPgyrd82ySoBiakQ7ktawJ5FqL4zK8lX7KdcbH5lEcYCYb/oUa3CgDQTfAcfdg38g2ahlK7yoveQBAr3JJJcNs+D9wi24byAWcSjOswMYCOVoPfZxBs3Rya8fN4W687LNLvsdmWKxeCJF6pWB1nB0YujmzAWmC7QQ/U/De+iGfAj8sfBsDmiqihP5O9sN+4JdwzgSXjqOR6vU82Mvq5w2SPBp4IM05GGu0K+Nhm9mR1E0FXB8NkEJVvILsxXA90QFSADD6fStYMAU8kpLVl+bfeV5vWDWhOdIlwtSvTMzUqLG18ufheDN1USlhEbS4aa+6B1uWzjQmmasEniRjkCj+dtsfopxhF8FBdXQOhhSX7eJSqN58fk7vap73rBXZzp+yn15p6g6BITF97pWiGzl/q5KO66Vjcb8RXtn5YY39e99W/UaVJPjVYqZjQ6Xx85Pawv2Uc4b4jEpUlOnTMWvdsGtkEi//wipqFbqzhTeMVWa4gYDy51YGHnwc07QR+kEEOHala2zD0Bx1hmlwgNut2+rkPm91qJsFaia5rw8Cl/PABFioASNnjlkmXiwvgox8GFxScZ8+dOIc8mzt2ELeiBeKZLLPn7P0/LSp0mNPMjSACWGI5zIg2dZ/SURmJ2xiU4hMft0IIIAbPyOGgPnjNm09iFPxc9X/Ca5CukflUbK7msmF+O7wtLug3nYieLqqUGu4COveAURRpXvyPcX5CScd6TuPoHUF0AeqXHiaKSCt7WYuM5MKgey4OxIAqV0EVaeIyQVf/zjUC5Yi0ZCTnwJdJuuGgFuNdcwLHS60ymZdCx2qbYsWG5KEY34n
 CbItBTNR
 GmGAW/lKMgCQ7JXq3XnhT/xtJ0jzG7aWsrqTsNSzaiwVGe9korgBJVzxEs5Byia0rWxsNOOMMK9UWmSLNtwRhCIIMSTJuHT8lHjL23hzQ8NZXJnzsZpYz14ES9Kk2hUkY5PS0OLkJg5EcINEUqQeE5RSnPh9NmfNm++Sb/EA9tg6emFG8pWfFvgTo2SOmsuAi8wGsIgEW4oMvdk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 59d7f9ec14ad4b6f38c04d254f8f2bfb991e888e  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1075m

configs tested: 162
configs skipped: 8

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261021    gcc-16.2.0
arc                   randconfig-1001-20261021    gcc-14.4.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                      am200epdkit_defconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                              mxs_defconfig    clang-17
arm                            omap1_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261021    clang-24
arm                   randconfig-1001-20261021    clang-17
arm                   randconfig-1002-20261021    gcc-14.4.0
arm                   randconfig-1003-20261021    clang-17
arm                         vexpress_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261020    clang-17
arm64                 randconfig-1001-20261020    clang-24
arm64                 randconfig-1002-20261020    gcc-8.5.0
arm64                 randconfig-1003-20261020    clang-24
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261020    gcc-16.2.0
csky                  randconfig-1001-20261020    gcc-15.3.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261020    clang-17
hexagon               randconfig-1001-20261020    clang-17
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261020    clang-22
i386        buildonly-randconfig-1001-20261020    gcc-14
i386        buildonly-randconfig-1002-20261020    clang-22
i386        buildonly-randconfig-1003-20261020    clang-22
i386        buildonly-randconfig-1004-20261020    clang-22
i386        buildonly-randconfig-1005-20261020    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261020    clang-22
i386                  randconfig-1001-20261020    clang-22
i386                  randconfig-1002-20261020    gcc-14
i386                  randconfig-1003-20261020    clang-22
i386                  randconfig-1004-20261020    clang-22
i386                  randconfig-1005-20261020    gcc-14
i386                  randconfig-1006-20261020    clang-22
i386                  randconfig-1007-20261020    gcc-14
i386                  randconfig-1008-20261020    gcc-14
i386                  randconfig-1009-20261020    clang-22
i386                  randconfig-1010-20261020    gcc-14
i386                  randconfig-1011-20261020    gcc-14
i386                  randconfig-1012-20261020    clang-22
i386                  randconfig-1013-20261020    gcc-12
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261020    gcc-16.2.0
loongarch             randconfig-1001-20261020    clang-21
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261020    gcc-11.5.0
nios2                 randconfig-1001-20261020    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261020    gcc-15.3.0
parisc                randconfig-1001-20261020    gcc-13.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                       ppc64e_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261020    gcc-16.2.0
powerpc               randconfig-1001-20261020    clang-24
powerpc64             randconfig-1000-20261020    gcc-8.5.0
powerpc64             randconfig-1001-20261020    clang-17
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261020    gcc-12.5.0
riscv                 randconfig-1001-20261020    gcc-8.5.0
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261020    clang-24
s390                  randconfig-1001-20261020    gcc-10.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261020    gcc-16.2.0
sh                    randconfig-1001-20261020    gcc-11.5.0
sh                           rsk7264_defconfig    gcc-16.2.0
sh                            se7619_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261020    gcc-16.2.0
sparc                 randconfig-1001-20261020    gcc-8.5.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261020    clang-20
sparc64               randconfig-1001-20261020    clang-24
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261020    clang-17
um                    randconfig-1001-20261020    clang-20
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261020    clang-22
x86_64      buildonly-randconfig-1001-20261020    gcc-14
x86_64      buildonly-randconfig-1002-20261020    gcc-14
x86_64      buildonly-randconfig-1003-20261020    clang-22
x86_64      buildonly-randconfig-1004-20261020    gcc-13
x86_64      buildonly-randconfig-1005-20261020    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261020    clang-22
x86_64                randconfig-1001-20261020    clang-22
x86_64                randconfig-1002-20261020    clang-22
x86_64                randconfig-1003-20261020    gcc-14
x86_64                randconfig-1004-20261020    clang-22
x86_64                randconfig-1005-20261020    clang-22
x86_64                randconfig-1006-20261020    gcc-14
x86_64                randconfig-1007-20261020    gcc-14
x86_64                randconfig-1008-20261020    clang-22
x86_64                randconfig-1009-20261020    clang-22
x86_64                randconfig-1010-20261020    gcc-14
x86_64                randconfig-1011-20261020    clang-22
x86_64                randconfig-1012-20261020    gcc-14
x86_64                randconfig-1013-20261020    gcc-14
x86_64                randconfig-1014-20261020    clang-22
x86_64                randconfig-1015-20261020    gcc-14
x86_64                randconfig-1016-20261020    clang-22
x86_64                randconfig-1017-20261020    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                           iss_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261020    gcc-15.3.0
xtensa                randconfig-1001-20261020    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

