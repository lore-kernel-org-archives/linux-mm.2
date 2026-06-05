Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0820ACD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2696B0098; Thu,  4 Jun 2026 23:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9456B0099; Thu,  4 Jun 2026 23:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFEC6B009B; Thu,  4 Jun 2026 23:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 483E56B0098
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:33:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D14661205AA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:26 +0000 (UTC)
X-FDA: 84844438812.07.020D10B
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 181D640008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:33:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FBzJrjuD;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=burVgKt+U0bNdZ+S4i+8PCamSBgPUcyGmVaC5AfN7II=;
	b=j+g0qI2z+tY/Iuis0+gnSaWsDGlQ82F+EzBiXv6XXftygiRIxm0BUyz0cKboZrsQXuyQLc
	OPZ9yvD7JhDidvyO/9qhxZd6B4aW85b9VHNMGTxGLlOxu1VsG+26495uY3RwjH6jDNLkmL
	E3lnJTSX1cBTpv9erTKu1KTvxBF+poU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FBzJrjuD;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630405;
	b=TjmlPV0yACBLIayKD+XjKL4kyeFctK/p1mA8IJcH0t8MTe2AN5dgn/t56D9W59ffsneTur
	L/W7gSu3TUVQrdhPcCMfsNJCkbY5biB5C/5Q5q/C2Fn3O1Pw+ocworeTEgg2H4otipHU9p
	9Qtr5mbg3mIxJ064hr1r3n845LSAU0w=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-91587626ae1so168098185a.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630404; x=1781235204; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=burVgKt+U0bNdZ+S4i+8PCamSBgPUcyGmVaC5AfN7II=;
        b=FBzJrjuDwtV1cT9EyLk4ADJAgSTgCFsrS1q7aFD1IayuJai3Kd9crc5xsBTamWIV44
         DlxEd7zly2vgT7L5o6nvzRG8U2O1hMQAPyZG/NysA1M06Bic9NVitGIvrZcKHHT9/pvv
         aWnTtKN9LHJjv9zy1inOiev5p2PTU990yxW9auFt73jyKx0vyeO04iJQT1w9uIecRHg2
         mCvy78mWagwTsdXuJe/9jWMYSvxlsb9rRx5SGcDR16IGz5q19cGHQq6XJkeVyS9RBLx+
         Txk3qiQoOKEnKgUayxBpC1oTaMIf1nY3WWUHadWFaVJ9xpZsYGFC6+dmtmp0O/jCbF6d
         USSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630404; x=1781235204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=burVgKt+U0bNdZ+S4i+8PCamSBgPUcyGmVaC5AfN7II=;
        b=WHykcIqC+ohvdY47xFfCSYE5uQHp8e+6q6E5PmoQX3Ouf9vGLYksFOcGlBnCm49YkL
         P7XxQAhi5bwqQGQBsYjtOLe5qtct3aNxLqZ8CbJfFA7g2F1GkLSf5lJRtgmU+UtZdlTk
         ea8s/kTji6OIxo0JBFmf2bwHC4SXTWAu49dvAUrbWh5JIGzZlWH5j5HgxILbbJB3yuOz
         pTW3OoMW5GyHBZKbnHFKsYMk6X1f/vWt5Dh9DCKuHeYWKeih41/fzfJNqCpYRQyFsKjW
         DmyRQm51pBB+2ug8rZA+w5dJVeUoYvbTBiHZFDflmx7TRkFIXxDS67+qaUwivwPKKhMY
         HuQw==
X-Forwarded-Encrypted: i=1; AFNElJ/FUTqfMQHaq5te0dnm4j1DWgKnbZ3IsWaqW6WdbEoVwPgJa+TXcTNnaGbtSsHi2loCzF3gqaKvSA==@kvack.org
X-Gm-Message-State: AOJu0Yy5CGYXlKXT1wNmVT+Yk4oUAzTdpeT51ng4lTrfvhJzJb+XylYX
	j+ZX1gprK+T9BThWFtaJuRt2fWf6OnmuyEWMfgt4gfs9pB4/+sj1gME4sgij9SF0ZvI=
