Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03057CCFA02
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2528E001A; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6A48E0018; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F19B8E0015; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFC78E0016
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3545388103
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:45 +0000 (UTC)
X-FDA: 84062854050.23.9FCE067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8708240006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S9873RHW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjXsM1p6RaV5vC9jYucX06rAwKhOTv1hsLzIiqMZO6o=;
	b=oVxJwghchx0z2MPUgJ1juze75H86nbnKftitGeCDJ5fFIaYho8jsTGRkzamyiPB8ORDXr7
	12IdEG9UWKTiKQiJa+YmfPQ+6e0npKb1CVAwj3jcf8nKfawBtr/j0y+aZ0HQTcOZdau1M9
	nLSPqLAXs3tGVIUqa/QLaVkPv9Hp6mM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021243; a=rsa-sha256;
	cv=none;
	b=1fKI//y+ylcsY10T9fGSutksIxrlVimHuWXV4WztoDq4hTc9fzFEvi463/ZfNIeI+ZN4uo
	vrD2TX8st/6RqMOFJ03mqJGrzVnVMAmunfAMOpwC7LLvncRZeV2tAHoksTah2N3ru8FzqC
	Qke1l35oOep32OHmJ7W9xHr10ZrgTMM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S9873RHW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 447AC43EDA;
	Sat,  1 Nov 2025 18:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EF4C4CEFB;
	Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021243;
	bh=tPpDN39ZJmNW8xL/EnZ9l/LC9JHHUFC5Pgu2gGvkODE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9873RHWW7uv7XCyR9LzUDjbqDMeEfGYpvU15+SUHHYroxynxEdpPSD5v09jmvz3j
	 aYhlJTfu++ETY8+P+/u3etiwe0zaiuDfKD7yjZ8yq/fYP1w20RnuNt0nCArm1cYu0c
	 xf4+3fBTXG5yuUWlrG8j9K7h4CdwGu2cd/8oEBuHfPaQMAj+dPDiYons/irjRS9KSC
	 FOD62F5D6A7WbHAWYYlQlmp63QoAeUWdF/TS1b5C88qOTDI81+Ix5Ou2Ukj0ExOHtd
	 d7pmx+GCnHLlxdMMGxldqSxAZK2VW0XAjYU66qmAcR90/oVla+yuPKlmWJtTbeMy6S
	 p3DBsuqAREXdw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 22/22] mm/damon/tests/core-kunit: remove unused ctx in damon_test_split_regions_of()
Date: Sat,  1 Nov 2025 11:20:16 -0700
Message-ID: <20251101182021.74868-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8708240006
X-Rspamd-Server: rspam02
X-Stat-Signature: o79z79tqhwxucfg5jqpckskb5odmygzu
X-HE-Tag: 1762021243-983215
X-HE-Meta: U2FsdGVkX1/h3AsSYcd9cohtEm3E36B40d+6iSf/Ffp5FIUwRL20fTJSCR6HVu7LJp0ywfHZx38wG+8WYvuMR0RpHqcia6llVgMhvRWE3ORQnMkzQYbqoq2M5SEnDtW1RMwgS5e8PcCW0l6tfFDtEohOjz4rAtsnoR4MgZjIEC5vcMW7s9iDk98Fwt2jhr5S77gPjBRC6u2hzNabmF9/z7WzhroBRkPv1P+6ImX/K3HM9Z6l6k3hI0kGN4FFNZUaaTjufj3MPhM0skQmyEddJRsgh74Ftl0dQgF2+8MI9KZnbyPPqv0SrzDEyD4K/aznacR62bhUS6toyFgQyd7wS5IT7oNw8bl4ZUq6SXyinEfQfom5Kv1dGQXsECkdl4yGDzaMK4/WH5lUxNssRRNy7RkgN+ZA3iuAiDlagsl1jw9wFUbdspCNrX+AJBngclxopZSo7EUJGayTfRXre7B6J9tLBOG4W4FrzMeJrQERGWFmW2E1ye0e2gfdY9i5OA9PNp1wJMoX9hCaAzG8PKQ9SORCVfBAjhNO6Dvldenp2/XO/mWcUeAwFUo6Yq5gEpFYWkZsHhPTwCJxZDJ55SexP3tZkolcpKRGCqDOCOiT5DqJVMB08zFd8sjfbI0iWY+UYLCSpAo7uyqo2JfL7RxNqeb9/ztZkL24mBSMnbEBsd7C8GsVQ9gwlKv7fSFKZN0T5mPTvcsifSwSzOhHV39Bi48uGj/wVfBXP10BkuJN4Ed1RAeAXE7/As7I7IIcguJp8k3ogSWBJ4ceheAuvySNoZK5wuLxk4zPMImmlOQaTctmLdQK8vcC3OZmpbRQn9kx4qDtLfWkAr7L2zD5N9QdCRbkO4fZq4WG4tem4wzQOvzIC+AkjNEQwLZe/6fmlphFPLYnUNT+DqUQ/7fcqON/PcXPalpyzA7nAay9fvloTAlkPTC5NXJDrxPBg8m3ewXaVD5TsB2QaN1hNwoa8p+
 kuvcM5b2
 GHsfXR8K80h2rI8L+WQxEsVTF1nZB7uP5kv2A2a3DjVrvi0GtkufR3pR9+M4L86ZQ49hggxdCytB4Hx22Ky61bnT5SynQVjeULEQcjf8m+krs7NtiOQVu3k0oPmbqA2H8XjIGYpzIwDY80vtWTSv17NElJBWAgbzFGaHwjQ29+B2lhF8TfRkuM4a+5EyDJir7ObXUYv1H0dWzz8N8wDzmA/EaS5fh9Q1vwoDj5Ju1XERrb8YFFjbcabDZDyubwQ9QHIep8zVDxJ5BOTh8Vj7ZLrAKyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_split_regions_of() dynamically allocates a 'struct damon_ctx'
object, but it is not really being used in the code other than handling
the allocation failure and deallocating it at the end of the function.
Remove the unnecessary allocation and deallocation of the object.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 726f593930e7..96a4cd489b39 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -267,20 +267,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
 
 static void damon_test_split_regions_of(struct kunit *test)
 {
-	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
 	struct damon_region *r;
 
-	if (!c)
-		kunit_skip("ctx alloc fail");
 	t = damon_new_target();
-	if (!t) {
-		damon_destroy_ctx(c);
+	if (!t)
 		kunit_skip(test, "target alloc fail");
-	}
 	r = damon_new_region(0, 22);
 	if (!r) {
-		damon_destroy_ctx(c);
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
@@ -290,13 +284,10 @@ static void damon_test_split_regions_of(struct kunit *test)
 	damon_free_target(t);
 
 	t = damon_new_target();
-	if (!t) {
-		damon_destroy_ctx(c);
+	if (!t)
 		kunit_skip(test, "second target alloc fail");
-	}
 	r = damon_new_region(0, 220);
 	if (!r) {
-		damon_destroy_ctx(c);
 		damon_free_target(t);
 		kunit_skip(test, "second region alloc fail");
 	}
@@ -304,7 +295,6 @@ static void damon_test_split_regions_of(struct kunit *test)
 	damon_split_regions_of(t, 4, DAMON_MIN_REGION);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
-	damon_destroy_ctx(c);
 }
 
 static void damon_test_ops_registration(struct kunit *test)
-- 
2.47.3

