Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF591C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5A96B009B; Mon, 31 Aug 2026 11:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393106B00A0; Mon, 31 Aug 2026 11:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5546B009E; Mon, 31 Aug 2026 11:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE4556B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:07:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69DCBC0184
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:07:01 +0000 (UTC)
X-FDA: 85161892242.13.F68A393
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C4387160011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:06:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XDfT2val;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eijFprEn5vtvf/LMCpMXuJKzdfeHNzAGCtIabB6fjsY=;
	b=7IS8aV8NWr1QpxPcwuPBfP8OD6/QwJx/R0p2SQWGVa+RD+PcsLUMRYH7T3Bchc1BFM77iS
	HNbB/urC0y/nEVFkJyYXNrwU9X+XD6gyn+cUHTAtJa1ph2Jtk/PhK+Blm02Qc8xjF38m1T
	YTRLGQLA7UqYP6+2A8pJGnwm8UEHZkc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XDfT2val;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188819;
	b=7M6ajnZMWQotJAj1ZAAa5zwLuhtqE5t/cTceARPDcOfj20BvMslVp+DjEV/EfhZw8XwyC3
	BjkdtaBpmFJeDFrA9X2eSfmK1ruNM0g3oS1TSRoRedGbb3dgDvR12XoUWIbalv84ldLyCv
	F+nz50ppZKgvXgAIUhv+E1XqfgJ/QPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 073EC413E9;
	Mon, 31 Aug 2026 15:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CC01F00A3D;
	Mon, 31 Aug 2026 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188818;
	bh=eijFprEn5vtvf/LMCpMXuJKzdfeHNzAGCtIabB6fjsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDfT2valRq0ffCXEwmL39LKtmFGpqdNyt06q3bmYE66NkaTSfgTfwbjQeKlKNAhQt
	 y4z1ah38eDZ48aX30QXLYfLnrbg8si31mjn1NSilOdX7YP/P/cSO5IsJiIPF7+M9Dv
	 9SmG82tY2XOAdAu/0TlhX1fO0NRcpMVo/r+Jxmp21iREl4rGlaPNSnK8BxrIjvPV2K
	 l9R7ZvHuh48Y1gpZYgXfokb6+RDVmL2qLXmmaeHbOaZHBm2MR2pfoJkbugUxf2zZkg
	 PZnuc6mAik0dHc1jbHuMP1LqirxB+Z3F1OGJGOLKxWVjBqem4NLlRZKI3oGBWdTpg1
	 37hcR4LuGULHQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Angelov <jasonangelov@ucla.edu>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/2] mm/damon/core-kunit: test probe_hits handling at region split and merge
Date: Mon, 31 Aug 2026 08:06:48 -0700
Message-ID: <20260831150650.84829-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831150650.84829-1-sj@kernel.org>
References: <20260831150650.84829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cd7a51rgk6ggqzidybyjq9zwhbszaa14
X-Rspamd-Queue-Id: C4387160011
X-HE-Tag: 1788188819-209913
X-HE-Meta: U2FsdGVkX18qgLBf9VgXHRQQp426Lg8QM3fkempksb4s8mtu+X25pPiei7pavrwSCLcsLLjRk8dq2sLWApVv337xCtFrV0jN1nve+v78Pt0ab4Yy9sV9jlVZMa5FbL9O3ZUFq3iAgo3xXRFZjjUXvUXhKAd8vbQ+l59CWNFhAqUKHo891jBok5ORF0p1pIQXb2vZ+7JSOQ9MJ+TCrkYgEsgEWOgyK1huG/U1H4THNyPvTLkD0hFYa3dVNXfiM4uzb3ktBcucaDzkRhtHa4mgFRFFbkZ6ykdpEgFIAxgqvKAM6bao80xtsPmIdhu7mWp7wmu+6YXjD+zm5Y1TOfu9WQZhwp8MhED17sSIjDK6caqMCyaLUNOoJpmK72eEw8HomHPHTpUidaOmdESI2puMOKCtdMQZUmbKVrKGsP78XD3ZHPZi/I9L4NBONI90yaqHUGWKJQcPWJZeotfKHRQ+EfzKnQKIxisX88NP/safmPs7yHG6UxpSFKYHG9zsLKZbPKkfmFZyX1LMw899ZotSvf4KUmLzVBRk+NEXadqkfBupbq697IxwtK+krUeq58vZrfdUhlG47flL+c76XmDX5QrhjDLU5nwcQNTx2ZPW+mWUZTmWz6DjCouofpxpjdXknyzh4FFsoay+q2jgtFohW5jimtPYojg/Z9+Y5cw6f71t3At3mb2M/ap2lnuHsLw4QKa2FO7wD8vuQXF4e7svhoXcZUImxliVkCtuddz/bzqzSTzx04NDPBODeus/7HuAvxjGDT39e2MG1JoQ4mcMN4ku19tObRlBj/jsQjazu8P9UgOGzPq8d6cljg1O9+zwaEwU3E2/4mE7PBy7gWjVoWYUaLPJC/WJ63+gvzCW+2EeRtVfnngnmMxd2Ls41sUuQw3GgXPBr5raHr6GmrULdhByQHDjh1qTQzR4mZ60M91ER8nuUJalutQeUSwnVWF1qWkQ1EOPp0UHo9mzUhf
 t8iKUjPG
 lILFjXWh/grjZYkEWocRtD//OszmmyltKaI+YoR3t5XNZI7NIvhL9YWbbszqTGR58XAygkgSEVzf/sJIzFzueyVQxseqoR9xRgY/QyZtb+A+Pg++zC0kBijH9gQbbhOc0lgmrsx7ugYyTCiu1OvpMvaSnG/BG7/GabtY+j/9yxP1jGQg9UbmiJ0Oh/4fTlbci5RaeRpACqg8+Hw+NTRdi5NnTNDgk/gdo1LmAepwVTzryXtRi+rcf78Lxl3G9Ksdmtt0bmf18X4jmeYqehd/pXH4mzBK3NUVBKOHSbFrvdtHVtICdvWOt81/lqY4TLe0fngky
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jason Angelov <jasonangelov@ucla.edu>

damon_split_region_at() copies probe_hits[] and last_probe_hits[] to
the new split region.
damon_merge_two_regions() sets probe_hits[] to the size-weighted
average of the merged regions.

Extend damon_test_split_at() and damon_test_merge_two() tests to
cover those fields.

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ec7260a3bfea8..68591ca99a4f7 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -152,6 +152,8 @@ static void damon_test_split_at(struct kunit *test)
 	}
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
+	r->probe_hits[0] = 7;
+	r->last_probe_hits[0] = 3;
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
@@ -168,6 +170,8 @@ static void damon_test_split_at(struct kunit *test)
 
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], r_new->probe_hits[0]);
+	KUNIT_EXPECT_EQ(test, r->last_probe_hits[0], r_new->last_probe_hits[0]);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 out:
@@ -189,6 +193,7 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 	}
 	r->nr_accesses = 10;
+	r->probe_hits[0] = 6;
 	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
@@ -197,6 +202,7 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "second region alloc fail");
 	}
 	r2->nr_accesses = 20;
+	r2->probe_hits[0] = 14;
 	r2->age = 21;
 	damon_add_region(r2, t);
 
@@ -204,6 +210,7 @@ static void damon_test_merge_two(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], 11);
 	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
-- 
2.47.3

