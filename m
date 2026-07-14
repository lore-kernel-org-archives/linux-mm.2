Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 798B3C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93F76B00E9; Tue, 14 Jul 2026 11:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6726B00EC; Tue, 14 Jul 2026 11:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD926B00EE; Tue, 14 Jul 2026 11:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6466B00EC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB96FA0436
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:18 +0000 (UTC)
X-FDA: 84987730716.09.27AA20D
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3DDB51C0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="qzyRx/oR";
	spf=pass (imf21.hostedemail.com: domain of 3g1JWagcKCNoRELEJODCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3g1JWagcKCNoRELEJODCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3w9lxehSFy6bEWUAEqWnKleB5eNdNwWh1m/SMhRNo4=;
	b=usb9OvOZ9SQXMX/epuf6kuzHjQa0mkBFFaX3YmUaLL/l+RUdgWz/QjcgnQdoS9FEah4BJ4
	5+fir1wY3TZcpX6E786HhOvuPyOzH+BYQx3lfHXYmQRMzqkVCfv7CGIVNB1LGCOU2qPI8t
	byYopCPch4Q2rkwAmybBwKGXbeclE0M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="qzyRx/oR";
	spf=pass (imf21.hostedemail.com: domain of 3g1JWagcKCNoRELEJODCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3g1JWagcKCNoRELEJODCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042117;
	b=bRXUE2CUE0ISdNOdbjvArMpHpf3ZaFqNgG+zl4OwG7R+8XVM2CrO+Sbe8jdfHsKgz7B9vb
	d54utUVg6SMHrHRzTtYZTSgf/ARoHJ796pm8qwreQ5MZ7mkayruwVGWoxni1CJx9Gnivww
	8ugh7jq2Mq58VGq09VXf/bsFZeXqtXk=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-848860def2cso4614470b3a.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042116; x=1784646916; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H3w9lxehSFy6bEWUAEqWnKleB5eNdNwWh1m/SMhRNo4=;
        b=qzyRx/oRrU1mvSqkpfhpwQZC0ch0ZHMtCy158HdGbiu81fVETT/d1Vp+y7SATPo7YE
         qvUtPQ0awhr0xGZ+Ep/Rtkd51c1TBbHDfjk4EQguAtmkQsH8bXYiIp368PScrG/TjfJJ
         5RG7GqX2Uek8O5g3gd0kgHtl3ayfJ2kQMo8ZlWCW1NxdnSfom6fbvCYd8x4oTXyPSorL
         bjWN97j6f4Fq34EwEw9Q+wq+VkfNhfiPx+z1U/fo5KLijYmJlX8o3MDvzGWsczs3R6xg
         NFgfVthi78WptizZ3lQj15ji3ZXstmDfobAEgI8enP9KFGOhk6TGaC+O3bcRQ39t4du9
         vrHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042116; x=1784646916;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H3w9lxehSFy6bEWUAEqWnKleB5eNdNwWh1m/SMhRNo4=;
        b=Y29tWYjlF28cXl9r8SyQ+fWo1+lDMF8an2+ykQ6UsPEKIJmMB4udN6J4lf304qMKpP
         qZEDIpgsxo82RzpgCNCmkA2vcRYRlGqtXKkNMQflrwM5nOAuQCIH+99jw9/j7Gjza0xJ
         ktWcI4CWcgOabQkiVThtzqd2NLF/M3q8bxO/3LjkdSxc7wVg4418NuZrovPDfnze7HDb
         vt+R8iim/e2cpQB7PXyh+rIUpUxLm12Yfz5ve4fW0A6thvxq6dTPN997y/FxmVENx3TM
         KaQt/JeMWuwHkELU5WdvouxcO6bIGCmkXyRObq8lU4AAz6itucVglXiCIGjfgXRombQf
         b2+Q==
X-Forwarded-Encrypted: i=1; AHgh+RpEM//GhEdvVTzmz0DJ86T42JSyd13CPxtHzsOyXOIATp5nn9bMLP/vOcdLvwjoSlX9LfV3yxm04A==@kvack.org
X-Gm-Message-State: AOJu0YxQa1xg1EM5HqL0ZBevUKPKpE8ni+yibp79I/iwU6Cxp7n0pohu
	lnyzuKqr9sRNwmz6zJVBc36Ye4MqnhKNLVE5ajvf29K6f8/jPCe1+U878RgKTze+iGWJu39xuy+
	B+is6gYoy6A==
X-Received: from pfez10.prod.google.com ([2002:aa7:888a:0:b0:848:492a:5b41])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:17a6:b0:847:980d:71f8
 with SMTP id d2e1a72fcca58-848896349ddmr12405772b3a.15.1784042115712; Tue, 14
 Jul 2026 08:15:15 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:51 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-7-vipinsh@google.com>
Subject: [PATCH v5 06/20] vfio/pci: Preserve vfio-pci device files across Live Update
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3DDB51C0007
X-Stat-Signature: hpo5a6p5g7q7bisided15zybzeiu5eq1
X-HE-Tag: 1784042117-117045
X-HE-Meta: U2FsdGVkX1+5TDLPFoYSgFh8szU4l0Gwh/3p3Fp04KOngPAcp/NjTxAXTyGwCDuwPyg5nQ14z/HCuG8YgKscfEwPxcit4WtX+sBhuY1OHDjnbDosAilC0qpvWNlLFD5nNaGY738qfxvFeEBSawhfTDfDYtlV5CMbjp1P60SNPgzjdahFx3m/xS6MQ0VJ+o5aTPEY7VY5qt9AEXvj41jbtqfJYh6fXybeHa/wzJhHRhgZEOIFL9ATM+6uu7bt78lI1NWyalhCIggASFmhOLtJeNVtYZSfHuqAB3dUkMd7QisY0KntLhC3+Ml+5MRFoJtS7O942vYkVUxfj8up04fDcY+A7Nd5dCEG9WW87l1ook/tACAnfXNXjVLYw9PDb4nYzis11fJwwTtjUeOzzQ7ecRZmRtvthmGKJfiO+htPM4eOMcLkoxDpocBTqb8l46XCDd+/vhxvMSC1ukKxFNHwEVmgFriREqugYpTQC/TmtGmcSzGFzrN2tCymR6r0mVFKt0am8PPRzzGnqUpz2pA1IYMMMG5h8PiUelimyPKPp/PQUus//j+Oh+5mWdRU+9AERxY9MHV2lWFOISaGaU23tfxwpcGcyc3sIUU4y06T9dJ22BtCmJY6EM7vw4Wm48iHhl57yFlaOi6eEa2ws3/FhC3PNxKG4TMaHLC6Z+Pytk0fCjX1BD+K1FEUUq5fWMZyJJ7i+SmOXN2BywadlTmnscw7M1WwLtBcGIS8cQEMrRUUh1bry181c4Vm8tNzqNs1TvAa5tDtN6/rnuLet2SfJ2Imcu/Vv6xuhue6iHAu+7o0lp6AD9uU10Qv/lgvAHNCWcKK5SWD7MLR9NsictXGySBYkxPkTMShv/mcBmEjvUyOHTjRhJK5es6wQhXjF0oEkO4ldPL6bdYsnxPCWOTKX6NmWsPo1sxcYdIuz7wgBZQ/Y1+YGTrpt1q6B64SaKnmDMHK2OKqsWfizyc7MiP
 LdJwdg5D
 oRelYQYsjrc0pBnh/FLPzSCpXrosasXgkX5tjzzGMfrokw1SLT1TWue9UQ9sgkf785IDclmW9ibrSrH3fXny5AgKgYmsLpoijzKguWWIj1l1dj58p45/cLrNMZLm0AM0ueMBHYn0u2hTYtxhiLSY1UORFNv74AZNwT6YXgP+fcCQAVhOK9xwtGCI3f+1if5+Te3XZhNdep+5uuAiylxwvaUXDe/S8eLjft7m16IZyZgfvsgI/CXOytr+PoXhviKE3P3FbGmKH7gkByk0TV73xLTooOgqADKKkWfzWioTevjz6Q3tS5Dsm099GudUvGRqQetx93BSL3j7JN8VHKWQHsRYp0RtIoN7ZzWVPTxxkccIxh5gNqEBR95GQ0Bsq/6RqrqPvUjmX1BCOFnxRwv5mbeFNJBJhrnQpNHka+RVI58xgSUcwJsBkGnNIzL11sUgKEEW9oeUhtwxuj1N1bjrPqIiHXKO/aJ9Jwjd2qJn5EBQqc9tnPkyKEjB+4rVbMe/C1XJqJZ8hRxewCqdpv8Ir+0x7XPkhqyTV03UqUFCg3c1gJigl1zj497GXCJtcvJYl5Mx3c8NOEIks+PDF0Tup3GS5dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the Live Update file handler callbacks to preserve a vfio-pci
device across a Live Update. Subsequent commits will enable userspace to
then retrieve this file after the Live Update.

State about each device is serialized into a new ABI struct,
vfio_pci_core_device_ser. The contents of this struct are preserved
across the Live Update to the next kernel using a combination of
Kexec-Handover (KHO) to preserve the page(s) holding the struct, and
the Live Update Orchestrator (LUO) to preserve the physical address of
the struct.

For now, the only contents of struct vfio_pci_core_device_ser are the
device's PCI segment number and BDF, ensuring the device can be uniquely
identified after the Live Update.

Key design notes and constraints:

 * Device state before kexec: Userspace is required to disable
   interrupts on the device and ensure it is in the D0 power state.
   This ensures the device does not send any interrupts until new
   handlers are set up by the next kernel.

 * Device reset during freeze: The device is reset and its state
   is restored in the freeze() callback, ensuring the next kernel
   receives it in a consistent state. Eventually, this will be
   dropped so the device can be preserved in a running state, but
   that requires further work in VFIO and the core PCI layer.

 * FD usability after freeze: Once the device is frozen, the VFIO
   device FD becomes unusable (i.e., ioctls and memory accesses will
   return errors) because the device may have already been reset.
   If the freeze operation fails, userspace must close the FD and
   reinitialize the device.

 * Lifecycle: LUO holds a reference to this file while it is preserved.
   Therefore, VFIO is guaranteed that vfio_df_device_last_close() will
   not be called on this device until userspace has unpreserved the
   file via LUO.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/Kconfig               |   2 +-
 drivers/vfio/pci/vfio_pci_config.c     |   3 +
 drivers/vfio/pci/vfio_pci_core.c       |  15 ++
 drivers/vfio/pci/vfio_pci_liveupdate.c | 198 ++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_priv.h       |   9 ++
 include/linux/kho/abi/vfio_pci.h       |  15 ++
 include/linux/vfio_pci_core.h          |   3 +
 7 files changed, 242 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index c12d614fc6c4..d97c809599fa 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -45,7 +45,7 @@ config VFIO_PCI_IGD
 
 config VFIO_PCI_LIVEUPDATE
 	bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
-	depends on PCI_LIVEUPDATE
+	depends on PCI_LIVEUPDATE && VFIO_DEVICE_CDEV
 	help
 	  Support for preserving devices bound to vfio-pci across a Live
 	  Update. This option should only be enabled by developers working on
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index a10ed733f0e3..a51805515d30 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -406,6 +406,9 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
 	struct pci_dev *pdev = vdev->pdev;
 	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 
+	if (vfio_pci_dev_is_frozen(vdev))
+		return false;
+
 	/*
 	 * Memory region cannot be accessed if device power state is D3.
 	 *
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f31e59e5badb..c312b0eaf7d0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1087,6 +1087,9 @@ int vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 	struct pci_dev *pdev = vdev->pdev;
 	int i, ret;
 
+	if (vfio_pci_dev_is_frozen(vdev))
+		return -EIO;
+
 	switch (info->index) {
 	case VFIO_PCI_CONFIG_REGION_INDEX:
 		info->offset = VFIO_PCI_INDEX_TO_OFFSET(info->index);
@@ -1513,6 +1516,9 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	void __user *uarg = (void __user *)arg;
 
+	if (vfio_pci_dev_is_frozen(vdev))
+		return -EIO;
+
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
 		return vfio_pci_ioctl_get_info(vdev, uarg);
@@ -1567,6 +1573,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 	struct vfio_pci_core_device *vdev =
 		container_of(device, struct vfio_pci_core_device, vdev);
 
+	if (vfio_pci_dev_is_frozen(vdev))
+		return -EIO;
+
 	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
 	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
 		return vfio_pci_core_pm_entry(vdev, flags, arg, argsz);
@@ -1591,6 +1600,9 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	int ret;
 
+	if (vfio_pci_dev_is_frozen(vdev))
+		return -EIO;
+
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
 
@@ -1775,6 +1787,9 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 	u64 phys_len, req_len, pgoff, req_start;
 	void __iomem *bar_io;
 
+	if (vfio_pci_dev_is_frozen(vdev))
+		return -EIO;
+
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 803528c9f1b2..e6eb7f6b53d7 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -6,28 +6,221 @@
  * David Matlack <dmatlack@google.com>
  */
 
+/**
+ * DOC: VFIO PCI Preservation via LUO
+ *
+ * VFIO PCI devices can be preserved over a kexec using the Live Update
+ * Orchestrator (LUO) file preservation. This allows userspace (such as a VMM)
+ * to transfer an in-use device to the next kernel.
+ *
+ * .. note::
+ *    The support for preserving VFIO PCI devices is currently *partial* and
+ *    should be considered *experimental*. It should only be used by developers
+ *    working on expanding the support for the time being.
+ *
+ *    To avoid accidental usage while the support is still experimental, this
+ *    support is hidden behind a default-disable config option
+ *    ``CONFIG_VFIO_PCI_LIVEUPDATE``. Once the kernel support has stabilized and
+ *    become complete, this option will be enabled by default when
+ *    ``CONFIG_VFIO_PCI`` and ``CONFIG_PCI_LIVEUPDATE`` are enabled.
+ *
+ * Usage Example
+ * =============
+ *
+ * VFIO PCI devices can be preserved across a kexec by preserving the file
+ * associated with the device in a LUO session::
+ *
+ *   device_fd = open("/dev/vfio/devices/vfioX");
+ *   ...
+ *   ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, { ..., device_fd, ...});
+ *
+ * .. note::
+ *    LUO will hold an extra reference to the device file for as long as it is
+ *    preserved, so there is no way for the file to be destroyed or the device
+ *    to be unbound from the vfio-pci driver while it is preserved.
+ *
+ * Retrieving the file after kexec is not yet supported.
+ *
+ * Restrictions
+ * ============
+ *
+ * The kernel imposes the following restrictions when preserving VFIO devices:
+ *
+ *  * The device must be bound to the ``vfio-pci`` driver.
+ *
+ *  * ``CONFIG_VFIO_PCI_ZDEV_KVM`` must not be enabled. This may be relaxed in
+ *    the future.
+ *
+ *  * The device must not be an Intel display device. This may be relaxed in
+ *    the future.
+ *
+ *  * The device file descriptor must be obtained by opening the VFIO character
+ *    device (``/dev/vfio/devices/vfioX``) and not via
+ *    ``VFIO_GROUP_GET_DEVICE_FD``.
+ *
+ *  * The device must meet following conditions prior to kexec without which the
+ *    ``reboot(LINUX_REBOOT_CMD_KEXEC)`` syscall (to initiate the kexec) will
+ *    fail.
+ *
+ *    - The device must have interrupt disabled.
+ *    - The device must be in D0 state.
+ *
+ * In addition, the device must meet all of the restrictions imposed by the
+ * core PCI layer documented at :doc:`/PCI/liveupdate`.
+ *
+ * Preservation Behavior
+ * =====================
+ *
+ * The eventual goal of this support is to avoid disrupting the workload, state,
+ * or configuration of each preserved device during a Live Update. This would
+ * include allowing the device to perform DMA to preserved memory buffers and
+ * perform P2P DMA to other preserved devices. However, there are many pieces
+ * that still need to land in the kernel.
+ *
+ * For now, VFIO only preserves the following state for devices:
+ *
+ *  * The PCI Segment, Bus, Device, and Function numbers of the device. The
+ *    kernel guarantees the these will not change across a kexec when a device
+ *    is preserved.
+ *
+ * Since the kernel is not yet prepared to preserve all parts of the device and
+ * its dependencies (such as DMA mappings), VFIO currently resets and restores
+ * preserved devices back into an idle state during kexec, before handing off
+ * control to the next kernel. This will be relaxed in future versions of the
+ * kernel once it is safe to allow the device to keep running across kexec.
+ */
+
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
+#include <linux/kexec_handover.h>
 #include <linux/kho/abi/vfio_pci.h>
 #include <linux/liveupdate.h>
 #include <linux/module.h>
+#include <linux/vfio.h>
 
 #include "vfio_pci_priv.h"
 
 static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
 					     struct file *file)
 {
-	return false;
+	struct vfio_device *device = vfio_device_from_file(file);
+	struct vfio_pci_core_device *vdev;
+	struct pci_dev *pdev;
+
+	if (!device)
+		return false;
+
+	/* Live Update support is limited to cdev files. */
+	if (!vfio_device_cdev_opened(device))
+		return false;
+
+	if (device->ops != &vfio_pci_ops)
+		return false;
+
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	pdev = vdev->pdev;
+
+	/*
+	 * Don't support specialized vfio-pci devices for now since they haven't
+	 * been tested.
+	 */
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || vfio_pci_is_intel_display(pdev))
+		return false;
+
+	/* Only non-VFs are supported for now. */
+	if (pdev->is_virtfn)
+		return false;
+
+	return true;
 }
 
 static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 {
-	return -EOPNOTSUPP;
+	struct vfio_device *device = vfio_device_from_file(args->file);
+	struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_core_device *vdev;
+	struct pci_dev *pdev;
+	int ret;
+
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	pdev = vdev->pdev;
+
+	ret = pci_liveupdate_preserve(pdev);
+	if (ret)
+		return ret;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser)) {
+		ret = PTR_ERR(ser);
+		goto err_unpreserve;
+	}
+
+	ser->bdf = pci_dev_id(pdev);
+	ser->domain = pci_domain_nr(pdev->bus);
+
+	args->serialized_data = virt_to_phys(ser);
+	return 0;
+
+err_unpreserve:
+	pci_liveupdate_unpreserve(pdev);
+	return ret;
 }
 
 static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
 {
+	struct vfio_device *device = vfio_device_from_file(args->file);
+
+	pci_liveupdate_unpreserve(to_pci_dev(device->dev));
+	kho_unpreserve_free(phys_to_virt(args->serialized_data));
+}
+
+static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
+{
+	struct vfio_device *device = vfio_device_from_file(args->file);
+	struct vfio_pci_core_device *vdev;
+	struct pci_dev *pdev;
+
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	pdev = vdev->pdev;
+
+	guard(mutex)(&device->dev_set->lock);
+	guard(mutex)(&vdev->igate);
+	guard(rwsem_write)(&vdev->memory_lock);
+
+	/*
+	 * Userspace must disable interrupts on the device prior to freeze so
+	 * that the device does not send any interrupts until new interrupt
+	 * handlers have been established by the next kernel.
+	 */
+	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
+		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
+		return -EINVAL;
+	}
+
+	if (pdev->current_state != PCI_D0) {
+		pci_err(pdev, "Freeze failed! Device not in D0 state.\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Reset is a temporary measure to provide kernel after kexec a clean
+	 * device while VFIO live update work is under development and not
+	 * fully supported. It will go away once continuous DMA support is
+	 * added to device preservation.
+	 */
+	vfio_pci_zap_bars(vdev);
+	vfio_pci_dma_buf_move(vdev, true);
+	vfio_pci_core_try_reset(vdev);
+	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
+	/*
+	 * Userspace cannot use the FD correctly now irrespective of liveupdate
+	 * freeze failing or succeeding. They will have to reinitialize the VFIO
+	 * device to continue using it as reset might have loaded default PCI
+	 * state. Disable ioctl, read, write and mmap access to the device.
+	 */
+	smp_store_release(&vdev->liveupdate_frozen, true);
+	return 0;
 }
 
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
@@ -43,6 +236,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
 	.can_preserve = vfio_pci_liveupdate_can_preserve,
 	.preserve = vfio_pci_liveupdate_preserve,
 	.unpreserve = vfio_pci_liveupdate_unpreserve,
+	.freeze = vfio_pci_liveupdate_freeze,
 	.retrieve = vfio_pci_liveupdate_retrieve,
 	.finish = vfio_pci_liveupdate_finish,
 	.owner = THIS_MODULE,
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 5d2ad128523d..4b65753e8936 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -145,6 +145,11 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
 #ifdef CONFIG_VFIO_PCI_LIVEUPDATE
 int __init vfio_pci_liveupdate_init(void);
 void vfio_pci_liveupdate_cleanup(void);
+static inline bool vfio_pci_dev_is_frozen(struct vfio_pci_core_device *vdev)
+{
+	/* Written in VFIO PCI Liveupdate during freeze() event */
+	return smp_load_acquire(&vdev->liveupdate_frozen);
+}
 #else
 static inline int vfio_pci_liveupdate_init(void)
 {
@@ -154,6 +159,10 @@ static inline int vfio_pci_liveupdate_init(void)
 static inline void vfio_pci_liveupdate_cleanup(void)
 {
 }
+static inline bool vfio_pci_dev_is_frozen(struct vfio_pci_core_device *vdev)
+{
+	return false;
+}
 #endif /* CONFIG_VFIO_PCI_LIVEUPDATE */
 
 #endif
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
index 67e8199eec59..229a13ac1e52 100644
--- a/include/linux/kho/abi/vfio_pci.h
+++ b/include/linux/kho/abi/vfio_pci.h
@@ -9,6 +9,9 @@
 #ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
 #define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
 
+#include <linux/compiler.h>
+#include <linux/types.h>
+
 /**
  * DOC: VFIO PCI Live Update ABI
  *
@@ -25,4 +28,16 @@
 
 #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
 
+/**
+ * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
+ * device.
+ *
+ * @domain: The device's PCI domain number (segment).
+ * @bdf: The device's PCI bus, device, and function number.
+ */
+struct vfio_pci_core_device_ser {
+	u32 domain;
+	u16 bdf;
+} __packed;
+
 #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 5fc6ce4dd786..adc5d05456bd 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -143,6 +143,9 @@ struct vfio_pci_core_device {
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
 	struct list_head	dmabufs;
+#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
+	bool			liveupdate_frozen;
+#endif
 };
 
 enum vfio_pci_io_width {
-- 
2.55.0.795.g602f6c329a-goog


