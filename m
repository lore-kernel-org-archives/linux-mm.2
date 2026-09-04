Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B84C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01E8D6B0088; Fri,  4 Sep 2026 13:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11A16B008A; Fri,  4 Sep 2026 13:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02926B0095; Fri,  4 Sep 2026 13:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD59A6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:31:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F4A44013F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:31:57 +0000 (UTC)
X-FDA: 85176772674.27.19708FA
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf28.hostedemail.com (Postfix) with ESMTP id EEB69C000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:31:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I6P7Bps9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3igCbaggKCFMDEzGz8Dy19916z.x97638FI-775Gvx5.9C1@flex--stevensd.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3igCbaggKCFMDEzGz8Dy19916z.x97638FI-775Gvx5.9C1@flex--stevensd.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788543116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6tqulB8FDTNVxXNeXDPTSBTeFrFMPJvixAJvKQn0AlQ=;
	b=2758EAS+CHzFONNFR0g7MqPB8T8QCvcW/G4TFzqIaC5XdcJx8LqKnpnZfAzmTnsovg6UVa
	u3sUkjqZtAbpEBRKhW0CQVwG9a83EfyWAVp/VCJwCGU7GuFFw+WQ9GFlIk6cjbDAnUcFf1
	0Q7VP98XOEeidaHvZOBRXwQA3CMhBbQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I6P7Bps9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3igCbaggKCFMDEzGz8Dy19916z.x97638FI-775Gvx5.9C1@flex--stevensd.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3igCbaggKCFMDEzGz8Dy19916z.x97638FI-775Gvx5.9C1@flex--stevensd.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788543116;
	b=T6DPVeueK+oh2Q++bsygPPD5prs8YcFjbbpMstHNyCW5IGIHvB9hWUYlxI1YbSEH5fNdhG
	g1eMizsSKSGRrA38xDYmK3hpo0dKvK0gEBwqJCcv69QIoqKmy2D0xE5mW+r85R9tlNWO9U
	U7Z8gJVH/X06Dujw+5quEfALbH0/nwA=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b388f7989fso1168704b6e.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 10:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788543115; x=1789147915; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6tqulB8FDTNVxXNeXDPTSBTeFrFMPJvixAJvKQn0AlQ=;
        b=I6P7Bps9fWrOPg02OxD+eB6tlzk5/R6CQhRtcCa3iggPI1NS7qMT1d8uIxrhmC63Rh
         ChEFKa2pRrfecYyQsK6iYFiSrBkrdpKzOJHqGmy7jkythtnYWn4MXkj+sDrB4iFNT0OL
         5hOQrlIzgvIZKSqSozsQS9niDmh78JvZe3mV/vTWLPUIm9YbbDjH/jVxg13ihzCQH2Dy
         Pu3LetAscuBeDNYJZR42eIu6zBV5ri0LGClnULhYuU/fG1/j9HZrEFj16ZqFcJs7PIK3
         0+etL/i47UrmwxFAvuVLU9XWiKA1quTfVXGzg5p2saO3ug2O8B7otVrzDoigLTQ0IbVB
         rvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788543115; x=1789147915;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6tqulB8FDTNVxXNeXDPTSBTeFrFMPJvixAJvKQn0AlQ=;
        b=DOhduS8iWtk4WoiP1ZwPROTPGtyMx3CnDrTBwXmQH4kdMpDxngOyooLMFzK2vcJJ+U
         IoJYOZs3CvShDejz1TrSuprkYKkf034klOYXXVA4+UCJtUfx9Lurqvtn+4c07pDuzR78
         UFjMLH0ZW11lRXDwo5JSuA/p37Hw5rjKnqh3sY85FGz7GgZwT0+wlzsGB7FkOuPe/u2p
         YOS48yztP0c3dHC4/2CnSlcWOu+ZBTNGjt2AScXD2sSHOruPArKTm0XyDYil1p/cMUcd
         bIW+sOqfIGMbAyYwJ0n3KtoJSMgK13nUWG61Vh8FJnzbAJjFFRGj+wSVLMHCmp7Bzteo
         lMWA==
