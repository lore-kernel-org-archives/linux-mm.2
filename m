Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD80CE8D4C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EBF98E003B; Fri, 14 Nov 2025 10:54:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D3B8E0029; Fri, 14 Nov 2025 10:54:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43EEE8E003B; Fri, 14 Nov 2025 10:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA168E0029
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E450E12DEE8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:18 +0000 (UTC)
X-FDA: 84109659396.03.741E18C
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 10706120014
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JvzqJgGF;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Uap8NJrH5Pb6CWLHsw3prb3WSqz01SCPOCj0nxF8f0=;
	b=Eq+x1STpX6YGMFvy42XVUG8OarGSVZHMMRPryL3uBwjtZbgeI8MqUQkk9LMjaMH1o1ZSln
	nvCXcO6+FfaPMm+KnwgTgA1BIEZ5+LgPbMnjaZYM9H+fLdVlEZDZQEM4Bu30I9RRue4ZLm
	/jVd4yg+YJQVNO5IePGkaBlzXkh6Abw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JvzqJgGF;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135657; a=rsa-sha256;
	cv=none;
	b=085HOS/xh3qMfHGLrzOH+6ITosjQ0fOoj6hQyG1KA0KicFXzreJFtdl+4Hl/mQ5ZkXPo18
	xk4UNamxCSNXm8e7c4vNZZHP4yao8B3MMdW1mteHpTlbFz9h0g2FuwU6xGrzSx2pgqRN1r
	WZx31Qp/PsMwCPt5oOaAvW/h2xk4yQU=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-787e84ceaf7so25406017b3.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135656; x=1763740456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Uap8NJrH5Pb6CWLHsw3prb3WSqz01SCPOCj0nxF8f0=;
        b=JvzqJgGF3zHJk1ZaA2xSVqXhpx/MKXu9cwBM02NJx2ksffjfx3TVzlApOgeRWb7WMs
         M8e6//siOgRM7NwScUYOIRTcyos6t2BiTHASFzTAGzhlIoVCFz1uPQQSw+PRH0eggIzD
         HLE5GnRv3aGMt+NUcI0K5NjoK38f3Z7Avuz7Lgj26vo7bD7Os2yaSSb7y+EWVUAtkOi1
         /1iVGqtL3+d5KZ3+KSASO0SRBDMD5kl0+kvO1LxodazEDXvP9mTC+RqEn1Bo+VT6aGT6
         wsn7NovU/hG5EiIJ9uGdi1xDdB9ea8miFGx7Vu9Oc9fq8LMRji7vpS+5TNQO/7NQj3QS
         sICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135656; x=1763740456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0Uap8NJrH5Pb6CWLHsw3prb3WSqz01SCPOCj0nxF8f0=;
        b=hbuqb3yT7XgXExOOLzdxlNsVPotZ0YewtOzu/7B18Ty1iKF3XZF9oDUPmvudPU4HPC
         n2SKdf7b52/K98MKVFAO45SYGXvd21IskSEOu6BFZ6RSdbSzZeIuzSXzvGehVqHPGHdr
         PS2y5Y+iZDHJ9UN6ub6p7iNNgd3bdLDF11yKUzzbVD8ix6ZBSG88jc33YlrUuFGx2Vel
         iWxls2KlODOiycVh5spgWBIO65NX4Dkac2yMfA6YF+iG+VdbqtNGQvNuPVHb2l5po7oR
         hW0F7r7QjzccUJCg3kf2oKeOhqhPiA5s5GAuRFC0IIt1hlnplOR0RDBUkDuJwhvwM+Zr
         +e0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+GQkg5RZMxmqNT8J95D67Ej+pFYrELVa+xE4s7blq9KHDPHqAqUy8l6qckR+athBTdEiJaaxBmA==@kvack.org
X-Gm-Message-State: AOJu0YyvCbvaS8twr3cR1/QhBWe5NX3Tkg8iV7vsgAF8ZLZlYfgmDwj9
	2AMDPvHbj4XKx8DM+up1tT2BmDLpP9AGddIaX7c6/13mDTgiS8ER27fHD2VvU/e5XL0=
