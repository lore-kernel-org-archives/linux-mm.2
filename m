Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39AFFCD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB11B6B0093; Wed,  6 May 2026 11:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89F76B0095; Wed,  6 May 2026 11:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D507C6B0099; Wed,  6 May 2026 11:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF8596B0093
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:54:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D8348B59F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:53 +0000 (UTC)
X-FDA: 84737443266.01.976377B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C7A9140005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZ5tb2rB;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082891;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Q/IhHIcKIusj7XMf1pelqqwMeW2oHa4kJu1zjh7YcI=;
	b=z3Uj/gVc4DKrGNy8l/wGg5N/r8BxxGJygtkVIPdkB6xRlGuDKZhUTD8S04iB8iMJjHx05T
	4xhVRm7AegTVtiGXO4w8mGqj89haRZHPrqfLCQhzyJT5Dsiw2ItcTwfFNv2u4o7q2hXw6j
	XSeiFOF1J9T3QCNRZyzspVqvBS9mWDI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZ5tb2rB;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082891; a=rsa-sha256;
	cv=none;
	b=EpbjruQSesD2BdfoV9W9k5VsUyYXvGsSAm3D6HPKS7FOX5PN7STfD5fAOAwM4WFadmZlQT
	YB2wvdM4CwYd9+D5xJyrPmkW9zgiZWK0WZLIQuKy1+nkddH7aCr/Olr/RLPu/xL1yPNKst
	9jaT3+Z4svv8rkMpH2GfZWGCxRaGxEE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D36AE44302;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3ED3C2BCF4;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778082887;
	bh=+7G4RM081CTfKDu8eUBQS6YQNemzuMtvLb/fbGmv+eY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EZ5tb2rB4uixhV43NTPrXveOV9p7u1rAJCDGdMp8WBd6b99CYZkP+/c8nGn1rwHqG
	 pmhTSckT+IHNBnLddE9G8ena2PrPX4ZUnKdCfNW8l1GB7mmAZE7/8jCNXntule71l8
	 F/IcaW/teRkSvxo3o6iQ2NKmAMZElu+/D+XUkM21i9Rip/UEoVoJQ55O4+u/H0k7Jr
	 oYHoUiWoe/Z2KV7+QapyARywE7IAco8FBjduNInabw5FGLSXQIaxKtJTGZprxP5rGY
	 1s7MiRshd3TBRczF+tIDbFNqhUXK3U4uPLobNISyyeI7mwNiYl6uZWXDMymocpuWyq
	 jEvhQnJjPtZEQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92DCCD3442;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 06 May 2026 08:54:42 -0700
Subject: [PATCH v2 6/6] mm: hugetlb: Refactor out hugetlb_alloc_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-hugetlb-open-up-v2-6-826a0c5f28fc@google.com>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
In-Reply-To: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778082886; l=9112;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zPlFgYkmuWlbZ0fv93XRQ9dNZUEoV1wVV83bZAcmM2o=;
 b=HPPWp6DtX5ckKKL2Y2JyaJF+iyeM5p2mthrOWGId5tZ2kGaFEKAjjUeJk0x1ijjrxS2mgxyZD
 757hPSkEcAiA6KNYC/D+jwmDVhIhVulPQxc2ibS0qLSwfEUrGctzgr5
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C7A9140005
X-Stat-Signature: zuohr67xs15fcsw3pdcby5b58hgk33ac
X-HE-Tag: 1778082891-353463
X-HE-Meta: U2FsdGVkX18dnOilV2iQK1zb7TqNcunYhS4nDU5p4BK9b+Bpmy6qVv6J7kdFoSCWyALZzf10Zo83UV8FuV8oS8NqzibLQjXIRcxoiFe7dzRcxbBV9eqvvG7SITR8tNOdnU5Yj4/kcUyRDUJR0ccLmEVe68QsCweenw/W2NKoLP2YIo3NQfMfgXibqNxLcIsxVK9rhuVqhJND9nnYnQLvuouN/Et6wLa/RhAqo8u/WDJr0y+PezdQhIgGVWtok7pHY9S0XWqJKVZ2sSruC108To13ftYAvsFJRtSgjvYSxwTZuDZQygh/lZOs2KIgmBIYZtXOTS+vidfxtrOfNXdyLb5teSk3YIcLnEBTCWf9e5jJ28ZvK3+Oz7ufNwx9epdWDlVqEx5EPGFg+2uCZnkgs5PlfjJCICNH7YspwZzumvzJefD7mfi6SB88nNgKdaTa36YbM/PirPuPspe0JkBXMy8SUfNEpLlmu+tsdI3m0aRG6OkhybW1VjCBi6aKJMQCib71cLfwQlZxkK+i37RNh3XELIHVrFYZe/6RH0UICJKlWElwLY3HP3ZFQvtE4RCntOTyXE/RK+fbtawXNVvc5lUAwepV1YRZ9r6jqP79rhHBohPzuzTA7b1NRsWqqESBRwxYs54lILBjKzi6IhUmLdk/8XY5Ch7G1SR+4sW6MuPmzRQVTbdc8T6vPoFq2QHJ4hvwvyKOp04Ma8ihEumj4VOUiwsnXIh5s4LHfpewxEwTvd1yyxcdKHQRaUNGz83jPkmvAI00MdjRAt9K/b27wpIXiZg+3milVm624Bfg7FHquIii3mA6DLTQou48/jGPc5RVy6EHupc7zkJaG9JHaGIX89am0m00bcNtsvcjY3tJAEoC0lejZdRs3KUR3rXWbBtZJcXZgAX+VJvyUi1pbP5e2ot9x1l0CdwYLRDaAj2Q4D9ZD72/gFmBrhDOQ63BwY7CnX9V3oiPicDlkZk
 me7Kp1He
 EKjlWHHxmVg0cSDJioqQPqNSUqSnsZ3aETnR8UEb0972UjKlokuGfrK64wzqH8PQEr8oerDOhwv1SoSti/LC9YjhxDUegGIQJyxvU8LqjZi1h/H3IHe06v9YFCe6EGjebTlf8IbepZ2qC3ry47OfC1Dsp1o57Ke/yifTFzHri+nBHCJ449ke+vwQ9DgjC4OZ505IK8WnmPmH/d8ftsDv1nIjOm+y3Q6EW5Bk2lkJCudUYepR7S2nWzpDK2/AI9IM9KMd2BAycSwbOhxfSuZO/y/lZZocsrHVNtB1xEbeRIeN6QcjGpen2k6emc7t7OFTdzKX4VPVOf2iOXlhAf3XCsIaG5xKzDRR6R1q8zg73y6/8GVmDJG4zqY8YDN2J8iJNtYyO84kA6iNLaf7USxEpZJabsNZqz9xbI0MUxq20IxyYeK9cjMpmaB2+xVYhd7edIYXBBXgwnp7K0NDljK0EjbJm/qKHZ24iPh2fl65ZyHXcFu7EhqnkRrEBCrX8BnC0jJOngmkvGyhHvFqGXMvgk2+NgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
