Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CE1606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NqZQqOUt
Received: by kanga.kvack.org (Postfix)
	id 7D78C6B05B1; Fri,  6 Nov 2026 17:35:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787116B05B4; Fri,  6 Nov 2026 17:35:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6768C6B05B5; Fri,  6 Nov 2026 17:35:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3185D6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:35:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 605D816023A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:35:36 +0000 (UTC)
X-FDA: 85406152272.03.49226F9
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8991820006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:35:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NqZQqOUt;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794004534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwjRA8ftZApzwOyImkXY8LHZEAElz+0AJdwAhV3strc=;
	b=gKpr+AKx0BiB7lcKMgQSNIkztDasO/s8fvgKcMZR9rFinqkaJUe7WguaBiTegD91H/NCpE
	aTgs9jfTHeXfzyLZvbcN+AY3ntrtPFVYiJy/fkrd7ckLPll8dAH2TJzXuQwiy6ZaCcp6oR
	nFIN7+a3OHmqAWL8qv8G4B9HH2LO3tg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794004534;
	b=bm1svlLzF2JicgCLN1ajYWdkC79RsZoQXAF3ZJquZCdm6Z9IT63niQ70VCtVLpzLSKx+pp
	qQm2nhkfG5p7If0swZGsd1Cmc4a9YVPNIKd9tgPJIWJ+B10Gg0FPCCXLfvymHOkpDleOul
	C4W+/FrLMQIebzkFmTwhkbGg5RX9vjQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=NqZQqOUt;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ed3f563739so12085ad.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 14:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794004533; x=1794609333; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BwjRA8ftZApzwOyImkXY8LHZEAElz+0AJdwAhV3strc=;
        b=NqZQqOUthW2y+72BE/C+LIFYMU/S+WBwwrOfTiDFwrm+vBDSU0c4QGL8f5FhJwC58k
         fzX/Q91QSSbunADrVVMSpLMYP0ircOi3sbC0eeeuGXHNS6Zc6F1UvDzC+LCM3IRIL3X3
         NCDU4e6AHriDzP2IJ98wxu+fSjBl8p1v7BIJK1zPiM8180trDQZ4iBoAN2M3UD4jIHMt
         Yev8TT6n5TXJ/icc9cyReujetHAJnkLx/Da92KW9Q2gA6KB7LIkl/RMdyM4voV8J9j7g
         OBswY+EKu1jR1H97HdPc0Q7qPacNT+WhShgu7CJbkioKIwpolvkTj7Sq0FBbEsJUWvOl
         Be0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794004533; x=1794609333;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BwjRA8ftZApzwOyImkXY8LHZEAElz+0AJdwAhV3strc=;
        b=HXisNuVmxDVW5F115FG1LAAI9HEVTqO6oRTZbkIRh4yD/OoMgFr9u2NAaQURqlKcIa
         OMqHJJoPmlGVzsQDxsMCmOnEtJ37VVhrMdZLeWIFNBJcsZ7Q08+wg6pUfGCdevGPneiw
         E3R4AZTeU37R/Cybsw70AxQP9AuuuOZC4gF+F3bWHn7gtmj5UL8IofiQdotBxWN3V8iS
         WZP6agdoBj/VlLAwPSJP8ujMhOAO4zUQ1SXULVHxgCkXCM0kpSHRijGaE/3Jmw1Pav0o
         /mXzTdJ0S9Qu5Dw7w4TO1KTV/IMNA9z50jfBWsrYX1jKbkf4POs77p+AiO+GlZU5Sfcf
         7Q0g==
X-Forwarded-Encrypted: i=1; AL+hErHwxTf1FBTQoHs9aCm9ImbzFGV+9FCTqyzUpqC8Zkp+VvJBMLhVqHE1BqfCO65Maye6Jl/Vx8gfjQ==@kvack.org
X-Gm-Message-State: APuU4Z/mAFVcbEXo7wOBTsieIf21ZtC92xPTXVKJ39ljtmpmSpDDcC70
	5SKkmT0G6Q5+Zy/qEPY29r4VmKyOP+JiFTzP8gQdjd3Agzmb2jybF9vjv0H3JJavWA==
