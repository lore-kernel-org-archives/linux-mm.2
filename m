Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA4F606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ByFMGpbm
Received: by kanga.kvack.org (Postfix)
	id 654556B05D1; Tue, 20 Oct 2026 22:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B476B05D2; Tue, 20 Oct 2026 22:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC476B05D3; Tue, 20 Oct 2026 22:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D95C06B05D1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:43:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C1B81A044E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:25 +0000 (UTC)
X-FDA: 85345087170.04.3BD5D6D
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5BCB5100007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ByFMGpbm;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550603;
	b=pKH/YIm/I+J+sKXvUKEGaxiiHILMI2go+3WWyodWL1taNgbovwz22TJxJDAa2Av2lmMJQ7
	XHghS1K5pzNP6wJB6HLPbFNw5TN0T5j33dfrIlyBZtn2iKdB7/EoBn9w4D/N7MVUuznuLW
	wyDmAzMh+Z4jEZd+WtJUfC8r0mSaVlU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ByFMGpbm;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeOSor/7asw+7lrqLJjpFf8NPmnjTqTqBdeuEnm5rMc=;
	b=gZul0Bq28Nv8yLnYZ/AkL9iHEEGX2dASPpdEU1GAX2xRIGMQjbsCzw/w4x4K1EIpQcLTtZ
	F2/tyAR6A+XHoUe5uCDsPMPNWj12w6TozwBiURfSf1O3nKmyjO4edY9JS0qWHhCfMu69jb
	Rbw5mkFEdXoU01zMVEa9Sk4eetR4BsM=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-15354aa70e8so779112c88.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550602; x=1793155402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jeOSor/7asw+7lrqLJjpFf8NPmnjTqTqBdeuEnm5rMc=;
        b=ByFMGpbmNsS3Y1uTI7dbHdFsi6bfJuypOKJdgtvNQvECHcI89fNhu5NrSIX/wheZzw
         nZh9wZLh4UHcDeLiahp+b1XgM3JmjIpw2PvmSXcBrBtxyRQLVLz9rHVr39298dpEHkLf
         4we3/0JB5xsZDWdxEMeXwpwi0lMCxuquz9XK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550602; x=1793155402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jeOSor/7asw+7lrqLJjpFf8NPmnjTqTqBdeuEnm5rMc=;
        b=gVaPbf747mkQj6olVeZn+Rf2kacD857bKzNTF9rKxfQ8QyBq1jUFNgK06Ob33VR4mF
         BtoVHKQpDsg3Tc67urtYNDufca0SLpmcfBX+mqqgXDXYIpmttUEt+TiJwmCq58+PwSjs
         w7XMoqjnyyFIAXGeO1Sk2dQpFU1fmUuFjZoARr3Xjb5GAwt1I0QusxMCR5RU7PzP2t0w
         PZZZCdR4JFLQDfDzFu7rari2cFhuH0jNy/UDG7PVjg7vsWH0jTMfAx3Kl6oxBS87Om0l
         AqBtJKsFmxD3jpNWb2FFbW2GPe6cPsiZ+bJYVo9/Cdi4lNQmRnrfi0eLVy7Cmrikjbs7
         cWgw==
X-Forwarded-Encrypted: i=1; AKwUvBx5ORPhGGWVJNkbNwNWSCyrvjOGy1Mkji0Z7njhUti2uKArY2IdeylQEbOCee9SXpAXq5SjIE+20A==@kvack.org
X-Gm-Message-State: AFq9FYKReXsdFBSmfY9vRRPI3spd9GJrPocLXoaKrtowqPUYCYTI2TTv
	26J3csazrHD9fAQA69CKzYjfBrLmTNQRZ5YaBMVFYmJd8Yo62UxJRy2Bxbg4Zhv89A==
X-Gm-Gg: AYBFou3ssbYE/Bn8bcXtUEvihQOeDbGkpXsEjKrRB/fHvh3f9LzllkfQ+RKOzTrF+H4
	Q58Wbdj79BywlQ7C6vtaXYo+Gbcwtsc20TXUf9Hp1AQ7Tqn2mIC5cL4dvcWhZWDp4jrO40mRu9B
	4n/TVU7JDzKnKowBc1NGo3/llLmSUeQxgwmLHK6UsUHJBFegOiEXFcDRKY1adYpT5FyyZ4TGSEM
	altkKs1uwVLT91oJiO9IKu6EZ+g3YTR80A6jaVD/iaxTdVczUPtqGIQdyAyf7eS9wWdbzAb7W4P
	Ytc0KT1PH3qPN2983AGnmKOlKQzVrKbM+7OYkXdF0VyL7epgNx78pw7apBxy3g5EwEP/yG/rEHf
	7iDq2uqyPmpxOkF2lc4tcR6tZqwkZrrAm7J8PqC4TLVV416K0XwJJLpYalJTVoi37j22VGkRNIW
	vhSqZx79qAXV2BJnO9Ew/BveqULfQkqSxbm6sRm9IhKNK3C5jyEwyexfUqzmGZ3zzlfErN+HIaJ
	6E31d4D+cUKs/6J2nzJKm4d+Wsgk3FKYYXEGKtWsqORIqeuK7IXTnZwF/nEzIpVDSb6im/+ppeZ
	3jsKmtOBMe+xtiFSzrSDmB7f7XnH2JnOlCsij8O9aLO+Jg==
