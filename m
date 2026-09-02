Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43A2C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 23:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465116B00AB; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6AA6B00B3; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213BB6B00B0; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC3876B00AD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:30:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62182140372
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:30:55 +0000 (UTC)
X-FDA: 85170419670.05.0A870C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6BA2940007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:30:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rno6fSfE;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788391853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7s7yLxy8LjruJq36YguyLSVmZTlMWqUyDgRg+6ldaw=;
	b=jY0DAn/FC6siQb8LZC2PbVFznjicVLyrksuAWrwZcYAbFOyyrvQ4yyMyrpIcTW0n16TX1c
	x3l0uRItcg8WehjN7T6oR03LGLNwnI3FdMbZ5VSqTwBG0ewjUNwD4eqiI8kQiUgxQFae5C
	rLuHDuYKp/KDeItZuUXdAD12c3JQaY0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788391853;
	b=BurOsahRJ0LYAgFqpyn+cHNxJS88KgwiSbmPcnTSOngmZFSKC2tOy/Mu9U+bciNIdgecvs
	2iE0+1W0SgpeN6ZCB6i4sXMQA2Uc4cgW7AwlPovY+e+ps8KZa3lOtMYNgSVUHa59ygXMtt
	A8IrOxkDjlSH+fM4NPbp8BKS1CZJkKA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rno6fSfE;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 22C314450D;
	Wed,  2 Sep 2026 23:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFB47C2BCFB;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788391851;
	bh=oLR6Ku5sA1PLxnjgFaINq5dHEjo3Hkd8Pu3Eio5YYSM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Rno6fSfEq5GMtAWQldGkAOdgGvP86M8o814pKhaHuGbEcFJRyvCVuzd0aYDfp7UbM
	 lBEbwJMOTh9VzoEwh0NQkyj5suoHeU20T4FTUqFupbQ6+xvWcZyruvmPDat4J6h3ex
	 pgAvsyFT1qPaVjrvgQOA0eknXut5lfmbB1RDyUupXTryILYKy5JVJk4rPgE1DqvobQ
	 mvZWjKmfVuHhhSlsw8M+P7xBgB+LODN/geScKQ/aRZUVSIe4Uwvu12v0QuIoY8swkZ
	 rOl8ZowG2qPXdvL5y0aVjG92wBDWaQbfBKO9XifFu0yXScgfD+HV1hsfOI5d51o5X6
	 fA0XecuD3W/9g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADA4C624D4;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 02 Sep 2026 16:30:49 -0700
