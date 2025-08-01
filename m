Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D252DC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DF76B009D; Fri,  1 Aug 2025 00:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B86C6B009C; Fri,  1 Aug 2025 00:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6CD6B009B; Fri,  1 Aug 2025 00:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3726B0098
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:36:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 021C5C0F1A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:53 +0000 (UTC)
X-FDA: 83726928306.30.0E918A3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id E83DB40002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ngY+Afmt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023011; a=rsa-sha256;
	cv=none;
	b=WDsVt/rIZHf9IM28ulG1gyBWO0wvJECJ3+ODVhXbXZF5bhnOP/yJqsDqVXaiYEKUnli77m
	GsPbLfYtBVmwZkbQxoJarCe7DmLaz7H7vNiz1t0kt5QRwQvaTC/OaYQTwqYGoRL9Db6Ry1
	ZpxYdJYe46E8t2OD5QjP7vMypyA7cng=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ngY+Afmt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKU512LHdFo4cZpys+/8l3ZTTENS2cCRaULS2bWKSEw=;
	b=pgjQ6hlmxeZufaNtTOn7EcVnGnCHTsyFmEsYtTnJYGEUgC6dI9b+E0s8kUj4p85trKAcqe
	QtkmwzdqjsaFWHozS1avp2Nb17Vj5zD5q3QjL3X42qyBAq6/K6eN9bZqVMRoHo+qTbu0uV
	CwIbvjA/MRrf9Q7Se8sHDnT8zUiJIEE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023011; x=1785559011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tfz94EJhl5ceOxVb2puBw1oVVyvE1c9obC/5A/EsyHQ=;
  b=ngY+Afmt9TwdCUKhdlGaFcDIC345Zmad4aSr4fFrG9J9j0rp6wXRBJfA
   5LQWPsKlB/33K5drMj7Jp8LBDNBqawhKdQxzN3XWP0ITr08l6I0AuTopb
   N8AA6NJGUVOngUye+Repl8mR0VcGzmpGtnGw3UlqUpDUuEtPiXS+fTK71
   ohgzzUmffHCohb2dIYoQw1xgry5vmoltVGB91b19fXSJBm48Gv68zbvb3
   xG92Rw4Ax45ePIzEInVgdhRbPUnBwkhz/HDiZXrfsvZLaqHKPMm9xqeDf
   tZqJw14sae3Sn8TGHmc2cyyK79W2nB4dtngGct3fD0LmOJOWiTAny4FOs
   w==;
X-CSE-ConnectionGUID: 9aBImqXjTF25iyKfLDw2Wg==
X-CSE-MsgGUID: QMEeVC/2SgmIf4Ts87526Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820209"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820209"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:44 -0700
X-CSE-ConnectionGUID: ADO720g5RLCFo59jOsCNKQ==
X-CSE-MsgGUID: jl5RRdIuSnOTEpTUwTWu2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796242"
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
Subject: [PATCH v11 06/24] crypto: iaa - Simplify the code flow in iaa_compress() and iaa_decompress().
Date: Thu, 31 Jul 2025 21:36:24 -0700
Message-Id: <20250801043642.8103-7-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E83DB40002
X-Stat-Signature: k18s9jx6ch3436mehrwiuzcdprm5sab7
X-HE-Tag: 1754023010-678632
X-HE-Meta: U2FsdGVkX1/8AMvf8UmRULPXoxs1WP8s1Ysfld7mFQqFFeEAJ6ZNfEEKhGSJ8Gbdz28n17GgzKOQuCZjYOo3H45ukRGIDXDLVM98HDCCaUywhHXUVA1Vwp619iB7LhsTPizFtUicbdeCa+G+GGtuo35nEW2QDhXVA4k+v9pDq9Yc3d9hurXQzekxPnXiYAFHn+PzONw/mfbdy+k+aUvM2XnoCN7CwwyV2eOximaY8bF0r73WE3JtHigKkr56Fce6gPfgIa9vb+3T1lpqDvdKHwGlJGtfHtfYHdNcszxEzgtKP7lZ9y0+CLUG4hCBwLXQ4iXbg3lWXZ8Bm4AjLDV796YcRRhXUNdNysXbJcIdTYKq6p3TdJplA3VWPCsZR2cuEZXen8btq8KqRsvcx4sFsHaSdjYLwrspxPq6hNKT7fbfnS2xcYFeSskOjcHYZHignLM5OJfbQCz2Qq9OWzEnXpouvaTxn9ZvqS6TfJOwPETmVchVq7oaslc6TAQFeAxAtoZmIfWALhDlErYu2kFSQGNumr1TBejbpRbz1GIr5xpdE8J2p4ySMs/ZG/JSnDEL4qpmUhpggojCh+TLOpj4iiGIMIS16RZcxBu3DpxWItjmdzbgkuKjxtfK9Q19Jm9TnMmLzVFffCTN3XZ/EneUXI+bi+DcSd5zygGLhIRekhaUrcbNQ4WP67kq824tgOqaK8PoDiq06yD2rmeL6ntOcGSXClTAst1q7/zmn+kjfRQ1T5jZZphNe3oCRUs7AgUxZNhCB7TgZp2D+NJcwXX8O2GWCbSqkHMB2w73op8AZI1j0IU2rYBTOUFB22EP8s/UlGDG8v7idpU5q/BUQR2l2RKDlypNo2a5G1e/7xO2s7z/4TAQw8M7ChOvIu+jmTY3E820B7n4nVAr+qf7eP8BsJRT+Gm3GCJnjYo49Mkaj/GqiRcUSdhMM/Jd51pqifMKY7gsWuSnvO9cGHCEfGN
 3Ju9JMM5
 E5N+xiW4MEjxYH1bS9zNpQ0oFsqTDuhnrp5UkzMb19a27GaziUYt/N9bMWiOJa/mgXy2lvbg27+SSakkQcgQD6sUlTpUYdcrLL9Ca5xkEiI0RE/6XUQN8wkWY+Nt53SU+EX20vIJZWj+0Q2v7wRCPX2GHGMEOeVcCXttGeLxG9s4icFlPVQbH6aefmlus8JZwUa3P5M48wF1Nqlo16VYO8DduNTes+0eS0qZP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit simplifies and streamlines the logic in the core
iaa_compress() and iaa_decompress() routines, eliminates branches, etc.

This makes it easier to add improvements such as polling for job
completions, essential to accomplish batching with hardware
parallelism.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 114 ++++++++++++---------
 1 file changed, 67 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index a12ea3dd5ba80..f80f3ab175a48 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1792,7 +1792,34 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1800,40 +1827,23 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
 
@@ -1888,7 +1898,22 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1896,25 +1921,20 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1929,7 +1949,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		if (ret) {
 			pr_err("%s: iaa decompress failed: deflate-generic fallback error ret=%d\n",
 			       __func__, ret);
-			goto err;
+			goto out;
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
@@ -1941,10 +1961,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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


