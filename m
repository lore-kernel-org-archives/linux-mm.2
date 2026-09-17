Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C549FC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E896B0098; Thu, 17 Sep 2026 10:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F546B009B; Thu, 17 Sep 2026 10:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFDCB6B009D; Thu, 17 Sep 2026 10:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFDCC6B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4908A1A029A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:23 +0000 (UTC)
X-FDA: 85223469366.17.E0ABE13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB1084000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ltc9y5z/";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HzbqHqjQymjaA7BsBDU1/xd02tq5ixlWdlSiDNtUtY=;
	b=CmEBi4ZIDy8F3Eple93iQKN5566Vr2hhTdkOZ3mAz+9PVYaGobVbr2OXvgz9O6A2hjJT33
	Tn5t12Sg2qVrvMILBC0Y04m+bFfk9XA4RvdFUBPbCemzhCHuz89YJ/1OkC660QHhsrMunD
	oPwKrUC3WlB7USIhzAvnvMmtv3t77xg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654941;
	b=ZJBO/Rc+01PNut9CCHGLJ+u6xkrSLUudYZTr6QLi2IhY+DT5gH4BeyBhd9kSJb+MkEU6o0
	oDpK5q0wCYqmrsHHK9DVe6qqrjPD9xLSwoE+gawufQXePs6M6bG3kWxE/oXF9QD/F3uxn5
	yXd0ylbDuh7TuG6mIlPi3xJhkd7YiLA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ltc9y5z/";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1303438CB;
	Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F81B1F0089D;
	Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654940;
	bh=3HzbqHqjQymjaA7BsBDU1/xd02tq5ixlWdlSiDNtUtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltc9y5z/3ONggzQaz+gWDW8wvl9S5sQIQvHt4ii/ZG7pw4aYnhxQILLkHd0qMSIPd
	 QX5qZgfzGBZaPQWgqq1C3J71poLBiq5KvE4fNgneVsV9IfpdC7UqsBAvNIA68dw0Ft
	 zJOA2aa+AhZ+DLS10cWjzjM5cjN4gX1qZyKBvx7vhDXEu5Elbiv17UQwJsLvSx7lip
	 jWU/j0V+ccDF+Rt9HBkImVWV2l8JOND8kN/T3MDg0aVLDX5BgTyH0KUIrMnHhGmLXj
	 E9j+OlVfh6B9EKu6HW3ByybAECIXzsJLj/BmzBp4D4YFpkmq1xZEXhWJyV3YBxTI3z
	 S6LrUkRHOD9Hw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/10] mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
Date: Thu, 17 Sep 2026 07:22:04 -0700
Message-ID: <20260917142210.90829-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: f8iy8oedb9nqh4kfucunrtcx3t3rebkf
X-Rspamd-Queue-Id: AB1084000E
X-HE-Tag: 1789654941-129829
X-HE-Meta: U2FsdGVkX192DLGOxCYHJpofTp7fFwPDZa1GRWyYtadDbQAdZSLYuyw3cLwUn5lRl+/MtB9Qv6NMrzS3xvb2K/5+SZ7vLmfp2sBP5hmGi7D+/LPPzDpRflj3PTFcOsYLrwaN/1x6IFY5HIGjprKDrMbHnurr/kqnP8PtTznn8XKT2xwIkDLeUsDfoykmOQTAWueRetdxibpaISWNO0TkPXoJ4elsEF32V1Hy9dDQh9gMjStux0pOzll3IadwyINcdTr+31pYB+r8xukVMBbX3enzLpigkZAB1s7wsmjphfaYvOXLV9Hl0fkkNiGOTWcMY/vKifrmQUZx6jia9+12UkK3oHl0CJPwfwWNEm1qQf7mdarmuaIR56lCqtyDK0CfbVFAZ0I/OlBZVl4VbfS8JkN1tjEkenQUMnDgFL7WFvYTeuA7qQ+frPK+H26m5GnViHOVcbZsl5k2d1O2sZIPPZ4hN8DBA6HKqWKJ9oL59cbVyLKe6EBO8+aPPk7m6XbenFmShBxEmEwD8y/aUIdqHg7H1X81EipuUKIW99QENB8uS2mdZD53ZHfNdpVhewOY9oAfKNaozmd5ehcqEOGFKC1VdTmgyJccMRu+zQVNoNmhtnPAIvPbIC+rRePXuzeRAqcrblFVA0k/ymX+ukV/X2OXS2kyh2DRGvfAVJUL6w+8ylx7vnxA0tjQ/58KJDI2K+8jJvls9RZbx3liHF0zsBWYCJ2tv+93x5l1PvHsoiIbivlZf/trU25reK89sOoTrqRQiOWBz9bHt72p9TY7KLGAUOh/mrQfIxOkBvJlCBWH8yUCeHtAK02+c4YpbzUwHgDf0YBMTiabq+Kc7ah/OXkkUrt7uGPz9GoLkx5eciefpUQCEmS8VfC9JoQVcZWZmUvPj3wnp30kAk8GDypfSu/R62M4dEV5PgjgKWdUkLiJRn6+hKx0QMG9BCMp5OiFhwZOGpLLhHX21ocnH6S
 LOXeoQk6
 G1khYUVTvkZk0CvSR039gNXddimsbVcjjRBeClYQDuDQ4JvtT92tpjMi80OuCSQpmmAtlW5GQtbPIWSErZsrg70QEh02VFxHhv/OwcwyW7ktleGT7nApHlqL7rkMKtiGY8j0NzM6oZuZxhKZ5OepvpebI4P3gYnSobojQdKrGlTRiabxwCcsAcbKBSl+wb6T5nbuz+863Gt2WfFlCZtBS05dh9SzaecC6+oa6dhog+QsQtWM4b8nS5+iofth7wv8W3HoeOdblhYoCxWuXlBffIlkz6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_pa_filter_pass() receives the 'pa' parameter, but doesn't use it.
Remove the parameter from the function signature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5abfabaa339e0..2cfdc356b4157 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -163,8 +163,7 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
-		struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
 {
 	struct damon_filter *f;
 	bool pass = true;
@@ -200,7 +199,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(pa, folio, p))
+				if (damon_pa_filter_pass(folio, p))
 					r->probe_hits[i]++;
 				i++;
 			}
-- 
2.47.3

