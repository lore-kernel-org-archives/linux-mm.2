Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 030D4CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 05:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0513E6B0005; Wed, 27 May 2026 01:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0016B6B008A; Wed, 27 May 2026 01:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A056B008C; Wed, 27 May 2026 01:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D41426B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:17:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 897C01C03BD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:17:25 +0000 (UTC)
X-FDA: 84812041650.26.9DC0388
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id 953C34000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:17:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f8xFhcCn;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779859043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=fBMUX0RILwza41O0o4RuftACClNoNTgpHu3BBj0w4Ck=;
	b=4SBYMA3iFeYd/pJtabgBI4jYJhXgj1htlX3EO1Vlg0QQKU0JbJ/HKrXAZnjpO8I36xrT3l
	NZEMul6wHdT8WduvNG3TWawy3yyou6TRvVQ3JouHe3PWc6R5vXvIXC0az4YO8KWXBYyeKd
	OT+59rAdMfC5Kbyy5/zDoPOUAJ1QzTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779859043; a=rsa-sha256;
	cv=none;
	b=7aVhR465fcXBo+G8hNB9AqAH/TZlKKJsXVyVurkULyiXxTU3vsCVVaa7PSDoduRvISscQ7
	h7gmAf38f/qWCUaRzDV3DSAK3m0/8+PsMgDK/IIPHCrtFisdLltuXLDBWerziXcTyCagf7
	OH5NFQS8A6EmnBk7GiDygyX+sPmfWL4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f8xFhcCn;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779859042; x=1811395042;
  h=date:from:to:cc:subject:message-id;
  bh=sIUJVM/Tyo5UiOhBXkpeSg0qA95TSz00hm7dg81oVLQ=;
  b=f8xFhcCnXswjr6kIYYnHAYuPzppUhXd6osUBCMUi3L57adoT5Xi/Cb1g
   G0BmpfD9lykeT4pZNL3VY92Rtzih3gEt6iqouSaoFeoM00jdn+sm816uz
   D9C2/uvuw2lC4PWsXV477D463TFTn5te4slmXWyqJhpfry99uJUuue9uk
   LSVnGJpN07y01jnf1FyyqTUP2SoFsFBplzQPjnz0RZz0P7CbWOomuHDWU
   kEU0SqTKPnvGbNb8fJ0fbHebCbIBDbAhSMg2pQhV7MLg45KChYH9UvM49
   qJRSFmiCITeeb7vH3Yz6SH4v/N/3PiYDtozrNo1wj43xwE1T65FExMfdo
   A==;
X-CSE-ConnectionGUID: EMhpZGjBTviyBlG92++P7g==
X-CSE-MsgGUID: 4Lyjz3YzSb62b8t3+JFhnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80792641"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="80792641"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 22:17:21 -0700
X-CSE-ConnectionGUID: m5AdRqiiSUKWV4yruMaPgw==
X-CSE-MsgGUID: bYqPCZsCQcmj8U8VD4bNIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="246386595"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 26 May 2026 22:17:19 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wS6dn-000000003Qa-3eXx;
	Wed, 27 May 2026 05:17:15 +0000
