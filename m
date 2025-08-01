Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B57C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AB36B009A; Fri,  1 Aug 2025 00:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A9E6B009B; Fri,  1 Aug 2025 00:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1876A6B009C; Fri,  1 Aug 2025 00:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 094286B009A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C96FAC0F11
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:53 +0000 (UTC)
X-FDA: 83726928306.11.BD8E9DF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id D1E6614000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LjAK13Pu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023012; a=rsa-sha256;
	cv=none;
	b=QLFa4zy80Mqpks/CiJOpKGKFLIG92FQ+XMwGU51GNelsKdKwvavG7yMvpd9Rup+KoMy7Kw
	04FeGVvMwZgyk8P4v5pJCH4n17CtHOFah7DiZmIy165ZtLMISVToTekFG8Q6BWpgTS2QQx
	eihN2tBYGoPe2NNc+n1GFTuKIdM38bU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LjAK13Pu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oO/gSc5Kz8H6FMzBs/b8wzSfVg2ahbzD/r/C3w6XLb4=;
	b=We8AuH9tQg4gcfSHIwJGckFJG48h43WMjiUgxkVj/JhNY5yKbG/AAjGHrPXYUxO216HACQ
	Ut8X5TYcSoToqUwwAP3AuZr2B0j5Ccx4TRscDdhMvns3xpr7LQEOZLh4Tx/XE6Z+DYMEhf
	/Jrmba02dvCsdLJPBCa19w7roNK/J+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023012; x=1785559012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EHRV1i0kscwsN0ARbX38Rrgo1/s26b8T5aeEMDGCmlU=;
  b=LjAK13PuS86+GfEpdaXpIEyBRcR6frstZUIstSLbCOjtdaeHY6KPBAxu
   TjUSdO52QHMKNWM319YM7e53iKi7364Q5GiO6gmTa9UFwBIwDsrja8oIH
   r/P7+EUHGREJO7FrWTc9KDDKIINic6vPVjeone6ITmdST+kOEOcJjFOmv
   iau5oZebKkcW7ueMxliFuDByklt2zfsGAmztodxTpPEuMAQ2fId/9cpHD
   oc81Vt4/HEaAuP2yFoNXSiToWYThllKfqAY9Kwcxu7efOTIg000PL/ajA
   hpqxuQvkB42wDWF9jpjYtCZo8pAe9DuqGM/4p5Yjbotfw6gtD3j7MigLp
   A==;
X-CSE-ConnectionGUID: v9jeCJR0Q8SZCAsbZ4RF7A==
X-CSE-MsgGUID: L3+KWTwHRe6PZhXO1Y/AJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820237"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820237"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:44 -0700
X-CSE-ConnectionGUID: ZFXyZA/mTgSl9sNgr3jntg==
X-CSE-MsgGUID: VUq+bsOhQ5yh7b9rbL9dNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796249"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:44 -0700
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
Subject: [PATCH v11 08/24] crypto: iaa - Simplified, efficient job submissions for non-irq mode.
Date: Thu, 31 Jul 2025 21:36:26 -0700
Message-Id: <20250801043642.8103-9-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1E6614000C
X-Stat-Signature: k14oj7oh8iqmyikcg6scxxerny1yd96x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754023011-689274
X-HE-Meta: U2FsdGVkX1+IqztztEOQruQJIJnehOckZ40C23PL0GvERUpUpTUWvnlq+KNGRq4ykju4a0Ssu5fqtO3jmvtzSHcWPtYjTngfUqseRmvIoMCdkFR6/lhlpSEZ2Np4lUIyQ9lyUlJc5T1KB4Umnrh/2pVy1oF3mY8WezYoV6/VqEnXd9Z8zeLZT6jjmIiAeeJFWf+ouRm8R2j8jsHA26YBHfuoHaMQTJzl+7P9TuaHhbaQVurox5cr9s8wVNnnZUNbCu8UVPFxV24fW3vn/QFJntt4LwtLgAquVME8Br+VtVBtd7OthBZNLBzIs66Of26VtXcL3nQbkzFypdMNz5OUy5/MNSPaIY+TMbGiLaQQsaKS8TGE3istNNqP06G0v7doiiIToYaVZJIunU3sP1CWibldZ69igni4agMdYOZZjPkYX2M5NFDq9e1Khm8qeh9BFy0rantc6/vhDkd7HErOPk0Evoqme6V3XrodEfD1Jc7mDERWVp1iIdc64RAd9jSxiD4lcqUJ6275hZcezNaKHUaQHxd6B9uBj07CqdaQEeUBnNUNV9wKFDWTZqcRWak9rDWIegjwGIGzzg+x0W97AZjmcPc20UWPrdZPWlfkCbX+Qeor7kT8FVuMDTrnwsusZxwfx2xHAGqZsTVK60XyZw3r8d2bdQwebIH47nccA/HYCcsJ9hcc1/3t/nJsz5+k9UuF48uuFTVB8sr5xOA6RuavU8ZV8TFC7aq1pn4SVZgyGtKX/KcZR6fTnCVTRZ5ewjlWBSKsiyeKr0Zt5tDeKBt0jsZBX2Zq35AsGJXKZHnDInLazcGb77sCzS5GbOBk2M4H4t8IIzGEaL7xUOtNNBp4Nn9f39IXmBXzGhkNeaac18UnLBAF88DJ9PGpvQgN
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
index a9e6809e63dff..63d0cb4015433 100644
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


