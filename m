Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6DACA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 06:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61666B0092; Wed,  7 Oct 2026 02:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11CD6B0093; Wed,  7 Oct 2026 02:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902276B0095; Wed,  7 Oct 2026 02:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66FF36B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:47:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E47A6120439
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:47:56 +0000 (UTC)
X-FDA: 85294900152.07.7085F63
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf29.hostedemail.com (Postfix) with ESMTP id 16B6F120005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:47:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MtioMsrw;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791355675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=w2OSPVUFC80egzuV8UtqAzEFViRK4G28b+72NnFC694=;
	b=Uzqy6bEpM5t+2uCb0H2ZDV1ucnVMdbkW3vuypVDZJwuoLn0v4Ml0WZZ4yoILx1hPh5dazS
	eJqW8H8vViV56DA94gWLC6pxi1dTik+eZJIpdoG/MwKMRJ5i3WY85K08R9nn8WqIw1nJTD
	aV9T0dLo4WWS+ERQPYib5IDOOOdJ7zU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791355675;
	b=JdNz+Drkkez4HzfWYNRNKUI5c1WJjkmz9TIzF6yTnYycK9CVvo9MBwZboB7uJUHW2SJ3Z7
	qYbAnmiFy78YB3riKN9BjVKpyDVIQAR3QgijOwW+9olhyb0EztQh8QdB4+rJoLJSw40Awo
	M/nq05iItbZ5GyKyRd2FiiGmDhdNOyw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MtioMsrw;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791355674; x=1822891674;
  h=date:from:to:cc:subject:message-id;
  bh=Ywaz9b7b/ectv3iF/LDRWnv4Tk3P0f5zRQL0G3KFnH0=;
  b=MtioMsrwkiGLBqq+TAtiEb7jslxT2RB+bNCJrBlwoFOlDKYbdbABmH02
   dPYUXiIKuM5hyjSOU+QzzqxpQ+RI9cwSezxsR/tZ54RV8nIcTLeGMDNuc
   FYm69o8k0bI63wmcfHppAX2O4E6Gk9syxj953DAnlqt3l1rg459vnt0Xw
   Nz3dpN9igaRvcDC44caYIMayusiD2e8uVwHZicYKMpx6tHFcR/c4xFL4P
   xoxn6TKe/8m4eIeM1+YxoEOHeVB5l6ydBOkiFCyxIYvf708i64PaUVnZr
   epf5L3E26Wr4XovNIzy3tiJMueXgTCl3DMHH3AuvlQM64iTEzvGk9QZOT
   Q==;
X-CSE-ConnectionGUID: FJrLv2kbSyKYPY8Rr5tJSg==
X-CSE-MsgGUID: UXTPXb16TNmPfXTIgWqWfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="2879"
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="2879"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 23:47:52 -0700
X-CSE-ConnectionGUID: +peGS7snRFG97qXaK02iTw==
X-CSE-MsgGUID: DUzz80slRNiYx1mn0z9zzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="285458548"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 06 Oct 2026 23:47:51 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xELRM-000000002bU-1AA6;
	Wed, 07 Oct 2026 06:47:48 +0000
Date: Wed, 07 Oct 2026 14:46:55 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD REGRESSION
 3fa97dbf7e37bff1e4dbe8bfd026c1b4a13e186e
