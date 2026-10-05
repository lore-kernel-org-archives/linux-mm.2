Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C94CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E766B00A4; Mon,  5 Oct 2026 08:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A79D6B00A5; Mon,  5 Oct 2026 08:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A976B00A6; Mon,  5 Oct 2026 08:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2936B00A4
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F88040243
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:30 +0000 (UTC)
X-FDA: 85288483140.12.BE6F992
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3BB6A2000E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Y86ikunr;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.141 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoMzcYfQ46Q4Wic1gIohvjH9NuFsrikk1/c/LCtb6Ck=;
	b=y4nBVpKSdXlEAuq9r+NLcBLoUPcc/aVTCtO80lEEQlyvsZVTg8n3EEFQU7fsMy+QlwqDDr
	m+YlIkAddqWeYpBI3e3FWTLq4rMDeLeepGrcVrHd42N0NtKC+oMnPRJo0OixaM/Jj1eeXx
	VmqAxUz9/vQs/6vYPdFrE3rRO5PV6s4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Y86ikunr;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.141 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202888;
	b=sGP9GS2CvoIKMlOoRRPB88rIhj39kzRWutHHe4WchYXy0Gj63+CX+QFVe3D/aZAbGHAkB3
	Lc8TyQEMdihxjiCYNc7JrwXuKfB/uu3n7aWm8clshaDC1c1wxSycPQ6fnrjzSohVGTDJSx
	rMUUD6xNdhbw60EE7hOsjqY0+vGJ7PM=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so866256a91.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202887; x=1791807687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RoMzcYfQ46Q4Wic1gIohvjH9NuFsrikk1/c/LCtb6Ck=;
        b=Y86ikunrwtEMydBeccxcfzrHQDysnClexoy/lRaAjxk10tj6vuTbD4OoWWJYAt/DMp
         xsInUS+nv5UWWy0zmhlLG9uoLFUAeOdwrLcrtRDuUCNI+lh7gd3nZNpCsFmxumy0PdG/
         8WHrDRbPLla7cmziFvvGfpRhj+QwL5cPiWXP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202887; x=1791807687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RoMzcYfQ46Q4Wic1gIohvjH9NuFsrikk1/c/LCtb6Ck=;
        b=Je3lYOgAxR1kQt3Yx/4aOti8nu3+11xcY7byIl6nxk6xrzn2ieWcmsbb3KG/FOzM4A
         TwLkxXVXsq+Fag04PwMKpE+XqXbCfLJiS+a1EHyCtXrm7Auoh9dKCg+xAdaOy6shuw+e
         snEQbB7mwkUL16ng3srOVXbvwTEiGpv+e3QkJwgIAfcufSkUyw2Ih0z8fNKpy9Dz9PS9
         t4jKvDpXlylDu3QZDPy+pg0mn/fQOKKKKouJEEJWJuAi3lFQS37dV38Vi1N6UE5SxC1c
         opBPYhNW5+jqt60w9g9Cbivsbh9dx7sYp+Uj49t/PGL/jbbepyYfukTvH7Rei5NbxvRS
         8mpg==
X-Forwarded-Encrypted: i=1; AKwUvBwdvvfsVU3lv/sLgrC5vsT3ZtmpauqQuOtrUhEcbzfkgs5DE0HBeriA7jqCPAwZsWdePbmhgbQd0w==@kvack.org
X-Gm-Message-State: AFq9FYIXrgYzuYVMYnCJ09gUPfCHI33+FJBd/qMMBGNzj3KoQsj9f4Lv
	cMIIO5HknyBhc21jTjI710zmuO84c0L2+6Qk6qxE8sgfjZKM2GfM/Uq7i2czUzV4Xw==
X-Gm-Gg: AYBFou2NcEOc7zHBMkGDgaxXLUNINfgJjr4eMfKuJVWF2NrEHB3DTTuyzDPe/rGBMai
	QBOKAvHX4IjNImNV7tc16mTrankZ5xelshyJR7NSdWQw+jig+607pOAw3w7nCtMS/mevtpP/UTk
	Vk6rp0qeZk4y0TrYGLGuwYu5aZKPz/r13sYqH/Q7QJPM2YwWwOZKFqn1hGVXPvJekPKQ4l+CICT
	JzkWm900amIwVOK/lRqx3a++j1eI7XBeTEss/FHX0ZKrPVAfsV41D06kPdU3ES7esi60RBmWLJy
	979ALkRJ1G2wYGliII+kUrlGevw5+1lrAqAodL52603u22SXz6VlwZa2jUvEFDNwJiqAn/PnYhi
	C8Ppj5ywIQbMmJNXZagA5dASt66EZLfEdnFd7tagWahmFwJ1hLx7PrI7ZyEOkT82OV5jKoGhHdx
	YxcOdQxcR2yG0oI8BaR/+9pJcgV9SHR19iARE4YRWvz94ONKJewIFIkDWEeqD3ztvkH6QctJE/O
	t3yzs5hkTPiuX/NGXxPw0Rb1OOpxUMnzpt5HEAAur6aFNXqTHdJLxthzpZsxFk=
