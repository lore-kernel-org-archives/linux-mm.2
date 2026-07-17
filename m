Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C44EC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3BB6B00C6; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79B06B00C5; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68B36B00C6; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD786B00C2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:02:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1959DA0002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:56 +0000 (UTC)
X-FDA: 84998515392.03.303191A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6FD39180012
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bmloB99Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyQzh9cAgWHiv+f51XfecFAFsLqN9MeOR+zzeRidaFs=;
	b=GlagLzZyyQdEcHbpY/Pl/PtmFN7t1Twv3NpZokZgtDvZDj5hPXqDHSP2u9pH0dZ9uyGo66
	U3uDAebr+/dKe1GP74OYpZKqx3kSwWFJpXi/3Yi0QnRFoON7Dg20umAlA7kU3geljq1eNc
	Vb/ckq9b5PqCsv++Mw9++aC1YkVxNrU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bmloB99Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298894;
	b=YEF5EmWZ9hcsmvq340wu2OShOfN7IJuejSUpeeUhrOlL16ilnJ79ZHqw1dE932pthbiSlO
	239WBEDQ3zdDJYFhX9osgzLFbzOl81kXchG312ToHFFvbrsMW/ou734VJDur5+q57dOMn3
	DNUHoK9LG/h/3e6JARa+XxiRqOgr8cI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C33594364F;
	Fri, 17 Jul 2026 14:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DEE1F00A3E;
	Fri, 17 Jul 2026 14:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298893;
	bh=KyQzh9cAgWHiv+f51XfecFAFsLqN9MeOR+zzeRidaFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmloB99Ybx1WKgtIc+yxyRNZ4NVfaVa99uMGlmbik1P6sKwLzzUKxIgu2TG7hBFGt
	 b7LMPjVozz0aZO5ICLqo1dC4+SHxox5Psc1/35wBHfgOelF9IiBkCrNr4DLLXat385
	 JbLTB6ejQXMC1x0uNT/Vta7tNeePtD7wpZ4433zw6NochFM0OsU1ZrkTnLthIGXnY0
	 afENsGXcK2SmtGyIAhqITzppKGuXMhYWRV3mHtdjKhwGOFnrMpfJjl/ge439/BwRXg
	 vnLNrWh1dCNWKiy765pLRjX9qCXndU8tRfbhDUyx51IOHtATOwyMEJdW2Dqrz2fYMd
	 PyRkMzt54ATXA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/7] mm/damon/core-kunit: check region count before testing in split_at()
Date: Fri, 17 Jul 2026 07:34:39 -0700
Message-ID: <20260717143445.91207-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717143445.91207-1-sj@kernel.org>
References: <20260717143445.91207-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 11xp4ccf5jp3n9pc877ot8dgb3y5p5os
X-Rspamd-Queue-Id: 6FD39180012
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784298894-28699
X-HE-Meta: U2FsdGVkX18kv5nHYzjxIYAVMCugTjRHXrWqwh5uNIYAIurEoApQ8gLj3NS6p9C54OLIi8XKsSB77pXHoVcRamIPDs8QnSV9BJPISe/miqAqaK6uuFK5O/1c2eMWxRM3d/4BpuV/ip2YY1sKSJZGz1xdqAr1eMMZaXDimlJj3yqXm/51Jy+iH8L2+Z0ZwPBqppJV7yzb7JkRItZAi/yCt1zNz0pEbVfN6Ft6i+g5iP55HalWCTp1pDGm6srwPp4xE5yfnzY75Y/AmozqQHI4ax0LHc47x+6iSATP+cUjxRB2lTiTKnXf5SQuGTYbPYKshD/+68T9/VRsF9U1xYUKrssleBJ4d8q18tcBL8Ucn2YlIqlFESjOlAUr80fA1OHrsOMq3vNO45JAKBPOjzZNrb0/9E6rt7GRrm05TZtSn14XMFL+c6l0MvikXcqMtqy6jegMXXY0aqWmrzkxYgOl1tU26hGIWfA1A2yWMgtwOIg6JNB/Ze3xARb7vc8h1TaGTtlupNT5ZKLla+ptm03gVD6nsK8Owt+oDm/TdXH+CwX4gZ6rTp4GXOkzkRidij5vLW6nz8algz8KiapxV+jyGp2O35NgTxbre7JgEVt4Ci2Ktj+rB3jcN/TQkvmJQegMCkwuw+uIJyL6UQVLSSRro//UISbAjbzQGFoWebMmu+VEkD+mQzi2AZImVfey7QZxZJGNTiYfDC7gQe2/+RcqLi1lexzTqqH4HTYmfXmP9AKlEhldnwPZDrClnhxaD3enT7I7ecLnt3Y3NtmpCkQL1OZ2LzVhQFXdMMat10iLcI7ywaWpoJntA5p03s/qzC72q1fJ0Km2zM3Baeb6ukgAKIY7m5ziQk8IMcvLX7J6oyisb6/TiPyDDt1jIyEYqNFNYKUE2opCBe97pm9s+1TIotiqH+ZDLNsOpFbjpIXzCWC8CqL6Z2MEJtdIifVubytgvz2igxLL8gwhmnMwmNz
 ndyI1OIe
 /6EeFitfZegJAtjj5TtRiMoJFIUcw+zXNKrYUFUfw1g87xvwF4K7oJ2ZaMZU/vJDf34VMuLbN59DhzXm9TSj9BEOBLZ/3kHMfHqYz6nzjBUqTnbWDgjeXUkGLDjMmm802knZkf1W83BvUjJCnj4Cz94q7Qf5LOAVqLCAq7FDE3JhyXq0Ue7WlsAH4maFJW/C0GEfGT0UJ5mzTACxZd70w1G3q0YmelKyQ7+Aprj50qKP6SsMS+hr3pJ/kL2d9TkZDYD+2OJEAMOfnzfEWwBACCclvPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_split_at() test next region that is assumed to be created by
damon_split_region_at() invocation.  But the split might fail.  In this
case, the succeeding test may dereference invalid pointers returned by
damon_next_region().

The invalid pointer may not cause a really bad user impact, because of
the implementation detail.  It would only read wrong contents in the
belonging damon_target struct.  Depending on the future change of the
offset from the link header to the accessing field, this could also be
really dangerous, though.  Still, the realistic user impact would be
limited.  It would affect only test run setups.

Fix it by testing if the number of regions was also changed as expected
and exit early for the failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index eba643762132f..322a295ac2cec 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -155,6 +155,10 @@ static void damon_test_split_at(struct kunit *test)
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
+
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -166,6 +170,7 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
+out:
 	damon_free_target(t);
 }
 
-- 
2.47.3

