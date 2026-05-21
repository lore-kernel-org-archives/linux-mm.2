Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB0DCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D886B00C6; Thu, 21 May 2026 10:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76A56B00C8; Thu, 21 May 2026 10:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA12B6B00C7; Thu, 21 May 2026 10:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EEBE6B00C8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55BD81A060E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:43 +0000 (UTC)
X-FDA: 84791673246.27.8B3BD23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A2C36A0013
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JtY5kwgF;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlDrTS/qDNMBtSrkkbpm6odK2sEC/p6nHvamOoXHSXU=;
	b=fvKKgSK03tqSYvIFha4Ly9klYx9gzdXPiyNWzwE+6mltHllyLevE4w+7HcxvvdMrVEx54u
	jLZdse5IN7KotLmHi0Rc9SwpwOZr1ewUwDJfPSMuPUnJEB0h4kCYUSvVoXkfUvWHfKrK95
	Zv5rwGVwJ7atbLgN6d+MROdQ6C6rmFE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JtY5kwgF;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374081; a=rsa-sha256;
	cv=none;
	b=wvkx5dNne5wT6OF1oJD3TDjXtMw2EjfKlGHSFnInCtWXrLKWsKs+7ygeNEYEmRTwmpIM76
	6ycQ7Oh+lSAY/LWjyvXNj7cYNZk6OjeSR4eKw83yUBA6GNo6vxBeHlMF5We67xGUJun0K5
	fw8mJ+EUyPAVvrS0fqLhu48xtC+Kc5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A48A2406F3;
	Thu, 21 May 2026 14:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF3F1F00A3E;
	Thu, 21 May 2026 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374080;
	bh=rlDrTS/qDNMBtSrkkbpm6odK2sEC/p6nHvamOoXHSXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtY5kwgF4NwiR351gN+IX2c7r/wJR+0aeF7H+sK8LicM/7/DxyiXigb0TCZ1ozEla
	 0RsIyyO4Lbz+bYSE71gTiHiEncqPdNwEjAwFHjE9PFGwQXfptpQx8MVzKARWNuF4j5
	 bUXioO3JgTlq0Qggl4aqdkeJUsipCmLdCYQHj4ztcuCwMGAMYvGS+k9HedAVX2vIkx
	 qOG7euYJG+CuXuKHcsz+GPig1oDr2n1hMWQtC59Y1CNr0J8yBnRu1umoNlKsHJFzM/
	 SbfuvdcQFxDNkXl7ogp47u87t/ROI5Loqe5V7v/dmaWoOgz8drDrXyVXyc35TDD/p0
	 JUEYKQKQluElw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 09/14] mm/damon/core: remove damon_verify_nr_regions()
Date: Thu, 21 May 2026 07:34:19 -0700
Message-ID: <20260521143428.83157-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2C36A0013
X-Stat-Signature: j4op3pbpkkkirdsqdnjg1jx1uorsi5bd
X-HE-Tag: 1779374081-996944
X-HE-Meta: U2FsdGVkX1/2H5ZTBv9PKo1wNuGUb1FCL3b5lgOezkTR8pHp7ScT79K1mWr5qCkK21zgb8znTHB2NatcfZP365oZgsXQtsfCHc2z6SNvxczH67v6bFIpkfkYpDB0E9+K54PByRQuZvjp1+ti41pseS+TXYup+DxSDx9lfw1batcuEBUdinHFExkLRraXsXkiz/AQwqTCMxgcHcbFsd+lJlt/ODgzxRh+pLWCJ9k+31aJM+jLoZr1LF6n/032/2WYKAS16+I4NTCE0oXGy0xa4d98TIEBILXNcPmJIifosbpTSNVJr1Ztig03dXE8nMaXBlFKCxUrV66+risz+WG9hBOgAc2K5txQVVegJOeZpxRnvyvy9vfil1B53LaxujT/zu8DlA15j3IdzFVy2QFVbAMom4Mc8ofAgkaiz5KTNDTsj4jPASeyp7ffHNtDUsuL5q2YjLGEIbGO9H5VCw4JvFum6289qJNpBTw5phHoIRXnDEFwrS2r3tiXzBDMS4/4Q+mZDBJNc5//4umMvlcwKYZGx1gY5h3r3VTK/SKrSkeDV3uQLAQsUHgF/k37vXZj6DkAZ0m8PWNkkIOWtMpE0pyRPy/y8ZRKE3/SAJwPqaNc5XHdNynLbP5vaUnk/Yiub86PBa3B2KYnqvOyXQfq0vKPOHIJc5K5ZvGMu0EMMn9FYr90W2hjy/NLWPpCQA9GusD/INTR2egNuj4NDQ3d8tEKhgWvAYO+RvFBQnJg81yJIdsOr284yA2KKpKs9ipzrR4IeAVEREZjk6rKcGxwFoj9+yO6lhnsYB91yLKZpnjDmx3myotGTk45zbcThFNEpJb56RrWA4FDt0hvDWxPovloQfa1IdlcdUGGfx9V4XipzQWPBarnl9ExLNJ40bjJJxiKuLskB59vwYIngkq9eypV0Wfp89euLQ6YT3LNUNbZ6PDi5K/QQ2c7bcvVnOXxBY18a8pR5/2TLGxj49Z
 Xx99LWje
 eZppvlMdgt/kYde3kmj43+Z5LgV9dhJZavDQZIUF+IguKU3TPGr7j4B+hOBFFplIwnMUqW1KHx+tSx5pEjILhnYAbChv9FL2CF+nd23s7XXnAXi0gou1MN4qHHWSLAFnE9TssISuOQp219qfpLXNCTI96vasz8bsNiVplwJC/dC0w132oUSbr9JSmCQ4MGKcuJ61X4sJDNLD3UeMoKVpf4TSC+ngpdEbChjpjOWBxgZFQ6EzgR1MYsb7pWNGX9NLrYSpmGkktuihS5xvXaNiOzb4OPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DAMON_DEBUG_SANITY is enabled, damon_verify_nr_regions() is
called for each damon_nr_regions() invocation.  damon_veify_nr_regions()
iterates all regions.  damon_nr_regions() is called for each region in
kdamond_reset_aggregated() and damos_apply_scheme().  Hence it imposes
O(n**2) overhead where n is the number of regions.

Though the verification is enabled only under DAMON_DEBUG_SANITY, which
is not for production use cases, it could be too high overhead.
Meanwhile, damon_verify_ctx() is doing the damon_nr_regions() test.
Because damon_verify_ctx() is called for each kdamond_call(), the test
coverage from damon_verify_ctx() could be sufficient.  Remove
damon_nr_regions() verification.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9cde5b47b9585..265d51ade25bf 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -686,27 +686,8 @@ void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx)
 	damon_free_target(t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-	struct damon_region *r;
-	unsigned int count = 0;
-
-	damon_for_each_region(r, t)
-		count++;
-	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
-			t->nr_regions, count);
-}
-#else
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-}
-#endif
-
 unsigned int damon_nr_regions(struct damon_target *t)
 {
-	damon_verify_nr_regions(t);
-
 	return t->nr_regions;
 }
 
-- 
2.47.3

