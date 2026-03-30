Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2188E1061B13
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E723C6B008C; Mon, 30 Mar 2026 12:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23306B0095; Mon, 30 Mar 2026 12:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB426B0096; Mon, 30 Mar 2026 12:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B575B6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:05:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EAD014063B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:05:58 +0000 (UTC)
X-FDA: 84603205596.01.93EB254
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D880100014
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:05:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RBL8ficR;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RBL8ficR;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774886756; a=rsa-sha256;
	cv=none;
	b=HpKawzTxsGHgl2A/XKwFVEDYLQuywBZAPQsj3u9GNo/sy6zciJIckORNymNoSaD6QsaxJA
	F1yNtgQ3iSzsVI7PoQnUqtMzZapVf1BjhzPfzQjy7apAsTdZ6qDGX+ZSo6tQ37ps+d0e4E
	tYSkuNWyhrX98wgqSFsFMtjObMHPLAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774886756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BG7PFkNFBpvP6Htxc+2d3T+e4s88j9TiPlIp0eqDnfk=;
	b=xOhye6x4LSM41chasnBbCu7LPxWg9L9dP9nnn5oj4w5eoGei8SB2HCR/U+NOBt9Eu4MfUJ
	Q2TYBuAFkP9nUr1Lu+nfxNIG4QKsYGafhLYCT7e5S9m80BOjRM6Ha454gL2D0VDfeSJIPA
	1qaJ5L2DCVMVTncplL0KCBt7aYjj57w=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a27b5ad832so5334537e87.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774886754; x=1775491554; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BG7PFkNFBpvP6Htxc+2d3T+e4s88j9TiPlIp0eqDnfk=;
        b=RBL8ficR4G/RaWdbKUS4vNqrmWqOnRVN1G1Z0Fc3LUHvjunnByl+86qsoDsIhpG+I5
         nvHtDjvizgM1pr0ktbny0uk+JIafvdzuhqM4uz6rQAvfh/ZKuz1yRjDoqjjkMH0QtM8L
         v0FApbXeMys0pqv7Lj3W3W9ieDVq31QVUrvT0+O0lNaKfjIjloanTGI0Q2rKzQx++Lv4
         8Rvu832RK1PZxJV1x1wq8ZnVjgW4nZW21ezi6O4gM13x7qzRUuy+nxxAX8mRIJ8ZW5Fa
         2h79izzz1KCopL6rDm8hjuIGWiPiakf4DAUZ84OF4HCsnun1piteG2PLzZvZmaDXoSq5
         UvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774886754; x=1775491554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BG7PFkNFBpvP6Htxc+2d3T+e4s88j9TiPlIp0eqDnfk=;
        b=HGKkEwJkRtrpks7qOe1ZkIzokCxLxoZfCgPkg1gkA8Bqq78o0OOoWn6a1lT6JUpC5K
         8l9W/xJLoy4/clf92/6NZvIgNSkuIKV+vuxCb5wRH0EBi2F+ayyH5a7WcffRVz12b4nm
         mpBW1d3bFKaRrIz2veqmk+oqpkbDrzlev2nYOKa5aodOleTMqEQwlAlpuepVqhWQpXU1
         yxGU1s96jph/QJbrvZpSae2qcUOLND8jHjjPzEfcSKvcKrwimNl/rIqKq/b0+M33DRUx
         qHslPMUl9DTFe7CssKa8yBuPf882Y1Wj0OrXZlBJcpJcdfOtLPowdfbYDdVewnaInkBd
         feFg==
X-Gm-Message-State: AOJu0Yzt/OXFoB9fWc3krW5zU1LbaDuxzNSzmU5PxWmutL5nDAF9UTWH
	KZTyCQE21fNOeDtZ/rzTYuxtWplZ9CPga1mSuvn4NcsxMIdurmzRgpdDmNOnvcJG
