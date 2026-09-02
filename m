Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E77C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 23:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325696B00AD; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0226B00AB; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176BD6B00B2; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6CAC6B00AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:30:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79ABA803AE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:30:55 +0000 (UTC)
X-FDA: 85170419670.10.0C61AE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78C19C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:30:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uObNl2d2;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788391853;
	b=c+4Mo0ckNHeXIuO67WrTpoZeDETqDSRkMHgdaCwTPYeERKBSzVsYcbiQp/HTNdBpUvgBWs
	0mSr4MKVv9h6VNhfX2OKYIfmWpB4DSGvfvLc37d/yDnM2nusooY0ZM+L9JUuJmeHDdNIko
	EohDn2WVG3nF+3Z8KBAfPEMk84SEvd4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uObNl2d2;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788391853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sT6YdfVf/UGiV+nvvVeClg125iBBJU6RwU2wEdplYwg=;
	b=EG4Pco/K88yw+IV3uskUitgxH6lu6ZHyLiOf5efoiFiR5Yedv8qmH70JF+O29gaqQXyZmH
	D81QPN5sOeuiAagRVVAMiHOl+IUxuj9ZHr6xvmu6cR2oacobL4MIaDd7efPGiCY3YB9yZf
	HCjyhn/dCgMHwUIbFmKh9JlDL592LYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EABF743FEE;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B93B9C2BCF7;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788391851;
	bh=YmTzLGCwOa83Q9censUxVmhxihQS3PGlGIxxvn+2hMQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uObNl2d2SiGKfQAUiAKEIjUwP4GukueS8gXoj+ArYQ38XEevH3eLly3Yphu1FT3T/
	 5nzebHCZQVwupekJ36MQ8eU/G1tRblvuo/jGwU8BYo8qpVi+JuKUAlEGKQID//BSzO
	 eskVlgX63KW95dhD70m5c0IMBeVKo1/WEmDuyg67jySelzPmg4Qy5L8UzAuTT85I+7
	 bOnOQr5FWPkM3htSMAxeD1SmwP+xkT51skIQC3OUrNAKhaSFlahnu/9hMhNovGoOPn
	 GpgAS+yE+bVRJJjUlee1Hst6v0DJKrhIPvl+74Dwu/OvBnqJ0OFw04lH/WXIUxGER8
	 0qf+Fp9fS4xlg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96094C61DD6;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 02 Sep 2026 16:30:47 -0700
Subject: [PATCH 1/3] mm: hugetlb: Track used_hpages when getting/putting
 pages from subpool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260902-hugetlb-subpool-always-track-used-v1-1-de1cd14bd713@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788391851; l=12003;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wbqSyhMI6dzMpDAelK9o12CP0bEKd0RZWUUuGXS5JZ8=;
 b=jEAb4yMSLDuGWrdYD9ZdQCoj7Wf/mmcrXgpyyl46iEvLdMe2w9MxyjEo1IvxRfUKZclWo6uOu
 50YDMznEm8PBqq9IW+bKTWguaUCJm1bLZBWCwiXrDmPLjtL7arHO/73
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 78C19C0003
X-Stat-Signature: rtr5b7hpg6ujf8f89kdn4tn3zam4r4uw
X-Rspam-User: 
X-HE-Tag: 1788391853-915676
X-HE-Meta: U2FsdGVkX1/hXzVuSZc8qmEJPe3E9fjfy/5Z3rzEbwvQ+NAKf4EYn5pheq7aSux7wMt7OX1Ira/45vAwI3Zc9YhKAEOprFPjEDemZ0y+cNiKKMKvRKbgy3wZA1SLiA9RR2k9cyjeCG+Oea2w4Etvqb1iA/jTkLR8InUDWgPu+/8Mh3nZOSir1319MftDuXGVBYOb9fGw+mQqt22/AmdyGXbw6aXAjXKvME3EsVWzkdnaHpyNc9D7EJvWnInWSQSR9FcusVtKNG5OAWuz7Xs7DU+hAhCiBHFRxSnl/8bOF0VtYCPqp56tR98+OKPgkyqaJX8OtjWNYSMfB6ruUMHnUwKZu8U07cOf4jiuqOoNYul/LsHCeImu29jC2Vv5Wad+jHrR90fS9XWUDKPvd/ynl33h6JcQOj7eq5WQ1vuXHYAuWmAISrhRw1N2Q1FTC00NhQczaryeZcqfB+l+CdLA+0a3iZhkeT9+5TaiXo76AgVNhJpiHn/qFpxpM+pXwCgNu57kfjfASaoiX6j3z4GprUhYUPuwuQYACVoUndFgwVVpDUX3I2cgAorzszIEXHWKua6p/njXSIIpFH0Rp5BAInE6+FKYhx/gDn3jdiCLrdMlo2CHILeniKpwGs7dmWAE8yRyKiw6dEhXqXToF1UmXH42SNlaBJwJ4MPCD2UpG4VVcsT6XMdNMtFuzMUSPLz2xka7lydC+vj9zCSfYT9JY//ifiC9dq55mNS3drqBpa7UXDJCxHTi/BHuvVXAxVg5jvGJ3CPHS9fOCrR4j8bZjE4xEHtIqqx8nPEMHVeVd0HsPgDTvNZG/C60zr34bqNWYHRHMRLA7D1ZNP7m9iVwF8q1gdK+Os5+jfJjR1TrTZ8FPEltXoF0y9HQt1QexZ8i1LvrXhWMBU5vt7nvy6rwutao9LaPqRURVniz3av+us3CD6XS1foj8EkmCuG2erBfAzCuKYWEQ720w8AtGcB
 AVJp4ZpE
 2BWu09RQIbSWGh19dtNmTirFgQgA6S4jQk0ZopW/nGDOrnrvbetQ8ZLKAU45ke83LMHs4Q7yXpyNVCvMTBr29v7I21ENpLbQp65rVxxy6dYlt6FWBu+2N74OUolBZQMGtwsU+ULlLIfZE9oCj86VwAmnk6xt5EOoDKR48B7sal2qCslTmRqvI6gNEyzya1NKouB6cW79WgXxG8LCTeX8BBAHhJ4Yn1a7Oa6qGZiMeKMB3Q/U/gO/9ZcVnhV9tFKPy/I/fuiHw+HhkEBYdBaGjc5QPgFDs0Ru5/aJUWhiOu+0qHlG2hVXRR9pd1e9VMkmhewaZbMoFybjfK7awYbbOuGXZTBL2ahOiKtazLb+w0h/QF6dPZCjvC7v5bfB7RrUkJKzR03y+yqWnmbOohPP3amKPDsCXsm6zr6eoJgkpq6puYhSHc4gtBOrOcAtZQ2zEVuGx+yXA9F8V3LzhgZGvceVz2Ilv3/jJ6K22pdwiYUE4iGZWqVnTW9cQljSj4hxyYAUWyaaoFvNa5bzqVf18RTnbtNnYQEZFeFckkcelfjGEtq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

