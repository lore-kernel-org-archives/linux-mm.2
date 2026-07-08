Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38EEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A1C6B0098; Tue,  7 Jul 2026 21:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2406B0099; Tue,  7 Jul 2026 21:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA1F6B009B; Tue,  7 Jul 2026 21:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06C046B0098
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E17240636
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:03 +0000 (UTC)
X-FDA: 84963885846.27.C45892C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D4950C0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXtSayPc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474381;
	b=q5l3ZpqrBX+lF1sPZc8Gxt9gY89oW5gueUCeyaiIijbz7vcrPrZzy+0Y4l5aLqCmm7Dhhx
	4+tKSo6gYja2slcwRDAOcfgH1xqVCGajQmYy9Kg2Cf55UjdUMP45oLJw8Mx64fgnHUyDLe
	M1XpVW13dHPXWH8RYwtX9cLeHWg+PPk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXtSayPc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjsCU14SCNwzNXGXZ9ta5DksRZeNC0xj5z1tjd9bQ8A=;
	b=PBxazDULvjRmfqeSSGgOFBP7ylWTr4OCenscAo6+bQXH4T6ZSGRz1vvP6lcDVutMLZyYCv
	7qzhP0PncZ+WAEffO/SvMbE8FNbS3xhz4CY5pMowBOQuqO7lfw/Ceqh+2eCOMchbjbGDF6
	rYudrbf1AIcrGlyOM6E+VSEl1tRO7SI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C11143EA5;
	Wed,  8 Jul 2026 01:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7431F00AC4;
	Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783474381;
	bh=FjsCU14SCNwzNXGXZ9ta5DksRZeNC0xj5z1tjd9bQ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXtSayPcIrnTvIdhY8+194PjZp5sGsg8Medv91bhy97ot0hoTraDvNj6fY67jTCty
	 1crqQ1KHRomInq0HarD9mAMRIP6O2ltitsb7TrClu3EKRXJXZtsNmUtIqXsKAIc/60
	 9YNCMrGTDpwghpF3Ij+LGyiCDSA8HvxtXN8FGl6vsS+7KdpwEemGxB3mhzFMBdBQox
	 a77Pv25/e/n8oy0/GGaJI+dj58tYYzMMs+3TP6isNqHNsMbucvMVl8zlYrNQCTl9x5
	 SW7YSmh8DN6+1y59qrNK2RaynXKD1tKyZkDOX/VTiUO+UE8czZbjBL0eOajGc+F3of
	 Ez//E7Q0UPrCg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 7/7] mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()
Date: Tue,  7 Jul 2026 18:32:50 -0700
Message-ID: <20260708013252.95888-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708013252.95888-1-sj@kernel.org>
References: <20260708013252.95888-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4950C0004
X-Rspam-User: 
X-Stat-Signature: w1cuab69cht6iqqt86wh9h5f3weax9yu
X-Rspamd-Server: rspam03
X-HE-Tag: 1783474381-90395
X-HE-Meta: U2FsdGVkX1/ZU16W7GpWjuqRudfatJCXzLoijo1SS5i0hMZUkIfe2lxqAhLHbm9pZ8A8lvuJKTw0YO7jUdotvbkYD7/unIz9QSGKzFH12SX5Wbf8X98aSpi4JKvLx01p/lnEWkzU0DC8O4lR9A00q8TswddtdgRx5nWGVnGY75EpuBF6GMeKm4a/i5CfcyRyKofHZKc5WjMdRqpwgEsOAWFYkbzfFD7bcXRJt/Qcane9gwdvH+KtqA6ToP+89vgK+1+33sJJu1ey+zRNP21N2ZXE7yeKylyCeqUljZ7ZdLZ840C3Tre8WPr1KzfE7fUgz+xcGras/DqP/ybru3IKruvps1Q7WpD69aVYzD7NQiq0M+ALyM514rKZqO62yhmVZGmjUDKmWOUHZbUSZ8bck72UINzbtFSdrl/B2MUQz0L+9x7I85Pxp4Zrp6BNJfshzOrfYgRzlKu8sc8f47z3eN5HuK9kS8G4dWWhA938pyWZ5hVtjoOAX55XeMv0YtNrGv9jGj6btKpZlfiRYrh3nMyJsVc2ONX3w0XxPyjux1ZvufPiJb/NYGDRrQ/jWj82suLgMg5tYzjA5usN5kyFVuyYH8+V8mHgc34WLWx33rcNSK3ZKr4Cix3Ae8tIREbsfsgthiMgz+EMC/QZnxICJ+zIWDoixDKFArk969jlmpxOhCMv9v5k2PStBane77emvrP9+lmhrXaW9EvJjkuIrycdOG/qqK45Z7Z89p/kwaLlsTHgYcz2+dKlLGOIOFMvHPQN/aC8H9JJco7qCCShGS/1z6ADJz9MfK4ekxkGQpdVpjk0zGn8j9lMlfKpJm0USOgsJpR1Z4Io8g3Q5QWc3PT7yfkG6v77NH9kn/c595znqJPMpsxguUFjpYNZx46hQB4NF1QVxV2rOi6knizimf/1WKAQH+t7dPofsqTcENJ95cOuoWR7/I2Y3q68cleG0OyZ1mtvlYceo9VgZfy
 G6wh40CZ
 n4o1bIhijXwV+Xd+5vDOvUVJTDIJ6R4/lzEq4X+onQ1a7w2PvC63oz7qZqjmB1jVUAk7Mrzp+0v/8+7F1UqqGI2YXZpdlxZEm3Mejjnl72HeFSYC8Ie4mVjKPzl5EzoqbYrhhIw51ObFOGabYjfjL6pc+BmQNxMngCNbyi+6WJMJDPEQTRuwmhT6D/O9QGB9BupgjEbSS/0JZg6teTgp60sT73MaNxlxuF7NMVXZiWmYh24gNRB0oL9bhVh/CrXbYLS8/RktE2Ts9WS7kTeNKeMJf6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If damon_update_monitoring_result() is called at the end of the
aggregation interval, probe_hits is not reset.  That's because the value
will be exposed to the user via damon_region_aggregated trace event.

Meanwhile, damon_probe_hits_mvsum() can be called in this state.  Due to
its logic, it will return a value that is incorrectly high.  This could
happen  if the user requested DAMOS schemes applied regions sysfs files
update exactly in the time sequence.

The impact is minor, but better to avoid.  Check the timing and simply
return the fully aggregated last_probe_hits, like
damon_nr_accesses_mvsum() also does.  It is not 100% accurate since it
is the last interval's aggregation.  But better than the value that is
completely reset.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 15d31285515d6..11473aa1f70f4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -290,6 +290,9 @@ unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 			ctx->passed_sample_intervals;
 	left_window_bp = mult_frac(left_window, 10000, window_len);
 
+	if (left_window_bp == 10000)
+		return r->last_probe_hits[probe_idx];
+
 	return damon_mvsum(r->probe_hits[probe_idx],
 			r->last_probe_hits[probe_idx], left_window_bp);
 }
-- 
2.47.3

