Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41969CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4B06B0005; Mon, 22 Jun 2026 14:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E346B008A; Mon, 22 Jun 2026 14:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6BD6B008C; Mon, 22 Jun 2026 14:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3E756B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:46:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 277CBC153D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:46:23 +0000 (UTC)
X-FDA: 84908429046.09.5DF597A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf08.hostedemail.com (Postfix) with ESMTP id A8D0E160012
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:46:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AS6jNDbu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782153981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=saaZNbL1xP6BFYcvImMmZw16cqbwSWsCE6giljApULI=;
	b=pXmy6juvssTa56Vw4Rjbr0cCQiWUFaw0WvOthON3K2TdpdjuxQR4xAoUY/5ZJlsUIVwRb7
	9MnfPdc0JL7w/rF7i4I8QzAsRrQgwa4M8ufqGRD3JJVf7hTS54WlnV2Hli83a5AZ8Lwbmw
	Ro/XHfUBh5wAWggM/E4STQNLBR7sCJo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AS6jNDbu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782153981;
	b=0arWXwiwU/WIq5pEHkpGPzUyfVMETzjlHl763hu/za2Yq9rzHoU6t4KV0Rh0IE61Q4HEzw
	eZ0ZJAU6jjNLeNJUplHlrm0jbOxUUVGjhYdbiFdaHGDyWv+P7ItAllGe6FdPdukoV369pd
	muBTnJJ83NFlR6dv5axV7viXI1w7EH0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782153980; x=1813689980;
  h=date:from:to:cc:subject:message-id;
  bh=LFeBm448ZH+AurP5febN8KfVhijbJzhf3SgQU1UwVuU=;
  b=AS6jNDbuANXlVSkGiJpB2QaU/TwtrRNY/uhr3BE3m1oSFAlko7x80jSy
   o7SrX2eIZ61t2+8hwFrrWmzXsl3SzbZ/gSSpwQjND0mAaDnCTgRODYr1e
   mkNbCdDzALwx0BIkjEpRwez226GFWeSKSGqElEky0lyb9iqmuegYiNz8I
   zz96vpVPWDBToqK6FsW0N/gR1eLCzCCwflnsZ9qeIgyu5gDMr4yp5+Ghb
   bUTpBCaErW+zyR00ebednTKDf/4nMRpUTTkQMh9F02TFynb4ovaQoLdKW
   oLFUu1FdG16NrqZXzdk9t0n17AVbo9j5GXpEKh2WJ4JG+VRzPxRse8dBO
   A==;
X-CSE-ConnectionGUID: BUgjmDztQrmrbFOdgJSg2A==
X-CSE-MsgGUID: 8CeOwGAqRH6WGn9ZAyH/zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="93548908"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="93548908"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 11:46:19 -0700
X-CSE-ConnectionGUID: HhdaVeN2Sse/Vy28/pd6kA==
X-CSE-MsgGUID: YCPMOoY0QzmOmUlXHtvk5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="254391490"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 22 Jun 2026 11:46:17 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wbjen-000000001jh-2fFb;
	Mon, 22 Jun 2026 18:46:06 +0000