Subject: [PATCH 3/3] mm: hugetlb: Fix subpool usage leak on allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-hugetlb-subpool-always-track-used-v1-3-de1cd14bd713@google.com>
References: <20260902-hugetlb-subpool-always-track-used-v1-0-de1cd14bd713@google.com>
In-Reply-To: <20260902-hugetlb-subpool-always-track-used-v1-0-de1cd14bd713@google.com>
To: Alex Shi <alexs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Peter Xu <peterx@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
 Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
 rientjes@google.com, vannapurve@google.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788391851; l=3568;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tOiKIJk4lCf4MxbAJGBewXo+Umkms5osEmNl/iOM9Fg=;
 b=k/ppmJwUIxnr7mkxBDZiMKZAiR+XSgPaNyo312BYQpvGcs049LcEqLMitF0MLO+p5YCizSbZh
 W0d7UofDCOSAEq9m0a7EZnsZBaNFaQkP35qjQzRIgkV5WdzV7I9j3Ol
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 34scj8y4s3asdj99wx9xyw48numjip3g
X-Rspamd-Queue-Id: 6BA2940007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788391853-949357
X-HE-Meta: U2FsdGVkX1/2ph/jpp+5D60RqYDdprmKWuww20EAFqOVBLW96mJEWDmYSkgqOMj/i4cR0eZeDAk4OW7H2m6MWZgIi8GyiqxRkPZU9xi8OSkDAoljFoOc5m4aK03Qp6kSik3u0dQyQYBmT+NuOeqrWFn7iPCOYj95pzVSqSeHUVxe9d/bXyV7zVMRdvCUuIDy6jdTLyVSNQerj65F3vLg/OOP87lm8suMrB1+jkNPeMOijZbKIFkKgENVPnzQK93Njj8niGFINOEkfvPHI4cXLQvOcy+hOs739F6Ifw7HWFuDsoptYysE4Qsy+1FIVH6AB8vLjqKTOOxhjNcYoCWwGC5iSHdN8TG2H+LcnVzJW02oqMve/1i0sbFPQfALzt41scSYf6+6twpSjfSzUEx/0Oig1Luc+IR/PTU5DGgqmlPq+i3HltuiT6D4czNAuN1nziC2U3R0Mwn5R89fIA4EFoFxWarNBFe/p/UE6dSsL3AtaiCC9QelYazeqFAoFZ0z7Ij0+B0cxcIK2lzNj1MPGtUTeqt9CSEtFbx7bMhJNkfmOYQ2V+wWrGw1xlurYgrnp6RuDkig96yxr9ky3CoNWl8DKY+wGxjFp/qNE5Y9ErcW4gEq9wL7AZngPsnaCeVvZGMZLxbTXe7VI/ps+kuzRtlV5512OXT+aGArAWQiqEyAZzsT4kXaKxZiqDKELfmDvGKWUNkoJDocg+TjQV78z9WXq9Tsz6sHzptdeqIbpQl4ym4T05iZbjszp+GvhLyzXb2lrMApqYoG1JBf6p7+vh3TQru5P1p3rtBxaGFxMaAD0EeHlVu+hKBtgrf2TziVcg9C92/DZ3jh32M92o7+COjSPUIW3NViChNxew3++LMfFV9LYe3I0qauK6ta7EtZeOdy4XSKXJCAn/0wovm5Q5b+LdGjKYoSTL6b2T6QKUjkRK1p6t+ew6bCkuhRj8RHKmf/paZllbmwtBM6UMN
 cpUQYhao
 fnqpRxorAw61fptYtqDOy6Ay8D5rsEudNXTB166aWtIxePLf5/KZKkCQwJlEodtb4N1srO82N7apgb/Bi5DGMOZahtH4a/w/svpXdK8l0UyzwPqRDTce7amIrIVDzwupLCd491j0RH8Tsx210/ity0g1E0tVHUOZ9K94UGTcK/Kr8dAuLAkJ9isH3pMcwBvtdACjjNNS0LoDQOh+54/MO4OfmaaoRAzv4M9ATn5gW/ZYv6WVq0dy7YaUmjs5nTPDLS3X1sNSqevrHTS7MzL2M96bsqwc848EWGs/LHRkoy+HNandE65IGx2mHceJcvVO1lcDRCkiCTWXhGsSnQg+3aIeelpkR7+AZoSf9dTQVOTuMc6WCZ9LbZsHmPtUKKueraSJc/TjKmliaAMe67zoakRAX66EDZ3SZC16my8FJTMpwQ9nyhpq7lNEpg0cVYgAwKmX1a2f03D98DWRsWiNBdNz5XZi0HMMnI9hd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When folio allocation fails early (e.g. buddy allocation failure or
cgroup charging failure) and a reservation was not used (meaning an
unreserved global page was needed), the subpool page acquired during the
allocation attempt must still be returned.

Currently, the subpool cleanup error path only returns the page to the
subpool if a reservation was used. If no reservation was used, it skips
releasing the page back to the subpool, permanently leaking the subpool's
used pages counter.

With subpools now always tracking used pages, always release the page
back to the subpool whenever a subpool page was acquired.

Opportunistically rename the local variables tracking global reservations
needed and global reservations returned. This clarifies the accounting:
a value of zero for needed global reservations indicates an existing
reservation satisfies the allocation, while a non-zero value indicates
new global pages are required.

Adjust global reservations using the difference between reservations
needed and reservations returned to properly handle races where concurrent
threads interact with the same subpool.

Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d84ef044d1346..e24f856c949c3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2955,7 +2955,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg, gbl_reserve;
+	long retval, gbl_resv_get;
 	map_chg_state map_chg;
 	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
@@ -2994,8 +2994,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * Or if it can get one from the pool reservation directly.
 	 */
 	if (map_chg) {
-		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0) {
+		gbl_resv_get = hugepage_subpool_get_pages(spool, 1);
+		if (gbl_resv_get < 0) {
 			ret = -ENOSPC;
 			goto out_end_reservation;
 		}
@@ -3004,7 +3004,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		 * If we have the vma reservation ready, no need for extra
 		 * global reservation.
 		 */
-		gbl_chg = 0;
+		gbl_resv_get = 0;
 	}
 
 	/*
@@ -3015,10 +3015,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		alloc_flags |= HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
 
 	/*
-	 * gbl_chg == 0 indicates a reservation exists for this
+	 * gbl_resv_get == 0 indicates a reservation exists for this
 	 * allocation, so try to use it.
 	 */
-	if (gbl_chg == 0)
+	if (gbl_resv_get == 0)
 		alloc_flags |= HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
 
 	/* Takes reference on mpol. */
@@ -3072,13 +3072,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	return folio;
 
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
+
+		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
 	}
 
 out_end_reservation:

-- 
2.55.0.970.g62bdec98f9-goog



