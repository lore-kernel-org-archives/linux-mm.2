Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D61CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258CE8E010F; Tue,  4 Nov 2025 04:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2A28E010E; Tue,  4 Nov 2025 04:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28938E010F; Tue,  4 Nov 2025 04:12:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1D278E0109
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E9F758FAD
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:45 +0000 (UTC)
X-FDA: 84072359490.02.1C722BD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8C8841C0005
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NPndAbmD;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qM8tZ99QvX34OUebu+pKKMLfxUauxhKgeTcQmpO1+4=;
	b=2a0uZlHG7FCCjwzFJZzcz49q9tssKQfCnLyVSdVH4UMTbFCBVYWDUuZzJYCxK/atZI7ub8
	71ZxkpD0xMv5z3OCCA7JgfOu29koLtvchr/3RT0FyYNg4JYBCBkhMdWJ3XhdBow15nYdBs
	zAUp0+xjmFlzYLpbqh4dtQtefrFVjyI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247563; a=rsa-sha256;
	cv=none;
	b=GiLxu+YD8w+nkKg4CKUrA6lxvQUDuied4kxLlvc/o4NcuXPZcamZW7W43XENaToRDxGKfI
	AciruL/wwHELLCPpnzYRQi7GzTsmnS4OEYHzl25CCzcuQ3+Xgjyh8QUCkQFahQPIZ6GfQW
	QfUSRNpq4wJ0fKTypq4P1e160d5RJQg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NPndAbmD;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247563; x=1793783563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oPLPiJah8d2OlF+hWiEDugRJhKLZBvrW8tTZckTAras=;
  b=NPndAbmDLiSF7pbFRb5zEsROZ01pGofQgcLem7QWEZbjuYCKxMwEK8Gp
   O+aggoS1srBAQfnpmZ81xr4QHGstUhNa6r0FD4kLFFZcL75gyKUCl4hfb
   kpHizUuN6fYZqkTrlPPaxF1sOTy9NOxmghWKYLi/KrPgA1abtOfGCws8E
   EDExG4gJwsnq/MLPmQmobQxjKdBAV1zz9HQCQZi4hTQVNARgw8fzvkcVX
   RPuum9TbcVtUG6TJl/6kS1iHgs0SCanR29yS9qkdPi32mCPoDsA47xZKu
   nEI+uKbcUCQfc+740K+rJYxxXvCmyBK4sBZ6YCxxtFyMZy7KFglGGR2iq
   g==;
X-CSE-ConnectionGUID: hR5J1yYXRoyl832pYozsTA==
X-CSE-MsgGUID: Fqtk7d+bTrmw0AKMfCcyQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265179"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265179"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:37 -0800
X-CSE-ConnectionGUID: u4P3K0AWQ/KWptIHKn0nBQ==
X-CSE-MsgGUID: 06kZgNKdS1yNCN6N6aM5bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795797"
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
Subject: [PATCH v13 08/22] crypto: iaa - Simplified, efficient job submissions for non-irq mode.
Date: Tue,  4 Nov 2025 01:12:21 -0800
Message-Id: <20251104091235.8793-9-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C8841C0005
X-Stat-Signature: ja5at15jkd6bs3agmhzd5jstjx5i55oo
X-HE-Tag: 1762247563-738579
X-HE-Meta: U2FsdGVkX18Kq4ePlYugiso7YfKi+qZCCjzEiVt7aL40eNcd6EXOO8+UOZib78EojUwpyB5RKTN9LO3fCZNGbPedDnyx59m+TfYrdx3yf/JLa4JWe+V8zB7T16RPjX010rVcAnXqk4rYd4q+WBPDjfvaTogB5IgWgiAVDBjYS/gc0yEOLKi7/D4Vm8J3vhVJ013HE9+00k+Hfi+FTxFiCk2bxXhDQcqyItKv6HpECa3q5dMqDEZi3mnarSghj2yqJuBgFAlqtkIaHIt1xa8uynmL8Pt5fwIoyPgoAM6neZS9NtuzA371lZ/GLGmZ2hdA+JzWtyDe8cTb7V5eZ9kbWrmRyQcyaNLg9xlikwf4aDKuemqbzANo9KdWjts3dQQd0hi2wXVNLsG8/EW+UwlxiuYo/h5Su+myJwE4zbrJBwE7NIpWXtN9J6g5t1zglBDaH0uUqa8AQ4z6GXMxkSf42txWbzCPM2+7wxPKQYvdFOTsMn9UPpsDIlZxNhH+Pn0u1UNoUNUVjGX0BpW64PKSLsf3F9oGWnW0mr8+zdj4v00g9E7+8fO+HNQvps0BxMRoZ9J2VAYc7xDGaIAVPa0wUqk2U9J4Hx3HQdC3nHjUel8mlG8gmiMPBIjGJqKVwQwbhDn5dXu26Jr2u3Y0dTKHwToEmqVJJ4DkgTYEjBcHkFA2HUMvv4LZbFj21E3PjMK9mFGDHvuzfGfqrr+xM47EszNGjGdPvnJLEpunXzT/2WYrVF4AJ00XYPulg218uZJfo0KsZG2NBrZw1qLM0ebfwEX2jQbmSvhgCG8AN31AFHh4pHKgqlOH7/9HplEoM+EoCH2p+637camk/3C2qEULUeK454KUM4I12CKTRwp5tNlkUG1UC67f30zxXax6X5et0R9CPwqrX+BRjROQO63v2fNUMlf6ZDIhcnrTcTkb/ojhvbwXBkeKZfYj3IqO/8ZmRTEchTw2ctI+oNQ+0fK
 Y0nTzx2q
 BvC7E+cVaMDoEazq4xC27r0w8JyBQXESFON7g+dnPDkT0DYwN212Vyo/p6iDTN5QfInSgwN1h+mxHfcn7JXtbCLrtybPwfIP0HOfYeYwI4CFWO71zTV/1wjIaR8wl0hxlR33SXZnXf9o5XF/xLX9cY94tMqjKGW4BmAS29ayaudQAhp2oBDv1hUY0Og==
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
index 697e98785335..dfc67109e81e 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1788,6 +1788,24 @@ iaa_setup_decompress_hw_desc(struct idxd_desc *idxd_desc,
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
@@ -1826,11 +1844,7 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1918,11 +1932,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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


