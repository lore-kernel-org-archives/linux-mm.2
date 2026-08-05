Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1288C55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D236E6B00B6; Wed,  5 Aug 2026 03:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9C86B00B8; Wed,  5 Aug 2026 03:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FF96B00B9; Wed,  5 Aug 2026 03:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9876B00B6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:55:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46485A19B7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:55:35 +0000 (UTC)
X-FDA: 85066456230.16.28462B2
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 99A3C1A0002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:55:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GLgVwNRU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbfFddbqSLBXoL9Z6NQe5+gvAdUEfreYVifyxE81zg0=;
	b=14pKrrkqfqLh1zXwKI+50SCe0hSmesTwCs4QXz7OaHWbg3nHNOcoQ0IS9sMK3RYnXS52zX
	hGG70UQ9jwPZD0kkWbGF2ClIwqRYB9tMCI1DWRTOVvGonIu3ApYnvmfz9I88tfVs+mmh3Q
	8sq9Q67rAhYheFmNjnjSM4ZOnpPyLgo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GLgVwNRU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916533;
	b=rquaz2cikPyTXdq+hu6bDtmBXXhi+211fDDKhae/3Zj/PdusM0LpkXk3RmBaYvy3e+/WUj
	UYVB2moHsfNnvVG2zf0aNjs0hI8khFnEqKNUc5s+8ZHRj+3p9WXIbztQiXNCeDorPm2ddD
	8DFafaJ0lm+ALuXjdZXiMM8y14fNPBI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EbfFddbqSLBXoL9Z6NQe5+gvAdUEfreYVifyxE81zg0=;
	b=GLgVwNRUwiBcSuY7U3D9LcolFHX5qp94+NHSDFNCWLyiNOSj/IDuA2OtulWLjCHMnDp0FP
	GBcfFr+2W4RrKIkXygjMqYPSkVmDYXphGEoyWSvWVXWVH/H8YIKDRPjIo6WiWBaP2iyTrV
	FpdB/Tm+iQCJEZO94Gpyn5ghqq5yloA=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH v2 10/10] mm, swap: defer xswap shrink to workqueue to avoid lock recursion
Date: Wed,  5 Aug 2026 15:53:33 +0800
Message-ID: <20260805075336.3579395-11-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99A3C1A0002
X-Stat-Signature: y3hi7hr7zekehbzz5tatmi9nrr4r6rm5
X-Rspam-User: 
X-HE-Tag: 1785916533-81358
X-HE-Meta: U2FsdGVkX1+uSD7PPBebEwq2FCYu6y2EpX9rerxErhVbLwPvNwhSrmPacZfPFbzAY5ikLjMUIcBnURqYf/fjhiY+pXyyqMeXcOTkCfS7u7tYglNUMLvMIVhMnBXqZZ8h4Mqfdiq9jaV4fvjAxDHhdVc6UEOG5FQtFG9e0j71maEXHncl1Zz7bcJbBqCe2HUxvK8/hhZa8miyqAAnumcLTEXyNuCY1bXx2arr7D4L4Z+uTpFk/JZwIQWrhSmjRY9kbJKoEQ6AQ4mTqEDUb0NQm8ea3NwkV8C0w6NkNhxC3ldlfI0iHg1a3BdeldWNYiT0PQgDRTJqNhqEAmB2iexcxCEVyh8cDuFQMPsUluvDdsaQPyZ4jQf/TcFdSbQ/fgOVcS+haMJ4KEnYPQZVggd6SahzvbZ9qwqXu9wkn4kdlqonaGhQRbtU/bu++DD/SR0G5HK+gphwG+o1+1kY3J06oMbR8w9YfCd23Qp3ib0hjYj/179rCw50W92Ls+BUv/SgRbD8DQnhM9MMveDT+K37wEOx0uVUIj/DGf4K9TO8v4RAcYtNYs7cDH+MUztzUmzpcardvw7L78WFn/cAV837l0ftTNehICyU+BLVNhsze4cpwpEBiqlwgceNxx5UKGiRMcusrqk9oWDM0i3kpIHLtZHahhi0lsZrT9M97Vr9EMzWBAbePAsI8/TLpQ+yCpaNhUqOzfolDWytSuiSw/wGoyinor+sGiYlV6oMWPg2LmzAeHsLZilN6DBNw7JU+UZWsxMmNanHesIl9I5ocN8N+F2eejnAHEStGMqGjBfxkskHSuitXF3IOQ6nUFwliG4/7iakSP2aXivZB6i1xWbjHY9VDyoQZPrZivekocvhe53+FyB+D3G4q0toXSdvD5EOTwwYCT1Pqk6ibf7zTurcprWk3gKOylNLhUNmFmVPwnAU5f8dF3WGjSR1z0tOlwCrpCzkbRDnHzYJMsYNk8C
 bf4GjerN
 +Sh2CXBCNqmW0ZAr37g/34jgTm9agPl11T1+eLYRmgOTgkJBFuOHEpDigPkPlmHbrIyXE3RO6KL5V2lKJR0QgDubVB5eymony0LagW+MuvtN6leqy3lJCYd+zpFRjnSgFd4v88IWv8LfY3w7p3Fm2TzmZTEEZtMvLAylAZQ0GJUegP/UrMq6zzB5DpjfdhwxrkkrsMy1GEFLRz0nQMdJ8R6O2tfOGZvuqwBY6u+0+fc3VWE76I3+o78Ale7nT7w8scvx+lSWyvqSdMF+Yrba2hg1lIzq63kgcB3xYGixyF1gkz2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap_try_shrink() was called directly from __free_cluster() while
