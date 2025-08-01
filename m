Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EDCC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495756B0096; Fri,  1 Aug 2025 00:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4474E6B0098; Fri,  1 Aug 2025 00:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336FE6B009A; Fri,  1 Aug 2025 00:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23F3B6B0096
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCDC7C0F11
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:51 +0000 (UTC)
X-FDA: 83726928222.08.D407B9D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id AFA0B140002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QBrSERnT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023010; a=rsa-sha256;
	cv=none;
	b=fZHyD/AXAmjjWSkJFtVHqPMC18Xyzx+jM1T1wg+iDfy/Br4km07isrSALCSiAbgXLj1xge
	aUx0aiAZdFAG9JEzhdNI9yh19qW23BFsy1KcXVACSTihVPetYnTnf8FuAnxJcDyukaZw08
	L/S9W4JM6aRllda+Rj59sGMdjTecqCs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QBrSERnT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbVUElS31b0/OxHH5UKcgFXdzU/hRLjpd6A5eJxkxr8=;
	b=3YC3M89OyP1GWBnxLEUZHj7qSwfIvnKeZah+uVJwPOKaa6hm1ALrY+WR3RvsA0KgZ9v85t
	rYfNwgXTAhJcM+GRMaA5XIkcdx+eYWCdblxbCEqM5YRFH0CxXhDYiofw45M40MmdxFzwah
	xDOPYryiyMWKc0vrXymgRQnmrraZGPk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023010; x=1785559010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fqo5Dixe597cz0RjfYR205Y2bqbC/FYhOmDv/Hw+wpM=;
  b=QBrSERnTp4OMos6vA5cDE2FUzAxALMjDoLGA4fAwFQFBPS0hKtQGmCx2
   RQakbXSo7pCt3ocW5m+eVt/l/2zTC3N6lmcSeaavwOcu/rbH1Ere3sN7b
   rR0xM4U3sXF9lAuyPsUbMHvNbiD5r9x+IDs/RaO0lTjKogxYp2Rl3V4Jz
   CUnLe1s+UxlQCs0tXiuBHVOHZb04P715f6Vsuu6QhoriSmmSvKFoAuYAB
   25SE7cpqyj6ME9Wk7P3/Nnf+Lb3gCWEwK8t7q0WaqQ6H6odzWGgQvvV0c
   vIeNbxNi9tDO8n57zJjzAh3o9H/YqTXG4qJZeevizYNGPR/wTZyyxdr5p
   g==;
X-CSE-ConnectionGUID: hcfz4BRuS7Shx436s5JCoQ==
X-CSE-MsgGUID: nS9jc/KuSM2H/Y8LLq8NtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820192"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820192"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:44 -0700
X-CSE-ConnectionGUID: xnJ8uAQtTYyivwxm/Nu/mQ==
X-CSE-MsgGUID: 4YXeeMATQxaXUKZ4A+fGxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796239"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:43 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v11 05/24] crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
Date: Thu, 31 Jul 2025 21:36:23 -0700
Message-Id: <20250801043642.8103-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AFA0B140002
X-Stat-Signature: b1s139sz691zqyyrqw5ecjnpmb3q5f4o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754023009-633427
X-HE-Meta: U2FsdGVkX18BYnxQB4RCKE77uEaO1hAk5nTMiiAwdiHjQ2S9cudxPUsL7aHkfCZ8hoZlAJoOpl9Yk4cPKN+o+A294mT7w2CSqnBBNkIYSN1GxWM7W5ae095WfsgrzRfGMcZTb+VTEsLpiqWuQhiV3A6XoRX+gPyjbH8QK/dYHuTa4Qec1SOGGNf1iNvGpWhBO7ziIhJglXS+jV1yaS/TFBxBbv7SUqF9ZgC7YJjNSzpfiUcJ0uf5CqF2nMtDXW7b1h8CI4/XK+WWTilbp2hKwrH3i8C/1e/JLZGnac5uDPC3BGmwX4ds4M7w97jLpcdz4WSHzC0KOlW8VAZAwyk9Dunu5ZuGLBf0/zOl7My+ahAUr8aN2dRYqtByshkM0s+VIblykfF2qE3Hqztfue0ntnt9Z3ejc6PcyO48tSZRonPEZ0jAWQbcvZSVAEJppTbS4o3Xudq6kUEVIS2uqzmy6VwjFVkKEoiMXblyiDNzHW8n32tzcrZsilTihLZ5Ih2VGJZCQCuG0wLwp9ocdLd1yAugKK4SFqRQ9q5BdxbJsJOaUk8mE/w1jhub2T6a3XxV2XseRXoVgG0sTQNCAtWz0FL1R7pbk1JcRuI6c2xt4d+K0lhBRwZc4dRGLcqcq4B+cOSgMzX0T5gHgBB/VAFyRFa9dmljnovFBWq/AfnG7Ug7RH/mODFBxaGMbInMY5RdzIkp1bBFIk1655m8c7IuLdx31NgO8acvsikhpi6r3vxIsvWhGLbu2yRThqbR5xji+miHP+yOpWIXThtYqgugQkqa21ENDIb9nnSGCQmr/PWa48shOI4BvfgsU92by+My0U9YheMtSOKckniFsfMDDKno+MT+9i4vSF6Wzb3Swvh7MhOYbI+BUyCsbtF30aXEqMiiIifefAYLESmLWLUfOoYMoSlThJ6PMsNHhoSp4xQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch modifies the reference counting on "struct iaa_wq" to be a
percpu_ref in atomic mode, instead of an "int refcount" combined with
the "idxd->dev_lock" spin_lock currently used as a synchronization
mechanism to achieve get/put semantics.

