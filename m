Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C33A606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H2rKIAAl
Received: by kanga.kvack.org (Postfix)
	id A981C6B05BC; Tue, 17 Nov 2026 04:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E7C6B05BD; Tue, 17 Nov 2026 04:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC046B05BE; Tue, 17 Nov 2026 04:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 794076B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:34:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFB19C0340
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:26 +0000 (UTC)
X-FDA: 85444100532.28.D76DDE0
Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	by imf18.hostedemail.com (Postfix) with ESMTP id 083221C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H2rKIAAl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVjEArGpfzLKglvqc3YXGN4z2hsAIb4Ii6LC+8XEfek=;
	b=VD8ljxpM4v2ZiCN0l+ktueQbPTKwXp9eZ35WwRdtH3QRuEgDvg9yW3iALW5PWunZC19hiE
	4/bxOJK0HEsaiwNxaDAN++cGDwY/7AZjeDFy8Zq7WwSCZegtCZXGz0D5uLCn5Llfvd1gR6
	XMfou0sAaKmw8+m6On/1auL+6HGWLaA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H2rKIAAl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908065;
	b=PaLIIDxazpvv8VkXFGADb1QXR9mzhfK6dXoDdqpRJQqcSq2lEX3CLsayUcFxhoxbj1wIji
	RC21veDKC0tmWKukCTpKNX9Dvb9KBYmzyydMc6378n+qR0GHkCpF0IdaVLeZIkr6nkKsdt
	ZgdZj+iEB8IQTuTzBcBWblW4y68hb9s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=osMdup1XthVBj9dZj7BkFJdDR3+5E/Rv1rSyQcK8Jac=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794908063; v=1; x=1795512863;
 b=H2rKIAAlMQX+xCzh2f7B3coiICfjjHHD74cFy+vvnGy5/4q/lmZmoa4yltUK/6GmZoxcZBKv
 snRvvjpQNA05gJ+5hYvefGvVT4s9VH4pZQdVzDgGWD7HpfwmbVq4UAq3ZEKB4Bo/QR25Cq6dr3M
 QggjyDxujfcWLPz/zqmUAbYM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e2236bfef0a0d9fc;
	Tue, 17 Nov 2026 09:34:23 +0000
X-Mizu-Trace-ID: e2236bfef0a0d9fc
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev,
	fvdl@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v5 2/3] mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
Date: Tue, 17 Nov 2026 17:33:58 +0800
Message-ID: <295af6601ce79f2c2b3dc4352a3279f0e6ac513e.1794907279.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794907279.git.zhengqi.arch@bytedance.com>
References: <cover.1794907279.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 083221C0006
X-Stat-Signature: 6a3a16pegbo17aw4d8hx4ghccr8zpowa
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794908064-307451
X-HE-Meta: U2FsdGVkX18mmJoIpNN7loVRWXcU3fyCv+cV56N/mqp1HaqVWyjBFsMkaqYcwRsCJH7RiUBaE9pYdbjBgzrTJQ/T/n532HUxwu6r3/wmFsSVrRfB2VduTtDRm3+C3MLVJxrOERc02XWa8rTQn2BkXWNLU7HPMIGCmWSvrA0hz/gCZ0Hyq+6VmbZG0Ep2fPg6WheoItfWEs/WGHNXjg7vAuaGVZHndmOvn2VHZGs6sVsDdMis7ZdaKCR9wX05FtdEQs6Urjbl9TkcyF/c7rIWFlBYDG499Xb//3uz5sa9ItDhWeBFduVZoeweafYXZGmxHn+Uv4GNaBa053TjOmBoBHB5oS2yKNFtS8zKPNnpanysNeR59Je1a3OXyx25+tGDgSvzkEL0HNXAjlS+ZeiMTtkSVx8SQs/HUCnZgpqDeObzqHN9BrFWqHGujBVqpKbUPL/4wYbeqnxcpVtfQhBVXMWAUDz945NU/BiIoHIK1VhNlhjPEgfqAZQYcNBXgLrX1NviwMULuh4OA2Wixrjk9wIK/+R+Eu3Hj6nLhtINNU3z0GPqZ0DWzha7V8jNmOi7c6oMNuQteaJHAk+pc2080L0+lyB1AAgX9ivrksgkYYGynlj1wF2WVROUU9hHZWBu6MXA/4VYfFBi+8yROMs51GY+1ZQGHUDBRkbGuBlWQLUa6DG9R95tUGO3IJuO3d2fe18B0XECKgz4kMA/rAr00wm5bsrx9f4EMqYhvLNFv/2EEEyup5TPmTSL1G2z+kcJTlW/quMhIdSx1M7+CN8KpKOoUE2yILUSO/MyAU9H5F1yGXHzs1wjRWbUlfcaU++Ye1pr9NzBpPnfptJN4XeooKF4bVbJo23uBjAc7vbNtv/lSDLDcKSAHa7Dz+Y5PXdhM3keyVvImBkyIBg6aQ6Bzxv1aQaGf7MFRVFZVc/7Wb0PWeL+G8EfavMYm127B7z4k9i56v/nHagDwkIUNLI
 SEd1qyLN
 ZUZR2IOjhuZkk3YZ9VOTO3yBNl//xMQDTpUlzdb0ZFNyEFXS1kIYtS9tam0gW+EhkMc69/9ogVUxPbjxX61RL+p+a279lpRbQBh1Lx2TbCJJGYmQB89EzpneXU4uWDZJUgWhld8sfLP271qw9vvvcyCmn+PeOV7wjxq6wLR7jmUjvD3lq5n3C6/Mm/RQhEDijc1q+pa+Buw7UZSLmimj3EG8OVP4rvs4MH7AfTyzNpG52a8D+YgSIEezDRMK3gUrxqHHfkD599ke1vsGHH3DnNTfwdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Long-term pinning rejects HugeTLB folios explicitly allocated from CMA,
