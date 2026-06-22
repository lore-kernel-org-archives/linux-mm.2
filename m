Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D28CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1732F6B00AF; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1247C6B00B1; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061236B00B2; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AAEB6B00AF
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB55C1A01A8
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:04 +0000 (UTC)
X-FDA: 84907762968.15.0540E39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F4F814000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BgSX5Z5H;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFwh7/bBrNQXMDavjXH4Q3alYmiXXZ8Rq6jleDMJWMs=;
	b=VjuEX8eS3tYY7dDWgb5ruLnX20uObSV1by+GXAIdfWEIO1UZg2IJxn3R7ko3SHV2Cbnw2v
	K8uEnI0VVdTgEriRhAxsf9QxC49ykYQi+2KmJcD6lVXqMwftXVgwkSwUS2xywO9WZh19IQ
	+6yRn0JPfaXU5ZAKLZCZML2jsDtSAoA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138123;
	b=8My21nWJkHMAW2EhjPzK7tsJe0KO5oMvuKsuV+HKKp0qwYe67qBWEIoS38R6akoC9iG8Vt
	v890f7GGl44o7mWBEGfn2uo+pQP7BPs+qNdUJARV/XTXZgEmwmCQIjGg00ghiFr9xQfSFQ
	5dnxExjRTVedw0uCl26A9cCQWyGA5Ws=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BgSX5Z5H;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93FD644486;
	Mon, 22 Jun 2026 14:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCEE1F00A3A;
	Mon, 22 Jun 2026 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138122;
	bh=eFwh7/bBrNQXMDavjXH4Q3alYmiXXZ8Rq6jleDMJWMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BgSX5Z5HvIbKVMXS+dr+xplYgflqX6KtXnQcCi/XxYcAIJfn6DPo2G/tfsH4wMkvm
	 q6MBt+FtFaVdqY+wgqwo+AJVYQex5UklDLO9J2/w0k8hvacLCXrvoUEPCHFDR/36o5
	 l3oNHM7ud5LHtKXZzUg1WNQGxq9WifN6ccg+Ub1sV0RHwtRzw6Fzb7us3BSta4Gy/3
	 nINWUpllnZPZHtKQkY1+Lac90IZZCAwF+dmJYMG9L6yewRcQzKstIl8KV90ZEh3NRZ
	 EzMHdWmv7Fj/nJBVtv9jKbXxy6ghvEUMyjt3zj0y9YjOQoUIgeejnjrSiU116VWfQ0
	 ZL4iOAIV6JDYQ==
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
Subject: [RFC PATCH v1.3 11/18] mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests
Date: Mon, 22 Jun 2026 07:21:31 -0700
Message-ID: <20260622142139.30269-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y441uog445hbjt6871fhn1yr5r47n3ie
X-Rspamd-Queue-Id: 3F4F814000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782138123-745770
X-HE-Meta: U2FsdGVkX1+oNYXsCOvCC5KRPgaLBK371Vmr64R+p0zrT37/w0pHm8H2QX2qBm+hAW3yEU8dDw3UdGWbWz1fg1pLtsh+HzVXxm4T6qQc+YDaeEAbtMIVoNjScr6wL8jqH9SC4TDihyWhVnTO4mmoSTPlnwHuCuKGe7CZpbUPJY7HOWbzqc7DD4o/k0a+9l1lPevYgQeZq8VKe0hKfSWeEPeXshV7UCgKG3b9hOi9XtHX8FNXYfevrAlc9W7VAtCKe+dnsRbPdaMCaZVpkhCv9bcUi6TNXqlQu/r8D9vJRJgGOgSfcCLY+1zKMQaugyBJL1xMB7TERVt4SArrn8i9h5sWrEBwIUm0tvPR7RFDqf3ZKfAX4ZfOEPwi8gs4kUd68sM6D/e7LZrs7dfcp75q2jjqy9ifGLLRBeR3uKvFwkdrtJFzoIb/ULQF+MmMr/MQVMaQ5DODWNWLkWICic1dscHOPPeT1m6CQk0omokpyBixGEWD5l/G/n/8j9FC/HRRBy48PbxnSleHV2XXIyNRtDLtN6Y5PR/7ljrZzNQZ9S+fv48MgRLxbDYIDt2hwfRrDHUpZVr8KEVZuVYzaFnWwbJhIOZ0nxBkgF16MCVladkL/XudDCq+tDoFOYSR+Ne5l4IZYrzAjm/nfe6U0ZqnXignraFp103M9gm+Amaf2yuLfP7Z0GAFfnB9FPqnjsDcBEROR5I+DJd67YtvAsqjRlOptFKSkbVMohj+N6IDiExsd+r7vNOrEmTQVUuH2RVVeYBkrJHFYvvQhsabtbmSe5vbGDNvyvzjx+EoJZ/GJgFoPjnIL9WKnS4QjvnpKAf+Vn2m171dcSntb4kWRw3cRw3vjEO4bVJkq8ZT9ndcUYrqWpHg3k6ASo/ujqVoc2SA9oq+1dLXDLQtp9xk/HhFpjUSiXoTgne7tf8medukmYb38KdN8j49js1w4rMk2BN9pT/1rGmsEFSKKQ7dMeF
 JVSQftwK
 rOTbDeD3XAJ+lNwsBs6M0ZsRqisxJlkRYG7DemI2vp3dgoBbL/aB3UhIV3spuRgibeOKJ+WaiveGXVA15BYQMD2VXBu9vnVb+hT/17NXpiQwpV7y5f0FkdbspJKQ9gMbshF/E8FwBPvHBjIgoxyJggSFb38aiYjm/QN/wMTCXkeo1xyMLhUdX6S1sQb3qV1hKXEFhc3dMWUWpSBAEkY1ImCVpwHeNKHfenmscyOFyS/TfKwRqRhXC2IXJAk5fWNR1nFCggRwxSu/WPr4N7FnZZPSBhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core unit tests set up nr_accesses_bp for representing realistic
