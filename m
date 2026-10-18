Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 088F4CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FBA6B00A2; Sat, 17 Oct 2026 23:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DFD16B00A3; Sat, 17 Oct 2026 23:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7036B00A4; Sat, 17 Oct 2026 23:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3120C6B00A2
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8493F1A0309
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:29 +0000 (UTC)
X-FDA: 85334374818.09.DA823E3
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id C094640002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DMq+CKA8;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295547;
	b=xoYsXTpK8b/TqU489iDz3LFx3SrLN34vDOzVLxOhqPqefkbydsDFI9krkp0UaDdWXIxMId
	/ZOjXZdldpQw7XjyEO+38+bV7Sykzz4wCT1bJ7UuzAREduLGTvuGZ+B3v5quqCzN87VRSt
	MOQq6pHnKAusJz74PdEQoEqMr04e3Wk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DMq+CKA8;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M55JStFe4+ywWFb/Lnl0qjUNokQckie0nywOU4qhi9c=;
	b=WlKcLY4jnjmxMDkzzBeivV+lqZ1Wru8OeUS6ulG9WL244PMgfrjhzZaGhkY/BrrYLh3+61
	eutYsEF8JDbHst7BW97eEtsVax8rQXRqLHvL2/912nIBobnzcTjZf3fbCuGqFeoZWpj2nj
	CENHkTg+PAHl/OFQObpOBgBSJNB4L+g=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ac78f4c10bso501855a91.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295547; x=1792900347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M55JStFe4+ywWFb/Lnl0qjUNokQckie0nywOU4qhi9c=;
        b=DMq+CKA8GTKaVQb9tfv+b1iVl+fFU8lR31ot8d9h7H5qBaeevSgW5KER15duLnqDll
         UaqzUlrfMYMFknFy5L9MBkM6/wocv3Ho6mN8lyxg3ytgmOFqxRFczVFCypmJt5gDRDpv
         oPdmpsbTvhRJq9acM3/R4QOUhU1IlK9PS7RI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295547; x=1792900347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M55JStFe4+ywWFb/Lnl0qjUNokQckie0nywOU4qhi9c=;
        b=C2j+ixlFGge2zkXqrqQ8QAAHuZibXvm+y+fnaAscJImY1LxGZ6VQBxwUkidaSECt0i
         bYGL0eWMJcQzuwU126taurXHOLxWD1r2/CUOp6w3JiyeMXNwqh+AKGRd+n1eSHtSSXv0
         6DrUXbnkDiB0Ip0e9Bk55on0qBeylKWdS4ijUWIdZJraoyhKdtiROIl2rdpHiBArai3D
         WH1Pq1CHUxtCgCtkHaJ/ShG7mMUeF13q13ivtFesexvLZz1hTjd2gFrPlBnRvqueziPi
         //P0g9ranEu+o0wy+7LltHH/nHFIGw7rRYZUOf0BL2m532P9+AbmappbV6308VENy1SJ
         9iPQ==
X-Forwarded-Encrypted: i=1; AKwUvByv1FNqZk6VH0q/9rUVJ8uN4LbAIGpMrb/QO5Hfuc9q0ZpAmwUdlZjy/n9eeWItwn9JUWMlrsx6sA==@kvack.org
X-Gm-Message-State: AFq9FYLebJHUO7O0aNVZvVtrHc8mNGhWTO0Ig3VJXF3dCnAh4pIYxzoJ
	P2seGOgDw1TshSJO5E1xC3gqjIfTdd8BDP2UWf+GwNidae3RbeUTdEiT2jRVyzesTQ==
