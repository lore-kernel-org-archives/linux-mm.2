Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 438A5C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82EC86B00B0; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8136B00B2; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6976B00B3; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38E3B6B00B0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B581B14021D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:40 +0000 (UTC)
X-FDA: 85168990200.30.D2AF2B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 04957A0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlBh8+Wj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRgNHsjFIHJ5E6PMMKzx1XWhx+ToWlevPqGLUpHC1XU=;
	b=1Hakqc0iy1f9pSnJqhCVQ8jwhsFNXS7YhUHNc/qkUb5HmzYmodXA01PxpGExB7ZLnQMEQy
	C6KSIlVvj6nK9QJaP/A2U9Yt03G6E9gCE6j1q+9jNuP1X5dFQ3NMi/MUUdfNDgsXu5jtDk
	GsRMhQlGaDk5vdpToQahSZhuWY1FSOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357819;
	b=GIuJ/i3nI2ChhNtZ11vX2jw2THeO0KnLOj09jkbUuB4R9gpa5HaQvQHya9WvU/QHixm1Dc
	2Du0yrpM8bzb4UbOqrs1HX18kCsYPUGqP7xGYQbe01J+mMFIDDb5113GtfK7KOewd9pvVz
	7DNI45BhEwSfZ/cr8ALHNR1fbbZez9k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QlBh8+Wj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43F224165C;
	Wed,  2 Sep 2026 14:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F8C1F00A3D;
	Wed,  2 Sep 2026 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788357818;
	bh=kRgNHsjFIHJ5E6PMMKzx1XWhx+ToWlevPqGLUpHC1XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlBh8+WjuF2tUrcxK9t8i6OKujglfGERH1zT9Ygc6ORXDetBsjv9UkXIFPqat4qQ/
	 XxncyUXVP54V9k1BE3y8dWajPTkMQFkwKuk0ZuKXnC2dI9HngItnFELEAuGjITSNDl
	 MQ/nOi7ad3OeZoVC6LjxAp3qr17gxsqPNEPcudfcbphgNtcisXwHuWLbuun77C0usV
	 pUWFJavZyMgYMZRK7/wFPzocZGYf6PR/6ryvRh9lvs2ab+TDN0FGpXL9BFcxICOmWn
	 f3SpQgIuEPObRLv1sQhlxhrxZ/lwGw4P00nBuBC/e5tlMazAXyQWveSIgGeRpk3lp9
	 H049qrbpP/sPQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/6] mm/damon/tests/core-kunit: test damon_commit_filter()
Date: Wed,  2 Sep 2026 07:03:07 -0700
Message-ID: <20260902140313.85983-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902140313.85983-1-sj@kernel.org>
References: <20260902140313.85983-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04957A0006
X-Stat-Signature: bbficy61uuz9ja77ftd9sueummikxt3q
X-Rspam-User: 
X-HE-Tag: 1788357818-66245
X-HE-Meta: U2FsdGVkX1967eXJmaNmFnFok6Om9MdQ4FI21ftj/XSCHfYWzbMiiA7ncZu7iyj7tuoEeKOCSqU1NQfYchtCQgCeYCu2X92Z6K7qqdnCvf03BcjXsfnoy9chQMyolpG8TkKidfEizTxmEkW/Yp2Ys2Lb9PXVbrba5N+u9c3psQywIB3wEcX8rsdt6Sdfn2bjkYXnq+fBfsh9CHOClzd7mXPIn9Sqk98tX3bGNebCm1U8D/UUWksIpKmA9mAGRbNUbN9z1p195FVZ6wMAMUTyy1Gj4/dCD7JL+hxR4Q0PG3J2BRj1d4B6/9k1BO5+rJuHzv478qJsMrMFhHVK8tIBOI/FsCsQVRYr3x9QEqobeL1TsLp20mOKkrVShdun/B34aM8WGgKmBFQqgPNNWj0XmYayFhv9EHYg/8dcbYG6cI54j/NQ6j7pMKZ376ZtqNjbjA8PJJSXdK77Y7Cw8pLRRuA8UcvuUYX5I0pDkDDssNPZP4d3f3xDJ/xznFJ2xQjNu9hM+TgD7AAjX3b6YgxLVzwFXKdJOHinN4wLwIowDDxkGGOsvlHXPjMscDTsXgQMnBcwA3cXpUvbA0kbNYps8Ws+hGJWevaGf6yUzDM6fckRwK3sCIkkz9crWdaI4TUXEB76iomzXOMEsSAvZWzskkS4OJQNL4huc1leEGUmYvlDWRxnMRQtYmJ5OSuqYTVmHk+u+MCnJSY+860YkbiCCCEcBtnwi1zGE41WdPGtc/rpSw9YGyfIOrmik5TAocV+pjBoOsSFCGX9XFGWeLlmjxUKBBDuPeErrPqyiknRno61akShJzTSGiAjOsSpFHH8wGuN9MB0E13LtLO+I3RHPbqJQzuJfd9DB7GT6FU52RUvhSalezTVZe3tCIqZ8LeFtoR3xY+G7499JkUS3kagsHORhPp1rY34WzLaqIlNEnPMI/PowN/Z72rse1yJRv38LldG4N7GUvx7zbFhrCC
 84IAshtG
 84iYmW4X0fcBjWjDrUZSrCQ1Z+As3GxpacLVBaiie6O5QZkpMbgA2kD87A1NIhXdzPjj1IEkDx4vQliMQ+lx/d0hvRTZrNfwxYp2E6FGuaxAHCLBLphE9FyUnOzGk7ZAXucIwXot+MfZS75lYBmXNuvD51omrQL8JQ3P9m3t8G9+xxuCxEW9zurLKm3S0y5QG9c1YSP5I8FCT/FMJCBd3tn1mK7Oi2U+u5z/bQxBByz9H3Xiw+naeBuSCxrfwp4+uawFzB52g996bHJcZewK88pvN2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kunit test to ensure damon_commit_filter() updates destination
filter as expected for valid inputs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 40 +++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index d0bed01a5b7fe..c2ddef3c76d35 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1364,6 +1364,45 @@ static void damon_test_commit_target_regions(struct kunit *test)
 			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
 }
 
+static void damon_test_commit_filter_for(struct kunit *test,
+		struct damon_filter *dst, struct damon_filter *src)
+{
+	damon_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, dst->type, src->type);
+	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
+	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
+	switch (src->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
+		break;
+	default:
+		break;
+	}
+}
+
+static void damon_test_commit_filter(struct kunit *test)
+{
+	struct damon_filter dst = {
+		.type = DAMON_FILTER_TYPE_ANON,
+		.matching = false,
+		.allow = false,
+	};
+
+	damon_test_commit_filter_for(test, &dst,
+			&(struct damon_filter){
+			.type = DAMON_FILTER_TYPE_ANON,
+			.matching = true,
+			.allow = true,
+			});
+	damon_test_commit_filter_for(test, &dst,
+			&(struct damon_filter){
+			.type = DAMON_FILTER_TYPE_MEMCG,
+			.matching = false,
+			.allow = false,
+			.memcg_id = 123,
+			});
+}
+
 static void damon_test_commit_ctx(struct kunit *test)
 {
 	struct damon_ctx *src, *dst;
@@ -1771,6 +1810,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_pageout),
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
+	KUNIT_CASE(damon_test_commit_filter),
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
-- 
2.47.3

