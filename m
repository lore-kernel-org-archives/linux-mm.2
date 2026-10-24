Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC03A606A31B
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=G8lnX+Hv
Received: by kanga.kvack.org (Postfix)
	id ACCD86B008C; Sat, 24 Oct 2026 05:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AFA6B0092; Sat, 24 Oct 2026 05:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990826B0095; Sat, 24 Oct 2026 05:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C44E6B008C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 05:11:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6C89A7BDA
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 09:11:12 +0000 (UTC)
X-FDA: 85356950784.01.20B62B9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id D158C120008
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 09:11:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G8lnX+Hv;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792833071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=+kvFalUR9ocw39ncWjk9hYOuY18oIedH9wIuk1qbQ8I=;
	b=dtvDM/qXzapd2RkZGkJYfKzi/Pf62sWtUtmeDylPW7ZhSGWQa+ZCY/U4TcrVgdqhTCDM52
	nBnlZHelzVg0I7XrQ73ob32IkmJug34bXn7b8YGRUqEYWvGwNjJcCoaJyUxgNdpab1zfmo
	yNrwik1E6VtvnHFWQ+QLkmSTxSYoqGM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G8lnX+Hv;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792833071;
	b=wK0LU8DenAIry25b4zUZv0UmdZWZ9pbR42FhbSCh9ZtO1TvKiPhRnzsMMmOVKqgC+DhMHO
	XlwqKQelnpKYUks9YSMVg71a8z4s4fCfamUEAHI+mnDsMPOUV2jY/hPHLtoNdOPjpy/xAZ
	bklI1U8mZJpX815Dcs0X0y/+H+3CbPs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792833071; x=1824369071;
  h=date:from:to:cc:subject:message-id;
  bh=dWmbJf3qKZcmJWnouZwfjdmVDZovyLdezGpiUmsPyF4=;
  b=G8lnX+HvtOFhSH3d+BlGM3A74UKoMvwEvmXY9+/5plGIql2f6d6pOHF1
   4OJuxQDNrem4cuyvEMh7YaM56rb6YE66288j7aaeEmZ91wvv0PG3bmZtm
   YyGFmoXd2tncyWKa4Wmlqrs0cVAza/cTfZTridAwMi268BqR4bn4dOFp9
   7/WFUyQATksY9FW0TQlpWe5ivEHK0wFi8IK136Tn/DDZ1MeCI+gyYUrpu
   c6BEAQTUTDKUPseJM6aE+PIrnjZ7oA0IFKHL4cii+Iag0MEK9MgU4tBq0
   hhsG26JYUO1h36gSmk3bzOGKF8I5GNu6jhm3TpeDdD75TTJCnuG5nTQjl
   w==;
X-CSE-ConnectionGUID: MNjX/ySoQbKH104yHk8S4Q==
X-CSE-MsgGUID: Hc0WuOTjTW6zybou2kQlGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1596674"
X-IronPort-AV: E=Sophos;i="6.27,176,1787036400"; 
   d="scan'208";a="1596674"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2026 02:11:09 -0700
X-CSE-ConnectionGUID: rIe/DfWcRmCgxfTY0Tb8Rg==
X-CSE-MsgGUID: lJP3SIZvTsOB8+AaK68n4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,176,1787036400"; 
   d="scan'208";a="4227639"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 24 Oct 2026 02:11:06 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xKXmJ-00000000TjW-293X;
	Sat, 24 Oct 2026 09:11:03 +0000
Date: Sat, 24 Oct 2026 17:10:22 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 3fdcce698abd9193752ee89fb1a440cdceb1b74a
Message-ID: <202610241712.y3nMZLnk-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D158C120008
X-Stat-Signature: u48a6qxhm31cmeddfisf3i15oiwpcjtf
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792833069-803723
X-HE-Meta: U2FsdGVkX19UCqNWVV1u8kGNSD8f8cZhVzImtIkRUJmRWZMReBvPKL8rO+1riJ2oXOcG1IS4v1mPXDtZ8iIfCiUhYvz0aNaHmPA3D18eweWun3PQ2p/JgerSy3pgSZVkSxIfRlsoWTTy3C/JSseUWMS3fpYB5+O5ivq/KvIvFSaNdoyPRB846xX2pd5oXKwxi3Kx7HvcDx5EMihmQEZkzPNVLVEJwWsrY2TiezLVYjnny0oyw8NjepLr/71egWE5LPoRTK7PXVQgzqLeCif9u1zt6GYTbrDLlMAKTAuitLevhXU8B6N0nGvHj0J11iOx6L7XEcEJ+dl9gk/ikXA/d1RxwP+H4gVwVKXtfYLlKRRKWJJJ5PbtPoEUexaPqtps0CemViw2dE6qy4KoMSNmOCspUdIkOq44vsxp44WWwc0jqwywxTeL04BV/ovLkIv1FLfX5yweuSipMyanTEUcOgmHaSECY/TjIpmlm+vujya1/Dq2RDTBH4NC9IqXhrSKBGJa2IhB/oYwAtq5AEBVoI/9rAPqsCTMQPEklasNxLLmfQePutV0dUl8DWQ3im2eNm7xE5ScdNXxRbEzRPBvRj1bGE05cO2uTZ0sNbiT05ZUzadH4mPZFKybAg+Naz66lAtd5gkQC0shMN1idlu8AK8E7J91x+Z9eGn+1zYQVCpXAhLqGJh0vNPYngYgVh66AsPhEPO9b1VxeJ4PAoSojfcu6+kI6kQ/+kaIP3MCLaWnHkcqnOsnZEfXUDX7sP11NqNy1ORhsCgnLxUYrmIC/wClxBLuOoMDKMuY+k3GyhaiNz9ypB/obSDkOm1Tw/9AhVk6Z83S2z6/tpe9ylmRnvPS0aXAzMZaCFt8s8AQfSzHZmnqmeLQuQF84DOsolBfYBzCR/gqXusQFGGlShJvoAoo7E+wVQIjebLj54XuDrdu7V9WRP8/67DjMpOS+qN9hKguSojzkhPC4c4rD1k
 qNQC5mW9
 +IOYBR/OHJYJcgzmzA6cEGP6qaAuv5ccN4e5/3yU4tJCC6HdmVOsLBvcIUZ25fz0fSs9rULCDbKhfUwHFU0divSqXobrKk9P5KldGXso8bidb/y6PkYlMDqHydWGshvl5QvwjO1oqquvNKqeLFNeI1GmuIl6GWKQyxdRnyaHHfFBmXIX2k5thoSSg92ZakEB1IOrAZCR0wjokwv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 3fdcce698abd9193752ee89fb1a440cdceb1b74a  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1222m

