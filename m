Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8715CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1396D8E000B; Thu, 25 Sep 2025 23:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB008E0001; Thu, 25 Sep 2025 23:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF38A8E000B; Thu, 25 Sep 2025 23:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E02438E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3BB884CE7
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:12 +0000 (UTC)
X-FDA: 83929985664.10.5F133A9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 897B7120004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PkNnQpIM;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgl0sflpGcb9Opabart4RZ85VK7ojtrv57kYnjcp4BQ=;
	b=P4cVyjVG2vcS3P+JqUIMtbX6wq2agwMm4s6nz6qMtN0VpJ3mebGce3ihCb/9n1wPLk+rpa
	TDqYc3kj0idqMkyj9sUsvgXRlG8+GL1ZVyjiAb/9RcXX1vaZXoKp7bUsQmtDCSSU+RYGv8
	/99jNW1W84vWYR70H1CzqVt5bPE96fI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PkNnQpIM;
	spf=pass (imf29.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857710; a=rsa-sha256;
	cv=none;
	b=vwnN5fzkGzctfOGlF/9eAHNo/kGhGHtxUwmuqAds57mo5LFmC/jmUPQbsvHmLNBk/Rlg0t
	ukpMBtMu8d/0TvIGYb1aM2n9Yj50h2qZVnvmYnWochGBT2MmUS3pDqDVPAN7bkxKZ2AH0E
	6tEvQuzIfINRQ4NrOY3fAmy7yv6da9I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857711; x=1790393711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e0xmkTjEegX9/gAzjxbdhPpVSNs/cVSQx7DHF0sEs5o=;
  b=PkNnQpIMi4sarXwxJV/i2nhvNafbGfWwoxH4g/QL4twU+41DxkVT42aH
   XHWHyx4GUSsxhtFnCfmrm5mvyrVe0mJgwkQGuoMyU9+NdFP0C4jFraZu8
   aBtgGVB14eadGJzXeXFmz350kJl/ZqIeibCp61VgIEIgNCBfHN7/+Crwp
   rXWJUUeugsx7bNmQCfFKez52bgqhfO1FicOo6311VlFxyylxom+02s6uy
   3yzWMEsY9zgVxKpHsAw8qY4T7wBChzoh+fnBO+t4Hwbtx2eQbQhHjDwpU
   ZRQtiYseYbXBEO708GpXhSwLN4qI+EnKr9WQhNYunZRBo+Yk4q1lcJ4fA
   Q==;
X-CSE-ConnectionGUID: qM3XBIPMQDypR72A7rC7OA==
X-CSE-MsgGUID: BKZfkpz2Q7SywdwnGI5Ixg==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819471"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819471"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: IRekTfCeRa6XCPu8OegLrA==
X-CSE-MsgGUID: B/fd+WcMQ9a+R9mFoITN3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636560"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:03 -0700
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
	sj@kernel.org,
	kasong@tencent.com,
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
Subject: [PATCH v12 05/23] crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
Date: Thu, 25 Sep 2025 20:34:44 -0700
Message-Id: <20250926033502.7486-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 897B7120004
X-Stat-Signature: bocwr9kkff3o6i36kmyxkqnzx81hnf3m
X-HE-Tag: 1758857710-529175
X-HE-Meta: U2FsdGVkX19omVDCaRjZAxDGJOHetajfWr5G7S4UenNM4jru2bxZ3nN1RUGWfHsTm1vpdTIbWH/TnUT8DqxrWsUSaY/TzvFTUG18FXVmrXXCvs5dIkYsanucMmasod/c0qhz/AnTkUcAQAp9pZcgQrSH7EB2VyXwApRn8Bdct3uRp+GX1l4kP+6xc2cVWQgIyvGeSGWplgtCnqEt925jnH+N2ojoeyppGKp2KTF+ahvbqL36kXzl5wJUA+kYlvOsGaHrRXVyw2Evhb7w3qmboWuqFvHvMPw1pu/QAtG0oBL35AK0F2ecluaIelRsVHsADdE47WCMRAN0K+GM15yXaR6DmCA7tVAbQxeKxinB2/Js2LP8pOZC678vp9Rk3TIW6Fwe6marHZ1Qv/7p4DfnXy7J4sDUxBnRXvRqfM7M22rJX7YStHWaSEcBDga5ba/CN8coihoxByWsK1nDFqljsMeCYnPf5fhzAwlzMOC1caiTLCWBkmnyunfZin4XnD10p2l7wYNpLoik8lTE1MkfttuCUC/2W1ooG9dBPaCVjUVx3q9vd/bLQae3nQOP5tXEL9oD0o/6pha0WQ627/95svL0xI/KrsQkASIioqDIdUsNfNEz/4ZsauELghhbAhR9yaqALkX5o6oYk4IXdQYoHnSQrWWEUvGRQc0nZhwsIO07ViUl1reTQePjlsIcebra2rIKevDQ7yBzaMzou5RK4guWjaZTETLFC9JOhAnjHPmF5/M65psus6QYcZ+Y/GAS9zFQ9XR7MvZIhpCzvqqZjKwkHGw1sgqx8QK3Ux2ffs334sHuwk1lGSOokglRyNV/kOfcnRhvRGubHiiShnKjE4RpdIJ3rLTR1cEqmYRWvYD+mPWp/zmSMF7WFmCue6gzOTzS0PUCkp2zvxe8h99p9fNomyVA8aUpBfWH51hrm0OeEftLSbQP5uzh1g6sYh5ofpxZDU+zCcnyOz1PJUx
 kBqLtii9
 zmMs/N+Xo76H49szAYtrOU9oDvvv0mtnjwiG9t3ek2grTOiqn+glUmylRnZqdugQpWh9wNE5/UL20voSHktTs16zMjk5W5DS/SgUNmm0hmACUqV0FCykXpwFr++oxwD4iZVFPO4/No3t2rCEkodLnJmFJG95647iojXKIrxaITr1pVAVixIUtcnozbPZgE36qSQN32GU1aGeAowuoktRAUzNAgoAMqi1qMixT
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
index cc76a047b54a..9611f2518f42 100644
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
index 1169cd44c8e7..5cb7c930158e 100644
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
+	if (unlikely(!iaa_wq || !percpu_ref_tryget(&iaa_wq->ref))) {
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
+	if (unlikely(!iaa_wq || !percpu_ref_tryget(&iaa_wq->ref))) {
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


