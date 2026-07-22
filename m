Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D38C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0A86B00A6; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679A36B00AE; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5698D6B00AD; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2EF6B00A6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 592A9140280
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
X-FDA: 85018036530.06.DC89F44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B70C1C000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZxa0L4P;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763683;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKG4VmBFmc9p69iWYgyAkG3n0OntC1+tax4erN67RSc=;
	b=BFfDsL/8ZJyb0oIr8323NF4jRRr6iHDM4ZSDKhwSA5wB/0/7If/zHl+vIt3A/VgunhIM9A
	9q5IlSwaLyrg/0hnSrLbX+AXEgRWEFjF70tZYGM4RgVxQ1eCClvp/STw3un8zpeHnohfXq
	mxVvbXK1bdQfdmdM/U+lwxERdzloqn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763683;
	b=aEKFtOXSECjp9/mp0c2BjvYLyJpOMDoUmub927+FHpECT6oLZAcSgO0W0Uqk6dOHWrNw9s
	3gkRUQnR7A4Ba749PpMNy5Cw+RMibIC7FaYtZW+vaBLfvzZzqK1wApEaPs5Douic16A9cM
	xU2bvVM0wfdqSPJJ84svoSQI0co3AgI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZxa0L4P;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 530E14512A;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B23DC4AF0E;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=aGbga1PkXCpZ8ED5LqrkeQ+Fq62YN785kMo+rpYCbc8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LZxa0L4POGfxU5e7iZ1UcLss+95VxKOFxH8x1G3dKJjbIRCBFNLJVK+UjPN7SWRvp
	 tDCS99qneiWqx5MNNwIwGEwlNh83mxLAsd4eIbiPF1mnOXakLLMnUCzAV3pdYLzVL4
	 TmhHGFW+R8YrQ0HM56Cr0LwgnI2Cl1++cRPBhL1+zkFNhfnMvTU/LU8i3QXugmBOVk
	 +zH16pmplCubUvwrByZin0CbgdFKMSIuiRI0iYqGJ15PjQKtx1Rua9zM/CDVC/+a2h
	 Vc7J71jFNi/67z33Rv6uFtUxRmJKe/vREwtEm/PZaEjcdAgAiaIwOPns7EOvuREfqo
	 zpDcHEyzLfrMg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1852AC44532;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:14 -0700
Subject: [PATCH v4 06/16] mm: hugetlb: Rename local variables for clarity
 in hugetlb_reserve_pages()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-6-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=4405;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YN6Ec4dryGn+lNCiGktVw2z+GkC+1qiWsI1wgmafaTw=;
 b=2bILnGfpQYBpRme36koKemun0e04kP1hxT7XZpV0o3yJRaZSrtupWWZeQRckJ1ePGfhGs4qPM
 8BCX7oBBkyyAdb4/2/vTHjmS0gJZT/YU/XnuJHwl3Zt1scXLcXt/uJ9
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B70C1C000C
X-Stat-Signature: 53thmxumg5g178yoezub3sr7nfirct6n
X-Rspam-User: 
X-HE-Tag: 1784763683-739122
X-HE-Meta: U2FsdGVkX1+C9Ze1YVETOY6qcxF1edIWhOBzKehLs+gNWB+x+YYlk0o9QJ+wmDSTIovXWGLCemdGYzoUwddaTQOxq3E09fU2LGbM3VtUNxu0sVTpKYwWLDy8yOclSp4BJkRpl65ScLDNfgxMPMCgFDrP1lAaf0hdavpoNVSV9vTb8iR5SAZUgjhMqszuc9mQsP1q2eRFzoXxPyPyxMvlKPhazdeEjFgdbGC/v7Md5JVvOZF3MTBdZl/sSExDzbdX4ysEPFYf8IjPK3mhCUfpa6SJxkzrNlQNteSU5q9lMsJixdkHZeGkS4A7n7fziylE0cSocE64aGcXBt3VzK0oe/EYsQcmv1gWXQsRKJAk2IAafffLowNUhchtROshLtDOysDfu7BScDwO5CvI4KkZQG7vLh9x6y4tuDmSxZ4HbBzLNitLJPmxhVZDj1FQcOZQg/jk0heNgkFygX+YsP5pCBarEwCMRQyiZ+R0Nx2qt8R+hm+x1CJEFMEGLiCh+JZcvGlDg+JZtfBD4Wb1z55awgJRfs4Z02NhEhnPOMX0Mb90TGmXecAkBOxaeCL+Zr5OiGGo2Qm4JLsEHpU60gkVTeIRxAH8M5F3Zj+QKIHe9WY+sIZSXKGHd2GxXsUg5ZBSHfiVdOZsQpb4X3BGI4hklky9duNAzVnfEFeVK3B/XWE7ulBE9TJ48IOEpOt7sCj8WocTMJuSWP56xNV0s9Ng99cXgpRAgIyyC2G+XvtwHs7zcXBHk9+/oAlO5Q0f+qEaaOyCJlvogW0MpRInkaaib5+plTXa6y1pJ5h09z8luTkvYPxeMxtF0UlV8LddfajypIn+HrRXsEdEEQzPbGo/raP8a5YM7iMtdhYbw4oE6NyJTzmZDZtWgG7A2KUhtp3WRHJ7o9pk62eIeXu8eC1706ecI3OUV4KwAqjE9reTa/6dh6uOL2d7fH9DxObCPK0+lSpaoHixrO/rJ9+9Ynt
 B9UTqXZ3
 +qV2gSlKtYj+567TWDjAZTWU5grRUee+ms7UZnsu5t+BlcXGVtWgOSrASgXvLLpdbVQ6QWfxMW8p/ThHuYsXeKk6Sar+niyHKfG6PsmZsNk7hhhOl5sUJQv/HpWhNEAOsTN2jQe8SlKM73LQCIyXPW2iMf3rbiEbgEyoi6BkdxibODtg5Zw+KI0uFftZd9kBKtWBIcWfnmt+6hEhA+ofpejRwqHL/8Pnl0viRGPgbeNkhM2JrhQ2E6glPOIjBkEICcNMvzI+A6spF8rdRiG+1noeY6Kg/XONxH43ei9WmdcAspbluW1CklcPsvDpf/KSU8eOKJX+0CUVSMci6rPlcCDiICkf9zogk9MXar1CbwsmQEqDl72T5W9l7vqP+5/Cacoh1GRGup8jXvZpOGVQJeJ3/+RzOnlwlxZv+ZuR0EXq0TWCSrPCM6SAZsoC7o5YjOUvOgs1Mby811tCEWS9JQMjSInITnAVMYv6CFglr6agOgPufo1aCJAvRCnIiXHEsnxzARvUQ3KUJpPxaWNrjASc88q48OBitia5W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

