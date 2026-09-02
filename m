Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1981C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB166B00A2; Wed,  2 Sep 2026 06:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984C66B00A3; Wed,  2 Sep 2026 06:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84CB16B00A5; Wed,  2 Sep 2026 06:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9116B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA3851A0188
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:21 +0000 (UTC)
X-FDA: 85168505562.01.9546B15
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39752A0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="izQVj/3N";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3pv-XagoKCGEUCNMMDENQSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3pv-XagoKCGEUCNMMDENQSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--vdonnefort.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1wC9u3twhPNjqquLWPyT5Y0R6x/ILvd7DMTdNgZ19s=;
	b=kZAfSwij0znUJRSlcrLSBN+IkCkGmWLB6ILyp8QuHzEhtfmGnqnmoKOJjRwMTN4ar7J+n7
	B4gsPkZouhyl9uWTWOFKCRf1QsKeBW8DKM/CuHMPU+OuSi7Q5BHD5Do4R0e+SCm4YNQB+y
	mHbTXj4u4r50BZlt+VEI2hWoX+w6wRs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="izQVj/3N";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3pv-XagoKCGEUCNMMDENQSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3pv-XagoKCGEUCNMMDENQSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--vdonnefort.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346280;
	b=op+nnpazyndBnaVBEOWHZKaJH2/vto6K4WGLJnvZdGV4tpj9ULsDql2pWU7Abb2ezACiui
	KqqxDWRbOHGsjs6slHxAVQpl7gddlxlua2ysDfFCVe4PP4/POrF6lTiFUD14IzuzjCMtCI
	unP2Y1oSLjmnidDTbo4JiaG7l/fwS5c=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49cc9f5bee2so7776675e9.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346279; x=1788951079; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w1wC9u3twhPNjqquLWPyT5Y0R6x/ILvd7DMTdNgZ19s=;
        b=izQVj/3NjXaKOA411Wrgk04ou1R5zb4zZhg2nFHKz6KTkgKl3W/K8p8xsx9X4hXb4V
         Fbjo+xd9J7MPWjRQ3y2yGOSu/AyOXd44pkEsRdiAzXKjA2Ya0h55K6OHH+75iDRoM0kB
         5HotqCIEvC9is9f/IpsigB/UOzgvQHydPndQelZZMXkudK1r1hXhE2VQhz3oC9314Nxx
         DtHAthJLc0suj+gGZXIyYn0ZpJo9z3gj9Oytmfb++k2WKunocIKpXZwUnrrmPJMLNGMU
         ANT8pjKbjKJHHlTSZrBP3E2Wwuo/la0Vk3b6dimYtCtfHjqa+cI/WHcHTDMQssczYzHT
         3Anw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346279; x=1788951079;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w1wC9u3twhPNjqquLWPyT5Y0R6x/ILvd7DMTdNgZ19s=;
        b=K+6P/osh91O5DQdliSfLacSxUUXC43fQ2e5nZVQOX/DbX/8b8oB6T11HnzJk4wi9it
         ATGO0Ai37yPreDEtouKOoDARBijXBGuSKYeTB7UAcy8YvAHxGJGCTq+dbKRaDP52bV5n
         jJwwluG40m1VGC9OmnLOot8mxmJxnx9zNs0tu6JFAY7RZInYeZlOegWpEXyJ08yHmYcE
         yw5gwQXRpqPuyM6dSMSFKsGu7MB4kKUAmRPVW2d39NAlzRZ+yZLTC5S6gSsg6rlLemDY
         v2b0ox1D8jX53IL6nNEPyg2YZ8ND+7r9cnCJ8am5ir6htkaCm05tZ+GcUnzjyrp7d413
         mIMA==
