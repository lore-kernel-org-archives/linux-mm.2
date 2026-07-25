Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97BADC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 19:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C50B6B007B; Sat, 25 Jul 2026 15:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676086B0088; Sat, 25 Jul 2026 15:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565106B008A; Sat, 25 Jul 2026 15:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16CD26B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:23:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72B8F140373
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 19:23:49 +0000 (UTC)
X-FDA: 85028273778.30.6541356
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id A0F5A1C0009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 19:23:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RZijIaxq;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785007427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=CX+tgQpKBQLzIjT0b29sdrk080pd9HNF43Zn1Gfk8Fk=;
	b=d5HH17EJ+MIyKendkfqPhefFIgKaNy39dbVLwyR1THi8Gtsq1E5CCRMC/kqojvn9anZKTv
	/8OXMuJInRBGdD5lYjUDo9cP309ySGtoXJ4Jp1In8KNpTkt9l8LUR4n6aZCujvtw9S30cH
	B2fD9k49B67EN58V2f2s2la//+uYDsI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785007427;
	b=FVbowZ7cUlXl4GFFkC1xID0ymKuO84ozc21qiwFNpFOu/pwEtPGXvN1/PbBajwagCejJMZ
	P3xcD7bdR69AD6sFU3cjtBzVkhH6HHREbiUqZWuqtZj3P5k0LzMm52W5eqAaCnjXF8/142
	w8JbyClqogLjaIVe6wJNDAz0VcdTmzc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RZijIaxq;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785007427; x=1816543427;
  h=date:from:to:cc:subject:message-id;
  bh=jVg+L2Exyf4K4F6Gf2i3SjiVAQ4iYbUyeTmPcEkO1YM=;
  b=RZijIaxqJfOgPsX59b4x8mwz4seTk3gs6yIFad5JcfhwPbG8IseR4xdW
   9lNVC8iNSLDHjZrDBMfG3wGHsYPvfyQpUwk/SDh7gbipYT9Q1CEX3pWVx
   pL3MN8C45ackgIVYwrNQbHj4FkbFPMB5nWKnqf4kQ8Ywi8N/VzYDP25Tw
   kPt6qVfuCGvVLEPLbZRQim2pP3NE8Jx7kzBZ+sd39xR7kYChQ3bnC4pCq
   FzQLIhvmhuzBVczHEV3ywNfScfvZbkbkAyGEEghKDYoDmzQL1WMDHZwub
   PQQENEgRwA99EsNrnKEqddx7JJlQYh7Wmwjou2/lYATtp6JaGxiaBpy6B
   A==;
X-CSE-ConnectionGUID: g9ebHIN6QC2+S1QO2q15MQ==
X-CSE-MsgGUID: tf0hxLznTdq9BsUP06vrOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11856"; a="97151587"
X-IronPort-AV: E=Sophos;i="6.25,185,1779174000"; 
   d="scan'208";a="97151587"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 12:23:45 -0700
X-CSE-ConnectionGUID: GVhADuxjT2KVmxX9FvsHxQ==
X-CSE-MsgGUID: VoxEGVhSSMGW3Jyvys9FwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,185,1779174000"; 
   d="scan'208";a="297242565"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 25 Jul 2026 12:23:43 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnhxn-00000000c1u-03lw;
	Sat, 25 Jul 2026 19:23:32 +0000
Date: Sun, 26 Jul 2026 03:22:35 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH WARNING
 9eebf259d5352b87080d67758f483583d9e763d7
