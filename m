Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F8FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BD36B00A4; Tue,  7 Jul 2026 09:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4CE6B00AE; Tue,  7 Jul 2026 09:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF2B6B00AF; Tue,  7 Jul 2026 09:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A62F36B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E62C120467
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:53 +0000 (UTC)
X-FDA: 84962116386.12.40B920C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 89FEA40007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSIC6W3f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GY3vV+uG8yWd6R6f7yGxLhbvEHq+g5ke+H2XqmQ5/Pc=;
	b=pBEgog6WHHAZCY9z9vdPuBw/wjWvpWR6i6eyQVALQg7BxvIWOqKQYMXUOrnSJfyjb8he/W
	lTs4mq2Ms67nDzrdEtocqbERswGv2zNMjjHD7ab1WDSNGquyGNNwgbtkox3I9cuZVUzqhU
	t3o0qba9Hv1o7DWA2BE8gk1oLG9UYfs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSIC6W3f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432251;
	b=uANFMKkgXCl0ZT+wwCTyU3gp2qS6WnJtJiDEAORLcWe3UKzgKwQTgLh5YKUAUw2MgwjzSY
	d/c6QRsnT/K4DqFFiRPed5qKBiy4lWsW5fwDfHKcGxeQxT3NTmgjc8vj//mcqfpXaoAAp6
	UEVk7wM4QXZv/3eycfp3Rw/AxyGB+I8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CECD843BEB;
	Tue,  7 Jul 2026 13:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0D31F000E9;
	Tue,  7 Jul 2026 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432250;
	bh=GY3vV+uG8yWd6R6f7yGxLhbvEHq+g5ke+H2XqmQ5/Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSIC6W3fIjsjD6tAbqohQR+5KgzASN3vZf47SOlZUIvyza1ATwUpS/t78YYf9VHl4
	 uyJSfKU5XTs2uE3toGAYAy7OQ+eGA9zIe+mGH4xUXTFweDh7jrxBst/unj08ZGclzT
	 EKh7kOeUoCzX89UXMZHTcqeXZXNSGVNpbAAEdsCXBKFqqHEH1e2w7Pvawv0JI01kJ0
	 hCKiDILlT4G2yesyvCe2gCYLnBwsY4nMTTyviZITOiQD+4gtHMEXY7WiX9Ac/n0rZB
	 Q/pZE2DQwfzgYdUkHsRHK+8Au3ZmiRf0pYks5wyh1gwEY5m0l02Dl9jviS+mX3LLGh
	 1mIqvWCgkJZ3w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/7] mm/damon/core: remove obsolete comment for nr_to_bp() divide-by-zero
Date: Tue,  7 Jul 2026 06:50:30 -0700
Message-ID: <20260707135038.90068-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707135038.90068-1-sj@kernel.org>
References: <20260707135038.90068-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tydhq6h51wjt76mrbnrrojbnz4h9ckfe
X-Rspamd-Queue-Id: 89FEA40007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783432251-713328
X-HE-Meta: U2FsdGVkX1+orZ/T4u03wpLEpf1avW269eTnUXt51ydxE5Pmn8NZJpD8HI9gw4bXT5Wt4fdVyWaYXiEiGuOBaVjL/E+wsZfx7HL1CK+ZFiEahawh7Maamrqt/AWCuuPSI5vqvfsdCq86BuvEM03jk66SCVyJra827skS98bsi6iRzdM2/oDHT3bkrE8xo2bbomK47syrHheY8H5PsnvXPxe47jrrs+7RY7Z3tmw3DNd6QqoHACX/d/By37RL+d6ZMmIxdP8HH+vXnsD9L37wjLTT/QL0yZpIM6VmnjwdTn/8VrIczyOTRzKLyELs3k5HI2waWoKtX5e2bKCqqGJ5y2RMi0Eg/z3Wf0vAK7PbmhlNifL7gfL80Au4kMO/WPzwz7BH18r1l3F5ft/lK+99DijzYcrowqt8moWVkniyi18MIBt8comcQ8RjrV/ckuIo308+j9uZlUbRFxMFyRpEMOZeUNslj5D6eeeZgrS7kZ2unyXZrFHtFrCYuevczk6T3oVUg/SBPBez+D5rTIdhWukiaSv02ETOgc0IN7PS9WF+oAPjxMrCMT2z/UJsmw1GMLBu+x+qcJweAz7C87nrSJqkj+YRX+9tgmX+HmGaZisSfYb+MsBw3DY40kGXloUK94FvDQxMSP36mK4xXpltaWUET1yy+q7gr/k/9JLokqm4hPy89sVs/6gdFT0dCs9xyBVZLtMjZBkUsNKndz1xsj96QgcmyHbKvQWYrSe4dZGumUecKdtSh/KoLobx+m6YICi2z7ohvbC5wI//58/3umyhBGmggI9eg/NC3drqjM5LdtQQpfOtqkLEQDS8lKuRRz0pRyXdi8if5A3UnO5S1/iZ4fi5gdW2Tlh9DUjw2nsiXW8w6j5z5WhtxJ+hbEgg29FA3tMqGWGg2kt3XSbt+3dNsgb0HIVhyroOV/F5iSO/i3PV8/L+qb/jpOLFHzgtQgxLQKZR2aeAhQgDIOg
 KAh3Qsqv
 h8PfO218cTEXHmhAvPBAXEfmm6BtwxRj760dZAcE7yHl/qFexwt+gcvjeSvp0h7NZaZIrMex25EbEoPyU9QmHTz1KwLpjtEBLJbkvSssZRYV55LhwKaGpzUnHUJpmUGqJhL2IPvRngxk+xEuM6Gn0ZBae5vD3IVeeE8r+nmqzH/3iZz86CU+dnvlztnslyQXhmc53e27a1Ukcvdj2RCw4lF6lokwDSCD93hJUgOP+m15+GHnVRixwOvSe0eLVwgXnBRTYFXECbyf05Diebyx4l0Jl+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_to_accesses_bp() warns it can trigger division-by-zero
when the aggregation interval is zero.  Commit 35d4a3cf70a8
("mm/damon/ops-common: handle extreme intervals in damon_hot_score()")
modified damon_nr_samples_per_aggr() to always return non-zero.  Hence
no division-by-zero of the note can happen.  Remove the obsolete comment
on the function and its test code.  Also remove the unnecessary guard
code in the test.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             |  8 +-------
 mm/damon/tests/core-kunit.h | 12 ------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 390e00b3685ef..a15005db82899 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,13 +883,7 @@ static unsigned int damon_accesses_bp_to_nr_accesses(
 	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
-/*
- * Convert nr_accesses to access ratio in bp (per 10,000).
- *
- * Callers should ensure attrs.aggr_interval is not zero, like
- * damon_update_monitoring_results() does .  Otherwise, divide-by-zero would
- * happen.
- */
+/* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b83..224a3ecaa0701 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -582,18 +582,6 @@ static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
 		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
 	};
 
-	/*
-	 * In some cases such as 32bit architectures where UINT_MAX is
-	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
-	 * damon_nr_accesses_to_accesses_bp() in the case will cause
-	 * divide-by-zero.  Such case is prohibited in normal execution since
-	 * the caution is documented on the comment for the function, and
-	 * damon_update_monitoring_results() does the check.  Skip the test in
-	 * the case.
-	 */
-	if (!attrs.aggr_interval)
-		kunit_skip(test, "aggr_interval is zero.");
-
 	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
 }
 
-- 
2.47.3

