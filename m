Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48BB11061B0F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869E26B008C; Mon, 30 Mar 2026 12:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819DC6B0095; Mon, 30 Mar 2026 12:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FC36B0096; Mon, 30 Mar 2026 12:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 625566B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:43:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1707E1A026F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:43:51 +0000 (UTC)
X-FDA: 84603301062.02.504F1F6
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F4B52000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:43:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UhXY+5gQ;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z1ehfC4g4KhB2DB8rwA/DspDLE7lmXPPnBTWqLJgD/k=;
	b=VpP+JnPqR/xnc1wQwKqReN5FrrYf+r4frS8Mth5q4Rl80BgwPwuvw9OWtOmWKh5xrrlNmH
	NQFYRDoUUaxPP375XY7C9sAUmWBUE/5DcQPANFtiXQ3NAjgMti0pmMPjpr5jiupcAV3zul
	CBmveTTdnttYqvIxkamPD6Qci7l7UjM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889029; a=rsa-sha256;
	cv=none;
	b=A3IkaBpJIdbRZtxq+g4j5LJKIO6Bjav6ogQvKrxeyGR/rPxie+jSNTVixhKukrBo/NbHPy
	zyelL+D1DT0bpcYAzevWk5Sht2MWHjSXv331+VJqlLMdhXokxomE+6mYEvyOMenJxviIOK
	6KBWuBurf7vf4eZPoQZ/+Yr/ipzp2rg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UhXY+5gQ;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35d8e548a05so2788169a91.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774889028; x=1775493828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z1ehfC4g4KhB2DB8rwA/DspDLE7lmXPPnBTWqLJgD/k=;
        b=UhXY+5gQ0tm2WpdtTqB6xbRxJFTdrIMoOtjTDAH/CcCzGXbYYHFWH9iq4sb8xUSOpk
         MvxZU2hXRqC9O357vvhTmBao6FGZkgl9ttG7n3WpXEVuRs3zNBfcvQNbhe8nY0z52YGv
         NeMIMmVAuLAzHtYj4mTbhd/si9gDYdT2CXHb8cg0DSjaG+Dy9rZdYU66KVlB/HpjbMJD
         65qDf6oEMga9/+Ond7ezC66k2E+cBJhBUlenDxTvI2QYrILl5Uon3MfHL1sN5bxdneI1
         ByeDcOpt10E99KtLcxAjnyopRWbQACHxlgXYD7oubyQTJh7arRZuMXOZGQAb2tg5jBjZ
         vTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774889028; x=1775493828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1ehfC4g4KhB2DB8rwA/DspDLE7lmXPPnBTWqLJgD/k=;
        b=tZwvSzrp9VZqHkQy/RAwZGl9uift5u4LtvSX9OFGivVYDF2ltg9U/PC7Gh1dcVGJcx
         0mi4fryttPQWqjDkMo/iUSJQ+Z9+NvqoIyAqgRdbG8SpC3yoQgaMHtbjOTizqqaDk4VG
         jKNp9e3/d5009gBXABdOz9uzo/mn9NOkQeCrWFTD705+gHfOC8znZRBJKaD3L86I8BjG
         rPyQqjwu41rAepVWI1pKjjGavPUSRgTZuR93t2Bbp3yBVp5ItUzvLmeLMhgqoD6scxD6
         jWaJNFnrhT0QTpPCGYz8yrlPFhwQd59P9tPIBVA+3uNZydlwO5qdxcj+/Napz615cJcp
         fIqw==
X-Forwarded-Encrypted: i=1; AJvYcCWcSzpMhi4Us+GyROO773RQ3TSMZj23o9LGZyqF0ZxtXyi637rbQJz2GV3V1N5ZSoD96gBD+ZYn1g==@kvack.org
X-Gm-Message-State: AOJu0YyG7dRMcG7QaAvbNGI1TLPEICkngeDnuBayzAtwcEIMwbG+PqHz
	0MEzYxHcZeXA9mYcF9Fsz8pcyKsh227R5Ab2aR2amZZIAG711AxKzJvv
