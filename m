Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCAB606A334
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=LG4klzmK
Received: by kanga.kvack.org (Postfix)
	id 2C3E36B05B0; Thu, 19 Nov 2026 01:59:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273DD6B05B6; Thu, 19 Nov 2026 01:59:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B296B05B7; Thu, 19 Nov 2026 01:59:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5BE46B05B0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:59:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4939F1C3E77
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:59:44 +0000 (UTC)
X-FDA: 85450968288.30.212537D
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 01BEF12000B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:59:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LG4klzmK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071582;
	b=OfDH9bM54/KItjANZPwbaMQcX4eBncEswofkTSPYGEFpwuWQMqs/P7sv5bFW5uWi6ah+yT
	agaroHANtnPVBr1lb2kAH/1++549q2k0+tKaX+cKdsKXpYOi6FMnNV3qyNxKZm3be9HtFy
	6ln/GbvqU0kxHJqHhOOGe4Cp57MM28M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ogi5GWES8zQkjfKNxeO+iNnJsM3bnylk9LsOSYEUFgo=;
	b=RlD+W4RMPQIYfkCp8mxa1nX8maD5JTM64YPOSHY8QQ9MWVHiEMXPTfH153flstVh2QgaUR
	PEWufOAGuWYu1qJibXxe4LfM+5DnlTCjSG5xr0IRR8/zpfVhF95GgtmgaHHmHNOajZO+1y
	1C016EPf6nBCW49f8M5TflgdO2DJ0kY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LG4klzmK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc147d86bebso399746a12.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795071577; x=1795676377; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ogi5GWES8zQkjfKNxeO+iNnJsM3bnylk9LsOSYEUFgo=;
        b=LG4klzmKWcrD601jaX0tacIVMXUfPagCGGttur8CE6HcfmeX5xRx1ZCdHaT3CYaF4L
         JV8Wzy8SKl4oM/gb1WRGjzgPyfsvZXBa9nCJ5bHO8CHICiHqkWKAZfFCxWPgJh7Mjii0
         N+8s7SFE7KOElKZfQWd85762U7cgIsJuoSIG7Uw5MXL9ElTOUMU6oEnQoaV+KS0Vbbj+
         QfA9XQtaKquESm0F5PvLQIZmn6Z3QR3XAZz/1/G+jNsu0UGwgzSF6E5gHGSaa9Ju77SK
         k6oUfXHS8mlpfkDjrUU+sRdeTF6QAbjHKigma9IaZV0oi7GpV1Rm0knomfYxZ2BP60fx
         M1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071577; x=1795676377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ogi5GWES8zQkjfKNxeO+iNnJsM3bnylk9LsOSYEUFgo=;
        b=za48d7LAsBTyGwdNZM2Yz1u/bbg24egw+Egr6ptBPngkDl1h1+x/VcX+nffeTrzeUY
         RIWzWGv4UjHnmTSSQOkFW/E/c2baBHCB60qpA508s6V8aM0eY0ba1a9JuOg9zPtQuYkA
         9ps6ZSbxXcvJ8Yy32BzsrsCDi3ZqDDGz9fRafX9KUC2QjHoy+O9mm5K5AeUS1U7P9VcJ
         aYo5IrEkO0NNY+VuziRgdqqT+RtkH0PfpjQ/cHzn+VY99dUIYdUs+oGKnZsfRvblEQWG
         ocX2BLvo1NYiAjFdkjkjxzZjXcWFrnFzb5FLYiSrg6g1V9WadG6OvjIhRMA81K66Edaa
         kbaQ==
X-Forwarded-Encrypted: i=1; AL+hErGsiM+FQHJY+Smipxe81Z8o2oz9+770qSP/rOKQdoJmjlYQkWSSEQk/SpgamgjF5zEhlIFdcngSUA==@kvack.org
X-Gm-Message-State: APuU4Z/8fNZUYkBaentycvPjAEqZMeT9aXPfDj/QD74n92zZjXWLhkXE
	wGJJ1oggmZQhiT4y4tB1zoAE4pEC3+zQLQ+TrQ5cZVHvTg0yF6InjgRetuIi+f2nvxE=
