Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EB2CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043C48E0017; Wed, 24 Sep 2025 11:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AD28E0012; Wed, 24 Sep 2025 11:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D147A8E0017; Wed, 24 Sep 2025 11:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B77078E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72C801DFD96
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:22 +0000 (UTC)
X-FDA: 83924454684.05.F39A200
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5082340006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AWgUFZbQ;
	spf=pass (imf27.hostedemail.com: domain of 3ggfUaAgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ggfUaAgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umKKDzHwdYkxD5fzEq4OswTg4T0LYreqV7DonTKBHhY=;
	b=yzQxnjzPEbznj5RAK0F/pLARagF7DvVfFYJA3/9cq+zCehr43895NBHddZoqbfCLKB0vfx
	DOGw+m94SiqMMkBy7c0dGwZ7fqTXq0kGmoCLd6IgRTNw5DG8tTVRLkTC3TrSDR1dapxLDq
	bC8Io4jXdBOSpgMfc2KlOTfTs3wpELs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AWgUFZbQ;
	spf=pass (imf27.hostedemail.com: domain of 3ggfUaAgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ggfUaAgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726020; a=rsa-sha256;
	cv=none;
	b=ZxqCw9IEpAv4ygFzPvO+Jj/g/uJMiFYS7Nj0CrUN+ZmcgbLBfr8rrvkSfLV490f6R6GQGS
	9kMyGS62n2jjg5nz5389X4mMLLWzjHatwOOeIQHm5H4mFL+jVofg4dAOqvkM4N//sRpWEV
	zedPp8FM+hJLkvxuvHv9JuM1uZDHMvc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46cde0b2226so16297015e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726019; x=1759330819; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=umKKDzHwdYkxD5fzEq4OswTg4T0LYreqV7DonTKBHhY=;
        b=AWgUFZbQd9OwfIu9Ji+tGJ0JqifrpoFAzQAwYfZRwk1khtZZO52o0uLnSm7AI921YZ
         gYss26IArVxRtKtgN92hfGHdgM7v9Y/CWv4eZ4c3PwKueHXofyY0T3gPBtebnNVyQHaB
         bd5y6mcwqy1LL4KRV6QDL7k6/CCdeSWEgyfRzFd4CUeDAY9sXebnG6gxKozmHEIZAFT3
         0LWH4dhDKZyzc4eJsfpi5vvI1UoG2wtDRVAHBUip3BuYBEZVnTSQu4xxWFb+1TW98ouN
         fOCzdz2whi59IIbj1yCRUtpGIIu5RcwSjN08/SNxC0CWabfUt3sm8uVf5+L78BR4PfgA
         KSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726019; x=1759330819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=umKKDzHwdYkxD5fzEq4OswTg4T0LYreqV7DonTKBHhY=;
        b=R2jOM1N/klB0GhKb1Cae2Brrj/gYpVF8ybUo9/6oYzUV9MOcy5G/dWWUIcXSXRhsiq
         MffgQAtimNODUh6lyLsHPwESnoPUg76rfvmAsr3hAMSmWxHwWReFy7Iop6H8amKN5C2H
         apDHi4MpzrF6lonKh6RBcpw88PK5hhMhtkeT8s6TJ/8cTjXuWPhkWl+UgsJQEsSwsTrA
         Zjrv5to6QVQadDvWCSQVlaHQbz0E5qsen6W2Ag9lqj4p7zysNKId6y0P2oqqzoeJSfoz
         nAIihHZRTO/NkGF7CBfjv2ItESiqqm0B5Yd2GQ7qgjOH5AH28fiQ/Ct+skm1oOmDOsn5
         9wmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUm60PSnjmuc+5p6JwkBhZ+A8Utro/0oWpWiqi9BuQ/3veUNsvXqiqk6GC4mltlTCTWDCUY0OqKGg==@kvack.org
X-Gm-Message-State: AOJu0YwvYreSFwp8MVWYnLU2eXS4QK9EijzW2gSNrtXuuSW7uCDUanPa
	qjqzaCCl8aCgYLAthjcsXwoDKRMCD5nHyl0ZXkf0ziZqvSEGIn4jckoAssGUtFR0NUaE/7niu9b
	BIXDVpsnXVQ/p9w==
X-Google-Smtp-Source: AGHT+IG3cFtJV3DePXPwZsRWDDlgSW6BHlRPO0JWm3MMiIcolz1ebfjg+4gpN4H3IjkHB7jt40XE6UpsIoIiNQ==
X-Received: from wmbfa13.prod.google.com ([2002:a05:600c:518d:b0:45b:89e7:5038])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35cc:b0:46d:9d28:fb78 with SMTP id 5b1f17b1804b1-46e329a54e5mr1658455e9.8.1758726018825;
 Wed, 24 Sep 2025 08:00:18 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:46 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-11-2d861768041f@google.com>
Subject: [PATCH 11/21] mm: introduce freetype_t
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 5082340006
X-Rspamd-Server: rspam05
X-Stat-Signature: jz5c16n9beqbaxwbbpcqzaw6b4agxjxf
X-Rspam-User: 
X-HE-Tag: 1758726020-212143
X-HE-Meta: U2FsdGVkX19qx0hdNWbdy6Lght8EM1ac+5w1dVoIUWGFllZp6kfL+s6+vsz7jXEl+Y6dmugUw7QJZXzjfIsHjDRxDES79W/nGWXSyi+/s/h1sGOfRCQxygK/nEWBcJRjO9CB7vRNcPwe6ogCjCQbVOFH6fYn39yPPj18a3kxAQHf1Cjxewe/3ZanWNhCLVsP44lVO4pDuUMn+SY+t2GMjCdiubR1W3pyTwc0Dd/rU9dom1PSQw2/wgP7qNXrKPhgA5Rh4a5XWkh4dlH58jYicFEArBhaxH1DShNMViO7Lr+PD71TmOqJLzBc7yrfUuhcmuyidMFLL+BDRDTO7A2pZQVMznDEINZDakVuj1CS7iH+5r3U+39U+JVLlzsGHL46E5Ru9dxc/NbttmXWePx3SJRQBBiPM05xbTOIvgsNzqCGGE/JDlr4kG0fc0+t6gezIosUwdKGps/ToR6ewCDcR/geUlySXAy3NJkYjlORR/H9NRogGIDbIy971WVp/loy48g1Y/DtYl6ZFI17n7X+Xx8y5zGIQ/zRQIR9jEbbB4yntThCo1CVV9GtQwlrqCxJQLp0zcscbEJGaVH9bCF5DtVMHxDJwJYclVV9RSSd3XCWoTfNdakyWFIBJygRXP01XcY4ggqG6aJiHnTKBK9RRDJg2uibdry0HWS9hM7wSwMHUwvJ+HRaOWOpnZfQAZpXqSWEx6ggc7LaHRhY4decT2CN9EdP0DV1OeIVgFEak08w3mGYy+eKOvnkL9lxWhCEwfBSDDnmwgUU/aiwY6Iu9z29VsaKPwS7RNvVJLKzsvUI8IJjX7J4gLlRhQHd14J5IKnT4FYm25ZRV+OSJj4F/jDIEX2or8W7LCBfWIYjQ4D15bTObkmnxE11hJH2dBdLPpdnPiF+ADbqvAwuU/CCk8AC76lkpukucyy74ZCBxn8IvGamyalK36YY1tW8jDzcLDCoLX8sysDMhwwMKsF
 kje3zn8i
 MukZ4O8d/031sXyUc0PJSijalDjmB5xhVTDvUBO9BuCUjM6e6HztBGz3VRQAr8joewUWOsXrVUJpf6rMzf52gxI5bt0xPBdlSRiLWQGKHw24kxXKb1TmyjvR7+3Ei/e9iX+yFyND8QwqP/zNaTi8PZpnKMXaQH5Um+P+0clMSZzg7YH7PrLVg9cdyA1QZhWlYRR6OW7FtddcB5omk7UfoNOqW0QMJfGQgegboAjiicNwNBRJbEpVlHa2vFLfBKBFHJJGy34/KGpaFK/tNrpej4ar3Zleyd+gtvgSWuffx9kL8QcErHWUfzJxGCnsTx75auwQuq5wwTmJImmdyEDwr3iQXGGt2KgpHtk9VNFoBiC+hrckvrWYl4aJaSdEFwwIKlJ+AqekyKX2IF7eHXuPwX0CcBQv/EA1uVttdpFfTHt89eih9WNwun7Yb+emcjMuCqb/ruTFlH2ksgGiU+IJ+PCB03tgOp/eWE6WSHmdgJRKb4LE3lNDcH+4NGd8V66je5u3YDyGPFCkyw4e7vUXBhFpoPUB2bNBaiNhwjOweZv49vhIbFEN26BcrfTWZoZrN9veaeyg2XNqXYmFfTfqFU2BKF3hjVl3WD/v9chBk/ReNxvG3Iw55kMqpL0ebCcZifc1oGIgMz0j7ivj8ZVOKOqT8ukcvfLlXTO7o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is preparation for making the page allocator aware of ASI
sensitivity. To do that, certain properties will be highly desirable:

- A "pool" of pages with each sensitivity is usually available, so that
  pages can be provided with the correct sensitivity without zeroing/TLB
  flushing.

- Pages are physically grouped by sensitivity, so that large
  allocations rarely have to alter the pagetables due to ASI.

- ASI sensitivity varies only at a certain fixed address granularity, so
  that the pagetables can all be pre-allocated. This is desirable
  because the page allocator will be changing mappings: pre-allocation
  is a straightforward way to avoid recursive allocations (of
  pagetables).

It seems that the existing infrastructure for grouping pages by
mobility, i.e. pageblocks and migratetypes, serves this purpose pretty
nicely.

Early prototypes of this approach took advantage of it by just
overloading enum migratetype to encode not only mobility but also
sensitivity. This overloading is OK if you can apply constraints like
"only movable pages are ever sensitive", but in the real world such
constraints don't actually exist, so overloading migratetype gets rather
ugly.

Therefore, introduce a new higher-level concept, called "freetype"
(because it is used to index "free"lists) that can encode sensitivity
orthogonally to mobility. This is the "more invasive changes" mentioned
in [0].

Since freetypes and migratetypes would be very easy to mix up, freetypes
are (at least for now) stored in a struct typedef similar to atomic_t.
This provides type-safety, but comes at the expense of being pretty
annoying to code with. For instance, freetype_t cannot be compared with
the == operator. Once this code matures, if the freetype/migratetype
distinction gets less confusing, it might be wise to drop this
struct and just use ints.

To try and reduce review pain for such a churny patch, first introduce
freetypes as nothing but an indirection over migratetypes. The helpers
concerned with sensitivity are defined, but only as stubs. Convert
everything over to using freetypes wherever they are needed to index
freelists, but maintain references to migratetypes in code that really
only cares specifically about mobility.

A later patch will add the encoding of sensitivity into freetype_t. For
this patch, no functional change is intended.

[0]: https://lore.kernel.org/lkml/20250313-asi-page-alloc-v1-9-04972e046cea@google.com/

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h    |  16 ++-
 include/linux/mmzone.h |  68 +++++++++-
 mm/compaction.c        |  32 ++---
 mm/internal.h          |  20 ++-
 mm/page_alloc.c        | 346 ++++++++++++++++++++++++++++++-------------------
 mm/page_isolation.c    |   2 +-
 mm/page_owner.c        |   7 +-
 mm/page_reporting.c    |   4 +-
 mm/show_mem.c          |   2 +-
 9 files changed, 330 insertions(+), 167 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0ceb4e09306c4a7098d5a61645396e3b82a1ca30..a275171c5a6aecafd7783e57ce7d4316c5e56655 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -16,8 +16,10 @@ struct mempolicy;
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
@@ -25,11 +27,15 @@ static inline int gfp_migratetype(const gfp_t gfp_flags)
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
+	return migrate_to_freetype(migratetype, false);
 }
 #undef GFP_MOVABLE_MASK
 #undef GFP_MOVABLE_SHIFT
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 02f5e8cc40c78ac8b81bb5c6f9af8718b1ffb316..56310722f38b788154ee15845b6877ed7e70d6b7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -123,6 +123,55 @@ static inline bool migratetype_is_mergeable(int mt)
 	return mt < MIGRATE_PCPTYPES;
 }
 
