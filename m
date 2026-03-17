Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D2DFD8777
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37B16B00B3; Tue, 17 Mar 2026 10:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FAE6B00B4; Tue, 17 Mar 2026 10:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CAA6B00B5; Tue, 17 Mar 2026 10:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0CBA6B00B3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:15:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A52AEB5BA3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:47 +0000 (UTC)
X-FDA: 84555753534.11.07F61A3
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id BEA74100012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ZQc/gEZA";
	spf=pass (imf14.hostedemail.com: domain of 3D2K5aQoKCA40qzo3w16ywu22uzs.q20zw18B-00y9oqy.25u@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3D2K5aQoKCA40qzo3w16ywu22uzs.q20zw18B-00y9oqy.25u@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pQdqVuW3s3IY2V2/GcIHf4+cwJRcBc6iC91+pnO9/s=;
	b=xVz9NvkRKi1obaSqGNdsnpVOw6rbwwTqPdvX9X0lxcJbqogEBK1KLB83C82WQXzdmXpgkq
	DzuqRllqpbD5m7VrsUMgzoqfBMNl/QGqrNf+AAA88qOIKdRr0/RKI5gNGvBNCJlevN+ZVV
	VutXFp3HygQ5L/l5mhN2aAMdN6A3DUc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ZQc/gEZA";
	spf=pass (imf14.hostedemail.com: domain of 3D2K5aQoKCA40qzo3w16ywu22uzs.q20zw18B-00y9oqy.25u@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3D2K5aQoKCA40qzo3w16ywu22uzs.q20zw18B-00y9oqy.25u@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756945; a=rsa-sha256;
	cv=none;
	b=SmwoPDTPjC6qDI+FffPx/2y+W+DXyl51TG5kSFaPE1ZVLTcz6Ts2t8YZtdOLDvhayYwJmb
	h8+7KFWi1tHU5PXG44nvOg1Q/76ZdUyQR2lwv14A4LomySJAjfAlyPPKORAgPGjvKQirX8
	bvHHmPob5fM9zxd/Fo/bl+QgAUTfjHA=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485397788b3so54364985e9.2
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773756944; x=1774361744; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6pQdqVuW3s3IY2V2/GcIHf4+cwJRcBc6iC91+pnO9/s=;
        b=ZQc/gEZAGrI+L94a/4EozRGx+3aS/tR15Yrf53+owIZtQIimniezjKOGkspyaUbMgY
         pymwcyBjsaW5AE40sbyM3gf4+uAu/YxLFtUIdO7ZqnyIUsGCwbdKH8r6KYw1Fm5zSapO
         CrdaHvgxZ4k3laupSr2DX+mcn0VKgmQO6hzQVpD+eLNpyFG0+Ggp5+ZkGgefuiaGpZW5
         svVVDnJIkIWj9T1F7zZB9axTuc3ids7ent4im9/mPRkUH44RjETfbkW5fAWDikWreKIk
         PnpQBOgH3V9neP4D2pJixxoQ22ocgZMxT3GGXT5NkjfOemrHfnv+ibS++b72LnJE9wJ2
         scdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756944; x=1774361744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6pQdqVuW3s3IY2V2/GcIHf4+cwJRcBc6iC91+pnO9/s=;
        b=MVeSXPop2AEV5rVYVTI5WmhrzinC/Nw7fpVQDvaOJI1oaemNx1JFdBmpjC2ewVm8wU
         K0q19wn4dw5Z26kwkdXeui+uDpLt1GOA41RvR2aspkKPJ9VkWu/wKA2PfNC3kPplVxeY
         ZSzm7n6gLCtF2WrQ7CgtlZsej+ri2BxuUfQ2EhfL2DxXOaHiAITyhRrrPUDy7xALkdMN
         6y9T4dtQN5IJf7CjJbfxEiKLMTIUyVIN3GTtIOxrXrXPHJ2u6Rl6RMb6Uy+LS5J+Kl03
         cCvFcDaZORsaIGky9offE8dHOXu+I+ovPdMWeW0NnGF+52ti6n8FEifA/+goLVAMtPlf
         AMLA==
X-Forwarded-Encrypted: i=1; AJvYcCWxkWp7c5+XJA9Q9k0rC/7XKkGKLFmYYgt9zaam8EaG0PKpc5nMWyhufpIFUQvf2VxqroWf7ZaBJg==@kvack.org
X-Gm-Message-State: AOJu0YxIuq2/00a77Q7ZwqXbVyPkkuuaDURv32TGPpvG8aMPw8oUilow
	m/PEKB8+Nk4GyKLGxrICxcAm0SCKSpO8xeQG1j1s2y92OQofJwwGWFGwRbRi7Efm8m3MumLzZT9
	Ga3WiIFFH5ME9uHrHXEAWLg==
X-Received: from wmz7.prod.google.com ([2002:a05:600c:6b67:b0:485:3aa2:da59])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4583:b0:485:3f17:410 with SMTP id 5b1f17b1804b1-485566fd031mr299341025e9.16.1773756943916;
 Tue, 17 Mar 2026 07:15:43 -0700 (PDT)
Date: Tue, 17 Mar 2026 15:15:32 +0100
In-Reply-To: <20260317141534.815634-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317141534.815634-2-mclapinski@google.com>
Subject: [PATCH v7 1/3] kho: make kho_scratch_overlap usable outside debugging
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BEA74100012
X-Stat-Signature: q48d67iggpjtabkss7mui9mdayeeznpi
X-Rspam-User: 
X-HE-Tag: 1773756945-531574
X-HE-Meta: U2FsdGVkX19/ke7+MqxNDNNT5pWCzLtFHPe18y3A7zBsw2sR+kdM7jS1UChXQPo4e5Bv/Q6RxRRHfZiNSw0TovQctlk5AnFzrYPct7Ygt41hMKiPtvradddgW9IeYKwnxWqm+3+kdhhkQjaUhs7ZnXpCnnYETd29V9PUC0l4exyRv6WgAqb38nzEYSfuZR9GkZ80drHB+kAAz14CV+lhqQoSWul26Cw0/jWKHr0GnvJ3sUJvkhv5dSV/hwH9FUCyZrLdP8MMJpF83dBGgv41k3eq9wf3HDkOPVjRLRRl24ggz/EdYzQw6w7vjazXarXuHiNjtPqf959QyEJim8XtBg9pI68Cmwbuf14EuEl5UY3NvJpPi+TJXe/jKeocTIsG2IqkWKcEGuIdyo30WSKkDsGAMoRDFpR95UiIKKvLI5CsfkHTcCm9vbVeulusNNd+Ilxxx1P/JBwknC9vIn8JUaEZ8iVF/fyLLpGLEKq49mTVMZl5vYjSOaKOrYgTDg6wCWXa9PYFFsXeow96IXLDUJcdzROD0WW32Baww4YUVePV/CIPHXISeMLlPW/a9LEkPXY2vT00agsWYR9ZW35nK3tmrbJA5z+qrYCg38q9IzObBoKpfsjwuX30UmOvLTCbkciaqxVEWyB7NoaDPpVzIniKfLzf0OT7i3x0pybZ6VkSEtYUnT8vm0qZJ8w3tJsHcH11fw+2JN2Bln7MYy5CWmKxfh4/mAo74IqgnXWmJV4NrXCY8XayY7xvmBMouDSu/Po8lYqWhUyoYWIBqUhKVkIVLRCdLVIabY4gsk0+fpxL/Lv1Adgi+Tn6Rl0YaaslGOi5KL0OZfWsIVkkh4luymTOh85HdD48hKWva1CObzvfFjBkqTNbCNM3J7iZUy26x1W4vg5YHei7t40mr1EcfmeJxjdjzFrSFECiWQxBB4p04F08ClP7ewWX6I2jd9G/PaRz+5kGV2eK65cIwVn
 mZ+sMhEY
 /X6wTjtuJoeIkyfmmFNETQIVWF/qr4D10TZCxRSQ5wdafzy0ma9ABwZnDbVTepG4nYmHm9XOKvINpUZV95FG7Zj/QTu3tT0ZT7dUVme9VhdAk5p4MABOUe6XDc1CfxwNHYRhabQ642fV5n6Ub91Zia5J1YEBgoFL8iApukir2mWt1BVDIvjLIZCvVBNC4FVD0x+8ViO2moivfeHUKLalVEfclBAD4cEecLRplwZ5TW47JyAUazuoM70kfI6l+SwvhTW2pq3gExQvpIvKyF40JJ8RTLhlb1aD29JeY9i4P0bm/0SnKr9Jv6qP8FiO7ev5Fi2uMJsdG3LsKwyyADxMvR0Zm4vyZuI3T3Apj8Qzy9G62DGMApUGK9tn6o2QnC9h5uNLCxs70IdnD1SQpXSM/0SHNi6NSvw/diST3ECy3Kb3Y26ir4R5Fut0XfgZjAmuna5FEBS7MbVo7KNtiYuXflQuya37LGYrLfk9CenmTAHnGNQ1A972wvBNlY3/gL9MsM/EKExpOOX3udVNVIk3VEAR0E48T4ojFENdAVH1Wbut2+1pQQIdsdLBwPpFREVBtnDREUsPw5gQgoqLHtUgMWFVVnUPBMAbO2TR+0ITl7rhCp74NGV2ySrEBnqdBdowtNYU+SUTS7TFuVzNm8+um8BL6RadfgDhoERt6VvbLNZWgf88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Also return false if kho_scratch is NULL.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 include/linux/kexec_handover.h              |  6 +++++
 kernel/liveupdate/Makefile                  |  1 -
 kernel/liveupdate/kexec_handover.c          | 28 ++++++++++++++++++---
 kernel/liveupdate/kexec_handover_debug.c    | 25 ------------------
 kernel/liveupdate/kexec_handover_internal.h |  7 ++++--
 5 files changed, 35 insertions(+), 32 deletions(-)
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ac4129d1d741..6a0e572c3adc 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -35,6 +35,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *fdt);
 void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
+bool kho_scratch_overlap(phys_addr_t phys, size_t size);
 
 void kho_memory_init(void);
 
@@ -109,6 +110,11 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	return -EOPNOTSUPP;
 }
 
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+
 static inline void kho_memory_init(void) { }
 
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index d2f779cbe279..dc352839ccf0 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -7,7 +7,6 @@ luo-y :=								\
 		luo_session.o
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 532f455c5d4f..c9b982372d6e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -820,7 +820,8 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 
-	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+	if (WARN_ON(kho_scratch_overlap_debug(pfn << PAGE_SHIFT,
+					      PAGE_SIZE << order)))
 		return -EINVAL;
 
 	return kho_radix_add_page(tree, pfn, order);
