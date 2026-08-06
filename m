Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F5FC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE096B007B; Thu,  6 Aug 2026 14:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E176B0088; Thu,  6 Aug 2026 14:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5606B008A; Thu,  6 Aug 2026 14:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF5776B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:09:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60001A12FF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:09:23 +0000 (UTC)
X-FDA: 85071631806.19.7B9078F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9ED9D100012
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:09:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MN2MKdtK;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786039761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Sx2UyEGoPQ7E2DTKqSo0B6Xwx28bzq7BcjPk7PC+yHE=;
	b=opD7WNUsS/vWaEdVlvibbCtM3RuVfvmttMRKKkAvO+vq6tVr9fwntjYxNH5RxFK7RM+8S3
	jQHPCnVIbilFBAUofG2XRVBwZb6JdQVmK7pLEiKPe21mALN+IunUHNaCVhUuGpFzGbClRO
	BBb2DmtD3nxGDq38esBd3zMz75GyELM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786039761;
	b=ysOT7CG2KMX+Sibowc/M9i/u2Pe7TM6JnQyvdaNFceZY+CjhMj8XnzF1W0jU6dnDGAIfAf
	xoxivPKdUIiKBYPwgMmWteO/ktRiXaQfn4Bv6Cqw1G6PrheWZKdi85cYXSYBuCR77O41RA
	dDk/pr+dzGCjXORtQcOWpJDFDB9hmQk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MN2MKdtK;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A599408E8;
	Thu,  6 Aug 2026 18:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04C81F000E9;
	Thu,  6 Aug 2026 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786039760;
	bh=Sx2UyEGoPQ7E2DTKqSo0B6Xwx28bzq7BcjPk7PC+yHE=;
	h=From:Date:Subject:To:Cc;
	b=MN2MKdtK8RSBAhvKCeaMXm8+/xw3CTFhSxl55KwN1vmoK7QFQ1CsfBdXdyF35o79a
	 vU+Vj3BVlBUCObuaGUSEszGqblgf4dbmtswIEIZuO02mbgUenOOjjHWvk0Gw5oG6MC
	 01QrFcUhXeNjsYDQo/m0lzQRtDm68Um54C1XbHMn1roIiHgIK5MjooylOi32PhApVU
	 mSJQBOLnuhaGmOyT/FI7lwBuCrmchNrnuFgWdtvDDRqHwFvjtjE+Ix/qGCIYAxKeee
	 C5eWsjEjg247gv286CRHxFlKRCZEWGHfp90hFJbh+pOmDqMkcr/KCufPRN/FZAXlZw
	 g1ymI3N8ufspw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 06 Aug 2026 20:09:06 +0200
Subject: [PATCH] mm/gup: factor out LRU cache draining for folio into
 lru_cache_drain_for_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-lru_cache_drain_for_folio-v1-1-c6287d295e99@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMHNdGoC/yXMQQqDMBCF4avIrBtILQnaq5QS4mSiI5KUiZaCe
 PemdfEW3+L9OxQSpgL3ZgehNxfOqeJ6aQAnn0ZSHKqh1a3VnbZqkc2hx4lcEM/JxSx1C2dl+5v
 pMURjBoT6fwlF/vzbj+fpsg0z4foLwnF8ATxaGrJ9AAAA