Date: Wed, 27 May 2026 13:16:24 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 amd-gfx@lists.freedesktop.org, netdev@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 e7e28506af98ce4e1059e5ec59334b335c00a246
Message-ID: <202605271309.olwSbM8A-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 953C34000B
X-Stat-Signature: j9w167ijj1zq99y6tdeyya4ez5o97wun
X-Rspamd-Server: rspam06
X-HE-Tag: 1779859042-100117
X-HE-Meta: U2FsdGVkX18dVmyHQwP7vnzHKz6ixS/Ad3u0pt9WLg7tvfK6g5yvS7JvXBsmI7yCXzdpvRMxNxBz/5KZ7VqoSwL5cQ5iRlheDDZMh4zGCZwrGG9S34ASQnB9biND35TUjOfNqaF/10dbYQK5WRg3ODDb3LxEHeyOiLk+HY+Uz1X/iLO89FYDDDyeYdNNvoJK0nntvfmypYy+QSuXXM8KubyqBF7o8S9H7ONO4KzW62tdWek55R0Ugnwf5xRyZwAYb2imeQYU8MgE5F38pHhUKhdx0uR+LdmMNWE2EdUe+c3WfePDjeoOZEnpv5vWXvrTvpZEXmf2bn4wVrlYd3tTgzZKvszdXeMWhV7Sz83oswGfYnFx7H5qTAza+UQ792mav4vly5MtoqzFXe9gmp9A58PHMBTtbrse83DYHCXq6XYueGz1I8EM0pVzb4UE1nIZOCd+fymWYKi4zTlPXqi6stF8En2fO1FtV/U8FVPYRDMjn6kGUJzamBAmaN1PmUHZqKDUPUhD1oisXKlu6NdbUWyov9zpeUM7crGIl0jrevRK7sOpP6rbIa4vLLRQXuQg4mmGHoF4XN88hQyYke0a04ms1V4xE+a6m21aXOTNjDN4ySitdBLEuuA79lz9Jn7T7fhqjIlHUzmL6DxZ3dfv9wcypZgnhb+Dg1yxGJLxCeen8Nb3EHnxJ3DlWNVeUwTVfDvCaYzw6cICEa9bpxCmoz6UlQdhkxRuQ7Zs45NKIHi9qfrVan8ew5UMhwLhhGQmNc0uJw02M15xt3XK87GEnHIFogm2KVmLYUC9MHklTQyQZ4veqENFEwqeazIr9hxWhoejYQpifRSk0GwApKOE2x2uIqNucX8RBOO9QG5CtZWBnQ9m6HbJvKhHlAdWBtXXkiGUTJ70BzK6albR+yTaDa4BqeojslSMzV+gdjAAMPwcz34TOJ2A00Vp8GQFfNmdAjkJVTRfXaui7vuoAQ7
 xtmeuCzs
 iB4YjF+7fHQKfYsuofQtz8rkNScBVPJEyuc4214rcJOnqROursVZ5xedNeSMeTre+2gwax6c2xabbVScV3Zt4Qr6ErYrZ5/c0jHLjUaZvv/qFktR4KrEH+yNUSMjYaQuVPjf8/nF7bXb4XdOPsi8FQhoWBBVLSIhotlSJ5nA6HszWmwsOdqfKxdTJwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: e7e28506af98ce4e1059e5ec59334b335c00a246  Add linux-next specific files for 20260526

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202605270101.2FFpzoFg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605270411.oPtYP6rg-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202605271203.r58wncYu-lkp@intel.com

    Warning: sound/soc/codecs/max98090.c:2353 function parameter 'data' not described in 'max98090_set_jack'
    alpha-linux-ld: sound/soc/codecs/es9356.o:(.data.rel.ro+0xd0): undefined reference to `sdca_asoc_q78_get_volsw'
    alpha-linux-ld: sound/soc/codecs/es9356.o:(.data.rel.ro+0xd8): undefined reference to `sdca_asoc_q78_put_volsw'
    drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:2357:1: warning: control reaches end of non-void function [-Wreturn-type]
    ld: se_ctrl.c:(.text+0x34b): undefined reference to `mbox_free_channel'
    powerpc64-linux-ld: sound/soc/codecs/es9356.o:(.data.rel.ro+0xd0): undefined reference to `sdca_asoc_q78_get_volsw'
    powerpc64-linux-ld: sound/soc/codecs/es9356.o:(.data.rel.ro+0xd8): undefined reference to `sdca_asoc_q78_put_volsw'
    sparc-linux-ld: sound/soc/codecs/es9356.o:(.rodata+0x18a0): undefined reference to `sdca_asoc_q78_get_volsw'
    sparc-linux-ld: sound/soc/codecs/es9356.o:(.rodata+0x18a4): undefined reference to `sdca_asoc_q78_put_volsw'

Unverified Error/Warning (likely false positive, kindly check if interested):

    https://lore.kernel.org/oe-kbuild/202605271103.Ty43jmZr-lkp@intel.com

    drivers/android/binder.c:5306:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/auxdisplay/line-display.c:417:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/base/core.c:3306:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/block/aoe/aoedev.c:507:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/block/drbd/drbd_main.c:2798:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/block/nbd.c:1541:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/block/rbd.c:6678:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/dpll/zl3073x/fw.c:274:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/gpu/drm/drm_gem_atomic_helper.c:176:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/gpu/drm/drm_prime.c:806:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/gpu/drm/tests/drm_gem_shmem_test.c:126:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/media/i2c/cs3308.c:97:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/mmc/host/ushc.c:528:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/most/configfs.c:618:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/rpmsg/qcom_glink_native.c:1014:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/scsi/sd.c:3893:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/tty/serial/max3100.c:742:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    drivers/usb/gadget/legacy/inode.c:1637:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    fs/squashfs/decompressor_multi.c:179:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    fs/squashfs/file.c:749:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    fs/ubifs/super.c:261:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    kernel/bpf/verifier.c:1629:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    kernel/trace/trace_events_user.c:863:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    lib/kunit/static_stub.c:122:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    net/ceph/osdmap.c:406:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
    net/kcm/kcmsock.c:945 kcm_sendmsg() error: we previously assumed 'head' could be null (see line 787)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   |-- alpha-linux-ld:sound-soc-codecs-es9356.o:(.data.rel.ro):undefined-reference-to-sdca_asoc_q78_get_volsw
|   `-- alpha-linux-ld:sound-soc-codecs-es9356.o:(.data.rel.ro):undefined-reference-to-sdca_asoc_q78_put_volsw
|-- csky-randconfig-001-20260527
|   |-- drivers-android-binder.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-auxdisplay-line-display.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-base-core.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-block-aoe-aoedev.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-block-drbd-drbd_main.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-block-nbd.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-block-rbd.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-dpll-zl3073x-fw.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-gpu-drm-drm_gem_atomic_helper.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-gpu-drm-drm_prime.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-gpu-drm-tests-drm_gem_shmem_test.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-media-i2c-cs3308.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-mmc-host-ushc.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-most-configfs.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-rpmsg-qcom_glink_native.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-scsi-sd.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-tty-serial-max3100.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- drivers-usb-gadget-legacy-inode.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- fs-squashfs-decompressor_multi.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- fs-squashfs-file.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- fs-ubifs-super.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- kernel-bpf-verifier.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- kernel-trace-trace_events_user.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   |-- lib-kunit-static_stub.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|   `-- net-ceph-osdmap.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
|-- i386-buildonly-randconfig-006-20260526
|   `-- ld:se_ctrl.c:(.text):undefined-reference-to-mbox_free_channel
|-- nios2-allmodconfig
|   `-- Warning:sound-soc-codecs-max98090.c-function-parameter-data-not-described-in-max98090_set_jack
|-- powerpc64-randconfig-r063-20260526
|   |-- powerpc64-linux-ld:sound-soc-codecs-es9356.o:(.data.rel.ro):undefined-reference-to-sdca_asoc_q78_get_volsw
|   `-- powerpc64-linux-ld:sound-soc-codecs-es9356.o:(.data.rel.ro):undefined-reference-to-sdca_asoc_q78_put_volsw
|-- s390-randconfig-r073-20260526
|   `-- net-kcm-kcmsock.c-kcm_sendmsg()-error:we-previously-assumed-head-could-be-null-(see-line-)
|-- sparc-randconfig-002-20260527
|   |-- sparc-linux-ld:sound-soc-codecs-es9356.o:(.rodata):undefined-reference-to-sdca_asoc_q78_get_volsw
|   `-- sparc-linux-ld:sound-soc-codecs-es9356.o:(.rodata):undefined-reference-to-sdca_asoc_q78_put_volsw
`-- um-allyesconfig
    `-- drivers-gpu-drm-amd-amdgpu-..-amdkfd-kfd_topology.c:warning:control-reaches-end-of-non-void-function

