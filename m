Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C44C4C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5F16B08D6; Tue, 18 Aug 2026 00:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50306B08D7; Tue, 18 Aug 2026 00:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C176A6B08D8; Tue, 18 Aug 2026 00:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9888F6B08D6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:25:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7B25409AD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:25:35 +0000 (UTC)
X-FDA: 85113101430.05.8BC39AD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 402FA100004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:25:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UXu1DPck;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787027134;
	b=jo9SpX12AG2rTiKPe3sAsFL56cQq3I8FqDkGzgNzKHPy/aPhVSEgFo6jYGEnZYQfXAaRyu
	KY7XS9HlzISk+F/+wAPAFLIKAPxD2Qrz5HRPU7Z8GHFKi0suQKS4V3dVddNf1JxLESF1NL
	kGz4AVqoPTe18XYH3eg71nbfFsV3Cys=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UXu1DPck;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787027134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=g7K5Z2kIVByKPZBdJMoYY9k8A5aVS0m63ocgv431RcU=;
	b=nsZ7L+qzhUorHPlv9C4Wx1Kw4wV1j9YSfIWBhdYvE/qxnMy5Qrf0iSyTcvUpvE9y435tKb
	tFKKvO4s0KVOK77s37WBTSy0KwXbe5wqOZFDr951bPlxAsN8BlfLKge280R4TaLZxaSQbF
	mvV4ITEzD9qwTrwz56GUSRfSoBniLYY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787027133; x=1818563133;
  h=date:from:to:cc:subject:message-id;
  bh=AKfeuVMoPY1cuCSdmz85r2TT8nmwjetbFVFMFfAEzDs=;
  b=UXu1DPcksb6KsIVI8JleSUpOvayYjE5Ao3siRSplLWMYxZekd5L53ZFm
   fWlu35xTUh/VBP5YLA3t3f5oinfC4WDREd+2kRDO7Sms+w5E+Ukgl/K6z
   /3D90wsx90nMBesdBnzHPNjz4N2LwqDU7MN7IoXU+AQl+dIIEs+YZaNI0
   U1XizV1aA2wu83MxRzrvKfmtFskSHmGmf86s1zegHRbg3+p0Kl7jOy+7U
   4Ho41NrvT+2ErXHcX5FgGhwjN1hwAAGGWDo9e5oJFpjZyrGOJdopeQV1h
   9GEIMUyr/S4ykVQjHyy3rQ84lHptVPSO7ig9NUwVxgnidOqOaCZrJaC/h
   A==;
X-CSE-ConnectionGUID: iUL+2agKRS2PpH+53OE5Fw==
X-CSE-MsgGUID: 5cKH/H+HTdqw+vGIntH94Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="86626843"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="86626843"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 21:25:32 -0700
X-CSE-ConnectionGUID: dVJfKGo5RmuomVQZdebHIQ==
X-CSE-MsgGUID: hQ+Ex7iwS1KuYgbCW5FNyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="264668673"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 17 Aug 2026 21:25:31 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wwBOB-00000000e6g-3E97;
	Tue, 18 Aug 2026 04:25:27 +0000
Date: Tue, 18 Aug 2026 12:24:58 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 4b65683fd25fe596b5b5947d934bb176413d077b
Message-ID: <202608181245.wv1B7pIh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 402FA100004
X-Stat-Signature: 5fugk11wq4ss8f3663nf6ufi7jx7t4ha
X-HE-Tag: 1787027133-208275
X-HE-Meta: U2FsdGVkX1+BhZNCOzCbC98n00We58g+cim9AB6fBb216gTBj9duESdMEfHZ6xC17ji9qMGcXACiLaUHhqUkF8/5jNl1POAFc+1V0juaYNJQ09bO910lMTb5GvYD4MzX6kQJUoCWEANYX4BQ7yMCGjsbzs6V1l19WwL60eEAKQpjG40cXEf8oMKFqoR0q077FdWAzE507PW5/cb98+G6a3E1zMlBETkTpmvt11vXyz0+p5cJl7QJxCshyGYjDfjF+D+buOW3d5EdhtAmbHMYvuf8lRNX/CHY8u9Vbzadh6nH+iwQELFBLk1EXsPX1Mz3+Mo731F1FnNf45y7If++pJkqXwutpeWQOebjxD8f7m8KXFUGCfHjY8ma0f0AZQBnurJkpfIjZ9fula9Z16RrMnwhSd9wYOeiZXW5f+8d9blfkrB1G/h9fL6OpzeRbMcIYyyLepodX/87P0k+g0u7il67rIl/IVDiMvF9BMfzPrmRhp8Dh/PcGqzsJNPqefIYPpvN1YuY0Z/KL7SO1iKtI6fvAmhapI3uaGWpFvoqI32i4jVAd9UMRbSqhE2qcWjromngzssDywuDVM4Hv4kvbcaPIq4hXojnwvzkDfjEBw7G+ioUXKzgse5JyLpKZnmBSaxlzMtbislYrtmR/uiQPiyl0/iEHZZSoabhbamXPcqnI3/cCvleAf/m8OVw7mmRlOSEIcPuE0+CPLituacNYloNHMoXrtJET2lDb1BQrtgKmO+d9hrjSj1uRzhY0Q9omjeH2VOkL869nLlMYdCQ0cHgGeDyRMWTWPHx7QkemS0059fuMSFiJDzbIYFbr2yqRGZE385cqAtQ6Bz62nfpLgyYD3+t4IaZs5/oeCmczuwHI/OvG3XT0KuWCOtbei0+Qw489WkfYosJUzoOWCzlRbr/FCHvZTLP287n0RuVieGycVtJTNHVw1TXk5B1PitAbWMj1hbRUYQ28lIXqWD
 JF6murl4
 btGZPFTD/JNnLXNixEOh3p7A2UVvz/1my+5ihhYcpVvh+F/reKKtix6ctdBggDbSysy/soVQRJ32qeJAblKooT6xGM/TCIn856cisUc7/H6ZN/f6b8qZ9t2DRZtWlTvC6h4naUJpVqJz8WmOhQMJHxG6pGD23FD3Qq6HHKNptgBtspKY+f8uJwUbQfTqVf/M0NJ7/JmjvqXmxCCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 4b65683fd25fe596b5b5947d934bb176413d077b  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 2072m

