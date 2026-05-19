Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C32FCD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907386B0096; Mon, 18 May 2026 20:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F536B009F; Mon, 18 May 2026 20:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE7D6B0098; Mon, 18 May 2026 20:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA756B0099
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:19:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D93DB1C0012
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:52 +0000 (UTC)
X-FDA: 84782261424.07.7096970
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C6D241C0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:19:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KINh+Kv9;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149990;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WH4zAGh/CBQJyEantlDm2En/+CHFekg+YBeWZUCF+QA=;
	b=bj6hCVjzPni68tmVm9Y0j/x6J+Ae2l2j0WTs8Gb6vt3jGCtcnFw93MIcaIddvu2X+uue8s
	g6K4lyKdwZAA5SmZhH1hSnEwOttVtwSsiXEDkxiX7Yf+tn1o4njpfx1FwUMYLk3F6KyV+v
	8zM1omNCacqVjovZ/1JqL7O8v2dqV94=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149990; a=rsa-sha256;
	cv=none;
	b=70DJksczQADWW9R9uuUHy1Gh4QL5HR6SRDCQljfFBAgGzbl+W4x2beO2kTb8Ixnh34W0Vw
	xL3EInu7vQbddGUs3C2YEr4COMH/ZJBF+Hg5rrzFlUDl85P4M/mAoGxcLDjWM71uHntJYw
	1RCRx0lLqg9zyL1q4je8BOsEUfdlbjQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KINh+Kv9;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 624DA4454E;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F7FFC2BCF5;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149989;
	bh=9WgM/k2IJyHrbk7WXf2mgxFfKhGk6TnbvjvPwy9E4wE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KINh+Kv93PCIrNV/ijhVMcn5JB1SFUUKhd8WeljcNOBTSC+g/LieipySZ0w163Z8j
	 wQj/tH1UW/DB0ziGqa5y+gq4V6bRTsPaxwNUbV9ziXAcNt3UDoY966E7OIKS6xz3xS
	 Uha5Hi7wkX6nwvmWBM0P7n0IUXAiI9DlQM6sRlhWHr3yDbbAKm1rywVhe3/B69l5bv
	 2Q4AXcWAizhGCIobJtAkznsa2zS0xP2t60v7icFBtO+GtYPicURclE+PF2BtjJVBw2
	 Ntd7B7UYgNAy+htvWLUqIvOTIvDA6Idq9ZlAKW70c7v3bYZTRwv0zmFcv36NxrcpvB
	 PPkcT+zcKEdrQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342B7CD4F57;
	Tue, 19 May 2026 00:19:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 17:19:42 -0700
Subject: [PATCH v3 3/6] mm: hugetlb: Move mpol interpretation out of
 dequeue_hugetlb_folio_vma()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-hugetlb-open-up-v3-3-e14b302477f8@google.com>
References: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
In-Reply-To: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779149988; l=4047;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=XBsBcsD+y0HocOj/hXA27UpdO3jJ7U9sMFebRSppli8=;
 b=WqYG2G00uuR/tiQzDklNV902phklHnP5SUs2U3AsZetnI5SBKRVwRY7HamLyLMuWvBKuQPHq8
 z5+aqi51hc6DJW7cfi+SaJMPylyc07wN+/bpiNTZ0k196Z8OTsYgou+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6D241C0007