configs tested: 159
configs skipped: 11

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
arc                   randconfig-1000-20261023    gcc-8.5.0
arc                   randconfig-1001-20261023    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261023    clang-24
arm                   randconfig-1001-20261023    gcc-8.5.0
arm                   randconfig-1002-20261023    clang-17
arm                   randconfig-1003-20261023    gcc-14.4.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261023    clang-20
arm64                 randconfig-1001-20261023    gcc-8.5.0
arm64                 randconfig-1002-20261023    gcc-8.5.0
arm64                 randconfig-1003-20261023    gcc-15.3.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1001-20261023    gcc-12.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261023    clang-24
hexagon               randconfig-1001-20261023    clang-17
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261024    gcc-14
i386        buildonly-randconfig-1001-20261024    clang-22
i386        buildonly-randconfig-1002-20261024    clang-22
i386        buildonly-randconfig-1003-20261024    gcc-14
i386        buildonly-randconfig-1004-20261024    gcc-14
i386        buildonly-randconfig-1005-20261024    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261024    clang-22
i386                  randconfig-1001-20261024    clang-22
i386                  randconfig-1002-20261024    clang-22
i386                  randconfig-1003-20261024    gcc-14
i386                  randconfig-1004-20261024    clang-22
i386                  randconfig-1005-20261024    gcc-13
i386                  randconfig-1006-20261024    gcc-14
i386                  randconfig-1007-20261024    gcc-14
i386                  randconfig-1008-20261024    gcc-14
i386                  randconfig-1009-20261024    gcc-14
i386                  randconfig-1010-20261024    clang-22
i386                  randconfig-1011-20261024    clang-22
i386                  randconfig-1012-20261024    gcc-14
i386                  randconfig-1013-20261024    clang-22
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261023    gcc-13.5.0
loongarch             randconfig-1001-20261023    gcc-16.2.0
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                           atari_defconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                         m5307c3_defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           eyeq5_defconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261023    gcc-10.5.0
nios2                 randconfig-1001-20261023    gcc-11.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261024    gcc-15.3.0
parisc                randconfig-1001-20261024    gcc-8.5.0
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                    motionpro_defconfig    clang-24
powerpc                  mpc8313_rdb_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261024    gcc-12.5.0
powerpc               randconfig-1001-20261024    gcc-14.4.0
powerpc64             randconfig-1000-20261024    clang-19
powerpc64             randconfig-1001-20261024    clang-24
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261023    gcc-8.5.0
riscv                 randconfig-1001-20261023    gcc-13.5.0
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261023    gcc-8.5.0
s390                  randconfig-1001-20261023    gcc-9.5.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                 ecovec24-romimage_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261023    gcc-10.5.0
sh                    randconfig-1001-20261023    gcc-16.2.0
sh                         sh7757lcr_defconfig    gcc-16.2.0
sh                               ul2_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261024    gcc-16.2.0
sparc                 randconfig-1001-20261024    gcc-15.3.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261024    clang-24
sparc64               randconfig-1001-20261024    clang-24
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261024    gcc-14
um                    randconfig-1001-20261024    gcc-14
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261024    clang-22
x86_64      buildonly-randconfig-1001-20261024    gcc-14
x86_64      buildonly-randconfig-1002-20261024    clang-22
x86_64      buildonly-randconfig-1003-20261024    gcc-14
x86_64      buildonly-randconfig-1004-20261024    clang-22
x86_64      buildonly-randconfig-1005-20261024    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261023    gcc-12
x86_64                randconfig-1001-20261023    gcc-14
x86_64                randconfig-1002-20261023    gcc-14
x86_64                randconfig-1003-20261023    clang-22
x86_64                randconfig-1004-20261023    gcc-12
x86_64                randconfig-1005-20261023    clang-22
x86_64                randconfig-1006-20261023    clang-22
x86_64                randconfig-1007-20261023    gcc-14
x86_64                randconfig-1008-20261023    gcc-14
x86_64                randconfig-1009-20261023    clang-22
x86_64                randconfig-1010-20261023    clang-22
x86_64                randconfig-1011-20261023    clang-22
x86_64                randconfig-1012-20261024    gcc-14
x86_64                randconfig-1013-20261024    clang-22
x86_64                randconfig-1014-20261024    clang-22
x86_64                randconfig-1015-20261024    clang-22
x86_64                randconfig-1016-20261024    clang-22
x86_64                randconfig-1017-20261024    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                randconfig-1000-20261024    gcc-15.3.0
xtensa                randconfig-1001-20261024    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