HugeTLB subpools currently only track used_hpages when the user
configures a size limit.

This is buggy since when there are existing allocations from the
subpool that would have satisfied the minimum reservations,
hugepage_subpool_put_pages() will still restore a reservation to the
subpool. See below for an example of a false reservation.

In addition, the subpool is considered free prematurely, is freed, and
this ends up causing a use-after-free.

The fix is to always track used_hpages within subpools, which is also
beneficial in general because with that information, reservation
tracking is also fully managed within hugepage_subpool_put_pages().

The subpool always knows how many pages were allocated through it. Every
page allocated through the subpool increments used_hpages, regardless of
whether a reservation was taken from it.

Conceptually, now, every allocation involving a subpool uses a page from
the subpool, which must be returned to the subpool. Every page taken from
the subpool tries to use a subpool reservation. Restoring a page to the
subpool reservations only if the page was taken from subpool
reservations. (If used_hpages >= min_hpages, the page must have not have
been taken from the reservations.)

Always tracking used_hpages provides the subpool with information of both
used and reserved counts to make the correct decision for both max_size and
min_size correctly.

With used_hpages always tracked, subpool_is_free() can be simplified, such
that the subpool can be declared free if there are no more pages in use.

Also update the

+ Documentation for used_hpages in the subpool struct, since it no longer
  matters whether the used pages count against the maximum.
+ Docstring for hugepage_subpool_{get,put}_pages
+ Documentation to use active voice, and remove some details in favor of
  having details documented in the docstring

Also update statfs reporting. Previously, if max_hpages is negative,
used_hpages is static at 0, so returning max_hpages - used_hpages returns
-1 and is always correct. Now, if the subpool doesn't have a maximum
requested size, indicate no limit for free pages (-1). If it does have a
maximum size, report the difference between the requested size and the
number of used pages. This difference is always positive, because if the
mount does have a maximum size, hugepage_subpool_get_pages() ensures that
the subpool usage never exceeds the maximum.

Fixes: 1c5ecae3a93fa ("hugetlbfs: add minimum size accounting to subpools")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/mm/hugetlbfs_reserv.rst              | 17 +----
 .../translations/zh_CN/mm/hugetlbfs_reserv.rst     | 11 +---
 fs/hugetlbfs/inode.c                               |  8 ++-
 include/linux/hugetlb.h                            |  4 +-
 mm/hugetlb.c                                       | 73 +++++++++++++---------
 5 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index a49115db18c76..d244583fdcbc3 100644
--- a/Documentation/mm/hugetlbfs_reserv.rst
+++ b/Documentation/mm/hugetlbfs_reserv.rst
@@ -314,21 +314,8 @@ huge pages.  If they can not be reserved, the mount fails.
 The routines hugepage_subpool_get/put_pages() are called when pages are
 obtained from or released back to a subpool.  They perform all subpool
 accounting, and track any reservations associated with the subpool.