+#define NR_SENSITIVITIES 1
+
+/*
+ * A freetype is the index used to identify free lists (free area lists and
+ * pcplists). On non-ASI this is the same thing as a migratetype, on ASI it also
+ * encodes sensitivity. To avoid accidentally mixing the two identifiers,
+ * freetypes are a struct in the style of atomic_t.
+ */
+typedef struct {
+	int type;
+} freetype_t;
+
+#define NR_FREETYPES (MIGRATE_TYPES * NR_SENSITIVITIES)
+
+static inline freetype_t migrate_to_freetype(enum migratetype mt, bool sensitive)
+{
+	freetype_t freetype;
+
+	freetype.type = mt;
+	return freetype;
+}
+
+static inline enum migratetype free_to_migratetype(freetype_t freetype)
+{
+	return freetype.type;
+}
+
+static inline bool freetype_sensitive(freetype_t freetype)
+{
+	return false;
+}
+
+/* Convenience helper, return the freetype modified to have the migratetype. */
+static inline freetype_t freetype_with_migrate(freetype_t freetype,
+						   enum migratetype migratetype)
+{
+	return migrate_to_freetype(migratetype, freetype_sensitive(freetype));
+}
+
+static inline bool freetypes_equal(freetype_t a, freetype_t b)
+{
+	return a.type == b.type;
+}
+
+#define for_each_sensitivity(sensitive) \
+	for (int _s = 0; \
+	     sensitive = (bool)_s, _s < NR_SENSITIVITIES; \
+	     _s++)
+
 #define for_each_free_list(list, zone) \
 	for (unsigned int order = 0; order < NR_PAGE_ORDERS; order++) \
 		for (unsigned int type = 0; \
@@ -132,17 +181,30 @@ static inline bool migratetype_is_mergeable(int mt)
 
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
+	struct list_head	free_list[NR_FREETYPES];
 	unsigned long		nr_free;
 };
 
