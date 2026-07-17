Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 187ACC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330946B00C2; Fri, 17 Jul 2026 13:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A1F6B00C7; Fri, 17 Jul 2026 13:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7486B00CA; Fri, 17 Jul 2026 13:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7E116B00C2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E865CA013C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:57 +0000 (UTC)
X-FDA: 84998515434.13.380B081
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 57121100009
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mndZPh2a;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jhCayPhKdoEPi4hYEuWhN+ktJFpA3DV4gThbyJ2nDA=;
	b=lRP6KyJP9oQfdti7KwtQyPWT2iyip9nGTHzc/nuka455d0X5zIrNiVrIqgeqzfIwFq+Rul
	ToOLMX8ZUa0hR8CDqok0hGvIxsp8sCrBtEgN6AyvgRfxDFhx9F/cBnJ1sU/OX+iq/ACF98
	j+WzNgYAUIOGpoMW5zjPTeDcKamjaqw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mndZPh2a;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298896;
	b=5fmadtVVf+o5aIRD1iTveXLBiae2iy8eBX4j7bWEpvDQMSrAKgYD/EwBOO4tyThxieF8ei
	KcCfBQ6A0vC7nxfuLQJDwa69Il04spaZDJOFKJKy1QGUR3UVIWgq53mToXTDIvZP22f5X1
	JuUs4s7rbZpxEZETF2Q16Dts+TUb2BA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A426A41ACF;
	Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2951F00A3E;
	Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298895;
	bh=+jhCayPhKdoEPi4hYEuWhN+ktJFpA3DV4gThbyJ2nDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mndZPh2aTUGOcNVi3fwU81/mclnJQsIzCc2t/4ib1q5L04yxf1/pEBkgLBHgvDm7w
	 7iRlFpsSgxEjL4DjMxixjgPlnXDNGZgdioe6JtUlujg67bPnVuHa+KgCj9uUZMVSjM
	 kPnC+n6zitVgYGxw3F1jGWbZqlnmemQxoA7g1FIxBZxX7FS9MBdyP1zctfRlgHReqR
	 mGvBqM5IrYquz9rP/d0QvnAMK5LLSdLtw7Bfygy1aU5R8nGvSMKm/60dT1NzoHcC6b
	 6w2J0XFioG9Nql2VbIbqNL9CT2FlMTonxIpkfkFxVJ++SXjGT7yjmcKhKLVqp1+33B
	 lHUWLF2aiIyEA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 6/7] mm/damon/core-kunit: skip wrong quota goal walk in commit_quota_goals()
Date: Fri, 17 Jul 2026 07:34:43 -0700
Message-ID: <20260717143445.91207-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717143445.91207-1-sj@kernel.org>
References: <20260717143445.91207-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57121100009
X-Stat-Signature: r4a7fbucufc66b1p3hsyzicwnq81w8qg
X-HE-Tag: 1784298896-530907
X-HE-Meta: U2FsdGVkX1+5Ventj+jz1I15bZVCQ34CyEhRwruFdcfM7sLNz4WnpXtfCydZd8SWZKLU1TKdmRFjJctkfZY2hpMHA6iWH8W2f04Wi1B66jykgZ/SkO8O96oyg0uP2RcASy/sr+jJlPTAKrdnddyJuwT9SJti0GNCOSe6IAeVXIRV7hKTX8dUIthSF4XaXTVcq0L6XYH8AmfCMF8GtJ1PXlmTECwHzedxFXkNg5UUbtgpB4ZKX73wh4XGuRHoOnZ/HrA0ayLucMgVmhEDDTPPplNwHQbM/hu66dXB2elC8OP9yXQKBR31+IDG+X2X/VZrM9JQ2zhg5OxtD9otaFChWsvCKZnUpyJWtZ4dDWJquhwq1afC88bE9tn3QL06Z+Yv6ctwJ8UeqOrbhoLoCqOL0tnwSCbomD8WyHdhQgb97G7HeJgH6MbuNxZl7SQuWBXFfKLBaO9FmzmUNvVHpLi/ed1JezHWIgOMzkO3MRfXC6nU0AUJuI48eobP4eGqcQvjWFT1We3cbmN0iwJoGm+90gjZmxVIdcEyu328lQMcDDPPdcp+XD2kyqcsHAwg0TeXKenP+JWsVqcScn8mFOEn6PlDHBY/L4U5XXXyR1JWAJ+fWZacnZ8xWPEWyRY5Nm6yYEjKnu92rNVmrgyGp51XrlV7nqFDRJNHrr6inJFeZTJCSRbyqDI9PiqhOwS1lxzHdymOa4zVBhKxWRQEUSNh1RfVzFY5YkG/CyGGJxgUELWZSLX6O9XanmnRhrQuOe239gB2Ck8AhgQf6w9eUqz2EZP3FvW8nS6rDM4rPGy1wilh2q2Ty8bAtYjsAi3yF3RZuPcGeVdrOB3f+OFC7vBurjJRwmhssg9dCIz/Af2s1KgGMhmfjbOqclLe9Y11/Koo7XPlBSAhahnxXE1otKMYDjGsV6qQQJjzyS2E9dJSbFodl4FlqQyWdL79ABkqcDHr2RgoMJvWhumFPIwdoBb
 9Md/OHgZ
 HsGk4RBHN8zChuvNNICdnG5OoLvCymFmBz5CNOSu/JnaBe0SXtWHYNH9OMUSb77Ak3oKvQaQnd8cLdrlfFrMsJ/5yg4osF/qduqMF4eIKzEf/epJaOqN1IiQjQ2ENLb8qq8bTEVecqvIE0FcpSj7Cc9251tuETV3s7F0Cf9qnGetg1gHKWss/62kktBKqhOVOkoDnf8qPIXtkCb1KyPbIczlLm+GVn8pvTJBGWIGZ3QMGI96xgk9Fpd9Jc23K1U+VtsWTXwjIa4nGDHeXL8tqyQftaS4rsIExuFGd
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