X-Gm-Gg: AYBFou2Y6+WHdnAioQklI1bf8utaVeOZQZv3WcTUgQThTJEk+GyFkwDvpouS+1zN/OK
	ljKR0ZYCHOoBwdmr7IBMAGZkCJjSB7fMRCYN5uSg//RdXulOI/YpIdB02h1CQ11bH3TO0c46NGv
	S4vC4wkm94yl42a6F+OR/wn0RcP3BLg6d0uy4y9Gwgz9wD0Wu4aZiyUXzFxwpnLHMMej1IpvfTp
	BUY5ykdqBWhKd81hI6BbIj3+DVBzP/7yBh7nrBSyg683YLDFdKFOWAQdPbKLs7IaC6zT/2+wXbZ
	ktYP1Z6z+sW/iYiwko3rTkDJpEKEp8T+Rh8N4rvLNV5ZqJKWT3Q8X+geBpYELeEZbKRrcJqD632
	4BKN53Id5uap3djlVyHMvz5FeynKiB/SiLuDsM6X8hwXHTEv64ShFCkNa3kFNz7nOh4hgM534WS
	wqSN/aA86hSajB4RNjXvPP8IXoFEjOLB06IPWiMpEoEJsZDNFx1e2TevXMrBZ/aORMOFp3Vvp0u
	DL3ifRCx5f7oXgnMIYS8Pg02y/1P5/BDdY/SwpKORRIoT2dtYNAUOVIwSadhTo=
X-Received: by 2002:a17:90b:28ce:b0:3ac:d17c:2a70 with SMTP id 98e67ed59e1d1-3acef5dcc7dmr3685875a91.62.1792295546657;
        Sat, 17 Oct 2026 20:52:26 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:52:24 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v5 13/13] zram: use a singleton compression context for recompression
Date: Sun, 18 Oct 2026 12:51:15 +0900
Message-ID: <20261018035125.3120704-14-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C094640002
X-Stat-Signature: r8hqrfetm8w9o8ck9p76xz69wjmzbdhi
X-Rspam-User: 
X-HE-Tag: 1792295547-698181
X-HE-Meta: U2FsdGVkX19OpqyrDjgzyacZbs6Pf500pZTD7WNppdKY3kED9+SgttHLUEwQuyWwe+qk4E5vutY/ukM8via7l3rB/WXbSpUDGljNgaO21JYaf8DxtZxeowNw6GCuZSBlT1mnkLmxAqrkCqPO5TYjU41IJpkjzQXbbk3QOteJmEDhHk2tF1XsuaJ5KSbCRC+ZdAdfAavImrCruFyQNh1tih+WLUD8k2/WcClcvjtsBlsJcxFoxBQSSRaIfnpyx/LeL+iXJaA8vwH2uyTIgY2NM4z6pSvEajs81zexjoi2pVjCM9ucuGxt/PnwCYwTFIeQfUSfj/bU4fYZvZzMryQ10+DeVwojs02K31ZgNGuQDsnQQDyZiHxAuSVMv02tilgjM5Hu+mk/kNvu5G4uG2dnzwKrQ6RaZcnWd1uFUVWkF4smbjOf2muFtL0BpHAmY+hJ0BhXrs+70gmxmkjUgh3865jDyDKK0AAY6g1wEN9MVYyfEBwXiuALsMpzJPTBX79PJ+rDh5bTaBSyKIctNPsVTOyFEwVIyge0KJ+ulp6CTyf9DexckX+TfcKROdFsk6+KA9inXh4VJ5jt2V3IjFhlnee5bkVBHzQkl4WLqzlTYa4tAK7KLiFYAhEjt7jMOZ8c/L1pm8xGJ1ZvHXcGeyDitLF7k9UEVpzFeJX+eBAu8w6i3i+9+uiHIKUjHR2tBRCM2xR5eawEWboFfTIRxOtkyDzBvMfnA56cZ3STF4JEjEZ4SOhHadD1FVyx8njfz4a5Dmj6xL1/HQOvn4ifKNraaGadFKeWzXlET3Mnbw1O5glwjHcN6F5fOrzjIKOSo2lo0MECZ01Mydi0O7qn20VKeTFWFKHJ2ltjfoFWu81gHxGVo6RdEkB1e9T1xJM6heVOj4q6xFqU0WuVOuB2JaH8hYdGWoWx0A6ZTA30iBVfHLFblpKWdt+HlQ5ccSAlNQU59LKwjVE4PY91R4XNhyB
 HsQqO3rG
 RtljYEaR9QBpqiu/5SLKy9TKkXlFSTyTYM5O5DmEDxCiguqFK22y8JFz6mpHq9BokiQ4SqF/134n1RWp99Y6BD5NGW7/AbBbQpZsZLCZWHN/XkOTs0A310Jyew+9F7YCuGV1uRGJpMXWHVGj3NjUHVRjW11yA2mBU6kPJ/eZNC20qqfE5IWxErO4oCRURT9vwq2XscmXrTK+rTNuzUzlVb3n0Kr+uEiTrht2t+Kbhyz0VHtpO+BD/qnzvC3WJVxZw7P1KHO/zPf/GSknNC2Fi07zbfPX1bsennY89sLXVoMqmsFlCCmj5XNwBiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Secondary compressors are only used by recompress_store(), which is
