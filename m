Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F1CCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041686B00A7; Fri, 16 Oct 2026 00:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE64C6B00AA; Fri, 16 Oct 2026 00:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAF76B00A7; Fri, 16 Oct 2026 00:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80AB66B00A7
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:45:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC2A3A02BB
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:45:13 +0000 (UTC)
X-FDA: 85327250106.08.CAE779A
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 194BA140002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:45:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OtMO8ySo;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBOVCm/X8gmadhFAKID1/i3qY0kJgP2tgsysisGgZRY=;
	b=FGARf5yw91CVyntNlJqpPFrDsJdKWWiJ2xnfnKcKU1i/cdpR5PkMgbNsUmgjCNhs+dVjQf
	IaOYA9CNntQK3qiMtOjU3UMlPn46z+IURoVK/OGjvpd5N6uinm8XS6pT9JqLA33ZiMoEYw
	dZTdM/aTbhL6c/xS2LIDqp5GLCCp1JU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125912;
	b=oC0E617suF3pGB3VK7PdphyapMIJVhrYrdfH/rFj2kSOOrcY/g5DRY8WhDPpDfkGxnKf3W
	dOD0p3e5a/svnXWTqqcsu2Ds2991oGzYkcIWI5xZMGeCokVS15JAkGQ6+XPP4AkQUwsbXG
	jLgnkaYI+lD4CBvI9jA83c7I1XH+QHs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OtMO8ySo;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e98798cbddso1140055ad.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125911; x=1792730711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nBOVCm/X8gmadhFAKID1/i3qY0kJgP2tgsysisGgZRY=;
        b=OtMO8ySoslr7pRkbhjDwZrF9hrHppQmfG/nUXSmed3qqSZdQxfHAlgK9ainxa9bbt/
         c9c7Z+/l/KrZ3iJMzQ/9ffVw7cqg9Om79nchsR4rZGYbYsw04mn9b8DXM0T6kqrc85Ba
         fLEirMksYf3KRIpq6RZoSZA6Y79VuHG+mQ63c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125911; x=1792730711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nBOVCm/X8gmadhFAKID1/i3qY0kJgP2tgsysisGgZRY=;
        b=1iJw6uwBphY7KR+pndznrf5E++oxXdcwvGyl1OrbQ3DGebF2iYfJp0KOxvglXZ960x
         K/+I42FidSDeyT1oCkqnCK0JxumPNrL45ueertJTaAyKvMx6TXZsv0hOHIU8r2lXheMk
         4Pj/4Bufmzlie+yeqFH1y+KX4IJEXKDCxnFMSL7m9sG6SWVORunYkVeWhP18UA+A4zvu
         /YGK7+au4jPa+GXrp6eY+cemnhpVtl/AHAndQFMwVFI9MMLPdeuuYBTqYkodN652Fbdd
         NJjFlN5PeNqhni7fBlvBO5jmZx4BVbTxe2ySMg3VVy5+8V2g7zXbIgF2jA6fpiX61AsC
         DkfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxkS2i8YAF4jb07Sl3jfzVNM2FUABo0RkSusCxpWaTGNu+v91mJ2QOH2gFL28y3jVUskC1ubLipwQ==@kvack.org
X-Gm-Message-State: AFq9FYIAAzL7q0uDhBJBCkolNDe5/27kT0/6et29LX09MyCkhqnZ916D
	F4P8MUYrpEKvNvDfI+RA85E2C+NgfqeH8K+j+KokxZmFsl+Mcft3TU2bU7mjQOfCSA==
X-Gm-Gg: AYBFou0Kj6yUGjO5oDQva6Kj/qVrrxWWuxDqHDmdmWbnqmOazaT96J2MWSKvLbvs2QM
	UaxNy0YwmT8PhrVNs/NJmIng5PsNwoIYZSw0rXIriHDqh+VLJym/kJl3lJdyKDn7l18Mg+xxOs1
	1e/VlQSme+cGpoMbYGIK/5qF8yWDET2Xd3vf6MOClCyKPYfvHxVAtAYi5tj/mFPZlrxuJK9ToTD
	0oIM5SEXxLEbffE9H3tsOF+eNUny6tismAbDOoAzf4Ej3HKWc33ivzk99g13lGX0JKJkmGOysTI
	7IBlOX2Dd7hQ8cCIfqnGcLSMLxRGdvFXqChhEHXExEqAbjdu968qchSHnW+TYE0dN+bA+ouiA6w
	XfvwmRuQHY6N/yYQKhh+tXYq1vhz32UL0aO2gt5I18Dft39RNvfEPIEMiqRFvvE25HJn5Mlv/2X
	dRin+MXZoQt4fQtZ+23QabI2kXQPL8cKmDjYV8H8PFSC1u7s7IlPq0nPUfVWyFZqOwjOZLOzYU8
	fgJ5ideh3LqF96A7J36mBUyiKme2aF+B2KewTvW4Nk6oEDP2Btt2e1vrE5hwNk=