X-Forwarded-Encrypted: i=1; AHgh+RrEhMDlGJRGIukZGnrMOXFkJQUhd0GAPiiRTTTM1P8M7uw/mOVoziy9m3VlYT4L4T59iJMhFSCSoA==@kvack.org
X-Gm-Message-State: AFuF++k9Yrgo1djJwPKtgUxqvVxwcHCoY+4/0OLM7k9vjKb+nJgyAq/B
	MKpt18Es7zvxzPd/kqCr84lfA9GCRsqgbfTrqgPShCOpNHjq/04ysttAeKb/OkX8o3chst+y12N
	xImZTrZTi2mtX/hdSNtU1NA==
X-Received: from wmqy14.prod.google.com ([2002:a05:600c:364e:b0:49c:ca29:c0ed])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5653:b0:49c:eb17:cf3b with SMTP id 5b1f17b1804b1-49ceb17cff4mr15337645e9.8.1788346278647;
 Wed, 02 Sep 2026 03:51:18 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:12 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-11-vdonnefort@google.com>
Subject: [PATCH v9 10/10] optee: Add support for arm,ffa-lend-pool
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39752A0006
X-Stat-Signature: j9mngh8wkboapkdgm1by3tgmruh78ke8
X-Rspam-User: 
X-HE-Tag: 1788346280-784340
X-HE-Meta: U2FsdGVkX1/h6msAL5y9jurve/m96SQyt22EltQM099Oo5bNNUiOjEwUSo3G6ewNejPrtceimh6bb3tXbZkwBFEkZZOJMLNYMR/9yjW8hIZx1BKtf9UmplgtB4iLpxFVgnQiIZy24LRvhILwqzDkAgxXZqdXk4TZaDlLf60GCrW8lMNLb8GzlTXYad6o/CAAy37FFGrG0qul2Ok4NA/L4wrxDux9jZzrYqBF1TFhVwBSxPlXNt3zy2cqSat8UWCmo+31FNlF5yxay3AjhJJwaqt4JzgtF1fshe3QjYMP7O0gJazmYwxmTIi6bX5/ZTD21KNP6XYahSsyZpv9DwO11ORyJ7oiuPQdckpWP+vXHzmDxrnbkmYg+9zYJIhqAh0j+PC8KtKijddJDYl8EeRFqxhLLino5P/luE41y00MivVKyAGA7U54CimJGjZg4QrRvdeXl5IU5peC4kiCJDqK+zbMcPZzgnGWbpDxwG3Lour1P+VOHOtTlWMK5p2+/WHrlzZATzvMD7TniMjciL1WOlhu3xUwBOq50WXwpc0kS7hK5uCAZpqU1wftuyeM0XrwVihCpGIvIWoQcRIPDh08XWMQAAkY5dvifopRa6uYXVu8rh6/CMlctm3ucY+S+QGj38ffj3MK5X6S+MVUDkVnxQn0HrarwDQbsIFn1vDmRcNiG0YfTCgCFG/FFq2C71yiuDMvITsYDTpHKkhwXKjYx88vGQBprMa4OSgkb6kzrTpUvnMVqKRcVH/cFoqyF2FWlrAG049ODgB5jbv3t2ZE9jvAgTbcCklu02l5Xex6TpBtb64ZLj/JgWQ6kPYqxQ6GInXx/E6FMGE4M9AUlGultPm0CU/L7dc+l7iy/fZq0FuBn6GYuN9bZEYpTBqCq5BLmqpec66pXyMUuGyuSY4/5I8xCKncGHNDaL18X7WdKAbDJXFXlNwa9X4Ij41caY6K7EVrVvoXfhSMR/CoAsL
 YEunCkyQ
 gRcs7+5gQ3x1K31sLH+oPpkoPn0l+hNoyQO5PsVkJi8zfAhS4ohq2nE1pu+GlSjjn4/HdPgjbMff0GwJFqtzSOTd44Zzyvoea9Xrac3Bq1FRSg+vGrE17hRT+zlrrDchMF4VXRYVLzXxlHcomLoSdjO5/ApytSn+z66uFgN6FCE5gxgQwVzik5HADJCoyC1SCm5XLBclpVvaVL2qiCdUYAnMBLCFWtkV3BPmbGfH4o6EqkpKBktkqAT9jG80O2zdPMuPnQHO7WiwZUEc8ecteCLfuiAcP5XVX8yQPeAEBg6l+b8ygLg3qh4vnwUoXtXi7wBU9CRMaKLWTpDZoNUizePmL51GBgUn8d/ewCJNbz7qHas/Tr2NvQyZlHx55Ip2GZp8bmKsqf6O1kneh4HCfK5vdaDKtSS+Auu8mFVktv2NT75syYTwnqdNQZUMTCJN+XbXWzwZUYPwybYQ+K0/8DnEbojd7s1lMOPdDWKYPE4qLc2yM7nK71laf+5+piT3gp+qpkkje+hkouU9KvQ4fui/nVg9O/xje0gvRBiPItZeXv1de9BBbnzNGIu7RKXNC7etiJvq/pkamf1QQgokrVxXNZnVmB65Akv3oQk2XMKHdWYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hook OP-TEE dynamically allocated protected memory pools to the
