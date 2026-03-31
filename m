Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCED010F92FB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029B36B0092; Tue, 31 Mar 2026 16:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF60E6B0095; Tue, 31 Mar 2026 16:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D969F6B0096; Tue, 31 Mar 2026 16:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C08976B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:23:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 809EBB8D39
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:23:58 +0000 (UTC)
X-FDA: 84607484556.04.1F1B24C
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id B61A740003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:23:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=phtIzxHm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774988636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gp8MmgexMa9kZc3iHEPrKAW8s9Qb4eG8gKB+d4t8Qx0=;
	b=0i7Bg+n8VCWI6wHWHsmN8cQKJH+0D9FtjX69DkvhKd+XP6Aoee07fJsxrAYNxhCzR6w5kZ
	nuwgDpk1ll9rhPbDxUGBKipvkL9bbI72MqmTjvWRniFqXaxnOFKE1l4JUYLDHS0kOvJimt
	QXBo0Jug3TabYigxe5WfvgmuSAUQFWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774988636; a=rsa-sha256;
	cv=none;
	b=XXaK0tWph1/5rqyhiloX9sZPxoBjfFuudVkGvTYV+mi21xPd5AXvbdxQNIAeh7RcWeUqpD
	CYISYUAuxP3+1E9MvamyHgs8jDalwwVpmz0RUk0nI/pd3Mcw4KOIC1nz41/wG5Cy43lYUY
	gQkCrV0105iO4hEpky39DNb8qDWI+gY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=phtIzxHm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a2b5366c7dso3185041e87.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988635; x=1775593435; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gp8MmgexMa9kZc3iHEPrKAW8s9Qb4eG8gKB+d4t8Qx0=;
        b=phtIzxHmzL15dQ5qHT/o54xUdytJOx14SoUwWIIe/50gJfDD1yHcp0akk//URNx+BH
         Yglzgyboi0A/F3aIfbRnDDiI3V3JhHp8uMCPW8pZygGv/ee3YQTDzbHIhs5qQtgQrQAn
         kBY4LhQsvsQmEWmhA2tJbSHwBDEVCXzp6Sf6woPdFqfj9kfatqiU6aHQBYZiP0kshw5t
         NsP+jFKVuLxjpTvlJV7UbxjTGPQIQaEVCIZo1c4VsZRbSCF5bpFVzI36PXyoQl4msNMN
         WRBpTXUsk/9L8uyl5OcOoVaO6A748ZqysKWUb3kCY63rLua2tU2F4tCQ4lvQCKfFXFpk
         4BTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988635; x=1775593435;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gp8MmgexMa9kZc3iHEPrKAW8s9Qb4eG8gKB+d4t8Qx0=;
        b=tIYb5ehwjFNgPhke+Io04gBnwK7RRFDph3nihJm/5E4C+0GKHgGccGWsdMcMNBBlgV
         j8I4jvCV3xsBGJI+sR5IZqOvLawpIIlLaHRneNu2gYDT0jMjP9CsmNrlngUdF4IWMcvW
         5k15gf3PsHBD8G+JtfIbeWm9/uaSRTBJzMiq4Y7kN8e8A+FS11tplbBUdzoAripXvogZ
         LXcTt+SOulgLDnVPbOh6Uo9mLLGPwoms5JA3WppE6nPn01FTsk5ioLMPbfLZombmrtx+
         xEQR13/BRgsgg25umzR2WBxOzCKn7FsJQJUUryF31ehHQRROOSle5V0EY8kAfuXqZQdP
         7bdA==
X-Gm-Message-State: AOJu0YyP6Wya2aNIoIBzXg9Yjw+bwJUqdSMqtG/nuaPpMEbVbt8K9O+m
	AXJfs1NIIn9RnEmz7Fs115Wv8v2e60V3HkyOdcB0Z2RGuAb5PsRl2JsrxlMyn+cC
X-Gm-Gg: ATEYQzylT9sDlW3ftOXrAtimK9Gy3IjKsdbEVCRG8pHy+eqmXka3lFrmGqJXlqN1MVy
	zx6CIJ/SB5OrZxz1iHmTgUxEqtm3H7iIVD6hD/eCUdk9xgdwiI5EvXJYZYdv+QD9hEw40GALK7i
	es++9NBFBbcvlKPlW+RPw67QgsyTI4Adxn8niacxFd5H55ZH6Z/JeenU/B6WVuqQ/aa30aElmFH
	OAeHE4U7LV6bqV5x+fF5sqR51kdRAengRoBIrqnlPx++yU2uKeMEY5VYomCpVDWzgSqaO2Br2F6
	oYaGhcXEpms52gV8FWg97I6AJdFBc9hwa8frhahQ0vY8JrcOwAf1wWOS/n/dzXo6oIlf+7Nnwjk
	uPT9J6hFYita3R7XlYsZco4jOnv9F5diMCzY90vlF1kbMhvefYrvGTiVguQYBib+Hx+JQ/3Qffk
	nZdax6reVLkGRGpsY=
X-Received: by 2002:a05:6512:1291:b0:5a2:7a31:9194 with SMTP id 2adb3069b0e04-5a2c1ef9aa4mr263563e87.19.1774988634449;
        Tue, 31 Mar 2026 13:23:54 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b13f4329sm2681171e87.3.2026.03.31.13.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 13:23:54 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	stable@vger.kernel.org,
	lirongqing <lirongqing@baidu.com>