X-Received: by 2002:a17:90b:6c5:b0:39e:4c7f:7306 with SMTP id 98e67ed59e1d1-3a6ce79880fmr7665968a91.29.1791202887152;
        Mon, 05 Oct 2026 05:21:27 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:21:26 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 10/10] zram: use a singleton compression context for recompression
Date: Mon,  5 Oct 2026 21:20:25 +0900
Message-ID: <20261005122036.718976-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3BB6A2000E
X-Rspam-User: 
X-Stat-Signature: bu8xx53e7ahr7pds4kc4jnxbohri3ssh
X-HE-Tag: 1791202888-338198
X-HE-Meta: U2FsdGVkX1+YRzwwxk2UT068ZWaM5gzCpfbiy9iawSYUAcATOYao8moBWwUswUYCCidjm5YECr+dP/mmMt56ZXPdcN7lWDaVSbaVsjVTuBQJkBGbi5Ez5J9ZuncW74BxXMEX/Lg22wTWc8ziZewEeyxw/QD/nuWsywpXTGfmfRZ4UTMO5RyJ8LD90bDMgK4v0dSMvISqNmgOJsdu0jT6q4RgrN9G/eH0E+5IDkv5WfmL4K6dvqKSgTpQqWUqfuXtTWB5nbtFNaMxdzciDqutPkB0k8lJrGxMv+Wt+LT7Al4CHAL4Ollpr5bUVUnEUcXyteBx0Stqj3CP78LaLRsZ05mmZxY4HKf/O0f6+j/6jgz/HZpRIoviupWIuQW6acye75ple884nYLrwQi8yDxU6MwonP7qgdhFzDXfg5ALYqVo64AWsuFGf04D06f/sseWM149l9SmNiCPSNDUfOgKvItFzh1EMD8rIR98MignR6iEYSlRVjZ9aZAn8SX6DcvN9k4b/cgFTkZ4goCccifYy+v4xjCswj48jPYx9pllDYcTf40hGYavfnR12k4THWT+ZXTf+NJvOefO0QTfJKLKS91zc7DjnpILNwuTLewgjOBlL4VrFe4Z/ejckwDf6xaoyV+sDIn74K/i/IWEepxjpPmvoWFdcWDVcmBCszrzR8czr2XJXDwa3IBRI5g5CFt0ZuBhyx/JWwpTWWFXUdAy4azPstau2W2ScRkaoTfXjJronw5uvGPF4jM0Uzd4hLj4/HytS9ZQo7jhUFho5GP6zaI5LarwEvMpZGxOVeF2nD6dRkSVGL54r7NhaTse4AA2t+CbrwxdwcFVGzZ+5ysvwd3UGKVOOiXT250JtYVZ3FAOjir7aVzG7+6eScjdHAQJ7M0wNlGCzaSnUTnLhdGI1Lp01YcKmWfrL80uRmUJPeII6KA3D5K5rkqrFnetafD2mE78LAX2JsQbAZ1Khr1
 rUqLTtTJ
 +HuO/NhC3Ea7BzxBm13I4fUVIkl/yi/VStWlOYceocJbblfXJ/oLzq2K/tlinnw0udnUBcN6jR3EcNonX5r6YE/OLydGA1HT/sWY5Arfdp/q5fmAmhcBWxJe5TLEJ4hAQ/gdTShCUUFwSyRGzGybz0gzbp0f2EadWthu3Mxf6lzCllbd6GEGFsBG0eQk794wEVDtcPxijxyTpf6M9gpEvgijuowFfZMwag+gKEP6GX0eCuk3qNK+1kk3gekvW4drDuO2+lQau1vZ4gTaXJjsTF3YNuWgiyXKA/2WxjJLyDdQ8OOqIY5q25qaqJg==
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

