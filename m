Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8433C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461D66B00D7; Mon,  3 Aug 2026 09:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECCD6B00DA; Mon,  3 Aug 2026 09:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216B56B00D9; Mon,  3 Aug 2026 09:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF4B86B00DB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 708401605CA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:38:08 +0000 (UTC)
X-FDA: 85060061856.10.51812DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 745E520007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:38:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAr+9fs8;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764286;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0J3U5C+0r7XiBOUW7yG5gex9CJ0pPmgF2qipeeLUOdA=;
	b=GZOBry0r3PodqPuzwVlX5vYx0w5P1IKz/tttgskBsGnznT2YQHZzwgti9VYa0On/8SkzA0
	oW4L6TgrfUQgFO3X58cpUp9BabyYnDyyR5B9zDBz6rT9V3lDAmKfc8tHvaFPBSBus0+jjd
	ENgcHIv9k/V69CzrVVIp1KEpQxb3oag=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OAr+9fs8;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764286;
	b=qq0jbWUuAsJUuHtaWCRjE4RYz5tztB4Ob6rpt5ELVd++Em+U4ba90ytrn6unckBr4Sa1TU
	mEpo/BN03/DDzb4KR1tddKbMj0/n7Zv0fVh9aaaZa70gDDaXdm7AQivlJXHy/ohXToHQNT
	uBU5hqfwa9v5mHGLs77iAvi3TIqOyjs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C6F243B97;
	Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C152C2BCF6;
	Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785764285;
	bh=1sczfEuOl5XyE2+dFqSPsBh7HifK/3TttmuhFQr34MA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OAr+9fs88Eie5X83EVkqf8msca0QFAUS4awl9Z+/gyCptTS+0PPtzO/Xe5udWhr6R
	 N+YCHIMuu041rNUZE2LJ29wC/xgjNk6QnysCXJfnAOrFQkz5eC+kjAjgVebsLRhV06
	 hS4RRuC4DX7Nqcer2D0IuPIcle1imYrWEfyplyO4lHqkE5acNdKCaUgt+TPOuSCdkb
	 ZvGtfS+01R8N/uzsIlDF/spCFPrZvIOz5ax66Ti0b5j897D2AxgI2XsGqCwiZtDYkl
	 90MXLyR6wU5cya6A5gPBgAtlcstm0BqNgxHQRa6UMk2VlpttUj1XNfOiY+eI+49cNX
	 p4bRmcXlWCpoQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112C4C55838;
	Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 03 Aug 2026 06:38:00 -0700
Subject: [PATCH v5 3/3] mm: hugetlb: Move mpol interpretation out of
 dequeue_hugetlb_folio_vma()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-hugetlb-mpol-interpretation-v5-3-af2b7089f8a9@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785764284; l=4241;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mxYJ9ZfIJDNqqNET+i798zl+eMXnvPpSjYi2l1OPxHE=;
 b=QivN7sN8I31WwiKn12XzM7zIcnCzCJFKMeumY1BlC2xQSYMVmWvVkTmcw5squW1hr8iXtI4B0
 wOnsLFdhs81A9khAN94v1qQa86hSPfKdAOJ4qgacYrp7gCr0+NrP8kz
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 745E520007
X-Rspamd-Server: rspam01
X-Stat-Signature: ztx5ztxduqpbbf96qy6suh7eyumog9gb
X-HE-Tag: 1785764286-636716
X-HE-Meta: U2FsdGVkX191XyJqahyWOvBbgNZ1/WhVIrQe0gUVdPw6dtveJ/5mKCnkanESJQYr55FxxXcX4UycC2gvdRqWqUTAGoie7DeZ+qglz3EWS6bG//4XoIhEP0ACVVcX1QyQTs0pq5HIarDfPbgjGEWvZ3Pt3Te3z0UdeQx8NiBvh3YJTc3Dh4DlF6PdTcSqgDY5/gFFbxlATZPmjd9HRwa3x9WNE8Psa886byb9AwzCP8+I/Tf7oaKMZZu/JEWcoIwhUDNba0gr06LJ5/L6SSmxQv6wsnUoz8r7BaFBXv3I6PEfSlYIfyPlMugsu5gtVEgmNWHRYshNq5vDxHi/f1F4koFYPLjDhK1NAEKHuA/WyHP0g0A1uZo2eH1rcx86TSz276BnEAid+Af0Edpb0u8hxPoY1IEhw91Hfxs3NbCBLHeASOAgHwUzA5YLgS3XP9lzNplqjjeuDiLGxxs0FvYubCNUcrv0zXtEnfBuEN9RltUgLA8dnn7cq8UfTXzuM3BOt35fi0e5ocwvn36ECDI+aHM9+UmbW7HJnUppwlWimgQGQFdjoXoDdTvh53hOMZxkylaSyiWjv1w5kClWzXTumFJ+vq0fSYRCpY2E//DaMPYlFpTQGYUoxL9Ul6IsTw7mJVqenqxi4UM8Ar+WmIcuCO4YGOLc2k9Mt0/8kmq91tbnpA4R4inwtN8oIAMLW+pL/b76eotWqJLuc0K3ygzPeg9n9ykVcPGRi4d8m1KlIfhQ4ym6MAGet7z2dm7zbjK+9WOX2OyUK/36BWLdhsSeU3chwSySmZKCWiwW1Ak+a/e3QCnvZGgJl1woyXQDH5GZiip6eoB0q97xNgCdp5itsVo7qE3lyKpozUu/1brOIFIM4kz85URTBDyP5T9YY6SfH102BlvQpByPrS0YIAo2yS8EqoYRNUKQE3hxKU7MRuhECZAZ4HhU87JgCG3NrHgwfXNEyaqOO6eakwHWzdv
 watcNcZx
 HujSmaIm8xhill+/fz1M1MyFIQ1dOxQbYBmLrR/kNCA+pXuBSKypDQ3A3OLhf0X42uoxOFgo9Sj99ZGpgVGeEqo6hH58skFF5YBxK3o9IEWT/nyjcb7c1aDVa16l1JgcciDCCK23GTbOUxa5niMtB/W7E6Ni+Ge1F6fETnUNLBdCNQsXwK9rITNmcdGkTmibDIZqiZM0IY598WZnTrKLrKhFk9A9AEkPcyOFXQVTF5H9YTGdFlEiXSsebiLnUdMDK8ZtTkr45uQUU61GmER9jpWEYr9HMDtqnlDVqPd8OXZpd/j1O7z0Nf2QSikrrMf9ve1N4ovtCDdmns8184lX1OfAp8ranwnoVGSLmLyKdUlDUyIEcAh3QF61xanAbDx9ptRdyHkMwcsfnztjxBvbVJ+7kyz7HVxcG+/VUzzkHTsEMMRs6F+F18S2hHuu8BYg8qXTop+HPJLlP34uZZZSdgaVO4R6o8aeo1L7YyanFLgehhqrgHYdL3th1hw5lkI+84G1GwNBNB7hNru/63j0MQCZ7t9qju4aUk11R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Move memory policy interpretation out of dequeue_hugetlb_folio_vma() and
