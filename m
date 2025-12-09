Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE8CD3B7F3
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 02:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50E66B0008; Mon,  8 Dec 2025 21:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C302A6B000A; Mon,  8 Dec 2025 21:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF13C6B000C; Mon,  8 Dec 2025 21:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 938A06B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:53:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30DA813ABD9
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:53:29 +0000 (UTC)
X-FDA: 84198411738.26.24F929A
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6A9CF80005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:53:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GSRf6bz9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3Jo83aQgKCHMaRjfedZlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Jo83aQgKCHMaRjfedZlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765248807; a=rsa-sha256;
	cv=none;
	b=IetpL//0T9j4flOZhO+cZF4jVBv2EZml2LlIG7vm4Obz0BA/R+cIU5/6WJT1X0ew9xTL0p
	JxMJf0G7ytNC3FxF07DKSQG9z+jvK81dJMPjVy8i90RMhOc8Ptb4gQ/BqXp0Mqa45vboB7
	SjMnasnfIpClV+AFzh2A1i8jFb7sAjw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GSRf6bz9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3Jo83aQgKCHMaRjfedZlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Jo83aQgKCHMaRjfedZlXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765248807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YniVUU6/+lQD/EVhfTXqpFE+9KZzpnPEHhqtMsCQi8=;
	b=k3w3tiQ5SBr6nVQ6lQmaKrzF4o3veDDHTLuVe7W7NiWmRRer74pwuKjn1Bi+5SnAdljeUR
	Ox6cEIFhRfz+FUzua7CWBwEXNNJnHFa5bPjHLKKnMQ6NzzCu6ajr/zbIDIUcxnucabmSNZ
	FYyfppPQqAR4sZ2XKhGuZfrAUmGTKG8=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5edecdf94eso8759603a12.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 18:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765248806; x=1765853606; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7YniVUU6/+lQD/EVhfTXqpFE+9KZzpnPEHhqtMsCQi8=;
        b=GSRf6bz9iftDF94D2r9s1/NAPASZtcPjGK2Gun2poQHcG6jQLI1nY8ex18j61TbtS2
         JXFpqQhvKtHiiEr3ncdzK5dOAy56+/dXOrt5g/G042tjgv/MyVGfxagywjhdz5LbjJeF
         lNdiZgQ540g+7MBTidr+JPtBYrgSuBOnRCTP8SOpsuigBvGeFG+KZswK0CK/zqujAq/x
         PZ6ydFog9owbggs72Ew+1SVobRhuJzkRx1c0jgr8miwp1yb2n8ub4Id28WhKrAWPDVgE
         9oE3JS4EqH8KU/iwEmhWt+rAER17Xgm2IeY5Vo5e2MhVhZ+/fssIHrZQSKTp/rKdN/ss
         E2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765248806; x=1765853606;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YniVUU6/+lQD/EVhfTXqpFE+9KZzpnPEHhqtMsCQi8=;
        b=wtfYb8oFJ5xdzwSKTjGNrTQobwdUex0qCtAMFHIAFVUeDaI9C573LQgIuNJQO7iUbA
         jrNJsP8xAp6e4udBBsdtvOICLMZ5YR9SUOXhtFNZ551TeK6yTfD6y9cWnq+lkwcDPRYN
         5ckPq+YMX407RkcE28++4mbalA6WswmCEuE9F0hSjKb8Nd9Eq2EqXRPndZQP5WxLGTX6
         h8fwQumlHALNMN4DLplO1RLwS1X1tz/kI5gAVzhtlZ6YRE9eIQZITglaWhnHZbLLpCGi
         cWTrAIJv7W34+lRgJimIC9xNWPIVtSaQOBA7TXXqWh76BN5HDb7AcqzxMUnyNnydgVuQ
         WJ8w==
X-Forwarded-Encrypted: i=1; AJvYcCXb7b37tBQzukRkw0ffuW/GQyupWweY0n/kdsU5La+OL0R4Jaxvo2m6+LPgx5UMp/jmvgah4reGPg==@kvack.org
X-Gm-Message-State: AOJu0YzYVs9dZ8a8BdxwxhizpukEkmOu6bgsxr/HQuPOQ/kMOnVZASDq
	QS5d8Hhh5heq3nZWSJz6lL1AhUhR6ATwQAezJrWoXx43q80gqpquNluT8Z7atfQN/1AflhYoEav
	ZlTbRaXiMxDVaTg==
X-Google-Smtp-Source: AGHT+IEE2+RzFDmhYi3sZJMC5POuF7uEYIA0RYOQQ5LbZQGlmWpKy+l52MCfZMJi+695a5er1FB0tS6NzuXitg==
X-Received: from dychz10.prod.google.com ([2002:a05:7301:860a:b0:2a4:7a56:1730])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:6589:b0:2a4:3594:72d7 with SMTP id 5a478bee46e88-2abc710d8f1mr7325213eec.6.1765248806192;
 Mon, 08 Dec 2025 18:53:26 -0800 (PST)
