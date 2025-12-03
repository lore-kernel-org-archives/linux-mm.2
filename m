Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEE5D1BDD2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 19:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9A66B0012; Wed,  3 Dec 2025 14:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA586B0022; Wed,  3 Dec 2025 14:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6992D6B0026; Wed,  3 Dec 2025 14:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58EFD6B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:27:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FDDCBA616
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:27:39 +0000 (UTC)
X-FDA: 84179144238.15.9D429C2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8DD2020002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:27:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K9oHxFwy;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764790057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=3gnsdi7MIcUwU25hrotmODKSrGsA25hhLAn0m/O4l24=;
	b=U3NNUd6BAOTQCOm1JXAazIoruQjpr0+kB6IVw8RXUz4QP92lPBUFTgl5XjirTiqPwjpeiv
	2g2m1AdbXLjKXd1zRQnVQNsZhDIIEEvImq9tStqrDAcjcIWfVJLR8U2CSSvikoERAehmvN
	mlUfF8/bMFSxF9Xts6UDFHuNkqXB8tg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K9oHxFwy;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764790057; a=rsa-sha256;
	cv=none;
	b=SJd0v5KvwBSPi5nk7ub9MB6aThMPoFlHIH6OMO49KnSmOgNacMcB2gmTtacdwDZWBYgppF
	CyBW9fc2ea/t6XvCi+3uyKlWTylap1eg1MwMCfOUh2nhf6sLZspt9lkGrBqAnrACTvDIJr
	YSU//Msw/GNVGiuar5FQhzgj3aFiMn8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764790057; x=1796326057;
  h=date:from:to:cc:subject:message-id;
  bh=bnlH4sabP2hJF9bXgTVeHs4tjh+vRdgpVSBjYOD3OQY=;
  b=K9oHxFwygdByOpqc7Yl2osrFa/KEe8aMLrZnSw8b0M21+w5lfxm/eT4h
   wBboeCOTtNMe3XzuS3VpI1d2X1piGBww6noZtOWF4/6lubbJyP5GFYk9g
   AMfIWN/pUOdtcX9b0MkB/ogchXvaStd2Qvn0I0YO1gUnc1NRT5CCEwaDX
   wlQayN/kLYy5ReXQMZk/yhFAHwgR6AeyA6vpQaHZE1kj04aF8TN4A26gQ
   LdXFugvW5UgjzA2rz1xf/ZitX5CUX5vc433vhSN6mxwOVUNg6fYicrNJn
   j8jGQLTlNIM2YkggJfPXMTFUK+uex8/a0vY3iKkjFs4PFP+0nJsvyZ0tq
   A==;
X-CSE-ConnectionGUID: +3bHv6eNSqmVCRbtBj6OTw==
X-CSE-MsgGUID: vJ9nAcPfS+CMP0ZYoGAx3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66688832"
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="66688832"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 11:27:29 -0800
X-CSE-ConnectionGUID: WvFXdNw3RyS5nJcMZW2Wiw==
X-CSE-MsgGUID: lNFo1wTFQ02JMckKmQ4AVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="225721673"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 03 Dec 2025 11:27:26 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQsVY-00000000D1Z-1l7c;
	Wed, 03 Dec 2025 19:27:24 +0000
Date: Thu, 04 Dec 2025 03:26:26 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD SUCCESS WITH UNVERIFIED WARNING
 b2c27842ba853508b0da00187a7508eb3a96c8f7