"arm,ffa-lend-pool" driver. While the SMC transport platform device
resolves the pool through its DT "memory-region" property, the FF-A
transport lacks a device tree node and binds via ffa_lend_pool_attach().

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index 633715b98625..4d6555171918 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -979,6 +979,7 @@ static void optee_ffa_remove(struct ffa_device *ffa_dev)
 
 	mutex_destroy(&optee->ffa.mutex);
 	rhashtable_free_and_destroy(&optee->ffa.global_ids, rh_free_fn, NULL);
+	ffa_lend_pool_detach(&optee->teedev->dev);
 
 	kfree(optee);
 }
@@ -1042,13 +1043,21 @@ static int optee_ffa_protmem_pool_init(struct optee *optee, u32 sec_caps)
 	int rc = 0;
 
 	if (sec_caps & OPTEE_FFA_SEC_CAP_PROTMEM) {
+		rc = ffa_lend_pool_attach(&optee->teedev->dev);
+		if (rc && rc != -ENODEV)
+			return rc;
+
 		pool = optee_protmem_alloc_dyn_pool(optee, id);
-		if (IS_ERR(pool))
+		if (IS_ERR(pool)) {
+			ffa_lend_pool_detach(&optee->teedev->dev);
 			return PTR_ERR(pool);
+		}
 
 		rc = tee_device_register_dma_heap(optee->teedev, id, pool);
-		if (rc)
+		if (rc) {
 			pool->ops->destroy_pool(pool);
+			ffa_lend_pool_detach(&optee->teedev->dev);
+		}
 	}
 
 	return rc;
diff --git a/drivers/tee/optee/protmem.c b/drivers/tee/optee/protmem.c
index be3abf6e8aa6..9b64db9b4e64 100644
--- a/drivers/tee/optee/protmem.c
+++ b/drivers/tee/optee/protmem.c
@@ -42,14 +42,6 @@ static int init_dyn_protmem(struct optee_protmem_dyn_pool *rp)
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
 	rc = rp->optee->ops->lend_protmem(rp->optee, rp->protmem,
 					  rp->mem_attrs,
 					  rp->mem_attr_count, rp->use_case);
diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
index b8a2bdac3208..5949aa717cad 100644
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -19,6 +19,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/platform_device.h>
 #include <linux/rpmb.h>
 #include <linux/sched.h>
@@ -1528,6 +1529,8 @@ static void optee_smc_remove(struct platform_device *pdev)
 	if (optee->smc.memremaped_shm)
 		memunmap(optee->smc.memremaped_shm);
 
+	of_reserved_mem_device_release(&optee->teedev->dev);
+
 	kfree(optee);
 }
 
@@ -1712,16 +1715,22 @@ static int optee_protmem_pool_init(struct optee *optee)
 	if (!protm && !dyn_protm)
 		return 0;
 
