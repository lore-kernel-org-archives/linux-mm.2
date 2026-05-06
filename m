Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA375CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B354A6B0088; Wed,  6 May 2026 11:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44E76B0095; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737136B0092; Wed,  6 May 2026 11:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 482CB6B0092
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:54:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03BE9C0A38
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:50 +0000 (UTC)
X-FDA: 84737443182.30.C7658EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB9C02000C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:54:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLnbJ6By;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082889;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygIr+qlW3Wjq6yTU9XLt5VyzypWTg2lhVcyOdiIfrvg=;
	b=hMq7jy427CtAa27nDqZ2mnuNxaLW15evCs8X1tDHrWFGs8DUiKfLnNCt0VdNpgfTvW1Ai7
	bP5StyRfcNTTf43vGlu5GbS+hLcYTSheNgVF41TEdRcE3HrVY+J0YwR3ULLkcURpvRrkU1
	lWD2t54YZj5wcamGc01jnGZTrWeJsHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082889; a=rsa-sha256;
	cv=none;
	b=SaMr2xnwuVhFrNuek/nmcGizhGhMRkWuZamD5FBQRwGvVZx0Q2zXFfc1x89H96ATvKVQ0K
	B3Bn0LAehYGRH1bMuqpjUoxuhMafjrwTpNJHK/87b6J5L8vXsDQ+/j9swjWJxjY0Bjov61
	jKf/n/SawYbQ4DCmeGc4ypqCObg8gyo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLnbJ6By;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99FC944224;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 746E3C2BCB0;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778082887;
	bh=Xc4Mx3TAo5LaqhnOgXJq/fFetgGTOsrrZKWvr/AN4iA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NLnbJ6BypjwjDgypbp/bz7x0EmLAhF/iB1cjZRPf7zn7V3ZU1ySM9xh195P+B5TWD
	 n9MtvN0Z+pnO0sLXjJ8wj3AbF2U91Q/bzv8iNVf0admIuAQgEd+2ezCoiOWrrXvP2g
	 VuUKXkofrO2nup1/Hr+sNkhGfbbrZ38dTlTceN+1Aq1H3dT56V3uumpBd8fkz3FEnC
	 oZrri0d9zzORGdf/wFs5CPSjvHxN5qD9BgakXZEUVMH3jYKAubgJEeqjmc/d5E0oR4
	 LCtqML6v+3XM3ZFd88yb0EYREblaColKQmyX8KFHIAS2vNVRUwSKsNT/ED9T4ShG+p
	 +MjDCyEqHhsbg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D3ACD3445;
	Wed,  6 May 2026 15:54:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 06 May 2026 08:54:39 -0700
