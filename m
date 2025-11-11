Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B16CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79FD88E000E; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776FD8E0008; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CB68E000E; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D128E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE0D11A0176
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:29 +0000 (UTC)
X-FDA: 84099201858.22.20F8726
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3566E40012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYYohash;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886668; a=rsa-sha256;
	cv=none;
	b=n8DI3K7RNeEMpFIs6xXU9SQrUhkakhv5ckm/e/NhWg98lucn5Kk6K68lGkJRH/v38kIrgG
	UVxeZFMgz2wTBIJYbWX16Rdey2dPL3TIDhUJdPpDoPbjoxEvhlDz7wbv/0PS3Ww58vOmjJ
	SFG8oeGBVaKe/JvRtIeIrFwszswbm70=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYYohash;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHwUPUoRA3TPNgsve5wbedGQ9XC5FQEOPz3sx39AW5k=;
	b=Lt56TM9S6PnRiO78v1NJSt5TWLR6n4q7ZQl7VQ882ArjYFWXHI9V429Ta1NqIbUuqm+fxQ
	mJB8HrrYqu8pKS3FF4aJeZKLDibLoI0/fLsgiNVAWmOkP95fgC7eFHqptTkGbTtdLH12Fj
	xPLxPEgPe/dUj+e0ZPhO0wEmNr2CZZU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DC9A43542;
	Tue, 11 Nov 2025 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BA9C19422;
	Tue, 11 Nov 2025 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886667;
	bh=mAIWfi16gggHF11DCFY7/6hV5ak1nSb/ROSHyLfYfYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYYohashKZ1/+G8G79TC/s7dyeb+R17yDQBEiIyO38hKCeCuABCKapiAFcY9lPOW7
	 Y3BVent0s5UOfWvMA1QJRxOjO9zRF7p0eq7kVcU57eEUlt/ePtO+284MaB+Eg/kMon
	 Uye/3APygEp66bcPIs2FCk59DcJD667MzfJCgKb7+PJ6zWl0FzUy7ptD1sa5fwLbF+
	 vPwGB2odoTsf9nIDr411XlxADvGfUynsRC4jtL3LWWlioGtj+lfjtLS9ssqKMvy1GF
	 zn/SXHcSZp5K3kShaIVT//2Xzl7RfYnOnqX2BZmZqD8SWcTAut9RSkmR1GIVQtesTU
	 VTjfiql/oepEA==
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
Subject: [PATCH 01/11] mm/damon/tests/core-kunit: remove dynamic allocs on damos_test_commit_filter()
Date: Tue, 11 Nov 2025 10:44:00 -0800
Message-ID: <20251111184415.141757-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3566E40012
X-Stat-Signature: yufxxxwzgbihhegubtg5euozs153hf8p
X-HE-Tag: 1762886668-965422
X-HE-Meta: U2FsdGVkX1/gkUqtCkRH5OK5BpQZ9MwO02CqnOMM5aO78OPlHGuvVmD114s8Sd2AJVh6YBBu+IhFlT1zwaU3UPLUAqGvxfuWcqfksuNcURtCKgGYSrmY4T94fZbUVpyh/ChE2HyZu4hJ6F7yauMzoSuDuSnfGR6RPvIfkSEclvSwyGguZoXx/cNO6b8IQb/66oWqc5gwHd3IXfn++94Q3di92iSpBg/4b3hLoj7dPVgm9xO/iPOWhHRSIMRPCcGol0uNID0ObPsJkcXx0IK3cGRj9rfalTyEED9uH7xXUoEfAX7jEedR220bS6zEqMa01t51AcuAp3zPEsZ8jk0h78K7AGRdxt2wcLHsoCGC1p9m8+scahoDXHEg2Mx+jtB3RnKFEjs+twJI5z3hB8oeQ0CapMU2tHFsCNLHD8lW3gKcrDiC/ZniP/EOccPVbMIBvYu1BCASm4s769pElFLH0K0IuWEKc8awt+JuLzIRyp7/kweIaBN5JKqjRxHUBrDxdoxJuKG+JzQ+vcqMy5I7PwFEpLBMEGM3VWXJ6gNC9pzhODz/i93EFWgsstVxNfSaIbd4rxzOF7KJd3ohXGUkoM/uBenVEaCzWEx2UH7TOly7seM/qaml1XvXSw2BpJq+mykOBae/oRNzdg3oFYNkZ6Kao/geeaf85c9SSgIh/gyLkdMtRbDX4YH9hh4NqjzSh9ihI7tRQqgn8wIy6LJzOOt+1uYwAAT5a7cXX5HeJPcx/PQE4iFg0m12pyL6+CrmXNHtFjVkH8j+vJcPoVoOXHXixMZnBXqYtoeHBtHpAoVviDRdNzf+oqX4+NObvFUF+nGze3o7aCpmLhC3kG9OtJHDUMV+bRk9tkl1yGPCrD30QzHIhClnkwlI78C6tG0RGL4xNcJkj0B/g8wjRcdI8+q5/aGKD8dRsScfB/xMMl7Q+MUe8urNaZ+JzWvwBxscL/uJjnLs+IHGSI3VUcu
 BoOQPjuD
 hU9HGeZHqQrgwRsVf1sDRDz17tp2YzOgWZpNPvN9jaFDZe/WHQ+UJFjsRmYetAuHquKMbSrCdOadgTsupt24Vnnnm5AJt6J8XfwaX35DPnGbkBMCEplaZ+KZKrGkUiesERxkgrf6z2MhWdzRZMsDBswZq1T6oPnYM/HdtLRAnSNPJOiWWyRO7UQL7u6sZFJWACZUiMwR8en/BNnA3fu0BxtytVfqID2/YfzubmudLV90b2IECVmkFpSHl7UpaBQUiy/OF54vqyMW6u961IBE63/hGHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_test_commit_filter() is dynamically allocating test-purpose DAMOS
