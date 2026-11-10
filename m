Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77732606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kE7S7aRa
Received: by kanga.kvack.org (Postfix)
	id C2EC56B05B3; Tue, 10 Nov 2026 17:53:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06126B05B4; Tue, 10 Nov 2026 17:53:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B438D6B05B5; Tue, 10 Nov 2026 17:53:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E10A6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:53:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21D8E14014E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:22 +0000 (UTC)
X-FDA: 85420712244.25.7AC427F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 17ECF140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kE7S7aRa;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbcxFShisicA4cPdWs1hNTl2liz7wLMuWY62Qdts3tw=;
	b=rM2BoUGALFhcnJGEVG1JRE9cLA2XFxpyS/A5Ydu3BqjWxZUaAHEN3xJXdSRV2XWy7Pqs+q
	5PL3ZP44s+QZObFGsYXy1DQuDX05KUQtpSpjDa9gfS/9l5m1yi2YUcJmgg2I+kc9dd7BhT
	es+uclvhH6WI8/SUcGYWItaEo9e3peE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kE7S7aRa;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351200;
	b=xggnyopwtWZpNvYTro1zxGfTOsCF02ipDTdyj152m1yXv1Fo4tCkPqbyMIMwCqUwfRef2D
	2lX4mIbabtkbdImC3sBt3bW5GTb0nj9IfiDUBd9PNXeSpBgGGld9gXDufPHVXpeNX1JgdL
	z2geGmIodRxFGl23vz0tOB+h0ZbbwYw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3340C1477;
	Tue, 10 Nov 2026 14:53:16 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AC433F85F;
	Tue, 10 Nov 2026 14:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794351199; bh=4HlolDn2s9lvvHCEH5BsxXm+blGfSDIFm9T7XUOaaIY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kE7S7aRaa4lPZF2xu2QJu0KowVuJThV9ILanVwBxAQwa48t3QvGd5HXPd5PQF9jZK
	 dpbih/IPLRx3IJ0tsISYTGmPgMmphUVXVLNd88UWzdHzVvi8NXuBA961EuzEFnsSkT
	 8er7Ni2v02Ie4cKdkgNy51K/gqK/flc3cL86y97s=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 10 Nov 2026 22:52:53 +0000
