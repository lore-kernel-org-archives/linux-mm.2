Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 284FCE9D809
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85C06B00A3; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5CF46B00A5; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72E86B00A6; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 970996B00A3
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58BA413C05C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:42 +0000 (UTC)
X-FDA: 84624844164.22.AF32FCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A22051A000C
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eD82keew;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rdaam9BwVxK+HQPMM/xSyzd71ZxUQuLXDJfRzSuG9c=;
	b=B/mjMx6D1YLEnbMSIfEsRfZ5Aa1XIqZWWG5w9a7RDehsI4Vi4+usZsN7OgsUh33+Sw/JqY
	6fQ6WebeNWHdwNgLUMlz+pZIgC/4Q30CKsQOH8f8LVLxKwUb0iq45ukz0ubAoJj8PX/so2
	7GGVdt3krSr6SUhn5D9EamSTP1u5Irc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eD82keew;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401960; a=rsa-sha256;
	cv=none;
	b=ejmfZUcnZO1OaQWpgYcyhths42q9LwxDBejCGyA1EPiLlx/7wp98TENDghPUnHsy0mNZ3u
	y0MeTTkvDOGJyHXLHhzDYPCnRZhCevFLtXdtAe++0aR7w0hdKnb88oCqHtZBqH0lJ6nynt
	Tt9wGrqhZDvsonfGzcYwTwSREhIeEb8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C918D44544;
	Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6509AC2BC9E;
	Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401959;
	bh=oBXW5uIN8lzshHczxlHFHeX8VLmiX/5T2Hz8N+WZ/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eD82keewiduJmKNLZkUPSOij2QOxI9toUc2chAgEsod36Q3LIs7GT0+v/U3jGdX4b
	 VokqFJL5gjG74PhVbRkTNZWHkZ5ejFixOhY+Z5HbNs2SO7qyH91QcE8xK18w34ylfA
	 E339PY7luvs4xCHiLWfnGNzohUgOJ4Fl6PXZSM79VH5JmQUGf1E52icWaDVZpeMjN5
	 6S8nPmysv+3lT+ghnqKgXUrdrkUZj/mmPyO8AvGOqQYVWe4b956LduKbdgwP7W62JK
	 abG600lmYNzTDOm8NhXWNhluvlCw5wX8NhzRJIJDYWPI45xO/XRHPn8OH1Rsow3pZd
	 0Ssy39EBcA90g==
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
Subject: [RFC PATCH v2 6/9] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Sun,  5 Apr 2026 08:12:24 -0700
Message-ID: <20260405151232.102690-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A22051A000C
X-Stat-Signature: gdbtbbohz7xi94d6ofqw45ap993ipooy
X-Rspam-User: 
X-HE-Tag: 1775401960-49627
X-HE-Meta: U2FsdGVkX1+859zhefzHeFDf/tyWN/80n1mZ/c0V75w5sLotluc2vaUYXTohA8n3/7ncVmy8fsulNG0AAv0Dl87OKI2NpzsYJfTddywW7S4uJZgtPNb0kHkxeSxy2IwdQgqmD5BUHxmHHN3iFsQV+hOiWp3GuJdzgbNt7Y+dfmIoyTdhUUswCHxVStOnWbbVvY/nlZJIPiIySNw8PQCP3uSidf1y+zklfLbhULO0TWdS2P7NykJMgcalAi2FJfDOJf36MzwYx7pawpLreWcCgIk8Pm0rTsLQkr5qtXEX/ca8+qbJd7Q2YPQAQLSyGoTTGomGs7FqbY60AurAe1P81kID+d8E47WbwEyWvKuwYWS76L1k98J4S+B96oV3e2nrnidfB05WBnjUa8hLbHX9pra8JlI7TsMhlFKgqzM5Tc/P/s/t6Crzgh++AboaJazMvRVwmOBpWM+Jd4ZGtwO/dnWbAMmQLtQMnaxVgGlmnb3hYqpTNu0WhdUoNy1Mqe+XM1cvkpbDulppb56ONFjr32A/xbxOTTLa9b5sGL/Te1vaBRYEHs8Qt6x98uDWvScHTww/HiDNrmNvL45z+5FaGXLY3Cejy6ZsQYgzLb+4zBYHhW4KUSuNT2oPnHlNu/KE+w1Uc6Hf82bPijpoWnYb2JBb9ksRU7nzblTAef3H5QAyHy98AoDWmeZytu3Zsa0l7clmPFVKsP/SWbrABXaSPxN3YQfsBeJZMLdlgqQWk8lQdeQ4JkRT9EZaWZ33U3zszg2TQKcUMsbZqz65/FuIx8keQSKPNrJUxk21TpHohSzlN76ki8yAPNH6q2swFC3mDEdXZQgrHDq4JSKS/Q36OW82rrWCrsukgEz0Z3JP26Iljzelt0y732GnfyqqIzx43Wy20ehw//+Rn2VR5rQroIHuSLLgDtsm5w8sY4nvH1YW7f6A0wYjIybDJZ+SXxVEHpIxQ1VZaLdTEhpCw3s
 WtkCXYj8
 hpNl6Nhv2BeJu7GsktB95yUN4paP7SqC7+Etp0fNOI8rLXRJkMl+yRwQRN+DDZ5sU6aaDmijiPB/7cXcik/EU2+MVqwshIEWYJB3XJAn2tWEu2mPeWLM8N2ssYzmWXxHm/QoGN6O8z0d8gLtjpr08PZizEI7R+vr8p1ut1nSULr5rRuoSZa0LTzNHLcl944lYOS0F8farLPP3gxg1rPia1kN2C4Tzb1zZcHUExwxXfWPIzL+dBOkovFob76uy94T7RyImanDc1G8y6FqwuiLBSBsUzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_test_commit_quotas() kunit test to ensure
damos_commit_quota() handles fail_charge_{num,denom} parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0030f682b23b7..1b23a22ac04c4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -694,6 +694,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 2,
 		.sz = 3,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.fail_charge_num = 2,
+		.fail_charge_denom = 3,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -703,6 +705,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 8,
 		.sz = 9,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.fail_charge_num = 1,
+		.fail_charge_denom = 1024,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
 	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, src.fail_charge_num);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, src.fail_charge_denom);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

