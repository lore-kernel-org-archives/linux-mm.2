Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A063DC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9195A6B0092; Fri, 18 Sep 2026 05:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB7B6B0093; Fri, 18 Sep 2026 05:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0F86B0095; Fri, 18 Sep 2026 05:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE286B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:59:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C152D1C2208
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:59:30 +0000 (UTC)
X-FDA: 85226435700.11.776251F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0BEEA1A0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:59:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KGlCxCXO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KGlCxCXO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725568;
	b=MZDeyzMmDGPqvA760zNQGPeY92Ghzx/PTF/S12J/pQSKoynC8vKKG3ANJYfuga5qGr/Z1C
	tF9nm/bgvdJEXUZiWyX+ahrgWcrQT4sQrE4TNrzNaAQ6egODDn0rF13LW0osT/iZZDzGI7
	zwJO+6nHrAIUesSH/Vr0fwqeJuKcp18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/zUOHFMxVfvSJ1Y0cGDgT5Mz/1dsKEZohxhuhkQ4Y3o=;
	b=e3IYvtoheeQe3Fetiop1+yWg419vFj3BfbOYlzPLR1nGj2lT02arTPMI+BcZJjt6y68T08
	LJUp0/5VBot6wsyyWLnxPt4RyNvb0wAjfmd68bPspsOCxHXmnVjbJVocDxyU4KmJlA0B1A
	ILST5rbtUWXvN+uh5NCPf4W0+jmxnZU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789725568; x=1821261568;
  h=date:from:to:cc:subject:message-id;
  bh=w15uyUcvETcA+eji5E2S/4k4jRZsuknMlEzT9MlVGEw=;
  b=KGlCxCXOiLBo30CEC7/1lNgQJ7G+bdQRks2TjewGLONTNlGe4xDwRGkF
   F6lsraGT4+lB+aKeh1YWj+N4lJX1KLOJfroRIWuBUfioKYOOAglJZ8Xh7
   dGvJvK3uT5ffqdclvqgEG+XgZHa+/qTRaac5EoDjoDJbxFA2h73+Gj8xJ
   E8gqaEn2ei7Kwk5WyPgATF2DSrkOahRRDzMVhUYoT8s+QxvEEK/UFP3qS
   7WeLNgtZ/HFyZWj7mWzoIcq7edIYdxuOM/kEHsdTNYQ1O1gMvw6qHVFLP
   VmvEVtaWVy2SW4aQXcZUOeXOLIqUlYruJPl/oApwXXuZA3xj4VYLXQ2P7
   g==;
X-CSE-ConnectionGUID: BDm+8C6jQVCstADpR0jVxQ==
X-CSE-MsgGUID: v36U/r4aSbWZAS9PJhryKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="90351999"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="90351999"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 02:59:27 -0700
X-CSE-ConnectionGUID: wzUsh3vTQBCrqEgpsd5Evg==
X-CSE-MsgGUID: SpZi+zeWTA+Yt0BMOql94g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="271643706"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 18 Sep 2026 02:59:25 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x7VNK-000000009ZB-2lns;
	Fri, 18 Sep 2026 09:59:22 +0000
Date: Fri, 18 Sep 2026 17:59:04 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS WITH WARNING
 0d9d0dbf2fddcff5859d623e90ca73c4054276e1
