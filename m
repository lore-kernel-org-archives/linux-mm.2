Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E631C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7436B00DD; Tue, 30 Jun 2026 10:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9512F6B00DE; Tue, 30 Jun 2026 10:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FDB6B00DF; Tue, 30 Jun 2026 10:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58C966B00DD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAA87120522
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:49 +0000 (UTC)
X-FDA: 84936782658.07.AE8CA90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 24A4F2001A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rky3Uhju;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829068;
	b=suX/dP3QfRN/GyupfMMUXhzhialoOUJLDQARXBc4wJ83emqZmoJQGfeSY0Lt7YUQb5eNy+
	pFoUI4Mt1Z4xD8VULKrPmcRyDboBeedJdZkE9miTS6ttvn8QDZqaL1q1SIT0wHY4ZLYq/4
	cO+QMDJDfPS8+Lz8P4XClTYgvZ9Uopw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LL+0Zjf9t3hBYduoXGS/7g+XduqJe2JKqWYU56ceygg=;
	b=SMUZfDy2WXE5Q0fihr+xP72auSsBB0PsLGvEdAP7Z68bZey84mg7ppHDgoUwxzV4sQmyp8
	mnXD8C3o2Vvua0SffrhVV6dWRDYSrrFOCGBRZ9gkrAzWX1x0u1pFMwyXzv6Cu0p5fHSnmy
	urdmK/JIW/U9nktT7/HPDHTnKFl2p2M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rky3Uhju;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDFC3601DC;
	Tue, 30 Jun 2026 14:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BED1F00A3A;
	Tue, 30 Jun 2026 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829067;
	bh=LL+0Zjf9t3hBYduoXGS/7g+XduqJe2JKqWYU56ceygg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rky3UhjuG2xBomQeg45ocsbvupyHFy7vbiUOjvY3IXqdgzv0LhvKiCXe5Kxw8+az3
	 PqOXy5FyuIEaFHdt0UYIUkm9RUX3IhHh4SkwcD4rSvF8fK+PLNlozG84Fk3+udaS2p
	 8LCW3PG0c8avqaDX9XhMmIMHAsIf7CwNAugK00CIds46WobXpWmTFcdsZ0lPjBQ5NQ
	 xJvV/2BmIN6cBTQol4jPir7YE+zR6Zo9nftxGK7pGRF0n88dVZCx74/sKbongXM0EA
	 +s++AHYy8nD6mv3L3ggJMwzmvCDuaFo4czT0oARLf80MwSvot4z0pDIAYJXzlhtzTy
	 pMUj2RRIWX82A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/11] mm/damon/core: reduce range setup in damon_commit_target_regions()
