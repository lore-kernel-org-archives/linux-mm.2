Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51814606D68A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=W6nrgIZO
Received: by kanga.kvack.org (Postfix)
	id DBE6A6B05C6; Sat, 24 Oct 2026 22:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95A66B05C7; Sat, 24 Oct 2026 22:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB866B05C8; Sat, 24 Oct 2026 22:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3476B05C6
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F8251C3C63
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:23 +0000 (UTC)
X-FDA: 85359541806.11.1E0D6B1
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53543140009
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=W6nrgIZO;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894761;
	b=vGPT6mtpXR0yK0dgOv1Fnz/fR/KbK2aycrZwW21G1T5RBQMrt7WFh2MFdCiSkz2g//ObXQ
	2uK+DBP6sCunowU5OKHyQpar1Cff2TOfVHn+QTSIf21qaHQYhXkHaaPtUk7dvBR/RtSEni
	aRzwnrk3x8WXCgv0LkDdfx55Pta2OLE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=W6nrgIZO;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yyLuz5UaStjKlvh7yTZOlGkgF8Ibo7+n1CkWw0SmUA=;
	b=fLfAxbKTS0IuCuuX6ws/0kOEPSrn7LiSGDYDArQL6fg0qyAyzFJxO+z4TB1EtK2eAHZrMp
	YWNi9qPMu9KpJu5C0MdCdQceuRjb7I6RpvZAzxgNk14C5QPYDa9Mk1A78a5VsfdBlCVr1h
	bZ2dq8gCXY5dBptsw5RG0R9iA0yr6Ts=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-170135e43c7so2020619c88.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894760; x=1793499560; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/yyLuz5UaStjKlvh7yTZOlGkgF8Ibo7+n1CkWw0SmUA=;
        b=W6nrgIZOKM1yuVFAT107vWVwvwuFPehg+DCvCDnpPAu3C52j6ZdZuNRdzeZenRhHz4
         hNCXG8hGIE11dazIRbFkMrQvv35NQ8T9Nv8xlxDRmZdui7v8t0J9k+KitDEi6kBZQKkQ
         POxseOrZsVhKtq+0Cog99Ctj8p7vO8LJpGN1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894760; x=1793499560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/yyLuz5UaStjKlvh7yTZOlGkgF8Ibo7+n1CkWw0SmUA=;
        b=tjlpX49a/3IthURZ0yxQToL/A4b1CDbJ0ZMwxUQfICGmTZqguUBppklE9fRTuQ4M/D
         LmMggQZlenpBJst8ep3oDG8WwNFxwxiPuER91Vq9WS1s4pFQSpGH03QtUk/68DmguSIe
         K5JCPPDF7ibIPyxg/YffBUu3odUony1f3xCB+yOsfVoZIjoOt6N7XD+2GgFKlz1emzwl
         GLTqfnqW0M7AapcrSvmWFL4c4UwlySxQQZiQ+cOH6kcCuUKAldh8Sf4j+Ap47KzchBMQ
         NQ+NqPIbgF7EUO1JiIlayuzqK9e8APerFKzaouFdzDVLHsP0jcF5X+RZsfGr4ewS+IhM
         uOsw==
X-Forwarded-Encrypted: i=1; AKwUvByikuBOOlQsQeu1PFkEmldFq4Seo2lhTki0JPXorYhR0tn52hty5VoW+4Xr5p9XAIbrjuaSCtLISA==@kvack.org
X-Gm-Message-State: AFq9FYIOPEWbjXLYWVhzYgEal1vWKdnGi5X+yxOMfwYk0Hox7F4zWqMJ
	GNqnujZ0bt/fP2P1PbFtRTar4XKJL1f2xp1FMOTs5F9To/+IQA1CicUlernWKA1lGw==
X-Gm-Gg: AYBFou2Rdq+WvjXBmQUfwvn2chbMRbtFyh8PuDu9efkQ5VBG0vMfpIa7E47vfxEXMy5
	rvNVgiYzHTrx068IwkGFa6uCkmgqUwF+8wKltWwhUKJwKu2uz+rzWaR5Ty4Xxe+bmETQmN3rGgj
	xfRMVlidmgSxSjb6HU77X9msc58WtQDd3H3aIofwk7mZKkpO1YRr5KbI5NH9hjnMLfP4lBc0v3D
	Yt2HUMtIMC6z0SK2IbzCCWCems72qJ/9GKCFME0rwSiPYnm7eaQYx3Ge7sS601d7mAmH4AaBTlp
	QulnbFs3RUIQsQB0qVD8AEhGJTd8SU+pd0XaRHuj/p1MFzU+lzj2hgZbfakWMarXMmEce890RBC
	8DcDJ1ftp9u7Wy6iVn7b5GLWdd2Vw23yUtJAzHIaH0bTGezTiotk6s/35z0g5UIMH4MV7WLjCQU
	+ZReFTLilUHMSjR5eFu12lg4/om1iSFtRXf1vpCQxY5JHF5RkRDu0hvD24epBxiwu9kc5E++6PN
	eQytPJ5YIqEtQOktzDwpc+Tgau1XHP11HjvBX20susKlmwwu0mjloNk1Aa5jV/jSCVOcfWCpMO0
	JhGE2hOGg2vhRSdlFmG8CmGQNqe2nj1bMCe1efxm+CdBUAb1SOxYKF1yuMfx5hvAKHRSAKllM0I
	qn78C3J9MOQ9kwysQSw==