holding ci->lock.  The shrink path calls xswap_unmap_clusters()
which unmaps vmalloc pages backing cluster_info, and on return
swap_cache_del_folio() tries swap_cluster_unlock(ci) on the now-
unmapped address — crashing on a not-present page.

Replace direct calls with schedule_work() so shrink runs in an
independent workqueue context where no cluster locks are held.
Use cancel_work_sync() during swapoff to ensure no pending shrink
work races with the VM area teardown.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f4583f9a4e5..a5b323374769 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -255,6 +255,7 @@ struct swap_info_struct {
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 	struct dentry		*debugfs_entry;	/* debugfs: type<N>_max_clusters */
+	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 265f2bac1a12..ca406556626e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -127,11 +127,8 @@ static ssize_t xswap_max_clusters_write(struct file *file,
 		spin_unlock(&swap_lock);
 	}
 
-	/*
-	 * Lowering the ceiling may make tail clusters eligible for
-	 * shrinking.  Trigger an immediate check.
-	 */
-	xswap_try_shrink(si);
+	/* Shrink trigger: lowering the ceiling may free tail clusters. */
+	schedule_work(&si->xswap_shrink_work);
 
 	return count;
 }
@@ -726,7 +723,7 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	ci->order = 0;
 #ifdef CONFIG_XSWAP
 	xswap_update_free_tail(si, ci - si->cluster_info);
-	xswap_try_shrink(si);
+	schedule_work(&si->xswap_shrink_work);
 #endif
 }
 
@@ -3236,6 +3233,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 #ifdef CONFIG_XSWAP
 	if (si->flags & SWP_XSWAP) {
 		xswap_debugfs_del(si);
+		cancel_work_sync(&si->xswap_shrink_work);
 		/* Unmap all mapped clusters and free the VM_SPARSE area */
 		if (si->nr_clusters_mapped > 0)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
@@ -4057,6 +4055,13 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
 		WRITE_ONCE(si->nr_free_tail, nr_mapped - idx - 1);
 }
 
+static void xswap_shrink_work_fn(struct work_struct *work)
+{
+	struct swap_info_struct *si = container_of(work,
+			struct swap_info_struct, xswap_shrink_work);
+	xswap_try_shrink(si);
+}
+
 /*
  * Try to shrink the cluster_info tail.  Uses si->nr_free_tail which
  * is maintained incrementally during alloc/free — no scanning needed.
@@ -4163,7 +4168,9 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
+
 		mutex_init(&si->xswap_lock);
+		INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
 		xswap_debugfs_add(si);
 		return 0;
 
-- 
2.54.0


