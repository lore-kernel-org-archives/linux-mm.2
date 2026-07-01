Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A31AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A9A6B00BA; Wed,  1 Jul 2026 09:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D156B00BC; Wed,  1 Jul 2026 09:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA886B00BD; Wed,  1 Jul 2026 09:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 621AC6B00BA
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:59:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFF19C1B7F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:29 +0000 (UTC)
X-FDA: 84940365258.20.34ACC93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 222C240003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:59:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PSnLRdMb;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782914368;
	b=GXy7hwvfYG7FdspdkO363Srfh92zLQIYj8V8jCb7DudHhL6komjtOutJxfVRx9xI8jPHDS
	f7Uj1PAALGPFUh3VXnXYLkoqY/9zPBkuuykgtdYiPaWNH/Inuz9NWFTcfBM7bl78KmdG3W
	mH8xPWiuMo84hj9s8Lm20kHUIZEwGcU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782914368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCZadshr+DzQYVkCBh6cy/RM40zwNi0ZS4nnwSr8GpY=;
	b=QCf1CmmzGVDhvtDLDZBzD9RcTLfSA7pt3MAbcpak7oFhFx7zydQW+R2HteQ4Ii/ZXWR/Mo
	i7iHgrePDK/yf8h1yLtkYnCE/6HY7KEj9DqiZBENWIY4KYNYAA2yiDCojC9tIdfqCISQwR
	RRgFGjTGW59V7qToZlbs9NHtMCZx//g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PSnLRdMb;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 741C843FA7;
	Wed,  1 Jul 2026 13:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFB91F000E9;
	Wed,  1 Jul 2026 13:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914367;
	bh=nCZadshr+DzQYVkCBh6cy/RM40zwNi0ZS4nnwSr8GpY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PSnLRdMbR+/yV7sSYLzPyLddnesEXsHa1tBDjdiRgJT4rOf5OL2e33EkaPOeSrqBi
	 2Tm+z4xZD2lBf7dMRHzTrj5eWLbvtZMnczL8DW3YjVrf5XcEdmCe1VUGYmjF8mtOu2
	 eEeo1cVlB7kWz40qdftC/LKcS7vMHHQrrWEOItqbaKKl5qWlYQsxtbr19+jTMWYBcX
	 YvvLtr0f1Xki4tTem74NG014lbPR+AC8nABvleVYXXXWo+WN9hhZRT5RUWYHEF4+FR
	 e3yd5jNY7jeR8NpZCmx55WG12xLJJkCKLwlobeiFmfuG9Tgt0O2hm9njCVYAczS7Tk
	 9Y6YPGJE+O7Ew==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 01 Jul 2026 16:59:13 +0300
Subject: [PATCH 4/4] wlcore: allocate aggregation and firmware log buffers
 with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-b4-drivers-wireless-v1-4-60264cdf2efe@kernel.org>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
