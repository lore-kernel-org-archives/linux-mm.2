Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08547FD9E2D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E786B0005; Thu, 26 Feb 2026 21:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D4A6B0088; Thu, 26 Feb 2026 21:53:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A566B0089; Thu, 26 Feb 2026 21:53:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7A456B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:53:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 852DB13AB6F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:53:45 +0000 (UTC)
X-FDA: 84488716410.10.84148A4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id BEB51160003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:53:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ooql8Oxr;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772160822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=FgdGBuBrArXQy9lRWQwZjjRE3Fsc3WoE4bT5YUQRccI=;
	b=6blJ45QbSSeptS7IuWYVMw3zg0Em8fufXW6Nxmd7OwZ/Oj0qTu0adATgxaF/zIvqqyZhMK
	ZHhlwbsLvuhaYa4SJUJjJVfuUVutybZ1POENtsz33Il1ZuzRzmwdRqbjtncHD8/9DIKsun
	Pq16ky6f1H2EyV0LnJSLNQIrhvkDX9k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ooql8Oxr;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772160822; a=rsa-sha256;
	cv=none;
	b=TnjGP9IZzfZXhOEm9wamiRTyFZQjvh/0IRFjf0NwhZ9fxgOePd/UeOCNlVrP8BYzUc5ECT
	o0wwQyev3LcbRoksh1VJDPJ48adLf1+IPfHcIXk1xSy6Ovmz/PxPatBK3Jg/GSVEJlMYdT
	9rQXobCeW4OWPnOp1bc5mBiaEn34e7I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772160822; x=1803696822;
  h=date:from:to:cc:subject:message-id;
  bh=XuhaLPJ0RrF5+LSgjmdXkpL7NWXTzTcym/0fFTjIn0c=;
  b=Ooql8OxrlBvmfQcr0Mq1uFUS0PVFIJRt+jyjGtFj+WnbaMjdIw+nuEGE
   4t+jIOpMQ6qAU8XA0TlB0aQcNOnCvDQm/927IaXK4qI+qunantopmGAB3
   xXLWuPTztd2+beD3DdFAA/pPxygygGizAaBPOh3AU3rAMNKwAd1ScCKvL
   4xtW1sSyEq9ZmywcsNIbEG+gyBQ7agiqCVuR0eqOdRzLYait/ZtICVZBT
   5GntU7TwFgc6fxMs2gQcKsklX8SKJQ490UTmdpPuO83og1RpQpZqdQVgC
   TDmkiqcVVyieA3Cfm4lvmGy165Bor9G/AurvGrEb8l2uvysBYZMdCMFgs
   Q==;
X-CSE-ConnectionGUID: yVP/nnIiT76dz8HXFfYq+g==
X-CSE-MsgGUID: v/N8c5irSO+eOezQAdvsWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="84593682"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="84593682"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 18:53:40 -0800
X-CSE-ConnectionGUID: 1YVXHfF7Q6C4AvLoCqU4pg==
X-CSE-MsgGUID: KHwb1ZVXQ+OEuW3UGaA3nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="216881515"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 26 Feb 2026 18:53:38 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvnyx-00000000A8N-2zEf;
	Fri, 27 Feb 2026 02:53:35 +0000
