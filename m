Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D57B6C44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5156B0098; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1DE6B009E; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8796B009D; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F00C66B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 724C512039B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:12 +0000 (UTC)
X-FDA: 85011262224.22.E024908
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 73EC51A0007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t8H9z6J2;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602390;
	b=jmz5XU9s1Bxrj3DaDX2aG5YieEJChoANSwFKBUxwhVqOpgZ5bRZPmkrH/w8E2IQJXVj2md
	MYhswQPoOEBv3+Ugk5UKlA1jubTW12vDJX3pQgLz0+Phg5493gzReavM5nCKe6MV+xaP5O
	5dZhhHlDdvTiJJ3qxSmqqrvRbFIcx3E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t8H9z6J2;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CBGEvt4xSfpvU+uejJMga5UcqPWTyAD1dFDY4Ex52Vo=;
	b=O1f59TDS9vGk8XZH3kD75+JWY92jxncBTt+IOjD8yT8OsatE3wXFE0Ai701x2OQXY8G+po
	b6P4+iLSJVVvzHNdNfkg/+JMsVMclbvp/DSs+yubydVSXSiXbFjWtgKweimtcWx3gmFBhZ
	JdO2pJpK/Ke6hv+1uDv6dz4UsZG6slw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E08344034;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41D1FC32781;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=dQJa64TA7n7wPBuMQAm33gNRQMnt8IhQlLQye0FISNY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t8H9z6J2NlgIVtT1kugXvkDJmSfCnl/14OIJqMCSkY5iPUGGV5RRk2b+MHWBPTbJo
	 yyry6m/JVZK797uqnu8HKVDr1Xl42r2ISMOMd5VXjFgNBiX50jEE1ORfGgpDPjNyDW
	 kAAdqn0bVNdwa3uYLfDf1DNbklQXsAldsYGHhydTXSDoS7Q2/z9NC2W9pl5LS4FN7N
	 wxh7JQks4WkF6PacqhAlSTeKW4ZBrusHlS5NAy83+VGrWXGKSkkmxHmLD2XtTxcScz
	 J0MI1U3Uk7YpK6x9HNj973LLvA5eQb0CAl4V4wSoe02QoeD6n3XXObj//MtqK7gB4P
	 88E6ZqK3OhaIQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFA6C44524;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:10 -0700
Subject: [PATCH v3 07/13] WIP: fs: hugetlbfs: Refactor subpool getters and
 integrate with hugetlb_subpool API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-7-7d2a169aa9ee@google.com>
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
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=5388;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/bVMwhDzkKWXm/PUQ4Oz0DueIPwM1LmPE5uQODdNRt4=;
 b=e9KVJDUd1/O3E5VwDVW5E9FSn4k3+pT0IRfemqqYsyY5VfHIO+b7wVSj17bceSsnoRwaed+Zi
 i/0O5pqbxyBCVCbC2l3qDsBLYdKyysNubSNU1FyLXhC3GzBd6/ng4aw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 73EC51A0007