into alloc_hugetlb_folio() to separate reading and interpretation of memory
policy from actual allocation.

Also rename dequeue_hugetlb_folio_vma() to
dequeue_hugetlb_folio_with_mpol() to remove association with vma and to
align with alloc_buddy_hugetlb_folio_with_mpol().

This will later allow memory policy to be interpreted outside of the
process of allocating a hugetlb folio entirely. This opens doors for other
callers of the HugeTLB folio allocation function, such as guest_memfd,
where memory may not always be mapped and hence may not have an associated
vma.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb.c | 66 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3a159de08a0b6..a11cb919e00fe 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1323,32 +1323,26 @@ struct mempolicy_interpreted {
 	enum mempolicy_mode mode;
 };
 
-static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
-				struct vm_area_struct *vma,
-				unsigned long address)
+static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
+					   struct mempolicy_interpreted *mpoli)
 {
+	nodemask_t *nodemask = mpoli->nodemask;
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
-	gfp_t gfp_mask;
-	nodemask_t *nodemask;
-	int nid;
-
-	gfp_mask = htlb_alloc_mask(h);
-	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
-	if (mpol_is_preferred_many(mpol)) {
+	if (mpoli->mode == MPOL_PREFERRED_MANY) {
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
-							nid, nodemask);
+						       mpoli->nid,
+						       nodemask);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
-	if (!folio)
+	if (!folio) {
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
-							nid, nodemask);
-
-	mpol_cond_put(mpol);
+						       mpoli->nid,
+						       nodemask);
+	}
 	return folio;
 }
 
@@ -2855,7 +2849,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
 	struct hugetlb_cgroup *h_cg_rsvd = NULL;
+	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	int nid;
 
 	idx = hstate_index(h);
 
@@ -2914,6 +2912,18 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (ret)
 		goto out_uncharge_cgroup_reservation;
 
+	/* Takes reference on mpol. */
+	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+	mpoli = (struct mempolicy_interpreted){
+		.nid = nid,
+#ifdef CONFIG_NUMA
+		.mode = mpol ? mpol->mode : MPOL_DEFAULT,
+#else
+		.mode = MPOL_DEFAULT,
+#endif
+		.nodemask = nodemask,
+	};
+
 	spin_lock_irq(&hugetlb_lock);
 
 	/*
@@ -2925,35 +2935,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	folio = NULL;
 	if (!gbl_chg || available_huge_pages(h))
-		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+		folio = dequeue_hugetlb_folio(h, gfp, &mpoli);
 
 	if (!folio) {
-		struct mempolicy_interpreted mpoli;
-		struct mempolicy *mpol;
-		nodemask_t *nodemask;
-		int nid;
-
 		spin_unlock_irq(&hugetlb_lock);
-		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
-		mpoli = (struct mempolicy_interpreted){
-			.nid = nid,
-#ifdef CONFIG_NUMA
-			.mode = mpol ? mpol->mode : MPOL_DEFAULT,
-#else
-			.mode = MPOL_DEFAULT,
-#endif
-			.nodemask = nodemask,
-		};
 		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
-		mpol_cond_put(mpol);
-		if (!folio)
+		if (!folio) {
+			mpol_cond_put(mpol);
 			goto out_uncharge_cgroup;
+		}
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		/* Fall through */
 	}
 
+	mpol_cond_put(mpol);
+
 	/*
 	 * Either dequeued or buddy-allocated folio needs to add special
 	 * mark to the folio when it consumes a global reservation.

-- 
2.55.0.508.g3f0d502094-goog



