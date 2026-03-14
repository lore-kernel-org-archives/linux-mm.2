Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86178107BCEB
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 05:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33396B008A; Sat, 14 Mar 2026 01:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13936B0089; Sat, 14 Mar 2026 01:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862E66B0089; Sat, 14 Mar 2026 01:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE596B0089
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 01:17:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B485598BF
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:17:15 +0000 (UTC)
X-FDA: 84543510030.03.DF0A0D2
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3639B4000A
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:17:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T3/hHzcH";
	spf=pass (imf12.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773465433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ua2whaiu3terS0YKE6w8QhRShJfDUc3Y3baQvMMaP0=;
	b=eCb92rb6xw1/mFMPRpap8/1d/r0wyt9iyuL9CSdRLl6IzFWJYzwJadJvRvnIs2HHua0Fpe
	zmujSQ2OttW8cVzf+WOI56aHs8FByYLNis5f5VOiZa2XF8M/g/g+UfNau2yyYXJeQqzVhp
	NXxT3eLmBMk7YNaDy7zC7GuVsUR/jvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773465433; a=rsa-sha256;
	cv=none;
	b=KWh8syiQrt7NUOwwr51GyI1zYYxRwTP7/anpiL6A8RS2TA3qrT5r/+HmW270pLRyo4VXA3
	y4RNTBKQpPQSPLcWgBbtd85rbNm6wxNYJXQBrCR1NX2WiVqaoDsXNJyCIdoa3SopcsTeNN
	xZm+dxdQx8RZpMf7GM+NiJlgkr2I6Zw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T3/hHzcH";
	spf=pass (imf12.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-128d2e3082eso1284149c88.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773465432; x=1774070232; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ua2whaiu3terS0YKE6w8QhRShJfDUc3Y3baQvMMaP0=;
        b=T3/hHzcHAqxTyvVlxuP1NVHNpEROVyC87C/tHi7xqbdVyQHZMzF9Ow727KiZctgkgO
         zohtIt+PmlwJ6jzbQ/hT33MC/30A7weQuovQfHAww0P7SvtBjk6KWLfq0JKXfI3+q6bL
         BBfL12PPBUTpUZf4tzVQ74CeVq23Au/u/dEKlfFB0eKnJjNyejAC8za2mYroplJvyD22
         OgnYQ0jcS+loa1OaZH73Z+6nfFrq689D+wsxLAFzakoXQ9NuI3mMNbZ88D7Nu0VnxG0z
         QK7CPQCXLrN7oDPvEdYHl3AKxjwJyFD10Ozu7Kkb/n7O7JsoOzpZXO+9kjJAJOo9R8wd
         +VIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773465432; x=1774070232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Ua2whaiu3terS0YKE6w8QhRShJfDUc3Y3baQvMMaP0=;
        b=G9itWzQEhF/Cv4pN1jZEo9DLeEDEs9/hFevcbgYFjQOtamolN2y9a3bbXvJK4Ky0y9
         FCVirOLmqMM0NGCAo8lbK0c1jW6OQ8y+p+iaiz/4kfKew1iatuNcSvKrFD+DJ3vmtdOJ
         pG3Z4wpr/ImNIndykZI3ig5CGU+6RT8lAPTZh4fKocx0dFuEJHust/9SUX6Cq35OiOeR
         5l3SytHR62e2N9i1GZefu1kc3tMU8Dpnqw0qEgdvSmD3eCLGzASaEomOV/I+Pd3Rbn6r
         moHaAB6ngT+KpiDS2O7lZC3K0HDObgltEPlDcC8wtAQ+Jb78oh2MR6DChIfJDfyOxl7a
         pGtw==
X-Forwarded-Encrypted: i=1; AJvYcCUT8/CE90S1V6kQzydP+MF/y67edjYWs7gPoBByhSeLc8/zRHotSGtXXZ0Z16mytv1H6JqQPhHCoQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3TrjgDsVmlcEsPKx3MngV25OTZVS0AiewR002Sb4zCHBl+lBK
	Ajptc00cq0LyhSOZe7Zh2U9P3oHg7+/kWBTTuahYT02IFyyWFK5kCrNB
X-Gm-Gg: ATEYQzzwalHpg0CxDybH3X4kbaRi6CylAOHAPDMtM9x57FUH85EUbf+MKsyjMaMW4Sa
	7sqnfxPKkvB6nZYykTUQPm9n3wRmy+rfMJ/0giIUesmOK2MY0X5OIawgjbvdRkNbpmvg0N9PzWw
	dDwvuuoVhEKcCX/G0N7mRFfcRatceZE+b9Vl51hdGs+tDwNJZgVBGIXdc52BPyXgZ37BtkgK40E
	+FD0CRu2sN25eq+qNNApSB9nEeOc0GCk1pDGpR5VUs7kmVi9K0LvNi33ZP32g/NnMzdetVmTuvV
	/ZMgCtgIuQ8HXHv69pPV65MxF2zLYfwTKOwmEhVLDpt6E6hlwU8oKPWh7Fb7lUzu7M4sp5IhmZC
	SAdvIh0povoi9/l2EUPXQdkPP/jkclRoWudZuLQC7I+Q2HzXEQVSNE7hL0SXsSsBj8Ul2Srbm9n
	vK8Wpf/QFP36eI0+m3UiHs0DM=
X-Received: by 2002:a05:7022:6606:b0:11b:88a7:e1ac with SMTP id a92af1059eb24-128f3d85794mr3079100c88.19.1773465431918;
        Fri, 13 Mar 2026 22:17:11 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-128f639a160sm4856196c88.12.2026.03.13.22.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 22:17:11 -0700 (PDT)
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
Subject: [PATCH 1/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
Date: Fri, 13 Mar 2026 22:16:31 -0700
Message-Id: <20260314051632.17931-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xk4zp6qqjsy3succn6ua4dmw35ntoxgg
X-Rspamd-Queue-Id: 3639B4000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773465433-447053
X-HE-Meta: U2FsdGVkX18KSaCL2GQX4HGRY4fCzdvbQV0ZzfiubaYU5GVegFn7VN7JI3f3WOo4vdWLkXDb+v1LZtg2iJJssmUSAML2EmrL50p+cP1AuOh5GTtE7yWxiSoheR2GZc8YOzpgJBtHyYpdl33lLMYm7iVy5cbjej+ZYecbUc7YU443/UUw1cQtPXa2qCYvA37Uj7/uaOVZkWkuh3PBbg8py6ZBBpgZRudnEgmRjKMHqqALilhE6Mrz1Y5fNDfLHEiMZdfhjYkvHTopOEP6s9DyYblito/gj4Vl38By8KYEM7E6MlG00ZD+psRBdFyErTwdF+6qoRxFm0EWmbksHhlaxYYMRy0SXklLXGqMjhfrNjyGK+9XcGq6UQL4PdpWy7KExxc2ecbjcYH6WFPR+SmOGTITNB68PT9NX5xxfmaYQm7YJ+0GA+6JPNYnOWf1VRfdQnaRSTy/PstXAaSMuf+DI/lhjMvD2SlhMG54qdvaEoz/thTNfctSWYW5g6Ww4p22c6JGMGDT4d2XMCEJzroS5Pnh70FWnPqftggRb1EwLaRcinq05N6KYYQvz6uFdocWTNw2Cze6grSN60SC7HqXWO48XeaTpGynTnsZ6j3OkTfcJ5vUXpdONknj2VLoWmY1aocO0TmxbKfbP/8Y54IeIbg54+l6u9/Rc/iJxv0ZCANiqmAu6T+xU1YMiRKPf2PVOrtZnjhiCKlHGzqJugIUfh9zAX7c0MYA9JI/iL1U7rwVQmQtT11cKw/ja5X4jl6Sk/8TvxkJHU7QUC0kxLnme91Ke9v8hgaUoOkdh8Fsqz7dNs/cUss1RVcgihy4vdoQWAHanl9ReX+xmJhWdGr3Ss6GrbROZBVMRYOSfTnpAhUAN2EGu3QLK0cWOd+u2HoVUiVG514eUA2Bu+WutWvCanEWIK9kIB63d549N9nBInLgAJaShIBx9Niixc73o12QTi9WqIZAGveGA4FkpaN
 qSaOo5wq
 MhwDSKba/SkM3UO87ao9yguhCGfNHNdZgLfipUBIsSU7MjvmayZ+MkYQFIqQAprEM0hB2VbMnU1+sanT4XvXdAuvFIOhZQJNj57yiHHN9aGzIQnqeHaQRaCUDSfCf/d6JpNi6znJ8yIPFs3N4GllZZn/OymdC8AhA1Oa7PKRW7XwGcvgqV+6NFNIEFVvsfgA2lGpdlyolFakBdjf+0yce/RNUW/pApOcG6iaPlNZGgUxs88c666oNU6snBLH6dhf8iPISi7dq/wzO8ifxDu+UkOxSZYhdWpiPfbIzR/TFYwKKux4nhs19pl6jKfXXEiRwOFqo1yjhsIqfqcuAZjzL6NJqH5nBNcjgDsey7itjGi/YHCPU5vXu21xNXqfqIh+u5Krvhfhe4YNpgLM0jMlpPSNsom9xhEf9pNb3Xd6STXxluk1WoRezIQNAH1LDDd7OtzHj8tNcbwNn8NaBylDzT32WMcmHmkhqH6GsTnnEHVUhOWE=
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
acomp_ctx_dealloc() to be used elsewhere.

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
       zswap_cpu_comp_prepare() to acomp_ctx_dealloc(), which again, can
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

    b) Pool deletion --> acomp_ctx_dealloc()
                                --> process migrated:
                                    * Old CPU offline: no-op.
                                    * acomp_ctx_dealloc() continues
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
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 mm/zswap.c | 163 ++++++++++++++++++++++-------------------------------
 1 file changed, 66 insertions(+), 97 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index bdd24430f6ff..26de0468e33b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -242,6 +242,20 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
+static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
+{
+	if (IS_ERR_OR_NULL(acomp_ctx))
+		return;
+
+	if (!IS_ERR_OR_NULL(acomp_ctx->req))
+		acomp_request_free(acomp_ctx->req);
+
+	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
+		crypto_free_acomp(acomp_ctx->acomp);
+
+	kfree(acomp_ctx->buffer);
+}
+
 static struct zswap_pool *zswap_pool_create(char *compressor)
 {
 	struct zswap_pool *pool;
@@ -263,19 +277,27 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
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
@@ -292,6 +314,10 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+
+cpuhp_add_fail:
+	for_each_possible_cpu(cpu)
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -322,9 +348,15 @@ static struct zswap_pool *__zswap_pool_create_fallback(void)
 
 static void zswap_pool_destroy(struct zswap_pool *pool)
 {
+	int cpu;
+
 	zswap_pool_debug("destroying", pool);
 
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
+
+	for_each_possible_cpu(cpu)
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+
 	free_percpu(pool->acomp_ctx);
 
 	zs_destroy_pool(pool->zs_pool);
@@ -738,39 +770,36 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
 
-	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp)) {
+	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffer)
+		return ret;
+
+	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	if (IS_ERR(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
-				pool->tfm_name, acomp);
-		ret = PTR_ERR(acomp);
+				pool->tfm_name, acomp_ctx->acomp);
+		ret = PTR_ERR(acomp_ctx->acomp);
 		goto fail;
 	}
 
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
@@ -778,80 +807,17 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
+	acomp_ctx_dealloc(acomp_ctx);
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
-	if (IS_ERR_OR_NULL(acomp_ctx))
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
-	 */
-	if (!IS_ERR_OR_NULL(req))
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
@@ -864,7 +830,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	u8 *dst;
 	bool mapped = false;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
@@ -930,7 +898,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -942,7 +910,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
-	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -961,7 +930,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	acomp_ctx_put_unlock(acomp_ctx);
+	mutex_unlock(&acomp_ctx->mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1781,7 +1750,7 @@ static int zswap_setup(void)
 	ret = cpuhp_setup_state_multi(CPUHP_MM_ZSWP_POOL_PREPARE,
 				      "mm/zswap_pool:prepare",
 				      zswap_cpu_comp_prepare,
-				      zswap_cpu_comp_dead);
+				      NULL);
 	if (ret)
 		goto hp_fail;
 
-- 
2.39.5


