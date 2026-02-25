Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66522FD3775
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23B06B00C9; Wed, 25 Feb 2026 11:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AACEF6B00CA; Wed, 25 Feb 2026 11:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BDD6B00CB; Wed, 25 Feb 2026 11:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 717906B00C9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AA0714067E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:50 +0000 (UTC)
X-FDA: 84483527940.16.9B4C704
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DF56100014
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="F/EGKh1E";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3piSfaQgKCL8ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3piSfaQgKCL8ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037288; a=rsa-sha256;
	cv=none;
	b=WeRdO5L+vXFTGuZ98i57lsrdu/0Xdn9SSupgDiUiuZi427/+VVx84qM/djKq6V44jm+0bG
	SEMsSUjAADNFWUukm49KVuMPvO1gBp5H5xB9q4mdvc33Fup7vj7q5AwMy5kbUYGzBLJMYu
	d9O4RNs6984PCgcw8OO1vvhD7Nj0JNI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="F/EGKh1E";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3piSfaQgKCL8ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3piSfaQgKCL8ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PV8VKqCr5gwSy+3zYzyUYTFEHqp60EEFKebqYSiuyow=;
	b=02FpbVgyDZxWQiYzGaPimdevbwdb9RxL7zoeKpBDBgd0uWBmbSmGeKdob07soKPcIjoltV
	rgtTpXNvK3vx7n61+GT11GZHTZvtJAmTPrCsgdPxsUm1RNsXj0hT29UuBrBRd4UxiyywiE
	3ebxYDcM4Yg0OKTL/I9PXJbbs7hRbz0=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8f96f3e197so578989566b.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037287; x=1772642087; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PV8VKqCr5gwSy+3zYzyUYTFEHqp60EEFKebqYSiuyow=;
        b=F/EGKh1EgAlt2gugxnAbL/b5Gxr/pSrujgNQXb1AjQ1f1aIehtKXBT1Buki2PUTN0m
         XbR/mXNjPDrEC9CK2DsFYz3tbbxkWnOFZ+DNYHPLysdEXlxYZYW1oZxGwJEpMJj83/zF
         dQMgosIaNaFrr+0dTNaGCT0wWc1u07IQaWwhSZxTEQzsnTpRnTif9FvGjbA9uLIm1aHt
         dH7TbLdLvsyMGp7sOGl7RiF7EvxZ8hJCxKKTrUVdJuU3QuF5AlYOCvBkyoMbzCFzfo0e
         +0cxHc14xrNXebb9aXhPUsIfY+VbT9MzKacR6rtSKX6YCk6ztEWQ+tS64mGUarGNZj4T
         gL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037287; x=1772642087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PV8VKqCr5gwSy+3zYzyUYTFEHqp60EEFKebqYSiuyow=;
        b=t2sNt3n2EvMEcHwQ9Jba5TybmfLHo8pj0VGWBPNDYrt/gjRnrbGxbJ3vpBV9PN18No
         DzoCbiXhdG8rTjG+wNqRhH/RYjW8c+kx8/aXbh3RTCnJdMPUJA0ggmZX9P5kU69aJmte
         m5so8J29DgpX7BWIbYfVTk9DFLK++56WTEbl9cF6emoKdeg0E2wXLZdPXvjd6gdj4JJQ
         f7aNwFaauzFO5gW5JZAgw9mKD/Gw7lKhBRXkhqRnROStzoR87Uck36wBh9YgEzogvt+Y
         tyZuy2NDUO4S8tB+hzyRaF4Y4Sjw5EDPV+HrBjkDZvzeA9T4h69pnWxAnE3F8cXEaTNX
         nafg==
X-Gm-Message-State: AOJu0YyN9MBtx58FK6IkYtofWLyRGzywYKYXxH5je5ULEJU/zbna/pzG
	iYGY/MgGmaLHBM6oKdiqCdjRhmps/Z9b/fnratCJKtSWQB5w8AIxKxPfKiTuyzDeivl012XTIw6
	+eyMCH5m2xTBA9Q==
