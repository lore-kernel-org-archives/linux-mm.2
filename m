Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE0FE63C86
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D12A6B00AD; Sat, 24 Jan 2026 22:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C41F6B00AE; Sat, 24 Jan 2026 22:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD73C6B00AF; Sat, 24 Jan 2026 22:36:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C31FF6B00AD
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62B37C1C54
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:06 +0000 (UTC)
X-FDA: 84369072732.16.7B11F5A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50B8E180007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gaJvssbL;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2FnbBvl1IajphGp5KRUu8cxcDJ31RcBWyAtqJQpN/g=;
	b=XsgQeoUMC8IEZoj2BzJpMX8EJl//CjmW/s1ROWo5wCiqfWDoUWgCX3oeJotFfMZdMwahUg
	QRj1silSg+XK5FBgMY2oz82I/JiA6r7iLKvjsnevz2Ar7xOnDxLdP9qcYBYTRK4xMFJ0eR
	MmM8hGdagWracQhcLYLJQuugprlw764=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gaJvssbL;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312164; a=rsa-sha256;
	cv=none;
	b=myspcV8IAC0vCow5EwFZY2ivUuT5HhGom/r6CVMukpkOt78aVyg3dlSM3HI54eJ4O6ica0
	+CBoyEvnQmGUAud6HI5tOpbuwYGhlcA/RZSv0rwZtLmH7MHnRwzR2hrJf0EMbrjBGVl46+
	Qydg5s2FdSUfeTfqSXxeFiM/40LtWq0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312164; x=1800848164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eQejQGKhQgKGnWoiX4nMcvTJdUUdiRQoPHylKVBWLaw=;
  b=gaJvssbLGyEXj+hFZwqI0I9Dr6O5XI0pkPTJsUdYyOUdevjA5iNhDnKW
   HENOycsaBwok/Y+uTp61sOtiRF5xXTYIV8DIT9heD+wkkgKagjPjNcuPb
   ElTawWnBOdwt70vPEsP5aK9IxDEJ7+VyO7U/ls1L1bzo4Rhqc2Yq5zJcp
   InnqGhbE7CzUFuJOba+SS+QshP1CMe/hPVQV7vLOxbQB4BzmjpUBVA/qa
   S91+0Aq0wVwUl0j9qAr5YGaUcA8dmQwNjOK3LYJVqPv3hzNXUMrF3sIJt
   dGKpv2gf94n2N4T0lbiA47i2gD0bzVZy7e3HFqKco5o3925AfeMq2rO/W
   Q==;
X-CSE-ConnectionGUID: K3SklbwcSbeJGgZER9aFAA==
X-CSE-MsgGUID: MxLtEMuTRXipRGUdA/FDpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887560"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887560"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:03 -0800
X-CSE-ConnectionGUID: Z85Pl1NcTsK2IN+kQ6nDfg==
X-CSE-MsgGUID: eHRhIEfTSDKJ2a+6EaNrNg==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:02 -0800
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
Subject: [PATCH v14 17/26] crypto: iaa - Submit the two largest source buffers first in batch decompress.
Date: Sat, 24 Jan 2026 19:35:28 -0800
Message-Id: <20260125033537.334628-18-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 50B8E180007
X-Rspamd-Server: rspam07
X-Stat-Signature: gnkymmznxzpt8s7e1gcakcjeno7oe3fy
X-HE-Tag: 1769312164-770875
X-HE-Meta: U2FsdGVkX19TapP4XUcs5BrowypNqynRR/rwqQEH8HQl0iFV5K2yeg7kavu7yOwVXTbTX1qCE1+1UqgWsHSaEgkySvZAl6CqN/h5DjQNgheUvO11A9bafWGyaDIJ6qCsBN8yJbMvt7J/hc76SUcsn47GP6DdkRr3DLIRsntbRkn6y469gNe+TdjM83d7M5wSvp7FunLZ4StcE0bEX8sPB89M266C1GjGkegqUFLR6VsuhHrOUnOIyTotB9LrXF0fhCaYSXuEWvVw9zkmlGkkhfdhGrAckaTiqYW0hyKRpcfbx/xwspEMe5ymX4TMC8O3IOLxrHA0o7uIaWOIty0Tg0YnJEKDxCVPTY3PssWWh8NTiHbaqxLk8Alx2na/dyYCnxJavQH3xDzPGaSCbhd9HamOO0W2MwXkXwbU0sIYDUx/gXDw7wEkUzUYxUtg7YifZQ/FkS8vexHcMKCD3hJX+LNfxYtKcfaBhT3eUjI8/CkIjDlJMwF3rt7UAi/S4AWNDAYDgKfSwuXAEGGiWjAwixp8gPmnEDI9CouDKh4RkhWjToMpSsdYDus1Bi6mVpLq83O2mt1rf/9yKaeEjlE9EoxR30xIyT4j9NqTyLN0RhBSNUQFTNnIp8wZJG/aYVrSj9egyZmsuZJCqZOHHGumzctwP50Cv032E3j3p53Xgtchyd+QfWk8IUF1jJ/o5rtgbg5YTJ8xAXFo4o/InzAGzlOVJtUuXeJskrWfZguPN7VQWrLHyBeMfU2HwF0ovK2GQV15/QoX0d6mXCzx8KSvqyUlAt9SadUga9GSnGIYt0hr2kVdB7B9Cm4DWPjuUSBXUHm53OENJf3oNQv3hV10n/GAR0vsNsqGrem9AP+BHvIfwhC0BVga+rr4rj/8H3PkN87sTCs4kqs9QgLZv7qoMEsGkOkaueCEBI+SzuSU+kmS/bIC2t3Fa6LiHfQsQjGfM2wqRsGbgQhzbHN2g/a
 F8gcj8wZ
 alvmwJfqchhYnQLmcvJ7sDsNuiUTIyxHGxtW0o0uTzxoraC47/oI966LShbLghXaJsXDHZaNhk+Kehj4nJVkDF0HnxBOdQrSKGdmLX6DdApU1woKsug+nBgVxa90Orjdz+eTxy3t2lbHmURtxWECnY39C3oie2wnufn/N73wULwZs3CU7h8OaOoU9UA==
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
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 49 ++++++++++++++++++++--
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index a447555f4eb9..8d83a1ea15d7 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2315,12 +2315,46 @@ static __always_inline int iaa_comp_submit_acompress_batch(
 	return ret;
 }
 
