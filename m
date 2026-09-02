Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AAF9C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 23:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74376B0088; Wed,  2 Sep 2026 19:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC516B00AB; Wed,  2 Sep 2026 19:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E656B00AD; Wed,  2 Sep 2026 19:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80A466B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:30:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0652C403DC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:30:55 +0000 (UTC)
X-FDA: 85170419670.04.8510EA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 123E2A0009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:30:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ND/DOedc";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788391853;
	b=crWsvPzfVznKUDh2tvrssREq0JBVQXhJ1c13iTDVkMEOoJ2Ne6dveG/EFX8ZbDdR53DFYE
	JYmj99vjyKQa+g/c5CDy4CWf913/10TPhe7ejGOfVRNnSmKakesp1Ta9GS6QSRvo5HPi2I
	HH3dto8bbbojRW4ORHyXxyKsCSqzspE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ND/DOedc";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788391853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPUl7JTf0o8nYtURyrgGsZ39w3HBI5seh8fqII73WQE=;
	b=QQfaUu9053aWSQSy9A3N3tQrW7KyabxvXSGBWJUy0Crg7trTJnQOo+BW5EDPikyfHa4eYC
	4ufOZONd5ao7s+QrrFf40oo75DVLK1c8adSgdFiNlveLJ3SsokkokR2qnJZVKfRxtWQqrF
	5+WdfXRF9IcIFC6A0zgCUa9CvgcRiJY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F73D601F0;
	Wed,  2 Sep 2026 23:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C45B4C2BCFC;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788391851;
	bh=Ki955AuPcL8ptd7DA7YclqDVfMByL7PliZlA0BuzWms=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ND/DOedcrMFnCY8DfibfP9hDng7EM/361nNjI71Mf0DliHbjkIPxRVh2AfLVoPMnd
	 AbmSFB6qHaq7ORwA9Sm46tCoz8VXHzx3r8KqAqbHyR3qi4Hh2gD8kz5zy5d6H474v9
	 p1gAuoCFI5dA1a8GPx3RsJZ0nR8LbTQ/wpKwOIzZrcg633GODwyQeVmJZFnmnbVQ6P
	 HXsSLmssiEO7h3X9S2riqCtbIaeBhU2ByB6uhauITdLKWW7kdZ6g+UHPtvNvzLgDrs
	 UBae/1LJKXGV69tj5EZvQnl/Usor0RN91bJJeTyoVH7iqbfm0IrpO96iOf8bbVmBgS
	 rpBHM6ja5WI1g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DDAC624DA;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 02 Sep 2026 16:30:48 -0700
Subject: [PATCH 2/3] mm: hugetlb: Fix out_put_pages subpool reserve
 calculation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-hugetlb-subpool-always-track-used-v1-2-de1cd14bd713@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788391851; l=5066;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=WAOJFELA74ZYgV3pRllA7LgbuGP3A6AKBVLXZF1SPnM=;
 b=EvrECO8aOK8i8SdPmLnnbqA1aqPFmPt+mDbbQUb1DM/nBfqdJX4cMT23/J5MKT+VUWwKjNMa6
 9CDPBG1/YNxDRRb2PM6VS+pRvMwSrcWckOcrsVb6nsXBqt40xL3f5DV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 123E2A0009
X-Stat-Signature: a14ngr9f3nx5xm6rbrmb759skogppjmb
X-HE-Tag: 1788391852-417704
X-HE-Meta: U2FsdGVkX18Arxpe90PZgDplM/mp3HoL7fKidhNW/+Rcf2sI7465dIwtwgmLNqmFKD7Oo0JlgcUUTyIjQlgBNR3USFSpOQy4wxWaukih/APMApPynmeEbp9J9V7hHYA2mB1PjwgKkCVly/qPBnPvTOzW00P0WTK1lzZPW70Z9h+zMTDSRj6LSbnov5/PCRomaTXtZEukd9lqdhjdabQKKzqLv50Dgy95mqHheUoYH75cdzXXxN5KMDDlcazrv2aVkv2hACshWRur3avjN4zY3n9I5LoAR4uC+HOP15h6d5N2IalQew3U37jMeMA2dWgT43CWmqo1mfaiScY69bbNRjWc3Q+pKIfoeTP2Nvii7hzteLCv4ns6DbE8UGTeOZ3o2O6DyNIdPjtkhepbNWcJ8HOArsnpzkQ8bZef5dU5KJ/W9Gz0q8zlzD+97Jq7QtgTmRh7mnSP81HFHrdLGuJLkPtUQT54LLK4qxMjY7gb7psx4dAhOI2UhNaNW34+fpEue13o4rDUWTLtw/as6P++ErEaLBP3ItCnOdrifN2LeYHhqyqIovzOPTy5sRwudK/K7TkfbV1Dp1Hd2M5r4MV4cHQeKFxfs+QfNhnz/sBYqyOlseyF+OTo6E40EwgJ0lYAKVMp+Ufooty/ajfG6y1Getva0O6d2R8f70PCh1k7TcwO4t4JDblEAtc8hOWSYBOCtf6Cz6Pbs/EIlHt3ksm3j93DCtz+jveaaBMabEL/1CePl4vw8/SfM1PTWXR0m9saKXaH4dqu5z1SpXv1RhvEHQGYYxZoar6q9sImt/wjLkQVCUrSNUt+boQhuL8SfRhh5sSPt6FB/HyuQ3DHS0H/Kjdz0NCOOIgnI/AYvWxdZnc9511iJxUOLfhqDA2y0h8T1q/gF05PESdZnKaFJkjpiBwTCEGm1FP7GhxlFDs3WDlDa1qtr0pdVNfZUhJP8orO+QQJc1YQywxxwYd5+YJ
 FWhtzx/n
 VyqFttpepSdAAkbFlWjdIrD8zyVDiMRGZ6jk8sMvnZIt1+L01qyvkKGzBo8nr3b9E6ORla6OyHP3DNKLxxVilZ1G/YHTESUU96YQoQLeEJ6bO2Gaf7KoTqL4d94LKhJSCkwzMfrP/6JoWpMHhqbP34H00EqtZ1hTHfmIKo6CpBrQlw3mbPQcRzKNjaXTuye4vPDlJ39rvi7Wo/uzZgL2uuxVU6mfB4q4HYUr/ksoe5yEd+/iGI/cqiBa6n+zCF2/VuzgWEgZHF7NAtMGuvjsG811Bb6bQfvPMT5C7db6Z15DXyI0k74Q+9Au8zxN7UGyIj5HhF+fJkLU1BB9msKhKV44E2CdHQlYQhqQ3D3DwG05QrCb9rnnX32bYcETyVzMvlDJvWmRNLT7h5VQX/dgSNM7JfBw1tKHP8XUZjmr2URErfmuabC1mb0RREFZW4c1JnHWuZUTa3YNmdA3XuiVMohmrqhcRBofQIrVCuNTspAp2ITh7kmi6FryuzAlcwmN4bPa4xrKYSvwtStOPhn4cWPM8AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When reserving pages for a mapping fails during global accounting, the