elapsed time: 772m

configs tested: 207
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                   randconfig-001-20260527    gcc-9.5.0
arc                   randconfig-002-20260527    gcc-15.2.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                   randconfig-001-20260527    clang-23
arm                   randconfig-002-20260527    clang-23
arm                   randconfig-003-20260527    gcc-10.5.0
arm                   randconfig-004-20260527    gcc-11.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260527    gcc-8.5.0
arm64                 randconfig-002-20260527    gcc-8.5.0
arm64                 randconfig-003-20260527    clang-23
arm64                 randconfig-004-20260527    gcc-9.5.0
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260527    gcc-15.2.0
csky                  randconfig-002-20260527    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260527    clang-23
hexagon               randconfig-002-20260527    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260527    clang-20
i386        buildonly-randconfig-002-20260527    clang-20
i386        buildonly-randconfig-002-20260527    gcc-14
i386        buildonly-randconfig-003-20260527    clang-20
i386        buildonly-randconfig-004-20260527    clang-20
i386        buildonly-randconfig-004-20260527    gcc-14
i386        buildonly-randconfig-005-20260527    clang-20
i386        buildonly-randconfig-005-20260527    gcc-14
i386        buildonly-randconfig-006-20260527    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260527    clang-20
i386                  randconfig-002-20260527    gcc-14
i386                  randconfig-003-20260527    gcc-14
i386                  randconfig-004-20260527    clang-20
i386                  randconfig-005-20260527    clang-20
i386                  randconfig-006-20260527    gcc-12
i386                  randconfig-007-20260527    clang-20
i386                  randconfig-011-20260527    gcc-14
i386                  randconfig-012-20260527    clang-20
i386                  randconfig-013-20260527    clang-20
i386                  randconfig-014-20260527    clang-20
i386                  randconfig-015-20260527    clang-20
i386                  randconfig-016-20260527    gcc-14
i386                  randconfig-017-20260527    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260527    clang-19
loongarch             randconfig-002-20260527    gcc-13.4.0
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
microblaze                        allnoconfig    gcc-15.2.0
microblaze                       allyesconfig    gcc-15.2.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.2.0
mips                             allmodconfig    gcc-15.2.0
mips                              allnoconfig    gcc-15.2.0
mips                             allyesconfig    gcc-15.2.0
mips                     cu1830-neo_defconfig    gcc-15.2.0
nios2                            allmodconfig    clang-23
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-23
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20260527    gcc-11.5.0
nios2                 randconfig-002-20260527    gcc-10.5.0
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260527    gcc-8.5.0
parisc                randconfig-002-20260527    gcc-8.5.0
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc               randconfig-001-20260527    gcc-8.5.0
powerpc               randconfig-002-20260527    clang-18
powerpc64             randconfig-001-20260527    gcc-8.5.0
powerpc64             randconfig-002-20260527    clang-20
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260527    gcc-9.5.0
riscv                 randconfig-002-20260527    gcc-15.2.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260527    gcc-12.5.0
s390                  randconfig-002-20260527    gcc-11.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-15.2.0
sh                    randconfig-001-20260527    gcc-14.3.0
sh                    randconfig-002-20260527    gcc-11.5.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260527    gcc-14.3.0
sparc                 randconfig-002-20260527    gcc-14.3.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20260527    clang-20
sparc64               randconfig-002-20260527    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260527    gcc-14
um                    randconfig-002-20260527    gcc-14
um                           x86_64_defconfig    clang-23
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64               buildonly-randconfig-001    gcc-14
x86_64      buildonly-randconfig-001-20260527    clang-20
x86_64      buildonly-randconfig-001-20260527    gcc-14
x86_64               buildonly-randconfig-002    gcc-14
x86_64      buildonly-randconfig-002-20260527    gcc-14
x86_64               buildonly-randconfig-003    gcc-14
x86_64      buildonly-randconfig-003-20260527    gcc-14
x86_64               buildonly-randconfig-004    gcc-14
x86_64      buildonly-randconfig-004-20260527    gcc-14
x86_64               buildonly-randconfig-005    gcc-14
x86_64      buildonly-randconfig-005-20260527    gcc-14
x86_64               buildonly-randconfig-006    gcc-14
x86_64      buildonly-randconfig-006-20260527    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260527    gcc-14
x86_64                randconfig-002-20260527    clang-20
x86_64                randconfig-003-20260527    clang-20
x86_64                randconfig-004-20260527    clang-20
x86_64                randconfig-005-20260527    clang-20
x86_64                randconfig-006-20260527    gcc-14
x86_64                randconfig-011-20260527    gcc-14
x86_64                randconfig-012-20260527    gcc-14
x86_64                randconfig-013-20260527    gcc-14
x86_64                randconfig-014-20260527    clang-20
x86_64                randconfig-015-20260527    gcc-14
x86_64                randconfig-016-20260527    clang-20
x86_64                randconfig-071-20260527    gcc-14
x86_64                randconfig-072-20260527    clang-20
x86_64                randconfig-073-20260527    clang-20
x86_64                randconfig-074-20260527    gcc-14
x86_64                randconfig-075-20260527    clang-20
x86_64                randconfig-076-20260527    clang-20
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                randconfig-001-20260527    gcc-8.5.0
xtensa                randconfig-002-20260527    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