Date: Mon,  8 Dec 2025 18:53:14 -0800
In-Reply-To: <20251209025317.3846938-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251209025317.3846938-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251209025317.3846938-3-jasonmiu@google.com>
Subject: [PATCH v3 2/4] kho: Relocate vmalloc preservation structure to KHO
 ABI header
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6A9CF80005
X-Stat-Signature: k5nk3nu7o5wg1hsuczz3iddbn5g8zfm6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765248807-147565
X-HE-Meta: U2FsdGVkX19MLLxN5PAjCQr1XSHDl1qef1PMPo8VNEwWmHn5ADDkJOVCfl5oGUS2LFKctnxrhA76RRl4u3Hqg5IjDXkePJ0bOYuW00enbevWVW/2boKJ2hxngOTzkZi0fvcUE8SOhpcgjYGUcaRFMKiGJCXtWfA4l6mxaOh7DXMp8n9IlbYEClx0B/B30WKrw9bhBC0mkon8GFL8AjxKEjapIjNtzrhjLsxED5HKcKZvn5NWtcQwuIU7YXh8UXlR8V7KCwZLaw2LukilwlnAzmAGzzMoPvpdAq0i3TAN+AA42oawnvHrI4X07Rg3zqr3dYavWHNYZGW5uHN4kXRZ3v6BAQsUqlhmdaWmUpC8bBLuX1DyldNqs7Tq61ngdl9iasovaSiL9Klp40tRqfcnzzhWeMDhuPKV7CdGbTCT8ily25tN519R8AKmDI4hWMNbrbZFfVE6X4xaB5IwLGsJ5WGGRJy1nGYEZCnPQL/3+ccyMgku2kyKXtCUHYNLsduS+gLUSvG6AUr7cfflh2pr/iaTMg5qFdi3ffieUodoUVdIOpht3KZwTIbEzBLkLuWj7N4LgHaX2lXQQ47k4SS6pvPnCeZrwGLidgyY8w5Kkz0csJoDl1Kyl6Z0HLppFh8XYCps93H5cCDRKUKneVcUjBtgN2B7fr1C9eqOxdzFOwDHccZ3VWUdlIvjHhsX4lGNt8TGC4X2GYlENM0Y0uHph2n5avoPHmN30DnZq41sCS8Z0YjT/Srudj5s0h+xvODcfwxuy4W37mU6jl7dF81kJKYKD7hhOAjIOHDNFkh1S6nNTc0Doi3Zx/LdIkHuV7/6Bg62tuDJhFu+sGC0LAc5G0KcTkz8lec+GWvWc/EuNmCgZ5kEvqC6Mdjf7/Wk7KCmaO7lzHo4SdgeuH2XQhoUW0NJyN8beQLpPKwIJW1HyaThaq/Lgk99FP0dKyIgCcpdYDywkvtISQ36wdOfbq5
 a0HuZ/iL
 t6n6VHZRgl7hNmBCYgVnA7Am889GWh9c7JDW9Sfx0l3uePxo/QBEnvfcCb7bnTVqdEiXh1cO9f6VZKRSgTZzYJTy/DSSkoepBlFW5G85E57c+hjZeUL/RZTEUk5bLtlcj/yLrdaBnE2BH9D9A0pxZytB4KLE9k2W0qrYyNGzUT9mKRJL5BikcLsCbpqgseZkkUmg0G1lEBMXUdXxB2szLhg2XY8R86UVINZ4M5P8p7H0pFWHiUOpJvh/YB7YvMXStFlosbYSvfIAsXEfo+fDjQbZjCXu0YmpT6JCjlWqkgDoIjUCv4QDzYgig8B6pn8o896pYhlyk3gcxmX/K1VQtTuV/EJ3jDlolNsouDla0q4UrWz+QoIB7V23JBS9d0GdxmAsr9cL6tRBMx9KWdp9f4GnSysdZh8YzVIWc2lw4D/XLUfADo0dDFpUHmBWFhYCu8F9HlJBbmefLBppDIMMESYulu0ateL4PWd/UlQZQwY+fKHptqZbDEzb21qz7/TZCSi+nQG/oxoMLB6wGsM6XARAH0VDBlLQHBi2nlYXxZTEx4V9SI1onP0mkmn0eIVq1zLNaRIXVLf/vSqkvz7vhejsr1iA2DeCss7lPzL0ACHTnqgdBDn57qOK9xKCkGASCYXTM
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