error path rolls back the adjustments made to the subpool.

Currently, this rollback was performed in two separate steps:

1. Returning only the portion of reservations originally satisfied from the
   subpool
2. Separately adjusting the subpool used pages counter for the portion that
   was requested from the global pool.

In (1.), because the used pages counter had not yet been decremented for
the global portion, the subpool observed an inflated used pages count. If
the mount was configured with both a minimum size and a maximum size, this
inflated count prevented the subpool from recognizing that usage fell below
the minimum size guarantee.

As a result, the subpool failed to restore its reserved pages counter and
instead returned that a global reservation should be dropped. The
mount-time reservation is permanently destroyed, leaving global reservation
counts depleted and causing an underflow when the filesystem is eventually
unmounted.

Additionally, if concurrent threads modified subpool usage during the
reservation attempt, calculating the rollback amount using stale local
variables could cause global reservation counts to diverge.

Now that used pages are always tracked within the subpool, return the
entire requested page count to the subpool in a single call. Global
reservations are then adjusted using the difference between the
reservations originally requested and those returned, fixing the issues
described above.

Fixes: 1d3f9bb4c8af ("mm/hugetlb: restore failed global reservations to subpool")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 66b6601abb069..d84ef044d1346 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6674,12 +6674,14 @@ long hugetlb_reserve_pages(struct inode *inode,
 		struct vm_area_struct *vma,
 		vma_flags_t vma_flags)
 {
-	long chg = -1, add = -1, spool_resv, gbl_resv;
+	long chg = -1, add = -1;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
-	long gbl_reserve, regions_needed = 0;
+	long regions_needed = 0;
+	long gbl_resv_get;
+	long gbl_resv_put;
 	int err;
 
 	/* This should never happen */
@@ -6754,9 +6756,9 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * the subpool has a minimum size, there may be some global
 	 * reservations already in place (gbl_reserve).
 	 */
-	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
-	if (gbl_reserve < 0) {
-		err = gbl_reserve;
+	gbl_resv_get = hugepage_subpool_get_pages(spool, chg);
+	if (gbl_resv_get < 0) {
+		err = gbl_resv_get;
 		goto out_uncharge_cgroup;
 	}
 
@@ -6764,7 +6766,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	err = hugetlb_acct_memory(h, gbl_reserve);
+	err = hugetlb_acct_memory(h, gbl_resv_get);
 	if (err < 0)
 		goto out_put_pages;
 
@@ -6783,7 +6785,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
-			hugetlb_acct_memory(h, -gbl_reserve);
+			hugetlb_acct_memory(h, -gbl_resv_get);
 			err = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
@@ -6819,26 +6821,21 @@ long hugetlb_reserve_pages(struct inode *inode,
 	}
 	return chg;
 
-out_put_pages:
-	spool_resv = chg - gbl_reserve;
-	if (spool_resv) {
-		/* put sub pool's reservation back, chg - gbl_reserve */
-		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
-		/*
-		 * subpool's reserved pages can not be put back due to race,
-		 * return to hstate.
-		 */
-		hugetlb_acct_memory(h, -gbl_resv);
-	}
-	/* Restore used_hpages for pages that failed global reservation */
-	if (gbl_reserve && spool) {
-		unsigned long flags;
+ out_put_pages:
+	/*
+	 * Return all that was requested from the subpool, let subpool
+	 * tell us the new number of reservations that need to be
+	 * returned to the global pool.
+	 */
+	gbl_resv_put = hugepage_subpool_put_pages(spool, chg);
+	/*
+	 * There may be a difference between the number of
+	 * reservations to consume and the number to restore now if
+	 * there are multiple threads interacting with the subpool -
+	 * restore the difference.
+	 */
+	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
 
-		spin_lock_irqsave(&spool->lock, flags);
-		if (spool->max_hpages != -1)
-			spool->used_hpages -= gbl_reserve;
-		unlock_or_release_subpool(spool, flags);
-	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);

-- 
2.55.0.970.g62bdec98f9-goog



