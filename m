Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B4CC624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 15:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998466B0088; Sat,  5 Sep 2026 11:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA306B008A; Sat,  5 Sep 2026 11:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1FA6B008C; Sat,  5 Sep 2026 11:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB1E6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:27:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C392B403AF
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:27:23 +0000 (UTC)
X-FDA: 85180087566.21.1F0AF8A
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 26A85100009
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:27:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U5Ixe3Oc;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788622042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fMDzWqUveBSzd5QyaJkSDxL5FMTYjVkFKS0zQ+Fx1Uo=;
	b=dRzBcwgLwC3I78U42N+vUB9hQJ461HrqjPoeEIQVIDed4S++Gk/cb7rtoEmD5BhENjU/tu
	8eQlicrIRYRGaED0927O1Be6YD4IpYfj50ijwTKYEK1VDJm0q5CAqbhf42Xe8XatnfKUZF
	rl0llQCcq6+Y4RwEL5N4M0Mz4xqoC/0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U5Ixe3Oc;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788622042;
	b=oJNJmiQlPylDu+j+bws/DU92Mq8OwS+xbGtCMUXBbrIho17bu4c78BhqkoKgAUll3WGyQw
	qQDd+oBPP6n5GnWIjo8W7LijIYKy6eaNVGh8imvg4D/eZbiXFrQK5qpP6M9lWzGwfXMwE6
	ePkNM2P+qC3oifTz/735vwa69GWqTJA=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c250c6a6a9aso328989066b.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 08:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788622040; x=1789226840; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fMDzWqUveBSzd5QyaJkSDxL5FMTYjVkFKS0zQ+Fx1Uo=;
        b=U5Ixe3OcLtWiNQXUf/pJtVwdP/c0+b6RuEe5rfijQQAYLyVHVWCwbmU486M4YVPnWS
         l/5E8krkQqkEMBbaTyYcZ9Gjx0nUeMTdA7EWNdFBRVuDXSAI+GpQDMyGj0K5btTY4m3j
         lrw4pU5zk3V3TX18yWeno5cGR8a+M6yTC4YRcgMtpemuPKsMd2tZwXuhBGEwKVV6NqlW
         9wAe+RAiL7wre2ED3/S6p07Hn1YajNdt6xq4Of8AVi5ZogUhROsbs3KL9ZpWtBRhs5Yq
         N1d8oPKFj26ei6Jo7z1q1mHbcpJjXAIrGaiePwFpCaqWbHffxhUY+fwnuT/w7JiVb++a
         Ky8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788622040; x=1789226840;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fMDzWqUveBSzd5QyaJkSDxL5FMTYjVkFKS0zQ+Fx1Uo=;
        b=AX18g/xKU9b75m9FlHVY1c822FBdDx1G8Tbe14RgDSIAnL8dWjsxo2E0cAUOYCYzcp
         iSaxCUkIAyHdHGuD40hSIIU1kK31YbAoBXVAo1ugfvJMdiMxEdoIe61/FWycEQsZY8IZ
         fRU9ftxfjJGNsNOLbiMnaKlH2YaV+Qe48W7RTmpNS2KOaj0zZoqSgN6AHUCD3PoBZCt0
         vvi6UeAZHN3UKr0B5DiKUhfxfIX/VJiksFurp66ODbGm3MZGxpa1oFRR7J5g2SM8gQHC
         reJcpT3jmEsaZ/LNgR/RyMIOL3WKeGIo+ShxYWnaH355mhA8AjPexB6YHJJ36k+pPV51
         3/pg==
X-Gm-Message-State: AFuF++lgMMCKv+AbJpbgiNb2UinTKVX0UAlExuIgo95qdbKfDlE3R8Si
	QmafWT/cLZFpgLzH6+OjXIlZWY0DcU/Sgd2VnBrwd5v3V4RoGm/5yWgaa4CmX7EnD/g=
X-Gm-Gg: AYBFou3bPVPOyT3GcEeXQezVKN3OkxDrmng9fLgbvEMVGRGclkrlG4myvY+/COSqa/4
	P5cSFsBTar+yQSczNIFgiV7sESex18meg/U++jfcGfY1+eHdvhv0z1H12d9vxPDh3cnnWCYSgv5
	LuZhXcUoMjR5rmv+AEK9ke8hY055Z1ZRaMbCPYzSYAOcz+s54dluTF4XZFD92HseUj32uSKjmZY
	B8oVKJrRGZNoQkr/1B6mIQT0+UV9E4LluF5+P54oTa6FhM9Sfurd8TTlrPpjYtzK6vbRWvYLyqZ
	r5BVgIjKXMKYGAPXWmupn7dtTQWZxES2kAeDKcfm0WgRErnLrvQJGqweRa1ealLFp22rHAGQ7nL
	87XuX8kJ25f9qKwVT6Cs894x6OZvayHMgFzD7lNpDPzLgph2KtEHFFCaO3RbdPkvrfiYITz7i3R
	ZqFR5tIIsRM4kX4vtgUxye7ZSfDPKjswKQC6mJhboADAiyezUGwDUM
