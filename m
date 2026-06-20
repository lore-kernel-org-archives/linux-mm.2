Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBA7CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EDB6B008A; Sat, 20 Jun 2026 13:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1B06B008C; Sat, 20 Jun 2026 13:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290A76B009F; Sat, 20 Jun 2026 13:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE1EA6B008A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3694F1C4138
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:08 +0000 (UTC)
X-FDA: 84900961656.21.6351041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 952E9140003
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kh5e7YFA;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFwh7/bBrNQXMDavjXH4Q3alYmiXXZ8Rq6jleDMJWMs=;
	b=dO0VDgkMMF+TIxSi8U6Bmrfe/kc2IvEp+Fziyg07m/UOKOZWcVIYUVVOaGMteI7ZVUfHlV
	66SbO6MSPXRFqzrDQhzgj23dkaFmvIlmMt3X0QEotBnmlaPob8RIVPB1l+lUejLqif6jt3
	5jIERwnyjk3Lq96DAjsrwwI8ORerxQY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kh5e7YFA;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976186;
	b=MZ4CrHA84JSn142hy1QZbUiQSesJtT7jK1jAzhSgFB0BC+jZwNAQm63GUULI3iKs13wp2F
	fX3b+PFYfLA06DrdTxTYSYi4o8rNEDgAwpq9GEu5ZhERuxTlS3VzQpmuEkbe3Grd0bbTgo
	nEIuF7D8NAOAOEjCBFCGD+yDYhWO4g4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EE74601F7;
	Sat, 20 Jun 2026 17:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B281F00A3D;
	Sat, 20 Jun 2026 17:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976185;
	bh=eFwh7/bBrNQXMDavjXH4Q3alYmiXXZ8Rq6jleDMJWMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kh5e7YFALX3Zt8CIcu02a7+ci/zQC7/GHELkBuKf+Si0eZab1Mw/9EPr6GyZPhF0P
	 hLnaQnmkXYh/jAugYhVEl6MIbRnYHikwTlG6LC6jmQa8eRUrD88gGzNGQp7XAMFmC/
	 hV0jzFhgavNgEo29XXVgh1kx4gKg69wWM9FhLcQgue5B3x6XZuvN5e2tMBVdYqVitp
	 z3d/GHOJxfFkjOUmrX8+Fhw5VoYi1ZyQXSSFkaHvTMglH7Y/xaF6h3RljlNreAWoJy
	 n/M73OZclCe5foS/EU7MSTcoW7mfHEh5IIIeUremgDpF0dPzIn3etQW7tWtNX2czsd
	 VaB4XQYZs53NA==
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
Subject: [RFC PATCH v1.1 09/13] mm/damon/tests/core-kunit: remove nr_accesses_bp setup and tests
Date: Sat, 20 Jun 2026 10:22:39 -0700
Message-ID: <20260620172244.90953-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 952E9140003
X-Stat-Signature: t7x9p736ppyp5h9wh4f41nwghiq4xrbh
X-HE-Tag: 1781976186-708171
X-HE-Meta: U2FsdGVkX18FfLnGUxckqD4fg3oP1q3TR1Ibz033GFoJg9vnd3ph+XhIh4GVclPxjjepVyDKCif0w7dWVC8+2lAC51KWWnH9Nds6khCRZgwH1Jjq7ZManvx3fVU9wIy4g1YlJYLNQ2xqEjfKh2/yt05nzsRmDf0gPzMAgf+MvoeODMV8tYXdmEezOgC61Sbwttqusp3Bu65SE9buv1pKyQYimNQTBCGOS7Tcx3mD/pUD7h7HISJ62nECFKJ/LeYEChB2gX8n3IbBwIdSmIK9XYiful/0X5FmPW2M1l7lyxNqOSi53YsmxeEBNMR27TD64VJYAD8FwUXj8MaDksCLdb5nFuuyc55wXJQhVQJIBZembALrMciPW2Num13sgfdOCxewsOpLzIjNHiVsrck1jPu+KSnbzfPZEQ9VPBw/QZwHWJqczCWUKyEDxOxBPyU1HFB8ho5uOKS/4WuVu5RZhRrpgMVzBgpYGf/oB1hQ9jKtDcDA70TjiDg5E9RPMipgJ+m3m1OI6O29yBaYVeKm9scVn/8VkQuBtpjc6FSkxozyVuOhVwgochFd3NpDISqbr+OH36LRCOpVhKtq4pUM4TvQa7fneLE5U5pTor6aM69O/dJa/f/CNVHUD6cKG86sJkvMB9Tt9lFG33l9L2pVbm+0Vgv1rCplH/kcn6CysgJ1VvQHg8b00cdU+RaSDogqIVid5lTfH+eEsS/WQjZol7IxrVO8Okav6tweMlv4RgS7WAwsSjb70sj7P9H7baioObE9AkwdI2j/JapeHSsTKQC1hSbCLsI5MAmFin4lytaI/rvZdUVyEXwkCPdJmsRx4RFCKAYlcZMB/p4RED9rSjMks9FdHbdQqgD20xspZTT5offNLvsY/HrTaJoxFr7tADuJYLOIGSm7E1+7cGpO+D4/yM0mp1o5j8CF2zJB1giMLgR6zOJg8U56qcFJ+7AZtN8IqMFF4em336VOOjZ
 juKvKbLW
 fqtg+lsx5rtKIQmgBdc74flCmHmlusnXsR+tVW1iECjRLM5/+J3GkIfJpCfnS3/b9csn84/RY9ilntkfUvEstKmfU287Y+CbIKKpEi/5hr4kQyzUAB3kAW5ie4i6opz8e3PJyQhD2rLZ8/ZyPQG3dx+pacZNhojK9ZD7jp38KhwuXQa0ZpDmlpLaaaKBjIpoIUSBKOugeBszpBvjqOmJJgvZsYO2fHQ0nufivmKRCgj3Z62dgedCX4JdaHv0Byl+y5AaYCfvTh7j2Y+WDwcCPi4R4Hw==
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