Date: Tue, 23 Jun 2026 02:45:39 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 e1201ff76176ef666b13d1a4ec6b6190ddc6abc8
Message-ID: <202606230227.UGnWbsis-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: A8D0E160012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qyfin9kjezromuk1aukqfy75ht3dj8iz
X-HE-Tag: 1782153980-212460
X-HE-Meta: U2FsdGVkX1+mjN82kJZIaU3RT351FH0ufYXaK96PuoJTbQOidphzgxNMJVadH9B9KL+iCTPjTaJakiaxKR7xbcFxAHe8rqiuX4EuChs63q7W9w/jKeeE9UEyNyi6YUUHhnRV92lPJsua1ON+LM1FHGNRenNzb7EmeYg66mHj5kgYdVw4UlQUSJXeqMdA4FZ6/j12HNdqKWFkepxvKAxtqyHCK+VN64B3YklrfiPrzqVyW6r2xZF2OX1PGPJRSsmW/H6Plf5H/A/S7fRN+kYyh7Z6roJm9Z4GB24A9W4bjJMMds9XeYvt9fDq5tDhd9hxO/zywKfZePqo5hUP0pLZQaHyYFeaQn4Aln6cGxAE016QxIRF1ZQRwnBG1wDrOBnF7hw3iH6vHffok9GHdChZloGS9QEHLckZ8QRAiDtUP9TrpoIMcAtmeUmbDtuooOzTAD3/gd1qpGflY4lD5I5Y0BUPPhxHwB1G3TUVh6o1GSW5dLqGeEMc7z8UgDycLjo65bj/3w70lpKXaaa20rHXrWd3nqLJKlA/QNvqfzGYZXgEWo5StxtubFpTunZHV6RSU9X+tGf74a84magzSG/jP9EuXCxyjs5cWFUOVzxPpyJR0qpghih7T1XNHeUZ9J4DvgnnGX/Gfa8I1WO8TYMlTh4XplmrCt8bkLmAr0AuEOxETkqaxPeKX8dFH7JjI1F6p8UTd2ErNMEeWurLZMLYmGBK8c1AzNG0uBc8UcFacWCQujK0++YpxNx0kBJnrzUMUXl+mf5D6SK6ajmX7D85TMnNXiNlHYavAZEM1rAV65IsV2UBZQ7wlf4AuCpK/bnrM3Mm7oZupwMI32BW5z24acv/yxG6G75NbuWUR8xRnJ82Jb7kRj8KsmSrsk4J7GKnLeG2qbQIGcueNTcWlJ8awjB9KWPzh4Hw+bYJcWacvT+V/Vv9tGFpF/DL8P6GsImpV4VK0StDywt4rKfvzxK
 kD9g+G3S
 G+VWxO2o+30lSZhevp4Voh5oxUKLnIdhuyWc8zFdRBK1ZsekfQY4F6nA7qCZd6q6EZwil/P/Lwt7Bs6rmO4RSBOmlTKNA8Bh1kNN69+jv9KnfHKlZr0nxwZyWCj9L9mqcIA5TXOJz5zcopSf5RQjEs1c88hlrg7S/VJbSn5GU0qcWr39Vs35jPuBciHyOvrJoMRWL8jBBi2XSu7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: e1201ff76176ef666b13d1a4ec6b6190ddc6abc8  mm/swap, PM: hibernate: atomically replace hibernation pin

elapsed time: 952m