X-Gm-Gg: ASbGncut9/N27eW4up7xT1QYOY4rjLK8gQCb4PXoUaoY1nuBePYOyY/vEtoyfCXbF71
	BjEP4jcp2n97hyrs5Nn0tQc7VjFv7FqUDwg3chdEZRiedpC8yVuDJsGggTaww+nhkggLJRT6/HD
	8VSTrdeQNRDh/9hl40qfE5JKdEQ7XMRhC2cEMM9ZeHyaSdqchhYjqpYnQ2GnvtRYvu3+BT9dtWu
	fRC3sg3ybtvIknLVXVdtbYLIUE8ifhWTmzMRfHXRawOBcb50q5Tl4tE78bAKyYJgriMpKIV+Hlv
	ey5Aoe+7kTzzBfkXDVNgDQ/3oEgO4AK64fKPSnYebqexwEIANK44Tr9MhUK9c23SEf3gbnjO6xc
	9stKKnc4abwfSROztOe2aFtlAQ7G39AjFSxBi0zTlyJD1xJGw+ANTcaa6UXpmbJmqtAO5jDMnrq
	73MPn0NnW0gqJrVhFWbMvbMfbNnMwfaLhYMKBUh6S+TQmgKvobBECA1blPct+aQ1EUl2Bw
X-Google-Smtp-Source: AGHT+IHNxNYIjWa6M85ng5fm7KdMGmaCp0p2DckarVLQ1uVdBIpVIya/6LO6pSDb2OyOlRX9dHvrhw==
X-Received: by 2002:a05:690c:5a14:b0:787:deea:1baf with SMTP id 00721157ae682-78929f16b28mr27160997b3.52.1763135656118;
        Fri, 14 Nov 2025 07:54:16 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:15 -0800 (PST)
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
Subject: [PATCH v1 13/13] kho: Introduce high-level memory allocation API
Date: Fri, 14 Nov 2025 10:53:58 -0500
Message-ID: <20251114155358.2884014-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 10706120014
X-Stat-Signature: gczxop3sdodqidngbsq8935xr156qr11
X-Rspam-User: 
X-HE-Tag: 1763135656-239704
X-HE-Meta: U2FsdGVkX1+NPwle6LRMnW18gWdH11VQTIcU7PTk8CzEtv9No8rENA3XuYrGL/ATyivG73LVPMWRmjL7jzZk6IKkB3wqmiC28dYvO0hRXnN1qrqMQAXx3gpUyelo3N4gIC3wp8rPfqw79d2rdBn9f6gPmGBvd+wFamBe74rmnhlPk95ye/92SIeepmsur8RtJI6BivNujCLd+HQtA1bM5rdft58ewCiHR+tg35NsHfmmOeKYH51JFmCI7qrpK5ZOh+EsA7Y6BPcUX4oatjQlboAABANv1jh/Qj+L3WiLq/rkEBiR7e+Sc5nFJ4pDPGhpU0rMje+qfb6hK2vMt9ppG4eOX984pgNuAhbm3gIjx5ybJ/H/G6yR4EY3esMk7Cvd1ooCZrNYfihHOLFMo/9Nam+QGaTF71GUv+GR+0A0g10pOrskI1x33JEVnw/gVXbxtWeEkpqL9jP1iMq3C6des8kwuAZrzzASqgyBQjGuna8qCtAvrJnR6zEJ0xUY33GpsiFqzBBZodmSsQMn0Qmd0anUOwU5it/flMhox1RND6bVCefTYk6iDfsfRi4MAIDQp9jIO3t9c3kPl2POcPoEa5uuE8O26O+2TAqIqyfa2axg5c54THy9Vfjee9gPKzwHdV54ivu+V7a7Rsmpb+92ULU3U0DmqP0CrZIUKZXZS4HbFJ6hR74qEoAMU1aa1I7i6oGa9tvAf6sY9V4zpAJKBR61hAWkMrEq0yB1rYXrDvJTYJjg8aJGTUkZuVTbnzvc3XOSZXHPfDCMuYTVaObTGhZFytT0YJa4LvDJ2cwphxBIUDtDcCyFVdM0vfDFgJz7NBZOA0lBcIWEiWoLHe/PtBAvSqkU9ULZ+rujbKijI/bOq8BUOYYkA6AZ1O2fLTW+eL5PKu6wncOkw5CINETR+sDXpxo5jxVbK9GFQkQwF6EH5M1ryxN36gc4Go8p9M/BtT+SmthE7dIwEytkZ6z
 9Dj0qQ0D
 NQ8sSZMuncIsOuHtZumhQ6ZRcISFabP64WXNFfuM1Zm6LYm6ShNX+gbgR528dXdcdeE0f0f31zN9jROazj/G0Zr7hlN8zxjPgGqmYQnb8JVqWZtlz68MKwDW1kHaWA2vv5TNCfUsme9Fg4JPZk5+YbdExDCFrTllZBa8acyuFTzTYB0CqwuALpr+HyFOfUg8MrKo4gFFBpphBaaCyAeDUzlEB8oeTIcV9Fbbufy/Jp/HKJhud9h5psnfMF0sC6n/rN9gKexXbXdx4msgyK/37qya/4UjjOV/A7jURphuruemycYJpwhXpy6mBdUrlhb8kTcp+K0rOmxxpN6/xASiN3IqzFIqcQ532pF7UsdqklLJDkqM=
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
- kho_free_unpreserve(ptr, size): Unpreserves and frees the memory
  in the current kernel.