Message-ID: <202609181700.8gIl6dek-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BEEA1A0009
X-Stat-Signature: hp81akyw318kfu7i93qdrcgedebwuewe
X-Rspamd-Server: rspam01
X-HE-Tag: 1789725567-229659
X-HE-Meta: U2FsdGVkX181ZQ0kFlztMYmTD4mAXO8tYuSRCfUY3Th3odkkR5Deu7DYvp5/l5O4EP9ZGe32tVkbc3DE0aWABuy4VGQHeDtcyEcH/GTK/Lginvcbf9s5BholLZ9ie77q5fVVsUM5ImkIlP58ROHki8dITxMiuLf3eH1PkJ5XG/ZnIWSemgJ3j+ECr9QoEeEDochQICvHApISonnCUhG1y2SP7ffmU3+rQObI0LSAjR4YHLslzhLsx5tBQO/SFoNHEwAjxHDQ/okDKoUCzjMUd0gR40tSfh/djnPxQdBwu5pcl3tqZ4FpVSzjhTaB+JB1muiNsr4BVabJ4KW2yZA1VvEKTyEctVO+lQRC6gw05RPWQfD0Hq8du3x2kN9LO5VmzhljDWPqLjh/GB9jOqoSrBor5cJ4xhokcW3vGzoaYHPMwCNboDijQ+lsdlBSHujrvVuiYOKjr0rXof6EMtD/CaBHgQpjAnjM/a7iKGSUS9a6jDeDcAoy53vz9IWRWhdrnSrQ22516VdyBiI9URQ7vYY1SWZDBIxyb8GmN9RUXAFoayE+xQwOAPR4Kb8VHmSe2PqfZID1kMiKLe9cx0qbh7rtZXCCvG0QPRtxXmgVHsVFXOpi7ck0WwFnRriDYFFPsxW9FXWC+l+HICN/CM7O2mtFwwbaEu10HuDy7NaQkRmCQqNmiF2n9iDs/x6gvwmK8rIYkJBjrtEK5Gykd2HL7FdWxqCT3MmjvGcf1VFK+0lNb9cJbaDYTIVwE3ah7purdnv+hcfKZpYAHb7IHQCu2IsIY3o47oWBSQbokCtLrYZK6AyNVxImzrd41A56aMmGErLq1uOMlXr/aos2GojIZEmia+KLLJsWtTR8NatJJJnzABXFsxHEU2OZW7wIgFYc8poSPCzK3PMrXaGrGLRKt0k+6eBkHarpLH4WtjgOAqW9WmieX2y0Ng2K+gB4OeHLppr6SdC5U38Fq1A1z1b
 rDak4H+F
 t28hItmaD0DEhofxU/ge31BEKxGLY60DnJ6AdnoZNEaMBr7NvcmcCgl+XyaQmeyiVgJlCu/r1QgDJ/OWNK6VTsHsQNR+UYvt6V8LeSLaa7BvIqF70/Upl/oqzVNEKVspg8djC349R96hCxiHVk6r+3LkLRbL5XHlj6LCe1W8H8LRiA+cppjuW1B0C6hdLRobkkUvidpyaef4sQmxGMrUOLIXw0eEonpQRtPJn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 0d9d0dbf2fddcff5859d623e90ca73c4054276e1  Add linux-next specific files for 20260916

Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202609171628.owHko7Uz-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202609172035.C7lXJWMl-lkp@intel.com

    Warning: drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c:204 function parameter 'readonly' not described in 'amdgpu_ttm_map_buffer'
    Warning: drivers/remoteproc/da8xx_remoteproc.c:102 function parameter 'irq' not described in 'da8xx_rproc_callback'
    Warning: drivers/remoteproc/da8xx_remoteproc.c:102 function parameter 'p' not described in 'da8xx_rproc_callback'

Warning ids grouped by kconfigs:

recent_errors
|-- x86_64-allmodconfig
|   `-- Warning:drivers-remoteproc-da8xx_remoteproc.c-function-parameter-irq-not-described-in-da8xx_rproc_callback
|-- x86_64-rhel-9.4-ltp
|   `-- Warning:drivers-gpu-drm-amd-amdgpu-amdgpu_ttm.c-function-parameter-readonly-not-described-in-amdgpu_ttm_map_buffer
`-- xtensa-allyesconfig
    |-- Warning:drivers-remoteproc-da8xx_remoteproc.c-function-parameter-irq-not-described-in-da8xx_rproc_callback
    `-- Warning:drivers-remoteproc-da8xx_remoteproc.c-function-parameter-p-not-described-in-da8xx_rproc_callback

elapsed time: m