+static inline
+struct list_head *free_area_list(struct free_area *area, freetype_t type)
+{
+	VM_BUG_ON(type.type < 0 || type.type >= ARRAY_SIZE(area->free_list));
+	VM_BUG_ON(!area);
+	return &area->free_list[type.type];
+}
+
 struct pglist_data;
 
 #ifdef CONFIG_NUMA
@@ -726,8 +788,10 @@ enum zone_watermarks {
 #else
 #define NR_PCP_THP 0
 #endif
+/* Note this is the number per sensitivity. */
 #define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
-#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
+#define NR_PCP_LISTS_PER_SENSITIVITY (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
+#define NR_PCP_LISTS (NR_PCP_LISTS_PER_SENSITIVITY * NR_SENSITIVITIES)
 
 /*
  * Flags used in pcp->flags field.
diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c6844c27682677a0a9ea552316828..64a2c88a66a92f5c87169fbc11f87e8ae822af99 100644
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
@@ -2309,24 +2310,25 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 	for (order = cc->order; order < NR_PAGE_ORDERS; order++) {
 		struct free_area *area = &cc->zone->free_area[order];
 
-		/* Job done if page is free of the right migratetype */
-		if (!free_area_empty(area, migratetype))
+		/* Job done if page is free of the right freetype */
+		if (!free_area_empty(area, freetype))
 			return COMPACT_SUCCESS;
 
 #ifdef CONFIG_CMA
 		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
 		if (migratetype == MIGRATE_MOVABLE &&
-			!free_area_empty(area, MIGRATE_CMA))
+		    !free_areas_empty(area, MIGRATE_CMA))
 			return COMPACT_SUCCESS;
 #endif
 		/*
 		 * Job done if allocation would steal freepages from
-		 * other migratetype buddy lists.
+		 * other freetype buddy lists.
 		 */
