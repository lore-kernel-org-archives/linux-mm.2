Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25338CE8D79
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1BB98E000F; Fri, 14 Nov 2025 14:00:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC6F8E0006; Fri, 14 Nov 2025 14:00:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8B28E000F; Fri, 14 Nov 2025 14:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E28C8E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EBC44D254
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:13 +0000 (UTC)
X-FDA: 84110127906.12.6FCD80D
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6B36F120014
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=crjC2pRx;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ihe0loas1LrTsn9bRuxuUBOFUFQUEsXdHcA1ZYhZ3IY=;
	b=e8Pta/JfWy7zKmovBWgE/dVJnsq/stKCM5MV4R223k71Zt5pi1f7VB43lRTXnRLx2KGNQw
	N2TkKRP4W8vVCos62xBV38waVMf3AdhE6y40OfTAwflqCZWGVQpn2Gfiu7YSABMUFbx/Nc
	5YdLF0IyE0mTq+O9SKjRjegi2WJddF8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=crjC2pRx;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146811; a=rsa-sha256;
	cv=none;
	b=AlT1Uj+VH9L+Wp9FGMwyTqSg4rI7fGIk5tlV1dIeH0SEd+OGHd+B9FOTBdVdC1xKV8OXYd
	+eXLmtRuXBOhj1wau8mIW0wwKFdCkHSNgYGScEd0JFg6AtMOEE6ytqfxR08LR7DZCAMA4i
	Jb7u/syzZ8ceo/9AoYk4QZslTvRF3fk=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63fc6115d65so2261990d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146810; x=1763751610; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ihe0loas1LrTsn9bRuxuUBOFUFQUEsXdHcA1ZYhZ3IY=;
        b=crjC2pRx6CMalFM49cJYnJfjOFzw8lWVZOGDZvn9XwbhBSrUmpsRinZY8PiyK8DUUV
         X4OYEQxDWnDpku95wNuDHbuQR2luMkDU04QwLbrmvKpgZqJncbvzP3TvR+xBDV0hwad1
         +qP918/ITbOrUL/+ObVziE1lsQuq9YcYIoqcYwqnhEauQPjgUbNplNzzOROciuUEoc6Z
         KUp+uxU+w06qNkdR7moD03EJUxrduCcHUq2GJQa04EN5VkjSEAkOZBnUyWFtggfFxFSJ
         DEDR6VrGY7D1uJSjrIOrJ1dQ3a9An3gJgUZ0ZG5huGfYv6qvKV3CEmN2H9wgPE9PVDhW
         onWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146810; x=1763751610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ihe0loas1LrTsn9bRuxuUBOFUFQUEsXdHcA1ZYhZ3IY=;
        b=odhQnWLcBOMDeOU7ay0eHvIwDlC1J0Dh7BfLp6VULSSOssO0U4nXzsEHf3ZCJpfa/J
         7DDVoMpCVJ4iqe/v1NhOZY9ja2tHYIxv/09cQSgat5PZRHW0P8NzCA/C/V2j0IejGH2/
         RJ0wapp5MgmGKWO5ey3oEvp35QNTA0uy0y3/LqRiV8zhpWYLaQBYTvgpWiFxI4I432ND
         t6scDFVuoR/ZeHQOb84nqajDzNqnn1ySF8ks7sJd0nXu6KLe08OW6hJvv4FnVkcAQVVN
         rVzw/1WrJ2gwdehB16mcaQSaRgMq/2y7RotMegmFesunZD53GcG67kMc6LPf69ssr7OK
         p1Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVB6QPs6E/y8jzZn+4fJJZARVVraCJzC/B7EgJv1UDhCuu1K6w+7L/MGz+XjriQedLZjgZpdIdPPQ==@kvack.org
X-Gm-Message-State: AOJu0YxlTUhNkxkn+CCVZtgwjM4Wa4rS8lPE1Bj6vFtkuhsNwRFfHcof
	5JHRPlGO7Dhq1o+SWqNn6QaqJvbZbbdQbgY0quWwErOPgxcet6Mqh6PeWoLtFDXo9F8=
X-Gm-Gg: ASbGncvAhYOi4zwUeSnnM+f4ztq3rLEiBDP0PogiRUVLzcz9L+XDCUFIjmJL/Ku1HO4
	0BalGj0pu74kwQ8QVXlJSIvqAiE5XAAQuc1w+E/aideoEP/j1sBhu95kcGIbX9QN8u3RwTv/oPu
	wdtQOUrhS5dGDNrPvO99ui0eUrz6CX+MSGjbBHwzZu0E05HP96Xmh4jUrgv+Keqh82jUHNJl7Uh
	+0SP5ew3TIR4r+ISokVBPa07bG2nbxwTsnzt505rBMTRnrr1F5vZt3/QXuB9+eHWL73FMHaZ2S9
	BvcUf6QaKbmmMPZCLudHUgDAuWAPorOY8WoR7WcIVuRPlMlxQqgcrIL30ehqfZGF1Mb7nWMbW4k
	1P9hFbnDJyEp0OnJ+h+WAi2qa2By11No8yVF8J3B3DrNKoPu+BAkYtUlPktV2S5lqMPPKvQeUgZ
	04clp4BDR8nr6kxTxaM3qKlXlYN1cMZad5+8NvlkYYrdqZPba461tyUPhP76jmvCMWZxb7XJoeB
	rRPKgg=