X-Gm-Gg: AZFdTZfbp2CZQvHWr7CRMcL1vr2cijUA8o84U3Eif3VtMkkPeJlmQSr6T5FefoAcVb3
	a/pzns29quFXOua6Tmf2vocbv3SGEwHUCvnw4mExqmLaePYTK8ngq6d4sRnJeiuRUvT8hgL9teJ
	c3PusQrq+XqWZAlIUP6nt8LJG92LKuTFk2C3Z/ltuqU+/QqbHzsW3k+bBSbflLsxuXV2ornbZuR
	UdzZv+sriPqEKbetkt0DlhkrDVdkb764dHrY0zDZLm4ek8Fv7YpbxrnTLyNl0zlh8s73ka4avI7
	nUGpYx479U6F067LxC2MkQDy+HZ2AL/JlQ20ymAIh2pPF654CcFPru2aM4gO9/4Bu3OphUXjV+o
	8iGH+MK0R2N+kHp9i/R9+udoIuyDKQYBm0FMJgYJyBmpo80kD0HDH46X24/SNjjz8M8siJEgF9g
	52ZmqXs/tu1uxEtJLN7h64d/b4BLIj6nEaV6qmFyz2fDSqGzslU+5Z8Ls82j/KeaA+2KMIatPk2
	y87G1a0W2xx4F7d8vDqOaAcRlmbO6O7p7zxBkkoXQrbLp85xMr4/1y2pLjRIiieAOcbBLlLwr0e
	wEALrlH/vKC/AsqOYqUk6jfdvo4Q6oAlOxitum+NEpAgG7NpKTeXBSxCAO4=
X-Received: by 2002:a17:90b:4b8b:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3b409d9bfacmr158793a91.3.1795071577008;
        Wed, 18 Nov 2026 22:59:37 -0800 (PST)
