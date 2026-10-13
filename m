Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57BACC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3816B00A2; Mon, 12 Oct 2026 23:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154C86B00A3; Mon, 12 Oct 2026 23:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37326B00A4; Mon, 12 Oct 2026 23:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB3A66B00A2
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EE3BC080D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:41 +0000 (UTC)
X-FDA: 85316231322.08.68BBA99
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91297A0008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hWIEWdIA;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCFwH738tBTVDAaZQU9JfFW8ZV79GtE0C0hDEYSYlFc=;
	b=3lEIBDZ9++E+lTicgaFBHzN9Oyd2/AnLTj2R7m2uN3NAERqlZnLhI6CgYwZig1qmWM0fav
	hu9ZDA77hFymRy+0qbfPklAwhnCzoPmq29+lZUBBboxf/XAkk9pYZjU/+yxC0zt8Ukwv/H
	yGfWLsDlFrwTRygtvo9VQHxSZJY5iN8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863559;
	b=NBZ7HBKtvogeQHzbXaYEtD11d+ifFjxENZl4RIdB1qoP9vMuQzQr4SjWDB1X5m0h8+//1e
	Sj6MLUwJHRQKijGoWNTGHtb+heU7aWfWxrxeYtlY6vPLVTlda8SS4HWIJaQ1o7wU59ANOq
	DifdMOuU9tr+DK9rq7Y1W+ZiBBNJcRw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hWIEWdIA;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-868b3248b2cso1862663b3a.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863558; x=1792468358; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pCFwH738tBTVDAaZQU9JfFW8ZV79GtE0C0hDEYSYlFc=;
        b=hWIEWdIAVbXH8kNUwxB3XFU1EC1kTJpW7L8sZoKr6I1UctUajRCooa6qPLKwD0gGaD
         ZVdOMNP+zZEj8IiVcbYdH7rlEKbN03F6OZ15vxX4ZFtW+3xnYAIwoH0x/il/IYqzisaT
         SZf2/QyzZ7F3QyPggrh+e58Wjr80fVBbFsepw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863558; x=1792468358;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pCFwH738tBTVDAaZQU9JfFW8ZV79GtE0C0hDEYSYlFc=;
        b=p/hHECzEljKqsvSqOCMgaeAnKqS9Kpq7ouKvppe9Lhm02CBzfVPzm0NO8HD0CkCsqL
         SbXS5iQTNe8H2HBtrFZS5KWkF6zvOirM5NTVXz15KdSA42GPiDgM4AE2zqPDp+fUFTPk
         pzrQReeRlsrrXoFKPg8XqAiPKttR926sto5EU5nYhMgkBHcn386nTrhgbjxGU76qo2tb
         eDw6K2AYjx5uiK4EpdYZS7ZAWMkDUSNrXfrsv/5em0n7oohbOBLil4ESJ2rYpkaMc3C9
         hQMKK02td5EdTq53wCic8iNFnGyH+1QMZNlDHxpjAl1IBoTE6XPJ/JEvf77+9TVqGRwI
         Aanw==
X-Forwarded-Encrypted: i=1; AKwUvByJVvJpfbvjGwFaqsZU++vgoszggWexQFz15vkp1hPaMH4FQZRw9PnsFurui4NLBvYH8uA5FQ3rxw==@kvack.org
X-Gm-Message-State: AFq9FYIa0DxarVI0Z5ytOpkwza+tXBt3AFhSCqw1SGr8e2BxErqXKPu2
	tEIhV4fxQMP2Uq6b46tB4HK174VLYj1ZCo3K+YeoMJpK/STbKaYRuD3EtZi7uqrd9Q==
X-Gm-Gg: AYBFou0uH4k6Jd/0jo0GMbetTfW3QWN3hS8XfVAKcVHkbj7Av8MCCbZCrUOlbh4jwZS
	ybQlp3sww2aP6Zzgb2Xp1ujBl3b2yM+YX8sOKAaj4ZWDs68DKbKZDcsxxH7j13vkM8DeN0aTwMG
	kVMe4NPZW6owVuh7UOMmaMruEecZvzLHnvKhFQYiNHTW/XExu6XdGE3d3vUBCvELHu/ppIg+PB8
	T2M5/2hmq0CN5JjdteveMm6N/N7DqBoLM9qL1+XejzcqW3z5RnnSxuYClZGlbcYs/HcBk7rrkln
	/OaAV3YgJYCGqft+ddDhFK1tjEP7ex4OyRjg00UrIfjWn9DrDCtlmvhZNvbqsmy6BlYATSFam6p
	Y9hTZ9csQ4qnG1gWxaw0QJgUyRBn9QpjF5xoF33B21v0x4X6jEgfW8hELkaEIw+z4wEQTT3Rf4s
	LlnFkzCbO501+agnGuVMGf6sx1vF0sOf9mq0Shp26CzayqBxkTeGZXjYZyWE5NsWUsCnDsLLDvF
	lzp3qVwktH5q5cTKOtnmRbFaQFRkQwuhakfVshIRUomiLcSnBjpRBX1EUhMRg==
X-Received: by 2002:a05:6a00:1a8d:b0:86f:394c:5c68 with SMTP id d2e1a72fcca58-897c7010529mr9961975b3a.13.1791863558349;
        Mon, 12 Oct 2026 20:52:38 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:37 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 11/11] zram: use a singleton compression context for recompression
