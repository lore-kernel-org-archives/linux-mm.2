Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F21CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 03:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC4C6B008A; Thu,  8 Oct 2026 23:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D116B008C; Thu,  8 Oct 2026 23:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A466B0092; Thu,  8 Oct 2026 23:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3926B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 23:24:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBE4E1C2646
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:24:24 +0000 (UTC)
X-FDA: 85301644848.25.4BD1D99
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE793140005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:24:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PjWAKrLh;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791516262;
	b=twz1SPJsv5bq3wNjwOuMxncmiMPfZIGKZIrVeiLElaWL/GoPY9ymRTFaX/Faep9UDoc94P
	pXU4tiWFoD53hkagobkYaqAhVwwHF0x1V0QITxWb5xBnnaIClJQv3lGh7lggNL6dCjCAK8
	D2+srYj37OOtOfMCFXNwCPwsgiwG3cE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PjWAKrLh;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791516262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UhA2bez15u9Q9qIt63jH6nT3aqrPU+yA977BboKL1t8=;
	b=g+eR8HZFC3wRxcqB50wxzxDyAA2F+I872EkeeTCA55oCCJQwEzGgIuND9oOU50B1CEfiy6
	TOi0z6CJBf9u9Kpq6M/CT57UeVfgQqHrnam2F/b7lzqTQEguUaJFSKoPmRtDF1dNtaFlXB
	PzUWAR2yy4J2NMcXgKzy/9AvBv4LvvQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791516262; x=1823052262;
  h=date:from:to:cc:subject:message-id;
  bh=sKs7OLsWgtqGNKZGS1+neje0lemXTvDt2ncwn13A860=;
  b=PjWAKrLhrFyHtuytQ4RlX9cD3T6qyn9KdzaGoiMKsDgGXTpbkeMrBot8
   AnGxmBdzTxzt5D/JLx/NEN3axPB1JWGTnhuJGb4jhymTbXcSAyVdS9dMa
   O+qVkvEAPNisf1qFhKebAN7g1NoxHbhFv0IGcdEpq0yNekWbN015n8Qc9
   J2Rl84jMC8uzOK2eASGqO9KlR3yaEFV36RAiQq1kbgVEJvjwSgzz3o1KQ
   8cKUwVGL6Dn1SeDZbkRuSKWddFZXqJqDCCI84YWzaVnEWfdgGKHZOONDF
   PwGLeeWNHQRBIuq0YC7OXyQUcChI+jrd1KwhjCAZhA+U7JIKz2ojIBg2h
   w==;
X-CSE-ConnectionGUID: fNg91wkHSP+wXaLYGvZwWw==
X-CSE-MsgGUID: WO1dOpRNTrSirXdOg74R8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="209836"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="209836"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 20:24:20 -0700
X-CSE-ConnectionGUID: aAhKcnhUQnKhhDHl7zWx0A==
X-CSE-MsgGUID: XYD1wk5hRcKzQ1LVUy23SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="323487"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 08 Oct 2026 20:24:19 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xF1DU-000000005FI-0ih7;
	Fri, 09 Oct 2026 03:24:16 +0000
