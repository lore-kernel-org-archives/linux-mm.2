Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C64BCD13CF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5570F8E0011; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D058E001B; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91F88E0011; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 962918E0016
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43949862EF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:32 +0000 (UTC)
X-FDA: 84099201984.13.8CDAF94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A42B240009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rj81mmns;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886670; a=rsa-sha256;
	cv=none;
	b=1XzuyMaHcwm0b6eLgcbmT0J/ZEmGay31fJwiyYBL//brklHebWf7wtLosTNW5oexnmfSxy
	mW7XlNrACpOuWv8Xv5Y9s5Lx9A7yPCdA7xNQ/z3R/PlXUfQhLNkC3EiqdteO4s5q1lcABT
	5c3HnVQ0GZ6LCW/ouwiZT00C8pblEIc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rj81mmns;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8KOwUqj586MtnKMIcrLakL6oDVeeP0SF56oad2SoxQ=;
	b=D5jk+QYumgaBdmkdBehXsHRQVYyonke1r9cx06oGu3fcDf7j/OLdfv2BgT/0XKeIBkfRpZ
	+K37hJLQuyoJKRBuKscwmJzpmUtC5U4IwTBttJyvKeKfEe3bnLAcVJtHulSzMcOTx0SKqH
	Ph5EsWBySfpz2szARHj8xt2phgEZNvM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3591446E9;
	Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B436AC2BCB1;
	Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886668;
	bh=5hPS/JRy01yuhaxPekjxyV4N7WLnupymMnfSho8r7YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rj81mmnsTq9QoQJciglj+bJbWGeRJMX1Z8c3nXxw5O866+6jzgG4D0x1bG/s/cn6t
	 Wm0mjoiaPhVNsS3s2lED/trYsAAYtzb3wqopG5VmmZ4K1TPEwrWC+sXxv7sfN7wQpm
	 3jPPoH0C2v8/27DKJTnnFYbiQoq25aOahjNWIRfHE0y4s0dHjAYQdH+651u1ARpvR2
	 V2QRm7lKBebdCZvRnz+600iCpaBS94DRjlRxAm86QubX5E9PQh95Yni4JVMDB+uYhq
	 76qP//eUUWQVLd1sBWkr9wxUDZqVr81muia0rWg/4VRdvg7XwFY4wGDoAeL/00hp6n
	 9CaqyCsyW7C9g==
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
Subject: [PATCH 07/11] mm/damon/tests/core-kunit: add damos_commit_quota() test
Date: Tue, 11 Nov 2025 10:44:06 -0800
Message-ID: <20251111184415.141757-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A42B240009
X-Stat-Signature: 7ejgqffziy6y38z1z61pe6q81ihhypg4
X-Rspam-User: 
X-HE-Tag: 1762886670-804598
X-HE-Meta: U2FsdGVkX19VDf/bYNKBdxuIzIGY1sv6piJjNh+jXnT5y/2HKDTSeQ960G0toJVNWhliN0KOP/NkvHRx6T/YuJ0lEiOY9MdzLZBRETBsio3KMTyifLiM5cneqJZAmqrUp7Itn+v2OBV8Q6XswFQksuf8U3+nb3BSFj1BCvr5HKa3o4wwcBkObUj8TSVZCTAp+FEO9IiOp+gMFdl4kmN3ydKO6/A71epVuB1RyKlr/iKmYwNP08kMdxr+Cu7DXKgo+ECJcjIIH5Ybc8kfPOkDNUUFAAso49V2leMcOLwQl9nIN8lU6GBC8b3EwPi352yTiArsS7RTN+YgnxyaFu7d8UavwDeRitxtDwBi8bTFeHw+SaTx9D+wG7jkf386cNhO9DZfLMZNJaBg+oX9ubR/uBozrELwiOZTDEC18Z/4c2tgkMaY4jT1odod4NrUVrK7siG0p3am6pBwBhGtneKF+HChVm/vgpcHO4Dpx0LR8xm7ucKRhbzyALrzlbcyO1Nl02xR/RwSFKlljoKJNrwR5LrwfKoZ1LwN0Cb4J6fDRG8NR6d3xcASOriScHlmT8wIMNwSzpj0a/97rMw+Xzl1mcD8QzeWgVF6qZMTfSqD21GG8iMDZIRr8tNxkXHdcrwZTyEWum3E1djQECpmweoPwJ/JCRQQfx1+lvTta/FlyAFunczOX0wBpqDWm+dP2r5MjdfTCV18BcwM2BU+yIAq3PLHw+CIEObD5Qictc9TU/74tFKmUq8J8xyN9AlHZXI/e0sgKw6nopZJkUDWBnnHVeQWW0lWRmn8bhCLtV50gFAU+mjA/2kCrFgcuAVRCa8N8S1N/iMxns7deptmt5aHxt/1jmSN7ZqC8Kw2tEHTcjpyTw0pN4Cb74KvZ5hS8Qj5N2u5uuZM33d1ulxj7X9D1MnhVHl5wN0KscazFLyHvalVaps1kF0ni1G0ScMyFcIq6x/mCDbzraOyIFI1KV2
 oc+Ho5F1
 DjRI4Xe3+v0nzjlu7SqxXBvvi+N3jBAIo1Y/fpLITj0rLKbzXcgEnhlCItUU49HpFUDF9ixSw2+7oW/XVhFfLs09e2GxG6i/tuvhxUIKHUlZbmunY8xUYBbMtwxXNITs40bu+L5ZCb1QrEubESebnzjrQvkENcWAdwA0aWxNwbHHU7sYo4Jfzm+TX7gD3I1MKzdHDMBqEJWjsP4EWOlSETAYNZovUc1fkqeTNetp9NtxFa3O2o43a15Mk/aQ+YZz92RrtCUYZSykfQLiUWU6Q1GrGGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new unit test for damos_commit_quota().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 3abf31fb1074..546e1a09d801 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -660,6 +660,38 @@ static void damos_test_commit_quota_goals(struct kunit *test)
 			(struct damos_quota_goal[]){}, 0);
 }
 
+static void damos_test_commit_quota(struct kunit *test)
+{
+	struct damos_quota dst = {
+		.reset_interval = 1,
+		.ms = 2,
+		.sz = 3,
+		.weight_sz = 4,
+		.weight_nr_accesses = 5,
+		.weight_age = 6,
+	};
+	struct damos_quota src = {
+		.reset_interval = 7,
+		.ms = 8,
+		.sz = 9,
+		.weight_sz = 10,
+		.weight_nr_accesses = 11,
+		.weight_age = 12,
+	};
+
+	INIT_LIST_HEAD(&dst.goals);
+	INIT_LIST_HEAD(&src.goals);
+
+	damos_commit_quota(&dst, &src);
+
+	KUNIT_EXPECT_EQ(test, dst.reset_interval, src.reset_interval);
+	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
+	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
+	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
+	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
+	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -947,6 +979,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
+	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.47.3

