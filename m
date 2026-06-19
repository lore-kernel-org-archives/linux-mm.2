Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40864CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152406B009F; Fri, 19 Jun 2026 15:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1042D6B00A1; Fri, 19 Jun 2026 15:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DDD6B009F; Fri, 19 Jun 2026 15:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBC006B009F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44B561C4B51
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:41 +0000 (UTC)
X-FDA: 84897664362.26.2EC8683
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8C586100011
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNt+PiuR;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOLvV8tB06/pvCLjG2dl48pE3b9/q317si70zxHfWTU=;
	b=yRVw4YsFzue1vIeCT3sUVgQAYixAbgJQf4XuQ7QIbHoYA7t8LMSfEVRqd/ERK0i7dQcPey
	F8D5efbgF2Se34cZUBCgu2xc+ryUwwL7EH0wOlr00oYgqLjcQRnrS1vyeAjjEx8Oq8v7nt
	2sovzZLBb64mjfGOZceUNXQmklMN5R4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897679;
	b=osyIEd3TpFOdtjFwVrapdLsnjDVt/GZsW1Yk4liO/kXpOzFaUj7H34+lYWjwMrGVThLnX5
	H3SNfNDeXGig1pWFY7m34b1QnYsoAQtB5fAzjfjR+SDcM3a1c9RORfPoodw9Z3SrFh9Kcu
	6RD7/I5yAueCRLRUaJyUy3nAmbcTuYA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bNt+PiuR;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D991E43860;
	Fri, 19 Jun 2026 19:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BE31F00AC4;
	Fri, 19 Jun 2026 19:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897678;
	bh=tOLvV8tB06/pvCLjG2dl48pE3b9/q317si70zxHfWTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNt+PiuRHcp1/q9m4TXokEOUpQ8IdcXtMFnOt3EY8sxikaiKbXsQPHt7/RQl8F/od
	 bMI5JZrxr+T4lBr+kN7BfSwsZfh36msxkMA8nbpEnINZmodviU3FAMEioM8QlbgU11
	 ykKCJEy+VanGB3woPJA+/tmWIibQmDnRYaW+jRT/F8/t+Ue+WYk5sk7e63JTsX0oz3
	 +YIC0aFUhT3mJ7cPqefLGXNO5W9UQMj1JLxbg3CkH7VOVH71GQ43+Krb4c4vq0/SaN
	 Y92sYr7lqBsjuRtXiwkDQtrWs0l58+qZjsLRxP+/s7PRdx9vi3msEoSfBQ9zt4H9Fz
	 wesUyjV8XjX1g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/13] mm/damon/core: remove damon_verify_merge_regions_of()
Date: Fri, 19 Jun 2026 12:33:53 -0700
Message-ID: <20260619193415.73833-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C586100011
X-Rspam-User: 
X-Stat-Signature: 6hbpp7topqf9ygosrnn3f68to4o1nq3o
X-HE-Tag: 1781897679-711319
X-HE-Meta: U2FsdGVkX1+6mJsrD0xbf/X/WL8vq7ymZUszeQ3r65UOTTfHk8xIrryG0BasYqV1UhIPEETC5FjWDfr8xmV4Wg0auzGm6DElVPTefqhUnPoWUMEfb+CycpJx02D5u6aZHs4XoxDVeMxO+69ulOlcHpN5zMtkMglIgGmNzrRzj0KeG4YEe5kVZ0EsgOmYwgTSRjNFOeKpflV1paKQ8rr63uKKYHCLoQc0c/o68YOr3L2dJvGsWGDv6KKTO0D1yodPjZ/hBkjmBrGbXK8cEV6SZQTavlqbvrd3MQN7C7edJ0TeX+YwrgoWMy4BeJbU+/ikAXdHz8JckqhOHDf9XpF8yZ6geDN0ETOd87gJmqUAgIAZRcBxzLzl8YsQcPwc+Jjw93S5BdDFmBG8b3y1NtRiJu1pZG516Urk8OoLvE/0YC2lPcnd/HD+u1AsI88/A6LjvXUMHJYz2IhP1NedkIQYKQuzxxKgakAsYFQA/UudKKcaFHta1dVKhKh0swQzsmbvu1YlrTaX8YE2nncUiug3xxBDzi6v1o965OA6LqcjTkH2IKGJlRC9tAcrTq9P0lSeMU8AqWY8zDz+V5jeOJpvtIHbKUQmDOcV8dwzBH3ZBQ+fMM2I+XtM+wW/tid/1B7EiBD5i0I+pYH6WMXjJWFAMYytnRMA0uGyqnWgCBceHvqFPYnFXhKjMWzllkCwbjaYAwhps+zDJ0kEF7OvFxAsvNt5yaYT8aGRRwuGbZCZMmoa/wv6NwCscvSF6Dq+xaS7TdSKPWRcqscfXgqW8x8Rb2JnbKl0VUJ3zNxL0cf9Dt5r4GVtoYEcrea7vvaVTzm+x5Buc88uChWNKr6aWu3cmleegxYTogHxEOyoKG+AL6ImoRGsGNaMHQkepkbtLSSO3C/gvkvYppVnmhmVGWgnibb6tw/yJNiRyAvZbZQ4GyOcTp+kZnoZRqnWk8FMaXyHx7ghQdJP/o0R1Wkc3yh
 wdqxnh6E
 Mb7YOukrFPo09sbykgDvgC3Y26MDTIuM4COdtmOm+2QqdYq704RXTQyVSou+z9OpffJ1MLSLHjPgEWp+LiDMFQX+QPHscfa4ER5PkG8WMgqWtZb85kuwYcex0iqrVQJUfLSBddVkDkHVydDkSQ9TKfQVHLpFqxEXnIVREAHVY6VnNrtFyGPfqaxfECRmHFrZEt+eNry/Riab8f2T3IIMAimCa+LWt2udnwYkEkwMwAYce8F9D67Aur9W2hkQnayRxNw/f8EvFb4OSZLi+N7XfgJbRxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_verify_merge_regions_of() is only for nr_accesses_bp validation.
But nr_accesses_bp is no more being used for a real purpose.  Remove the
validation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9b8423056d879..f2db39aa34f4c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3107,20 +3107,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-	WARN_ONCE(r->nr_accesses != r->nr_accesses_bp / 10000,
-			"nr_accesses (%u) != nr_accesses_bp (%u)\n",
-			r->nr_accesses, r->nr_accesses_bp);
-}
-#else
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-}
-#endif
-
-
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -3134,7 +3120,6 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		damon_verify_merge_regions_of(r);
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
-- 
2.47.3

