Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3641C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FE16B00A6; Wed,  1 Jul 2026 06:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1286B00A8; Wed,  1 Jul 2026 06:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E09C6B00A9; Wed,  1 Jul 2026 06:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 675FA6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:13:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC5578D083
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:13:44 +0000 (UTC)
X-FDA: 84939796368.27.BCC6C2E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id 075D1140003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:13:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XYursMmu;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782900823;
	b=S57PHck4It/HgrWVi+E+9Cxs3seOQEDECZL4ZXYrV1K9zje98JBLJrslERBCEh+SkNfCwA
	v1CK+RwtuSyL540ZNzGgAzKwsQxFEhumlcMEUIknArWlA/oCcwLQ686xz7Ti4NaXRyp1s3
	sbriDat58rMnKggSDdkWtiopNWcY/e4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782900823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=kWuoUaNa1UlRdiwHvvb8MVnAsMaEbpXACFsyyaXjY74=;
	b=amvSYjQfcO0ya7ra9F7FUr4hFvQndVMYpYfiwNN5qOuw9ZlLrEm3jQ9kqwQnvd46uKoqjf
	RlF/seYxi4DKs8jhLCdchSeIQqa/HbRM9JqctMG+oKA71DdPyq2tNFrkfdh8vMu/C57jA/
	sn5NFGy/FFmOj5arJ93FrdqUpo9IEmo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XYursMmu;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782900822; x=1814436822;
  h=date:from:to:cc:subject:message-id;
  bh=nu3dFizFFDwleuu4pYeeKi97FA2l9/Cw/yOx7g6woaU=;
  b=XYursMmue/O25UH4Kq6TWE751DyBddIFkSCfqnEmOqoCxthQAmmiZ8iY
   9CaMBwVrsk0x4T2AbqWpZaU8j2qC0bwlEbVAo9Rs6c2yrhiA0qbpQRvtW
   ZGRcAhvSP98a6t9xnM12rnwetZcY3KiP7v6RHqEGy8YeZIebTn+/QSbZ+
   +FzvBAi74AIfyoQfH97r3osb4468UID5DAuZa0TbGXRQ7IpAMucRHR/ub
   d91MZV7Fginw3MVQfLzcHK6BvX2JaVVavSFQLkQ5li41yuGpYl7amkZR4
   geKA3quj7MSvMTno+RlICysXCqw8EjdXrEf0+aoairT7Mz+caMtHTk+rt
   w==;
X-CSE-ConnectionGUID: LPLGxj6OR2OKJWIcNkZ7wg==
X-CSE-MsgGUID: sMaUO90dTP23gPlypgQcxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="93985568"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="93985568"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 03:13:40 -0700
X-CSE-ConnectionGUID: XFPk9g1dTTae1GuN35VlHQ==
X-CSE-MsgGUID: XgGvB5sJR4Sola9dNJ93KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="251481385"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 01 Jul 2026 03:13:38 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1werwP-000000009BX-1oUE;
	Wed, 01 Jul 2026 10:13:25 +0000
Date: Wed, 01 Jul 2026 18:12:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 apparmor@lists.ubuntu.com, linux-arm-kernel@lists.infradead.org,
 linux-input@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-usb@vger.kernel.org,
 virtualization@lists.linux.dev, Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 be5c93fa674f0fc3c8f359c2143abce6bbb422e6
