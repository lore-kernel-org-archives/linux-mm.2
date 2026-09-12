Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F064C88E64
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C849E6B009E; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D0F6B009F; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26806B00A1; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80B8F6B009E
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C3F7120577
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:20 +0000 (UTC)
X-FDA: 85206071160.22.E074969
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B780514000A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5QhBUHr;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240698;
	b=xyb1LwfWPwBsQUdyeN6ofvWdv6xo8AOKGAd/elR7GL2cRLxw+jrCfuomFnF8uqVdZ2qtYg
	SKnY/PIwdnvaL9RnEp1T5N2wb+yI/HyoS63gJvV3hPZZgzB8hFqmh8HsdThTZK9s1O9mA9
	YdDEc0SLterHFDzH+nQY0E2+Ro/FZGA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5QhBUHr;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqfaQq4DYDAwDcS6eX/vnZ8ZZiveWwkFxlbgk1mGGIc=;
	b=c/6wSj/70cOf+pJ58UUg9urKWKGj7hi8du4vOwjwA1InEfIXW2JvW6RXrO4j0S4yKydp0F
	EvMumx80mUa5x4dkdFH3ZbMkQcKHvQxoVnWNjk4IcQEi8SPFgyCPwpNcAIRRhpdTyaY9aD
	vsXX2TzB39wdFxfm3LCn41VmpL9+XIU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BF9640B2C;
	Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3D01F0089D;
	Sat, 12 Sep 2026 19:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240697;
	bh=nqfaQq4DYDAwDcS6eX/vnZ8ZZiveWwkFxlbgk1mGGIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5QhBUHrflz5pYPHYuZafb/qwhmZbipzas1UBJfiSeQQjqAKW6MqLAfgXqwq6x5os
	 ox4OgOWPMeGv+kNoLMKiDq5Y3SarBI5MbqMWxwtBJVEfrLn390keBGKcmymPYs02IX
	 p7KPmpXNZVc0X9iziOf1g4J7Ys8JHAXx2h10LL5jJcfjrQ0pMiYQ9e8gjUyvJCIE09
	 yFQPrBcr0rPeHoA+Km+rgDofDyn4I5g6h+ueHfU58VDyVWqChFmJVcG0FuzZJMVAvh
	 nz1xjpcigZW/Fp3tIt4VvGMUJTxvCZl5Bm877mGhUU0bFt42Tiy5lxSnxzJUtI3T0B
	 4PGiDcWU1f4aQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 7/8] mm/damon/core-kunit: extend damos_commit_filter_for() for wrong input
Date: Sat, 12 Sep 2026 12:18:05 -0700
Message-ID: <20260912191807.138502-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912191807.138502-1-sj@kernel.org>
References: <20260912191807.138502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B780514000A
X-Rspam-User: 
X-Stat-Signature: mf5gnfkeoiymjfnmouf98jxgey64xzok
X-HE-Tag: 1789240698-895559
X-HE-Meta: U2FsdGVkX18tWYnxkfTksSKpTSw/+dbN77df8Z8kGaodXKcFmhh7u7XQonZuaSpb5Trd/tAhK6GhLrXQJPmuKPWga56D7jRTr+nEpgQ6Ft1peRlL4H/45vLPwEHRu9Y5p3cLM7V4SszMcmpHF/OY2oScGfArx7R4WmAwTDgIrLWbLgfNcydJtOVHVo2Hq7xY8d3ycENiPLSJOTHAOoTLqlBGy11KEK8GeEz5+zugnujP2Fk9zHnVm6+v6MXnK1DBhF5WEMCom0ygCWYkwuQgOJ+PVmvXUMfAxrAd1TrILlHlIvd1hO+Eg4j0f3w5o3aoH0hyZGGR187bmiVwzyROU7SueyfLharshIewlmcxauQ/W/bztKxdvSQKFGAhj/CDxkhYKXp+79WTJ1aAFCbpayDHBNW4GWqfLj5J+YK6N01WU8cpvBqnW0sUYZGBA00n7tt5Wm8CboaZmLmE21rS7B8eN1UNrZwbaQT7W4P9vNYdzxosxmdi4IuQ0vtKMBTxGhSok/MhGf8n9XsMvkoXaFynsGzEKhROa6uQ3e5jDadDMZxXh+TEDv79pbfyiwjGxgb1JarmvsV/QeUKvRtFAVlbJiQwj7MAOAkqkVQwaOMmVcd6HG7cxy4RM0VBlb7oVJksSPfhzn64FBu4Zw2fVO3lQzTJRUZpNhYmg4GcUIioZcntxmuY7rPI9XvdTsSrxWH9XdDslmwefhz0dWLZNHCKYtj5asxWGeEJ84T0nn7wGMCfmRAtRm7SSri+3BbaR1xtwmqUXXwvnkpwpMAbSFSDYIpIm1Dl/UNbgKfeyfY5xwCH9Bc749mwslfnNP/jRL4OmvlgLphSv1Rlg+QkI5xKeDNCOsVCAlrXlfsz8FPa6VCmsaxYBbwCc+fBRzMU+uUJCIAeJjZP7AX+tLbifehHux/PEEwGnWq+Ln34enEpUCWGNZ7CPUN3jPAwU+NGUc1Itx0CamexanW4rLm
 Xth7ZXLV
 12P2X2m2lv/fEmbsk2EssFZgsOcaAxeYgyOE5GOf42kEPuOOVAMtSuWh/OdvatE3ThPrSjoKnr2WlwwXRuSlhUAiKpJXUmAl5Kos7u/kK/hl/MmLP4e4Ri/5x+utLWX8+Gq/RWPA+f8AtGd/9vJB94CkZQkgUY/+UT4iW/ThVT0NQSBApQAtT5iAJo3QjJT0ENJ1Ugv17M1sJj3oYUsJcitlVYfbdlAeMMrpvRbldp97pF/mSnw4H09lzo9ECtO+5ZE1UiYe3l7MwBbKgI9lFUC2ndg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter_for() supposes damos_commit_filter() to always
succeed with given inputs.  damos_commit_filter() could return an error
for invalid inputs.  Existing callers always pass only valid inputs, but
they may pass invalid inputs in future, for test purposes.  Extend the
function to be able to be used for wrong inputs-caused error testing.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a47a5cdf285c8..c9941f3bfb42b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1127,9 +1127,15 @@ static void damos_test_commit_dests(struct kunit *test)
 }
 
 static void damos_test_commit_filter_for(struct kunit *test,
-		struct damos_filter *dst, struct damos_filter *src)
+		struct damos_filter *dst, struct damos_filter *src,
+		bool expect_fail)
 {
-	damos_commit_filter(dst, src);
+	int err;
+
+	err = damos_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, err != 0, expect_fail);
+	if (expect_fail)
+		return;
 	KUNIT_EXPECT_EQ(test, dst->type, src->type);
 	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
 	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
@@ -1168,47 +1174,47 @@ static void damos_test_commit_filter(struct kunit *test)
 			.type = DAMOS_FILTER_TYPE_ANON,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_MEMCG,
 			.matching = false,
 			.allow = false,
 			.memcg_id = 123,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_YOUNG,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
 			.matching = false,
 			.allow = false,
 			.sz_range = {.min = 234, .max = 345},
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_UNMAPPED,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_ADDR,
 			.matching = false,
 			.allow = false,
 			.addr_range = {.start = 456, .end = 567},
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_TARGET,
 			.matching = true,
 			.allow = true,
 			.target_idx = 6,
-			});
+			}, false);
 }
 
 static void damos_test_help_initailize_scheme(struct damos *scheme)
-- 
2.47.3

