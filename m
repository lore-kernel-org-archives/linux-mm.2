Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D20ACAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 02:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690AB8E000F; Tue, 16 Sep 2025 22:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F59D8E0001; Tue, 16 Sep 2025 22:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4508E000F; Tue, 16 Sep 2025 22:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A72F8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:50:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A76D1A03D3
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:47 +0000 (UTC)
X-FDA: 83897214534.29.9A22463
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 37EE74000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:50:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PATYt9WR;
	spf=pass (imf11.hostedemail.com: domain of 3AyLKaAgKCLwlcuqpokwiqqing.eqonkpwz-oomxcem.qti@flex--jasonmiu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3AyLKaAgKCLwlcuqpokwiqqing.eqonkpwz-oomxcem.qti@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758077445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSn2CmdF8+yf4DtOsVnJBkMWdMtw6s5eBLN2Lm9vVpQ=;
	b=Sv2+6nt2mdiJOHT15zmM38yKamCVdGw2PaegmsVtzj1ug8St9JQB9tsW3QwJ/n6UBiIkJr
	P3C9RZFkKfIvrjaAZsVMlZBhJzCiWpV5Gm62nvSmT/1pvThDHCSbWzIMb3a3TU7DHyw/xu
	ufJORlYwFKqgCdKtF4AaX4OmFL73axA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PATYt9WR;
	spf=pass (imf11.hostedemail.com: domain of 3AyLKaAgKCLwlcuqpokwiqqing.eqonkpwz-oomxcem.qti@flex--jasonmiu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3AyLKaAgKCLwlcuqpokwiqqing.eqonkpwz-oomxcem.qti@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758077445; a=rsa-sha256;
	cv=none;
	b=wR8tGHmgDolWI9UFTZJS/qbOiXgohk3nwvSiX8jqXrCT1uYSDh+xF8nZiT8YMTmiaAm0/v
	jciPem85+OfDO83ONjIPz+Av7WR6/55Xz0WidNcOCCkcONFZdiF/fFXCd/UxwGtHSv/MyP
	Q/LuSLZe/2bRjSBFI+1WdT2sgpXRRTg=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ea857e58bso1596525a91.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758077444; x=1758682244; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lSn2CmdF8+yf4DtOsVnJBkMWdMtw6s5eBLN2Lm9vVpQ=;
        b=PATYt9WR+/V7pPulEm/r6jaDD+lSSnj4OcjZi+2AYsGxkX0Og0UCKaVLpkSzoTAotY
         H4S+1O4tbtTDLhvUJjHnzbXq0bw7TmrYUvguSx5F/4r8HhIymQ7V9j2Pl0rwVHuo5BaD
         GFjMFWFJU91TpAJ+6zSKXcXIqoZwDYUsd6d8pgcdjblFbYSm4VZKOUTkkz50ylHIFzOb
         w/EAgK2QX11NP0r3cwDanb++7af3XK9bV1ZT5oTvSocEP5M3B+5vo2pguhoJ/gm6dPLU
         NCcTPsH7hrHXl0acMmQwFcb+Vw+dUpkRUa+mEaSEQemsx+0J+XURDdJaHLP2qclawl3c
         hR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758077444; x=1758682244;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lSn2CmdF8+yf4DtOsVnJBkMWdMtw6s5eBLN2Lm9vVpQ=;
        b=A8XKGLrOji/A7/CZ8iNx0D12iC/78bqEbEbS8PPLu4S9h8b0K/BHRgPNLXn19awS3J
         5g1dqYe0VgCxKcsbVBWi4AP2xhJ15Cl5uqtW7F7l9MlxFhaS+N3Ye5clN5iQWKF1kIgq
         tWTgEoF80O/+CGod9K+QeV9UCMzvRnfRExY/snRqMjDlcgQz+r84Ye40WzoHLgu2ujna
         d5LFH4HaeWNzrGrIxmJCeHYJcam7cFweh2c9v5tkUfVU0Yb24FMPxfCUIVIMbknOSq1L
         Ce1cJUeyM2t4QSmbfxITKvXFGoBGRA/mayNhOT1VbPdC4LBc0MwHTtnr1g1os6R2n/3a
         /Dug==
X-Forwarded-Encrypted: i=1; AJvYcCUQfaDgIhcyDMKJz1H28o9GCeG4mFf9zwny9H4w03Ro6XCJK1UtZChP/Y2wmzhn8Rn8QUfv+im4WA==@kvack.org
X-Gm-Message-State: AOJu0YwT5LSoHXmuJ5jBYAQjbfhZpCl70hgJGJHQhD9J05sOd9QIhgX6
	W0qIeRTc9kYbhwZvVnEGgmOlnVDcxmGpanTWELYHsT+CVUV1l7US77GvzyIKwJvfYWd9Zy/5XDt
	a8IYmm9uYJ9cNSA==
X-Google-Smtp-Source: AGHT+IHQ74t+zzjdi8h+z/5IY48HHRSYodyFCrNO4puZo9tU2iy1v7RraJy6Ayld7eqRNTEp/i2TMXedcJZ7fA==
X-Received: from pjbdy13.prod.google.com ([2002:a17:90b:6cd:b0:32e:2c41:7def])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4fcf:b0:32b:9774:d340 with SMTP id 98e67ed59e1d1-32ee3f65f8fmr715320a91.33.1758077443958;
 Tue, 16 Sep 2025 19:50:43 -0700 (PDT)
Date: Tue, 16 Sep 2025 19:50:18 -0700
In-Reply-To: <20250917025019.1585041-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250917025019.1585041-4-jasonmiu@google.com>
Subject: [RFC v1 3/4] memblock: Remove KHO notifier usage
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, 
	Joel Granados <joel.granados@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 37EE74000A
X-Stat-Signature: iyhi6m19j8ks3tap7ina3hwtgufiy51z
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758077445-944086
X-HE-Meta: U2FsdGVkX1+hEcpzx0yxE+HoQcAqlw2BtXs1D18XMr/TxLPe55O0ZJY3t3HkWsCXvPf5dPgEuAftwj02m7zSnzqi+ZYFYGod6lWaw4TtsSmd9kiV78XX58nU05eHnc2TkACSqYUbYf/H1kViCzwSrWaD6H3zhfoXIo8dbCwpAMbUHdgPAB1UMy6IWrqcTkUCB6p6GZFWq7ig8abJxmMmVUnDRRg8CH3w8By55R1GrRnvhodOSEeXVuZIrYz9dE14rbhaaiZwFW/Kgt8dZ//xCSj2XgfRwdHDMvrw02C3wHoeCF1OBry13URsqr9U6SBf0KW14W7vsHkc+L8XjwCV/sNeNuI17234YL8ZbuCoSR09UgQcEag5unhaSXUiu/J3J+S3mD5vHs3pfbpttVl6M5E7J2bYaJzhzsYpmr+s9ndfzyWs/TeRnIq7zABOZfwa9WSW+W7bg+xbtTiLAD2+kAPBp+SYiXVotp3dsqJ7ol7g4qvU3c4xp5ZKvXAq+4WsJar90dO7V7c6WvCCPhYdt5GgVeXc2m6eIPrDBZj1pc87z9U9+wx2rECO9iNlzUlYxgGr0eIDrmnhomByimgr5XePU6fks1bB1aT8R7DEfuq/tHiZZEm7ODd9hTJ7xS2cG2Q02CzhJlfzMQOp/+mq4wWK9U/LxPTp6juKwtho8HP1IELcEAOlPEZg3QdQiueCggDiSTSpSB+p8VwgB4c1rdsiaQmVZI8M1212ovO8k6qANJP/zX3k8vpVW2uq0jVSv1XDcCIGHYI1fW2MuJs5o5R/3iDzBxv8RCZDR1mfqdNDEpsYKenQhuxmNYHxFjDhIrGZ3CfymE7gfIuq6F/SHq9GUAPbfpOlglzB/Weh5+cqGu9bkqUdAR/zfyH8PhCqBlqtAb03esBRNVJxcM5ppLa08lYZj8fFSAEzKNCnkKxo553i0By8Lm5hDZ3xCJa1G58zsQ9j2I0hZZhGPGu
 jikpVcYW
 417DR6LFGZSz0s71BVyuqXRKBrQ1CaLvHdWRIO4IrL//mo6bEZz2zj2CyKn71GrOc003ElDxra04TDQsQjVrtdFufKrC/KUncRsrf9gtfgIHdsLaUz3VC0OpYdc3doeD9hz5cY8f0h2ZC/ELsf9gI/OjgOhAMZd3HSZW86kwsojBU5Xrzzj/qJYWELxmr33tToZqdvKET3++L3nzrVYBewJhfTLcgbZ9zh/FpT7RC+uLQ2S+EL9FIHDyxhMDdjvxNYNguJ6MaJL00YmHbr/NkLXBjcGLqDauNd7vm+CIPje2DT8pQT28pNXeSOPW4esKBJWHYmeRgVSuksVH6grwBmHb2GxQT628oOd71kAL5owlv/KTEbgCeuK6nj5RPiOBZhylfDkkfFJOhlReb8QNneFqEXJ2uIyJbj/HmDz2hYQQ+9jxBIcoLqCCP8gTNi4dmRUXlcdT5a1yn+O2qFgasG+NJzaGQkYjROO4d7ptamR1NLwzvVRfTkWapllVsdqrdRmMFsowip8Prhx/e65odNlKESHx7H5VTS+eSTSpCHO5vKZ4mp0G9tNE9TZeXSoQldhSjkWBPDEpvLkwtarTDmYh16A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update memblock to use direct KHO API calls for memory preservation.

Remove the KHO notifier registration and callbacks from the memblock
subsystem. These notifiers were tied to the former KHO finalize and
abort events, which are no longer used.

Memblock now preserves its `reserve_mem` regions and registers its
metadata by calling kho_preserve_phys(), kho_preserve_folio(), and
kho_add_subtree() directly within its initialization function. This is
made possible by changes in the KHO core to complete the FDT at a
later stage, during kexec.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 include/linux/kexec_handover.h |  7 ++----
 kernel/kexec_core.c            |  4 +++
 kernel/kexec_handover.c        | 46 +++++++++++++++++++++-------------
 kernel/kexec_internal.h        |  2 ++
 mm/memblock.c                  | 46 ++++++++--------------------------
 5 files changed, 47 insertions(+), 58 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index c8229cb11f4b..e29dcf53de7e 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -19,15 +19,13 @@ enum kho_event {
 struct folio;
 struct notifier_block;
 
-struct kho_serialization;
-
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
 struct folio *kho_restore_folio(phys_addr_t phys);
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
 int register_kho_notifier(struct notifier_block *nb);
@@ -58,8 +56,7 @@ static inline struct folio *kho_restore_folio(phys_addr_t phys)
 	return NULL;
 }
 
-static inline int kho_add_subtree(struct kho_serialization *ser,
-				  const char *name, void *fdt)
+static inline int kho_add_subtree(const char *name, void *fdt)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 31203f0bacaf..3cf33aaded17 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1147,6 +1147,10 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	error = kho_commit_fdt();
+	if (error)
+		goto Unlock;
+
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		/*
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 578d1c1b9cea..f7933b434364 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -682,9 +682,21 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 	return 0;
 }
 
+struct kho_out {
+	struct blocking_notifier_head chain_head;
+	struct dentry *dir;
+	struct kho_serialization ser;
+};
+
+static struct kho_out kho_out = {
+	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
+	.ser = {
+		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
+	},
+};
+
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
- * @ser: serialization control object passed by KHO notifiers.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
  *
@@ -697,8 +709,9 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt)
 {
+	struct kho_serialization *ser = &kho_out.ser;
 	int err = 0;
 	u64 phys = (u64)virt_to_phys(fdt);
 	void *root = page_to_virt(ser->fdt);
@@ -714,19 +727,6 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-struct kho_out {
-	struct blocking_notifier_head chain_head;
-	struct dentry *dir;
-	struct kho_serialization ser;
-};
-
-static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
-	.ser = {
-		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
-	},
-};
-
 int register_kho_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
@@ -952,6 +952,7 @@ static int kho_out_fdt_init(void)
 	void *fdt = page_to_virt(kho_out.ser.fdt);
 	u64 *preserved_order_table;
 
+	/* Do not close the root node and FDT until kho_commit_fdt() */
 	err |= fdt_create(fdt, PAGE_SIZE);
 	err |= fdt_finish_reservemap(fdt);
 	err |= fdt_begin_node(fdt, "");
@@ -965,9 +966,6 @@ static int kho_out_fdt_init(void)
 
 	*preserved_order_table = (u64)virt_to_phys(kho_order_table);
 
-	err |= fdt_end_node(fdt);
-	err |= fdt_finish(fdt);
-
 abort:
 	if (err)
 		pr_err("Failed to convert KHO state tree: %d\n", err);
@@ -1211,6 +1209,18 @@ int kho_fill_kimage(struct kimage *image)
 	return 0;
 }
 
+int kho_commit_fdt(void)
+{
+	int err = 0;
+	void *fdt = page_to_virt(kho_out.ser.fdt);
+
+	/* Close the root node and commit the FDT */
+	err = fdt_end_node(fdt);
+	err |= fdt_finish(fdt);
+
+	return err;
+}
+
 static int kho_walk_scratch(struct kexec_buf *kbuf,
 			    int (*func)(struct resource *, void *))
 {
diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
index 228bb88c018b..490170911f5a 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -46,6 +46,7 @@ struct kexec_buf;
 int kho_locate_mem_hole(struct kexec_buf *kbuf,
 			int (*func)(struct resource *, void *));
 int kho_fill_kimage(struct kimage *image);
+int kho_commit_fdt(void);
 #else
 static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 				      int (*func)(struct resource *, void *))
@@ -54,5 +55,6 @@ static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
 }
 
 static inline int kho_fill_kimage(struct kimage *image) { return 0; }