X-Received: by 2002:a05:7022:3c8a:b0:149:cfa4:9b3b with SMTP id a92af1059eb24-1992afd1fa8mr4068951c88.3.1792894759858;
        Sat, 24 Oct 2026 19:19:19 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:19:19 -0700 (PDT)
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
Subject: [PATCH v7 15/15] zram: use a singleton compression context for recompression
Date: Sun, 25 Oct 2026 11:18:31 +0900
Message-ID: <20261025021839.1542805-16-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 53543140009
X-Stat-Signature: fhrtdr59y397twdwi3u99b8d53fc61jf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792894761-282554
X-HE-Meta: U2FsdGVkX18M++ZYxgl+KHR7NrHSeWgJ1SfI1uFW3J2jGY7Gwvhq6xJht7fFf3/Rwsw2ZJxna9R7N/G1qHFTD4PKr2zL0AIWb+UBMSho61el2kiTWZv/QKaHLzdYYBpZUQYlqXd2fJN/Ouk2uLTQUboPLsYiDqcIMjB62+87h2vrWvyS/DKSGFAgO22JEQBWUh/8kYhw78DXW+Tx/yAxOFsXx2wMC0zZiGNCXP9ecgcypFLDDklHMxwgumeLdvVM+1t5uon2b7YleoXMPq2uTKBVBPKnkbAzCsaZOAABQzuSd2jM3Qh7DYV/cyMLU1vLoveGnWhnPZQtJeJcoUuiIrj3w5E/OGDbhL/DODECwy5dOM+qACMG9bfwqh3EXCglJMhra+gwa0VhB6bEpGp6s3Fv+YJQM46pX6VWaTlMTEtOcengOZqa5EqdsKwGXUh4Aki9ry3c306C7RWFSvnrdbQMFWS9KyVXGCJO9FHFB/xu4kN2RK6GglL/OIUE21hcq6nfD6aKSGjR015lpCzNBW5xhlAdQVAuZDpPXXVACIltosfurxk7mP0SpVEC2+/0xu2yTPGA47zqTCl2CR12ZbkoC+P6OXMd/R4gAeqz3kmYEjD/DOcPu/8kvFhu/INu3bu5g2CocXbIM/5o3ilZCUX9fLwJWhf3fW7/SBCgvr7LWzra6o1Z7z6Eg3iigrLD6ACXelBrCJNTvv8dYEa6hnO/b/BBR9Rot+83R2e0FRFXdBRixsTPU3uVM2iTZi4SZ7aTaEjz8tAtJ+Ysma/J6L9Kay31PWOx3wIeO4iuTVnzDEgCfiw9JXQN3hfPUCxBWX2OIa9IPTIifKNDzcdlY7lAUQvcdrAghUL+QwL8kYw9uuN7kLOVuaD+hictSKiJH+ZIGgpzsze0LzJRDRqH7dZQwMrKaPjX0UfC4OZpXG9Uo2kksBpmeHYuPD5oN41VPrTR+mG3+JUAovgQqrI
 WBmDHjSV
 ABAGpy2uW33aQfsemoH9foQiA7TOoiOb4VIjf6iVE8nvJVz+qf8JMv7OrsEQXFuYonYqG3yFIGj9rp6ss7iqBMHhbaHomfMhoqUQIr9kCC9LmFSgIHPRNeOQChQvd50T86Wcx/E9DG1lBV73whnwBZhKpnKdb59jAG2hFOfGUuRGa8lsjvL7+pp6ZXrzNoZgvBYYweBy15wWucZ4xVOHDiEtHSm/Sq3Px2VZEMoD7kYgJoW8zevkqQRy2YWdbwerwK3gAggzUXWlAk3a3e04JutUO/s/4tuTtQRjJUEg4iD5+QzWJf5/Rllnb+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 72683f91313f..ad8c7dc73922 100644
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
index 8d55b1104b76..9593c14a1f81 100644
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
@@ -2920,7 +2920,8 @@ static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
 			continue;
 
 		comp = zcomp_create(zram->comp_algs[prio],
-				    &zram->params[prio]);
+				    &zram->params[prio],
+				    prio != ZRAM_PRIMARY_COMP);
 		if (IS_ERR(comp)) {
 			pr_err("Cannot initialise %s compressing backend\n",
 			       zram->comp_algs[prio]);
-- 
2.56.0.257.gf7497c7d27-goog