X-Gm-Gg: Acq92OEOkKZULZdvm0ylQPW2FR+UASD3WdRRyeOPiXU41+n7+iDtvUp5daLXdNyRkU4
	VckCGI/G81xCP14rEGEPLe3dqLP4wjXGpZdpOt5ZP4vtlLG1z2FUx/ULIigODkiBW3hGjK65yvS
	VSEJGCWkaMz5UB7dgsTdGvpncm/jEjN5VZVdzuN5Tx2jCPPo4Wi3NIj7Rz2NXB2VmlT+hn9R3s4
	SsHclEiY7jSOG5vXtIHN8wiUa2XMOYR1Gicf8koCChwIXPDuOdS+sDSPmJ4v3NXvGpq5nV8qIhV
	zEL4+Pw/b8ExwUxpzJZkcEqRwdRJDR/w1Rb84KlbaD/hdZcOUp4aEywN8bW5UCvxT/ZlM2cy7bc
	bOx0/ZB0eXZJNBhnrvktYMBBlWBWk3PB3oVkhO6P1pZTDS+XrY4WYHRXurzyUmxyXymr+JNTKO5
	Xz1cTQYvpdw/9Y3oORxWFoGHXWNRZe5eyEXZpnpwZXSz00mWbHMiLFp7Uv5LPnaTNAt6EYZn1M
X-Received: by 2002:a05:6214:2d07:b0:8cc:f882:2562 with SMTP id 6a1803df08f44-8cee61497cdmr30262576d6.39.1780630404187;
        Thu, 04 Jun 2026 20:33:24 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd263003sm71383816d6.42.2026.06.04.20.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:33:23 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 4/9] kho: split vmalloc headers out of kexec_handover.h
Date: Fri,  5 Jun 2026 03:32:30 +0000
Message-ID: <20260605033235.717351-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 181D640008
X-Stat-Signature: bikt65b54asfxu3zq9nyrynpoz3au494
X-Rspam-User: 
X-HE-Tag: 1780630404-273270
X-HE-Meta: U2FsdGVkX1/x+RIX6teNIf2fvxxex+uckHYq8YSxKJIHtWDXufvFxkf8/WDL3fCTOV+GQ2nWSRyLOse3Wx7Pj0EdhvsMO/K/r/PeZceooRy/gYKa2B43w2S9fcEKB6gy3Eeer7tsTHvF4sFcTF0Mqezgz4f5EDAXdwgs9Kh+eKksOYi8F/7dQ1Ymm+uc+pB+1E16EcwA8SMi6Z+OGRRhVGjjCI+f6okjVFD9Q+5dwFAuQVEm499gVyXKkSu218SB7edYg+Whc54l2gi+DlM5g7yjz8B+XSCIHtPqAKK0FqACKoRQZgocR/j5wTQE5dEKtMgXKMrhlzGaejzVGKbrgnZ7m7GGedP7CRqvqglTKTlItIZx0T4MF7UeS5dxOPY12aEl3Z1ZepUIvJV9Il+BpAcQzfqGwzbJ5Sm1t4xBBU1azaBfHixNgWD6bDJ8vwCNKb43Y1ptuHN24jSOSHZuMnfUr0J3ZmTxObVazX6krxz7dqfrPDVjcVqf+93XKtC8h+GFk/sXvJ4XM+jPv6NslsFsFzcGTRU9Bb4LqvYVUQ6a1/wmz1pggojCyu7HqyDwDQn71BHpuKm3etAayR05SXv3UeBHdLOz0YYT+YCCmKOJfoDMsNBo8flKoRVoaIf9uDTycV3JameYY67pEuKA51H0SxmoUIewDlEHL/Epg4rbPY1A+lg6E5gunb17CMa29Ccq78O/uyp1b/K5WSxd4m8fFHFK0Yzbhda8FBAHWwRzw0UAxDrhh6xmX3FdzFFC/q9XCPTogFMNQmmkGE+2jv6v2I7c5viM1WSvdQ9fiOPuoyLcU1KQ/ddoQLCoObHYNLnzTTIBEGp7kwQJqfgZsmiDNBlN3p6X+IE9G067pmkBWM2DnbedvJhe5ah7dqofaKQbt4H1Ke5fFqIyrUVli9haW+Vs82cxbaeGxdwIkcVNYVvNRPtXdQsk9I7bWk0aaoxB8sMyTp5MvQY2eGE
 qb/neriK
 KoZaGOl8uofkFwDy1Z5Qe9XlHTzRDu+zFVWtdsXA6a7J3k6nd0v3sva81JeP06+urmwC+HLYMBW3QG5Ws62K/hqoGdagwQFK/gLKT884rYwT+jrJ2uxsWFgSL3QIa3ILMexW1AwYf+geRUZR8PzYRXehRA7zB0SGLm0Q9qLvQXvxUrjgJyCd+uge+xwnNQlm1jwtRBbUqXcTwemaN+UozgRKGvEcbELg7MR40v+hO+zLDDO3p5zqpzgq1TxhGN+e/5D4LvVUSINKdpQiY8Ixx8SXCkwyus0ppW5huNRm89F+7Te/Bqd+DxpuZ9lu1CoTd2JLneLtzCuUtLqcWkCqRn47cUT5sGB8TPR1L8plAPzZL57dSYvMwLHgonOvvlLDlFA1kjCJQ+Uui+XZhODcoX6imTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split the vmalloc-related ABI definitions and header declarations out