Subject: [PATCH v2 3/6] mm: hugetlb: Move mpol interpretation out of
 dequeue_hugetlb_folio_vma()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-hugetlb-open-up-v2-3-826a0c5f28fc@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778082886; l=3663;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zIDAPwSnRf8adh9I7F/T1NlbtOUHnAoWsG2BkZYAmpE=;
 b=e6zxTOz1Z5Z7o18qfH+LW7SX9rmjkxEwXMwf606rlXQdoT9U30y3BMbzYKZvyIorkfFoOtRCm
 J8flqEynR5oAbgxmGpozVQHraboIoYB2OmWYo5LFk4l23gaMyzZ0nSY
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB9C02000C
X-Stat-Signature: ijqmo5np8gtawopaprbb3jht9swykfzm
X-Rspam-User: 
X-HE-Tag: 1778082888-527198
X-HE-Meta: U2FsdGVkX1/RZfQH41eiIg9Cd8P0IPoAQhX0cJRo1jY2Zh4NbPQOR+qFt+6oK6T6Z7i8y7ZOD9kNaI6gAroZYaRZTyq9NDUXWeOZqfdoxGFUPnhcsCUSyqPwZYaLxeOsfyRyWujLRs/zvWLvqd+ezoPWFijVebjlPlXG/1wzisiNu/RA/cbhutVlq8Mbcefv6TZC1sJ0DcbTJPAMihLwc8N1Do8PA7h/tGbrC86VWrc0PM36qZixRtjL2FDjIruIrARrkP9+zkmmeEaI1F1Z5hIlxI8eu/BTaiff8pQiPNYC6xN8SuoS6H6iEw4jiIlJ1uAY8irLne4Q9mMlOuh6npjd3GEuQQRD/q79KbounaFy3YEGfixT4LJ5SyKCqrTTcdQ1dKvy9cnum0ctBZqJ8tSM7hhUCvGmXM9zBo5Z7bCz/O/TmC23DtNJAmn7TvRkfmpEf7O+rYEgO06h2dyeqXyZlMEXpYpyswXUKcIAC12NM70O0a/pR3RBt2iVDLZ3vsPfXy3pmVcaoJGcG/40BUSBms5LqQOVHWjDiESi2gprEnl5d5kLg6MJplLrZxoNsEmULUijXEnTD1vTXxsDgjbSoUZGsOnbii/yHk6NRsiCRpl3K+KCB73jukkSFa2OtpM8d+9eraQeiRNapgb/wJzOryFiDhcTzLAsTg23vx6H+eKrh/PsPfV/XdAcaDdBh5XWtwlhlEByD5KKG+oPV6Oo4cxO2eKywqgKYPAQqxJ1ohS2rSfz+5Ws637HS5rhwe7WKieZLT4DwSObkLb1DGlGZRiexh82KvZOLrnZdZb6y4ZW6dypaTTu9IUoJvTOZ+OXtuymyVTx+qUhPOeXsnvJm/QTHxhz+Z3BksS8QUelNNHnrMrmyN5K/1KUVmAoiNt1qLcpxkhfldZzvmxNMkFunkFhVOQa+UPxj7+iy6Ieh6gjE5b0C7iWHjV5KleLwWb44rPTs0gVmk9Nvs6
 XVPLao90
 ALTqAlFAq6v3hcyKmfVrYwrU/B1l77PN04k+wD/OMtxzf1rzv9g9cMwLjb/yilZlQbKBXGD9dTss5T6FszbCM4uYF0W9LROYvXpKc5IqaIAL2sqthfcpOPxOk/Y0GpmSnYQxdfhsZ47mu1f6ViVM/c7UEm3mPNtwev3PLOzxpBXtg7W9gBwR9lyQWKUncA3pf4tjF2TUpYYyqyeBcT066kj2Tcz9FY3T/qqnmhyKnXi+SxQUtIZ4C9PPRKzBMxhDJlbXfMoP0QBC22VD7YvCC1h+kOJ6KS/V+kQLJSUB5R4fi3n2bRZD5SfHgTajbe5OOlB4iMC/z1/KaZtzpPKdpZ7BJFT/D5HNN8dp81RO9nUSakaCQjODG4IaXdkiEiqG+STeRhzmbJ2oYFdPTDMr12EEXQLnz7D1FLQAIaRCI7kfBO+Uz/oBvlnWeNlWXMlydXzV5eQlrA/FcwOg0qx82F+dEVzBAirnCrtWnVNsQTBWcInr8WJhjXEuk01bd/wryU13SC+SSG19usgoAwtuRuOOxYA==
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
 mm/hugetlb.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ea3bc405b3162..3395de4d0999a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1334,18 +1334,11 @@ static unsigned long available_huge_pages(struct hstate *h)
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
-static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
-				struct vm_area_struct *vma,
-				unsigned long address)
+static struct folio *dequeue_hugetlb_folio_with_mpol(struct hstate *h,
+		struct mempolicy *mpol, int nid, nodemask_t *nodemask)
 {
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
-	gfp_t gfp_mask;
-	nodemask_t *nodemask;
-	int nid;
-
-	gfp_mask = htlb_alloc_mask(h);
-	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
+	gfp_t gfp_mask = htlb_alloc_mask(h);
 
 	if (mpol_is_preferred_many(mpol)) {
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
@@ -1359,7 +1352,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 							nid, nodemask);
 
-	mpol_cond_put(mpol);
 	return folio;
 }
 
@@ -2866,6 +2858,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
 	gfp_t gfp = htlb_alloc_mask(h);
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	int nid;
 
 	idx = hstate_index(h);
 
@@ -2926,6 +2921,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_lock_irq(&hugetlb_lock);
 
+	/* Takes reference on mpol. */
+	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+
 	/*
 	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
 	 * try dequeuing a page. If there are available_huge_pages(), try using
@@ -2933,25 +2931,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	folio = NULL;
 	if (!gbl_chg || available_huge_pages(h))
-		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+		folio = dequeue_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
 
 	if (!folio) {
-		struct mempolicy *mpol;
-		nodemask_t *nodemask;
-		int nid;
-
 		spin_unlock_irq(&hugetlb_lock);
-		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
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
2.54.0.545.g6539524ca2-goog



