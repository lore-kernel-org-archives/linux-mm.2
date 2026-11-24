Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9D4606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 09:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UnvWvO4R
Received: by kanga.kvack.org (Postfix)
	id 0F19C6B0659; Tue, 24 Nov 2026 04:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2E76B065B; Tue, 24 Nov 2026 04:32:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9536B065C; Tue, 24 Nov 2026 04:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA95E6B0659
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:32:21 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A35E1A01A3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:32:19 +0000 (UTC)
X-FDA: 85469496798.30.DFA2A42
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A51A180005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:32:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UnvWvO4R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795512737;
	b=isEejiClaCw5Sd2gOigieUOmEHhUyz+sFOlxEYRx+waAcTvQA37azxpKpi9o+m/477tCli
	CR+0l7wZ4hgAb+5q803upeuCBC6yrHtW6LwoOimMgcMhClE0nLiXKIF8j8VVGIpZhMKbVq
	xmDErzMQ6qvsVy2UlrSIdIQRcCWOig8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795512737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=3leLo9NeoASMjuHKjFkn70Hkk1Zt7EsVVrRg3CEIPNU=;
	b=XFMU+t9FSe2rF09+VEeLgb11eNtlieCkmJKftpCCNp2Xc4y2PPmXwNropi/hag8lL3jwKC
	9aYUEW57rQFHFtbHb/Qu1ZuAsh6NNu7kxregXB7kvnfYjzYp1/bOiwvNp3k4pq1SehH3Od
	A1+qHVFNjNyMDVfd0uhj9yplQjDYoFg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UnvWvO4R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795512735; x=1827048735;
  h=date:from:to:cc:subject:message-id;
  bh=U5dVBxe0C8PTbXSZYUiCEkVItK+wepeVFxuUBfm5N+8=;
  b=UnvWvO4R2EVJiaaXylSk8/qjjVDuuaxp7ZpUtRIvKT2rSfE5koEAxsWQ
   2vBfVn3QXbNpMQAMC3adhGHNV4DogCq5mz051PJ5eyZdIAOUN/oOGmqtm
   v8+JhMLZgnleZbWxGqXnRRRHaZKM6lruCT/5U8K0Y3+62I61OfSrhqdPF
   NrfR5pumVR/m6m5tgJrmMrnRUEGbU1JXmZS8rEdU69ZcoVgRC6vdRQbEf
   J+YFe9GHKREO1l14jRhz4XlcERzJNKy8E9idZKwcZTYzz+S7vpG1hYpTn
   OMOM4aRqhMeieEyYdMFxk0/4EdQinLQXCAHpsEBBTyYtqlX+kkBZKuXrV
   w==;
X-CSE-ConnectionGUID: /Sog0P+bQlSjo4P3N6dc8w==
X-CSE-MsgGUID: 4kzLusgeQPSDBHWB1Ure4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="4252041"
X-IronPort-AV: E=Sophos;i="6.27,230,1787036400"; 
   d="scan'208";a="4252041"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 01:03:21 -0800
X-CSE-ConnectionGUID: pudJ75leRby1OENaek7xuA==
X-CSE-MsgGUID: oLnWS+hwT42h2Zst9Dhxnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,230,1787036400"; 
   d="scan'208";a="11815405"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 24 Nov 2026 01:03:18 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xVmQl-00000001OvS-49og;
	Tue, 24 Nov 2026 09:03:15 +0000
