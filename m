Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 748B5C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9986B008C; Mon, 24 Aug 2026 05:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA2B6B0092; Mon, 24 Aug 2026 05:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674636B0095; Mon, 24 Aug 2026 05:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 409606B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:50:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD10B804A3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:50:28 +0000 (UTC)
X-FDA: 85135692936.06.1EC378E
Received: from mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id B0A09A0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:50:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cHxQvXr/";
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787565027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DIQ9nUDPPdsjn+myRSxfW1pgABv9nS+mwIZpATyE9iQ=;
	b=Q5cZUHX/EADWid0emiMNmpkHL3MoHTU7pZZ64A/bLiMAvdkXvOzJELuc+9C5UUmY6Fsla7
	9gIkeAiC55SJYVune7udepJ4NrVufJw5Aailw7AEwKuTJ2lbCCOkAQpo1iXARAIb2erTMw
	HPkuEX0hNN13azMwjlDQn4SzqAayZvE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cHxQvXr/";
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787565027;
	b=KMAX+YUmm+2Onh2KkG2vrMOsSfS7wL7d3aEgSs05I/M4A78ZiG8KYn6JvmbL1J9aODzwdW
	KRJbxV+qC4smMGt7B3YDvfffB1kJZQzvFmimGyRVHNqP1+huNAe0sQRU6By1hMzxW59BSh
	Tunn0qXDs/5xtUa45bpMrIffl8jcJ4A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=X9ufpZjmt4MTtglWZo2Xlzd7jESQtJorX9XRJ/2a3JE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787565025; v=1; x=1788169825;
 b=cHxQvXr/m7dDgUj1iUfWadKl8lsgOinpRGrVII/lxOswxHoX/pnYUwqiJDPpUbpW1HZtm93h
 gt5kcViKvLZoZEvwXvafO2Wc4tFP8ANMk2FC4qRUITY07NYYdfradzUD13TbxlA9JfdZqAd4AO0
 7EtibDLMUOk9EVtsqBUNld+I=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (39.156.73.11)
	by smtp.migadu.com with ESMTPS id 0f92cbfa78e388f7;
	Mon, 24 Aug 2026 09:50:24 +0000
X-Mizu-Trace-ID: 0f92cbfa78e388f7
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmalloc: fix vmap_purge_lock livelock under memory pressure
Date: Mon, 24 Aug 2026 17:50:19 +0800
Message-Id: <20260824095020.1225189-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: icndfj49xokbqkxrajftc8aihs96uais
X-Rspamd-Queue-Id: B0A09A0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787565026-531594
X-HE-Meta: U2FsdGVkX1+YMrosdi9a4WEbB+Cl1NEtPtpL/GNn0ycZPaizD7YgjlYPLFy0hfmyBzPrVNl8gUuj/DKXIHIaJ2+Sq4PQWfVyyF8LyByvlagb/TbX48YANw0KWTITFK+bevG+c9vowuo1+arrsdnNAFLp5Io6GBdPF9dun4EJVDz7w8m+2RmiJ4INB2I9f/TftWePLFqVb0jrMnMdC6bYxgluNUb8DJb8w96HocFyojjP3r7/xP+8JZTusjxvReTpktiiCp1/NnpfhXrvl+077rLSNoLANHAjIq2pzWAzrXCyRPmRdBD2SiihrZHwqiMK/1yKtpubi7b5+qiyRW/YJsYwxquXQYs5z++wHJNg4f/O6xtoN9Ybpb8cags57sKSMsaerPIgYR6innSK3dxak4kgUnfNJYK6819q4JmKh0+jGHINL3hkj+0AWq0mdvBO7clrS8+f6MfGVbxlssxgnm0RBg0hbqXcwtMASodiTBllGtUPEq+B3/tywUDbP5622bv7Tq7kNvmjuw6ao2Pe6LSfHlJs6sSaU5y92J8yQiuBaQ3uvY/vJil1aQWWw7XzlUAExP53C7mqat03QVQefcX3oK/CPs46jiC4rU55QyyW1x99sxESHdAiX/kWSe6LlJEL2jtFSeijqRPAPKsf8D4VrJZYehN4IhZqTaW+uWiPX9LvQQncXUQ8DJUnRJ1oJETISj3hrhEGYv2GqGu9waR2b7uUN4Hot2bOsSUvfAX1/J6hqn0wPe1c9nuLZoaClqgMgZHSGVNX/n6A5QWsmr7vpnFds8m6ABYk/1N2YhZpmE2D6exTlx59a7n52xGB/DCT3BSIZ23Zn9mwfs1oHEeSHrK5KKuHBHBHW/Y8xJmWKHwFXeF9sU6KzHMPrBoaQyhoYh3DE2eMidBAaqaOwz+/io6J2/XWt6EUh6DJEwwhKjYqQwtOPOLt3GvymWaya4fHlXvJUpKhbWBeasi
 JelH75Za
 PDiCejEoh3ekfmQCPfaJtFpHn1KXICvxY2fxZKUcpBt9fmPrRZ4rZBVCK/PAzHiT9GWXgFMHs5eO3bIzMgmIpqC6e7L1oSoeiuvY4UpIcbaQ4h0lysCPPEhapG316awD+flPZqTCq87IkB0ET5ZW1UWbVNiJSz1sntzgXvZJ6G4pQkWW17zwBNBZGvgUL3+ceaUWOBSXW/VrIZl16sel1WAdxRC+sx4ZEDAj+Itb8irmGmTOG/JYlch0yNku2utAoAGtgdtOjHAJ6Z4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The vmap_purge_lock mutex can be held for an extended period by
