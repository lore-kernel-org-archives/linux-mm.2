Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9AC2CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 04:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005D96B0010; Mon,  1 Dec 2025 23:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF87F6B0011; Mon,  1 Dec 2025 23:54:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC02E6B0012; Mon,  1 Dec 2025 23:54:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C11986B0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:54:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A0711404E5
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:54:02 +0000 (UTC)
X-FDA: 84173313924.04.F152F6E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8DEAF40003
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:53:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gfi5KxSM;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764651240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=jaUlUBqye8vcNhTYd4F8x2LIL6l4Bwnsebq13tyfqPs=;
	b=IpS1ng6XaLXYyRSBqaqWpOTLxSaLqjhkd/LA2cQ8fSH4VcNa/HWH5lCzKZwlhAzjUHl1vj
	KCZa/aVZnRUYSZP8PCFQrC1sfYGKsDq5CnwKCOW8XGQcTffG5PwgyuZ/mkpbZD+u9SHClZ
	6nh4WxXL2jTaZ0sr/kif02E11FTY5AY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764651240; a=rsa-sha256;
	cv=none;
	b=daOHKYuL+J657z6ZO1s9v5B178eXk+WvfVlo1EUUTYtAB18DI2F16o78Wf8DhCWTGDTLDF
	icxjuL3b0UdErjpJKEfWRyTfJSqdhyKonfzIU/QHH74JryaXHmMy/C+pabdOh90Y19QuXX
	hRNguoB27OpWuT64xdWaJgwKvcQR5MM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gfi5KxSM;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764651240; x=1796187240;
  h=date:from:to:cc:subject:message-id;
  bh=4qkIRR/G1i5s2BeXlE1FEl4TXy/hcfV9UQIMR+7Mo7g=;
  b=Gfi5KxSMpul1dGTOkpquvlR2iQikUzpJ+HtBb7IbaEtUdF8QHH5i3hj1
   KtIp/LEm9C/n3LNfVZG0lvY1nY3uDs/yRGAeMpf5ShKgOII2crfWmEiiq
   N41VDab/GzPTWoRCzdbFdlIZj+5B7Zjcvd8JORJ3u4Ol32Uh5ESnFEy9y
   GUXQcVr+i/F257+Xp3tT4A/XUoMt/jqO2VwkENG+PzxeSokpXXnSdcTSf
   pB+QvdMBf/JUu9ctTNQz+JNi8tc8ysrqrVJtTzvvWYbKz3XgnsBmr3f4s
   j5QvkCj8rs6LZZV39LsdEVIAfKpYtShlfq+DMS//WaW0zqnRrTIaMO+U7
   A==;
X-CSE-ConnectionGUID: 8AgguEi9RxeerLHvy8ZYWg==
X-CSE-MsgGUID: 7Ay8l58nQvu6/IZPJN3hZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="69199391"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="69199391"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 20:53:58 -0800
X-CSE-ConnectionGUID: 1RL4srg0ST28v7d5f2HHqA==
X-CSE-MsgGUID: ydLptWpTS++0XKayyOo+2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="225236146"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 01 Dec 2025 20:53:56 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQIOg-000000009Q5-0d6I;
	Tue, 02 Dec 2025 04:53:54 +0000
