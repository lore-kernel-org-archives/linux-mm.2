Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A8AC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F926B0096; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CCC6B009B; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF456B009D; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 303286B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBF6A120251
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:28 +0000 (UTC)
X-FDA: 85187609976.09.1086436
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2CD0FA0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kC4AxmPQ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lU6Anck8dGcwHo6Zz1AH/wx0RCbpjIZ1+t8NQz+I98U=;
	b=keEPhBZEKk0Pi7ncmSIYb0mczNkNAM5Zd9x4iQ58soxA3vm9wxOmCByMIt/tViFYIAFNRm
	uHiW3rYkLBKddr7k0PZ4ZkXnc4WDhPFfnUxm8zEZPC1MfU0FF8sAJAhTe2odDQQYWTInmd
	/fwgVs5jsz/YPZBIt0fJ1v2fUVXfHWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801147;
	b=Ar9D6A38QKSbUhH/2U2GykyCecTb1vCmGYv/jEZMzSFrlWAv9dkD5CynRxOGkLbRJxvjhG
	xb1vlpKmJC1ppsvjkaZGnp52kPiHS0o6B3Ob36pZSEkywgPLELSkuPcVKjEvIGPDSoa3Vn
	uxUWsZh7WhhhffuyPlGdYYKvI+yfswY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kC4AxmPQ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3883601DE;
	Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552B81F00A3F;
	Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801146;
	bh=lU6Anck8dGcwHo6Zz1AH/wx0RCbpjIZ1+t8NQz+I98U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kC4AxmPQiOZ3aJ+kyB9vrnbNxo6iJlrY/iUYv1AXldMH4C/fJN36qQrI2ES9RCnXE
	 SQFcvPOjzZlAdzrkPSsR0vsHmP13qCTg/bm8g4IbjuJ6optJOOgxqEIVbFjwScHaJ0
	 GmxsBnmUi8ewFCxfkyiuQ7/2FGOYMF+zaduMew5hsmbZGgP/kuK6oWjbzkHGl19yxU
	 uJu9HlasDNMRUoxYy3G1mU6wL/ttmYQyoIxLNjyW4OswjL2/lZDFxNaTN4Gr2npOBk
	 c6BFdAAbvggDGBZ7v/TOEMJ1ovF+cnMCo1UODwHrVWVH0ZlV5a7c0mUgB5/QxiiIkg
	 34yqqnFgQwzvQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 3/7] mm/damon/core: support probe_hits_wsum damos core filter
Date: Mon,  7 Sep 2026 10:12:12 -0700
Message-ID: <20260907171218.101430-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171218.101430-1-sj@kernel.org>
References: <20260907171218.101430-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CD0FA0006
X-Stat-Signature: 4515nd8z5nodfu3b639m3i8hq6rid9cm
X-HE-Tag: 1788801147-268819
X-HE-Meta: U2FsdGVkX19Zh/gVPMvVTpi2+R1ZKcj9yogmFp5wuRXDYPclSy2J09IMcX8cpp0Stp4jjoLQnjdwvQZ9GNdQXp3AIeVF+EQPMIAftmBQTRKtsxYc2064JbfbeH//Rf417RGrGESAAuWwo7uRaztnx9oFJUo1DO8sxHzcxkTKPFTxO7jJvjs+SshLMRJ2fPgA26GOxevklncUVY670Z1KbEqiTUjleli5VLJ63sqxkSzXriFbrUtSbeeXBLo+n3HH0gw305hf3FPP3dRQd1UV5/q5kHgeaDaXLLDDuByLduh11wx2OAF9Q65Iq9aEsMechItv+eNqFvU5HsZ7GwjNQRY7jUx6piLJbI2UWIvrTKzVCwsJ7fPmKWmCa9Y7U5XRPrT6NQGOELaxo84saiOAxRBtkPZ5op65sXI25uN5OIRH0P/qW6aKtrm5KFJJCXCobI1D3gh6t+ftj1nEwKqvnJpr00rAKs4imAAIea7ROvVCnZH2D6oNpg/Rt4xyKIMVCemZcoSX0lZE/xi0diWx9UKdNBo3t13BH4LtckVa2bhaNN//eSMh8VEusE7vAnK2RIXOkgOb8CuUvX7IBYvQLPqrFMO2hFDrxjmepTVutRqUmQsWAWebssll5oCKm3GmqJioRAva0qTfD9sMPIyWr6GtlpARjg5qUZt5y+TNFFarAThg3oaknzK9mdh3YSVOeqQ/tcMLSxhYEIogXK1sOSfnJyydqQK8L/AcN+YItuOYl2fiJSco9IvyquGAASO3AmmZDeDHbcjtDC/SZ0fHg5zX/Pffye8woIPIr7x+FnZ3zfNz++Tekhmf7y9XjtTeKo0/X77uiwA5YdOF3VUKTK5d/oDWaBT0r+FIUvPsgttqzc9C2frNcL+Sk5H29L+AImyG4vZaKbpBr7shdPg79qBWF/aNgzIlIWt95HbBMUNM+AP8HMKszPq+r6wHRbdHhVQn1o2jSpMMsQAaecu
 nmZNujNW
 KYzBjBB4WjvP7oGSZ1YNGZL88F6HfkaWRAETbZ8kTYaLH+FGJsf3FKMYRwi6mnn1lyurExht6tG3XxeiPIMpd5YwJPOMM6SC+wk0DsytN+xjATTOZImSJg1v7jCIX+jskWGQrDja7aIWYDeJ8uoRHbnXuw8QHbOsyr9JKG6cQScYdxofBVTkunJCregMQimd6VA5yWta+42Z6JkvjCrCfQyOTN34BfZ0ja9fQO3KYL37TkOIQOYAOHoPRd07LWovgu/pfHQB9a++CQhUKUJBZuUxi5w==
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
index 30af5bbcc90e7..98efc6e2876f4 100644
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

