Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76960CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215816B0093; Fri, 19 Jun 2026 15:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6AC6B0095; Fri, 19 Jun 2026 15:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC686B0096; Fri, 19 Jun 2026 15:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1EA56B0093
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47252A045A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:34 +0000 (UTC)
X-FDA: 84897664068.11.D9CFB9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E31A14000D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWBCCwIp;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGqKzRnIP+DKXc/Th2v0SJe+T3xtV4bAe2ASi7qsS9Q=;
	b=j45pRNvZ/kv/Z++3Ze+7aoA1MLq86EppC+OSiNodWjbbl7rvy5RErjeifVSj5q2LC2qxhL
	D1vQJJb73KEeO07kzZdoOX9jfDg5EHO7UuzwxjOfMarnfF1CW10FCXz7XOdCyaOnylEY4A
	2x0qAi03VTLpI/nigS8vhoNHVDWGks0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWBCCwIp;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897672;
	b=nvfvvKT3yfg4oqy/gqUybLjjPU5x1zS2pFMJVkjrpK2Z4wBgUXgvvTKjvCthcpmRJKmWQB
	4rnwvf+V4+2Jk5Cu1aTK3lUVHCCkqUefFw9QjRbWME8m5ZBrrVCdWmjseLZ69UCgJjHuvz
	8nC9vm3eToi/5MW+tyT+CnfJY+jMTFQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B088F43510;
	Fri, 19 Jun 2026 19:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50541F00A3A;
	Fri, 19 Jun 2026 19:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897671;
	bh=dGqKzRnIP+DKXc/Th2v0SJe+T3xtV4bAe2ASi7qsS9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWBCCwIpN9s2oD7RD8XxYXNLw/MPorDIdy9e0/hPw27TaA/xDOXw0jSzNgdHCFVw9
	 Hg8VTnQnHpZqXGkJwyYBT4PBKg4HSaStzm5xlshkTs2kqnK0uaH1MCfto0OPwEt8AG
	 X3VKaccakv+TtNQ6LwJkLMLqUkrAUTKSIi4WrY5di5CD8+TXc+8CM4iD8IeIZK7DfG
	 in2c4Y9LFDz8oUr9S17F6E90mx7IYCuemwzBeoaV3qqfNFAWnq+m4jmwGGCx4d6H0m
	 DSOV8aCQIuiDGgn1d50MBgPJcnyFee6ASVkS3SmLBbeCOrtGi7Rz/50jhGxn7zqZWb
	 jJb/6y8MyipaQ==
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
Subject: [RFC PATCH 02/13] mm/damon/tests/core-kunit: test damon_mvsum()
Date: Fri, 19 Jun 2026 12:33:47 -0700
Message-ID: <20260619193415.73833-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9E31A14000D
X-Stat-Signature: msx813i5h7ckxqbka3o9amikzx9ia114
X-HE-Tag: 1781897672-4679
X-HE-Meta: U2FsdGVkX19BAH2wEWM7z0NRmuPwHB/yQI8oL4PCvPydqEO6h11lGmGdl29lZJMJTZxwjRy0+BPqvclRTlUTWDd88nDhIGuP2Clb1S2lJdFteOD7792inKNH4Hq0ncpBU7TsjWYMZ8RIEPo1bAtt8IMYI2LABi7n3uhN2XQ28gbS9jeRMEoPUAZ152S9M3CGjHOCi4TGPNOCGl3fOMrV8S0y8XvLoTL7W7aDnzyGGuGem0Do+9Y7GvzYqlS+1mmEUDfHOje8xeiic9om55ETAcBJ6wLgUdZO4J6qt5Jyt4Obzz9bDkdeD4WHtCmvTBI9kqz6UDCgyU5Blj/2KTIVReOqC53WZAxVHB6/SKDbfKVfJ7zxTDOKE6kreb9Q9TqnwhQ4lAFhc3cjKA2Z/zBPlNivgQINKSVAwHxVV21gTyeJfV/YU+OvSA8/JQE2DjwSNfb9ItallukcKhRsodlCE01d8sFQAjBowpvcPq40rMCDLHRhynbZbSVHo+PBGt2EJQflx/nN013dJg0JHRp2PPg6VDtu848Own1SC2WO+9xCJRvcDoE+ZZHFL3Uni4IftNnCfimp3up63cp2C0BBRf/VhARo69+T9hd6oFk8iyqAhSlcADGbvt3MPXpxTGaL71gUqxUsW4F6rrH4fVZwt/dye9j5LCYallVisQXpvcCLQ9ZF/91k74kNus7hAitk62Zkty6EKnocX2HmxVwmcO7WOQuaN7LdEt6XxX9GPJVTMraJFqDcHdH+DG+W8tm7S49O+l6ZRXq+vrUr6sQdmsKlOFZ/8rXv78YERo5UPgifB2ENL9VwGLKqqdCASWgW4w2Tzy+mmL47QqL3ALcEEXV4H4bHDci/MwROOlmuDKZNMexa+PTy46qjH5tfTuYcozsR5oUWe2ZOYghB6kOIZpSNTl3znGzeYmg0G5dChW5z/t3qTB2JMtMU+qD2IEAZKoTApqnoZwlBm05+QdQ
 hPC9G+vn
 On6h2BhDUokk9TuAh2xDmkxxGY1lOGaU8UIRHBEazQNvTSTUEzmqlv0Da/3N78iXUCjM/HJ5BHqDCrcmWVFYSb5oCNWmWR2SS3w6DHBcZ6G+JD+KzrppSrBK0Bduu3MAxYV82D8c+tDgVGTlyDLVt1tU3cJ4f8tTTPUDsjAWnweZoPU2L1Jkj6JxrZVh5IDvb9eqdp/pCQWi8kp4wXV77fm/qfLxE33wQS5XiB9VWiuxHUeKMhEm/IuD39i4U3el7T4AiKWEO7ra5bC5PT3IA5dAF5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple unit test for damon_nr_accesses_mvsum()'s internal core
logic, damon_mvsum().  The test contains cases for just-started windows,
partially completed windows, and just-completed windows.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4e448c08c724a..cdab14396250f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -623,6 +623,30 @@ static void damon_test_moving_sum(struct kunit *test)
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
@@ -1501,6 +1525,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
+	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
-- 
2.47.3