configs tested: 230
configs skipped: 2

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20260917    gcc-8.5.0
arc                   randconfig-1001-20260917    gcc-15.2.0
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                           gemini_defconfig    clang-24
arm                         mvebu_v5_defconfig    gcc-16.1.0
arm                   randconfig-1000-20260917    gcc-8.5.0
arm                   randconfig-1001-20260917    gcc-8.5.0
arm                   randconfig-1002-20260917    clang-17
arm                   randconfig-1003-20260917    gcc-8.5.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20260917    gcc-8.5.0
arm64                 randconfig-1001-20260917    gcc-8.5.0
arm64                 randconfig-1002-20260917    clang-24
arm64                 randconfig-1003-20260917    clang-17
arm64                randconfig-r2107-20260917    clang-24
arm64                randconfig-r2202-20260917    gcc-16.1.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20260917    gcc-9.5.0
csky                  randconfig-1001-20260917    gcc-11.5.0
csky                 randconfig-r2201-20260917    gcc-16.1.0
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20260917    clang-20
hexagon               randconfig-1001-20260917    clang-17
hexagon              randconfig-r2105-20260917    clang-19
i386                              alldefconfig    gcc-14
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20260917    clang-22
i386        buildonly-randconfig-1001-20260917    gcc-13
i386        buildonly-randconfig-1002-20260917    gcc-14
i386        buildonly-randconfig-1003-20260917    clang-22
i386        buildonly-randconfig-1004-20260917    clang-22
i386        buildonly-randconfig-1005-20260917    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20260917    clang-22
i386                  randconfig-1001-20260917    clang-22
i386                  randconfig-1002-20260917    clang-22
i386                  randconfig-1003-20260917    gcc-14
i386                  randconfig-1004-20260917    clang-22
i386                  randconfig-1005-20260917    clang-22
i386                  randconfig-1006-20260917    clang-22
i386                  randconfig-1007-20260917    gcc-13
i386                  randconfig-1008-20260917    clang-22
i386                  randconfig-1009-20260917    clang-22
i386                  randconfig-1010-20260917    clang-22
i386                  randconfig-1011-20260917    gcc-14
i386                  randconfig-1012-20260917    gcc-12
i386                  randconfig-1013-20260917    clang-22
i386                  randconfig-1300-20260917    gcc-14     sparse
i386                  randconfig-1301-20260917    gcc-14     sparse
i386                  randconfig-1302-20260917    gcc-12     sparse
i386                  randconfig-2100-20260917    gcc-14
i386                  randconfig-2101-20260917    gcc-14
i386                  randconfig-2102-20260917    gcc-14
i386                  randconfig-2103-20260917    clang-22
i386                  randconfig-2200-20260917    clang-22
i386                 randconfig-r2104-20260917    clang-22
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20260917    clang-24
loongarch             randconfig-1001-20260917    clang-24
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                 randconfig-r2104-20260917    gcc-8.5.0
m68k                 randconfig-r2201-20260917    gcc-13.4.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2102-20260917    gcc-10.5.0
microblaze           randconfig-r2107-20260917    gcc-12.5.0
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                            ci20_defconfig    clang-24
mips                 randconfig-r2103-20260917    clang-24
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20260917    gcc-11.5.0
nios2                 randconfig-1001-20260917    gcc-11.5.0
nios2                randconfig-r1308-20260917    gcc-11.5.0 sparse
nios2                randconfig-r2101-20260917    gcc-9.5.0
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc                   or1klitex_defconfig    gcc-16.1.0
openrisc                     or1ksim_defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20260917    gcc-11.5.0
parisc                randconfig-1001-20260917    gcc-9.5.0
parisc               randconfig-r1306-20260917    gcc-8.5.0  sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc               randconfig-1000-20260917    clang-24
powerpc               randconfig-1001-20260917    clang-24
powerpc64             randconfig-1000-20260917    clang-24
powerpc64             randconfig-1001-20260917    clang-22
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20260917    gcc-16.1.0
riscv                 randconfig-1001-20260917    clang-17
riscv                 randconfig-2000-20260917    clang-24
riscv                 randconfig-2001-20260917    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20260917    clang-17
s390                  randconfig-1001-20260917    clang-20
s390                  randconfig-2000-20260917    clang-17
s390                  randconfig-2001-20260917    clang-24
s390                 randconfig-r2106-20260917    gcc-15.2.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20260917    gcc-16.1.0
sh                    randconfig-1001-20260917    gcc-11.5.0
sh                    randconfig-2000-20260917    gcc-14.3.0
sh                    randconfig-2001-20260917    gcc-16.1.0
sh                   randconfig-r1306-20260917    gcc-16.1.0 sparse
sh                           rsk7269_defconfig    gcc-16.1.0
sh                      sh7710voipgw_defconfig    gcc-16.1.0
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20260917    gcc-8.5.0
sparc                 randconfig-1001-20260917    gcc-15.2.0
sparc                 randconfig-2000-20260917    gcc-16.1.0
sparc                 randconfig-2001-20260917    gcc-12.5.0
sparc                randconfig-r1308-20260917    gcc-8.5.0  sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20260917    clang-24
sparc64               randconfig-1001-20260917    gcc-8.5.0
sparc64               randconfig-2000-20260917    clang-20
sparc64               randconfig-2001-20260917    clang-20
sparc64              randconfig-r1307-20260917    clang-24   sparse
sparc64              randconfig-r1309-20260917    gcc-16.1.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20260917    gcc-14
um                    randconfig-1001-20260917    clang-17
um                    randconfig-2000-20260917    clang-20
um                    randconfig-2001-20260917    clang-17
um                   randconfig-r2106-20260917    gcc-14
um                   randconfig-r2200-20260917    clang-24
um                            x86_64_defconfig    clang-24
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20260917    gcc-13
x86_64      buildonly-randconfig-1001-20260917    gcc-14
x86_64      buildonly-randconfig-1002-20260917    gcc-14
x86_64      buildonly-randconfig-1003-20260917    gcc-14
x86_64      buildonly-randconfig-1004-20260917    gcc-14
x86_64      buildonly-randconfig-1005-20260917    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20260917    gcc-14
x86_64                randconfig-1001-20260917    clang-22
x86_64                randconfig-1002-20260917    gcc-14
x86_64                randconfig-1003-20260917    clang-22
x86_64                randconfig-1004-20260917    gcc-14
x86_64                randconfig-1005-20260917    gcc-14
x86_64                randconfig-1006-20260917    gcc-14
x86_64                randconfig-1007-20260917    gcc-14
x86_64                randconfig-1008-20260917    gcc-14
x86_64                randconfig-1009-20260917    clang-22
x86_64                randconfig-1010-20260917    clang-22
x86_64                randconfig-1011-20260917    gcc-14
x86_64                randconfig-1012-20260917    gcc-14
x86_64                randconfig-1013-20260917    gcc-14
x86_64                randconfig-1014-20260917    clang-22
x86_64                randconfig-1015-20260917    clang-22
x86_64                randconfig-1016-20260917    clang-22
x86_64                randconfig-1017-20260917    clang-22
x86_64                randconfig-1300-20260917    clang-22   sparse
x86_64                randconfig-1301-20260917    gcc-14     sparse
x86_64                randconfig-1302-20260917    gcc-14     sparse
x86_64                randconfig-2100-20260917    clang-22
x86_64                randconfig-2101-20260917    gcc-14
x86_64                randconfig-2102-20260917    gcc-14
x86_64                randconfig-2103-20260917    gcc-13
x86_64                randconfig-2200-20260917    gcc-14
x86_64               randconfig-r2105-20260917    gcc-14
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20260917    gcc-8.5.0
xtensa                randconfig-1001-20260917    gcc-13.4.0
xtensa                randconfig-2000-20260917    gcc-8.5.0
xtensa                randconfig-2001-20260917    gcc-10.5.0
xtensa               randconfig-r1307-20260917    gcc-8.5.0  sparse
xtensa               randconfig-r2100-20260917    gcc-8.5.0
xtensa               randconfig-r2202-20260917    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

