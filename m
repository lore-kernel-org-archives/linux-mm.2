Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B81560A2627
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=O6zSV6AD
Received: by kanga.kvack.org (Postfix)
	id 02C8C6B05D0; Mon,  9 Nov 2026 07:32:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004176B05D1; Mon,  9 Nov 2026 07:32:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35DB6B05D2; Mon,  9 Nov 2026 07:32:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABFF36B05D0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:32:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EA85C0659
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:43 +0000 (UTC)
X-FDA: 85415519406.07.0FD8AD3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 47F3DC000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O6zSV6AD;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0m3LG1TSGw1pl4wrdSXysmWFFd72Xwpe4g0cR8PTVs=;
	b=OQ35lmy8Ueav1lHG3w7ABYS2uJBLByEUJQWoY3TMn0FpG9eRLAPvZrilPmmHKyiSubZSch
	ue7jKEIH4JH7QQx4qg8MGxmltZ7IpHhDy/tPPKbOYQa84Hw+pFNSQpEd4jS20rfzAMuumc
	YpQYZw6bjnlWK4JpndTb8dEWc5qIJio=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O6zSV6AD;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227561;
	b=JTJxhMYD7xhKooVlu7ovdAK3XoKfCi9rlWYe9BsaL74uUi7PyM/xCvGHDE2iP0CTzftyCq
	wibXEsTN5da0kaFQvgYmYogguYhbPi0CPcLHxiidysrLsLm9wuHIK3XMdA/PELQZGCW56N
	NS0yvuEVJGq3/QL+9Z0czrK/DgPJ5QI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85A881BA8;
	Mon,  9 Nov 2026 04:32:37 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7FBC3F632;
	Mon,  9 Nov 2026 04:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794227560; bh=jgTt0m9myglWZu/F2zsSCv7Hlde3huyTl+uIVrhL1pc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=O6zSV6ADLb+2dw7TL4s2du5r2X3O8T9grQMMx63wdw0frJ3ISrEqJnBSTdoFsCGn+
	 qI/w1HVzJRAwg0+eLvzZl0qXpr9o08iF3SqHPihczfjwiMLh5Z/JTjAhfyPZpQ/uUg
	 7DFiDIPExDC+LXgWhXMruI1vguXDE5lQ/gaCkl7I=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 09 Nov 2026 12:32:27 +0000
