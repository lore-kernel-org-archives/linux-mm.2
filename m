Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979E9C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218C86B00DC; Mon,  3 Aug 2026 09:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153046B00DA; Mon,  3 Aug 2026 09:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FA56B00D7; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFF706B00D7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46514804C3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:38:08 +0000 (UTC)
X-FDA: 85060061856.26.B098BED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 38374140003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:38:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NlDuf1Od;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764286;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqCJ1UMFtKL9dxaJ6nM8IZaiWWdsh4famQYbW7qG2d4=;
	b=iyQ3stoImXg0r8xVD+Ei4iWE/hurLG5c8nv+wO5D7C/0vcr/zarcxnDKO/bsEfmG7LWrSV
	eUjdaoLYYnDZmFMxxUGdfpWMDwnqya0mnb/n9rsLaBP1QW5nB6Bo+c7IptFkdY39jYDlKB
	EVxGvSKhL2DUyT0VtOIkF5JQJAbJr48=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764286;
	b=sWcN9X0u9mbPt+Rtq9yuN3+6Q+FXwFB8utfiIvkisuhdGQqXOHx7J+SzOpUWUPNow1F7Wv
	LgMenxox0ynV+vvJsIgGFWaC//0p1iHFavFAtbPrO/j4nK3Y/cuCLJr4mnPaLI1f/ckXoM
	ti+JL//fo+spLGXlc/ptQa7E8TrSgdA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NlDuf1Od;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 423ED438E1;
	Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D91EC2BCF7;
	Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785764285;
	bh=qAOL5IDICIJegnaGClpi5ht+KVdNjbuTSDgoo+LyWwE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NlDuf1OdSjHnkctrwJMJGolNde74KbAIULiheOzKk1wNv06s4TiCxLzCTL/C4c4/w
	 FbJ/BOm618t6Y4g/uu+sjw1iz79mmuYYDUPxQOxpM2bsKZMcirFae4Tiye+Bd3/P2x
	 DzjNqxNTktm5OTPRLIWRRLYK6Qu2+dfCziaNxg2lPujrctne5pRhwMQ8sASVVeU3YK
	 OJxau6c58o6wIgjSqQm2hpHNeIofVH6Bb72Eg3fDFzm3aQrmKXEyxLXv2X2PVq4rP1
	 yBwSzxh901jWpbawai0t1ONFhW0WdLZNDkSq2siI+oyLv4pO+RaL9mPFdggCXk/98q
	 ZCp5OCKv/jMGg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF68EC55182;
	Mon,  3 Aug 2026 13:38:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 03 Aug 2026 06:37:59 -0700
Subject: [PATCH v5 2/3] mm: hugetlb: Move mpol interpretation out of
 alloc_buddy_hugetlb_folio_with_mpol()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-hugetlb-mpol-interpretation-v5-2-af2b7089f8a9@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785764284; l=4762;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wYqvllJ825+3G1PTvuHSW07dYvdU6Lqe0qHUWN7iPXg=;
 b=hhdnZtqqlVB1rX6spiHuGLYVsQxCacg57E65NcWdbiU0wvPTL175Kov8PdD4TlSirrYO3htAn
 4qQJuOqkg4XBEUhakN6nChqbcwfRaPZo0EJDSqR5FQQpBB20TepPmHo
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38374140003
X-Stat-Signature: 3kyeyfhkdc7mbyemuurke5jbpz7qu9rq
X-HE-Tag: 1785764286-751232
X-HE-Meta: U2FsdGVkX19H6EwPQy6qG8JqbZRu7viUh+rBlI3vhKtF+vNHbW1ignZ6/ANJ/vBXnByRC6IMyTMvULam3rJV39e+MdFRvF2UvZAeCmcqQzD2R0eYUxN/sL+61j08CALyPDR2JInGB+n+6cOXK9hIx3OBKDaRmUYe3VkiCY2VQdHsfnJdnpnP+DSPUPBtGm4rVjIBxICkCA2miMLrys45jg92pf4T6yAg4FDCAIHmBup0yVzHKeYEHJXm2rT08Ur2Xl2H0rF4x5xC2uThPrk+CUfWjOJpjHiXiXmUsVSoiUPC4zBWn3AR7lqZp9nvM9wrijD0kwISMU8ADEw/jauoRT0RSfxR9PCMawM91i/SZNWkpRzetfyZWkGFvZUugQkWT8r++yIbXw3GqbkLZbRp47WwYs99L9PTBRpyoUNQ2tznA121hkisDJjNfU5ZUpjpyi7WGMwUv3PQ48BFGdcd83CExVAtT5/GW6syA5cIfRpGYH+c1drmoyhJfDXUCpmnbeEYVGxzeU9hLYBVNyNyTpYhhxBNnlIE6DWSSqGd3JqRxenlryEB26iDdbbhMWJgDqqrCmFV/TfzrbIaVq2HnzgWeL7aR0DD/tdEFU/UbU5YnoOVD83u3uAQmLXnRswJTxKB3WDajiLZReUsGZjdj7lLbI8x/CzStBo26415/lXv7NIkIu2r7lv596mxLyx30rbfeeNv6J6BJMvwkKW2N4Tu9OeFa9vPyzPgWb8MHQvo4HtJ5TdxrOTuJBniH05BkbyGBQwBzHwFnj5KIKrNafieSIs0kSc3n8wZ0nS+bvzsQD9YyVGi3G4Rxn2MH0e3HsemA6rQxXta6uY6IH+nHyt3rIVhrsPUjdyqGOnKI3aJnXB7KBTKcXQm5bLwo32CPfKNKk/k9X03sCsSW8G1eYirxJPTuKSW052alFLo3YU1rZ7eyVpcsVTFmnmcvkneLF8dr8s6paxhVXfCfRt
 vWtyjy3O
 uI0J4QqSTyXXTmiSHuk06Zf1EXgk2YRRULDIFlC0t+GOqNrcdauAkOiYeOhx8Eq2lZlESybIkGxlwrPv6EkAcO85LP90hK0WxLBH9PoNBG0e0CdzYLIA7Y31JHZdl8SZjOM9JepRW5/baKx2tJkyI4xbg1sMTW5gznksNtwSprz+B5MkBVYMImtAFiWE4ymUwWL2XkcbYfrAe4zZyO69cuYa299KfGTPRyhagXhluhjP5jukZI3BGboXqk2Qvnu3Y4i2yBXsOC96B0rpEJZ8wEJ8YxY4vfBtxO3JBI+HMtmn8DV/vYlstugHTuC55Pw59rPQR4MXz3+h0A66qQ1rJe0HRFLB1EofTomVU6ph6f+XmszMEWi6VyoNOa6sz82tRT+A9LOl1KZ7eO2ZqevyDp6X4RGgjOrxSI0iO19UdV/yxl8437BZyNnqHp3sJ2Kfb7RzABMy/5R2S5uQlArllCk1jGHXlS1vDBUHGw/vtbU9pgBZcQ7d39JxOUgfxU1R8cCl4DEx3jwam9ucQJurI2kj527E/Ep/+NEsV
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
index 7985cfd21a03c..3a159de08a0b6 100644
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
 
@@ -2926,8 +2928,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
@@ -2983,7 +3001,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here. If it turns out that
 	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and

-- 
2.55.0.508.g3f0d502094-goog



