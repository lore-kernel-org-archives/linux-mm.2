Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FFBCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856476B0098; Thu, 25 Jun 2026 01:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0B26B0099; Thu, 25 Jun 2026 01:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6804F6B009B; Thu, 25 Jun 2026 01:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 342CA6B0098
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE3DAA0557
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:15 +0000 (UTC)
X-FDA: 84917253750.13.0F3A620
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30DE720009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eG3xyDlc;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364094;
	b=73sElbfDmOQBcnyBws1bIWg1bSUUZLP6CCMDWQYDd6468t3Tmr3woUikTvK11CE8e4M6h0
	Si3R8vj+E7E0GghKBSlY8nR4ih3Alrzj6IXhLxLb8s5z75ANqgmsl55jfi029Vts6mCbj2
	qOBiEt1W/fFqbzYys3EjHaLoWlUVrMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNLgK6VekKiqsNObBDFES+rnS20A7718psQePgY2aCM=;
	b=RqvZYEO1ouL0pYbm2JzDtywz8+Hwrvqmr/x9b3FZgAB3qpL8ayF3XqB6NDX5/ss0/qsXBm
	/ompwowpKvp6Vh4ygWSdkijX7xETWUgoHonx/bMxLI9fOz8pY8uSFSe4hQOQwfl4NldgEq
	4AQWOBnbjZ46/SGrvBvDTmi1mSwBnSI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eG3xyDlc;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0F9860139;
	Thu, 25 Jun 2026 05:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F371F000E9;
	Thu, 25 Jun 2026 05:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364093;
	bh=fNLgK6VekKiqsNObBDFES+rnS20A7718psQePgY2aCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eG3xyDlcLCX5iTF+RmzsKyzT/t18Va9zOOOyuC04ZIolNSfwAFLNCPMYHpHc11ktM
	 +CBBox/OdM5o1FQd7n/gCbUuxZ0Mu3xLpWzBS1csm/tNOhRCjxifUU3ApwZPorEsRE
	 wGhF5Z4IFnZ0oia+V250IH0B0FIYEKl/uZrrA5Pm3wTittwig+tbzTmmpVojuvd+tE
	 9D4fnpFTAstiD8B6ZdLnr5DjxdBlZv5vfKsAFws04ZnWHfsgSVqfIF4+pvhyFeHyzl
	 ekSLntcYb35BqUIsO1uod9NcqqFMb6HGEp3jpWWZURJb8YoJv+jNHFchtVNeMWK0sZ
	 Q9liXI9Jdz06g==
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
Subject: [RFC PATCH v1.1 03/11] mm/damon/tests/core-kunit: test damon_rand()
Date: Wed, 24 Jun 2026 22:07:46 -0700
Message-ID: <20260625050756.91115-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 35jed6j8ywa6uyexwb1ta7aqq7msnke6
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 30DE720009
X-HE-Tag: 1782364094-684684
X-HE-Meta: U2FsdGVkX1/XIQT8s5k3AeOAgvE312HT22laRfQKpCvw5bC00hRH7oP98EziZVxEtb8PKCSaLb5sYlzWJb5dBn9IJOxlcwyDyblTtDiEgGGslbHuNRY+OsduuKCEwjJSXh4kPBszUpTGGB6R/tHYqZJepARC2HrnHnNwfVccWJehrPzcMLH+wCoi2LN4tC6HC6RVHXHxx1puKu+kZdc3D72BkwHxg2/3X+vyb5Od+1zS/wDjCh+o8QpWL+9LNzYcJ65kmJWOjy8UxYtb5HeC024M3eS0+mkhOdz7Mddh0SqBFOCM27/arWicdGYc6WKFq9sRMXv72IbTlWFf4L8xNj34wjQALo53aiNdAVSNCBjBsOL0rrXWkKUlykp0dN/Oif+kFuaae3/xOdF7bA0U+u5pAYNJGCG6vDmKp86jGMxcFgDom8FVi5KkM4I0zJ+BKGsNLJ/OLjvtbMZkeScQHHgglHRjAZkaiGkP3XWJbANnl3FDhHk5ILeXZKFhPlb7rGkTQVN9QLji3AWjepAicm5ZG6U5WNcKz4JBi50qmDAz7n574Jw6fnmZs8EZEJindxNybsKwVq2VdpG4NhhtlKtfYfHUqUZga4CbphWSUiWD+G+HCTlDTRWFWA296tOeqvYHi14VJp4R9Ckc7xpixrDvvmq2tEwSU+CU9NwRTn1s01X7KgufZlXJescNXbKLZ/Pwpxn37gTKxckhxfxZve+tD5ux2YPQaJ6sqEgC26VEC3DazMuXzu6MrnoiD4E7oEW0Xrw72gtlzASZHuDQ9wqUm8kKoe9VIEfglN+bVg7VS7LPm4Pc2YV8DcJV2586sRQbUTjmkQjirVVVXwfbdz0FTJxS92LCewh4cHcdkP5HY0Qfs0pshbF8AJxoBydbR1j5IutYHdrpPIdYIlsgFaItPYGqxuTf/0z12U+0LkEMWEXjiSe42Mo/BhHQQJcu4qg8xFPjNDyALcib4bl
 nszc8aHe
 TEbhcBrRgpxZXi8qBFs8VulkR5Yqft5pVqTN24DcDzGwbUBXRonipao35TSxNeSlp5b7Tko8ULQKbC6VyH+KCZb0ZDFqkY/HVuCHUUEGoDD9IvawUYhYrZZGZmcBJoaeBq2AAcE/1ArZbX97Eutx2WUEia1nPiWV8WO9ucFcLZeZ+L7bVeO/OS9SEVcrsDZBFN410yWWU+7+IF6ANzmvOAp5ZqlvH9yZnCPIU7WNkKpBe7vUL38xvGkoQcRgUe9PnIfHZfND2/VZHrpYxIyOt/0kTIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9012c4e647df ("mm/damon: replace damon_rand() with a per-ctx
lockless PRNG") optimized DAMON for better performance.  Add a kunit
test for ensuring the pseudo randomness quality.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 1cfb8c176b873..756f3b9e2ed3b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1460,6 +1460,26 @@ static void damon_test_is_last_region(struct kunit *test)
 	damon_free_target(t);
 }
 
+static void damon_test_rand(struct kunit *test)
+{
+	struct damon_ctx ctx;
+	int counts[10] = {};
+	int i;
+
+	prandom_seed_state(&ctx.rnd_state, get_random_u64());
+	for (i = 0; i < 10000; i++) {
+		unsigned long rnd = damon_rand(&ctx, 0, 10);
+
+		KUNIT_EXPECT_GE(test, rnd, 0);
+		KUNIT_EXPECT_LE(test, rnd, 9);
+		counts[rnd]++;
+	}
+	for (i = 0; i < 10; i++) {
+		KUNIT_EXPECT_GE(test, counts[i], 900);
+		KUNIT_EXPECT_LE(test, counts[i], 1100);
+	}
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1489,6 +1509,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	KUNIT_CASE(damon_test_is_last_region),
+	KUNIT_CASE(damon_test_rand),
 	{},
 };
 
-- 
2.47.3