X-Stat-Signature: z8ty37azjps4xjf94kr1dtse9ju375ws
X-Rspam-User: 
X-HE-Tag: 1784602390-104022
X-HE-Meta: U2FsdGVkX1+ePwJz2aGMTcX0cuVZ2rO5W0MzJCcWDv4Nx0HkG+jDCo4BOiMfcuWBdIc0BWmEjsE15QzM5yMiCfcOlw/SsRw4zENga87fNUIRhFNu/Be+7bSjKdFt5TLe+FZO4e9jx+DIQ3Uvo61uIJqM1o+0Nn808Soaf7RR2EAFE+wvv1nQpHALkWXSbsxsHInuJOYiDLW/eeL7JdCdLhGIZjr6jwB+rU09uwlERc+T2Ycoy3fm70XTVCBIJeALTb562T1La/8FxziMb3BlllnBtRlexoOPpW0I7o4PQ5y3YXyxR6tKgDFoJ3xYQiysOQ8WVW8h8PyGtIksbUzuNI5SPRmrEIhmR4yJjX8jWF+veO+E6rJTlOcN9pRDJQJVGsR4nhOPDUtc1npZIW8LJrRs7ZxIDBPrBDCt1BnfOjbCzaRlzSaihi85PDhdM7YkV+22tAySJXin75cQIz7M1OXnai+ORtywfsA1k8V25uY3joumwVqdsP3vfGJXFvTLRzmB5ER5nPPlFGBF82au6LoYtUcty8VM5NE9FobJXxSrEuXzJUxdGBt/ukLmksasA/Od5YvvWHkf7UMd7qhsLBiIKQIuu5fd8oAPQQwEi0dHkeyV0GXgTo3OK95m6rMRbktXuXxsU+w8F9HxvHyiTtOKcbzFp9s9/KCIWVuTwB5LQBgWgIMPZyRL6eWTHJ15G8eom4UbUWymV/kQRM1MIua34Vyq0G25z9SqI0RheB7m2vzFL+oH1VlgwzCw9J5bykAllWTcjwmUVS85poMJZFh9S2wmCWR/E73DsY/WCT0GovOE6vHdt9E5McA/C432hZ3MfIM4Lh78opoD/Uo69ycf+5luEkg8+xp160WA5ApT6iWHDu8isNRtaivkHcvfYvvY8yvRHGdhBmAxePY6Yef6PNsyrvmZRoHY/61jWzQ+rqv2NiUskZoU3TgQWKGCE4FCPysBgA2xXRHxSAl
 ujxyq16Q
 8lAd3rD82L0uwxS1H8Fy7bYKwl0U2+f0+p610S3S6nmHaSXkayz2guPUmLRjDOcYAIqNxBcAWZ2zU6mbPZ9dlQcPxLsh9lrYtBXW49cVX6sUObmh59CRQ+UCTyW0AL7o3UgzGBBhm4ZJhDo3XQKQVSAyoJxqOSkkMxsL1T0YdIDPiJYQgxpl+M/RAGKq0/UKNkOap5E+l7PUZTsM3p3CdezGb4AKHbSH1cyAYK+yX5O5pg3G8x0ny7L980AEOKzmGhAvFTd6R34UCWVUel2ZJBoCN5Frkj23Glyol5u/YaKKzB1cNSKvMkC1dwzXsiq9MamVSupvuLvfYUsznwb13Uxxf+spmDranvLUI+ZATnhnRD/ndI62fPZcCKfhgPX7NB3VmEc2Ljf56ULGeXrTs9LQJUuq+BQ5lKbvs28mFjRXn+6mWXZlEFkolMLK783Lk97bpD+d50hyW4LLwjNVLNXSq3QYg058P4eSudyQbf0dIgt8JiwUI+YEwpKTX5kE92U6dKX0XRZUx6XHJm3qM9UVAbR4kmjMCwVCl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Refactor the direct field accesses to `spool->max_hpages`, `spool->min_hpages`,
and calculate subpool properties using dedicated, encapsulated accessor getters inside
`mm/hugetlb_subpool.c`.

Introduces and exports the following harmonized subpool getters to `mm/hugetlb_subpool.h`:
- `hugepage_subpool_free_hpages()`
- `hugepage_subpool_max_size()`
- `hugepage_subpool_min_size()`
- `hugepage_subpool_max_hpages()`

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c | 28 +++++++++-------------------
 mm/hugetlb_subpool.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/hugetlb_subpool.h |  4 ++++
 3 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8c1caad74c409..8abe0574b1c7e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1060,7 +1060,6 @@ static int hugetlbfs_show_options(struct seq_file *m, struct dentry *root)
 	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(root->d_sb);
 	struct hugepage_subpool *spool = sbinfo->spool;
 	unsigned long hpage_size = huge_page_size(sbinfo->hstate);
-	unsigned hpage_shift = huge_page_shift(sbinfo->hstate);
 	char mod;
 
 	if (!uid_eq(sbinfo->uid, GLOBAL_ROOT_UID))
@@ -1082,12 +1081,13 @@ static int hugetlbfs_show_options(struct seq_file *m, struct dentry *root)
 	}
 	seq_printf(m, ",pagesize=%lu%c", hpage_size, mod);
 	if (spool) {
-		if (spool->max_hpages != -1)
-			seq_printf(m, ",size=%llu",
-				   (unsigned long long)spool->max_hpages << hpage_shift);
-		if (spool->min_hpages != -1)
-			seq_printf(m, ",min_size=%llu",
-				   (unsigned long long)spool->min_hpages << hpage_shift);
+		unsigned long long max_size = hugepage_subpool_max_size(spool);
+		unsigned long long min_size = hugepage_subpool_min_size(spool);
+
+		if (max_size != -1ULL)
+			seq_printf(m, ",size=%llu", max_size);
+		if (min_size != -1ULL)
+			seq_printf(m, ",min_size=%llu", min_size);
 	}
 	return 0;
 }
