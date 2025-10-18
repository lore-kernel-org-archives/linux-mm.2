Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD4DCCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684EA8E0010; Sat, 18 Oct 2025 13:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6346C8E0002; Sat, 18 Oct 2025 13:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6208E0010; Sat, 18 Oct 2025 13:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBBA8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD3EC590C0
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:10 +0000 (UTC)
X-FDA: 84011893140.07.53B9653
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 27A694000D
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EI8wSJdr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7YtyqkoqKD6VWdGbdex27QCyhVfB5yWUVWWXB11RvY=;
	b=7jeqDQt75KF3VMWl4jEwA7WVyknsGenYhcfWm2bPyuq5UeZpIQPgCNjKpZ1q410CKOuKDe
	9V9/aTH+Yi/G4/2eqQHyHnQPNsEAGaXS9T8sZtVOBMPNKgmkzLDXMF2IbIYm6WVCSlDpfV
	WuhdswOD7IYF8rboTrHRoJDINK9z13g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807889; a=rsa-sha256;
	cv=none;
	b=B1UEDtWe++E8MmqPGO9vOKADWFgH8chY9aPDQWHKV+kfO1L7SQwtB8pkV6w0sviyvgk4eE
	P7FYrVed95Wz25zgSyz/FHf0nN2UqVsbxJ8wZ0mzuCckLj2c0PKbpKzwIs0Re7u18BB5R1
	wduGKXLOG0Lx5kaN+ZRsmMJ454felbo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EI8wSJdr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-87d8fa51993so13141396d6.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807888; x=1761412688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o7YtyqkoqKD6VWdGbdex27QCyhVfB5yWUVWWXB11RvY=;
        b=EI8wSJdrpRvGDnJ0+IYsr7DS4rBhNsbNoVgkj0t+ZbaaJCnLlORzwsmM2mQUiUL0ds
         8bm30N4Zk8++ehjSpmMEsK2mnAP0dla8gcYiyHNc0v0VaRYbzOwCWEPEdM7D/Q40MpJA
         qoBZd0kcn+tTQ+75eQpr/jorL6fNn4Zl3KePf0ZIQpYFVdGuXFUbunZrq2/WiVK/yGT9
         BFzTgAgywQ1PhXh9swMt0DyXdOwbehrWfjhMLnpgYjpMSyeSj0zV/b9K+r4tLjAaH8ZS
         G1Kd4gf8QxQ+DF9ULeHU8qxJILXH7XQkovWahNdqZXF3RH+bsioh8D5wFLoe58ThRbLg
         ywOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807888; x=1761412688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o7YtyqkoqKD6VWdGbdex27QCyhVfB5yWUVWWXB11RvY=;
        b=uDI3CgPrpAFJInTJjYIUGKV34gBH/Luk1W0vv63ml/34ZOWYZGocJr+oalwuYn9OHj
         y8hIBN4LhAjZoUX9qf7bYnTNKH+5+WdHgpxIFFbDqT8+nQr/wEm/rTbezwd4X12flea6
         zuiLIr6tsJta1XshDGJhWZiGqqQZqaQa9lmaPLcut42r2CtWDUjJ5kTs+KwxhsHN2h9O
         dfVmtwpk32GAAeh6dLAUM5znedkoU7pgKmbyYRUmFSip1GygSd2obm+Y6ydVx3r/W5L/
         /+2cKoBxeY2g8vT716Y9RUmPzYDxpmSn4OhCidie5biOcAXLzOrVWT7wpBeLnqQ/WzSa
         0eZA==
X-Forwarded-Encrypted: i=1; AJvYcCUiN4pHRgQc7sCJyL4ZfWtLHW02RZPpaRY/thO7nZo24i/w7kxrD4INOXuob9E2f9prlNwNdK0QZw==@kvack.org
X-Gm-Message-State: AOJu0Yzlwvl7x8Uwb7jCCjAmmBks3NfjV9Wf8ZsUmOIC3FthFUXImxym
	nrfL5iQ97tX6lDcZRZ6/6psmLCO6sXWn8Bop0me2pwd9GlHlyGkXykQqwqW2iC9uaQA=
X-Gm-Gg: ASbGnctUEs6R3fTkMmy9Gq3XuR+Mwb1shGCv+OsvFIkFDnEutQRrO2efrVKNOXE93ec
	ldGY+Z1CtQbjF0Y6gYZipm8yuHcZhhLm9X6UwkoMFAMA3t0MW6OUpJfjDYqb0xu3+U8ee215X7c
	jHJ5ngybX1NRSW3TCqvAYC3C1t23JF4TYXeWiPDLpy+5DXwmL2e9tBsklztI4yx2QkFT66wvUaD
	4gCgRHsri2GBDbqhN9yTTkC6tl862+e+jyVhZLMyhcwG900QIRV/f10a6Jqb02NpxJzTyuevK+f
	GG+ybnlL79PhBIst4ZJ7aR6lMqqDsCjNVLR76j/qlNVLXe7/LK+1AXrdzSrF4AAxxHzu//wFFT7
	0ps8vRrrQpL9ztqbgi018FRdQO1JnQ1MF8lKgztlTA7YrYMhebfFvhqC5liEfQer/BETXQBFAxT
	QwEdn4BGG7Wys7s1IL+pzTNY5f0KiNSf8TnV2rtQKUL8Y8Bt0DCCQVP6IwTII2ktBVjLGWVotJi
	GCY/3oIASaq6m2isNWrsvNnFY66m72K
