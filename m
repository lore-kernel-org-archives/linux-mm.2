Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A3A4FB5EA1
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 01:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BF96B008A; Mon, 16 Mar 2026 21:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CAF36B008C; Mon, 16 Mar 2026 21:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA676B0092; Mon, 16 Mar 2026 21:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 614D16B008A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:48:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CEE1B92E2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:48:24 +0000 (UTC)
X-FDA: 84553870128.19.AAD76A3
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2411D40006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:48:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jGn1sifB;
	spf=pass (imf04.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773712102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovJFrvNdn0DpMq+zF+ycTp26h9oVszt5lPY82j9CwUY=;
	b=trhbLKwGoFlSg/SPfQGFAHvgKxs5LYyqBVEp1/9l3myE83F4uFjxNOsN0lD1YCUAfst+2I
	if/KLBNnF4g+tvlIIYXb4H0I913wWBW1Tm0l8QmJnLcUw6BbEjU0OFIeybZkgmJU0UdSf2
	gaEqpzwqQlrONhncr7he2MsDjCzWy+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773712102; a=rsa-sha256;
	cv=none;
	b=gnB6xL2xgam8ck7CTY8SZi0O72FR8N8VgGwVgD+DrfBHXR48rwfyxBxhUB8lyXOy5dXRa+
	gi2Lw7EyrI/OXmkRoOMC8JIOREPBD9jAaaUtT1YUSWpZKHieqBo9I66AghLepwALHf4E5s
	OoEpxsslWhvqQwPwv1DrXVrngpr+rgc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jGn1sifB;
	spf=pass (imf04.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so4021266eec.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773712101; x=1774316901; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ovJFrvNdn0DpMq+zF+ycTp26h9oVszt5lPY82j9CwUY=;
        b=jGn1sifBwH0RWmHtXrZFFaA/NP7aNhydsJhXSirAabyvH1T2skEACI2sLS5pgnP87d
         vccQ88LUbhr8/FNXM4DbS1WSrD/26konYVWbv7qz9dBQe3F2Rpeo4wGTptfzWRbJ85lX
         sOFgPZDlsLyg61jGepvJ4kBsxw2uJFVqw5I62j0E3XtgUL8mvnEFkuqKgEqkXAxAFtaL
         39bcxesgT6UE9rBtP9X2Cv0y18IAVeLBTfQ9Vgvs5qvID5YXzX5VlkKBa6r4ZQSzwtOx
         9XWRwAFkDN6dewzXSOZjw499odXfj+VD7axNIlR0V8+9hkK/kz5BtiNt2iu96F1KPE8a
         hLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773712101; x=1774316901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ovJFrvNdn0DpMq+zF+ycTp26h9oVszt5lPY82j9CwUY=;
        b=TikVSxe9MbLQqYSDJ6ZEwOlDGP8dbC3cn5WsoD9xvgXrgmNM3GgWYQ56kWBIJ0eecW
         TGzj/KOgLWr53WK2ZuWPXb3aSpW6C0nl9ETts4Y2DZ3xw8Qq9tqDEVI5xa8NrnK9VKHl
         sEUTxrpFSpuQESncD/I21lNoez8ARh0xF+B0lpK8EJ0goMghnBozNGTEKyUgeNbMiV8Y
         l3SPiJ/A8u+9pzN6xAaXwpoBSQ/lmtIZe7ftdZlp73wDT3xYmsqVfQrrcjOvrVJf2U5D
         cfZJbgvv6Cb5fNY2Np0KiwfrQuKJs3F4dH3M2NgpsHBgv9CSb8c8XLmXPiy9HtRrEBAS
         1mrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaaNs9kG2VyOx/jOsqfq2Qvvq2HQtJ2dM/W6GzTNhaVNJWkQMceQHYVfCnuS0oF8D4kQdeV3N13g==@kvack.org
X-Gm-Message-State: AOJu0Yxg2yQuKNfHv2yzUE6jU7FutGtIICtTnk+5ox8RMdo35PLiMsEY
	njPEADB3TY8WHvUVDlMRt6TwVmnkgenutVUqliYKLoGZilCCWEm51d04
X-Gm-Gg: ATEYQzzEsQ5y2PQU5C+ojskjcvK2k1IglRySiQs88cQR28rSI5c4hp0mgsPBXdqGrcC
	Gt5HKfeukfXtLfmgrVTcoF6QblX0EEGgGVCk/xIrLA0sYls5TEgxUb0PlC7MCfpzJpSDgH3CnMh
	h8cI46LvmLD1x1Z4tFPKUndiaXcHoNvcanaTYKaTJ9FbklA8cifkRvvc8cmtHia5TJp4QcqtIsy
	YcpwPbo3/kHq/ARcu635wrW+4UvySgAVLlWqAAtjjmZ6Y04toQix3RlUAMyJlDIuUd2mosjj+2z
	dBgmP3tCY0eZQ+JzKcM1TqtOcSWpaOmGey0ICv+GOyr/H+g+9NTQBt9/za6szw7Nlbgq7d6rVOl
	RrTGlupNDRVCdlkuYlYO5H3zkWcQZGFAGNEt+x1KDcxyc8wXp3UMRWf/dPGWPVA3TAuHjb8bdCD
	yXm+JQSpjsZWi7qZtYnlHxZq0AYNxPNi7KvzaJ4EXlwnATzEVO
X-Received: by 2002:a05:7301:2c89:b0:2ba:7b71:4f4 with SMTP id 5a478bee46e88-2bea571f88emr7143066eec.32.1773712100812;
        Mon, 16 Mar 2026 18:48:20 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab3a12e2sm17931130eec.2.2026.03.16.18.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 18:48:20 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	kanchanapsridhar2026@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	senozhatsky@chromium.org
Subject: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
Date: Mon, 16 Mar 2026 18:48:02 -0700
Message-Id: <20260317014802.27591-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nhamfa9xpp8yz9sg55u6948cm343mhns
X-Rspam-User: 
X-Rspamd-Queue-Id: 2411D40006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773712101-525503
X-HE-Meta: U2FsdGVkX19LIkJ1bNB198QYiAqRfC9LLIzOtPrCcuNqiCxVzCw4A8++/TNwFeKVJrZ/1lWzyA3pent4Ib3FUIJYJoxSgsAcBmaNVfo2gQYT7zYpZaKJXuX+KTOlVIJaH18RnRDoZin5gU1pq/KyIf2p5lwUoOFAmeQt6MopBpVysoAUmb8JiOSHbh8BiAerF2A7mz6KLSAddpLrVpLP9/I+BIa7VJ69urVZTo6p/UKsmbImPZAF3VzZhSrZ1Ti28/Q/sC9hM5FxPN5V183sl8GOOluNPd7oFp/c9R6DmTcxj/V+iAHH1Q9PAngbTLV8D1mloQiMLNFWTM5aSuZPHf72vIlMkOdZblb8hkeF23QRK0ampV/L0LAtXFNRcVOk06ZDP4ajEb1w8jY/YlylpTlTXeknghhxFRmvTn3oRrJrhmK77yvC9xy6Zdrr32PVSh0FsjEI3TkBtTn5NsKRnx+FheM49IgzrZFep0qNUu9+YvWooR0YW8rlf7q/hSjPcm7n0rslm5PZWiDZwTXHCl/8Yy9vfij0QbciD5KLFhgiUuwWdEkknY+FEYzGEJZgFmkDdv1Q/9oCW4QGgOrh/4XRP55TjSq1vh7Z6UGjxpWOkZMuaa/Gsi+qDEQ3266RyxeHLSz+rUFQ+1W1uIOtKEYG3JNlw3i+ZutgStkhs8sUnRqaOL1HZPXqbpkAu9S9Sl4JT+OjNp+K6/SGXR2EFibQDOtjxum1z9tLDK8/rKvxQjTynG284/7Xae8gywzjLhtB/xx89I+muSWkWwr31x5Vmkaiu30S7El4KmfckS7Zi/sz6aBD7WUM4p9LLCOuRx+/TQFeFO7VxKH1jzicvI45QNxt5+PwI1fwR6o+eQDn3f96LqTAecgYY3AOwodjQjReyOx+YMCxWlen0MxiJGS6ybLQRA9c8U39zlpDQrQlByJ867WZUe3hPEP6xZ4N6cUJhAJlBT2SKu2CDjH
 7F3pKmPI
 oRkPzoNhlwx8/XGKqEPfr92IG5pzCSUWxjEimEoJiT++CmSw3zxyAG9QXHEGeyG1zBq7zjFrtuVagGGWw0ZQ8I8HprN65mtDn9UraeKjxqEEFgZ65P66Bw9O1rjBm00tp+7UB4auDw4sGu6xYHoiKxDWRKPSnKqAaRcWknEiEWqoxDNlkSNHunoVD5T+KCQnZtKDcrIsH0Zh/YHVOyFinQq8tzPRd0equdwssjo5EeZHfGjfBdZEVVg2KLF4N/bLQzLzsVRAZGFWioOUM9UNtJevw0cHctmNcpSzsoNKiNFk1HBhc8LMihQIt/9iETt41zLaa/5cZ0Whs7RRuziGlepdw433ZDRNNsDcsy5d49R4U9dK7/QRbuko3642yORUqvIj+Q+iFbB8xuUHAwuI4NOu7ClYh16kqwvmY9qkRSpPIrhw46RDkKOOil3m7v/jwLp40/DBGaGbCUT+czYIMbHSvKGre6x69U0CNWHGv10R1Q10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
hotplug, and destroyed on pool destruction or CPU hotunplug. This
complicates the lifetime management to save memory while a CPU is
offlined, which is not very common.

Simplify lifetime management by allocating per-CPU acomp_ctx once on
pool creation (or CPU hotplug for CPUs onlined later), and keeping them
allocated until the pool is destroyed.

Refactor cleanup code from zswap_cpu_comp_dead() into
acomp_ctx_free() to be used elsewhere.

The main benefit of using the CPU hotplug multi state instance startup
callback to allocate the acomp_ctx resources is that it prevents the
cores from being offlined until the multi state instance addition call
returns.

  From Documentation/core-api/cpu_hotplug.rst:

    "The node list add/remove operations and the callback invocations are
     serialized against CPU hotplug operations."

Furthermore, zswap_[de]compress() cannot contend with
zswap_cpu_comp_prepare() because:

  - During pool creation/deletion, the pool is not in the zswap_pools
    list.

  - During CPU hot[un]plug, the CPU is not yet online, as Yosry pointed
    out. zswap_cpu_comp_prepare() will be run on a control CPU,
    since CPUHP_MM_ZSWP_POOL_PREPARE is in the PREPARE section of "enum
    cpuhp_state".

  In both these cases, any recursions into zswap reclaim from
  zswap_cpu_comp_prepare() will be handled by the old pool.

The above two observations enable the following simplifications:

 1) zswap_cpu_comp_prepare():

    a) acomp_ctx mutex locking:

       If the process gets migrated while zswap_cpu_comp_prepare() is
       running, it will complete on the new CPU. In case of failures, we
       pass the acomp_ctx pointer obtained at the start of
       zswap_cpu_comp_prepare() to acomp_ctx_free(), which again, can
       only undergo migration. There appear to be no contention
       scenarios that might cause inconsistent values of acomp_ctx's
       members. Hence, it seems there is no need for
       mutex_lock(&acomp_ctx->mutex) in zswap_cpu_comp_prepare().

    b) acomp_ctx mutex initialization:

       Since the pool is not yet on zswap_pools list, we don't need to
       initialize the per-CPU acomp_ctx mutex in
       zswap_pool_create(). This has been restored to occur in
       zswap_cpu_comp_prepare().

    c) Subsequent CPU offline-online transitions:

       zswap_cpu_comp_prepare() checks upfront if acomp_ctx->acomp is
       valid. If so, it returns success. This should handle any CPU
       hotplug online-offline transitions after pool creation is done.

 2) CPU offline vis-a-vis zswap ops:

    Let's suppose the process is migrated to another CPU before the
    current CPU is dysfunctional. If zswap_[de]compress() holds the
    acomp_ctx->mutex lock of the offlined CPU, that mutex will be
    released once it completes on the new CPU. Since there is no
    teardown callback, there is no possibility of UAF.

 3) Pool creation/deletion and process migration to another CPU:

    During pool creation/deletion, the pool is not in the zswap_pools
    list. Hence it cannot contend with zswap ops on that CPU. However,
    the process can get migrated.

    a) Pool creation --> zswap_cpu_comp_prepare()
                                --> process migrated:
                                    * Old CPU offline: no-op.
                                    * zswap_cpu_comp_prepare() continues
                                      to run on the new CPU to finish
                                      allocating acomp_ctx resources for
                                      the offlined CPU.

    b) Pool deletion --> acomp_ctx_free()
                                --> process migrated:
                                    * Old CPU offline: no-op.
                                    * acomp_ctx_free() continues
                                      to run on the new CPU to finish
                                      de-allocating acomp_ctx resources
                                      for the offlined CPU.

 4) Pool deletion vis-a-vis CPU onlining:

    The call to cpuhp_state_remove_instance() cannot race with
    zswap_cpu_comp_prepare() because of hotplug synchronization.