Message-ID: <202610071450.i6M2Kc7Q-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 16B6F120005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nma3ict549wqnchzgqwg4w15y9jjx36a
X-HE-Tag: 1791355673-10200
X-HE-Meta: U2FsdGVkX18vv7ag+f4nV9ubLpnK50Tf/Hsh/Awup0Okj6Nrff4pObNyJOt8MG69mWdzyM6g4p5FJERRcBNMf7euTCzbPAkELILVlr75zqlXWwBlq7yQZ8H0pVgIbxxTv0M1wpa1HnPCcNOMkLrlikLLcEx+f3s3mRboAbcnMZiIJocw4Bfu+NnALcDmORxUs5KTy+obIu2ygoX4b3Tz+WR84U5+gKQX8goxHbHAUEzRdib1JuwvDQQHlLZWr7y05vx4t/T4YEeztHYIfWZJPPl4WLnCL3yCa+0uAiRDngA5rKhAw2I6YlBV7sUjFlXvl5iZXRG465QPjs8NdRoUlrh9ASzw1p39IdVz/LDmwu1MDldoULt2rEVO0N7Ou+7GEP+F5T7YtzWWEeXUAhzJIg3OhEGsdGrFARX0v5Tnk1umC6gQfBeJYowIVgcpxoiPdMa4psGolHSGGnYllfBr8sHnp0zJBK2HWhOQ6VOXZkGnRIxzGaZzwjYW2pMSP9ZnZgF0bILogxNhc1Nh7KPeCPIA+XzgvxsGbOdBzbq2mgzECHTGv054JqprImwB6Z+lnrAC67zmhyePEuQ8SxWuBGI9PPcWsMFReb7ja7zZ3/AuT1t8flCoTPv2s7hoDxMQNsEEivJzj/k/qM2xNtAqubMGQy9EvERc1U3qrx0qL+BPEUEOJi6cuy7OsYe77QJVG3y5vuog/WwNnNS9PiQoM+TqmfuK9vK1MMKorapuXknNwmlElLP5ibPqMFi1vJOi6j/lb23/s46w6Hi12OMGSNXGS+h+zqv2Ab3U4cAZw8kIBrOCir9cNaUeAiWNwOcPXJh0qPFVM+NcOuDrAYJXH6L4R4cgo58l8cHOzLpQjTdM1Vp7/KeS88a80HfGZhMC6klRGHUOUlMbpjO2L6YltnAK5fpR6RtzqiVDZ2Y4BPGbGZy8vWWoSI4kATzwpzmXjjq8G9S5jTbMsX/P/+F
 vo90OlL9
 9sXAMqUHPLQw3f6VLkMy72F9l/VeuYFXkSJxQ3MDjQvK3+AaVXj1pJ1ujqQwGNlzE4bYzTr3VKy+SUJVneerZUGwG2XJXhDJmIFICSDH9rKJlAfCr87T0vsxB3K+PRrAcSfbshS53i8vHSq/TudRnKM6PakvSu23YCtn4XPvwK0YXmIhxfbqmSY6BpcMV5JA6S9rzxFqd36nMoHY638OOkhOkLHHiK1Uatx1l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 3fa97dbf7e37bff1e4dbe8bfd026c1b4a13e186e  mm/swap, PM: hibernate: atomically replace hibernation pin

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202609121707.Hya5cxAX-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202609151628.hydefVEV-lkp@intel.com

    drivers/scsi/sg.c:294:1-17: ERROR: sg_fops: .read() can deadlock .write(); change nonseekable_open -> stream_open to fix.
    fs/proc/task_mmu.c:1427 show_smaps_rollup() warn: 'vma' is an error pointer or valid

Error/Warning ids grouped by kconfigs:

recent_errors
|-- arc-randconfig-r2103-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- arm64-randconfig-r2104-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- arm64-randconfig-r2106-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2100-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2101-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2102-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2103-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- i386-randconfig-2200-20261006
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- openrisc-randconfig-r2107-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc-randconfig-r2101-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
|-- sparc-randconfig-r2201-20261006
|   `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid
|-- x86_64-randconfig-2102-20261006
|   `-- drivers-scsi-sg.c:ERROR:sg_fops:read()-can-deadlock-write()-change-nonseekable_open-stream_open-to-fix.
`-- x86_64-randconfig-2200-20261006
    `-- fs-proc-task_mmu.c-show_smaps_rollup()-warn:vma-is-an-error-pointer-or-valid

elapsed time: 1049m

configs tested: 326
configs skipped: 16

