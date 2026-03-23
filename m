Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F29EF532C3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F426B00AC; Mon, 23 Mar 2026 19:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307096B00AD; Mon, 23 Mar 2026 19:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F60F6B00AE; Mon, 23 Mar 2026 19:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0210F6B00AC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1499160CF2
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:01 +0000 (UTC)
X-FDA: 84578996082.05.2888BB9
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0B9D81C0006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p1dxQUO0;
	spf=pass (imf18.hostedemail.com: domain of 3wtPBaQgKCMUoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3wtPBaQgKCMUoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDvzsZ/wW7otbfhEhu+LWvOHypwI+AXZcNsT2i6QVdU=;
	b=qUh65fUUhVpdqWHhTMPX8ftkctooeSDvY3Nk+WDas8enAA9WRfk7A+OfTB/wLFUA9TX75Y
	pvTKrUrl/KZzoA7RRexQH3+V6XDIX0kUJ9wc5DNg/9KngeXIWpY/3NUJK+LDs9V6cRF8gY
	KcYBWwx1wUkKQjBqdCplZD6ZOiZduHQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p1dxQUO0;
	spf=pass (imf18.hostedemail.com: domain of 3wtPBaQgKCMUoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3wtPBaQgKCMUoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310340; a=rsa-sha256;
	cv=none;
	b=z6hiXINz/w0c3HY9PvWzkzGbgLeb1Nfqs8VI6n1ZF9XqXjlHUIV59EwVNuogJ4aQPIfmEV
	R5v6KRu8dBS1wpbTMqm3KFgGEnxyx+klMuxgdzGN6AKTIy72IL2w6z3ktJkjRU372/lMrz
	2iPXw8GCmGkohCxpCYR5ZgMf0GizeGs=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b0565d77a6so10203155ad.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310339; x=1774915139; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WDvzsZ/wW7otbfhEhu+LWvOHypwI+AXZcNsT2i6QVdU=;
        b=p1dxQUO0IJtbyh+Qypkgupe6AvgzfrcNJgwRjzD8Nl5VrVPWL+LrFYRwXgPKEvjPG9
         sD4qHtPk9rxv0aYn8PuimzgYlzw50iNRVBJRfuEu1V2Yn7YnpQX2tQNP4zZ/Q3HaAibv
         wmi802T94GipmKw3jwNOLo92qK0yKcKMy3k3R6aA6R0gdCeqcvmmD2s31SzDj2GXUWEj
         g2+Nt6Cp75zmgfk125e00ojlWkt1BUs5BkRhX247DYV4xsU8NaRrv++5V4fTGED8E79P
         tiP9ECY21FGz4F7o5oCccPzlyweXoZKRLjiKdIeVPSpsDDZcZrqvtyc+/iO/OQmGD3ad
         POaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310339; x=1774915139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WDvzsZ/wW7otbfhEhu+LWvOHypwI+AXZcNsT2i6QVdU=;
        b=DB5HHwtIPFLCyuJ0U5mEvG0VfGIvN4HoU0M2a1tSV1DQeY036yVrgow+RpTCGmrbGI
         VM5R68p5Nmj+QGjvqlW/nzNej9CpykekL6fpwKz61BhW/mS/XhhzEeHmQPdI0r/noGoE
         LMwWoWPwXP6KkfqA2JfUGv6x8e9+FhZ3tZEHNVQRpU6plvI5k0/AmaUdzBn6UorEybdr
         gk79ii+lfsKYtKJeskeM8efN06NwN0khbR8PP+bb6Pc4RqmQKWHc6TPhtOr+wWO90j4N
         BZjZKG4m3T4KTmgIaw42NQd+GhHjuyU7u0qFq290xstXdZV4ZSxD2i9Hr5Lq634+6nep
         S+/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX08ZqeUcf6S8npCIpi4sJYVNGuFkv7f62BYXe4kEGaFe3+0Pso/gmGah+xIl7Ba3zSdGJCsBlung==@kvack.org
X-Gm-Message-State: AOJu0Yymd/LPxrOs9gCUDkD3tOJzps29hFxHcrbZ0gh87BKudCl9arc8
	qEQy219I3f0VMpgETBMWLqGR9w+WBn7JZWgRpFjF3ssqtk+rpUHXv190esB/NDydCuG7WAO3Ezu
	GriogbTVPf97FSw==
X-Received: from pldt15.prod.google.com ([2002:a17:903:40cf:b0:2b0:59ce:931b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1c7:b0:2b0:5fa5:a68c with SMTP id d9443c01a7336-2b0826b9030mr140489925ad.9.1774310338569;
 Mon, 23 Mar 2026 16:58:58 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:04 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-13-dmatlack@google.com>
Subject: [PATCH v3 12/24] vfio/pci: Skip reset of preserved device after Live Update
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B9D81C0006
X-Stat-Signature: gqaa3s8xnaoi7y7fwuqennxjk1dtmemg
X-Rspamd-Server: rspam06
X-HE-Tag: 1774310339-577303
X-HE-Meta: U2FsdGVkX1/yl70FQLplmqEq+YtYSHPH5qvbvQIQ7H+OwUlEP3mh7arXLUCKLlaE4SxPkkFkP+V+i/FS3yRgVEFfBaaAbJ4aL3mujBju/5MkkeAFWNkiWhITK5zJGG+Hi42R9BgKLUC6GyHeo8FZ1ofzcbRPk/jG+gDpM8MG0TFioBqCywpSvQculkOfCl9KGyZwhYiKwqAP2RkgoI6do51DhK1G+T0J0gMjwQC3l8YW2q0v7oHtrdzb0npkEg2jKGji6r3K3+wIQyUibq749M6vFWIwIRR/yhZuo/ic5jNAY46CRZsRGKe58wAPD/uI4xSk1xFJtDnFmvA+Wc7r4d9cWFOGB24Iey6azH7e9xahIiZ37rPqBMjOPDh4YaVozctVo+Y4ExfWmzSr+ff4ZBpBVW7LXT47BJGCG8huMvHxlKAyrn6zglqsMfg1zVQUbD7L9pZS79+ISt9T3XDc8jpY4n7vpLx2Qyg8apWxARJZap4V7qzUyeorwSRoVuRTY+niSbXg1in3eX9GfECPLM3ZDILGEq0Jz/rAlWFXFXc7uyNM/YNlspTRXV/ZIMlWHx46s8hsoA5LM6aEXhP1meZ0s+DFWOokO9Fc7eA2PTVnKwm8ujvUWZjvexexiCj3FkdLIj6e+MOy1E7kCstZCdRRKr+TYHml2OwLUeYrzuYWkB+Y1CqFDjdWwMxBC1kkwiwflRZpLKdNFuxfc+B6DmIl7irGGk60a6GI21cbrqrWCzAua91j/MhnT/8BBj4R3Fr1k40QdjQKfltwzndjxQen/vNXKKMByl/gsEOBVh9Dlq5JvGgYnhxREHc52pr8SNINbVRHFsVDIoKyXR4lhIzW+fcPuz83uhXhmkav9f4etiVcq3sBRkdH2q3yYn4j7GnX1A7CLbygZZBOxYWINM3A/TPLB1vkj8UMLULVuq5v9G9nzQQWZY16dAAk92BSIAqX+amkjwGLsRT+vSU
 9zweX+lh
 2UnD41NQa5foWLnUoJCozKuZ1HhQ0qFKLiWMDw9u7gi9/KeJSHj/7yF2GWIFfzrKjUhfl/HtqkQX/YLxofsi4ik7gi0OCX78jCitddt4++bVIPkvKrD+Fr9jYlhjwH+ns6WI//e2yIOzMln1WbeEr1EWlar10kKFYjABeSHsZ/k+SWIl+at+jkku6CzqHjAfhGW6WwjkbNAnHx8f3W+P5QvoMTXlWpdIy7eqxBG0yVH2/rrucedO9Q/invYouTsUAq8JPD8aDhTqqDbkmfsjP9pNTM+a4mR+mYn1gnfF2/X/0Lh+q0xHes+5fJ2eBnM1NK9cBLj6Je5ORlOAV1IstcTqM7Kcu4h9qmsgIN+KNu6w+a//w+IU3EmzPxUViOarsGCGA2FrRFGZDfKUbneRkZsTSC5Ug/RlS3lKIIy7Yls2kXFH2L5TfmOMb1JSwOWaDZtwNJ8ws6iIlzc0Kx2jwBUp9jVzI+xeuQPGL9IGeUmzFbBEJx2PWC5OxEgDiniMzXwwBh9so6xfX0D7h1cVExpZLEPsg24DhihCrovw4LHiO6SJlZN4B4eHo0p3iFupeQr7wh2FsnHvzkc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Do not reset the device when a Live Update preserved vfio-pci device is
retrieved and first enabled. vfio_pci_liveupdate_freeze() guarantees the
device is reset prior to Live Update, so there's no reason to reset it
again after Live Update.

Since VFIO normally uses the initial reset to detect if the device
supports function resets, pass that from the previous kernel via
struct vfio_pci_core_dev_ser.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c       | 31 ++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_liveupdate.c |  4 ++++
 include/linux/kho/abi/vfio_pci.h       |  4 +++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d7c472cf4729..849a3b57d56b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -16,6 +16,7 @@
 #include <linux/file.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
+#include <linux/kho/abi/vfio_pci.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
@@ -494,6 +495,30 @@ static const struct dev_pm_ops vfio_pci_core_pm_ops = {
 			   NULL)
 };
 
+static int vfio_pci_core_probe_reset(struct vfio_pci_core_device *vdev)
+{
+	int ret;
+
+	/*
+	 * This device was preserved by the previous kernel across a Live
+	 * Update, so it does not need to be reset and reset_works can be
+	 * inherited from the previous kernel.
+	 */
+	if (vdev->liveupdate_incoming_state) {
+		vdev->reset_works = vdev->liveupdate_incoming_state->reset_works;
+		return 0;
+	}
+
+	ret = pci_try_reset_function(vdev->pdev);
+
+	/* Bail if the device lock cannot be acquired. */
+	if (ret == -EAGAIN)
+		return ret;
+
+	vdev->reset_works = !ret;
+	return 0;
+}
+
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -514,12 +539,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (ret)
 		goto out_power;
 
-	/* If reset fails because of the device lock, fail this path entirely */
-	ret = pci_try_reset_function(pdev);
-	if (ret == -EAGAIN)
+	ret = vfio_pci_core_probe_reset(vdev);
+	if (ret)
 		goto out_disable_device;
 
-	vdev->reset_works = !ret;
 	pci_save_state(pdev);
 	vdev->pci_saved_state = pci_store_saved_state(pdev);
 	if (!vdev->pci_saved_state)
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 8d6681e1d328..874c821bf6eb 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -91,6 +91,9 @@
  *    kernel guarantees the these will not change across a kexec when a device
  *    is preserved.
  *
+ *  * Whether or not the device supports function resets. This is necessary to
+ *    avoid resetting the device after kexec to probe for reset support.
+ *
  * Since the kernel is not yet prepared to preserve all parts of the device and
  * its dependencies (such as DMA mappings), VFIO currently resets and restores
  * preserved devices back into an idle state during kexec, before handing off
@@ -162,6 +165,7 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 
 	ser->bdf = pci_dev_id(pdev);
 	ser->domain = pci_domain_nr(pdev->bus);
+	ser->reset_works = vdev->reset_works;
 
 	args->serialized_data = virt_to_phys(ser);
 	return 0;
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
index 876aaf81dd92..c057794a044f 100644
--- a/include/linux/kho/abi/vfio_pci.h
+++ b/include/linux/kho/abi/vfio_pci.h
@@ -26,7 +26,7 @@
  * incrementing the version number in the VFIO_PCI_LUO_FH_COMPATIBLE string.
  */
 
-#define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
+#define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v2"
 
 /**
  * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
@@ -34,10 +34,12 @@
  *
  * @domain: The device's PCI domain number (segment).
  * @bdf: The device's PCI bus, device, and function number.
+ * @reset_works: Non-zero if the device supports function resets.
  */
 struct vfio_pci_core_device_ser {
 	u32 domain;
 	u16 bdf;
+	u8 reset_works;
 } __packed;
 
 #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
-- 
2.53.0.983.g0bb29b3bc5-goog


