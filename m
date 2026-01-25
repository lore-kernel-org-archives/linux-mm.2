Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44733E63C81
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD40E6B009D; Sat, 24 Jan 2026 22:35:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A401B6B009F; Sat, 24 Jan 2026 22:35:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EFF16B009E; Sat, 24 Jan 2026 22:35:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4B46B009B
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 019C4B970C
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:52 +0000 (UTC)
X-FDA: 84369072186.08.C6C9C05
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id DD356180006
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ty1qdUc2;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCTiul1ByBa/7stQ0jlDY+wAlBvoSpqlrbBEK1/Cz0k=;
	b=koOlcM/tQMS5BO3lcJvS/u8drBhIDmMqlyjPLUaEduIdfd5PC2CeeNrJHgEzmz+hvy3TPk
	5okZ1BNKSduKh/WFB+VGLkc1a7G6cgGR1lUtxNB2ufKof1bufZ/Q98hVr44hmYkk87xRYg
	RA6Ik4MWSJHXXCNspTJ2+WINIxFBNzA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ty1qdUc2;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312151; a=rsa-sha256;
	cv=none;
	b=jSS8wiROMWLZIPitKiKcb6r+WaLvG7T11zdNX23MguEriMHc5TaaP3zo8vdCu0L5meB74b
	Y4LwahHMfrA73FWNA2QbZnjMUjXvXRVr8fdIw1NTRXBWZ9vecvUdfBffM6smCEkOIRdCU8
	4IgprVxFtre9JKlh7gH/2w/KahvQ5w4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312151; x=1800848151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uouKU0vsxu25WjgQZAwJOmR1+ifiHlkSgXwdMLeZ+pA=;
  b=Ty1qdUc2SCkWMw59W7N2emOK6wGu2OfEPuyRD549XSBxfg4Ioe0/H87B
   0Ew49x1VC1OUqNeR4O3Jpbnd3sKTg3nq0MkJoW8GrRW6/PgEsAfScd52z
   6LVYg/SSATLpeorZZDz9XE1YEf9BkQa6GZWSmzqs3j4O2y0dKBrpq1JxH
   jARram7rg7IOU7wHj6YrCcwycYpn/4D/OUoAXNRNJmEY8/Nyq7UIhrltE
   +mEZNxbt0p20SAleqqbq4MJPBhlINCo7M2V1+JGuN8HwZsInbuqbB1l/+
   0efmSCZXiWmvHMYhZGwUwmO3eOSEEo7DlGdv33uXUHknKtoV4qV2el4c6
   A==;
X-CSE-ConnectionGUID: yc+kBxGHTY2JoxJSxlpctA==
X-CSE-MsgGUID: mcWrO8APQH+criWQ6ldWsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887406"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887406"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:35:49 -0800
X-CSE-ConnectionGUID: dKiPaKA3Rcepklzio8wAkQ==
X-CSE-MsgGUID: ymmFnGsSSOiKenGczLpWyA==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:48 -0800
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
Subject: [PATCH v14 07/26] crypto: iaa - Simplify the code flow in iaa_compress() and iaa_decompress().
Date: Sat, 24 Jan 2026 19:35:18 -0800
Message-Id: <20260125033537.334628-8-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DD356180006
X-Rspamd-Server: rspam07
X-Stat-Signature: g5uo1wd5mfi5gtj3bdjmc8brpndqgh8r
X-HE-Tag: 1769312150-158532
X-HE-Meta: U2FsdGVkX18Gg/qal/PXh5i8ixgFIWN/HwrcgCgJYkjwBYZ7tTxHNxRC9mj5NS7ssWnWsDiAZe7lrAPhqy1idyqnhirjPqCUV5WZ7jVZpITHtQfLIaq+8A9bAxrxICRKmAX1sw6FZ75qWyRlajB11KKyenkTuj9qdlX3WF8fEy7I8gKTPRZU2N6D501rDSJmVEK9Nb93CPtrMd6cx1dTVoaCAKWAM/FhgB9Xs/O1SRf+TprV7IYVDkZNL1ctfTqpeqBSI63gyeYy0R2DcW4rEtWd2mpujQmRTtfdMkUBl4T2MnaaoJ97wpRfGg/VSLoJ4waO+Efg1FO0jYtqhbVPUMcHRkSN2yJ9QTuE4emEQDJMpVs1l+S/YoiI5qwIoTS/xnW9xkwGCFJsuQcYbf0TzoThzRDPk6qFkg5uBnGIJGwGOr6U+/AFP0CDldq3Vj66ImrLTU9SAgyZjCi9bPcVjmpca7/26JKwJqAXUtJTW43eDFpdoPxykdBwrlMAx8UFkDg1w9MkyDOn/hVt1NG2p+oHigA4UKQj93HPHHug/9FNOmQkCq/EX7IBL+ULzclugSvr3X4OV7020cnl+1+1M2cO0l0mVI0Udh8g2kQoF3mVVkzj2zo82ygdUub228UKSdtKbmbhAudRw3Vxcd1aqgXA5/awviz2gER3fWHqct/tDOHqPDUaiMjWhi+ojUXpmW6XtBQ0LLNHlnbb6jioE2V1S36GHTqlhM1PJuHxGG7s3uao3Dhefi7DqrT0r/jkHl41Mff5rvioKyGq6V35LhmmFz/hPOnDnyQivcdaka9fbUPCzTS0bAozw11fxu/lFgt3BFilLnKvVpmV7nt38rNVOwCJchladWiW4ADEuABVJsULj6KYlI2974t8K7lZDjf1Auz7Nt67+BF+KCuuc1ygL8oLxYNLu0fFVlaWDczllX6WfXzwig3RoGYyAllQ1KMXBZNXg4IVChb2udh
 mbS9sEcB
 fYLinYNlCTcme95h8J8+Ia/eouV7tHI/GGlaULdJl69wX4L5UTuCiADgAFNagbuDd1KevUlagaagxYUqa86LDlqaTElWipvloNey19xRyGQyV7vR78+3OpUrEeVd0A1oEB3EWo0BYmvZSioT7NB0VfpOcH8GqIJBqoO3izAlWWLaN2selDuIXCD/Wek5DHt/wvpTGiPsHzgZ0TjiLNYk9tSh72QV2CoVhXPHC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit simplifies and streamlines the logic in the core
