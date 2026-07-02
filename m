Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2580C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13456B00E5; Thu,  2 Jul 2026 20:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2F76B00EA; Thu,  2 Jul 2026 20:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A786B00E5; Thu,  2 Jul 2026 20:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53E5A6B00E5
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:37:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1643E1672AD
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:55 +0000 (UTC)
X-FDA: 84944352990.07.29F2173
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 269ED100003
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhbPbyxQ;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009313;
	b=0anTHfdmZufRJfOsjaBnbundiwL4g3slMlOPxonEwgfRqP3qu0Zo13vTbkrKqiUT5xoGwm
	pawxNDKXylSCs+6KsDt+52eWf91nFjxEjpHv23pH0RIapjB3nG6JZtBsch9RUJXlMSWXaU
	JAX1E9TGj9UC+UpOwnyvYDmnNySEn+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009313;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8zXsOHj+8QLMuq41NuHYRZCy8C/8orxXBapqwy6Gos=;
	b=vEfY8e036HTZzjtjN5Cb30JD8haPwPYp4wZCc58WtsNJxulWCY8k8nStuGGkddqNnLFbRH
	pnUlcWNSMh8k0dNV5FjsAA9K4so+DtWaWMJ7osow/AUcQtd0gBomOUL/7mOjtsxO9QfxSb
	+hS9Ne2yUeClaEEwZ2axA5QeJYnLit4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhbPbyxQ;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CFA6601FA;
	Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C97D2C2BCF6;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783009311;
	bh=L6CajZVBgzjS8wjxh2LVoHr1hPxj1p1z49lWx+D36K0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lhbPbyxQZuZOi+E3tUzhLLAeuv0kphRtAD10nQMcRn7WozfCu3plR+p/ZWsSc15O8
	 Rgkf3uH/WA33XCbWDDzzSSrS49LwAeeXQzOVnrcie1hopfj6TvBCRtvI24NtcYm5lE
	 b5JhyESEcwX4MHSkicUzQQsUAOB8tBRDRO8MHZM/eU4Vxz4jhhhsiQkfatpfk1qQ9G
	 zJ5EHSl048Dc/HdKvdrzYvBEapiRHmIGwcVj5bxP7Eh3qyUZpHhDOnVyvUln7u+TYv
	 bPEMvhsgguU8N1WNGtXjhoxB6+pIeltUTyK/I49/fQTetjKtRuXfGlkx6u7Ar1RxfS
	 9CWW24rjI0kWw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8ADC43602;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 02 Jul 2026 09:21:47 -0700
Subject: [PATCH v4 3/6] mm: hugetlb: Move mpol interpretation out of
 dequeue_hugetlb_folio_vma()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260702-hugetlb-open-up-v4-3-d53cefcccf34@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783009310; l=4245;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RYxWDoursNMXPBaEsqbHPgjLpUH2ys8iFhzueYn0G14=;
 b=rYD2Hbywotp4zMbjXDA/oclXMUW71K3rQjI4+GOqZkRuLl0QU8QJ+9LUumuTUgfjVVeTPpfMz
 QDR8Wh2SZl1Dfkr6NQKDJ3aytxkM4tOU29DQW5mwsJ9mfqa7X6mAJIr
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 269ED100003
X-Stat-Signature: shgd5rk4fbjixog3o734r4e4iwxizzy4
X-HE-Tag: 1783009312-905023
X-HE-Meta: U2FsdGVkX18c04zirF24wktQCEHb92w7/YFrljFUtINoPHy+DEESEfQMLzIyewgb2lllPzCoPzz2R+f2q9lYSO2K+LHSqrjamC5YrX0zONYYMjKmUChyXWVwmfpJhDKCEhnXDn2KEQGMDuPy4nkTK7kU/GsOyK/fZrlp5k01psDtdl4w1Lfo5cBZcDHqPUMmhlQL+NiUmY4JQvGU2/4DQynnOuihi5PEaXM43gxpUU0TWVkIQrKWn10/gPlkRskdkYoS3HEOq5B5dWqw997PUlD2Wh3iyxcjF9nUS1LdWE1C2CT1Jn3pJpxJcK2cRif366u+dbDOGBCutsn2S0Ql6by32PV4BNgHsU+pK8Q0WavdBcUY2H0unR92JLGP1DEUhO+lT/i46HJUtI6BkTClc+gHzHGt+zHSZs2jFxnEy2nGSRB0ogPBjbFz1zAGlX5Y593GmneUIh9C2chd4oDMxeXuT7aRCE6z2kkv1z6oYghwIgx6AWVTBj/J8rel6xTqrcxuR69ABV0hmttgIPNNkNuVkL+cdPUaFcD5mUIvF5dAHPouTKpApEZFmes5InqdlFpMdt+fDDFBUEhtsgKNPbdqc7KMTEzdmX3HOLH+Ew0otU91fWlqF7OTntkioirgIqVTtNyccBsBfOCrmLBIooGhVKLuc5ZOviMfaZMF9phDRCVe6QPnx+zUJ/IU8ZoZecTN/AB/c5FoGzr5FbdtlgkrvCM9yA5q105cNIYDewnQhlocygfOoxcH4/aH8fbvK4kYYjD15x6gAFbW8lUU8G+LzUZwLAhvM4lTVePHyyX044nIW+0m9iW+xoecu6SEmK44AKTVXN3qdsbwhmSTIBI/MtegY8nnLNul7T6IQRHCNvmmj6BlSHJs0QmcuEmpSsqXtQ+ditIYN8Tm/Dawg7ooaDCFzGqIBeIuGE+t6bkdFkFRSM3KO2uQBpnEx4nszC/hdVrxRg1hIfxojCc
 o9TTV7el
 MlaQm/ae8wFTy5SdvxN8zgCqhIS2p3zI9HgUXVw8GgtpdQdtEf/xixoGbY7I+xQUZUzOF1Sch7MNi4k9rOI0vhX532PougtqjVMwHb+zTzPjNCTaiLrV3r+3AvSur0w708xEEqbGZK4zGVJw+MkCM/aA5NU8c+k0edpKQ+QLXPKj8y7iCfkR6fowV3yKCNq0+uivNUFcbaRGTUz8K1U/asbWReUeqGaxSgznqRGm/uURWPyDPtu1FG8pr10jBoLVov5oHP9hxZsoUGIj7BoBJJGhiUrQJyKGH8f/4NLsGA0hwcLMry8mohmXIZLCeOKHf0dT09PBhkRJSj+6p8Ve53Nk9ZfJzDCFJ4tRIWTyur7Tt1vkUWzNCt2pFconbC//sTKdPR0ZGOW/kCvdVwspsLfpgwmGnUO45t3fhlL7CUFfrOVKUTNCjJlo68Eeh4H+dBaSaMzYf9nhg30bM9EqTpeiJkwuvcUXeJmPw4Tb61cU9rHPbYjnTsPowgwyy4asVG4mAU4q4vUqiF4tp0S050zKHKhFAc1Wc5prE
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
index cdcfff521b6db..f595ab15f9fcb 100644
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
@@ -2924,35 +2934,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
2.55.0.rc0.799.gd6f94ed593-goog



