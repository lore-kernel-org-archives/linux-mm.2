Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B131061B17
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 17:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A2F96B008C; Mon, 30 Mar 2026 13:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953AE6B0095; Mon, 30 Mar 2026 13:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868976B0096; Mon, 30 Mar 2026 13:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74F706B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:58:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 181A7E0ED5
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:58:30 +0000 (UTC)
X-FDA: 84603489180.17.3B0BFC8
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 500E512000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:58:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mhe5tEuW;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774893508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IebezMsHMybLTK7aOLHXktLPT4Jkv4NWF4iYsG8JrgM=;
	b=8mOq/PRrpVWP6LSRvYKp7bzZ58NgC/95uqgkGkf1mPkn6Z0JXT56u45nKBHs56zM+G9Af3
	JT0dlfNp2zo0Ta2k3DkX1hoE4UKtLbbOZIC/STeHjwa9wPDaMDmFIRbATVCMWwLAZiABX6
	nQfD+otZL6p6FKuo3WxMoSSi5+eI9uM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mhe5tEuW;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774893508; a=rsa-sha256;
	cv=none;
	b=A2wViw8YLvaJPSsyNBRN2cz4F4n5FvikLoHv0a8UcefOcWp3TCTiJQuucDFpEJVULRd7Ph
	iP6LroYiR1YtirdrtSZPJkklXES/qvI4Qm+QjFDJsjEN49CtXQ7g8G2lD8wwNKxih5B2R0
	q+RBIA8TLS2NVOcmZrn37LL2M+nJ3S0=
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38c688bdc71so32351891fa.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774893506; x=1775498306; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IebezMsHMybLTK7aOLHXktLPT4Jkv4NWF4iYsG8JrgM=;
        b=Mhe5tEuW9n3NLRnkePKww3lRsBh3THL4870ZC07S/hI6adV9oJhpt+ifmDM85vpViG
         iOyOimjxVHto1d3vy+EmoKRfAdhSutBt8yycXKHCZ7W4YsnthCkWYXSLU2x42Yzqs78R
         APJnqfBcFsPaIm8JTitAD+wkKQohGPvhvO93Hx3AeBL9C9/r/NeiU8tMD53VFPa8msXl
         HPiDbjYeuZwWU1bFksy20ve7DV5/6E85AQ4lFE01kdO8ai6vWbXgIjbkzOFE1Q0lmnMU
         UqKitTWviJEfJpDPLbJ69ZRt073M9pddPLWw8CfEOirnu2G8pp+jPNGgIO+eTckgjEPP
         Tk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774893506; x=1775498306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IebezMsHMybLTK7aOLHXktLPT4Jkv4NWF4iYsG8JrgM=;
        b=BdUhEHxpZW7tPKBo0MzVisjQKOwczeBAbcCxfFMKYDprgNJva1sXT9zeDbcTyPgE+y
         +2c2wYmY48/pqw20p7B8N44LHcz+Vxmy063D8QMwXN4L6owqzGFSKSU1pQ4hi79WxTfb
         V7KHU/iEZgGSKp851vIUS57IWH6CHlgO9vbWE9CCzwHe7sEFXAamMF4DK0JN+4xyyl2x
         csm7HAflsFKbyRwnPs3JYoDcMyT5Ayy7IZPyhDI+SnohsSaPJK3tDYC3DaktX/jcM+Bu
         qVhA6L7xdqEdLsoVVRxf2A9as+xHhYyiEexBVuahUfYbYWzrWommjPngZTkDtvekLUFw
         CtgQ==
X-Gm-Message-State: AOJu0YwKFCPmLNT9fI5b3FOAoRZrQwZwPNYzhM4l+5zDvfB6memnRc3k
	b6X0G8+8hBj5TOOMTL1Xggwwt2qEN9ZCMIMC0qvb+EOLZV1oPnmLUsf2S94FhIHV
X-Gm-Gg: ATEYQzzbsoaX2V7jpD9jmCG/4L1aJevCouLYEwU2WB5+KziVHSSI/ZMQbXb9Jphw3+U
	g4jOGELqklTP0nRR3T3al+I/UsOvuWlL4XuhHbBXdLy33y4G3vh2Z9sojybqahGs9fcnQCm2HsD
	AOalPakbAx/2B0Ip2IH0+sk4jiMjf1vsz8eEGugdH1kGdmRVMB/3iMFEw3Ajp7NQft60Uxi9S1X
	glAG+rlVSM49GOABT22C/Rumt95ft3WgtKowi1YHQVkjPCC8BJ8AwFWYMUnai9eDjDuoWx3CikA
	lH8wpMkFnM8IfsyWOqHMWqzxRwYEcpD0suip8KxVzXMDfsLmxAYAlgPEqQ1c649SlMZiZ1gJDVI
	joEes4wnad05HPRXarAtYm/5Nif3Z7JFz0HOiDJE9OtdEYsnnlxHQsJslntajN5D5hBza9tA5DQ
	DNdB71vmFE046u7vM=