Date: Tue, 02 Dec 2025 12:53:44 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 95cb2fd6ce0ad61af54191fe5ef271d7177f9c3a
Message-ID: <202512021247.OeK8hpLz-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DEAF40003
X-Stat-Signature: d7486njmzbt4tsdu9dbiizjhsy6hjxfk
X-Rspam-User: 
X-HE-Tag: 1764651239-935842
X-HE-Meta: U2FsdGVkX1+ZWcy1eXJv0qtzFxueTQ8YDi5gQSHwzzBKNaJuQSLs/9Hm+TCeAZd1mrErGsyHFYu+JeV5Gpmenk7cnp1XKs/ZLZOMRxErmC8qfLO66V5uKbAm1TXrZgbSixdPt+q4iT9TkYehC07r5korlpQHtSmGu5ETDjFLYbyuP0yGSh+CgMi8hemtKMlzKTBTo18dMwLL1QOeOB5O+p7f3IB/ZLiHK0z2NxyAOVXP7zRETpvDIFTBx9qOsAukMgS5x1iXjPOmQ4owz5bgctOz//ouCd4zhfm6x+SUrHHWfgJDIwDY/6vLrE0XhFDr17ptt4d7gsCs18qYKMQyFT3U8TuGTJo4QjlZPSJtgp8sJ7dfzBPpAtEIV+aoSnEjNIb1D/AZWIUn3Oe2lTm6PPWNvSA48/eU3mpD4f8sKYupXSg2yYHMcRu1TCQLDLjforsUQvTygvQOswpfCxabYv5TD8TYLO+iGAG9kQm9WBAz+Ybw1gc33IpAPRx5tOEhkt8CzcbaNutgRzflQUsX8IUzkvTm5K9e/hlY5kpxaTzdhcWTABf8LDJRgYK7KoENiThyrYd57yQQhqY6DHf9ws0ABmojrjZY4f/mGe82yDW1rz2NiDrlHIJPCSTiDEi1njP2ORFYguH43W0Nd7WqQaDJAjN4iluWnv6ml27Cx3hNvXiFLdArRC2kJM/YdiygfUnorXUXfnmR+GnaB9ui7ZVo8dSEVXIwG3Errwii7XZy02HOMrTnpnDnn1FqW7qmPwyv4nDyqxANuAxkrVnAekovF9Tyi5iFVpayX8gWh3fKVOGpH+OlwwkVkT2yqFAGhhzCCbrlGZKHv1Qwxjpb8chbMgXCwn60ruBm9J6/Ibfij2YyfBodIlCJEprDPwLw5TSeVETfR0YuYQz0RLBit8HgQ/tccBzIafsRRtxQ12gcbuqGnPqrIeGXBTgZvbCX04a82qAW1qFgfr1ieky
 GPnW13Ic
 rlGEu3keey9tJrKBh6DFcBrZfIPFSb5POLUEhxp22YEC6u/EFX1lEHEXP+3Wun3W8NVn70IuCcXLmOfY3AJb8Zx8U6P9+smPJgBj6Y20WjpwdAqWtCynTSn8qdcyTpg4f6ohjt6oInMYyqKKf6PV25w8aB1bu6nqY673HseqrNM4EDtVH/ci2nhb+xA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 95cb2fd6ce0ad61af54191fe5ef271d7177f9c3a  Add linux-next specific files for 20251201

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202512011732.RHIyTQHZ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512011905.z4ACJpAS-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512012040.BkoYgkkr-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512012238.YgVvRRUx-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512020154.xVlxrCXE-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512020454.Tf36WHw5-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512020510.Fsn6vGmt-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512020708.C7Q0UXB2-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512020925.2CUjcAsA-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202512020957.PqnHfe7C-lkp@intel.com

    ERROR: modpost: "devm_backlight_device_register" [drivers/gpu/drm/panel/panel-visionox-rm69299.ko] undefined!
    Warning: drivers/crypto/ccp/sev-dev-tio.c:188 struct member 'reserved' not described in 'sev_data_tio_status'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:213 struct member 'reserved1' not described in 'sev_data_tio_dev_create'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:213 struct member 'reserved2' not described in 'sev_data_tio_dev_create'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:239 struct member 'reserved1' not described in 'sev_data_tio_dev_connect'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:239 struct member 'reserved2' not described in 'sev_data_tio_dev_connect'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:239 struct member 'reserved3' not described in 'sev_data_tio_dev_connect'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:239 struct member 'reserved4' not described in 'sev_data_tio_dev_connect'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:249 #define TIO_DEV_DISCONNECT_FLAG_FORCE   BIT(0); error: Cannot parse struct or union!
    Warning: drivers/crypto/ccp/sev-dev-tio.c:267 #define TIO_DEV_MEAS_FLAG_RAW_BITSTREAM BIT(0); error: Cannot parse struct or union!
    Warning: drivers/crypto/ccp/sev-dev-tio.c:289 struct member 'reserved' not described in 'sev_data_tio_dev_certs'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:303 struct member 'reserved' not described in 'sev_data_tio_dev_reclaim'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:80 struct member 'reserved1' not described in 'sla_buffer_hdr'
    Warning: drivers/crypto/ccp/sev-dev-tio.c:80 struct member 'reserved2' not described in 'sla_buffer_hdr'
    alpha-linux-ld: include/linux/pinctrl/pinconf-generic.h:235: undefined reference to `pinconf_generic_dt_node_to_map'
    arch/x86/hyperv/hv_crash.c:631:9: error: 'smp_ops' undeclared (first use in this function)
    error[E0425]: cannot find function `pci_alloc_irq_vectors` in crate `bindings`
    error[E0425]: cannot find function `pci_free_irq_vectors` in crate `bindings`
    error[E0609]: no field `__bindgen_anon_1` on type `bindings::kernel_param`
    error[E0609]: no field `addr` on type `i2c_board_info`
    error[E0609]: no field `atomic` on type `pwm_chip`
    error[E0609]: no field `dev` on type `i2c_client`
    error[E0609]: no field `dev` on type `pwm_chip`
    error[E0609]: no field `driver` on type `i2c_driver`
    error[E0609]: no field `id_table` on type `i2c_driver`
    error[E0609]: no field `npwm` on type `pwm_chip`
    error[E0609]: no field `nr` on type `i2c_adapter`
    error[E0609]: no field `ops` on type `pwm_chip`
    error[E0609]: no field `p` on type `bindings::device`
    error[E0609]: no field `probe` on type `i2c_driver`
    error[E0609]: no field `remove` on type `i2c_driver`
    error[E0609]: no field `shutdown` on type `i2c_driver`
    error[E0609]: no field `type_` on type `i2c_board_info`
    include/linux/compiler_types.h:602:45: error: call to '__compiletime_assert_293' declared with attribute error: min(burstcnt, len - count - 1) signedness error
    include/linux/compiler_types.h:617:38: error: call to '__compiletime_assert_378' declared with attribute error: min(burstcnt, len - count - 1) signedness error
    include/linux/pinctrl/pinconf-generic.h:235: undefined reference to `pinconf_generic_dt_node_to_map'
    include/linux/pinctrl/pinconf-generic.h:235:(.text+0xd6): undefined reference to `pinconf_generic_dt_node_to_map'
    ld.lld: error: undefined symbol: pinconf_generic_dt_node_to_map
    panel-visionox-rm69299.c:(.text+0x48c): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `devm_backlight_device_register'
    pinctrl-mpfs-iomux0.c:(.text+0x77): undefined reference to `pinconf_generic_dt_node_to_map'
    pinctrl-pic64gx-gpio2.c:(.text+0x77): undefined reference to `pinconf_generic_dt_node_to_map'