This enables a more light-weight, cleaner and effective refcount
implementation for the iaa_wq, significantly reducing latency per
compress/decompress job submitted to the IAA accelerator:

  p50: -136 ns
  p99: -880 ns

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto.h      |   4 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 119 +++++++--------------
 2 files changed, 41 insertions(+), 82 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto.h b/drivers/crypto/intel/iaa/iaa_crypto.h
index cc76a047b54ad..9611f2518f42c 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto.h
+++ b/drivers/crypto/intel/iaa/iaa_crypto.h
@@ -47,8 +47,8 @@ struct iaa_wq {
 	struct list_head	list;
 
 	struct idxd_wq		*wq;
-	int			ref;
-	bool			remove;
+	struct percpu_ref	ref;
+	bool			free;
 	bool			mapped;
 
 	struct iaa_device	*iaa_device;
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 1169cd44c8e78..a12ea3dd5ba80 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -701,7 +701,7 @@ static void del_iaa_device(struct iaa_device *iaa_device)
 
 static void free_iaa_device(struct iaa_device *iaa_device)
 {
-	if (!iaa_device)
+	if (!iaa_device || iaa_device->n_wq)
 		return;
 
 	remove_device_compression_modes(iaa_device);
@@ -731,6 +731,13 @@ static bool iaa_has_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
 	return false;
 }
 
+static void __iaa_wq_release(struct percpu_ref *ref)
+{
+	struct iaa_wq *iaa_wq = container_of(ref, typeof(*iaa_wq), ref);
+
+	iaa_wq->free = true;
+}
+
 static int add_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq,
 		      struct iaa_wq **new_wq)
 {
@@ -738,11 +745,20 @@ static int add_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq,
 	struct pci_dev *pdev = idxd->pdev;
 	struct device *dev = &pdev->dev;
 	struct iaa_wq *iaa_wq;
+	int ret;
 
 	iaa_wq = kzalloc(sizeof(*iaa_wq), GFP_KERNEL);
 	if (!iaa_wq)
 		return -ENOMEM;
 
+	ret = percpu_ref_init(&iaa_wq->ref, __iaa_wq_release,
+			      PERCPU_REF_INIT_ATOMIC, GFP_KERNEL);
+
+	if (ret) {
+		kfree(iaa_wq);
+		return -ENOMEM;
+	}
+
 	iaa_wq->wq = wq;
 	iaa_wq->iaa_device = iaa_device;
 	idxd_wq_set_private(wq, iaa_wq);
@@ -818,6 +834,9 @@ static void __free_iaa_wq(struct iaa_wq *iaa_wq)
 	if (!iaa_wq)
 		return;
 
+	WARN_ON(!percpu_ref_is_zero(&iaa_wq->ref));
+	percpu_ref_exit(&iaa_wq->ref);
+
 	iaa_device = iaa_wq->iaa_device;
 	if (iaa_device->n_wq == 0)
 		free_iaa_device(iaa_wq->iaa_device);
@@ -912,53 +931,6 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	return 0;
 }
 