X-Google-Smtp-Source: AGHT+IGtzHn/6DD3dWiswCVgFR84KeOf4/Bt9Z7b+lVvn1HSzoZWElRRGyMVVN30USlthvsHs20ChA==
X-Received: by 2002:ad4:5e86:0:b0:87c:43f0:373d with SMTP id 6a1803df08f44-87c43f039damr68609776d6.39.1760807888207;
        Sat, 18 Oct 2025 10:18:08 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:18:07 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 08/10] liveupdate: kho: warn and fail on metadata or preserved memory in scratch area
Date: Sat, 18 Oct 2025 13:17:54 -0400
Message-ID: <20251018171756.1724191-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 27A694000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 7ysdcss6xy5i4x3jesj5yuxtj3yku74c
X-HE-Tag: 1760807888-59878
X-HE-Meta: U2FsdGVkX1/1WSMoQQLcYEieHZ7bwZlmFQ5CtvcaYEl13R1ax7/V0CvFMQj4RwBsKuuRyTIEpHeMQwtBWfpIatIH8nuLU3/6rUV8LlZlfM3vbYV9jpEFCBjwaywROVhadgrxkNh/fssFB7bsNRKzENTMdkH/HjaBN5h4hsbV/BFzhBzO/7+vNXgkwLoU00Q9NXR/hyZ0drE9Ek4eZa1DXvQkNztYn9gRkZAMOvT6Ig65LnKgBT70XIbkygsZhifnsiUlxUm1FlBMgxeysFS1oD7IbdVXY29OqQgU1KWsa0QyL2kT9m7cLYl0u9JGBv4n4r6MhWGzCQ2uIkv2lep9miimhEF3RYWY8ynG3TGUFrbtYGYSFLGAiV0YMfqMEY7kGIbLP2HQEVQATpXytRlcue0GEN6geYrmo9/oPrlfMlIR3HCMy7W+Gdkp5wbDFnwIWrq33xwe1rCAnO3sFB4+h5yJFc0+YOYPwDHlskvA9q3+7ErryQPJ7FKLCBefRXdmZurwRQI+w+zarSiIHB/6Sgzs57RcpqotcqW8dVSXnRyDZ59UWu/K55mx4R2HeWdYfUBHQZVy38zxCjGSZ3ntxgkojnmDwuXYHvZI5afPvfpRE1NBlqWsDx81t1/b2PHPEjbXuIg+b3QnMCamj5/3plFdJyTrM57Qd0q9hDFrHdTR1o6t5cZMumAZP7WdKl5eZMu8ZmT5Fsf2CAU6lrjNK6l7Wgzt7nh5e9Ortse6I6CeGU37aakf4fs2DajoKDluV0iywlURu3sDbVxsU2RcAgmJYBIuyNsOGFhp4taQTxn8VrWCLZDoDNo/I50c+0MwHaypNIgvzEIoe7aj6ia90MK00wLtW7RQrR3RQf1rpDjpH9BIN0vzguPKPkotdM8OrQKmdDiITCzLPzhlwvFwvpWYy5VrSWZebsZtPOajFNnc7abLwOZQ6+rjKcKX9njICtAb34F4caOARq0fqJ/
 0uBLs+bR
 VFZ//ieNdJi42ArL0kIBgU7iZzRlwDfkICmxWPxEd+Ttq1cvHBtHvqw/EQyss1c1GvPyt7NFtHr5ta5zVPKXo7KGm/CD7u5xMzZm1HUaTqO1qn7qnVZ3ncgzIaovzqA5yAIyASKsstzrB9S/FHbfjudlzLxwATgyqLAQtuWgb1MYfwHeOQfqVNNdvKc4KD2EMzZkgVL+wqBjxNffI766PPi3O5nkmqZOXnt9ISP6yUQm9e+bz/jVX4j1cE4Z80oKwa9zXcpP+X6+jcOKxLvKc8jyG2UI9oXE+aHUYCRoT4gqTDnwKCPxBE2AXP5FlTqpdlqa6cTLjF5cVoTodE/Fx6kACLIVGXXyFoFscQHL/NbbPHt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is invalid for KHO metadata or preserved memory regions to be located
within the KHO scratch area, as this area is overwritten when the next
kernel is loaded, and used early in boot by the next kernel. This can
lead to memory corruption.