causing unnecessary migration or pinning failures. These folios already
own their CMA memory and do not need to be migrated out for future CMA
allocations.

Add cma_folio_is_longterm_pinnable() to recognize these allocations
through HPG_cma. Allow them to be pinned even in ZONE_MOVABLE, since
memory blocks overlapping boot-time CMA areas cannot be offlined. Ordinary
movable allocations that borrow CMA memory remain unpinnable.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Cc: stable@vger.kernel.org
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Frank van der Linden <fvdl@google.com>
---
 include/linux/cma.h |  3 +++
 include/linux/mm.h  |  9 ++++++---
 mm/cma.c            | 11 +++++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1a..d829fd0355bae 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -21,6 +21,9 @@
 #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
 
 struct cma;
+struct folio;
+
+bool cma_folio_is_longterm_pinnable(struct folio *folio);
 
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index daf5c5b567ebc..e71aae8001831 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -38,6 +38,7 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
+#include <linux/cma.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -3015,15 +3016,18 @@ static inline bool is_zero_folio(const struct folio *folio)
 	return is_zero_page(&folio->page);
 }
 
-/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
 #ifdef CONFIG_MIGRATION
+/*
+ * MIGRATE_CMA and ZONE_MOVABLE folios cannot normally be long-term pinned.
+ * CMA may allow pinning folios explicitly allocated from its areas.
+ */
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
 #ifdef CONFIG_CMA
 	int mt = folio_migratetype(folio);
 
 	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
-		return false;
+		return cma_folio_is_longterm_pinnable(folio);
 #endif
 	/* The zero page can be "pinned" but gets special handling. */
 	if (is_zero_folio(folio))
@@ -3042,7 +3046,6 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
 
 	/* Otherwise, non-movable zone folios can be pinned. */
 	return !folio_is_zone_movable(folio);
-
 }
 #else
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
diff --git a/mm/cma.c b/mm/cma.c
index 9ec1d1fd5dff5..fea5d1015319d 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -29,6 +29,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
+#include <linux/hugetlb.h>
 #include <trace/events/cma.h>
 
 #include "internal.h"
@@ -38,6 +39,16 @@
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
 
+bool cma_folio_is_longterm_pinnable(struct folio *folio)
+{
+	/*
+	 * Explicitly allocated CMA folios own their CMA memory and can be
+	 * pinned even in ZONE_MOVABLE, as CMA memory cannot be offlined.
+	 * For now, only HugeTLB tracks these allocations with a folio flag.
+	 */
+	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
+}
+
 phys_addr_t cma_get_base(const struct cma *cma)
 {
 	WARN_ON_ONCE(cma->nranges != 1);
-- 
2.54.0