X-Received: from ejff26.prod.google.com ([2002:a17:906:31da:b0:b8f:9d74:ef7b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:960a:b0:b8a:fd04:c789 with SMTP id a640c23a62f3a-b9351659aafmr63321066b.22.1772037286212;
 Wed, 25 Feb 2026 08:34:46 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:33 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-8-e8808a03cd66@google.com>
Subject: [PATCH RFC 08/19] mm: introduce freetype_t
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1DF56100014
X-Stat-Signature: 6zcge9z9c3pr6s4csyuad9drg66ou16q
X-HE-Tag: 1772037287-545960
X-HE-Meta: U2FsdGVkX18ugFvl8+sroeQKNqd+Q+HyGXDp8DdMOcvqXzfce6JjsckKQ/cfJp3SEGPi+XUkfy9j4lqKQ+B31h1FqCnrSNXo7wLDzN0wf1yJM9xDD/35rVeOy5fnHdrW4wx3tY0Ucxx1J1A6ENEjDKpFht+TI9RaD+hw6wTIPXHuY29nRPMq0HL8hD3zWPJBkycSTyCIZmffURdlxUOPLGhR4AGqNmLG5PFOKSOatwWn5G0e5PFaNAvNPjbZL9ro/d5tLianPtDux/Jy9qSKdbOE1DOnkF/0eqqBvUT5DP333XgvvNaEKj22ldw4xzc5bYFbksoDO0v2/QCSvS6daI0UBQK664rFPAFABO820+FQvc9JW4ftkg7aAd9d5AesEy/8fL8bNQW+kk12JrmJJR/acHBKOX6L0T4+JgPzubd6J7+0d4KoDyHJf8qdOGqRPUHRtl7OGPWXiNCTQ4wCQDzvoo7MZ+03Fq+bpzehH/DYG4Ihc6P9W0rxeOv2QA/iSgBKKN/jm64nI563W8jBVsq61szGHAFDS3UIQdkXn2KlBcIwGLrY63MKH5TxcED+QD6sj20H07MSZ13a9Kjk930yW+O79PBceZd0+u8C5DZgX+DFTsxT3+fv4OTv3eoBorVO11uJbas7tnZ7yccDRaK3o0aIbdviWuxzcvqGqMjMc4cQLCvCo87dvCuG86zLX2h8lQ5uk/VCWwtiECcJpEKgElodNNox9+UAlTMVbytPkro7A5MR5ywx5i1Qv/1m/VDAO23Woo6dP7539XyxjEZuGy1JY0IdKz4Cao/ceRehJjkJg0ZyOG9VlzzuDOvuCAYT2pS00+6BJps0hJZxbmXC+gok+xmJWLcioYd7PdBIMU680VaFdrwRWHPpvg0ptefwwWv0hptNN9Bc/PB80Mhfl3PK8WSEtvhwTeC5va54tBThIh2lDgcDHX5q3gzZgSGluwsu69ogrCCuejc
 fW6juaee
 w/286iKc9a5SK0a5dR1cXeh1ePkKHb6SVp7REPwBtPvRnD8B8NTA3D4Bn5UUpq7MuNT/w2Pxf8bm3UxfEIJlhylmnJs5CkIorLFS1h6Mw+rOvOLehRd6/ZD0RynAGJVJqLmXBErKsPCwHrp9C6/aEXyJyK0yxs833f5pv3018CeB0ahyZ7m2XMhUNdUNOmt/Bgi1KmpzSLsKQ2f9gdbo63EPIHaqrIvDqq8AC1L/HKsdvooWQnCQJ+2QDF59lk+1VapJz2suHx3dh7m6ukX62mpXyhxXgHBtbMcE86uU1NlP1f/gVnxGXsFKWoNBt7BcVICXRF76CuC9mipjDkCWzoemW9GsZychpICk0fDNV558US0jQh5tl3C5oLrl03eivrFHLhksg0B8aPxhSZLw+TVUTog8R1qFMCEoOxVATFazq9gRdlULSu8nZXksjfj6snRdRlYr0OBUOhw4YPFO7NcIsCmefqmzSopp+BT8PQrd8bBTkIibZi5ULT56auhSXNegjvMLVoRQD1yfMR/kSLRNmba74oIsfR9W6+C4DG4+5AzRZ3mmTlT2Li8DaIrHZOCV9zyPwUUYuXbcpLL4qJlpaeIWuQncQ7EqbTvY3TUP1dQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is preparation for teaching the page allocator to break up free
pages according to properties that have nothing to do with mobility. For
example it can be used to allocate pages that are non-present in the
physmap, or pages that are sensitive in ASI.

For these usecases, certain allocator behaviours are desirable:

- A "pool" of pages with the given property is usually available, so
  that pages can be provided with the correct sensitivity without
  zeroing/TLB flushing.

- Pages are physically grouped by the property, so that large
  allocations rarely have to alter the pagetables due to ASI.

- The properties can be forced to vary only at a certain fixed address
  granularity, so that the pagetables can all be pre-allocated. This is
  desirable because the page allocator will be changing mappings:
  pre-allocation is a straightforward way to avoid recursive allocations
  (of pagetables).

It seems that the existing infrastructure for grouping pages by
mobility, i.e. pageblocks and migratetypes, serves this purpose pretty
nicely. However, overloading migratetype itself for this purpose looks
like a road to maintenance hell. In particular, as soon as such
properties become orthogonal to migratetypes, it would start to require
"doubling" the migratetypes.

Therefore, introduce a new higher-level concept, called "freetype"
(because it is used to index "free"lists) that can encode extra
properties, orthogonally to mobility, via flags.

Since freetypes and migratetypes would be very easy to mix up, freetypes
are (at least for now) stored in a struct typedef similar to atomic_t.
This provides type-safety, but comes at the expense of being pretty
annoying to code with. For instance, freetype_t cannot be compared with
the == operator. Once this code matures, if the freetype/migratetype
distinction gets less confusing, it might be wise to drop this
struct and just use ints.

Because this will eventually be needed from pageblock-flags.h, put this
in its own header instead of directly in mmzone.h.

To try and reduce review pain for such a churny patch, first introduce
freetypes as nothing but an indirection over migratetypes. The helpers
concerned with the flags are defined, but only as stubs. Convert
everything over to using freetypes wherever they are needed to index
freelists, but maintain references to migratetypes in code that really
only cares specifically about mobility.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/freetype.h |  38 +++++
 include/linux/gfp.h      |  16 +-
 include/linux/mmzone.h   |  49 +++++-
 mm/compaction.c          |  35 +++--
 mm/internal.h            |  17 ++-
 mm/page_alloc.c          | 388 +++++++++++++++++++++++++++++------------------
 mm/page_isolation.c      |   2 +-
 mm/page_owner.c          |   7 +-
 mm/page_reporting.c      |   4 +-
 mm/show_mem.c            |   4 +-
 10 files changed, 370 insertions(+), 190 deletions(-)

diff --git a/include/linux/freetype.h b/include/linux/freetype.h
new file mode 100644
index 0000000000000..9f857d10bb5db
--- /dev/null
+++ b/include/linux/freetype.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_FREETYPE_H
+#define _LINUX_FREETYPE_H
+
+#include <linux/types.h>
+
+/*
+ * A freetype is the index used to identify free lists. This consists of a
+ * migratetype, and other bits which encode orthogonal properties of memory.
+ */
+typedef struct {
+	int migratetype;
+} freetype_t;
+
+/*
+ * Return a dense linear index for freetypes that have lists in the free area.
+ * Return -1 for other freetypes.
+ */
+static inline int freetype_idx(freetype_t freetype)
+{
+	return freetype.migratetype;
+}
+
+/* No freetype flags actually exist yet. */
+#define NR_FREETYPE_IDXS MIGRATE_TYPES
+
+static inline unsigned int freetype_flags(freetype_t freetype)
+{
+	/* No flags supported yet. */
+	return 0;
+}
+
+static inline bool freetypes_equal(freetype_t a, freetype_t b)
+{
+	return a.migratetype == b.migratetype;
+}
+
+#endif /* _LINUX_FREETYPE_H */
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 23240208a91fc..f189bee7a974c 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -17,8 +17,10 @@ struct mempolicy;
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
 #define GFP_MOVABLE_SHIFT 3
 
-static inline int gfp_migratetype(const gfp_t gfp_flags)
+static inline freetype_t gfp_freetype(const gfp_t gfp_flags)
 {
+	int migratetype;
+
 	VM_WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 	BUILD_BUG_ON((1UL << GFP_MOVABLE_SHIFT) != ___GFP_MOVABLE);
 	BUILD_BUG_ON((___GFP_MOVABLE >> GFP_MOVABLE_SHIFT) != MIGRATE_MOVABLE);
@@ -26,11 +28,15 @@ static inline int gfp_migratetype(const gfp_t gfp_flags)
 	BUILD_BUG_ON(((___GFP_MOVABLE | ___GFP_RECLAIMABLE) >>
 		      GFP_MOVABLE_SHIFT) != MIGRATE_HIGHATOMIC);
 
-	if (unlikely(page_group_by_mobility_disabled))
-		return MIGRATE_UNMOVABLE;
+	if (unlikely(page_group_by_mobility_disabled)) {
+		migratetype = MIGRATE_UNMOVABLE;
+	} else {
+		/* Group based on mobility */
+		migratetype = (__force unsigned long)(gfp_flags & GFP_MOVABLE_MASK)
+			>> GFP_MOVABLE_SHIFT;
+	}
 
-	/* Group based on mobility */
-	return (__force unsigned long)(gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
+	return migrate_to_freetype(migratetype, 0);
 }
 #undef GFP_MOVABLE_MASK
 #undef GFP_MOVABLE_SHIFT
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fc4d499fbbd2b..66a4cfc2afcb0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -5,6 +5,7 @@
 #ifndef __ASSEMBLY__
 #ifndef __GENERATING_BOUNDS_H
 
+#include <linux/freetype.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/list_nulls.h>
@@ -125,24 +126,62 @@ static inline bool migratetype_is_mergeable(int mt)
 
 #define for_each_free_list(list, zone, order) \
 	for (order = 0; order < NR_PAGE_ORDERS; order++) \
-		for (unsigned int type = 0; \
-		     list = &zone->free_area[order].free_list[type], \
-		     type < MIGRATE_TYPES; \
-		     type++) \
+		for (unsigned int idx = 0; \
+		     list = &zone->free_area[order].free_list[idx], \
+		     idx < NR_FREETYPE_IDXS; \
+		     idx++)
+
+static inline freetype_t migrate_to_freetype(enum migratetype mt,
+					     unsigned int flags)
+{
+	freetype_t freetype;
+
+	/* No flags supported yet. */
+	VM_WARN_ON_ONCE(flags);
+
+	freetype.migratetype = mt;
+	return freetype;
+}
+
+static inline enum migratetype free_to_migratetype(freetype_t freetype)
+{
+	return freetype.migratetype;
+}
+
+/* Convenience helper, return the freetype modified to have the migratetype. */
+static inline freetype_t freetype_with_migrate(freetype_t freetype,
+					       enum migratetype migratetype)
+{
+	return migrate_to_freetype(migratetype, freetype_flags(freetype));
+}
 
 extern int page_group_by_mobility_disabled;
 
+freetype_t get_pfnblock_freetype(const struct page *page, unsigned long pfn);
+
 #define get_pageblock_migratetype(page) \
 	get_pfnblock_migratetype(page, page_to_pfn(page))
 
+#define get_pageblock_freetype(page) \
+	get_pfnblock_freetype(page, page_to_pfn(page))
+
 #define folio_migratetype(folio) \
 	get_pageblock_migratetype(&folio->page)
 
 struct free_area {
-	struct list_head	free_list[MIGRATE_TYPES];
+	struct list_head	free_list[NR_FREETYPE_IDXS];
 	unsigned long		nr_free;
 };
 
+static inline
+struct list_head *free_area_list(struct free_area *area, freetype_t type)
+{
+	int idx = freetype_idx(type);
+
+	VM_BUG_ON(idx < 0);
+	return &area->free_list[idx];
+}
+
 struct pglist_data;
 
 #ifdef CONFIG_NUMA
diff --git a/mm/compaction.c b/mm/compaction.c
index cf65a3425500c..2b26bd9405035 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1359,7 +1359,7 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 static bool suitable_migration_source(struct compact_control *cc,
 							struct page *page)
 {
-	int block_mt;
+	freetype_t block_ft;
 
 	if (pageblock_skip_persistent(page))
 		return false;
@@ -1367,12 +1367,12 @@ static bool suitable_migration_source(struct compact_control *cc,
 	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
 		return true;
 
-	block_mt = get_pageblock_migratetype(page);
+	block_ft = get_pageblock_freetype(page);
 
-	if (cc->migratetype == MIGRATE_MOVABLE)
-		return is_migrate_movable(block_mt);
+	if (free_to_migratetype(cc->freetype) == MIGRATE_MOVABLE)
+		return is_migrate_movable(free_to_migratetype(block_ft));
 	else
-		return block_mt == cc->migratetype;
+		return freetypes_equal(block_ft, cc->freetype);
 }
 
 /* Returns true if the page is within a block suitable for migration to */
@@ -1963,7 +1963,8 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 	 * reduces the risk that a large movable pageblock is freed for
 	 * an unmovable/reclaimable small allocation.
 	 */
-	if (cc->direct_compaction && cc->migratetype != MIGRATE_MOVABLE)
+	if (cc->direct_compaction &&
+	    free_to_migratetype(cc->freetype) != MIGRATE_MOVABLE)
 		return pfn;
 
 	/*
@@ -2234,7 +2235,7 @@ static bool should_proactive_compact_node(pg_data_t *pgdat)
 static enum compact_result __compact_finished(struct compact_control *cc)
 {
 	unsigned int order;
-	const int migratetype = cc->migratetype;
+	const freetype_t freetype = cc->freetype;
 	int ret;
 
 	/* Compaction run completes if the migrate and free scanner meet */
@@ -2309,25 +2310,27 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 	for (order = cc->order; order < NR_PAGE_ORDERS; order++) {
 		struct free_area *area = &cc->zone->free_area[order];
 
-		/* Job done if page is free of the right migratetype */
-		if (!free_area_empty(area, migratetype))
+		/* Job done if page is free of the right freetype */
+		if (!free_area_empty(area, freetype))
 			return COMPACT_SUCCESS;
 
 #ifdef CONFIG_CMA
 		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
-		if (migratetype == MIGRATE_MOVABLE &&
-			!free_area_empty(area, MIGRATE_CMA))
+		if (free_to_migratetype(freetype) == MIGRATE_MOVABLE &&
+		    !free_area_empty(area, freetype_with_migrate(cc->freetype,
+								 MIGRATE_CMA)))
 			return COMPACT_SUCCESS;
 #endif
 		/*
 		 * Job done if allocation would steal freepages from
-		 * other migratetype buddy lists.
+		 * other freetype buddy lists.
 		 */
-		if (find_suitable_fallback(area, order, migratetype, true, NULL)
+		if (find_suitable_fallback(area, order, freetype, true, NULL)
 		    == FALLBACK_FOUND)
 			/*
-			 * Movable pages are OK in any pageblock. If we are
-			 * stealing for a non-movable allocation, make sure
+			 * Movable pages are OK in any pageblock of the right
+			 * sensitivity. If we are * stealing for a
+			 * non-movable allocation, make sure
 			 * we finish compacting the current pageblock first
 			 * (which is assured by the above migrate_pfn align
 			 * check) so it is as free as possible and we won't
@@ -2532,7 +2535,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 		INIT_LIST_HEAD(&cc->freepages[order]);
 	INIT_LIST_HEAD(&cc->migratepages);
 
-	cc->migratetype = gfp_migratetype(cc->gfp_mask);
+	cc->freetype = gfp_freetype(cc->gfp_mask);
 
 	if (!is_via_compact_memory(cc->order)) {
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
diff --git a/mm/internal.h b/mm/internal.h
index 1d88e56a9dee0..cac292dcd394f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -10,6 +10,7 @@
 #include <linux/fs.h>
 #include <linux/khugepaged.h>
 #include <linux/mm.h>
+#include <linux/mmzone.h>
 #include <linux/mm_inline.h>
 #include <linux/pagemap.h>
 #include <linux/pagewalk.h>
@@ -658,7 +659,7 @@ struct alloc_context {
 	struct zonelist *zonelist;
 	nodemask_t *nodemask;
 	struct zoneref *preferred_zoneref;
-	int migratetype;
+	freetype_t freetype;
 
 	/*
 	 * highest_zoneidx represents highest usable zone index of
@@ -809,8 +810,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
-extern void __putback_isolated_page(struct page *page, unsigned int order,
-				    int mt);
+void __putback_isolated_page(struct page *page, unsigned int order,
+			     freetype_t freetype);
 extern void memblock_free_pages(unsigned long pfn, unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context);
@@ -968,7 +969,7 @@ struct compact_control {
 	short search_order;		/* order to start a fast search at */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	int order;			/* order a direct compactor needs */
-	int migratetype;		/* migratetype of direct compactor */
+	freetype_t freetype;		/* freetype of direct compactor */
 	const unsigned int alloc_flags;	/* alloc flags of a direct compactor */
 	const int highest_zoneidx;	/* zone index of a direct compactor */
 	enum migrate_mode mode;		/* Async or sync migration mode */
@@ -1029,7 +1030,7 @@ static inline void init_cma_pageblock(struct page *page)
 #endif
 
 enum fallback_result {
-	/* Found suitable migratetype, *mt_out is valid. */
+	/* Found suitable fallback, *ft_out is valid. */
 	FALLBACK_FOUND,
 	/* No fallback found in requested order. */
 	FALLBACK_EMPTY,
@@ -1038,11 +1039,11 @@ enum fallback_result {
 };
 enum fallback_result
 find_suitable_fallback(struct free_area *area, unsigned int order,
-		       int migratetype, bool claimable, unsigned int *mt_out);
+		       freetype_t freetype, bool claimable, freetype_t *ft_out);
 
-static inline bool free_area_empty(struct free_area *area, int migratetype)
+static inline bool free_area_empty(struct free_area *area, freetype_t freetype)
 {
-	return list_empty(&area->free_list[migratetype]);
+	return list_empty(free_area_list(area, freetype));
 }
 
 /* mm/util.c */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1cd74a5901ded..66d4843da8512 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -457,6 +457,37 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
 	return test_bit(bitidx + pb_bit, bitmap_word);
 }
 
+/**
+ * __get_pfnblock_freetype - Return the freetype of a pageblock, optionally
+ * ignoring the fact that it's currently isolated.
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ * @ignore_iso: If isolated, return the migratetype that the block had before
+ *              isolation.
+ */
+__always_inline freetype_t
+__get_pfnblock_freetype(const struct page *page, unsigned long pfn,
+			bool ignore_iso)
+{
+	int mt = get_pfnblock_migratetype(page, pfn);
+
+	return migrate_to_freetype(mt, 0);
+}
+
+/**
+ * get_pfnblock_migratetype - Return the freetype of a pageblock
+ * @page: The page within the block of interest
+ * @pfn: The target page frame number
+ *
+ * Return: The freetype of the pageblock
+ */
+__always_inline freetype_t
+get_pfnblock_freetype(const struct page *page, unsigned long pfn)
+{
+	return __get_pfnblock_freetype(page, pfn, 0);
+}
+
+
 /**
  * get_pfnblock_migratetype - Return the migratetype of a pageblock
  * @page: The page within the block of interest
@@ -768,8 +799,11 @@ static inline struct capture_control *task_capc(struct zone *zone)
 
 static inline bool
 compaction_capture(struct capture_control *capc, struct page *page,
-		   int order, int migratetype)
+		   int order, freetype_t freetype)
 {
+	enum migratetype migratetype = free_to_migratetype(freetype);
+	enum migratetype capc_mt;
+
 	if (!capc || order != capc->cc->order)
 		return false;
 
@@ -778,6 +812,8 @@ compaction_capture(struct capture_control *capc, struct page *page,
 	    is_migrate_isolate(migratetype))
 		return false;
 
+	capc_mt = free_to_migratetype(capc->cc->freetype);
+
 	/*
 	 * Do not let lower order allocations pollute a movable pageblock
 	 * unless compaction is also requesting movable pages.
@@ -786,12 +822,12 @@ compaction_capture(struct capture_control *capc, struct page *page,
 	 * have trouble finding a high-order free page.
 	 */
 	if (order < pageblock_order && migratetype == MIGRATE_MOVABLE &&
-	    capc->cc->migratetype != MIGRATE_MOVABLE)
+	    capc_mt != MIGRATE_MOVABLE)
 		return false;
 
-	if (migratetype != capc->cc->migratetype)
+	if (migratetype != capc_mt)
 		trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
-					    capc->cc->migratetype, migratetype);
+					    capc_mt, migratetype);
 
 	capc->page = page;
 	return true;
@@ -805,7 +841,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
 
 static inline bool
 compaction_capture(struct capture_control *capc, struct page *page,
-		   int order, int migratetype)
+		   int order, freetype_t freetype)
 {
 	return false;
 }
@@ -830,23 +866,28 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 
 /* Used for pages not on another list */
 static inline void __add_to_free_list(struct page *page, struct zone *zone,
-				      unsigned int order, int migratetype,
+				      unsigned int order, freetype_t freetype,
 				      bool tail)
 {
 	struct free_area *area = &zone->free_area[order];
 	int nr_pages = 1 << order;
 
-	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
-		     "page type is %d, passed migratetype is %d (nr=%d)\n",
-		     get_pageblock_migratetype(page), migratetype, nr_pages);
+	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
+		freetype_t block_ft = get_pageblock_freetype(page);
+
+		VM_WARN_ONCE(!freetypes_equal(block_ft, freetype),
+				"page type is %d/%#x, passed type is %d/%3x (nr=%d)\n",
+				block_ft.migratetype, freetype_flags(block_ft),
+				freetype.migratetype, freetype_flags(freetype), nr_pages);
+	}
 
 	if (tail)