X-Gm-Gg: AYBFou1gGw+ykawY6Wi+pa0dpVjvV/AdG44I7Pp8qZzDxeCM+YNMo2ZxRfVYb4ttIBU
	slv4gNGKeqtpxLw9XUxj6wlHxzz4gWqjkdkZyjXcJ++TBG0/2I8GRve+9xJZtEPZpesZCD6o7W/
	ggVposMGmdDGC8aT77LU8+lZOIvsqTmhiJ21PHCdx76un3Xgl3WW7YUgeKIdRurqJkBsEzi34Or
	3sXkpK3Tr8WG03RSwlfhQq1Ql+huq9pKs+jVC0nh2Hy71WZpSKJ/i7JIjFL7HNnFY9Vgp5696hM
	ZjRmshXmeHXvK3dMNB3/tGfgVyHPEjKIhVdpL11sDW712IvupPLNV1zrScGJtNQYePkLPub6i/s
	AOGSQ0Kxkxd8/8OB+/SJaTKRVMlqAPfD9jJt7ddj83Kx0oXlIEeOP25IAz2684d3va+wd+Gaosb
	MTtb8/5S66PhQrtPheBvz9+2oekj3j8HWkhLH4evUB8iLUU/1/SaWOst+Uktp3D2px933m+bKY+
	8toj/aVBidjdVTAOCoOtGA3afC4mDQ2aYJjtV2+VUdV9Xa5YZUx3xoQ2MoCPtxY1STOIjBUmDFN
	YdwttITX4H785EmT0W4IbzmMVo62LqkyXWPVtaUkj4E0nwA8+f4woGuRGbiDNM7CVDSMumLlC9p
	qdt1NyPCgmlTRYotTCmlg
X-Received: by 2002:a17:902:e80e:b0:2ea:1079:e519 with SMTP id d9443c01a7336-2ed6a97c2c6mr202835ad.17.1794004532665;
        Fri, 06 Nov 2026 14:35:32 -0800 (PST)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b103435561sm482994a91.3.2026.11.06.14.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 14:35:31 -0800 (PST)
Date: Fri, 6 Nov 2026 22:35:27 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, 
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, rananta@google.com, 
	rdunlap@infradead.org, rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, 
	saeedm@nvidia.com, schnelle@linux.ibm.com, skhan@linuxfoundation.org, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 07/27] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <au5VMy7zhOb65xIE@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-8-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261102153656.1431701-8-vipinsh@google.com>
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 77i73d7umk3pwu8g4refdppm8zcbz95c
X-Rspamd-Queue-Id: 8991820006
X-Rspam-User: 
X-HE-Tag: 1794004534-917642
X-HE-Meta: U2FsdGVkX1/NmfcnabyN6alSSbaybSwJS/dsisxC+rs6hVmnh0yNx0+iBUtjuXGVh3HwxS71Q7WezpTZeI+VpAyqzgHfrXns/jdHa2orCKKISXCTqQFZcOxzhNAWuZ8HvRt2fpEqpgY5tcPBxGAxsU0PVjFiQLkdWQwOTRIHjce0vSB9uKWL4MgxNgnSlrCvgISPbzVaRMuHaqkcb+jdHJigNta4IwJdbDaixd5BlsA8Zj89ixyKUxVtbKXRsJwPIFvOLSj1xWoYrWPTUO/JG/ErfsKcDaI7neEDclv1hvxF6zFCCcLSaHCOap40wTNCR+q3xvHHAxFwAYvlpgyBU6VDVs5Z6xxOrprZxUiDXq9YAx2K2iPfvnGyhYmTC16ROB8vxP9zNZxUmAdGzpucqZof+BodXPulPkcv/1rRFuJmtn2QIFSxs51rCIM/uWQ/HnNHVnSYJIpktbwa6csGBEwXJ3OTxOu7pb6ZS7O6C6zkuW90+AZIkv0Ngg6YCVMGTGSPw7BHQwRx5VVg55oDRp1s0776IbfHcmw3Z3UubM5MbTuxLFiMUdi6vOS/dW9g9iQY6aU6EiTRF+6StoIWZHjwzctfm+p+1cQzlFGB2tvmRL5MVLX8IFB+FYlV2CfReBe/JPl8vrm6IRvWQffV5klxGyV1ZJju55LvHHKz3z2mjx9nIBFOf+xRq4MkF883rMSi+r7l2BUEKzAPi0Et68VWNwT00GJ++XW1isVDUTTn9kZsc2hbccUizQLLbx5F2i51ywELBQZeBwfy6MylqzW/Pjl/O2yOBrKvEnfCT0846cjrzylm+p3RJXcA1sBLhdSR30eOPoDG7ymZHFbwl05LQzUfastNoqL1Of6r3y5S4wJiooEYWolzNr8MIMNT00JKwwC0ddEiLtzwUGrEJfM00WUMxbGyjjWIhgaW7PoeFofvkgNx0vPnOAnDsBGBPOpw1gYse/TkPgTLui1
 Zsm0peFk
 m4yDkLwEQ37306J2pJl6pSeQkaBmsDkn5zizGVBevdcHk2g6JDsHymWmGE+MEpoeTfvesP+nk60rvQ1dDcJBbnpk6rzA8bQfXLgcyd/tdt5/Ttyb/QShJzopeGyA8G114JNuiiQ+5K/nNC2/H/zbkF6nRDZpO8l64iy17l2KA5z6QPygIJ4sit8wpuvAXIg10uA0DDVRQjqqTwcz+6G63f0nCU2LnYkptTMZnsq/ZEln3sYlQ1q5A4PcvDm1sCmzGot8DESvmJlDAHV+hriFlKIrkVyDcpdnqXedEHqT6VUfYILp7cMQxy1rytlOYqy4ilv0XdD5gTR687C6wNEEbNtvweYozbu/Z/Ay+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 07:36:36AM -0800, Vipin Sharma wrote:
