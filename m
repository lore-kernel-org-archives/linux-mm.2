Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BD4606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lG5nRJrJ
Received: by kanga.kvack.org (Postfix)
	id AAE3E6B05BD; Mon, 26 Oct 2026 11:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A853D6B05BE; Mon, 26 Oct 2026 11:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B556B05BF; Mon, 26 Oct 2026 11:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79C2D6B05BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:53:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E2E41C3FE3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:53:57 +0000 (UTC)
X-FDA: 85365223314.02.35BA44C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F8C2180003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:53:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lG5nRJrJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=VqxzS8fwgzLWYbePYKVt+w8xAcU28yr4TDFbVUA1IHc=;
	b=oaHC795BzvitKpzVPq63ERKF4sZzOpm7A3rTEH8qr3WSvynKj25u5Icp2m/rsag5oxzYJc
	F7cS4knZ+wW1bfyiLHQe1QMt7mXlHUvaCo72LCaPiMEfHIOoVLyO+jafYOjuJDQVfpK4X4
	BEsKHS9J1DssXXYjqe48nLWm+ajdioE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lG5nRJrJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793030035;
	b=MvkMGAx59PAnk5HOSvIfdgBQ+9gQTU6jdFEbk3XZ7kvJZA3RpSV2O6YeQHzZYUFPY/5ceV
	EI0eF2V9AMZMX3mRO0SdS6MfIkoCpHEFWwZ7TnYAQ4Fo9N+MFXkAzSwWYYiIknljRe97AN
	o2NrKTIMBwhTfcj6h43AgTPgmWuhL8s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793030035; x=1824566035;
  h=date:from:to:cc:subject:message-id;
  bh=V1LNmW1CHrNm69ucLl2xVsTweBKFJp7gHFdBmSZIikE=;
  b=lG5nRJrJZHEsEHXxva0rFKAb0Z8iM4wlOE6+M5TEhIzdOf43RmM8iqcT
   0We/X/B5NQW0MDIw4306xgU5T3L1qRKCpHL6MgljZHNKuWMxWbZPJO7mC
   +Mr6iSx8ILShLhKIqC39umnEZ8YHrQ/ENdi797T7MztHm2CBdfWt4vKGy
   eB5H/EyKDS1Nw0TiGN60f+6an4HvKffhBYOBFO1XCtsvYufe1r9t/kVlu
   jUzB6ILVubhYLW5NHMKAy1GBl4Ge8Nw5p5SwBedZf1HkPNcGMl2/ndhcH
   ck2HmZJFErkDCXwX8L2SKEIV5jNB8UafpF05fltbwv9FoRbpo9Pbl5exO
   g==;
X-CSE-ConnectionGUID: ixrTZOWyScOfCPyzyLjNrw==
X-CSE-MsgGUID: EDnnIjUwTK+P2polm8LMjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1694332"
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="1694332"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 08:53:37 -0700
X-CSE-ConnectionGUID: /CVOf7moT6O5j9eoSA81ZQ==
X-CSE-MsgGUID: +oJ5XFDwSBO1OPEUsD3iAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,179,1787036400"; 
   d="scan'208";a="4446541"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 26 Oct 2026 08:53:35 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLN0v-00000000WB0-0Opp;
	Mon, 26 Oct 2026 15:53:33 +0000
Date: Mon, 26 Oct 2026 23:53:11 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 73b6c575e9b3679e871df98b23758e90df2c6efa
Message-ID: <202610262301.ot4w6DSx-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 9F8C2180003
X-Stat-Signature: yuc1fmjmz4acjhaf9ciyiqfbgyuctt45
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793030034-902332
X-HE-Meta: U2FsdGVkX1+4lxpRwPXbuTXu+K63GEKhGibFV0J+C6kOZuIr1ZC1reDgGobMO0C+Vp1QbV747HxTMAc4VviKDoQUNlk481Su++MKI30UcNQpfIvXvO1ZWEag7DX9v52bMwJQHbp7rMCihjX/QghDBoZN9IkqW1ph58y3lp+iKKOUNO/HBZFF+8k/w1pyRo+e42A8bChXyYo0VnJJZ0fF4AZL2A9gOiY/olT0TpeDoEHINkJPPt1WkRVaKCVwkh9gWq/xWprRfLDdxNAk5qwB2ydr10FoFfeZ4RfMeZXF3MzZodBh6XUUTqjwpnv0AI2CWxd/JhQ6WsbIEvKcx+/iQhKcwIT63rLZPd3YXR05oFylyOkVBmKVdzbk52qApV11DruFYDhmezlLkKAfQFeiyJl9kRX4z2C72hoeE4r+A/7ycee5h6F5WhQ9DgbYUN5wH9ZGZAK89DugYxlBemn0g2uSpyT3z7FLuqHh/nVySN87KrTEJXeRREnhmvfGkLKHSU3cxWLDSXVkCKQ0vZtMBGl2pvE5MsLmrWfAYb8QcCjvd9c0nTvYJYPYpP8UgTq6FvyJJgjDtTfDSDiTf1GVtiGG8PVBhpX0gRhMf3EPF0M3elGVDJPFVK2IiTtS8qfd9P/0ls6r+fqxq+YhoGXPngOxB5kd4v2jXG7xPNRf2e8bwIfZxbd77HvVE2z7cvaExPN5s20sCKzTXRQh5aZmfdP+SkYdAojoMHn+uhawQ5XW0P0W4OUFV2PCdGw2thdjcxylovlJbqcNMwoImd1loYtnaS30GMltErjD1Gkc9J4SVDur6hsQPH2yMDNW/HObxcIKWr8Xrk2LEcCnsUVGfidLn5ZziPZwmT2X51MenxgHvPZip4QYEXJjlIfYidCmdA14rySVhNN27hnb1cyJkYllOuS2568s45q0aAqrVgNqWSo+6tLptRxoX2jUa/iHffMu3qMeccJeNHipzgy
 lyiTMF2a
 Bpns2ECgAj3usE8OwyYtsjnnyKtDzZo93zj5vwor5udnc+7JQc8BKWJZRGW6Ep8U2LLnyTRTz4HrQpP8Qy/ybhf1e9Db61dpgmia4k2tCfGl137AYqtAYzGJev8/1CGT/43f/l5NV5xKSeAdehS1FJ0nWHoGthYwn1aBj5BAvgc1FuDmYoaZzuLd9MVqL4Rjp1BnCBwRbgNaJBPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 73b6c575e9b3679e871df98b23758e90df2c6efa  riscv: mm: fix concurrency in mark_new_valid_map()