configs tested: 153
configs skipped: 16

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260622    gcc-15.2.0
arc                   randconfig-002-20260622    gcc-9.5.0
arm                               allnoconfig    clang-23
arm                                 defconfig    clang-23
arm                   randconfig-001-20260622    gcc-13.4.0
arm                   randconfig-002-20260622    clang-23
arm                   randconfig-003-20260622    gcc-8.5.0
arm                   randconfig-004-20260622    gcc-15.2.0
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260622    gcc-8.5.0
arm64                 randconfig-002-20260622    gcc-13.4.0
arm64                 randconfig-003-20260622    gcc-8.5.0
arm64                 randconfig-004-20260622    clang-22
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260622    gcc-13.4.0
csky                  randconfig-002-20260622    gcc-11.5.0
hexagon                          allmodconfig    clang-23
hexagon                           allnoconfig    clang-23
hexagon                             defconfig    clang-23
hexagon               randconfig-001-20260622    clang-23
hexagon               randconfig-002-20260622    clang-23
i386                              allnoconfig    gcc-14
i386        buildonly-randconfig-001-20260622    gcc-14
i386        buildonly-randconfig-002-20260622    clang-22
i386        buildonly-randconfig-003-20260622    gcc-14
i386        buildonly-randconfig-004-20260622    gcc-12
i386        buildonly-randconfig-005-20260622    gcc-14
i386        buildonly-randconfig-006-20260622    gcc-14
i386                                defconfig    clang-22
i386                  randconfig-001-20260622    gcc-14
i386                  randconfig-002-20260622    clang-22
i386                  randconfig-003-20260622    gcc-14
i386                  randconfig-004-20260622    gcc-14
i386                  randconfig-005-20260622    clang-22
i386                  randconfig-006-20260622    gcc-14
i386                  randconfig-007-20260622    clang-22
i386                  randconfig-011-20260622    gcc-14
i386                  randconfig-012-20260622    clang-22
i386                  randconfig-013-20260622    gcc-14
i386                  randconfig-014-20260622    clang-22
i386                  randconfig-015-20260622    clang-22
i386                  randconfig-016-20260622    clang-22
i386                  randconfig-017-20260622    clang-22
loongarch                         allnoconfig    clang-20
loongarch                           defconfig    clang-23
loongarch             randconfig-001-20260622    clang-18
loongarch             randconfig-002-20260622    clang-18
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260622    gcc-8.5.0
nios2                 randconfig-002-20260622    gcc-8.5.0
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                         randconfig-001    gcc-8.5.0
parisc                randconfig-001-20260622    gcc-14.3.0
parisc                         randconfig-002    gcc-12.5.0
parisc                randconfig-002-20260622    gcc-12.5.0
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    gcc-16.1.0
powerpc                       ebony_defconfig    clang-23
powerpc                        randconfig-001    gcc-10.5.0
powerpc               randconfig-001-20260622    gcc-8.5.0
powerpc                        randconfig-002    gcc-8.5.0
powerpc               randconfig-002-20260622    gcc-8.5.0
powerpc64                      randconfig-001    clang-16
powerpc64             randconfig-001-20260622    clang-21
powerpc64                      randconfig-002    clang-23
powerpc64             randconfig-002-20260622    clang-20
riscv                             allnoconfig    gcc-16.1.0
riscv                               defconfig    clang-23
riscv                 randconfig-001-20260622    clang-23
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    clang-18
s390                  randconfig-001-20260622    gcc-14.3.0
s390                  randconfig-002-20260622    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-16.1.0
sh                    randconfig-001-20260622    gcc-13.4.0
sh                    randconfig-002-20260622    gcc-15.2.0
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260622    gcc-16.1.0
sparc                 randconfig-002-20260622    gcc-8.5.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    clang-23
sparc64               randconfig-001-20260622    gcc-16.1.0
sparc64               randconfig-002-20260622    clang-23
um                               allmodconfig    clang-23
um                                allnoconfig    clang-16
um                               allyesconfig    gcc-14
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260622    gcc-14
um                    randconfig-002-20260622    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                            allnoconfig    clang-22
x86_64      buildonly-randconfig-001-20260622    clang-22
x86_64      buildonly-randconfig-002-20260622    clang-22
x86_64      buildonly-randconfig-003-20260622    clang-22
x86_64      buildonly-randconfig-004-20260622    clang-22
x86_64      buildonly-randconfig-005-20260622    gcc-14
x86_64      buildonly-randconfig-006-20260622    clang-22
x86_64                              defconfig    gcc-14
x86_64                randconfig-001-20260622    clang-22
x86_64                randconfig-002-20260622    gcc-14
x86_64                randconfig-003-20260622    clang-22
x86_64                randconfig-004-20260622    clang-22
x86_64                randconfig-005-20260622    gcc-14
x86_64                randconfig-006-20260622    gcc-14
x86_64                randconfig-011-20260622    clang-22
x86_64                randconfig-012-20260622    clang-22
x86_64                randconfig-013-20260622    gcc-14
x86_64                randconfig-014-20260622    gcc-14
x86_64                randconfig-015-20260622    clang-22
x86_64                randconfig-016-20260622    clang-22
x86_64                randconfig-071-20260622    gcc-14
x86_64                randconfig-072-20260622    gcc-14
x86_64                randconfig-073-20260622    clang-22
x86_64                randconfig-074-20260622    gcc-14
x86_64                randconfig-075-20260622    gcc-14
x86_64                randconfig-076-20260622    clang-22
xtensa                            allnoconfig    gcc-16.1.0
xtensa                randconfig-001-20260622    gcc-16.1.0
xtensa                randconfig-002-20260622    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

