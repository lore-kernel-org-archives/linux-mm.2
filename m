Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF6C6EC01A2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610886B0093; Mon, 23 Mar 2026 03:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8456B0095; Mon, 23 Mar 2026 03:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE4D6B0096; Mon, 23 Mar 2026 03:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6396B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:49:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4A95C329B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:37 +0000 (UTC)
X-FDA: 84576553194.08.0551A73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F2B9A40005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLj2uAa3;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUoq4AqXxwwvH6idpeZLZNb7HSgeuk0Y/FgULYcntaU=;
	b=e4XM8/O6qjvyBs6ds3AYpEHTjvsjIVRyao/INdF/v7bAVO0wzQsSd3HOK5w1xeeqj5DnPj
	peWk6PO3UdeJztUOj5X2JsDiX+usDwanwcPBjWg0O1lO0L8HV9mYgXn/8FwsCbqgWUVJQT
	MOzpl3VzzHdkshFEIdfKoRjIdnKDaNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252176; a=rsa-sha256;
	cv=none;
	b=m+12I4Loaom1JmKMLpJhsk5mvNqcn4EKLzwzUFHtm4PksLI4u3U5RJ4v6V5lsb42TRDbcM
	T5twyQgyCg0BBOGSSoEa0u5K1vNRFAgYKJ3wYObMgbUAog6frQbMIo87SDnt9eOEqBEdxA
	iOFoLl6IHsDmc0FK+GP0VckKJn+AEzw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLj2uAa3;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DDA6406E9;
	Mon, 23 Mar 2026 07:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591E2C2BC9E;
	Mon, 23 Mar 2026 07:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252175;
	bh=BA3ifIM8vMxNHhaniMoWafVGKix2KJOOnEEIB0IJslA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLj2uAa3+/NwQuaTBTXMkFS5rLYfpWnRharPWCiY5k6pdAcO4J3dmwxqJ62FgiBQQ
	 6QZgWy9Mlf+tLly2+EmiGoDig1TtvZff/B4jJXf2DfbTWewwveYymwfcCOjtHZQiEM
	 A5doCHhRHLPTbVpCiM0WsxIRUNgKw1Bx20fB8JozatJ8LOTL2kl9c4hvj5qA9sfO+n
	 AzfuKIyOe63JrT4uxw94ft2d5Kx2CM1R8jWppspvBEBJEOpyiO3cITWk2VSYdG1nuP
	 qsE5AeX67dLQzBsQgP/eryYFm2ElRC0wJ8E8PQf9c8rRCCLLCxB/Hagi8E4T2A58pl
	 wNxCDVFEoh0Dw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 4/9] mm: move free_reserved_area() to mm/memblock.c
Date: Mon, 23 Mar 2026 09:48:31 +0200
Message-ID: <20260323074836.3653702-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m18b763at4n8kuhhu5kowwihcskzs76m
X-Rspam-User: 
X-Rspamd-Queue-Id: F2B9A40005
X-Rspamd-Server: rspam12
X-HE-Tag: 1774252175-741411
X-HE-Meta: U2FsdGVkX18+3nMQqAND9dWEKoeA4kHc2aE3C3E8aVUxHE8v2rx0M29+AELmCigN507m1GO9wOdk+lslO1rQpOP0RgFWG2PgP1d2lKf644yBkf9H7KzNloLjezXSlsEoxaZ5vDj7lUlH4ihbViVh4VOpjphY97ACreD70K8U89EsRYqfvpK9S4ZDQcnVJCWB6Cv99+3tBGeweMAAmG73wdHWsOTHf7Cz8xnlnYF/TWe2ZUkAiKAdAKhV0oPZZc7SReWLqOjoLGyaJlpu1k1XAuXkwDGHbvS95xGBk6OEa9+DaQgJZKoAlCA7c1NxDAVXEog0TTTj7Qq64sW+eBFZzefndQX1+it/OT/YU00fuo/KElQWIb8TfvZTlp9LmU4N2b6QBOIwvO9926mHSdp0YOG9ogmKkJnGCyy4v6Fuv1osZ1uuaYxL8+wJD7PYndNAlSsF0jsekDu2m6xTW5THBMbBlTIHZACnqpVLeqmn+9DvtpufzxIdWB8kW5Ym0ZAE2mCysvr52m4zzrJhCwONnOZUwFIRlXi0aYgRsqjlSfFHhLJ1srN0QnHWpyzsQS3PgUxVMxI6cWN2+MlTRIWbG76YhLzZxqZ3WwR6HKOHILVo0pvV5pan96OX8VWnlPNQtuCcTiG1LXr7BwRotmgNiM46prqvsippQ+TGdacDDN6avSa6uXtHVCnQ/5wfj9ddX/AUb+jy3Nc/TrLc1Pg397nLUGnaeUIf02AOP+9pZT+DBAyz0G3f/5vBYgJdsIG5MsEDYMojz4h2t/vPegr8YBoEnV5rcaRbMjlUs8thyszO6VAjtALOAqUp9pTk8ImTKVEWGqe98AV3fpMLizHu695KBRTSFLeSB4bbDsf4n6Q3LVEu/quaaW9sgt+P4ST/T6JK32lyTuah5AVko9v5XcQcqmdaB/0NrvX9b9PvrgV544TViv/VMHhIKDj3wL+Kpn9bi4Vgpf5j7cTAoQ4
 jN6lhvHO
 TnGygPtEhvedCdsOZInZyHThQSmv9TB8j/itwLKh+fM0UnbefdOinBqi61BMMSCLRA+wN794s+eVWR1o++gwhUK4eQ6Q4T2+LtOWHoJfP5InTZKfxwa4ddRYPfafDjNT7iDVMTX2vbCNBYsY+J2GcXHzLMwqS3IOTgHqjn8QecWTGlKviFfnH8mSrsP2F3mWi18GTqjI5Kv+zZn7gdS9C2fHzsHFZhgN7gLaNIGvEWdTwaJppvTI0ymF4+pDXA4/8yx1uCCOBy1or1cXr9v5Qbo3EXG/XeEIgBidM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

