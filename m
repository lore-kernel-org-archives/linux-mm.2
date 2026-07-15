Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E3DC4450B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644736B0088; Tue, 14 Jul 2026 23:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BEB6B0092; Tue, 14 Jul 2026 23:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558776B0093; Tue, 14 Jul 2026 23:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02FB26B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:10:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 351FEC054A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:15 +0000 (UTC)
X-FDA: 84989532390.17.55EF163
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F8F6180004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdwQejIq;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784085013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Csk2Bs95SoFAJpGitaPFL2lXi5OcS5tAvUkrHnWNWRA=;
	b=b9g7GgpQWxQxp0XAmfYfV63wfgx/0MvykKKZg+NpinVdwoBmiOuFtUS3vk2SzIV3PJQNa/
	hnzDhfpfB9m8Y7so/Zr0/r5StWTqpXj4LweVa+qK+Fd7h3O8QM6I9QN/casA8dPeA/7vW4
	uyiM1IVgqSVpG8qO4f6pzd+1r4Eh2JU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdwQejIq;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784085013;
	b=orpDli44i27h3zMfm7tZzFjQnixRQ4MFf1h+CRRwsQL39sRDfOgkVQ3Z5FvfAY/FRASm8O
	vuvizTP/nZ8sLrMX8iOnrIMVvQo0fB0T0ZMbt+LvPCDiNVr1dfT7DeguQe1kdvutrs6uj2
	e94/tt8J3Lubmmf5r35wb6QCqwOHRSI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAE74414BD;
	Wed, 15 Jul 2026 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D9A1F00A3E;
	Wed, 15 Jul 2026 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784085012;
	bh=Csk2Bs95SoFAJpGitaPFL2lXi5OcS5tAvUkrHnWNWRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdwQejIqjSXVn6ZOjjgrAJxWrno8uipge6ifEx+jog45KonTkm+btFthmQAKpVfGY
	 0lJqAjEeCtWVkb3LH5/9Rh3jnbfuu/DkUFS5DORwogllwKC71kxDCU4xDTxYtyxG/8
	 TwHmM9R05lRNvUclDVUams2YNzRAzh6erkKutdnASE02fLexoXyXpg7rKd8/2lOYqu
	 DWMfD6VbNrS+gZHEUeuwMlDEWMMtwZoAkVRjTdK2XBtV9TUo8+/sZIuMXaqs/PGXUb
	 jI6CmAHHekvsgEt0luLBay+leef/Kv8/pd601qEHt3iU61R8KZ7LNGoN8HmQXIEl5o
	 fhuANby88ZDVQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 2/6] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Tue, 14 Jul 2026 20:09:57 -0700
Message-ID: <20260715031002.108504-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715031002.108504-1-sj@kernel.org>
References: <20260715031002.108504-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wqm16hsmm9wocidpku6571c3p6c3xp6j
X-Rspamd-Queue-Id: 9F8F6180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784085013-929943
X-HE-Meta: U2FsdGVkX18BQAG/UpF6vwZo424guhwQIYf/pRuHjFMzBuutuCLMwEIUnThxj5aHmdaE2NLA+e5DT4KHLhdjViYbb41PQ3iOyNB3l6yBjW40/FdJY/fCCe6q53tPM74SYxquixVARHzZxvVDnlikUe5eoOGJa7cjxkJxWAJuIkSDCZLOj3iqHpaqTE3uNhrVMTu/INs946F3bzsWmrJT1wSaSUWLV5tcGVQxKkqJ7N8qI2lOoS12der+SIBJmkI0f8gGsoWAHy9hzppWATmz8oWj0IaNlItcpwsXB77edbvCLxpk6zr7Kq4Kpth7D/6xzz4auZ7o1kUz0mU0naXKtw3QvboOB0+GhCAQAn7C4OOJfWAHfbW6PPjMvHQlSvhdR4lak8RyFPgH9Xr7fBopEzXARX4egHdzXwEg06NKlglL8HiB6s3iEqZJJsABYwGx6TwWVveZAG6yUUGQh8aRmwmQEMXzVfQlgO12Qz9VVykDfHrKZq4tZv7F052AD3fXOqQJQZunuaFgvTt3kKLCE176Y8Dyskdwwkhl5Hdi4xCZEnBBL/IHS/408Uzm+zXy8Oc1zPsBoCEnEuwCeByVsnyVUOH862xvP6w/e/xFtSBAxvVCPG4NtTdrFHZPGLWE0dI7aMNdC/AXfW11WWRbmW0BhcXLxe2vCD9UzqE1x2AtmGpTnFBYW22LP/drVEDoQ5KXn+N2FLtRmdwPKdKrOaPFeHs8xCO16gtW4ypA6CZNeAZrhO0f/cdN7vvvvvS11pc5bF7T1NVgqdEvT0rM/Dvp1+Kf5g8YwsxARY3rKRGLOTz/7M7LfbcnGbegs3U4M1wONlDELgReAT268XlHqX+GPCWr46Ur8YAYN8giWM0Okhc+3IciBJsQ08WsniJqPSA4npc263gj6/6lSp/6zIqOG7H3QoMA8K1zC8ZIuluJnaB+SIkhpwQm3+r7zZYsyRvV4i7Rbl6vVRWHzno
 esn/Lbdt
 hN2zA4wumuzYd+Jx2xbSv8x5r2htR/XD4utwiwj6oxm9crTpMHTF+F2AHpoczakOMYriDy5oW3p+n8/ar+E6F+SXqTC1N/IRvx7D086tLCp7SSO6FPpGZKZb7Ftf0TdN/CC/lI2T3V0sF46b3yBQLUM5dUGm+yOsCNOvEVsWxz3kVuFmHA8dID5CT6oH983EW5gpYW+gIXxiq1Fu7It/DVAZ13Gzc9+QMs7qxM8JABuQPvw9xpxj4fbUMwwYr1pOEZ3P/Ekx6KaPEFKP+QMcAKTf16tci7QhI8yX5dgrGcltDTAr6pDaVnRzlYnKebc45kqpJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KUNIT_EXPECT_EQ() does not abort the execution of test code when the
expectation is not met.  But damon_test_merge_regions_of() code after
its initial KUNIT_EXPECT_EQ() call assumes the expectation is met.  It
does a per-region test with a hard-coded number of regions that is
correct only if the expectation was met.  As a result, __nth_region_of()
could return NULL, and the test code can dereference NULL pointers.  Fix
the issue by catching the expectation failure and skip the per-region
tests.

The user impact on realistic setups should be negligible, as it is a
unit test.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260710144937.26981-1-sj@kernel.org

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 485472ddebd19..eba643762132f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -260,11 +260,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	damon_merge_regions_of(t, 9, 9999, ctx, true);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
+	if (damon_nr_regions(t) != 6)
+		goto out;
 	for (i = 0; i < 6; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
+out:
 	damon_free_target(t);
 	damon_destroy_ctx(ctx);
 }
-- 
2.47.3