Unverified Error/Warning (likely false positive, kindly check if interested):

    Warning: arch/arm/mach-omap2/cpuidle44xx.c:75 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    Warning: arch/powerpc/platforms/pseries/lpar.c:1080 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    Warning: drivers/char/xilinx_hwicap/fifo_icap.c:51 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    Warning: drivers/cpufreq/longrun.c:20 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    Warning: drivers/infiniband/hw/mlx5/umr.c:986 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    Warning: ipc/sem.c:629 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    Warning: sound/usb/usx2y/us144mkii.c:15 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    Warning: sound/usb/usx2y/us144mkii_controls.c:8 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    drivers/gpib/eastwood/fluke_gpib.c:1002:21: error: incompatible integer to pointer conversion assigning to 'void *' from 'int' [-Wint-conversion]
    drivers/gpib/eastwood/fluke_gpib.c:1002:23: error: call to undeclared function 'ioremap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    error[E0425]: cannot find value `compat_ptr_ioctl` in crate `bindings`
    error[E0609]: no field `dev` on type `usb_device`
    error[E0609]: no field `disconnect` on type `usb_driver`
    error[E0609]: no field `id_table` on type `usb_driver`
    error[E0609]: no field `name` on type `usb_driver`
    error[E0609]: no field `probe` on type `usb_driver`
    kernel/nstree.c:727:1: internal compiler error: in change_address_1, at emit-rtl.cc:2299
    {standard input}:601: Error: pcrel too far

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- alpha-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- alpha-randconfig-r072-20251201
|   `-- alpha-linux-ld:include-linux-pinctrl-pinconf-generic.h:undefined-reference-to-pinconf_generic_dt_node_to_map
|-- alpha-randconfig-r111-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-allmodconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-allyesconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-nsimosci_hs_smp_defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-001-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-001-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-002-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-002-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-r062-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-allyesconfig
|   |-- Warning:arch-arm-mach-omap2-cpuidle44xx.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-defconfig
|   |-- Warning:arch-arm-mach-omap2-cpuidle44xx.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-randconfig-001-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-randconfig-002-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-randconfig-002-20251202
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-randconfig-003-20251201
|   `-- Warning:arch-arm-mach-omap2-cpuidle44xx.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-randconfig-004-20251202
|   |-- Warning:arch-arm-mach-omap2-cpuidle44xx.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-randconfig-r061-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm-randconfig-r072-20251202
|   `-- ERROR:devm_backlight_device_register-drivers-gpu-drm-panel-panel-visionox-rm69299.ko-undefined
|-- arm64-allmodconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm64-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm64-randconfig-001-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- arm64-randconfig-001-20251202
|   |-- error-E0609:no-field-__bindgen_anon_1-on-type-bindings::kernel_param
|   |-- error-E0609:no-field-addr-on-type-i2c_board_info
|   |-- error-E0609:no-field-dev-on-type-i2c_client
|   |-- error-E0609:no-field-dev-on-type-usb_device
|   |-- error-E0609:no-field-disconnect-on-type-usb_driver
|   |-- error-E0609:no-field-driver-on-type-i2c_driver
|   |-- error-E0609:no-field-id_table-on-type-i2c_driver
|   |-- error-E0609:no-field-id_table-on-type-usb_driver
|   |-- error-E0609:no-field-name-on-type-usb_driver
|   |-- error-E0609:no-field-nr-on-type-i2c_adapter
|   |-- error-E0609:no-field-p-on-type-bindings::device
|   |-- error-E0609:no-field-probe-on-type-i2c_driver
|   |-- error-E0609:no-field-probe-on-type-usb_driver
|   |-- error-E0609:no-field-remove-on-type-i2c_driver
|   |-- error-E0609:no-field-shutdown-on-type-i2c_driver
|   `-- error-E0609:no-field-type_-on-type-i2c_board_info
|-- arm64-randconfig-003-20251201
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- error-E0425:cannot-find-value-compat_ptr_ioctl-in-crate-bindings
|-- arm64-randconfig-004-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- csky-allmodconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- csky-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- csky-randconfig-001-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- hexagon-allmodconfig
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- hexagon-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- hexagon-randconfig-r072-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-allmodconfig
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-allyesconfig
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-buildonly-randconfig-001-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-buildonly-randconfig-001-20251202
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-buildonly-randconfig-002-20251201
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-buildonly-randconfig-002-20251202
|   `-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-buildonly-randconfig-004-20251201
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- ld.lld:error:undefined-symbol:pinconf_generic_dt_node_to_map
|-- i386-buildonly-randconfig-004-20251202
|   `-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-buildonly-randconfig-006-20251201
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-buildonly-randconfig-006-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-001-20251202
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-002-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-003-20251201
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-003-20251202
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-004-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-004-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-005-20251201
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-005-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-014-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-015-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-017-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-051-20251201
|   `-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-051-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-052-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-052-20251202
|   `-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-054-20251201
|   `-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-141-20251201
|   |-- Warning:drivers-cpufreq-longrun.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- loongarch-allmodconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- loongarch-allyesconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- loongarch-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- m68k-allmodconfig
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- m68k-allyesconfig
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- m68k-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- m68k-randconfig-r063-20251201
|   `-- include-linux-pinctrl-pinconf-generic.h:undefined-reference-to-pinconf_generic_dt_node_to_map
|-- microblaze-allyesconfig
|   |-- Warning:drivers-char-xilinx_hwicap-fifo_icap.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- microblaze-defconfig
|   |-- Warning:drivers-char-xilinx_hwicap-fifo_icap.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- mips-allmodconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- mips-allyesconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- nios2-allmodconfig
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- nios2-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- openrisc-allmodconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- openrisc-randconfig-r052-20251201
|   `-- panel-visionox-rm69299.c:(.text):relocation-truncated-to-fit:R_OR1K_INSN_REL_26-against-undefined-symbol-devm_backlight_device_register
|-- openrisc-randconfig-r063-20251202
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- openrisc-randconfig-r073-20251201
|   `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(burstcnt-len-count-)-signedness-error
|-- parisc-allmodconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- parisc-allyesconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- parisc-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- parisc-generic-32bit_defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- parisc-randconfig-001-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- parisc-randconfig-002-20251202
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- parisc64-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-allmodconfig
|   |-- Warning:arch-powerpc-platforms-pseries-lpar.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-motionpro_defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-mpc8315_rdb_defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-randconfig-002-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- powerpc64-randconfig-001-20251201
|   `-- Warning:arch-powerpc-platforms-pseries-lpar.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- powerpc64-randconfig-002-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- powerpc64-randconfig-r063-20251201
|   `-- Warning:arch-powerpc-platforms-pseries-lpar.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- powerpc64-randconfig-r064-20251202
|   `-- Warning:arch-powerpc-platforms-pseries-lpar.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- riscv-allmodconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- riscv-allyesconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- riscv-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- riscv-randconfig-002-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- s390-defconfig
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- s390-randconfig-001-20251201
|   |-- drivers-gpib-eastwood-fluke_gpib.c:error:call-to-undeclared-function-ioremap-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-gpib-eastwood-fluke_gpib.c:error:incompatible-integer-to-pointer-conversion-assigning-to-void-from-int
|-- s390-randconfig-001-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- s390-randconfig-002-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sh-allmodconfig
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-nstree.c:internal-compiler-error:in-change_address_1-at-emit-rtl.cc
|-- sh-allnoconfig
|   |-- kernel-nstree.c:internal-compiler-error:in-change_address_1-at-emit-rtl.cc
|   `-- standard-input:Error:pcrel-too-far
|-- sh-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sh-randconfig-001-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sh-randconfig-002-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sparc-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sparc-randconfig-001-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sparc-randconfig-002-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sparc-randconfig-r064-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sparc64-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sparc64-randconfig-001-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sparc64-randconfig-002-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- sparc64-randconfig-002-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- um-allmodconfig
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- um-allyesconfig
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- um-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- um-i386_defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- um-randconfig-001-20251201
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- pinctrl-mpfs-iomux0.c:(.text):undefined-reference-to-pinconf_generic_dt_node_to_map
|   `-- pinctrl-pic64gx-gpio2.c:(.text):undefined-reference-to-pinconf_generic_dt_node_to_map
|-- um-randconfig-002-20251202
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- um-randconfig-r053-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- um-randconfig-r054-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- um-randconfig-r121-20251201
|   `-- include-linux-pinctrl-pinconf-generic.h:(.text):undefined-reference-to-pinconf_generic_dt_node_to_map
|-- um-randconfig-r133-20251202
|   |-- error-E0609:no-field-atomic-on-type-pwm_chip
|   |-- error-E0609:no-field-dev-on-type-pwm_chip
|   |-- error-E0609:no-field-npwm-on-type-pwm_chip
|   `-- error-E0609:no-field-ops-on-type-pwm_chip
|-- um-x86_64_defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-allmodconfig
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_DISCONNECT_FLAG_FORCE-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_MEAS_FLAG_RAW_BITSTREAM-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_certs
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_reclaim
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_status
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved3-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved4-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-allyesconfig
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_DISCONNECT_FLAG_FORCE-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_MEAS_FLAG_RAW_BITSTREAM-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_certs
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_reclaim
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_status
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved3-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved4-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-buildonly-randconfig-001-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-buildonly-randconfig-003-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-buildonly-randconfig-004-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-buildonly-randconfig-005-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-buildonly-randconfig-005-20251202
|   `-- arch-x86-hyperv-hv_crash.c:error:smp_ops-undeclared-(first-use-in-this-function)
|-- x86_64-defconfig
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-kexec
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-006-20251201
|   |-- error-E0425:cannot-find-function-pci_alloc_irq_vectors-in-crate-bindings
|   `-- error-E0425:cannot-find-function-pci_free_irq_vectors-in-crate-bindings
|-- x86_64-randconfig-011-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-012-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-013-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-014-20251202
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-015-20251201
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-072-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-074-20251201
|   |-- Warning:sound-usb-usx2y-us144mkii.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:sound-usb-usx2y-us144mkii_controls.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-075-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-076-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-102-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-161-20251201
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-9.4
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_DISCONNECT_FLAG_FORCE-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_MEAS_FLAG_RAW_BITSTREAM-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_certs
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_reclaim
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_status
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved3-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved4-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-9.4-bpf
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_DISCONNECT_FLAG_FORCE-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_MEAS_FLAG_RAW_BITSTREAM-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_certs
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_reclaim
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_status
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved3-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved4-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-9.4-func
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_DISCONNECT_FLAG_FORCE-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_MEAS_FLAG_RAW_BITSTREAM-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_certs
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_reclaim
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_status
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved3-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved4-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-9.4-kselftests
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_DISCONNECT_FLAG_FORCE-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_MEAS_FLAG_RAW_BITSTREAM-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_certs
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_reclaim
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_status
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved3-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved4-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-9.4-kunit
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_DISCONNECT_FLAG_FORCE-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_MEAS_FLAG_RAW_BITSTREAM-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_certs
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_reclaim
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_status
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved3-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved4-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-9.4-ltp
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_DISCONNECT_FLAG_FORCE-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-define-TIO_DEV_MEAS_FLAG_RAW_BITSTREAM-BIT()-error:Cannot-parse-struct-or-union
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_certs
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_dev_reclaim
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved-not-described-in-sev_data_tio_status
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved1-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sev_data_tio_dev_create
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved2-not-described-in-sla_buffer_hdr
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved3-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-crypto-ccp-sev-dev-tio.c-struct-member-reserved4-not-described-in-sev_data_tio_dev_connect
|   |-- Warning:drivers-infiniband-hw-mlx5-umr.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
|   `-- Warning:ipc-sem.c-This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-to-Documentation-doc-guide-kernel-doc.rst
`-- xtensa-randconfig-r123-20251201
    `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:min(burstcnt-len-count-)-signedness-error