X-Change-ID: 20260806-lru_cache_drain_for_folio-69359cdf55bc
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
 Sean Christopherson <seanjc@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 9ED9D100012
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yhnidax1q1ap3go9i8fr1pa7wnan41wn
X-HE-Tag: 1786039761-133520
X-HE-Meta: U2FsdGVkX18Ms8xipZ/wUW9I6fadYSenSPu9oQlI8eYr9Q6MfWMdxLjZWZ/3YKBIS1+MADxSNFJyT519G/zN8bnbyOszCeTX3QTIhtpJpXiGG+ZM54R3e4kfv5j435wUmPV6O3rOpk6flpCOcfd/ZXbtJmWKR2LWWs13IjX0xxmow0DpmO9HK+PUsEv8R1EjD312z7xbrr5nC/JPMdkoRisFZ6mcUw+tuT9AU8KknfotyqoRTthr9xRpvl+Af6pj94whjIaLJS/AMpCNiKmZDcZ1kB4gkkOrUDlopfv5ymmBQ28qSa6bostD4JHp48rvVJKRT9OM+dv/kGUNlgq8QyqyyDAuJZP296vaJKpt08y4aCzDoC3hlgSI4iFXL9E4sUzLUMCiqUcepWH0+X/efFPWnOan7GI5hfu9nkxXybKHZAzyMKlMM8fV3v4WaZQNx8dTsu9aB2+AzZ0F87pTHztcrBPe4AVbW1C5jLxJ2L/Fuq8lyTIbHzXCQnRQddzkdBmKx6NWt/Bo2h6OLLKTaF1B8ogASQKioiCHM/Rv//WCLFOF/XduexIlyP4iqzd+newcn4OzmvJqB15/sZyqipfkplK70+pq/O3zK/nUAsA0u/1k92g6m01lr62qpKt7QC993J8fC4IhU3fwCZomGVEGQ2E7D74e0xohh26crqxmHYiWz8cxUuQ6tJm4OTSHCOxXISkW+9fGDVNvxd25VoXfT5KMcZBHbg3oR2A3DmVdvBACaAZR7kJVM14Xli+JEXBnasehNQcwYdIzpTHpY9GTjFzZ47yOlYCjSON4thubROlYmgpHN+zykY6FHJlB8vhamKpfqqYFbbWgWtBDHyV0GjXbrNQYJ2417dnHROMlPOWfMWSgFVDA1LwpTo4G553MrHoFMsPSnPEeXf2eOke1JleFNAEBcTtviVZt+k7Clj0meXqMPlTxcr6aaowgGSbgUkbHWpwLKpSaI5U
 fbLGV5Sf
 pBuKOqyBF7FLc5/kzACWkuohIvgjmfJnhi8PiIibccgmxvUQUUexMFvzXAfzmHjORt6DFKt6SdB/xCvXKyY4ZPH6oEwDQFc0FMlFn1QayZ9d6TCKdJZvX9EYxSb8nfASxrNCHQnJimVHbsnN13kK/KLJH5jwbxMtXhVly6AKUcSI6l0gt23sD43tsw6JElAfetRCydwFXXcqumuRfaXEhUG3CyQSvopQjEG8GDgJEOQ5SfPRlOe1ZsZ/iin6zm/2b3+aN2hgo0zacksUGlXFRbZbcL7sexlNml2xXcJLu7B6SaDkgKoCMFCG2ZYztWgZHZiv3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KVM with guest_memfd wants to remove any folio references due to LRU
caches, as it really must only allow to convert folios from shared to
private when there are no unexpected folio references (e.g., from GUP
references).

So, to drive the refcount down, it needs a way to flush the LRU caches.
Let's factor out what we have in lru_cache_drain_for_folio(). Document
it, and also mention that concurrent folio (un)mapping might, in theory,
miss detecting LRU cache references. Keep obtaining the expected refcount
twice to minimize the possibility. For the current and future user that
should work, and we don't really have a better alternative: we could
detect if the mapcount changed, but it would still be racy and add more
complexity with questionable benefit.

Maybe there is a chance to avoid the draining entirely in the future,
by avoiding extra references from the LRU cache: Hugh thinks there might
be a way. But for the time being, this handling is unfortunately
required.

Make folio_may_be_lru_cached() accept a const pointer so
lru_cache_drain_for_folio() can accept a const pointer as well.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
This is based on the fix [1] that is already on its way upstream.

guest_memfd will need this for the work they are now targeting for
7.4. I expect the guest_memfd user to add a KVM-only export of the
symbol.

So either we get this into 7.3-rc1 as well, or Ackerley can carry the
patch as his stuff goes upstream through the x86 KVM tree.

Andrew, let me know what you prefer, the merge window is getting closer.

