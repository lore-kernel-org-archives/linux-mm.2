Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0E3C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72F3A6B00A7; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DEFB6B00A6; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446106B00A7; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 153D96B00A4
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:37:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBF49161007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:59 +0000 (UTC)
X-FDA: 83726928558.07.682F4FA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id C4F7640008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:36:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TJuXNAAE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oN9OqHXxPdXGMc0GO4VcTwubjHVuGw8MDzyPJKvZF0M=;
	b=8dRJPU8fsJWRDX2qzjovXjIkPQqSK39K4B6fwb41KPscWWrLYwr1X3tq5AwZZ+D78e31vB
	BWM9kTkfEnjJnVDzN874YoP1AxumOykZSboXPF7nSFU3iVy+I4Afq7kg59Um3NGKNsCLrL
	aO83mGZ9QhQcWSaHcdd/Kl1m1HRGLVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023018; a=rsa-sha256;
	cv=none;
	b=bU3mVFZKPh4ET0IYlDclwrcg6CtkvMvYQgkYb4KDbcDAs/oBADHpeM9g5tjSq7f9y9vgWG
	iLKH7q97AfqSGGIWPydvgNddD0PyhgQiJBsnH4YydIhyVNlgS0B5atGSgXphVRhSQcfnHi
	XDRpNirA9Slvi0bf601fl/HMV1UrjD4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TJuXNAAE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023018; x=1785559018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ZLjGS9LPh5l1NRnF8BWKlxrZG59dvvl5zxuiBF/lbw=;
  b=TJuXNAAEc4SpTJYWy7mSgTm6LC++gXuZL+rEmFrsAKg0edLHdvm6uYZt
   mTDKgX1wMkwXYo4yJREXRH4spTfxIBrX1fcZYyoBke+QYWDARi0FGp0g3
   YoagBnIDewD7JY/V1MGGW9Hf7KkcjS/8FnhZMDECk2tzuiHFj6ROc+EYK
   qgnr0cdS+UJh6TCHSiDyx5jNHSAR6UMCO+oTLo587lNpqSMyMWaqm0YWU
   fJ6Zeo18NdLJ367DiGCcLv1gKfmqwGoZB+Jqd9NV5yIII6SyqlWehcXx9
   h6ZwjhAZEnkR6gKA/pncAkVyO2HKPbzSXUE0xBd4bA9Ubrr4BEsxEL+Ay
   w==;
X-CSE-ConnectionGUID: DjdQzZAaSgygHjUiO//Big==
X-CSE-MsgGUID: SK4YBQ+BS9itQKQIXWDcBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820349"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820349"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:46 -0700
X-CSE-ConnectionGUID: f2WOmrJLSqu26xYnHRLdSA==
X-CSE-MsgGUID: eKot6YdyR7uHM4tuWqMcIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796288"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:45 -0700
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
Subject: [PATCH v11 16/24] crypto: iaa - Submit the two largest source buffers first in decompress batching.
Date: Thu, 31 Jul 2025 21:36:34 -0700
Message-Id: <20250801043642.8103-17-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4F7640008
X-Stat-Signature: 4wk4c7ocijuzu3ef3camr5bth1pu67m9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754023017-359033
X-HE-Meta: U2FsdGVkX1+xs1I7WFXqrtrHehHoV6ryOZCBR8M34tgPFd2RGvkmpWJNLWFov2GQNlSZ1xgAex4Z2Z3xCifq2mfgEdZdLWhh/1xnn0Ne8DDw3R3Ib1Ush5ZK3y8iVkG7xmE4+9snIFP+bAfE5804pXuOfP5SK5oJ/pIcvICTLm8Rg/m+UD4/V8Pko6CVy5iTNAzZkH6YBXnu10btwLo99NSU471osj53CZOponhafAA9ZFnOKkSvC5UFwgz+BZLEDhRBD2D4JzMVK7I2TSGPfJIJsiyNtqn4h5yrBZTSti207CPYd2L4gW73bnLH/Xu2piiGT7jxyAYB/hgS5Vr/kFi7idejK5/shLMnZ//Yw6Zpa9adKDJrk1tq22Z4sLudcRFr+tDP8jdzWtoL3JEj/bdocCvHQVaMkxGBiaybP/wPQOZlcsCg99XHj/XPGotFXr+JhDKbD9DwpP3zDCHaTqYx4BFl1f0Su7NrcwM12nW8LfcXJdw0x2s3KVhjdi84v6Xtwc8rsPM7FIv9EifxdiJaOb5J/urdGVZ0A9aUOkrfxKeqd9QybQeLylzOuraA79z6xFUmjal7bWSJHpFLLLbMAhulQJjwJ3BLZuyGHb5fSqpTqcsZNM/0iZ5YRbrXFbHKvUXSfLWTOsfv+bHG9fWkV8W5gVwPPAjzzLnHByJRnXBMw3e7TUCyJlymbVwrnHF4FsHcd2tK6OrtATPxCThuMhB5M8FNBiRiDQyicUcbJHknKpeArK2lDPlCQFGRMxnz/+aIDJUGedJZ6MWW3VPhXDz3wsR1840h7BI0oUxjrpRFznyHf5pXdASYOcUveKJGs0mDF4qjphKf3jKYfRUwwUSfQdqMHIPy1CtZJPItQruK+eU5Wz2DYKVDn8uMriHAhuLycipXWYGJqeHbBoS+aFuPD88gkAE9OeQHrF2bbW+Ey2lBKFYDwOAB7SXxmiwCigctpdCy6NfsOJw
 9LQNu+yH
 zpiLSjUKNP1B8mvgIl3Sizj4+yTFJRjElwnOCkA+ezSbQ52DAluM+DNrxDnvAueSaJoGuCtd55pu11ZbcKmGaNpCaLnkV+0gQinAUKrDVONwALrKcim5YjeLBvju7/sbLeZLvngH1H8MAZaEBxCzUZgzWqFoQ0n8ujly/d2Ou4xoJeJzOEoF1sBazIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch finds the two largest source buffers in a given decompression
