Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBBACD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46AD6B0098; Wed,  6 May 2026 11:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821F16B0093; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623E56B0095; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC976B0093
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:54:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E370D1A01F3
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:50 +0000 (UTC)
X-FDA: 84737443140.20.5217A8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9B77160012
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N0aUTaZk;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082889;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nrI3igY9gye5r90+zQBOGRKnrPB5fXd8r6Cugnmdf0=;
	b=nkrDJp3o2IdpJjNZVL1jAW+CnKn7/UoLr5rh62VLLVBsbsw6Tt28M/148aZFQenXrov8tO
	q+DL9CTQ5xyhRLktuSRn1Lri30gJLjzJUlGFEuRv0ubJSrlAPnEMK1QdUMuFO0F9mToapL
	8KrZ6pbo9yxYQpORVAQv1MuYeDqD8Ws=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N0aUTaZk;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082889; a=rsa-sha256;
	cv=none;
	b=YaCcS/KtS8ObSdGXborKc67Y6U1heA+Mqbvvdf9da31VEirbhxBKFt2sqN8z9O4eR3At8r
	dCblvtlpIl3Cq+ew/kTBFcuWFwEYbyWJ9FqHC3MZinCgmWFeHOPRFgEUx8cfYRunllRPy6
	YmrADPUwzD8NZO0hIxAuLlJ2kynhPXU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89980441AB;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 652F4C4AF0B;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778082887;
	bh=EFOzcDiW1BDWFgsTmk3gKLgei1KKWehsjtmzBwOCodE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N0aUTaZkA0ShwVqw98q8eo8OiQaJq2Cur8HhxDQ8LlVPfSYGaMIUNSxQk66h2rKfJ
	 S0wiJVIhUQEJk1GJJ+KvZlXbbBFxk51iVTzu3v120FMdaC8H7tj6bCCAtZjNw8rYD6
	 JYTD2LkhHj8TjebFmXeVsw5AQX8JoXPDJDgylije6DOJo80sjlyvGvFyLZVlIAn5KY
	 vaisEsDr9euP7N4+zt3WdaDiFmQAFMm3lDP7FWA55XzQSsM/aGISzpQuJH6DxLlPLr
	 nBAyUTndM3/pAWC2oq9y3xbW2a2UuUZhOkO+buS7N0BaXoE7ryATxFptA8gx4rqYn8
	 0lhyQZEjCJjmw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E32CD342C;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 06 May 2026 08:54:38 -0700
Subject: [PATCH v2 2/6] mm: hugetlb: Move mpol interpretation out of
 alloc_buddy_hugetlb_folio_with_mpol()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-hugetlb-open-up-v2-2-826a0c5f28fc@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778082886; l=2961;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ngW2MpP6uF73PbJ5TvqQViScClcx1raOJSqESPZNT2g=;
 b=60OulaMrVIeL0AUDLw/Oj4vJ4TXPrn+qA6Ksx0VcV+YxxEG7QSPdreEFwdfYdmXpaEq60mkKZ
 NM7+wE2n83lBiKpobQJz9oQFqYCtE8npaDcWzeD6ssL5cTOLYqSVXQ1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D9B77160012