Message-ID: <202607260311.Mnd1CzmA-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A0F5A1C0009
X-Stat-Signature: ozmjaz34oiqhtuqb7x3hf3ohod8y8rid
X-Rspam-User: 
X-HE-Tag: 1785007426-332209
X-HE-Meta: U2FsdGVkX1/rSIAT74Z9meB06/6AIpfXx/Zo2CgefccMEwYr/LgE67rYt9xAdy/eoWybLj7uUFpuZZJSVREZNp87kA0inzmaT2UvUFUJ+NY2dekYJicPI2RFb4LeR/mv0h8f1+0pJQ+Vmg8mCsg6ZqUjRq5u2+OVG4RLFqT35RfPqWk2IrxPq3H3u5Ew0GLa0wIZG2VI0FCwcHR9Bgf10Z0X9m9hyktFs9/SavuGGfL48ku/veR3NgA58LjUu23Az2FhsiDQTPo2DaOS1miaTa47tY74qAxSEFYgtKwYoUjcgXRAn3NH2VyTBkTNUFvE0MDZdQwj1oL7EUamLnKHBs/V+XbpRwuPTmEPbq2CjWfCyhwS1AVzTugaaqQq6jpOf3NfQJNiO2XGGcrgP8m5pPHN6BEMrx+Cd0BPDhFOkPmYOdIL0pWBBQlzm7UpOKzyR8tQlyAWVWwRXilXYwMhTUwSdBSumknTBpqKhy2SM6y1/S9mqY4HqBnWMYFiGJ6rk1jqIcPI8VOgfvmrPvVu24wbL8x0m3QRlK4C/2n/CzmZTs64kufg0fGLfp+wh8Au8pq1mJkSKPqy9CpEqOFW4yKgGbL/6LnwWig+gdNPgtOFBD7HjDgcRtRO+qqK2UwCvjM+Hfebq1nxQoGL5GMbiYGWyI10CWjLRAM9toPP0PMrkPFDkQYlHWQgh4+UDS2QgEPQF3V05k3xGL0xT4k6mwxJjl9rq6VzJnvlj2xm12lvsvXRkbULSTAa29ugzTvCLKjKIYIk1fjekK+MH6tzVWQNoYbSMvO6LXs5KMIUcUpk3ddeAv5WVN8Y4zX+GS7FAl8M329z7alnEi4kLEYXFf4rzjkTXAFBx1gobyWjGEzZJHJc9hD0qWf9PDAxHRCN3iwnYODSll7cB160v4BiVFGuM1iNtDeIgI4JTXv9Om66k0ChBsJJN57osVzf8K+lG/8Kiq/Y2wRLDPdPMld
 hWa5QDtu
 mwn5wpCF2UJdZUtFADrIsIm66EFMest0jQDV8bGr2mLsijZ5olacWn7vxSqw4pMltpR3vdN/YaEA/5VVaPjcuf4gkPw5WVVgZITtM7bBB22S4v9XX/koJWk3/ucNMic8KMumaaTy7znKH5BaMxH+HtGl7ibIePwC0vFVhuIsNYoy1JnJ2AN1YfwG7qbYp51VZCtRaPv3usC2MmHWLgu7QuYQLVQzRk82R0AC0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9eebf259d5352b87080d67758f483583d9e763d7  Add linux-next specific files for 20260723

Warning (recently discovered and may have been fixed):

    Warning: drivers/gpu/drm/panthor/panthor_fw.c:143 Excess struct member 'end' description in 'panthor_fw_binary_section_entry_hdr' (did you mean one of: 'va.end', 'data.end')
    Warning: drivers/gpu/drm/panthor/panthor_fw.c:143 Excess struct member 'start' description in 'panthor_fw_binary_section_entry_hdr' (did you mean one of: 'va.start', 'data.start')
    Warning: drivers/gpu/drm/panthor/panthor_fw.c:200 Excess struct member 'buf' description in 'panthor_fw_section' (did you mean one of: 'data.buf')
    Warning: drivers/gpu/drm/panthor/panthor_fw.c:200 Excess struct member 'size' description in 'panthor_fw_section' (did you mean one of: 'data.size')
    Warning: drivers/gpu/drm/panthor/panthor_fw.c:273 Excess struct member 'ping_work' description in 'panthor_fw' (did you mean one of: 'watchdog.ping_work')
    Warning: drivers/gpu/drm/panthor/panthor_mmu.c:405 Excess struct member 'kernel_auto_va.size' description in 'panthor_vm' (did you mean one of: 'kernel_auto_va.end', 'kernel_auto_va', 'kernel_auto_va.start')
    Warning: drivers/mtd/nand/raw/omap2.c:671 Excess function parameter 'ecc_data2' description in 'omap_compare_ecc' (did you mean one of: 'ecc_data1', 'page_data')
    Warning: drivers/phy/apple/atc.c:631 Excess struct member 'sw' description in 'apple_atcphy' (did you mean one of: 'swap_lanes')
    Warning: drivers/tee/qcomtee/async.c:107 Excess function parameter 'msg' description in 'async_release' (did you mean one of: 'async_msg')
    Warning: drivers/tty/serial/mux.c:117 Excess function parameter 'ports' description in 'mux_set_mctrl' (did you mean one of: 'port')
    Warning: fs/inode.c:1300 Excess function parameter 'isnew' description in 'inode_insert5' (did you mean one of: 'inode')
    Warning: fs/inode.c:1303 Excess function parameter 'isnew' description in 'inode_insert5' (did you mean one of: 'inode')