The current acomp_ctx_get_cpu_lock()/acomp_ctx_put_unlock() are
deleted. Instead, zswap_[de]compress() directly call
mutex_[un]lock(&acomp_ctx->mutex).

The per-CPU memory cost of not deleting the acomp_ctx resources upon CPU
offlining, and only deleting them when the pool is destroyed, is 8.28 KB
on x86_64. This cost is only paid when a CPU is offlined, until it is
onlined again.

Co-developed-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 180 ++++++++++++++++++++++++-----------------------------
 1 file changed, 80 insertions(+), 100 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 8ac38f1d0469..6bdd2ed7d697 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -242,6 +242,34 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
+static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
+{
+	if (!acomp_ctx)
+		return;
+
+	/*
+	 * If there was an error in allocating @acomp_ctx->req, it
+	 * would be set to NULL.
+	 */
+	if (acomp_ctx->req)
+		acomp_request_free(acomp_ctx->req);
+
+	acomp_ctx->req = NULL;
+
+	/*
+	 * We have to handle both cases here: an error pointer return from
+	 * crypto_alloc_acomp_node(); and a) NULL initialization by zswap, or
+	 * b) NULL assignment done in a previous call to acomp_ctx_free().
+	 */
+	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+		crypto_free_acomp(acomp_ctx->acomp);
+
+	acomp_ctx->acomp = NULL;
+
+	kfree(acomp_ctx->buffer);
+	acomp_ctx->buffer = NULL;
+}
+
 static struct zswap_pool *zswap_pool_create(char *compressor)
 {
 	struct zswap_pool *pool;
@@ -263,19 +291,27 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
 
-	pool->acomp_ctx = alloc_percpu(*pool->acomp_ctx);
+	/* Many things rely on the zero-initialization. */
+	pool->acomp_ctx = alloc_percpu_gfp(*pool->acomp_ctx,
+					   GFP_KERNEL | __GFP_ZERO);
 	if (!pool->acomp_ctx) {
 		pr_err("percpu alloc failed\n");
 		goto error;
 	}
 
-	for_each_possible_cpu(cpu)
-		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
-
+	/*
+	 * This is serialized against CPU hotplug operations. Hence, cores
+	 * cannot be offlined until this finishes.
+	 */
 	ret = cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
 				       &pool->node);