+/*
+ * Find the two largest source buffers in @reqs for a decompress batch,
+ * based on @reqs[i]->slen. Save their indices as the first two elements in
+ * @submit_order, and the rest of the indices from the batch order.
+ */
+static void get_decompress_batch_submit_order(
+	struct iaa_req *reqs[],
+	int nr_pages,
+	int submit_order[])
+{
+	int i, j = 0, max_i = 0, next_max_i = 0;
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
+	submit_order[j++] = max_i;
+
+	if (next_max_i != max_i)
+		submit_order[j++] = next_max_i;
+
+	for (i = 0; i < nr_pages; ++i) {
+		if ((i != max_i) && (i != next_max_i))
+			submit_order[j++] = i;
+	}
+}
+
 static __always_inline int iaa_comp_submit_adecompress_batch(
 	struct iaa_compression_ctx *ctx,
 	struct iaa_req *parent_req,
 	struct iaa_req **reqs,
 	int nr_reqs)
 {
+	int submit_order[IAA_CRYPTO_MAX_BATCH_SIZE];
 	struct scatterlist *sg;
 	int i, err, ret = 0;
 
@@ -2334,12 +2368,19 @@ static __always_inline int iaa_comp_submit_adecompress_batch(
 		reqs[i]->dlen = PAGE_SIZE;
 	}
 
+	/*
+	 * Construct the submit order by finding the indices of the two largest
+	 * compressed data buffers in the batch, so that they are submitted
+	 * first. This improves latency of the batch.
+	 */
+	get_decompress_batch_submit_order(reqs, nr_reqs, submit_order);
+
 	/*
 	 * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
 	 * these decompress jobs in parallel.
 	 */
 	for (i = 0; i < nr_reqs; ++i) {
-		err = iaa_comp_adecompress(ctx, reqs[i]);
+		err = iaa_comp_adecompress(ctx, reqs[submit_order[i]]);
 
 		/*
 		 * In case of idxd desc allocation/submission errors, the
@@ -2347,12 +2388,12 @@ static __always_inline int iaa_comp_submit_adecompress_batch(
 		 * @err to 0 or an error value.
 		 */
 		if (likely(err == -EINPROGRESS)) {
-			reqs[i]->dst->length = -EAGAIN;
+			reqs[submit_order[i]]->dst->length = -EAGAIN;
 		} else if (unlikely(err)) {
-			reqs[i]->dst->length = err;
+			reqs[submit_order[i]]->dst->length = err;
 			ret = -EINVAL;
 		} else {
-			reqs[i]->dst->length = reqs[i]->dlen;
+			reqs[submit_order[i]]->dst->length = reqs[submit_order[i]]->dlen;
 		}
 	}
 
-- 
2.27.0


