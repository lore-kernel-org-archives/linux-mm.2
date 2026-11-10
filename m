Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE190606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 00:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ecr7oeSg
Received: by kanga.kvack.org (Postfix)
	id A186D6B00EF; Mon,  9 Nov 2026 19:48:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2326B05B0; Mon,  9 Nov 2026 19:48:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891546B05B1; Mon,  9 Nov 2026 19:48:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9EE6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:48:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5B99407CC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:48:26 +0000 (UTC)
X-FDA: 85417373412.02.67DA743
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 39F2120006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:48:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ecr7oeSg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794271705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3Xo6pRfKtJUGUHdPK++9LnJKDE8puj/5ez9TES0+7xw=;
	b=2wCPU5UXbI/ZwSHYaIhwtohE3Hpa0uTtGLMGQRqWuCCEs35qDjBk92xsScP+pMXLA8y1Jo
	jL0iMjQywhx1blVBzZsFh9/63pt4RIuLVUHtatK+8UWe3PNF89zAEj8OBN9mtXfHMUO8Vf
	BloQvWBom5hhWfUDdIjrlYz720UhNdk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ecr7oeSg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794271705;
	b=BAWrwvg6SH/EDCz8WvlbQbCTr288IYpsBl548ykgj4V1cpoRnjVkqVQ8bpHVtXISUtfKnt
	LZJEyrwhwycRk0vvr0+uEm+tzjMEB7ZxQaMF0I6dIuD2T4bymy9aHhBkxNJso9ytgIRcKv
	24po7GcWEAZOawls257+21yoISDRlRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 480474249A;
	Tue, 10 Nov 2026 00:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53451F008A1;
	Tue, 10 Nov 2026 00:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271704;
	bh=3Xo6pRfKtJUGUHdPK++9LnJKDE8puj/5ez9TES0+7xw=;
	h=From:To:Cc:Subject:Date;
	b=Ecr7oeSgvsJKzDeMDBpc7QEOPzDe6UTbRKUtx0+XnFGQ4sMMlyG5Nopq9bwUm46VP
	 cLnLW9iB5UycYapqZA0RFitW0YvfVm4VzBfKhoU/MWtwFHVTRP66MBiD5Bh8cl6T+R
	 vugK3lQjpmOcfTxaiqonolaKG219lLKHAfC/GeZSsOHEl7xG1j23C4G4KP9TwI1dF2
	 b7pX8nfG4A3dFRdyWW0ftaayxauJ94zTFXlHxndzj6mYjMb8BlNyKL5yOcB3MB1B2P
	 rFIzvAGNm0UVDoUiQ5UX6lKvxtRECMn6HWJk6eXH+NUUFjuuFRjGuFwuHZRo4HJOWa
	 vLH5y4vEcl+Pw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wang Guangke <gkwang@linx-info.com>,
	stable@vger.kernel.org,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-hotfixes-unstable v3] mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
