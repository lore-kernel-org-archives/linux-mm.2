Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9E9C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D706B00AA; Mon, 27 Jul 2026 10:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF48E6B00AC; Mon, 27 Jul 2026 10:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0AA66B00AD; Mon, 27 Jul 2026 10:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A20056B00AA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:06:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EBB18075E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:52 +0000 (UTC)
X-FDA: 85034732664.13.D012B88
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf20.hostedemail.com (Postfix) with ESMTP id 355651C0007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xL1htqHG;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwPLUDcYtzirJbTxv7cVnoW3Ob/U1PfUpNFV/nBTnqo=;
	b=wtjG3rLqt813qBR4cDE0CVzVmHjr28I9A/H8bL1Aw3gkqJdeRfkRIoKbqZq34w7csjcfpS
	2N8f3XUrYO6CRKN6MaLQW0IVaNlY9Ehp+NXSjBHKt8vniqwJcqu9Id2pYUgzYViTNmm4Uc
	0r+99/PMqV0iZCo/81kRnXruiQfvook=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xL1htqHG;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161210;
	b=HHDJR4HhGLsjUC3fh0mrCRQyMOxdrUnLLXQtksyCkogJmdBT1DMgQ1QI7QX0eFXsYJC2YD
	MrK67QNoNeQrRCzKu8fq2cfRzaPYZYA++2Czuaad28XwTP6Hhr0HQYPoFhJqUjBVu5Pqey
	YoomHtYXYy3uFwUjd0k/3+urXIaDl0w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IwPLUDcYtzirJbTxv7cVnoW3Ob/U1PfUpNFV/nBTnqo=;
	b=xL1htqHG48CwyZbQnfU77hWkxzflKln+ZJeLE8qKJdsAz0dpvUhRxaEqk6Z+Omk+w4ISN8
	j9kMjG78FSyg1JZJjxBgPVAYM7QgZYRLs3V0f7lSG+08H3+kZix6Dq7cJEXOL3qKpUuLeZ
	No9LYhDp61B7VrF9xPvkNRh1emhNu3I=
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
Subject: [RFC PATCH 11/11] mm, swap: serialize xswap map/unmap with a mutex
Date: Mon, 27 Jul 2026 22:05:02 +0800
Message-ID: <20260727140503.1060918-10-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 355651C0007
X-Stat-Signature: tip89dqpxcgwyjcozb4zrbb8q8n6dq9y
X-HE-Tag: 1785161210-653803
X-HE-Meta: U2FsdGVkX18Xajxn/UwSISs7i5GBIXbzhL9D5DouyzvAFLMY2eKkvTLgUii5M2v4/lRtWrGDr71BRuF5CYqLPOJWu1/BAq0UfQgKVCjxWh8RdrNmjDg2F+PXwam496ESzhM2QrRO4hrXNPhVCz+oIPhUlrV7uGd/GYoTgDAhluPlOq4uO2B+OvxeIDiv9ehqig5J3+68/Moxif0kwzgG4ddgxLpY5RA6ivc8+XC9Cyq4fXiN0lGbykUlkHaft64BUx79CKObHYGoE93qiWjn0id7uNz9EGVN3h6QLWSpMY/Wk/uu5Dt6A1F2gmg7EhHgC+GyiY+6/0u+B6r9Cv4xPlxmUOgDNl9Oxc6SmK6xj+ntb2WI/MWIzSyMrlbhvJmCB9CYZdpvqiwG6EQiD0xJE8DZoTBUHDY53u1VjgCv7Km0vrWUHG+/xBisndpW7RroCOeebAPKDOBKhUY3T/q2TY6KM2CdWBUw5cg4hw13zYeUCLyWjBM779g6+4mxl9mn6tZq9MqNyr6qzx3grD3oEQK1a33W6rJWX2gYH0jncAte2jLcRQOoNgGlUN1tMQgVnibxl7D0+FFj99GyRejMKkCpasmsXgTUsRalqfnLCbkS1jZeU9iLI2NoJLOpokp42moGrOEdjpQFnIBU3k56s4RbEa0dnreJsrXpX0/5B5MvemEwoNECZEE1nxgYcPZFIlJmeyHz6eZXrgnXPZO2yh1dK5fFT3zCwaqMOupteuFo01+0x7MrSbTB9miLtNXg3Wviy0bvGyCZd+97hst7G41zsGH4RKEzihUhkAok8nRrAuVunCp3dvKPP+vBkos7I4JCK6Umicpo9fuRQ9FOSa/Ht+x4GDKoY/BhPKe28BRhvKZxoqeC9S+kOqbtGeN6g8sFt0qaz3vsMJJDAk75cxyyB8RssprNt+bdHfga4cI42Jy9xd4qRFaQxuPLXLLvZ2zuKyx0YUoo13DI0jy
 980Pq5C2
 ONvFiA3rhDE0pr8ZRU2bUpvtn7psp62Vu87BsY/KU9CzSGur/0+p2ydSqp+UBKew6YfemBIAGkAPF7LqS2vS98IhOy4NJQBQyiiR1sOTLRG29TpVZlVxDZRMGa99TJ9t3mOmHt/0IblHcwByUej4ARRWTv904zpjLnf8UaV2yQRky2OcsSUT3pn0IZESAAAxMZxDj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Concurrent xswap grow operations race on vm_area_map_pages(),