X-Received: by 2002:a17:903:8c8:b0:2e6:1828:59fa with SMTP id d9443c01a7336-2e8429a802amr202472735ad.18.1792125910970;
        Thu, 15 Oct 2026 21:45:10 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:45:10 -0700 (PDT)
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
Subject: [PATCH v4 12/12] zram: use a singleton compression context for recompression
Date: Fri, 16 Oct 2026 13:44:17 +0900
Message-ID: <20261016044429.1304561-13-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 194BA140002
X-Rspam-User: 
X-Stat-Signature: w3ujzbnxpe79k47bb546nniuyyaagz7t
X-HE-Tag: 1792125911-237118
X-HE-Meta: U2FsdGVkX18DsMDKBJSXohsBtgmhbeWgjig2qIS0/lZW5QTFlXa/VAUs+vRHDICmO/riIXKc9v83N/eHfsLwqWIqraBeviq7OjMjn5/QBZG++UOWnfGCetgIynm9kH13QSNDE4kwVSRH+l8JSfN18+G3+hU7wpBDWb/K0WiN/PTR2S8PeGBPZrBnNFsWHI5VbNrK/g0Y4Pl5bteaVDJ6aVa+krE6q2GwFhQa+dPWWO1J6vMeCxnrR/cVk2fLp2XxJst15daCwwap7LTMr3aS5P/GE3MDc92UzsWjh7Z+SiDb4eNJDwD409MJY4LevVl9/NC0rwIC3qxDaY6aNA9JiFaSE/XE/cmc4TVDzlg4pfEANdYqVGKg2ucJEb7212efZQIekljMu6OVPB0GeDvSk7lXNu/5H6RV9AydpOzsnxkmbmG4Xd+BymrvsNR6GYfd+fq2q+AZ9dMCrFmdrzGn6FzZI6Inrb8Hw8xlCxNBfzkx13d/j1ZKM0WG8qxA6sFK/ubAHTpjhhxRjBun8HJliSkzSHtYcnu+65zz/MCw+mAWJ1T1AfEQTcMSUADbu0W1WKTW7TMKPY0lifm2Aaz3UhJIq2pVr+Q1XsgtOrjR7qFQfCIAKU3kTnfQBBO8goqu67GLGo55nyaZGFikUn+SiaeKX61DR9kMcWf1R6IZz3L+yBGuoyIlLbUzSfpqxpupPP0dWS/PBZF8ZJS/hdlf+wZeUEEg6jYaEBerV4CW93wsD+g4iHvB3JFjgJXmrU52PDcGnmxmmOtT1bvVniedpS1hATWaT9JeOO9+Ul1oMWPlkVFOnQypLasoGBNVbXwYu1GvemcDUy8uckI13BRHGgbXzOqk1cDrXIQRFVL9vEsgn6UNPGsgXiscvIAN0edeXCFU++XakURQH2qznXuIhTx93VGwUwMUpPmeQOED1Auiy/vh76rzxCglU5Ld+oDPpLWUS225fh19bkE/rs+
 T9eBbAf7
 TIXpNeFsL6RLOvIrvNqnqSeNqn6tpTYspip6lEn8RE+hVZTCC0BJ8qi6Q4gJQBzbtB+aPaPNzrzAsZcBkIzBwH9ECzRCu6V78YHN9i0LEL4etfJQCPt+sWn/TCrliv3+W8VwiIzt+CpdhXr0m8Faj+NorP2HphUO+eeKlgeQXgsNan8205z4xqadeaWJb38wPmg0rmegWYzhE+uTZAWnB+y8SzuXKsx/2ueJOnXz1ciyqQXXmcUiFtT0L5EkoU7RbCDb6v4MBEoIHkH8O4iXchON70A6Am9fNrH35bR/yVXU0rALAs+qYhzjbcg==
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
index 4fda13aac896..81f21bad787e 100644
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
 
@@ -295,22 +300,25 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
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
 
@@ -323,10 +331,12 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
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
@@ -336,7 +346,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
+static int zcomp_init(struct zcomp *comp, struct zcomp_params *params,
+		      bool recomp)
 {
 	int ret, cpu;
 
@@ -345,10 +356,28 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
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
@@ -360,7 +389,6 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	for_each_possible_cpu(cpu) {
 		struct zcomp_dstrm *zstrm = per_cpu_ptr(comp->dstream, cpu);
 
-		mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
 		init_rwsem(&zstrm->lock);
 		mutex_init(&zstrm->excl_lock);
 	}
@@ -372,6 +400,10 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	return 0;
 
 cleanup:
+	if (comp->recomp_cstream) {
+		zcomp_cstrm_free(comp, comp->recomp_cstream);
+		kfree(comp->recomp_cstream);
+	}
 	comp->ops->release_params(comp->params);
 	free_percpu(comp->dstream);
 	free_percpu(comp->cstream);
@@ -381,13 +413,18 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
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
@@ -410,7 +447,7 @@ struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)
 		return ERR_PTR(-EINVAL);
 	}
 
-	error = zcomp_init(comp, params);
+	error = zcomp_init(comp, params, recomp);
 	if (error) {
 		kfree(comp);
 		return ERR_PTR(error);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 362a6da014aa..6764818d2a9f 100644
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
index b429c52cb37d..e608769bfad5 100644
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