X-Received: by 2002:a17:906:c107:b0:c25:ec7a:a488 with SMTP id a640c23a62f3a-c260c9780b9mr862792266b.1.1788622040355;
        Sat, 05 Sep 2026 08:27:20 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5497cbsm236702166b.34.2026.09.05.08.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 08:27:19 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	stable@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>,
	Ye Liu <ye.liu@linux.dev>,
	lirongqing <lirongqing@baidu.com>
Subject: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for vmap drain
Date: Sat,  5 Sep 2026 17:27:17 +0200
Message-ID: <20260905152717.11711-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hi3ms6iz4s6n1m9arrcb3yqptiueb5b8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 26A85100009
X-Rspam-User: 
X-HE-Tag: 1788622042-301875
X-HE-Meta: U2FsdGVkX1+CURD2vAsoUCpWAIMHYj6bvyp+lN8tTqRC6k0aHL1jYUIz2OHfMWq6EaAmqK9aeN1SXPTOllv8QPgY9QzKlN42kVUuZc64aXN4xo7XEyYkLOJuTqAhTSwo9sWo+JuTntpKWJrXc5f9lmbKVCNiY48XkHqpf97TP+TlpLKx0xnnWcSCfQPR6X7D+eu+WUxcNDE8KUx8KsdFUe2aBKUBUOiy6HNYZqFaN1DRHHAMgUj3nQ9JqllGKksGXb/Ma4xzq855HBFRrKTL5WKJOqStDE7pw9hdqxo3YsDxW/RVHCpMLwYD50rkOFIyaGA/Cx3KtNz+jRzGdo1ch+kJKGhAgjbyk04onUJr5F45Rn9OSWcWDWOvMN3IlZvrJ77fSuE4TWYzdkKMcNHeb3ztipsPMHEENmDPg3tBDvFEpZSG3OI72RHFa+NV6TurViG0QUFGulm8q+M/1WmgfvBGZRAKGi2hmJIMnwpfETbhidYJ+H/M+RrV7F+rZ2xQ+MpjbfgpNVgqDCUNlgNDsLcf3OLIDk0W+MhG7rFQv44k2E14WAi3WVEe6ndfJ8xaVlht358ISeDDVLfaJs5heQWuBDY051z5SqHvvHwgYc9i030oo8uYS52Es0TtsNdbtT4sDPUX/UwHkYVIoQszFNwDbp5MKl4AR/YCmJbmXU9HkYHBf5CRJVC57tthN1G2ICi4wI2OmAn7JHYWlVg927HoS7FrMAGFejfZyVvv5vrSGxW4pHxu+O9D9x0YDGQrFMAy6mUMsJB7Xjo4DFqncQ0N4WV/BaSYEPHp+Yy9d9DOvDTmSgpJzUaLm40oInq3nDGF7v8FYe2TFtgWu+zk9rtP4sUDEWC/SrAxjgua7GJjDbt/tu60/1IeXO1HvdANg/WsAG0/f3vtt/ZtsCJehHWbG6R3xhBxIRQR1wtYMcIdIc36m4tPdw/MCMr6GijCnch8ZuFGxmeXf6STXfL
 pYdcoPpb
 SpIGgdFCtBVstr9a0xRGjDYT/rML4FkHsUHJ9+YaOiJ0AcT3sjoHkKXIp+XoRUSdjUM9v6nX0OcKfMoxkAJSwY47/BPQALCeTTFmzLrYg8zdHqacAB5qveuBvaxH2Ez6MyWj3jhWNG776spWlNqUX1dS/d3rS2qzb9MNOo4FKRWpoNJXjMgUO1WBQKgWYnB/MTjiW9JpOQOVktA1XBH7yY1Fm5JnNuU/QWNuWtcqiCHbp9Q50Dtyp5K8D6W8wq3+EMX0TpxpJOANe4d1rvD3FLcv45n1CGCmT8UFDD4qi5VymQv37tKJGkecgjkaEX/agvV7aVBrJAXxEQjKBWhNHoycXdD2YApzrKB3VuAyANx7FY8aTgduX4CDOG1z+CK1hbPBjd+XpjFn2ioPQ422VFiOIOSqsCN5SlifThoc4E93urMcvhUP8f346v3aapeJ01kdENbXRQk7o+FIvdwzuN77/m7rguVaI2HTQ3KL1zbT1dwS/7b8rUvnHGdP+VK775H+b/+sh3dF4Jq2x6r3cWOqr5yrfuqwQSBMWEgh4yzfwvPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drain_vmap_area_work() function can take >10ms to complete
when there are many accumulated vmap areas in a system with
high CPU count, causing workqueue watchdog warnings when run
via schedule_work():

  workqueue: drain_vmap_area_work hogged CPU for >10000us

