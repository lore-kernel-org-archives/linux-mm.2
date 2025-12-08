Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50CCD3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AC36B00AA; Mon,  8 Dec 2025 01:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE616B00AB; Mon,  8 Dec 2025 01:30:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3CC6B00AC; Mon,  8 Dec 2025 01:30:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 19D396B00AA
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE7DBC09DA
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:35 +0000 (UTC)
X-FDA: 84195330030.11.2A28CDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 225ECC000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=euXt4Rbs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175434; a=rsa-sha256;
	cv=none;
	b=mWwUgnMwZHUnAhbZzpeWOOrAP3pVTUCKOgLDtCJrbIHM2Dw6WE7oVvwplXCqCcromwkQDU
	PLn7q3QG43tS9rE1JYMkhKX3HfWNVcz9v70zfgEGNxp/oESao0RHNL7E+FvePAxf7eIJ3Z
	N+aYc7ZTz9XEak4XHR0MSgZKbVz1MAQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=euXt4Rbs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88081l5G0n0jUNxO/d/QRijgsqdKRGHegqqoSpEFOAI=;
	b=DDF2xpSoXTkUJppT/eXskK7S1biAn7ctVDuN8Y0zCXVaaJqrTbeNKdjIljnhVk9t0SJuWz
	+L14F1SBIJMkf/SDDIKTefrh44wP7qj4/IsUMA1Fl1L3G+HV/oDTVNsMSUTLX6FSPWKn9F
	FY9ub6eeR8ZWPIvNsFpUdxNC9H2FsOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F05260143;
	Mon,  8 Dec 2025 06:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66783C113D0;
	Mon,  8 Dec 2025 06:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175433;
	bh=gwTxa0+Xw/5ku9fEShf6P61CX21upFsU6eEBzrxcpzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euXt4RbsZvz/JVIq9rAtil0vOmQVNcrpPL1Nccoc9a4iX1XyV4b0MLoBdiEspWc+z
	 UiF6XeIRapawls7mzSEnKfrTs+8j2R48XDy9BL07iOO35DWwo0HCY/ttxi/sHwUqxj
	 gb3vJ+tisW6bhNcejx9VhjNpz0iDE+Bc79FP8xMm4LY7KHmPZtWEWb0QZkz0vmkT+5
	 Lrp6xQgaTcjaZSXbLKlCf2GegD8FvCsKyanGqvD7rw+ToXL9z6k6q5y+XYCrcCNFx5
	 uwCmOjS3uUc6QzBnBuEmvPqMxJKaASKq73+b2jQ9Zh1KFr6jZk+7YSM+C0+t+B04Ro
	 3na0LG6r+aL4g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 29/37] mm/damon/core: support threads type sample filter
