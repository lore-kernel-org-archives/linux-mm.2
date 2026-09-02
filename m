Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B092DC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66886B0099; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC75D6B009B; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B71B6B009D; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 765A96B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04DDE40746
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
X-FDA: 85167741078.04.1C6B656
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5F6431C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J02qS4mG;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OzGA+O2Q4uOwSPOS2Cbn9lXzmSaQwiafB86MxgZx8A=;
	b=k41fqHo78xtNyVpKsZXm3YWcOx0ec1x6NUm+bNAOeRAQzim7S4qA0hBq/mHXj/Bpdhsl4C
	BQWayJU4OYwl/ajvCj5NieFolnuoVM+/ZaePV06ODR34aE6VkVvPtMMoi6ku0W3/Y8jvEM
	JKayumXB6fHRXlU5WeOrr0BuITDmhP4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328077;
	b=YI/6eo5beB3x8CLvINcUZZDJFL49RZn6M0Ex/akGfduqbpZ1pbRrQqs3riSliifimgffkv
	8a9n7AM/5kbfTRL0/K3ndff4gUlkfcnI8dCZyAkS6TgcWr4LwGXmmH6cr0B2fsQNM5bNVP
	JsSJw6s7oPvhMvpFYd0+xSlA/mi9xBE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J02qS4mG;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B095343EFE;
	Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBDB1F00ACA;
	Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328076;
	bh=/OzGA+O2Q4uOwSPOS2Cbn9lXzmSaQwiafB86MxgZx8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J02qS4mG49amT9aL3qy0N/9i1yyI4Gsah5BLEvacx1Fg8/zXD2kzAp0KNcl+fhWuM
	 Je22SK57DqL931haIX85t07X3Ih44MaXddzyX10Ta5vD8SRZ9JLbgybXeIwfhFWfKR
	 TvPESGAR9FjLzwGiy17s6hZ+bHJpi5smnek79MCQaS7uGa/15Jt5Jcw9p84ZcJOMPK
	 X6y4deFY7ltvG+x4scupqqLvulP7xDPYrI9DtvYdSh/ABSCwjNEayrv+abxdqsWehe
	 3FXyr5T22Ay4KFIPEoqjDAdGkIhRuIwCThrf2+WG4+HDGpjkv/k2aQ1K2/S1YtLzmm
	 WCnOIT6zg1bLg==
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
Subject: [PATCH 06/12] mm/damon/tests/core-kunit: extend set_regions() test for error case
Date: Tue,  1 Sep 2026 22:47:39 -0700
Message-ID: <20260902054747.99370-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o3tygz66a7c9bc91ui45xz7ox58bk6b5
X-Rspamd-Queue-Id: 5F6431C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788328077-171947
X-HE-Meta: U2FsdGVkX19JTpzeG5sM3UEdg8TooKt7SURBmWu57vre82kmsxxcb1wGmN/E+aw03euxSTsL32KQUpu8pqMyX4lR3gQpKcMjE30TtbduktnD1LtBI1WZfuDS0OaMO9qHG3AD7FvzxSAqC/gg5yyaxXn4iNHP5hEHRrNMSBw7yIKjADHegxzFiqUVX/btuIUX2L5i1AJKCf/BcnZCFzMYM660PD+L08vyqXyN8uJuQMsBX4Jy/D+kQvHZv7TrBcuun9RlskRRQM8Btv0dnPuyolPTLCatR21qLVnmgrShxgLcbEMnRzFUeI4oXazGlX4O8tbexpuGJMb8PyRTJpqmac6eQQUZobHlYCL6NvcjPg0yrnIdoUG1sGhjUYCA+pPUZqxFlnOxijtZTqr3z1j7odukA39m5ZyEDmv32DeB1BNj0ZxjgmPkk7lZn7kq4ymn9ThVGqgWsqDC8bC1xwzenug448p4v/sIPfIBhUopeQ+1Bl+WNFlL+0Bkgkqx5osdgh8xJMEtP30z1GAJDqlDOuimuByxUfgJjPIITT9V0k1V6VJVoXBqK2opoUcoFaC2aGLN9gxr4fJzrpEcudwY+C9x5KrJO3g3QnSIoAckXqn928FfveDHkLt5fpvVe7MnN1N/tnoxTS+H87bh+hT/rbIw800YA+GqwCgy+bhEIVE0NOp4RPPLVmLEDhG96+fNsEebyfeATBymHunbdLQE3lRPQmmkSTUxM+ZoiBai4CJK+X4Y4zBLLw8vO5JflbKzj2TPMNVGZDtG81HEWzUpMyOQscxju30/VVu0P7UlVzYKRUwdGpxz+dIrjYBWBbv4L9WaZbQ2K2s57acl7nTYlDnJ17toreW/FUqpEIzswvvW9mIui3QT0lQYhHvJfl4wpiBbqek3VuB3f6xC0Dbx/f4L/9CWvLvpH/S5rRV5yA+842sji3AUxjHdk4If2sdecvgdPLa6ABkn+EiGIW4
 fs6o/50N
 cEhSKG2X6z7uMyJhcXgK38ng8cQUfTjF6SAqnEF5X2ClEWcSlQVpvCqqNgDKFEQsE0lyY7qXZ8OTeJWT72Wy3xcFzBPwiUd5ELVBQagdSAwV5lTjo6mv9OXVfJW8rBkU8jnWEH1MEQLfrgSzc5hgyQL+9FzUS9lPJN+KIXpTpwkVpRireVp7wE9/53PpqDfq6EXaYrdG0+U1t9vExQoszk4sWTwIKhDJNRNEoJV2wkv8uTbsT5ReDDlvC1iYgaLVgZIvmaEY7AMezwXvG7Acdh1vZc906pBKxixBQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_set_regions_for() is designed to test only success-expected