-		list_add_tail(&page->buddy_list, &area->free_list[migratetype]);
+		list_add_tail(&page->buddy_list, free_area_list(area, freetype));
 	else
-		list_add(&page->buddy_list, &area->free_list[migratetype]);
+		list_add(&page->buddy_list, free_area_list(area, freetype));
 	area->nr_free++;
 
-	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
+	if (order >= pageblock_order && !is_migrate_isolate(free_to_migratetype(freetype)))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
 }
 
@@ -856,17 +897,25 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
  * allocation again (e.g., optimization for memory onlining).
  */
 static inline void move_to_free_list(struct page *page, struct zone *zone,
-				     unsigned int order, int old_mt, int new_mt)
+				     unsigned int order,
+				     freetype_t old_ft, freetype_t new_ft)
 {
 	struct free_area *area = &zone->free_area[order];
+	int old_mt = free_to_migratetype(old_ft);
+	int new_mt = free_to_migratetype(new_ft);
 	int nr_pages = 1 << order;
 
 	/* Free page moving can fail, so it happens before the type update */
-	VM_WARN_ONCE(get_pageblock_migratetype(page) != old_mt,
-		     "page type is %d, passed migratetype is %d (nr=%d)\n",
-		     get_pageblock_migratetype(page), old_mt, nr_pages);
+	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
+		freetype_t block_ft = get_pageblock_freetype(page);
 
-	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
+		VM_WARN_ONCE(!freetypes_equal(block_ft, old_ft),
+				"page type is %d/%#x, passed freetype is %d/%#x (nr=%d)\n",
+				block_ft.migratetype, freetype_flags(block_ft),
+				old_ft.migratetype, freetype_flags(old_ft), nr_pages);
+	}
+
+	list_move_tail(&page->buddy_list, free_area_list(area, new_ft));
 
 	account_freepages(zone, -nr_pages, old_mt);
 	account_freepages(zone, nr_pages, new_mt);