Message-ID: <202607011852.7VW94YAL-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: f4gamxmzmnmsnjzgepon4i8boe73gdck
X-Rspamd-Queue-Id: 075D1140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782900821-313180
X-HE-Meta: U2FsdGVkX19AOxhN4u0Ms3OSe5QxPpHlNeh5ENrb9Apk+Ezj98wsVcvSo+etUPvDlNAkELGJNivbmRzn0VaBMESOSYsXN/7h3Tndt580g1Oc/XSVcupBFehfyyQUY76DncOn03nMAt2IFQCC9L4LcZLCHe5GI40sOUdwNCEuCOGAKingFuhsZbp5Pja7FHL+X/vHKlFEYJJ8NwGZ2vjPnbSLzSr6eIUTTFi0ajnFTomgcaoaOsOSutHdTmrI9LzmRlLGc7AKzZNNV8C+tg0K0BPc2w80g/BEcAoDnPqCf0FjssZNm6Pp+nFKaBoEStYD83rL8hEk9ZlRwYT2DJND7YIZjwaAZWVKhGE2yBtbA8HPKoWrAls6VqhKW/d6YMeFvuxCMqGwxeJ/JmHPcP+/Dz0Ik+717sMCzInfEloTA3nXzwwLUSyVOGTYmDwaKWaZAKg+LkdMn0iDYDrR1IIHT7ANXD4CNjIGXtF8blGW2/WztkZEhEcc8GIyfN9S2tmfE9OBuPESbfTyrVa9SrwPa5+mqx++OUhZpEex/itONUwV355gkLDu3fen/PYQCcHbP99OAgU3esvsl85OelO6cShSPAqJa5hFHQ2a2oaeA/gYr1p6F2raaL0xZPagr0Ly5HY5bMzS+REf4DCSMFI7I/LyEwVUKP1NIy2HJc1s8jOPf8OciP81m+gUZH79XFlVwFzPFJvTxGkvMK+D+XJBjzcn6LCEYsiuYaEdK0ud9NhczEFEinYOkTNdxJtUjTzcgKQDIUQiszfSdcZaTQgCyhVU2deObnb3J9ze4nha9Kx9S5QT4GG9ojETBJ7E5Cna3RIqcuCqVWdj2JccB/nneZmti6oAdYH0YFFSLe1giCHxxLSeJQ3YyuDVpmr9St+BcCkboUnp+A34H/FDMMuf/tqDxyV+iYi+yxVE1vUWRtFqakpBzX3o9Q/QCU+PAnRQu9NmtZzjPVkDaibNEJJ
 CnNUxXpj
 WhidFJEtOizh4E2br2IvBH+BPCZ1kLE7rJYXEg3s2/QpnJLjLEXt8bqFwCmu9OECjayjparFC9eQe0Ds7Qyrj+ALiL9An3QJJx/4nB7aT1IKK62IxYOd7Zgv3VZRiaQss6QO3CZsemNPWTei2KQY7Qnzj/lVFhqOE9q5ORZTRVi1J+dITbTF/sV35viG7z8jhbUi60Z616U8eZ0MybtbvyFrt1/U3idTDzduZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: be5c93fa674f0fc3c8f359c2143abce6bbb422e6  Add linux-next specific files for 20260630

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202607010945.6lDjBFTU-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202607011210.PI7XDDb1-lkp@intel.com

    drivers/remoteproc/remoteproc_internal.h:131:5: error: incompatible integer to pointer conversion assigning to 'void *' from 'int' [-Wint-conversion]
    drivers/remoteproc/remoteproc_internal.h:131:7: error: call to undeclared function 'ioremap_prot'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    drivers/remoteproc/remoteproc_internal.h:146:2: error: call to undeclared function 'iounmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    mm/hugetlb.c:3095:4: warning: array subscript -1 is below array bounds of 'struct list_head[1]' [-Warray-bounds]

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202607010826.2wLg1q08-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202607011451.icwPyCIk-lkp@intel.com

    drivers/hid/hid-asus.c:620 asus_kbd_backlight_work() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/i2c/busses/i2c-rk3x.c:1131 rk3x_i2c_xfer_common() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/rpmsg/rpmsg_char.c:236 rpmsg_eptdev_read_iter() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/usb/host/ehci-hub.c:1080 ehci_hub_control() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/usb/host/ehci-hub.c:691 ehci_hub_status_data() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/usb/host/ehci-sched.c:1290 itd_urb_transaction() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/usb/host/ehci-sched.c:2093 sitd_urb_transaction() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/virtio/virtio_input.c:333 virtinput_probe() error: calling 'spin_unlock_irqrestore()' with bogus flags
    drivers/virtio/virtio_input.c:56 virtinput_recv_events() error: calling 'spin_unlock_irqrestore()' with bogus flags
    security/apparmor/apparmorfs.c:590 policy_update() warn: passing zero to 'PTR_ERR'