Date: Mon,  9 Nov 2026 16:48:14 -0800
Message-ID: <20261110004816.100066-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 39F2120006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ny9dszxikbi5n93cjddjo5nyk9f7n61b
X-HE-Tag: 1794271705-7043
X-HE-Meta: U2FsdGVkX19tDFHYr7GfvILHAP7bly08YrXZC4xQ86v7X2aKU6FnPzhDmQ/URn1oySkLtmMQbGrVegodYuZH/8Tyf9N331XBek5J7bAGNdmrLZe0QS52fkZRii4mLPLPm+MNaaIBMdvjrrMx2Up+djn0uqyarwPKriHjAb3qjeuzIZb/KXaNs2yVGOQ1fBHm1QA0BzoX8RF+OuUnphWQmFMtq+N8qXoPL59s3qjGDcg9Cnm7f6P2LESQefY1fmSj8jQW8o4Ou2rHtAFpUyb6WDcqvnUi14M+2R165PAMfmIxDGeqeox5wPwPFBJtq8fhVrfXwyd1a5N4Dk0UJYKvXtOaMiV9UeMPfj6jsl7n2dTd8Vux8pJ1Bf3prvpPl/ZtlxbsmRVwo0Bs+RRYCMletfE69QQYMmxgEs2iDEA4IauXkpDw0SL2sok2Shjn88yx4RszeoEnFsf3DT1tZGfO4x/g6idKfd82c8F2QHAqUmc/Ylv0q4fe3Ft3pJt7bUsoXEsIq7GcRedsDci2SauxGebqGdOLEpihAALbfp0ZSrZBgPp/HGymYinPrJujrhd1fjCrXIuYdX4QI76u8rbNv+wkzWLRRhPQ/ED85OHwkXUdA9Km0lhDA1w3QnO6BJSsJ3Ku9WP+oXNxoHlYphF+yaJJPbvU1/inVCg0uDGkoZ30LR6tRtq51MP6jm92f6J2bnoeg5U26AwUYIzAxstuWnBNun1WXfidl457QW8Ug4s9Hk3pSd/SHMacebzg5IwUT83N85jFaCRQWLT2NQuW4ODg4LF9FPChJlcTYG10vUpdvpORsUuYPeJgYf3FIWEigpXlDIb+nOJcjRJt+JIMTI7/Vow+kN3DblTaSNPpO4YTicnl70gMeZRMWy0KNKHKH2/KK1YklnRMrREQDmA5+BkdJIrlEs0vXXXGH4E0RtrgMvS4XlEMmc7U+9Q9LT0SYozoKDpPIfIsLMS2NJC
 CQ++/YlV
 d+XsMjI3YEvTeQkvN3qQWLiPkGhujkRqFI4QYs3u+grrGYvOIvFNp0+K2ttwnXM31ohItUAx/d1XwbaDIFwX4B0hejbyi1W0Bcl/mSmeFbW39NzFHQ8JqGDgi1J0Cq9INY1OwTgNAK7aD7G5Xfliz3m39fW9tzp3Co+c/8LKmTfpaVFM7eSQcMnE+BskpGjX1Hg756rwevVglPlCOl8WPWkURzFBUeedZrDN5JUcenNPXtS7lzhGmGYTNHXl6FluILKNZoL3Al+zTqL18RvrgXtXsZzV51iiMWtTNrSro70eBe0MxC+IZvYC/eGDXag0vBv5YS2uBhEFlKjKiKA4AXxTUSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wang Guangke <gkwang@linx-info.com>

estimated_memory_bandwidth is calculated by access_bytes *
USEC_PER_MSEC * MSEC_PER_SEC (= USEC_PER_SEC) / aggr_interval,
and users read it via
/sys/module/damon_stat/parameters/estimated_memory_bandwidth.

On 32-bit systems, access_bytes * USEC_PER_SEC overflows unsigned
long once access_bytes exceeds about 4294 (U32_MAX / USEC_PER_SEC),
so users get a wrong value.

Fix it by doing the calculation in 64-bit and splitting the division
into quotient and remainder.

The issue was reproduced on a 32-bit system (qemu-system-i386): the
parameter estimated_memory_bandwidth reported 362 instead of the
expected 1926150; with the fix, the value matches the expectation.

Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
Cc: <stable@vger.kernel.org>
Signed-off-by: Wang Guangke <gkwang@linx-info.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20261103034034.7978-1-gkwang@linx-info.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.
Changes from v1:
- v1: https://lore.kernel.org/all/20261101180001.167198-1-gkwang@linx-info.com
- Clarify the issue and its impact on users.
- Add Cc: stable@.
- Rename variable bytes_per_interval to bytes_per_us.
- Use USEC_PER_SEC instead of 'USEC_PER_MSEC * MSEC_PER_SEC'.

 mm/damon/stat.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index b05b68f73e10d..e44f5bf3645cc 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -32,8 +32,8 @@ static bool enabled __read_mostly = IS_ENABLED(
 module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
-static unsigned long estimated_memory_bandwidth __read_mostly;
-module_param(estimated_memory_bandwidth, ulong, 0400);
+static u64 estimated_memory_bandwidth __read_mostly;
+module_param(estimated_memory_bandwidth, ullong, 0400);
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
@@ -55,15 +55,18 @@ static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long access_bytes = 0;
+	u64 access_bytes = 0;
+	u64 remainder, bytes_per_us;
 
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t)
-			access_bytes += (r->ar.end - r->ar.start) *
+			access_bytes += (u64)(r->ar.end - r->ar.start) *
 				r->nr_accesses;
 	}
-	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
-		MSEC_PER_SEC / c->attrs.aggr_interval;
+	bytes_per_us = div64_u64_rem(access_bytes,
+			c->attrs.aggr_interval, &remainder);
+	estimated_memory_bandwidth = bytes_per_us * USEC_PER_SEC +
+		div64_u64(remainder * USEC_PER_SEC, c->attrs.aggr_interval);
 }
 
 static int damon_stat_idletime(const struct damon_region *r)

base-commit: 09f140d2cb078edfcd08a40a23ead0bdceea30a4
-- 
2.47.3