Date: Fri, 09 Oct 2026 11:24:07 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 a92f009ac1c21986ff1ea0706419e545a4739513
Message-ID: <202610091102.4zn4FvX1-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE793140005
X-Stat-Signature: fyjqqrcc5fziuy9tor1ay5h3cqa4gzdg
X-HE-Tag: 1791516261-165847
X-HE-Meta: U2FsdGVkX1/uOwye2Lz54CtFftiDq5ksNw7GK792PyDNhNC4t2r7KzijM8igqtxQdDkhmZYh7kTiZyHmVJWqCh8SoApkQm1sqYf5rMI48a/1hfnDflLohKLAjfvCZaOZVqYPRiWAViYDBlvZ+ZkduW991F6nhyhAuo1vOfuo638W9h5MtpM2jm+nYW8741G1Az5VGtP4oz6yVhamWTcj/O2T7cZdYReESs2OWib+b2tO/2TyetOpXPLAmhbc4lHRkJzBV1TyxbT0unpbJaOWAP3fKa0HBaVcFoccfvBjkw16C/3XmjE7x7PsoIONl1i84M2PELwE8ZE3x4FjEPSsRNuYnUo5oYggw3XQrG838P36upL75Knq7t4isS0MzvouJ9eh05dTT//h37HsKbikycNHEqO20lc0C7jywefaKbP/URthy4j0gAzhiecfOtahzOYFp2KbyCwNklQu4FL3GHVHaunPwB5bnHgtwGQp3xnaeOBZAPnsQWwYS/B339V/89IgFC/1weet9kMrGSVbOGpx9u28dnNMlU+mR2q+qp/DS0P0x0MGYfI3l1l6joiXM1SRoPPe+1LveheRGQlqdqJecfkearigBli+BzsHF1CMcAuJy4V5iKl2eNMBsQulQMppy0Q9RmO9o0GpKnwZHYV7uRvtlsvDGDl8FQn2GM5V2KZbPyrbfpt6rl53kYF3WIbCFDBSAQ0yHvBkpa046mNQ8x3mieQGhKTmwKLQX58dBm6dROvPV+zFUJwVACQStKmCzOwRB1QLa7khWLkjb9lgjzbi+Uz+aI2iqdNyQoricfTtp4iEf1b7tcDZywXFbq0I2lekOvonPeCsE1IyawXgF1xEPLddDS0KNVfCAmkwP5Yu4I8T2p8iwKVBA5/GJuOg3A2JaMDP2aSWDrOeKVVustQSAeY9/ckNsrVRtuwhHZMqQopC+E0jMAPhJN3pbaHmXrOoD2UA0qsB2w6
 x/kwMMAH
 b5vHNcjS9vtYzGDOHIFkDqAIFBVWJPIyWzzrZFhTpLWOyncQbMQckJwYIB/k+e8AFR420B7tPc8b+raPJsf7nFQXyTUpxbEWOnyAufSwFztmLWHd/A8do/OSkDJtLMTDwJIVf83MuHMVzGxuIazgo5xAfcPntlcBo91LekTSrt8PBgomb3yoInjXGBZIRfnZpuGSJVHlmonuwkwo48IacCFHbVPxoPS5shAqe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: a92f009ac1c21986ff1ea0706419e545a4739513  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- i386-randconfig-2100-20261008
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20261008
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- i386-randconfig-r2107-20261008
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sh-randconfig-r2104-20261008
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc64-randconfig-r2103-20261008
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20261008
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2102-20261008
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2103-20261008
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2200-20261008
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
`-- x86_64-randconfig-r2201-20261008
    `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid

elapsed time: 858m

