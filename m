Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E724BC44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6A26B007B; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370516B0093; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015AF6B009E; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF1306B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DB30A0AFD
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:12 +0000 (UTC)
X-FDA: 85011262224.25.91DCE45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 288CF80005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wq8FOEO8;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602390;
	b=cMK6iwdRZ7WX2nIKIhDSgNEkgGuqjj50CNyZqrgqSxRJnMDL+Ku+bAeYxF2RASYh9fRkdm
	Ypa02eG9t4fqdzx3eMLnLvDY3msrkoRsID4qQX//ODU1Aia+cX8cNlIuRm5/etu/TgCZ8o
	zq2UeYXYU3NsJSl8xGY+9Y12YSU+I6E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wq8FOEO8;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Mk+f7zHxxDmeu0juGcxcdp/lUpa/BXLwpg6L28m3rk=;
	b=iyQo/ZOkB9+StwmZGugB+HpDBE9/v4zQBOdCS0zc016pt9IHYcKsxl1Y+kUNhcOSDVHz9q
	62eX7EV1l+61vaI4q9Z4he5QQdQKYtrwKYM/cTfvQDHR7D/o4/pDxd/0xKJa9A9KnH1gYK
	b7GNR002xit9pX3F6fnScBAOjhqCpN8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1060143C84;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBC0DC2BCF7;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602388;
	bh=G7owv0Rh8aK9HMc13GyQyMnhYD7EJP9+jUjD/VdT8wY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Wq8FOEO8fWount63Mrrt4fbeFwHO5uXGjd1wZx0VDUEV955uJiVkGPqj3XoF0tFdW
	 22XbMfT3IiTljDe3zvEFdMxsKM75B168bU9xCqRnDpHOqhyFWjD+TUGrVjqVcbeTgF
	 BQmytPP/ZHgE80maX8fRfrIVFuoJpgLQWU7xfLtaG5ehA6wBwXEafhgzjq9P5YzYUj
	 EfAHtCf/IJN/FTJ6mSfK3BnpFeoT2epDigDzpRwNvLHYLwB4tbAxRTHM/XRfBd6IKv
	 eMGVjvMMXO4hgr7+CO0hK6GDzMxk4oN/KdVaRQZyKMyeZtmyAHUfyPRdesYVhDwiyO
	 3SCJ2ASnXd5pQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC01BC4452D;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:04 -0700
Subject: [PATCH v3 01/13] mm: hugetlb: Track used_hpages when
 getting/putting pages from subpool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-1-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=8769;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=w2qajt1r8Q6gjrtYXuj4ovqvEP7oIX8X7JrtFo0nCxg=;
 b=sLajWR3ya/oU2guuR3A6UKK6t+gsg3meCcu2cmJNYfdGD5C15Gsco5sKlvP9dcBy6/F+UxTiR
 KmMFHjmgQJuBEw2lPu0g1TnTLQt8BIPsFy9NkDTPVao6+FuE3Yjsdfi
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 288CF80005
X-Stat-Signature: bx9zgr3bu41pq5dk7w6ohebybkk8kmfd
X-Rspam-User: 
X-HE-Tag: 1784602390-721960
X-HE-Meta: U2FsdGVkX1+wpcD/cMKaqER/QRne9wEQzxqx6tgiGeHYut2zlcf79BmjLqP940RHBjSZuQWzgho2quqx7Ued+mygpQx7irECL4YObUnxRzVFu49AhqOnJH+5uuZhVXi21iTr8ilN+J03JJPPrIgj6Rlo8JWvLiNt7kOhdwgFErsxhkTQ2zihx5NMi9Z5/Bm4QPZyU9Y3Jd07Ef0FNBOw7wy2YRRV82o12kbyo4/ipNP01MlHnBSx/oTE0QjP+a8Xj2KBX/ObZFYVVx4znPyxNZwmTcrUXPhRB6CpDcdWclmHs/RaJh4atg8+XnHyaj76ol8CcCORl38GWgAeDIPSGRw88/BKQK1OZEjF5uB9yZee67sRQSh+rKypPWKRnWPLwj3GyKigv69uFt7KxmD6uKAJA90cScuUgvO2GR7xjwHJFXNmij0lmQ0ytm8zWa6mYYtZZRO/e24SeE3mc/Dm7glhLZ3VKDtm+q5oAO8MD9w4DIwVjQwOPkjG1pcMLaSAgAdc70aSBYWQ0NxhM7i/qnhpNoMAtVIagF8kLwHnD5Pjknxxhg0u4i5iVd3+sfoNvwS6dx9/KB6zPWi6U6dmZMQFmp51H79E0ahddn3aN4ECw1Cs+nlBGpDrUJSfJlwCJXOeG7PLkOjt3j29MJ4fz6RRgbCCTuWxB47gWD3Tf6qQRT9lXpchEv+fsvLUseEK7LrVIq9nMitDVHx7jT7mJNCloE73U+n6UC7wD4IMPEJZJ3XraQG5LuIoFmz2rZ1UH/YKBHZrRAEB/ixEw1x4g3EJZ8BWTALXQNWh61QNyk7ooogPAhf7kizlJZaRuNLOwDTD78eCF1rkDgXKg/K+JxQPTv43jUHaAHi/tya4QgQDlpHBoimTXMOyyObzLxiytSY1lTsau8vsXA3885SY3VmE61rpCPdKBf8/d531Ef7z1WAm6p9qgxy4SVGQalfqXOg3BFg8EWZKuzw0MYx
 82OWUnwK
 Qv1xxv3zEYjhGSYgGltFkoDLnkmXiuRLtk1a1AjBUr+hzE0l+VtLdbcMj2vKeVaSn1lVsTNgjHyd9hShGRien/NEun6KxY7L0y30zCPqvzXIMvhV7kEB23BnPt2XoDp9HIEQD6LeKYk3eg7RepQDICtzi+aFlRWAcSuZxgZT7EyiNzH8w30Be+aOzQQfXsqbBSCRqM8kGqAHHPFeA/+onDByBjeD1IVl63mSVII+FP9UzRiK03HzbxMtiLsH1B6FB5r5S8w9Tr3liVk/6Zczns8SgRShznbBgrpOoYNWzM4JNJetWb4GCmrRFX9i7PLKS7N4464shopTE2x5nM+uweonl/Rl5hfFRcuNqWaJ6XVk0HUDAEXvgmvBqwm5mScbzR8ZRxp7fhBOs8/AoevjHgoot+fknDQhcMi4renlWGSrd0u/ARGeTqndtCAr0+V022/4dTXQ4RPZSgk5eCIop5y6NyQsw0HhmoVnZB8hoIUOqPGnvSYs5m0zrAdTh+tk6QfShDqKuZyEAzt9/u1MLJkCMPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