X-Gm-Gg: ATEYQzwnlEczk2OvC/da17TRD1RCe7R6a/IwqRzULFAOaegbO3l3j0hbj2ThObO/BuD
	3+uNJt9HxDZaHfRKZGKHlrWbheVHUL8OKQgjbmk1/+IDTbl3pZgKO5mf/nbvhQqV5ZfGVZURZJ9
	BduUXZtXLewR5Y+SjexiUvqAcIxeBWlTorbzNyCi5P/xtlrgn0ElUVrA22+XArvpwEU0cIhA38z
	xDTdUxBsQsDgDTmW8Lq/AV1wwmuZFzM3QoarUv/DCdDua1l7+/iuNbi6DCML1O/T0QO3jXc7/J3
	AxsL/aJe3FVA614gXG7lnnp1ocF/TZfQ/U+kCHY9CVj4RXiV616W+S8WFJZWXJNPV1FMaQ6u7q4
	3ccZGHl3GFc4XjRwAFrVkaC/d1xJpf47rn2zxooi1FxGBnx9xaBqeSlXediBTFfP1KkpPdudajf
	OLPyZO3ECDYPBI2yo=
X-Received: by 2002:a05:6512:3b12:b0:5a2:b86c:c5e with SMTP id 2adb3069b0e04-5a2b86c0cc5mr704730e87.8.1774886753847;
        Mon, 30 Mar 2026 09:05:53 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b1456eb9sm1733066e87.69.2026.03.30.09.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:05:53 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	lirongqing <lirongqing@baidu.com>
Subject: [PATCH] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain
Date: Mon, 30 Mar 2026 18:05:52 +0200
Message-ID: <20260330160552.485430-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D880100014
X-Stat-Signature: qs7p91j7bmicqemc6kggm6pfyipmq6ia
X-Rspam-User: 
X-HE-Tag: 1774886755-103313
X-HE-Meta: U2FsdGVkX18PQ14oEyKbuQcFcKmWsfec2toBITMLdEuhhIXn/eB70hde9oCoIl8ox4SHg1HD5zTdyuP3ZbNuQi7lGN2ONkPj5h6bkIPPfGB8/XJx4w4m+MvUl4OgTj4+TxZw5zWOk7OFjPWjkDjJwZzXrwcR21lnaobR5hf7XRaKqireDxVz+s7ZKmiH0cBcjj/aIC7KD0Uc+GMKuh9EWPhwkUKF1FJzq1FNElWvEIaWPcQb4RdfYwfJcI4A7NTjGaz0J3LCxJ1B5ExzjgmZHeiiIjh4lvo4ZD7UBFpHc+bGUc3U1/InXRNiH+EiEl28/L6frRbJD6Lz0aomZKEP9K9YDO0CwZ0rYh4L5wfpIgmBHO+bUTMZWfqfTyVs9RDQnmOAwoClMlU0zPkIyF9hmSvoTNPJf72AAvOFp6uBGSH5MEgAkvndFqwAAeUF9jZRfczXF9MMGi9j3u02Y2MV5yH9smr0jA4urZr6G0hjkJjNg6SIT1XUcRYX/oDBr1xt1A9RorkgCNZbywxJ5Z6OBJHxFpnyRby9iHV1tF9HNAuJ+moPwxKFkkmEhN0GLIHKZqCN+5VxgebyrbZWmo8vBOB3EwXLeA4Vm248T/Ieo4An+rxloAAT21BKvSRSPQqD+ZAGRdTopiXfFKdQ7he0fb2J5jAajBleQfLqYNgOI806PAR8Q3f+spRM2+GT3M/sB2pOTf+yf6FolS4Sdchh2ZThPzADKHodRMv54Cg0pglcjSvVEop7d05fpfI89bwjs9DaMbBTRpW28QcxA6g5wZPgqwGNeuacO4U5nOmo2lYkP0gD9aF9oN6u4YxSkMqWrLX2xcGIsR+4XFgNvkPzNrG5WTLmMRpSEUUGXVK/VGpmIpgy0l+uxrZzUIxVkujv6i9CVgD6F/FnWoip+4BNcPMyN3+RHaGxONuLA4BXC8h5ltdgUWFe9g7Hc1x4KV9HxNei8u7KXCAGiJcu17G
 gMDTOwlL
 dz4Xw5PEh9Zy7LOf2WqcAVVMK6JOsx+oi9Q1flm4l0j1aL8+iPLoKTpG932aSSltZKD85dqaSC9LLqdjrXcAU+vZ+S//2YjUmxQ4iFSF83bkn1ytPjX2AA7di9kZmqs1EsIRDYiR532aWhANP7q90ka0PkwnbMs53UkSGa3dCWu3Vqf96DAIsd+tsmEQ7DO+zSfKbGBp9VOmVc9SAkWfCttJ41jDPRQC7I/7lE21yCgAQCAl1biivNSKAfpYiZeZg3mioTswckDUSQ7C6QIopOM+q4Zbf8tdx8ansrHVNFIdepvF0Mhl5m0SgKHOyNuzOeqNAfU+CEUnUy+QfSXb43/dWMxl26Hq0ZpO+LxmS6LSEVAC5c+npqseXuGY/P9zIYTn01lCtFm2ra56tURAruXnuov9RmvuSo+KMXtXDRrqV/nctSRYEINP9UFuxO2Hc6PVLOXR+h7VyNohc1Ops333qdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The drain_vmap_area_work() function can take >10ms to complete
