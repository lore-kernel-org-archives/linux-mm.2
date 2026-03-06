Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6412BFCC044
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B966D6B009B; Fri,  6 Mar 2026 12:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D466B009D; Fri,  6 Mar 2026 12:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42D06B009E; Fri,  6 Mar 2026 12:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 96EF66B009B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:18:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64AF41A067E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:47 +0000 (UTC)
X-FDA: 84516297894.09.41EFF1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5290C0009
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3HRU2ly;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xY1I5NuNUR0Tm5pQgRHBCqSCMoklqCH+cASNc+1LDiM=;
	b=x6ffhSM55STyjQO6Ieoy2z42pJEo9IzbxGChtpGpoHuF18ZBx1CaNVg+XJdDTgIukjDSTO
	blXzwAqVCMPxcSqBIm0lP47IiAUlu4VNxtq3i9I2XzYF7ZP8ro9OFK+/pOYyLaDMmdLsgr
	UKPjfa/pgFfZUoNgATth91zt8p73VHc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3HRU2ly;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817525; a=rsa-sha256;
	cv=none;
	b=WW6jQfkrRxbbWgDJiWip7reatjLyoyMz2U6LpkiBbuFElBHkkAHXzUsWHtPK+jRfffGbj0
	vnOh9BAJpsW5SjN7ucDb2ZoLlQtbVo0Y7GnIFd1JwtnUAM95ZKQTgHkRIOT9hL+KOYK8nw
	gOGO6j/HNdSnaQDJaZw/IRiyPgbLkTw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A0F46012B;
	Fri,  6 Mar 2026 17:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B55C2BC9E;
	Fri,  6 Mar 2026 17:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817524;
	bh=DdkBLcyw+sipu4BSpL/585CvFlIlf6rPDOWu2SiTMnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3HRU2lyWBByIjTTYyfZYZak9BV/jY/lGIMnXLyCgmBCD81NBAfQjFBY9ow5u2M7I
	 nUIDesnw68TLEvSvBx0m6XKIIsrxf0MS0K4MKVcIe5H/+cwHijM91MTIkiIN/LGhWc
	 /5sxbrSW0wDfTA7Hta3ANG+yJmOjyYtZZD1giqm1U/kPCBYvonFxw4G9t4UBkemHwm
	 +cy0bUnJhLbuDi6tAJ5kOsP7tFwIlvCtospvN4F+Kw1jzczJLPuly4hohmRgfQC8qk
	 JrrsOL8LIs5uTFqZ+G3VNMKe9F2/IOGD+j8D6uVPDMdpHmiF3V/Hv+klbNKjTvHbwc
	 VqFPzJMuB94mg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 03/15] userfaultfd: introduce mfill_get_pmd() helper.
Date: Fri,  6 Mar 2026 19:18:03 +0200
Message-ID: <20260306171815.3160826-4-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5290C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: 1jnkrb6g6zqm4cdad85ijtk6t1s41d7u
X-Rspam-User: 
X-HE-Tag: 1772817525-784619
X-HE-Meta: U2FsdGVkX19gn5lKrZcnHOJAidrGTpWtEYqRAo9VAO6hSIkeJHwVY4R66Ktpi/3wHAchdeknKIZVQwRntSCsW3pweNSQox7jhB5XtBqW1YDxScLEPbMpgyJcaDDr0eqgYcnOCxyqJOEER1XAarrwImIYycTWKQsf3ReLjrD+efdyaR16YWNw/j8Qmoj5P8pqih4AteOIT++tPqzZPVVIFTyg1rFcfNpDnQO7sewWrvdYIq0yJpriQRYZdxv6kEsSYBakcjh5SGRkqjMK2bF5daSDcI1eqINSi+kA9YGWWaSTEeaEOaikOOU9dUO8MxNESpP+Zy3ZpN727KozvQlFiRPpDZ5XlAJG6wGSkkynSGKA0sUGgaGJGGwnlaWlowHSOJjgWL3t+mB+rZxVotUfE8iRL7+bMusLp/cJ/jk0wcsvPSNnFG9CzMbecsgB7RtKtNkKr1HXMTbjC3TYvKBe+4q7tnA0hhxA3UDpRsY6SMGnrVTCRbdRVVBCUcEJjfdcwZzlrkCF2pfhULi6HaMWAk+XT4cZM7y07+R4aGP/3qQrCP0W8vvOLvgyb3grwUDssIC2pLl5Ht4w1FOxSMY8M+Yao8i2rFJvezLT38FqRu0hyDWrnAfLmsNQj7ZOEn0/WDuncqE1cTNPpGma2oKtu4fLttq/oEvsPfjNM94eS1Sr4TADTEPG905MARsFMxO4AVTK0zK2yGh8JeJHxxAPPnOEXhODsJS2CGiz2ks7UKy+ilV5hfkMyPqqRIjTj+LEOQDE8P8ZRPEKxEt9BpbkTuHAhp3pNe4gfuAzifE0F3rjSf9UE6kN1PNbOMskRRgxnsBFXb045rYj5wxrfR1GZMhCixcrwDo6GayzUdflmUjOFtSuaD3bb9RW0CQHjZDNdV4RYeO3CJlWlkrqsqfP7Z5iir+cnCHDeLB5k9vKYHGfBqEN2Qr8fACVxOvedJ5+fMqU7Ut4CmiPUBi04iz
 4gEL5Xu8
 fNWoPrKGQlayddhnMQZkO2rcocHFHz+WbxMCQtQb1JpUPF+YJKBYq6Reo8JT17w8e8FMZXfpSHR5blUxA+Rov26CxpOveUt5EFUuc0LzFqFFHycyY/N6PQ1bBde3FbasjFuRfdBq8CbDo7/sK9AOtK038YbMRxjYMEGnQ6QG0OS0S4lVy4AnjD4evQf2ze0Gs+Y5ydo8fWIREQXKzjymL/GWCu4Z6W71HW5c/VHHxalRTDAjDJWkAT80G3hFwW8yZL6a16yTtIDgBhUq+NccIugrX0g==
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
index e68d01743b03..224b55804f99 100644
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


