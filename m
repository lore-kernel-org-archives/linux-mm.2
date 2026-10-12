Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A0CCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4776B0098; Mon, 12 Oct 2026 09:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A57B6B0099; Mon, 12 Oct 2026 09:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694DD6B009B; Mon, 12 Oct 2026 09:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F26A6B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:23:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C28AA160E2C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:23:49 +0000 (UTC)
X-FDA: 85314041778.29.9D576B6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E197120005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:23:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W+cT8+v1;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LzFdfjWqBqn8fj/zj7xcGm5Mi39ZdsbH2wZDYqiuY8Y=;
	b=Dy7SGBzXOs8yJvap/2ad7+QsgHm9GMAZzb1t+aBkRLosQWRsx5uoCxzBwqCK/knRtMDxPt
	ADxxwgBH48i/noiTtLGRDIGyYgmxevjnABO0kNwHBzQUZ0LcWPCuGewpdgCjfH5jzggkpU
	DC13Pv3uH7XC5q/Hjcxu8/SDqv8Am2g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791811428;
	b=EVlrFSoVWfgUAn8n1ET5dQhSMXlRwtjzZx+/DzpoR+vf5NXDbRz0/Snz/2rFVIgBNY/U0I
	GPWX53RxI0pxcH3nEf0Ao1rG8ls4PEfgY0A+Qjdv0odt7oucbD5DPjSGNt673hpVmyzgPP
	enGEyg8CoM8IAN1On9YLCx4687GHrnM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W+cT8+v1;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791811428; x=1823347428;
  h=date:from:to:cc:subject:message-id;
  bh=le44JWQtSr09oIK0IiPMn1zHwQ94vjT58/E9CBnarsA=;
  b=W+cT8+v12dxF3f7N3dH4jcsNawrxYH8g58SvK3wb35A8LwtZPqTNNsZ8
   RQS0cJeO2DENHSiOFX0xjjFhCw69GtE8ER/0V9BEIYJl85wsWhNzFPiFY
   dD0EkGnOUaTJ1ogAktdcCwdN9gZE8XSclUAPbfhjaqSW6huxlOnCT6xAJ
   DkJNp6bUdcUn0dOUBJkhejhtoxEjlSsTcww/gUdfG47ofZqkKSfsQVQok
   5c9wjo6lqxGCjew4Lh63ndh+2MRPnrv9BVEtWGalqPa4Hhu5pqoaYY7QS
   YqkUzksTj8qASya4kwfNrGrfparIYWauZ9LImhPEPtFua5EUpss2wW8Dj
   g==;
X-CSE-ConnectionGUID: 0x1NLk1dQm2eS1cMme/NcQ==
X-CSE-MsgGUID: iJP8xDszRXCYDX57Pd6+qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="402983"
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="402983"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 06:23:17 -0700
X-CSE-ConnectionGUID: l0tCTG9oSm+2PDl2uxoOOQ==
X-CSE-MsgGUID: 9NqNigdbQ5quzdkWwqvv4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,153,1787036400"; 
   d="scan'208";a="2659499"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 12 Oct 2026 06:23:13 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGFzi-00000000BX3-3TiW;
	Mon, 12 Oct 2026 13:23:10 +0000
