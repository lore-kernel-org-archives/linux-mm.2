Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E07CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F37A6B00A0; Fri, 19 Jun 2026 15:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4446B00A1; Fri, 19 Jun 2026 15:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1AC6B00A2; Fri, 19 Jun 2026 15:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9456B00A0
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D63A81C502F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:42 +0000 (UTC)
X-FDA: 84897664404.13.7525403
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 44A211A0011
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cl9m0lZS;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFwh7/bBrNQXMDavjXH4Q3alYmiXXZ8Rq6jleDMJWMs=;
	b=5gZuKBgRSXu/QMr4QQ84hw3DL2X739Ocyg6cQ3gNT+TtUwzKCNtChE/6p0j+6b7fGz+wbw
	tb6o1RUKvAl2CSgl7gjTlGtzuXKjTCNHxZ5y7TBIKfVAevRcR8J2A9nTocO4IwpaGxud5D
	byDMsMwVpTXoHCF8dyfvm5WqsCL4/HU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cl9m0lZS;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897681;
	b=lmPs2PozoyUQ3mzrgBwCdOcZ+6eBc9KpcNNW9hDsKs09eQYp7CaSwO8ag7bTF66ACZ8VF3
	nn08PoE2+XLcm19cVEf61tHKf2cF39iPT6YmGRpRUHiFlaMnSYGH6qWW/ahMUqg8CBpTlU
	i1K8NAPhz+9AUZfMAkLVijN9dEPI7kM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E49D40D67;
	Fri, 19 Jun 2026 19:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167F01F00A3D;
	Fri, 19 Jun 2026 19:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897680;
	bh=eFwh7/bBrNQXMDavjXH4Q3alYmiXXZ8Rq6jleDMJWMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cl9m0lZSTLE8aoHs8+Ru67aexhBBe2PdSDtZ6NkIsWTGqf15tHCa43Yf+vPGeJEJ/
	 JbW51/p4XSKqMKBuEMKKd5fj9jzOfJU9KDG7nNC2SPTr2ILcv0iMQci02y+pR8aNEH
	 iMUT1hvkR95+MBk/t0LWVxiKCBGjm+5pbuEGpqA1aQnN2hdg+jMS1/MZq+DoaCeiGQ
	 i9nM5TrQXr8PzTUWZchIMyyc9/PPZRdN4re2Bp9IU6XJp/Tw61zW+AV4D+oWloWBJ1
	 F9gKSd7GOR/7MSQt+NdfvpHZNLxtxLj4Fh826jIZBYu23Nf1yS9N2xsF8otzRNTYBI
	 8Gia+ARGgQ8Xg==
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
Subject: [RFC PATCH 09/13] mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests
Date: Fri, 19 Jun 2026 12:33:54 -0700
Message-ID: <20260619193415.73833-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 44A211A0011
X-Stat-Signature: j6gngjzji1xug3ncg8m7pgpro48sepgf
X-HE-Tag: 1781897681-92727
X-HE-Meta: U2FsdGVkX19qBomggbx+PN1fQtNSf4wy6XTELNO7MJcNrhzVWYMFJXj13B/XKzvYoEgbdFnZ5fabHtsIs757/sjGAed4MVE30A2CYdZcTvHjfaDOrUmxtQbYbKZKYbCYn3Ko4vGUPc5Jz3ThLT6omMxKginB1MQPuAr7KCRNc0VdvLeMcPLSvWBmv+dZFssLxIM72kEEp5zdjeF5r6IwEsXboBSUYAsWSdILkz8WrX9bdOESA7JUUOdTlGFyfWPL72lwgarL25OXNXH3GyVLeym62b57XKAnQ2b7T4sRYUK6o+QLA7JmM7umuccBFa1DQBTv5X0aG869PP+Zc8y1RRxG0rZfdX6P6tiBSKT5SlVvioVXx9z8wD+hIVp8MHLeD+dik8Yar6br2//DTudAPjaYoVXTeHCtkbd4Tx5HdwDjolB1OAlXmEr9eC/eYm33woZwHkZDVOcGb1JWAxlBoE5OzZToMZLuNdowd+n3sBWWbrwgn0Tj/AjQ/BvLeKYQwj4fm/Rj4pzNF3OouWnvRqmFM9zQbunSQ2f90g1MziVRVjzvSlQdFmF2cLXvTkhD7E8br2+kmyDkGssdKe/HfyNv8zm0K+EZcx1XIMQiv5f8o7l82ZLKD/O/JcJ8YjNdDHy/X/ixxpUF+wUlD8M1Ibw5GeqOqXuktKSWoqgtGUXXAADx7vweR80wVgNdBcjC4eM79fGktYDXLVkhxItixQnVsBAuPfxVPzYdHAUl4qM1PiSGZP1QIMqwduJPYgdjYQ6Y69Z/oH07ONFbVMtNTT2Rgw4kIuPzDDcNVGvqccV9y2a5fjbEurh/oCLZS4c6F4iyLni7Y7g1n4tk+qaU061clrEt/0nfYBBCZf1bW2cesdWl7sSWRe10klR7DQQi2B9SCgbS0f23pJpg4mQdaMkJV5Wd7W+3v/vyP0RRSFJxlRnP7mvZxxVkrVluFY9qn1xGYTyLW86GPYgr/hH
 meGRtqVF
 daeK250vsEIsHFo2Tlr30HDIQIzHJEvVDmi8sbHOxDbDgZD3cFqVzuOOGdwlFfcdwaJAPjpHUs7ccw4i9AqiQs02cWBZmIAP0eK00GT5gYE4bu9nPyTmxCetzskDnNZlXaSvhs/t5PRnb18cJdvnax0+La1HNVZEzG6FlqzCraMNhk1ytSdhneC1c8E02kjKLlY2KlngJQFTBOV6/ygyoB1nnWFfgBkCLuJzpvPl4Rlt3lwFuWgbXNrd0YHzk8NcMcxeER6mrgEsAsQG2P2r+lXXnJKroARjIK68p
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