>Implement the Live Update file handler callbacks to preserve a vfio-pci
>device in noiommu mode across a Live Update while keeping it running
>across kexec. Subsequent commits will enable userspace to retrieve and
>take over this file after the Live Update.
>
>State about each device is serialized into struct vfio_pci_core_device_ser
>using Kexec-Handover (KHO) to preserve the pages holding the struct and
>the Live Update Orchestrator (LUO) to preserve the physical address of
>the struct.
>
>Key design notes and constraints:
>
> * Noiommu-only policy and bound cdev requirement: can_preserve() verifies
>   that the preserved file is a bound vfio-pci cdev file descriptor via
>   vfio_file_is_bound_cdev(), and preserve() requires the device to be in
>   noiommu mode via vfio_device_is_noiommu() (returning -EOPNOTSUPP
>   otherwise). CONFIG_VFIO_PCI_LIVEUPDATE now depends on
>   CONFIG_VFIO_DEVICE_CDEV and CONFIG_VFIO_NOIOMMU.
>
> * Serialized state: During preserve(), serialize the PCI domain, BDF,
>   config space size, reset_works flag, and the initial pci_saved_state
>   captured when the device was first opened. During freeze(), snapshot
>   the virtualized PCI config space (vconfig) and capability map
>   (pci_config_map).
>
> * Keep-running freeze and unfreeze: Do not reset the device, clear
>   PCI_COMMAND_MASTER, zap BAR mappings, or revoke dma-bufs during
>   freeze(). Validate that VFIO interrupts are disabled, that the device
>   is in PCI_D0 (and not in VFIO runtime PM low-power mode), and that
>   SR-IOV is not enabled, as VFs are not preserved and the next kernel
>   disables SR-IOV on the running device. Then mask physical INTx
>   (recording the prior state) and mark the device frozen. If the
>   Live Update is aborted after freeze(), unfreeze() restores the physical
>   INTx state and clears liveupdate_frozen so the existing FD remains
>   usable.
>
> * TOCTOU synchronization: vfio_pci_dev_is_frozen() is checked locklessly
>   on entry to the ioctl, read/write and mmap paths, and re-checked under
>   a lock that freeze() holds before any operation that could change the
>   device or vconfig: under vdev->igate in vfio_pci_ioctl_set_irqs() and
>   around every config-space write in vfio_pci_config_rw_single(), under
>   vdev->memory_lock in vfio_pci_runtime_pm_entry(),
>   vfio_pci_ioctl_reset() and the SR-IOV enable path of
>   vfio_pci_core_sriov_configure(), and under dev_set->lock in
>   vfio_pci_dev_set_hot_reset(). A racing operation thus either completes
>   before freeze() takes its snapshot or fails, while existing BAR mmaps,
>   ioeventfds and dma-bufs keep working. Serializing config writes on
>   igate covers the PCI_COMMAND, INTx disable emulation, power state and
>   FLR paths at one point (the INTx disable emulation now uses the
>   igate-held __vfio_pci_intx_mask() and __vfio_pci_intx_unmask()
>   helpers), and also serializes the irq_type and virq_disabled accesses
>   of config writes with VFIO_DEVICE_SET_IRQS.
>
>Co-developed-by: David Matlack <dmatlack@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>Signed-off-by: Vipin Sharma <vipinsh@google.com>
>---
> drivers/vfio/pci/Kconfig               |   2 +-
> drivers/vfio/pci/vfio_pci_config.c     |  19 +-
> drivers/vfio/pci/vfio_pci_core.c       |  49 +++-
> drivers/vfio/pci/vfio_pci_intrs.c      |   4 +-
> drivers/vfio/pci/vfio_pci_liveupdate.c | 303 ++++++++++++++++++++++++-
> drivers/vfio/pci/vfio_pci_priv.h       |  13 ++
> include/linux/kho/abi/vfio_pci.h       |  52 ++++-
> include/linux/vfio_pci_core.h          |   4 +
> 8 files changed, 434 insertions(+), 12 deletions(-)
>