Message-ID: <202512040318.fYi1U6Eg-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 8DD2020002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: boqop1ou6s1g9qujqa35cj6gbd4st38p
X-HE-Tag: 1764790056-361003
X-HE-Meta: U2FsdGVkX191YIYUr8rY1jnpb7B88v5CP5DkbODynnzGBw7PmurOvpowddUMxwjHLSQTuTlIoN54QqzidZZMj6idmDPji6HRX8ZUs439vhQJPKjNo9gEM0iaYhB9ak6wZpXPEKeAvkivuxRaBZvzPEaEd16QpLciLqNkbQVFFKWRkLsucB4rMvGJNKZFdDdiau+scRNbWe3Z2U94n6IAH4MqmUkDyxMOfBJwZkvfYyiht6XRlTbZBSyf9X+HJ8cE868aBGLjtCsyiF4fFiKcimrHbrMjKzjMwEnNdG1OSjgj3lpxT90trCJ17sFMQI0aci66kDFMu90uV/kD1goi5MkGMc7cYeAAVRJob3SF1V+vsVo61ZwRG8U6imn1STUlrklWTKeQsC4exDw1JpwvyVguO8iL5jnf+fvD3f0TsrdYrv4AcTyOEEbi3YNciICUfSrVS0PTGIl0Irnenp+u46Z4yUnl0mykPBxQ49qY+/ITDZlw5pw4+Mt4ugrC9apYvx7KO8SrznWi74nj2WkI65bqr91wAJyRDCDm4Ft7ZtV1sWZF0VSu4HuIYcFva2vsBe/wGVANWK1azkwnlKXFwTBOkCjtvZ4g0iABCHjBahZXESe/yORjysctS9JNEu8Y181kFg5YI5aGVuu//q1Suk4QcUDr6sJVkXUne9c3RMkFc4mk82qZZ4B7BRF3ewr3oMxfk9bEgUAJMzKVmbIi2wDn9hQHblmj16PZdeRDW8d+4Ls55WhoZFX3N0qnJnDfXwA/jdvt7e4MXfKHCT/ZDT+MASifPnyZhGKmbxgzjZPuUrCRkQNSPCVF9quRQRQlFS1iaJQS2yAcjY+9eeJKaslWCd82HIaV/zAfX677wgdy0jEJ1Bnv7fwUg41wsI+y5dcYUIej4drwfMk5JW3HKwbpRy6+VjcbhqdqEBSJGbfd6vX436dyIhuRrVMMJjqB1e0RJKf7OMhHVbaj2fn
 L2nJzfjP
 0TvDAWtifdGrDXtnQZPcaFuK6dOPj3ie9mbWAf9O+MP4KVbgz0R+UVjRbW99YvpsUw01iLA+EaltJYPX91Wpwyczh9wNWSXwvBEFI0W5Dz/7/1a/csvf14eEJ4I2ybGoSaV4LwnsDFdGsG2dFUa8/9DOomC344/BJS5cr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: b2c27842ba853508b0da00187a7508eb3a96c8f7  Add linux-next specific files for 20251203

Unverified Warning (likely false positive, kindly check if interested):

    Warning: sound/soc/fsl/fsl_dma.c:127 cannot understand function prototype: 'const struct snd_pcm_hardware fsl_dma_hardware ='
    Warning: sound/soc/fsl/p1022_ds.c:182 cannot understand function prototype: 'const struct snd_soc_ops p1022_ds_ops ='
    Warning: sound/soc/fsl/p1022_ds.c:62 cannot understand function prototype: 'struct machine_data'

Warning ids grouped by kconfigs:

recent_errors
`-- powerpc-randconfig-r123-20251203
    |-- Warning:sound-soc-fsl-fsl_dma.c-cannot-understand-function-prototype:const-struct-snd_pcm_hardware-fsl_dma_hardware
    |-- Warning:sound-soc-fsl-p1022_ds.c-cannot-understand-function-prototype:const-struct-snd_soc_ops-p1022_ds_ops
    `-- Warning:sound-soc-fsl-p1022_ds.c-cannot-understand-function-prototype:struct-machine_data

elapsed time: 808m

