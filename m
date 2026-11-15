Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B9B606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YMgs8l/c
Received: by kanga.kvack.org (Postfix)
	id CA34E6B05C6; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C4D6B05C4; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD6A6B05C8; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 749E96B05C4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6120E160806
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
X-FDA: 85438492818.19.60E2874
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id CFD8220004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YMgs8l/c";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVIDIsarcg4flQK51gffTpdo9vpbQ6R+h4bt6Nmq354=;
	b=SK3o06vapmECmnHj6YY9h4JCjVFRmPs0H3WHBmbmlCR64RFswOZW5uj4I8+jlCGUjuHV4W
	5vPjWyHHNRTj6MC4bvnXB2XFXv6tWBxe0w052Ndt/XFKP0TkPAl0xxobKlcbzZJkvde7nw
	XziWAG3OMv37EqLltdAGlRus+VUW3PM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774547;
	b=ye7erwq3XoyfC84gT1MbNOLZKS7bxOyS2zNybtyFx1qaXm7F7qrr6wrB59yOBdYXhkTsYB
	aETP9TBL2eD8NleM82KhKVvSl2U7+GeiVWkfrawHJVzWnttLqXywlj5HZYoYPri28OblT2
	LHNyug45KE0103xW6O4+4aWBPEuy01g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YMgs8l/c";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7766062417;
	Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0648C1F000C9;
	Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774547;
	bh=YVIDIsarcg4flQK51gffTpdo9vpbQ6R+h4bt6Nmq354=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMgs8l/c5DaJT6mpLqKbvdNxvRKT5bQQg9S/OprybcinK+IP9kRoQcNIQC9KjYZK5
	 eNwqiAgBa6jnEwFdvYl64YpOHfWl3oU9e6AmjziiKsJu5QvyZvaQeUb+yxOA5m+CxU
	 Mb0f8s0o2yyAttRJm+p6EZnW42QMgcLQOzjiJXJGEVCG5fqQG61kAVkpETUAG7SHop
	 MsrorhPJ9+DVtra9WzwvmWOyvJXzGpAFfAJvlFtY6XN+iCENUUjnkvS5QWDGfIeGo5
	 GrBHbP1Q6YkbgPJjryHPwMGNQxv/Uc6tPAaCYZwV7qebulLLwL6cmnxG3987z1znKr
	 o4XrVpX83z3pA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Sun, 15 Nov 2026 12:28:32 -0800
Message-ID: <20261115202849.99134-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CFD8220004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: juiouebbqqxofed3e7y1yiakoar3iqmw
X-Rspam-User: 
X-HE-Tag: 1794774547-686194
X-HE-Meta: U2FsdGVkX19eLciGa8LT59zGmMU2pKT4TYnaNyZcNw0Nvlqc+b006OCtJepzejG43ekZb6KXkgTor896mEEEarlingENQ/ce5c+aKG88wy1i5zCOizJvt49/11RBPVopXkZzuTyO4lgeSnxbaqF1vv1u3E6nWqyMtfdxsDT2xKtBvMPMKWlIxCxeVJL4Wh8PkZ4L2GxXfDOmIUC3XtcWQwakvaD5Yf4FPCSzwkLeDpwvJVDr9rqhfjy0e9YmtX49D+ERreYXYDzdy8OC0iov5jprJ9NXi67aacRtL3p2ZXjtadbWRcgvqAsXLi6Ppr7nUlMY6Mpx1k7x+lJIWwcSsI7ZnJqTCmkDdJStQa6sF3CWM2xdVh27WN9S5oODW3I5SjNWgqN6tjPmKBwKJuCeLX60va3S8N9PBcH3G/ZnMoofCGwjE15fNcKEAJ3f/vWfcnDtrJICd8rL7/4UqUT1m3WQGtUNvuMz2C11AjaYZHrgv155RA5qOtW6FB/uinQX6W7W8CCcv01zEZFqKrtLrnO8RoiJwe9BXlXSIUmGl1GNQQkV61ynjhCNN6WxLyFSM2Fj9YBk7LHLtZQPuwBL/Mrc3TIDCucU8p0zrEvaP3mxbXEbG/c2y0sE3zTVKNZ3CY7tpBzRDp41DuVeX565Rak+fQ0p7A60POmO3uhgOlM9SftrIv41Naqiv5EltOoaGliIpYkzWkO+bI9sk7kSzbE0XMEW+NB6TmU+FRlbQF499Fck8WoRXAOaKg5CB/VYo6pkbp5UHZjYjHLUE24pUO/flFn+GkQPek12E1NVmBgjXTV235JGKiSWF7i90YDgqje5N0jrA0zoSHRrF4kgCwZBw/Ol6VNSFjFLq2gdx5l06C3gm4ykQkCeXjezkvGEQIQ3a0YZvbf7BTV1m/2eRkg93G2MzYuG7VE2UEtlLSvqGUmpl1MOotWjIAZCJvu8Ob17QpyEWwA52QiND1x
 70JdoRs1
 0qotHI0wNjiXMCYh09uk4r0Uz1oSo0mhb0MuvgPORuebIrKkxYo8aGjeW8huda5XPVa9zWNQMe04KcDOPl3I4fp4+fHo0O5i0ZscVYQNcNFIOETLboLKdQZxGxF/j0AUqa11z4rWApJh+VSIbDgsRTvTw/Tg3Z4k94tfPqNRHjha5QL3S/bB5n8/a7i+SzKWZL2RppMbsMG23oKw76zv7Hsvv/3i8V5jiOFX9r0f9WELMhV9p3eQF8sgh6xBOcIVjgioYxFV9yBqStB77Nznjg3PBOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a support of DAMON_FILTER_TYPE_REPORT_MADE type probe filter to the
physical address space operation set.  Use the DAMON core API function,
damon_report_exist() for the core report search functionality.  Set the
time range as the last sampling interval.  Pass damon_ctx to the filter
matching function for getting the sampling interval.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5b773012a8764..04e95047f8cea 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -140,9 +140,10 @@ static void damon_pa_prep_probes(struct damon_ctx *ctx, bool set_samples)
 }
 
 static bool damon_pa_filter_match(struct damon_filter *filter,
-		struct folio *folio)
+		struct folio *folio, phys_addr_t pa, struct damon_ctx *ctx)
 {
 	bool matched = false;
+	struct damon_addr_range addr_range;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
@@ -157,19 +158,27 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		else
 			matched = damon_folio_young(folio) == false;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		addr_range.start = pa;
+		addr_range.end = pa + 1;
+		matched = damon_report_exist(filter->report_type, &addr_range,
+				jiffies -
+				usecs_to_jiffies(ctx->attrs.sample_interval));
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p,
+		phys_addr_t pa, struct damon_ctx *ctx)
 {
 	struct damon_filter *f;
 	bool pass = true;
 
 	damon_for_each_filter(f, p) {
-		if (damon_pa_filter_match(f, folio)) {
+		if (damon_pa_filter_match(f, folio, pa, ctx)) {
 			pass = f->allow;
 			break;
 		}
@@ -199,7 +208,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(folio, p))
+				if (damon_pa_filter_pass(folio, p, pa, ctx))
 					r->probe_hits[i]++;
 				i++;
 			}
-- 
2.47.3