Date: Tue, 30 Jun 2026 07:17:22 -0700
Message-ID: <20260630141726.92246-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24A4F2001A
X-Stat-Signature: e8kot3y46m33y3w8zxnkuhk8w477mnda
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782829067-111872
X-HE-Meta: U2FsdGVkX1+1xVlHrbxRdxiRvhZrU4UTl9mIQCOIlTtYYELsw7QJxrE6o+rwJQUXbJr4JtZfqc4bgTpFS8wL766JIO84bPEUsVvqi3Rw7uaLBKWoWw/dqshZE9Li/Gxuo5cdBdKZEnnpyVVEAOoHChKje1IcUenco4RG62ddp9cZfAzMXNscLNPWWTPm+h+HHaN7/49UWFxDgrPr762Y12xdJd0sQu4iJpbN9fr7LS1xpaTH35DwuQ90dzgjOYO9tR1tggkbwEbzRGLeiRVpY85ixqVmAhrMVcPnxYANXFFW7r5tJtvYhjPpJBXFRQ5eIvTu7cns1v0ee4DX9u+CAR1dnEouSg+iK7/2vrmxkStw81rjkFAgB4ptrMz2+BMxF/565YLAq4QyeLkd+woA80maTkxg6SWUiPixCB4sVnSa9WojzhmvlLyHFf9+gtmY/20e/XHu4jSqUdjc/BqPCUX4XrNwSGo8eq4tTx53DrzBtka0coR7iYX5bTDXjUAxq0fpjnfIaYG57Q3GJRrZyJj5gSJEpMNXQ90sYJZwrKbbmwqpKgjHrOD5mEONFueCn4ZMZty5OxSnbBz76A0uEzieQzIF9zKA97MqA4QGDNjm1zbh9BrDO1ZyJepp49spEdZ+3WHXJBk0Nz4C3w4odOVHvBvzVOyCyLuqijaAkBZ/0u48D9xS4WF53nT6O5Nth59s5pkfLZnwzHi/c6QGvwHt9PgVX/zpV0ARTYhFIOvGfgYgqpmtCaF3L1ztqBzhwhbZZ20RxfHpr8bGtAEBouHb+tPxEXdQ3cYMRJRgQNouwcd/p4XcHQOfDRmEsxtIb1s/gmu62YAYA+5GHCS6A1kbsM2tVEvBNFQonVOubsRQROIGjmWdwq3vP6j9HN7YX1ysHdlFfVO0WfL9Gh4UA4WB9xXdlIlPli82G6dmlSTudn1qMALsfm9oY60tFsxrK9j0XDavGuwRzonZmUp
 LiPCDUBW
 6RWlX3txlsfWV/VIEeHHOTp3ApydhSebw9MvZaBzvXI5DiDRAHbXh2xTGXWvmkPH0tEjaeJkGy52FeM/qRYQezqVCdUcyUoQjzrX/v43MS1J0degJ4GBl4p8EgbrvEPCObyxQDyWbEv4HLWWyQMh0YqJepFaPmyOFfpU4KRiFEgkOUBVVkNP2g07mSda2+7y17VqK0IptVf8FHyDhRitWM4N8i07/SFM33GPP4EmrLeIia9bzgMFn38zJGN1dPvn6BOI+XXyT+X+SgK322+X1xBCLDAQ+rBMjE+zeAhhyt4p0Aus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_target_regions() calls damon_set_regions() for updating the
destination target's monitoring target region boundaries.  It sets the
boundaries same to source target's monitoring regions, even if they are
adjacent.  Meanwhile, damon_set_region() sets the destination target
regions exactly the same to the source, only when the target regions are
empty.  When there are existing target regions, only a few regions are
expanded or shrunk to fit on only the boundaries for disjoint regions in
the source.  Hence the adjacent source ranges mean nothing in common
cases.  When there are many regions, such adjacent range setup is only a
waste of time and space.  We recently found [1] it is actually causing
memory overhead.  Setup the ranges for only distinct ranges.

[1] https://lore.kernel.org/20260603112306.58490-1-akinobu.mita@gmail.com

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 59a91a0ab6d45..c6fc35be633b3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1414,21 +1414,33 @@ static struct damon_target *damon_nth_target(int n, struct damon_ctx *ctx)
 static int damon_commit_target_regions(struct damon_target *dst,
 		struct damon_target *src, unsigned long src_min_region_sz)
 {
-	struct damon_region *src_region;
+	struct damon_region *src_region, *prev = NULL;
 	struct damon_addr_range *ranges;
 	int i = 0, err;
 
-	damon_for_each_region(src_region, src)
-		i++;
+	damon_for_each_region(src_region, src) {
+		if (!prev || prev->ar.end != src_region->ar.start)
+			i++;
+		prev = src_region;
+	}
 	if (!i)
 		return 0;
 
 	ranges = kvmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
 	if (!ranges)
 		return -ENOMEM;
+	prev = NULL;
 	i = 0;
-	damon_for_each_region(src_region, src)
-		ranges[i++] = src_region->ar;
+	damon_for_each_region(src_region, src) {
+		if (!prev) {
+			ranges[i].start = src_region->ar.start;
+		} else if (prev->ar.end != src_region->ar.start) {
+			ranges[i++].end = prev->ar.end;
+			ranges[i].start = src_region->ar.start;
+		}
+		prev = src_region;
+	}
+	ranges[i++].end = damon_last_region(src)->ar.end;
 	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
 	kvfree(ranges);
 	return err;
-- 
2.47.3