free_reserved_area() is related to memblock as it frees reserved memory
back to the buddy allocator, similar to what memblock_free_late() does.

Move free_reserved_area() to mm/memblock.c to prepare for further
consolidation of the functions that free reserved memory.

No functional changes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c                     | 37 ++++++++++++++++++++++++++++++-
 mm/page_alloc.c                   | 36 ------------------------------
 tools/include/linux/mm.h          |  1 +
 tools/testing/memblock/internal.h | 34 +++++++++++++++++++++++++---
 4 files changed, 68 insertions(+), 40 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index d4a02f1750e9..c0896efbee97 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -893,6 +893,42 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 	return memblock_remove_range(&memblock.memory, base, size);
 }
 
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
+{
+	void *pos;
+	unsigned long pages = 0;
+
+	start = (void *)PAGE_ALIGN((unsigned long)start);
+	end = (void *)((unsigned long)end & PAGE_MASK);
+	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
+		struct page *page = virt_to_page(pos);
+		void *direct_map_addr;
+
+		/*
+		 * 'direct_map_addr' might be different from 'pos'
+		 * because some architectures' virt_to_page()
+		 * work with aliases.  Getting the direct map
+		 * address ensures that we get a _writeable_
+		 * alias for the memset().
+		 */
+		direct_map_addr = page_address(page);
+		/*
+		 * Perform a kasan-unchecked memset() since this memory
+		 * has not been initialized.
+		 */
+		direct_map_addr = kasan_reset_tag(direct_map_addr);
+		if ((unsigned int)poison <= 0xFF)
+			memset(direct_map_addr, poison, PAGE_SIZE);
+
+		free_reserved_page(page);
+	}
+
+	if (pages && s)
+		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
+
+	return pages;
+}
+
 /**
  * memblock_free - free boot memory allocation
  * @ptr: starting address of the  boot memory allocation
@@ -1776,7 +1812,6 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 		totalram_pages_inc();
 	}
 }
-
 /*
  * Remaining API functions
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..df3d61253001 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6234,42 +6234,6 @@ void adjust_managed_page_count(struct page *page, long count)
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
-unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
-{
-	void *pos;
-	unsigned long pages = 0;
-
-	start = (void *)PAGE_ALIGN((unsigned long)start);
-	end = (void *)((unsigned long)end & PAGE_MASK);
-	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
-		struct page *page = virt_to_page(pos);
-		void *direct_map_addr;
-
-		/*
-		 * 'direct_map_addr' might be different from 'pos'
-		 * because some architectures' virt_to_page()
-		 * work with aliases.  Getting the direct map
-		 * address ensures that we get a _writeable_
-		 * alias for the memset().
-		 */
-		direct_map_addr = page_address(page);
-		/*
-		 * Perform a kasan-unchecked memset() since this memory
-		 * has not been initialized.
-		 */
-		direct_map_addr = kasan_reset_tag(direct_map_addr);
-		if ((unsigned int)poison <= 0xFF)
-			memset(direct_map_addr, poison, PAGE_SIZE);
-
-		free_reserved_page(page);
-	}
-
-	if (pages && s)
-		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
-
-	return pages;
-}
-
 void free_reserved_page(struct page *page)
 {
 	clear_page_tag_ref(page);
diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 028f3faf46e7..4407d8396108 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -17,6 +17,7 @@
 
 #define __va(x) ((void *)((unsigned long)(x)))
 #define __pa(x) ((unsigned long)(x))
+#define __pa_symbol(x) ((unsigned long)(x))
 
 #define pfn_to_page(pfn) ((void *)((pfn) * PAGE_SIZE))
 
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index 009b97bbdd22..b72be2968104 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -11,9 +11,22 @@ static int memblock_debug = 1;
 
 #define pr_warn_ratelimited(fmt, ...)    printf(fmt, ##__VA_ARGS__)
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 bool mirrored_kernelcore = false;
 
 struct page {};
+static inline void *page_address(struct page *page)
+{
+	BUG();
+	return page;
+}
+
+static inline struct page *virt_to_page(void *virt)
+{
+	BUG();
+	return virt;
+}
 
 void memblock_free_pages(unsigned long pfn, unsigned int order)
 {
@@ -23,10 +36,25 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
-static inline unsigned long free_reserved_area(void *start, void *end,
-					       int poison, const char *s)
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
+void free_reserved_page(struct page *page);
+
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
+
+#define for_each_valid_pfn(pfn, start_pfn, end_pfn)			 \
+	for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
+
+static inline void *kasan_reset_tag(const void *addr)
+{
+	return (void *)addr;
+}
+
+static inline bool __is_kernel(unsigned long addr)
 {
-	return 0;
+	return false;
 }
 
 #endif
-- 
2.53.0


