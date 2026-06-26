Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E2ECDE00C
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97EC6B00E1; Thu, 25 Jun 2026 20:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49786B00E2; Thu, 25 Jun 2026 20:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38616B00E3; Thu, 25 Jun 2026 20:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8D626B00E1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FB6C1A02BA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:06 +0000 (UTC)
X-FDA: 84920148852.28.3B3F4D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8DEDA140002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJrhdGvj;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433024;
	b=eq8VDdgHZkbrsQCRMfUKwn3fG9uyQa9aoEjtfLqfU4MuYofGGrBz/RAQYNwLQrXBAcGLWT
	ZoMulYnhviAI8fxSJQADHlr5/kxlQwgYUSvv7DBRVW1Z3vl9KCRezKyPba130klfWQs1gl
	WqidY22X2T8fByigWgK4ufJNwbFhiJw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dKSzklg/iygza9/Q9kj3LGtbFghgmmhxZCw/eIqgzY=;
	b=l1XWpjUXB9l9+VdGX1xp4Ix3GlQEETTKJxQt4zYrV/jj90BEftAlFGI11JCk3yvnscDLU5
	G5WF17aRa3+uCdu0ERqzSkGFsl9DoMqIe+zhtuf2cO3Xv28gq8kZD/QNb/g8z4voX+J/nF
	bkixpUgspO4lo1/uOBUppETXbEaMg1k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJrhdGvj;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC44A443B8;
	Fri, 26 Jun 2026 00:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500C41F00A3D;
	Fri, 26 Jun 2026 00:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433023;
	bh=2dKSzklg/iygza9/Q9kj3LGtbFghgmmhxZCw/eIqgzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJrhdGvj3mMyAr45edesRy1s4UQtEBtCTDY+FxTtS3/BZvgzvKbVfPO5j7rbT2ttW
	 6RBc88u+FgIP9uty5oDQoJC1WMR4oyCLPqhS08snJ6mLTyVg67Bep2DImBhgT+7NXa
	 Gaz0ER4ZTKIEfDsMa4ZgF+1+pbV57yMYo8ow8/bu0EsCHPUepKy37hwW+50u00Z6TX
	 k3KsVyVtO1yVrZgh+91FXpEFG1uVYN5lVRgP4tz37xE3inWOeaKL27mERGckxogk9d
	 xzG7e3wR3SErovAc2l/MKG0PXiyfUTPXTX3LEFV2PSJeTWO5/Gza9dl6YpQ2yjOZZV
	 QG8npMF+HiDRg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 03/11] mm/damon/tests/core-kunit: test damon_rand()
Date: Thu, 25 Jun 2026 17:16:34 -0700
Message-ID: <20260626001644.85825-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8DEDA140002
X-Rspam-User: 
X-Stat-Signature: 7k136k1ykf3upj7otmoxyjtp7pnekwsk
X-HE-Tag: 1782433024-327324
X-HE-Meta: U2FsdGVkX18JD0eLCfv6gGmOmcIn4A1jbhLIZhmWbIeV+0Z3XE4tubdbcPKtiRvjoLJqpFeSyzoYGkRcg+pKfFnXjrcYBTva3zx7r77CYV+0ATPqwi9pwcDX4DiBmgn4TD4Sz7cdTsZceVazrpqlxdkzc7T9k/JoWRizaZLueA9cIj7QYOY8gcQkuOI2t40g1oiWPtOu5j5CG73AyuxjzKG/Skg5/4YkqPzggBGuB2gGF6iucqBGQBjKF+m9i85PXLc13lRux99kIPs6sVBrGfk87V0zYTTPuRVb1TE/91xttRJYlkL3gXdRMiWPJad3hsaTmg/seH/qVa5zDXmm+SgHzTZ8gyeGeRgaO4kwavinJTtsgwDU6ustHh3OmHV9mibKlpcMNIrFofaepWpg7bS4Hi9uZdcEexqYrjhmfi3yVWdYB4wqwIucOl2y/J8lJwtiVlMSOVLAFu93IGg/6TyIcSWMQ1vDnKQ1Jl09gtI6yVbsfNjW6HFaSyuKA+FgZJW4dOEWDOroA799AEAo3UFYew08e7XSXzDZNtmUbviAh/41+mbI2MTMCit7mBnnktqC/U1JxHPXWEbj54NGKA7AUfGltuhvZxqzhTgZDhLIyYyWdFK7vIFn4ZumPwbOHGUoyAzUFhc63cIy8htnSdEu6W25SCUlYikOB7qXyzR8Clp/5jSBfEmGRl03vWcCrrPhv8lxxpkniwOxLamjpVATH1S5I/Zi1y8QXoZNItAQYYkJSvTOcJi/a5BgM6wZfoTWTZCk1GAsjCRESm7aeB6qfJpnqovwkh7t//u+1X7JfTub7WHF2WuE89awmEoyouzJGYup/UAzqqpBGP2AO6WK+MEWfdqkB674xOmh6OVHUj7LBmgFEzPChGFjE0Zn0pXejxz44vR4Pu+QWhzQbmMwIP7zLtMtSx/2jk5+l3PIlRYpOfOZ+BFrW1G8FjFnUW93z6ndR4C5qzrbW8M
 VuBa8Jsd
 Rg5rUmWyy3BizjY6r9GyH2BuH1o0x9dvmDU0C/qCkGDo14ZsnCGY0WylVclmWGW7RSmfX8cG4Ujc0mACP+V2vcHr7U6N3nzLpr+BjFJP0kJdqizt3dZK6H0r+e/fpz1noE+Q4ljAVp2py8/rgFGxS+DMI2wiptpH4mai8xAl+20OsUtkRCjjGA1NgMzGoCUQPkS7ML/XZgSOXpaWvFsXn+6eP3LWkvHyyE/qYZ8wfllD+wVsBVK/jdFBhIS/C8hXhOfdjWi6P338FtNmO5z/H2A8s4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9012c4e647df ("mm/damon: replace damon_rand() with a per-ctx
lockless PRNG") optimized DAMON for better performance.  Add a kunit
test for ensuring the bounds of the output.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 1cfb8c176b873..282670b0fa908 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1460,6 +1460,20 @@ static void damon_test_is_last_region(struct kunit *test)
 	damon_free_target(t);
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
@@ -1489,6 +1503,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	KUNIT_CASE(damon_test_is_last_region),
+	KUNIT_CASE(damon_test_rand),
 	{},
 };
 
-- 
2.47.3

