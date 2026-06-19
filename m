Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 509E3CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263B76B009D; Fri, 19 Jun 2026 15:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C986B009E; Fri, 19 Jun 2026 15:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152C86B009F; Fri, 19 Jun 2026 15:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEACF6B009D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57BB040509
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:39 +0000 (UTC)
X-FDA: 84897664278.30.FAD586C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3F3D140003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKY+azgH;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zrHWh3GiVfO/8U75+2UxprSqwOj2/SBF1FltGYOX4u0=;
	b=r/eoFpgLgoFW7zT2cyx5LPWTJ3Mc12owv1AhGWZbWCAWH479o6lv0SohCziJnIvNcCVQlT
	4Hr9eEqU7RiraFQnGAaA5o613JQvQJJ7ukCZH82l5eE8cOJVhmpou6xWnvXQ9bfUsfOT9P
	SUJsPDwH8LIXYY36RJh6VUuOllh93eE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897677;
	b=sLQXzUeHnBfPJ7QfAqWspN0zV5lqWD3mv4zLkaww76kyM3ePeCqLhiklZhY66TNEKWY8GD
	tiWnggtUIlCeTJJLbVHKZErcqaQaPcS7DfLBfAf+fqhUqeNeIAnlv5RB4Pzgsrkq57Jj1T
	TnIDVzxfZtkQfeoMV8UYn8pbkUtZzIs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LKY+azgH;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C4C7601E1;
	Fri, 19 Jun 2026 19:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759F41F00A3F;
	Fri, 19 Jun 2026 19:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897677;
	bh=zrHWh3GiVfO/8U75+2UxprSqwOj2/SBF1FltGYOX4u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKY+azgH7CU74H5abuvE3sjjSthi2JPWe+ndYBhg2Q5Jw/8lzP/m7FtBppiEznQpY
	 i0qF19kA5G/LtgAO5iHYwMt4h7Tw+JoF3kNRkM1FCu7c3CWJqvTMRDBQ9HQrTK8OSp
	 H/7kzNURe51Mc95fmqz9024fz5E/79rGtrJPjPorEydMti8KnVDK0HF9+NoWFiAZ85
	 K3y7zXN53/6eltCI7SczLQ+mJxMpBHv2NwYXkhcVPJypbU62qNv4EupU7yBB6VWmv8
	 slBt+Nw3P2PdXeIU6yR53NcpSbzK8/TaGWkEUbeqVHJ5nw57VptPAgQ6oGdZ4liSh/
	 qvLGtYcn+1sUw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/13] mm/damon/core: remove damon_verify_reset_aggregated()
Date: Fri, 19 Jun 2026 12:33:52 -0700
Message-ID: <20260619193415.73833-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C3F3D140003
X-Stat-Signature: hpwz3srn54zkbt56ogp9eg6zf47jo5da
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781897677-997535
X-HE-Meta: U2FsdGVkX19qbL7GfEVRXAa55vFBjYhjgbqg3QPNYJdcYjPj5Gi4VJYr8pfqIH47feUd3jvWCq3VKzsdq1Wdb09tOPEToo9v6ETY/fc7ooUzMzQB8Zo3rFWfxRlSyh9XvX7uyjkrOgW6Jn+Zm+UCwAGKwzsUHztcgjqkZDs2hzbt37jLtfyxTvYyH7cMK0ut7/bQRsWYDYNgz0q5J5wJrvaWRhLIg7Md2fOzLX9yTcNAbhaa+NbUZfnVFRF6UDtoGXGA9kjjIvlJXxUGk5ij5ZaOQa3kVtPaRVw8bVUgd4aN/gwrp3jkmOaYhG6imuHMQ8A5MpIvqNw9j17pIke/mHdo6poe3HtZDotg8+YWliciTaxDd+4lnEP89XEvDOJBKIttPmfRa+M+LK/7no6mLqUztSM/FEjMkLQbcV9HAljK45O83wJx294uR2IsKf07ExjTAVK8OazuNUdsEv+Hw+xcgYwi9D78/axJtBJOwAu+HnHgYIPQ854Fa8wtW0wEFuMst/KP3p7MHPU4ep6e/oGcIWohx/6osS+roOJ1UA1rY67OXaUbvLQJXNoojdue7B5HNFQwmtE2VuII2/wLPxR2+7qmCKSlAaSRIsPeP/TH5FYjbKvL0MijQNRPNltZ19FEGsWmZCi9l3PNcEMthmVcT43+qykF1GPpA4P7pZLx/liaM8jU8SU9CpfBhWsqNz+sD3WjZLrSUzx4tczqVE/6Uvwlteo+FTs1lcJnWcC8PeUNNY6JVZRb8PSVoo75Y+nx2NiTGLnLrmusS8JGsXngNNZaMAIONRgXKQo/6Pu40m6fzvh5TbUTXpRX9Wq/vIDWp/ymnczLuhruy/WCr9ZOTMHa4r2I6qyJ3KWHqRgwS0rfjbbv8h2meH6usxbcwe+j3V+Cnh9/kA1C87+ZPT4gsR/9UNIQAhqnzXX4nxupFmqM9R+BHVfJ1m+LHjv+6sGPhfDS5AN17PKgEiu
 A04Hyy1u
 UUANmO769T28FfMMZqB3h6dx76P0CaAjqXfIifhbQ1HgJHhIPKcvYGufvrAGdhwdXXVkisNmgS2stXsFf4t0JvGbDql+FSRFU9c0EeAktcFIjVtf+eaIHUKh1dUhJTCwnAQwLwhRW/RPLzteulE5ilFLTpgUuZFyZQXoH8VaHbwInH31sfp80ji+wRp6c0VrUQTSZjO1YNPSxLRB4WGZTYYuVdbAfK3wJTpg7ryMglr5GypKb0aZX96TUTUjjrONe7qVUkUbQN4/G5ezmuquaxZZPRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_accesse_bp is no longer being used in real use cases.  Remove its
validation function.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 12d09d2f7ea1e..9b8423056d879 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1992,23 +1992,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-	WARN_ONCE(r->nr_accesses_bp != r->last_nr_accesses * 10000,
-			"nr_accesses_bp %u last_nr_accesses %u sis %lu %lu\n",
-			r->nr_accesses_bp, r->last_nr_accesses,
-			c->passed_sample_intervals, c->next_aggregation_sis);
-}
-#else
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-}
-#endif
-
-
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -2037,7 +2020,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
 				r->probe_hits[i] = 0;
-			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
-- 
2.47.3

