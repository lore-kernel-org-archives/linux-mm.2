Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B614C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089156B00AA; Wed, 22 Jul 2026 19:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E9F6B00AD; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E426E6B00B1; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92DFF6B00AF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB792C0381
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
X-FDA: 85018036530.04.A37AC78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E94341C0007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+SxcELL;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763684;
	b=6fWZs8fs6Q1jwNgIb32wEtrj+rAX1Kfk1yTi1k3yIbyEAS1wFiVtay4bTZhgYUlADXFQnO
	5ZS9pfugjmWRMNDsijPc0Mg3TVnqBrR6C7FwJUbAs59+OozUc3q0l19QxacgVlTTGUBL2W
	APXcqAUO+1ef1IxsgoUarIIpnY7jpdc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c+SxcELL;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763684;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JL3nOHHJKwIgaFRgCaZ0FAH9HasZ1/6Bh9fPtiAi3LA=;
	b=zbIyucFt8sGQuTrqeGik8Ars83wBlikItxDpaY8/ct+E0eqo/57bmlyVnOMDd7vWlhkuVX
	batAS11/1+3P+QM+f7flRq0juC6v9W2k2HY4gL44VytO8nr8SphHvNcFFCr3l7ACanaXE+
	Ihgov3p/EcibzBq53u6mkKDBiPi1ggw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A8CD45147;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79314C2BCFB;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=5/iRF3xNqMsJsR53Yn485u1SJJR2JsiIiVvY2SQNe+s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=c+SxcELLjBmZdtQTreWKXPNovxnW3u7q1JQ10iW2wkifkQmxpZYDgskte5XeqvBNm
	 PNrXcMFlRbxCeOEeollYUTgXaOl3GLV7G2H8Fow4XuQcOhzJunxXRuO6KG0AagMrXu
	 U/2yO8njKtb97sVW68BEkxcMQtnKs5m60gsRABH4Tt5jmGeZq81q95djQnIbeZRAoJ
	 iP38iUplPnQxQP+CCyoZYAOGksNwUFjs4DQEBDWTEh8YJ9W+q1VXmjCyoZOF7fGcfu
	 Uf6Txk5Errh4Ckax4kGdHZ3MrnORlhH94SCSjIxC5/EUzMu3Tfn7SPOkyIKT+WrEhK
	 NdtmrjAE0NuEw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67147C44536;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:18 -0700