-		if (find_suitable_fallback(area, order, migratetype, true) >= 0)
+		if (find_suitable_fallback(area, order, freetype, true) >= 0)
 			/*
-			 * Movable pages are OK in any pageblock. If we are
-			 * stealing for a non-movable allocation, make sure
+			 * Movable pages are OK in any pageblock of the right
+			 * sensitivity. If we are * stealing for a
+			 * non-movable allocation, make sure
 			 * we finish compacting the current pageblock first
 			 * (which is assured by the above migrate_pfn align
 			 * check) so it is as free as possible and we won't
@@ -2531,7 +2533,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 		INIT_LIST_HEAD(&cc->freepages[order]);
 	INIT_LIST_HEAD(&cc->migratepages);
 
-	cc->migratetype = gfp_migratetype(cc->gfp_mask);
+	cc->freetype = gfp_freetype(cc->gfp_mask);
 
 	if (!is_via_compact_memory(cc->order)) {
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
diff --git a/mm/internal.h b/mm/internal.h
index c8d6998bd6b223c62405fd54419282453fc40b9e..50ff6671f19d38a59c9f07e66d347baf85ddf085 100644
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
@@ -589,7 +590,7 @@ struct alloc_context {
 	struct zonelist *zonelist;
 	nodemask_t *nodemask;
 	struct zoneref *preferred_zoneref;
-	int migratetype;
+	freetype_t freetype;
 
 	/*
 	 * highest_zoneidx represents highest usable zone index of
@@ -740,8 +741,8 @@ static inline void clear_zone_contiguous(struct zone *zone)
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
-extern void __putback_isolated_page(struct page *page, unsigned int order,
-				    int mt);
+void __putback_isolated_page(struct page *page, unsigned int order,
+			     freetype_t freetype);
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order,
@@ -893,7 +894,7 @@ struct compact_control {
 	short search_order;		/* order to start a fast search at */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	int order;			/* order a direct compactor needs */
-	int migratetype;		/* migratetype of direct compactor */
+	freetype_t freetype;		/* freetype of direct compactor */
 	const unsigned int alloc_flags;	/* alloc flags of a direct compactor */
 	const int highest_zoneidx;	/* zone index of a direct compactor */
 	enum migrate_mode mode;		/* Async or sync migration mode */
@@ -950,11 +951,16 @@ static inline void init_cma_pageblock(struct page *page)
 
 
 int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable);
+			   freetype_t freetype, bool claimable);
 
-static inline bool free_area_empty(struct free_area *area, int migratetype)
+static inline bool free_area_empty(struct free_area *area, freetype_t freetype)
 {
-	return list_empty(&area->free_list[migratetype]);
+	return list_empty(free_area_list(area, freetype));
+}
+
+static inline bool free_areas_empty(struct free_area *area, int migratetype)
+{
+	return free_area_empty(area, migrate_to_freetype(migratetype, false));
 }
 
 /* mm/util.c */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 08e0faab992fcf3c426d4783da041f930075d903..4ce81f8d4e59966b7c0c2902e24aa2f4639a0e59 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -430,6 +430,37 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
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
+	return migrate_to_freetype(mt, false);
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
+	return __get_pfnblock_freetype(page, pfn, false);
+}
+
+
 /**
  * get_pfnblock_migratetype - Return the migratetype of a pageblock
  * @page: The page within the block of interest
@@ -739,8 +770,11 @@ static inline struct capture_control *task_capc(struct zone *zone)
 
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
 
@@ -749,6 +783,8 @@ compaction_capture(struct capture_control *capc, struct page *page,
 	    is_migrate_isolate(migratetype))
 		return false;
 
+	capc_mt = free_to_migratetype(capc->cc->freetype);
+
 	/*
 	 * Do not let lower order allocations pollute a movable pageblock
 	 * unless compaction is also requesting movable pages.
@@ -757,12 +793,12 @@ compaction_capture(struct capture_control *capc, struct page *page,
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
@@ -776,7 +812,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
 
 static inline bool
 compaction_capture(struct capture_control *capc, struct page *page,
-		   int order, int migratetype)
+		   int order, freetype_t freetype)
 {
 	return false;
 }
@@ -801,23 +837,23 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 
 /* Used for pages not on another list */
 static inline void __add_to_free_list(struct page *page, struct zone *zone,
-				      unsigned int order, int migratetype,
+				      unsigned int order, freetype_t freetype,
 				      bool tail)
 {
 	struct free_area *area = &zone->free_area[order];
 	int nr_pages = 1 << order;
 
-	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(!freetypes_equal(get_pageblock_freetype(page), freetype),
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
-		     get_pageblock_migratetype(page), migratetype, nr_pages);
+		     get_pageblock_freetype(page).type, freetype.type, nr_pages);
 
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
 
@@ -827,17 +863,20 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
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
+	VM_WARN_ONCE(!freetypes_equal(get_pageblock_freetype(page), old_ft),
+		     "page type is %d, passed freetype is %d (nr=%d)\n",
+		     get_pageblock_freetype(page).type, old_ft.type, nr_pages);
 