configs tested: 345
configs skipped: 7

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2200-20261008    gcc-16.1.0 smatch
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261008    gcc-8.5.0
arc                   randconfig-1001-20261008    gcc-8.5.0
arc                  randconfig-r2101-20261008    gcc-12.5.0 cocci
arc                  randconfig-r2201-20261008    gcc-13.4.0 smatch
arc                  randconfig-r2202-20261008    gcc-15.2.0 smatch
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    gcc-16.1.0
arm                          bcm2835_defconfig    clang-24
arm                                  defconfig    clang-24
arm                       footbridge_defconfig    clang-24
arm                             mps2_defconfig    clang-24
arm                         mvebu_v7_defconfig    clang-24
arm                   randconfig-1000-20261008    clang-18
arm                   randconfig-1001-20261008    clang-17
arm                   randconfig-1002-20261008    clang-20
arm                   randconfig-1003-20261008    clang-22
arm                  randconfig-r2201-20261008    gcc-8.5.0  smatch
arm                  randconfig-r2302-20261008    gcc-16.1.0 sparse
arm                  randconfig-r2303-20261008    gcc-16.1.0 sparse
arm                            sama5_defconfig    gcc-16.1.0
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261008    gcc-8.5.0
arm64                 randconfig-1000-20261009    gcc-15.2.0
arm64                 randconfig-1001-20261008    gcc-11.5.0
arm64                 randconfig-1001-20261009    gcc-15.2.0
arm64                 randconfig-1002-20261008    clang-17
arm64                 randconfig-1002-20261009    gcc-15.2.0
arm64                 randconfig-1003-20261008    gcc-11.5.0
arm64                 randconfig-1003-20261009    gcc-15.2.0
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261008    gcc-10.5.0
csky                  randconfig-1000-20261009    gcc-15.2.0
csky                  randconfig-1001-20261008    gcc-16.1.0
csky                  randconfig-1001-20261009    gcc-15.2.0
csky                 randconfig-r2105-20261008    clang-24   cocci
csky                 randconfig-r2300-20261008    gcc-16.1.0 sparse
csky                 randconfig-r2306-20261008    gcc-16.1.0 sparse
csky                 randconfig-r2309-20261008    gcc-16.1.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261008    clang-24
hexagon               randconfig-1001-20261008    clang-18
hexagon              randconfig-r2304-20261008    gcc-16.1.0 sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261008    clang-22
i386        buildonly-randconfig-1001-20261008    gcc-14
i386        buildonly-randconfig-1002-20261008    gcc-12
i386        buildonly-randconfig-1003-20261008    gcc-14
i386        buildonly-randconfig-1004-20261008    gcc-14
i386        buildonly-randconfig-1005-20261008    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261008    clang-22
i386                  randconfig-1001-20261008    clang-22
i386                  randconfig-1002-20261008    gcc-14
i386                  randconfig-1003-20261008    gcc-14
i386                  randconfig-1004-20261008    gcc-14
i386                  randconfig-1005-20261008    clang-22
i386                  randconfig-1006-20261008    gcc-14
i386                  randconfig-1007-20261008    gcc-14
i386                  randconfig-1007-20261009    clang-22
i386                  randconfig-1008-20261008    gcc-12
i386                  randconfig-1008-20261009    clang-22
i386                  randconfig-1009-20261008    clang-22
i386                  randconfig-1009-20261009    clang-22
i386                  randconfig-1010-20261008    gcc-13
i386                  randconfig-1010-20261009    clang-22
i386                  randconfig-1011-20261008    gcc-14
i386                  randconfig-1011-20261009    clang-22
i386                  randconfig-1012-20261008    gcc-14
i386                  randconfig-1012-20261009    clang-22
i386                  randconfig-1013-20261008    gcc-14
i386                  randconfig-1013-20261009    clang-22
i386                  randconfig-2100-20261008    clang-22   cocci
i386                  randconfig-2101-20261008    clang-22   cocci
i386                  randconfig-2101-20261008    gcc-12     cocci
i386                  randconfig-2102-20261008    clang-22   cocci
i386                  randconfig-2103-20261008    clang-22   cocci
i386                  randconfig-2200-20261008    clang-22   smatch
i386                  randconfig-2300-20261008    clang-22   sparse
i386                  randconfig-2300-20261008    gcc-14     sparse
i386                  randconfig-2301-20261008    clang-22   sparse
i386                  randconfig-2301-20261008    gcc-14     sparse
i386                  randconfig-2302-20261008    clang-22   sparse
i386                 randconfig-r2102-20261008    clang-22   cocci
i386                 randconfig-r2103-20261008    clang-22   cocci
i386                 randconfig-r2107-20261008    gcc-14     cocci
i386                 randconfig-r2202-20261008    clang-22   smatch
i386                 randconfig-r2304-20261008    gcc-14     sparse
i386                 randconfig-r2309-20261008    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261008    gcc-16.1.0
loongarch             randconfig-1001-20261008    gcc-16.1.0
loongarch            randconfig-r2105-20261008    clang-24   cocci
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
m68k                           hp300_defconfig    clang-24
m68k                 randconfig-r2306-20261008    gcc-15.2.0 sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2107-20261008    clang-24   cocci
microblaze           randconfig-r2200-20261008    gcc-8.5.0  smatch
microblaze           randconfig-r2300-20261008    gcc-15.2.0 sparse
microblaze           randconfig-r2302-20261008    gcc-11.5.0 sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                         bcm63xx_defconfig    clang-24
mips                  decstation_r4k_defconfig    gcc-16.1.0
mips                   maltasmvp_eva_defconfig    gcc-16.1.0
mips                 randconfig-r2106-20261008    clang-24   cocci
mips                 randconfig-r2202-20261008    gcc-15.2.0 smatch
mips                 randconfig-r2308-20261008    gcc-12.5.0 sparse
nios2                             alldefconfig    clang-24
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261008    gcc-10.5.0
nios2                 randconfig-1001-20261008    gcc-8.5.0
nios2                randconfig-r2100-20261008    clang-22   cocci
nios2                randconfig-r2301-20261008    gcc-16.1.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2101-20261008    clang-22   cocci
openrisc             randconfig-r2200-20261008    gcc-16.1.0 smatch
openrisc             randconfig-r2308-20261008    gcc-16.1.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261008    gcc-8.5.0
parisc                randconfig-1000-20261009    gcc-8.5.0
parisc                randconfig-1001-20261008    gcc-10.5.0
parisc                randconfig-1001-20261009    gcc-8.5.0
parisc               randconfig-r2305-20261008    gcc-8.5.0  sparse
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                       chrp32_defconfig    clang-24
powerpc                        holly_defconfig    clang-24
powerpc               randconfig-1000-20261008    gcc-11.5.0
powerpc               randconfig-1000-20261009    gcc-8.5.0
powerpc               randconfig-1001-20261008    clang-24
powerpc               randconfig-1001-20261009    gcc-8.5.0
powerpc              randconfig-r2100-20261008    clang-22   cocci
powerpc              randconfig-r2103-20261008    clang-22   cocci
powerpc              randconfig-r2105-20261008    clang-24   cocci
powerpc              randconfig-r2106-20261008    clang-24   cocci
powerpc              randconfig-r2107-20261008    clang-24   cocci
powerpc              randconfig-r2301-20261008    clang-24   sparse
powerpc64             randconfig-1000-20261008    gcc-8.5.0
powerpc64             randconfig-1000-20261009    gcc-8.5.0
powerpc64             randconfig-1001-20261008    gcc-15.2.0
powerpc64             randconfig-1001-20261009    gcc-8.5.0
powerpc64            randconfig-r2106-20261008    clang-24   cocci
powerpc64            randconfig-r2303-20261008    clang-17   sparse
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261008    gcc-11.5.0
riscv                 randconfig-1000-20261009    gcc-16.1.0
riscv                 randconfig-1001-20261009    gcc-16.1.0
riscv                 randconfig-2000-20261008    clang-24
riscv                 randconfig-2000-20261008    gcc-11.5.0
riscv                 randconfig-2001-20261008    clang-24
riscv                 randconfig-2001-20261008    gcc-11.5.0
riscv                randconfig-r2101-20261008    clang-22   cocci
riscv                randconfig-r2104-20261008    clang-24   cocci
riscv                randconfig-r2307-20261008    gcc-16.1.0 sparse
riscv                randconfig-r2309-20261008    gcc-15.2.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261008    clang-24
s390                  randconfig-1000-20261009    gcc-16.1.0
s390                  randconfig-1001-20261008    gcc-13.4.0
s390                  randconfig-1001-20261009    gcc-16.1.0
s390                  randconfig-2000-20261008    gcc-11.5.0
s390                  randconfig-2000-20261008    gcc-8.5.0
s390                  randconfig-2001-20261008    gcc-11.5.0
s390                  randconfig-2001-20261008    gcc-8.5.0
s390                 randconfig-r2102-20261008    clang-22   cocci
s390                 randconfig-r2305-20261008    gcc-16.1.0 sparse
s390                 randconfig-r2307-20261008    gcc-16.1.0 sparse
sh                                alldefconfig    gcc-16.1.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                  kfr2r09-romimage_defconfig    clang-24
sh                    randconfig-1000-20261008    gcc-10.5.0
sh                    randconfig-1000-20261009    gcc-16.1.0
sh                    randconfig-1001-20261008    gcc-16.1.0
sh                    randconfig-1001-20261009    gcc-16.1.0
sh                    randconfig-2000-20261008    gcc-11.5.0
sh                    randconfig-2000-20261008    gcc-9.5.0
sh                    randconfig-2001-20261008    gcc-11.5.0
sh                   randconfig-r2100-20261008    gcc-9.5.0  cocci
sh                   randconfig-r2104-20261008    gcc-13.4.0 cocci
sh                   randconfig-r2306-20261008    gcc-11.5.0 sparse
sh                            se7712_defconfig    gcc-16.1.0
sh                         sh7757lcr_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261008    gcc-14.3.0
sparc                 randconfig-1001-20261008    gcc-12.5.0
sparc                 randconfig-2000-20261008    gcc-14
sparc                 randconfig-2000-20261008    gcc-8.5.0
sparc                 randconfig-2001-20261008    gcc-11.5.0
sparc                 randconfig-2001-20261008    gcc-14
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261008    gcc-8.5.0
sparc64               randconfig-1001-20261008    clang-24
sparc64               randconfig-2000-20261008    gcc-14
sparc64               randconfig-2000-20261008    gcc-16.1.0
sparc64               randconfig-2001-20261008    clang-20
sparc64               randconfig-2001-20261008    gcc-14
sparc64              randconfig-r2103-20261008    clang-20   cocci
sparc64              randconfig-r2307-20261008    gcc-15.2.0 sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261008    gcc-14
um                    randconfig-1001-20261008    gcc-14
um                    randconfig-2000-20261008    gcc-14
um                    randconfig-2001-20261008    gcc-14
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64      buildonly-randconfig-1000-20261008    gcc-14
x86_64      buildonly-randconfig-1000-20261009    clang-22
x86_64      buildonly-randconfig-1001-20261008    gcc-14
x86_64      buildonly-randconfig-1001-20261009    clang-22
x86_64      buildonly-randconfig-1002-20261008    gcc-12
x86_64      buildonly-randconfig-1002-20261009    clang-22
x86_64      buildonly-randconfig-1003-20261008    gcc-14
x86_64      buildonly-randconfig-1003-20261009    clang-22
x86_64      buildonly-randconfig-1004-20261008    clang-22
x86_64      buildonly-randconfig-1004-20261009    clang-22
x86_64      buildonly-randconfig-1005-20261008    clang-22
x86_64      buildonly-randconfig-1005-20261009    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261008    gcc-14
x86_64                randconfig-1000-20261009    gcc-14
x86_64                randconfig-1001-20261008    clang-22
x86_64                randconfig-1001-20261009    gcc-14
x86_64                randconfig-1002-20261008    gcc-14
x86_64                randconfig-1002-20261009    gcc-14
x86_64                randconfig-1003-20261008    gcc-14
x86_64                randconfig-1003-20261009    gcc-14
x86_64                randconfig-1004-20261008    gcc-14
x86_64                randconfig-1004-20261009    gcc-14
x86_64                randconfig-1005-20261008    clang-22
x86_64                randconfig-1005-20261009    gcc-14
x86_64                randconfig-1006-20261008    gcc-14
x86_64                randconfig-1007-20261008    gcc-14
x86_64                randconfig-1008-20261008    clang-22
x86_64                randconfig-1009-20261008    clang-22
x86_64                randconfig-1010-20261008    clang-22
x86_64                randconfig-1011-20261008    clang-22
x86_64                randconfig-1012-20261008    clang-22
x86_64                randconfig-1013-20261008    gcc-14
x86_64                randconfig-1014-20261008    gcc-14
x86_64                randconfig-1015-20261008    clang-22
x86_64                randconfig-1016-20261008    clang-22
x86_64                randconfig-1017-20261008    gcc-14
x86_64                randconfig-2100-20261008    clang-22   cocci
x86_64                randconfig-2101-20261008    clang-22   cocci
x86_64                randconfig-2101-20261008    gcc-14     cocci
x86_64                randconfig-2102-20261008    clang-22   cocci
x86_64                randconfig-2102-20261008    gcc-14     cocci
x86_64                randconfig-2103-20261008    clang-22   cocci
x86_64                randconfig-2200-20261008    gcc-14     smatch
x86_64                randconfig-2300-20261008    clang-22   sparse
x86_64                randconfig-2300-20261008    gcc-14     sparse
x86_64                randconfig-2301-20261008    clang-22   sparse
x86_64                randconfig-2302-20261008    clang-22   sparse
x86_64               randconfig-r2102-20261008    clang-22   cocci
x86_64               randconfig-r2201-20261008    clang-22   smatch
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261008    gcc-8.5.0
xtensa                randconfig-1001-20261008    gcc-8.5.0
xtensa                randconfig-2000-20261008    gcc-14
xtensa                randconfig-2000-20261008    gcc-8.5.0
xtensa                randconfig-2001-20261008    gcc-14
xtensa                randconfig-2001-20261008    gcc-8.5.0
xtensa               randconfig-r2104-20261008    clang-24   cocci
xtensa               randconfig-r2308-20261008    gcc-15.2.0 sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