handles allocation of a folio and memory and HugeTLB charging to cgroups.

This refactoring decouples the HugeTLB page allocation from VMAs,
specifically:

1. Reservations (as in resv_map) are stored in the vma
2. mpol is stored at vma->vm_policy
3. A vma must be used for allocation even if the pages are not meant to be
   used by host process.

Without this coupling, VMAs are no longer a requirement for
allocation. This opens up the allocation routine for usage without VMAs,
which will allow guest_memfd to use HugeTLB as a more generic allocator of
huge pages, since guest_memfd memory may not have any associated VMAs by
design. In addition, direct allocations from HugeTLB could possibly be
refactored to avoid the use of a pseudo-VMA.

Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
subpool is stored at the fs mount. This is also a requirement for
guest_memfd, where the plan is to have a subpool created per-fd and stored
on the inode.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/hugetlb.h |   3 +
 mm/hugetlb.c            | 179 ++++++++++++++++++++++++++----------------------
 2 files changed, 100 insertions(+), 82 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5f..ec205d8580885 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -705,6 +705,9 @@ bool hugetlb_bootmem_page_zones_valid(int nid, struct huge_bootmem_page *m);
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
+struct folio *hugetlb_alloc_folio(struct hstate *h, struct hugepage_subpool *spool,
+		struct mempolicy *mpol, int nid, nodemask_t *nodemask,
+		bool charge_hugetlb_cgroup_rsvd, bool use_global_reservation);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4159b3565a9be..a1c5b94e52e0a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2821,6 +2821,88 @@ void wait_for_freed_hugetlb_folios(void)
 	flush_work(&free_hpage_work);
 }
 