- kho_free_restore(ptr, size): Restores the struct page state of
  preserved memory in the new kernel and immediately frees it to the
  page allocator.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kexec_handover.h     |  22 +++++--
 kernel/liveupdate/kexec_handover.c | 101 +++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 80ece4232617..76c496e01877 100644
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
+void kho_free_unpreserve(void *mem, size_t size);
+void kho_free_restore(void *mem, size_t size);
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
+void kho_free_unpreserve(void *mem, size_t size) { }
+void kho_free_restore(void *mem, size_t size) { }
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
index a905bccf5f65..9f05849fd68e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
  * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
  * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
+ * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
  */
 
 #define pr_fmt(fmt) "KHO: " fmt
@@ -1151,6 +1152,106 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
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
+ * kho_free_unpreserve - Unpreserve and free memory.
+ * @mem:  Pointer to the memory allocated by kho_alloc_preserve().
+ * @size: The original size requested during allocation. This is used to
+ *        recalculate the correct order for freeing the pages.
+ *
+ * Unregisters the memory from KHO preservation and frees the underlying
+ * pages back to the system. This function should be called to clean up
+ * memory allocated with kho_alloc_preserve().
+ */
+void kho_free_unpreserve(void *mem, size_t size)
+{
+	struct folio *folio;
+	unsigned int order;
+
+	if (!mem || !size)
+		return;
+
+	order = get_order(size);
+	if (WARN_ON_ONCE(order > MAX_PAGE_ORDER))
+		return;
+
+	folio = virt_to_folio(mem);
+	WARN_ON_ONCE(kho_unpreserve_folio(folio));
+	folio_put(folio);
+}
+EXPORT_SYMBOL_GPL(kho_free_unpreserve);
+
+/**
+ * kho_free_restore - Restore and free memory after kexec.
+ * @mem:  Pointer to the memory (in the new kernel's address space)
+ * that was allocated by the old kernel.
+ * @size: The original size requested during allocation. This is used to
+ * recalculate the correct order for freeing the pages.
+ *
+ * This function is intended to be called in the new kernel (post-kexec)
+ * to take ownership of and free a memory region that was preserved by the
+ * old kernel using kho_alloc_preserve().
+ *
+ * It first restores the pages from KHO (using their physical address)
+ * and then frees the pages back to the new kernel's page allocator.
+ */
+void kho_free_restore(void *mem, size_t size)
+{
+	struct folio *folio;
+	unsigned int order;
+
+	if (!mem || !size)
+		return;
+
+	order = get_order(size);
+	if (WARN_ON_ONCE(order > MAX_PAGE_ORDER))
+		return;
+
+	folio = kho_restore_folio(__pa(mem));
+	if (!WARN_ON(!folio))
+		free_pages((unsigned long)mem, order);
+}
+EXPORT_SYMBOL_GPL(kho_free_restore);
+
 int kho_finalize(void)
 {
 	int ret;
-- 
2.52.0.rc1.455.g30608eb744-goog