Date: Mon, 12 Oct 2026 21:22:15 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 50dba3e474f7c3932cba85ebd9a7188e7b8dd6d4
Message-ID: <202610122112.aAg2PojA-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E197120005
X-Stat-Signature: jeofihun66oz5wabonrr4z5fkb8hzs69
X-HE-Tag: 1791811427-315499
X-HE-Meta: U2FsdGVkX18/J65Lq2sE91/qrFw2wnq9ZYXUEt5xAn6pIp8Wa9+kWG7wqm6c3eDac6Ylo7Zj25A1VxgSbnlqjs3Izx506xvkC0geSU3a5ib9Qq1val3hC1WoheTMoKQqszfrwXI/6TsovEDjDENLB1zfid46jgy/iZi/2+G7UJZEX2/KVWyH/aM2pHTYQNEzuocvUlmPx/putz0pX4+K1sn9I6KGFHPRzs/FyKMIRrn5mTe3+mLwW6vJNSW24BvuY/4WTchUNli8rRj+OvXtrsaGe12ex6lvBkBrUSmoiSu7JOFRw9mZFMQTflwM7ikHjCACBc4vit2NKHPb21i8Mjnqgj0mBWAVyfBLFzPKHR85ixerQYvaAiznHu8zfV2o+0/xKIlVJJMlnaWOr/35M7B4i+TeGmYBwBPw013h3tLf0xeNG4ddw0MdDPYYwMP3Qnn1eA7hOmX1aCE33irz0dlZMOGOSt7F9iHfkCEUGaoOjWcgm/EvEOhl/wVkmttxeURqpXLuZoPX3QHBv8NNEDvQEWNUYoS0+HZhr98IBq0lM+VgW63dJOCBGRfci2WY1jcXRT7/iqKZGqqSr6p7AYiwNvyQyZnzyzU7ptEW/CvCCu3PXxIuXZiu7jPmuMKcDZHUsu6NKK+XzbD8DNhkZJJ8wGEmpcl5T1wDSs/cWUEwAaJdu5kpd1qJV5Rb1c1DZnYdbUxJG8Wn+aBXsiwHgXSzGUQ1zOR+JjA1X9P1UplXKD6LaGr2GKqa4GXqsSNTOFw9Bq+nS1o6640ox+EBk9eZ3fq0rYETeNqVjOmawaQj4p/Me+KgCPZgrFALuzljaGSniia+CrZH5rhY52QX4L9NQNWrVRgKlM4NLiF14+oYlH7+p43QzQBV6LhlTZLOodC2rLLODqZu4XZ31OZYKPFpwAX+ZUPkA+uJpFbwb0KMYIjwfa4B62Cn8YZvLaIcQ5zvuw732INk2yUOyel
 4wMLGXCx
 5KQjtamWjMJZvVsLjnMPojRKik7jD/R1w3F9Xz7f0vqt5pyzc+5SaGXhaNHx+FgA626a/0a7FpeJWTMGyQV6uzglKU5NPJnHyqD7VKplr1icYeAATQr1c931GdcmHCGRKMkIpf52D1tWiT3d73DrOC57q2i0lzZGIokzXifyssbWd/vclka8CJnZMXKTBZ42gOL24RSc0m9WwDW+d9iWetHCKJObfw2N5SBVs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 50dba3e474f7c3932cba85ebd9a7188e7b8dd6d4  sh: drop include/asm/sparsemem.h

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-randconfig-r2101-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20261011
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- i386-randconfig-r2111-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- loongarch-randconfig-r2110-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc-randconfig-r2108-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc-randconfig-r2202-20261011
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- sparc64-randconfig-r2105-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2101-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2102-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2103-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2104-20261011
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- x86_64-randconfig-2200-20261011
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
`-- xtensa-randconfig-r2109-20261011
    `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.

elapsed time: 1008m