Subject: [PATCH v3 3/6] mm: gup: move gup_must_unshare() and
 INTERNAL_GUP_FLAGS to gup.c
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-refactor_gup_fast-v3-3-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
In-Reply-To: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6133; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=jgTt0m9myglWZu/F2zsSCv7Hlde3huyTl+uIVrhL1pc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq8b1duRloqYMc+JZKOmgdOeurSbfd/E4SfH9H5
 16ooShkiCKJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavG9XQAKCRBt1cPRWsUx
 MxQxC/0ZeP9kUeFguyGFERYtz+cwMA0d4iAsOi1YW9qLdaay2HKD3xNI0IHssMLcpUK7cfa3XlS
 5UG2N0NV93oCxw6VDzLHWvP+ksSXJGfbeCde2KfQYqlIfaYl9jSe4Ma5yvchoAn1lVxGpltB45J
 V9Gx++6Loh/uHF6BlfakBxzRsJI2iJl3FfmaLYWSRR/VoQB6eJEIX26ofg1znk9U3TDTYyxyPpv
 ON9T0EVd5gDeMTx4Fm3wQq2jh3/8RnPa2CfSX1OYSsgkywYyGc56UXkczvHQo19NffyB7/1nXGX
 Dp0acOBgYAPygU2Mb7YAJP4Kt5mDca+LlrjIH/c7I+0+5zhhT4OycdnHc32P3oRe9aMPjWQgli7
 39gaoW/GMEtvnl00WsiXk/d7dtSR2pG7xZakb4afUfiKleCnc2fFOIomd1r3UKwqasMeFeMqzQt
 cqnP1mAzHWHG/NiH7ieQTQ2EPB7+uLRUliRZFEQc7rv38LB8zRTwVXtwtDlm+HwlLgJvU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: ukicckee3wt1fknqkopng396u8qxeh58
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 47F3DC000A
X-HE-Tag: 1794227561-899465
X-HE-Meta: U2FsdGVkX19ps42jtuky8sNHm8Wkj9FDq6CK9ztixEkhT8nq1s6nacG23XAJiZSrPpYDaArIkfxwUvZCeC8l9ZNFA6mDKJAT8LO6q6q+J28kRio2A1PhUm+TAwcHlTzAZyWYO6yZ1O2o89435dq0PFa6ziAL4icb8/PrnlxZ6AiwxwMjZp7ORBvfBk5FnQwzDNiKBqVhGwxKIrbmewf+Y21KEl0lRDiAGrWlbJECOFhs0Ld4FDb5skDewYDSMWrQO/DUg/r4TrIqR6W3UOZLaJgCvpTy3qVNtxKbf/LB9Zi0c8gfEHlxLBmF1yfQIyUP4wd4W8HIW9IcFkYYJ4PqXFHoTNg64rprfx6JcADz/jNC8JAihnlV5YvpRfTA1dTrnfIq7S5GQS7HvZU31pX685VcnQuqGIGEgtlB3ESCEnVAQZMJfneeGSh4Rr5Ju6+4o8s0HLfpCKjxESmtTTd7SliZrASrAjiDUjq5VsF6lH4qjGXuTRCxdFkzzNxj9qaZAPzf3XJ2NUHdIcoUNBS0DXY9UqqMEnVgi4l0WgIVxoPxS6zhXq7kcyEniB/R4Z40ElYGI8QqdqTyCt+PMZqlf71+GtdiyYrHPA2RuEH9jV6tAtavO4zMPVqeMFOSF4fA6B6iI0CxcwLkon1GEThw5Na3zDomRq8RByUzbB11wXJHUT5+AQ/BR6hHuicwTntnW2YwJqfnjA6ZyGoj2t7d6TD9EKLX/iX4zstOVTWKqbTYulDgaDqmalgP+oKNgUgAdeSlqjewDOrENd1M/G7ZR5ZxplQEgpOvfKNgZaDG4omDKmw+CgWq72Gl8fXTs8Zp7aGGVkzYrRssD47BN2hViSIql/Ym6YB7/AroRZt+aMCIlYAckibJiL599h7XdXkxtb+mtYlnHLtGgzjR3Fburvumy5zyYVwhaXoQ00X8+znGc8lJLBW64hmuDVeZR0FCVcnP6mwGbQKkTidxlCl
 6zNSYIVS
 XkVDsCXrgvEFRt4fLaHIYEBPkFeS+VC98t2POZq3G9J+Oxm9UCy31EiNXxUaaOhcUfWnxzG57hxKXdajExPBgGDVjiLbzAPI6mdPdKv/jlZrIMDCGEciRY2mB2rsF4ZxN/ryDYqrM9HMMw1fdF9MoDDkCj+usQ68P1vFkWYA22/lHPjqYAq73fsl6dzM+wNOVDLD8XcgrIlr3OQpxlFLy6kTnHdoEzaW2cmeO2/omxs1LSxbEFJXJ5/AqRBqG+33sJHuNguE91G/x1r/cNiZ+4zAoP98sWqWBUN4tuhHKa1mEGyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

gup_must_unshare() and INTERNAL_GUP_FLAGS are used in gup.c only.
Move gup_must_unshare() and INTERNAL_GUP_FLAGS from internal.h to gup.c

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c      | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/internal.h | 70 -----------------------------------------------------------
 2 files changed, 69 insertions(+), 70 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7f9348c633d58..bfe83ce1411d5 100644
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
@@ -2503,6 +2568,10 @@ static long __gup_longterm_locked(struct mm_struct *mm,
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
index 9b8864a8540aa..7a315c0a93f49 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1330,76 +1330,6 @@ enum {
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


