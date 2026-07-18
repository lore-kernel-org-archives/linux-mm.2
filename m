Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 849A5C44516
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9ED06B0101; Fri, 17 Jul 2026 20:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A749C6B0104; Fri, 17 Jul 2026 20:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9637F6B0105; Fri, 17 Jul 2026 20:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8456B0101
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:14:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C72D31402B8
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:49 +0000 (UTC)
X-FDA: 84999976698.24.F2F6B99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3596A80002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bdUsS8ZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333688;
	b=QizTuuREgdnefBiI7WuaTIMOVV48JioxFXtvQbjbCfhpd2VRN9RczJEA43XgM6byYxIoi7
	DuCLEN48Sav+R8hjF84INVbwbbGGHszRzgNB+i0vDI4Efsa50Td/nfwtAxgIh/lQ03IUgq
	GPkLfqJsMtEZXsiXzVexYWN4MT8PKQA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bdUsS8ZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jhCayPhKdoEPi4hYEuWhN+ktJFpA3DV4gThbyJ2nDA=;
	b=lBDvKaKZMCD1fRw3c/D/RQCbcziXrm29efgGkLTMt0WcoAsFa1cjN5LDBNZI8ftFfGvKgl
	X23Wco+Bi3jmyLYcsyS2/lcluR4zJ0LvsMRo6MA5+dhVBNDnHF6u0n6Jsp207SvN/1go14
	o9l6t9KP/+HGWyvSqfeMiWKoJo+ksY8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86D86408F9;
	Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCE41F00A3E;
	Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333687;
	bh=+jhCayPhKdoEPi4hYEuWhN+ktJFpA3DV4gThbyJ2nDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdUsS8ZXnttW3GnYu1ABomdOLnq+jg3jHJG/BCjbz4e748+3cYBwH8weP9YAFgIyR
	 U2pqINgBD41IX6f5UdR20qv0wC/DOPgKXgff1L7470+Stu+Jc/SPTu8SJXP2ADT8pw
	 7uU6q+UBncqf2/DSD5oB03y+AH9dJzznTdQNLNKsFy5Euz+D4cJyPWfFRGaTN9kY91
	 4OCRKPWi+mAHicPo21tfSdOT2FFCmAh0UgnnR+rtGogBG1PuJUMafsYiqK5R3528EU
	 BQ4+6Z+DEorzNYkl2gc9MlfR/WwmasRXOVi9mKN2pJMKwe97lIvzdSB+mcq1xIUv+x
	 6pCYOmjLZgH1A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()
Date: Fri, 17 Jul 2026 17:14:40 -0700
Message-ID: <20260718001442.87129-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718001442.87129-1-sj@kernel.org>
References: <20260718001442.87129-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3596A80002
X-Rspam-User: 
X-Stat-Signature: 4o1fpt88uefu6y3yixkmsgbqp1u144c3
X-Rspamd-Server: rspam03
X-HE-Tag: 1784333688-614153
X-HE-Meta: U2FsdGVkX1+IvihEOdN83ZsCs0Fq0H7Lb0sdK75GdSeTwUm/g2bkZ+8Z9cIVpJWy//anxBd3971EEVIXg3RwSrG9ceWHg1gElDwYJ0l+xpCJa9kAeVeiHDxJsEI+HcqoTyFg3XrXgVbVDUwgjuBJbDFjcLwR6BxS9sBI1pp2HeoXyGS7MmcyYuyoso7uNRSovrhtAC5xnDRavqaX/1iymg7XdFCOb42u0bujmGL1VnRJNhNiz7VuILMdNx/MXl8D8VEpd6O6asmT+rpdsuUbzVw89UFho3IEr4VeUyRnOgZglc/uGLt5lqL19IMPPP7KfpFJJZiLSlFiCsyfQdEYBy8UF5fYRy16EJLAdmxg8Ja5cLy3zM1Xcj7A8cUgCFwuFRCtAT9CR309sLn2g1FWtJX0WKOZz4qargC5AWq1cljSInTW7qgHozWC1hOYjGSpMonYodCPg2ckDJJM16R7MUo0903RBlaqyIlTVajM6dtpY2rGBCLuLPzdZqulo+ukQnez6hQWMGFwDKRZIlET1YKB4gtFkJzOFZ2xBxhlqZV8gEGYne7qdbVMVN6wLQhfUnd368v787RfDdtZsvK1tDQND76j5vihuXy0seSQJauJ7+ERdaAV5JPZRwulGLFo+dqiMww5uHrx5pOzup6fyQRAsxDTtExFZCeRdsIn8RAJwLFrhYAdadfcXlRKpq+R7YouQ7pJkA2ZfKO991eb3OkP5BzSAMtlEvFdHi4ae1F3YfjnJJpOgFxlfI9IQzTzG3Kim0xnIoSEDuwCd5w6GeJcUUH5lIvCBhyqSIz8IYTl3cALFYef+S/IMMLNfrv1VrsVgf7yZu+izrtm+Ba8xsy2M9SQtqmQDFxt0ceG9D7TzdavNIDI1J48MzNU58pGN8iD2JQqrf8muyVgA1lnsbpVbkWzm4xLvR06Tz1zOkBj0WrOoO0prMTCXmB2l1h2BgoiFvEvYiznXOWPYTD
 2lDd7/u6
 Yr4MDAT13ZefjnsQRL9/R93lqcpBgbQfJoNAiVLlEFUvo7DL9tw0G9pkDy5RrpKr6VhMu2kzXzAqZHn4l8+gXPjpq1BZllxOmfG7jObhH4SJ0ty8m2JjC+zpmtqJb6T91HFxPy7TIu8Q7hQ7kwX15DghqwhJzv1jJd6ev53rTNYd6YT2Mm3XO0wQBXU4kX2E+duj3FHFOLJh/Q+7JC0cp+R/hlMV8Ycm5KGGrYSP0sWiAgBpK3L+GOd7U8enpAQi3YTBgvPnnFgf20QQadb/EXvVbM4F69m0akohL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_test_commit_quota_goals_for() traverses damos quota goals after
damos_commit_quota_goals() call.  It assumes damos_commit_quota_goals()
made expected numbers of goals.  It might not.  Because the traversal is
made based on destination struct length, it could do out of bounds
access for source expectation value array.

The consequent user impact (out-of-bound access ) is quite bad.  The
realistic user impact would be limited though.  It would affect only
test run setups.

Fix it by testing if the number of goals was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260713144757.39740-1-sj@kernel.org

Fixes: d9adfb8a28e7 ("mm/damon/tests/core-kunit: add damos_commit_quota_goals() test")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9b8c20a50ad53..fbf986aee2dea 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -839,6 +839,7 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 	struct damos_quota_goal *goal, *next;
 	bool skip = true;
 	int i;
+	int nr_dst = 0, nr_src = 0;
 
 	INIT_LIST_HEAD(&dst.goals);
 	INIT_LIST_HEAD(&src.goals);
@@ -861,6 +862,14 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
 
 	damos_commit_quota_goals(&dst, &src);
 
+	damos_for_each_quota_goal(goal, &dst)
+		nr_dst++;
+	damos_for_each_quota_goal(goal, &src)
+		nr_src++;
+	KUNIT_EXPECT_EQ(test, nr_dst, nr_src);
+	if (nr_dst != nr_src)
+		goto out;
+
 	i = 0;
 	damos_for_each_quota_goal(goal, (&dst)) {
 		KUNIT_EXPECT_EQ(test, goal->metric, src_goals[i].metric);
-- 
2.47.3

