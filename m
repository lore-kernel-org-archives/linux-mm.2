Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75063FD006E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207346B00A6; Sun,  1 Mar 2026 12:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A086B00A7; Sun,  1 Mar 2026 12:43:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A93A6B00A8; Sun,  1 Mar 2026 12:43:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4FA76B00A6
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91B1013B917
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:36 +0000 (UTC)
X-FDA: 84498216432.30.876246C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E424E8000F
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7kM60CE;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEoOZh4aL7JRuh6wAuw06VMxdtW54HJvRP0C0PttKWo=;
	b=3TC1bzvcVxKqNAbzAGohipil/IW3NRg8UkAmXA41Huv0Sn0VYq0YBLfiqyGU5Lf6AQLZgx
	22hrp7BQp5FhzLS+UjPH30lQ/BFdSboxP5Q4I5UIIaxAmKHggKgIlema4yUha7bWIQA8H+
	UwxTFMPTaq9TIl+GN81JpS3GYdN2ll0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387015; a=rsa-sha256;
	cv=none;
	b=5INQDk0eyCslZzPnJztgaK+rOXUmXXtz2jNwexoxxBZHHRKVSogKJfVWph/z4faVQtIgQ5
	SW0O2NRqL+4+m9NaNtnCkY81hmFTO6+NyVLjQArOHYY5FY4Nn7EIi5pTNn8/aWM1MP0ils
	fTWCjqinyhmCTqsA4WGqjUu2QQS2ubE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7kM60CE;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3578D4442E;
	Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0281DC2BC86;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387013;
	bh=7QL/RYpMYPTB1eC/p0ZRS1BwtD3YKWYXznWIGxGADnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7kM60CEmDaEzNJTLTipUMV58oimjOz6LLzz56XC7mxaW9NAFTZrX1ECyv31z3LXx
	 47QuYTMJoYczO1ndrolzeKIUlFl5c7SpKgDLHOpUdGVDfNudPok6f6Pll/t/j5V5Vl
	 Vhj50I5tC1d4Ph1ByHi5QzSbBI4I67LFXQ5/yTCee35voA5bJIynLeJ091CjVU8DZ4
	 +pQEWpJ4115VEYgzKJiSf9O1oFwdMSyIXtoPLpYWIiYawScj8l0SOJaZbvVmxJWQKL
	 4rMRRDxAzOtSWOmJDHNvSdLVkMtMRRdPoQhh/PMuJzNED+Q9286s2vTCNVnWvOAfrO
	 NGGRBLLU8Ju/w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 08/10] mm/damon/core: add damon_reset_aggregated() debug_sanity check
Date: Sun,  1 Mar 2026 09:43:23 -0800
Message-ID: <20260301174327.76849-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E424E8000F
X-Stat-Signature: 615pe8n4syj4oq7w154faaxjrmz4twtc
X-HE-Tag: 1772387014-44887
X-HE-Meta: U2FsdGVkX190Yn2DhOBZbq03nfuuStlOMaPYrgTaSIwctBvz/S7dNgMDkAEuA90fB50u/EPSvcF90GneWSlcKc3bFfrVxWD9pLiKA5nKmSAydJTRO/R+llAygJrDCOYcRqrNsZ0eLDb3+4o3j/FtwAokg2SFIJ+rAeF43dGM0Cf0rJoh8+4d5Y3V033RSvSXCwasFb/8AsO/czWvxISFBMEi0LSGaWujmPEeMCjnVZkqvNgGLcav6pugAx30yi9n+tRYbpr3UKpov+i2MXhMAQHw0zRtAHEc22w4PspbCRc+xrHuaV6DTUnFHGDTuKZ880LdP7T95ZmjgScf8zWWrOwTWhizk3aeWNGV+DFX/N57U0GtnljoV/PmtfhuATxpXsRksKJXvFLmT8dVnd1q7vQKGx/BeuJb+wMUMyEezWpietn08DJQQ8kgTQUg1Ej8/wuLLPdE4GNMVIE+eLHYKVE3YuarOQIt+CzDc5fyadJua2mNNEpS2bnc1OQ+hkhaELhEqiMLUTm67NNTtJ0C7ercNyenD1DWejAUibKoaIu78wulg3lHVX4Bc8mRcY67ucGHWQXlc7XVIv8q+hz2EE+fIstWkbvt5wCiT5EI80IEMXl82h6/sAbFACrZxKtsx5Nc/Dzb8Tcl48GXc2zFuipQaUTwKYSYMovAg0cIuXvlERNM/1xonWKXO0v2ppd/fWq6eqd37a0Tp0Qr1LRgijGqkyj6PlRESh8tQkzP7d1XYPQ/N+XnJDbDKBRwm2zYTse7YTps8cwRQPK88NDTRt9iSraQJeJO2udw/WTthoTEXt2dVd4UPUQ9jADLFxqjadIUUoS3vetg3XmKwmALs/lASWOm5exie7nchgQoQOP5RNMfCDiid0C6v9T2rirRaC+C01D9bsWC/jiVReygchUatKQnQBVl99/fAHENtoM9YitptmId9HsQVECLgsQAZ0105OmvuZzDVSX6iIe
 Bdi0asL5
 mIqNo8SJ4L3N/PcSJJYywIKxkXpMluTa/xyeGEleW5HzwDQJDvaIDFltUkmP3vOib65UxCItD4bDQaTvKGnYsykrIwIfnu+RZQDxiuMzpbHFOfzzHt8lMh/G7Lf5yYDGFlbpUK8yc48whLySMDnU7o+7Cf3/z+zNaFjzh5Fh1uHjjx5Gq/nUPeequ8IzYXfVMptguLuBbsUXoQinYoTRfXJzf11CgRNWGVWy2BfYkhQ3SM88PQU3mB8kuZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At time of damon_reset_aggregated(), aggregation of the interval should
be completed, and hence nr_accesses and nr_accesses_bp should match.  I
found a few bugs caused it to be broken in the past, from online
parameters update and complicated nr_accesses handling changes.  Add a
sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index be2300cf3aeae..e8c44541754f7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1666,6 +1666,23 @@ static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
 	r->nr_accesses_bp = r->nr_accesses * 10000;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_reset_aggregated(struct damon_region *r,
+		struct damon_ctx *c)
+{
+	WARN_ONCE(r->nr_accesses_bp != r->last_nr_accesses * 10000,
+			"nr_accesses_bp %u last_nr_accesses %u sis %lu %lu\n",
+			r->nr_accesses_bp, r->last_nr_accesses,
+			c->passed_sample_intervals, c->next_aggregation_sis);
+}
+#else
+static void damon_verify_reset_aggregated(struct damon_region *r,
+		struct damon_ctx *c)
+{
+}
+#endif
+
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -1682,6 +1699,7 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
-- 
2.47.3