[1] https://lore.kernel.org/r/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org 
[2] https://lore.kernel.org/r/20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com 
---
 include/linux/swap.h |  8 ++++++++
 mm/folio.c           | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/gup.c             | 15 ++-------------
 mm/internal.h        |  2 +-
 4 files changed, 57 insertions(+), 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 45f301d73e2ae..8dd68733c955a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -298,6 +298,14 @@ void folio_add_lru(struct folio *folio);
 void folio_mark_accessed(struct folio *folio);
 void lru_add_drain_all(void);
 
+enum lru_cache_drained {
+	LRU_CACHE_NOT_DRAINED,
+	LRU_CACHE_DRAINED,
+	LRU_CACHE_DRAINED_ALL,
+};
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained);
+
 /* linux/mm/folio-compat.c */
 void mark_page_accessed(struct page *page);
 
diff --git a/mm/folio.c b/mm/folio.c
index a9e328c3f21bb..59c477120b9a8 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -881,6 +881,52 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */
 
+/**
+ * lru_cache_drain_for_folio() - drain LRU caches if the caches might hold
+ *				 folio references
+ * @folio: The folio.
+ * @extra_refs: Extra folio references held by the caller.
+ * @drained: Drain status for batch folio processing.
+ *
+ * Drain LRU caches if the caches might hold folio references. Start
+ * with a local LRU cache drain, to then drain LRU caches on all CPUs if
+ * local draining was insufficient.
+ *
+ * This function detects LRU cache references by comparing the folio refcount
+ * with the sum of the expected folio refcount + extra references held by the
+ * caller. Note that we cannot rely on PG_lru to reliably detect all LRU
+ * cache references, and there are rare scenarios (concurrent folio (un)mapping)
+ * where this function might miss detecting LRU cache references.
+ *
+ * If @drained is not NULL, the function will avoid re-draining LRU caches
+ * when processing multiple folios in a row. In that case, the variable
+ * @drained points at must be initialized to LRU_CACHE_NOT_DRAINED before
+ * the first invocation by the caller.
+ */
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained)
+{
+	if (!folio_may_be_lru_cached(folio))
+		return;
+
+	if (!drained || *drained == LRU_CACHE_NOT_DRAINED) {
+		if (folio_ref_count(folio) ==
+		    folio_expected_ref_count(folio) + extra_refs)
+			return;
+		lru_add_drain();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED;
+	}
+	if (!drained || *drained == LRU_CACHE_DRAINED) {
+		if (folio_ref_count(folio) ==
+		    folio_expected_ref_count(folio) + extra_refs)
+			return;
+		lru_add_drain_all();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED_ALL;
+	}
+}
+
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
 /*
diff --git a/mm/gup.c b/mm/gup.c
index 41c3317e0f0f4..297e7de81c374 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2266,9 +2266,9 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	unsigned long collected = 0;
 	struct folio *folio;
-	int drained = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2293,18 +2293,7 @@ static unsigned long collect_longterm_unpinnable_folios(
 		 * but also to remove any other folio references from LRU
 		 * caches.
 		 */
-		if (drained == 0 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + pin_refs) {
-			lru_add_drain();
-			drained = 1;
-		}
-		if (drained == 1 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + pin_refs) {
-			lru_add_drain_all();
-			drained = 2;
-		}
+		lru_cache_drain_for_folio(folio, pin_refs, &drained);
 
 		if (!folio_isolate_lru(folio))
 			continue;
diff --git a/mm/internal.h b/mm/internal.h
index f47f06c555481..f6b59ab296b80 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -43,7 +43,7 @@ void workingset_activation(struct folio *folio);
 /* mm/folio.c */
 void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma);
 
-static inline bool folio_may_be_lru_cached(struct folio *folio)
+static inline bool folio_may_be_lru_cached(const struct folio *folio)
 {
 	/*
 	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.

---

base-commit: bacc32cc7de65ffff70080a48eb294f89e434d5e

change-id: 20260806-lru_cache_drain_for_folio-69359cdf55bc

--

Cheers,

David