of the monolithic kexec_handover.h header into a dedicated header
file (vmalloc.h).

This is a pure code movement patch; no logic or functional changes are
introduced.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/kho/abi.rst     |  3 +-
 include/linux/kexec_handover.h         | 18 -----
 include/linux/kho/abi/kexec_handover.h | 77 +-------------------
 include/linux/kho/abi/memfd.h          |  3 +-
 include/linux/kho/abi/vmalloc.h        | 99 ++++++++++++++++++++++++++
 include/linux/kho/vmalloc.h            | 34 +++++++++
 6 files changed, 137 insertions(+), 97 deletions(-)
 create mode 100644 include/linux/kho/abi/vmalloc.h
 create mode 100644 include/linux/kho/vmalloc.h

diff --git a/Documentation/core-api/kho/abi.rst b/Documentation/core-api/kho/abi.rst
index da5c6636bb17..b61363679829 100644
--- a/Documentation/core-api/kho/abi.rst
+++ b/Documentation/core-api/kho/abi.rst
@@ -13,8 +13,7 @@ Core Kexec Handover ABI
 vmalloc preservation ABI
 ========================
 
-.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
-   :doc: Kexec Handover ABI for vmalloc Preservation
+.. kernel-doc:: include/linux/kho/abi/vmalloc.h
 
 memblock preservation ABI
 =========================
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..518fdab2a4d1 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -11,8 +11,6 @@ struct kho_scratch {
 	phys_addr_t size;
 };
 
-struct kho_vmalloc;
-
 struct folio;
 struct page;
 
@@ -24,14 +22,11 @@ int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned long nr_pages);
 void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
-int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
-void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
-void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *blob, size_t size);
 void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
@@ -65,14 +60,6 @@ static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 
 static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
 