-	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
+	list_move_tail(&page->buddy_list, free_area_list(area, new_ft));
 
 	account_freepages(zone, -nr_pages, old_mt);
 	account_freepages(zone, nr_pages, new_mt);
@@ -880,9 +919,9 @@ static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 }
 
 static inline struct page *get_page_from_free_area(struct free_area *area,
-					    int migratetype)
+						   freetype_t freetype)
 {
-	return list_first_entry_or_null(&area->free_list[migratetype],
+	return list_first_entry_or_null(free_area_list(area, freetype),
 					struct page, buddy_list);
 }
 
@@ -938,9 +977,10 @@ buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
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
@@ -949,16 +989,17 @@ static inline void __free_one_page(struct page *page,
 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
 
-	VM_BUG_ON(migratetype == -1);
+	VM_BUG_ON(freetype.type == -1);
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
@@ -974,7 +1015,8 @@ static inline void __free_one_page(struct page *page,
 			 * pageblock isolation could cause incorrect freepage or CMA
 			 * accounting or HIGHATOMIC accounting.
 			 */
-			buddy_mt = get_pfnblock_migratetype(buddy, buddy_pfn);
+			buddy_ft = get_pfnblock_freetype(buddy, buddy_pfn);
+			buddy_mt = free_to_migratetype(buddy_ft);
 
 			if (migratetype != buddy_mt &&
 			    (!migratetype_is_mergeable(migratetype) ||
@@ -1016,7 +1058,7 @@ static inline void __free_one_page(struct page *page,
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
 
-	__add_to_free_list(page, zone, order, migratetype, to_tail);
+	__add_to_free_list(page, zone, order, freetype, to_tail);
 
 	/* Notify page reporting subsystem of freed page */
 	if (!(fpi_flags & FPI_SKIP_REPORT_NOTIFY))
@@ -1471,19 +1513,20 @@ static void free_pcppages_bulk(struct zone *zone, int count,
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
 
@@ -1504,9 +1547,9 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 		order = pageblock_order;
 
 	do {
-		int mt = get_pfnblock_migratetype(page, pfn);
+		freetype_t ft = get_pfnblock_freetype(page, pfn);
 
-		__free_one_page(page, pfn, zone, order, mt, fpi);
+		__free_one_page(page, pfn, zone, order, ft, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
 			break;
@@ -1684,7 +1727,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, freetype_t freetype)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1703,7 +1746,7 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		if (set_page_guard(zone, &page[size], high))
 			continue;
 
-		__add_to_free_list(&page[size], zone, high, migratetype, false);
+		__add_to_free_list(&page[size], zone, high, freetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
 	}
@@ -1713,12 +1756,13 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 
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
 
@@ -1877,7 +1921,7 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
  */
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
-						int migratetype)
+						freetype_t freetype)
 {
 	unsigned int current_order;
 	struct free_area *area;
@@ -1885,13 +1929,15 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
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
@@ -1916,13 +1962,18 @@ static int fallbacks[MIGRATE_PCPTYPES][MIGRATE_PCPTYPES - 1] = {
 
 #ifdef CONFIG_CMA
 static __always_inline struct page *__rmqueue_cma_fallback(struct zone *zone,
-					unsigned int order)
+					unsigned int order, bool sensitive)
 {
-	return __rmqueue_smallest(zone, order, MIGRATE_CMA);
+	freetype_t freetype = migrate_to_freetype(MIGRATE_CMA, sensitive);
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
@@ -1930,7 +1981,7 @@ static inline struct page *__rmqueue_cma_fallback(struct zone *zone,
  * change the block type.
  */
 static int __move_freepages_block(struct zone *zone, unsigned long start_pfn,
-				  int old_mt, int new_mt)
+				  freetype_t old_ft, freetype_t new_ft)
 {
 	struct page *page;
 	unsigned long pfn, end_pfn;
@@ -1953,7 +2004,7 @@ static int __move_freepages_block(struct zone *zone, unsigned long start_pfn,
 
 		order = buddy_order(page);
 
-		move_to_free_list(page, zone, order, old_mt, new_mt);
+		move_to_free_list(page, zone, order, old_ft, new_ft);
 
 		pfn += 1 << order;
 		pages_moved += 1 << order;
@@ -2013,7 +2064,7 @@ static bool prep_move_freepages_block(struct zone *zone, struct page *page,
 }
 
 static int move_freepages_block(struct zone *zone, struct page *page,
-				int old_mt, int new_mt)
+				freetype_t old_ft, freetype_t new_ft)
 {
 	unsigned long start_pfn;
 	int res;
@@ -2021,8 +2072,11 @@ static int move_freepages_block(struct zone *zone, struct page *page,
 	if (!prep_move_freepages_block(zone, page, &start_pfn, NULL, NULL))
 		return -1;
 
-	res = __move_freepages_block(zone, start_pfn, old_mt, new_mt);
-	set_pageblock_migratetype(pfn_to_page(start_pfn), new_mt);
+	VM_BUG_ON(freetype_sensitive(old_ft) != freetype_sensitive(new_ft));
+
+	res = __move_freepages_block(zone, start_pfn, old_ft, new_ft);
+	set_pageblock_migratetype(pfn_to_page(start_pfn),
+				  free_to_migratetype(new_ft));
 
 	return res;
 
@@ -2090,8 +2144,7 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 		struct page *page, bool isolate)
 {
 	unsigned long start_pfn, buddy_pfn;
-	int from_mt;
-	int to_mt;
+	freetype_t block_ft, from_ft, to_ft;
 	struct page *buddy;
 
 	if (isolate == get_pageblock_isolate(page)) {
@@ -2247,14 +2300,15 @@ static bool should_try_claim_block(unsigned int order, int start_mt)
 
 /*
  * Check whether there is a suitable fallback freepage with requested order.
- * If claimable is true, this function returns fallback_mt only if
+ * If claimable is true, this function returns a fallback only if
  * we would do this whole-block claiming. This would help to reduce
  * fragmentation due to mixed migratetype pages in one pageblock.
  */
 int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable)
+			   freetype_t freetype, bool claimable)
 {
 	int i;
+	enum migratetype migratetype = free_to_migratetype(freetype);
 
 	if (claimable && !should_try_claim_block(order, migratetype))
 		return -2;
@@ -2264,9 +2318,11 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
 
 	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
 		int fallback_mt = fallbacks[migratetype][i];
+		freetype_t fallback_ft = migrate_to_freetype(fallback_mt,
+						freetype_sensitive(freetype));
 
-		if (!free_area_empty(area, fallback_mt))
-			return fallback_mt;
+		if (!free_area_empty(area, fallback_ft))
+			return fallback_ft.type;
 	}
 
 	return -1;
@@ -2281,20 +2337,22 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
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
 
@@ -2316,7 +2374,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	 * For movable allocation, it's the number of movable pages which
 	 * we just obtained. For other types it's a bit more tricky.
 	 */
-	if (start_type == MIGRATE_MOVABLE) {
+	if (start_mt == MIGRATE_MOVABLE) {
 		alike_pages = movable_pages;
 	} else {
 		/*
@@ -2326,7 +2384,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		 * vice versa, be conservative since we can't distinguish the
 		 * exact migratetype of non-movable pages.
 		 */
-		if (block_type == MIGRATE_MOVABLE)
+		if (block_mt == MIGRATE_MOVABLE)
 			alike_pages = pageblock_nr_pages
 						- (free_pages + movable_pages);
 		else
@@ -2339,7 +2397,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
 		__move_freepages_block(zone, start_pfn, block_type, start_type);
-		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
+		set_pageblock_migratetype(pfn_to_page(start_pfn), start_mt);
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
@@ -2355,14 +2413,14 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
+	int fallback;
 
 	/*
 	 * Do not steal pages from freelists belonging to other pageblocks
@@ -2379,25 +2437,29 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 	 */
 	for (current_order = MAX_PAGE_ORDER; current_order >= min_order;
 				--current_order) {
+		int start_mt = free_to_migratetype(start_freetype);
+		freetype_t fallback_ft;
+
 		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, true);
+		fallback = find_suitable_fallback(area, current_order,
+						     start_freetype, true);
 
 		/* No block in that order */
-		if (fallback_mt == -1)
+		if (fallback == -1)
 			continue;
 
 		/* Advanced into orders too low to claim, abort */
-		if (fallback_mt == -2)
+		if (fallback == -2)
 			break;
 
-		page = get_page_from_free_area(area, fallback_mt);
+		fallback_ft.type = fallback;
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
@@ -2410,24 +2472,26 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
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
+		freetype_t fallback_ft;
+
 		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, false);
-		if (fallback_mt == -1)
+		fallback_ft.type  = find_suitable_fallback(area, current_order,
+						     start_freetype, false);
+		if (fallback_ft.type == -1)
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
 
@@ -2446,7 +2510,7 @@ enum rmqueue_mode {
  * Call me with the zone->lock already held.
  */
 static __always_inline struct page *
-__rmqueue(struct zone *zone, unsigned int order, int migratetype,
+__rmqueue(struct zone *zone, unsigned int order, freetype_t freetype,
 	  unsigned int alloc_flags, enum rmqueue_mode *mode)
 {
 	struct page *page;
@@ -2460,7 +2524,8 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 		if (alloc_flags & ALLOC_CMA &&
 		    zone_page_state(zone, NR_FREE_CMA_PAGES) >
 		    zone_page_state(zone, NR_FREE_PAGES) / 2) {
-			page = __rmqueue_cma_fallback(zone, order);
+			page = __rmqueue_cma_fallback(zone, order,
+						freetype_sensitive(freetype));
 			if (page)
 				return page;
 		}
@@ -2477,13 +2542,14 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
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
+						freetype_sensitive(freetype));
 			if (page) {
 				*mode = RMQUEUE_CMA;
 				return page;
@@ -2491,7 +2557,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 		}
 		fallthrough;
 	case RMQUEUE_CLAIM:
-		page = __rmqueue_claim(zone, order, migratetype, alloc_flags);
+		page = __rmqueue_claim(zone, order, freetype, alloc_flags);
 		if (page) {
 			/* Replenished preferred freelist, back to normal mode. */
 			*mode = RMQUEUE_NORMAL;
@@ -2500,7 +2566,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 		fallthrough;
 	case RMQUEUE_STEAL:
 		if (!(alloc_flags & ALLOC_NOFRAGMENT)) {
-			page = __rmqueue_steal(zone, order, migratetype);
+			page = __rmqueue_steal(zone, order, freetype);
 			if (page) {
 				*mode = RMQUEUE_STEAL;
 				return page;
@@ -2517,7 +2583,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
-			int migratetype, unsigned int alloc_flags)
+			freetype_t freetype, unsigned int alloc_flags)
 {
 	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 	unsigned long flags;
@@ -2530,7 +2596,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		spin_lock_irqsave(&zone->lock, flags);
 	}
 	for (i = 0; i < count; ++i) {
-		struct page *page = __rmqueue(zone, order, migratetype,
+		struct page *page = __rmqueue(zone, order, freetype,
 					      alloc_flags, &rmqm);
 		if (unlikely(page == NULL))
 			break;
@@ -2815,8 +2881,8 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
 }
 
 static void free_frozen_page_commit(struct zone *zone,
-		struct per_cpu_pages *pcp, struct page *page, int migratetype,
-		unsigned int order, fpi_t fpi_flags)
+		struct per_cpu_pages *pcp, struct page *page,
+		freetype_t freetype, unsigned int order, fpi_t fpi_flags)
 {
 	int high, batch;
 	int pindex;
@@ -2829,7 +2895,7 @@ static void free_frozen_page_commit(struct zone *zone,
 	 */
 	pcp->alloc_factor >>= 1;
 	__count_vm_events(PGFREE, 1 << order);
-	pindex = order_to_pindex(migratetype, order);
+	pindex = order_to_pindex(free_to_migratetype(freetype), order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
@@ -2896,6 +2962,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
+	freetype_t freetype;
 
 	if (!pcp_allowed_order(order)) {
 		__free_pages_ok(page, order, fpi_flags);
@@ -2913,13 +2980,14 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
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
@@ -2930,7 +2998,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_frozen_page_commit(zone, pcp, page, migratetype, order, fpi_flags);
+		free_frozen_page_commit(zone, pcp, page, freetype, order, fpi_flags);
 		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
@@ -2982,10 +3050,12 @@ void free_unref_folios(struct folio_batch *folios)
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
@@ -3027,10 +3097,11 @@ void free_unref_folios(struct folio_batch *folios)
 		 * to the MIGRATE_MOVABLE pcp list.
 		 */
 		if (unlikely(migratetype >= MIGRATE_PCPTYPES))
-			migratetype = MIGRATE_MOVABLE;
+			freetype = freetype_with_migrate(freetype,
+							MIGRATE_MOVABLE);
 
 		trace_mm_page_free_batched(&folio->page);
-		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
+		free_frozen_page_commit(zone, pcp, &folio->page, freetype,
 					order, FPI_NONE);
 	}
 
@@ -3091,14 +3162,16 @@ int __isolate_free_page(struct page *page, unsigned int order)
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
 
@@ -3114,7 +3187,8 @@ int __isolate_free_page(struct page *page, unsigned int order)
  * This function is meant to return a page pulled from the free lists via
  * __isolate_free_page back to the free lists they were pulled from.
  */
-void __putback_isolated_page(struct page *page, unsigned int order, int mt)
+void __putback_isolated_page(struct page *page, unsigned int order,
+			     freetype_t freetype)
 {
 	struct zone *zone = page_zone(page);
 
@@ -3122,7 +3196,7 @@ void __putback_isolated_page(struct page *page, unsigned int order, int mt)
 	lockdep_assert_held(&zone->lock);
 
 	/* Return isolated page to tail of freelist. */
-	__free_one_page(page, page_to_pfn(page), zone, order, mt,
+	__free_one_page(page, page_to_pfn(page), zone, order, freetype,
 			FPI_SKIP_REPORT_NOTIFY | FPI_TO_TAIL);
 }
 
@@ -3155,10 +3229,12 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
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
@@ -3169,11 +3245,11 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
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
@@ -3182,7 +3258,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * high-order atomic allocation in the future.
 			 */
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
-				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+				page = __rmqueue_smallest(zone, order, ft_high);
 
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
@@ -3251,7 +3327,7 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
-			int migratetype,
+			freetype_t freetype,
 			unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
 			struct list_head *list)
@@ -3265,7 +3341,7 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 
 			alloced = rmqueue_bulk(zone, order,
 					batch, list,
-					migratetype, alloc_flags);
+					freetype, alloc_flags);
 
 			pcp->count += alloced << order;
 			if (unlikely(list_empty(list)))
@@ -3283,7 +3359,7 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			freetype_t freetype, unsigned int alloc_flags)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3304,8 +3380,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 * frees.
 	 */
 	pcp->free_count >>= 1;
-	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	list = &pcp->lists[order_to_pindex(free_to_migratetype(freetype), order)];
+	page = __rmqueue_pcplist(zone, order, freetype, alloc_flags, pcp, list);
 	pcp_spin_unlock(pcp);
 	pcp_trylock_finish(UP_flags);
 	if (page) {
@@ -3331,19 +3407,19 @@ static inline
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
@@ -3365,7 +3441,7 @@ struct page *rmqueue(struct zone *preferred_zone,
 static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone)
 {
-	int mt;
+	freetype_t ft, ft_high;
 	unsigned long max_managed, flags;
 
 	/*
@@ -3387,13 +3463,14 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
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
@@ -3438,9 +3515,11 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
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
 
@@ -3467,14 +3546,14 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
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
@@ -3580,18 +3659,18 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			continue;
 
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
-			if (!free_area_empty(area, mt))
+			if (!free_areas_empty(area, mt))
 				return true;
 		}
 
 #ifdef CONFIG_CMA
 		if ((alloc_flags & ALLOC_CMA) &&
-		    !free_area_empty(area, MIGRATE_CMA)) {
+		    !free_areas_empty(area, MIGRATE_CMA)) {
 			return true;
 		}
 #endif
 		if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
-		    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
+		    !free_areas_empty(area, MIGRATE_HIGHATOMIC)) {
 			return true;
 		}
 	}
@@ -3715,7 +3794,7 @@ static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
 						  unsigned int alloc_flags)
 {
 #ifdef CONFIG_CMA
-	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
+	if (free_to_migratetype(gfp_freetype(gfp_mask)) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
 	return alloc_flags;
@@ -3878,7 +3957,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 try_this_zone:
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
-				gfp_mask, alloc_flags, ac->migratetype);
+				gfp_mask, alloc_flags, ac->freetype);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
 
@@ -4644,6 +4723,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int cpuset_mems_cookie;
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
+	enum migratetype migratetype;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4714,6 +4794,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	migratetype = free_to_migratetype(ac->freetype);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-
@@ -4725,7 +4807,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 */
 	if (can_direct_reclaim && can_compact &&
 			(costly_order ||
-			   (order > 0 && ac->migratetype != MIGRATE_MOVABLE))
+			   (order > 0 && migratetype != MIGRATE_MOVABLE))
 			&& !gfp_pfmemalloc_allowed(gfp_mask)) {
 		page = __alloc_pages_direct_compact(gfp_mask, order,
 						alloc_flags, ac,
@@ -4933,7 +5015,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
 	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
 	ac->nodemask = nodemask;
-	ac->migratetype = gfp_migratetype(gfp_mask);
+	ac->freetype = gfp_freetype(gfp_mask);
 
 	if (cpusets_enabled()) {
 		*alloc_gfp |= __GFP_HARDWALL;
@@ -5094,7 +5176,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed_irq;
 
 	/* Attempt the batch allocation */
-	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
+	pcp_list = &pcp->lists[order_to_pindex(free_to_migratetype(ac.freetype), 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */
@@ -5103,7 +5185,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
+		page = __rmqueue_pcplist(zone, 0, ac.freetype, alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
@@ -5208,7 +5290,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		page = NULL;
 	}
 
-	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
+	trace_mm_page_alloc(page, order, alloc_gfp,
+			    free_to_migratetype(ac.freetype));
 	kmsan_alloc_page(page, order, alloc_gfp);
 
 	return page;
@@ -7607,7 +7690,8 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
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
index f72b6cd38b958be97edcea9ce20154ff43131a4a..572128767a34d87cfc7ba856e78860e06706730d 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -265,7 +265,7 @@ static void unset_migratetype_isolate(struct page *page)
 		WARN_ON_ONCE(!pageblock_unisolate_and_move_free_pages(zone, page));
 	} else {
 		clear_pageblock_isolate(page);
-		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
+		__putback_isolated_page(page, order, get_pageblock_freetype(page));
 	}
 	zone->nr_isolate_pageblock--;
 out:
diff --git a/mm/page_owner.c b/mm/page_owner.c
index c3ca21132c2c18e77cd4b6b3edb586fc1ac3cba7..355012309cea1373759e81aa1e45220160250801 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -469,7 +469,8 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 				goto ext_put_continue;
 
 			page_owner = get_page_owner(page_ext);
-			page_mt = gfp_migratetype(page_owner->gfp_mask);
+			page_mt = free_to_migratetype(
+					gfp_freetype(page_owner->gfp_mask));
 			if (pageblock_mt != page_mt) {
 				if (is_migrate_cma(pageblock_mt))
 					count[MIGRATE_MOVABLE]++;
@@ -554,7 +555,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
-	page_mt  = gfp_migratetype(page_owner->gfp_mask);
+	page_mt  = free_to_migratetype(gfp_freetype(page_owner->gfp_mask));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"PFN 0x%lx type %s Block %lu type %s Flags %pGp\n",
 			pfn,
@@ -605,7 +606,7 @@ void __dump_page_owner(const struct page *page)
 
 	page_owner = get_page_owner(page_ext);
 	gfp_mask = page_owner->gfp_mask;
-	mt = gfp_migratetype(gfp_mask);
+	mt = free_to_migratetype(gfp_freetype(gfp_mask));
 
 	if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags)) {
 		pr_alert("page_owner info is not present (never set?)\n");
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index e4c428e61d8c1765ae00ee22818cfadfd27f324c..faf0347e795cabf8a52ba3a35b5483ea0a8e1934 100644
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
index 3a4b5207635da8e5224ace454badb99ca017170d..f0d9cbd37b0c0297cfb57349ce23df7d52b98d97 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -374,7 +374,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 
 			types[order] = 0;
 			for (type = 0; type < MIGRATE_TYPES; type++) {
-				if (!free_area_empty(area, type))
+				if (!free_areas_empty(area, type))
 					types[order] |= 1 << type;
 			}
 		}

-- 
2.50.1


