Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8770BCC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796456B008A; Wed, 14 Oct 2026 04:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747436B0095; Wed, 14 Oct 2026 04:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638796B0098; Wed, 14 Oct 2026 04:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5036B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:10:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B7EB160481
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:10:54 +0000 (UTC)
X-FDA: 85320510828.18.3B6BFE6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 822DF100006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:10:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JfqUH5tz;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791965452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=oTDumDTSO03oRBOS5Cr6KqLqCt3n7a7Fpj+Yh1pXQYY=;
	b=8INl2G51LP2U8baIjDgP58ihQ3Hmj/UZOc+sdswMs3Ir2I/OcuHBGUNKhhFYmF0RaRW3O9
	aSbkPpOXQaTCmX2JEeezFJyReXWXA8hCdG9N2yQtdwc+tGeL48SQKGRSpQ1qcTb3cO0AnY
	YLeLtK5C053zmWVd1KpSDTbQFPvBGU0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JfqUH5tz;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791965452;
	b=lQ7NWBXMOiAS2ij03X1wTPcsssJauqQ8R0zZDPGGyRffqizKred0c2JSRyO18fed4wKxcl
	fv75mpcoKf64fa4vnBsJvZsafbs6MPBTC+uHD71qtXtb9z2Ju+tDmE1eFW4HG69+6qQTh3
	gKV27QDXjZmM44snbPjfiAN1kQaQcIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791965452; x=1823501452;
  h=date:from:to:cc:subject:message-id;
  bh=YMMDTQTXoueiQKbjB1EUXxpab8sGn0ieRohlvFHW/rA=;
  b=JfqUH5tzPSZMhaOXc5NzMQvn07k1egSvaDUGcaIS0dvv1YZVfjcKkZIW
   DOBN+DQtjQWH30k+Ho2VZXn3WhU+YIvg6rPh/wVcQobw4WNx1y54K17hl
   TPZhgpfPW9x1/9MLsXuSjMVDEMnC1glYbMFOb/M/MQBofjgnno0bxkTiY
   leWRnEcycogESim2AhHAOG9eclKrzug99+MV09J133s7S7AReWKugA34i
   iMlAklZg9VVOXOFy+7yItYr7MmHn7N+8UlLE/9D591jgNPlql50WCYOyZ
   E/GEnvkvfhFgpgY1C2+FGvxYJkEGlzbmcrWoSnJnefqfLxr0aaOJkIZph
   w==;
X-CSE-ConnectionGUID: J8HIh2zaRWqITBwrsjI9Pg==
X-CSE-MsgGUID: PHtGkVpmSbau+rPA4aMpcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="721725"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="721725"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 01:10:51 -0700
X-CSE-ConnectionGUID: KJ0GNF4WRhaqOixJKJ9T2w==
X-CSE-MsgGUID: rj7UdN7dT6KkLgfEgf5+sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1718268"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 14 Oct 2026 01:10:48 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGu4U-00000000EMR-01CY;
	Wed, 14 Oct 2026 08:10:46 +0000