X-Received: by 2002:a05:7022:929:b0:14c:be8e:69fe with SMTP id a92af1059eb24-190a051dd50mr1271104c88.5.1792550602131;
        Tue, 20 Oct 2026 19:43:22 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:43:21 -0700 (PDT)
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
Subject: [PATCH v6 13/13] zram: use a singleton compression context for recompression
Date: Wed, 21 Oct 2026 11:42:23 +0900
Message-ID: <20261021024236.1787884-14-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z3wygkon7sdxtcg9gmuwxu8sp68hkuxr
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5BCB5100007
X-Rspam-User: 
X-HE-Tag: 1792550603-147471
X-HE-Meta: U2FsdGVkX1/yj1v9IvrV0x6XbIbmPVYzUvHNNRufImlAFX/bqIFUJtnsOfmIiko5dLI0L0E9th68dlDT39Jp5QYBJLjIk/7plka070CuACirSeAQCwgrp3Usb8a03i80BIThu8mPaZHbpk8kITp2ONZ5oChIZDfL3s0zInS/vj8e3p4VACTo3pmdZmMvceq6eBifQO77s8dO888YgvtyWREzHX7/yPw2MIRLK/T9Kqd3zfy6Hik4W2Zu2DsY1zEd8DY1FzjhpN52CXpmonEPAIdv7RPN0mRRnvtOqbryAtYpmf7KErH9uEbFwsiFToZSD5K5Jzp05cO1UY7IBr4d1UtnMyOYZEkDMYiHHAxuIxTzwv4kbqIG6UUeufKKK1ehNmGPbO5CXjEKPhn5PRiXadpWRMmIWaRftEelCZ8K6QN9lryzEPGD1r1Ruw3kLexjaNC9mDNdK/oYOxY+vUVbpbP1meMnHlASSsL3jqeC6/PMvri02pyr5JcUH9VD9HN4P+OgO1S/bZZvNSjn+TEqxLI714ynE26vvCCRGv/RKVhfztVXr+BCTVLyGVYD7nRc/JfT61O/MlWcwNuPQQqY9NHw/SzE2bT6xGJNw6LS1dUW4BZLabFo6tLF4/jMymcGGXIY6oOYvsYbeQ+F53r+mprloWnKknptSvIgZpuJmTKXUu2CzM/rp+VROAmt0FDwDw3IuMoGMJVROBiY3Tx4qVmXXkcgUhpdTaVlD9HlnZQynrMBeQoebRqlfMf3E/ebrbZznNLJdctO1mp4c58gEvKZtnISTy/XqLsu2TElPS41lROsUxJGkNqwfR5d1Sf43o4cM1B3ye3hIeB7uekls8KrNEfO2IpURaZQsQqQ3qwdPc2q0Qxiu0xGuWQVVHMSpQngJfwmFKrZ+NgQakKhkNkg5qFoXE+wo1vRgePMskNAao7lKiBgyqKgTT17GENd/8vqgs2z9mCUBi1d+jg
 uVdUByDg
 GP1tf8cpNCxX8xEkykk61OpCAhJwk29mIzh3FjkgmHWVb3ucIaI8Q45GMvrSOF5X96CBYrKYEtfqbjE2v86SciLzc955YD42CkCgLkPGz2G0lPELQaiBqY+NZsRLZ5uGc6C33BPWnmQk321bsua8/gM2C36z65AcNVuhT2SwGln1bEKlwAuOB9y8LdR4qzDGcM5gCWWLoj2gJVHxFeLKg+qf1wqDlLSOeGmS/nfcqyhaMzMwNPvTdOknSAM74gVjb+J3nyg+byuHMkBB3FYyqQ/upUBIv3Tz0HWOIdyLSKvbeeEoqfvpgBtBUag==
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
2.56.0.212.g129ede20d9-goog