Date: Tue, 13 Oct 2026 12:50:58 +0900
Message-ID: <20261013035201.2809924-12-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91297A0008
X-Rspam-User: 
X-Stat-Signature: q3mi9zi6xbjqnaxuzcmpopdc1o9usht5
X-HE-Tag: 1791863559-578479
X-HE-Meta: U2FsdGVkX1+nb/ckcOJngaghKipnEfN+sFlpoeYJwaurcrPI16deoIFBYn/CXjyX89gqaCuik+1WDhX3LGPf1kbWVraorc0AMUGVUlmlKKYb9U4I/NMkzWhvlfG4ZXwR26nSH35ErZaTWPDOqW0UcqUP5DB/a85t5KHUpnNj5XRMo03BYHgsFZD9FMVq7nxb7F7wheLS/Z8tUFBfbaFw1GZwsg5OIPglLgw0oW3xPr9lK2q2Y0G9rvwBFwv0A5xH+RAJX8WYoepZsNLaAPZqw6La0qpxGaxzDp/tQj4M1A0BBB/VIRMPVmNNx3jIMFaUMO4NDQdq5gm4EbjMFeC6wFo4UUqCt74Mp84vLSwNpXDrwT59RipzKcvtxu5Eoo6/FdiSjTYaZcZOBsWFa6EcPThqN6a5/n+Ra1EPrKumWSiWOzok66g7vk7FVHAw77mbgJKTxhalU6i56YhZhJgYmreIfm5gJgsELgcNq6lHQCf0g12DXHB8419vT3vJkx/nwkC/uttP7Povae2/fen2M3QGJwLM1vixUyYKFso6u2VQ5IlAzAk9jdwUFEeF9wgEK5uQBtHN670mlpiVWzP510e0Jw9eB0gPkhbye5+mDHvM42PN7I22e7kLlC6tgnEfJ3oYVL9yGcqdq2FFLk5h+796pupR6xHX1QWDxPXysTpBvKCGJmW9F1A4qLgmJb8Z5e9McoVfUVle07LzaP+sT53C/z+hhjWWV2VfvLWPzU3Eqb9iJdC2/wnBIGKJmJtg1UdiP94NmY8BMai1fTo7013LKnbhWgkPR5ejDw3NFwgb+wQYq9SyNLiIuPO3+QB5IVY56XcfP3MSAFtsB6HYeGYyeOxnZr+8v619Kc9mJGYBwJz3QT33ESmyOXkJXPv+KojDy9QoDqxL/vNBz5uV5D/5WCJ8wp9rXetvJ8QhmLDiFrzFeBRW4Bp8NhMjg/NjsgfElj17Cegu+voBUVd
 yFFsDRxJ
 v/8kcDf/mmEA604Vnt0o+KAKLuzY6wHiUHz/s9ssN8tww/VORuvDse7l5BaypqCuGdElC2bYgAZAI2Kckb2xJLid58UHB5pFh+E2T4ikW9lU90djpjT7Kkol443CsGvf4OcvYaTomLuB9ILebp2DN+ROfqr8JYoHzQmy6zQmxeL3aspG9qcgd19Gfwny2z7+qWXa6+QHw4FD2JKEly/cyASghKYznPeAmqOOK/wiFe4OmOLMdGu5868R+5u5I4m4Mopbg+XNvB0rLCcw1cjAUskSkLXXPKkaLjE5AjJ/UEgHxVJ8G97sGDytkgA==
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
instead of per-CPU streams, which saves N - 1 compression contexts
and 2 * PAGE_SIZE buffers.

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
index da122bf4dd15..39d1f9384939 100644
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
 
@@ -274,22 +279,25 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
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
 
@@ -302,10 +310,12 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
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
@@ -315,7 +325,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
+static int zcomp_init(struct zcomp *comp, struct zcomp_params *params,
+		      bool recomp)
 {
 	int ret, cpu;
 
@@ -324,10 +335,28 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
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
@@ -339,7 +368,6 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	for_each_possible_cpu(cpu) {
 		struct zcomp_dstrm *zstrm = per_cpu_ptr(comp->dstream, cpu);
 
-		mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
 		init_rwsem(&zstrm->lock);
 		mutex_init(&zstrm->excl_lock);
 	}
@@ -351,6 +379,10 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	return 0;
 
 cleanup:
+	if (comp->recomp_cstream) {
+		zcomp_cstrm_free(comp, comp->recomp_cstream);
+		kfree(comp->recomp_cstream);
+	}
 	comp->ops->release_params(comp->params);
 	free_percpu(comp->dstream);
 	free_percpu(comp->cstream);
@@ -360,13 +392,18 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
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
@@ -389,7 +426,7 @@ struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)
 		return ERR_PTR(-EINVAL);
 	}
 
-	error = zcomp_init(comp, params);
+	error = zcomp_init(comp, params, recomp);
 	if (error) {
 		kfree(comp);
 		return ERR_PTR(error);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index bf41b27958c4..924c4185abe9 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -39,7 +39,8 @@ struct zcomp_params {
 /*
  * Run-time driver context - scratch buffers, etc. It is modified during
  * request execution (compression/decompression), cannot be shared, so
- * it's in per-CPU area.
+ * it's in per-CPU area (except for recompression, which uses a single
+ * per-device compression stream).
  */
 struct zcomp_ctx {
 	void *context;
@@ -94,8 +95,9 @@ struct zcomp_ops {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct zcomp_cstrm __percpu *cstream;
 	struct zcomp_dstrm __percpu *dstream;
+	struct zcomp_cstrm __percpu *cstream;
+	struct zcomp_cstrm *recomp_cstream;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
 	struct hlist_node node;
@@ -106,7 +108,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node);
 ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at);
 const char *zcomp_lookup_backend_name(const char *comp);
 
-struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
+struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params,
+			   bool recomp);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a34859ff0461..ad244624d4a5 100644
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
2.56.0.385.gd3acb90ef8-goog