configs tested: 173
configs skipped: 2

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20251203    gcc-9.5.0
arc                   randconfig-002-20251203    gcc-11.5.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                       multi_v4t_defconfig    clang-16
arm                             mxs_defconfig    clang-22
arm                   randconfig-001-20251203    gcc-8.5.0
arm                   randconfig-002-20251203    clang-22
arm                   randconfig-003-20251203    clang-22
arm                   randconfig-004-20251203    clang-22
arm                       versatile_defconfig    gcc-15.1.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251203    gcc-8.5.0
arm64                 randconfig-002-20251203    clang-17
arm64                 randconfig-003-20251203    gcc-8.5.0
arm64                 randconfig-004-20251203    gcc-8.5.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251203    gcc-15.1.0
csky                  randconfig-002-20251203    gcc-15.1.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20251203    clang-22
hexagon               randconfig-002-20251203    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251203    gcc-14
i386        buildonly-randconfig-002-20251203    gcc-14
i386        buildonly-randconfig-003-20251203    gcc-14
i386        buildonly-randconfig-004-20251203    clang-20
i386        buildonly-randconfig-005-20251203    clang-20
i386        buildonly-randconfig-006-20251203    gcc-14
i386                                defconfig    clang-20
i386                  randconfig-001-20251203    clang-20
i386                  randconfig-002-20251203    gcc-14
i386                  randconfig-003-20251203    clang-20
i386                  randconfig-004-20251203    clang-20
i386                  randconfig-005-20251203    gcc-14
i386                  randconfig-006-20251203    gcc-14
i386                  randconfig-007-20251203    gcc-14
i386                  randconfig-011-20251203    clang-20
i386                  randconfig-012-20251203    gcc-14
i386                  randconfig-013-20251203    clang-20
i386                  randconfig-014-20251203    gcc-14
i386                  randconfig-015-20251203    gcc-13
i386                  randconfig-016-20251203    clang-20
i386                  randconfig-017-20251203    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251203    gcc-15.1.0
loongarch             randconfig-002-20251203    gcc-14.3.0
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251203    gcc-9.5.0
nios2                 randconfig-002-20251203    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20251203    gcc-12.5.0
parisc                randconfig-002-20251203    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                  iss476-smp_defconfig    gcc-15.1.0
powerpc               randconfig-001-20251203    gcc-8.5.0
powerpc               randconfig-002-20251203    clang-22
powerpc64             randconfig-002-20251203    clang-22
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20251203    gcc-14.3.0
riscv                 randconfig-002-20251203    clang-22
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20251203    clang-22
s390                  randconfig-002-20251203    clang-22
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                        edosk7760_defconfig    gcc-15.1.0
sh                          kfr2r09_defconfig    gcc-15.1.0
sh                    randconfig-001-20251203    gcc-15.1.0
sh                    randconfig-002-20251203    gcc-13.4.0
sh                           se7705_defconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251203    gcc-13.4.0
sparc                 randconfig-002-20251203    gcc-8.5.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20251203    clang-20
sparc64               randconfig-002-20251203    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251203    gcc-14
um                    randconfig-002-20251203    clang-20
um                           x86_64_defconfig    clang-22
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251203    clang-20
x86_64      buildonly-randconfig-002-20251203    clang-20
x86_64      buildonly-randconfig-003-20251203    clang-20
x86_64      buildonly-randconfig-004-20251203    gcc-14
x86_64      buildonly-randconfig-005-20251203    clang-20
x86_64      buildonly-randconfig-006-20251203    clang-20
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251203    gcc-14
x86_64                randconfig-002-20251203    gcc-14
x86_64                randconfig-003-20251203    clang-20
x86_64                randconfig-004-20251203    clang-20
x86_64                randconfig-005-20251203    gcc-14
x86_64                randconfig-006-20251203    gcc-14
x86_64                randconfig-011-20251203    gcc-14
x86_64                randconfig-012-20251203    clang-20
x86_64                randconfig-013-20251203    gcc-14
x86_64                randconfig-014-20251203    clang-20
x86_64                randconfig-015-20251203    gcc-14
x86_64                randconfig-016-20251203    clang-20
x86_64                randconfig-071-20251203    clang-20
x86_64                randconfig-072-20251203    gcc-14
x86_64                randconfig-073-20251203    clang-20
x86_64                randconfig-074-20251203    gcc-14
x86_64                randconfig-075-20251203    clang-20
x86_64                randconfig-076-20251203    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251203    gcc-14.3.0
xtensa                randconfig-002-20251203    gcc-11.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

