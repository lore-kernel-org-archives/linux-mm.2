Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F27DCDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514886B00A2; Wed, 24 Jun 2026 10:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4E76B00A3; Wed, 24 Jun 2026 10:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB026B00A4; Wed, 24 Jun 2026 10:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 055E66B00A2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82D0A1C5C07
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:36 +0000 (UTC)
X-FDA: 84915016872.01.8133777
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC17B40006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CwArp1Jc;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310834;
	b=INTd8KNA9Y7ls8EwTi3d/Jl7QpeBWUtdn6nSPmrOqPkF6DZyM8dehKMg9zYjSNAeaEpa9N
	SVPR6+AqQATh6ITU2A9zEpGbVBHErlZJR9GLyI7u414zfup9FeETCNjAK/6YYiXeCFsA7V
	bddveS3C87//hcpeLsKtPktSYUivBOw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2mraUvSsMm7k53gR/hu+9iLKWZ52dB0SyQlMrxy7JE=;
	b=7r2Iz34YRD6tt9QkqagGu47Mo6EvIGbfKNuK2GDBHVloH/CtQac8IUEhmUBYWmzoBwc34H
	lMx1fjyypYz6xJqFhPmavz6I6SljNaTj2ur9kHiGui+tLTHvxU+fTprSVsNnTyB/JxbZy3
	eYeS6tmQO0IK4MSmcnM7DNmivm+lPUs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CwArp1Jc;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D39740DEE;
	Wed, 24 Jun 2026 14:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444E31F00A3D;
	Wed, 24 Jun 2026 14:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310834;
	bh=e2mraUvSsMm7k53gR/hu+9iLKWZ52dB0SyQlMrxy7JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwArp1JcnEolIG6QvpKI6fGN7Me2Or60i0nv98sy+kzWXoE1nbJevjLFWONNSxwAp
	 IEYf3Ew6ek+LBBpWi1AV9ixRNEBjaD4GzvUM532e66vCmpw7vdqne2zscDPbH4fM3H
	 HR7TUCe8oVKXRPp0rq2ug9ZCQUrGaXHPsNOUGxpaQPYXkWCYihQ7/YybA70DScugMT
	 ynPvn+5JRwQs6HfffXf9W7vTzLiXk3mI7rHZEA1CPlAF4KQKllb2r05QFc6TbZOmrE
	 XprENZRd5VRg3t9uGHkerZvJqUYvH6y7FwxOuWdbn5SSoEzyJmJq0RKlRBs5JSPYZH
	 CkGYWUwFkd2kg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/11] mm/damon/core: reduce range setup in damon_commit_target_regions()
Date: Wed, 24 Jun 2026 07:20:04 -0700
Message-ID: <20260624142008.87180-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC17B40006
X-Rspam-User: 
X-Stat-Signature: dtdmpnmmh67aty8annbu8gz4k3mszph4
X-HE-Tag: 1782310834-652647
X-HE-Meta: U2FsdGVkX1+HmXdasMmoHOvUCpaIItnaB6pEqhxKTvpLb0hChJKdeavOMORIRJ4vjDFy6LlBxYREpDE1rTrqW7lgVqWXK6f7dngr8USe1V+3n9PVdHomkSrgbCQePxUd36+aQ+PYb75Ui+WjqeYDnBXjZT/MbdesrghRSOaHj4xxBbyXZHDilP+Ff8vdqDKonb3Yd8cgXAt0GboNNVHN1CEWx7yoR7hlYltFi5BEDnAux19Xnm38i173c7OrMkjwWkfWBswXGYO1l6VWhqRD/PExfoaYlXXSruoZnNqLMN11DML+8hsczi9iTHT0lI0Tz7sf+xquHh2zLz3F3BYrcCQgd6bnhhx0XyZFhI5Re1u20QsH8bjgo1RTyzt2A2APUeg43rx/cDzOSPVixtST2me4gTIa76I8FOM51L+N3T8C4VekX4FP9N+zQAMltgHcjcoyRvVLil4V5bdHlVQlHEn7yuaAL1XGWXNDUOPKMoJxejgirbShY9x2uT3TMxwnvs3sv9C2XUw59WkfldBIQRiIJbYsBw7u/I8lu8DmyhcO88iltQtHY5nt0z4QdfbRq9EqBZ+7VgvhL/we1AR7DU2IGkeKmP5BzMeiI8pvaEV9LHKIScUqU9izuw6ZKy9Y9A70xMF3D0efspN1nqIhWpLqemUEisC71atfpVX4ZPFyQqCj1s4PyOGaS+uuloQG1qLOzhyiAYb+GeyJgi04MD0CrkKRHeOjf/CSqe04Mut3WbeMZaaO9i5DFjLdtJvscaSR/10Valqho90ayLYT3/uACmh+nNXU5QQ7lyXmYRUyTzmaeYsieY04x+BytlHjlXatFvz0eBIosOVdworcaGtVRC20+ok1a2LeB3S3Lvbjpulhal67e+XxO0Fa9Nw29UQSMFC+Q88CABn5mP7igqanw+EfEPUuSbejdPif1mEoNUxv9HgC0z6p1PDIS7UYOz/Xm9s8r/6kY7iiZSi
 7I1vcFBh
 ccU1qzeIxbBUtv2NiynUHdibGgylrEIaYdjeMJZf7rp7Us7QdsCk1j6WY49UrMNU8FkvODL5WkRdR3XbxYcj2o9E3jAjdkbtGKGyzApn0WdSyB037DXai6wck9cTJ8giVB/Y9w4gUhRMfO3igqTbiMhW4p8mHrRjtcvn0uqICs5jQqmISpoBjI8yYwGWzhe7RXOT67/pntuzSEOvGTwpZfg6NV6UMTL2MboYs4xzdQCTBOgaGnH1eSv82CZMa+7sENIpjRN09ZNo8qN3N6k7MSWufQoomyG+i9DWXuA4a8hKAzgr8TYVse0pYsA==
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

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b5f63f2f726be..10deab847ee71 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1433,21 +1433,33 @@ static struct damon_target *damon_nth_target(int n, struct damon_ctx *ctx)
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

