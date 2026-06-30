Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15BEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903CB6B00D6; Tue, 30 Jun 2026 10:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C9B6B00D7; Tue, 30 Jun 2026 10:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755216B00D8; Tue, 30 Jun 2026 10:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45E6E6B00D6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9617120524
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:42 +0000 (UTC)
X-FDA: 84936782364.19.E43240A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1C40D100011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6y75598;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829061;
	b=7RXr7DOJeeu98pKqeYlee1VEYPtXaoHK0jn+eQiX+Fx4edQtSS4jn6bwCo8knRAd9c1skC
	iaO0CjGOvLXYSSQlRNadQWFEvEkD5Tn7+1xtj104yIzDp6O+QhmpbRWgR5ePB9e6TYeCER
	fv/e1PHJntWTh0GuexGgkUCVkQg4QNo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uS6dozko2yZPUVNoFA79ufpLiFmvL+C2qUOX4NrXFs=;
	b=XY6Fo1/lqIMNo9xIUK199FQAKUXiKgf/DmyOwE/mmnHGvK+N/ThJZY15/HngkQMD7CUx7j
	tuTdbK7XJ52GYLgajZZFJY1ZhEUUOr7t7qaT2uxf1QMHQnWwKYGaIrBtmvWGGCVfgEz5qD
	SHD1lSmT16PJrIxQ+NlbP16jO/mz+Jo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6y75598;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B74943CFE;
	Tue, 30 Jun 2026 14:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3371F00A3A;
	Tue, 30 Jun 2026 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829060;
	bh=2uS6dozko2yZPUVNoFA79ufpLiFmvL+C2qUOX4NrXFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6y75598emWFv7MuquKR3xnTvI5bWm5OwWmd1cKX6WS/8PTsllnL5LZuUhTEMgKal
	 O0yGoQwcKRjp8V1+meDk3bf4ht4oiCY1RJ0guY4NEMcS3jef1Fp+OVmEkPK9Xnx4UP
	 uGIKOrc8oPLh5dSgKHdo50VgaNwRymnp28/Ai9Pilo/xnj/e4bwyekzTUNr/eNqpUz
	 V/cN044WEmjwN+9s6lAGYBlTOj8iMSStzNTUp10tqWvYyJ+GsSKs5LNg/F+0gdsdlA
	 2J6deVAtXsXkmpanniBCqVvNr00O6TAoqVvTfZQGCm/w/wWNwUA3mjFxNVbNvLLRc9
	 PBrUw8XoMYqLQ==
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
Subject: [PATCH 03/11] mm/damon/tests/core-kunit: test damon_rand()
Date: Tue, 30 Jun 2026 07:17:17 -0700
Message-ID: <20260630141726.92246-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C40D100011
X-Stat-Signature: j9u3ymao4h8iob1psqweccph4piewxk6
X-HE-Tag: 1782829060-122205
X-HE-Meta: U2FsdGVkX18lErWcGkrcsUQm6/hIDz3kexnRQSxHjAjJ5/1yInk2Ydraeg954f88yAwZDWdcBz4Y+l5Wrl1ERRxJVwBb7ZH8fukAZ4OX+XtFdWJb7/wkNTb1DQfRpR/gUtXpwm6EL0aOgMzTmK3AjHQFSzSQ+zXgtfaod6wrtyGhu9Zzlkw2ONoVLRuG9yBe1tEC2CxWr67YAvr6vWMb/E+I9BHpad/OQlBg+UOPbP9T/y4YR3TUoY2ZZ0+9t/BuLWu0fLMJSK24bMi+zLZa3hA9XfgoWThO512qOFazJrZZY4CjeBo/FJutuHFiVejL46PC08ifP/dus0H9FkM9Ko6aKU/fd8aVZBcYgsQepy9B/6qOX6w2UiW2d/kclJ7W0BIl0Nz5g/V0Zmki3ExP0Hh+gDUzJVpjqTrfsjFzn89wKVju7qfs3rvgYIf0KIkzfss4hcD/oDQUV/DziLlZJcADxV7687mIG5J0ES3dqdwsXo6NdOsU3A1+yCJVk1fFCBdMBOT8akKOsNGKhJtJ6tHd+AidbOgmFSs5gQgphg3nxMCsaiQqNwnGBliR6tJ/rvntxQFVsXsUXOPecti6hXhN4JWQNOLspKk4htJoReiSMoc/x8WV8c/B/TfiWOLIt6WaC+VQ3gHEOJ/0XJcOhBU65GGVh04X7gXquk0yD9QdkjrpBpJ48NG3S1K6JbDHxXa8ETJnpNFf5Nl1rR4YkK7QYnvz6HcZPYgDTbfs+/VpdB1fP6kjAyfvvZqvISc5rM5pOQcjWiyXkUcl3F4/LVLbJZta/gtu3qmWpjVJCBC9Uavs7L4y6ImVB2cb7szOix//T67HIrJmNQXdrLQxmpSzNciToSJ8WVDn7A/oW2511R08YtE8xvQAQFDFSGrPBDgUQJUej2oyD9ftMeeUEEZVN18CWSPAgXRggNiVSNX0tRI1M3ExYykVYS3y5etYlVPi9DcY52RgKz22BQw
 cJU1AoOd
 pkH1OPw7xEPTWVrCftSmzmOa5BFdDHrnHuSjpJEqnL+m+XKCVjVAVs2AlfB5ZbUWufLp/ZWYEuuwaH1nrOHoqP4FUx43u5bvlAu7DWkSERv1D4Ipf9qE46c5bvtzZiVkryv4nFhOLbdgONaJKN4wR/46/f/f6iZpbwbE7IcEBFWilIfo37yboaKTjLhPJbfUDQ7fWlzoyqVX+0aVSP3ykxOkzYsuP9ET+VVOLhrbmt3khS5/l+xtSnX0NqYxZH7qDMdciwN1X3E4XJHgMBi3J7h4WOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9012c4e647df ("mm/damon: replace damon_rand() with a per-ctx
lockless PRNG") optimized DAMON for better performance.  Add a kunit
test for ensuring the bounds of the output.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index aef7e0553cba4..0124f83b39b83 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1547,6 +1547,20 @@ static void damon_test_walk_control_obsolete(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+static void damon_test_rand(struct kunit *test)
+{
+	struct damon_ctx ctx;
+	int i;
+
+	prandom_seed_state(&ctx.rnd_state, get_random_u64());
+	for (i = 0; i < 10000; i++) {
+		unsigned long rnd = damon_rand(&ctx, 0, 10);
+
+		KUNIT_EXPECT_GE(test, rnd, 0);
+		KUNIT_EXPECT_LE(test, rnd, 9);
+	}
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1578,6 +1592,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
+	KUNIT_CASE(damon_test_rand),
 	{},
 };
 
-- 
2.47.3