Received: from G6L4RL2QG9 ([2408:8440:c38:5ca5:3175:932a:757b:716a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402e75223sm597488a91.4.2026.11.18.22.59.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 22:59:36 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 1/7] kmsan: encapsulate per-page metadata access
Date: Thu, 19 Nov 2026 14:58:06 +0800
Message-ID: <20261119065812.89959-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119065812.89959-1-songmuchun@bytedance.com>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 01BEF12000B
X-Stat-Signature: btf7wftyunuzmfeo4iodxwpq3bob88ku
X-HE-Tag: 1795071578-607321
X-HE-Meta: U2FsdGVkX18X9f1WbDzyfuzWazR5lV1WHZymAo/FXkLH9dLtILAk7aePi0NMPa5vXfRPkfjQb8jrYWpxYyuE5WawPV1AY2V0qLAEAYYsSfjBXj7GVBm8WDf54dAqilPvICZEkyldbqaT2LD1SB1U4AiejjehTjBK0LbUkAHHyMagyeVwRGX7wp95D4KY41swLnfRXrdYNIESNsXBOBSm63du8IBPNPZfevAiBSo1+yXBUSuCiR6srio5mfg7KZgAQmn+DvpTEdMVIw5W0kJL2U7iP2hikBSdZkHiSM6WtJ2HqpG9OmrX59UGNN+s/xT52RFzQVeq4mH+DSKLzwmSN5mx+KXDxjpy+n7XLsgq+Mo+iV8//kn7O5afQ+gmnWGsjqWTECNm4QAQfQdYjOkactaOVwNNXbNaAy0f49Pial8WxdT2re18zAXLpo2lLHFGT1ecb6GeH5dmOSeUWIj0FeVDGTYqI6SSHVw3rcdpq8V3W5Zad7R58b/hc+63x1cuh9SpcbkZad4dHfhIALUB9wv0zgIF8TCUtadxzmWq/7Qvb+vODuXsQkHOaCD8hnW7I9XkmR4/L0jyyaiHUcuU16kBfMf7q4ijps+9sxeDOF2mEIbsPNRxrznk2Qm9OsasROYcfTR9QhXROiUXwkoVtGyh4fOoybYdy1pwM7GE6cnU55qYfrk0QHizRGg/LMjMwKGTjXBVZwdlWT/06Br5QPZReCYKxaBniOmSUVQv6+clXVlCFckRuoDpiWcfVAdaff2i7NyHnFhKHZJ7+eb6aq8BkuQdN/8N5J5/5FTJ3oguWmrAyavyXrvYXCtwq0vUaRurnpljj/fkQsFoEIFnBvxz15/CSfT57czCA+feiKZBCKHNOqTexEqXUOJ0vbFepGDunEnnnHAs6fk+afbzYa1LI6UT/jN2CiEplZDVAmPs5LW8iPP653We3SOUhsiiUoKD3Uf05xMAAeXNAGT
 gQ648geA
 yqf642ch4Aeq0ilVclqxba2DmJ1d6k16BMPgJx68/hSPOhpt/NIfBuaT4sIVRQLCmc07x9mqbgPHyxIzAyExCSEbbSUaIUHQVoHVCqeL6/w3btl19Grq9t00d0pkwb5gfJtydeLvsr6e0TBx79za9McsJejJYFRFkjM9Xbj5bo4IVk8mq6fnog0InEvqTh+PvtJpSz4DGqAp6j+ndqxqd3A3xWA6ayoBG0ObHsCqTW1+3kRPbGyzpJrQP3hKGXjE6DpLE5z9fjcK/jkM7j10okAmTUrW+PqedQErD4dZ/JRdsscL8gTxmiVGkOr60PksqWdks3eIjlXqS+pSnRYI6pwCrYG1IE0I/r9f4KWgFClUu4dpR/B4jY5uessWj8vgYuj+vOa4+CpZWsIUkerbupIx7ff1HKfnmHxqJhSclP6Co1n69Q1TPu4RfxJQU5zvMFHLAiuS/SZQ5JyIbSAb505XyaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KMSAN directly accesses page->kmsan_shadow and page->kmsan_origin
throughout the shadow implementation. This couples these users to
storing the metadata pointers in struct page, requiring every access
site to change when the storage moves elsewhere.

Introduce helpers that get and set both metadata page pointers as a pair
and convert the existing users to them.

kmsan_get_shadow_origin_ptr() is the main metadata lookup path for
compiler-instrumented memory accesses and requires both pointers. For
page-backed addresses, resolve the backing page once and obtain the
metadata pair through one lookup instead of calling the single-metadata
path twice. This also avoids duplicate lookups after moving the metadata
storage out of struct page.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
---
v3:
- Collect Reviewed-by and Tested-by from Chris Down

v2:
- Use one page metadata lookup for shadow and origin pointers (suggested
  by Chris Down)
---
 mm/kmsan/shadow.c | 166 +++++++++++++++++++++++++++++++---------------
 1 file changed, 111 insertions(+), 55 deletions(-)

diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 0c88d89bf0d6..300b48818af1 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -9,6 +9,7 @@
 
 #include <asm/kmsan.h>
 #include <asm/tlbflush.h>
+#include <linux/bits.h>
 #include <linux/cacheflush.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
@@ -20,29 +21,46 @@
 #include "../vmalloc.h"
 #include "kmsan.h"
 
-#define shadow_page_for(page) ((page)->kmsan_shadow)
+#define KMSAN_META_MASK_SHADOW		BIT(0)
+#define KMSAN_META_MASK_ORIGIN		BIT(1)
 
-#define origin_page_for(page) ((page)->kmsan_origin)
+struct page_metadata {
+	struct page *shadow;
+	struct page *origin;
+};
 
-static void *shadow_ptr_for(struct page *page)
+static inline struct page_metadata get_page_metadata(struct page *page)
 {
-	return page_address(shadow_page_for(page));
+	return (struct page_metadata) {
+		.shadow = page->kmsan_shadow,
+		.origin = page->kmsan_origin,
+	};
 }
 
-static void *origin_ptr_for(struct page *page)
+static inline void set_page_metadata(struct page *page, struct page_metadata meta)
 {
-	return page_address(origin_page_for(page));
+	page->kmsan_shadow = meta.shadow;
+	page->kmsan_origin = meta.origin;
 }
 
-static bool page_has_metadata(struct page *page)
+static inline void *shadow_ptr_for(struct page_metadata meta)
 {
-	return shadow_page_for(page) && origin_page_for(page);
+	return page_address(meta.shadow);
+}
+
+static inline void *origin_ptr_for(struct page_metadata meta)
+{
+	return page_address(meta.origin);
+}
+
+static inline bool page_has_metadata(struct page_metadata meta)
+{
+	return meta.shadow && meta.origin;
 }
 
 static void set_no_shadow_origin_page(struct page *page)
 {
-	shadow_page_for(page) = NULL;
-	origin_page_for(page) = NULL;
+	set_page_metadata(page, (struct page_metadata) {});
 }
 
 /*
@@ -79,11 +97,56 @@ static struct page *virt_to_page_or_null(void *vaddr)
 		return NULL;
 }
 
+static __always_inline
+struct shadow_origin_ptr __kmsan_get_metadata(void *address, unsigned int mask)
+{
+	struct shadow_origin_ptr ret = {};
+	struct page_metadata meta;
+	struct page *page;
+	u64 addr = (u64)address;
+	u64 origin_addr = ALIGN_DOWN(addr, KMSAN_ORIGIN_SIZE);
+
+	if (kmsan_internal_is_vmalloc_addr(address) ||
+	    kmsan_internal_is_module_addr(address)) {
+		if (mask & KMSAN_META_MASK_SHADOW)
+			ret.shadow = (void *)vmalloc_meta(address, KMSAN_META_SHADOW);
+		if (mask & KMSAN_META_MASK_ORIGIN)
+			ret.origin = (void *)vmalloc_meta((void *)origin_addr,
+							  KMSAN_META_ORIGIN);
+		return ret;
+	}
+
+	if (mask & KMSAN_META_MASK_SHADOW) {
+		ret.shadow = arch_kmsan_get_meta_or_null(address, KMSAN_META_SHADOW);
+		if (!ret.shadow)
+			goto lookup_page;
+	}
+	if (mask & KMSAN_META_MASK_ORIGIN)
+		ret.origin = arch_kmsan_get_meta_or_null((void *)origin_addr,
+							 KMSAN_META_ORIGIN);
+	if (ret.shadow || ret.origin)
+		return ret;
+
+lookup_page:
+	page = virt_to_page_or_null(address);
+	if (!page)
+		return ret;
+	meta = get_page_metadata(page);
+	if (!page_has_metadata(meta))
+		return ret;
+
+	if (mask & KMSAN_META_MASK_SHADOW)
+		ret.shadow = shadow_ptr_for(meta) + offset_in_page(addr);
+	if (mask & KMSAN_META_MASK_ORIGIN)
+		ret.origin = origin_ptr_for(meta) + offset_in_page(origin_addr);
+
+	return ret;
+}
+
 struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *address, u64 size,
 						     bool store)
 {
 	struct shadow_origin_ptr ret;
-	void *shadow;
 
 	/*
 	 * Even if we redirect this memory access to the dummy page, it will
@@ -95,12 +158,10 @@ struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *address, u64 size,
 		goto return_dummy;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(address, size));
-	shadow = kmsan_get_metadata(address, KMSAN_META_SHADOW);
-	if (!shadow)
+	ret = __kmsan_get_metadata(address, KMSAN_META_MASK_SHADOW |
+					    KMSAN_META_MASK_ORIGIN);
+	if (!ret.shadow)
 		goto return_dummy;
-
-	ret.shadow = shadow;
-	ret.origin = kmsan_get_metadata(address, KMSAN_META_ORIGIN);
 	return ret;
 
 return_dummy:
@@ -124,46 +185,36 @@ struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *address, u64 size,
  */
 void *kmsan_get_metadata(void *address, bool is_origin)
 {
-	u64 addr = (u64)address, off;
-	struct page *page;
-	void *ret;
-
-	if (is_origin)
-		addr = ALIGN_DOWN(addr, KMSAN_ORIGIN_SIZE);
-	address = (void *)addr;
-	if (kmsan_internal_is_vmalloc_addr(address) ||
-	    kmsan_internal_is_module_addr(address))
-		return (void *)vmalloc_meta(address, is_origin);
-
-	ret = arch_kmsan_get_meta_or_null(address, is_origin);
-	if (ret)
-		return ret;
-
-	page = virt_to_page_or_null(address);
-	if (!page)
-		return NULL;
-	if (!page_has_metadata(page))
-		return NULL;
-	off = offset_in_page(addr);
+	struct shadow_origin_ptr ret;
+	unsigned int mask;
 
-	return (is_origin ? origin_ptr_for(page) : shadow_ptr_for(page)) + off;
+	mask = is_origin ? KMSAN_META_MASK_ORIGIN : KMSAN_META_MASK_SHADOW;
+	ret = __kmsan_get_metadata(address, mask);
+	return is_origin ? ret.origin : ret.shadow;
 }
 
 void kmsan_copy_page_meta(struct page *dst, struct page *src)
 {
+	struct page_metadata dst_meta, src_meta;
+
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
-	if (!dst || !page_has_metadata(dst))
+	if (!dst)
 		return;
-	if (!src || !page_has_metadata(src)) {
+	dst_meta = get_page_metadata(dst);
+	if (!page_has_metadata(dst_meta))
+		return;
+	if (src)
+		src_meta = get_page_metadata(src);
+	if (!src || !page_has_metadata(src_meta)) {
 		kmsan_internal_unpoison_memory(page_address(dst), PAGE_SIZE,
 					       /*checked*/ false);
 		return;
 	}
 
 	kmsan_enter_runtime();
-	__memcpy(shadow_ptr_for(dst), shadow_ptr_for(src), PAGE_SIZE);
-	__memcpy(origin_ptr_for(dst), origin_ptr_for(src), PAGE_SIZE);
+	__memcpy(shadow_ptr_for(dst_meta), shadow_ptr_for(src_meta), PAGE_SIZE);
+	__memcpy(origin_ptr_for(dst_meta), origin_ptr_for(src_meta), PAGE_SIZE);
 	kmsan_leave_runtime();
 }
 EXPORT_SYMBOL(kmsan_copy_page_meta);
@@ -171,19 +222,18 @@ EXPORT_SYMBOL(kmsan_copy_page_meta);
 void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 {
 	bool initialized = (flags & __GFP_ZERO) || !kmsan_enabled;
-	struct page *shadow, *origin;
+	struct page_metadata meta;
 	depot_stack_handle_t handle;
 	int pages = 1 << order;
 
 	if (!page)
 		return;
 
-	shadow = shadow_page_for(page);
-	origin = origin_page_for(page);
+	meta = get_page_metadata(page);
 
 	if (initialized) {
-		__memset(page_address(shadow), 0, PAGE_SIZE * pages);
-		__memset(page_address(origin), 0, PAGE_SIZE * pages);
+		__memset(shadow_ptr_for(meta), 0, PAGE_SIZE * pages);
+		__memset(origin_ptr_for(meta), 0, PAGE_SIZE * pages);
 		return;
 	}
 
@@ -191,7 +241,7 @@ void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 	if (kmsan_in_runtime())
 		return;
 
-	__memset(page_address(shadow), -1, PAGE_SIZE * pages);
+	__memset(shadow_ptr_for(meta), -1, PAGE_SIZE * pages);
 	kmsan_enter_runtime();
 	handle = kmsan_save_stack_with_flags(flags, /*extra_bits*/ 0);
 	kmsan_leave_runtime();
@@ -200,7 +250,7 @@ void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 	 * to just fill the origin pages with @handle.
 	 */
 	for (int i = 0; i < PAGE_SIZE * pages / sizeof(handle); i++)
-		((depot_stack_handle_t *)page_address(origin))[i] = handle;
+		((depot_stack_handle_t *)origin_ptr_for(meta))[i] = handle;
 }
 
 void kmsan_free_page(struct page *page, unsigned int order)
@@ -238,8 +288,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 		goto ret;
 	}
 	for (int i = 0; i < nr; i++) {
-		s_pages[i] = shadow_page_for(pages[i]);
-		o_pages[i] = origin_page_for(pages[i]);
+		struct page_metadata meta = get_page_metadata(pages[i]);
+
+		s_pages[i] = meta.shadow;
+		o_pages[i] = meta.origin;
 	}
 	prot = PAGE_KERNEL;
 
@@ -289,10 +341,12 @@ void __init kmsan_init_alloc_meta_for_range(void *start, void *end)
 		page = virt_to_page_or_null((char *)start + addr);
 		shadow_p = virt_to_page((char *)shadow + addr);
 		set_no_shadow_origin_page(shadow_p);
-		shadow_page_for(page) = shadow_p;
 		origin_p = virt_to_page((char *)origin + addr);
 		set_no_shadow_origin_page(origin_p);
-		origin_page_for(page) = origin_p;
+		set_page_metadata(page, (struct page_metadata) {
+			.shadow = shadow_p,
+			.origin = origin_p,
+		});
 	}
 }
 
@@ -302,7 +356,9 @@ void kmsan_setup_meta(struct page *page, struct page *shadow,
 	for (int i = 0; i < (1 << order); i++) {
 		set_no_shadow_origin_page(&shadow[i]);
 		set_no_shadow_origin_page(&origin[i]);
-		shadow_page_for(&page[i]) = &shadow[i];
-		origin_page_for(&page[i]) = &origin[i];
+		set_page_metadata(&page[i], (struct page_metadata) {
+			.shadow = &shadow[i],
+			.origin = &origin[i],
+		});
 	}
 }
-- 
2.54.0


