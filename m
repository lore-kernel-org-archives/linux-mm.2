Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE12C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003CA6B00A6; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96F76B00A8; Tue, 30 Jun 2026 00:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75056B00AA; Tue, 30 Jun 2026 00:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1EE6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A39C5166DA6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:26 +0000 (UTC)
X-FDA: 84935247012.02.4931B82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 11AB940007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IbfmI2ii;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792505;
	b=j6QxbJDrMINr/KSj9g1VGQzOvWHw59t69zKcNtnZE+ObmBydpK806m+e1vyGzrs4efAl9N
	/p1zRxt+2LXBYZncfQ2sOENxKQEPV+ZTBG7D+byOQ8mxGCNR1QhIHtZJfvuMgofkLuGs+1
	gCoDs8BSbgblYzov1+amE+OBXwM4EwE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GC3wyUkKm2lBSXyC75E/pWZjQqr+3L3eUEF2Xn7YLI=;
	b=eQB1gEdkgkrzaWVU5anxUPwp7NqUSAmWk/kHiGgSePddeUDqH5WfXcv8VWBy7LKnPTaXwS
	/8XWIhSVyVnZq6kohRS+ID5rJl/tpzgOY+6LIhhmiTrFNZfUM/7h8GnLbExj2BYaEK74+J
	Bu+6qii9zHGtJSVAnKQ9ipojneRjvVE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IbfmI2ii;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1EBA600BB;
	Tue, 30 Jun 2026 04:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AC41F00A3D;
	Tue, 30 Jun 2026 04:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792504;
	bh=8GC3wyUkKm2lBSXyC75E/pWZjQqr+3L3eUEF2Xn7YLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbfmI2iiyt4NEusU5XXmPmaAf23CVDfD5ij+jZNxdxrzC62RThcIfkwmnk1MCh3bC
	 1JW7MVu+3TNElaw9LYdiWH4WiQgdEl3r4iNZvuPK3KyG8yAvVtxYCCFcAChKn8qJjZ
	 DG94BswKjRjr1jqmqV1aXsMK/+aSyVTTgSN9qqqqy+zirZ1sSZKMeaZfe+0CKOhWR4
	 uMta/hBhs2s42SIMj/hNpk766h2TSuvdGFlgDz5SnQPxcKkTPQRd6WHvO22Sll13gS
	 cDRn2Cg20r3FT4r8J3scMb/LfDkOOJ1Oy9pFglG/aGUN880s4Kq1urDoNjH+wBWFCW
	 XS9r584calg0w==
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
Subject: [PATCH 02/18] mm/damon/tests/core-kunit: test damon_mvsum()
Date: Mon, 29 Jun 2026 21:07:55 -0700
Message-ID: <20260630040812.149729-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 11AB940007
X-Rspam-User: 
X-Stat-Signature: b167c686gpw56py3y3knzoggjq31apci
X-HE-Tag: 1782792504-29845
X-HE-Meta: U2FsdGVkX1/+DcIdJTrMLmPauDopqcOvIgysfaUbmIMQrFA8mTLXuofXqYMYPBboSPWKDHM/HH3VQiLWRPA/MoqhGrKCFKnvKlefW+HlLLmuK0L2q/2AYXcP6pVjAHPL5JpMrZj3gdm4keK6X21h3IXyAsJsD3tMXpK6d75/UdfuIx9TODqARzOwD6tE4LquqEYEolAOCpSVlMnwE4hs6yFKl7jibrNWDCPlarndE+uX0KSH75l+L7ewRiv7o3dDgU1E9/Jv8CuJ0X3rZB3jk+4Qltro7ABIwqE+acdyDJVn7A0sghkQGFleBibYZPYCVr5RGSQwNEUaFat94IlrmqrIFlzx+GLzKouMYwlXaUFtFjKbYbW+0avfZbwRPs6yTzJLgwQqohGZVVcMXhxHlGlyW1EgRXUs2t/05VzrilpURlWpFeGXtpJj+diaropMxkhCjJntHmAjQzmqn9Bwlb3un/1S8LhvYmq9L9elaXwQKzLQelciU3xE4Ji5XT46PODbUm34u2AHbazWlOUq7UXfNm+XRoVo4jGPSBs78+8E3Urp7gDW55km0rNRkcILxZQjCM1C5609X6fueYx76QcSoKSa+QGfeN5kFbvU1iEh4/k9zmi45UAfGyhFBz0E0/ua+G/g8x9Pt3S/4J2X2gnRX2T8IKvY9eF/tdwNi617Hh5u7K+QZLaWOMXeQgjP0lvsR1RVZRNX6Sd+TsK+Iln/YuLptjSuepCiWEzbG6oOq7mbLzkMSuzVuqzy2CK+0CupMe6jT0b3dzhXBOAT1aOQSYfOGjF5WQ8jDOLs20MHZrYUawTS+JikbhXm80zzogcWHw6/765rxddGitR/4/H3Fx66VEU9Dmiyx+P/D/KnvoPJugs1PNpUx/b1scTdSV+YDsvGDID86tpcFzprC8optGbjb5M7XwV0QTGkH9GVS94Eaq0CXffOxotZoodI6w3b1goAf88U0uaXzv8
 qTxRm7cx
 VHlx1lk2cHEdGFUA1QB2xpR96FJasi2VK7MIu5rKwmi4E3CaYKIA2uHd/+QLfnURTgbVfrZmGi5FeXaZOQsvDJdwypO4SwNLll7cZWy8jqGDrL3YBjICQ47kSXc1wdeUkEkOaQTTmyOWU00sst6B9vLsQnec2DvdAQFFxWRteyJVp3GO6vCVYZ1lDbTVVIQ8lldPg0tHxlXS8aaGyebmUqXYLM+Ney+Ohs5MAuehgSk+CDeO5J9GqqZ6xHXWXOCBCLRByJIu2EjP/EhCbtWIs8a0dlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple unit test for damon_nr_accesses_mvsum()'s internal core
logic, damon_mvsum().  The test contains cases for just-started windows,
partially completed windows, and just-completed windows.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a00168730445d..ff13d1b1cbc94 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -682,6 +682,30 @@ static void damon_test_moving_sum(struct kunit *test)
 	}
 }
 
+static void damon_test_mvsum(struct kunit *test)
+{
+	unsigned long input_expects[] = {
+		/* current value, last value, remaining window (bp) */
+		0, 49, 10000, 49,	/* 0 + 49 * 1 */
+		3, 10, 7000, 10,	/* 3 + 10 * 0.7 */
+		3, 10, 5000, 8,		/* 3 + 10 * 0.5 */
+		32, 100, 1000, 42,	/* 32 + 100 * 0.1 */
+		42, 49, 0, 42,		/* 42 + 49 * 0 */
+	};
+
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(input_expects); i += 4) {
+		unsigned long current_nr = input_expects[i];
+		unsigned long last_nr = input_expects[i + 1];
+		unsigned long left_window_bp = input_expects[i + 2];
+		unsigned long expect = input_expects[i + 3];
+
+		KUNIT_EXPECT_EQ(test, damon_mvsum(current_nr, last_nr,
+					left_window_bp), expect);
+	}
+}
+
 static void damos_test_new_filter(struct kunit *test)
 {
 	struct damos_filter *filter;
@@ -1561,6 +1585,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
+	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
-- 
2.47.3