elapsed time: 1454m

configs tested: 274
configs skipped: 3

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    clang-19
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    clang-19
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    clang-19
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                 nsimosci_hs_smp_defconfig    gcc-15.1.0
arc                   randconfig-001-20251201    clang-20
arc                   randconfig-001-20251201    gcc-13.4.0
arc                   randconfig-001-20251202    clang-22
arc                   randconfig-002-20251201    clang-20
arc                   randconfig-002-20251201    gcc-13.4.0
arc                   randconfig-002-20251202    clang-22
arm                               allnoconfig    clang-22
arm                               allnoconfig    gcc-15.1.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                                 defconfig    gcc-15.1.0
arm                         lpc18xx_defconfig    clang-22
arm                         lpc18xx_defconfig    gcc-15.1.0
arm                   randconfig-001-20251201    clang-20
arm                   randconfig-001-20251201    clang-22
arm                   randconfig-001-20251202    clang-22
arm                   randconfig-002-20251201    clang-20
arm                   randconfig-002-20251201    gcc-8.5.0
arm                   randconfig-002-20251202    clang-22
arm                   randconfig-003-20251201    clang-20
arm                   randconfig-003-20251202    clang-22
arm                   randconfig-004-20251201    clang-20
arm                   randconfig-004-20251201    gcc-15.1.0
arm                   randconfig-004-20251202    clang-22
arm                           sama7_defconfig    clang-22
arm64                            allmodconfig    clang-16
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20251201    clang-22
arm64                 randconfig-001-20251201    gcc-8.5.0
arm64                 randconfig-002-20251201    clang-22
arm64                 randconfig-003-20251201    clang-18
arm64                 randconfig-003-20251201    clang-22
arm64                 randconfig-004-20251201    clang-22
arm64                 randconfig-004-20251201    gcc-14.3.0
csky                             allmodconfig    gcc-15.1.0
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20251201    clang-22
csky                  randconfig-001-20251201    gcc-15.1.0
csky                  randconfig-002-20251201    clang-22
csky                  randconfig-002-20251201    gcc-14.3.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    clang-19
hexagon                           allnoconfig    clang-22
hexagon                           allnoconfig    gcc-15.1.0
hexagon                             defconfig    clang-22
hexagon                             defconfig    gcc-15.1.0
hexagon               randconfig-001-20251201    clang-22
hexagon               randconfig-002-20251201    clang-22
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.1.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20251201    clang-20
i386        buildonly-randconfig-001-20251202    clang-20
i386        buildonly-randconfig-002-20251201    clang-20
i386        buildonly-randconfig-002-20251202    clang-20
i386        buildonly-randconfig-003-20251201    clang-20
i386        buildonly-randconfig-003-20251202    clang-20
i386        buildonly-randconfig-004-20251201    clang-20
i386        buildonly-randconfig-004-20251202    clang-20
i386        buildonly-randconfig-005-20251201    clang-20
i386        buildonly-randconfig-005-20251202    clang-20
i386        buildonly-randconfig-006-20251201    clang-20
i386        buildonly-randconfig-006-20251201    gcc-14
i386        buildonly-randconfig-006-20251202    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.1.0
i386                  randconfig-001-20251201    clang-20
i386                  randconfig-001-20251201    gcc-14
i386                  randconfig-002-20251201    clang-20
i386                  randconfig-003-20251201    clang-20
i386                  randconfig-004-20251201    clang-20
i386                  randconfig-005-20251201    clang-20
i386                  randconfig-005-20251201    gcc-14
i386                  randconfig-006-20251201    clang-20
i386                  randconfig-006-20251201    gcc-14
i386                  randconfig-007-20251201    clang-20
i386                  randconfig-011-20251201    clang-20
i386                  randconfig-012-20251201    gcc-14
i386                  randconfig-013-20251201    clang-20
i386                  randconfig-014-20251201    gcc-14
i386                  randconfig-015-20251201    gcc-14
i386                  randconfig-016-20251201    gcc-14
i386                  randconfig-017-20251201    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                         allnoconfig    gcc-15.1.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20251201    gcc-15.1.0
loongarch             randconfig-002-20251201    clang-18
m68k                             allmodconfig    clang-19
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    clang-19
m68k                             allyesconfig    gcc-15.1.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    clang-19
microblaze                          defconfig    gcc-15.1.0
mips                             allmodconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
mips                             allyesconfig    gcc-15.1.0
nios2                            allmodconfig    gcc-11.5.0
nios2                             allnoconfig    clang-22
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    clang-19
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20251201    gcc-8.5.0
nios2                 randconfig-002-20251201    gcc-8.5.0
openrisc                         allmodconfig    gcc-15.1.0
openrisc                          allnoconfig    clang-22
openrisc                          allnoconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
openrisc                    or1ksim_defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    clang-22
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                generic-32bit_defconfig    gcc-15.1.0
parisc                randconfig-001-20251201    gcc-13.4.0
parisc                randconfig-001-20251202    clang-22
parisc                randconfig-002-20251201    gcc-15.1.0
parisc                randconfig-002-20251202    clang-22
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.1.0
powerpc                          allmodconfig    gcc-15.1.0
powerpc                           allnoconfig    clang-22
powerpc                           allnoconfig    gcc-15.1.0
powerpc                    gamecube_defconfig    clang-22
powerpc                      mgcoge_defconfig    clang-22
powerpc                   motionpro_defconfig    gcc-15.1.0
powerpc                 mpc8315_rdb_defconfig    gcc-15.1.0
powerpc                 mpc836x_rdk_defconfig    clang-22
powerpc               randconfig-001-20251201    gcc-13.4.0
powerpc               randconfig-001-20251202    clang-22
powerpc               randconfig-002-20251201    gcc-10.5.0
powerpc               randconfig-002-20251202    clang-22
powerpc                     tqm8540_defconfig    gcc-15.1.0
powerpc64             randconfig-001-20251201    gcc-14.3.0
powerpc64             randconfig-001-20251202    clang-22
powerpc64             randconfig-002-20251201    gcc-13.4.0
powerpc64             randconfig-002-20251202    clang-22
riscv                            allmodconfig    clang-16
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                               defconfig    gcc-15.1.0
riscv                 randconfig-001-20251201    clang-22
riscv                 randconfig-001-20251202    gcc-9.5.0
riscv                 randconfig-002-20251201    clang-22
riscv                 randconfig-002-20251201    gcc-8.5.0
riscv                 randconfig-002-20251202    gcc-9.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    gcc-15.1.0
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                                defconfig    gcc-15.1.0
s390                  randconfig-001-20251201    clang-22
s390                  randconfig-001-20251202    gcc-9.5.0
s390                  randconfig-002-20251202    gcc-9.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    clang-22
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20251201    clang-22
sh                    randconfig-001-20251201    gcc-12.5.0
sh                    randconfig-001-20251202    gcc-9.5.0
sh                    randconfig-002-20251201    clang-22
sh                    randconfig-002-20251201    gcc-15.1.0
sh                    randconfig-002-20251202    gcc-9.5.0
sh                          sdk7786_defconfig    gcc-15.1.0
sparc                             allnoconfig    clang-22
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20251201    gcc-14
sparc                 randconfig-001-20251201    gcc-8.5.0
sparc                 randconfig-002-20251201    gcc-14
sparc                 randconfig-002-20251201    gcc-14.3.0
sparc64                          allmodconfig    clang-22
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20251201    clang-22
sparc64               randconfig-001-20251201    gcc-14
sparc64               randconfig-002-20251201    gcc-14
sparc64               randconfig-002-20251201    gcc-14.3.0
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    clang-19
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20251201    gcc-14
um                    randconfig-002-20251201    gcc-14
um                           x86_64_defconfig    clang-22
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-22
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20251201    clang-20
x86_64      buildonly-randconfig-002-20251201    clang-20
x86_64      buildonly-randconfig-003-20251201    gcc-12
x86_64      buildonly-randconfig-003-20251201    gcc-14
x86_64      buildonly-randconfig-004-20251201    gcc-12
x86_64      buildonly-randconfig-004-20251201    gcc-14
x86_64      buildonly-randconfig-005-20251201    gcc-12
x86_64      buildonly-randconfig-005-20251201    gcc-14
x86_64      buildonly-randconfig-006-20251201    gcc-12
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20251201    gcc-14
x86_64                randconfig-002-20251201    clang-20
x86_64                randconfig-003-20251201    clang-20
x86_64                randconfig-004-20251201    clang-20
x86_64                randconfig-005-20251201    clang-20
x86_64                randconfig-006-20251201    clang-20
x86_64                randconfig-011-20251201    clang-20
x86_64                randconfig-011-20251201    gcc-14
x86_64                randconfig-012-20251201    gcc-14
x86_64                randconfig-013-20251201    gcc-14
x86_64                randconfig-014-20251201    gcc-14
x86_64                randconfig-015-20251201    clang-20
x86_64                randconfig-015-20251201    gcc-14
x86_64                randconfig-016-20251201    clang-20
x86_64                randconfig-016-20251201    gcc-14
x86_64                randconfig-071-20251201    gcc-12
x86_64                randconfig-071-20251201    gcc-14
x86_64                randconfig-072-20251201    gcc-14
x86_64                randconfig-073-20251201    gcc-14
x86_64                randconfig-074-20251201    gcc-14
x86_64                randconfig-075-20251201    gcc-12
x86_64                randconfig-075-20251201    gcc-14
x86_64                randconfig-076-20251201    clang-20
x86_64                randconfig-076-20251201    gcc-14
x86_64                               rhel-9.4    gcc-14
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    gcc-14
x86_64                    rhel-9.4-kselftests    gcc-14
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-22
xtensa                            allnoconfig    gcc-15.1.0
xtensa                           allyesconfig    gcc-15.1.0
xtensa                randconfig-001-20251201    gcc-14
xtensa                randconfig-001-20251201    gcc-9.5.0
xtensa                randconfig-002-20251201    gcc-12.5.0
xtensa                randconfig-002-20251201    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