configs tested: 165
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260817    gcc-8.5.0
arc                  randconfig-002-20260817    gcc-15.2.0
arc                  randconfig-002-20260817    gcc-8.5.0
arc                          tb10x_defconfig    gcc-16.1.0
arm                        at91_dt_defconfig    clang-17
arm                  randconfig-001-20260817    clang-24
arm                  randconfig-001-20260817    gcc-8.5.0
arm                  randconfig-002-20260817    clang-24
arm                  randconfig-002-20260817    gcc-8.5.0
arm                  randconfig-003-20260817    gcc-11.5.0
arm                  randconfig-003-20260817    gcc-8.5.0
arm                  randconfig-004-20260817    clang-24
arm                  randconfig-004-20260817    gcc-8.5.0
arm64                         randconfig-001    gcc-14.3.0
arm64                randconfig-001-20260817    gcc-11.5.0
arm64                randconfig-001-20260817    gcc-13.4.0
arm64                randconfig-001-20260818    gcc-14.3.0
arm64                randconfig-002-20260817    gcc-11.5.0
arm64                randconfig-002-20260818    gcc-14.3.0
arm64                randconfig-003-20260817    clang-17
arm64                randconfig-003-20260817    gcc-11.5.0
arm64                randconfig-003-20260818    gcc-14.3.0
arm64                randconfig-004-20260817    clang-24
arm64                randconfig-004-20260817    gcc-11.5.0
arm64                randconfig-004-20260818    gcc-14.3.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260817    gcc-11.5.0
csky                 randconfig-001-20260818    gcc-14.3.0
csky                 randconfig-002-20260817    gcc-11.5.0
csky                 randconfig-002-20260817    gcc-13.4.0
csky                 randconfig-002-20260818    gcc-14.3.0
hexagon              randconfig-001-20260817    clang-24
hexagon              randconfig-001-20260817    gcc-8.5.0
hexagon              randconfig-001-20260818    gcc-10.5.0
hexagon              randconfig-002-20260817    clang-24
hexagon              randconfig-002-20260817    gcc-8.5.0
hexagon              randconfig-002-20260818    gcc-10.5.0
i386                            allmodconfig    gcc-14
i386                buildonly-randconfig-001    gcc-12
i386       buildonly-randconfig-001-20260817    gcc-12
i386       buildonly-randconfig-002-20260817    gcc-12
i386       buildonly-randconfig-002-20260817    gcc-14
i386       buildonly-randconfig-003-20260817    gcc-12
i386       buildonly-randconfig-004-20260817    gcc-12
i386       buildonly-randconfig-004-20260817    gcc-14
i386       buildonly-randconfig-005-20260817    clang-22
i386       buildonly-randconfig-005-20260817    gcc-12
i386       buildonly-randconfig-006-20260817    gcc-12
i386       buildonly-randconfig-006-20260817    gcc-14
i386                 randconfig-001-20260817    gcc-14
i386                 randconfig-002-20260817    gcc-14
i386                 randconfig-003-20260817    gcc-14
i386                 randconfig-004-20260817    gcc-14
i386                 randconfig-005-20260817    gcc-14
i386                 randconfig-006-20260817    gcc-14
i386                 randconfig-007-20260817    clang-22
i386                 randconfig-007-20260817    gcc-14
i386                 randconfig-011-20260817    clang-22
i386                 randconfig-011-20260817    gcc-13
i386                 randconfig-012-20260817    clang-22
i386                 randconfig-013-20260817    clang-22
i386                 randconfig-013-20260817    gcc-14
i386                 randconfig-014-20260817    clang-22
i386                 randconfig-014-20260817    gcc-14
i386                 randconfig-015-20260817    clang-22
i386                 randconfig-016-20260817    clang-22
i386                 randconfig-017-20260817    clang-22
i386                 randconfig-017-20260817    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260817    clang-24
loongarch            randconfig-001-20260817    gcc-8.5.0
loongarch            randconfig-001-20260818    gcc-10.5.0
loongarch            randconfig-002-20260817    clang-18
loongarch            randconfig-002-20260817    gcc-8.5.0
loongarch            randconfig-002-20260818    gcc-10.5.0
mips                        db1xxx_defconfig    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260817    gcc-8.5.0
nios2                randconfig-001-20260818    gcc-10.5.0
nios2                randconfig-002-20260817    gcc-8.5.0
nios2                randconfig-002-20260818    gcc-10.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-13.4.0
parisc               randconfig-001-20260817    gcc-12.5.0
parisc               randconfig-001-20260817    gcc-13.4.0
parisc               randconfig-001-20260818    clang-24
parisc               randconfig-002-20260817    gcc-13.4.0
parisc               randconfig-002-20260817    gcc-8.5.0
parisc               randconfig-002-20260818    clang-24
powerpc                     arches_defconfig    gcc-16.1.0
powerpc              randconfig-001-20260817    gcc-13.4.0
powerpc              randconfig-001-20260817    gcc-8.5.0
powerpc              randconfig-001-20260818    clang-24
powerpc              randconfig-002-20260817    clang-19
powerpc              randconfig-002-20260817    gcc-13.4.0
powerpc              randconfig-002-20260818    clang-24
powerpc64            randconfig-001-20260817    gcc-13.4.0
powerpc64            randconfig-001-20260818    clang-24
powerpc64            randconfig-002-20260817    clang-24
powerpc64            randconfig-002-20260817    gcc-13.4.0
powerpc64            randconfig-002-20260818    clang-24
riscv                randconfig-001-20260817    gcc-10.5.0
riscv                randconfig-001-20260817    gcc-13.4.0
riscv                randconfig-002-20260817    gcc-10.5.0
riscv                randconfig-002-20260817    gcc-11.5.0
s390                 randconfig-001-20260817    clang-17
s390                 randconfig-001-20260817    gcc-10.5.0
s390                 randconfig-002-20260817    gcc-10.5.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260817    gcc-10.5.0
sh                   randconfig-001-20260817    gcc-15.2.0
sh                   randconfig-002-20260817    gcc-10.5.0
sh                   randconfig-002-20260817    gcc-9.5.0
sparc                randconfig-001-20260817    gcc-16.1.0
sparc                randconfig-002-20260817    gcc-8.5.0
sparc64              randconfig-001-20260817    gcc-10.5.0
sparc64              randconfig-002-20260817    gcc-16.1.0
um                   randconfig-001-20260817    clang-24
um                   randconfig-002-20260817    clang-17
x86_64     buildonly-randconfig-001-20260817    clang-22
x86_64     buildonly-randconfig-001-20260817    gcc-14
x86_64     buildonly-randconfig-002-20260817    clang-22
x86_64     buildonly-randconfig-002-20260817    gcc-14
x86_64     buildonly-randconfig-003-20260817    gcc-14
x86_64     buildonly-randconfig-004-20260817    gcc-14
x86_64     buildonly-randconfig-005-20260817    clang-22
x86_64     buildonly-randconfig-005-20260817    gcc-14
x86_64     buildonly-randconfig-006-20260817    clang-22
x86_64     buildonly-randconfig-006-20260817    gcc-14
x86_64                                 kexec    clang-22
x86_64               randconfig-001-20260817    clang-22
x86_64               randconfig-002-20260817    clang-22
x86_64               randconfig-002-20260817    gcc-14
x86_64               randconfig-003-20260817    clang-22
x86_64               randconfig-003-20260817    gcc-14
x86_64               randconfig-004-20260817    clang-22
x86_64               randconfig-004-20260817    gcc-14
x86_64               randconfig-005-20260817    clang-22
x86_64               randconfig-006-20260817    clang-22
x86_64               randconfig-011-20260817    clang-22
x86_64               randconfig-012-20260817    clang-22
x86_64               randconfig-013-20260817    clang-22
x86_64               randconfig-013-20260817    gcc-14
x86_64               randconfig-014-20260817    clang-22
x86_64               randconfig-015-20260817    clang-22
x86_64               randconfig-016-20260817    clang-22
x86_64               randconfig-016-20260817    gcc-14
x86_64               randconfig-071-20260817    clang-22
x86_64               randconfig-072-20260817    clang-22
x86_64               randconfig-073-20260817    gcc-14
x86_64               randconfig-074-20260817    clang-22
x86_64               randconfig-075-20260817    clang-22
x86_64               randconfig-076-20260817    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260817    gcc-8.5.0
xtensa               randconfig-002-20260817    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

