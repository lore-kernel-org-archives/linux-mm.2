Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D095C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A116B00D8; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39936B00DA; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA13B6B00D9; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB2B6B00D7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2048B1A0711
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:38:08 +0000 (UTC)
X-FDA: 85060061856.06.0C9219E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1956C140016
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QPbS+zgo;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764286;
	b=JmWGhvLZ/j/s5GRo1u7DNBE1RXEDDzInCv0pvJ9rkz9NxGIJQ+3zRZX8p9+DgsnREg9FKj
	FPHPaJktdfNsJQJeco9SXBylfvNt7kiHNNCJIT0qbWSlAEKANkeEEdBd2VXl+NMw5E+6C9
	qNjIfsEe5glhEGVDopbOEewFDcb+SDw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QPbS+zgo;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764286;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhS0QL5vdnrOXe/uVKEJPlsd4kakvR5vPEX7gUGfoto=;
	b=7Zi0OW4/SS4oEFD8LGmM6yibjwSgKTLAxc7RvV9Ytd0W+Uvdl6iHb9GeGAik8552ZNnhFZ
	0TKG+GZ6VwU6923bEPZX+WGWwmGB5fVGFp0VJFErFCZPJwkZ3M+K3hcUeXQbTtdska/hJB
	JPEl3H+RTUpMJm+6+zKdokom+TKwxro=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3282142AB2;
	Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08419C2BCF4;
	Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785764285;
	bh=40q8fHgrl8IDhLHqWUcb4B48rq7YY/FRZG1EdbUo6Zc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QPbS+zgodnxPQGiJyFIgllRtmV8vNj/3Tv0CUylyalZ7OTfpaFQalUVs7/mNJVPBt
	 ZDYvZly8ujRRcUUep0N0JqorzhPF8vvyszaL0DP7sb6o1aryPLyKDGuk3fn8prDjZP
	 tS50PHX7A65A9xmKtD19ZUHHlczQHbumFWx8gap+KuGyrxhe6pHyv0j0UMEAY9W1xr
	 gxNKVKwKS4f+JKuS4mj22rRbyXKBgjQGG8MnXyvMd+diOhPSQnyxtzLthj4o6igH9R
	 wlMEp4lkItzyEBxAkUYjqD7JR+ScQSl5SbK3MY8UmXsNrGQw/N6i5XhY+aOccfwo48
	 AYPk3pfBOvQwQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA435C55179;
	Mon,  3 Aug 2026 13:38:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 03 Aug 2026 06:37:58 -0700
Subject: [PATCH v5 1/3] mm: hugetlb: Consolidate interpretation of gbl_chg
 within alloc_hugetlb_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-hugetlb-mpol-interpretation-v5-1-af2b7089f8a9@google.com>