@@ -909,9 +958,9 @@ static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 }
 
 static inline struct page *get_page_from_free_area(struct free_area *area,
-					    int migratetype)
+						   freetype_t freetype)
 {
-	return list_first_entry_or_null(&area->free_list[migratetype],
+	return list_first_entry_or_null(free_area_list(area, freetype),
 					struct page, buddy_list);
 }
 
@@ -978,9 +1027,10 @@ static void change_pageblock_range(struct page *pageblock_page,
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype, fpi_t fpi_flags)
+		freetype_t freetype, fpi_t fpi_flags)
 {
 	struct capture_control *capc = task_capc(zone);
+	int migratetype = free_to_migratetype(freetype);
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
@@ -989,16 +1039,17 @@ static inline void __free_one_page(struct page *page,
 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
 
-	VM_BUG_ON(migratetype == -1);
+	VM_BUG_ON(freetype.migratetype == -1);
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
 	account_freepages(zone, 1 << order, migratetype);
 
 	while (order < MAX_PAGE_ORDER) {
-		int buddy_mt = migratetype;
+		freetype_t buddy_ft = freetype;
+		enum migratetype buddy_mt = free_to_migratetype(buddy_ft);
 
-		if (compaction_capture(capc, page, order, migratetype)) {
+		if (compaction_capture(capc, page, order, freetype)) {
 			account_freepages(zone, -(1 << order), migratetype);
 			return;
 		}
@@ -1014,7 +1065,8 @@ static inline void __free_one_page(struct page *page,
 			 * pageblock isolation could cause incorrect freepage or CMA
 			 * accounting or HIGHATOMIC accounting.
 			 */
-			buddy_mt = get_pfnblock_migratetype(buddy, buddy_pfn);
+			buddy_ft = get_pfnblock_freetype(buddy, buddy_pfn);
+			buddy_mt = free_to_migratetype(buddy_ft);
 
 			if (migratetype != buddy_mt &&
 			    (!migratetype_is_mergeable(migratetype) ||
@@ -1056,7 +1108,7 @@ static inline void __free_one_page(struct page *page,
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
 
-	__add_to_free_list(page, zone, order, migratetype, to_tail);
+	__add_to_free_list(page, zone, order, freetype, to_tail);
 
 	/* Notify page reporting subsystem of freed page */
 	if (!(fpi_flags & FPI_SKIP_REPORT_NOTIFY))
@@ -1517,19 +1569,20 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		nr_pages = 1 << order;
 		do {
 			unsigned long pfn;
-			int mt;
+			freetype_t ft;
 
 			page = list_last_entry(list, struct page, pcp_list);
 			pfn = page_to_pfn(page);
-			mt = get_pfnblock_migratetype(page, pfn);
+			ft = get_pfnblock_freetype(page, pfn);
 
 			/* must delete to avoid corrupting pcp list */
 			list_del(&page->pcp_list);
 			count -= nr_pages;
 			pcp->count -= nr_pages;
 
-			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
-			trace_mm_page_pcpu_drain(page, order, mt);
+			__free_one_page(page, pfn, zone, order, ft, FPI_NONE);
+			trace_mm_page_pcpu_drain(page, order,
+						 free_to_migratetype(ft));
 		} while (count > 0 && !list_empty(list));
 	}
 
@@ -1550,9 +1603,9 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 		order = pageblock_order;
 
 	do {
-		int mt = get_pfnblock_migratetype(page, pfn);
+		freetype_t ft = get_pfnblock_freetype(page, pfn);
 
-		__free_one_page(page, pfn, zone, order, mt, fpi);
+		__free_one_page(page, pfn, zone, order, ft, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
 			break;
@@ -1730,7 +1783,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, freetype_t freetype)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1749,7 +1802,7 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		if (set_page_guard(zone, &page[size], high))
 			continue;
 
-		__add_to_free_list(&page[size], zone, high, migratetype, false);
+		__add_to_free_list(&page[size], zone, high, freetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
 	}
@@ -1759,12 +1812,13 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 
 static __always_inline void page_del_and_expand(struct zone *zone,
 						struct page *page, int low,
-						int high, int migratetype)
+						int high, freetype_t freetype)
 {
+	enum migratetype migratetype = free_to_migratetype(freetype);
 	int nr_pages = 1 << high;
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, freetype);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -1917,7 +1971,7 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
  */
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
-						int migratetype)
+						freetype_t freetype)
 {
 	unsigned int current_order;
 	struct free_area *area;
@@ -1925,13 +1979,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
 	/* Find a page of the appropriate size in the preferred list */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; ++current_order) {
+		enum migratetype migratetype = free_to_migratetype(freetype);
+
 		area = &(zone->free_area[current_order]);
-		page = get_page_from_free_area(area, migratetype);
+		page = get_page_from_free_area(area, freetype);
 		if (!page)
 			continue;
 
 		page_del_and_expand(zone, page, order, current_order,
-				    migratetype);
+				    freetype);
 		trace_mm_page_alloc_zone_locked(page, order, migratetype,
 				pcp_allowed_order(order) &&
 				migratetype < MIGRATE_PCPTYPES);
@@ -1956,13 +2012,18 @@ static int fallbacks[MIGRATE_PCPTYPES][MIGRATE_PCPTYPES - 1] = {
 
 #ifdef CONFIG_CMA
 static __always_inline struct page *__rmqueue_cma_fallback(struct zone *zone,
-					unsigned int order)
+					unsigned int order, unsigned int ft_flags)
 {
-	return __rmqueue_smallest(zone, order, MIGRATE_CMA);
+	freetype_t freetype = migrate_to_freetype(MIGRATE_CMA, ft_flags);
+
+	return __rmqueue_smallest(zone, order, freetype);
 }
 #else
 static inline struct page *__rmqueue_cma_fallback(struct zone *zone,
-					unsigned int order) { return NULL; }
+					unsigned int order, bool sensitive)
+{
+	return NULL;
+}
 #endif
 
 /*
@@ -1970,7 +2031,7 @@ static inline struct page *__rmqueue_cma_fallback(struct zone *zone,
  * change the block type.
  */
 static int __move_freepages_block(struct zone *zone, unsigned long start_pfn,
-				  int old_mt, int new_mt)
+				  freetype_t old_ft, freetype_t new_ft)
 {
 	struct page *page;
 	unsigned long pfn, end_pfn;
@@ -1993,7 +2054,7 @@ static int __move_freepages_block(struct zone *zone, unsigned long start_pfn,
 
 		order = buddy_order(page);
 
-		move_to_free_list(page, zone, order, old_mt, new_mt);
+		move_to_free_list(page, zone, order, old_ft, new_ft);
 
 		pfn += 1 << order;
 		pages_moved += 1 << order;
@@ -2053,7 +2114,7 @@ static bool prep_move_freepages_block(struct zone *zone, struct page *page,
 }
 
 static int move_freepages_block(struct zone *zone, struct page *page,
-				int old_mt, int new_mt)
+				freetype_t old_ft, freetype_t new_ft)
 {
 	unsigned long start_pfn;
 	int res;
@@ -2061,8 +2122,11 @@ static int move_freepages_block(struct zone *zone, struct page *page,
 	if (!prep_move_freepages_block(zone, page, &start_pfn, NULL, NULL))
 		return -1;
 
-	res = __move_freepages_block(zone, start_pfn, old_mt, new_mt);
-	set_pageblock_migratetype(pfn_to_page(start_pfn), new_mt);
+	VM_BUG_ON(freetype_flags(old_ft) != freetype_flags(new_ft));
+
+	res = __move_freepages_block(zone, start_pfn, old_ft, new_ft);
+	set_pageblock_migratetype(pfn_to_page(start_pfn),
+				  free_to_migratetype(new_ft));
 
 	return res;
 
@@ -2130,8 +2194,7 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 		struct page *page, bool isolate)
 {
 	unsigned long start_pfn, buddy_pfn;
-	int from_mt;
-	int to_mt;
+	freetype_t from_ft, to_ft;
 	struct page *buddy;
 
 	if (isolate == get_pageblock_isolate(page)) {
@@ -2161,18 +2224,15 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 	}
 
 move:
-	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
 	if (isolate) {
-		from_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						    MIGRATETYPE_MASK);
-		to_mt = MIGRATE_ISOLATE;
+		from_ft = __get_pfnblock_freetype(page, page_to_pfn(page), true);
+		to_ft = freetype_with_migrate(from_ft, MIGRATE_ISOLATE);
 	} else {
-		from_mt = MIGRATE_ISOLATE;
-		to_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						  MIGRATETYPE_MASK);
+		to_ft = __get_pfnblock_freetype(page, page_to_pfn(page), true);
+		from_ft = freetype_with_migrate(to_ft, MIGRATE_ISOLATE);
 	}
 
-	__move_freepages_block(zone, start_pfn, from_mt, to_mt);
+	__move_freepages_block(zone, start_pfn, from_ft, to_ft);
 	toggle_pageblock_isolate(pfn_to_page(start_pfn), isolate);
 
 	return true;
@@ -2276,15 +2336,16 @@ static bool should_try_claim_block(unsigned int order, int start_mt)
 
 /*
  * Check whether there is a suitable fallback freepage with requested order.
- * If claimable is true, this function returns fallback_mt only if
+ * If claimable is true, this function returns a fallback only if
  * we would do this whole-block claiming. This would help to reduce
  * fragmentation due to mixed migratetype pages in one pageblock.
  */
 enum fallback_result
 find_suitable_fallback(struct free_area *area, unsigned int order,
-		       int migratetype, bool claimable, unsigned int *mt_out)
+		       freetype_t freetype, bool claimable, freetype_t *ft_out)
 {
 	int i;
+	enum migratetype migratetype = free_to_migratetype(freetype);
 
 	if (claimable && !should_try_claim_block(order, migratetype))
 		return FALLBACK_NOCLAIM;
@@ -2294,10 +2355,18 @@ find_suitable_fallback(struct free_area *area, unsigned int order,
 
 	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
 		int fallback_mt = fallbacks[migratetype][i];
+		/*
+		 * Fallback to different migratetypes, but currently always with
+		 * the same freetype flags.
+		 */
+		freetype_t fallback_ft = freetype_with_migrate(freetype, fallback_mt);
 
-		if (!free_area_empty(area, fallback_mt)) {
-			if (mt_out)
-				*mt_out = fallback_mt;
+		if (freetype_idx(fallback_ft) < 0)
+			continue;
+
+		if (!free_area_empty(area, fallback_ft)) {
+			if (ft_out)
+				*ft_out = fallback_ft;
 			return FALLBACK_FOUND;
 		}
 	}
@@ -2314,20 +2383,22 @@ find_suitable_fallback(struct free_area *area, unsigned int order,
  */
 static struct page *
 try_to_claim_block(struct zone *zone, struct page *page,
-		   int current_order, int order, int start_type,
-		   int block_type, unsigned int alloc_flags)
+		   int current_order, int order, freetype_t start_type,
+		   freetype_t block_type, unsigned int alloc_flags)
 {
 	int free_pages, movable_pages, alike_pages;
+	int block_mt = free_to_migratetype(block_type);
+	int start_mt = free_to_migratetype(start_type);
 	unsigned long start_pfn;
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
 
-		del_page_from_free_list(page, zone, current_order, block_type);
-		change_pageblock_range(page, current_order, start_type);
+		del_page_from_free_list(page, zone, current_order, block_mt);
+		change_pageblock_range(page, current_order, start_mt);
 		nr_added = expand(zone, page, order, current_order, start_type);
-		account_freepages(zone, nr_added, start_type);
+		account_freepages(zone, nr_added, start_mt);
 		return page;
 	}
 
@@ -2349,7 +2420,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	 * For movable allocation, it's the number of movable pages which
 	 * we just obtained. For other types it's a bit more tricky.
 	 */
-	if (start_type == MIGRATE_MOVABLE) {
+	if (start_mt == MIGRATE_MOVABLE) {
 		alike_pages = movable_pages;
 	} else {
 		/*
@@ -2359,7 +2430,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		 * vice versa, be conservative since we can't distinguish the
 		 * exact migratetype of non-movable pages.
 		 */
-		if (block_type == MIGRATE_MOVABLE)
+		if (block_mt == MIGRATE_MOVABLE)
 			alike_pages = pageblock_nr_pages
 						- (free_pages + movable_pages);
 		else
@@ -2372,7 +2443,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
 		__move_freepages_block(zone, start_pfn, block_type, start_type);
-		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
+		set_pageblock_migratetype(pfn_to_page(start_pfn), start_mt);
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
@@ -2388,14 +2459,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
  * condition simpler.
  */
 static __always_inline struct page *
-__rmqueue_claim(struct zone *zone, int order, int start_migratetype,
+__rmqueue_claim(struct zone *zone, int order, freetype_t start_freetype,
 						unsigned int alloc_flags)
 {
 	struct free_area *area;
 	int current_order;
 	int min_order = order;
 	struct page *page;
-	int fallback_mt;
 
 	/*
 	 * Do not steal pages from freelists belonging to other pageblocks
@@ -2412,11 +2482,13 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 	 */
 	for (current_order = MAX_PAGE_ORDER; current_order >= min_order;
 				--current_order) {
+		int start_mt = free_to_migratetype(start_freetype);
 		enum fallback_result result;
+		freetype_t fallback_ft;
 
 		area = &(zone->free_area[current_order]);
-		result = find_suitable_fallback(area, current_order,
-						start_migratetype, true, &fallback_mt);
+		result = find_suitable_fallback(area, current_order, start_freetype,
+						true, &fallback_ft);
 
 		if (result == FALLBACK_EMPTY)
 			continue;
@@ -2424,13 +2496,13 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 		if (result == FALLBACK_NOCLAIM)
 			break;
 
-		page = get_page_from_free_area(area, fallback_mt);
+		page = get_page_from_free_area(area, fallback_ft);
 		page = try_to_claim_block(zone, page, current_order, order,
-					  start_migratetype, fallback_mt,
+					  start_freetype, fallback_ft,
 					  alloc_flags);
 		if (page) {
 			trace_mm_page_alloc_extfrag(page, order, current_order,
-						    start_migratetype, fallback_mt);
+				start_mt, free_to_migratetype(fallback_ft));
 			return page;
 		}
 	}
@@ -2443,26 +2515,27 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
  * the block as its current migratetype, potentially causing fragmentation.
  */
 static __always_inline struct page *
-__rmqueue_steal(struct zone *zone, int order, int start_migratetype)
+__rmqueue_steal(struct zone *zone, int order, freetype_t start_freetype)
 {
 	struct free_area *area;
 	int current_order;
 	struct page *page;
-	int fallback_mt;
 
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
 		enum fallback_result result;
+		freetype_t fallback_ft;
 
 		area = &(zone->free_area[current_order]);
-		result = find_suitable_fallback(area, current_order, start_migratetype,
-						false, &fallback_mt);
+		result = find_suitable_fallback(area, current_order, start_freetype,
+						false, &fallback_ft);
 		if (result == FALLBACK_EMPTY)
 			continue;
 
-		page = get_page_from_free_area(area, fallback_mt);
-		page_del_and_expand(zone, page, order, current_order, fallback_mt);
+		page = get_page_from_free_area(area, fallback_ft);
+		page_del_and_expand(zone, page, order, current_order, fallback_ft);
 		trace_mm_page_alloc_extfrag(page, order, current_order,
-					    start_migratetype, fallback_mt);
+					    free_to_migratetype(start_freetype),
+						free_to_migratetype(fallback_ft));
 		return page;
 	}
 
@@ -2481,7 +2554,7 @@ enum rmqueue_mode {
  * Call me with the zone->lock already held.
  */
 static __always_inline struct page *
-__rmqueue(struct zone *zone, unsigned int order, int migratetype,
+__rmqueue(struct zone *zone, unsigned int order, freetype_t freetype,
 	  unsigned int alloc_flags, enum rmqueue_mode *mode)
 {
 	struct page *page;
@@ -2495,7 +2568,8 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 		if (alloc_flags & ALLOC_CMA &&
 		    zone_page_state(zone, NR_FREE_CMA_PAGES) >
 		    zone_page_state(zone, NR_FREE_PAGES) / 2) {
-			page = __rmqueue_cma_fallback(zone, order);
+			page = __rmqueue_cma_fallback(zone, order,
+						freetype_flags(freetype));
 			if (page)
 				return page;
 		}
@@ -2512,13 +2586,14 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	 */
 	switch (*mode) {
 	case RMQUEUE_NORMAL:
-		page = __rmqueue_smallest(zone, order, migratetype);
+		page = __rmqueue_smallest(zone, order, freetype);
 		if (page)
 			return page;
 		fallthrough;
 	case RMQUEUE_CMA:
 		if (alloc_flags & ALLOC_CMA) {
-			page = __rmqueue_cma_fallback(zone, order);
+			page = __rmqueue_cma_fallback(zone, order,
+						freetype_flags(freetype));
 			if (page) {
 				*mode = RMQUEUE_CMA;
 				return page;
@@ -2526,7 +2601,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 		}
 		fallthrough;
 	case RMQUEUE_CLAIM:
-		page = __rmqueue_claim(zone, order, migratetype, alloc_flags);
+		page = __rmqueue_claim(zone, order, freetype, alloc_flags);
 		if (page) {
 			/* Replenished preferred freelist, back to normal mode. */
 			*mode = RMQUEUE_NORMAL;
@@ -2535,7 +2610,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 		fallthrough;
 	case RMQUEUE_STEAL:
 		if (!(alloc_flags & ALLOC_NOFRAGMENT)) {
-			page = __rmqueue_steal(zone, order, migratetype);
+			page = __rmqueue_steal(zone, order, freetype);
 			if (page) {
 				*mode = RMQUEUE_STEAL;
 				return page;
@@ -2552,7 +2627,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
-			int migratetype, unsigned int alloc_flags)
+			freetype_t freetype, unsigned int alloc_flags)
 {
 	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 	unsigned long flags;
@@ -2565,7 +2640,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		spin_lock_irqsave(&zone->lock, flags);
 	}
 	for (i = 0; i < count; ++i) {
-		struct page *page = __rmqueue(zone, order, migratetype,
+		struct page *page = __rmqueue(zone, order, freetype,
 					      alloc_flags, &rmqm);
 		if (unlikely(page == NULL))
 			break;
@@ -2863,7 +2938,7 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
  * reacquired. Return true if pcp is locked, false otherwise.
  */
 static bool free_frozen_page_commit(struct zone *zone,
-		struct per_cpu_pages *pcp, struct page *page, int migratetype,
+		struct per_cpu_pages *pcp, struct page *page, freetype_t freetype,
 		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
 {
 	int high, batch;
@@ -2880,7 +2955,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 	 */
 	pcp->alloc_factor >>= 1;
 	__count_vm_events(PGFREE, 1 << order);
-	pindex = order_to_pindex(migratetype, order);
+	pindex = order_to_pindex(free_to_migratetype(freetype), order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
@@ -2975,6 +3050,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
+	freetype_t freetype;
 
 	if (!pcp_allowed_order(order)) {
 		__free_pages_ok(page, order, fpi_flags);
@@ -2992,13 +3068,14 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	 * excessively into the page allocator
 	 */
 	zone = page_zone(page);
-	migratetype = get_pfnblock_migratetype(page, pfn);
+	freetype = get_pfnblock_freetype(page, pfn);
+	migratetype = free_to_migratetype(freetype);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
 			free_one_page(zone, page, pfn, order, fpi_flags);
 			return;
 		}
-		migratetype = MIGRATE_MOVABLE;
+		freetype = freetype_with_migrate(freetype, MIGRATE_MOVABLE);
 	}
 
 	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
@@ -3008,7 +3085,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	}
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 	if (pcp) {
-		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
+		if (!free_frozen_page_commit(zone, pcp, page, freetype,
 						order, fpi_flags, &UP_flags))
 			return;
 		pcp_spin_unlock(pcp, UP_flags);
@@ -3066,10 +3143,12 @@ void free_unref_folios(struct folio_batch *folios)
 		struct zone *zone = folio_zone(folio);
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = (unsigned long)folio->private;
+		freetype_t freetype;
 		int migratetype;
 
 		folio->private = NULL;
-		migratetype = get_pfnblock_migratetype(&folio->page, pfn);
+		freetype = get_pfnblock_freetype(&folio->page, pfn);
+		migratetype = free_to_migratetype(freetype);
 
 		/* Different zone requires a different pcp lock */
 		if (zone != locked_zone ||
@@ -3108,11 +3187,12 @@ void free_unref_folios(struct folio_batch *folios)
 		 * to the MIGRATE_MOVABLE pcp list.
 		 */
 		if (unlikely(migratetype >= MIGRATE_PCPTYPES))
-			migratetype = MIGRATE_MOVABLE;
+			freetype = freetype_with_migrate(freetype,
+							MIGRATE_MOVABLE);
 
 		trace_mm_page_free_batched(&folio->page);
 		if (!free_frozen_page_commit(zone, pcp, &folio->page,
-				migratetype, order, FPI_NONE, &UP_flags)) {
+				freetype, order, FPI_NONE, &UP_flags)) {
 			pcp = NULL;
 			locked_zone = NULL;
 		}
@@ -3180,14 +3260,16 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
 		for (; page < endpage; page += pageblock_nr_pages) {
-			int mt = get_pageblock_migratetype(page);
+			freetype_t old_ft = get_pageblock_freetype(page);
+			freetype_t new_ft = freetype_with_migrate(old_ft,
+				MIGRATE_MOVABLE);
+
 			/*
 			 * Only change normal pageblocks (i.e., they can merge
 			 * with others)
 			 */
 			if (migratetype_is_mergeable(mt))
-				move_freepages_block(zone, page, mt,
-						     MIGRATE_MOVABLE);
+				move_freepages_block(zone, page, old_ft, new_ft);
 		}
 	}
 
@@ -3203,7 +3285,8 @@ int __isolate_free_page(struct page *page, unsigned int order)
  * This function is meant to return a page pulled from the free lists via
  * __isolate_free_page back to the free lists they were pulled from.
  */
-void __putback_isolated_page(struct page *page, unsigned int order, int mt)
+void __putback_isolated_page(struct page *page, unsigned int order,
+			     freetype_t freetype)
 {
 	struct zone *zone = page_zone(page);
 
@@ -3211,7 +3294,7 @@ void __putback_isolated_page(struct page *page, unsigned int order, int mt)
 	lockdep_assert_held(&zone->lock);
 
 	/* Return isolated page to tail of freelist. */
-	__free_one_page(page, page_to_pfn(page), zone, order, mt,
+	__free_one_page(page, page_to_pfn(page), zone, order, freetype,
 			FPI_SKIP_REPORT_NOTIFY | FPI_TO_TAIL);
 }
 
@@ -3244,10 +3327,12 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   freetype_t freetype)
 {
 	struct page *page;
 	unsigned long flags;
+	freetype_t ft_high = freetype_with_migrate(freetype,
+						       MIGRATE_HIGHATOMIC);
 
 	do {
 		page = NULL;
@@ -3258,11 +3343,11 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			spin_lock_irqsave(&zone->lock, flags);
 		}
 		if (alloc_flags & ALLOC_HIGHATOMIC)
-			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+			page = __rmqueue_smallest(zone, order, ft_high);
 		if (!page) {
 			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 
-			page = __rmqueue(zone, order, migratetype, alloc_flags, &rmqm);
+			page = __rmqueue(zone, order, freetype, alloc_flags, &rmqm);
 
 			/*
 			 * If the allocation fails, allow OOM handling and
@@ -3271,7 +3356,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * high-order atomic allocation in the future.
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
-				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+				page = __rmqueue_smallest(zone, order, ft_high);
 
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
@@ -3340,7 +3425,7 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
-			int migratetype,
+			freetype_t freetype,
 			unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
 			struct list_head *list)
@@ -3354,7 +3439,7 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 
 			alloced = rmqueue_bulk(zone, order,
 					batch, list,
-					migratetype, alloc_flags);
+					freetype, alloc_flags);
 
 			pcp->count += alloced << order;
 			if (unlikely(list_empty(list)))
@@ -3372,7 +3457,7 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			freetype_t freetype, unsigned int alloc_flags)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3390,8 +3475,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 * frees.
 	 */
 	pcp->free_count >>= 1;
-	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	list = &pcp->lists[order_to_pindex(free_to_migratetype(freetype), order)];
+	page = __rmqueue_pcplist(zone, order, freetype, alloc_flags, pcp, list);
 	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3416,19 +3501,19 @@ static inline
 struct page *rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
 			gfp_t gfp_flags, unsigned int alloc_flags,
-			int migratetype)
+			freetype_t freetype)
 {
 	struct page *page;
 
 	if (likely(pcp_allowed_order(order))) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
-				       migratetype, alloc_flags);
+				       freetype, alloc_flags);
 		if (likely(page))
 			goto out;
 	}
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
-							migratetype);
+							freetype);
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
@@ -3450,7 +3535,7 @@ struct page *rmqueue(struct zone *preferred_zone,
 static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone)
 {
-	int mt;
+	freetype_t ft, ft_high;
 	unsigned long max_managed, flags;
 
 	/*
@@ -3472,13 +3557,14 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 		goto out_unlock;
 
 	/* Yoink! */
-	mt = get_pageblock_migratetype(page);
+	ft = get_pageblock_freetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
-	if (!migratetype_is_mergeable(mt))
+	if (!migratetype_is_mergeable(free_to_migratetype(ft)))
 		goto out_unlock;
 
+	ft_high = freetype_with_migrate(ft, MIGRATE_HIGHATOMIC);
 	if (order < pageblock_order) {
-		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
+		if (move_freepages_block(zone, page, ft, ft_high) == -1)
 			goto out_unlock;
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 	} else {
@@ -3523,9 +3609,11 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
+			freetype_t ft_high = freetype_with_migrate(ac->freetype,
+							MIGRATE_HIGHATOMIC);
 			unsigned long size;
 
-			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
+			page = get_page_from_free_area(area, ft_high);
 			if (!page)
 				continue;
 
@@ -3552,14 +3640,14 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 			 */
 			if (order < pageblock_order)
 				ret = move_freepages_block(zone, page,
-							   MIGRATE_HIGHATOMIC,
-							   ac->migratetype);
+							   ft_high,
+							   ac->freetype);
 			else {
 				move_to_free_list(page, zone, order,
-						  MIGRATE_HIGHATOMIC,
-						  ac->migratetype);
+						  ft_high,
+						  ac->freetype);
 				change_pageblock_range(page, order,
-						       ac->migratetype);
+					free_to_migratetype(ac->freetype));
 				ret = 1;
 			}
 			/*
@@ -3665,18 +3753,18 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			continue;
 
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
-			if (!free_area_empty(area, mt))
+			if (!free_area_empty(area, migrate_to_freetype(mt, 0)))
 				return true;
 		}
 
 #ifdef CONFIG_CMA
 		if ((alloc_flags & ALLOC_CMA) &&
-		    !free_area_empty(area, MIGRATE_CMA)) {
+		     !free_area_empty(area, migrate_to_freetype(MIGRATE_CMA, 0))) {
 			return true;
 		}
 #endif
 		if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
-		    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
+		    !free_area_empty(area, migrate_to_freetype(MIGRATE_HIGHATOMIC, 0))) {
 			return true;
 		}
 	}
@@ -3800,7 +3888,7 @@ static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
 						  unsigned int alloc_flags)
 {
 #ifdef CONFIG_CMA
-	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+	if (free_to_migratetype(gfp_freetype(gfp_mask)) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
 	return alloc_flags;
@@ -3963,7 +4051,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 try_this_zone:
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
-				gfp_mask, alloc_flags, ac->migratetype);
+				gfp_mask, alloc_flags, ac->freetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
 
@@ -4732,6 +4820,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 	bool compact_first = false;
 	bool can_retry_reserves = true;
+	enum migratetype migratetype = free_to_migratetype(ac->freetype);
 
 	if (unlikely(nofail)) {
 		/*
@@ -4762,8 +4851,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * try prevent permanent fragmentation by migrating from blocks of the
 	 * same migratetype.
 	 */
-	if (can_compact && (costly_order || (order > 0 &&
-					ac->migratetype != MIGRATE_MOVABLE))) {
+	if (can_compact && (costly_order || (order > 0 && migratetype != MIGRATE_MOVABLE))) {
 		compact_first = true;
 		compact_priority = INIT_COMPACT_PRIORITY;
 	}
@@ -5007,7 +5095,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
 	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
 	ac->nodemask = nodemask;
-	ac->migratetype = gfp_migratetype(gfp_mask);
+	ac->freetype = gfp_freetype(gfp_mask);
 
 	if (cpusets_enabled()) {
 		*alloc_gfp |= __GFP_HARDWALL;
@@ -5172,7 +5260,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* Attempt the batch allocation */
-	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
+	pcp_list = &pcp->lists[order_to_pindex(free_to_migratetype(ac.freetype), 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */
@@ -5181,7 +5269,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
+		page = __rmqueue_pcplist(zone, 0, ac.freetype, alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
@@ -5275,7 +5363,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		page = NULL;
 	}
 
-	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
+	trace_mm_page_alloc(page, order, alloc_gfp,
+			    free_to_migratetype(ac.freetype));
 	kmsan_alloc_page(page, order, alloc_gfp);
 
 	return page;
@@ -7500,11 +7589,11 @@ EXPORT_SYMBOL(is_free_buddy_page);
 
 #ifdef CONFIG_MEMORY_FAILURE
 static inline void add_to_free_list(struct page *page, struct zone *zone,
-				    unsigned int order, int migratetype,
+				    unsigned int order, freetype_t freetype,
 				    bool tail)
 {
-	__add_to_free_list(page, zone, order, migratetype, tail);
-	account_freepages(zone, 1 << order, migratetype);
+	__add_to_free_list(page, zone, order, freetype, tail);
+	account_freepages(zone, 1 << order, free_to_migratetype(freetype));
 }
 
 /*
@@ -7513,7 +7602,7 @@ static inline void add_to_free_list(struct page *page, struct zone *zone,
  */
 static void break_down_buddy_pages(struct zone *zone, struct page *page,
 				   struct page *target, int low, int high,
-				   int migratetype)
+				   freetype_t freetype)
 {
 	unsigned long size = 1 << high;
 	struct page *current_buddy;
@@ -7532,7 +7621,7 @@ static void break_down_buddy_pages(struct zone *zone, struct page *page,
 		if (set_page_guard(zone, current_buddy, high))
 			continue;
 
-		add_to_free_list(current_buddy, zone, high, migratetype, false);
+		add_to_free_list(current_buddy, zone, high, freetype, false);
 		set_buddy_order(current_buddy, high);
 	}
 }
@@ -7555,13 +7644,13 @@ bool take_page_off_buddy(struct page *page)
 
 		if (PageBuddy(page_head) && page_order >= order) {
 			unsigned long pfn_head = page_to_pfn(page_head);
-			int migratetype = get_pfnblock_migratetype(page_head,
-								   pfn_head);
+			freetype_t freetype = get_pfnblock_freetype(page_head,
+								    pfn_head);
 
 			del_page_from_free_list(page_head, zone, page_order,
-						migratetype);
+						free_to_migratetype(freetype));
 			break_down_buddy_pages(zone, page_head, page, 0,
-						page_order, migratetype);
+						page_order, freetype);
 			SetPageHWPoisonTakenOff(page);
 			ret = true;
 			break;
@@ -7585,10 +7674,10 @@ bool put_page_back_buddy(struct page *page)
 	spin_lock_irqsave(&zone->lock, flags);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
-		int migratetype = get_pfnblock_migratetype(page, pfn);
+		freetype_t freetype = get_pfnblock_freetype(page, pfn);
 
 		ClearPageHWPoisonTakenOff(page);
-		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
+		__free_one_page(page, pfn, zone, 0, freetype, FPI_NONE);
 		if (TestClearPageHWPoison(page)) {
 			ret = true;
 		}
@@ -7829,7 +7918,8 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 		__free_frozen_pages(page, order, FPI_TRYLOCK);
 		page = NULL;
 	}
-	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
+	trace_mm_page_alloc(page, order, alloc_gfp,
+			    free_to_migratetype(ac.freetype));
 	kmsan_alloc_page(page, order, alloc_gfp);
 	return page;
 }
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c48ff5c002449..bec964b77b8e9 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -276,7 +276,7 @@ static void unset_migratetype_isolate(struct page *page)
 		WARN_ON_ONCE(!pageblock_unisolate_and_move_free_pages(zone, page));
 	} else {
 		clear_pageblock_isolate(page);
-		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
+		__putback_isolated_page(page, order, get_pageblock_freetype(page));
 	}
 	zone->nr_isolate_pageblock--;
 out:
diff --git a/mm/page_owner.c b/mm/page_owner.c
index b6a394a130ecd..32e870225aa8e 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -481,7 +481,8 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 				goto ext_put_continue;
 
 			page_owner = get_page_owner(page_ext);
-			page_mt = gfp_migratetype(page_owner->gfp_mask);
+			page_mt = free_to_migratetype(
+					gfp_freetype(page_owner->gfp_mask));
 			if (pageblock_mt != page_mt) {
 				if (is_migrate_cma(pageblock_mt))
 					count[MIGRATE_MOVABLE]++;
@@ -566,7 +567,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
-	page_mt  = gfp_migratetype(page_owner->gfp_mask);
+	page_mt  = free_to_migratetype(gfp_freetype(page_owner->gfp_mask));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"PFN 0x%lx type %s Block %lu type %s Flags %pGp\n",
 			pfn,
@@ -617,7 +618,7 @@ void __dump_page_owner(const struct page *page)
 
 	page_owner = get_page_owner(page_ext);
 	gfp_mask = page_owner->gfp_mask;
-	mt = gfp_migratetype(gfp_mask);
+	mt = free_to_migratetype(gfp_freetype(gfp_mask));
 
 	if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags)) {
 		pr_alert("page_owner info is not present (never set?)\n");
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 8a03effda7494..403e5080ebcd0 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -113,10 +113,10 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 	 */
 	do {
 		struct page *page = sg_page(sg);
-		int mt = get_pageblock_migratetype(page);
+		freetype_t ft = get_pageblock_freetype(page);
 		unsigned int order = get_order(sg->length);
 
-		__putback_isolated_page(page, order, mt);
+		__putback_isolated_page(page, order, ft);
 
 		/* If the pages were not reported due to error skip flagging */
 		if (!reported)
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 24078ac3e6bca..84bd3e6440117 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -373,7 +373,9 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 
 			types[order] = 0;
 			for (type = 0; type < MIGRATE_TYPES; type++) {
-				if (!free_area_empty(area, type))
+				freetype_t ft = migrate_to_freetype(type, 0);
+
+				if (!free_area_empty(area, ft))
 					types[order] |= 1 << type;
 			}
 		}

-- 
2.51.2