Move the top-level drain work to a dedicated WQ_UNBOUND
workqueue so the scheduler can run this background work
on any available CPU, improving responsiveness. Use the
WQ_MEM_RECLAIM to ensure forward progress under memory
pressure.

Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
workqueue. This allows drain_vmap_work to wait for helpers
completion without creating dependency on the same rescuer
thread and avoid a potential parent/child deadlock.

Simplify purge helper scheduling by removing cpumask-based
iteration to iterating directly over vmap nodes checking
work_queued state.

Cc: stable@vger.kernel.org
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: lirongqing <lirongqing@baidu.com>
Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 79 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 27 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..89c327a6ce7d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -972,6 +972,7 @@ static struct vmap_node {
 	struct list_head purge_list;
 	struct work_struct purge_work;
 	unsigned long nr_purged;
+	bool work_queued;
 } single;
 
 /*
@@ -1090,6 +1091,8 @@ static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *drain_vmap_helpers_wq;
+static struct workqueue_struct *drain_vmap_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
@@ -2351,6 +2354,16 @@ static void purge_vmap_node(struct work_struct *work)
 	reclaim_list_global(&local_list);
 }
 
+static bool
+schedule_drain_vmap_work(struct workqueue_struct *wq,
+		struct work_struct *work)
+{
+	if (wq)
+		return queue_work(wq, work);
+
+	return false;
+}
+
 /*
  * Purges all lazily-freed vmap areas.
  */
@@ -2358,19 +2371,12 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 		bool full_pool_decay)
 {
 	unsigned long nr_purged_areas = 0;
+	unsigned int nr_purge_nodes = 0;
 	unsigned int nr_purge_helpers;
-	static cpumask_t purge_nodes;
-	unsigned int nr_purge_nodes;
 	struct vmap_node *vn;
-	int i;
 
 	lockdep_assert_held(&vmap_purge_lock);
 
-	/*
-	 * Use cpumask to mark which node has to be processed.
-	 */
-	purge_nodes = CPU_MASK_NONE;
-
 	for_each_vmap_node(vn) {
 		INIT_LIST_HEAD(&vn->purge_list);
 		vn->skip_populate = full_pool_decay;
@@ -2390,10 +2396,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 		end = max(end, list_last_entry(&vn->purge_list,
 			struct vmap_area, list)->va_end);
 
-		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
+		nr_purge_nodes++;
 	}
 
-	nr_purge_nodes = cpumask_weight(&purge_nodes);
 	if (nr_purge_nodes > 0) {
 		flush_tlb_kernel_range(start, end);
 
@@ -2401,29 +2406,31 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
 		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
 
-		for_each_cpu(i, &purge_nodes) {
-			vn = &vmap_nodes[i];
+		for_each_vmap_node(vn) {
+			vn->work_queued = false;
+
+			if (list_empty(&vn->purge_list))
+				continue;
 
 			if (nr_purge_helpers > 0) {
 				INIT_WORK(&vn->purge_work, purge_vmap_node);
+				vn->work_queued = schedule_drain_vmap_work(
+					READ_ONCE(drain_vmap_helpers_wq), &vn->purge_work);
 
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
+				if (vn->work_queued) {
+					nr_purge_helpers--;
+					continue;
+				}
 			}
-		}
 
-		for_each_cpu(i, &purge_nodes) {
-			vn = &vmap_nodes[i];
+			/* Sync path. Process locally. */
+			purge_vmap_node(&vn->purge_work);
+			nr_purged_areas += vn->nr_purged;
+		}
 
-			if (vn->purge_work.func) {
+		/* Wait for completion if queued any. */
+		for_each_vmap_node(vn) {
+			if (vn->work_queued) {
 				flush_work(&vn->purge_work);
 				nr_purged_areas += vn->nr_purged;
 			}
@@ -2487,7 +2494,8 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		schedule_drain_vmap_work(READ_ONCE(drain_vmap_wq),
+			&drain_vmap_work);
 }
 
 /*
@@ -5587,3 +5595,20 @@ void __init vmalloc_init(void)
 	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
 	shrinker_register(vmap_node_shrinker);
 }
+
+static int __init vmalloc_init_workqueue(void)
+{
+	struct workqueue_struct *drain_wq, *helpers_wq;
+	unsigned int flags = WQ_UNBOUND | WQ_MEM_RECLAIM;
+
+	drain_wq = alloc_workqueue("vmap_drain", flags, 0);
+	WARN_ON_ONCE(drain_wq == NULL);
+	WRITE_ONCE(drain_vmap_wq, drain_wq);
+
+	helpers_wq = alloc_workqueue("vmap_drain_helpers", flags, 0);
+	WARN_ON_ONCE(helpers_wq == NULL);
+	WRITE_ONCE(drain_vmap_helpers_wq, helpers_wq);
+
+	return 0;
+}
+early_initcall(vmalloc_init_workqueue);
-- 
2.47.3