X-Forwarded-Encrypted: i=1; AKwUvBxb2wrGbKOzXtD0HZmLtKjefpAMvNKEzFeb/Zvvr9FdROl3DMaAvmXw0bTayHMPYZ3jr+p/h+sWfQ==@kvack.org
X-Gm-Message-State: AFuF++lNfTO7YXzV6tPTrxmvDNivib4VxSDgnX04XhlkXlfH8Syvxwpx
	UoAe2k8pohzeO4bNJzCmyDZkyIVhMv2nsQBiMmcBtl/cyza7qX9inNSDUI4su8/rJDVNQHuFpWg
	V3pdEhjUTWOzTYw==
X-Received: from dyjh19.prod.google.com ([2002:a05:7300:5613:b0:315:877c:f169])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:60b:b0:6b7:8396:f3c2 with SMTP id 006d021491bc7-6b78396f7ecmr3028618eaf.36.1788543114426;
 Fri, 04 Sep 2026 10:31:54 -0700 (PDT)
Date: Fri,  4 Sep 2026 10:31:45 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904173145.2028377-1-stevensd@google.com>
Subject: [PATCH v2] memcg: Don't call schedule_work when no spinning is allowed
From: David Stevens <stevensd@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@google.com>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EEB69C000B
X-Stat-Signature: qhetgzn6nxb778mtgebfyb38oq7ahtx6
X-Rspam-User: 
X-HE-Tag: 1788543115-6829
X-HE-Meta: U2FsdGVkX1/DvCAFapqmkcPzYhQxMGttGKcaSXdsm12LRnHZwXzJJgp1YSBKxVXtNgKEgbicokns5aLwdFahwLqRkQzbiJxSeo6ozvfKBbCOoROhfmCTd3gpTujm8+KEGraxj5NXx4c6UP2KEe9v/QNGV9RD6wXt2Q6Kmav50DXHEV11V0jb9T1hXZiW4gH2Op/UKct/rZzm+txW4oW5QzZUnXJaGocwc+v8bF77nVLiUKCl2IpGFbA4QjRJlvfFwSw5cRP5k6hFBO3ypyNU+s7bHPdmwTJhwQwqe/sC+xAMxLT/FjLhhqFF1RUS0Mr0bzrRmMVoHG/YRvw9yDLHRjpNteEBqaSS64FO9pLoHQPHyyNqASExQ0vgsq77BrjlgubnRG6rvW9vEPGfSf1VJ2HK54+rHDz8fod9qCTHS56EccR582N5+NoI5jSp9lr2DgOKyBSuCEozDQVM2HTzoRnh3f13i5ghIrJF9uGIlX5IruMm4aHktXhlKqPZOLRDkoAyHhCxGnckBFQiKml3LgYxs7hZTpSYpADCCJK/tKCL+dBRYSeINwE5cwdwCv3apmp6qDQpTWsbw6MICS8ZuWNeqRvE81XYY/AnGr+Fuse1w9PXrfxN1bMpgpNe9SFiIhB9wbWYqtR0gRMWCyKKPDy+jzCejPx5tkWxudMyw0b2WOqU7W3FQwvs5Jdqdc9L2ZxLAML+OHsUVUaoodF6OpFc5/j097M0OA7tlqHwHCYgZzE5viGQd+xm9jMQ3B+YLeIxw+3JEhGGcN8aBihkywpQu052ZH1GZe/ZhyhTnCAe9nn2OxR7OEt1WdGl6TBtXJAEiWUyhrcUz2HXlc5Ce0M1Ctn6Btl14GI5wrEHIkVBAo0TofrrI/3KoKkaEZyS2Nxi9cs/aeO5ODo+rd8alV6WucFGJNkpgLzN9y5511bKyb9Y6/yUcgOZOANcbMPUdJYNs4Hqdwd3S759MoC
 yNrgvW+b
 nlf+RHRThdgPpDzCyCp1V3HlHSYsLXFK00jCtwNAKcucrUM207X/kvReZZ7BiP7d0Ije8N5DXufA5kH2KogHT8G/bArIgSzwQQg5ShPDxMrcbPiHtm1bK0Hpmz082cemBTVCmA+/SDrDqKPbb4DV4rSZTxmx44umpZvgZhFU/pBEh3U3srAAlCBxPrvHesOWq0VapGeDj3L0gMeM5iHAutkS5/HMB3m2y2Pfl6gNgWd61PpiOQati4QXyjLSlxXFXHO/XC3oZVyTeU6TZERXDHybKkYRh2t62Xo3Xi26wwRBtl418X9S9GH9av3TZt82v3gM+dyyia1oKyiIj1g/V66n62T/6M/vIfpAygxvjeQ4fqTwJnsxPtuS+uXkrelwJDeG4GJ/aPfXlcY9LsVDMpGuBSXpIxnRdrymP/8B+6yfnCA9tSKg2DxKOJeo6ac8xtkHSLaKVxQ8xb05iZ65PBJQZzeP4CSulXpuT0C94pbWEvZsWDH+4U4K0823VE9G6SUv0VdXiWZpapvuMoCvada51we0zgw3AB+mDEWYEDmNnYWjdIWBcWeOxYclFbhjNdQCXvdsR71g8VmlWSUppXzhklE4HEsqS0XQsShEpjkykLUKNWh8qqDrebaKycbr0cZleej1/7XtnxEgVsWwSkMakn/6FF6ovQrdEp8Jip6a8cZIwCHK6MZ/DRCU1b941/C1G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memcg charging can be done from any context, but calling schedule_work()