when there are many accumulated vmap areas in a system with a
high CPU count, causing workqueue watchdog warnings when run
via schedule_work():

[ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND

Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
run this background task on any available CPU, improving responsiveness.
Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.

Also simplify purge helper scheduling by removing cpumask-based
iteration in favour to iterating directly over vmap nodes with
pending work.

Cc: lirongqing <lirongqing@baidu.com>
Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 63 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..7c1ab4a57409 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -949,6 +949,7 @@ static struct vmap_node {
 	struct list_head purge_list;
 	struct work_struct purge_work;
 	unsigned long nr_purged;
+	bool work_queued;
 } single;
 
 /*
@@ -1067,6 +1068,7 @@ static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *drain_vmap_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
@@ -2335,6 +2337,19 @@ static void purge_vmap_node(struct work_struct *work)
 	reclaim_list_global(&local_list);
 }
 
+static bool
+schedule_drain_vmap_work(struct work_struct *work)
+{
+	struct workqueue_struct *wq = READ_ONCE(drain_vmap_wq);
+
+	if (wq) {
+		queue_work(wq, work);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Purges all lazily-freed vmap areas.
  */
@@ -2342,19 +2357,12 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
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
@@ -2374,10 +2382,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 		end = max(end, list_last_entry(&vn->purge_list,
 			struct vmap_area, list)->va_end);
 
-		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
+		nr_purge_nodes++;
 	}
 
-	nr_purge_nodes = cpumask_weight(&purge_nodes);
 	if (nr_purge_nodes > 0) {
 		flush_tlb_kernel_range(start, end);
 
@@ -2385,29 +2392,25 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
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
-
-				if (cpumask_test_cpu(i, cpu_online_mask))
-					schedule_work_on(i, &vn->purge_work);
-				else
-					schedule_work(&vn->purge_work);
-
+				vn->work_queued = schedule_drain_vmap_work(&vn->purge_work);
 				nr_purge_helpers--;
 			} else {
-				vn->purge_work.func = NULL;
 				purge_vmap_node(&vn->purge_work);
 				nr_purged_areas += vn->nr_purged;
 			}
 		}
 
-		for_each_cpu(i, &purge_nodes) {
-			vn = &vmap_nodes[i];
-
-			if (vn->purge_work.func) {
+		/* Wait for completion if queued any. */
+		for_each_vmap_node(vn) {
+			if (vn->work_queued) {
 				flush_work(&vn->purge_work);
 				nr_purged_areas += vn->nr_purged;
 			}
@@ -2471,7 +2474,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		schedule_drain_vmap_work(&drain_vmap_work);
 }
 
 /*
@@ -5483,3 +5486,15 @@ void __init vmalloc_init(void)
 	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
 	shrinker_register(vmap_node_shrinker);
 }
+
+static int __init vmalloc_init_workqueue(void)
+{
+	struct workqueue_struct *wq;
+
+	wq = alloc_workqueue("vmap_drain", WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	WARN_ON(wq == NULL);
+	WRITE_ONCE(drain_vmap_wq, wq);
+
+	return 0;
+}
+early_initcall(vmalloc_init_workqueue);
-- 
2.47.3