+static inline int kho_commit_fdt(void) { return 0; }
 #endif /* CONFIG_KEXEC_HANDOVER */
 #endif /* LINUX_KEXEC_INTERNAL_H */
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c..978717d59a6f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2001 Peter Bergner.
  */
 
+#include "asm-generic/memory_model.h"
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -2510,39 +2511,6 @@ int reserve_mem_release_by_name(const char *name)
 #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
 static struct page *kho_fdt;
 
-static int reserve_mem_kho_finalize(struct kho_serialization *ser)
-{
-	int err = 0, i;
-
-	for (i = 0; i < reserved_mem_count; i++) {
-		struct reserve_mem_table *map = &reserved_mem_table[i];
-
-		err |= kho_preserve_phys(map->start, map->size);
-	}
-
-	err |= kho_preserve_folio(page_folio(kho_fdt));
-	err |= kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
-
-	return notifier_from_errno(err);
-}
-
-static int reserve_mem_kho_notifier(struct notifier_block *self,
-				    unsigned long cmd, void *v)
-{
-	switch (cmd) {
-	case KEXEC_KHO_FINALIZE:
-		return reserve_mem_kho_finalize((struct kho_serialization *)v);
-	case KEXEC_KHO_ABORT:
-		return NOTIFY_DONE;
-	default:
-		return NOTIFY_BAD;
-	}
-}
-
-static struct notifier_block reserve_mem_kho_nb = {
-	.notifier_call = reserve_mem_kho_notifier,
-};
-
 static int __init prepare_kho_fdt(void)
 {
 	int err = 0, i;
@@ -2583,7 +2551,7 @@ static int __init prepare_kho_fdt(void)
 
 static int __init reserve_mem_init(void)
 {
-	int err;
+	int err, i;
 
 	if (!kho_is_enabled() || !reserved_mem_count)
 		return 0;
@@ -2592,7 +2560,15 @@ static int __init reserve_mem_init(void)
 	if (err)
 		return err;
 
-	err = register_kho_notifier(&reserve_mem_kho_nb);
+	for (i = 0; i < reserved_mem_count; i++) {
+		struct reserve_mem_table *map = &reserved_mem_table[i];
+
+		err |= kho_preserve_phys(map->start, map->size);
+	}
+
+	err |= kho_preserve_folio(page_folio(kho_fdt));
+	err |= kho_add_subtree(MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
+
 	if (err) {
 		put_page(kho_fdt);
 		kho_fdt = NULL;
-- 
2.51.0.384.g4c02a37b29-goog


