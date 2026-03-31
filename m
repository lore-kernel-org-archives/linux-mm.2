Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5682C10F92E9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCAE86B0096; Tue, 31 Mar 2026 14:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7B426B0098; Tue, 31 Mar 2026 14:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44896B0099; Tue, 31 Mar 2026 14:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2FA06B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:34:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 548471B7A3A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:10 +0000 (UTC)
X-FDA: 84607207860.17.0DFB5DB
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74F61180010
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZcSaltk1;
	spf=pass (imf24.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774982048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VQr8VStIW3khugMggzICz/R/RgxNPfHVnCtjXQuBpc=;
	b=03kPlnBJYXHVgje28FAz07zi8olTsWkQ2SX6dnImmgYK0H0/HVZc5UsC4Y54vuw5UJWIg1
	AxQNrue/AIgB8OV14sbrFE0wHaj9RDA2jZb8h/o1GyrbKfc2cwGMdbxL9SyRDDSBQu6ASR
	osmrhHUm+Y1P2fVfIpFoCijQKlKB3hU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774982048; a=rsa-sha256;
	cv=none;
	b=Yj6TkjPbt0SjfCdr2mUhIlyVtqNGwBMLEFPl6Edxs5mkQHJ1TbIFc0RP/wT+FIxvDNkyiu
	4jJ5pxiG0tCzwGvhZdxCQdz/PTvDqgL9kpu6nVuTbfYeROUyACY1culHAyDj83Jw9cOGtY
	nG4w4/ekfI51cqdmLE8psVC8JVcocvE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZcSaltk1;
	spf=pass (imf24.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-126ea4e9694so1014055c88.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774982047; x=1775586847; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+VQr8VStIW3khugMggzICz/R/RgxNPfHVnCtjXQuBpc=;
        b=ZcSaltk1OOLz8z7yk/FkS5Idxca7EJDBPhQcp3nfT4T40Cv3NWAtPWuOGvSYIz5Bi4
         FkQb2pth30cT0WL9Mc5CYjx1zFZB2+rMc5q+UuqYq4IEsetwgtxRhXl8yemiGxsCrOam
         tVrtYd7VZO50GUqf9LwIJ2Ca18GFr2Ahb+o3AVsoofl/qp4FKp3aveSjDtzzXA28XjiM
         XwSlUx5DjqNwKIEWgCIgecxlc8pFtF/KiGxsE4zl8PP+nVYosdDCYmuTxv7Iv51kECR/
         57/fLFocdKP2l6Sm8ojY+iyE83igGTH6MzPJK6mweOhRSB6P6t7YQ9nhHj2oMBT3u823
         EkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774982047; x=1775586847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+VQr8VStIW3khugMggzICz/R/RgxNPfHVnCtjXQuBpc=;
        b=lzCeUJU3F6AI+C8milyKwCDBJ8HzznQ3HOxtJEKTI9Qa3l8+JoSNMKu6xJiDm6toWg
         vw8k5Y5lZ/X7JwVUirdgSxbUdCyAj93fDBVntZa8nnqf9eOa61e+zpRtzH2lL48xag8S
         9KMPtAMcz9w3bsUJyVbadGUQLmfmcl7iDWXlwmeysQd3qkPGlOFWZnKDMRam7JnlHdMR
         YbuRUU0REzB15jmzDTJmCAHS+t3Lsj0xLCsedit361e/Ik1jcldoqvGB+D7KQM5xm5b+
         VyyEp2muUfsVsvm+qBdmQ6rYhvkvc9/rUa9lbg+qIPi3d5A5rsG38przHs4bJnZp+RxG
         vaug==
X-Forwarded-Encrypted: i=1; AJvYcCXZ3bvvvidPv0SileocgXQ+KwQEX3VuApgyH1hZds+FPsfR9glGtHnDxaV4kEhA7I5oUp+7CADuSw==@kvack.org
X-Gm-Message-State: AOJu0Yz1ZdZlG+8FOt8Laxksc2dzyC3eehRKZY0AX9n1WVtXU3+V8UKm
	gYq0NbFXdjIq66Wwcw+BW9U5Aw2n7Gto9TDS39AEa6KBf4GgQFhU3Fir
X-Gm-Gg: ATEYQzw4qR6D5jRH5wTm/pINb1PdbTExT4FlgG1yiiqaIbuNI8MRznswJDeRcgyehrQ
	n9DEcazogHfUAssGZS9+sKICukux18eqevZHclF/x4UNJPih1yhZawn2xYCWfCVeABhSow7GMOt
	hUwH0Ao6fxvL9SS7Q633T2T7s+zYD0sSVv7dvobSk05bQjACdqoKyWH4OshS8G5CCkoWmL2ZClo
	pN2e3/6ux/C6ai1WDbYpZKJ0wnPPTCTJY0s0p7zIb9w450qNA5PqciazN60MEzR2RSh22EB6u6c
	BA74u65BVcCOVbwVljXxAOg8TrfX8DeQ/FKbXZPxMybLVdpQ4Pz6LvBqRihCFuoRGBljGzLJqXq
	k28P8TT4rHQncrSx+s52oTAflb/+JSYEmS5D9B1xaL0pGkNBn7aX3tzK8W4/t5BtVxrFvN5ZyDF
	neTCpFIFROoXF/tP1Yf4sogkEJ/NAkY5Bx0vPIWQ==
X-Received: by 2002:a05:7022:ea22:b0:11a:61ef:7949 with SMTP id a92af1059eb24-12be6473dccmr353198c88.9.1774982046977;
        Tue, 31 Mar 2026 11:34:06 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ac4a0fa8dsm7961271c88.15.2026.03.31.11.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 11:34:06 -0700 (PDT)
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
Subject: [PATCH v3 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
Date: Tue, 31 Mar 2026 11:33:51 -0700
Message-Id: <20260331183351.29844-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74F61180010
X-Stat-Signature: 7i8t1mskes4htsmd8k8nwo75srf3nujc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774982048-413505
X-HE-Meta: U2FsdGVkX1/aHxqtno783zOhUviIEUkKC9I4Qp3UEGZZKBemFJG9WcA8F6xciEDwBVw1eLSOTSlajNChbXfVy3jACoOaKykGWrA6MUqP+lP2Ig2jWt9zUAPOwwXJyTQYkNWqSC+4TdTL5aePFjIVy01IVS4pvnYIMswwJxWIp2nQW0j87RGOborsSysBBMjLEoDjYqosCoB9SWpX/XRjuldoCtaw/2bWXtRn3xFTHTqwI4rMnnfjZhjevjz9oqgIF/kcIFN8B8OR52fUEPbN0iK6hvvTGKwI7F1GHVFm6e+aWoClyvBsbPOhkQ5OVrQFfkiXOrEcYNB51HG0mVCH94BNMbfQ9RRb1KEN76dRPcMpWl0ou9HsXukiOIte0wT3C50RQD/+sVIz7HeOA5eOXQ480zqo9nCI0EgsI7ype68rNuCByDdQgG680aSdtpb7LmL8cxiV0+HIdVpRvRqbDAer/MCpDz+bR2cNHA/o1b2VTsmv/hj87CHbVLikrXNuW1Cyl5SalqlSJDJqxSw5MWwF9urdM/OKFVPPHhHscI7w91d6rOsrFTV4n+tW01s3klR0yBXuBsxvabb1UnX4FgDxlgJLaN+h6pXdznS/fDp746/Xz+cpNfEoEHdDnedfUcdhSwrzsUdlgOJEv7kFn1Rgh4WyWf+MZumtThBOMb5+j3gVdzwOgxOqJjDTWh43vbioHbDrOYxg0VnYXhP3TtgENv5uWy8ldnK0speWfjvz+408Qb2V5ubiMEMyCLAhrbm1BNliU+kvUVI6OmUhMaeYBAVxPJTsu4QAyXr+lSGY+8bWtmLt6qvKq6OXf0HI0JTmZX1eYha8hEypxvopkGLFG0bLX/PtaF43VkbrRnGK2fKubpYQHHmbztNH2WXkUxIlL/zYrfYLlRgO4MJQTXbxxwHWdaKYpYxLMMjSCceJ19eEx5XHQhTjay4Tmm4tVdlONxqIiE6d6647syG
 KIP2Pn0b
 qXQ5A8pfxjsRL3DjwvKxYD7/cMIMQP3XvT7NyBHbIn0naVo4IwCGabIOZeORGrGrVPo3kPQohgoYXPM+ZINxiVolbloI3brQ2klD3ApKLGbi+SPmqVqlrNcjjTXX5JIJhaIbMDgEx4LonQ7WwnNQ3nmrLh5NnjzGb0WkAAzD62hyGH85UpY9uMrPyGLub/+LlvkUz7gHrqbrJnGs7taOo+63EnYOR4w1q+iLlTUmfeuIC/UzfbWFxETvWoDl2ejSVxjcTvocTTDpNjKXjzMgHVJwmOkKbDYgDUt6Cv4XxeBVEJe1jarw6GlRgZxUGVa+8mmP4SBsyVIKPDXVeam2swBNNZTgLMNK4VtqbObX1W4Ra0tyZ06bSnn8XqWKFYLcZhQIiN21Pj2cLZZiLoVi3ZYyrzAPZBrCert2KI5G3/22cNmdpieYbccahmrhZV3dFjQGe1svkETC2AoKIn9MIVinSj5grDGWwrIHuyO8i7SgDyg+/FuPt1+C7p5RdeEeWFaoP
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
Acked-by: Yosry Ahmed <yosry@kernel.org>
---
 mm/zswap.c | 180 ++++++++++++++++++++++++-----------------------------
 1 file changed, 80 insertions(+), 100 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c59045b59ffe..4b5149173b0e 100644
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
@@ -975,7 +955,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1795,7 +1775,7 @@ static int zswap_setup(void)
 	ret = cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE,
 				      "mm/zswap_pool:prepare",
 				      zswap_cpu_comp_prepare,
-				      zswap_cpu_comp_dead);
+				      NULL);
 	if (ret)
 		goto hp_fail;
 
-- 
2.39.5