Now that we have Read and Write contexts decoupled, we can allocate
a single per-device compression stream (recomp_cstream) instead
of per-CPU compression streams for secondary algorithms, avoiding
N - 1 per-CPU cctx and 2 * PAGE_SIZE compression buffer allocations.

For example, on an 8-CPU x86_64 system (4K PAGE_SIZE), this saves:
- zstd (level 3, default):        ~700 KB (~100 KB/CPU)
- zstd (levels 12-22, no dict):   ~1.91 MB (~280 KB/CPU)
- zstd (levels 14-22, 110K dict): ~5.33 MB (~780 KB/CPU, lazy)
- deflate (winbits=-11, default): ~1.04 MB (~152 KB/CPU)
- deflate (winbits=15):           ~1.86 MB (~272 KB/CPU)
- lz4hc:                          ~1.84 MB (~269 KB/CPU)

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 78 +++++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h    |  9 ++--
 drivers/block/zram/zram_drv.c |  5 ++-
 3 files changed, 66 insertions(+), 26 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 1c9f6d5c8cd1..20c487bafff2 100644
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
 
@@ -243,22 +248,25 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
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
 
@@ -271,10 +279,12 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
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
 	mutex_lock(&dstrm->lock);
@@ -284,7 +294,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	return 0;
 }
 
-static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
+static int zcomp_init(struct zcomp *comp, struct zcomp_params *params,
+		      bool recomp)
 {
 	int ret, cpu;
 
@@ -293,10 +304,28 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
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
@@ -305,10 +334,8 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 		goto cleanup;
 	}
 
-	for_each_possible_cpu(cpu) {
-		mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
+	for_each_possible_cpu(cpu)
 		mutex_init(&per_cpu_ptr(comp->dstream, cpu)->lock);
-	}
 
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	if (ret < 0)
@@ -317,6 +344,10 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	return 0;
 
 cleanup:
+	if (comp->recomp_cstream) {
+		zcomp_cstrm_free(comp, comp->recomp_cstream);
+		kfree(comp->recomp_cstream);
+	}
 	comp->ops->release_params(comp->params);
 	free_percpu(comp->dstream);
 	free_percpu(comp->cstream);
@@ -326,13 +357,18 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
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
@@ -355,7 +391,7 @@ struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params)
 		return ERR_PTR(-EINVAL);
 	}
 
-	error = zcomp_init(comp, params);
+	error = zcomp_init(comp, params, recomp);
 	if (error) {
 		kfree(comp);
 		return ERR_PTR(error);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 22be50dc51ba..e48e3f075352 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -33,7 +33,8 @@ struct zcomp_params {
 /*
  * Run-time driver context - scratch buffers, etc. It is modified during
  * request execution (compression/decompression), cannot be shared, so
- * it's in per-CPU area.
+ * it's in per-CPU area (except for recompression, which uses a single
+ * per-device compression stream).
  */
 struct zcomp_ctx {
 	void *context;
@@ -81,8 +82,9 @@ struct zcomp_ops {
 
 /* dynamic per-device compression frontend */
 struct zcomp {
-	struct zcomp_cstrm __percpu *cstream;
 	struct zcomp_dstrm __percpu *dstream;
+	struct zcomp_cstrm __percpu *cstream;
+	struct zcomp_cstrm *recomp_cstream;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
 	struct hlist_node node;
@@ -93,7 +95,8 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node);
 ssize_t zcomp_available_show(const char *comp, char *buf, ssize_t at);
 const char *zcomp_lookup_backend_name(const char *comp);
 
-struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
+struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params,
+			   bool recomp);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index def5266679b0..70d3f0ed9a3c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2522,7 +2522,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	}
 
 	/*
-	 * We are holding per-CPU stream mutex and entry lock so better
+	 * We are holding compression stream mutex and entry lock so better
 	 * avoid direct reclaim.  Allocation error is not fatal since
 	 * we still have the old object in the mem_pool.
 	 *
@@ -2924,7 +2924,8 @@ static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
 			continue;
 
 		comp = zcomp_create(zram->comp_algs[prio],
-				    &zram->params[prio]);
+				    &zram->params[prio],
+				    prio != ZRAM_PRIMARY_COMP);
 		if (IS_ERR(comp)) {
 			pr_err("Cannot initialise %s compressing backend\n",
 			       zram->comp_algs[prio]);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


