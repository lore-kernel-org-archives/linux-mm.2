Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28058C982CC
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B73B6B0095; Wed, 16 Sep 2026 19:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9C66B009D; Wed, 16 Sep 2026 19:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADFF6B0099; Wed, 16 Sep 2026 19:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAB476B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:39:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5BB2C01B1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:39:09 +0000 (UTC)
X-FDA: 85221243618.17.246BDCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE1FC180002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:39:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e92l7mcC;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789601948;
	b=uAv5FyJtXfL/U9njmUPMsAuaFbeyuIQhkxkBjnuW8RB3Z5yt3c1q/ms6g+X41zCu/9tUP5
	UUmZmtodsVFOuWd8C1/l5tWTm/I47VB4HbP25DP1zDDv52fq+6KbNUOR3dVV/ZvhR2Jgjk
	Rr9aa1Rw4V26M2Vj9mjwBwYJi3BTgW4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e92l7mcC;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789601948;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vf7VE6q2uT03JYKaJrNLskhMG4dUxqdG03ckxZLkf/I=;
	b=srB3eEAql5hCGyV7X4xULZOnHEQS3YUfc6smCHc5szoJO3wtd/vGIOor8j5V5kWtAuZfS4
	TbaeFJloMW2e5ZiMN5EocWh6gCApadtXRc+w9P86W5NJZyqMSiFJvOncQXnv4kAGBfXX9e
	n2RqrgGDRPodbrg32ojvlYYWWkeZu1I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 996AA444FB;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 328D0C2BCF5;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789601946;
	bh=tsqf0aWLMOSwHnXHAdTX02Wxeb0NHizwCLMEWz/sUuI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=e92l7mcCyLvFCvSdP+gQOJGEpnIArr3QpQLdShF+6mqjzhvhG7dyJYo0nPWI2zL0M
	 bE3hENv4WBhfgLnfFiajWk9V3kgN6N2L+e42zVmOesaS8UcRfnp/3ekRtRlMUaIqJG
	 TxPDKZpDXuSvljbtBHKnkiqNDEhfPoWdTyscHw9NDLBCRJQicIii0jO4cJiPs3q5ar
	 UYmNPPUx6FitppsoLhBTUjhVLcXGvBMREvbKyW8CG6f7tTA8z0C8HvBr8ffG3Wkcje
	 piG87SJxjRFcvJBtMNX0Y+TrbRXq0JAlgL1zK58qdkXI6EwmwDr+LUa2cgLzG+UGiO
	 oHFLldgU0ujHw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111E0C982D1;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 16 Sep 2026 16:39:02 -0700
Subject: [PATCH v3 2/4] mm: hugetlb: Fix out_put_pages subpool reserve
 calculation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-hugetlb-subpool-always-track-used-v3-2-38aae9b5ccdd@google.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
