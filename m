Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03AA8CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3E68E0011; Thu, 25 Sep 2025 23:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E0E8E000E; Thu, 25 Sep 2025 23:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8568E0011; Thu, 25 Sep 2025 23:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0C1F8E000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DE4814057C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:16 +0000 (UTC)
X-FDA: 83929985832.26.48F21E5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C425C0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f+d4Al1o;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7LK9OACXrm1Sex4e6zyQvjBxBYkJKdu/1ZF4SHeo3o=;
	b=sZjldFVLEHYi8zyXCIrfqRT3BOOsvNthqONN7dTEbmeKXiW7chJGvsPjGwyW8INS3Iv7NM
	LM5b2wEoAUXjeg+1IejpIlKLmBx/h9jr7vMfHX7kzRZ5Jfv7fX5zUDkhNSNY5oUkufJEOu
	GYRDVMq1uKqMlig4Vyx3V7zOfaIhQxY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857714; a=rsa-sha256;
	cv=none;
	b=5Xoo5bVE+SKL1FRMLHeA/phEAKPjBrWg8i1vDDhf3vwbEcbjGsWQTPv9/Y287nemZqwJsq
	JS/prEQ4E1fUnF+FJcGwrpk7y6dhiYw0yhRtRb9Nxlcs4XAKoI46li4xfdmKI9FR6TtqF3
	cVxhixqSXbBGRYHL5O6WqGAXc0z6W0c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f+d4Al1o;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857715; x=1790393715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YYmh8xZd4gk/n5yJ1RFX0hHDp3XB4RnrHYtV9eqN8Fc=;
  b=f+d4Al1ovotelgK0xQ4frt6J5nfHCMEp6arQmHR5/JjzZIZRLypwqYZW
   zd+SKCfAJOngHN+C4Af0HK9oNwLlQ+xx8Y8yQ5xyMvwW8AF6aSKByQxf7
   m/CVKP0Y1Uxld9SXDd+Gszgofirg80i9e62rKEo1BkUPB6KN8RnGjufMT
   nj4BiHrrBlKwA9x9wnRyE3URSfZqnorRYssab/VNV07xxjStiBBjaPTK8
   KEdcC1Y3HG7U2W7FVoataP/hamBudOnmZ5jnsdKXHpvgnEc85TGpIj/Kq
   0FyX1+Vjn1ev5+RVN7yrwywdI4Ad/mAoDn62vXfBdXBxVSEyu0qFVq2c9
   w==;