+
+	/*
+	 * cpuhp_state_add_instance() will not cleanup on failure since
+	 * we don't register a hotunplug callback.
+	 */
 	if (ret)
-		goto error;
+		goto cpuhp_add_fail;
 
 	/* being the current pool takes 1 ref; this func expects the
 	 * caller to always add the new pool as the current pool
@@ -292,6 +328,10 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+
+cpuhp_add_fail:
+	for_each_possible_cpu(cpu)
+		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -322,9 +362,15 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
 
 static void zswap_pool_destroy(struct zswap_pool *pool)
 {
+	int cpu;
+
 	zswap_pool_debug("destroying", pool);
 
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+
+	for_each_possible_cpu(cpu)
+		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+
 	free_percpu(pool->acomp_ctx);
 
 	zs_destroy_pool(pool->zs_pool);
@@ -738,44 +784,41 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct crypto_acomp *acomp = NULL;
-	struct acomp_req *req = NULL;
-	u8 *buffer = NULL;
-	int ret;
+	int ret = -ENOMEM;
 
-	buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!buffer) {
-		ret = -ENOMEM;
-		goto fail;
+	/*
+	 * To handle cases where the CPU goes through online-offline-online
+	 * transitions, we return if the acomp_ctx has already been initialized.
+	 */
+	if (acomp_ctx->acomp) {
+		WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
+		return 0;
 	}
 
