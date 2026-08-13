Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1785AC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177766B0288; Thu, 13 Aug 2026 06:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128276B028A; Thu, 13 Aug 2026 06:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E566B028B; Thu, 13 Aug 2026 06:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4EF26B0288
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:50:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 700E91C16A6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:54 +0000 (UTC)
X-FDA: 85095928428.18.411DD63
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf18.hostedemail.com (Postfix) with ESMTP id 862FF1C0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618252;
	b=4ZVTLYfBbcmD1K3162yonJTeSHu1xDBqOBOF52V00QcfWUSdjQdha7KQxeUEPJrWhICiPb
	PGdOKJXvG06UGSOpXu/E/I+U+IEuh6chtrOTtniUiScXxfHXLmlNJ4+Cax/NCO9RBb62ur
	ZHJ95frj8UtGsC/Wr0hUN6RmB4rdkWI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJM+gNkJZDEtNrDNvPUb1yMvPB9OP5TGYKJBu8udzYo=;
	b=GSJCZLh8uMy+NevII5PqA92EGc6tI/P4nDAJhE4pVrtgei/moT0+/jOfuE255kTr/NOMYy
	YYLkGlx3sVeXY+/l2z67cg83Vx/gvMKHLEv3Ft7Ef7StOfyoChTE6ub1FPJXZxjKhOIYGT
	wLdhNlkYOrlaaIZZCIp9JoT8Ky7wVrQ=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 36e88a40f772f975;
	Thu, 13 Aug 2026 10:50:49 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 13/15] mm, swap: defer xswap shrink to workqueue to avoid lock recursion
Date: Thu, 13 Aug 2026 18:48:52 +0800
Message-ID: <20260813104857.3450386-14-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 862FF1C0006
X-Stat-Signature: pax7uuucni8yewsuhwt4613sb78sk1e5
X-HE-Tag: 1786618252-610830
X-HE-Meta: U2FsdGVkX1/wHjRLKiCCZzLLonGXgOTVoJFTWaWRrSHkDSKE9jC5n67K1jhbq8N1xyUchfoekMchNTCwlPq85a6VTjfhe8JFNHASbpQywo57YZRQt+vwPDNbwb4RCOA60CyuG4lgn8hI0EXyGhw5SYSH4zL3MlzvkM4TvmUCTfyEY30omMwcBiEmefvKw3gu4gMjBUBSrZoHtcf+R27VMRGqdtt+Lht/cfYOpfiX/A6qcR5uLBuQCsuNSswCvStu3Q+pBVZ+ODI2/LtStq8NW2k4Kh3fGSx4j5ctzZcTJ2zSakb7swx8I0iT5MyY8dSWDyjK1A2AXfR+zFngJ/8snWsUtuVb3IUUDRQU75bAJniLekX3n6xn/vNYlbjmC8IvcO5/FXz2X+tZc+s/OsT4m+agDZakEt/G3BZbeeaYkqbHaE5/mas2y1nzRyTu8Iz2MD1vh6c8NiJ1yuY4bWccJF22nRUB7uW+zxJCkEYKVPAV1YTDcHKbSmSGrkCyN/7YjNdKsuqMJzMWra41nNyMoTKuo82gQk1XxAV9hwHxneCjeZNjoRyEJjO++M0Y7M/B2RQyM+oGz4AukQD2MWrbrgzvUvuTaUdFyOe68/wC9YTO5ImXH7BQs8TtobHfCy9cat+gaZk0AQiwdgR6rgdZE76jk9GIP1nXu1p5VG62sMkLUymrKl05DqE1nsO8TyOwirB0JlXc3UUxdLZhKTVrHidnxxKsbR2esfFAXAb8hQAO/kS8k249JMZHbyauwA8K13HVXTqJwiOjyoAmMKqo2lKMx+u1V67EY/1r8d4fixqy+xPfG0OL6IcepSxpefIybfZgOMq4PktDgwns9p/jf/VNKFcZa1Z+J5TKL6J9cQse2NUSxz3IzFVu6/M9yermfneNg8sYRMXgED2EoJahYAuDsXOoDbnYXvA5rtbXEIOkrFUP8gVymHIcyCihVi5md1+vKzwai3aRxQEIyEF
 JV7c7M43
 29iWOmBsdmWqzLVIPXRWFnUxZh91pPxQ9XbV6n+b0v3lRtw2n6OVbvbKbSeeJoFheqUQcYj6Xmbr+1vi8jpjKNMIZhLb3HBk3zxzcOG7zx03zmRPp0lnOLL4fi1Z/Wx8BY6KcReZb6L6N4bMlSlL/prjUG4ZMGSCU6SfFwTNnTWvlTYO89SVvuFBC+XD/v5CfM0ytLiVyVTfl6kyYskzB66ivfQQZ2DFQt93cKwWuAONxyIIKSGWZDQaYeh6NSkHg3dnoo5u0aAkUQR0EZU0XfkDXEO4pIBvEJkhWR+lXNwd+43e8LTO0j2l4b3phX3iotSqGw64Lt4QAlv1qKjKmMxlYk1H+3tRP4j1TPeKDJ+9weAGU0aXw+mbZUTBOkBA67891xK26jTo/3H8udAZxWzeSzOFvjThuTlC1xuvrfAoIA+/qYvj4mhxXw+IX91Cpd7nhi7DdG2PAAvbkHuqTnCTvIg==
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

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4d8ca920d2f9..d3a68bd45c82 100644
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
index 2755a549582c..aa83a76773fe 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -786,7 +786,7 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	ci->order = 0;
 #ifdef CONFIG_XSWAP
 	xswap_update_free_tail(si, ci - si->cluster_info);
-	xswap_try_shrink(si);
+	schedule_work(&si->xswap_shrink_work);
 #endif
 }
 
@@ -3305,6 +3305,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 #ifdef CONFIG_XSWAP
 	if (si->flags & SWP_XSWAP) {
 		xswap_debugfs_del(si);
+		cancel_work_sync(&si->xswap_shrink_work);
 		/* Unmap all mapped clusters and free the VM_SPARSE area */
 		if (si->nr_clusters_mapped > 0)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
@@ -4075,6 +4076,13 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
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
@@ -4190,7 +4198,9 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		/* All mapped clusters except cluster 0 are free at the tail */
 		si->nr_free_tail = si->nr_clusters_mapped - 1;
+
 		mutex_init(&si->xswap_lock);
+		INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
 		xswap_debugfs_add(si);
 		return 0;
 
-- 
2.54.0