Date: Tue, 24 Nov 2026 17:03:00 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 87cdbd9bd63174de47ba16555bfe9800a8f3da07
Message-ID: <20261124170300.4E39XncB-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: po77nr4is3e4o746f6nf9z6bqxadjzni
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9A51A180005
X-Rspamd-Server: rspam03
X-HE-Tag: 1795512735-56758
X-HE-Meta: U2FsdGVkX19HdUDw//4UTyMhwlifAxNZH9Z/i+4zihm7wi1xuUS7KtSuOpoYABCQPn0vuiwv1k96w/tG98PYQtm/PJ2BI/n5NIsIABkOhgyCVxTuPShM6Cv5YckbxwkLpNItTR9a8MSILACXU1innsN5WmkfE7dw7u6jJqT1Wy7j0aMJ75MMPwK4E98Ypl6sopkYro4kvmv8A6D/rIj8MX6Q+sYwKU3/8jonj1yyYgI7SZi9VojH8iYCEDFohO60Hd99AK5TcIsPtb15TJj42BBUIQ09KXeFTmjS9zQ9n0wN4bjW/w5RmZ3Ht/rMHGIzNnc9BpfIUwhdtE4mq7kwH7VqkirvFDMUQBaA1ky2Nctecrf4jiYDJ7GV+FcWIfCDFua2Q0bdPGgR99HA4XbQXPgSCUHasiq05W28Any6i8T01F0IixtQS5hie27I6eAYdUHD8XfOycXVScx1fDN9zQPGzMKHzEHs+EePeq5UW3zxivRgqbcrkx2Y8wPysgr3C1eg5mDB7IZhgl2IjmqJVssRZl3ynw4q2B1ZVfcgotmOxXGVWGfpsUaztppLpp5y8WXj7f8KCnCQffFIru+6BMk+BH1vW98dY9rVVzI/Rxhw3foSTWnc16b2/Hboyo7bJ33uJDqoAiFM06xjDvZ7/cV9/PRpxFufdRsZCLdRhvie2WzLadYJx4i1j1hmemigqSa8Fa1e43JxHasWRLhZMW1JiqoDq8iz6AZnjxYOoDMgfESmi3uJt43EEnyKG4XRsX3fGbxZUoD21VTNIkMPHLicOFy4aBC+eav4+Loq/WD/xkujIQ55CNKLfM6AYJ3xu2gN4bNi7CbrV+JOgY6bfUyMtNfYmMJEsAxngxXaAR7gWdrRTp0wekjIKoA+W0k8vb9aVNPT8M7n3SdNL+QFv5gUsGKVnjVpl74HioUAtLNaimVXNCppfbdg03OChp5qzasABF/gqxXGm5a9gqI
 SDdUAM1A
 5k+CucyfMAf77wUz3box/NsPD9K4CulReEOQ/AAzs9IqQj685xSSD/W6J6FmEn7Yb9CqbcMyOvk2LKziY7W5b3KTa7yGxguOM3z89JLKYbzh9HU1gjRvcrT0x3xfTPaij+3CQpEQlxmYiO8ZJdm7LUJktr8F5pwe/h4gXuK57moKo/HASachItQGJfxUe8Nln26TF2nF6qQ8j5CxIZF79+QjXkCiNg1vZqmbXlIA9zr2M4axONwcGrwqT2qwiuKBLSa6atagLq4odMZR3J7zmYatkcWWhsD1n9cI84HqoPyN2553Xvd5wl68Tzs/7WVjaEbL/4iOI+kKVnRR1c1R1zUA0WjurbS1YK+BJ07r4e51ZlvfcjoPMRLQGWgc84GT1GppQlzeHR+0WZFAMysxmInZeQgMq0Lys/Tk2Fso8oEfgfyJTU11tbggpEx3H5aeBImWkAkYss/Br+W8qIZ4hD73kdLxYR4EuIur2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 87cdbd9bd63174de47ba16555bfe9800a8f3da07  mm/mm_init: move pageblock migratetype init to memmap helpers

elapsed time: 989m

