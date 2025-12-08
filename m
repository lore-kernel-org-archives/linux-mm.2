Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7D0D3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FD56B0032; Mon,  8 Dec 2025 01:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898E36B0088; Mon,  8 Dec 2025 01:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFCB6B0095; Mon,  8 Dec 2025 01:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4A16B0032
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:35:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 278F213BF5A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:29 +0000 (UTC)
X-FDA: 84195342378.05.29DEC8A
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55204120003
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:35:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MC4S6X1m;
	spf=pass (imf29.hostedemail.com: domain of 3rnE2aQgKCLskbtponjvhpphmf.dpnmjovy-nnlwbdl.psh@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3rnE2aQgKCLskbtponjvhpphmf.dpnmjovy-nnlwbdl.psh@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175727; a=rsa-sha256;
	cv=none;
	b=UDNxYhatb18ZS993152eUKB8zrQGI8UkhaRrJraDCIbTOR2VwuTcT0ObFkUiedv8m2zeZT
	WoDbQLJoENXiYIkFbcJLKUQoiI8LuO/eHCNH9nwy2X2/8irjP7p/gLP5x3KG4FSiiCwOxv
	86r0aZTvUT+ncqKG7xCOlfqciw8XpJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YniVUU6/+lQD/EVhfTXqpFE+9KZzpnPEHhqtMsCQi8=;
	b=sqp+c2f9c8dXxIQ2Y11KN30AZZFG91sWEV+jvLrw+Ox8ODaWYM77KyjAUOaHmuipsbeABy
	iOnjovBs7kFeFIb78RwVbrhy2qHWMamC82mYLpMMcjuyfSQmBtjynPm0cGRc7Mr+fVAqsN
	mUwSpV+2GJ/NMLRrJkLbE43jcIz7q2M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MC4S6X1m;
	spf=pass (imf29.hostedemail.com: domain of 3rnE2aQgKCLskbtponjvhpphmf.dpnmjovy-nnlwbdl.psh@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3rnE2aQgKCLskbtponjvhpphmf.dpnmjovy-nnlwbdl.psh@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b9ceccbd7e8so8388985a12.0
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 22:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765175726; x=1765780526; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7YniVUU6/+lQD/EVhfTXqpFE+9KZzpnPEHhqtMsCQi8=;
        b=MC4S6X1mk1iFBeZ2NYc97q5eIlrplR/z0X5co4PX77jKaI6TzoWNiWj2dgGpV7zTlv
         Krw6eeygZ+sCJjnhLGEm9nhaAMx9+j2nFma9cWXCDO9axQ7w0aq2xPwiEnyPkFnQXYtd
         sEWUfHmEnwtcbjxuvA+HI7wvr2FPA9fQtpZYr74XWwHMG6ll5z5cpx9cF8O5WzUhpRFH
         lcRyuSzrTqdEQCMMBd8/81ctu/tq7zhS2lSNckdWpWHYFlHSN8cybyBYbnsnyUetW/9i
         tEgWTWENdvjxHxkfdiCd3fXtg94yyBu01kIcYhzT3mJDkZuYKCI6yrRLsrh0yratuLe0
         4CRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765175726; x=1765780526;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YniVUU6/+lQD/EVhfTXqpFE+9KZzpnPEHhqtMsCQi8=;
        b=N183j8C2Fr+hzaNfJVEFKNsqUDHUlW499a8zvZfBdUJdxO8QL1AMEUa8NRI1Kplmsw
         v8u0z1XyZyubnVFK+k9EnBOAhHXIapHw0ab2/E64lfJPoUJGW/gdAptGFTpqrqkUByI/
         04nnFIRZ98Gh8iLw1FadiumEOujnp23JtVGgi+2kYX4ds+g4ExfEhwvgmHkQTVvBsAhp
         DiOPPUjoCdnSaiV5BVxl7shCZa0jcTWNg70s69YWYdbd4sKOk1GMQS463hMOZJ+E0FvO
         r7cGs6PnDqEdx+L0hbprZ5of8o5PUUXLSsCc6HJGI1ejsxZNksx8s1dO3mfk8vcLjlyf
         n1iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXATXzDSuCx1lx03vu5sS72WWoQbSOr+zHKj+UTTCqTj7yYc24WWlhRUgHmNpPIu+OzFqAuKxGBpA==@kvack.org
X-Gm-Message-State: AOJu0YzAqPhbUTAcP7SJ701o38xr52SRU13yPQR22up8OqTx7krCLkW8
	CUsUJek957WStwHhcPv7fLp7xSApHS8dcdqwdDvapxtJ5c0Y9KHHslaL990IM4KSgORuuIGlRVA
	MgMzDPZBQGvbfxw==
X-Google-Smtp-Source: AGHT+IHU6+/mDElXpIos6i8CNSp+95UxIucCYl80yGbmgb7FYlxpfDXUEFziZxt82S/j1o9ILLaNDoE1BFGUog==
X-Received: from dybhw4.prod.google.com ([2002:a05:7301:2b84:b0:2a4:559f:7c4e])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:fae:b0:2a4:3593:9698 with SMTP id 5a478bee46e88-2abc71f7ec6mr4262433eec.21.1765175726144;
 Sun, 07 Dec 2025 22:35:26 -0800 (PST)
Date: Sun,  7 Dec 2025 22:35:11 -0800
In-Reply-To: <20251208063513.3633942-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251208063513.3633942-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251208063513.3633942-3-jasonmiu@google.com>
Subject: [PATCH 2/4] kho: Relocate vmalloc preservation structure to KHO ABI header
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 55204120003
X-Stat-Signature: yiqp6t5r8ptrsd7m1unbwhgn4qkjrenz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765175727-754294
X-HE-Meta: U2FsdGVkX1+HRNmazMMb+uvFqTsThTlIHn6bnKWPI1wPZZK4MMd7v92enXX97rP/Egh8k3k6NFb3zcv71iyWHsyekB8ZDvFc9rQQV3Lw1YhJZJWk8FDsAyxiuoNXUWv2KLgkMI4kxqIVie5ktVKMcFgpEIJ+DiBNhInxxPwbD80zRj9tpqTcIkiT0204RxhsrnvPUGVa0idAGICVPylmenfBc6P3n+krsqdNKz6JfNmD14OruOmFjCwm5qzkF0XqcApdAfeJa8iTPwmGb9SKATGekLZaafvVv3oO+IDkJvoG4z2nrjVcMo97nJ3WKau+NfUGzHYsJSHokH8cSNEaIGbMp2U7q/cnBfnjmNlWtqFJhhd2RmWlLNU6anfIA1s7VNa1vsrnuDatqDTM4A0uwE4wLyNlSbbx1bEUBItyRKxBGnvIxBPl+l2XJs2I0Gvwjz1j5I6C0JwMDaqlC2Qdf4A9z4/se8y6zOcPCknpQwv4SW0o4m+cmXiYKU/NuslGT6iLjESLBYNl8cZJuY04cR+T0Ix+ybKcxkPoReFdr6gS5tYNffejDeqn2fRl05BgH1kMGIGSTNi2vssUhZIt+TlV2fth8H+eoxp5XN9jEZNY05E6SAipj/hHUzM/EA3kcX9G1xbL7GZzsDekU13s5u33s5UYjKpvrpXY8nrwcj1tsNwSQ291j0icC94n4iuKB7VxdD2etOhaUra+lzAHSbFp6DW1Ai4dwZsy1o6mgC/KSJc6eJUJjrH6EOGQ9vckArkErBc38jpE9fFtMBOsDy8CngasmIFwCQiLgDzpqSlhFGOGK7ckiZ8D8pOFrHRdgvJ6pr7jqrLho5wChlVkulwwv78LtEpvuAhEJRuOkXZgCyFsdAy4lzmfGNVDUiVje7NB61+2TWWQ+6xuoXcQsGits1nV3W0qQexuYRRQ3xp4PSb0usySaPRyJnqoh7vRcVtLL5i+pnHJOgbXMET
 TW4TKqbb
 IMhl0eEGY6qzXbXrWgTZKcadj8tgOb2d1ptFTSf69FTDtlr1DoQORUSw97QCq2q/zt6bbCIGisQavLp2xrBxu1xU5Z8qfTRC4o6exKtTMjmZDb6eJQhV045hgVMEmuSYT8r3wlV6qJPNz7X6Zt8JF+jrk523yUmvc52WEUjj1rTP5gAS7LkfGcVnPOWkFDsrrIUhbb6Sac1/Df6+xN38SH41FUQIhi6kZh3ZcDJCpr79TqYOQII/HWTwcnzUA00ROhpdUwuKkU6jvlSwO5iI/saSPkgUhCWcVUxAyCzEmzpmFuVpVWwjX5af6aypQsKz/vPkmXPuytXiz0OF/73nBHUnwLLgOlcGx3okgP5uMiPmK8QRDvtO8hcz02X+7dzkE3XeSrvxZSbKDain/mBQlDkTehb7vlVTQj8fxROI9ShrtTkX+V8ovBms7rZwMY05boTpkrk5sURm4CZrEjwmH7TT02IyoTtpvNaqmyjMGguF82TpNAE54HpL0LcYZFQ7p9cNvS5JTclH2rPJBwf0loYzt8NtcKdij8KmNJ2kZ83J8ErZLzmNGhePMoh1CT55eqdeKWj+QCjf+7EnPSGUGaK0YYWTC21xaXTop7mKCk6Qh3oCgMAC462ewDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The `struct kho_vmalloc` defines the in-memory layout for preserving
vmalloc regions across kexec. This layout is a contract between kernels
and part of the KHO ABI.

To reflect this relationship, the related structs and helper macros are
relocated to the ABI header, `include/linux/kho/abi/kexec_handover.h`.
This move places the structure's definition under the protection of the
KHO_FDT_COMPATIBLE version string.

The structure and its components are now also documented within the
ABI header to describe the contract and prevent ABI breaks.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 Documentation/core-api/kho/fdt.rst     |  6 ++
 include/linux/kexec_handover.h         | 27 +--------
 include/linux/kho/abi/kexec_handover.h | 78 ++++++++++++++++++++++++++
 include/linux/kho/abi/memfd.h          |  2 +-
 kernel/liveupdate/kexec_handover.c     | 15 -----
 lib/test_kho.c                         |  1 +
 6 files changed, 88 insertions(+), 41 deletions(-)

diff --git a/Documentation/core-api/kho/fdt.rst b/Documentation/core-api/kho/fdt.rst
index 4e080ccc420e..4202b67fcdf9 100644
--- a/Documentation/core-api/kho/fdt.rst
+++ b/Documentation/core-api/kho/fdt.rst
@@ -14,6 +14,12 @@ directly in the ABI header file.
 .. kernel-doc:: include/linux/kho/abi/kexec_handover.h
    :doc: Kexec Handover ABI
 
+Kexec Handover ABI for vmalloc Preservation
+===========================================
+
+.. kernel-doc:: include/linux/kho/abi/kexec_handover.h
+   :doc: Kexec Handover ABI for vmalloc Preservation
+
 See Also
 ========
 
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 5f7b9de97e8d..a56ff3ffaf17 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -11,34 +11,11 @@ struct kho_scratch {
 	phys_addr_t size;
 };
 
+struct kho_vmalloc;
+
 struct folio;
 struct page;
 
-#define DECLARE_KHOSER_PTR(name, type) \
-	union {                        \
-		phys_addr_t phys;      \
-		type ptr;              \
-	} name
-#define KHOSER_STORE_PTR(dest, val)               \
-	({                                        \
-		typeof(val) v = val;              \
-		typecheck(typeof((dest).ptr), v); \
-		(dest).phys = virt_to_phys(v);    \
-	})
-#define KHOSER_LOAD_PTR(src)                                                 \
-	({                                                                   \
-		typeof(src) s = src;                                         \
-		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
-	})
-
-struct kho_vmalloc_chunk;
-struct kho_vmalloc {
-	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
-	unsigned int total_pages;
-	unsigned short flags;
-	unsigned short order;
-};
-
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 bool is_kho_boot(void);
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index d78df2d44cb6..74f4fa67e458 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -10,6 +10,8 @@
 #ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 
+#include <linux/types.h>
+
 /**
  * DOC: Kexec Handover ABI
  *
@@ -81,4 +83,80 @@
 /* The FDT property for sub-FDTs. */
 #define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
 
+/**
+ * DOC: Kexec Handover ABI for vmalloc Preservation
+ *
+ * The Kexec Handover ABI for preserving vmalloc'ed memory is defined by
+ * a set of structures and helper macros. The layout of these structures is a
+ * stable contract between kernels and is versioned by the KHO_FDT_COMPATIBLE
+ * string.
+ *
+ * The preservation is managed through a main descriptor struct (`kho_vmalloc`),
+ * which points to a linked list of `kho_vmalloc_chunk` structures. These
+ * chunks contain the physical addresses of the preserved pages, allowing the
+ * next kernel to reconstruct the vmalloc area with the same content and layout.
+ * Helper macros are also defined for storing and loading pointers within
+ * these structures.
+ */
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
+ * chunk and an array of physical addresses of the pages that make up the
+ * preserved vmalloc area.
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
 #endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index da7d063474a1..1af4c9dc5a06 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -12,7 +12,7 @@
 #define _LINUX_KHO_ABI_MEMFD_H
 
 #include <linux/types.h>
-#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
 
 /**
  * DOC: memfd Live Update ABI
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index d3d02a9ea391..a180b3367e8f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -882,21 +882,6 @@ void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 
-struct kho_vmalloc_hdr {
-	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
-};
-
-#define KHO_VMALLOC_SIZE				\
-	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
-	 sizeof(phys_addr_t))
-
-struct kho_vmalloc_chunk {
-	struct kho_vmalloc_hdr hdr;
-	phys_addr_t phys[KHO_VMALLOC_SIZE];
-};
-
-static_assert(sizeof(struct kho_vmalloc_chunk) == PAGE_SIZE);
-
 /* vmalloc flags KHO supports */
 #define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
 
diff --git a/lib/test_kho.c b/lib/test_kho.c
index 47de56280795..3431daca6968 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -19,6 +19,7 @@
 #include <linux/printk.h>
 #include <linux/vmalloc.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho/abi/kexec_handover.h>
 
 #include <net/checksum.h>
 
-- 
2.52.0.223.gf5cc29aaa4-goog


