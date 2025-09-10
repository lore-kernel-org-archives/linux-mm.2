Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F396DCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 04:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5F98E0011; Wed, 10 Sep 2025 00:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656498E0002; Wed, 10 Sep 2025 00:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545CF8E0011; Wed, 10 Sep 2025 00:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 435018E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:00:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1CCEC05A8
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:00:30 +0000 (UTC)
X-FDA: 83871988620.28.AED0EAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 889A210000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:00:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKKMlKjn;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757476829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eb+Au32sMF8ks12UcDDLcaTemdBsX4Y0Lz1SVq+bWao=;
	b=EuSP8C44RzLJvrRawk9eWlkKWClnDdTyDCCCgi9SeQwV58ba9OnM4hv2njxFn+smxfKSUT
	5R9UZRMgtUu090YqfbMip3ra8pbpnjEM4Xq+nBAisQBQiLu7NxtdqiEFmvzqiZ+LTD1Xif
	gDJAFZ53X4dcb73JXxnzDGl6SdUrRi8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKKMlKjn;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757476829; a=rsa-sha256;
	cv=none;
	b=Xl4qGfcdqFCYI8HF4FVqvE4BexJTaWvEQUhHBOO7+xsBVtn+Am9La10wUi3V43448K26hW
	LIP4Uc1227UrMalYbeo3aT3o+xWMZYaRpdVxShgqkxAbrLm7UUMex1J/YET4BvIr56j0so
	DSsnC+SC8jWjJuLn28UovcoOzdKn93A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F2F986023B;
	Wed, 10 Sep 2025 04:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC42C4CEF0;
	Wed, 10 Sep 2025 04:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757476828;
	bh=tykok6yuppc8B7LyjfEUNz5kChZB/VZzSzIWRHi56lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKKMlKjnDInPEpLjXklc0LMM0RJrFSRuecQPbdidJABxRvOlhLFjfP1brKAUdFxI2
	 U8+MtMgrYww5JU8JfwQMxSGMo9aIKrBFVyfZSFWm3/1rAyQtqHmtcQ1rrz76rbx7GV
	 6yBk8cDU7BGOj9kE5vwuSWV3mgpDlfWQ7nMOvbXTjoJ/+O1pLAjJkaGTsh/k0l9etW
	 2UcTEM+aMLKNAGkuKgacDLwcHegW/ld0KaVN0uicfUM4Ahj6Ek+PEQRNxEToMZMx+i
	 BvRwt+RVW97FaMjseHPyFNhF22/cUXOufbKtUC60KFYioj6gHfOrLmj9IVzrCTWcQn
	 VxItLrMWdC4JQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/2] mm/damon/stat: expose negative idle time
Date: Tue,  9 Sep 2025 21:00:22 -0700
Message-Id: <20250910040022.168223-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250910040022.168223-1-sj@kernel.org>
References: <20250910040022.168223-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 889A210000F
X-Stat-Signature: b71xburx7pjrdpecog8318fahegis1jm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757476829-514392
X-HE-Meta: U2FsdGVkX19nmGbAEHYXfXFB2i79v8D/zW0pwl/JgstIP50+ZklEjD7F2ug/HBheUU3MgzW1xsSiN+P1Ecj+7PFUvgzLQZxa5VP9lTY7HMDxJVjgM7PgnjXMs7KkT6eJbpKB8YchHsrVQApf1Hhpr2VQCBFYj3KMJ9XzcjOOwKCEj0DuPKj+5YXeJKAwO2xsU+//bsKiDBvZgxMIsngfmhAIPTJrSwbGgDO7wFZ3B+jiqK0isq0ZbTWa/2ikfR8ArfNTPIsBbWhSl3e6adilp/ZPMEW9eZg6vUVNnYs4I3K6AY8wb6oPG56QYnkv74KnnHELThlnbiC5IoyL926BrMDRH7dUEKLQxWpaGHMJ5xxfoLSNjQ+ML0JlXTVPsVM9r4L0zyzvgWJsuYqRsrJDi1oWbLtBLARBCz1AqKD3kLGpvjjAC/yBYDY4fnje/AXSsZRyMPjsmp/vakmZ/lPWLRwxywpZ4gp5hAR0Qj+Sv4ikN7yGvpp00Uuzz6JykYj8XScMEHzla2dSNeyMlCWhWc95cTlpaem/SgwZj0FS50NgHiZ+Y8Vm9jHCW+m7ZDy1iwiyfHLFStzOmCop9AiPYpLQ/ctxoPttPg5Mdm1A4QYJGmuf2GGYAggwJZE2zUq2/ylBOgqOhkQ0vgevj4LZ7rPZNisGbm8+8CDsfLGa6FPdH00s2kCE/1jaWf4NES6H88NSSHP6kPpfgbNcPrGJdJmApW3BrMHmqwhpFDvDMJsJ2N8yXOjfpKCY3lHygjjwkgT6+GwGxhcLlkecCsWZkf6G/UVC2Q9n8AMbVs/+zJdEBE1Mhu22ig18CKxCUgHJS3qJ9iQdfdynyxyZDkxj2bVOQpJ1xBsq/zckHL4BTSt2yGC0RGIVcQuSY6XvpCmcaZxO5K3Fu5c9i7lsUOzz2frRbATPmpyp92VzlFEa0s7vaRhHC+8QQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT calculates the idle time of a region using the region's age
if the region's nr_accesses is zero.  If the nr_accesses value is
non-zero (positive), the idle time of the region becomes zero.

This means the users cannot know how warm and hot data is distributed,
using DAMON_STAT's memory_idle_ms_percentiles output.  The other stat,
namely estimated_memory_bandwidth, can help understanding how the
overall access temperature of the system is, but it is still very rough
information.  On production systems, actually, a significant portion of
the system memory is observed with zero idle time, and we cannot break
it down based on its internal hotness distribution.

Define the idle time of the region using its age, similar to those
having zero nr_accesses, but multiples '-1' to distinguish it.  And
expose that using the same parameter interface,
memory_idle_ms_percentiles.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index ff1c076185e6..c33df0ade183 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -34,8 +34,8 @@ module_param(estimated_memory_bandwidth, ulong, 0400);
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
-static unsigned long memory_idle_ms_percentiles[101] __read_mostly = {0,};
-module_param_array(memory_idle_ms_percentiles, ulong, NULL, 0400);
+static long memory_idle_ms_percentiles[101] __read_mostly = {0,};
+module_param_array(memory_idle_ms_percentiles, long, NULL, 0400);
 MODULE_PARM_DESC(memory_idle_ms_percentiles,
 		"Memory idle time percentiles in milliseconds");
 
@@ -61,10 +61,10 @@ static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
 		MSEC_PER_SEC / c->attrs.aggr_interval;
 }
 
-static unsigned int damon_stat_idletime(const struct damon_region *r)
+static int damon_stat_idletime(const struct damon_region *r)
 {
 	if (r->nr_accesses)
-		return 0;
+		return -1 * (r->age + 1);
 	return r->age + 1;
 }
 
@@ -122,7 +122,7 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 		while (next_percentile <= accounted_bytes * 100 / total_sz)
 			memory_idle_ms_percentiles[next_percentile++] =
 				damon_stat_idletime(region) *
-				c->attrs.aggr_interval / USEC_PER_MSEC;
+				(long)c->attrs.aggr_interval / USEC_PER_MSEC;
 	}
 	kfree(sorted_regions);
 }
-- 
2.39.5