damon_set_regions() calls.  Extend it to cover error-expected calls,
too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index af26b3d60957b..2bcf3bafe2e29 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -469,11 +469,12 @@ static void damon_test_set_regions_for(struct kunit *test,
 		struct damon_addr_range *old_ranges, int sz_old_ranges,
 		struct damon_addr_range *new_ranges, int sz_new_ranges,
 		unsigned long min_region_sz,
-		struct damon_addr_range *expect_ranges, int sz_expect_ranges)
+		struct damon_addr_range *expect_ranges, int sz_expect_ranges,
+		int expect_err)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	int i;
+	int i, err;
 
 	t = damon_new_target();
 	if (!t)
@@ -487,7 +488,8 @@ static void damon_test_set_regions_for(struct kunit *test,
 		damon_add_region(r, t);
 	}
 
-	damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	err = damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	KUNIT_EXPECT_EQ(test, err, expect_err);
 
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), sz_expect_ranges);
 	if (damon_nr_regions(t) != sz_expect_ranges) {
@@ -516,7 +518,7 @@ static void damon_test_set_regions(struct kunit *test)
 			(struct damon_addr_range[]){
 			{.start = 5, .end = 15},
 			{.start = 15, .end = 25},
-			}, 2);
+			}, 2, 0);
 	/* Un-intersecting regions should be removed. */
 	damon_test_set_regions_for(test,
 			(struct damon_addr_range[]){
@@ -529,7 +531,7 @@ static void damon_test_set_regions(struct kunit *test)
 			1,
 			(struct damon_addr_range[]){
 			{.start = 18, .end = 23},
-			}, 1);
+			}, 1, 0);
 	/*
 	 * Holes should be filled up with new regions.
 	 *
@@ -550,7 +552,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 8, .end = 16},
 			{.start = 16, .end = 24},
 			{.start = 24, .end = 28},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be appended.
 	 *
@@ -572,7 +574,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 0, .end = 4},
 			{.start = 4, .end = 15},
 			{.start = 25, .end = 40},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be inserted.
 	 *
@@ -595,7 +597,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 0, .end = 15},
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
-			}, 3);
+			}, 3, 0);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