+struct folio *hugetlb_alloc_folio(struct hstate *h, struct hugepage_subpool *spool,
+		struct mempolicy *mpol, int nid, nodemask_t *nodemask,
+		bool charge_hugetlb_cgroup_rsvd, bool use_global_reservation)
+{
+	size_t nr_pages = pages_per_huge_page(h);
+	struct hugetlb_cgroup *h_cg = NULL;
+	gfp_t gfp = htlb_alloc_mask(h);
+	int idx = hstate_index(h);
+	struct folio *folio;
+	int ret;
+
+	if (charge_hugetlb_cgroup_rsvd &&
+	    hugetlb_cgroup_charge_cgroup_rsvd(idx, nr_pages, &h_cg))
+		return ERR_PTR(-ENOSPC);
+
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg)) {
+		ret = -ENOSPC;
+		goto err_uncharge_hugetlb_cgroup_rsvd;
+	}
+
+	spin_lock_irq(&hugetlb_lock);
+
+	folio = NULL;
+	if (use_global_reservation || available_huge_pages(h))
+		folio = dequeue_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
+
+	if (!folio) {
+		spin_unlock_irq(&hugetlb_lock);
+		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
+		if (!folio) {
+			ret = -ENOSPC;
+			goto err_uncharge_hugetlb_cgroup;
+		}
+		spin_lock_irq(&hugetlb_lock);
+		list_add(&folio->lru, &h->hugepage_activelist);
+		folio_ref_unfreeze(folio, 1);
+		/* Fall through */
+	}
+
+	if (use_global_reservation) {
+		folio_set_hugetlb_restore_reserve(folio);
+		h->resv_huge_pages--;
+	}
+
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
+
+	if (charge_hugetlb_cgroup_rsvd) {
+		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
+						  h_cg, folio);
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	/*
+	 * Unconditionally increment NR_HUGETLB here because if
+	 * mem_cgroup_charge_hugetlb failed, freeing the page will
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+
+	if (ret == -ENOMEM) {
+		free_huge_folio(folio);
+		/*
+		 * Skip uncharging hugetlb_cgroup since the charges
+		 * were committed to the folio and freeing the folio
+		 * would have cleared those up.
+		 */
+		return ERR_PTR(ret);
+	}
+
+	return folio;
+
+ err_uncharge_hugetlb_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+ err_uncharge_hugetlb_cgroup_rsvd:
+	if (charge_hugetlb_cgroup_rsvd)
+		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, nr_pages, h_cg);
+
+	return ERR_PTR(ret);
+}
+
 typedef enum {
 	/*
 	 * For either 0/1: we checked the per-vma resv map, and one resv
@@ -2856,11 +2938,12 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	long retval, gbl_chg, gbl_reserve;
 	map_chg_state map_chg;
 	int ret, idx;
-	struct hugetlb_cgroup *h_cg = NULL;
 	gfp_t gfp = htlb_alloc_mask(h);
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	int nid;
+	bool charge_hugetlb_cgroup_rsvd;
+	bool global_reservation_exists;
 
 	idx = hstate_index(h);
 
@@ -2907,89 +2990,28 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	}
 
 	/*
-	 * If this allocation is not consuming a per-vma reservation,
-	 * charge the hugetlb cgroup now.
+	 * If allocation doesn't reuse a reservation in the resv_map,
+	 * charge for the reservation.
 	 */
-	if (map_chg) {
-		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
-		if (ret) {
-			ret = -ENOSPC;
-			goto out_subpool_put;
-		}
-	}
+	charge_hugetlb_cgroup_rsvd = map_chg != MAP_CHG_REUSE;
 
-	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret) {
-		ret = -ENOSPC;
-		goto out_uncharge_cgroup_reservation;
-	}
-
-	spin_lock_irq(&hugetlb_lock);
+	/*
+	 * gbl_chg == 0 indicates a reservation exists for this
+	 * allocation, so try to use it.
+	 */
+	global_reservation_exists = gbl_chg == 0;
 
 	/* Takes reference on mpol. */
 	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
 
-	/*
-	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
-	 * try dequeuing a page. If there are available_huge_pages(), try using
-	 * them!
-	 */
-	folio = NULL;
-	if (!gbl_chg || available_huge_pages(h))
-		folio = dequeue_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
-
-	if (!folio) {
-		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
-		if (!folio) {
-			mpol_cond_put(mpol);
-			ret = -ENOSPC;
-			goto out_uncharge_cgroup;
-		}
-		spin_lock_irq(&hugetlb_lock);
-		list_add(&folio->lru, &h->hugepage_activelist);
-		folio_ref_unfreeze(folio, 1);
-		/* Fall through */
-	}
+	folio = hugetlb_alloc_folio(h, spool, mpol, nid, nodemask,
+				    charge_hugetlb_cgroup_rsvd,
+				    global_reservation_exists);
 
 	mpol_cond_put(mpol);
 
-	/*
-	 * Either dequeued or buddy-allocated folio needs to add special
-	 * mark to the folio when it consumes a global reservation.
-	 */
-	if (!gbl_chg) {
-		folio_set_hugetlb_restore_reserve(folio);
-		h->resv_huge_pages--;
-	}
-
-	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
-	/* If allocation is not consuming a reservation, also store the
-	 * hugetlb_cgroup pointer on the page.
-	 */
-	if (map_chg) {
-		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
-	}
-
-	spin_unlock_irq(&hugetlb_lock);
-
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here. If it turns out that
-	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
-		/*
-		 * Skip uncharging hugetlb_cgroup since the charges
-		 * were committed to the folio and freeing the folio
-		 * would have cleared those up.
-		 */
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
 		goto out_subpool_put;
 	}
 
@@ -3022,12 +3044,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	return folio;
 
-out_uncharge_cgroup:
-	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
-out_uncharge_cgroup_reservation:
-	if (map_chg)
-		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
@@ -3038,7 +3054,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
-
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);

-- 
2.54.0.545.g6539524ca2-goog