Error/Warning ids grouped by kconfigs:

recent_errors
|-- s390-randconfig-002-20260701
|   |-- drivers-remoteproc-remoteproc_internal.h:error:call-to-undeclared-function-ioremap_prot-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- drivers-remoteproc-remoteproc_internal.h:error:call-to-undeclared-function-iounmap-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-remoteproc-remoteproc_internal.h:error:incompatible-integer-to-pointer-conversion-assigning-to-void-from-int
|-- sparc-randconfig-r131-20260701
|   `-- mm-hugetlb.c:warning:array-subscript-is-below-array-bounds-of-struct-list_head
`-- x86_64-randconfig-161-20260701
    |-- drivers-hid-hid-asus.c-asus_kbd_backlight_work()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    |-- drivers-i2c-busses-i2c-rk3x.c-rk3x_i2c_xfer_common()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    |-- drivers-rpmsg-rpmsg_char.c-rpmsg_eptdev_read_iter()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    |-- drivers-usb-host-ehci-hub.c-ehci_hub_control()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    |-- drivers-usb-host-ehci-hub.c-ehci_hub_status_data()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    |-- drivers-usb-host-ehci-sched.c-itd_urb_transaction()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    |-- drivers-usb-host-ehci-sched.c-sitd_urb_transaction()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    |-- drivers-virtio-virtio_input.c-virtinput_probe()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    |-- drivers-virtio-virtio_input.c-virtinput_recv_events()-error:calling-spin_unlock_irqrestore()-with-bogus-flags
    `-- security-apparmor-apparmorfs.c-policy_update()-warn:passing-zero-to-PTR_ERR

elapsed time: 823m

configs tested: 227
configs skipped: 6

tested configs:
alpha                             allnoconfig    gcc-16.1.0
alpha                            allyesconfig    gcc-16.1.0
alpha                               defconfig    gcc-16.1.0
arc                              allmodconfig    clang-23
arc                              allmodconfig    gcc-16.1.0
arc                               allnoconfig    gcc-16.1.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-16.1.0
arc                                 defconfig    gcc-16.1.0
arc                   randconfig-001-20260701    gcc-12.5.0
arc                   randconfig-002-20260701    gcc-12.5.0
arm                               allnoconfig    clang-17
arm                               allnoconfig    gcc-16.1.0
arm                              allyesconfig    clang-23
arm                              allyesconfig    gcc-16.1.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-16.1.0
arm                   randconfig-001-20260701    gcc-12.5.0
arm                   randconfig-002-20260701    gcc-12.5.0
arm                   randconfig-003-20260701    gcc-12.5.0
arm                   randconfig-004-20260701    gcc-12.5.0
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-16.1.0
arm64                               defconfig    gcc-16.1.0
arm64                 randconfig-001-20260701    gcc-12.5.0
arm64                 randconfig-001-20260701    gcc-16.1.0
arm64                 randconfig-002-20260701    clang-17
arm64                 randconfig-002-20260701    gcc-12.5.0
arm64                 randconfig-003-20260701    gcc-12.5.0
arm64                 randconfig-004-20260701    clang-17
arm64                 randconfig-004-20260701    gcc-12.5.0
csky                             allmodconfig    gcc-16.1.0
csky                              allnoconfig    gcc-16.1.0
csky                                defconfig    gcc-16.1.0
csky                  randconfig-001-20260701    gcc-10.5.0
csky                  randconfig-001-20260701    gcc-12.5.0
csky                  randconfig-002-20260701    gcc-12.5.0
hexagon                          allmodconfig    clang-23
hexagon                          allmodconfig    gcc-16.1.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-16.1.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-16.1.0
hexagon                        randconfig-001    gcc-11.5.0
hexagon               randconfig-001-20260701    clang-23
hexagon               randconfig-001-20260701    gcc-11.5.0
hexagon                        randconfig-002    gcc-11.5.0
hexagon               randconfig-002-20260701    clang-17
hexagon               randconfig-002-20260701    gcc-11.5.0
i386                             allmodconfig    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-16.1.0
i386                             allyesconfig    clang-22
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260701    clang-22
i386        buildonly-randconfig-002-20260701    clang-22
i386        buildonly-randconfig-003-20260701    clang-22
i386        buildonly-randconfig-004-20260701    clang-22
i386        buildonly-randconfig-005-20260701    clang-22
i386        buildonly-randconfig-006-20260701    clang-22
i386                                defconfig    clang-22
i386                                defconfig    gcc-16.1.0
i386                  randconfig-001-20260701    clang-22
i386                  randconfig-002-20260701    clang-22
i386                  randconfig-003-20260701    clang-22
i386                  randconfig-004-20260701    clang-22
i386                  randconfig-005-20260701    clang-22
i386                  randconfig-006-20260701    clang-22
i386                  randconfig-007-20260701    clang-22
i386                  randconfig-011-20260701    gcc-14
i386                  randconfig-012-20260701    gcc-14
i386                  randconfig-013-20260701    gcc-14
i386                  randconfig-014-20260701    gcc-14
i386                  randconfig-015-20260701    gcc-14
i386                  randconfig-016-20260701    gcc-14
i386                  randconfig-017-20260701    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-20
loongarch                         allnoconfig    gcc-16.1.0
loongarch                           defconfig    clang-23
loongarch                      randconfig-001    gcc-11.5.0
loongarch             randconfig-001-20260701    clang-23
loongarch             randconfig-001-20260701    gcc-11.5.0
loongarch                      randconfig-002    gcc-11.5.0
loongarch             randconfig-002-20260701    clang-19
loongarch             randconfig-002-20260701    gcc-11.5.0
m68k                             allmodconfig    gcc-16.1.0
m68k                              allnoconfig    gcc-16.1.0
m68k                             allyesconfig    clang-23
m68k                             allyesconfig    gcc-16.1.0
m68k                                defconfig    clang-23
m68k                                defconfig    gcc-16.1.0
microblaze                        allnoconfig    gcc-16.1.0
microblaze                       allyesconfig    gcc-16.1.0
microblaze                          defconfig    clang-23
microblaze                          defconfig    gcc-16.1.0
mips                             allmodconfig    gcc-16.1.0
mips                              allnoconfig    gcc-16.1.0
mips                             allyesconfig    gcc-16.1.0
mips                            gpr_defconfig    clang-23
nios2                            allmodconfig    clang-20
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-23
nios2                               defconfig    gcc-11.5.0
nios2                          randconfig-001    gcc-11.5.0
nios2                 randconfig-001-20260701    gcc-11.5.0
nios2                          randconfig-002    gcc-11.5.0
nios2                 randconfig-002-20260701    gcc-11.5.0
nios2                 randconfig-002-20260701    gcc-8.5.0
openrisc                         allmodconfig    clang-20
openrisc                         allmodconfig    gcc-16.1.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-16.1.0
openrisc                            defconfig    gcc-16.1.0
parisc                           allmodconfig    gcc-16.1.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-16.1.0
parisc                           allyesconfig    clang-17
parisc                           allyesconfig    gcc-16.1.0
parisc                              defconfig    gcc-16.1.0
parisc                randconfig-001-20260701    clang-17
parisc                randconfig-001-20260701    gcc-13.4.0
parisc                randconfig-002-20260701    clang-17
parisc                randconfig-002-20260701    gcc-15.2.0
parisc64                            defconfig    clang-23
parisc64                            defconfig    gcc-16.1.0
powerpc                          allmodconfig    gcc-16.1.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-16.1.0
powerpc               randconfig-001-20260701    clang-17
powerpc               randconfig-001-20260701    gcc-8.5.0
powerpc               randconfig-002-20260701    clang-17
powerpc               randconfig-002-20260701    clang-23
powerpc64             randconfig-001-20260701    clang-17
powerpc64             randconfig-002-20260701    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-16.1.0
riscv                            allyesconfig    clang-23
riscv                               defconfig    gcc-16.1.0
riscv                 randconfig-001-20260701    clang-23
riscv                 randconfig-002-20260701    clang-23
s390                             allmodconfig    clang-17
s390                             allmodconfig    clang-23
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-16.1.0
s390                                defconfig    gcc-16.1.0
s390                  randconfig-001-20260701    clang-23
s390                  randconfig-002-20260701    clang-23
sh                               allmodconfig    gcc-16.1.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-16.1.0
sh                               allyesconfig    clang-17
sh                               allyesconfig    gcc-16.1.0
sh                                  defconfig    gcc-14
sh                    randconfig-001-20260701    clang-23
sh                    randconfig-002-20260701    clang-23
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-16.1.0
sparc                               defconfig    gcc-16.1.0
sparc                 randconfig-001-20260701    gcc-13.4.0
sparc                 randconfig-002-20260701    gcc-13.4.0
sparc64                          allmodconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260701    gcc-13.4.0
sparc64               randconfig-002-20260701    gcc-13.4.0
um                               allmodconfig    clang-17
um                                allnoconfig    clang-17
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-16.1.0
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260701    gcc-13.4.0
um                    randconfig-002-20260701    gcc-13.4.0
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-22
x86_64                            allnoconfig    clang-22
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-22
x86_64      buildonly-randconfig-001-20260701    clang-22
x86_64      buildonly-randconfig-001-20260701    gcc-14
x86_64      buildonly-randconfig-002-20260701    clang-22
x86_64      buildonly-randconfig-003-20260701    clang-22
x86_64      buildonly-randconfig-004-20260701    clang-22
x86_64      buildonly-randconfig-004-20260701    gcc-14
x86_64      buildonly-randconfig-005-20260701    clang-22
x86_64      buildonly-randconfig-006-20260701    clang-22
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-22
x86_64                randconfig-001-20260701    clang-22
x86_64                randconfig-001-20260701    gcc-14
x86_64                randconfig-002-20260701    gcc-14
x86_64                randconfig-003-20260701    gcc-14
x86_64                randconfig-004-20260701    clang-22
x86_64                randconfig-004-20260701    gcc-14
x86_64                randconfig-005-20260701    gcc-14
x86_64                randconfig-006-20260701    gcc-14
x86_64                randconfig-011-20260701    gcc-14
x86_64                randconfig-012-20260701    gcc-14
x86_64                randconfig-013-20260701    gcc-14
x86_64                randconfig-014-20260701    gcc-14
x86_64                randconfig-015-20260701    gcc-14
x86_64                randconfig-016-20260701    gcc-14
x86_64                randconfig-071-20260701    gcc-14
x86_64                randconfig-072-20260701    gcc-14
x86_64                randconfig-073-20260701    gcc-14
x86_64                randconfig-074-20260701    gcc-14
x86_64                randconfig-075-20260701    gcc-14
x86_64                randconfig-076-20260701    gcc-14
x86_64                               rhel-9.4    clang-22
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-22
x86_64                    rhel-9.4-kselftests    clang-22
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-22
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-16.1.0
xtensa                           allyesconfig    clang-20
xtensa                           allyesconfig    gcc-16.1.0
xtensa                randconfig-001-20260701    gcc-13.4.0
xtensa                randconfig-002-20260701    gcc-13.4.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