triggering WARN_ON(!pte_none) in the vmap page table walk when
one thread sees a PTE already set by another.  The -EBUSY safety
net catches it but the warning is noisy and unavoidable without
serialization.

Add a per-device mutex (xswap_lock) held across xswap_map_clusters
and xswap_unmap_clusters so that only one thread can modify the
VM_SPARSE page table at a time.  The shrink path is already
deferred to a workqueue so it does not contend with itself.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ebae01fbd100..b0fe0475bba7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -256,6 +256,7 @@ struct swap_info_struct {
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 	struct dentry		*debugfs_entry;	/* debugfs: type<N>_max_clusters */
 	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
+	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b41ff2c594fc..89c6a6b03a9d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3773,11 +3773,14 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	struct page **pages;
 	unsigned long i;
 
+	mutex_lock(&si->xswap_lock);
+
 	if (vm_start >= vm_end) {
 		/* All requested clusters fall within already-mapped pages. */
 		for (i = start_idx; i < start_idx + nr; i++)
 			spin_lock_init(&si->cluster_info[i].lock);
 		WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+		mutex_unlock(&si->xswap_lock);
 		return 0;
 	}
 
@@ -3842,6 +3845,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 	 * Pairs with READ_ONCE() in shrink/grow paths.
 	 */
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
 	return 0;
 
 fail_nounmap:
@@ -3862,6 +3866,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 		spin_lock_init(&si->cluster_info[i].lock);
 
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx + nr);
+	mutex_unlock(&si->xswap_lock);
 	return 0;
 
 fail:
@@ -3871,6 +3876,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 			__free_page(pages[i]);
 	}
 	kfree(pages);
+	mutex_unlock(&si->xswap_lock);
 	return -ENOMEM;
 }
 
@@ -3910,8 +3916,12 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	struct xswap_page_data xpd;
 	int i;
 
-	if (vm_start >= vm_end)
+	mutex_lock(&si->xswap_lock);
+
+	if (vm_start >= vm_end) {
+		mutex_unlock(&si->xswap_lock);
 		goto out;
+	}
 
 	size = vm_end - vm_start;
 	npages = size >> PAGE_SHIFT;
@@ -3937,10 +3947,12 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 			__free_page(xpd.pages[i]);
 		kfree(xpd.pages);
 	}
+
+	mutex_unlock(&si->xswap_lock);
+out:
 	/*
 	 * Pairs with READ_ONCE() in shrink/grow paths.
 	 */
-	out:
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
 }
 
@@ -4142,6 +4154,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
 
+		mutex_init(&si->xswap_lock);
 		INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
 		xswap_debugfs_add(si);
 		return 0;
-- 
2.54.0