-static int iaa_wq_get(struct idxd_wq *wq)
-{
-	struct idxd_device *idxd = wq->idxd;
-	struct iaa_wq *iaa_wq;
-	int ret = 0;
-
-	spin_lock(&idxd->dev_lock);
-	iaa_wq = idxd_wq_get_private(wq);
-	if (iaa_wq && !iaa_wq->remove) {
-		iaa_wq->ref++;
-		idxd_wq_get(wq);
-	} else {
-		ret = -ENODEV;
-	}
-	spin_unlock(&idxd->dev_lock);
-
-	return ret;
-}
-
-static int iaa_wq_put(struct idxd_wq *wq)
-{
-	struct idxd_device *idxd = wq->idxd;
-	struct iaa_wq *iaa_wq;
-	bool free = false;
-	int ret = 0;
-
-	spin_lock(&idxd->dev_lock);
-	iaa_wq = idxd_wq_get_private(wq);
-	if (iaa_wq) {
-		iaa_wq->ref--;
-		if (iaa_wq->ref == 0 && iaa_wq->remove) {
-			idxd_wq_set_private(wq, NULL);
-			free = true;
-		}
-		idxd_wq_put(wq);
-	} else {
-		ret = -ENODEV;
-	}
-	spin_unlock(&idxd->dev_lock);
-	if (free) {
-		__free_iaa_wq(iaa_wq);
-		kfree(iaa_wq);
-	}
-
-	return ret;
-}
-
 /***************************************************************
  * Mapping IAA devices and wqs to cores with per-cpu wq_tables.
  ***************************************************************/
@@ -1765,7 +1737,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 
 	if (free_desc)
 		idxd_free_desc(idxd_desc->wq, idxd_desc);
-	iaa_wq_put(idxd_desc->wq);
+	percpu_ref_put(&iaa_wq->ref);
 }
 
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
@@ -1996,19 +1968,13 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	cpu = get_cpu();
 	wq = comp_wq_table_next_wq(cpu);
 	put_cpu();
-	if (!wq) {
-		pr_debug("no wq configured for cpu=%d\n", cpu);
-		return -ENODEV;
-	}
 
-	ret = iaa_wq_get(wq);
-	if (ret) {
+	iaa_wq = wq ? idxd_wq_get_private(wq) : NULL;
+	if (!iaa_wq || !percpu_ref_tryget(&iaa_wq->ref)) {
 		pr_debug("no wq available for cpu=%d\n", cpu);
 		return -ENODEV;
 	}
 
-	iaa_wq = idxd_wq_get_private(wq);
-
 	dev = &wq->idxd->pdev->dev;
 
 	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
@@ -2061,7 +2027,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2083,19 +2049,13 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 	cpu = get_cpu();
 	wq = decomp_wq_table_next_wq(cpu);
 	put_cpu();
-	if (!wq) {
-		pr_debug("no wq configured for cpu=%d\n", cpu);
-		return -ENODEV;
-	}
 
-	ret = iaa_wq_get(wq);
-	if (ret) {
+	iaa_wq = wq ? idxd_wq_get_private(wq) : NULL;
+	if (!iaa_wq || !percpu_ref_tryget(&iaa_wq->ref)) {
 		pr_debug("no wq available for cpu=%d\n", cpu);
-		return -ENODEV;
+		return deflate_generic_decompress(req);
 	}
 
-	iaa_wq = idxd_wq_get_private(wq);
-
 	dev = &wq->idxd->pdev->dev;
 
 	nr_sgs = dma_map_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
@@ -2130,7 +2090,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2303,7 +2263,6 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 	struct idxd_wq *wq = idxd_dev_to_wq(idxd_dev);
 	struct idxd_device *idxd = wq->idxd;
 	struct iaa_wq *iaa_wq;
-	bool free = false;
 
 	atomic_set(&iaa_crypto_enabled, 0);
 	idxd_wq_quiesce(wq);
@@ -2324,18 +2283,18 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 		goto out;
 	}
 
-	if (iaa_wq->ref) {
-		iaa_wq->remove = true;
-	} else {
-		wq = iaa_wq->wq;
-		idxd_wq_set_private(wq, NULL);
-		free = true;
-	}
+	/* Drop the initial reference. */
+	percpu_ref_kill(&iaa_wq->ref);
+
+	while (!iaa_wq->free)
+		cpu_relax();
+
+	__free_iaa_wq(iaa_wq);
+
+	idxd_wq_set_private(wq, NULL);
 	spin_unlock(&idxd->dev_lock);
-	if (free) {
-		__free_iaa_wq(iaa_wq);
-		kfree(iaa_wq);
-	}
+
+	kfree(iaa_wq);
 
 	idxd_drv_disable_wq(wq);
 
-- 
2.27.0