isn't safe from an NMI. If memory.high is breached from a context where
spinning isn't allowed, use irq_work to schedule the reclaim work.

Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: David Stevens <stevensd@google.com>
---
v2:
  - Added missing includes reported by Lorenzo and kernel test robot
  - Added Acked-by

 include/linux/memcontrol.h |  2 ++
 mm/memcontrol.c            | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8170bb8066a2..4a5ef0aba475 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -23,6 +23,7 @@
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 #include <linux/shrinker.h>
+#include <linux/irq_work_types.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -219,6 +220,7 @@ struct mem_cgroup {
 	spinlock_t	 peaks_lock;
 
 	/* Range enforcement for interrupt charges */
+	struct irq_work high_irq_work;
 	struct work_struct high_work;
 
 #ifdef CONFIG_ZSWAP
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..0e8b302ca9ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -62,6 +62,7 @@
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
+#include <linux/irq_work.h>
 #include "internal.h"
 #include "swap_table.h"
 #include <net/sock.h>
@@ -2360,6 +2361,11 @@ static void high_work_func(struct work_struct *work)
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
 }
 
+static void high_irq_work_func(struct irq_work *work)
+{
+	schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
+}
+
 /*
  * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
  * enough to still cause a significant slowdown in most cases, while still
@@ -2752,7 +2758,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
 			if (mem_high) {
-				schedule_work(&memcg->high_work);
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
 				break;
 			}
 			continue;
@@ -4129,6 +4138,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 		goto fail;
 
 	INIT_WORK(&memcg->high_work, high_work_func);
+	init_irq_work(&memcg->high_irq_work, high_irq_work_func);
 	vmpressure_init(&memcg->vmpressure);
 	INIT_LIST_HEAD(&memcg->memory_peaks);
 	INIT_LIST_HEAD(&memcg->swap_peaks);
@@ -4337,6 +4347,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 		static_branch_dec(&memcg_bpf_enabled_key);
 
 	vmpressure_cleanup(&memcg->vmpressure);
+	irq_work_sync(&memcg->high_irq_work);
 	cancel_work_sync(&memcg->high_work);
 	memcg1_remove_from_trees(memcg);
 	free_shrinker_info(memcg);

base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
2.55.0.979.g7e5102b832-goog