+	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffer)
+		return ret;
+
 	/*
 	 * In case of an error, crypto_alloc_acomp_node() returns an
 	 * error pointer, never NULL.
 	 */
-	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp)) {
+	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	if (IS_ERR(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
-				pool->tfm_name, acomp);
-		ret = PTR_ERR(acomp);
+				pool->tfm_name, acomp_ctx->acomp);
+		ret = PTR_ERR(acomp_ctx->acomp);
 		goto fail;
 	}
 
 	/* acomp_request_alloc() returns NULL in case of an error. */
-	req = acomp_request_alloc(acomp);
-	if (!req) {
+	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
+	if (!acomp_ctx->req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
-		ret = -ENOMEM;
 		goto fail;
 	}
 
-	/*
-	 * Only hold the mutex after completing allocations, otherwise we may
-	 * recurse into zswap through reclaim and attempt to hold the mutex
-	 * again resulting in a deadlock.
-	 */
-	mutex_lock(&acomp_ctx->mutex);
 	crypto_init_wait(&acomp_ctx->wait);
 
 	/*
@@ -783,83 +826,17 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
-	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
-	acomp_ctx->buffer = buffer;
-	acomp_ctx->acomp = acomp;
-	acomp_ctx->req = req;
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
 fail:
-	if (!IS_ERR_OR_NULL(acomp))
-		crypto_free_acomp(acomp);
-	kfree(buffer);
+	acomp_ctx_free(acomp_ctx);
 	return ret;
 }
 
-static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
-{
-	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
-	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
-	struct acomp_req *req;
-	struct crypto_acomp *acomp;
-	u8 *buffer;
-
-	if (!acomp_ctx)
-		return 0;
-
-	mutex_lock(&acomp_ctx->mutex);
-	req = acomp_ctx->req;
-	acomp = acomp_ctx->acomp;
-	buffer = acomp_ctx->buffer;
-	acomp_ctx->req = NULL;
-	acomp_ctx->acomp = NULL;
-	acomp_ctx->buffer = NULL;
-	mutex_unlock(&acomp_ctx->mutex);
-
-	/*
-	 * Do the actual freeing after releasing the mutex to avoid subtle
-	 * locking dependencies causing deadlocks.
-	 *
-	 * If there was an error in allocating @acomp_ctx->req, it
-	 * would be set to NULL.
-	 */
-	if (req)
-		acomp_request_free(req);
-	if (!IS_ERR_OR_NULL(acomp))
-		crypto_free_acomp(acomp);
-	kfree(buffer);
-
-	return 0;
-}
-
-static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
-{
-	struct crypto_acomp_ctx *acomp_ctx;
-
-	for (;;) {
-		acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-		mutex_lock(&acomp_ctx->mutex);
-		if (likely(acomp_ctx->req))
-			return acomp_ctx;
-		/*
-		 * It is possible that we were migrated to a different CPU after
-		 * getting the per-CPU ctx but before the mutex was acquired. If
-		 * the old CPU got offlined, zswap_cpu_comp_dead() could have
-		 * already freed ctx->req (among other things) and set it to
-		 * NULL. Just try again on the new CPU that we ended up on.
-		 */
-		mutex_unlock(&acomp_ctx->mutex);
-	}
-}
-
-static void acomp_ctx_put_unlock(struct crypto_acomp_ctx *acomp_ctx)
-{
-	mutex_unlock(&acomp_ctx->mutex);
-}
-
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 			   struct zswap_pool *pool)
 {
@@ -872,7 +849,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	u8 *dst;
 	bool mapped = false;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
@@ -938,7 +917,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -950,7 +929,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -969,7 +949,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1789,7 +1769,7 @@ static int zswap_setup(void)
 	ret = cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE,
 				      "mm/zswap_pool:prepare",
 				      zswap_cpu_comp_prepare,
-				      zswap_cpu_comp_dead);
+				      NULL);
 	if (ret)
 		goto hp_fail;
 
-- 
2.39.5


