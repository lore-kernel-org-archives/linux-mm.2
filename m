Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B72E8ECD6FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF0C6B0093; Wed, 11 Feb 2026 19:37:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F6B6B0095; Wed, 11 Feb 2026 19:37:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6FC6B0096; Wed, 11 Feb 2026 19:37:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60CC46B0093
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD913C2303
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:36 +0000 (UTC)
X-FDA: 84433941312.03.534C6A9
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49E2B180013
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NsymmOXr;
	spf=pass (imf06.hostedemail.com: domain of 3ziCNaQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ziCNaQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770856655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pe2F5DK4zZDtXkI/xhYQlRYGmZxVF2QOYK8cN8BDaKU=;
	b=XO6mQGR4Oj5J6GwqQeJ1fI2p1Edin6CRTMQLuHlH0f6btB6ioQXrk40TSdVr+peqe/tbjW
	AslGj6zv3/5PYitaw2zT3a/0GcxBpzJn/YQZOLjE/QBVvFVr98Wj1R4HAaJGfSqUP5A7Nw
	vqI1lx/jpdC73j0mQl4UIVsNYgJpdio=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NsymmOXr;
	spf=pass (imf06.hostedemail.com: domain of 3ziCNaQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ziCNaQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770856655; a=rsa-sha256;
	cv=none;
	b=5zPHs0mG6d73CeCMs+cMewn8BHU5Cdmi4xnRYfzcz6rZpsBPhR5ZcwY9htg79duAkLA9Rl
	S8moT5I6XMFqYUYC2Wl3VUKCYvD2qNJkEBu6Y8Vaxzuq1rSnNGrgVLks0Oauxvl2RLxFGR
	v0HoZjn3tNY/ud09LpQUdLg6inggfRU=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aaf2f3bef6so42700995ad.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770856654; x=1771461454; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pe2F5DK4zZDtXkI/xhYQlRYGmZxVF2QOYK8cN8BDaKU=;
        b=NsymmOXrMIMxqfkSo+QKwt0NY3smF9acCsRs2wdTjX2iM8QQK7WxkKBe5guPHs3eU/
         HFju/qaF05It3kKj2qY4zxuvkeyctn/7pp6eKkMeWDLf71mIlAZTxFhG4PGr7/UNhVNy
         t3RFbLPkAhlV+eleopG7cruUAwLhV/j8R2dyA7Au/Sfb1Ud9zUeoUXpY1P+Bp2KoH+Wb
         hV7ShElOK7MgaP7Ucg1MkxVnpdMcU9K8Wdn56RsB2Oq/0BCZO0XKNld/4IpcwPYfTZCM
         klW//du5w/+24rLmIh+Hf+7u81xKyD6NtkzVbrjJqCIjK22twtRd3VXs5A8H0a5Tvvga
         EXNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856654; x=1771461454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pe2F5DK4zZDtXkI/xhYQlRYGmZxVF2QOYK8cN8BDaKU=;
        b=E2Utt4AjbiWNHSWdMRy5kjJm1fJzJr86GgaAEh9YCIJAK91qlJjPkv5jn0HalbZxgO
         Va0s7AyDx0BO2NEiq/J1/bKHr3NsjbWZq8BQKLGuUfa5hNqwBOyXkEVivQKIn6MqGqVq
         +yGzWcWT0z55bstgHgIVy1KTD92qZLVSn7IRodTVjwxQEzUQCEisCrxRD+x2XWXcgynL
         XOELKfCgEE8Pec4x2a+L70xS/pGLOy8/h18jXmjQoA8hincakjstcb0DcA/HQ82UVPLa
         GbGfdJooMl4X5TnW0Xycqv9lmRSh8XeTgS9yhsIzMQLCmRCW8xOAKb3kfEYDWcSVFL1E
         87cQ==
X-Forwarded-Encrypted: i=1; AJvYcCWny/d2NB8g75uri7LG5jZjxNvclwYocO1VENp4+YyRzjLiNa7jU3AHFRwPyqZXVZsvdNAP0DVj6g==@kvack.org
X-Gm-Message-State: AOJu0YwtzaAL2helm/fF1eA4ag+1w0O9o3MZM9zXWBPWF6qGajACinGc
	Xu2VSgKPskfcIFuJROLOdJ0h/4ZfgnzFtLC2WvDlI+cFSKIqDqPRKpLtU9delncI4Ofc2zTe62p
	cOOxUdLYmpUdHun1p3Adut05F1Q==
X-Received: from pllo10.prod.google.com ([2002:a17:902:778a:b0:2a7:80ac:dd82])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:17cd:b0:2a0:8e35:969d with SMTP id d9443c01a7336-2ab39b16ed4mr9131845ad.39.1770856654111;
 Wed, 11 Feb 2026 16:37:34 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:16 -0800
In-Reply-To: <cover.1770854662.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <28d1cd5b7b9a628d6ca6550b8fcafe887190a9e6.1770854662.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 5/7] mm: hugetlb: Adopt memcg try-commit-cancel protocol
From: Ackerley Tng <ackerleytng@google.com>
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com
Cc: ackerleytng@google.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: x8nkjd8rr5kbp1e8a1ix411944941arc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49E2B180013
X-HE-Tag: 1770856655-822731
X-HE-Meta: U2FsdGVkX1+5/qktqXYtzC7m3Gc2+U3Y5dC6f4ZM0HFXnh6HMP6IR3ZwL7gMQpNa7mzya4r6ejGqgBNsuVjAK/ECcWEy+K6qx+/7T0u9MCDgx8dpfM3C9qSA3M7R6RReQLhr4UkrZc+tXnDtoneme07wG+/f9Jo+KcryIPLNp2KEp6QDZHzAk5w9Jt/Qyu3utR4zrnIAFG9vIkjrgbeOKY7HjwMDe++d8xUd/dv3cfUuOQMu7g0X0HfnRNvnQCAuppKTGS7sCCwlpOhTbljnyjiYVn7LcLJP0/K8KHABdPjQq3aPBN9jYRC2zRA7w89iVpzP0lsPimG0BB5DoGbNXAEd5dxT8HBDBIJGNpwrnhTf3aWlO7Z80D/CFJoHYofaZoUZkXzuC7vx8rwYqPY0NxN6V0CMxFwFpGw5rzvqdEQmwpnqUnAfnGpZ+BuXjwqUJwlU7Q/1/CwZ76Q52U3N4yCHTutzezOKoO+ZU1e21Y5xoO8japsiuVYIdKFRSRHyNdHcKuqrYNyL0ehW37MVWfzw3BnPWrtaEKovZfL5rTWUz/n9Raj75VkswAKnk1Mxin1WOwmvfa2IK7uG5zQu/wvggqe+0PtZydlo+kivPDcs8dA6MLLf7Vk9xMJNdDO4vH5fMmplBSawsGbWLlrVvJYpXA1TJYiCHXe5XBXOmnYPMMRCMlNzLigfXBLgsFos6c9u7gbSF4/lUuC6nOpwRltPB4ej/0XAyTPUvp3aUvdi/KIUjLIKmiNQntJYT1Q2oOZ4xM+cz6HUJL6doGcDnFPDF4xD7EqEgIH8Bf1FpSCUMuUhyo6zhB4b0A1TmTQ8r8PgkvPPnYB7MYClAkeE1C3N0v8sqF4UA8HEDhmx8bG0lrd6G+zxXr974R/5T9qaQo5RL4S3Ka64hZNAcQ0BrgzUDkjBXDjRoT95/v1aayDrSTvlc5g/LeS0Chfr36AyyNazwigI5WEyjwdeKje
 IdPBOScz
 MihDHgwca1r5juAM4ODjd4RrINxr9yd5BHOuU9y3GuKzhOlONp4MSMZSBFLoICcSuHIl+QrQr5FxhsIR2gSmoZSQplJ1QeCJdiXD0ozo+f8A1z626WpM0WDEkZ940qFt6nQiveowvwYSQYx5t3E3BZ/rhyXH+pq5s8lTF4AUbz7Oq84d47xQW64KE3KxYiJZKUdJNdWnCrAfo86JZzMG5JkJ+MN1WhLRGTERHuqvPjjNfyS0+ZkBJMZjjk0DMKJjaR5bkWF+jn1zWX5i+0qpSV4isR3VjG/WfGgcud7L88wjY+M8z2zxrBUoh/2Mp7UknVUZHf/C+a0e7FmQqVUOjv2eN/ZHFE+fAEfGh23VtgcCp7Hvn3aq+gfbTJgNrWR3ORZNN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor alloc_hugetlb_folio() to use the memcg try-commit-cancel protocol.

Do this to allow the core of allocating a hugetlb folio and associated
memcg charging to be refactored out in a later patch.

In addition, checking cgroup memory limits before allocating avoids
unnecessary allocation if the limits had already been hit.

Update error code propagation in the failure paths so that existing error
cases still return -ENOSPC, but if the memory limit is reached, return
-ENOMEM as before.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 53 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 74b5136fdeb54..70e91edc47dc1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2881,6 +2881,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
 	gfp_t gfp = htlb_alloc_mask(h);
+	bool memory_charged = false;
+	struct mem_cgroup *memcg;
 	struct mempolicy *mpol;
 	nodemask_t *nodemask;
 	int nid;
@@ -2917,8 +2919,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	if (map_chg) {
 		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0)
+		if (gbl_chg < 0) {
+			ret = -ENOSPC;
 			goto out_end_reservation;
+		}
 	} else {
 		/*
 		 * If we have the vma reservation ready, no need for extra
@@ -2934,13 +2938,25 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
 			idx, pages_per_huge_page(h), &h_cg);
-		if (ret)
+		if (ret) {
+			ret = -ENOSPC;
 			goto out_subpool_put;
+		}
 	}
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret)
+	if (ret) {
+		ret = -ENOSPC;
 		goto out_uncharge_cgroup_reservation;
+	}
+
+	memcg = get_mem_cgroup_from_current();
+	ret = mem_cgroup_hugetlb_try_charge(memcg, gfp | __GFP_RETRY_MAYFAIL,
+					    pages_per_huge_page(h));
+	if (ret == -ENOMEM)
+		goto out_put_memcg;
+
+	memory_charged = !ret;
 
 	spin_lock_irq(&hugetlb_lock);
 
@@ -2961,7 +2977,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
 		if (!folio) {
 			mpol_cond_put(mpol);
-			goto out_uncharge_cgroup;
+			ret = -ENOSPC;
+			goto out_uncharge_memory;
 		}
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&folio->lru, &h->hugepage_activelist);
@@ -2991,6 +3008,12 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+
+	if (memory_charged)
+		mem_cgroup_commit_charge(folio, memcg);
+	mem_cgroup_put(memcg);
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -3021,22 +3044,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
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
-		return ERR_PTR(-ENOMEM);
-	}
-
 	return folio;
 
-out_uncharge_cgroup:
+out_uncharge_memory:
+	if (memory_charged)
+		mem_cgroup_cancel_charge(memcg, pages_per_huge_page(h));
+out_put_memcg:
+	mem_cgroup_put(memcg);
+
 	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
 out_uncharge_cgroup_reservation:
 	if (map_chg)
@@ -3056,7 +3071,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-	return ERR_PTR(-ENOSPC);
+	return ERR_PTR(ret);
 }
 
 static __init void *alloc_bootmem(struct hstate *h, int nid, bool node_exact)
-- 
2.53.0.310.g728cabbaf7-goog