Date: Fri, 27 Feb 2026 10:52:55 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 7d6661873f6b54c75195780a40d66bad3d482d8f
Message-ID: <202602271041.QazC39vA-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BEB51160003
X-Stat-Signature: g5efc9yjmak83de7a8od7dxjjzrkbqgp
X-Rspam-User: 
X-HE-Tag: 1772160821-747339
X-HE-Meta: U2FsdGVkX1+lwa96iShRmCgthr8UEYkY4I3cuOH0Iaglkg7tDLZtf5O5OI8HqSzlYTnoMIcH43MriHR+krdtr7A9U/T0RtcJYpqKHxR4cmS5nEIp7bucJckzCHtbFV1h4FUiwhMdHL3LqQ3fqOeO+/Fux5EYsf59kViBJnfUoP6S6MTdAGY19Ofo8G9cYSIchJeQkLz+heMsMx6KzQajCret9EkvMmiH4l/2Omr8rNYRTToa36i0p67Ne0KrfyntHAu8AI+i1mGTKgVRf9n4zad41ZHzXHvCz/uPYnGZg6FkXMD9y3ZAr6Dp4uOW7AG/dZGXkzcqU056/eblZm56CALs3NfKco89U/5hswpGkkwtt9UNndaObSLv8Wf2OFf2abWYxdr3Ukw1IRGqUa8zwz4rkCXbfXaXcu6sRUg8ahccdmEm1QIFKAetmYPqH9Q2VXFdteYSSN4+ZusmboxNrs21bVhBTlBWJmwZUbej55r+YC8u+wBszZ955pExUQ48saJTM7x7SqhP075Dbv77PmV257nni2m5sFbeT3dOXG3PsxRzLSwwZnrI6JRxgPZ1zp6bHRirzlWqTCMN5YtV02ejF+Toxn0teb91w9rOdfB6sKecSgT4cWasvYfVFI/pd0znqd+guiDcS/NYyvCEdU0BLyp5vYgBBE0LbSRj6pkM6d3Jx+OOxE53KO/nGIvu37VbSi/dV4nZfZ5c2UNxO1kxslskUILQJTlpKtF7E6/PBr0oq2mlE3ggYDfa9lf+Z/PhSt7s7J9/a8+cXzE0GFE5ULYaT/YGLc/6RJYCGAZZKMpBGSr4nFQTnbKGFzWGkdacA8VJJtvq8gY/rky7/dU/sLHYYK6W5SjAi8EEvhjSf2PtF2QiJt3Ob3kNMcgZAMEJKHqCZNugF8vv42JAscZZpPwgoW9kPyTHO8a3HK+II5pmcDsZLenror4+x1iWWnHSLJrEEKSWpf/xjOR
 LRhHyy/+
 HV0/c3fCUOcPU/g7N1jizt1f5qOAkp0eC4KT2DYs3lJxS+IPfydjoJUF9jNlhRgB+SdinDrhLj/HEDR34nQFq5KQ6ji1CChIXUiGuEttCyskhH4Lc75bBiuCEoT2M+MaHnVlK3yPrCWYUbzNv5v7WXPF0iaCoh074ea4xMwhxfAUZO1pQk5tRVeRFoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 7d6661873f6b54c75195780a40d66bad3d482d8f  Add linux-next specific files for 20260226

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202602270250.nso29Dzu-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202602270328.Vbi7C0da-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202602270620.f8yH2jlz-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202602270631.Rv6on3Hk-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202602270121.ugpgH7ot-lkp@intel.com

    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `crypto/lzo-rle.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `crypto/lzo.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/char/hw_random/core.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/char/ipmi/kcs_bmc.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/char/ipmi/kcs_bmc_cdev_ipmi.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/char/ipmi/kcs_bmc_npcm7xx.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/char/ipmi/kcs_bmc_serio.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/hwmon/npcm750-pwm-fan.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/i2c/busses/i2c-npcm7xx.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/i2c/i2c-mux.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/mtd/ubi/block.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/mtd/ubi/build.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/peci/cpu.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/pinctrl/nuvoton/pinctrl-wpcm450.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/pwm/core.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/soc/nuvoton/wpcm450-soc.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/spi/spi-npcm-pspi.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/spi/spi-wpcm-fiu.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/chipidea/ci_hdrc_imx.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/chipidea/ci_hdrc_msm.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/chipidea/ci_hdrc_npcm.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/chipidea/ci_hdrc_tegra.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/chipidea/ci_hdrc_usb2.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/chipidea/core.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/chipidea/usbmisc_imx.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/common/ulpi.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/composite.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/f_acm.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/f_eem.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/f_fs.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/f_hid.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/f_mass_storage.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/f_serial.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/storage_common.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/u_ether.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/function/u_serial.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/gadget/udc/core.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/usb/roles/class.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `drivers/watchdog/npcm_wdt.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `fs/ntfs/super.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `fs/squashfs/super.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `fs/ubifs/super.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `lib/crypto/sha1.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `net/ipv4/ip_tunnel.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `net/ipv4/tunnel4.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `net/ipv6/af_inet6.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `net/ipv6/sit.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `net/packet/diag.o' being placed in section `.modinfo'
    arm-linux-gnueabi-ld: warning: orphan section `.modinfo' from `net/unix/diag.o' being placed in section `.modinfo'
    drivers/gpu/drm/amd/amdgpu/../amdgpu/amdgv_sriovmsg.h:521:1: error: static assertion failed: "amdsriov_ras_telemetry must be 64 KB"
    drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h:521:1: error: static assertion failed: "amdsriov_ras_telemetry must be 64 KB"

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/gpu/drm/amd/amdgpu/amdgpu_benchmark.c:57:1-7: preceding lock on line 38

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|   `-- drivers-gpu-drm-amd-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|-- arc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|   `-- drivers-gpu-drm-amd-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|   `-- drivers-gpu-drm-amd-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|-- arc-randconfig-002-20260227
|   |-- drivers-gpu-drm-amd-amdgpu-..-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|   `-- drivers-gpu-drm-amd-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|-- arc-randconfig-r122-20260225
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dmub-src-dmub_dcn42.c:sparse:sparse:static-assertion-failed:DMUB-command-size-mismatch
|-- arm-randconfig-003-20260226
|   `-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-fs-ntfs-super.o-being-placed-in-section-.modinfo
|-- arm-wpcm450_defconfig
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-crypto-lzo-rle.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-crypto-lzo.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-char-hw_random-core.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-char-ipmi-kcs_bmc.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-char-ipmi-kcs_bmc_cdev_ipmi.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-char-ipmi-kcs_bmc_npcm7xx.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-char-ipmi-kcs_bmc_serio.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-hwmon-npcm750-pwm-fan.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-i2c-busses-i2c-npcm7xx.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-i2c-i2c-mux.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-mtd-ubi-block.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-mtd-ubi-build.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-peci-cpu.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-pinctrl-nuvoton-pinctrl-wpcm450.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-pwm-core.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-soc-nuvoton-wpcm450-soc.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-spi-spi-npcm-pspi.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-spi-spi-wpcm-fiu.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-chipidea-ci_hdrc_imx.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-chipidea-ci_hdrc_msm.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-chipidea-ci_hdrc_npcm.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-chipidea-ci_hdrc_tegra.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-chipidea-ci_hdrc_usb2.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-chipidea-core.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-chipidea-usbmisc_imx.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-common-ulpi.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-composite.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-f_acm.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-f_eem.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-f_fs.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-f_hid.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-f_mass_storage.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-f_serial.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-storage_common.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-u_ether.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-function-u_serial.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-gadget-udc-core.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-usb-roles-class.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-drivers-watchdog-npcm_wdt.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-fs-squashfs-super.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-fs-ubifs-super.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-lib-crypto-sha1.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-net-ipv4-ip_tunnel.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-net-ipv4-tunnel4.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-net-ipv6-af_inet6.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-net-ipv6-sit.o-being-placed-in-section-.modinfo
|   |-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-net-packet-diag.o-being-placed-in-section-.modinfo
|   `-- arm-linux-gnueabi-ld:warning:orphan-section-modinfo-from-net-unix-diag.o-being-placed-in-section-.modinfo
|-- i386-randconfig-051-20260226
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_benchmark.c:preceding-lock-on-line
|-- openrisc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|   `-- drivers-gpu-drm-amd-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|-- openrisc-randconfig-r071-20260227
|   |-- drivers-gpu-drm-amd-amdgpu-..-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
|   `-- drivers-gpu-drm-amd-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
`-- powerpc-allmodconfig
    |-- drivers-gpu-drm-amd-amdgpu-..-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB
    `-- drivers-gpu-drm-amd-amdgpu-amdgv_sriovmsg.h:error:static-assertion-failed:amdsriov_ras_telemetry-must-be-KB

