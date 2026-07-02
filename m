Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461D4C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685C96B00F4; Thu,  2 Jul 2026 20:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611226B00F7; Thu,  2 Jul 2026 20:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7916B00F8; Thu,  2 Jul 2026 20:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 095486B00F4
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2112A01A0
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:54 +0000 (UTC)
X-FDA: 84944352948.05.EC1C020
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DE72714000A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jjRyeolJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009312;
	b=GLDR4FhmC12A2YwiLPKZKeOxyylXwVJOh7Yt1KM6mlCtx6sSDNEFikGlBYrPVpFDgiqbiY
	DIQln7B9y0quU66jjKXLk7+0jJHIWQVekaLxGK85nvaHuaaVtLhowJZkaNwhVDmgLd4l2J
	jbSyTK5TiKIJYtu7oC/WmqX2CjIivAM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpMS5DLMBIaYAbJPS7VS1skQAcYAyKqmNuTxNtK/oC8=;
	b=pJD5MKORR1vhRLrJ9nMJ/kC0Vp9yboXg15ACXlUvQTK9yX9/e9NxUiKmqA0dCDg0upWB1r
	WqfJ+p6AW9Kc2zCmJj17S1toccw3iKlVIu2kfHhlKZjv79SFlPYgfK2lFDpDOu6jStBYoY
	KACndYiqcpJ+607HinoGt0gGeJmNOUY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jjRyeolJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52588601F7;
	Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBE7CC2BCC9;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783009311;
	bh=nT85txx2JmM1U62zsTs9SFw0h68Gg2nyrAtQwjgoyTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jjRyeolJvy0uDj5ygYHJuamTHGNNXQ0F0iNrL4l7hB3J929Sz4mRZAMZMSOreOCtr
	 Qd1802RP5BeIKpyAJKUkqnwHXY+mUV5KF2LCSO4A9ow4yq+X25HFCKasZIzvuiUAYO
	 c2wtlWF28FTH0mPgdVhwD3o5ASZMsVdJbvO+yvBW/Mb954tGfet1yW3CTpRI0nEoVh
	 FTIl1yMJsMBsq6G2u6R4RubNW6pRgdqAmhSAzRUoyObMizejIsC0/KK/3/u38IXmk6
	 Cj321U7M5tIDznfpwEOnIpCTRka4oDz7b5B+Ig9+rLA4j1j54pBprs62/YnPcH06Nx
	 x1cLmUO8ke+4w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D72AC44500;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 02 Jul 2026 09:21:46 -0700
Subject: [PATCH v4 2/6] mm: hugetlb: Move mpol interpretation out of
 alloc_buddy_hugetlb_folio_with_mpol()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-hugetlb-open-up-v4-2-d53cefcccf34@google.com>
References: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
In-Reply-To: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783009310; l=4766;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=2jWAF3HAwTBG0geXcDCSU9vc4ojuXyHXW0JiBSi/XNI=;
 b=ikqY98+QuylZk6PVjj0evvIs0PRsVQ5isGbwLy/WbQa9ooxTds1n3aeS/IGh/x8dhuICPCxDe
 ztrWZ7nkNfYARtYgAgx3fOVDwIJi9eqtv12jptkc2aXl4r7ixYiLdOo
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE72714000A
X-Stat-Signature: npxs83d5d4xiub5ebokif85tbti36de5
X-Rspam-User: 
X-HE-Tag: 1783009312-456700
X-HE-Meta: U2FsdGVkX1/KSLKpbQ/NqWNVVGQlkKEISf1yHudg9OMpGalxXctjAjMo+3LQlkhZAGoWzRoLss7hOfupZFJlLKtwrTcciGNdsOLzt0vGgV1SMA6IElsfcSDbRwTpwFSRuQ3dwiBR6ju412sr2CiN3Z78ZnF//PXdWHisE5Zv8/ZZRfeRCiG1KAR7iAt6rhO8qqLuKFOwRfPMnpwBcRv7cQxFWd2FI9Piz6XgIuJfwbNbJ2/VnUhkCw/+xdJsFN7MDWv0NAUukSRiQWW5VfPsl5F8Ho6zpJ9lLPfKQZJRwQKyAkadjisKf4HWNHBLbN42QKJzpb6Ml1z6zJbclcJHSISaLdVdhGsrlBmPFNyNr0UUhsadKbU08DcLr63bNJEJBZ2ukQ7uXFEuwFoSboDF9AEaGoSHUOnPJrS9e1AaNATjZS3Azv8z3Ox2yVvOzGZDHJY8DDtxum8YujFscb2zNLEvWOl/a9ApdnPobQp9qX8VHle1UvL8OUvWiEZOoX00j0HCEqFdanKC6y6K6b7MEqLxvcgvu9DTGrJ3LUa3howH/lBs0J2tR1sEW8EueEVICTEQ6gffJ5/Tp68/0w+jzmhHHXuRiD6baq27DrLJ4+SZlM9rR4s21x/8l68pYTSpibUh4YiSAI2FMSJ7vXBQ44E614bM6G41RgnDR2/3MpQtVYSPRYr/xjYMfZnhvBvn1iLHyOznjPxDo4YnnZ8JmpEqkLPMGtAaWfGQMLb7EogUJ3e5WOcu6L9G8d1v0fdBlPeMkhNHD/jb112EKMJUMKSG8jP6P/yuEwzv8nDChh+W8rxiNyh4Sdkd2yoLA5LgRwDmhr9p7eGukfqMUAbocpZKEIwlV79hIMSA1bRNYQK+ivAV4mKcrULAudAnQrf5m9+abXm/7enLSrqox3I5M6e8WkOj4fib7i5LGe5Q9yycyNezPWanHAB9ugjsvWkJe0/6YPdDILCi5B6z8AS
 cO2UxM67
 hHozmR0CCj+uZywt18MOVU32063oKEaPh0rZXF4aaTe58QKlwwtq6tNBexp5HPv603h717Wy08kZST0TiTNkVY05WwD9enlnPQb8BQXKziAnNdW23RFazK9nLZ9EKoemRVxktoMvNFChKU4sp2mByFjwbu+qCJybb/E/T5QECsHO4g8CMWvhF/pJevIE+98Bl10hhRGXbaf+t8br5jvaCvvrBG6YsUeYFqdIP9scSet0QeH5ffCvscmrXVzBM4tXtkB+mgftAj6sPpF1AS9+oPtpf4bZnxX8qRf7Kv5b/rT04BSguOjRQX8slHFrEPLuizb4mFyH/EgbosH4XNl0tIYSV1952jRHU6gFR/+P6gGhulcz8MJ0+Rq6PmJzupWJHj8/4grgzk97eOnP51eXqLHmhLry1Ay/wLuddYnskQUY1TOF5LUAU0G1VylHdQklvzaXq5nRa7m7zC23oeDCp3Zo+B1C3zYoRnMMr6q9DhbAvzoR5Mi5BQ4SXzbJKEdtQ+g9Bnn6bJ5zFqCEj3wHXZ1yrY+T7MSVZdXz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move memory policy interpretation out of