In-Reply-To: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Brian Norris <briannorris@chromium.org>, 
 Francesco Dolcini <francesco@dolcini.it>, Jakub Kicinski <kuba@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, b43-dev@lists.infradead.org, 
 libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: zw68f54c7hstjjb8dd13q469cmh4a8ez
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 222C240003
X-HE-Tag: 1782914367-369
X-HE-Meta: U2FsdGVkX19nHUjyM9Oz4jtBVCYJxbUenshDkxHkqxvaT9PQ+ibC9dQJ9TIrTn2XM1vZM7uRgc9UkRwZWqAFc8iJH9taY5KI8800esBv20jZFlJcy5yQeDGL4d9PKVxV+4fFWIBLwHLamH5g5/Os6w7Bm/QGOUona06LY8GPR9ZmmyPJzxfYIKDkiJR/8mJ5Wx24/dUQbwjBato1zRYgc8sCjtOXLNCdIpEZDmsNul5ha2CdwF8fUSKNcKSHC1989Hrx949xJlCtMGofQK05dMX1LMJ+ocLS4yz65fO9MgavDjKDrAb9Ct/gtGSzf5ZbiPXF39bCBSVW2AFtdCQPC25ohqnIB18LaQMZjUcDTYnv0lnS3vJ0stdOZ47SWYjVcCNDFibXmDBAsQe8W9sd31eHb+PJ/72A1zXWyJoj5wADYFi+2ZAkMYW4o7yMsvyj7BVyl1bAtX9cIyzrPKphWc09siq+jL6JcX+k8pej3xiF+2RBo6sL4R/Rj4K1tHl3DkBBavpmXmQNSp2Zs5cHR52lHalnLAxlBvGs8WkdzyV90R/Na1En63iKGOpeNpXU5xY/yYqWUZOxVbmBcQA5o1sBGGSgB9HTFwEtwljS8kUxjoZOCvySbbzEZhhU6THZvt0RQEGdeuWL/N32Bqm3TNGDrWtcAOaby5lvj4Z2dFsUrRNbptWBQvjsz3TCNi6H/5PWI5/GA38+H5RotsMlwAuhYFgQsgJZCe8J6H5HvfNxqPq73dUXz+1+eOpouVX/V6cXXrvvbGEtIIuix4QuaymythKcv+RtMu8nn0sLbDgz9sTkhBR71+zkq8EH93G/sUJumMVEXz8nAcg++5Uy99a2IB09NSHKePdl6Wg9G5OhFOp5WdLC3Eh6msCODetIzLICm6WOu+CLqB0t+mzKLYI0AKYrjEaNUMNA6BASXzVpIQ4vOBsFglI6u8iGid4fw3luVqt71UeAspSGCTE
 jgsGH3I9
 Wlvm2MWcO+vDCl9BOxpTW2xvPfjLHtsMAdMJyZY5OQYkPNvHcdH4/7CKutJ2DSfQDLrqqiyNrtfgh9NsS6BPKiPqRDNeXNu3CMsJGhonNJwoZkXhIgCjhDB2QYR6nRdBPaUUjG6aFP4aJPiAbrz/5KGZccIi73HcrpUz05PruJkkDA3ak56DbD2ViGdDk3l6GUIA7nofIjl7PoOxpnLKp/+uMUBKKWadeJeookVQP3uI5K4WffTr2tMuQnZe8dgYfb12kcEf8+EriHw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

wlcore_alloc_hw() uses __get_free_pages() to  allocate TX aggregation
and firmware log buffers used for software data staging.

These buffer can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kzalloc() and free_pages() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index be583ae331c0..5595f7a1fc0c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6354,7 +6354,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
 	int i, j, ret;
-	unsigned int order;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
@@ -6434,8 +6433,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	mutex_init(&wl->flush_mutex);
 	init_completion(&wl->nvs_loading_complete);
 
-	order = get_order(aggr_buf_size);
-	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
+	wl->aggr_buf = kmalloc(round_up(aggr_buf_size, PAGE_SIZE), GFP_KERNEL);
 	if (!wl->aggr_buf) {
 		ret = -ENOMEM;
 		goto err_wq;
@@ -6449,7 +6447,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	}
 
 	/* Allocate one page for the FW log */
-	wl->fwlog = (u8 *)get_zeroed_page(GFP_KERNEL);
+	wl->fwlog = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!wl->fwlog) {
 		ret = -ENOMEM;
 		goto err_dummy_packet;
@@ -6474,13 +6472,13 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	kfree(wl->mbox);
 
 err_fwlog:
-	free_page((unsigned long)wl->fwlog);
+	kfree(wl->fwlog);
 
 err_dummy_packet:
 	dev_kfree_skb(wl->dummy_packet);
 
 err_aggr:
-	free_pages((unsigned long)wl->aggr_buf, order);
+	kfree(wl->aggr_buf);
 
 err_wq:
 	destroy_workqueue(wl->freezable_wq);
@@ -6509,9 +6507,9 @@ int wlcore_free_hw(struct wl1271 *wl)
 
 	kfree(wl->buffer_32);
 	kfree(wl->mbox);
-	free_page((unsigned long)wl->fwlog);
+	kfree(wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
-	free_pages((unsigned long)wl->aggr_buf, get_order(wl->aggr_buf_size));
+	kfree(wl->aggr_buf);
 
 	wl1271_debugfs_exit(wl);
 

-- 
2.53.0


