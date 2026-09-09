Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB03C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940C56B0092; Wed,  9 Sep 2026 17:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CABA6B0098; Wed,  9 Sep 2026 17:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DF46B0099; Wed,  9 Sep 2026 17:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA9A6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:49:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 058CB160362
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:49:41 +0000 (UTC)
X-FDA: 85195566162.29.1053FDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A1BE100002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:49:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bNHx/EH0";
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788990579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbnXfxn2Gx4VFcrGbx5BMqvSOzop5+o0kVczGL+oaUA=;
	b=4rUGO/npWXL6xkBv6bdclrujXo9LwvcCaYIGabhcpIvGVhYMGyDyOUNL5NQsEkIL0kxeAv
	dy1tYuuYQE/bX09Xvoi7W/KV4B5JBIRDUWxGqo+P7ZqMLpt+EosWgJ+BIhD/toPvy6paOe
	2Qm3un2URE1VQu8ypHjTxIPN4X2dQX4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788990579;
	b=BuIlX99CB4azyynCg88av3pSPmTe6UZoqGR69BHGMJRWJ7p+1Et9aMUh8ifr1RA+YFGP1u
	8ODJwXCvEDLsL8W2LLtV5cjJzsOMtKpCqC/vDaIjRJq0y7In1hk+Lyhx+R7sgk6/fyTXqz
	ai8LNYaYeATSUrApPtH4surbX8ztRio=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bNHx/EH0";
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26B95444E7;
	Wed,  9 Sep 2026 21:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED555C2BCFB;
	Wed,  9 Sep 2026 21:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788990578;
	bh=IpuMmCTHCH6IIMy98L5rBZSj/YgZOfEudC6ymLrW5rQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bNHx/EH0Cb/hdSNbAr+oD0OQovE5QEj0dxlpPO3XinstfZhmjO9wICxnPHSmm/dJ+
	 cc7ia0kzDRkO3zzhv8nHqzIR2gGA6KAngFpMyRaqFmoDIrt+n6Me4leX6j0dsS+S9p
	 IZa4dKmY2Hs2LSmxqzXoO9eROJc55i+jgu7z0RwF6yDTD5Tzd9xaYCmjSi8Rs5sX9d
	 F4dWuQ9ZeqgM9WZIRiiUFuW0w1l+lls0hHWzOBzbFCNTVas2wybWzv0eBch9NsrP03
	 Nomi8NeA0qdb9bJmNXVc+KPR7Ue8j+kIIt3LCwYkx57cQZyzB1dQirLfqdXcJeAMyj
	 XoFwWIsgbXEWQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE74C88E41;
	Wed,  9 Sep 2026 21:49:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 09 Sep 2026 14:49:28 -0700
Subject: [PATCH v2 3/4] mm: hugetlb: Fix subpool usage leak on allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hugetlb-subpool-always-track-used-v2-3-30c5d83b572a@google.com>
References: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
In-Reply-To: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788990577; l=3569;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=cYJ89cnWWYewpfV2xJr1JZku8Dzt8E3hqm4GB5Ws6/g=;
 b=saJolngd03Eu0+scYnu3x47RfGTgFmOprIS5lh7xp/uDq2/hCD/CKZYbPTtBY4n9Hn7uqo2rO
 V8dm6FOIsbRBfyagUeDDamv2dWK3Q7IFZscOJPx3Tg8l77vta/SfUMo
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A1BE100002
X-Stat-Signature: meoxjdhyip3p9ny65rqjgmkfwjsqhum5
X-Rspam-User: 
X-HE-Tag: 1788990578-828577
X-HE-Meta: U2FsdGVkX1/hq8iBbCZdGATXTnl/9xI/TeWvf9tbslcAQ55r1V/vElFM+DgCs4+9DbI5DChgIyKxEjuzakdBuUF4EoaTtnQqOHByfN8YCbZ08xHeeOFDlv9yTOmOfr9XzkjmPYZXiEzitSfaFobcw70902AAxXO8wN0zChuRqmIrBzEiXb1OyKMJmwaotUt3d+SM9ycdYwfoGy0hw3MPEvcPxMbvRpKfxg6Y1hc8YYkBNTjXnSN31g3sB4O6h5VnlXWrdYHCbqAOWfdnR8TiDSNst7w0fTJOpodydYTrsCf5R8IiKslo99a3qIMjNx2pIsOw+EDv1Iazu+mE7A/or5KpPcFhpHsCUG2IRfI8g7G5Ud3neL5N5EqeCmjt6yW4HULT36FAadKrZwS5JnLVx3JS0goFoypgusTyzY79gwHnmhnJ3HykfChgou6Zn5UVQ60jfjmx6S0EaOQe7/0jwRumRZymCIW9sUh5zUdUx0rv8b0Thq0iJxHaUetQCGbI+TiUQgueHJddxfc/c0oWHLLPtdLAef97I9T73olpDZUqBz2u1hZz6PetUrhFxirvmPMt+yNsiGP5x68SQ8GdHdK/zPDmlIaAa1ERb0FcbHEqNoghrjOsHA3e/SWidK75cJcPPkrDqA9IBDVnYCOGR/T41BCEMSKVID8HBNTcVIUtUFAhAnm7+s9mqPA9ZiCzW2QIwAHGxAMwVajM2x4uDD4g+55mRFiBhdQbRQ6nY9GJxChrdUHENo7r3HUhFne4LQGWWhWVi0U2B+VeCZpyRoxs+vBMUkOijFd1QRRWLxtHc5ThH23yMFWaqNeeKGOjQFgF5KXQgCJxJa7UnjarPUsI6pY6Q4u8GexDH7U43OsA7nmRqcRBbLfs7PlcnbOLYWLpTNQsnGwbgnVnb7sdqF2/QWQ6LhfOtOr5f0J6YE0vjGAL5qmgDTW2B4n4vfSlX78sFeHLzX31el/iggz
 /QMqBjJ1
 euL1FQMA1cfQ2Lo/NUFtVfSSPOwvRNv1AoRjRFdVMm2Ae0343uvLavpkBDCbwG6xeIqQnVvrmlMLnocBt3LYz/gAxEA7w1PauSkY10H40sDcw3Svbz4mC6RsKcZF1qo9HHSoVZh6XSUspJG2igJxI/g8gRpbct4GAUW3Q1ilTNCwy2Eh/zq/sJZ28VMhmLVkCwJ7T44Yd6T9xaCN+ZccCoFw4puV7w4caXkVwMPC3n/objEQQrlV42EC4x/0dkSLnUgd3k7Pxpo78q26T5WzUI2p+C/GXPN/IKs4Eqru4QISjsj3qh4MJmUZgP+KiLSwiolPB1jiynsFLVbJyzkFeGWYPsGZBgGK4bbwcV1tS2Rv7LOAJAkvW8aFKZHDSgQmw+RxGth+/ltH9CXt87EGUnQJRbcdo0T/Bc4zbU6/WxRmAM7bYDztysRck4gXhSldqNNa15JCi0gzVEvTtUmLmHMShMpoggpJU9+Nb
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9eb9f3442574c..652cfb55c6e6e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2957,7 +2957,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg, gbl_reserve;
+	long retval, gbl_resv_get;
 	map_chg_state map_chg;
 	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
@@ -2996,8 +2996,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
@@ -3006,7 +3006,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		 * If we have the vma reservation ready, no need for extra
 		 * global reservation.
 		 */
-		gbl_chg = 0;
+		gbl_resv_get = 0;
 	}
 
 	/*
@@ -3017,10 +3017,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
@@ -3074,13 +3074,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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
2.55.0.1007.g17ff1f9808-goog