References: <20260803-hugetlb-mpol-interpretation-v5-0-af2b7089f8a9@google.com>
In-Reply-To: <20260803-hugetlb-mpol-interpretation-v5-0-af2b7089f8a9@google.com>
To: Alistair Popple <apopple@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Byungchul Park <byungchul@sk.com>, David Hildenbrand <david@kernel.org>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Zi Yan <ziy@nvidia.com>, erdemaktas@google.com, fvdl@google.com, 
 jiaqiyan@google.com, jthoughton@google.com, mhocko@kernel.org, 
 michael.roth@amd.com, pasha.tatashin@soleen.com, pbonzini@redhat.com, 
 peterx@redhat.com, pratyush@kernel.org, rick.p.edgecombe@intel.com, 
 rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com, 
 shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com, 
 yan.y.zhao@intel.com, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785764284; l=2991;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=rwfMlDQJWltPz5tqq1rs54f6f20kc49IZ7Zey0jTeJA=;
 b=2zSZQf9o6UpYJ9eX/dzPufzBYrXVNfD5XqllHda3DLhg9nu4sCYW4Poxxn/K+5QpGBoDsThlp
 LKnBnPTEUMdDj7Dri4sNbXQLoI9d8sPZXL/aAUEw2FfYdqAgMaCHYVy
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1956C140016
X-Stat-Signature: kr5fz4i1uo3371j9ain6z343u8dmosms
X-Rspam-User: 
X-HE-Tag: 1785764285-885462
X-HE-Meta: U2FsdGVkX18sSQT4OrpPcisMpZEQDHmFnpaxBELkVsR7XGObMA+ANjjxJna2SL9v1Qstumaz2lFE2GbhPPSwIfEv21u7jKR8zwINS9z3EkD9ubE4/eOy58jpLorl7ZuLuQ3cJNXENQjGsAHBTwsdGfksP/PbzS7QSqA+89F0CZKjx6FaGPCTcbzTlLE5tGsc3A3jTESFG46vdCK61LrVJeJ06Q0lSMYLaPFrBiyLF773n9hKjiASgX+j5fdIwvdJrqweU5+EH5ZN0Qi7gVAsTY2J6GBOxLJLOVUHqF/qhSWb6PVal1hKka4YlQ/+kCKvCDmFZXOlktbstcDydYKDIcfYh3pfw9OMgOWgemZFvYWy/WMNoHrxKcudCsBXGTT2zaa98SoBv5kOTQJ1QXz+LaBm5KKqaDsg6+avrOn/0LzOp0e1kjfoQv/GyiQXv8dcVt0c6SpBZV+ncKygy1YL3Ey04EWN+6mTX05z3HK1fwiEjDnxdroE6fIxZhq3MwLFAwtL3wdkweNaEhZV0egKPYoeF4hMYO7eScuUcvyDM06bEoJ6NePFMiGHflJpVgFSGL9I4kJ82E6ruhRPQ4UhMpoEPiwtkt+G3SSG7rHG3LK/PSe3lFygh42tqHxO0NgJBg732PKafDkFtancl9Ss3zsaTIGMd67Y87eBdZPNp5SpSIxfadnNoYdIQnhn8eAEJ91igOtlJWq1pg6OR7eTmt2WGibSrhU+X+kFT03c4FjchZQ8/Wl7/t1HzCLRil+wozBgx6qdVpSWOLRzGY6/IdgbKY8RxLAWxhp7wmxUzZQphYi+MUyIVfW2ZwVtKrR/qjeefjaroZJYRm/hBpRflBJN394qQWLY5o845EkDrpj70eQCsDWxMqOOJ7H86zKjJIOINCkK4mLG2tc/Vj+eGgNVGlyTUmKXQCXgqFCS/+yMDSLd9nc+VBaNVjExFHp0xkejtgnhc21ZZaUgJnt
 0gYezu4a
 J4mZs2mDLqKZqXu26rPHldYWqJWyBW7pMzHiaanEN2wZsqTDN6UVEXuDNYvXX84bGVT/SDoHQICRo/3CPX8Fvx31rEaHh2j8EqvcXMFe3PuFIfW7S7PWAUt7YU7yJckVZKxJ6uGB7Id73dHTgDwthy1PD+GMLmM8x/Vu7yZ7FcHv0lQMjmfgYvtKGsFoPKN5QI0N/09BeQRh2E86Cv+3eiMFlMJasAaXuQ7kq7ed6kQXzEGcquojqDjC6r423gNZKq6gtLwMn1ANZObuGNGNvVy+3cjkFg9Os4YR1qLfuoFhv/asQjBRKiTXnvIspPVhaVWu/zSFoYcmJTZ48U0YTDEvCXNuEhZD0f9JsPFS7y5sTtxdegoWkFdGtNKOFXeuVAXg/X9OyFeqOYCowdbSI7CYEjco7RCXrfw2g885AdwmJEHn2Xo54MsBODvBxWxEjzo9RbGRBKijMeSuBxYcEgWr8a/thlEgww13Caut4Q8TFCTQ8OLa6v6aH8u7PchTwZcJXtcPKcv+wOLIJlNYC5PLLWQ2f+tPFnAfIZ028BfUUW3Z7isDAG/MSJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

The dequeue_hugetlb_folio_vma() function currently handles the gbl_chg
parameter to determine if a folio can be dequeued based on global page
availability. This leaks reservation-specific logic into the dequeueing
path.

Relocate this logic to alloc_hugetlb_folio() so that
dequeue_hugetlb_folio_vma() focuses solely on selecting and dequeuing a
folio. In alloc_hugetlb_folio(), only attempt to dequeue a folio if a
reservation exists (gbl_chg == 0) or if there are available huge pages in
the global pool.

No functional change intended.

Reviewed-by: James Houghton <jthoughton@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e93c4d2456aa4..7985cfd21a03c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1319,7 +1319,7 @@ static unsigned long available_huge_pages(struct hstate *h)
 
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, long gbl_chg)
+				unsigned long address)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
@@ -1327,13 +1327,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 	nodemask_t *nodemask;
 	int nid;
 
-	/*
-	 * gbl_chg==1 means the allocation requires a new page that was not
-	 * reserved before.  Making sure there's at least one free page.
-	 */
-	if (gbl_chg && !available_huge_pages(h))
-		goto err;
-
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
@@ -1351,9 +1344,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 
 	mpol_cond_put(mpol);
 	return folio;
-
-err:
-	return NULL;
 }
 
 #if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
@@ -2923,12 +2913,18 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		goto out_uncharge_cgroup_reservation;
 
 	spin_lock_irq(&hugetlb_lock);
+
 	/*
-	 * glb_chg is passed to indicate whether or not a page must be taken
-	 * from the global free pool (global change).  gbl_chg == 0 indicates
-	 * a reservation exists for the allocation.
+	 * Try to dequeue from the pool if either:
+	 * 1) A reservation exists (gbl_chg == 0).
+	 * 2) No reservation exists, but there are unreserved (available)
+	 *    pages in the pool; this prefers using pre-allocated pool
+	 *    pages over allocating fresh ones from the buddy allocator.
 	 */
-	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
+	folio = NULL;
+	if (!gbl_chg || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);

-- 
2.55.0.508.g3f0d502094-goog