In hugetlb_reserve_pages(), the return value of
hugepage_subpool_get_pages() was named gbl_resv, while the return value of
hugepage_subpool_put_pages() was named gbl_reserve. These variable names
were inconsistent with the naming conventions established in
alloc_hugetlb_folio().

Rename local variables in hugetlb_reserve_pages() to match naming in
alloc_hugetlb_folio().

+ Rename gbl_resv to gbl_resv_get, which is the number of global
  reservations required from the global pool (because neither reservation
  maps nor pre-existing subpool reservations could cover the request).

  If gbl_resv_get is 0, the reservation request is fully covered by
  pre-existing subpool reservations, so no additional global reservations
  are requested. If gbl_resv_get > 0, it represents the number of
  additional global reservations required, which are charged to global
  memory via hugetlb_acct_memory(h, gbl_resv_get).

  Note: gbl_resv_get in hugetlb_reserve_pages() is conceptually slightly
  different from gbl_resv_get in alloc_hugetlb_folio():

  + In hugetlb_reserve_pages(): additional _reservations_ required,
                                accounted using hugetlb_acct_memory()
  + In alloc_hugetlb_folio(): additional _pages_ required, no change to
                              h->resv_huge_pages if gbl_resv_get > 0

+ Rename gbl_reserve to gbl_resv_put, which is the number of pages the
  subpool could not absorb into its reservations during rollback (and are
  thus returned to the global pool).

In error rollback paths, hugetlb_acct_memory(h, gbl_resv_get -
gbl_resv_put) adjusts global reservations using the difference between
global pages requested (gbl_resv_get) and global pages returned
(gbl_resv_put).

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 879e4640dc50d..8431c00d48267 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6562,12 +6562,13 @@ long hugetlb_reserve_pages(struct inode *inode,
 		struct vm_area_struct *vma,
 		vma_flags_t vma_flags)
 {
-	long chg = -1, add = -1, gbl_resv;
+	long chg = -1, add = -1;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
-	long gbl_reserve, regions_needed = 0;
+	long gbl_resv_get, gbl_resv_put;
+	long regions_needed = 0;
 	int err;
 
 	/* This should never happen */
@@ -6642,9 +6643,9 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * the subpool has a minimum size, there may be some global
 	 * reservations already in place (gbl_reserve).
 	 */
-	gbl_resv = hugepage_subpool_get_pages(spool, chg);
-	if (gbl_resv < 0) {
-		err = gbl_resv;
+	gbl_resv_get = hugepage_subpool_get_pages(spool, chg);
+	if (gbl_resv_get < 0) {
+		err = gbl_resv_get;
 		goto out_uncharge_cgroup;
 	}
 
@@ -6652,7 +6653,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	err = hugetlb_acct_memory(h, gbl_resv);
+	err = hugetlb_acct_memory(h, gbl_resv_get);
 	if (err < 0)
 		goto out_put_pages;
 
@@ -6671,7 +6672,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
-			hugetlb_acct_memory(h, -gbl_resv);
+			hugetlb_acct_memory(h, -gbl_resv_get);
 			err = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
@@ -6713,14 +6714,14 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * tell us the new number of reservations that need to be
 	 * returned to the global pool.
 	 */
-	gbl_reserve = hugepage_subpool_put_pages(spool, chg);
+	gbl_resv_put = hugepage_subpool_put_pages(spool, chg);
 	/*
 	 * There may be a difference between the number of
 	 * reservations to consume and the number to restore now if
 	 * there are multiple threads interacting with the subpool -
 	 * restore the difference.
 	 */
-	hugetlb_acct_memory(h, gbl_resv - gbl_reserve);
+	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
 
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),

-- 
2.55.0.229.g6434b31f56-goog