batch, and submits them first to the IAA decompress engines.

This improves decompress batching latency because the hardware has a
head start on decompressing the highest latency source buffers in the
batch. Workload performance is also significantly improved as a result
of this optimization.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 60 +++++++++++++++++++++-
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 1166077900522..2f25e02ca0aa3 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2377,6 +2377,35 @@ static int iaa_comp_acompress_batch(
 	return err;
 }
 
+/*
+ * Find the two largest source buffers in @slens for a decompress batch,
+ * and pass their indices back in @idx_max and @idx_next_max.
+ *
+ * Returns true if there is no second largest source buffer, only a max buffer.
+ */
+static __always_inline bool decomp_batch_get_max_slens_idx(
+	unsigned int slens[],
+	int nr_pages,
+	int *idx_max,
+	int *idx_next_max)
+{
+	int i, max_i = 0, next_max_i = 0;
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (slens[i] >= slens[max_i]) {
+			next_max_i = max_i;
+			max_i = i;
+		} else if ((next_max_i == max_i) || (slens[i] > slens[next_max_i])) {
+			next_max_i = i;
+		}
+	}
+
+	*idx_max = max_i;
+	*idx_next_max = next_max_i;
+
+	return (next_max_i == max_i);
+}
+
 /**
  * This API provides IAA decompress batching functionality for use by swap
  * modules.
@@ -2409,18 +2438,36 @@ static int iaa_comp_adecompress_batch(
 {
 	struct scatterlist inputs[IAA_CRYPTO_MAX_BATCH_SIZE];
 	struct scatterlist outputs[IAA_CRYPTO_MAX_BATCH_SIZE];
+	bool max_processed = false, next_max_processed = false;
 	bool decompressions_done = false;
-	int i, err = 0;
+	int i, max_i, next_max_i, err = 0;
 
 	BUG_ON(nr_reqs > IAA_CRYPTO_MAX_BATCH_SIZE);
 
 	iaa_set_req_poll(reqs, nr_reqs, true);
 
+	/*
+	 * Get the indices of the two largest decomp buffers in the batch.
+	 * Submit them first. This improves latency of the batch.
+	 */
+	next_max_processed = decomp_batch_get_max_slens_idx(slens, nr_reqs,
+							    &max_i, &next_max_i);
+
+	i = max_i;
+
 	/*
 	 * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
 	 * these decompress jobs in parallel.
 	 */
-	for (i = 0; i < nr_reqs; ++i) {
+	for (; i < nr_reqs; ++i) {
+		if ((i == max_i) && max_processed)
+			continue;
+		if ((i == next_max_i) && max_processed && next_max_processed)
+			continue;
+
+		if (max_processed && !next_max_processed)
+			i = next_max_i;
+
 		reqs[i]->src = &inputs[i];
 		reqs[i]->dst = &outputs[i];
 		sg_init_one(reqs[i]->src, srcs[i], slens[i]);
@@ -2441,6 +2488,15 @@ static int iaa_comp_adecompress_batch(
 			err = -EINVAL;
 		else
 			dlens[i] = reqs[i]->dlen;
+
+		if (i == max_i) {
+			max_processed = true;
+			i = -1;
+		}
+		if (i == next_max_i) {
+			next_max_processed = true;
+			i = -1;
+		}
 	}
 
 	/*
-- 
2.27.0