@@ -1106,18 +1106,8 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		/* If no limits set, just report 0 or -1 for max/free/used
 		 * blocks, like simple_statfs() */
 		if (sbinfo->spool) {
-			long free_pages;
-
-			spin_lock_irq(&sbinfo->spool->lock);
-			buf->f_blocks = sbinfo->spool->max_hpages;
-			if (sbinfo->spool->max_hpages == -1) {
-				free_pages = -1;
-			} else {
-				free_pages = sbinfo->spool->max_hpages -
-					     sbinfo->spool->used_hpages;
-			}
-			buf->f_bavail = buf->f_bfree = free_pages;
-			spin_unlock_irq(&sbinfo->spool->lock);
+			buf->f_blocks = hugepage_subpool_max_hpages(sbinfo->spool);
+			buf->f_bavail = buf->f_bfree = hugepage_subpool_free_hpages(sbinfo->spool);
 			buf->f_files = sbinfo->max_inodes;
 			buf->f_ffree = sbinfo->free_inodes;
 		}
diff --git a/mm/hugetlb_subpool.c b/mm/hugetlb_subpool.c
index b12c16aa7e4c5..99e7975911079 100644
--- a/mm/hugetlb_subpool.c
+++ b/mm/hugetlb_subpool.c
@@ -12,7 +12,6 @@
 #endif
 #include <linux/spinlock.h>
 #include <linux/bug.h>
-
 #include "hugetlb_subpool.h"
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -41,6 +40,50 @@ static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 	}
 }
 
+long hugepage_subpool_free_hpages(struct hugepage_subpool *spool)
+{
+	long free_pages;
+
+	spin_lock_irq(&spool->lock);
+	if (spool->max_hpages == -1)
+		free_pages = -1;
+	else
+		free_pages = spool->max_hpages - spool->used_hpages;
+	spin_unlock_irq(&spool->lock);
+
+	return free_pages;
+}
+
+static unsigned int hugepage_subpool_hpage_shift(struct hugepage_subpool *spool)
+{
+	return huge_page_shift(spool->hstate);
+}
+
+unsigned long long hugepage_subpool_max_size(struct hugepage_subpool *spool)
+{
+	if (spool->max_hpages == -1)
+		return -1ULL;
+	return (unsigned long long)spool->max_hpages << hugepage_subpool_hpage_shift(spool);
+}
+
+unsigned long long hugepage_subpool_min_size(struct hugepage_subpool *spool)
+{
+	if (spool->min_hpages == -1)
+		return -1ULL;
+	return (unsigned long long)spool->min_hpages << hugepage_subpool_hpage_shift(spool);
+}
+
+long hugepage_subpool_max_hpages(struct hugepage_subpool *spool)
+{
+	long max_hpages;
+
+	spin_lock_irq(&spool->lock);
+	max_hpages = spool->max_hpages;
+	spin_unlock_irq(&spool->lock);
+
+	return max_hpages;
+}
+
 struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
 						long min_hpages)
 {
diff --git a/mm/hugetlb_subpool.h b/mm/hugetlb_subpool.h
index be1f1cf012c9c..41d22239f2c3e 100644
--- a/mm/hugetlb_subpool.h
+++ b/mm/hugetlb_subpool.h
@@ -13,5 +13,9 @@ struct hugepage_subpool *hugepage_new_subpool(struct hstate *h, long max_hpages,
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 long hugepage_subpool_get_pages(struct hugepage_subpool *spool, long delta);
 long hugepage_subpool_put_pages(struct hugepage_subpool *spool, long delta);
+long hugepage_subpool_free_hpages(struct hugepage_subpool *spool);
+long hugepage_subpool_max_hpages(struct hugepage_subpool *spool);
+unsigned long long hugepage_subpool_max_size(struct hugepage_subpool *spool);
+unsigned long long hugepage_subpool_min_size(struct hugepage_subpool *spool);
 
 #endif /* _MM_HUGETLB_SUBPOOL_H */

-- 
2.55.0.229.g6434b31f56-goog