X-Gm-Gg: ATEYQzwZeoA8oqkvHlRXNXzeQA/HXznSJggqqQmujgs+pqjstsr1Sap2sI8nRQ4IfHJ
	3vdniKy1a8z+Bf/qlxtiohcG3IpqLlE5KIDdlgcOryWCdo7lA0TKe6dcUR81uwEelgp48SiWrL4
	LSjuCzhT0nWEaCqvgF3gCBgSeFDOyGAMW66Oc4GoQAWOmJomsWztulf6qfErf4dWwbGfAPF5FRA
	oZxb2iy4xPB6jNJCIwcfgCmHiuuTJzjRUNDjE30ejwdzIEDY5xO/8XyNF4HYbkKVkfgr6PrORF6
	z3Wx8eY+90ok1YjRmiTq+/la9bhakNgrv2jTcDJxo0GNKh2zeZCYubiuc0tgYnWKB3BEWvZtLmj
	wUSIIrQCpmgMFl+oic5HKjdsC1E8LS1uuV/9dxLhB/ppU2xWt403fjX06GyIBIDHWTSJTH43SWC
	zTtctVslb69AHOyJbLASSuUOUlhS2at2j9Y9EUPtLtfYWWnTv5Eu3hSOin6iXiJQ==
X-Received: by 2002:a17:902:f607:b0:2b0:6829:9414 with SMTP id d9443c01a7336-2b0cdbe9dddmr147340345ad.8.1774889028009;
        Mon, 30 Mar 2026 09:43:48 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765c6fsm104514555ad.52.2026.03.30.09.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:43:47 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 31 Mar 2026 00:43:47 +0800
Message-ID: <20260330164347.12772-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 3rb5keuefj1jpn3pxtwrywwhqahukbai
X-Rspamd-Queue-Id: 4F4B52000B
X-Rspam-User: 
X-HE-Tag: 1774889029-536372
X-HE-Meta: U2FsdGVkX18HOlVzOqlAgKdoUUguHq3PNOWD4Zqt8zWmsz7MQfZ0mwRL6Vuv92dUH3YTOIANNCWUH58WfoHX7k6XuzDdb5BXLiwnt+fnRD0hXJqmhHZh0cj51iITfA37Q+g4OgBtuTk+GP4J2hM9Qc+ybHptV70spEuJ+gwppb4TcXiJ98WlgKknMG/O5R1VJnG02gWwL7159/d+my+pbRF/Qkpff3Opd6NPZNGsOFThM0CFm/Y4yUgtwX5MxRFhB2lhHd9/b7Ab4iqW4yjo/uwC6THz6DQHTm/Bs7UTdoC79FcleZbl6Z2ZiJfmpSfN9q7hX5SltvniIte1M5/FdeNvg3g6qTqCeRXubLwaXu5R1czsu4Oz64gpV3ZuAv94yCdTKALBR2VQPlMRj63inr3I/yGVw3Fk1aTCr0WEABUhTYQkovwzpclf07WkjJxgamJn/pNiEGcC44o2fGExRz0s5gez/pU025Vgt7Al6ODiLSQXSlAkyvaaVc+xlKyyzBGuB2jo2LRk5LMwExXqCzbPBQPd79/r4Qc+BUI5GEi5eUeKiEWURf3d4NvnshIaLQ8Me4cf9YaXm8kMbaWVIxYXryG+V4OW02xRJEpFmc5vvOf37fBb4PteQnJOc8hH9doppqfFdPwrGIsJkU+r+vO/AfRtrcx7gIDDm0xwkICaHpFqmMj46w5s8FOawmSdlPcVLt8U9nx2AcWFDXcqdzRFsnEPYYvvPfiizJz1j+LHbzg1lrDu+YJqeO6UNG8Yp/Mb2+q77FrPCZ58+yT7N+yFx2X7MzbCtn9h8MvvGQMiVmZHQYnsbCALruZw+VBtY330XJyIvn3wWr4DrfhpimQ3DPISdUK3JrnsZo3xCegBrgU4RMGYX1Cxf+wnFJfauJgwwroKTjoQqo2uRKnWBznw2Y0dhJfstIZG4sfZQQU0j0xR3ZebvyGGRjtbGaRWfOYzRiuVDHSnuDUYk1/
 c1+RueXm
 q0TyBVZSLwLozTV8cqQ8TQfDCTYon9CXirXGPuJeh5gNHP2fv+1Cq3vsEkEKcc52bUG9y2/QuDmLKZUun2JdJBLJktXK91VSl2Lnx//xKqwkxy0zZltNK24h9CDgw9GM0UHlaGiNNCl7+NOoZXVIdQThgC7IM25Wthl+GvTZJnWoaeL0SDD0KdCpEbsqC8+/Op7U9hpKw+mMmVJ0n5fTa9zTWcmwuTQNSysmz3plOpCXNeDKPjTfL17dY/4fjfRNSXer8pWR//7Q/joMaC4c2mDPRY6yeAONc0I7jl8HWdomturnT9cul/8Y4prGaeCfY9s4CFiieUEtJGd670Yx+SQyiTsmGP+HD2ClLhjTiKJTCmMQWh9RTWLVHt4KgS7FmBwjD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