Subject: [PATCH v3] mm/vmalloc: Use dedicated unbound workqueues for vmap drain
Date: Tue, 31 Mar 2026 22:23:52 +0200
Message-ID: <20260331202352.879718-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B61A740003
X-Stat-Signature: ht6fzxusuwpxgzpby1d1q3amhomi3on1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774988636-746686
X-HE-Meta: U2FsdGVkX1+M/qC8nQI7vRXqgiY010R6an+UsKqreqrk79E6rXJ3MlFtnbxTkOwZIOFaLENARf+pCRAfsLK70gXxaJvb7mIexArNetbZdawI4k6XMiSdWQHz+DKZj6hDPcA32GnJPViXViyeYGLMEAQGmJSu9jhVNnOlqtlGjh6gjif5IM50uTkTldBhSfZTqsBy4eu7NEPAn2AhJjMmS6d9a71H0NLjCr4nqG4mUHic9fnosu8CL9D02GjGnFmaSMRnb3uAi2MwCFYu3oXE4t29rvQnL/OYoxL5HMzD20wuAir9ws+S67Nxkq/3CneV8yS1YA9qf1FRL0Dq23sC8aPOQ+hnLBJ+FpjSD8s+m4d0cANRDBkajz/tpS1rV0PfeMvL6j+THxypffu9HkHcGd2aQrNU+k1cfmMKr92v5pD4zXtObplCh6S48Upb4X9su5hm/hNEo9jTl/9DgtTQ76vT/8U5QLvEXIHl4kNr01rwm5FjziZYoNaxlykNueStZdKl89PGdMx9i36H3J+xIM9w5VecOhQyX/tqmSK7+q1NKOc32yRkhsmRylvCZIateTgD8EXCNmykoKXDCD2xFDS89e9kem+JiJ/WGSahaCTOo2INDwFfQnjh7uYXbV52nPvbt0X1ZgajKl9B3aQMDUt0+gDDaWeqF1cTF2kc3N2bDW6prXdkb+ZnoWvebSrz3mkjTllqb8iMmVYpnDXuzPQk2CBqj+wMFu7l5L13p4UPn9vR5j8MP7avsY+lrNTSFi7lfmzi+j0HJ7rSUBYHX+FR65fVd+OfF8d3aV3AnaUZLa08s2NzkrBQJV30pv3npNPISiqmqzfh/BjXFk26jEwGgDcy6VmSCrqjnyViU9UR72OIgEyucJBcjcWQxS36UR5GFYCjXjLk40XvzLU+nTPK6zsaEmlsv29jgTTMfgSMST0RhBO8kgU+JOKsCpolc72JvBcZ01r4t8Gu2Sa
 3tWDvync
 1QxoZNXl7BFF7KYAFAJEqhBbOEEqQTdn28hM9T2ggX24MVIR4PKsnonQue2Jo6ty00Yv/vv0eu1lxzcczlVEihIIIedwtarkkXrtFwbihmqZy73VFG1yN7CaJ2mW3Hagug4bpApEQ0rIir2Cbyh7oUe/foid/dUxHKlq8EotHnH5ofzoo4erl3dvb6GbFWfmJimiDq+Uqk3XInEPmejFIYQL5OX8OU0vNcr7ex8aio12G2jeI00kq5G4IceLu+Cw34oVjtXDiOZq/5ZmLZJYOLRP9gX9w9dqcVS7jpdGqZgyLtcJ59rbDNEnCrJ6GN7bBQsv5X/+SAjWdNjjFncsZnkJvWiw71U0XbKtvvlyELw/ndZm/EhWeBygIggJYidM/6ARRKRq3WtYBLxCgKhKH1YRKLVWpRPqHOtCnNdn5aCSwZYU=
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
Cc: lirongqing <lirongqing@baidu.com>
Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 79 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 27 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..0fa1208a910b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -949,6 +949,7 @@ static struct vmap_node {
 	struct list_head purge_list;
 	struct work_struct purge_work;
 	unsigned long nr_purged;
+	bool work_queued;
 } single;
 
 /*
@@ -1067,6 +1068,8 @@ static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *drain_vmap_helpers_wq;
+static struct workqueue_struct *drain_vmap_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
@@ -2335,6 +2338,16 @@ static void purge_vmap_node(struct work_struct *work)
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
@@ -2342,19 +2355,12 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
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
@@ -2374,10 +2380,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 		end = max(end, list_last_entry(&vn->purge_list,
 			struct vmap_area, list)->va_end);
 
-		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
+		nr_purge_nodes++;
 	}
 
-	nr_purge_nodes = cpumask_weight(&purge_nodes);
 	if (nr_purge_nodes > 0) {
 		flush_tlb_kernel_range(start, end);
 
@@ -2385,29 +2390,31 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
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
@@ -2471,7 +2478,8 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		schedule_drain_vmap_work(READ_ONCE(drain_vmap_wq),
+			&drain_vmap_work);
 }
 
 /*
@@ -5483,3 +5491,20 @@ void __init vmalloc_init(void)
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