Subject: [PATCH v4 3/6] mm: gup: move gup_must_unshare() and
 INTERNAL_GUP_FLAGS to gup.c
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refactor_gup_fast-v4-3-e779a7674274@arm.com>
References: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
In-Reply-To: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6232; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=4HlolDn2s9lvvHCEH5BsxXm+blGfSDIFm9T7XUOaaIY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq86BTaITMnZuXz2iWq65NmLKimaLIBA3D6V6EG
 LnDxZ0QFKyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavOgUwAKCRBt1cPRWsUx
 M52KC/9FZh1ap2gl+irou0YmRVf46FuZMY0LDD8VvKO4+xX+FANh/nRIvpMTAYS10YG8H9wQJyQ
 WK+Pisvn5daet1SeqdYB21UmvVTZEAJAj3H2NsYnUfsp05G178JwOi08mJTTZmMzkjH36yMGCgT
 FhYQKkc4/YPCjlYaWpnvPAoWh8/ZRor9wKVW02X7Ep93TqBXIA3KJ95Do5f9ODVlp8ckRt6C22S
 WRx1Yu1CJveFEWUqH4NVQCyX/RvPmiWNI1HzPi26l03ujoGYWMihYOikx3Lp5KdQTS6PlFzYVX1
 rQHV6r9Hoz2WmlKKuDDnjQx6M925bfw38nEQ1Z/4yA+LSB0bODIH88VXluOYvGcAbpY3cMHbWn8
 K+/L1KcAia989Wv/kWWzVi7QHxBuf6G/xnD4KoORcONL5uw0f32hFmvRUs6/hlZDVLgeKafReLh
 nLcTnVWRa9WaOF/5Vyls97Kpz71i1Cwe0sDZBe0KWssEG61zf9WpHwP24q20IGg1Zs3iA=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: zzb9yfio7fuhi1n1zar3pin5j1ewo1nn
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 17ECF140009
X-HE-Tag: 1794351199-308571
X-HE-Meta: U2FsdGVkX1/OpMl9W9c3CRVtCBhgdttEnJHgJv2bROIn2INEI1PAO65RtGq8zkZ/M+utJ1/HhZI4C9f7RFX/vmk6PxN0yCzGDs8O2vPcGHDERwopKLk44h9UFMX5lLQv3OZuV7MDfgdZQPG68G6jK1R8y+q+zskWrnWQhfuqFSUcUnAXYqmX1D6zBfm/hOp09gM+b5N9SSoICEphpbGCF78mZuQ1QhzSTfAa3sWycS5svNZfrwFXYysD5UZj1gvUyPsxVJClRx7BAMAtCeiUeX7rMzoEY2eBdM9mq3lcRABBLvr8tti1TyRWRyIzD1Sp3KBwZyVARJhZE6SDGZfkavVqEvy8FrsRyACTdKo31a/ci8/A6pnXMI9SG6sfcgOXlOFGpBLgeurBUofnb+zmzdlkkFxb9emCNggpbmE/9q7mU7sPRdgbUWKQ5rBGD8j3kZVthHzWMHny/sgggN6fDsErSMEI5PliPvSERt2pjkiY2hNPswlaqyj8eZDTqQSVZrYPmNAhvv+54BWukWrddMREQkdQtpZBt8O6LSZOm0DrTPNkB8MPBqeUagaEo4IeR6V6vJ6716/oVzVCP38iDhp6EMjtTlGJxmG9KpvBSwXJDrGMqgYC1Mrv44RQ5rV9x3PYHymf8hd4U99RMzqI6hw0JVHPEa8aAAo8WdS+ZAP9Yi5mbOyONo3L3kaK6wC8nosVMqK3KFHvgCRrBHvWbj326Bphr69ve2Td5jbgHP9KmWkk6G29Eg1lfe/gCWwk+xggt9UI3fHvX+HOmaiVJV1W3/h78YOqRDj1lQjN047y/6zAUJhVzJlL6MohPWW4D8gavcjLfKh0SgvvND9Bzv6a8IOe8luOroLiEikPa7icVitLw8otDgG31DykH7ycLOlgjWYvhxCadMMEEjeNfLKtdOo31kGKOIbcIgS8T8fZYhAz1WrZpsD7vxX/6tNnKAxfRJXaC7gel2l3Q+8
 7Oc5vSs/
 wee//7UVVmA3z4B9n57BGeDPkJMGAOV0BAj+Y3SETlO4897DgrxKx9MTCw6DOG0LWSTzk4V3POjA1SepDYUFXSU6jjXaIS5S5WP9eOCaKWNwQ3EgOiZhXuX6pjj5IxtN4Hd4ckMfsmElnKcig3zf6lTmmnjKM1OJnTVUb1sIg+8ACc1f8LK4lTEqDtndAfO5uXnIqUXs39XJP05TSGPKalyD7bhL68BJU0e75Xf7xlAaiH1coSCv0Qi2SaeqHeHabbKvK4urziT7pFRrDmflR3C2xQHAb7x2S4hVYIV3sP7w8iVU9cZlj9xWV7SKBedLWbzDbHzDk+TGDtaQnJEiJxq3cvhZfzQsbgc3ugD6uLEephwuvrt/wkPFVSnZ2/9qvQl3V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

gup_must_unshare() and INTERNAL_GUP_FLAGS are used in gup.c only.
Move gup_must_unshare() and INTERNAL_GUP_FLAGS from internal.h to gup.c

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c      | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/internal.h | 70 -----------------------------------------------------------
 2 files changed, 69 insertions(+), 70 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 00dac03093a4..ccdce67ef300 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -633,6 +633,71 @@ static struct page *no_page_table(struct vm_area_struct *vma,
 	return NULL;
 }
 
