Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B000D2FED2
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1A96B008C; Tue, 27 Jan 2026 14:30:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35EA06B0092; Tue, 27 Jan 2026 14:30:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261F76B0093; Tue, 27 Jan 2026 14:30:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1440A6B008C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E836D3391
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:08 +0000 (UTC)
X-FDA: 84378734496.25.CF55557
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03654C0002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZsAx+lcO;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V28GZ/pMMlammuSEiK+5kr//9uioWeDO92cSNKZ9IvA=;
	b=PRCN3iqKU0xI0rB1Egxr5KTV4HtvZ0eMb9mL1drFR3EQTTauvRSnktFryP92IbLWAPUJ43
	YPOUdkelehYoMHtYWXK5VnAIFNbWyJfsDB3jzGUibaMazLijEsxps0hfaciBYb7e1O5c0Y
	6CoYmBX9m3ZiLENDMFzFY7/y0l11q4c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZsAx+lcO;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542207; a=rsa-sha256;
	cv=none;
	b=1RIPiNJ3vmGqSydDc8ndWGZ5XC6c8sfT1sSdM7Ftyle4bDPSM5vK/uxHboFVzjMdXnWfFi
	y+8j5iV8teza+HVMC9C6NQUcUa36ome7KvX2m5FudvOA9VBXnzhwDh4dxt6itFvpsgexnc
	WmHXixaOCcqlT4T8pn/pGTbJw9ii56g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7247B60146;
	Tue, 27 Jan 2026 19:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2B5C19422;
	Tue, 27 Jan 2026 19:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542206;
	bh=vrJiGnjrN54H6/hY2yBJ167Kljp428ywa4wfYNGCg7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsAx+lcOfUN+ECjYaQy+/o3roO+K1SedxxG5fNMiknciYUsLwxKjIjhmCgIUs3wNY
	 Y81+OqvNTso0O/aKTQ9Y8I0Gkm/8wJDtbigcgGWHw4VLjiOiUwfKlBrZS9ZK4AKR4f
	 w3tjGLjAXXqe52duuTP9qv/6lh1muhhNvJ2d3oyTZGqyyXYTbZfjQWj+ZVZkUQHjlC
	 36C4iJ6jhgGm9WiJMNqaoViZgCOZuXilC/3Z0t3ZF15rAoqN0uQxYBP5eEq2w16lmp
	 5aPfACXz90qz/XONl8LYfFtdB38cmBz0euQcpU84+fQHpFa7ZAeuo75YE4KQzrt1+k
	 wN4w2q+MEFi8g==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 03/17] userfaultfd: introduce mfill_get_pmd() helper.
Date: Tue, 27 Jan 2026 21:29:22 +0200
Message-ID: <20260127192936.1250096-4-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 03654C0002
X-Stat-Signature: 6a4a7xd9f7xunsge5n38cbmzwfhopamp
X-Rspam-User: 
X-HE-Tag: 1769542206-272584
X-HE-Meta: U2FsdGVkX1+D6UxR22E+qXgZD4TBW8Z23p1GZLOpCkI/3jYte7WtGDrQ1/gmevJssA7QS6fJi02PsgyRqofeUXmUWMVSwyFwwUdE6v4A5cR6LmIe69BZI1xAU6sgq6AHklTtumypAbSd6IUu0Nj3w7/UE3GhEahY+BXL2MxAOtEMeZjLC6j0zpdiwDUeTI1DHNEH2XoE5hCoC1MaUHtWwfw5rx8Xe1YnSGrs4HQn1sbMPILolalrURlPse2KGKn9jva8QEUURPnElkr+0/iWNT+NJ4v4yjp6SeXAJXlwFoRjHk3FXBOVL71XoizYxSYE+Ax6fYKnohUttikICOSzdty3tpNLNsjXI2un5XmogfFOPkUY/3TorK57SJsFa0KXS/y0uz2qyh/env6lNn9FqQVqNR9Oxtmj0dOxlOKTH96krolZW4tEKgD1sP/APnKb/lclCXHHfEXs/PpJ/06nk+0TgrxbQxMRpdinI2uys+3ls6DJAV3vremNWn1q5fagMgm/1h/FJ1YjgTWIKROf5nwxTTl3F4gr0f8HClEACpEovg+KAg/UhxTo5d9mhoZKqGIBZ9ayI/QoRVfG4k6JwxdLyBQOI5kcEHh/iz1Azwe37d0+oq8kayEp9vCTcqZCEQ4spXvGTuwf1ZTykPR+B+8H+XOM+YntcFbuLOAcc1eiA4OWBu1ybyMzujhu5vgJR5G4zm9ih02I4GBF+8ik8eBm7lxBdhUuyuaDSue8aPiAgV3MYIs89mRhM6S9jwN2WnvqK1uVBubVrXEZvDnfUomRex8C2nfS/If0VR+Mf9bEXsZen+phOP9RC/TvIsOB4mItGtLkYqqnqYJS5pjG+0TnvJ4hmNbuCR3DAeWl+poKiifm89jxdeYpS1pMoQ1oyb7o6cFuiSOIkQy15zriBRvoNuG4KbNd4SI9P3NCnXsGtLI83PbX7ROk0VrNG5IxgQYRA8Lh9oiAhAOgCxs
 5bz6R/tw
 Gn/sBbot5SpX7NKeAGNYlepODwD2+HRAQI4LRfD7//gWWSnvwNfoiD2BoNIJ1Ybvw2BejmjJiqRnwrP+pFuA81dxkE2vaRjosaHJosd9SrJQorZgw7nbn3TAm5FezSNlgIbND9F8kozegdYpVexVUZs1Mho1wNQ7MPmJ68VeIpmkf1IDdYfnoR0HHe1y1+7Q2huPXWS4thbXSGrCDo7ZuCDa/hz9QQLikjxtU2HGnEq7dXsUOhv8sDMwMuTgDwbwoe1ykCl35CYc20WigWdnpV6zAcOlhu3r9GppzFz/KAhlcvfUnTjdPagj4buSAXeTo9fGJO2UdvJje+PBpTFOEZJ9pzSkZ88zxJv6S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