[snip]

>diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
>index 67e8199eec59..725043a44b55 100644
>--- a/include/linux/kho/abi/vfio_pci.h
>+++ b/include/linux/kho/abi/vfio_pci.h
>@@ -9,14 +9,19 @@
> #ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
> #define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
>
>+#include <linux/bits.h>
>+#include <linux/compiler.h>
>+#include <linux/types.h>
>+
> /**
>  * DOC: VFIO PCI Live Update ABI
>  *
>  * VFIO uses the ABI defined below for preserving device files across a kexec
>  * reboot using LUO.
>  *
>- * Device metadata is serialized into memory which is then handed to the next
>- * kernel via KHO.
>+ * Device metadata, virtualized PCI configuration space, VFIO's capability map,
>+ * and the initial PCI saved state captured when the device was first opened are
>+ * serialized into memory which is then handed to the next kernel via KHO.
>  *
>  * This interface is a contract. Any modification to any of the serialization
>  * structs defined here constitutes a breaking change. Such changes require
>@@ -25,4 +30,47 @@
>
> #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
>
>+/**
>+ * define VFIO_PCI_SER_RESET_WORKS - Device supports function reset.
>+ *
>+ * Set in &vfio_pci_core_device_ser.flags when the preserved device had
>+ * ``vdev->reset_works == true`` prior to kexec.
>+ */
>+#define VFIO_PCI_SER_RESET_WORKS	BIT(0)
>+
>+#define VFIO_PCI_SER_KNOWN_FLAGS	VFIO_PCI_SER_RESET_WORKS
>+
>+/**
>+ * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
>+ * device.
>+ *
>+ * @domain: The device's PCI domain number (segment).
>+ * @bdf: The device's PCI bus, device, and function number.
>+ * @cfg_size: Size in bytes of the device's PCI configuration space
>+ *            (``PCI_CFG_SPACE_SIZE`` or ``PCI_CFG_SPACE_EXP_SIZE``).
>+ * @size: Total size in bytes of this serialized buffer, equal to
>+ *        ``sizeof(struct vfio_pci_core_device_ser) + 2 * @cfg_size + @saved_state_size``.
>+ * @flags: Bitmask of ``VFIO_PCI_SER_*`` flags; unknown bits are rejected.
>+ * @saved_state_size: Size in bytes of the serialized &struct pci_saved_state_ser
>+ *                    blob stored in @data after ``config_map``, or 0 if none.
>+ * @reserved: Reserved for future use; must be 0.
>+ * @data: Variable-length payload containing, in order:
>+ *        1. ``u8 vconfig[@cfg_size]`` - VFIO virtualized config space snapshot
>+ *           captured during ``freeze()``.
>+ *        2. ``u8 config_map[@cfg_size]`` - VFIO capability map snapshot
>+ *           captured during ``freeze()``.
>+ *        3. ``u8 saved_state[@saved_state_size]`` - serialized
>+ *           &struct pci_saved_state_ser captured during ``preserve()``.
>+ */
>+struct vfio_pci_core_device_ser {
>+	u32 domain;
>+	u16 bdf;
>+	u16 cfg_size;
>+	u32 size;
>+	u32 flags;
>+	u32 saved_state_size;

We will need space for iommufd_token when we preserve that, we should
probably add it now as otherwise the compatibility would be broken when
we add it? Is the reserved here for that?
>+	u32 reserved;
>+	u8 data[];
>+} __packed;
>+
> #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
>diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>index 9a1674c152aa..6bae7581f4f4 100644
>--- a/include/linux/vfio_pci_core.h
>+++ b/include/linux/vfio_pci_core.h
>@@ -149,6 +149,10 @@ struct vfio_pci_core_device {
> 	struct notifier_block	nb;
> 	struct rw_semaphore	memory_lock;
> 	struct list_head	dmabufs;
>+#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
>+	bool			liveupdate_frozen;
>+	bool			liveupdate_intx_disabled;
>+#endif
> };
>
> enum vfio_pci_io_width {
>-- 
>2.56.0.317.g454f8302e1-goog
>

Thanks,
Sami