X-CSE-ConnectionGUID: UqFFjW8PQdKzPAIRTtIZLw==
X-CSE-MsgGUID: BAtqErFjSe+NFgJVSc6vog==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819507"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819507"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:05 -0700
X-CSE-ConnectionGUID: 57Vr0BPDSrGeV5s6DKEX4A==
X-CSE-MsgGUID: SFBy/7XIQiyBs6zCQpO1bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636571"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:04 -0700
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
Subject: [PATCH v12 08/23] crypto: iaa - Simplified, efficient job submissions for non-irq mode.
Date: Thu, 25 Sep 2025 20:34:47 -0700
Message-Id: <20250926033502.7486-9-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C425C0004
X-Stat-Signature: 5ff45fkcq5nif9kfjbnf1sbttxiag46e
X-Rspam-User: 
X-HE-Tag: 1758857714-884638
X-HE-Meta: U2FsdGVkX19bY2J2FkqOWUYbMGot689ee9N0xcYnI9W7WrIqwIujh3nvMu+AVTA9I1R+tn4lH/x1e4fX10nmiii0FKFC3lEC+LAsYwSxw6nCCVJ7ku1qDV7LaRiLBBvxdAMuSyfvSayOhw4pnaD9hj9Sz1botoKSKWpGcYFme69RFqZIU+8Qi2PfBK58330NillLLVcLFadsRFDKv8iRUsEWzK/tewlu5szxk56H7HavkdT1OJhoveY+NUgdAPsWgaaJUqwPfCOp2zTBypLmzm3oMxNagDpLnLLBttqON4eRXnhHWmxvmCRW+tYDqdJO+dMwk09VABPFm0uKeasgYYBra9QLtGGDW8f/utMKcwIkUJd2+HbOVbaeLBYHEQZdcSf7A1Y8zgERXNIw2DdNM9k7tCaJFClVtROS24pUzQDCl+zwvuuEOGtHCvvAgxBXMGd6GQ7m4p+wUu1v5Fs968ynQZPswU4A4j0ib2Q4ROIRXlitf9RJc8uCfPe7Hf2EB7fvoW7xe4VdZn1aRZoEVjinE9yHMDwPoyunYeqVZxYLF7W2BjvFGhd4UvXf9eIy21NFTUbUB/pUMT23uxLCERSRTM81Y7f2XurOHz2giFZuwriMlCJdnRaUhQtVGbhXl8L59DzZ2BCIQmqX/XX/Sc4dp7aWN9XB5eGhPbQt7QcT30MUguBTzVZ/BUG6yG3NUG5IupDEdQWpIry8OUjc8KacOZgd0P7jCKXD1ZoHfuG94tjfD/LpwQW0ZIGnSGCGDkZQXDCABeewd/Ch3l42tm3aW3Hb5tgdPcgXVLWv6r67C7WbM38taKSpTyN0r2oQsC3LjSO8YC0RHXKfMJ0kT+ItjMJjbxf8VYltlr2vnw5zbZcmj75fZiwDNcoswxnfu4yCwcNQZZOxsDi/LVo+/5CX31PLNPWvf0MVZ7igKyBhmF6bT5U+zXwbPOstpbxk8lxQulmxOQ9ggEfZ6YG
 Pc01YPXT
 3XWWyu8GNHTC4LCe7pVMRblRzFjLpyMGvNeYuFoJ5Ey5qd9pUCEZIDifeuJ4fNySRaCcb1/97xP9vV1lfCZpN+cU+4Vdl0i8QVZK3fJ1XhGb/FojNHYxOixPoCw194ntKJVs0oGWGEXjAZl0UyfjDvndqjqqnTonw4VM6XK+7Zx5xjpVpTmfksqW/qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds a new procedure, iaa_submit_desc_movdir64b(), that
directly calls movdir64b. The core iaa_crypto routines that submit
compress and decompress jobs now invoke iaa_submit_desc_movdir64b() in
non-irq driver modes, instead of idxd_submit_desc().

idxd_submit_desc() is called only in irq mode.

This improves latency for the most commonly used iaa_crypto usage
(i.e., async non-irq) in zswap/zram by eliminating redundant computes
that would otherwise be incurred in idxd_submit_desc():

  p50: -32 ns
  p99: -1,048 ns

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 30 ++++++++++++++--------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index c94e7abd3909..cac39b418cf0 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1782,6 +1782,24 @@ iaa_setup_decompress_hw_desc(struct idxd_desc *idxd_desc,
 	return desc;
 }
 
+/*
+ * Call this for non-irq, non-enqcmds job submissions.
+ */
+static __always_inline void iaa_submit_desc_movdir64b(struct idxd_wq *wq,
+						     struct idxd_desc *desc)
+{
+	void __iomem *portal = idxd_wq_portal_addr(wq);
+
+	/*
+	 * The wmb() flushes writes to coherent DMA data before
+	 * possibly triggering a DMA read. The wmb() is necessary
+	 * even on UP because the recipient is a device.
+	 */
+	wmb();
+
+	iosubmit_cmds512(portal, desc->hw, 1);
+}
+
 static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
@@ -1820,11 +1838,7 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 					  ctx->mode, iaa_device->compression_modes[ctx->mode]);
 
 	if (likely(!ctx->use_irq)) {
-		ret = idxd_submit_desc(wq, idxd_desc);
-		if (ret) {
-			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-			goto out;
-		}
+		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_comp_calls();
@@ -1912,11 +1926,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc = iaa_setup_decompress_hw_desc(idxd_desc, src_addr, slen, dst_addr, *dlen);
 
 	if (likely(!ctx->use_irq)) {
-		ret = idxd_submit_desc(wq, idxd_desc);
-		if (ret) {
-			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-			goto fallback_software_decomp;
-		}
+		iaa_submit_desc_movdir64b(wq, idxd_desc);
 
 		/* Update stats */
 		update_total_decomp_calls();
-- 
2.27.0