+/*
+ * Indicates for which pages that are write-protected in the page table,
+ * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
+ * GUP pin will remain consistent with the pages mapped into the page tables
+ * of the MM.
+ *
+ * Temporary unmapping of PageAnonExclusive() pages or clearing of
+ * PageAnonExclusive() has to protect against concurrent GUP:
+ * * Ordinary GUP: Using the PT lock
+ * * GUP-fast and fork(): mm->write_protect_seq
+ * * GUP-fast and KSM or temporary unmapping (swap, migration): see
+ *    folio_try_share_anon_rmap_*()
+ *
+ * Must be called with the (sub)page that's actually referenced via the
+ * page table entry, which might not necessarily be the head page for a
+ * PTE-mapped THP.
+ *
+ * If the vma is NULL, we're coming from the GUP-fast path and might have
+ * to fallback to the slow path just to lookup the vma.
+ */
+static inline bool gup_must_unshare(struct vm_area_struct *vma,
+				    unsigned int flags, struct page *page)
+{
+	/*
+	 * FOLL_WRITE is implicitly handled correctly as the page table entry
+	 * has to be writable -- and if it references (part of) an anonymous
+	 * folio, that part is required to be marked exclusive.
+	 */
+	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
+		return false;
+	/*
+	 * Note: PageAnon(page) is stable until the page is actually getting
+	 * freed.
+	 */
+	if (!PageAnon(page)) {
+		/*
+		 * We only care about R/O long-term pining: R/O short-term
+		 * pinning does not have the semantics to observe successive
+		 * changes through the process page tables.
+		 */
+		if (!(flags & FOLL_LONGTERM))
+			return false;
+
+		/* We really need the vma ... */
+		if (!vma)
+			return true;
+
+		/*
+		 * ... because we only care about writable private ("COW")
+		 * mappings where we have to break COW early.
+		 */
+		return vma_is_cow_mapping(vma);
+	}
+
+	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+		smp_rmb();
+
+	/*
+	 * Note that KSM pages cannot be exclusive, and consequently,
+	 * cannot get pinned.
+	 */
+	return !PageAnonExclusive(page);
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -2507,6 +2572,10 @@ static long __gup_longterm_locked(struct mm_struct *mm,
 	return rc ? rc : nr_pinned_pages;
 }
 
+#define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
+			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE | \
+			    FOLL_MADV_POPULATE)
+
 /*
  * Check that the given flags are valid for the exported gup/pup interface, and
  * update them with the required flags that the caller must have set.
diff --git a/mm/internal.h b/mm/internal.h
index cd3675c044e0..177bd47045d1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1326,76 +1326,6 @@ enum {
 	FOLL_MADV_POPULATE = 1 << 22,
 };
 
-#define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
-			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE | \
-			    FOLL_MADV_POPULATE)
-
-/*
- * Indicates for which pages that are write-protected in the page table,
- * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
- * GUP pin will remain consistent with the pages mapped into the page tables
- * of the MM.
- *
- * Temporary unmapping of PageAnonExclusive() pages or clearing of
- * PageAnonExclusive() has to protect against concurrent GUP:
- * * Ordinary GUP: Using the PT lock
- * * GUP-fast and fork(): mm->write_protect_seq
- * * GUP-fast and KSM or temporary unmapping (swap, migration): see
- *    folio_try_share_anon_rmap_*()
- *
- * Must be called with the (sub)page that's actually referenced via the
- * page table entry, which might not necessarily be the head page for a
- * PTE-mapped THP.
- *
- * If the vma is NULL, we're coming from the GUP-fast path and might have
- * to fallback to the slow path just to lookup the vma.
- */
-static inline bool gup_must_unshare(struct vm_area_struct *vma,
-				    unsigned int flags, struct page *page)
-{
-	/*
-	 * FOLL_WRITE is implicitly handled correctly as the page table entry
-	 * has to be writable -- and if it references (part of) an anonymous
-	 * folio, that part is required to be marked exclusive.
-	 */
-	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
-		return false;
-	/*
-	 * Note: PageAnon(page) is stable until the page is actually getting
-	 * freed.
-	 */
-	if (!PageAnon(page)) {
-		/*
-		 * We only care about R/O long-term pining: R/O short-term
-		 * pinning does not have the semantics to observe successive
-		 * changes through the process page tables.
-		 */
-		if (!(flags & FOLL_LONGTERM))
-			return false;
-
-		/* We really need the vma ... */
-		if (!vma)
-			return true;
-
-		/*
-		 * ... because we only care about writable private ("COW")
-		 * mappings where we have to break COW early.
-		 */
-		return vma_is_cow_mapping(vma);
-	}
-
-	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
-		smp_rmb();
-
-	/*
-	 * Note that KSM pages cannot be exclusive, and consequently,
-	 * cannot get pinned.
-	 */
-	return !PageAnonExclusive(page);
-}
-
-
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	/*

-- 
2.43.0