iaa_compress() and iaa_decompress() routines, eliminates branches, etc.

This makes it easier to add improvements such as asynchronous
submissions and polling for job completions, essential to accomplish
batching with hardware parallelism.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 114 ++++++++++++---------
 1 file changed, 67 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 01d7150dbbd8..a727496d5791 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1800,7 +1800,34 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src2_size = sizeof(struct aecs_comp_table_record);
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq) {
+	if (likely(!ctx->use_irq)) {
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto out;
+		}
+
+		/* Update stats */
+		update_total_comp_calls();
+		update_wq_comp_calls(wq);
+
+		if (ctx->async_mode)
+			return -EINPROGRESS;
+
+		ret = check_completion(dev, idxd_desc->iax_completion, true, false);
+		if (ret) {
+			dev_dbg(dev, "check_completion failed ret=%d\n", ret);
+			goto out;
+		}
+
+		*dlen = idxd_desc->iax_completion->output_size;
+
+		/* Update stats */
+		update_total_comp_bytes_out(*dlen);
+		update_wq_comp_bytes(wq, *dlen);
+
+		*compression_crc = idxd_desc->iax_completion->crc;
+	} else {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1808,40 +1835,23 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = true;
-	}
-
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto err;
-	}
 
-	/* Update stats */
-	update_total_comp_calls();
-	update_wq_comp_calls(wq);
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto out;
+		}
 
-	if (ctx->async_mode) {
-		ret = -EINPROGRESS;
-		goto out;
-	}
+		/* Update stats */
+		update_total_comp_calls();
+		update_wq_comp_calls(wq);
 
-	ret = check_completion(dev, idxd_desc->iax_completion, true, false);
-	if (ret) {
-		dev_dbg(dev, "check_completion failed ret=%d\n", ret);
-		goto err;
+		return -EINPROGRESS;
 	}
 
-	*dlen = idxd_desc->iax_completion->output_size;
-
-	/* Update stats */
-	update_total_comp_bytes_out(*dlen);
-	update_wq_comp_bytes(wq, *dlen);
-
-	*compression_crc = idxd_desc->iax_completion->crc;
-
-err:
-	idxd_free_desc(wq, idxd_desc);
 out:
+	idxd_free_desc(wq, idxd_desc);
+
 	return ret;
 }
 
@@ -1896,7 +1906,22 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src1_size = slen;
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq) {
+	if (likely(!ctx->use_irq)) {
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto fallback_software_decomp;
+		}
+
+		/* Update stats */
+		update_total_decomp_calls();
+		update_wq_decomp_calls(wq);
+
+		if (ctx->async_mode)
+			return -EINPROGRESS;
+
+		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
+	} else {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1904,25 +1929,20 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = false;
-	}
 
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto fallback_software_decomp;
-	}
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto fallback_software_decomp;
+		}
 
-	/* Update stats */
-	update_total_decomp_calls();
-	update_wq_decomp_calls(wq);
+		/* Update stats */
+		update_total_decomp_calls();
+		update_wq_decomp_calls(wq);
 
-	if (ctx->async_mode) {
-		ret = -EINPROGRESS;
-		goto out;
+		return -EINPROGRESS;
 	}
 
-	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
-
 fallback_software_decomp:
 	if (ret) {
 		dev_dbg(dev, "%s: desc allocation/submission/check_completion failed ret=%d\n", __func__, ret);
@@ -1937,7 +1957,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		if (ret) {
 			pr_err("%s: iaa decompress failed: deflate-generic fallback error ret=%d\n",
 			       __func__, ret);
-			goto err;
+			goto out;
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
@@ -1949,10 +1969,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	*dlen = req->dlen;
 
-err:
+out:
 	if (idxd_desc)
 		idxd_free_desc(wq, idxd_desc);
-out:
+
 	return ret;
 }
 
-- 
2.27.0