+	of_reserved_mem_device_init_by_idx(&optee->teedev->dev,
+					   dev_of_node(optee->teedev->dev.parent), 0);
 	if (protm)
 		pool = static_protmem_pool_init(optee);
 	if (dyn_protm && IS_ERR(pool))
 		pool = optee_protmem_alloc_dyn_pool(optee, heap_id);
-	if (IS_ERR(pool))
+	if (IS_ERR(pool)) {
+		of_reserved_mem_device_release(&optee->teedev->dev);
 		return PTR_ERR(pool);
+	}
 
 	rc = tee_device_register_dma_heap(optee->teedev, heap_id, pool);
-	if (rc)
+	if (rc) {
 		pool->ops->destroy_pool(pool);
+		of_reserved_mem_device_release(&optee->teedev->dev);
+	}
 
 	return rc;
 }
@@ -1833,14 +1842,14 @@ static int optee_probe(struct platform_device *pdev)
 	    (sec_caps & OPTEE_SMC_SEC_CAP_RPMB_PROBE))
 		optee->in_kernel_rpmb_routing = true;
 
-	teedev = tee_device_alloc(&optee_clnt_desc, NULL, pool, optee);
+	teedev = tee_device_alloc(&optee_clnt_desc, &pdev->dev, pool, optee);
 	if (IS_ERR(teedev)) {
 		rc = PTR_ERR(teedev);
 		goto err_free_optee;
 	}
 	optee->teedev = teedev;
 
-	teedev = tee_device_alloc(&optee_supp_desc, NULL, pool, optee);
+	teedev = tee_device_alloc(&optee_supp_desc, &pdev->dev, pool, optee);
 	if (IS_ERR(teedev)) {
 		rc = PTR_ERR(teedev);
 		goto err_unreg_teedev;
diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 6742b3579c86..49a9b2993c83 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2015-2017, 2019-2021 Linaro Limited
  */
 #include <linux/anon_inodes.h>
+#include <linux/arm_ffa.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-mapping.h>
@@ -43,6 +44,7 @@ static void tee_shm_release(struct tee_device *teedev, struct tee_shm *shm)
 
 		dma_mem = container_of(shm, struct tee_shm_dma_mem, shm);
 		p = dma_mem;
+		ffa_lend_reclaimed(&teedev->dev, shm->paddr, shm->size);
 		dma_free_pages(&teedev->dev, shm->size, dma_mem->page,
 			       dma_mem->dma_addr, DMA_BIDIRECTIONAL);
 #endif
@@ -288,6 +290,7 @@ struct tee_shm *tee_shm_alloc_dma_mem(struct tee_context *ctx,
 	struct tee_shm_dma_mem *dma_mem;
 	dma_addr_t dma_addr;
 	struct page *page;
+	int ret;
 
 	if (!tee_device_get(teedev))
 		return ERR_PTR(-EINVAL);
@@ -297,9 +300,13 @@ struct tee_shm *tee_shm_alloc_dma_mem(struct tee_context *ctx,
 	if (!page)
 		goto err_put_teedev;
 
+	ret = ffa_prepare_lend(&teedev->dev, page_to_phys(page), page_count * PAGE_SIZE);
+	if (ret && ret != -ENODEV)
+		goto err_free_pages;
+
 	dma_mem = kzalloc_obj(*dma_mem);
 	if (!dma_mem)
-		goto err_free_pages;
+		goto err_map_pages;
 
 	refcount_set(&dma_mem->shm.refcount, 1);
 	dma_mem->shm.ctx = ctx;
@@ -313,6 +320,8 @@ struct tee_shm *tee_shm_alloc_dma_mem(struct tee_context *ctx,
 
 	return &dma_mem->shm;
 
+err_map_pages:
+	ffa_lend_reclaimed(&teedev->dev, page_to_phys(page), page_count * PAGE_SIZE);
 err_free_pages:
 	dma_free_pages(&teedev->dev, page_count * PAGE_SIZE, page, dma_addr,
 		       DMA_BIDIRECTIONAL);
-- 
2.55.0.970.g62bdec98f9-goog