Date: Wed, 14 Oct 2026 16:10:01 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 0e199ae6e803e76ebf128e009d336e5917221e63
Message-ID: <202610141658.4IAcRu81-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 822DF100006
X-Stat-Signature: ycwu6s5uqy61uykdc4yjme7iugtds949
X-HE-Tag: 1791965451-295332
X-HE-Meta: U2FsdGVkX18D4KcS14gF7xZscjXdoelyw+A61QF3b/Kx+Kxcti9MfaoDyTue5an8WNzoafbVCFLjkAzc9g9nQ/8RQ7vAHFf+Pvnp2qnm7NAx82i0QTdbkoVBNNFLHksJQFlkfn+cL2Tr5tLS4/0tiaQERN0C4D9Kmsa1u3JaaPiiKMU0ImuVR5RPj7mkYdYLCeLwrARZkjK4Aw30lEusqSQHKKo03zQLhgw4w+6diY+7TJNBPGE/TGqXWhgJxmgr5f+UwAOjtKGD1nX2ZZmZgEqVD61heW8+OXB6pW/rN9Kr1NttZ9YzldJDv+NqaYUex4aF6lq8CXWSae5CCE/CCtC7Gd+u0owF40TWk6Xcj1aD2+ql5GwDteo9CJvOhw2Tv963I31KmLwNq0LFfasdxfGJdXrZKPpp6+sYpwi9FBzL5BmVms23+C+b8kesi9Tugx2Tgl53T/h5CfHaS1iRitDQ+LFN48HhIvpFNvTJXd3JiMN5ijLjguz/RaX41fQxo6sYC1SiNjJc4ZMm1SvW3OrgAsqa+0avtuQihn58B8pcP2HbhbcHLPf+LtOA88FUAtuhCTJ0SScZixN/Mm2k/DJ9tPRFRhZ5Z0whNZMjoNpkGEG5iASBjMNfJBRIHmLeQobZFGbOG0e7WcaCQs+MoieIK3W6APNkxmp5VNL7KCYnSttloGgOcrcU1jLziERWT0mo4edNob3lIT8yikJJJwKpUc5xyW7vYlZLdU61ayyAC68LlqHanX97Nre80CDcV9FdqL9/1ksVO2SpWiKPqIBEwf4ejKBLfS/5IZJGViWl7r9tu65KvPoZPGzqCswB6R102l91XumQT97HlTFyfpLnh0vfb+/EwBIu0kt9k0SoW03xSTrgiDhuoWEkrHSRymCXdRdnL8N4L9qZhMoD95vV+ES+5SD94/RLzO+xK0LdydABPqMB5c7LVfRW1ME8hgvpU+pMys0b88DeUt+
 rNDQhFKb
 36BBhKw3krrbkjqzRjfoJN/qNoDN6elVSc7BE3QHR/v0igl5IPq4yapS+abSyqb7NAJlkjNBJVmjSI0TjXAtuSh5//ygw0qsy1MVmdZ14fuYsDcSQJ8Ar9Z/anqrB+QE1sVBN3EZ8hgmVDwbVidlgrxntPs7sDoMsbOR3vj/HofptVI8ZDb0aJ3DC5KaYldAJpxfZBQFbsy1uWxLabZNh4NHlr7+929DAb6Ur
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 0e199ae6e803e76ebf128e009d336e5917221e63  riscv: mm: exclude invalid THP PMDs from page table check

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r2104-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- arm-randconfig-r2109-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- csky-randconfig-r2105-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- hexagon-randconfig-r2106-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2101-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2104-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- nios2-randconfig-r2102-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- nios2-randconfig-r2110-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- openrisc-randconfig-r2107-20261013
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- x86_64-randconfig-2100-20261013
    `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.

elapsed time: 909m

configs tested: 268
configs skipped: 9

tested configs:
alpha                     allnoconfig    gcc-16.1.0
alpha                    allyesconfig    gcc-16.1.0
alpha                       defconfig    gcc-16.1.0
alpha       randconfig-r2104-20261013    gcc-11.5.0 cocci
arc                      allmodconfig    gcc-16.1.0
arc                       allnoconfig    gcc-16.1.0
arc                      allyesconfig    gcc-16.1.0
arc                         defconfig    gcc-16.1.0
arc          randconfig-1000-20261014    gcc-15.2.0
arc          randconfig-1001-20261014    gcc-13.4.0
arc          randconfig-2000-20261013    gcc-15.2.0
arc          randconfig-2000-20261013    gcc-8.5.0
arc          randconfig-2001-20261013    gcc-8.5.0
arc         randconfig-r2111-20261013    gcc-13.4.0 cocci
arc         randconfig-r2303-20261013    gcc-16.1.0 sparse
arc         randconfig-r2310-20261013    gcc-8.5.0  sparse
arm                       allnoconfig    clang-17
arm                      allyesconfig    gcc-16.1.0
arm                         defconfig    clang-24
arm                  gemini_defconfig    clang-24
arm                mvebu_v5_defconfig    gcc-16.1.0
arm          randconfig-1000-20261014    clang-17
arm          randconfig-1001-20261014    clang-19
arm          randconfig-1002-20261014    clang-17
arm          randconfig-1003-20261014    clang-17
arm          randconfig-2000-20261013    gcc-13.4.0
arm          randconfig-2000-20261013    gcc-8.5.0
arm          randconfig-2001-20261013    gcc-8.5.0
arm         randconfig-r2109-20261013    clang-24   cocci
arm         randconfig-r2111-20261013    gcc-14.3.0 cocci
arm         randconfig-r2307-20261013    clang-19   sparse
arm                   sunxi_defconfig    gcc-16.1.0
arm64                    allmodconfig    clang-24
arm64                     allnoconfig    gcc-16.1.0
arm64                       defconfig    gcc-16.1.0
arm64        randconfig-2000-20261013    gcc-8.5.0
arm64        randconfig-2000-20261013    gcc-9.5.0
arm64        randconfig-2001-20261013    gcc-10.5.0
arm64        randconfig-2001-20261013    gcc-9.5.0
arm64       randconfig-r2309-20261013    clang-19   sparse
csky                     allmodconfig    gcc-16.1.0
csky                      allnoconfig    gcc-16.1.0
csky                        defconfig    gcc-16.1.0
csky         randconfig-1001-20261014    gcc-9.5.0
csky         randconfig-2000-20261013    gcc-15.2.0
csky         randconfig-2000-20261013    gcc-9.5.0
csky         randconfig-2001-20261013    gcc-9.5.0
csky        randconfig-r2101-20261013    gcc-12.5.0 cocci
csky        randconfig-r2105-20261013    gcc-12.5.0 cocci
csky        randconfig-r2200-20261013    gcc-11.5.0 smatch
hexagon                  allmodconfig    clang-24
hexagon                   allnoconfig    clang-24
hexagon                     defconfig    clang-24
hexagon      randconfig-1000-20261014    clang-17
hexagon      randconfig-1001-20261014    clang-18
hexagon      randconfig-2000-20261013    clang-24
hexagon      randconfig-2000-20261013    gcc-9.5.0
hexagon      randconfig-2001-20261013    clang-17
hexagon      randconfig-2001-20261013    gcc-9.5.0
hexagon     randconfig-r2106-20261013    clang-17   cocci
hexagon     randconfig-r2301-20261013    gcc-8.5.0  sparse
i386                      allnoconfig    gcc-14
i386                        defconfig    clang-22
i386         randconfig-1000-20261014    gcc-14
i386         randconfig-1001-20261014    clang-22
i386         randconfig-1002-20261014    clang-22
i386         randconfig-1003-20261014    gcc-14
i386         randconfig-1004-20261014    gcc-14
i386         randconfig-1005-20261014    clang-22
i386         randconfig-1006-20261014    clang-22
i386         randconfig-2000-20261013    clang-22
i386         randconfig-2000-20261013    gcc-8.5.0
i386         randconfig-2001-20261013    clang-22
i386         randconfig-2001-20261013    gcc-8.5.0
i386         randconfig-2100-20261013    clang-22   cocci
i386         randconfig-2100-20261013    gcc-14     cocci
i386         randconfig-2101-20261013    gcc-14     cocci
i386         randconfig-2102-20261013    gcc-12     cocci
i386         randconfig-2102-20261013    gcc-14     cocci
i386         randconfig-2103-20261013    gcc-14     cocci
i386         randconfig-2104-20261013    gcc-12     cocci
i386         randconfig-2104-20261013    gcc-14     cocci
i386         randconfig-2105-20261013    gcc-14     cocci
i386         randconfig-2200-20261013    gcc-14     smatch
i386         randconfig-2300-20261013    gcc-14     sparse
i386         randconfig-2301-20261013    gcc-14     sparse
i386         randconfig-2302-20261013    gcc-14     sparse
i386        randconfig-r2103-20261013    gcc-13     cocci
loongarch                allmodconfig    clang-19
loongarch                 allnoconfig    clang-20
loongarch                   defconfig    clang-24
loongarch    randconfig-1000-20261014    gcc-12.5.0
loongarch    randconfig-1001-20261014    gcc-16.1.0
loongarch    randconfig-2000-20261013    clang-24
loongarch    randconfig-2000-20261013    gcc-11.5.0
loongarch    randconfig-2001-20261013    clang-24
loongarch    randconfig-2001-20261013    gcc-11.5.0
loongarch   randconfig-r2100-20261013    gcc-12.5.0 cocci
loongarch   randconfig-r2110-20261013    gcc-14.3.0 cocci
loongarch   randconfig-r2304-20261013    gcc-12.5.0 sparse
loongarch   randconfig-r2305-20261013    gcc-14.3.0 sparse
m68k                     allmodconfig    gcc-16.1.0
m68k                      allnoconfig    gcc-16.1.0
m68k                     allyesconfig    gcc-16.1.0
m68k                        defconfig    gcc-16.1.0
m68k        randconfig-r2103-20261013    gcc-12.5.0 cocci
m68k        randconfig-r2109-20261013    gcc-12.5.0 cocci
m68k                   sun3_defconfig    gcc-16.1.0
microblaze                allnoconfig    gcc-16.1.0
microblaze               allyesconfig    gcc-16.1.0
microblaze                  defconfig    gcc-16.1.0
microblaze              mmu_defconfig    gcc-16.1.0
microblaze  randconfig-r2300-20261013    gcc-8.5.0  sparse
microblaze  randconfig-r2301-20261013    gcc-11.5.0 sparse
mips                      allnoconfig    gcc-16.1.0
mips                     allyesconfig    gcc-16.1.0
mips        randconfig-r2100-20261013    clang-17   cocci
mips        randconfig-r2300-20261013    gcc-8.5.0  sparse
mips        randconfig-r2311-20261013    clang-24   sparse
nios2                    allmodconfig    gcc-11.5.0
nios2                     allnoconfig    gcc-11.5.0
nios2                       defconfig    gcc-11.5.0
nios2        randconfig-1000-20261014    gcc-8.5.0
nios2        randconfig-1001-20261014    gcc-9.5.0
nios2        randconfig-2000-20261013    gcc-11.5.0
nios2        randconfig-2000-20261013    gcc-8.5.0
nios2        randconfig-2001-20261013    gcc-11.5.0
nios2       randconfig-r2101-20261013    gcc-11.5.0 cocci
nios2       randconfig-r2102-20261013    gcc-11.5.0 cocci
nios2       randconfig-r2106-20261013    gcc-14.3.0 cocci
nios2       randconfig-r2110-20261013    gcc-11.5.0 cocci
nios2       randconfig-r2201-20261013    gcc-8.5.0  smatch
nios2       randconfig-r2202-20261013    gcc-11.5.0 smatch
nios2       randconfig-r2305-20261013    gcc-8.5.0  sparse
nios2       randconfig-r2311-20261013    clang-19   sparse
openrisc                 allmodconfig    gcc-16.1.0
openrisc                  allnoconfig    gcc-16.1.0
openrisc                    defconfig    gcc-16.1.0
openrisc    randconfig-r2107-20261013    gcc-10.5.0 cocci
parisc                   allmodconfig    gcc-16.1.0
parisc                    allnoconfig    gcc-16.1.0
parisc                   allyesconfig    gcc-16.1.0
parisc       randconfig-1000-20261014    gcc-8.5.0
parisc       randconfig-1001-20261014    gcc-15.2.0
parisc       randconfig-2000-20261013    gcc-11.5.0
parisc       randconfig-2000-20261013    gcc-13.4.0
parisc       randconfig-2001-20261013    gcc-11.5.0
parisc       randconfig-2001-20261013    gcc-15.2.0
parisc      randconfig-r2108-20261013    gcc-14.3.0 cocci
parisc      randconfig-r2202-20261013    gcc-8.5.0  smatch
parisc      randconfig-r2306-20261013    gcc-12.5.0 sparse
parisc64                    defconfig    gcc-16.1.0
powerpc                   allnoconfig    gcc-16.1.0
powerpc             ppa8548_defconfig    gcc-16.1.0
powerpc      randconfig-1000-20261014    clang-19
powerpc      randconfig-1001-20261014    clang-22
powerpc      randconfig-2000-20261013    gcc-14
powerpc      randconfig-2000-20261013    gcc-8.5.0
powerpc      randconfig-2001-20261013    clang-22
powerpc      randconfig-2001-20261013    gcc-14
powerpc     randconfig-r2201-20261013    gcc-11.5.0 smatch
powerpc64    randconfig-1000-20261014    clang-24
powerpc64    randconfig-1001-20261014    clang-22
powerpc64    randconfig-2000-20261013    gcc-14
powerpc64    randconfig-2000-20261013    gcc-8.5.0
powerpc64    randconfig-2001-20261013    gcc-14
powerpc64    randconfig-2001-20261013    gcc-14.3.0
riscv                    allmodconfig    clang-24
riscv                     allnoconfig    gcc-16.1.0
riscv                    allyesconfig    clang-24
riscv        randconfig-2000-20261013    clang-24
riscv        randconfig-2000-20261013    gcc-15.2.0
riscv        randconfig-2001-20261013    gcc-15.2.0
riscv        randconfig-2001-20261013    gcc-8.5.0
s390                     allmodconfig    clang-24
s390                      allnoconfig    clang-24
s390         randconfig-2000-20261013    clang-24
s390         randconfig-2000-20261013    gcc-15.2.0
s390         randconfig-2001-20261013    gcc-15.2.0
s390         randconfig-2001-20261013    gcc-16.1.0
s390        randconfig-r2105-20261013    gcc-14.3.0 cocci
s390        randconfig-r2108-20261013    gcc-12.5.0 cocci
s390        randconfig-r2200-20261013    clang-24   smatch
sh                       allmodconfig    gcc-16.1.0
sh                        allnoconfig    gcc-16.1.0
sh                       allyesconfig    gcc-16.1.0
sh           randconfig-2000-20261013    gcc-15.2.0
sh           randconfig-2001-20261013    gcc-15.2.0
sh           randconfig-2001-20261013    gcc-16.1.0
sh                  rsk7201_defconfig    gcc-16.1.0
sh                  sdk7786_defconfig    gcc-16.1.0
sparc                     allnoconfig    gcc-16.1.0
sparc                       defconfig    gcc-16.1.0
sparc        randconfig-1000-20261014    gcc-11.5.0
sparc        randconfig-1001-20261014    gcc-16.1.0
sparc        randconfig-2000-20261013    gcc-11.5.0
sparc        randconfig-2000-20261013    gcc-16.1.0
sparc        randconfig-2001-20261013    gcc-16.1.0
sparc       randconfig-r2306-20261013    clang-19   sparse
sparc64                  allmodconfig    clang-20
sparc64      randconfig-1000-20261014    clang-22
sparc64      randconfig-1001-20261014    clang-24
sparc64      randconfig-2000-20261013    clang-24
sparc64      randconfig-2000-20261013    gcc-16.1.0
sparc64      randconfig-2001-20261013    clang-24
sparc64      randconfig-2001-20261013    gcc-16.1.0
sparc64     randconfig-r2308-20261013    clang-20   sparse
um                       allmodconfig    clang-17
um                        allnoconfig    clang-17
um                       allyesconfig    gcc-14
um           randconfig-1000-20261014    gcc-14
um           randconfig-1001-20261014    clang-24
um           randconfig-2000-20261013    gcc-14
um           randconfig-2000-20261013    gcc-16.1.0
um           randconfig-2001-20261013    gcc-14
um           randconfig-2001-20261013    gcc-16.1.0
um          randconfig-r2102-20261013    gcc-12.5.0 cocci
um          randconfig-r2307-20261013    clang-21   sparse
um          randconfig-r2308-20261013    clang-19   sparse
um          randconfig-r2309-20261013    clang-17   sparse
um          randconfig-r2310-20261013    clang-19   sparse
x86_64                    allnoconfig    clang-22
x86_64                          kexec    clang-22
x86_64       randconfig-1004-20261014    gcc-14
x86_64       randconfig-1006-20261014    clang-22
x86_64       randconfig-1007-20261014    gcc-14
x86_64       randconfig-1008-20261014    gcc-14
x86_64       randconfig-1009-20261014    clang-22
x86_64       randconfig-1010-20261014    gcc-14
x86_64       randconfig-1011-20261014    gcc-14
x86_64       randconfig-2000-20261013    gcc-14
x86_64       randconfig-2001-20261013    gcc-14
x86_64       randconfig-2100-20261013    clang-22   cocci
x86_64       randconfig-2101-20261013    clang-22   cocci
x86_64       randconfig-2101-20261013    gcc-14     cocci
x86_64       randconfig-2102-20261013    clang-22   cocci
x86_64       randconfig-2103-20261013    clang-22   cocci
x86_64       randconfig-2103-20261013    gcc-14     cocci
x86_64       randconfig-2104-20261013    clang-22   cocci
x86_64       randconfig-2104-20261013    gcc-14     cocci
x86_64       randconfig-2105-20261013    clang-22   cocci
x86_64       randconfig-2200-20261013    gcc-13     smatch
x86_64       randconfig-2300-20261013    gcc-14     sparse
x86_64       randconfig-2301-20261013    clang-22   sparse
x86_64       randconfig-2301-20261013    gcc-14     sparse
x86_64       randconfig-2302-20261013    gcc-14     sparse
x86_64      randconfig-r2302-20261013    gcc-8.5.0  sparse
x86_64      randconfig-r2303-20261013    gcc-8.5.0  sparse
x86_64      randconfig-r2304-20261013    gcc-8.5.0  sparse
x86_64                       rhel-9.4    clang-22
x86_64                   rhel-9.4-bpf    clang-22
x86_64                  rhel-9.4-func    clang-22
x86_64            rhel-9.4-kselftests    clang-22
x86_64                 rhel-9.4-kunit    clang-22
x86_64                   rhel-9.4-ltp    clang-22
x86_64                  rhel-9.4-rust    clang-22
x86_64                  rhel-9.4-rust    clang-22
xtensa                    allnoconfig    gcc-16.1.0
xtensa                   allyesconfig    gcc-16.1.0
xtensa       randconfig-1000-20261014    gcc-13.4.0
xtensa       randconfig-1001-20261014    gcc-15.2.0
xtensa       randconfig-2000-20261013    gcc-16.1.0
xtensa       randconfig-2000-20261013    gcc-8.5.0
xtensa       randconfig-2001-20261013    gcc-11.5.0
xtensa       randconfig-2001-20261013    gcc-16.1.0
xtensa      randconfig-r2104-20261013    gcc-14.3.0 cocci
xtensa      randconfig-r2107-20261013    gcc-14.3.0 cocci
xtensa      randconfig-r2302-20261013    gcc-8.5.0  sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

