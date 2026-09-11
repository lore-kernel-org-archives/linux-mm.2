Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896E9C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBBBB6B008C; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44E86B0096; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9869F6B008C; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 509506B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:13:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 627CD1605EF
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:41 +0000 (UTC)
X-FDA: 85199709042.03.5BB4791
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id DCCA920007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwxpBJKS;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789089219;
	b=u79d5Js8+KezJaR29HnIIarnN5EeJqFDyYx9RAYolBYrG4dGUTeqIF4hMPqaQfy6rTK04S
	ZcgAFuHjKHkw1Y7DrjJxI0dLHS2uOq59yOVfJMJG6vQnAyX4XwDykYzf2AGXiCTHhJQP+B
	G2wwHAuu/Zl/6mybAa6z9yZ6S2nQC9I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwxpBJKS;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789089219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b57SpIkbZ6AMBsE6RM4G3dlGWMR1DXMsNf+oP0yvVfg=;
	b=KbGB0OUSHxS7lGF1DzgFbZ/1ofHQBsYRviPPwkXMBlAozFj9CIbSlUxkfNaCourLfgCBny
	NOFFm0dFLeiKYPt3LLoZpQdxupjx5JpjOQr7gVRazKN6jHcrB3X+DX26V2lLxW/dQzTRUh
	ZsT/rcXlJaSPoTZW0GTXzv7H1f89utc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7486760200;
	Fri, 11 Sep 2026 01:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013021F00899;
	Fri, 11 Sep 2026 01:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089219;
	bh=b57SpIkbZ6AMBsE6RM4G3dlGWMR1DXMsNf+oP0yvVfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwxpBJKS/QiinPaLXeMhuqncGlUqStkYv7JTJwV4RsBGPZNogMbgdim4vQj3rK+VV
	 Ag41Px4bbwivRlpnWqciRr45S8GOgbkuG9E+8s/8ks6MUVHTRdQyotvMpMaa6px9Cz
	 zJIsfcwL6XRAWFdKd5TdWXBiKn/Ci5RZPyqJRtXq1XLcVrj4cw2Xjp7EAwZy7XdSsW
	 wBpmxYxaVNsRPJF5RK3Dr8ZGlES35uDwSRewLWIrBSDP2Eox6RMW8KsnHb7oAiYoUW
	 0iuHM+T3XKVD9eoYhh6vC6HrP+TMt3nJtIAL4qIEZwC0/pxl9K6BPgNweLOFbJCy2w
	 1OOXsTzxWoM0A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 3/7] mm/damon/core: support probe_hits_wsum damos core filter
Date: Thu, 10 Sep 2026 18:13:24 -0700
Message-ID: <20260911011330.93678-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911011330.93678-1-sj@kernel.org>
References: <20260911011330.93678-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DCCA920007
X-Stat-Signature: 5xzdt6krmegjpxrx6pk4joaciyohfma1
X-HE-Tag: 1789089219-74136
X-HE-Meta: U2FsdGVkX1+pyX81hcsir9TBR8yatE2rQCKA0VzLNTcqYOTMfTcY99IhuAMsDs+XLMA8aEjbg2MO8MeMuxB4ffL6oivrhkBcU8le5V0D1syT6n4+hFk8o2NBAC+CN+alNCHMiASYLwud7NjltARM/YQ29sw3rZqNSEN13MDg+V9Y9yTnzg9OMt3Fo9NxqgXRaA9CH92sTfp6IxIlOXVCwKr5WCvTtzjcnS+c95k5mF9Ham3/NhqbMLGqG4foZExfnFUYmlplV+9rkYQnfkMgOsV1CzpOcmQWG95l0mtxsWKTdDvyXemKrK6hA4g/msOym4+UfKzdaQ4tdR5CYcM+f8OKdUd0ABAvGXbUriFqYASdvKUkGb+yyXnrANT6GNHTt0RW6Aw6GgCGjNtvyWr99TWvmmuSA/L+kmt6E5D3DuPXy0MXrtgtMU4w6bWiz92TJLkPtw9iRHOVjHNvJI4m5jHlmut5xqodKDFTpVuVgQ7Vsaip1ef7q9xQle5R3pUxhd3J+QnAqcWxlMGk0zrtI3gU1fAKIIGlZ8GBNxugWj86CDY2EtnmG7J0C5CSaSIzqmR2/RcALWrLFDeAxSa11qtRT0LNgRAd313479jl+C1Ey68/PrSW0mZLPFNvlaRT3/+wqhxciSfNTmjyPIDsMD7NwSNp/4+Le2Jbb49CCNFMuF0NGOGTb8nyCbCgZvHYSY5400QJ4lMim27k+HOlM1At8J+/Z82AViBAkw262IdRBRPamTU3DyCNlA6iRDmdn4xqeMiB6x4VCqzNTLSr3zsLlnwAeZqVLcRYVtx18a8eumw520+I0noJ83mKdt7Z2SGbnKix3cEAZs99x2p0XbUmz0VMKxHDgzDXdWkwhV9519tUSAWu0jqiuKGsaVm7SWXDIIAOeVel0J9beBE1hTiPlIxi8ZfLf6xmvF+TTCXrrjNQRPB3XzbT7Tme/PMfhtUGZOeb3BbOn9ynpYR
 iPHFs055
 ptZ5EnvIO3Q31D9tYxn8ZKs69XH5fl/9GY85tik0qR2FKwarYZFant9r7SBRVberamT2z6VM1xqEq2PL3AJVy4ffsbPrOfNpSIegOhzZee3DLsnmn9htNEYfG8ezb/FEimvkhO+/+5/yT6pyCXngYXENVmhzvCoY9Ou58EP4AnF0e6HULMv5yCQFDZb5B9M00Doz2E1m1ls0nJN+Z6mv4isba/t3UER01qutLBpH+x4W8YojHfdWsleuaFshGnGNgDT9pREZfq0hcmSbv5oSTI7uYPg==
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
index 50e0f9407db2b..0c98f7e267d07 100644
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