X-Rspam-User: 
X-Stat-Signature: pcyyjj9ahih9iofdnpynfc5tm7q5nyq7
X-HE-Tag: 1778082888-215404
X-HE-Meta: U2FsdGVkX1/pd36bXFpMtbruhOOxTYq3931iEXyvz/GoZoHPJZi6Cbk7QD8iMjQ0q0bMb8l9oFQIdvMq3BahoocPBuC6lpTUHytPegBAaRKsPiimj2FDyC9KzVUfRtzbCly7u8EGLsart68ChGprUtMBqtRwP74g6yepaHDoEWKjypRBY6ymVq1i05O0BdlyJwWalGzF0uSkCuqaak4d7nFQ9CVFZ8kFuYvxhPH8I0kPvnJ/ohH6Mf79BwgTrZIJ2EB0k2JPP3KgYso7eC6B6o/ejOcd9TYtnD3nnQxhpcfI5A0/IiIRkhW1JKJvzakdnKhLJGPYmt0XQcO/YWUzpEQWHnOSmI3zgoBrejduipKgUJGCVE8JHe/3ESBBH3if6A86FDLnXiFL7PLDVRSNiultboEtkum+lrk4D8yZb7brzOVmuux4DEZ9O/SQxW6/X9qRPz4Qt2H8nQQ+LjMtTrkiTJqrRt0MIrKziyJ0Sco6/OvhsSFoxpGz+3UR0S/A2mQXQVdzyDwOwWz38pPDRW/+EUmSZ2YGx8SLHSsazWFU1uzD5bBH+WZGG1FlBEzWN2CvLigldSrnnQynIw1Iv5iXZU2/DIIyGeA86DDZ2GQGsWOJcxybji8I5G5e+H4+UCaw7BwWWfaEiG5N4YII3CP24C0n0pGr3AAsEQs91ntYgvuHJiKOInI4Nw4ljqRDaiGq/hlQZWjcZ8mD9WcrA6wUsxmMkh3gT4r5ehR77ZwQrgq6Owsqjtjh3vLL8LzPom14CQBDiGEax+4BuIcKdVvZtZlKoZZQyEqgAlV5YW10iAGN+Q/Glwa5xEyBqM24knSVrcYSPxuqwAgYkySPEH8duo59YkiYpye57Iugz8SZWg8GZM+5n6Upsb6hTKyG7dbE6RcJ8vfI2wUNRv+q04BDTs2xrjq6my2TLPXx49kWThjEAu4pBqIZjA1UN/qjh1ltTLmz2c82BHtRFO7
 ME93m9+W
 hZw1hNK1lRThzo80aD8NRv5gJBWa8zmie6zioG69dpbn23oBeObBNJvl+g1oSgekTLiaUf2hRD5y6Ccr/YL681y0iY7lfwn+yqkoSRStKFGqeYCMSexWeSSyFPt+E12ZbYulHq5DWlhOdazH671UeQWGOI2TuC6ExKRFt0ES7KvTYT3jyQdQix+uR3FwuyJDnR9vkW99KHHX7iRh9M4S62w9Hnzt10piGi8ctEsmepgUkPQ6GEv5hIe1gIeiRvCU4knpPJ+qAHrSPMSfk92sLKZEguzXLJvlPm4FHUmcd9r+zODl1JqEdX1F5OmoTdeU98K/R3IoFzDcMcWHCaOfcG6cf1lYWBS/mIwPItFeXcRD5Wa1UvvHULG8rbSWkKMGcMbczDbnVFlVAXaST31w3LBcjPLLxxjN5yzg2mELIoqggHA79W4nbdoxM9GhyzbUnQnrVAou6BDW9l3VPw/l1RawwXPi7u2t1uaaFqLG0MrbGpeyGYbRINOViXzOsVRkb68dXVr9BRBZYW8Uw6O6K8ZtrZZfGfyhlnkmw
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

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8be246b4e6134..ea3bc405b3162 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2160,15 +2160,11 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
  */
 static
 struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr)
+		struct mempolicy *mpol, int nid, nodemask_t *nodemask)
 {
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
 	gfp_t gfp_mask = htlb_alloc_mask(h);
-	int nid;
-	nodemask_t *nodemask;
 
-	nid = huge_node(vma, addr, gfp_mask, &mpol, &nodemask);
 	if (mpol_is_preferred_many(mpol)) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
@@ -2180,7 +2176,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 
 	if (!folio)
 		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
-	mpol_cond_put(mpol);
+
 	return folio;
 }
 
@@ -2869,7 +2865,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	gfp_t gfp = htlb_alloc_mask(h);
 
 	idx = hstate_index(h);
 
@@ -2940,8 +2936,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
 
 	if (!folio) {
+		struct mempolicy *mpol;
+		nodemask_t *nodemask;
+		int nid;
+
 		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
+		mpol_cond_put(mpol);
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
@@ -2997,7 +2999,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here. If it turns out that
 	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and

-- 
2.54.0.545.g6539524ca2-goog



