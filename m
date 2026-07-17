Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434EBC44512
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38C86B00AF; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9036B00B0; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B894F6B00B1; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1766B00AF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:30:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1DE21203C2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:35 +0000 (UTC)
X-FDA: 84996387630.24.56FB3FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 53ED8A0004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:30:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CfAbMLTf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rj9Z5Y27iRqji8iRGMFfcJYv5ZbfjmRp4XJwmqUyuks=;
	b=tRfyvVzUX4RRKxWrOEZGBKsJXFZopB+Vkn5uclx8VYeDA/rGZBzfsUXAdXM2RVa8kGqkjA
	d0d3RuSsf2tH4GNdtlZkBy81bSCPmMdYUOrpABFCQXpC87jaZp66QzLwGmcICMN+xd+oRx
	4w6VNlBkvA3WnDRYDLd2MBL8BPsGqmI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CfAbMLTf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248234;
	b=Yij94IrZR2sYAupdKJbYH/MDOcfTF0lArw76GaqfNiJ1P183J4z97EKwCRRoNlvp0j2mXH
	7mWmtqPaacZvfccjHC60k0MBiXbeLNsabU0eSd7h73qqI+hsXLlPPtpm1XsRXEUpLSDaAA
	OZ8WbuXewr2YRXJNqLg6Mp1+u2zQEYM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E150E60A6B;
	Fri, 17 Jul 2026 00:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4292E1F000E9;
	Fri, 17 Jul 2026 00:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248233;
	bh=rj9Z5Y27iRqji8iRGMFfcJYv5ZbfjmRp4XJwmqUyuks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfAbMLTf558lsnXavsBfIowovwZYqHiUt4jX3iHP9sYrYd8xvWyRsvrpSvw0MSTWY
	 nTcbokmih6UEEtk7TKjAgq6PEtBt7VusLCyE6/gkskuqKzlKEPlo6tHYl6nQ1TAkVa
	 j+Srwx13jxoE3PzjlTZiqIb2fplrrza5feZkxkcAMJ9HLGRwnHSzv/5XpJPGIf8vRA
	 6sP2WNThsPfP5+a28TQJ9obpiIl6Zkye1TLUF3f/2wVAmTBrMqaDmdGjTKt0AqbSkx
	 97tj/l2r23MalKc/ingRhKlRlXWkRW1pjllfd7rXyMGpOatQYwoI+Yo4upeXu0ROJX
	 SrEmPADQFTI7g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/damon/core-kunit: handle region split failure in filter_out()
Date: Thu, 16 Jul 2026 17:30:18 -0700
Message-ID: <20260717003022.119437-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717003022.119437-1-sj@kernel.org>
References: <20260717003022.119437-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53ED8A0004
X-Stat-Signature: 7ra4sz8wz6qhuwjspym3ag9h5sqxdrq6
X-Rspam-User: 
X-HE-Tag: 1784248234-366601
X-HE-Meta: U2FsdGVkX19tATMgoR/2I54rPNfg+HS921a/tgupk4e8sINWn7LwpXzapgW6Ey5MYCK2tQzIs10rCKLhk+GqD0kAyA/PrEN1OixQY3K7jPhG1yrI1500T/dNeBtigBKsJqpbDTxJnu4YDNn+DBuFB6UbRd54OTGjm90NTo6omYbGJ6eJ2Pflx4uJK7Zs9JPKODoDHa0syxJG+5DB0m9lfey8cB+VMtnShCuEEJnbP3ug6M2flgYFEmlaowjgHaMTZ3ZYFtl8o9mJucfgZoHAy5hFk6cShrC0tu/V7ZSiJPjlDYuFLVBd6ywKhXs4kcstxU2Wnc5Bz45UI4rBwkx9vOud4dmNxtXHxD5pcDfTj8QPZ0m6A4Ooj8+en3BWAcBomZW3IEzEe8nlQedF3ieYTTsuidAKpjc/gO5p90F+ShXAlUH0KpRJarf5F/vucRtHASdtUS+arxR3g6Y+to7BRBbxChEPb5YvBfkNtLRNyvpomx0DhlQe4rqS4Flxjkk57TvmBtnKfhKB9my7OEHZrwvWIpBPL7BVdpEAY/5UAOl1wi5t7uBZeUmqMeVRSRHcNCYCdOH4SQ8fCgFyHH6PTQ6iO5EoHKehlXS0U3/UpO2EB0cYSOSafl2lu6rSwZoB7r3dExYNsgYpM2WQHxTzMI/Qd2lQi8cm8YYksSJC1E+PxjnCyqigSoL7+ZdeYgnBQiAcR4u7yxifO+9QztKbWeetSWqtGsFut/9QbE2EV9FcZU9c5KaLjYPQ7mL48aGHqIEkgl11CNjLnDoCLUMisGsVU1c3sstjS8FICwP7JMrG/+ygr6p3J8I0OrvhQJDyujwsXRUijw360Kc+zN663UTrcKYuN5wlPgQnD8y8Tk/2U0058OAj7jLcNFELdRPvCB0mUJ6XyI0m2bNG7QlUPCY1Z1wdcYSoMCUWByjrNTLA1s0tHMYSFeYiVut0sQjbn2Kqdq8ubnsuKknQ/Hf
 JRB+nWR2
 reKSpu5cXuEOpEmcE8DWfE9bVdBb+12cAvi1UjS5EX60QmdcHd+cKwlx7w4KrtfDQra9VxwoEMUKB/yHOUaK64+McuLP4kXDDUYtzZvyeuhfgfrK1CF5XIKXkPxxtvnbAg+8ZBWkk2+tayh+wsUUtwiVCv6UxYf5PxGvXpsZg9fntrtF+qAFs5ELT9DjuBHTRi3mWsyxQ0kXUsuVA51cRwgWqI4ozYkeNOxQLF/ij7D85dYebAcpLPrNzHIn9QrdQjaQw/RBN42BBca2hLFHKdg1zNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dasmon_test_filter_out() test checks if damos_filter_match() of an
address filter splits the region as expected under a given condition.
But, the test continued regardless of the split successes.  As a result,
the later part of the test could dereference invalid pointers that
returned from damon_next_region().  Further, it could corrupt memory
from damon_destroy_region().

The consequent user impact (memory corruption) is quite bad.  The
realistic user impact would be limited, though.  It would affect only
test run setups.

Fix it by exiting early for the number of regions test failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714142352.100478-1-sj@kernel.org

Fixes: 26713c890875 ("mm/damon/core-test: add a unit test for __damos_filter_out()")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 322a295ac2cec..bd3bbd421392f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1365,6 +1365,8 @@ static void damos_test_filter_out(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	if (damon_nr_regions(t) != 2)
+		goto out;
 	r2 = damon_next_region(r);
 	KUNIT_EXPECT_EQ(test, r2->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r2->ar.end, 4);
@@ -1384,6 +1386,7 @@ static void damos_test_filter_out(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r2->ar.end, 8);
 	damon_destroy_region(r2, t);
 
+out:
 	damon_free_target(t);
 	damos_free_filter(f);
 }
-- 
2.47.3