kdamond does not actively modify the module's
(DAMON_LRU_SORT/DAMON_RECLAIM) 'enabled' and 'kdamond_pid' after
exiting. After an unexpected termination, user will still see 'enabled'
as 'Y' and 'kdamond_pid' as a value other than -1. Furthermore, user
cannot restart the unexpectedly terminated kdamond by executing 'echo
Y/N > enabled' again.

Solution
========
Introduce a 'thread_status' structure to link the internal kdamond
state with module parameters ('enabled' and 'kdamond_pid').

Specifically:
1. Extend 'struct damon_ctx' to include pointers to the module's
   parameters.
2. Initialize these pointers in damon_lru_sort_apply_parameters()
   and damon_reclaim_apply_parameters() to point the respective
   module variables.
3. Implement damon_update_thread_status() to reset 'enabled' to
   false and 'kdamond_pid' to -1 when the kdamond thread finishes.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 include/linux/damon.h |  7 +++++++
 mm/damon/core.c       | 19 ++++++++++++++++++-
 mm/damon/lru_sort.c   |  5 +++--
 mm/damon/reclaim.c    |  5 +++--
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d9a3babbafc1..66cdac1eea93 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -763,6 +763,11 @@ struct damon_attrs {
 	unsigned long aggr_samples;
 };
 
+struct damon_thread_status {
+	int *kdamond_pid;
+	bool *enabled;
+};
+
 /**
  * struct damon_ctx - Represents a context for each monitoring.  This is the
  * main interface that allows users to set the attributes and get the results
@@ -841,6 +846,8 @@ struct damon_ctx {
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
+
+	struct damon_thread_status thread_status;
 };
 
 static inline struct damon_region *damon_next_region(struct damon_region *r)
diff --git a/mm/damon/core.c b/mm/damon/core.c
index db6c67e52d2b..6c71203beec5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1353,6 +1353,9 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
+	dst->thread_status.kdamond_pid = src->thread_status.kdamond_pid;
+	dst->thread_status.enabled = src->thread_status.enabled;
+
 	dst->maybe_corrupted = false;
 	return 0;
 }
@@ -2941,6 +2944,14 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	}
 }
 
+static void damon_update_thread_status(struct damon_ctx *ctx)
+{
+	if (ctx->thread_status.kdamond_pid)
+		*ctx->thread_status.kdamond_pid = -1;
+	if (ctx->thread_status.enabled)
+		*ctx->thread_status.enabled = false;
+}
+
 /*
  * The monitoring daemon that runs as a kernel thread
  */
@@ -3065,17 +3076,23 @@ static int kdamond_fn(void *data)
 	kdamond_call(ctx, true);
 	damos_walk_cancel(ctx);
 
-	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
+	if (ctx->thread_status.enabled && *ctx->thread_status.enabled)
+		pr_debug("kdamond (%d) crashed\n", current->pid);
+	else
+		pr_debug("kdamond (%d) finishes\n", current->pid);
+
 	mutex_lock(&damon_lock);
 	nr_running_ctxs--;
 	if (!nr_running_ctxs && running_exclusive_ctxs)
 		running_exclusive_ctxs = false;
 	mutex_unlock(&damon_lock);
 
+	damon_update_thread_status(ctx);
+
 	return 0;
 }
 
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..7196010ee9b4 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -294,6 +294,9 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	param_ctx->thread_status.kdamond_pid = &kdamond_pid;
+	param_ctx->thread_status.enabled = &enabled;
+
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
@@ -388,8 +391,6 @@ static int damon_lru_sort_turn(bool on)
 
 	if (!on) {
 		err = damon_stop(&ctx, 1);
-		if (!err)
-			kdamond_pid = -1;
 		return err;
 	}
 
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..61592be438d3 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -204,6 +204,9 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	param_ctx->thread_status.kdamond_pid = &kdamond_pid;
+	param_ctx->thread_status.enabled = &enabled;
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
@@ -290,8 +293,6 @@ static int damon_reclaim_turn(bool on)
 
 	if (!on) {
 		err = damon_stop(&ctx, 1);
-		if (!err)
-			kdamond_pid = -1;
 		return err;
 	}
 
-- 
2.53.0


