Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4000EC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D226B00A2; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3E96B00A3; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5F26B00A4; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56B556B00A2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87F32A0585
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:03 +0000 (UTC)
X-FDA: 85198059366.03.FE3BA4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0139E120008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XeRVgxyi;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWrMrM3f3WHWIPiBc1do7PEyYjGSCGGW8JjOmMYVBv8=;
	b=jZxqA7jzCwyP9ptduhv9v75OMiXaUU0zLNjLvlij4jgr/iUEvJL1suOZZhmmssNrdZqjRc
	HduSfQuRBzszc3Z/RmbjxJmcFiFy6tEyhtg9Wt69Aj9jeqba8IU3+oSxSdk9xv6f0/gN5Y
	ZS6y6rBKcxCtHcAKEZSZldUGWmVdPHU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XeRVgxyi;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049942;
	b=CeBgtzYKkI+q34pSNsBeCSxytdqHMpevnIFBXc211Ac3CwO1aSash1wV88N4TSFOhpUlJ9
	yAt0UXaGiKjR4RxHkbXkgiv7tz8zu4UEHIjlVkckAaKVqDtnUX4Qq2zzpA225tE6Yti3gG
	Jp3XG0PH8AwF0ZDZGhQfsZSKmg5vAxY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E6A06020C;
	Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E98C1F00893;
	Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049941;
	bh=PWrMrM3f3WHWIPiBc1do7PEyYjGSCGGW8JjOmMYVBv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeRVgxyixHufqqb7P/t2eodGXN/9vTEqu3GKl7K33f+WK9+KgwQtezZTip4wimx5G
	 vyHHRWf1ooGXazAwjYavRcGa/pNX5WqXp5fGtv7sWtDdIYfjwHoG/v5Tw2qFyRH3CT
	 W5khMH+4iC3x3MBnlEyQw8de3MnV8tzfx6vR21OzNegXqn9tZP6wAsY6KBfEX8qSCq
	 nR0fbUoSv7b5+zXRE03mKl/o5OQcim9w3ldTkJ096g6YR4jd3uNZGGwd8s4hDgZbOZ
	 uNNoO3Od/UHfUGbHVhylzoZBDUprdXzpizGc1dx6MH0Uj7cbReCYnOiPsF4m4GB+jh
	 Rb1PgVve+WMQA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/core: support probe_hits_wsum damos core filter
Date: Thu, 10 Sep 2026 07:18:43 -0700
Message-ID: <20260910141849.170896-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910141849.170896-1-sj@kernel.org>
References: <20260910141849.170896-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0139E120008
X-Stat-Signature: c8zuidomyjph1gafp9ubmbfg93hdx837
X-Rspam-User: 
X-HE-Tag: 1789049941-195907
X-HE-Meta: U2FsdGVkX18KsqcMv2z87lfv4jewUdBphJHg6NvCtWngMj9/nhRn4jF9KBDwpM5Rl+6FgXP+FpQp8pe7Ys+4Jiogihc8lOWk/b2RD9SZIrAchITq7awjIy7Vm+nUNpIeNOl2gO0B5KN2lNQQHuoM8GrJ4lqE4/Wu/yZQEdYEZcBoGwxC7R1E2TNcZoRWP2MsozdlwHEMRKA3YYn9Og9TWmVfuh10p6UE1wxLGNEzJQYQzLFvsXoDR7Rh1JKMRXRJpyaLs2A0i5q2XHN0Epd/xujrhkCxh0NX1o+QpHZTv33OEbpDYbf2ZiVxgrHgAz1BALwtdmna6Al/BpmzOs7xSAgggVFo0c0fEWiJI/RsW8bycyYDf005O4uqlZZyzGtyKyCRZZQJYWgUq0wEKyi5X4SzmtKdORaON7w9GfvP+6f0UaBnUfLK6mwMR/HYJ94ZbzLZjckCSokrMnCT7VdMs7EPRA9j3tyFF6wHE1dlvJ6xLjyXIx6SXp74J1qhfmPl63nw4nrpBdRkoDo/KxAZw0tENiD1jR//zEGM+23MXgD5haSrmSvVBmvUJlqSpiSEuXL/ta/TB3CbMCo7b3C15zRP6/zbTU5aD3RSMDY1zinCIiTpDPZ2aAJwIdGydM4SSjWIf0bTKg5iN0hGWcaLzbxlmV6GBR5soS8GfLbLcfCclh+yC84OjjI8K0SyuOweNVe233aYX4gEI2ZD7pSfALDkF0VGzQXQjTPyGHpxd9ySvJd7Ap27p8XrQwlIejVXbeT0kkDZIydaowfXJW4htRjVbtebnbE1/+PdsiiO4zFW9/RG4DKJ86YPvY9Moemzqs370axWJUqgs3oY5MS5w71RH1ja7YeY/pgcKnJ5qwohWhcSgfRLTWhrWBKnnDJMLWD63LkKqamqISIML8UkqX6AqlycE9JPovde5JLut5QgLkzjlyGqQ3SfzJHE/tkipt5IOt1PUBhz5Rtm9wb
 8syHTWcv
 fHgfKumKHPy12gHaUSo+sAX57wc127gY38gy/Kb/ErL3j1X4s1ft9PHS1AM0yxBDlmef6XdVFxDmdIm7X88T9LGafadHzpmd+jMgyakEPKGvqFUwHmj/U7wp6n4snl0ZuxeiwncPLj3bHXU32pohoTJBsSop6+6bSiExAZflbRn0wwd9zoGyvElGh5X1OLlqfCUhW3DcHXcDx9h4r8ni+Yej6sdC1HxqO+h0ZFi8Zon9T8/I9sw7cZbbTL3+qxbQ145cm116K+bXZCfu2ixQJGHZGig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement probe_hits_wsum DAMOS core filter support in the core layer.
Make three small changes for the support.  First, update
damos_filter_for_ops() to treat probe_hits_wsum filter as core filter.
Second, Update destination damos_filter->range_{min,max} for
probe_hits_wsum type damos filter commits.  Third, extend
damos_filter_match() to handle probe_hits_wsum type filter. Calculate
the weighted sum of the given region and compare it with the given
filter's target weighted sum range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e9630f41e51fe..d9d56f4be1a97 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -658,6 +658,7 @@ bool damos_filter_for_ops(enum damos_filter_type type)
 	switch (type) {
 	case DAMOS_FILTER_TYPE_ADDR:
 	case DAMOS_FILTER_TYPE_TARGET:
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
 		return false;
 	default:
 		break;
@@ -1332,6 +1333,10 @@ static void damos_commit_filter_arg(
 	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
 		dst->sz_range = src->sz_range;
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
@@ -2510,7 +2515,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
-	unsigned long start, end;
+	unsigned long start, end, wsum;
 
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
@@ -2545,6 +2550,11 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		wsum = damon_probe_hits_wsum(r, false, true, ctx);
+		matched = filter->range_min <= wsum &&
+			wsum <= filter->range_max;
+		break;
 	default:
 		return false;
 	}
-- 
2.47.3

