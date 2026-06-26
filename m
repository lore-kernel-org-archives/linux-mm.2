Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E6CCDE00C
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CC4B6B00EA; Thu, 25 Jun 2026 20:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4B26B00EC; Thu, 25 Jun 2026 20:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7932D6B00ED; Thu, 25 Jun 2026 20:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39B0B6B00EA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B325C18E6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:14 +0000 (UTC)
X-FDA: 84920149188.11.19D8CC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 063351C0007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hHikkI0/";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433033;
	b=phMOlj87d0LRvcls1jSEux+e5xBol4zecYEQyXXmSwyEHpb++4EfZPJS62wlNvgbPcp6a1
	/WGLiSnvaPoTac6vT1RyJM3Q9Qs0N1ACN0K6FMRfasYG/01OsEOYQpTCkdNuQnI4693BOz
	yrnNEKNLt4ZxxNkYNJVFyfqkrqInvFY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HI/zoVaSGKDNLoA6cct9QoJPib3MnUiHJc9KJcrjGCA=;
	b=dyszU7Ug34oEMyPyed4T9L0NqiXYaFBwJQyRRs3q9Yu2MGzl4EyUFDp0do9AD2AT9EhBNu
	AKFvyvFBJMKwy/ot7modSH+c4eCPferB/6jWZWY/bPyK3BqBzr50rFx/e3fv5U4QPhxLv5
	JCVwUyl18PBTaI4qjuNXHYQHSmdVuoY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hHikkI0/";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 740A1416D2;
	Fri, 26 Jun 2026 00:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0484B1F00A3D;
	Fri, 26 Jun 2026 00:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433032;
	bh=HI/zoVaSGKDNLoA6cct9QoJPib3MnUiHJc9KJcrjGCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHikkI0/xB2Rb+vQZH94XvX0XP5vyoUexPcbqnJtxxLFRTrE1ApHFCDX+z90CMalF
	 tb94E84Km2n3dMuNEgq16CvRfwdLqCJYiQbi/XNQPy0Sr2iiNaH7emyL9PRsrajJSv
	 rjMuDY7ydbqV2njj+lu7cM5GRc477x6sFXjkNygzOpA/qEyTKp2PXixY9x7VlFToxT
	 t22/4KDs8vn97Mm8N5ZYfoFvRpLyXkOR3hpPINq4AXmEwSXnIoqjFHVhAQQWdCZQB1
	 tzQldxmxhRnC5ckpj2zZqBrE2uM/vDMqE2gVSGcTXylOy1Mz6K9hrzWqiHGGUE8ZDf
	 EKh4tq34weOyw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 08/11] mm/damon/core: reduce range setup in damon_commit_target_regions()
Date: Thu, 25 Jun 2026 17:16:39 -0700
Message-ID: <20260626001644.85825-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 063351C0007
X-Rspam-User: 
X-Stat-Signature: fujg4skstkzu79ruqfjyxcg169fnghbz
X-HE-Tag: 1782433032-992519
X-HE-Meta: U2FsdGVkX1/l93MDSEfs2MX0PzE73tElNuOmQhJUYAJMar0MvKJHyH1PC0G2c96ZSGU//eF1kVcrurKpg7+Qp4YYCL/jjWkFwja0jNDjZiH+CQ9eJhPwc1H5ljsLb9iWTKInPM+ycdDBLpNzbdwe49FXKCPv3yK/6OC1PTRehecaLwjug+9GOewUSurchU2Lqr24b5cCv2OJ5/XWTTlGyRwrJ8tQ/3PaF43Cpi2JwNMU/KImTxEawJy++7XvurFLgDyWxsNeOUZxuXuyBXgF/QfWzFceV2RhhZXcukfSLiOPcQLdWL1OoaJc2v/oxSAgm4hPrd6X2mpYr/76Plh/HDztx0WnHINEttOERXvDUl3P3Bqf0k5bzA/qe1lcAKzKKF1WjsrCGAeF79sJJCGT3seUmQzcJOzLZMFM01m4OPkhivyr+piwfOANEPi9hYn6HZRoRgZ6I4zUWgx7KHjDpXQoLO1avFK8fNigZpJHOLDcobIoIAGCH838QzdtrhJKjGj8Q4HD59a0E63pvNg4BotfD7jEcH1bjsltrPGMXzbBFdCaVs1zjaXCOCYG9R+7emAeW7aIQrR/uR0rzxPDFPqwEcZtSVuyVYjIpHH0BIuBPEXxW5FaGk0tXJ0n5LPEiIgJk7srBpSptlP4L7iK8H6x24+OLRXJwkszZgcOBwfBjWWTEP9RKnGqrVyxfXH+gpYwfKqQWd4jygS67dEfgNu6uSppY5O+UyYfF531n6W2c3nBD7qV+xcycqiPk9U+Fn6HAzb0K3xKjTLtsGJi23m0doJHiWWY5Ke5hHaXXFtR8P0gNKycsKbovIrW1C2oS6HFQj42rN0WBLoOngjPwOxd5dR1X6QK6glYa1tKUJL7LMtuBBjbST/++ORKnyVVk91/vKaWBpoa88ChEBstNu2GCpGILqruCE7BnEE/PQmv4hoFxfFQscuv43/LMxiJUxgc+Mlp7nR2d6RfQ0L
 DzUZ6NEq
 rlh6i2Yoo4FwEUj9nYkbqIPjsPR0LauYhtuN4cm17ZpL0usPhW/1iMv3DMyJQQd2iqbSPN6t39IgFvnJIvMp2maJfeVlFBhnZMjhPYJLn9Qgj5O8LfpxDIT3OpHcelriimJ+9MktXCADxAJTkllrIxz8HX3pJepv6wIlgsoCnaMNsI43Bfri17bkO1fSIYVh3CfhqlOVXLGE2xGtUNYzn32j0+c3bbcZUjfrYdfhKxpFWJ7Gxeixfjc4KtXaoPl4cCAbaA3SxLP/DeV0FVain/M+jREFV/iAK9MabavhnPp/EgdLc+twD8MYzAtRlgKzO1iJKv4UIu0v4NCNlidnum80x1F97n7B46CCZY+kbQues/F5q3GScZOMbECgb4f5CmfcbvE831zFexS4=
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
index 7e4b9affc5b06..ce5294cb1b4f3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1349,21 +1349,33 @@ static struct damon_target *damon_nth_target(int n, struct damon_ctx *ctx)
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
 
 	ranges = kmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
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
 	kfree(ranges);
 	return err;
-- 
2.47.3