elapsed time: 1000m

configs tested: 158
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
arc                   randconfig-1000-20261026    gcc-11.5.0
arc                   randconfig-1001-20261026    gcc-8.5.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    clang-24
arm                           pxa910_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261026    gcc-13.5.0
arm                   randconfig-1001-20261026    gcc-15.3.0
arm                   randconfig-1002-20261026    gcc-13.5.0
arm                   randconfig-1003-20261026    clang-24
arm                     vt8500_v6_v7_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261026    clang-17
arm64                 randconfig-1001-20261026    gcc-14.4.0
arm64                 randconfig-1002-20261026    clang-24
arm64                 randconfig-1003-20261026    gcc-8.5.0
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261026    gcc-16.2.0
csky                  randconfig-1001-20261026    gcc-9.5.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261026    clang-24
hexagon               randconfig-1001-20261026    clang-24
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261026    gcc-13
i386        buildonly-randconfig-1001-20261026    gcc-14
i386        buildonly-randconfig-1002-20261026    gcc-14
i386        buildonly-randconfig-1003-20261026    gcc-14
i386        buildonly-randconfig-1004-20261026    gcc-14
i386        buildonly-randconfig-1005-20261026    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261026    clang-22
i386                  randconfig-1001-20261026    gcc-14
i386                  randconfig-1002-20261026    gcc-14
i386                  randconfig-1003-20261026    gcc-14
i386                  randconfig-1004-20261026    gcc-13
i386                  randconfig-1005-20261026    clang-22
i386                  randconfig-1006-20261026    gcc-13
i386                  randconfig-1007-20261026    gcc-14
i386                  randconfig-1008-20261026    clang-22
i386                  randconfig-1009-20261026    clang-22
i386                  randconfig-1010-20261026    gcc-12
i386                  randconfig-1011-20261026    clang-22
i386                  randconfig-1012-20261026    gcc-14
i386                  randconfig-1013-20261026    gcc-14
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261026    clang-24
loongarch             randconfig-1001-20261026    clang-24
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                 econet_en751221_defconfig    gcc-16.2.0
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261026    gcc-11.5.0
nios2                 randconfig-1001-20261026    gcc-9.5.0
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261026    gcc-9.5.0
parisc                randconfig-1001-20261026    gcc-15.3.0
parisc64                             defconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc                      mpc83xx_defconfig    clang-21
powerpc                      powernv_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261026    gcc-8.5.0
powerpc               randconfig-1001-20261026    gcc-8.5.0
powerpc64             randconfig-1000-20261026    clang-20
powerpc64             randconfig-1001-20261026    gcc-14.4.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261026    gcc-10.5.0
riscv                 randconfig-1001-20261026    clang-24
s390                               allnoconfig    clang-24
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261026    clang-17
s390                  randconfig-1001-20261026    clang-24
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261026    gcc-15.3.0
sh                    randconfig-1001-20261026    gcc-13.5.0
sh                            se7722_defconfig    gcc-16.2.0
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261026    gcc-8.5.0
sparc                 randconfig-1001-20261026    gcc-8.5.0
sparc                        sparc32_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261026    clang-24
sparc64               randconfig-1001-20261026    clang-24
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261026    clang-22
um                    randconfig-1001-20261026    gcc-14
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261026    gcc-14
x86_64      buildonly-randconfig-1001-20261026    clang-22
x86_64      buildonly-randconfig-1002-20261026    clang-22
x86_64      buildonly-randconfig-1003-20261026    clang-22
x86_64      buildonly-randconfig-1004-20261026    clang-22
x86_64      buildonly-randconfig-1005-20261026    clang-22
x86_64                               defconfig    gcc-14
x86_64                randconfig-1000-20261026    clang-22
x86_64                randconfig-1001-20261026    clang-22
x86_64                randconfig-1002-20261026    clang-22
x86_64                randconfig-1003-20261026    gcc-13
x86_64                randconfig-1004-20261026    clang-22
x86_64                randconfig-1005-20261026    gcc-14
x86_64                randconfig-1006-20261026    clang-22
x86_64                randconfig-1007-20261026    gcc-14
x86_64                randconfig-1008-20261026    gcc-14
x86_64                randconfig-1009-20261026    clang-22
x86_64                randconfig-1010-20261026    clang-22
x86_64                randconfig-1011-20261026    gcc-14
x86_64                randconfig-1012-20261026    gcc-14
x86_64                randconfig-1013-20261026    gcc-14
x86_64                randconfig-1014-20261026    gcc-14
x86_64                randconfig-1015-20261026    clang-22
x86_64                randconfig-1016-20261026    gcc-14
x86_64                randconfig-1017-20261026    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                   audio_kc705_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261026    gcc-13.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