hugepage_subpool_put_pages() currently has two distinct responsibilities
that conflict:

1. When size is specified for the mount, max_hpages != -1: Keep track of
   total active pages (allocated + reserved) and decrement this count
   (used_hpages) when a page is freed or allocation fails.
2. When min_size is specified for the mount, min_hpages != -1: Ensure we
   don't drop below the guaranteed minimum, and restore a reservation
   (rsv_hpages) if we do.

This causes trouble because when allocation fails (refer to
alloc_hugetlb_folio()) if gbl_chg = 1 (i.e. no subpool reservation was
taken):

+ To keep used_hpages consistent, HugeTLB needs to call
  hugepage_subpool_put_pages() to restore undo used_hpages being
  incremented
+ But can't call hugepage_subpool_put_pages() if no reservation was
  consumed.

One option would be to conditionally do subpool tracking updates outside of
the hugepage_subpool_put_pages() function, but that would spread logic all
over.

Instead, always track used_hpages, regardless of whether a max_size was
requested for the mount, so that the subpool always knows how many pages
were allocated through it. Every page allocated through the subpool
increments used_hpages, regardless of whether a reservation was taken from
it.

Conceptually, now, every allocation involving a subpool uses a page from
the subpool, which must be returned to the subpool. Every page taken from
the subpool tries to use a subpool reservation. Restoring a page to the
subpool reservations only if the page was taken from subpool
reservations. (If used_hpages >= min_hpages, the page must have not have
been taken from the reservations.)

Always tracking used_hpages provides the subpool with information of both
used and reserved counts to make the correct decision for both max_size and
min_size correctly.

With used_hpages always tracked,

+ subpool_is_free() can be simplified, such that the subpool can be
  declared free if there are no more pages in use.
+ open-coding in hugetlb_reserve_pages() can be removed.

Also update the documentation for used_hpages, since it no longer matters
whether the used pages count against the maximum.

Also update statfs reporting. Previously, if max_hpages is negative,
used_hpages is static at 0, so returning max_hpages - used_hpages returns
-1 and is always correct. Now, if the subpool doesn't have a maximum
requested size, indicate no limit for free pages (-1). If it does have a
maximum size, report the difference between the requested size and the
number of used pages. This difference is always positive, because if the
mount does have a maximum size, hugepage_subpool_get_pages() ensures that
the subpool usage never exceeds the maximum.

This fixes a bug in hugetlb_unreserve_pages(), where pages are returned to
the subpool regardless of whether it consumed a reservation. The
corresponding bug in the failure handling path of alloc_hugetlb_folio() was
fixed in a833a693a490e.

