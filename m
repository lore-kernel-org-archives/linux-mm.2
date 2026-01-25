Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D532E63C81
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9136B009F; Sat, 24 Jan 2026 22:35:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3036B00A0; Sat, 24 Jan 2026 22:35:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6F46B00A1; Sat, 24 Jan 2026 22:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FDFB6B009F
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36F6F140423
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:55 +0000 (UTC)
X-FDA: 84369072270.21.7F5AB97
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E3F5180006
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X3YI5ACt;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8joqye1NuAlUu1PgUnsLrO7saLHzX4wJaterBiHYh2I=;
	b=LsEtNWeofuwFwGwNrA3hzBsJ4QLWAWUKmqlclz5aEjfkydMaXetLiuvCez+XMLKV/yEypO
	bpcD+QugXGO23rjydYrQ17srszrQ34iS6SCwI4dHlTPWor/iCBjJqQ18m4WBFvV1oP5Wvn
	t7R61KWuSKyXSJg6R2u3/+M5dslhj2o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X3YI5ACt;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312153; a=rsa-sha256;
	cv=none;
	b=TG0jQ70ttTkosBem6ZPcURpw8PXUEYZc/y/cGSRTNzJfBnVQM2maHGRKUZ64TkYZALa1Bs
	q0XwZSu/fzReh48UV0VjXM7rtE7MzbHcbBXQ1jMx0jA5OM9nXhYzskIJxFsA81K7C53D9w
	WdYepsUfxQv85UOgtuE93ZEg6W0hYac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312153; x=1800848153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TXS6CTscafJd3lQMfTmunv6KR6knJ1F1wFy/sJU25Y8=;
  b=X3YI5ACtCQ0Ytapa3kHWDhbVWytgdDNXebiL8mFYZuVAyt9PwQxi7CFR
   am+mtjjwXranYarUstfW1OrOahIF3xmYUNeLnZf4Sb/RWFxFdPEQlrQ69
   4fiqViCgDa46+fyp2/yr6aufgOatG97NxidUkQ496ARBANWdWP9gARe6y
   HVU3l1vipXI7p5UdHrYCwlhbagXrdNgXK5uVmU5pm6U00dzWn62fL7f4m
   8rCbD8u0JVeEWtmvTdmo6Viqm62nGl0oqhGKn+EW6ZQDCmIzBghHDrZF2
   hLfeHqFovhwyd29gKWuJzRWHSKxhNfQrUmvW3lm+CA7jYjy86OfANCd2E
   A==;
X-CSE-ConnectionGUID: p+9t6Wt9SJK6HoZg3lncFg==
X-CSE-MsgGUID: ZuB3Tm10RySHZfgGkpOAWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887437"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887437"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:52 -0800
X-CSE-ConnectionGUID: k99u/6GAQNWgvmrs5Y/PeQ==
X-CSE-MsgGUID: d5166B6RSsGzE7qv4gQMbw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:51 -0800
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
Subject: [PATCH v14 09/26] crypto: iaa - Simplified, efficient job submissions for non-irq mode.
Date: Sat, 24 Jan 2026 19:35:20 -0800
Message-Id: <20260125033537.334628-10-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E3F5180006
X-Rspamd-Server: rspam07
X-Stat-Signature: dpuyi74x6tqs84mcb1gstue3p7eks8og
X-HE-Tag: 1769312152-964016
X-HE-Meta: U2FsdGVkX19S98UFXi3V0DTBNXbZ8hjtTv4NLs4d8zMetjrYFMTJ9cOOWc46aGkkxroGXDJhYrWtktGpKWf1pID7ExSmo/c+SItRc9esKSWD2AcWo8A8c7UMtPMD/OgD5XNh6pPTSoW0CBL02YV0u/TlUVFIr3gBiRuS4w20yFZxqhQktDQjeXkPdPrhDHBxBPq39wKL4iedhGGWMWlqaQh+UOV6CuiR8zssN7HKdmU2nOcTeC+KfOzKISIk9F/I80e0Jzw/Z5kyD/ShOU9NwFveN7kQT7aLpwXCIZRUKwx7Z6IP9KbJLhlr/OhntxFRZF6vBtzHQ3IZB/4KDIx4O147DptdgmZpEtC3kbcDopFqMArvw7BzadQTRxCQbY4Y4yJ28npwg4DUchDJPscJaT7QhFVNEnZbuP1D+X5gKL8B+VeP5Il4u1pv6/1x1TVWWL5v9x4I945nGH4rOHPl51QB3WklLEVxkAUFbvBTlGTv+OpviI0u3qUTXUAhb1ZFUN2lQF2tDPDdGOOgDPp8JIwM/vElzC3mdKs7FmHY2o7dsXKhG+dwz0rnWP2w5StwLdBV/X0lpU6zb5hKhU6HjnOstgwUiXwomTBPr2K0ix6gvgXf6L7xMIhwpkaJKZQZU/ptwpLIfdMn5ujzYWFRh0py1a7pigZJwSSVj6Uf4tDQ+CyuGmTMz+rgVSwwTxb//DFLNqm0WBU8YWCyn69sGy6M4iucoiG7+LVKCsSwKHqHZCY583s03wepZrPjhMchuJcIq98vn3K1DU4bcqNR5mmkfFDcglw+RdqsguSce2KPLaeqYOwmIzLfzIeBtHprrzZdymtRnzYO++kEfNmnhiGZOCpkzNFuERW3wJXOjqdi2N73/yS2qhM6ADrc9eKr652+srojZNxMkg4e3lbz0eDo2QChrUnWgZ472FccSSytxfxdc2PXhMDQjGHR/6gCyElA/QwrHeznBoDsbh0
 JyICdBWz
 KTNlA8dTDcB6McqvDptITtc4CdNKHr9B8/g8S+a1VLP7P2jlWUD47uN41Sx4RAFaNsv1egipm5sJlZ2LVEXhvXjTzLSqXqwGKCLjm6cxDbMBmYxAjnGoTJGCL/IPLjSMuKuGVYKSUQNBvTsg67drA6WCu0Zr+pqoId+8tvS8JEIsWnm8/gY+q33x1aQ==
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
(i.e., async non-irq) in zswap by eliminating redundant computes
that would otherwise be incurred in idxd_submit_desc():

For a single-threaded madvise-based workload with the Silesia.tar
dataset, these are the before/after batch compression latencies for a
compress batch of 8 pages:

     ==================================
                   p50 (ns)    p99 (ns)
     ==================================
     before           5,568       6,056
     after            5,472       5,848
     Change             -96        -208
     ==================================

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 30 ++++++++++++++--------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index f0e9eb52eec4..4b275cc09404 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1790,6 +1790,24 @@ iaa_setup_decompress_hw_desc(struct idxd_desc *idxd_desc,
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
@@ -1828,11 +1846,7 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1920,11 +1934,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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


