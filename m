Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F085CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48468E010C; Tue,  4 Nov 2025 04:12:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA018E0109; Tue,  4 Nov 2025 04:12:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84AED8E010C; Tue,  4 Nov 2025 04:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7035A8E0109
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7EB1B9873
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:43 +0000 (UTC)
X-FDA: 84072359406.22.F46E4EF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9D38C0004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bbLDA3fD;
	spf=temperror (imf28.hostedemail.com: error in processing during lookup of kanchana.p.sridhar@intel.com: DNS error) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwTgu6uApzjxS3fc9LOaQFSsF++wc7AQzT4Xzv6gwmM=;
	b=Gq0JvfOCgFNBSMFTkMiOxFX9HSXGCENeyMn+4L+4VfxqvD/ewienODHJdRWvkBc8AL/LWW
	lbnXmIULak5XvIA/V+wDlAAPENzCJqSEKQnyeSf5kDUOKVvZJ2RXxLu3PqQ/7Yg54M2z3v
	7XwxWiU6VatIt8j0/aUxwnd6ABoWyjk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bbLDA3fD;
	spf=temperror (imf28.hostedemail.com: error in processing during lookup of kanchana.p.sridhar@intel.com: DNS error) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247562; a=rsa-sha256;
	cv=none;
	b=mibxOWEj1CcD7iuQfI17nQeZJNIho49mqt6EToXwhng5316YbuZG7IEhBXfFccrO2UdyYD
	ORPjVAO2K0mZr8zMFBruYe9KqiGusNelgueDMtGohCg0UNE1yb7s/S0IwuZtysBo8HcHzK
	80MwqJl4KCZISrTwrAPcpxoijwZgGBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247561; x=1793783561;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=azkrQ7DeSclQsaOR4GhI5QQ6G4Vd3RZf2l9aN/qPbMs=;
  b=bbLDA3fD8cwVgmqrT4mpZVcAlv+xPumGgpNuE16E4uvbZz0R2evqGvCk
   BCFytD6lOfl1ugw/E/IHVU8mrO/QcQDE2kK+JnQybTG9HCK0XHHe5+Wgg
   Xz6uSK0v6f0oFuCFk5i8D7S+gezoFGLAf2zAr2s5VZpVhTl0jJBtlI9Ht
   N19wNv4Do9RRf70end0h+nyk77LwgHbmfgfgjQHOCRGWybuMVFd7dgkzQ
   9M/qJGSSX90dQnB+/e/Ybrrb38C5iZgxwdWE7RqIf4lzfrJK5uQTTAJJp
   G9q/tucACf96PI5dqrbTJPbdVnx1wxcub5+opLLNXHre7GSt8JSVapuIC
   w==;
X-CSE-ConnectionGUID: KBsf/X7lSj6b7IokZtwq/Q==
X-CSE-MsgGUID: aZ8NR7DgQHGnmU/1ob1KKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265174"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265174"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:37 -0800
X-CSE-ConnectionGUID: uin207E2SMetKzkN84VFlQ==
X-CSE-MsgGUID: DTES6r2LQ0W9RJcIblMVag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795791"
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
Subject: [PATCH v13 06/22] crypto: iaa - Simplify the code flow in iaa_compress() and iaa_decompress().
Date: Tue,  4 Nov 2025 01:12:19 -0800
Message-Id: <20251104091235.8793-7-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9D38C0004
X-Stat-Signature: uhn6i8zrccs5nycw9c5hrth1yw6xqr8h
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762247561-772292
X-HE-Meta: U2FsdGVkX19rwWQjtfUW2cJTut8O9ct7J9wp5efrNe7D7jNH+W5fzluQRiCN8yoAfoqBY+/LIqz0E+DxhHbOzU34An7iVObaUl5A4jw99rdXbtUF+vSLfwfoxcb8h+qKWhkQtVVsgC2AxilIdBa6XV2KRAGA5EXxC6bCLDGLRTU4EnVfPeCec7op4Sg9cfffPXpFH5zhF+wHr04K23NFZ3iOyFhqiiMjHEvEP2x4KS2vXmdyWDWlojpeRy7pzJT/xM3OrzK6ItTY2eTuUv66coMcBwVOaMXfQQFN4X5PCKhvYfz9WdBkbtV//Gyi7nHN9QnkNgUHVdvpI5mckgHpxEgwJLgC/HOlV+aOwaIIy2pZ90b0KQta8jeqHgKVgFazaFE9UnqDz5t3n07/a55qA2rjO8q6I25px0RiigIAgPoJ5oxQaYbBjjZ1+eya2i63lzhNKdKIQ48RuuP5lZjk0l5+oAMHTOZhUHxmiQ3Q3s3qJdpy7jJB3yj8u9kvJT3xyFoOvzFI7X/NMixyMNoFnQyrRiEgheiRRLMKZqVLXs7qX4U4a2oPhIbKNqfKkJ1zezNWpqSlAQfRP4yzAunnYnU3+XzP7D38Cn8cGRnMT/rUj2fi8tOqcpjUg2sc35T0n+s9AZVrOZuAaXFPvfpWsYG04X7xinhERp+vys5sdUk1RQj581BaDPbA6h+zrx4NjBq6qJvbuqRDkI+UzbrYf7J6ZjVc6ZmmWK1DXikR1UCdVHP1gWNFE+z85o3QYyHTUswGZn5Mx61CgturuW/bYdSm/qD46T6Zrg4eVfknGLOePzYV4tq6DFZ9qTWLym/5IK6ug80SBfgK/+GayMzgeJuaNgmnF0c6fyjCsjteVFMYoRql0t8weqoF0yjKsn4QCDhYfRTpcVFXRew3k2m61QP4owQ5kPIThN5Uq8c/kK0=
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
index ca53445a0a7f..74d5b451e34b 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1798,7 +1798,34 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1806,40 +1833,23 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
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
 
@@ -1894,7 +1904,22 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1902,25 +1927,20 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
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
@@ -1935,7 +1955,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		if (ret) {
 			pr_err("%s: iaa decompress failed: deflate-generic fallback error ret=%d\n",
 			       __func__, ret);
-			goto err;
+			goto out;
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
@@ -1947,10 +1967,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
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