elapsed time: 746m

configs tested: 312
configs skipped: 4

tested configs:
alpha                            alldefconfig    gcc-15.2.0
alpha                             allnoconfig    gcc-15.2.0
alpha                            allyesconfig    gcc-15.2.0
alpha                               defconfig    gcc-15.2.0
arc                              allmodconfig    clang-16
arc                              allmodconfig    gcc-15.2.0
arc                               allnoconfig    gcc-15.2.0
arc                              allyesconfig    clang-23
arc                              allyesconfig    gcc-15.2.0
arc                                 defconfig    gcc-15.2.0
arc                     nsimosci_hs_defconfig    gcc-15.2.0
arc                   randconfig-001-20260226    gcc-15.2.0
arc                   randconfig-001-20260227    gcc-8.5.0
arc                   randconfig-002-20260226    gcc-8.5.0
arc                   randconfig-002-20260227    gcc-8.5.0
arm                               allnoconfig    clang-23
arm                               allnoconfig    gcc-15.2.0
arm                              allyesconfig    clang-16
arm                              allyesconfig    gcc-15.2.0
arm                                 defconfig    clang-23
arm                                 defconfig    gcc-15.2.0
arm                           imxrt_defconfig    clang-23
arm                   randconfig-001-20260226    gcc-10.5.0
arm                   randconfig-001-20260227    gcc-8.5.0
arm                   randconfig-002-20260226    gcc-11.5.0
arm                   randconfig-002-20260227    gcc-8.5.0
arm                   randconfig-003-20260226    gcc-10.5.0
arm                   randconfig-003-20260227    gcc-8.5.0
arm                   randconfig-004-20260226    clang-16
arm                   randconfig-004-20260227    gcc-8.5.0
arm                         wpcm450_defconfig    gcc-15.2.0
arm64                            allmodconfig    clang-19
arm64                            allmodconfig    clang-23
arm64                             allnoconfig    gcc-15.2.0
arm64                               defconfig    gcc-15.2.0
arm64                 randconfig-001-20260226    gcc-14.3.0
arm64                 randconfig-001-20260227    clang-23
arm64                 randconfig-002-20260226    gcc-8.5.0
arm64                 randconfig-002-20260227    clang-23
arm64                 randconfig-003-20260226    clang-16
arm64                 randconfig-003-20260227    clang-23
arm64                 randconfig-004-20260226    clang-23
arm64                 randconfig-004-20260227    clang-23
csky                             allmodconfig    gcc-15.2.0
csky                              allnoconfig    gcc-15.2.0
csky                                defconfig    gcc-15.2.0
csky                  randconfig-001-20260226    gcc-9.5.0
csky                  randconfig-001-20260227    clang-23
csky                  randconfig-002-20260226    gcc-14.3.0
csky                  randconfig-002-20260227    clang-23
hexagon                          alldefconfig    gcc-15.2.0
hexagon                          allmodconfig    clang-17
hexagon                          allmodconfig    gcc-15.2.0
hexagon                           allnoconfig    clang-23
hexagon                           allnoconfig    gcc-15.2.0
hexagon                             defconfig    clang-23
hexagon                             defconfig    gcc-15.2.0
hexagon               randconfig-001-20260226    clang-23
hexagon               randconfig-001-20260227    clang-23
hexagon               randconfig-002-20260226    clang-23
hexagon               randconfig-002-20260227    clang-23
i386                             allmodconfig    clang-20
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                              allnoconfig    gcc-15.2.0
i386                             allyesconfig    clang-20
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20260226    clang-20
i386        buildonly-randconfig-001-20260227    clang-20
i386        buildonly-randconfig-002-20260226    clang-20
i386        buildonly-randconfig-002-20260227    clang-20
i386        buildonly-randconfig-003-20260226    clang-20
i386        buildonly-randconfig-003-20260227    clang-20
i386        buildonly-randconfig-003-20260227    gcc-14
i386        buildonly-randconfig-004-20260226    gcc-14
i386        buildonly-randconfig-004-20260227    clang-20
i386        buildonly-randconfig-004-20260227    gcc-14
i386        buildonly-randconfig-005-20260226    gcc-14
i386        buildonly-randconfig-005-20260227    clang-20
i386        buildonly-randconfig-006-20260226    gcc-14
i386        buildonly-randconfig-006-20260227    clang-20
i386                                defconfig    clang-20
i386                                defconfig    gcc-15.2.0
i386                  randconfig-001-20260226    gcc-14
i386                  randconfig-001-20260227    clang-20
i386                  randconfig-002-20260226    clang-20
i386                  randconfig-002-20260227    clang-20
i386                  randconfig-003-20260226    clang-20
i386                  randconfig-003-20260227    clang-20
i386                  randconfig-004-20260226    clang-20
i386                  randconfig-004-20260227    clang-20
i386                  randconfig-005-20260226    gcc-13
i386                  randconfig-005-20260227    clang-20
i386                  randconfig-006-20260226    clang-20
i386                  randconfig-006-20260227    clang-20
i386                  randconfig-007-20260226    clang-20
i386                  randconfig-007-20260227    clang-20
i386                  randconfig-011-20260226    clang-20
i386                  randconfig-011-20260227    gcc-14
i386                  randconfig-012-20260226    clang-20
i386                  randconfig-012-20260227    gcc-14
i386                  randconfig-013-20260226    gcc-12
i386                  randconfig-013-20260227    gcc-14
i386                  randconfig-014-20260226    gcc-14
i386                  randconfig-014-20260227    gcc-14
i386                  randconfig-015-20260226    gcc-14
i386                  randconfig-015-20260227    gcc-14
i386                  randconfig-016-20260226    clang-20
i386                  randconfig-016-20260227    gcc-14
i386                  randconfig-017-20260226    gcc-14
i386                  randconfig-017-20260227    gcc-14
loongarch                        allmodconfig    clang-19
loongarch                        allmodconfig    clang-23
loongarch                         allnoconfig    clang-23
loongarch                         allnoconfig    gcc-15.2.0
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20260226    gcc-15.2.0
loongarch             randconfig-001-20260227    clang-23
loongarch             randconfig-002-20260226    clang-20
loongarch             randconfig-002-20260227    clang-23
m68k                             allmodconfig    gcc-15.2.0
m68k                              allnoconfig    gcc-15.2.0
m68k                             allyesconfig    clang-16
m68k                             allyesconfig    gcc-15.2.0
m68k                         amcore_defconfig    gcc-15.2.0
m68k                                defconfig    clang-19
m68k                                defconfig    gcc-15.2.0
m68k                          hp300_defconfig    gcc-15.2.0
m68k                       m5275evb_defconfig    gcc-15.2.0
m68k                          sun3x_defconfig    gcc-15.2.0
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
nios2                 randconfig-001-20260226    gcc-11.5.0
nios2                 randconfig-001-20260227    clang-23
nios2                 randconfig-002-20260226    gcc-11.5.0
nios2                 randconfig-002-20260227    clang-23
openrisc                         allmodconfig    clang-23
openrisc                         allmodconfig    gcc-15.2.0
openrisc                          allnoconfig    clang-23
openrisc                          allnoconfig    gcc-15.2.0
openrisc                   de0_nano_defconfig    gcc-15.2.0
openrisc                            defconfig    gcc-15.2.0
parisc                           allmodconfig    gcc-15.2.0
parisc                            allnoconfig    clang-23
parisc                            allnoconfig    gcc-15.2.0
parisc                           allyesconfig    clang-19
parisc                           allyesconfig    gcc-15.2.0
parisc                              defconfig    gcc-15.2.0
parisc                randconfig-001-20260226    gcc-14.3.0
parisc                randconfig-001-20260227    clang-17
parisc                randconfig-002-20260226    gcc-12.5.0
parisc                randconfig-002-20260227    clang-17
parisc64                            defconfig    clang-19
parisc64                            defconfig    gcc-15.2.0
powerpc                          allmodconfig    gcc-15.2.0
powerpc                           allnoconfig    clang-23
powerpc                           allnoconfig    gcc-15.2.0
powerpc                 canyonlands_defconfig    gcc-15.2.0
powerpc                     kmeter1_defconfig    gcc-15.2.0
powerpc               randconfig-001-20260226    gcc-11.5.0
powerpc               randconfig-001-20260227    clang-17
powerpc               randconfig-002-20260226    clang-16
powerpc               randconfig-002-20260227    clang-17
powerpc                     tqm5200_defconfig    gcc-15.2.0
powerpc64             randconfig-001-20260226    gcc-8.5.0
powerpc64             randconfig-001-20260227    clang-17
powerpc64             randconfig-002-20260226    clang-23
powerpc64             randconfig-002-20260227    clang-17
riscv                            allmodconfig    clang-23
riscv                             allnoconfig    clang-23
riscv                             allnoconfig    gcc-15.2.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-23
riscv                               defconfig    gcc-15.2.0
riscv                 randconfig-001-20260227    clang-23
riscv                 randconfig-001-20260227    gcc-12.5.0
riscv                 randconfig-002-20260227    gcc-12.5.0
riscv                 randconfig-002-20260227    gcc-8.5.0
s390                             allmodconfig    clang-18
s390                             allmodconfig    clang-19
s390                              allnoconfig    clang-23
s390                             allyesconfig    gcc-15.2.0
s390                                defconfig    clang-23
s390                                defconfig    gcc-15.2.0
s390                  randconfig-001-20260227    gcc-11.5.0
s390                  randconfig-001-20260227    gcc-12.5.0
s390                  randconfig-002-20260227    gcc-12.5.0
s390                  randconfig-002-20260227    gcc-9.5.0
sh                               allmodconfig    gcc-15.2.0
sh                                allnoconfig    clang-23
sh                                allnoconfig    gcc-15.2.0
sh                               allyesconfig    clang-19
sh                               allyesconfig    gcc-15.2.0
sh                                  defconfig    gcc-14
sh                                  defconfig    gcc-15.2.0
sh                ecovec24-romimage_defconfig    gcc-15.2.0
sh                          kfr2r09_defconfig    gcc-15.2.0
sh                          r7780mp_defconfig    gcc-15.2.0
sh                    randconfig-001-20260227    gcc-12.5.0
sh                    randconfig-002-20260227    gcc-12.5.0
sh                    randconfig-002-20260227    gcc-15.2.0
sh                           se7343_defconfig    gcc-15.2.0
sh                           se7750_defconfig    gcc-15.2.0
sh                   secureedge5410_defconfig    gcc-15.2.0
sparc                            alldefconfig    gcc-15.2.0
sparc                             allnoconfig    clang-23
sparc                             allnoconfig    gcc-15.2.0
sparc                               defconfig    gcc-15.2.0
sparc                 randconfig-001-20260227    clang-23
sparc                 randconfig-001-20260227    gcc-11.5.0
sparc                 randconfig-002-20260227    clang-23
sparc                 randconfig-002-20260227    gcc-15.2.0
sparc64                          allmodconfig    clang-23
sparc64                             defconfig    clang-20
sparc64                             defconfig    gcc-14
sparc64               randconfig-001-20260227    clang-23
sparc64               randconfig-002-20260227    clang-23
um                               allmodconfig    clang-19
um                                allnoconfig    clang-23
um                               allyesconfig    gcc-14
um                               allyesconfig    gcc-15.2.0
um                                  defconfig    clang-23
um                                  defconfig    gcc-14
um                             i386_defconfig    gcc-14
um                    randconfig-001-20260227    clang-23
um                    randconfig-002-20260227    clang-23
um                           x86_64_defconfig    clang-23
um                           x86_64_defconfig    gcc-14
x86_64                           allmodconfig    clang-20
x86_64                            allnoconfig    clang-20
x86_64                            allnoconfig    clang-23
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20260226    gcc-14
x86_64      buildonly-randconfig-001-20260227    gcc-14
x86_64      buildonly-randconfig-002-20260226    clang-20
x86_64      buildonly-randconfig-002-20260227    gcc-14
x86_64      buildonly-randconfig-003-20260226    gcc-14
x86_64      buildonly-randconfig-003-20260227    clang-20
x86_64      buildonly-randconfig-003-20260227    gcc-14
x86_64      buildonly-randconfig-004-20260226    clang-20
x86_64      buildonly-randconfig-004-20260227    gcc-14
x86_64      buildonly-randconfig-005-20260226    gcc-14
x86_64      buildonly-randconfig-005-20260227    gcc-14
x86_64      buildonly-randconfig-006-20260226    gcc-13
x86_64      buildonly-randconfig-006-20260227    gcc-14
x86_64                              defconfig    gcc-14
x86_64                                  kexec    clang-20
x86_64                randconfig-001-20260226    gcc-14
x86_64                randconfig-001-20260227    gcc-13
x86_64                randconfig-002-20260226    gcc-14
x86_64                randconfig-002-20260227    gcc-13
x86_64                randconfig-003-20260226    gcc-14
x86_64                randconfig-003-20260227    gcc-13
x86_64                randconfig-004-20260226    gcc-14
x86_64                randconfig-004-20260227    gcc-13
x86_64                randconfig-005-20260226    clang-20
x86_64                randconfig-005-20260227    gcc-13
x86_64                randconfig-006-20260226    gcc-14
x86_64                randconfig-006-20260227    gcc-13
x86_64                randconfig-011-20260226    clang-20
x86_64                randconfig-011-20260227    gcc-14
x86_64                randconfig-012-20260226    clang-20
x86_64                randconfig-012-20260227    gcc-14
x86_64                randconfig-013-20260226    clang-20
x86_64                randconfig-013-20260227    gcc-14
x86_64                randconfig-014-20260226    clang-20
x86_64                randconfig-014-20260227    gcc-14
x86_64                randconfig-015-20260226    clang-20
x86_64                randconfig-015-20260227    gcc-14
x86_64                randconfig-016-20260226    gcc-14
x86_64                randconfig-016-20260227    gcc-14
x86_64                randconfig-071-20260226    clang-20
x86_64                randconfig-071-20260227    gcc-14
x86_64                randconfig-072-20260226    clang-20
x86_64                randconfig-072-20260227    gcc-14
x86_64                randconfig-073-20260226    gcc-14
x86_64                randconfig-073-20260227    gcc-14
x86_64                randconfig-074-20260226    clang-20
x86_64                randconfig-074-20260227    gcc-14
x86_64                randconfig-075-20260226    gcc-13
x86_64                randconfig-075-20260227    gcc-14
x86_64                randconfig-076-20260226    clang-20
x86_64                randconfig-076-20260227    gcc-14
x86_64                               rhel-9.4    clang-20
x86_64                           rhel-9.4-bpf    gcc-14
x86_64                          rhel-9.4-func    clang-20
x86_64                    rhel-9.4-kselftests    clang-20
x86_64                         rhel-9.4-kunit    gcc-14
x86_64                           rhel-9.4-ltp    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    clang-23
xtensa                            allnoconfig    gcc-15.2.0
xtensa                           allyesconfig    clang-23
xtensa                           allyesconfig    gcc-15.2.0
xtensa                  audio_kc705_defconfig    gcc-15.2.0
xtensa                generic_kc705_defconfig    gcc-15.2.0
xtensa                randconfig-001-20260227    clang-23
xtensa                randconfig-001-20260227    gcc-15.2.0
xtensa                randconfig-002-20260227    clang-23
xtensa                randconfig-002-20260227    gcc-10.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