-hugepage_subpool_get/put_pages are passed the number of huge pages by which
-to adjust the subpool 'used page' count (down for get, up for put).  Normally,
-they return the same value that was passed or an error if not enough pages
-exist in the subpool.
-
-However, if reserves are associated with the subpool a return value less
-than the passed value may be returned.  This return value indicates the
-number of additional global pool adjustments which must be made.  For example,
-suppose a subpool contains 3 reserved huge pages and someone asks for 5.
-The 3 reserved pages associated with the subpool can be used to satisfy part
-of the request.  But, 2 pages must be obtained from the global pools.  To
-relay this information to the caller, the value 2 is returned.  The caller
-is then responsible for attempting to obtain the additional two pages from
-the global pools.
-
+hugepage_subpool_get/put_pages() use the number of huge pages passed to adjust
+the subpool 'used page' count.
 
 COW and Reservations
 ====================
diff --git a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
index 20947f8bd0654..ae1f1f31477fc 100644
--- a/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
+++ b/Documentation/translations/zh_CN/mm/hugetlbfs_reserv.rst
@@ -246,15 +246,8 @@ hugepage_subpool的min_hpages字段中被跟踪。在挂载时，hugetlb_acct_me
 被调用以预留指定数量的巨页。如果它们不能被预留，挂载就会失败。
 
 当从子池中获取或释放页面时，会调用hugepage_subpool_get/put_pages()函数。
-hugepage_subpool_get/put_pages被传递给巨页数量，以此来调整子池的 “已用页面” 计数
-（get为下降，put为上升）。通常情况下，如果子池中没有足够的页面，它们会返回与传递的相同的值或
-一个错误。
-
-然而，如果预留与子池相关联，可能会返回一个小于传递值的返回值。这个返回值表示必须进行的额外全局
-池调整的数量。例如，假设一个子池包含3个预留的巨页，有人要求5个。与子池相关的3个预留页可以用来
-满足部分请求。但是，必须从全局池中获得2个页面。为了向调用者转达这一信息，将返回值2。然后，调用
-者要负责从全局池中获取另外两个页面。
-
+它们负责所有子池的统计核算，并跟踪与子池相关联的预留。
+hugepage_subpool_get/put_pages()函数使用传入的巨页数量来调整子池的“已用页面”计数。
 
 COW和预留
 ==========
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a8470ea26..5113f743f6fc7 100644
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
index 16c4c4caa126c..4551ff3023640 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -39,8 +39,8 @@ struct hugepage_subpool {
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
index 7857728457952..66b6601abb069 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -130,12 +130,8 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
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
@@ -193,13 +189,18 @@ void hugepage_put_subpool(struct hugepage_subpool *spool)
 	unlock_or_release_subpool(spool, flags);
 }
 
-/*
- * Subpool accounting for allocating and reserving pages.
- * Return -ENOMEM if there are not enough resources to satisfy the
- * request.  Otherwise, return the number of pages by which the
- * global pools must be adjusted (upward).  The returned value may
- * only be different than the passed value (delta) in the case where
- * a subpool minimum size must be maintained.
+/**
+ * hugepage_subpool_get_pages - Get pages from a subpool
+ * @spool: pointer to subpool structure (may be NULL)
+ * @delta: number of pages to allocate or reserve
+ *
+ * Check and update subpool page usage counts when allocating or
+ * reserving @delta hugepages.
+ *
+ * Context: Takes spool->lock using spin_lock_irq().
+ * Return: Non-negative number of reservations that cannot be
+ *         satisfied by the subpool, or -ENOMEM if the subpool maximum
+ *         limit would be exceeded.
  */
 static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 				      long delta)
@@ -211,15 +212,14 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 
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
@@ -240,11 +240,19 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 	return ret;
 }
 
-/*
- * Subpool accounting for freeing and unreserving pages.
- * Return the number of global page reservations that must be dropped.
- * The return value may only be different than the passed value (delta)
- * in the case where a subpool minimum size must be maintained.
+/**
+ * hugepage_subpool_put_pages - Release pages back to a subpool
+ * @spool: pointer to subpool structure (may be NULL)
+ * @delta: number of pages to free or unreserve
+ *
+ * Check and update subpool page usage counts when freeing or
+ * unreserving @delta hugepages.
+ *
+ * Context: Takes spool->lock using spin_lock_irqsave(). May release
+ *          and free @spool if its usage count and references reach
+ *          zero.
+ * Return: Non-negative number of reservations that the subpool cannot
+ *         absorb.
  */
 static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
 				       long delta)
@@ -257,19 +265,24 @@ static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
 
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

-- 
2.55.0.970.g62bdec98f9-goog