There is a lengthy code chunk in mfill_atomic() that establishes the PMD
for UFFDIO operations. This code may be called twice: first time when
the copy is performed with VMA/mm locks held and the other time after
the copy is retried with locks dropped.

Move the code that establishes a PMD into a helper function so it can be
reused later during refactoring of mfill_atomic_pte_copy().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 103 ++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 50 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 6a0697c93ff4..9dd285b13f3b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -157,6 +157,57 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
 }
 #endif
 
+static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	pgd = pgd_offset(mm, address);
+	p4d = p4d_alloc(mm, pgd, address);
+	if (!p4d)
+		return NULL;
+	pud = pud_alloc(mm, p4d, address);
+	if (!pud)
+		return NULL;
+	/*
+	 * Note that we didn't run this because the pmd was
+	 * missing, the *pmd may be already established and in
+	 * turn it may also be a trans_huge_pmd.
+	 */
+	return pmd_alloc(mm, pud, address);
+}
+
+static int mfill_get_pmd(struct mfill_state *state)
+{
+	struct mm_struct *dst_mm = state->ctx->mm;
+	pmd_t *dst_pmd;
+	pmd_t dst_pmdval;
+
+	dst_pmd = mm_alloc_pmd(dst_mm, state->dst_addr);
+	if (unlikely(!dst_pmd))
+		return -ENOMEM;
+
+	dst_pmdval = pmdp_get_lockless(dst_pmd);
+	if (unlikely(pmd_none(dst_pmdval)) &&
+	    unlikely(__pte_alloc(dst_mm, dst_pmd)))
+		return -ENOMEM;
+
+	dst_pmdval = pmdp_get_lockless(dst_pmd);
+	/*
+	 * If the dst_pmd is THP don't override it and just be strict.
+	 * (This includes the case where the PMD used to be THP and
+	 * changed back to none after __pte_alloc().)
+	 */
+	if (unlikely(!pmd_present(dst_pmdval) || pmd_trans_huge(dst_pmdval)))
+		return -EEXIST;
+	if (unlikely(pmd_bad(dst_pmdval)))
+		return -EFAULT;
+
+	state->pmd = dst_pmd;
+	return 0;
+}
+
 /* Check if dst_addr is outside of file's size. Must be called with ptl held. */
 static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
 				 unsigned long dst_addr)
@@ -489,27 +540,6 @@ static int mfill_atomic_pte_poison(struct mfill_state *state)
 	return ret;
 }
 
-static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-
-	pgd = pgd_offset(mm, address);
-	p4d = p4d_alloc(mm, pgd, address);
-	if (!p4d)
-		return NULL;
-	pud = pud_alloc(mm, p4d, address);
-	if (!pud)
-		return NULL;
-	/*
-	 * Note that we didn't run this because the pmd was
-	 * missing, the *pmd may be already established and in
-	 * turn it may also be a trans_huge_pmd.
-	 */
-	return pmd_alloc(mm, pud, address);
-}
-
 #ifdef CONFIG_HUGETLB_PAGE
 /*
  * mfill_atomic processing for HUGETLB vmas.  Note that this routine is
@@ -742,7 +772,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	struct vm_area_struct *dst_vma;
 	long copied = 0;
 	ssize_t err;
-	pmd_t *dst_pmd;
 
 	/*
 	 * Sanitize the command parameters:
@@ -809,41 +838,15 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
-		pmd_t dst_pmdval;
-
-		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
-		if (unlikely(!dst_pmd)) {
-			err = -ENOMEM;
+		err = mfill_get_pmd(&state);
+		if (err)
 			break;
-		}
 
-		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		if (unlikely(pmd_none(dst_pmdval)) &&
-		    unlikely(__pte_alloc(dst_mm, dst_pmd))) {
-			err = -ENOMEM;
-			break;
-		}
-		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		/*
-		 * If the dst_pmd is THP don't override it and just be strict.
-		 * (This includes the case where the PMD used to be THP and
-		 * changed back to none after __pte_alloc().)
-		 */
-		if (unlikely(!pmd_present(dst_pmdval) ||
-				pmd_trans_huge(dst_pmdval))) {
-			err = -EEXIST;
-			break;
-		}
-		if (unlikely(pmd_bad(dst_pmdval))) {
-			err = -EFAULT;
-			break;
-		}
 		/*
 		 * For shmem mappings, khugepaged is allowed to remove page
 		 * tables under us; pte_offset_map_lock() will deal with that.
 		 */
 
-		state.pmd = dst_pmd;
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
-- 
2.51.0


