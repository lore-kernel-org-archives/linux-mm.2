Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA652E63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47A2B6B0098; Sat, 24 Jan 2026 22:35:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C4D6B0099; Sat, 24 Jan 2026 22:35:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC776B009B; Sat, 24 Jan 2026 22:35:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2B66B0098
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5260160418
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:50 +0000 (UTC)
X-FDA: 84369072060.17.E29E2E4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf27.hostedemail.com (Postfix) with ESMTP id CDFCD40008
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qefz28GH;
	spf=pass (imf27.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gI0ie/4ipGyst2cWu6eqiELXmwolPJ5TJLh7WAmvL50=;
	b=khRFgANcP6RMw4dY3xTb9YzY5B7OXgSE0o5csVqcOrs9BP3iMa7CZPn4uvNxeU4Ss1JmwN
	/WkWmaJJiLuJaB05o0Eoj9vetMhRCbFvvHW4ciLdZSbYx0hhufQIesZfRZNEVaw3dFPXub
	p8whiZAf2PuUTYx1dLSW7Sz3rWZa+pM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qefz28GH;
	spf=pass (imf27.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312149; a=rsa-sha256;
	cv=none;
	b=1v9xtFLqraTheWA8JfpcHZenXlXM7KBahM7bvysbkXn9u0skCNX1lu8a5nyqUqA4pxEv3Y
	dpb1VRILQGnabwUDMhXcz+LmBrZOlwn+jblksdMIPu+W/U5J3vsiNI9pt2wmG9GNeiJRnP
	qF1/3UVhz97CqTz6c23QCCspVMG6dJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312149; x=1800848149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R1d16AugdTU+dxffX7g2H/eEuKGm/v5AQk9DA55X8iI=;
  b=Qefz28GH4VD1bC+gISWLAvvsjgb9uJ8VCs4oA2tsu1/fqUfsFpLUJFaG
   hzmNlxkcqi3eNjvwomyavg/lhwVYC8xjDPRDTLpbvvlvPsmbQwwSShI/w
   eTElfc1kD19VP+u2aYtAgQ73K14jVv57HqI7349nCzFDfarGqsh/VgaTQ
   e7AC/De7eAz/OxkBzscOxesqm1IIHyaNut4+OIcuAsgcO7q1l2ilVs2mL
   gssipXscmywlu/qsZYV1cY1x0XjRQzWwlSa+JVJYFGoBVxxTiG3a69NI1
   dWhP0o20mrC5mPfUUXUSH2JpF0AcDMT3qdJv7pi1CegNZzTnbNDuUJPhV
   A==;
X-CSE-ConnectionGUID: FUtKyo6wRg2FuMvi/T8kwA==
X-CSE-MsgGUID: yp91r8HgQNmzZTOqGqrTRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887387"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887387"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:48 -0800
X-CSE-ConnectionGUID: aBZlt/ZORpiyo+w/FeqO9A==
X-CSE-MsgGUID: KzY5wfLsQYSG/LirKaN3ig==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:47 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 06/26] crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
Date: Sat, 24 Jan 2026 19:35:17 -0800
Message-Id: <20260125033537.334628-7-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: iiejyugop6wpo3t5tsxaguqmdfpqmkee
X-Rspamd-Queue-Id: CDFCD40008
X-Rspam-User: 
X-HE-Tag: 1769312148-125870
X-HE-Meta: U2FsdGVkX1+zRAaK0Qh4mrV1ffwh/3zHiaVmKxJX4zKRnOQlM76T27u/lWa7kuLVQwBcWtumoc+fhSNGMKHW7wXNAZnIkzqaemi3Zd9jBxrxsj7+hMpA5W5Efmj6Lt4AjLNWWmfAebZMh9PDacI5/4JmNgQBp+aXsGvy4JJLQUQyd1Kpj6FfmL7UsEWaiQCkXDH9PDSa0p+oKIKcI/DcOYjQXYcDVTmb/xJASmm8Bx2UQ67fL68aYDcutAfekZBZusJg/ZSZb9nDSt8nChfaJHn1riMoBUC62GlXislH5/0dxhqrUoWxWu6Mw070lbR1r4fanvhciS9L3TfEBtKtNb+pfnhC0uy8dNsmWcSwKRYQRfd47PBZyRNtSGQ4eRRQLLOCLhh1/So5K+G2l11SQDAj/pSsHkOB9FQtb6c35Q5HG9pQxOW0V545I86jSdVZ5H/Q1xZeSkyZ2XK38u78vS+lnfYlKMRkwOO/WmBBwi2BN2KBxGbfs9alT10eRqZYFftPh0GOdZAMc+sfvdyxiTmOvTSgdrn7WE8gvAvhnCd+K/nyHrrZHdVsPFFvZJA2PB24WxrzCUPZruXmQyDL1Earb6OrW2PNZi7RTpXanQ0sEioWmwo4V34MxYBhU9LK8kLeVBHLfgf08TKaPAzNFH+oznWFItJK28Bwq3Z9+2xmv99IT2M5SOVhC7gvTssiqw0u5RybeAl53jFuBIajVa4JnxRfdTAB321kTUA+yF8J9I81WR5Lmw4MrPNPWIM6YAHOWyL+sOmJCWLe1UydQPobNETssxgUQKYjtUZd8/0FEGTbrgOZf4PANL7AKP0jMv/0aJBNN/wW8qHls8nEn9ABvgqYrj5Wx5sGhESSSGLGIFSUD93Ipbg4igsAV9vHx9/oLu3VSolG816OoehDIikTniibRn7RmnMXg62069WFtCGh7t6TMIfDGXGH4PCOeg4MlpbsloezkOo4QB0
 fmvcgecc
 osm0BXKTYJVE0VG7GWFPZprU54RluHQX/o6BuL47eaXN7jI/EcFU1ByN7PTmxRIrSdSlF7cIoqi2kBRhEBlJpZRgEYNvbvzK4YvqShvdEDF5yR5eai86176g8vFb2hU0QFP5GER1IVVzgqO0Gf5hdPfHCAPRrmBnIBTsZLQmSL09gK7UxLUdu6TXNdlCbo1VJXtO3W8vKuHmRC9u7MsnudilNF20+Bk9KkmXj
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
implementation for the iaa_wq, that prevents race conditions and
significantly reduces batch compress/decompress latency submitted to
the IAA accelerator.

For a single-threaded madvise-based workload with the Silesia.tar
dataset, these are the before/after batch compression latencies for a
compress batch of 8 pages:

 ==================================
               p50 (ns)    p99 (ns)
 ==================================
 before           5,576       5,992
 after            5,472       5,848
 Change            -104        -144
 ==================================

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
index 3466414f926a..01d7150dbbd8 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -702,7 +702,7 @@ static void del_iaa_device(struct iaa_device *iaa_device)
 
 static void free_iaa_device(struct iaa_device *iaa_device)
 {
-	if (!iaa_device)
+	if (!iaa_device || iaa_device->n_wq)
 		return;
 
 	remove_device_compression_modes(iaa_device);
@@ -732,6 +732,13 @@ static bool iaa_has_wq(struct iaa_device *iaa_device, struct idxd_wq *wq)
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
@@ -739,11 +746,20 @@ static int add_iaa_wq(struct iaa_device *iaa_device, struct idxd_wq *wq,
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
@@ -819,6 +835,9 @@ static void __free_iaa_wq(struct iaa_wq *iaa_wq)
 	if (!iaa_wq)
 		return;
 
+	WARN_ON(!percpu_ref_is_zero(&iaa_wq->ref));
+	percpu_ref_exit(&iaa_wq->ref);
+
 	iaa_device = iaa_wq->iaa_device;
 	if (iaa_device->n_wq == 0)
 		free_iaa_device(iaa_wq->iaa_device);
@@ -913,53 +932,6 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	return ret;
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
@@ -1773,7 +1745,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 
 	if (free_desc)
 		idxd_free_desc(idxd_desc->wq, idxd_desc);
-	iaa_wq_put(idxd_desc->wq);
+	percpu_ref_put(&iaa_wq->ref);
 }
 
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
@@ -2004,19 +1976,13 @@ static int iaa_comp_acompress(struct acomp_req *req)
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
@@ -2069,7 +2035,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2091,19 +2057,13 @@ static int iaa_comp_adecompress(struct acomp_req *req)
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
@@ -2138,7 +2098,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2311,7 +2271,6 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 	struct idxd_wq *wq = idxd_dev_to_wq(idxd_dev);
 	struct idxd_device *idxd = wq->idxd;
 	struct iaa_wq *iaa_wq;
-	bool free = false;
 
 	atomic_set(&iaa_crypto_enabled, 0);
 	idxd_wq_quiesce(wq);
@@ -2332,18 +2291,18 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
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