X-Google-Smtp-Source: AGHT+IHtcsADCaRWmb9vZYl521slB2k1TyP9yi6kP/peGKq0p/n4sbxoK2XQz6YSUfgIDyLwv/pwEw==
X-Received: by 2002:a05:690e:23c3:b0:636:563a:6725 with SMTP id 956f58d0204a3-641e7644cefmr2737299d50.49.1763146810418;
        Fri, 14 Nov 2025 11:00:10 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:10 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 03/13] kho: Introduce high-level memory allocation API
Date: Fri, 14 Nov 2025 13:59:52 -0500
Message-ID: <20251114190002.3311679-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B36F120014
X-Stat-Signature: aq843z8ky1fsaj9e4qsrrdatw56tknfi
X-Rspam-User: 
X-HE-Tag: 1763146811-875216
X-HE-Meta: U2FsdGVkX19l4r/vKaGogDzL5v/zh/mfQbWsZQPYah/EssXTbRm/FKujGdrouBkNd3Sc/Kk6SBVF9pSNRAFjiuMAtChGyeXh6JpCoGFWuKMgRAqCrElYomc4p7HY4nD4j4QovoYCqYkf5Mk9zs5IgD1wcDxv7KBkMZJU+satGZIrj2DI9X1o4Aqr+QW7fj4dqi5csO9AWludmql3EmWA8WwpVAeoDnfvdm71u6VgrZ5dR5kjsMiVAS8MajDJNes3fYPbxzkBqRNRNDWYErSZvmiyEVda4IXQKeXigf1ttuNaSN01K7iPdaIxdvn60afOpJOEvBulfJg7lJA9k12a1fAT0hz5WuLX+2AooK9vyFJ2zdkSP+STAHUSELoO2Kn1dk6qin24KPRZzYS14RTtJNdUXGUQN+0rRS9wJbAor5wfGrN8BFpIzdIkKle2CpNyB9EeynXtBWOE6UmzpkfnBGHsbpAlyTM0bVmFr98hL7ws6zBmWicieM/yVhWKQp5ejhOMAOK3TKhIX8BvvMgWTdxuR7Ax7LFZUjh5lL+yEfEEpZe4ojeVJ1B2Do46OUmRDgNpucAXuc8sOExGfCXB49+Rld+0aOswymkE0DUCDhPThjQvTUGvKadnDTd2hQhJDpkwE7OJYYSj6sfYqFnIAI+BUJIlTkbKLmWBy2oL06UdgqyZPdmar/ZDNIH5EfhUgAIBG6NY1MlE5lsYH4M2yZqDo+9S97c5IAmkPdpOPnKOw3YIyoMClU6/tBGhIE4+nAvSUdNYD026twdPdX5rq8MageTnoLAFvfpYbXozHeeIQRPzXvjwnsy5hCbEbheAegEhdXbVRCZ1QrQCOXsWXncSNN9NXjtvjCYzeSSB4pUbGH3h3SERj+PCZq0UJzDR+Gcg6ojhtpkuEFmIpkfvRXOoojk3v/1cVMg7d2QXEtPYscLQKMMNAEXRPcPAp1bIBfYGKWRNvOPGWPAn7RD
 PhEMnkEH
 nhLPmmxGgXT4hauVRsnLHUG8GwN9fYT46eHlP8YE33gVSJfsmyvhuY982iF/xr4N2zTsKNVJ4eq5y6eR/gnMoVpRr/Xgdaf8PcyHx6IJmXZLgP+BR+WXwPlk5Pnt2PAUygT/II8AAesdigARVPIHPqXWdPOBu9V/oRNpO1wbLBpkr8nxYb5JmVL5nTNO/YoDTudg4paevsSBfN5CxbtC867HqiVccMQCehfo0eaPCt4d3OUg0WqtG0gdf96SN2BQIt0d57w+y0r1yy2SVBgJkM2v2nzAZhKcGa85NqJYtbzhS21IWf4UOnzQMu2zxTZ/M7rPSYgNyZf/U5J6vLQqNX3ZMH9lQ7FM9z5FoPmq29gaNFqI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, clients of KHO must manually allocate memory (e.g., via
alloc_pages), calculate the page order, and explicitly call
kho_preserve_folio(). Similarly, cleanup requires separate calls to
unpreserve and free the memory.

