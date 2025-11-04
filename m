Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A510CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5B98E0115; Tue,  4 Nov 2025 04:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0928E0116; Tue,  4 Nov 2025 04:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD25B8E0115; Tue,  4 Nov 2025 04:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2CA18E0115
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78A3513AEA0
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:51 +0000 (UTC)
X-FDA: 84072359742.26.9E77582
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5E89440003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AF7rN6qV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247569; a=rsa-sha256;
	cv=none;
	b=E6ydkDWiNcUwDBLlrB4KHsECqjfsx6P2rKttRngKnTY20eaPCMFCGi8CKCWRUBtc7TmBZy
	9/2sA4piZLcyuTgqV+e/gyUuRw5sb2wnZngwg7qjoWmBFj+sZnUz+N/lXcdnh3ektxQBqG
	0ubMIKNtq5OGvzzoFJxahmzMEmd+CCk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AF7rN6qV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCzupiKPegpzQo33ps+ZjCVuZMPIrXk8Y2RfirEStT8=;
	b=HBoDX++sph4ST2pOBVp6p5xccLFrXmKpf/iSLoWpqwqwQcZvvJXyqWQPWdGu8lELq8B/CW
	1sZzVNkHj4d9C6pn7zrzBGzb+v+RaD3ZD1+Zx+SunyBkmkyWc0aPYXJ67dNvJTvwaTdnol
	6jveoLBtPcn+TAxb2Qhtdbfuzg0OPFE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247569; x=1793783569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y6UTZGxTCoeHJhxCck167UlocEl2a1qtxUU6EBdN9+Y=;
  b=AF7rN6qVFYLcepyHUdrWJkZaruP4mxozI8dPSrsWnpcyFwzj1i1CfRO1
   9ewMwHZXe63tGi/Ps30nwVdIWG/jFmmKiqbl5haNnYuOm7+6HvtmPwUrl
   pq9s6ubnP/9QjYblTYjNfXKpH6mLZGZCJ20vGyO9x+u97i8K6lqtueMFT
   itijnyrJ5Vhp4mNo0mAiqrJPcfzPv2D0GdZJnWPaIobRhataKLjqJ04sX
   u0TXavNv61/Q9XVDGj2cFWi22qIAwQ0m/m+VYlDAJJ1jmeJ5AU+A6wYOl
   wfxf2MnWRrsRoEoN8VbeFYtWrjnIt24gdv4iADkL4ykUedE2APgPYRNYi
   Q==;
X-CSE-ConnectionGUID: jv8pkjJHSbWfrbuSuKl6Kw==
X-CSE-MsgGUID: y6BM+55zTM6b2qqN8PMapQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265196"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265196"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:39 -0800
X-CSE-ConnectionGUID: dtyy11KhTGyeNDo4ENzvdg==
X-CSE-MsgGUID: TRwWE9bGQaKWqmErNh7qyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795823"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:39 -0800
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
Subject: [PATCH v13 16/22] crypto: iaa - Submit the two largest source buffers first in decompress batching.
Date: Tue,  4 Nov 2025 01:12:29 -0800
Message-Id: <20251104091235.8793-17-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E89440003
X-Stat-Signature: 74g1h4e6ieypyz6ia7i7g6p7ubk53qyz
X-HE-Tag: 1762247569-447967
X-HE-Meta: U2FsdGVkX18+NKgG/GlUewfLasBEAbnM4bJUIwNGNkTGT3IBk9+yN4QgXKWU9k/pMt5Jeywsa/iJS0wiSSWd9qWnJZquNsC0aH1BW7PsHFfs01D5DxxGsCGfilbOr9ob5umJgfcFunGR0VagzrH47uvXRqkDDUGTmsIm3spSaJz41m/JYQESFmAzNYXW1hLIQu7f69q0NZg45bFwdbUw6xTr4WqTzOSfeWVQpQdQtI8TecryevbXLjn8qlegUvRLysb2NcYOYuf4uWXcs04YUPWDTVKjLU2+lusU3uq5t7D18UNmCWg4fb2igeAgp84ivYuswVWJQlvCuzBW9pRfychICMx3Qizk5G5yCb7zTFImrLp8iz0Sv8eUf+9b1CQ7St6PQW4T2efZS82KhoRAIxgfEqSN8439iPYV3jfsYotUlC03xky6E0/icRQlVG4fe3XTp4RsPIroF5v1eSAmEJFKCXGJVjHkxGKF8T2UqL0Gx5Vta+IxKe0LEqrFr7j5Su4yM5YHYrMJRZk380UUhm7VNxaEBlO4wesAafU6NMdvrecg+oIEIS0aalnC+VhAEr7lJQQzVsJN39Z+eGta4Sz2867y7mIsgH0Lqsk5X9LJlHbFeaGENQw273i77JzOh/fB4tsgE+4D+HDAKilhwqpMEFQQ5MFyXyfrMxf9N6KC8xWVrrNkKktqOwaEg1nasfY7BX/Pf2O+u9YbgKBQO8E1JveGDiidcgmwK9p2qEVFtptRyyT7Jarb9XYIeVKgpbp6PNfBxX6Zsd0tNpCklhNU0siHLLjcmDuE9HHI+0xLJytrPNBDe3nwVbCyIWuEHRljfeRShaPr+MTpG5KZDMAaG5YCmySiuZrn7SRPvrDV3mKdKjVMFVim2U0SbzHto7CDvZx+RsbI+Sl+el33lxUbr1nbet+1xwDdsxBIttiVmPGa0GBvdco/Rjk27F9l6EMKrl76hxTeNSE0zY3
 FPb9+tDo
 xcF/xXRJjNoDcz68cmzD0gyII9/giInraeXinZJ2eXitjvdbiv6+bwIhsmE7Tzm9DkB6vuQImdAAbNh1BqBwaTHgQshsywiWb6ZFYlIJi6d0YFlNDmEHU4UF2VP99MKLSdciJb4DsbEA9S+6ihWvHjcHKokYJA1asXy6GpbDdETjMrect2J2/cwtJMg==
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
index 349fea0af454..cc0d82154ff6 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2390,6 +2390,36 @@ static int iaa_comp_acompress_batch(
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
@@ -2412,13 +2442,14 @@ static int iaa_comp_adecompress_batch(
 	unsigned int unit_size)
 {
 	struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
+	bool max_processed = false, next_max_processed = false;
 	int nr_reqs = parent_req->dlen / unit_size;
 	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
 	int *dlens[IAA_CRYPTO_MAX_BATCH_SIZE];
+	int i = 0, max_i, next_max_i, err = 0;
 	bool decompressions_done = false;
 	struct scatterlist *sg;
 	struct iaa_req **reqs;
-	int i, err = 0;
 
 	mutex_lock(&cpu_ctx->mutex);
 
@@ -2437,11 +2468,28 @@ static int iaa_comp_adecompress_batch(
 
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
@@ -2456,6 +2504,15 @@ static int iaa_comp_adecompress_batch(
 		} else {
 			*dlens[i] = reqs[i]->dlen;
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