Adds checks to kho_preserve_* and KHO's internal metadata allocators
(xa_load_or_alloc, new_chunk) to verify that the physical address of the
memory does not overlap with any defined scratch region. If an overlap
is detected, the operation will fail and a WARN_ON is triggered. To
avoid performance overhead in production kernels, these checks are
enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/Kconfig                   |  8 ++++
 kernel/liveupdate/Makefile                  |  1 +
 kernel/liveupdate/kexec_handover.c          | 52 ++++++++++++++-------
 kernel/liveupdate/kexec_handover_debug.c    | 25 ++++++++++
 kernel/liveupdate/kexec_handover_internal.h |  9 ++++
 5 files changed, 78 insertions(+), 17 deletions(-)
 create mode 100644 kernel/liveupdate/kexec_handover_debug.c

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index cea287842475..851d1a22b4c5 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -27,4 +27,12 @@ config KEXEC_HANDOVER_DEBUGFS
 	  Also, enables inspecting the KHO fdt trees with the debugfs binary
 	  blobs.
 
+config KEXEC_HANDOVER_DEBUG
+	bool "Enable Kexec Handover debug checks"
+	depends on KEXEC_HANDOVER_DEBUGFS
+	help
+	  This option enables extra sanity checks for the Kexec Handover
+	  subsystem. Since, KHO performance is crucial in live update
+	  scenarios and the extra code might be adding overhead it is
+	  only optionally enabled.
 endmenu
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index fcdf163b4b0e..f52ce1ebcf86 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index c87d00c40c82..ebfc31814d16 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) "KHO: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/cma.h>
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
@@ -131,26 +132,26 @@ static struct kho_out kho_out = {
 
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 {
-	void *elm, *res;
+	void *res = xa_load(xa, index);
 
-	elm = xa_load(xa, index);
-	if (elm)
-		return elm;
+	if (res)
+		return res;
+
+	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
 
-	elm = kzalloc(sz, GFP_KERNEL);
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
 
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
+		return ERR_PTR(-EINVAL);
+
 	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
 	if (xa_is_err(res))
-		res = ERR_PTR(xa_err(res));
-
-	if (res) {
-		kfree(elm);
+		return ERR_PTR(xa_err(res));
+	else if (res)
 		return res;
-	}
 
-	return elm;
+	return no_free_ptr(elm);
 }
 
 static void __kho_unpreserve_order(struct kho_mem_track *track, unsigned long pfn,
@@ -350,15 +351,19 @@ static_assert(sizeof(struct khoser_mem_chunk) == PAGE_SIZE);
 static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 					  unsigned long order)
 {
-	struct khoser_mem_chunk *chunk;
+	struct khoser_mem_chunk *chunk __free(kfree) = NULL;
 
 	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!chunk)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE)))
+		return ERR_PTR(-EINVAL);
+
 	chunk->hdr.order = order;
 	if (cur_chunk)
 		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
-	return chunk;
+	return no_free_ptr(chunk);
 }
 
 static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
@@ -379,14 +384,17 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 	struct khoser_mem_chunk *chunk = NULL;
 	struct kho_mem_phys *physxa;
 	unsigned long order;
+	int ret = -ENOMEM;
 
 	xa_for_each(&kho_out->track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
 		chunk = new_chunk(chunk, order);
-		if (!chunk)
+		if (IS_ERR(chunk)) {
+			ret = PTR_ERR(chunk);
 			goto err_free;
+		}
 
 		if (!first_chunk)
 			first_chunk = chunk;
@@ -396,8 +404,10 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 
 			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
 				chunk = new_chunk(chunk, order);
-				if (!chunk)
+				if (IS_ERR(chunk)) {
+					ret = PTR_ERR(chunk);
 					goto err_free;
+				}
 			}
 
 			elm = &chunk->bitmaps[chunk->hdr.num_elms];
@@ -414,7 +424,7 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 
 err_free:
 	kho_mem_ser_free(first_chunk);
-	return -ENOMEM;
+	return ret;
 }
 
 static void __init deserialize_bitmap(unsigned int order,
@@ -737,6 +747,9 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.track;
 
+	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+		return -EINVAL;
+
 	return __kho_preserve_order(track, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
@@ -784,6 +797,11 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 	unsigned long failed_pfn = 0;
 	int err = 0;
 
+	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
+					nr_pages << PAGE_SHIFT))) {
+		return -EINVAL;
+	}
+
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
new file mode 100644
index 000000000000..7986dcc63047
--- /dev/null
+++ b/kernel/liveupdate/kexec_handover_debug.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kexec_handover_debug.c - kexec handover optional debug functionality
+ * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define pr_fmt(fmt) "KHO: " fmt
+
+#include "kexec_handover_internal.h"
+
+bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	phys_addr_t scratch_start, scratch_end;
+	unsigned int i;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size - 1;
+
+		if (phys <= scratch_end && (phys + size) > scratch_start)
+			return true;
+	}
+
+	return false;
+}
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index b3fc1957affa..92798346fa5a 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -44,4 +44,13 @@ static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
 					  void *fdt) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+#else
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
+
 #endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
-- 
2.51.0.915.g61a8936c21-goog


