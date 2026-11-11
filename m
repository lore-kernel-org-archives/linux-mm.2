Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFDE7606A880
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bMQAE6IN
Received: by kanga.kvack.org (Postfix)
	id 69D686B05BC; Wed, 11 Nov 2026 06:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6769D6B05BD; Wed, 11 Nov 2026 06:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1A96B05BE; Wed, 11 Nov 2026 06:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 362E76B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9C9B4028E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:43 +0000 (UTC)
X-FDA: 85422565326.28.405B1A3
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 11FE0180008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bMQAE6IN;
	spf=pass (imf06.hostedemail.com: domain of 3uEz0agoKCIE0itssjktwylttlqj.htrqnsz2-rrp0fhp.twl@flex--vdonnefort.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=3uEz0agoKCIE0itssjktwylttlqj.htrqnsz2-rrp0fhp.twl@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395322;
	b=S9yDciORi2iMTNr8yhpVu1t0tSfe7dYwgF/yOg27qqnd4nT1oojjpFxmGpYpjvMLZSpDwS
	eb0vhK2jWhiyv7QF7tGmXWtsBVGCuPmVrrOaAv/UFMTT2h/AezXrjGuCgk8tBxTrypSwPr
	R6CgA5fdXmCTOn4Eu6kSwlS9BvA10H4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bMQAE6IN;
	spf=pass (imf06.hostedemail.com: domain of 3uEz0agoKCIE0itssjktwylttlqj.htrqnsz2-rrp0fhp.twl@flex--vdonnefort.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=3uEz0agoKCIE0itssjktwylttlqj.htrqnsz2-rrp0fhp.twl@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XlqkjYgUHqMtiyvO2/LqlbV238Aov7kyKv1cwFa5P4=;
	b=kWaA3LH+40cRw20paZ7lCI/StS/pdl3OiCZHmx5wEPwTWhCRH1nIWCSZd8dSDF8Iq3Ow4Y
	/5onPhZ7pMkf+5xjkZ/FwspOQVP1LQwPppqq0Vi6g8AX2kPa+7JaylTtwWo2YhezHMOXG8
	WinHgYkq1EmdTHUxzAgvTew63xCYb1c=
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4902ce85f72so2397979f8f.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395321; x=1795000121; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1XlqkjYgUHqMtiyvO2/LqlbV238Aov7kyKv1cwFa5P4=;
        b=bMQAE6IN6B/wMGaDP9zCHMbgF79aq7S+fCMF5XfDA6GPLl+lCMxiZr2Hr8hFkarZoY
         EWakB0CBOg/iOc58HY00OKoc6+iXO0HPvnmOIUSG0T9xf93r7lffG+bQ9+JeTErAdgQ8
         55dAm4VN7Px7xYuNgX3/P009s+fc5/THSDqQj3j/bUA4zQ1qGbLlh6tGGg117Qex9y3y
         ey0dBmUi56Gdkz4f6do+KDO5VejhAZGk3ucc+6G9wLm260vPUK51MI2h5RRIn0k4WCO2
         J0XsCa8HT2w6FTSzPswYAHqV+3Om/sP2azkJzk7dlqxNdxyas6xXC2WRj4Dgmi3nBXjI
         bNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395321; x=1795000121;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1XlqkjYgUHqMtiyvO2/LqlbV238Aov7kyKv1cwFa5P4=;
        b=V2RpHWdOzphL5riyJDBYVHPzdqps+W1bUpsGseELGtmb2loe1s7JyabN87401drKnH
         it3sMylxdUkSim0YxU+wwU5q3sh+Ghmo4D2QBXPvUVne/9sO4hmRcQMf/iMgy8k1unLM
         kiNRkWU9H874yjwoc7jdChdgHCZcCFo5N51sUujp6ig26RBniX6QXt9SdqpTyyXxR+fa
         HdWXQp5SCYctWXwfjFaF/8y+fUsB1blQnNUSXQaKmK4AmPNozixaa7le7qSFUBlYHi5x
         F8KGRXcn9FUYvZsTCtYk3x9v8ZuLHa4U418hzww8Ts3v3j6Jp+Rv5pdJQzT3kpFYyaE3
         e71A==
X-Forwarded-Encrypted: i=1; AL+hErGTeBHdwY9udw0p8sSJHZGQVtpafeTRilcoNvW1XYJPWDVxTxbLiqwcTRJF7TL51r99yIaco19UAg==@kvack.org
X-Gm-Message-State: APuU4Z++TnK1eqhmRnRSdzPtB8A0K7Je0YJBFvwEbTssTkKQVMX2wUcl
	9CWUW8xVZtq+oAC7icqWGO/ePFDAYdVQnELQ6RSbDR07w1ZXCcT4U3sQGelCENpv6GhyMrjTUZ5
	zJ4MJe43kw9GLwo8OSkgnGg==
X-Received: from wrqn16.prod.google.com ([2002:a5d:4210:0:b0:48e:3826:ef3f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:481d:b0:493:803e:800f with SMTP id ffacd0b85a97d-499c6e96f58mr3024659f8f.29.1794395320547;
 Wed, 11 Nov 2026 03:08:40 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:38 +0000
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111110738.872947-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-9-vdonnefort@google.com>
Subject: [PATCH v3 8/8] optee: Add support for lendable-dma-pool
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sck738n7w4ki81qfb6ofh7xt4fswmhiu
X-Rspamd-Queue-Id: 11FE0180008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794395321-551810
X-HE-Meta: U2FsdGVkX1/p+z63j3xms9FNrBtwSTPbyUXOl8zFWpLL6yghJJEGGyoJ+DoxACP96Id/2H/igvwBjHnpxO1eeMRxBixt/nX7cFVwq46vG3761TwpB3cNH05s+7EuedytfjSZZc1iPoXHSsKTfedN06ZuOVwhFbKum7/4jmAxL0rLx6L5UfcVe7E+CUPLMVXM6bAkvS0Xy7wFjA5X3SRMpf8BWFPmvyBi8OZw8ieujk0d8f8NCEjpUHsKLadoC+syrButf5jHi4xHQTKS1PUOCTeQuTeg07/rRwCavdyD46s9Ral623DZqBQYHoMoKxz9Wy4WTjnOY0JIw/MN1qnvx6fnq8BTmW5iylzpKBYmlR8qLgPqU/LXt41+iVmW1BhO1nMzw6oHFwgVeGy0t1jVAGmiGz2F6MJyGt7F+DNCneY1Fw4bzzOUQ+gQJk2R7I4fc4pOyXuj8ujD3pkgFYmfUJXTYDEWM0uB2mZZH3+77v5ssQpoVnREgWJ32vBSH91JqMVF4rh+KdIv0GNIR6KSqOXPQ/TevI/zhJUvYzCLIh/oSl5jAHFEEGk8tnMrSalCeV7zGzMnNZyytWNaAbMotZIyKLHT+dhF7LETQO+9uaKts8oeOQmXWZ5Odyry5ere1tlnRX5+OBjsdoOWVb+Ho4V8fr9EsMIXh9f0k8yQ81mqumwmiGI08MeX4SEwLGlGKHvScUsjSV6SBCNWab7Q+hWv7GRwyvxApHBEobovgN2oPXUADVRHHZb8PJpmtKfA1ybj1HVr+efhw1y+Rq9V0+Ivp+wQTd10fgzM9pzCpEO4Z2lrPTmLAA3f+IHniOM0Oi7sx/prkMl6dPegFq9Mo54sT82rI8xwlg8kya8FORPe0K7Exr0mPV3FTCWdAbyBR1sk8naZ6uPWZSuI401aXuoHOQek+KMJ9/95o9UCZcXwqAV+zEDVDiwgzA/QHVLLb5nuL7FxF3BfWD4wBS2
 1qWOrhUH
 d7Q5cGCAe1mDa90i74pST2j0+Jn7WczDkXI9z6UVXlHQlMcEFOSm+/pInMj7rxj7KakGrR5CEZr1W7/3KsdNV9WmH1Eisg9Ji0nDCfkuKGpo13mMPXL6oR671W1hfysrorE1fyPsdEJ/bfPZrgcZPNoKThiftp41KX5Y4Bdv1QFNTrfcnqoIeF4WkszP3GxEm/njiuiYZ2YXfrBQpJROhrRfdf/GX2xiy1xDnea85zXKsiLNCWthJOKswTg/e0FCaMKIbpTuWccZvnIeaTU6GrgBRlYpT2fWPU4w4CEVVANpfUKoQM8FzUTK5lVzIBY56ZahCp2tqCl5XLVpBPTxjzvOzKX0w7UicQjTFaM0gsK3W9s2rCETGrA9uRTg0sHQZabWsakevxapWajTZOnugGgLocqmodrGl01P9bmhn/wt5MOIqp0bQ4Xr/RmC7kvI8EjR5D+bRPGXmTv58JvegsXlg57++uXMYloSbnfs4fsJMW8Ho36OgsH76fvSR4UbLpQqzEC3/OCuEzOlSPAw/xQ5iNbW3N+6q1y7uW1b2mLekdSsipNdzVEOFsCiB1TxbhDWH1pZqyXsPeJX4vWdcT4Aj0cMN2pkKCmRT4Gf9933QdI5BzehDlojS6e6TivbbfYVz5kJCXD9lSiId8x41cFdVZysO7M8Xxt1cvjrYjP/89rAx8/62we6X0P2cKnSYgEiiLmdXpR8ov661KJwjatcMtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When memory is lent to secure world, fatal CPU speculative reads can
still occur while it retains a cacheable mapping. Use the
lendable-dma-pool API to unmap pages before lending and restore them
upon reclaim.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 drivers/tee/optee/protmem.c | 48 ++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/tee/optee/protmem.c b/drivers/tee/optee/protmem.c
index be3abf6e8aa6..10e8f1540e5e 100644
--- a/drivers/tee/optee/protmem.c
+++ b/drivers/tee/optee/protmem.c
@@ -4,6 +4,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/dma-mapping.h>
 #include <linux/errno.h>
 #include <linux/genalloc.h>
 #include <linux/slab.h>
@@ -21,6 +22,7 @@ struct optee_protmem_dyn_pool {
 	u_int mem_attr_count;
 	refcount_t refcount;
 	u32 use_case;
+	bool unmapped;
 	struct tee_shm *protmem;
 	/* Protects when initializing and tearing down this struct */
 	struct mutex mutex;
@@ -32,6 +34,35 @@ to_protmem_dyn_pool(struct tee_protmem_pool *pool)
 	return container_of(pool, struct optee_protmem_dyn_pool, pool);
 }
 
+static int zap_direct_map_dyn_protmem(struct optee_protmem_dyn_pool *rp)
+{
+	int ret;
+
+	ret = dma_zap_direct_map(&rp->optee->teedev->dev,
+				 phys_to_page(rp->protmem->paddr),
+				 rp->protmem->size);
+	if (ret && ret != -ENODEV)
+		return ret;
+
+	rp->unmapped = !ret;
+
+	return 0;
+}
+
+static void restore_direct_map_dyn_protmem(struct optee_protmem_dyn_pool *rp)
+{
+	if (WARN_ON(!rp->protmem))
+		return;
+
+	if (!rp->unmapped)
+		return;
+
+	dma_restore_direct_map(&rp->optee->teedev->dev,
+			       phys_to_page(rp->protmem->paddr),
+			       rp->protmem->size);
+	rp->unmapped = false;
+}
+
 static int init_dyn_protmem(struct optee_protmem_dyn_pool *rp)
 {
 	int rc;
@@ -42,19 +73,15 @@ static int init_dyn_protmem(struct optee_protmem_dyn_pool *rp)
 		goto err_null_protmem;
 	}
 
-	/*
-	 * TODO unmap the memory range since the physical memory will
-	 * become inaccesible after the lend_protmem() call.
-	 *
-	 * If the platform supports a hypervisor at EL2, it will unmap the
-	 * intermediate physical memory for us and stop cache pre-fetch of
-	 * the memory.
-	 */
+	rc = zap_direct_map_dyn_protmem(rp);
+	if (rc)
+		goto err_put_shm;
+
 	rc = rp->optee->ops->lend_protmem(rp->optee, rp->protmem,
 					  rp->mem_attrs,
 					  rp->mem_attr_count, rp->use_case);
 	if (rc)
-		goto err_put_shm;
+		goto err_restore_direct_map;
 	rp->protmem->flags |= TEE_SHM_DYNAMIC;
 
 	rp->gen_pool = gen_pool_create(PAGE_SHIFT, -1);
@@ -76,6 +103,8 @@ static int init_dyn_protmem(struct optee_protmem_dyn_pool *rp)
 	rp->gen_pool = NULL;
 err_reclaim:
 	rp->optee->ops->reclaim_protmem(rp->optee, rp->protmem);
+err_restore_direct_map:
+	restore_direct_map_dyn_protmem(rp);
 err_put_shm:
 	tee_shm_put(rp->protmem);
 err_null_protmem:
@@ -112,6 +141,7 @@ static void release_dyn_protmem(struct optee_protmem_dyn_pool *rp)
 	rp->gen_pool = NULL;
 
 	rp->optee->ops->reclaim_protmem(rp->optee, rp->protmem);
+	restore_direct_map_dyn_protmem(rp);
 	rp->protmem->flags &= ~TEE_SHM_DYNAMIC;
 
 	WARN(refcount_read(&rp->protmem->refcount) != 1, "Unexpected refcount");
-- 
2.56.0.542.g3ef89b7020-goog