alloc_buddy_hugetlb_folio_with_mpol() and into alloc_hugetlb_folio() to
separate reading and interpretation of memory policy from actual
allocation.

This will later allow memory policy to be interpreted outside of the
process of allocating a hugetlb folio entirely. This opens doors for other
callers of the HugeTLB folio allocation function, such as guest_memfd,
where memory may not always be mapped and hence may not have an associated
vma.

Introduce struct mempolicy_interpreted to hold all the components of an
interpreted memory policy.

Rename alloc_buddy_hugetlb_folio_with_mpol() to alloc_buddy_hugetlb_folio()
since the function no longer interprets memory policy.

No functional change intended.

Reviewed-by: James Houghton <jthoughton@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/mempolicy.h |  2 +-
 mm/hugetlb.c                   | 54 ++++++++++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 6c962d866e864..7f6fc9599693b 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -16,7 +16,7 @@
  */
 
 /* Policies */
-enum {
+enum mempolicy_mode {
 	MPOL_DEFAULT,
 	MPOL_PREFERRED,
 	MPOL_BIND,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 83ab9390db565..cdcfff521b6db 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1317,6 +1317,12 @@ static unsigned long available_huge_pages(struct hstate *h)
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
+struct mempolicy_interpreted {
+	int nid;
+	nodemask_t *nodemask;
+	enum mempolicy_mode mode;
+};
+
 static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 				struct vm_area_struct *vma,
 				unsigned long address)
@@ -2138,32 +2144,28 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	return folio;
 }
 
-/*
- * Use the VMA's mpolicy to allocate a huge page from the buddy.
- */
 static
-struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr)
+struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
+		gfp_t gfp_mask, struct mempolicy_interpreted *mpoli)
 {
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-	int nid;
-	nodemask_t *nodemask;
+	nodemask_t *nodemask = mpoli->nodemask;
 
-	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
-	if (mpol_is_preferred_many(mpol)) {
+	if (mpoli->mode == MPOL_PREFERRED_MANY) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
-		folio = alloc_surplus_hugetlb_folio(h, gfp, nid, nodemask);
+		folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
+						    nodemask);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
-	if (!folio)
-		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
-	mpol_cond_put(mpol);
+	if (!folio) {
+		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
+						    nodemask);
+	}
+
 	return folio;
 }
 
@@ -2853,7 +2855,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
 	struct hugetlb_cgroup *h_cg_rsvd = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	gfp_t gfp = htlb_alloc_mask(h);
 
 	idx = hstate_index(h);
 
@@ -2925,8 +2927,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
 
 	if (!folio) {
+		struct mempolicy_interpreted mpoli;
+		struct mempolicy *mpol;
+		nodemask_t *nodemask;
+		int nid;
+
 		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+		mpoli = (struct mempolicy_interpreted){
+			.nid = nid,
+#ifdef CONFIG_NUMA
+			.mode = mpol ? mpol->mode : MPOL_DEFAULT,
+#else
+			.mode = MPOL_DEFAULT,
+#endif
+			.nodemask = nodemask,
+		};
+		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
+		mpol_cond_put(mpol);
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
@@ -2982,7 +3000,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here. If it turns out that
 	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and

-- 
2.55.0.rc0.799.gd6f94ed593-goog



