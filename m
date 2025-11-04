Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6210CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B098E010B; Tue,  4 Nov 2025 04:12:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9128E0109; Tue,  4 Nov 2025 04:12:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E938E010B; Tue,  4 Nov 2025 04:12:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8CA18E0109
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81F4088AF0
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:43 +0000 (UTC)
X-FDA: 84072359406.14.AE9CF9D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3996E1C000D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a+jqMCFf;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhUz48MFyqwrQ7BhDw3R2XWGB/I4FfkFjFcl306dgcc=;
	b=riPFiNLj/p6aYc/TNFT1ULQMG6FroatwqlECg/zLrp2VphXowzVrbGpqzU0NFdcrhYsEVG
	5UaLJSXsEARzzdCQ1bBBE6OVifFHBYm6ts40xsMpWDKUli66j5Y3p/1+QsZArf0E0jPw9V
	3ttFUnGBF1XDC4RLfdXcMk9Q7j/SPtg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247561; a=rsa-sha256;
	cv=none;
	b=jy9wRsytQdxEwscDZ6cKXFEVQ4MEwButSsHnH9WGMpyHv7gtMJco2cm1G2PZXbBZnKSx0e
	n8h19MEodtT4h4/fxlSoP/5CjZYAbj2xV81gz+/WQGQoWAqGyz1nqCN+1p6nekE9UQAl/k
	R3j5ilbcHdZFoGam2d02wOTaox8c9iQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a+jqMCFf;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247561; x=1793783561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6i4unP24Rk75I3UX9HXmZHA/5/EFm2CM3Ncnume5Re8=;
  b=a+jqMCFfNOfTSbbnvFvzH3Yn1QF4EDCTn/wTwanUTJCahTAKbuzZwD1C
   pfHMmBo/9AVWaGsAoXNXDJZQbWBStIhiPhbNvxTpl0B7vC/PYGwXLewhQ
   FPIUc6f+glaM5g/c+74oNfj+C3N6MeMTSxCtczdLMg1uMM52J2ubirzH2
   okqpCi3/RLgwO3yO0IIj5QglLE+yFcxEeLQh83Fyf9b97wxcP9JHr4zBg
   LHBB9Y/slXSXw7kLUwiYfmeuN6Vwlpmqq5cGvFj9Pm3JvECZj8jP1yX8y
   UV1RKDoZ+xO6GUldFHcU+fFU5gO8MV97kp2SHWSIC2NYiVnRmC89BZDb/
   Q==;
X-CSE-ConnectionGUID: L72raLDlRjeUenW7kED9UA==
X-CSE-MsgGUID: Z1g+F9GGStSCt2PQA69GHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265172"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265172"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:37 -0800
X-CSE-ConnectionGUID: Sl2IvojiT7CLXTI6diAbgg==
X-CSE-MsgGUID: WpZ5vlf8TTGJzCqEgZJfug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795788"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:38 -0800
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
Subject: [PATCH v13 05/22] crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
Date: Tue,  4 Nov 2025 01:12:18 -0800
Message-Id: <20251104091235.8793-6-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3996E1C000D
X-Stat-Signature: aqttrkdcdkdn39ue86abebmu3xd3hc3y
X-HE-Tag: 1762247561-772742
X-HE-Meta: U2FsdGVkX1+F0Rs5vq772QEKwkG1XW8Y+lUfw0BLqv+gSY/Fl1bd5X9sx0RqwjQwrmDrtOgLJPjvcQgrEwLz1oe67wkDIKK7UW/1hTTfLQExEFR5URpiyyWNwUIAdQfFoK1SmOUKuRPcno0MP4i3T1WIks+fw+uf6Do+1GktdJg3XChv0XeYXRULtuQCzhjW/RdyP5ktUbmjZkhNOHK/xcxSFIhJujnm+JDPx/bulrJ0J34lq8eezC7K7h+JT3tfobc0jK8yqcOiOAm7AY6l78xLr+0D7836tpv/71z6a1HDLYS6g2KKaACvt8IXnz+L4H/cN9HBvLcG3Qd7+uqa7xvnUhYG5b9Y0dYYkR+s+rIa5U/uMOoRgO0nIe6KMFw0MyPLXGIOWJmGh8a2zOufUxllrLFsP91QJeGiOI7F6Ftfvj9QsIzgkM//+aio+ggb95rqnzQOqIsOE8zW7ctZXQ+GXSojzTn2xOiq1MszaoWSBPkNlrVd75pLq3m/dozpcztKLdXp2/kAHCnq4sCggh/mQdWssOMuECr+4OUOab/B+/I5gcMQMQiSPBddK/AuS0fEGabPPV37eDQEmRKh9SZ1FmAO2N4fU2ttWjVIr16rb6Eb9ybI3SHye91i0yTzxuOdixwyM2NLzvOtsh/lG8lmvxOzwVru6bn8xq30tB7WhQVzq+z0d6S9Xq93+0CbF2dajjN1E1Jwvf3bAsKwz9frrdRN73vw+XtiQ/ZHLULAHsomtvj0hsXaeJZAVOyEDeKbuxKm9YvENPbzNlFcnWyVAV+SYKd630CD1DAWrG43+ezKZ876mwuq3NU826nEyPymfxtOrwrm3Zic/thS8AWdSUFsJQqAZJuLn7YFFz6WuWXlCzTB1j/OsVKKQ5XpKbwkWntvThTPifdp67/5gCKyKR5cPy3GiHr4bBj8Bh/jRwwJUpF3KNg2amqg41gtlRojXxXfG5Osfjw69uU
 ZnZ0Xj29
 AuBB7ILKjJmhFNNnyTNDDjsUbo7YSRKhHfZUrXkb9AgMxIt6CFNgp0jsGdJY98/RUGlo0ggcVrxZ8udlaW08x0vQuuwR3qJ5MCsJhmOmhsxKp99F2aljsoh8ircimj6nt4JspqXFEktGXGKIh8LaO+GxmNhiNWceCIwAU92EZmmR2vmg3JNCNTA/WrYPaaBDIJxzz3F1QV+mFVBI06he/1ChPJ8UDfgrluY0n
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
index 89e59ef89a69..ca53445a0a7f 100644
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
@@ -1771,7 +1743,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 
 	if (free_desc)
 		idxd_free_desc(idxd_desc->wq, idxd_desc);
-	iaa_wq_put(idxd_desc->wq);
+	percpu_ref_put(&iaa_wq->ref);
 }
 
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
@@ -2002,19 +1974,13 @@ static int iaa_comp_acompress(struct acomp_req *req)
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
@@ -2067,7 +2033,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2089,19 +2055,13 @@ static int iaa_comp_adecompress(struct acomp_req *req)
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
@@ -2136,7 +2096,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 err_map_dst:
 	dma_unmap_sg(dev, req->src, sg_nents(req->src), DMA_TO_DEVICE);
 out:
-	iaa_wq_put(wq);
+	percpu_ref_put(&iaa_wq->ref);
 
 	return ret;
 }
@@ -2309,7 +2269,6 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
 	struct idxd_wq *wq = idxd_dev_to_wq(idxd_dev);
 	struct idxd_device *idxd = wq->idxd;
 	struct iaa_wq *iaa_wq;
-	bool free = false;
 
 	atomic_set(&iaa_crypto_enabled, 0);
 	idxd_wq_quiesce(wq);
@@ -2330,18 +2289,18 @@ static void iaa_crypto_remove(struct idxd_dev *idxd_dev)
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