X-Rspam-User: 
X-Stat-Signature: bwe3bp7mupeui3zdoiwyida6xxukasxj
X-HE-Tag: 1779149990-898877
X-HE-Meta: U2FsdGVkX19GFqF7oN+weeiksLgXJirJJzgHr2BfJAGkbaXl16XjKDoT1Pgsd6dBnxz+OaSmgOYyzIT++pMUOz05w1GAbXrH5Hv1Nv/QLC46GssmXLBWBUoaMche+pY7mjKze6JlfwfV0fZGfSlsdCYwecwGFWT162Q+qaY96jw/5avfRFlIBP62a+Fl/LP8hCPt632/i4NiIgIXH4YXE3kh/btyd7WZIAXWa+wH828MYxwaxGPrONR/RWUsHl2g1DeWihNHE9w9SFbk08LIxSV+lMPm38jaMfm9ZlF054bLlfb0ShIx1X9KcI5Mfe9HVXvo0tdbeD3JGyOGtd4AJp9AfZuQXMpPcTrmYpGkoOiGyUEksrzFn/TIw86cOB5cjPysW31ip1+YTrMGf48qLxo5h7aJ6vsflS6tQEFkR4FdGeWMg3xtvry+A2sB/Y9oZTTwp5s0I32UUJHv9FuzRgX6UMpseXibSxbaSwWbENj+Dw3YyWgFQ3kTgwukn30wApplC0J3OWGNMzm4dnomuEt7ZtAhGlwuAg5aXDqHGjHHDKWjXf4Uq5AQHt+1Eg/oWC0eRt1pz9EjtPrwUFpZzGyPOi9HpeIhEssAJUeXIwoutSgUS2CuNFL1TpAFgVncTG+hcNBxykAuPLIfNgwxZ5XomXBSiCqOE2oLm49OR2uHYgy1t2k5PWkjD8Mto3ogzhomV6+emOfIhIvs1iN8O6LOJ2970lJeC2yX0gbl0fPeTrfEXoFnQJ9Yspv52woxQONDFI6TnrD1z2tenaEiAI33xWcdc+oc8urmdzDRwVzywlWVUXKVqOWDvHTkNiOwVl8Nbj1+Dxg96jQ+5bQaUWqviL5v0maJFaUA+9AcIeEMLtXvwkIuFbtRLifZIujGnfNMxQgeEqS6K2vKpFcPIGFVjC7VNv08TPhTvGvSbz74hMAaYG1iFX9QcHu79l9C1gfOt7dxzD8E0wnMmId
 AVryI6WB
 81Ww3tjU2P7qWZJ2UdhMd7gc/90h88GddJePJ8hJ+iepbET7EBnBqSx3EqgfLk68K44446/IicBBZSUySOEFI2sGQpzI4jzfQY/vWqDr/Jt4GwCTbmmmCQVkRtBIMJB7sW4dY+Sjth7cydqNCGG+BTId2TYITIc+5pDE+MYPUoxvoByMgxIkB65OroPBPsxI6gWwSAJOEPcA8IrB52okXX83wmd1ui9y/QfkFCv/SAM9ijumN0w8jwTX260JWLaqrHGYMzz7+IszlTM9n0aqVFVlm/z4EgcM7wJpCC+CdGUxznmD4x18C4685+/GtVf6qWA+Rtsf6Zqi0LHMyfWQTkrREbATUgsM3KIqWFX967V+LKsny0oe6GriPIddi6Dmi4ETp9OAyg5P920vo+CrveZAmR7zAy4wN5ymQfu5JlGWFRz2b9I7F1PIlHNAJ89OxwDlssK54rCfRZB2btYvPyjcH9qKwwbpv5U4cvrZc/Bqq7BmE9EeXMlH+zHicux6IktpXYvFEZ3u3egEEIB46yyiM4Q==
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
 mm/hugetlb.c | 57 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6a5f69b3b1cb4..9807bbe0d70df 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1340,32 +1340,26 @@ struct mempolicy_interpreted {
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
 
-	gfp_mask = htlb_alloc_mask(h);
-	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
-
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
 
@@ -2871,7 +2865,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
+	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	int nid;
 
 	idx = hstate_index(h);
 
@@ -2930,6 +2928,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (ret)
 		goto out_uncharge_cgroup_reservation;
 
+	/* Takes reference on mpol. */
+	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+	mpoli = (struct mempolicy_interpreted){
+		.nid = nid,
+		.mode = mpol->mode,
+		.nodemask = nodemask,
+	};
+
 	spin_lock_irq(&hugetlb_lock);
 
 	/*
@@ -2940,31 +2946,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
-			.mode = mpol->mode,
-			.nodemask = nodemask,
-		};
 		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
 		mpol_cond_put(mpol);
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
2.54.0.563.g4f69b47b94-goog



