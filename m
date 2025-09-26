Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C1BCAC5B5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BDDF8E0018; Thu, 25 Sep 2025 23:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46EDA8E0019; Thu, 25 Sep 2025 23:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 298BC8E0018; Thu, 25 Sep 2025 23:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1455C8E0013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDA1F1A054C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:21 +0000 (UTC)
X-FDA: 83929986042.05.B01A6DD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id DFD94A0007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c1llFKE0;
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZV6gmFDjAgsmH8wXBQd2uT3uPOIgvz/RFVUDESjZ90=;
	b=CXg5Xch1jMQj1Z6Uyw+Oqd5evRKJl1gF/cY1FNEbUA+sWLI5rCRmvuufpuD13LgwwX7ITv
	Wq7NwIYudc47nRWzslO7JqYnSUlq9KnL3GZ2tbtSfTThm7QoZLRoIfa2krCRV51Ye+MyWq
	khk693Gg90ksq2pwrarI7ehcMktgWZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857720; a=rsa-sha256;
	cv=none;
	b=1Us0vUqoSlaZ2Q0rfozBsiwbUTQiZDR3ONN8SFyEYwo/eqvuGdkEJzBEQ4nf0yo9DeGSmL
	C6Edf6Rc8uevvyyFxJenqgA1abjUIKZVeG+jhBJ5F18ZQ6K7kRBRFRHfpHVMUMa5BeSsib
	gxnl5q2mQE7ixUDw/vNgDLcZp1S7nO0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c1llFKE0;
	spf=pass (imf15.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857720; x=1790393720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RdtG4oYnaUiZ1ttzY4avkjog/6/16IXF7YMAS9x4VlM=;
  b=c1llFKE0+q0gOllMFDYb+ww/83tcKiPNfgWOdML3YV4hgBW+y6odCXl1
   NPsTrJRVJlSEXdn/zFsDJVN1u3oztRXB5YjFVDXEBKsS/jHvC6Kpz4jNM
   kBzZQ4cOIZKsDeOiWeFyFyS22z8xuMoYRHMAhLmNRy8IU7fX97yjxU31I
   CYkvN3eN/h6h7Fi10qHOJo5u84fntdbqNecoYsJ3nXtJhAxFcTgAGwDPP
   +9kShga1sILa99aYonSoug3ws5Awvx0rSsJE13YAxNAnFc496zTCze1hd
   SyRSmBdwF9SZxLERh52AK1X46MBwakFKvTP0Md1lguWQY9LA8sc3GwyJU
   g==;
X-CSE-ConnectionGUID: fWvPGNz5RZ+7S827dP58uA==
X-CSE-MsgGUID: I3vJ72HGRXyl8kdtOY3r4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819627"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819627"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:07 -0700
X-CSE-ConnectionGUID: cAKDv1LcRUqGg49d9GbJ8g==
X-CSE-MsgGUID: YeuClNc0QHeBobxThiltsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636602"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:06 -0700
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
Subject: [PATCH v12 17/23] crypto: iaa - Submit the two largest source buffers first in decompress batching.
Date: Thu, 25 Sep 2025 20:34:56 -0700
Message-Id: <20250926033502.7486-18-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yatbijhj6pnxpskmxwmsyrri74gxat8a
X-Rspamd-Queue-Id: DFD94A0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758857719-2629
X-HE-Meta: U2FsdGVkX18gI9o5wGJuYAqd83DYa1OuY4kZx6y+nB9IIZIMDGVWLwzr3VLjNx+qQBfUBCvKqwNi8/p1KWhe8obWDDgEQql4JVTakCyOz1yU1XPLdYmXM7GA60Z3TEGS6b69ZH7MHOSnClLAB4gWf1MdGY9gt0641aIsW2oN2HKNZcdOC+YpcellEfjv1WfgPSzWdnMaJdhLBlm8iQUrKX/W6tr56Xa9a+eahRKm6ThWuWhcODJUaPi0Z1gDiKSbWYfTYf2rTceISy8D9kMQA0v6e9tq+P+C9+BZmTjiYKGl+iYSJ740WfNQ3Ndak4/8qfoR3n1cdvNpLeiBBX4ZHKD6E2Zz7QlxqWQFcqOwGQYS7d/B9B7H6WRaiqwHeoizLP3pxnIzZPu+7eOZs6Tja2MHLjfuppanXAbrbh7wau4FFzJD71KjJVYRgJMrG7BV+dppNl0qOSNu/TwImoB5KLQ7cf2lNOqoxIUDADI0tHcDR3xlF+srAp1M448wpHZYZT9qH+7YIiUI3ZjwLVYYr0OD4/mvtJ0LIXa9mWgECvxTyKf9Scaldam6B20Um3d0p59z515ulQhD5o7uKpLnVXF4w6wiARSTBpDU3YaPBbM8TNiFTaZpz14LVbDe0wl3zAc9IhIvZ4zxTUUiSlNEdAIghBFR5xQ3lMccRBJ9mGGT/3V/mnOIyUqzNazMScSX1vkep5/4B6YUlfeGp5kSn0li4qLnXKbsQqMxasBRnUcD0EpwXhyj9dbMv6dB7/jpi+WekqAFPOAe/AoH5M5U1bYxn/r03mIi8x6Ut+Z4rbZaZcQXIhZTaSVOKuqI0Wlh6Hj7jXJQTV9L7EeKb1hlxmH3XgChIMAbgAqgBkshkF1GGMrwdNX+X89Jap6IVDxg
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
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 61 +++++++++++++++++++++-
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 5b933c138e50..0669ae155e90 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2379,6 +2379,36 @@ static int iaa_comp_acompress_batch(
 	return err;
 }
 
+/*
+ * Find the two largest source buffers in @slens for a decompress batch,
+ * and pass their indices back in @idx_max and @idx_next_max.
+ *
+ * Returns true if there is no second largest source buffer, only a max buffer.
+ */
+static bool decomp_batch_get_max_slens_idx(
+	struct iaa_req *reqs[],
+	int nr_pages,
+	int *idx_max,
+	int *idx_next_max)
+{
+	int i, max_i = 0, next_max_i = 0;
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (reqs[i]->slen >= reqs[max_i]->slen) {
+			next_max_i = max_i;
+			max_i = i;
+		} else if ((next_max_i == max_i) ||
+			   (reqs[i]->slen > reqs[next_max_i]->slen)) {
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
@@ -2401,12 +2431,13 @@ static int iaa_comp_adecompress_batch(
 	unsigned int unit_size)
 {
 	struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
+	bool max_processed = false, next_max_processed = false;
 	int nr_reqs = parent_req->dlen / unit_size;
 	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
+	int i = 0, max_i, next_max_i, err = 0;
 	bool decompressions_done = false;
 	struct scatterlist *sg;
 	struct iaa_req **reqs;
-	int i, err = 0;
 
 	mutex_lock(&cpu_ctx->mutex);
 
@@ -2425,11 +2456,28 @@ static int iaa_comp_adecompress_batch(
 
 	iaa_set_req_poll(reqs, nr_reqs, true);
 
+	/*
+	 * Get the indices of the two largest decomp buffers in the batch.
+	 * Submit them first. This improves latency of the batch.
+	 */
+	next_max_processed = decomp_batch_get_max_slens_idx(reqs, nr_reqs,
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
 		errors[i] = iaa_comp_adecompress(ctx, reqs[i]);
 
 		/*
@@ -2444,6 +2492,15 @@ static int iaa_comp_adecompress_batch(
 		} else {
 			*parent_req->dlens[i] = reqs[i]->dlen;
 		}
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