configs tested: 280
configs skipped: 9

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261123    gcc-14.4.0
alpha                 randconfig-2001-20261123    gcc-8.5.0
alpha                 randconfig-2200-20261123    gcc-12.5.0 smatch
alpha                randconfig-r2301-20261123    gcc-10.5.0 sparse
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261124    gcc-8.5.0
arc                   randconfig-1001-20261124    gcc-16.2.0
arc                   randconfig-2000-20261123    gcc-14.4.0
arc                   randconfig-2001-20261123    gcc-12.5.0
arc                   randconfig-2002-20261123    gcc-8.5.0
arc                   randconfig-2003-20261123    gcc-12.5.0
arc                   randconfig-2004-20261123    gcc-14.4.0
arc                   randconfig-2005-20261123    gcc-12.5.0
arc                   randconfig-2200-20261123    gcc-12.5.0 smatch
arc                  randconfig-r2105-20261123    gcc-15.3.0 cocci
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                       integrator_defconfig    clang-24
arm                         keystone_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261124    gcc-16.2.0
arm                   randconfig-1001-20261124    clang-24
arm                   randconfig-1002-20261124    clang-18
arm                   randconfig-1003-20261124    gcc-8.5.0
arm                   randconfig-2000-20261123    gcc-16.2.0
arm                   randconfig-2001-20261123    gcc-8.5.0
arm                   randconfig-2002-20261123    clang-20
arm                   randconfig-2200-20261123    gcc-8.5.0  smatch
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261124    gcc-8.5.0
arm64                 randconfig-1001-20261124    gcc-8.5.0
arm64                 randconfig-1002-20261124    gcc-8.5.0
arm64                 randconfig-1003-20261124    clang-22
arm64                 randconfig-2000-20261123    clang-24
arm64                 randconfig-2001-20261123    gcc-8.5.0
arm64                 randconfig-2002-20261123    clang-24
arm64                 randconfig-2200-20261123    clang-17   smatch
arm64                randconfig-r2107-20261123    clang-17   cocci
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261124    gcc-14.4.0
csky                  randconfig-1001-20261124    gcc-16.2.0
csky                  randconfig-2000-20261123    gcc-14.4.0
csky                  randconfig-2001-20261123    gcc-12.5.0
csky                  randconfig-2200-20261123    gcc-16.2.0 smatch
csky                 randconfig-r2104-20261123    gcc-15.3.0 cocci
csky                 randconfig-r2110-20261123    gcc-16.2.0 cocci
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261124    clang-24
hexagon               randconfig-1001-20261124    clang-24
hexagon               randconfig-2000-20261123    clang-18
hexagon               randconfig-2001-20261123    clang-24
hexagon               randconfig-2200-20261123    clang-24   smatch
hexagon              randconfig-r2103-20261123    clang-24   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261124    clang-22
i386        buildonly-randconfig-1001-20261124    gcc-14
i386        buildonly-randconfig-1002-20261124    gcc-14
i386        buildonly-randconfig-1003-20261124    gcc-12
i386        buildonly-randconfig-1004-20261124    clang-22
i386        buildonly-randconfig-1005-20261124    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261124    gcc-14
i386                  randconfig-1001-20261124    gcc-14
i386                  randconfig-1002-20261124    clang-22
i386                  randconfig-1003-20261124    clang-22
i386                  randconfig-1004-20261124    gcc-14
i386                  randconfig-1005-20261124    gcc-14
i386                  randconfig-1006-20261124    gcc-14
i386                  randconfig-2000-20261123    clang-22
i386                  randconfig-2001-20261123    clang-22
i386                  randconfig-2002-20261123    gcc-14
i386                  randconfig-2003-20261123    clang-22
i386                  randconfig-2004-20261123    gcc-14
i386                  randconfig-2005-20261123    gcc-12
i386                  randconfig-2100-20261123    clang-22   cocci
i386                  randconfig-2101-20261123    clang-22   cocci
i386                  randconfig-2102-20261123    clang-22   cocci
i386                  randconfig-2103-20261123    gcc-14     cocci
i386                  randconfig-2104-20261123    clang-22   cocci
i386                  randconfig-2105-20261123    gcc-14     cocci
i386                  randconfig-2200-20261123    gcc-14     smatch
i386                  randconfig-2300-20261123    gcc-13     sparse
i386                  randconfig-2301-20261123    clang-22   sparse
i386                  randconfig-2302-20261123    clang-22   sparse
i386                 randconfig-r2101-20261123    clang-22   cocci
i386                 randconfig-r2108-20261123    gcc-12     cocci
i386                 randconfig-r2303-20261123    clang-22   sparse
i386                 randconfig-r2304-20261123    gcc-14     sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261124    gcc-16.2.0
loongarch             randconfig-1001-20261124    clang-18
loongarch             randconfig-2000-20261123    gcc-16.2.0
loongarch             randconfig-2001-20261123    clang-22
loongarch             randconfig-2200-20261123    clang-24   smatch
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261123    gcc-15.3.0
m68k                  randconfig-2001-20261123    gcc-9.5.0
m68k                  randconfig-2200-20261123    gcc-8.5.0  smatch
m68k                 randconfig-r2300-20261123    gcc-12.5.0 sparse
m68k                 randconfig-r2302-20261123    gcc-8.5.0  sparse
m68k                 randconfig-r2308-20261123    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
microblaze            randconfig-2000-20261123    gcc-8.5.0
microblaze            randconfig-2200-20261123    gcc-16.2.0 smatch
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  randconfig-2000-20261123    gcc-8.5.0
mips                  randconfig-2001-20261123    gcc-10.5.0
mips                  randconfig-2002-20261123    gcc-16.2.0
mips                  randconfig-2200-20261123    gcc-14.4.0 smatch
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261124    gcc-10.5.0
nios2                 randconfig-1001-20261124    gcc-11.5.0
nios2                 randconfig-2000-20261123    gcc-8.5.0
nios2                 randconfig-2001-20261123    gcc-11.5.0
nios2                 randconfig-2200-20261123    gcc-8.5.0  smatch
nios2                randconfig-r2305-20261123    gcc-8.5.0  sparse
nios2                randconfig-r2311-20261123    gcc-8.5.0  sparse
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc          de0_nano_multicore_defconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261123    gcc-10.5.0
openrisc              randconfig-2001-20261123    gcc-16.2.0
openrisc              randconfig-2002-20261123    gcc-10.5.0
openrisc              randconfig-2200-20261123    gcc-12.5.0 smatch
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261124    gcc-12.5.0
parisc                randconfig-1001-20261124    gcc-14.4.0
parisc                randconfig-2000-20261123    gcc-8.5.0
parisc                randconfig-2001-20261123    gcc-10.5.0
parisc                randconfig-2200-20261123    gcc-14.4.0 smatch
parisc               randconfig-r2106-20261123    gcc-8.5.0  cocci
parisc64                             defconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                  canyonlands_defconfig    clang-22
powerpc               randconfig-1000-20261124    clang-24
powerpc               randconfig-1001-20261124    gcc-13.5.0
powerpc               randconfig-2000-20261123    gcc-8.5.0
powerpc               randconfig-2001-20261123    clang-24
powerpc               randconfig-2002-20261123    clang-21
powerpc               randconfig-2200-20261123    gcc-9.5.0  smatch
powerpc              randconfig-r2310-20261123    clang-24   sparse
powerpc64             randconfig-1000-20261124    clang-24
powerpc64             randconfig-1001-20261124    clang-24
powerpc64             randconfig-2000-20261123    gcc-8.5.0
powerpc64             randconfig-2001-20261123    clang-24
powerpc64             randconfig-2002-20261123    clang-24
powerpc64             randconfig-2200-20261123    gcc-15.3.0 smatch
powerpc64            randconfig-r2102-20261123    gcc-15.3.0 cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-2000-20261123    gcc-11.5.0
riscv                 randconfig-2001-20261123    gcc-13.5.0
riscv                 randconfig-2002-20261123    gcc-8.5.0
riscv                 randconfig-2003-20261123    gcc-8.5.0
riscv                 randconfig-2004-20261123    clang-24
riscv                 randconfig-2005-20261123    gcc-13.5.0
riscv                 randconfig-2200-20261123    clang-17   smatch
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-2000-20261123    gcc-15.3.0
s390                  randconfig-2001-20261123    gcc-9.5.0
s390                  randconfig-2002-20261123    clang-20
s390                  randconfig-2003-20261123    clang-22
s390                  randconfig-2004-20261123    gcc-15.3.0
s390                  randconfig-2005-20261123    gcc-8.5.0
s390                  randconfig-2200-20261123    clang-24   smatch
s390                 randconfig-r2111-20261123    clang-24   cocci
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                  kfr2r09-romimage_defconfig    gcc-16.2.0
sh                    randconfig-2000-20261123    gcc-16.2.0
sh                    randconfig-2001-20261123    gcc-16.2.0
sh                    randconfig-2002-20261123    gcc-10.5.0
sh                    randconfig-2003-20261123    gcc-16.2.0
sh                    randconfig-2004-20261123    gcc-14.4.0
sh                    randconfig-2005-20261123    gcc-16.2.0
sh                    randconfig-2200-20261123    gcc-16.2.0 smatch
sh                   randconfig-r2306-20261123    gcc-12.5.0 sparse
sh                           rsk7269_defconfig    gcc-16.2.0
sh                    rts7751r2dplus_defconfig    gcc-16.2.0
sh                           urquell_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261124    gcc-14.4.0
sparc                 randconfig-1001-20261124    gcc-8.5.0
sparc                 randconfig-2000-20261123    gcc-16.2.0
sparc                 randconfig-2001-20261123    gcc-8.5.0
sparc                 randconfig-2200-20261123    gcc-12.5.0 smatch
sparc                randconfig-r2109-20261123    gcc-16.2.0 cocci
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261124    clang-20
sparc64               randconfig-1001-20261124    gcc-13.5.0
sparc64               randconfig-2000-20261123    clang-24
sparc64               randconfig-2001-20261123    gcc-9.5.0
sparc64               randconfig-2200-20261123    clang-22   smatch
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261124    clang-24
um                    randconfig-1001-20261124    clang-24
um                    randconfig-2000-20261123    gcc-14
um                    randconfig-2001-20261123    gcc-14
um                    randconfig-2200-20261123    clang-21   smatch
um                   randconfig-r2307-20261123    clang-19   sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261124    gcc-14
x86_64      buildonly-randconfig-1001-20261124    gcc-14
x86_64      buildonly-randconfig-1002-20261124    gcc-14
x86_64      buildonly-randconfig-1003-20261124    gcc-14
x86_64      buildonly-randconfig-1004-20261124    gcc-14
x86_64      buildonly-randconfig-1005-20261124    gcc-14
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261124    gcc-14
x86_64                randconfig-1001-20261124    gcc-14
x86_64                randconfig-1002-20261124    gcc-14
x86_64                randconfig-1003-20261124    clang-22
x86_64                randconfig-1004-20261124    gcc-12
x86_64                randconfig-1005-20261124    gcc-12
x86_64                randconfig-2000-20261123    gcc-14
x86_64                randconfig-2001-20261123    gcc-14
x86_64                randconfig-2002-20261123    gcc-14
x86_64                randconfig-2003-20261123    gcc-14
x86_64                randconfig-2004-20261123    gcc-14
x86_64                randconfig-2005-20261123    gcc-14
x86_64                randconfig-2100-20261123    gcc-14     cocci
x86_64                randconfig-2101-20261123    clang-22   cocci
x86_64                randconfig-2102-20261123    clang-22   cocci
x86_64                randconfig-2103-20261123    clang-22   cocci
x86_64                randconfig-2104-20261123    clang-22   cocci
x86_64                randconfig-2105-20261123    gcc-13     cocci
x86_64                randconfig-2200-20261123    gcc-14     smatch
x86_64                randconfig-2300-20261123    clang-22   sparse
x86_64                randconfig-2301-20261123    gcc-14     sparse
x86_64                randconfig-2302-20261123    gcc-14     sparse
x86_64               randconfig-r2309-20261123    gcc-14     sparse
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261124    gcc-8.5.0
xtensa                randconfig-1001-20261124    gcc-8.5.0
xtensa                randconfig-2000-20261123    gcc-16.2.0
xtensa                randconfig-2001-20261123    gcc-8.5.0
xtensa                randconfig-2200-20261123    gcc-8.5.0  smatch
xtensa               randconfig-r2100-20261123    gcc-9.5.0  cocci

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

