Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A58F0C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8771D6B00A7; Mon, 27 Jul 2026 10:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8280B6B00AA; Mon, 27 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7684A6B00AB; Mon, 27 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 529AC6B00A7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:06:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7054A10DE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:40 +0000 (UTC)
X-FDA: 85034732160.13.EA728F0
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CB0E1C000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ol4EjBnM;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yGYb4251xen6xq86IV6E6mB7obBsI6jDmsaNtiaKQw=;
	b=zPGGzSMjsLO4cn/cddu7vafU3SCixK7gCm4yWssDShwsHt0KmcANmn/9lVKelsTQPUwGfK
	ceqL528fyxsaYYrJyLNSlRXyFzgtzGNbwbTFyLe8xQWA/5ogB7Er4jL51FHTyRGVSwrYm5
	UfdZh0R3QLkdiQJuEyYEQltJTYyPS1s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ol4EjBnM;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161199;
	b=VkA1J+g/JfF+Bl7gSxH+xqK0iCpihiwqJ5fxroJqNgjCVgziu4XluIuAQImxuy48QVbIYT
	1RpLoWRTAcLUUhCT489vrbqmG0rTDlGj4x/SvI0KuiX3UqDM1Oq0oRQ0qXRLWv3aadlcmB
	nXkIAG726uEowHfw/DeYhEqrPrRbe+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4yGYb4251xen6xq86IV6E6mB7obBsI6jDmsaNtiaKQw=;
	b=Ol4EjBnMG3jAVqaTNBrQNftF0n45q6z3fLWxqc8Mp8aara4iUzUCTVxMThAlxS640iHEHw
	LP1XunNzgeje1Er9j984M+KsfbsdxP1b0NUYKLD0QOxDCzu+1dV73d5Hl3AjLjxIQvdlJ8
	X42wigqlOFa6/7nrIdgszuh1/qKrRHw=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
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
Subject: [RFC PATCH 10/11] mm, swap: defer xswap shrink to workqueue to avoid lock recursion
Date: Mon, 27 Jul 2026 22:05:01 +0800
Message-ID: <20260727140503.1060918-9-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1CB0E1C000C
X-Stat-Signature: ymhfowccx6qt6csdssu1yju8h7osu486
X-HE-Tag: 1785161198-797548
X-HE-Meta: U2FsdGVkX1+A1NxGLVkhAbKPHyO3I+9u0+EzLZ1Wpk4qGX7fWWLzllrrzR7OExk1k/By2LUEpFpFRbkCiXvSpVECW2XK4e1BMH2mqf5wA6gISLUel15PpODlfKpDpnqcxcwvDv6cQ8bj2RgiZ9fj1LHSHxw+z1uSNkRBvaQlCulcvOqCPC7MimzI5fTJCN21saHe/cVQ/39PFQa2xf7UQZowDhL5hEL70q1ROD42LlKYwVxOjnkX0lltnbYLagRcDRQYelppktYuWz2CxGfHLS4OFOC01zPLeS0HFwewxczhpiDiy0ll+mYeUTMQsnu+xODBR7GSExg6qOJUCo4sVq0Imoazjx0IV+nZxogTqd2AOplHLOYzgusqb8F/qNFdo66OyHU7lSVdac8S/op6/FSAlXCzPGHqjEv2TCiXMdT9KExEKMIWDwu147SjzkjUTAUqg/eYed31hxmYZplzjLwN2gdNXtoe0vFt5HdbaMBWfB0Ux/hkj/el76892lgCJx16XpHoWyLKlJmcm6jfuP99ZI/nGPgV7h/nfw/Xn5rZ0mjNPyJZsJl67C7qzKzCj/KegKlEIgP+wgyd1uPKHTyLQ9p2jkwzk9qCiNihPhbYpRS00Nm4so7DPKq4R2qVPl5TdXdn50psrn6G9msH/UPYcnSWgTl7e36FpOQMgIn1BN8SJJY5f2U/tbWWNLekBZmmjTooPnPSSTmGnEFPoklNotHKqCzlIkF2X6EqXnJt1dnkdjtuuLmc9K/ZLY3N384DQmQcyWehWis5FyH+7qsxpibd+Ma3NrdxIlN7VgLM806OQ3G8vSkkf/BNFMYpcxuKOx9EL5fJlYeKsLqTkkvp0uG3jkkyHSZ1x+cmRMGeQ/1Ufncrl5VpYdYOjtoxznJAulEKYX+8Z0eoZWjSMIlTndXrmwJ+AsVhge6FWeLxUf4+5u6/SsOxcVNnjHi0bzzyyLZ8hcLYGyo7Vg8
 G6W6vOdT
 EHPp8DQhV+Z5E2WJxiBcqkMIQ00sABbdBtxVnrkXvQ2EDhlmbEVeQ1UsZJMriZTdQItX4k5NDA1hQLFyvVfo/7aqPVohoAd8Fh+lU6reMv8MNjikkJihwNNfIKoUTMWOJsSg7vOpmu5JXXmAW+quFGEnLxMQNf79iTE5mspL0CHUC0VDgxA6SbXgbfUHLtrIccaEUXTj45aT1zIkaiTZWU9bndyPZ1d4hcYGCbXvBVO7SVK1wYATHTYLePWgExPxdULW8sotVFLwQT/LXZjVhFySq2fbZ7N2P/uHPyNqXbD04DZk=
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
 mm/swapfile.c        | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ebcd5eaa7924..ebae01fbd100 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -255,6 +255,7 @@ struct swap_info_struct {
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 	struct dentry		*debugfs_entry;	/* debugfs: type<N>_max_clusters */
+	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index af62981506d3..b41ff2c594fc 100644
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
@@ -4030,6 +4028,13 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
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
@@ -4137,6 +4142,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
 
+		INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
 		xswap_debugfs_add(si);
 		return 0;
 
-- 
2.54.0