@@ -864,10 +865,9 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 	unsigned long failed_pfn = 0;
 	int err = 0;
 
-	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
-					nr_pages << PAGE_SHIFT))) {
+	if (WARN_ON(kho_scratch_overlap_debug(start_pfn << PAGE_SHIFT,
+					      nr_pages << PAGE_SHIFT)))
 		return -EINVAL;
-	}
 
 	while (pfn < end_pfn) {
 		unsigned int order =
@@ -1327,6 +1327,26 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	phys_addr_t scratch_start, scratch_end;
+	unsigned int i;
+
+	if (!kho_scratch)
+		return false;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+
+		if (phys < scratch_end && (phys + size) > scratch_start)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(kho_scratch_overlap);
+
 static int __init kho_mem_retrieve(const void *fdt)
 {
 	struct kho_radix_tree tree;
diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
deleted file mode 100644
index 6efb696f5426..000000000000
--- a/kernel/liveupdate/kexec_handover_debug.c
+++ /dev/null
@@ -1,25 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * kexec_handover_debug.c - kexec handover optional debug functionality
- * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
- */
-
-#define pr_fmt(fmt) "KHO: " fmt
-
-#include "kexec_handover_internal.h"
-
-bool kho_scratch_overlap(phys_addr_t phys, size_t size)
-{
-	phys_addr_t scratch_start, scratch_end;
-	unsigned int i;
-
-	for (i = 0; i < kho_scratch_cnt; i++) {
-		scratch_start = kho_scratch[i].addr;
-		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
-
-		if (phys < scratch_end && (phys + size) > scratch_start)
-			return true;
-	}
-
-	return false;
-}
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 9a832a35254c..804d6a1209b8 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -41,9 +41,12 @@ static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG
-bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+static inline bool kho_scratch_overlap_debug(phys_addr_t phys, size_t size)
+{
+	return kho_scratch_overlap(phys, size);
+}
 #else
-static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+static inline bool kho_scratch_overlap_debug(phys_addr_t phys, size_t size)
 {
 	return false;
 }
-- 
2.53.0.851.ga537e3e6e9-goog


