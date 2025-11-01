Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A2A4CCFA02
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38BD88E000F; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F5E8E000D; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07ED48E0010; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFDC78E000E
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6131459031
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
X-FDA: 84062853924.08.3E6B94A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B7768C0006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hN3fiNJJ;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021240; a=rsa-sha256;
	cv=none;
	b=u0IQaDb6yjwHhPOheOuUX+q9DB4nuES7QX9lMxVROwyVQklftRS7jMI1m74+oHyitcIDMO
	2gPMxkvwZ4oBqmz6KciSuZCfVz6OkVE9DEinAR4+KepxOr/W0+ryJPSG8zO6CBS4fE+rSN
	3ReRBJr2HOia41XvjXpy4fsORbjnFq8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hN3fiNJJ;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igQf3mLdaYjlWMVy+yzpg9kmYdQx3I2tmO0I5uo3K3M=;
	b=BlFRLlcnCqFHfksadRG+rwzQgQkEN+kGnOOyrCZsqHncVUYMKwuxEL/B4JASyj1e0LovFX
	lEsqP0q4TckYY+6bq3ZGVQVB0GD2yJDE0ZRhJFJ5AYQD47XygygwINPFx6dKfzpxmqVH9M
	NAvw9t/PiKhFQ78gMVjQAPY2eFPKKB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B31F4441DB;
	Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69578C113D0;
	Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021238;
	bh=xEepEI/9EWPjrFmW0+GI6DwgedFIowTo82PSpqc2yR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hN3fiNJJRo0pvY442J+Yl1LisLZv1Nv6XgkcnFaM5wTHfwFoEBaMR6N0dHOloSFOk
	 6Ta978Kg2+ckOqj6eAzdq1b1VybHv8iRogTFKwZTelDx9TllrklStkaekQVt+XZqgs
	 jIwNBZIBB7sVuU8N4t/7L8/sP7nBp9CsA9MYkWOsD0zLpBhpbDvSEgSRryFUM9L99r
	 qUuvOCF4MTT4YUaJmr1syRo4PevEFj/iwXBvdoTWS/dEEcC8IX1RJUwOmZHL6MMx4V
	 GcbOX59ebc5c5HQaBVGu3E3vnLO4bwJqp3mWmbUrQsg43s5EiYwmLm4KdFbz+mAK2s
	 cPLHV1NWBCE0A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/22] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()
Date: Sat,  1 Nov 2025 11:20:02 -0700
Message-ID: <20251101182021.74868-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bak5fc3j3jysjtcs3ka14zrd3qo1c74x
X-Rspamd-Queue-Id: B7768C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1762021240-101390
X-HE-Meta: U2FsdGVkX1/EJTZeU5WY0QKbul5E6kHx14Q8uoOrQDX0ERwaqPQXrd7zxKpFn4Fu8J5u/l+JRwtovYnmaiYyUiw0mwccNi7VAJckyu+IYfdFSfdZ82r5tvuVNUoV0Mpfka+Uu+Q4Gm25v+FDU+kp/RH5t8e7Pjb9NMCaVl+p5TNip0yD4AZYmrLqygsROaOGIHnFl7ye+Q8nr+10mnZlYfRJTNeaUQInefcDzIP7HYXOMVfoP6Xx5DoC+NkJn036AQC7UDdPC2Bh3d2p74wuftDKVBmQBpf0RHqZacZcjdieO0kAKdiROhURXZfx6RML1TVTTsLqIoza5/WsTXgbd0lH7RLsFPeqMP+RIdCO15reDB2cm8dsj4WjASb+I4O5q+17EOwsXaNua+nS4NQg5TPYwYC5V6eyTCLAKSuJP2qIo/716zVEmoa4ASZ6Lukl27FeVkU4444hY5wpPyVdehIf5+j6fbzhy0icEVrwcPD8j8Qo6MgPfCysRv04Depzpo+hcf4der5eSm6xGorlqtykdh15fJKOAEsoEEvvB34ziq/bXx/nGDJQsrmKq5wJaTU7VBfKNYKd32sHXEbYWMijZsDtPHKiZ8rv0zpCAKebzrqkqFgUPOKwSX+0fpl5PUtKl4POvtU9zIh0LlLehy+OX7jUt5Y/P9J/4TcP2rHLlHF+BJv7LtER0UAy4fz8Wi5DJDiW+eO/S3+FcztXUR+2XEm71wkjMKUtbdeQehK7O0DVHmrjYjpvJiG4rnNRjlkDx3wWv0GM1He+OPsOBhc+zVZcxgj/rHjo36fjmEDOqvNsb82z9RRYyOJK18CGcFbQi4KCdyVqGUDwoKmNFH2VbVQgGuvg0XUOw5WfZLpjJ4Ma1jZ5zNNiz9HSb0ol3J5eJo7eG818sYco9AgsymV1BYuBJfT/oFUvWXPR7/PIoZjDiJ3toXxHaRs2M31H3xUmN0e1/qhcU3qpTjf
 MEn1y39R
 1PiyRCMcRiwB1UfLi6Tq03Ee2r623bFOsEr+sJq/lGYICuG80u/mH8/yU+rr4unK00VPtb5u5KbKVQKrcskTkFgtmkgzvSVOWg0F47V6yDAPpksbdvJZvKgiL/HrC7idQi3H+oV505h3LuNGOcrOllm4g11m4DKPp4CVsVBZCNzf6ValTZdetZmxRkfedb/srOJryPA34YNTrGzILWqNblumDYB4S/KV3piaPsdoL+Z9MP4lv/NDllqUN9e4/Mq4CcXM0Y9BPttJxRYRHyGNXrseXw0JEUpFFAdHz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_split_regions_of() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 98f2a3de7cea..10618cdd188e 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -278,15 +278,35 @@ static void damon_test_split_regions_of(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r;
 
+	if (!c)
+		kunit_skip("ctx alloc fail");
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 22);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	damon_add_region(r, t);
 	damon_split_regions_of(t, 2, DAMON_MIN_REGION);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "second target alloc fail");
+	}
 	r = damon_new_region(0, 220);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "second region alloc fail");
+	}
 	damon_add_region(r, t);
 	damon_split_regions_of(t, 4, DAMON_MIN_REGION);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
-- 
2.47.3