serialized under zram->dev_lock, so we only ever use one secondary
compressor at a time, yet we still allocate them on each CPU, which is
just a plain memory wastage.  However, we do need per-CPU decompressors
in order to support concurrent reads.

Now that Read and Write contexts are split, we can allocate just a
single compression stream (recomp_cstream) for secondary algorithms
instead of per-CPU streams, avoiding unused per-CPU compression
contexts and 2 * PAGE_SIZE buffers.

For example, on an 8-CPU x86_64 system (4K PAGE_SIZE), this saves:
- zstd (level 3, default):        ~700 KB (~100 KB/CPU)
- zstd (levels 12-22, no dict):   ~1.91 MB (~280 KB/CPU)
- zstd (levels 14-22, 110K dict): ~5.33 MB (~780 KB/CPU, lazy)
- deflate (winbits=-11, default): ~1.04 MB (~152 KB/CPU)
- deflate (winbits=15):           ~1.86 MB (~272 KB/CPU)
- lz4hc:                          ~1.84 MB (~269 KB/CPU)

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 75 ++++++++++++++++++++++++++---------
 drivers/block/zram/zcomp.h    |  9 +++--
 drivers/block/zram/zram_drv.c |  5 ++-
 3 files changed, 65 insertions(+), 24 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index c6d2fd23c6f6..ce94dd96cc98 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -151,6 +151,11 @@ ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at)
 
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp)
 {
+	if (comp->recomp_cstream) {
+		mutex_lock(&comp->recomp_cstream->lock);
+		return comp->recomp_cstream;
+	}
+
 	for (;;) {
 		struct zcomp_cstrm *zstrm = raw_cpu_ptr(comp->cstream);
 
@@ -326,22 +331,25 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
-	struct zcomp_cstrm *cstrm;
+	struct zcomp_cstrm *cstrm = NULL;
 	struct zcomp_dstrm *dstrm;
 	int ret;
 
-	cstrm = per_cpu_ptr(comp->cstream, cpu);
-	ret = zcomp_cstrm_init(comp, cstrm);
-	if (ret) {
-		pr_err("Can't allocate a compression stream\n");
-		return ret;
+	if (comp->cstream) {
+		cstrm = per_cpu_ptr(comp->cstream, cpu);
+		ret = zcomp_cstrm_init(comp, cstrm);
+		if (ret) {
+			pr_err("Can't allocate a compression stream\n");
+			return ret;
+		}
 	}
 
 	dstrm = per_cpu_ptr(comp->dstream, cpu);
 	ret = zcomp_dstrm_init(comp, dstrm);
 	if (ret) {
 		pr_err("Can't allocate a decompression stream\n");
-		zcomp_cstrm_free(comp, cstrm);
+		if (cstrm)
+			zcomp_cstrm_free(comp, cstrm);
 		return ret;
 	}
 
@@ -354,10 +362,12 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	struct zcomp_cstrm *cstrm;
 	struct zcomp_dstrm *dstrm;
 
-	cstrm = per_cpu_ptr(comp->cstream, cpu);
-	mutex_lock(&cstrm->lock);
-	zcomp_cstrm_free(comp, cstrm);
-	mutex_unlock(&cstrm->lock);
+	if (comp->cstream) {
+		cstrm = per_cpu_ptr(comp->cstream, cpu);
+		mutex_lock(&cstrm->lock);
+		zcomp_cstrm_free(comp, cstrm);
+		mutex_unlock(&cstrm->lock);
+	}
 
 	dstrm = per_cpu_ptr(comp->dstream, cpu);
 	down_write(&dstrm->lock);
@@ -367,7 +377,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
+static int zcomp_init(struct zcomp *comp, struct zcomp_params *params,
+		      bool recomp)
 {
 	int ret, cpu;
 
@@ -376,10 +387,28 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	if (ret)
 		goto cleanup;
 
-	comp->cstream = alloc_percpu(struct zcomp_cstrm);
-	if (!comp->cstream) {
-		ret = -ENOMEM;
-		goto cleanup;
+	if (recomp) {
+		comp->recomp_cstream = kzalloc_obj(*comp->recomp_cstream);
+		if (!comp->recomp_cstream) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+		mutex_init(&comp->recomp_cstream->lock);
+		ret = zcomp_cstrm_init(comp, comp->recomp_cstream);
+		if (ret) {
+			/* zcomp_cstrm_init() cleans up after itself */
+			kfree(comp->recomp_cstream);
+			comp->recomp_cstream = NULL;
+			goto cleanup;
+		}
+	} else {
+		comp->cstream = alloc_percpu(struct zcomp_cstrm);
+		if (!comp->cstream) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+		for_each_possible_cpu(cpu)
+			mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
 	}
 
 	comp->dstream = alloc_percpu(struct zcomp_dstrm);
@@ -393,7 +422,6 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	for_each_possible_cpu(cpu) {
 		struct zcomp_dstrm *zstrm = per_cpu_ptr(comp->dstream, cpu);
 
-		mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
 		init_rwsem(&zstrm->lock);
 		mutex_init(&zstrm->excl_lock);
 	}
@@ -405,6 +433,10 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	return 0;
 
 cleanup:
+	if (comp->recomp_cstream) {
+		zcomp_cstrm_free(comp, comp->recomp_cstream);
+		kfree(comp->recomp_cstream);
+	}
 	comp->ops->release_params(comp->params);
 	free_percpu(comp->dstream);
 	free_percpu(comp->cstream);
@@ -414,13 +446,18 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 void zcomp_destroy(struct zcomp *comp)
 {
 	cpuhp_state_remove_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
+	if (comp->recomp_cstream) {
+		zcomp_cstrm_free(comp, comp->recomp_cstream);
+		kfree(comp->recomp_cstream);
+	}
 	comp->ops->release_params(comp->params);
 	free_percpu(comp->dstream);
 	free_percpu(comp->cstream);
 	kfree(comp);
 }
 
-struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)
+struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params,
+			   bool recomp)
 {
 	struct zcomp *comp;
 	int error;
@@ -443,7 +480,7 @@ struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)
 		return ERR_PTR(-EINVAL);
 	}
 
-	error = zcomp_init(comp, params);
+	error = zcomp_init(comp, params, recomp);
 	if (error) {
 		kfree(comp);
 		return ERR_PTR(error);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index ca1ebc70ad0a..39efefc43a13 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -40,7 +40,8 @@ struct zcomp_params {
 /*
  * Run-time driver context - scratch buffers, etc. It is modified during
  * request execution (compression/decompression), cannot be shared, so
- * it's in per-CPU area.
+ * it's in per-CPU area (except for recompression, which uses a single
+ * per-device compression stream).
  */
 struct zcomp_ctx {
 	void *context;
@@ -95,9 +96,10 @@ struct zcomp_ops {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct zcomp_cstrm __percpu *cstream;
 	struct zcomp_dstrm __percpu *dstream;
 	wait_queue_head_t dstrm_waitq;
+	struct zcomp_cstrm __percpu *cstream;
+	struct zcomp_cstrm *recomp_cstream;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
 	struct hlist_node node;
@@ -108,7 +110,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node);
 ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at);
 const char *zcomp_lookup_backend_name(const char *comp);
 
-struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
+struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params,
+			   bool recomp);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 52341f05da83..079f3723db31 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2526,7 +2526,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	}
 
 	/*
-	 * We are holding per-CPU stream mutex and entry lock so better
+	 * We are holding compression stream mutex and entry lock so better
 	 * avoid direct reclaim.  Allocation error is not fatal since
 	 * we still have the old object in the mem_pool.
 	 *
@@ -2928,7 +2928,8 @@ static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
 			continue;
 
 		comp = zcomp_create(zram->comp_algs[prio],
-				    &zram->params[prio]);
+				    &zram->params[prio],
+				    prio != ZRAM_PRIMARY_COMP);
 		if (IS_ERR(comp)) {
 			pr_err("Cannot initialise %s compressing backend\n",
 			       zram->comp_algs[prio]);
-- 
2.56.0.176.g3575e65682-goog