-static inline int kho_preserve_vmalloc(void *ptr,
-				       struct kho_vmalloc *preservation)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation) { }
-
 static inline void *kho_alloc_preserve(size_t size)
 {
 	return ERR_PTR(-EOPNOTSUPP);
@@ -92,11 +79,6 @@ static inline struct page *kho_restore_pages(phys_addr_t phys,
 	return NULL;
 }
 
-static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
-{
-	return NULL;
-}
-
 static inline int kho_add_subtree(const char *name, void *blob, size_t size)
 {
 	return -EOPNOTSUPP;
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 99e4a53d4e35..c893b5045078 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -96,80 +96,5 @@
 /* The FDT property for the size of preserved data blobs. */
 #define KHO_SUB_TREE_SIZE_PROP_NAME "blob-size"
 
-/**
- * DOC: Kexec Handover ABI for vmalloc Preservation
- *
- * The Kexec Handover ABI for preserving vmalloc'ed memory is defined by
- * a set of structures and helper macros. The layout of these structures is a
- * stable contract between kernels and is versioned by the KHO_FDT_COMPATIBLE
- * string.
- *
- * The preservation is managed through a main descriptor &struct kho_vmalloc,
- * which points to a linked list of &struct kho_vmalloc_chunk structures. These
- * chunks contain the physical addresses of the preserved pages, allowing the
- * next kernel to reconstruct the vmalloc area with the same content and layout.
- * Helper macros are also defined for storing and loading pointers within
- * these structures.
- */
-
-/* Helper macro to define a union for a serializable pointer. */
-#define DECLARE_KHOSER_PTR(name, type)	\
-	union {                        \
-		u64 phys;              \
-		type ptr;              \
-	} name
-
-/* Stores the physical address of a serializable pointer. */
-#define KHOSER_STORE_PTR(dest, val)               \
-	({                                        \
-		typeof(val) v = val;              \
-		typecheck(typeof((dest).ptr), v); \
-		(dest).phys = virt_to_phys(v);    \
-	})
-
-/* Loads the stored physical address back to a pointer. */
-#define KHOSER_LOAD_PTR(src)						\
-	({                                                                   \
-		typeof(src) s = src;                                         \
-		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
-	})
-
-/*
- * This header is embedded at the beginning of each `kho_vmalloc_chunk`
- * and contains a pointer to the next chunk in the linked list,
- * stored as a physical address for handover.
- */
-struct kho_vmalloc_hdr {
-	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
-};
-
-#define KHO_VMALLOC_SIZE				\
-	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
-	 sizeof(u64))
-
-/*
- * Each chunk is a single page and is part of a linked list that describes
- * a preserved vmalloc area. It contains the header with the link to the next
- * chunk and a zero terminated array of physical addresses of the pages that
- * make up the preserved vmalloc area.
- */
-struct kho_vmalloc_chunk {
-	struct kho_vmalloc_hdr hdr;
-	u64 phys[KHO_VMALLOC_SIZE];
-};
-
-static_assert(sizeof(struct kho_vmalloc_chunk) == PAGE_SIZE);
-
-/*
- * Describes a preserved vmalloc memory area, including the
- * total number of pages, allocation flags, page order, and a pointer to the
- * first chunk of physical page addresses.
- */
-struct kho_vmalloc {
-	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
-	unsigned int total_pages;
-	unsigned short flags;
-	unsigned short order;
-};
-
 #endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
+
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 08b10fea2afc..af310c0c9fdf 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -11,8 +11,9 @@
 #ifndef _LINUX_KHO_ABI_MEMFD_H
 #define _LINUX_KHO_ABI_MEMFD_H
 
-#include <linux/types.h>
 #include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/vmalloc.h>
+#include <linux/types.h>
 
 /**
  * DOC: memfd Live Update ABI
diff --git a/include/linux/kho/abi/vmalloc.h b/include/linux/kho/abi/vmalloc.h
new file mode 100644
index 000000000000..87650e1dd774
--- /dev/null
+++ b/include/linux/kho/abi/vmalloc.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
+ * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: Kexec Handover ABI for vmalloc Preservation
+ *
+ * The Kexec Handover ABI for preserving vmalloc'ed memory is defined by
+ * a set of structures and helper macros. The layout of these structures is a
+ * stable contract between kernels and is versioned by the KHO_FDT_COMPATIBLE
+ * string.
+ *
+ * This interface is a contract. Any modification to the structure fields,
+ * compatible strings, or the layout of the serialization structures defined
+ * here constitutes a breaking change. Such changes require incrementing the
+ * version number in the `KHO_FDT_COMPATIBLE` string to prevent a new kernel
+ * from misinterpreting data from an old kernel.
+ *
+ * Changes are allowed provided the compatibility version is incremented;
+ * however, backward/forward compatibility is only guaranteed for kernels
+ * supporting the same ABI version.
+ *
+ * The preservation is managed through a main descriptor &struct kho_vmalloc,
+ * which points to a linked list of &struct kho_vmalloc_chunk structures. These
+ * chunks contain the physical addresses of the preserved pages, allowing the
+ * next kernel to reconstruct the vmalloc area with the same content and layout.
+ * Helper macros are also defined for storing and loading pointers within
+ * these structures.
+ */
+
+#ifndef _LINUX_KHO_ABI_VMALLOC_H
+#define _LINUX_KHO_ABI_VMALLOC_H
+
+#include <linux/types.h>
+#include <asm/page.h>
+
+/* Helper macro to define a union for a serializable pointer. */
+#define DECLARE_KHOSER_PTR(name, type)	\
+	union {                        \
+		u64 phys;              \
+		type ptr;              \
+	} name
+
+/* Stores the physical address of a serializable pointer. */
+#define KHOSER_STORE_PTR(dest, val)               \
+	({                                        \
+		typeof(val) v = val;              \
+		typecheck(typeof((dest).ptr), v); \
+		(dest).phys = virt_to_phys(v);    \
+	})
+
+/* Loads the stored physical address back to a pointer. */
+#define KHOSER_LOAD_PTR(src)						\
+	({                                                                   \
+		typeof(src) s = src;                                         \
+		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
+	})
+
+/*
+ * This header is embedded at the beginning of each `kho_vmalloc_chunk`
+ * and contains a pointer to the next chunk in the linked list,
+ * stored as a physical address for handover.
+ */
+struct kho_vmalloc_hdr {
+	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
+};
+
+#define KHO_VMALLOC_SIZE				\
+	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
+	 sizeof(u64))
+
+/*
+ * Each chunk is a single page and is part of a linked list that describes
+ * a preserved vmalloc area. It contains the header with the link to the next
+ * chunk and a zero terminated array of physical addresses of the pages that
+ * make up the preserved vmalloc area.
+ */
+struct kho_vmalloc_chunk {
+	struct kho_vmalloc_hdr hdr;
+	u64 phys[KHO_VMALLOC_SIZE];
+};
+
+static_assert(sizeof(struct kho_vmalloc_chunk) == PAGE_SIZE);
+
+/*
+ * Describes a preserved vmalloc memory area, including the
+ * total number of pages, allocation flags, page order, and a pointer to the
+ * first chunk of physical page addresses.
+ */
+struct kho_vmalloc {
+	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
+	unsigned int total_pages;
+	unsigned short flags;
+	unsigned short order;
+};
+
+#endif /* _LINUX_KHO_ABI_VMALLOC_H */
diff --git a/include/linux/kho/vmalloc.h b/include/linux/kho/vmalloc.h
new file mode 100644
index 000000000000..2d1b5d282a93
--- /dev/null
+++ b/include/linux/kho/vmalloc.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KHO_VMALLOC_H
+#define _LINUX_KHO_VMALLOC_H
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/kho/abi/vmalloc.h>
+
+struct page;
+
+#ifdef CONFIG_KEXEC_HANDOVER
+
+int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
+void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
+void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
+
+#else /* CONFIG_KEXEC_HANDOVER */
+
+static inline int kho_preserve_vmalloc(void *ptr,
+				       struct kho_vmalloc *preservation)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation) { }
+
+static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_KEXEC_HANDOVER */
+
+#endif /* _LINUX_KHO_VMALLOC_H */
-- 
2.53.0