Introduce a high-level API to streamline this common pattern:

- kho_alloc_preserve(size): Allocates physically contiguous, zeroed
  memory and immediately marks it for preservation.
- kho_unpreserve_free(ptr): Unpreserves and frees the memory
  in the current kernel.
- kho_restore_free(ptr): Restores the struct page state of
  preserved memory in the new kernel and immediately frees it to the
  page allocator.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kexec_handover.h     | 22 +++++---
 kernel/liveupdate/kexec_handover.c | 87 ++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 7 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 80ece4232617..38a9487a1a00 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -2,8 +2,9 @@
 #ifndef LINUX_KEXEC_HANDOVER_H
 #define LINUX_KEXEC_HANDOVER_H
 
-#include <linux/types.h>
+#include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/types.h>
 
 struct kho_scratch {
 	phys_addr_t addr;
@@ -48,6 +49,9 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages);
 int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
+void *kho_alloc_preserve(size_t size);
+void kho_unpreserve_free(void *mem);
+void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
@@ -101,6 +105,14 @@ static inline int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
 	return -EOPNOTSUPP;
 }
 
+void *kho_alloc_preserve(size_t size)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+void kho_unpreserve_free(void *mem) { }
+void kho_restore_free(void *mem) { }
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
@@ -122,18 +134,14 @@ static inline int kho_add_subtree(const char *name, void *fdt)
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_remove_subtree(void *fdt)
-{
-}
+static inline void kho_remove_subtree(void *fdt) { }
 
 static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_memory_init(void)
-{
-}
+static inline void kho_memory_init(void) { }
 
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index bc7f046a1313..5c5c9c46fe92 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
+ * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
  */
 
 #define pr_fmt(fmt) "KHO: " fmt
@@ -1117,6 +1118,92 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
+/**
+ * kho_alloc_preserve - Allocate, zero, and preserve memory.
+ * @size: The number of bytes to allocate.
+ *
+ * Allocates a physically contiguous block of zeroed pages that is large
+ * enough to hold @size bytes. The allocated memory is then registered with
+ * KHO for preservation across a kexec.
+ *
+ * Note: The actual allocated size will be rounded up to the nearest
+ * power-of-two page boundary.
+ *
+ * @return A virtual pointer to the allocated and preserved memory on success,
+ * or an ERR_PTR() encoded error on failure.
+ */
+void *kho_alloc_preserve(size_t size)
+{
+	struct folio *folio;
+	int order, ret;
+
+	if (!size)
+		return ERR_PTR(-EINVAL);
+
+	order = get_order(size);
+	if (order > MAX_PAGE_ORDER)
+		return ERR_PTR(-E2BIG);
+
+	folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, order);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	ret = kho_preserve_folio(folio);
+	if (ret) {
+		folio_put(folio);
+		return ERR_PTR(ret);
+	}
+
+	return folio_address(folio);
+}
+EXPORT_SYMBOL_GPL(kho_alloc_preserve);
+
+/**
+ * kho_unpreserve_free - Unpreserve and free memory.
+ * @mem:  Pointer to the memory allocated by kho_alloc_preserve().
+ *
+ * Unregisters the memory from KHO preservation and frees the underlying
+ * pages back to the system. This function should be called to clean up
+ * memory allocated with kho_alloc_preserve().
+ */
+void kho_unpreserve_free(void *mem)
+{
+	struct folio *folio;
+
+	if (!mem)
+		return;
+
+	folio = virt_to_folio(mem);
+	WARN_ON_ONCE(kho_unpreserve_folio(folio));
+	folio_put(folio);
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_free);
+
+/**
+ * kho_restore_free - Restore and free memory after kexec.
+ * @mem:  Pointer to the memory (in the new kernel's address space)
+ * that was allocated by the old kernel.
+ *
+ * This function is intended to be called in the new kernel (post-kexec)
+ * to take ownership of and free a memory region that was preserved by the
+ * old kernel using kho_alloc_preserve().
+ *
+ * It first restores the pages from KHO (using their physical address)
+ * and then frees the pages back to the new kernel's page allocator.
+ */
+void kho_restore_free(void *mem)
+{
+	struct folio *folio;
+
+	if (!mem)
+		return;
+
+	folio = kho_restore_folio(__pa(mem));
+	if (!WARN_ON(!folio))
+		folio_put(folio);
+}
+EXPORT_SYMBOL_GPL(kho_restore_free);
+
 static void __kho_abort(void)
 {
 	if (kho_out.preserved_mem_map) {
-- 
2.52.0.rc1.455.g30608eb744-goog


