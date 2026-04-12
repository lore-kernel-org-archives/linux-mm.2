Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEE6E937EA
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50EF66B009B; Sun, 12 Apr 2026 12:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427396B009F; Sun, 12 Apr 2026 12:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 141406B009B; Sun, 12 Apr 2026 12:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E80686B009D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B37CABD0DB
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:07 +0000 (UTC)
X-FDA: 84650415654.26.302E976
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21DD2C000D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u+QPsNov;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rdaam9BwVxK+HQPMM/xSyzd71ZxUQuLXDJfRzSuG9c=;
	b=rI4bcSpG8eCJAdiKYXTVRb5eMbZdbG+GJAdfSWOkmJZkiYm1s+FzEZP4AFmjab7mu6Inuc
	kpeCE+9pHhVfX/KqEDDOv+9fA7TDRU/1Buw6qBCGjzEtaGITaQnm2mBOct77I8xbjva/TK
	X9iHag+YzefU/+FzD608xsXRyH0Adtk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010806; a=rsa-sha256;
	cv=none;
	b=AnJZgMztn+xAF9r6eTTJsFeYwTvMeBux0ipehWzQHaSV8/KhL6WvtmnPdH/eYL9bD1QPQ9
	unkwFVZLbWzggAc++FjgSsBGFB8YbCd+KFpzxsaBoyLuGe0Y8AbPpo+xUUIQl6/j8TjK3/
	6y8K0JskcgNOjr9emb65Ymtwu9sDSGs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u+QPsNov;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EA3E60180;
	Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E965BC19425;
	Sun, 12 Apr 2026 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010805;
	bh=oBXW5uIN8lzshHczxlHFHeX8VLmiX/5T2Hz8N+WZ/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+QPsNovzlK80YmtrwBP4U05y1zDbVdemsKIeAZvBdz36NnKp96zp7tz+KKjgCQdP
	 0Dbr7t2hfCgueYz5486y6/b4cbMniEXNHve/xCkeU/TjsAU8ObFZHz8yY/aDiHWfmx
	 4aXSC9Dt4aMja6nKF+NfoG7zs1UkgoNLYvYXy6izvGo++BniCHZ/sg/+JR9y6xukxB
	 yous8y810ey7XqMqTY9i1sTbQ+aH/vka/AEL5yY9J66KB5EXDZNXx1LWe2/FmBcDaE
	 /Bf4EAtmgPIWMrKsCXv/AUYSHHNX1oOxz3V3LU+wbc0SpfCdP3VWH8FJatMwZyeeIV
	 VhtisjV33f96Q==
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
Subject: [RFC PATCH v5.2 08/11] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Sun, 12 Apr 2026 09:19:51 -0700
Message-ID: <20260412161957.82835-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21DD2C000D
X-Stat-Signature: np9uk8aaags3itzjz973yh9usf1bgp6s
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776010805-90222
X-HE-Meta: U2FsdGVkX1/famUQpWcuMM+NrP65nGAhsTs/x+4/jlNrNdyW5v6/On5nxZAPx3wwEZ0Hpm9xVd5l6uITId4cp5N7yS+0YdASf3CX8ZkJr27JlPbFhqLM51nLIHPWiXiOxPgWH5tJKxVDgCioi7qMJKcWkWFxUyK9wrPhvELM/iXUQFEJ+ofohV9BOlzsvVJeWPFUdsMjbuN9+Hmy13ycl0krtbbwFwla1fUT6iOvJSV6Lh2PCPyMOHeoaYpqWy1o8yZjNSyy8dYzN4SovGLXrDrjZvBuYaeGk9uQw5Og2RxGt806QYCNZCeFkGntudTeGbFAbNQbydSAWvedm9xJeGwG1GS9bqYCY/Fn5405pHpS1tF4NSWTsoXQppLs820lIJNkfwQCWYCus6z16HPpyoYd4+Tb2idY5svQFyCEXqzkNM2ms4tDN3hcP+5ms+SJO+dvAOuKRJ7RlLzNWW5N+tTXOcUq0MeW10EDwRErSWRA/bXA+DcXg/RwTFtrt6+HS+nshYWsklSOSwwn4Sqa5FnwfP70bPjGB+Hi9D6aWwBZC/Bpt9P9SyFune4kJHjmbJfjRLAFIqoJcfJWYtz96ELmUOiu9rwUFuQvygsrAcw3WVA9OVFzLm2BhcBxCoS0NeyvP5H+FVces/vdpnu/TPnGT/T4VLhx3CMNVVzEXFXPViKbeZj9dOfJnbpYZNPR1w7QYejOrcqb6nbzdntILA7qMBk5CFeD9gq7SIHMuX8aoopek3QgqZPF7rLcSfXzmAVLvaN4RbaHoaYNxhML/12rAIWdWUcZoA6KQK6zEfzmqaztjEixC1wEFU8VImSiQAn5yfoNyY1tWNZCAuklnq0b9wzCBQ8wgrUqEhvEw/WmP6WlS0idlKnmAg+fD7PiSAS4fEPPbokhwv71K/y3gjyvdTrAbkomQq/2ixST62GpGeCarFmuAvaWu6s68VeCGIqpVh04BIIVJyl6WvS
 IYFKx5vM
 7wt/WJhE4T+oFoKu0yWBfq2z0S5Dl0S8Y6Vj1mFLH0oBJcVNziBpEVVFnpyCMjmOs6KoKcXyM2rW4vCYKJRrsE4TD9kbA8zONZpbTZLt/zhLCVGNS6YeTucg7sLomGjGB9fE+uvyl0VP4HZZa0Vxn9+LwWFxjwrMDhQdyVmno2qn3vJ51agdHz2UIUkbrmIXzP6xRYJ92YJXoD5X2JgmQ0evA28bIP5Myd0CKpa6cHzom+C+lgha5cIiL5mpsvHgNwssVy6Pig4UoVe2RbKclgUmCzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_test_commit_quotas() kunit test to ensure
damos_commit_quota() handles fail_charge_{num,denom} parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0030f682b23b7..1b23a22ac04c4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -694,6 +694,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 2,
 		.sz = 3,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.fail_charge_num = 2,
+		.fail_charge_denom = 3,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -703,6 +705,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 8,
 		.sz = 9,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.fail_charge_num = 1,
+		.fail_charge_denom = 1024,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
 	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, src.fail_charge_num);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, src.fail_charge_denom);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

