Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3997606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JgXUvtLp
Received: by kanga.kvack.org (Postfix)
	id B08586B05B2; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE05E6B05B5; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E60A6B05B6; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61BA66B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:06:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0221A0743
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:09 +0000 (UTC)
X-FDA: 85403054058.19.7AC351C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F8D5140003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:06:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JgXUvtLp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793930768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33k/P5SFUfytPej7H77BAGZq9RIshANAPOsnx9OCzY0=;
	b=Rz8BBTBZnDbIRiEfhRlSV9o0szF0GQUeQ75nItB45E7jxzUiP3CGztHesSCVbOc3WCqX6/
	uJopvVmPJbWKMiPfipGCT14MBbZaw52UzPyOe6y2DuTeeUszxxKFUe+r3XFyEAM6O2AGJ0
	cw9jpDzzruW4hm00QHv9LETiAIjDEUQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JgXUvtLp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793930768;
	b=cfyIOXZENxEed2BpHRnsY9An72QCShm4mV6Lf9O7JccHIVkQI15pfH8CF1z+Uylb4Bpkns
	EKGRiTy5g7A22lnqZp0amJBATpCF78oDoC2jFOKDIQzWp1qNqsYvbB5/cYmuUSaEMhCyhr
	gCYrlAgjeCKTDPHv31H4RsIGBzvwdXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 708FB60202;
	Fri,  6 Nov 2026 02:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C461F008A2;
	Fri,  6 Nov 2026 02:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793930767;
	bh=33k/P5SFUfytPej7H77BAGZq9RIshANAPOsnx9OCzY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgXUvtLpeaDJ5faRXg+ycd+p3SN66fZtkXH6+vfvMFQksU2hm4UKSTkuMEeQ6cu0o
	 uidSPb+aN8cPaNo0DnPlx/qTCWTd7Qreo3yCMTbaobgwlGf9k1cmd/U9sfcaC+bs1S
	 0YP3E13ViqO/t/4xUNN1GXVd/RWBReJPAZDu1kK02sO/4Q27GCqgcnmiwWBTjkflbC
	 VFLv0TJ0SYKCQ80DUZ47CUZ2zRUFydTuCggjs0A3PI/gSYYnXBk5NWef28+uSUwm31
	 zCt+UPkGL8dSCgI6ntFCvb9mHMVbRDuZFW/wEJzZTZNAoVOT9l6AX71jXc4Y00zsT/
	 Dtqk7G5lDYm1Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH 1/4] mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
Date: Thu,  5 Nov 2026 18:05:55 -0800
Message-ID: <20261106020559.98352-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106020559.98352-1-sj@kernel.org>
References: <20261106020559.98352-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F8D5140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bxywhzhjoi9zsa6rurkjfrbm1iko4m7i
X-HE-Tag: 1793930768-643345
X-HE-Meta: U2FsdGVkX19PYewzlVb6Xx0hoO4caEyIXieXNergSLwT9MT+EA+dnKVysmXWutC/pCTIXKmRsLpi49h5gEJChbxR2u682z5pSwx8EXggAJDiTlACuZGbsA2yuYbSS/MRbOuYwunRWaomJ5FvVSzPw/QT109M9kkRP4gn9okdNTrHsrGKvtViT/4XGN3Vl4jOJQAwWFKz0A+w4TujzV02IiSZp5EMHGt1hqZaqPBW6WEtR/TFOk6jNhISAJ2gJyZqiwzG5gCAgKZpQ+ipelVcJFhrhXkfJ0GH4Yf6vfgqbzmY5aaUFc1OXDJu9a+htE8dh7xDM4cWMIksb/vER92F+AciFWBerWBuEUmkB/CBrU6zRHMFAyDNQYcWZGR0GeUdF43dWcMVM68+NpHPYLj+p3yJCkD6pbYYp+8EJ9FkhZR3z0GI3mFOCErR8hPu9TAD5bzsQOQ+6JMCrF4KXs/nrrM0lZPuAzwddnM+fY95RLU8yW+CZFksRcV8Sf4SI6rVDRA97vpLxdpxNl7ogYE+FutSyST+j4OAFIEWNyRzhetZGLkqZq385kJZq/R1zG9eyA1xKXAbSgFFt6dyrRPQp7EMbkhVV5QFi/0bIOYjOVqnROTa3d5r1GLpjP+X/TODT8sdyk5LtZHRAV5u2LsUebglk6aie36pfUQWR3HTfJNVIvW15+Z7LXgQsf048H12cGA7c9QzOljWwNU3lXyNqwleRTsJr5ZewFzmFoZjtmRwqWh8w8UxXbYyaoXWE0a18XxV0n6F0wikhjvY1kSlYpSXoJxwYokxk4qRTAW86pi2ubTYGrvLgE04Xzma1s93pbx83i3UcWzq7ustsYWHB7YvyE4GsD0BWnCt0yx4DmWrj/tp4EoVpIHDVoVJyC8EZ1altJqlc8bPrHHVt4Z4cT0bzExaA7g0bXCupEjCE7wYdb8mPwpM3ZLjS+sdIxoX17vFHEHZ6Pegx5YYJbP
 O5zAJbe2
 pxIzddQFu6kUMgWBimIxmbxYOMdzh3WhKHQXOgxXjGgh9575IMfSv0R3kDCv1h0OXd36SDk86pZ/xXCqz1f2ZkXdfOiSeOpiVHJit2wpI8YBQvDGA+vqYDdZSmh0eBE/AxEE/BnVYb2FDOc2f0tPvyQHISTX6gDNp4CBnXkiIG3XEnHJaT1nanvWs4Ce64o4M2VlCrskl33xfr4eVmYDHvZPR3TDPQLhNfLd0QUX+tW80DUUHKB+oanEkmop7WiTnZ1OLBp00nCtFmsV51bWLy+V/pgLIkr81fv0AhySrFjauQ78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There is no way to specify DAMOS target regions with a deterministic