__purge_vmap_area_lazy() which calls flush_work() to wait for
purge_vmap_node workers while holding the lock.  Under memory
pressure, those workers may themselves be blocked in direct
reclaim trying to acquire the same lock via the
vmap_node_shrink_scan() shrinker callback, creating a circular
dependency that deadlocks the entire system.

Two changes:

1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
   mutex_trylock().  This is a shrinker that only decays the vmap
   pool and returns SHRINK_STOP without freeing memory; skipping a
   decay cycle when the lock is contended is harmless and prevents
   tasks from piling up on the mutex in the direct reclaim path.

2. __purge_vmap_area_lazy(): purge all vmap nodes inline instead of
   scheduling purge_vmap_node via workqueue and calling flush_work()
   while holding vmap_purge_lock.  The workqueue dispatch + flush
   pattern under a mutex is the deadlock trigger: if no free worker
   threads are available (all blocked on the same lock), flush_work()
   never returns and the lock is held indefinitely.

Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 51 +++++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..41443708d22d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2358,7 +2358,6 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 		bool full_pool_decay)
 {
 	unsigned long nr_purged_areas = 0;
-	unsigned int nr_purge_helpers;
 	static cpumask_t purge_nodes;
 	unsigned int nr_purge_nodes;
 	struct vmap_node *vn;
@@ -2397,36 +2396,17 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 	if (nr_purge_nodes > 0) {
 		flush_tlb_kernel_range(start, end);
 
-		/* One extra worker is per a lazy_max_pages() full set minus one. */
-		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
-		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
-
-		for_each_cpu(i, &purge_nodes) {
-			vn = &vmap_nodes[i];
-
-			if (nr_purge_helpers > 0) {
-				INIT_WORK(&vn->purge_work, purge_vmap_node);
-
-				if (cpumask_test_cpu(i, cpu_online_mask))
-					schedule_work_on(i, &vn->purge_work);
-				else
-					schedule_work(&vn->purge_work);
-
-				nr_purge_helpers--;
-			} else {
-				vn->purge_work.func = NULL;
-				purge_vmap_node(&vn->purge_work);
-				nr_purged_areas += vn->nr_purged;
-			}
-		}
-
+		/*
+		 * Purge all nodes inline.  Do not schedule_work() and
+		 * flush_work() here: flush_work() while holding
+		 * vmap_purge_lock can deadlock if the worker pool is
+		 * starved (e.g. all workers blocked on this same lock
+		 * in the direct reclaim path via vmap_node_shrink_scan).
+		 */
 		for_each_cpu(i, &purge_nodes) {
 			vn = &vmap_nodes[i];
-
-			if (vn->purge_work.func) {
-				flush_work(&vn->purge_work);
-				nr_purged_areas += vn->nr_purged;
-			}
+			purge_vmap_node(&vn->purge_work);
+			nr_purged_areas += vn->nr_purged;
 		}
 	}
 
@@ -5519,10 +5499,21 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct vmap_node *vn;
 
-	guard(mutex)(&vmap_purge_lock);
+	/*
+	 * This shrinker is invoked from direct reclaim path where memory
+	 * pressure is already high.  Blocking on vmap_purge_lock here can
+	 * cause a pile-up of tasks all waiting for the same mutex while
+	 * the lock holder may itself be blocked in flush_work() waiting for
+	 * a worker that is stuck in the same reclaim path.  Use trylock to
+	 * avoid this; skipping a pool decay cycle is harmless.
+	 */
+	if (!mutex_trylock(&vmap_purge_lock))
+		return SHRINK_STOP;
+
 	for_each_vmap_node(vn)
 		decay_va_pool_node(vn, true);
 
+	mutex_unlock(&vmap_purge_lock);
 	return SHRINK_STOP;
 }
 
-- 
2.25.1