X-Received: by 2002:a05:6512:3088:b0:5a2:b379:22d6 with SMTP id 2adb3069b0e04-5a2b379244cmr2628747e87.17.1774893505968;
        Mon, 30 Mar 2026 10:58:25 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c838db4b3sm15752631fa.33.2026.03.30.10.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 10:58:25 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	lirongqing <lirongqing@baidu.com>
Subject: [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain
Date: Mon, 30 Mar 2026 19:58:24 +0200
Message-ID: <20260330175824.2777270-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8j17zbbw1wrkznpm9b6gaqcnk6ao73z9
X-Rspamd-Queue-Id: 500E512000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774893508-438713
X-HE-Meta: U2FsdGVkX1/UySWq63vTAmisQ0FWQ1WupIpSf7xAkRi1SDP7eKykJgC6MSeeAyDVRAXKvFrtQ+Gkev/LHpNyvOi+9fuxwh5l9C9/8r9a/uMt8mva9WFQInTJWi4Pdp79tzR3+2Rfanf2QLMN0DYy9ng6uN/T4MdUCIOe6Hj4dAJ0PzR2vamPKhIu1h3JuEtEnuDoRoitTLRg0NJRYmURiwhLtZqUkRoEVDmwrGgusNmGMWmK9EU7yho+Yo6fRHHHKaUCy4JJTIyAY8MkM0mIRHf+TDgCjYGGwFqDXBT+zFL6hyW8Njts02cm95JubHo9uvxw5O3lyOKJYjBsCy1q7qKEYYQzWPjZn2eEVYttHwHw3ytkIOCtNfjSmE84UHPnugnBtxeEjgyzeTWn0u0ENt6JrrhtWNcusqPqZ/46+Z4CgWPhqgMzKrEP95EYo4GrmWQdhL0zv937wnWfkiZ8lyH41eSHCVm1dnmddEykJCJ1K0xqempCduGxpansBjxbaoLCETvcdTTYeNE93ioD6I0V9IWbruDYe36KGL/b+onrBft9qvRZvkE0rf4R+UsM3PtobD7iQdlAD7ei4mAHpFXh6bU6UvDLnJYsFfBiNytmtHQHNUSRLDsHoC85B8JugEgjIz49/FJ1ZjknQTEoVeUyC5cVAKDPsGxE9F3KzZWNreVCw6T9R6Z0v4YGBjs1E/aozIDeF+NzVbkdlEUa+/gpiT6xxDfr0u0WtF1i/s5nS5Rug0r45rz45+aWo9R0jfgMU6+EyaRuGQJMECS+/4D5iPDqpsh0zthrsayk+VQIrBirnSNc12CAxoxyrb1eR3DKGDjUysQnhk4fpJTKb13ixOyRLePYbnrlFVIE0M/2i7d1gZthoKveQNEL1244t/b5YbTNEkR+lsIIpnHWCMLjQG97Jmbq/p3hp2B4IcqcD6aqitUzzDGBpQs8dkLEF52bbTWKQr58DThyOYE
 ymOPwe3z
 r9TOtXCV2aiDcACyQ13I5MQ1du7p9xqKyY6eNmgObvb9+X8OxRe0rVKW57OaVCEdzWq+4FQ8V2q4kgZHecQ4B8u9Plz49O3HIHN4ZNKwL723YqnN6Y7X9smgIgIFusi+M0UEj5jeXamB5WXSjD2sK8M1U71M8VPO3pieWThjpZ+PzuQ3vlcJlqngvGjHX6Qs09hmFwRh4vy/HPbhZ55EnVxDRiW/+WDmjD7jh247o8Q39gIzfcA2geC5hA8RS2j3po61i78SnlajdLgcDE8AC6npntzzV1pniUMx8yio4znXK8JBiSDuKbUsuieS3kW6YR5nrjpB/ICy8+EbziCKLc4C8nFR8CrUt9OE254dC3nuegnVffZNaySvE3jV84NdkfanPfwoz2xRr9gM8clUBKl9dgQ2YbWRah4PZ3uEBtUtQlKF6nO1RFLCidqoz3Hns4epJuw5Dl77B3GNr50WYvEs27g==
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

If queuing work to the dedicated workqueue is not possible(during
early boot), fall back to processing locally to avoid losing progress.

Also simplify purge helper scheduling by removing cpumask-based
iteration in favour to iterating directly over vmap nodes with
pending work.

Cc: lirongqing <lirongqing@baidu.com>
Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 74 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..6bc2523bf75b 100644
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
 
@@ -2385,29 +2392,30 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
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
+				vn->work_queued = schedule_drain_vmap_work(&vn->purge_work);
 
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
@@ -2471,7 +2479,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		schedule_drain_vmap_work(&drain_vmap_work);
 }
 
 /*
@@ -5483,3 +5491,15 @@ void __init vmalloc_init(void)
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