time based age range.  Extend DAMOS core filter to specify target
regions with age in milliseconds.  Introduce new damos_filter_type,
DAMOS_FILTER_TYPE_AGE_MS in DAMON API, and implement support of the type
in the core layer.

Convert the age in aggregation intervals to milliseconds and use it when
the filter is evaluated.  Reuse damos_filter->range_{min,max} to save
the age range.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 16 ++++++++++------
 mm/damon/core.c       | 10 +++++++++-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 380f9cf6ddd82..1302ffb6f0bcb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -394,13 +394,16 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
+ * @DAMOS_FILTER_TYPE_AGE_MS:	Region age range in milliseconds.
  *
- * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
- * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
- * damon_operations as a part of scheme action trying, and therefore accounted
- * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET
- * and &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM filters are handled by the core layer
- * before trying of the action, and therefore not accounted as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET,
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM and &DAMOS_FILTER_TYPE_AGE_MS are handled
+ * by the underlying &struct damon_operations as a part of scheme action
+ * trying, and therefore accounted as 'tried'.  In contrast,
+ * &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET,
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM and &DAMOS_FILTER_TYPE_AGE_MS filters are
+ * handled by the core layer before trying of the action, and therefore not
+ * accounted as 'tried'.
  *
  * Support for the operations-handled filters depends on the running
  * &struct damon_operations.
@@ -415,6 +418,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+	DAMOS_FILTER_TYPE_AGE_MS,
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d36823f4d0928..0a056949604f9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -659,6 +659,7 @@ bool damos_filter_for_ops(enum damos_filter_type type)
 	case DAMOS_FILTER_TYPE_ADDR:
 	case DAMOS_FILTER_TYPE_TARGET:
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+	case DAMOS_FILTER_TYPE_AGE_MS:
 		return false;
 	default:
 		break;
@@ -1336,6 +1337,7 @@ static int damos_commit_filter_arg(
 		dst->sz_range = src->sz_range;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+	case DAMOS_FILTER_TYPE_AGE_MS:
 		if (src->range_max < src->range_min)
 			return -EINVAL;
 		dst->range_min = src->range_min;
@@ -2552,7 +2554,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
-	unsigned long start, end, wsum;
+	unsigned long start, end, wsum, age_ms;
 
 	*err = 0;
 	switch (filter->type) {
@@ -2594,6 +2596,12 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		matched = filter->range_min <= wsum &&
 			wsum <= filter->range_max;
 		break;
+	case DAMOS_FILTER_TYPE_AGE_MS:
+		age_ms = div_u64((u64)r->age * ctx->attrs.aggr_interval,
+				USEC_PER_MSEC);
+		matched = filter->range_min <= age_ms &&
+			age_ms <= filter->range_max;
+		break;
 	default:
 		return false;
 	}
-- 
2.47.3