Subject: [PATCH v4 10/16] WIP: fs: hugetlbfs: Refactor subpool getters and
 integrate with hugetlb_subpool API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-10-88e8b81970dc@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=5109;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Rr0t6FQpLc5GBEHSOpDNGxRyeiM/tB/HQxHFWvewyxI=;
 b=r8aum4myXhKIuGOvNFNRV2xnP+sRjMi82PJGF7WGGuvumuJvvLXs2oRu08WpAjRrptqeMPkev
 cpDbibmLIwAB3MMC8TVRLPb2o/yYixAdK/+t9iAz2EISXgaiFArJ1q+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: msi5kk9wajk613yy4i4y7yw46tp6hj57
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E94341C0007
X-Rspam-User: 
X-HE-Tag: 1784763683-151260
X-HE-Meta: U2FsdGVkX19xALy8wSLYq5uojpBp6KNVP7Bzf1qrLgl24OBhihzTy8cIMUMJHNy+9DH+WuKq8jME0FCTtFEvOuMwlUasDrdpPR10TRddPpOsHMH0brzB5HX02x5Z6YGAmiSC3A5S0O/fYPGG9B8lfO9iVMu8fbrXuzxNY3BH73wtUUI8kBlrT014C9ZDlF9zkTBx/MKrV1/UneLCQDbN91FqFP1inEpUD3y7xyYswubVxMJIJnd0LAqN5V8xz+85mue1k2fJUMo6FZJzyXEgfl/7SRf7P/7gxRPuPtNGgJFpGMjlnGNiF8opit1PobJFGhB8xOzgof6/zWjKcFlUk4AJ+beLdkvydfX+n8WIbMf1+V4h+UacvHUBKwRq7+/5xFWj5K5zKnv3S0wvv8iJAJMgOr2BJ/HQmfvH/g3ZUwvskAvdUF0EPJqOhTIUURbfD/Uhoipeg/tLunVfFGtHqNwCIPuyeqstafxX+5dFGe97+ps1nhpTMxN42Ry2UiMoCf3WnMgERf/m7odOi5xGhaA9Qj0fDHs6Fv9W4J4Hdwm8HOlvahm9DBY7QofvLnq9KqpksiYtSU8C8pPUha2Q7hBYwMpeytA0KZtZyoRvpPU1M7XREk9498na2H/xsGBBQCzQwrGAzhDJCfIyARo8l9hrzi0kRriY2hkyGx5GrLKtIMeUmBy8H1yT2LnqIyMYgRPI/N5AbKcdDYvgiV9dPN7SmkuDOHjJ69Q0In8lpszQMx37ZE5Ccr7GhdmGLgIplBiUV4PT4O91hcM2BKnSjttr3FnUbDqaCQ8zkblx63pS/Sfk7B+2rYeepSt0QFzIi5cPZRTXB/FD1mzMDYzW7qgKfaoAAc5oSjj3BBR4J2vyB1yd8242ZECH9Src2aWDjSnakY4GKJKwyLrYrqw3+RUS/QlGpjIAcyxZulr5PfOWDQijlAWQc1bEh62bGU3xszZnNCC9odClhKRR8Dg
 M/SIjorl
 3XNfC1xoHd07Ocx1NbD3jB7ixZKh+YeLfV+4qZjW3j2i2TZKcdHVOag5ndhgjPZaEurDNuEPYtncmr5v9//rhAlSiDHtfvBBWzw/B/FX0aPt+FSxibNJ6xdPxRfYe783skaYmOlIhvSp78u3V06/lgc8/8D1LVQnB/8PJstnLfcR20r6mKXdFhN8poZ6PB/m6Hr3Uy5O3ouKp5MrTsNhycjEaVLXnDqZgO02zYF+JnjuJPOwIYEFCUqRrOtJ/XrbXITuN8U3fBPq8kDojv2/ZIW/GYxEsqyb1GiPeQLg6VguEKje2uejHwDy1Uj0Eq5cniXoXecHVdaiXmrsc68igtPjkPLcnc24ahLOmrdl/aosG2ViIQt12lW41aexInjF+CVaA0e4IVSmDEiExSMDJwb17VXBjbQgdfkVVPP9Fxo09pUkSo5yDv/1JyQnezxiKOoM3KHB1BIW0hRKtMtfnnCiFZ47YCCXPLC4mBia4vcHqVQiGbwJXvIrtIhDSd36wzKXduxV3OyOGpL20/1pt51R5FEAjOA6HfxKR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Refactor the direct field accesses to spool->max_hpages, spool->min_hpages,
and calculate subpool properties using getters inside
mm/hugetlb_subpool.c.

This will allow the definition of struct hugepage_subpool to be
encapsulated and private to mm/hugetlb_subpool.c

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 fs/hugetlbfs/inode.c | 28 +++++++++-------------------
 mm/hugetlb_subpool.c | 39 ++++++++++++++++++++++++++++++++++++++-
 mm/hugetlb_subpool.h |  4 ++++
 3 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 86c21f8272470..b424afdedb3ee 100644
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
index 6184860ed7374..ac0f9057b4921 100644
--- a/mm/hugetlb_subpool.c
+++ b/mm/hugetlb_subpool.c
@@ -12,7 +12,6 @@
 #endif
 #include <linux/spinlock.h>
 #include <linux/bug.h>
-
 #include "hugetlb_subpool.h"
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -38,6 +37,44 @@ static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
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
+	return spool->max_hpages;
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