In-Reply-To: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
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
 Yanteng Si <si.yanteng@linux.dev>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
 jthoughton@google.com, rientjes@google.com, vannapurve@google.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789601945; l=4939;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hbCc1VLcSxFYUMlKbRMMvbXITCMyD6a9EHSLeup8DNs=;
 b=MH2U3Qi7wREMFL0fYx06ravkLlUdpLhlZGfCa/VY1ZApR995ImjP5LngSVOH3zHCLQXF1LY/w
 QoBsu4M7/krCg4sUbpsZ26aXy80XwK6XqvfTmoAoynkMZqkEAX6m0n7
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE1FC180002
X-Stat-Signature: uda98o7eu6u6rentdqns3bc58psuxywi
X-HE-Tag: 1789601947-926281
X-HE-Meta: U2FsdGVkX19MO1Q0VO7ch/RDQrTCQsMpnf9gbCAFSFuJPgGQq8XcqrHVJZCG2y3f5duMx98GMBTZiHsZq6/OlWOyovVE+Q8pMj6FR62X4e6ie/ycSyQoKEwuvFrAlaCcsLWPlqKcW77s6YJr4xhX0XrsUktUvcmJPxNL/tFmd2l7GFQUvmNSF7c7fgfE8l3Q7bwUtUR//V2l6cHMHSqJFQ55uR/rTeTmRFZWdtVUJi5XZZ94xfvJ2RlQs07BAwM4rqBcHrCkpOfU0e8ehCsiRnsOIseXJZpD7UdiOcwgcfK6doWaLgDOYAi2Ib7CBl/d6iNJZjIBGZ6EWxA1xyojDVKkRt6Q7tlDVDRXRQy7n60hiI+avElu2ClguotpanJmjKbkGn1mBupmuZHK/KZWZ2pemILjqxHaPJJ52lEaFhMmWHlCQ4+klOGFwbmlCMSrLB3aM0eWVLGqbPkg+dKDrfIxmMXGfWhYtjZz8ihP83bgNggiFtEkRNlXXABFumhLif5ACuv7cCP89YA8wZwq6bZUJQTHYG4aeAOof9G2RfmrMmryCaHkY+tlxtzUQN8RNc6Q9lvsZesjBc1gq5qqmTn9gjR5Pwr0ugCh6kYDubd8++QqOzi0+Me+xkU3Uq7rNfoZIufQmZsy+iH1CMU0ygcAguOwTAw/o1XkB7T1eLfhm7/cnFlscLI4pumcuF/8fafWEsIERXXqlWXaLkqQEEa7rdVbU0mRzvGEE93dCBJ5ZQ61XQVcJ/VdxpfoG6pL6hUXA2jlwI+AWxOkcVKCUhq0/N2sp/on2n4hajflbNCU5yGmaYQ4sSWn6qS/t228Vf1lTa2HKwwpM8vCmUT0j2LQwmUeyj3VczunxHWigtLk66yqBR5fZbWYf98vVYwiXufA/s7U+bcoarZVm8FqBVUyp3QxSzDJ4vSL7Vik3Df4m/DAwshtPE+dpqN37eIwnHeUWLaUt0ybQefsWXp
 pKErXzFD
 6/9VNSVMkVg1mwNVpfPYK0wYq8YZdQ3Q11NSfbyS4PnY20wyj9PK3B66KbawxWUDGA2SSLMI5c0A+sBiI7DFMeWziydR4NsvQjNLdLcTQlc0cphvBxoQoIog/kzrqw62sgpmWqVOmaKX2UBM7Z5kwuhSCenS6Rz9qrIkk8f0n5ICgZE74Fd8HM2lREpklVlf91eWMXYTtWciJSaGHXM/vu85GbzZpxOHfR2oxTm0UXN0oaTe3VK+3BeQOUz5fSyIWEXGDX7WfE8YfRg6ySt6mj3POIFbyNRbFvXjSd1jeym4w8AGRUGrrNJiRuJsNBvRot6VoIeAd4T9MOE529XqwdWvFIW+EdTu1FHEMbdj25FU8s+SLo4X/f9RWiuPzvTDt0Pd+WRDOVGsnKRVMNdYzeBRpOXofof1Che7EqwOaa16qxTS12iWnAiR+9CsiNO7bCltp4P4lZDKdWWwM4D+fR4u84KpfbXAJ1GFTLx0i9WDpDR9d9Dgs/sf6bpdbtVrTqqRaBSk30Ht+9ZUQjIOqHmCxZgFz8f8lG3EbhOITzprrzy4=
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e72e22f887478..faa799634822e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6676,12 +6676,14 @@ long hugetlb_reserve_pages(struct inode *inode,
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
@@ -6756,9 +6758,9 @@ long hugetlb_reserve_pages(struct inode *inode,
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
 
@@ -6766,7 +6768,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	err = hugetlb_acct_memory(h, gbl_reserve);
+	err = hugetlb_acct_memory(h, gbl_resv_get);
 	if (err < 0)
 		goto out_put_pages;
 
@@ -6785,7 +6787,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
-			hugetlb_acct_memory(h, -gbl_reserve);
+			hugetlb_acct_memory(h, -gbl_resv_get);
 			err = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
@@ -6821,26 +6823,16 @@ long hugetlb_reserve_pages(struct inode *inode,
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
2.55.0.1082.g2b9226bbc0-goog