tested configs:
alpha                              allnoconfig    gcc-16.1.0
alpha                             allyesconfig    gcc-16.1.0
alpha                                defconfig    gcc-16.1.0
alpha                randconfig-r2202-20261006    gcc-10.5.0 smatch
alpha                randconfig-r2308-20261006    gcc-8.5.0  sparse
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.1.0
arc                                allnoconfig    gcc-16.1.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.1.0
arc                      nsimosci_hs_defconfig    gcc-16.1.0
arc                   randconfig-1000-20261006    gcc-8.5.0
arc                   randconfig-1000-20261007    clang-24
arc                   randconfig-1001-20261006    gcc-10.5.0
arc                   randconfig-1001-20261007    clang-24
arc                  randconfig-r2103-20261006    gcc-8.5.0  cocci
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.1.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.1.0
arm                                  defconfig    clang-24
arm                                  defconfig    gcc-16.1.0
arm                   randconfig-1000-20261006    clang-24
arm                   randconfig-1000-20261007    clang-24
arm                   randconfig-1001-20261006    clang-24
arm                   randconfig-1001-20261007    clang-24
arm                   randconfig-1002-20261006    clang-17
arm                   randconfig-1002-20261007    clang-24
arm                   randconfig-1003-20261006    clang-24
arm                   randconfig-1003-20261007    clang-24
arm                     vt8500_v6_v7_defconfig    gcc-16.1.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.1.0
arm64                                defconfig    gcc-16.1.0
arm64                 randconfig-1000-20261006    clang-24
arm64                 randconfig-1000-20261007    gcc-13.4.0
arm64                 randconfig-1001-20261006    gcc-13.4.0
arm64                 randconfig-1001-20261007    gcc-13.4.0
arm64                 randconfig-1002-20261006    clang-24
arm64                 randconfig-1002-20261007    gcc-13.4.0
arm64                 randconfig-1003-20261006    clang-24
arm64                 randconfig-1003-20261007    gcc-13.4.0
arm64                randconfig-r2104-20261006    clang-17   cocci
arm64                randconfig-r2106-20261006    clang-17   cocci
arm64                randconfig-r2306-20261006    gcc-10.5.0 sparse
csky                              allmodconfig    gcc-16.1.0
csky                               allnoconfig    gcc-16.1.0
csky                                 defconfig    gcc-16.1.0
csky                  randconfig-1000-20261006    gcc-16.1.0
csky                  randconfig-1000-20261007    gcc-13.4.0
csky                  randconfig-1001-20261006    gcc-14.3.0
csky                  randconfig-1001-20261007    gcc-13.4.0
csky                 randconfig-r2102-20261006    gcc-16.1.0 cocci
csky                 randconfig-r2309-20261006    gcc-16.1.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.1.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.1.0
hexagon                              defconfig    clang-24
hexagon                              defconfig    gcc-16.1.0
hexagon               randconfig-1000-20261007    clang-17
hexagon               randconfig-1000-20261007    gcc-12.5.0
hexagon               randconfig-1001-20261007    clang-19
hexagon               randconfig-1001-20261007    gcc-12.5.0
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.1.0
i386        buildonly-randconfig-1000-20261006    gcc-14
i386        buildonly-randconfig-1000-20261007    gcc-14
i386        buildonly-randconfig-1001-20261006    clang-22
i386        buildonly-randconfig-1001-20261007    gcc-14
i386        buildonly-randconfig-1002-20261006    gcc-14
i386        buildonly-randconfig-1002-20261007    gcc-14
i386        buildonly-randconfig-1003-20261006    clang-22
i386        buildonly-randconfig-1003-20261007    gcc-14
i386        buildonly-randconfig-1004-20261006    clang-22
i386        buildonly-randconfig-1004-20261007    gcc-14
i386        buildonly-randconfig-1005-20261006    clang-22
i386        buildonly-randconfig-1005-20261007    gcc-14
i386                                 defconfig    clang-22
i386                                 defconfig    gcc-16.1.0
i386                  randconfig-1000-20261007    clang-22
i386                  randconfig-1000-20261007    gcc-14
i386                  randconfig-1001-20261007    clang-22
i386                  randconfig-1002-20261007    clang-22
i386                  randconfig-1003-20261007    clang-22
i386                  randconfig-1004-20261007    clang-22
i386                  randconfig-1004-20261007    gcc-14
i386                  randconfig-1005-20261007    clang-22
i386                  randconfig-1006-20261007    clang-22
i386                  randconfig-1007-20261006    clang-22
i386                  randconfig-1007-20261007    gcc-14
i386                  randconfig-1008-20261006    gcc-14
i386                  randconfig-1008-20261007    gcc-14
i386                  randconfig-1009-20261006    gcc-14
i386                  randconfig-1009-20261007    gcc-14
i386                  randconfig-1010-20261006    gcc-13
i386                  randconfig-1010-20261007    gcc-14
i386                  randconfig-1011-20261006    clang-22
i386                  randconfig-1011-20261007    gcc-14
i386                  randconfig-1012-20261006    clang-22
i386                  randconfig-1012-20261007    gcc-14
i386                  randconfig-1013-20261006    clang-22
i386                  randconfig-1013-20261007    gcc-14
i386                  randconfig-2100-20261006    clang-22   cocci
i386                  randconfig-2101-20261006    clang-22   cocci
i386                  randconfig-2102-20261006    clang-22   cocci
i386                  randconfig-2103-20261006    gcc-14     cocci
i386                  randconfig-2200-20261006    gcc-13     smatch
i386                  randconfig-2300-20261006    clang-22   sparse
i386                  randconfig-2301-20261006    gcc-14     sparse
i386                  randconfig-2302-20261006    gcc-14     sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.1.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261007    clang-24
loongarch             randconfig-1000-20261007    gcc-12.5.0
loongarch             randconfig-1001-20261007    gcc-12.5.0
loongarch            randconfig-r2100-20261006    gcc-14.3.0 cocci
loongarch            randconfig-r2302-20261006    clang-20   sparse
loongarch            randconfig-r2303-20261006    clang-24   sparse
m68k                              allmodconfig    gcc-16.1.0
m68k                               allnoconfig    gcc-16.1.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.1.0
m68k                          apollo_defconfig    gcc-16.1.0
m68k                                 defconfig    clang-24
m68k                                 defconfig    gcc-16.1.0
m68k                        m5235evb_defconfig    gcc-16.1.0
m68k                        m5249evb_defconfig    gcc-16.1.0
m68k                        m5275evb_defconfig    gcc-16.1.0
microblaze                         allnoconfig    gcc-16.1.0
microblaze                        allyesconfig    gcc-16.1.0
microblaze                           defconfig    clang-24
microblaze                           defconfig    gcc-16.1.0
microblaze           randconfig-r2105-20261006    gcc-8.5.0  cocci
mips                              allmodconfig    gcc-16.1.0
mips                               allnoconfig    gcc-16.1.0
mips                              allyesconfig    gcc-16.1.0
mips                         maltaup_defconfig    clang-17
mips                         omega2p_defconfig    clang-17
nios2                             alldefconfig    gcc-11.5.0
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261007    gcc-12.5.0
nios2                 randconfig-1000-20261007    gcc-9.5.0
nios2                 randconfig-1001-20261007    gcc-11.5.0
nios2                 randconfig-1001-20261007    gcc-12.5.0
nios2                randconfig-r2200-20261006    gcc-11.5.0 smatch
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.1.0
openrisc                             defconfig    gcc-16.1.0
openrisc             randconfig-r2107-20261006    gcc-10.5.0 cocci
openrisc                        virt_defconfig    gcc-16.1.0
parisc                            allmodconfig    gcc-16.1.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.1.0
parisc                            allyesconfig    gcc-16.1.0
parisc                               defconfig    gcc-16.1.0
parisc                 generic-32bit_defconfig    gcc-16.1.0
parisc                randconfig-1000-20261006    gcc-14.3.0
parisc                randconfig-1000-20261007    gcc-15.2.0
parisc                randconfig-1001-20261006    gcc-8.5.0
parisc                randconfig-1001-20261007    gcc-15.2.0
parisc               randconfig-r2307-20261006    gcc-8.5.0  sparse
parisc64                             defconfig    clang-24
parisc64                             defconfig    gcc-16.1.0
powerpc                           allmodconfig    gcc-16.1.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.1.0
powerpc                     ge_imp3a_defconfig    gcc-16.1.0
powerpc               randconfig-1000-20261006    clang-24
powerpc               randconfig-1000-20261007    gcc-15.2.0
powerpc               randconfig-1001-20261006    gcc-11.5.0
powerpc               randconfig-1001-20261007    gcc-15.2.0
powerpc                      tqm8548_defconfig    clang-24
powerpc64             randconfig-1000-20261006    clang-24
powerpc64             randconfig-1000-20261007    gcc-15.2.0
powerpc64             randconfig-1001-20261006    gcc-13.4.0
powerpc64             randconfig-1001-20261007    gcc-15.2.0
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.1.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                                defconfig    gcc-16.1.0
riscv                 randconfig-1000-20261006    gcc-8.5.0
riscv                 randconfig-1000-20261007    clang-24
riscv                 randconfig-1001-20261006    gcc-8.5.0
riscv                 randconfig-1001-20261007    clang-24
riscv                 randconfig-2000-20261006    gcc-14.3.0
riscv                 randconfig-2001-20261006    gcc-16.1.0
riscv                randconfig-r2305-20261006    gcc-12.5.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.1.0
s390                                 defconfig    clang-18
s390                                 defconfig    gcc-16.1.0
s390                  randconfig-1000-20261006    clang-24
s390                  randconfig-1000-20261007    clang-24
s390                  randconfig-1001-20261006    gcc-11.5.0
s390                  randconfig-1001-20261007    clang-24
s390                  randconfig-2000-20261006    gcc-14.3.0
s390                  randconfig-2001-20261006    gcc-8.5.0
sh                                allmodconfig    gcc-16.1.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.1.0
sh                                allyesconfig    gcc-16.1.0
sh                                   defconfig    gcc-14
sh                                   defconfig    gcc-16.1.0
sh                    randconfig-1000-20261006    gcc-12.5.0
sh                    randconfig-1000-20261007    clang-24
sh                    randconfig-1001-20261006    gcc-10.5.0
sh                    randconfig-1001-20261007    clang-24
sh                    randconfig-2000-20261006    gcc-16.1.0
sh                    randconfig-2001-20261006    gcc-16.1.0
sh                   randconfig-r2301-20261006    gcc-16.1.0 sparse
sh                            se7712_defconfig    gcc-16.1.0
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.1.0
sparc                                defconfig    gcc-16.1.0
sparc                 randconfig-1000-20261006    gcc-16.1.0
sparc                 randconfig-1000-20261007    clang-17
sparc                 randconfig-1001-20261006    gcc-14.3.0
sparc                 randconfig-1001-20261007    clang-17
sparc                 randconfig-2000-20261006    gcc-15.2.0
sparc                 randconfig-2001-20261006    gcc-16.1.0
sparc                randconfig-r2101-20261006    gcc-8.5.0  cocci
sparc                randconfig-r2201-20261006    gcc-16.1.0 smatch
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261006    clang-24
sparc64               randconfig-1000-20261007    clang-17
sparc64               randconfig-1001-20261006    clang-21
sparc64               randconfig-1001-20261007    clang-17
sparc64               randconfig-2000-20261006    clang-20
sparc64               randconfig-2001-20261006    gcc-8.5.0
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.1.0
um                                   defconfig    clang-24
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261006    gcc-14
um                    randconfig-1000-20261007    clang-17
um                    randconfig-1001-20261006    clang-17
um                    randconfig-1001-20261007    clang-17
um                    randconfig-2000-20261006    gcc-14
um                    randconfig-2001-20261006    clang-24
um                            x86_64_defconfig    clang-24
um                            x86_64_defconfig    gcc-14
um                            x86_64_defconfig    gcc-16.1.0
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261006    gcc-14
x86_64      buildonly-randconfig-1000-20261007    gcc-14
x86_64      buildonly-randconfig-1001-20261006    gcc-14
x86_64      buildonly-randconfig-1001-20261007    gcc-14
x86_64      buildonly-randconfig-1002-20261006    clang-22
x86_64      buildonly-randconfig-1002-20261007    gcc-14
x86_64      buildonly-randconfig-1003-20261007    gcc-14
x86_64      buildonly-randconfig-1004-20261006    gcc-14
x86_64      buildonly-randconfig-1004-20261007    gcc-14
x86_64      buildonly-randconfig-1005-20261006    clang-22
x86_64      buildonly-randconfig-1005-20261007    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261007    clang-22
x86_64                randconfig-1001-20261007    clang-22
x86_64                randconfig-1001-20261007    gcc-14
x86_64                randconfig-1002-20261007    clang-22
x86_64                randconfig-1003-20261007    clang-22
x86_64                randconfig-1004-20261007    clang-22
x86_64                randconfig-1005-20261007    clang-22
x86_64                randconfig-1005-20261007    gcc-13
x86_64                randconfig-1006-20261006    gcc-14
x86_64                randconfig-1006-20261007    clang-22
x86_64                randconfig-1007-20261006    gcc-12
x86_64                randconfig-1007-20261007    clang-22
x86_64                randconfig-1008-20261006    gcc-12
x86_64                randconfig-1008-20261007    clang-22
x86_64                randconfig-1009-20261006    gcc-14
x86_64                randconfig-1009-20261007    clang-22
x86_64                randconfig-1010-20261006    gcc-14
x86_64                randconfig-1010-20261007    clang-22
x86_64                randconfig-1011-20261006    gcc-14
x86_64                randconfig-1011-20261007    clang-22
x86_64                randconfig-1012-20261006    gcc-14
x86_64                randconfig-1013-20261006    clang-22
x86_64                randconfig-1014-20261006    clang-22
x86_64                randconfig-1015-20261006    clang-22
x86_64                randconfig-1016-20261006    gcc-14
x86_64                randconfig-1017-20261006    clang-22
x86_64                randconfig-2100-20261006    clang-22   cocci
x86_64                randconfig-2102-20261006    gcc-14     cocci
x86_64                randconfig-2103-20261006    clang-22   cocci
x86_64                randconfig-2200-20261006    clang-22   smatch
x86_64                randconfig-2300-20261006    gcc-14     sparse
x86_64                randconfig-2301-20261006    clang-22   sparse
x86_64                randconfig-2302-20261006    gcc-14     sparse
x86_64               randconfig-r2300-20261006    clang-22   sparse
x86_64               randconfig-r2304-20261006    clang-22   sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.1.0
xtensa                            allyesconfig    clang-20
xtensa                   audio_kc705_defconfig    gcc-16.1.0
xtensa                randconfig-1000-20261006    gcc-10.5.0
xtensa                randconfig-1000-20261007    clang-17
xtensa                randconfig-1001-20261006    gcc-16.1.0
xtensa                randconfig-1001-20261007    clang-17
xtensa                randconfig-2000-20261006    gcc-9.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