Date: Sun,  7 Dec 2025 22:29:33 -0800
Message-ID: <20251208062943.68824-30-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m678r1smdtg7sq11sawgh9yfnpte3cb8
X-Rspam-User: 
X-Rspamd-Queue-Id: 225ECC000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1765175433-288087
X-HE-Meta: U2FsdGVkX18k6PG4dPVzAWPg2jJj1XBemuJFHLqyhUKATOKa9uxR5yGrCNo6xRxgvycyrCqRlnsw2pFX/OdeFYMr3baaYiNJPdBQXk7xgJuIAvGMF0R2cFqlHPA12/zUq2HexHmjld+WOrbX+UC45is/Y95E7PPdmRm6cx77hFwzOQFS4FXHnLjk6PMInTrOKlBl4K+oWRLTFs3GzjbRM4GLZYZSnbCW+4/mkHPcA+M9VzKMRY4NCvtcfkug/57JPm8ZS85HY/5g8gDWo8/CZGwL0FO5C8xEF2DoUYE2dc2TB+RXEWdK+/cDE1Y77y8VNy7+5nH6Xd68RJfJLmijz2e08xYggaPOl6Y9/3lPZJBpEBQ8qMT4UnwLhvRoz88U/F/88VUW3etfYhOfWHBUnBNB9RpKmw9tAmnLUdGj44DJ/sA0uLbttLB1LFGtTwRY7fZ9egyiozQu1JRWvjPj6cmlG20ONcw9af8CHLU25BVVLyhoprzo1XKZuCED4Nzbgv4XZsJz9Jt8j+Zs6SXyaCQaNNMSmNL/Pk/jjVQ/c4ejALwK5VVnvYJKoTNJNtjW51J7u/JwIOV6OsBV59zIbnVEGNdGqdZ2NmLtqD6tlvsNz5+bAIKC7zDAUwQd9KrG6fDd1GVhOhAwTlaM9joH2plgiTJ0CfSV2Ut8kgjSMOs8oMnqMnSdtqhotGM6p+uQjuEsq4cByVnxFqXdLUryngqvp5rD+8kd7RzoDyHyJr0z3pUqBfSCVZ7GzfkqZ3AwtaQb+3U/pkbzdcXOESHI/iCLpdRczELTgevZwRSNDcZJymDw+HLdDBKUrdkhc+7FnPn0wR/wBQEmjVTPSnOrYWOX5hfgDDw+d3+Wg78l6n4Jptz0EUkaIwWV2Juqpw+9rxdVbhkxyl+g/ZfpTM0WeGySi0zO1j8e2DaFHMlN6Z8oQQJNYiuxt3QScjjBrlceprpKOwGae0QBsQo01IK
 2r7/z8sB
 6yvYkeDnz1iIOQnhheTo0W0b6jgYmKCG3l7hwlnbAP8Jrwrm6yDD3c+Z6kWod6w+Do44NmC94QVsaHbZF+qEnwTophY7kwT1KG6+kN/UGc9qkbgnV8frjykIVHrQspJamiFOCvEOz1gy7cCVk6MXgiPsuV8z0DHDm1sUhMNmY9SKD+Zy0HpiZVV8ZVSfmUsFOy6VOxVxDsPqnf8bbd/beJQNTBhAwA8dSsSus
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Access-generated threads based access sample filter type is not really
being respected on the core layer.  Implement the support for doing the
filtering, and committing the information when doing the online
parameters update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4971647d4b5e..782af39ef0c0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -546,6 +546,10 @@ struct damon_sample_filter *damon_new_sample_filter(
 	filter->matching = matching;
 	filter->allow = allow;
 	INIT_LIST_HEAD(&filter->list);
+	if (filter_type == DAMON_FILTER_TYPE_THREADS) {
+		filter->tid_arr = NULL;
+		filter->nr_tids = 0;
+	}
 	return filter;
 }
 
@@ -570,6 +574,10 @@ void damon_destroy_sample_filter(struct damon_sample_filter *f,
 		struct damon_sample_control *ctrl)
 {
 	damon_del_sample_filter(f, ctrl);
+	if (f->type == DAMON_FILTER_TYPE_THREADS) {
+		kfree(f->tid_arr);
+		f->nr_tids = 0;
+	}
 	damon_free_sample_filter(f);
 }
 
@@ -1317,6 +1325,17 @@ static int damon_commit_sample_filter_arg(struct damon_sample_filter *dst,
 	case DAMON_FILTER_TYPE_CPUMASK:
 		dst->cpumask = src->cpumask;
 		break;
+	case DAMON_FILTER_TYPE_THREADS:
+		if (dst->type == DAMON_FILTER_TYPE_THREADS)
+			kfree(dst->tid_arr);
+		dst->tid_arr = kmalloc_array(src->nr_tids,
+				sizeof(*dst->tid_arr), GFP_KERNEL);
+		if (!dst->tid_arr)
+			return -ENOMEM;
+		memcpy(dst->tid_arr, src->tid_arr, sizeof(*dst->tid_arr) *
+				src->nr_tids);
+		dst->nr_tids = src->nr_tids;
+		break;
 	default:
 		break;
 	}
@@ -2878,11 +2897,20 @@ static bool damon_sample_filter_matching(struct damon_access_report *report,
 		struct damon_sample_filter *filter)
 {
 	bool matched = false;
+	int i;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_CPUMASK:
 		matched = cpumask_test_cpu(report->cpu, &filter->cpumask);
 		break;
+	case DAMON_FILTER_TYPE_THREADS:
+		for (i = 0; i < filter->nr_tids; i++) {
+			if (report->tid != filter->tid_arr[i])
+				continue;
+			matched = true;
+			break;
+		}
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