filters.  Allocation failure checks are making the code longer,
complicated, and difficult to extend for more test cases.  Refactor the
code to remove the dynamic allocation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 96a4cd489b39..ae97886137dc 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -499,23 +499,20 @@ static void damos_test_new_filter(struct kunit *test)
 
 static void damos_test_commit_filter(struct kunit *test)
 {
-	struct damos_filter *src_filter, *dst_filter;
-
-	src_filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, true);
-	if (!src_filter)
-		kunit_skip(test, "src filter alloc fail");
-	dst_filter = damos_new_filter(DAMOS_FILTER_TYPE_ACTIVE, false, false);
-	if (!dst_filter) {
-		damos_destroy_filter(src_filter);
-		kunit_skip(test, "dst filter alloc fail");
-	}
-	damos_commit_filter(dst_filter, src_filter);
-	KUNIT_EXPECT_EQ(test, dst_filter->type, src_filter->type);
-	KUNIT_EXPECT_EQ(test, dst_filter->matching, src_filter->matching);
-	KUNIT_EXPECT_EQ(test, dst_filter->allow, src_filter->allow);
+	struct damos_filter src_filter = {
+		.type = DAMOS_FILTER_TYPE_ANON,
+		.matching = true,
+		.allow = true};
+	struct damos_filter dst_filter = {
+		.type = DAMOS_FILTER_TYPE_ACTIVE,
+		.matching = false,
+		.allow = false,
+	};
 
-	damos_destroy_filter(src_filter);
-	damos_destroy_filter(dst_filter);
+	damos_commit_filter(&dst_filter, &src_filter);
+	KUNIT_EXPECT_EQ(test, dst_filter.type, src_filter.type);
+	KUNIT_EXPECT_EQ(test, dst_filter.matching, src_filter.matching);
+	KUNIT_EXPECT_EQ(test, dst_filter.allow, src_filter.allow);
 }
 
 static void damos_test_filter_out(struct kunit *test)
-- 
2.47.3