configs tested: 454
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2101-20261011    gcc-15.2.0 cocci
alpha                randconfig-r2106-20261011    clang-24   cocci
alpha                randconfig-r2111-20261012    gcc-8.5.0  cocci
alpha                randconfig-r2202-20261012    gcc-15.2.0 smatch
alpha                randconfig-r2300-20261012    clang-19   sparse
alpha                randconfig-r2304-20261011    clang-24   sparse
alpha                randconfig-r2304-20261011    gcc-14.3.0 sparse
alpha                randconfig-r2305-20261011    clang-24   sparse
alpha                randconfig-r2311-20261012    clang-22   sparse
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    gcc-16.1.0
arc                                  defconfig    gcc-16.1.0
arc                   randconfig-1000-20261012    gcc-13.4.0
arc                   randconfig-1001-20261012    gcc-8.5.0
arc                   randconfig-2000-20261011    gcc-8.5.0
arc                   randconfig-2000-20261012    gcc-16.1.0
arc                   randconfig-2001-20261011    gcc-8.5.0
arc                   randconfig-2001-20261012    gcc-16.1.0
arc                  randconfig-r2109-20261011    gcc-16.1.0 cocci
arc                  randconfig-r2200-20261012    gcc-16.1.0 smatch
arc                  randconfig-r2304-20261012    clang-19   sparse
arc                  randconfig-r2307-20261011    gcc-8.5.0  sparse
arc                  randconfig-r2311-20261011    clang-24   sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.1.0
arm                         clps711x_defconfig    clang-24
arm                                  defconfig    clang-24
arm                             dove_defconfig    gcc-16.1.0
arm                             hisi_defconfig    gcc-16.1.0
arm                           ixp4xx_defconfig    gcc-16.1.0
arm                   randconfig-1000-20261012    clang-19
arm                   randconfig-1001-20261012    clang-24
arm                   randconfig-1002-20261012    gcc-8.5.0
arm                   randconfig-1003-20261012    clang-24
arm                   randconfig-2000-20261011    gcc-8.5.0
arm                   randconfig-2000-20261012    gcc-16.1.0
arm                   randconfig-2001-20261011    gcc-8.5.0
arm                   randconfig-2001-20261012    gcc-16.1.0
arm                  randconfig-r2102-20261011    clang-17   cocci
arm                  randconfig-r2300-20261011    clang-17   sparse
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261012    gcc-10.5.0
arm64                 randconfig-1001-20261012    clang-24
arm64                 randconfig-1002-20261012    gcc-8.5.0
arm64                 randconfig-1003-20261012    clang-17
arm64                 randconfig-2000-20261011    clang-24
arm64                 randconfig-2000-20261011    gcc-16.1.0
arm64                 randconfig-2000-20261012    gcc-16.1.0
arm64                 randconfig-2001-20261011    gcc-12.5.0
arm64                 randconfig-2001-20261011    gcc-16.1.0
arm64                 randconfig-2001-20261012    gcc-16.1.0
arm64                randconfig-r2100-20261011    gcc-16.1.0 cocci
arm64                randconfig-r2106-20261011    clang-22   cocci
arm64                randconfig-r2108-20261012    clang-24   cocci
arm64                randconfig-r2109-20261012    gcc-11.5.0 cocci
arm64                randconfig-r2303-20261011    clang-17   sparse
arm64                randconfig-r2311-20261011    gcc-13.4.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261012    gcc-9.5.0
csky                  randconfig-1001-20261012    gcc-16.1.0
csky                  randconfig-2000-20261011    gcc-16.1.0
csky                  randconfig-2000-20261011    gcc-9.5.0
csky                  randconfig-2000-20261012    gcc-16.1.0
csky                  randconfig-2001-20261011    gcc-16.1.0
csky                  randconfig-2001-20261012    gcc-16.1.0
csky                 randconfig-r2108-20261011    gcc-8.5.0  cocci
csky                 randconfig-r2202-20261011    gcc-9.5.0  smatch
csky                 randconfig-r2202-20261012    gcc-16.1.0 smatch
csky                 randconfig-r2303-20261012    gcc-9.5.0  sparse
csky                 randconfig-r2309-20261012    clang-22   sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261012    clang-24
hexagon               randconfig-1001-20261012    clang-17
hexagon               randconfig-2000-20261011    clang-19
hexagon               randconfig-2000-20261011    gcc-16.1.0
hexagon               randconfig-2000-20261012    gcc-16.1.0
hexagon               randconfig-2001-20261011    clang-17
hexagon               randconfig-2001-20261011    gcc-16.1.0
hexagon               randconfig-2001-20261012    gcc-16.1.0
hexagon              randconfig-r2100-20261011    clang-24   cocci
hexagon              randconfig-r2103-20261011    clang-22   cocci
hexagon              randconfig-r2104-20261011    clang-24   cocci
hexagon              randconfig-r2106-20261012    gcc-16.1.0 cocci
hexagon              randconfig-r2107-20261012    gcc-8.5.0  cocci
hexagon              randconfig-r2109-20261012    clang-24   cocci
hexagon              randconfig-r2302-20261012    clang-17   sparse
hexagon              randconfig-r2304-20261012    clang-17   sparse
hexagon              randconfig-r2308-20261011    clang-24   sparse
hexagon              randconfig-r2309-20261011    clang-24   sparse
hexagon              randconfig-r2310-20261011    clang-24   sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261012    clang-22
i386        buildonly-randconfig-1001-20261012    gcc-13
i386        buildonly-randconfig-1002-20261012    clang-22
i386        buildonly-randconfig-1003-20261012    clang-22
i386        buildonly-randconfig-1004-20261012    clang-22
i386        buildonly-randconfig-1005-20261012    clang-22
i386                                 defconfig    clang-22
i386                  randconfig-1000-20261012    clang-22
i386                  randconfig-1001-20261012    gcc-14
i386                  randconfig-1002-20261012    clang-22
i386                  randconfig-1003-20261012    clang-22
i386                  randconfig-1004-20261012    clang-22
i386                  randconfig-1005-20261012    clang-22
i386                  randconfig-1006-20261012    gcc-14
i386                  randconfig-1007-20261012    clang-22
i386                  randconfig-1008-20261012    clang-22
i386                  randconfig-1009-20261012    clang-22
i386                  randconfig-1010-20261012    clang-22
i386                  randconfig-1011-20261012    gcc-14
i386                  randconfig-1012-20261012    gcc-12
i386                  randconfig-1013-20261012    clang-22
i386                  randconfig-2000-20261011    gcc-8.5.0
i386                  randconfig-2000-20261012    gcc-16.1.0
i386                  randconfig-2001-20261011    gcc-8.5.0
i386                  randconfig-2001-20261012    gcc-16.1.0
i386                  randconfig-2100-20261011    gcc-14     cocci
i386                  randconfig-2100-20261012    clang-22   cocci
i386                  randconfig-2101-20261011    gcc-14     cocci
i386                  randconfig-2101-20261012    clang-22   cocci
i386                  randconfig-2102-20261011    gcc-14     cocci
i386                  randconfig-2102-20261012    clang-22   cocci
i386                  randconfig-2103-20261011    gcc-14     cocci
i386                  randconfig-2103-20261012    clang-22   cocci
i386                  randconfig-2104-20261011    gcc-14     cocci
i386                  randconfig-2104-20261012    clang-22   cocci
i386                  randconfig-2105-20261011    gcc-14     cocci
i386                  randconfig-2105-20261012    clang-22   cocci
i386                  randconfig-2200-20261011    clang-22   smatch
i386                  randconfig-2200-20261012    clang-22   smatch
i386                  randconfig-2300-20261011    gcc-14     sparse
i386                  randconfig-2300-20261012    gcc-14     sparse
i386                  randconfig-2301-20261011    gcc-14     sparse
i386                  randconfig-2301-20261012    gcc-14     sparse
i386                  randconfig-2302-20261011    gcc-14     sparse
i386                  randconfig-2302-20261012    gcc-14     sparse
i386                 randconfig-r2100-20261012    gcc-11.5.0 cocci
i386                 randconfig-r2104-20261012    gcc-8.5.0  cocci
i386                 randconfig-r2111-20261011    clang-22   cocci
i386                 randconfig-r2200-20261011    clang-22   smatch
i386                 randconfig-r2300-20261012    gcc-9.5.0  sparse
i386                 randconfig-r2302-20261011    gcc-14.3.0 sparse
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261012    gcc-16.1.0
loongarch             randconfig-1001-20261012    clang-18
loongarch             randconfig-2000-20261011    gcc-8.5.0
loongarch             randconfig-2000-20261012    gcc-11.5.0
loongarch             randconfig-2001-20261011    gcc-8.5.0
loongarch             randconfig-2001-20261012    gcc-11.5.0
loongarch            randconfig-r2110-20261011    gcc-16.1.0 cocci
loongarch            randconfig-r2111-20261012    gcc-16.1.0 cocci
loongarch            randconfig-r2306-20261011    gcc-16.1.0 sparse
loongarch            randconfig-r2308-20261011    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    gcc-16.1.0
m68k                                 defconfig    gcc-16.1.0
m68k                         m5272c3_defconfig    gcc-16.1.0
m68k                             q40_defconfig    gcc-16.1.0
m68k                 randconfig-r2201-20261012    gcc-13.4.0 smatch
m68k                 randconfig-r2310-20261011    clang-24   sparse
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2104-20261012    gcc-16.1.0 cocci
microblaze           randconfig-r2202-20261012    gcc-15.2.0 smatch
microblaze           randconfig-r2306-20261011    clang-24   sparse
microblaze           randconfig-r2309-20261011    clang-24   sparse
microblaze           randconfig-r2310-20261012    clang-22   sparse
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                 randconfig-r2103-20261011    gcc-16.1.0 cocci
mips                 randconfig-r2106-20261012    gcc-8.5.0  cocci
mips                 randconfig-r2107-20261011    clang-24   cocci
mips                 randconfig-r2300-20261012    clang-17   sparse
mips                 randconfig-r2302-20261011    gcc-12.5.0 sparse
mips                 randconfig-r2305-20261012    clang-17   sparse
mips                 randconfig-r2306-20261012    clang-22   sparse
mips                 randconfig-r2309-20261011    clang-24   sparse
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261012    gcc-8.5.0
nios2                 randconfig-1001-20261012    gcc-11.5.0
nios2                 randconfig-2000-20261011    gcc-8.5.0
nios2                 randconfig-2000-20261012    gcc-11.5.0
nios2                 randconfig-2001-20261011    gcc-8.5.0
nios2                 randconfig-2001-20261012    gcc-11.5.0
nios2                randconfig-r2102-20261012    gcc-11.5.0 cocci
nios2                randconfig-r2110-20261012    gcc-8.5.0  cocci
nios2                randconfig-r2111-20261012    gcc-15.2.0 cocci
nios2                randconfig-r2202-20261011    gcc-8.5.0  smatch
nios2                randconfig-r2304-20261011    gcc-8.5.0  sparse
nios2                randconfig-r2307-20261011    clang-24   sparse
nios2                randconfig-r2308-20261011    gcc-11.5.0 sparse
openrisc                          allmodconfig    gcc-16.1.0
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2101-20261012    clang-24   cocci
openrisc             randconfig-r2103-20261012    clang-24   cocci
openrisc             randconfig-r2104-20261011    clang-22   cocci
openrisc             randconfig-r2104-20261011    gcc-16.1.0 cocci
openrisc             randconfig-r2105-20261012    gcc-15.2.0 cocci
openrisc             randconfig-r2305-20261011    gcc-14.3.0 sparse
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                randconfig-1000-20261012    gcc-15.2.0
parisc                randconfig-1001-20261012    gcc-13.4.0
parisc                randconfig-2000-20261011    gcc-8.5.0
parisc                randconfig-2000-20261012    gcc-11.5.0
parisc                randconfig-2001-20261011    gcc-8.5.0
parisc                randconfig-2001-20261012    gcc-11.5.0
parisc               randconfig-r2100-20261011    gcc-8.5.0  cocci
parisc               randconfig-r2100-20261012    clang-20   cocci
parisc               randconfig-r2101-20261012    clang-20   cocci
parisc               randconfig-r2201-20261011    gcc-11.5.0 smatch
parisc               randconfig-r2201-20261012    gcc-16.1.0 smatch
parisc               randconfig-r2301-20261012    clang-19   sparse
parisc               randconfig-r2304-20261012    gcc-9.5.0  sparse
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    gcc-16.1.0
powerpc                      kmeter1_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261012    clang-17
powerpc               randconfig-1001-20261012    gcc-8.5.0
powerpc               randconfig-2000-20261011    clang-22
powerpc               randconfig-2000-20261011    gcc-8.5.0
powerpc               randconfig-2000-20261012    gcc-14
powerpc               randconfig-2001-20261011    clang-22
powerpc               randconfig-2001-20261011    gcc-8.5.0
powerpc               randconfig-2001-20261012    gcc-14
powerpc              randconfig-r2101-20261011    gcc-8.5.0  cocci
powerpc              randconfig-r2103-20261012    gcc-11.5.0 cocci
powerpc              randconfig-r2106-20261012    gcc-15.2.0 cocci
powerpc              randconfig-r2111-20261011    clang-24   cocci
powerpc              randconfig-r2302-20261012    clang-19   sparse
powerpc              randconfig-r2305-20261012    clang-19   sparse
powerpc              randconfig-r2306-20261011    clang-24   sparse
powerpc              randconfig-r2311-20261011    clang-24   sparse
powerpc64             randconfig-1000-20261012    clang-24
powerpc64             randconfig-1001-20261012    clang-24
powerpc64             randconfig-2000-20261011    clang-22
powerpc64             randconfig-2000-20261011    gcc-8.5.0
powerpc64             randconfig-2000-20261012    gcc-14
powerpc64             randconfig-2001-20261011    clang-22
powerpc64             randconfig-2001-20261011    gcc-12.5.0
powerpc64             randconfig-2001-20261012    gcc-14
powerpc64            randconfig-r2101-20261011    gcc-16.1.0 cocci
powerpc64            randconfig-r2104-20261012    gcc-15.2.0 cocci
powerpc64            randconfig-r2106-20261011    gcc-16.1.0 cocci
powerpc64            randconfig-r2108-20261012    clang-20   cocci
powerpc64            randconfig-r2110-20261011    clang-22   cocci
powerpc64            randconfig-r2302-20261011    clang-24   sparse
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                 randconfig-1000-20261012    clang-24
riscv                 randconfig-1001-20261012    clang-24
riscv                 randconfig-2000-20261011    gcc-13.4.0
riscv                 randconfig-2000-20261011    gcc-8.5.0
riscv                 randconfig-2000-20261012    gcc-14.3.0
riscv                 randconfig-2001-20261011    gcc-13.4.0
riscv                 randconfig-2001-20261011    gcc-8.5.0
riscv                 randconfig-2001-20261012    gcc-14.3.0
riscv                randconfig-r2107-20261011    clang-24   cocci
riscv                randconfig-r2110-20261012    gcc-15.2.0 cocci
riscv                randconfig-r2301-20261011    clang-24   sparse
riscv                randconfig-r2303-20261012    clang-19   sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261012    clang-24
s390                  randconfig-1001-20261012    gcc-8.5.0
s390                  randconfig-2000-20261011    clang-17
s390                  randconfig-2000-20261011    gcc-13.4.0
s390                  randconfig-2000-20261012    gcc-14.3.0
s390                  randconfig-2001-20261011    clang-24
s390                  randconfig-2001-20261011    gcc-13.4.0
s390                  randconfig-2001-20261012    gcc-14.3.0
s390                 randconfig-r2201-20261012    clang-17   smatch
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261012    gcc-16.1.0
sh                    randconfig-1001-20261012    gcc-16.1.0
sh                    randconfig-2000-20261011    gcc-13.4.0
sh                    randconfig-2000-20261012    gcc-14.3.0
sh                    randconfig-2001-20261011    gcc-13.4.0
sh                    randconfig-2001-20261011    gcc-16.1.0
sh                    randconfig-2001-20261012    gcc-14.3.0
sh                   randconfig-r2101-20261012    gcc-11.5.0 cocci
sh                   randconfig-r2107-20261012    gcc-15.2.0 cocci
sh                   randconfig-r2108-20261011    gcc-16.1.0 cocci
sh                   randconfig-r2303-20261011    clang-24   sparse
sh                   randconfig-r2305-20261011    gcc-13.4.0 sparse
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261012    gcc-13.4.0
sparc                 randconfig-1001-20261012    gcc-15.2.0
sparc                 randconfig-2000-20261011    gcc-8.5.0
sparc                 randconfig-2000-20261012    gcc-8.5.0
sparc                 randconfig-2001-20261011    gcc-8.5.0
sparc                 randconfig-2001-20261012    gcc-8.5.0
sparc                randconfig-r2105-20261011    clang-24   cocci
sparc                randconfig-r2105-20261012    gcc-8.5.0  cocci
sparc                randconfig-r2108-20261011    gcc-16.1.0 cocci
sparc                randconfig-r2200-20261011    gcc-8.5.0  smatch
sparc                randconfig-r2201-20261011    gcc-14.3.0 smatch
sparc                randconfig-r2202-20261011    gcc-16.1.0 smatch
sparc                randconfig-r2300-20261011    clang-24   sparse
sparc                randconfig-r2303-20261012    clang-17   sparse
sparc                randconfig-r2307-20261011    clang-24   sparse
sparc                randconfig-r2310-20261011    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-1000-20261012    gcc-16.1.0
sparc64               randconfig-1001-20261012    clang-20
sparc64               randconfig-2000-20261011    clang-24
sparc64               randconfig-2000-20261011    gcc-8.5.0
sparc64               randconfig-2000-20261012    gcc-8.5.0
sparc64               randconfig-2001-20261011    gcc-10.5.0
sparc64               randconfig-2001-20261011    gcc-8.5.0
sparc64               randconfig-2001-20261012    gcc-8.5.0
sparc64              randconfig-r2100-20261012    clang-24   cocci
sparc64              randconfig-r2102-20261012    clang-20   cocci
sparc64              randconfig-r2105-20261011    clang-21   cocci
sparc64              randconfig-r2111-20261011    clang-22   cocci
sparc64              randconfig-r2301-20261011    gcc-16.1.0 sparse
sparc64              randconfig-r2302-20261012    gcc-9.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261012    gcc-14
um                    randconfig-1001-20261012    gcc-14
um                    randconfig-2000-20261011    gcc-14
um                    randconfig-2000-20261011    gcc-8.5.0
um                    randconfig-2000-20261012    gcc-8.5.0
um                    randconfig-2001-20261011    gcc-14
um                    randconfig-2001-20261011    gcc-8.5.0
um                    randconfig-2001-20261012    gcc-8.5.0
um                   randconfig-r2102-20261011    gcc-16.1.0 cocci
um                   randconfig-r2102-20261012    clang-24   cocci
um                   randconfig-r2103-20261012    clang-20   cocci
um                   randconfig-r2105-20261012    gcc-16.1.0 cocci
um                   randconfig-r2107-20261012    gcc-16.1.0 cocci
um                   randconfig-r2110-20261012    gcc-16.1.0 cocci
um                   randconfig-r2301-20261011    gcc-14.3.0 sparse
um                   randconfig-r2301-20261012    clang-17   sparse
um                   randconfig-r2303-20261011    gcc-14.3.0 sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261012    gcc-14
x86_64      buildonly-randconfig-1001-20261012    clang-22
x86_64      buildonly-randconfig-1002-20261012    clang-22
x86_64      buildonly-randconfig-1003-20261012    gcc-14
x86_64      buildonly-randconfig-1004-20261012    clang-22
x86_64      buildonly-randconfig-1005-20261012    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261012    clang-22
x86_64                randconfig-1001-20261012    clang-22
x86_64                randconfig-1002-20261012    gcc-14
x86_64                randconfig-1003-20261012    clang-22
x86_64                randconfig-1004-20261012    clang-22
x86_64                randconfig-1005-20261012    clang-22
x86_64                randconfig-1006-20261012    clang-22
x86_64                randconfig-1007-20261012    clang-22
x86_64                randconfig-1008-20261012    clang-22
x86_64                randconfig-1009-20261012    gcc-14
x86_64                randconfig-1010-20261012    gcc-14
x86_64                randconfig-1011-20261012    gcc-14
x86_64                randconfig-1012-20261012    clang-22
x86_64                randconfig-1013-20261012    clang-22
x86_64                randconfig-1014-20261012    gcc-12
x86_64                randconfig-1015-20261012    clang-22
x86_64                randconfig-1016-20261012    clang-22
x86_64                randconfig-1017-20261012    gcc-14
x86_64                randconfig-2000-20261011    clang-22
x86_64                randconfig-2000-20261012    gcc-14
x86_64                randconfig-2001-20261011    clang-22
x86_64                randconfig-2001-20261012    gcc-14
x86_64                randconfig-2100-20261011    gcc-12     cocci
x86_64                randconfig-2100-20261011    gcc-14     cocci
x86_64                randconfig-2100-20261012    clang-22   cocci
x86_64                randconfig-2101-20261011    gcc-14     cocci
x86_64                randconfig-2101-20261012    clang-22   cocci
x86_64                randconfig-2102-20261011    gcc-14     cocci
x86_64                randconfig-2102-20261012    clang-22   cocci
x86_64                randconfig-2103-20261011    gcc-14     cocci
x86_64                randconfig-2103-20261012    clang-22   cocci
x86_64                randconfig-2104-20261011    clang-22   cocci
x86_64                randconfig-2104-20261011    gcc-14     cocci
x86_64                randconfig-2104-20261012    clang-22   cocci
x86_64                randconfig-2105-20261011    gcc-14     cocci
x86_64                randconfig-2105-20261012    clang-22   cocci
x86_64                randconfig-2200-20261011    clang-22   smatch
x86_64                randconfig-2200-20261012    gcc-14     smatch
x86_64                randconfig-2300-20261011    gcc-14     sparse
x86_64                randconfig-2300-20261012    gcc-14     sparse
x86_64                randconfig-2301-20261011    gcc-14     sparse
x86_64                randconfig-2301-20261012    gcc-14     sparse
x86_64                randconfig-2302-20261011    gcc-14     sparse
x86_64                randconfig-2302-20261012    gcc-14     sparse
x86_64               randconfig-r2107-20261011    clang-22   cocci
x86_64               randconfig-r2108-20261012    gcc-11.5.0 cocci
x86_64               randconfig-r2109-20261011    gcc-8.5.0  cocci
x86_64               randconfig-r2109-20261012    clang-20   cocci
x86_64               randconfig-r2300-20261011    gcc-14.3.0 sparse
x86_64               randconfig-r2305-20261012    gcc-9.5.0  sparse
x86_64               randconfig-r2307-20261012    clang-22   sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    gcc-16.1.0
xtensa                randconfig-1000-20261012    gcc-11.5.0
xtensa                randconfig-1001-20261012    gcc-9.5.0
xtensa                randconfig-2000-20261011    gcc-8.5.0
xtensa                randconfig-2000-20261012    gcc-8.5.0
xtensa                randconfig-2001-20261011    gcc-13.4.0
xtensa                randconfig-2001-20261011    gcc-8.5.0
xtensa                randconfig-2001-20261012    gcc-8.5.0
xtensa               randconfig-r2102-20261011    gcc-8.5.0  cocci
xtensa               randconfig-r2103-20261011    gcc-8.5.0  cocci
xtensa               randconfig-r2105-20261011    clang-22   cocci
xtensa               randconfig-r2109-20261011    gcc-12.5.0 cocci
xtensa               randconfig-r2110-20261011    clang-24   cocci
xtensa               randconfig-r2200-20261012    gcc-8.5.0  smatch
xtensa               randconfig-r2301-20261012    gcc-9.5.0  sparse
xtensa               randconfig-r2308-20261012    clang-22   sparse

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