damon_region, and also test the field.  nr_acceses_bp is no longer being
used for a real use case.  Remove the setup and tests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index cdab14396250f..d1f019ab6fc25 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -118,7 +118,6 @@ static void damon_test_aggregate(struct kunit *test)
 				kunit_skip(test, "region alloc fail");
 			}
 			r->nr_accesses = accesses[it][ir];
-			r->nr_accesses_bp = accesses[it][ir] * 10000;
 			damon_add_region(r, t);
 		}
 		it++;
@@ -155,7 +154,6 @@ static void damon_test_split_at(struct kunit *test)
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
-	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
 	r->age = 10;
@@ -168,7 +166,6 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r_new->ar.start, 25ul);
 	KUNIT_EXPECT_EQ(test, r_new->ar.end, 100ul);
 
-	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
@@ -191,7 +188,6 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 	}
 	r->nr_accesses = 10;
-	r->nr_accesses_bp = 100000;
 	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
@@ -200,7 +196,6 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "second region alloc fail");
 	}
 	r2->nr_accesses = 20;
-	r2->nr_accesses_bp = 200000;
 	r2->age = 21;
 	damon_add_region(r2, t);
 
@@ -208,7 +203,6 @@ static void damon_test_merge_two(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
-	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
 	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
@@ -256,7 +250,6 @@ static void damon_test_merge_regions_of(struct kunit *test)
 			kunit_skip(test, "region alloc fail");
 		}
 		r->nr_accesses = nrs[i];
-		r->nr_accesses_bp = nrs[i] * 10000;
 		damon_add_region(r, t);
 	}
 
@@ -556,7 +549,6 @@ static void damon_test_update_monitoring_result(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 
 	r->nr_accesses = 15;
-	r->nr_accesses_bp = 150000;
 	r->age = 20;
 
 	new_attrs = (struct damon_attrs){
-- 
2.47.3