Fixes: 1c5ecae3a93fa ("hugetlbfs: add minimum size accounting to subpools")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c    |  8 ++++--
 include/linux/hugetlb.h |  4 +--
 mm/hugetlb.c            | 71 +++++++++++++++++++++++--------------------------
 3 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b23..26c0187340636 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1109,8 +1109,12 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 			spin_lock_irq(&sbinfo->spool->lock);
 			buf->f_blocks = sbinfo->spool->max_hpages;
-			free_pages = sbinfo->spool->max_hpages
-				- sbinfo->spool->used_hpages;
+			if (sbinfo->spool->max_hpages == -1) {
+				free_pages = -1;
+			} else {
+				free_pages = sbinfo->spool->max_hpages -
+					     sbinfo->spool->used_hpages;
+			}
 			buf->f_bavail = buf->f_bfree = free_pages;
 			spin_unlock_irq(&sbinfo->spool->lock);
 			buf->f_files = sbinfo->max_inodes;
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e90..34b9a3e1be0fa 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -38,8 +38,8 @@ struct hugepage_subpool {
 	spinlock_t lock;
 	long count;
 	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
-	long used_hpages;	/* Used count against maximum, includes */
-				/* both allocated and reserved pages. */
+	long used_hpages;	/* Used page count, includes both */
+				/* allocated and reserved pages. */
 	struct hstate *hstate;
 	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
 	long rsv_hpages;	/* Pages reserved against global pool to */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835e..eef9610a0593c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -129,12 +129,8 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
 		return false;
-	if (spool->max_hpages != -1)
-		return spool->used_hpages == 0;
-	if (spool->min_hpages != -1)
-		return spool->rsv_hpages == spool->min_hpages;
 
-	return true;
+	return spool->used_hpages == 0;
 }
 
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
@@ -205,15 +201,14 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 
 	spin_lock_irq(&spool->lock);
 
-	if (spool->max_hpages != -1) {		/* maximum size accounting */
-		if ((spool->used_hpages + delta) <= spool->max_hpages)
-			spool->used_hpages += delta;
-		else {
-			ret = -ENOMEM;
-			goto unlock_ret;
-		}
+	if (spool->max_hpages != -1 &&
+	    spool->used_hpages + delta > spool->max_hpages) {
+		ret = -ENOMEM;
+		goto unlock_ret;
 	}
 
+	spool->used_hpages += delta;
+
 	/* minimum size accounting */
 	if (spool->min_hpages != -1 && spool->rsv_hpages) {
 		if (delta > spool->rsv_hpages) {
@@ -251,19 +246,24 @@ static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
 
 	spin_lock_irqsave(&spool->lock, flags);
 
-	if (spool->max_hpages != -1)		/* maximum size accounting */
-		spool->used_hpages -= delta;
+	spool->used_hpages -= delta;
 
 	 /* minimum size accounting */
 	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {
-		if (spool->rsv_hpages + delta <= spool->min_hpages)
+		/*
+		 * limit is the maximum number of reservations that
+		 * can be restored to this subpool.
+		 */
+		long limit = spool->min_hpages - spool->used_hpages;
+
+		if (spool->rsv_hpages + delta <= limit)
 			ret = 0;
 		else
-			ret = spool->rsv_hpages + delta - spool->min_hpages;
+			ret = spool->rsv_hpages + delta - limit;
 
 		spool->rsv_hpages += delta;
-		if (spool->rsv_hpages > spool->min_hpages)
-			spool->rsv_hpages = spool->min_hpages;
+		if (spool->rsv_hpages > limit)
+			spool->rsv_hpages = limit;
 	}
 
 	/*
@@ -6542,7 +6542,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		struct vm_area_struct *vma,
 		vma_flags_t vma_flags)
 {
-	long chg = -1, add = -1, spool_resv, gbl_resv;
+	long chg = -1, add = -1, gbl_resv;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
@@ -6687,26 +6687,21 @@ long hugetlb_reserve_pages(struct inode *inode,
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
+	gbl_resv = hugepage_subpool_put_pages(spool, chg);
+	/*
+	 * There may be a difference between the number of
+	 * reservations to consume and the number to restore now if
+	 * there are multiple threads interacting with the subpool -
+	 * restore the difference.
+	 */
+	hugetlb_acct_memory(h, -(gbl_resv - gbl_reserve));
 
-		spin_lock_irqsave(&spool->lock, flags);
-		if (spool->max_hpages != -1)
-			spool->used_hpages -= gbl_reserve;
-		unlock_or_release_subpool(spool, flags);
-	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);

-- 
2.55.0.229.g6434b31f56-goog