Unverified Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607260226.sVPNzyMU-lkp@intel.com

    fs/iomap/direct-io.c:939:36-37: WARNING opportunity for min()

Warning ids grouped by kconfigs:

recent_errors
|-- arc-allyesconfig
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-buf-description-in-panthor_fw_section-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-end-description-in-panthor_fw_binary_section_entry_hdr-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-ping_work-description-in-panthor_fw-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-size-description-in-panthor_fw_section-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_fw.c-Excess-struct-member-start-description-in-panthor_fw_binary_section_entry_hdr-(
|   |-- Warning:drivers-gpu-drm-panthor-panthor_mmu.c-Excess-struct-member-kernel_auto_va.size-description-in-panthor_vm-(
|   `-- Warning:drivers-phy-apple-atc.c-Excess-struct-member-sw-description-in-apple_atcphy-(
|-- csky-allmodconfig
|   |-- Warning:drivers-mtd-nand-raw-omap2.c-Excess-function-parameter-ecc_data2-description-in-omap_compare_ecc-(
|   `-- Warning:drivers-tee-qcomtee-async.c-Excess-function-parameter-msg-description-in-async_release-(
|-- i386-buildonly-randconfig-001-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-002-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-003-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-004-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-005-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-buildonly-randconfig-006-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- i386-randconfig-r053-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- loongarch-defconfig
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- m68k-randconfig-r051-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- microblaze-randconfig-r053-20260725
|   `-- fs-iomap-direct-io.c:WARNING-opportunity-for-min()
|-- parisc-defconfig
|   `-- Warning:drivers-tty-serial-mux.c-Excess-function-parameter-ports-description-in-mux_set_mctrl-(
|-- sh-defconfig
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- sparc-randconfig-r052-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-001
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-001-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-002-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-003-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-004-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-005-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-buildonly-randconfig-006-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-randconfig-161
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
|-- x86_64-randconfig-161-20260724
|   `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(
`-- x86_64-randconfig-r054-20260724
    `-- Warning:fs-inode.c-Excess-function-parameter-isnew-description-in-inode_insert5-(

elapsed time: 3026m

configs tested: 117
configs skipped: 1

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                           randconfig-001    gcc-8.5.0
arc                  randconfig-001-20260725    gcc-11.5.0
arc                  randconfig-002-20260725    gcc-8.5.0
arm                  randconfig-001-20260725    gcc-8.5.0
arm                  randconfig-002-20260725    clang-21
arm                  randconfig-003-20260725    gcc-10.5.0
arm                  randconfig-004-20260725    gcc-15.2.0
arm64                randconfig-001-20260725    clang-24
arm64                randconfig-002-20260725    gcc-13.4.0
arm64                randconfig-003-20260725    clang-24
arm64                randconfig-004-20260725    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260725    gcc-9.5.0
csky                 randconfig-002-20260725    gcc-16.1.0
hexagon                       randconfig-001    clang-17
hexagon              randconfig-001-20260725    clang-17
hexagon              randconfig-002-20260725    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260724    clang-22
i386       buildonly-randconfig-001-20260725    clang-22
i386       buildonly-randconfig-002-20260724    gcc-14
i386       buildonly-randconfig-002-20260725    gcc-14
i386       buildonly-randconfig-003-20260724    gcc-14
i386       buildonly-randconfig-003-20260725    clang-22
i386       buildonly-randconfig-004-20260724    gcc-13
i386       buildonly-randconfig-004-20260725    clang-22
i386       buildonly-randconfig-005-20260724    clang-22
i386       buildonly-randconfig-005-20260725    gcc-14
i386       buildonly-randconfig-006-20260724    clang-22
i386       buildonly-randconfig-006-20260725    gcc-14
i386                          randconfig-001    clang-22
i386                 randconfig-001-20260725    clang-22
i386                 randconfig-002-20260725    gcc-14
i386                 randconfig-003-20260725    gcc-14
i386                 randconfig-004-20260725    gcc-12
i386                 randconfig-005-20260725    clang-22
i386                 randconfig-006-20260725    gcc-14
i386                 randconfig-007-20260725    gcc-14
i386                 randconfig-011-20260725    gcc-14
i386                 randconfig-012-20260725    gcc-14
i386                 randconfig-013-20260725    gcc-14
i386                 randconfig-014-20260725    clang-22
i386                 randconfig-015-20260725    clang-22
i386                 randconfig-016-20260725    clang-22
i386                 randconfig-017-20260725    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260725    gcc-16.1.0
loongarch            randconfig-002-20260725    gcc-13.4.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260725    gcc-11.5.0
nios2                randconfig-002-20260725    gcc-9.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-001-20260725    gcc-10.5.0
parisc               randconfig-002-20260725    gcc-12.5.0
powerpc              randconfig-001-20260725    gcc-9.5.0
powerpc              randconfig-002-20260725    gcc-15.2.0
powerpc64            randconfig-001-20260725    clang-17
powerpc64            randconfig-002-20260725    clang-24
riscv                randconfig-001-20260725    gcc-8.5.0
riscv                randconfig-002-20260725    gcc-8.5.0
s390                 randconfig-001-20260725    gcc-10.5.0
s390                 randconfig-002-20260725    gcc-16.1.0
sh                                 defconfig    gcc-16.1.0
sh                       edosk7760_defconfig    gcc-16.1.0
sh                   randconfig-001-20260725    gcc-16.1.0
sh                   randconfig-002-20260725    gcc-11.5.0
sparc                randconfig-001-20260725    gcc-16.1.0
sparc                randconfig-002-20260725    gcc-8.5.0
sparc64              randconfig-001-20260725    gcc-8.5.0
sparc64              randconfig-002-20260725    gcc-10.5.0
um                   randconfig-001-20260725    gcc-14
um                   randconfig-002-20260725    clang-24
x86_64              buildonly-randconfig-001    gcc-12
x86_64     buildonly-randconfig-001-20260724    clang-22
x86_64     buildonly-randconfig-001-20260725    clang-22
x86_64     buildonly-randconfig-002-20260724    clang-22
x86_64     buildonly-randconfig-002-20260725    clang-22
x86_64     buildonly-randconfig-003-20260724    gcc-14
x86_64     buildonly-randconfig-003-20260725    clang-22
x86_64     buildonly-randconfig-004-20260724    clang-22
x86_64     buildonly-randconfig-004-20260725    gcc-12
x86_64     buildonly-randconfig-005-20260724    clang-22
x86_64     buildonly-randconfig-005-20260725    gcc-12
x86_64     buildonly-randconfig-006-20260724    clang-22
x86_64     buildonly-randconfig-006-20260725    gcc-14
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260725    gcc-14
x86_64               randconfig-002-20260725    clang-22
x86_64               randconfig-003-20260725    clang-22
x86_64               randconfig-004-20260725    clang-22
x86_64               randconfig-005-20260725    clang-22
x86_64               randconfig-006-20260725    clang-22
x86_64                        randconfig-011    gcc-14
x86_64               randconfig-011-20260725    gcc-14
x86_64               randconfig-012-20260725    gcc-14
x86_64               randconfig-013-20260725    gcc-14
x86_64               randconfig-014-20260725    gcc-14
x86_64               randconfig-015-20260725    gcc-14
x86_64               randconfig-016-20260725    gcc-14
x86_64               randconfig-071-20260725    gcc-14
x86_64               randconfig-072-20260725    gcc-14
x86_64               randconfig-073-20260725    gcc-14
x86_64               randconfig-074-20260725    gcc-14
x86_64               randconfig-075-20260725    gcc-14
x86_64               randconfig-076-20260725    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260725    gcc-16.1.0
xtensa               randconfig-002-20260725    gcc-8.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

