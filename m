Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8394AC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319136B0198; Tue,  1 Sep 2026 09:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA926B0199; Tue,  1 Sep 2026 09:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6FF6B019B; Tue,  1 Sep 2026 09:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBDBF6B0198
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BBD91C211B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:03 +0000 (UTC)
X-FDA: 85165248966.03.404D0CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C3EB34000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZwKYNYCW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/E3Oie88We+VUNBoQinHbEvxciAXpLnuOmC5tKc4/XE=;
	b=OlPS55uQTfiqhAOTkXhMuN5HMSF+5nDxiVQFJWM8OsyZqRwIH6wtz3BCWEcUlqfD6mwWGW
	4FAga1upN+chr94K3MjqfTwxhmDv7e9+z/65Lb3EqVY5oxz2q0NA/bp5/r9FUCygB78CgL
	2xa4lqaJf/r4MKdd+ImbcJBDvMxSSco=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZwKYNYCW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268741;
	b=D/APy7EBuFcGEL6OaxrzBXw9pCmqPwFuho3CAHJHo0/41DiUlOPOTL0GKOCR4/qvhDxQXl
	nj0EGac8iU+hI8C1/LN4I6CNveej/7sQhIAeRygwo75GDS7sGq1likcp2sJveFp/NGBNuN
	7c7sZjlAjn5H5KERuf0iY+op9iR5OAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67CD860A54;
	Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25D21F00A3D;
	Tue,  1 Sep 2026 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268741;
	bh=/E3Oie88We+VUNBoQinHbEvxciAXpLnuOmC5tKc4/XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwKYNYCWXkf3YcSo51XFKfIBjCb8OCl5BO+I54kmq6FiZHkliHE7g1on9UYpfxsdU
	 2SDIwQfVwj2Zf7vAcXQVsVbi8q3wupnNKn/brVsZzmIY3rYNCGLkn2YO7VOESECV3W
	 8OQIjhhtUNLHhUCyhUxO40Al8ceT8Izf16Ej6fi06DtaHFKPu/1bJFljhROx4NhcJn
	 doJSWRCIQJbfbftYigig4hpE6Yx+vjeUpX7HJLzSd9t6OQk7xxMevPVSa1x60QFS+z
	 c1LVdwXDuKxe0+hxv6I/2HVsHfGAYVcMaD2mfnoBkIE0SOzWAiBgO7oP+vSlj27mzZ
	 lXe3py30Y8SAA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
Date: Tue,  1 Sep 2026 06:18:48 -0700
Message-ID: <20260901131850.98037-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: <20260901131850.98037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: n1qrga77cqh4i7r8n7nm7mpihnjook47
X-Rspamd-Queue-Id: C3EB34000A
X-HE-Tag: 1788268741-706711
X-HE-Meta: U2FsdGVkX1+XOuGsapvY44Vt2kagTdU/ReJFMtKw+YCG6gzrb9bXtRcGxbSOgSpxCL255sgirYPFWGZLh+mbB19GbEol6AZwB2ekbyWjonB6Fcn7Fy9Rt4vKbuGrB0DywBKbis2nYoR7WevE7VwDEv+/BT9X+xpxuY6WkyJA0kjvJNNhEk5PiWD8fW5Dz0whEsrW+vT9aZczBNZPvA7vOrHYbfFGgBFF/PMZtwpoxpDMH2JNmXNf2l8jWYiGGqqIQQRFa287t25vaw9WxF98b06cAwA8I7uc44v2oG0cxjea0ciQKm22yjZ8vJuzxfj2/at1dbl7iIqTszUWIyYOisyjf6dQNegLJxZuIYrEDb61ntqPvYlbvNIveJDXEeoNwfBA19pw1B4Ikij/sNwSg2ygF62WBw/a0+fu8orIvGdYFfg9bZWQr7HSR3DumNbwxfrXlSdEgTkiBsS2T9P3jZRcGTtDN3Z95X4e4FTgn87+BV8Wy+Hq6nXLdtyBnRkjoK2HSZ5VJovUgBa4sa4cxcVexT+0ien7BopMRM7OzEqK05TugSK3dGgdYYJK60lyflkp/ZpToBHVYBj07G9xanTIt8Cm/9ST5VBfyfcgJsu1Us3kr9Xm8WJ5/apArt2XXguo2bzvnpLmHvrPRwjQ13ttBb/BejZdeC0VZ/z3yuJtNXCNEwecG7qA+cjcWIVK9c1/i6sY4q0yCeHIe0YzkMS4OeW6CYLQvfQuGw6pl8IJDQ/7O1lFZBfNedkhFWDPGMscFCePp0liB3u/3Si+saQQ8lJ68TzHJsUFEgowoOSbqxxjZlTkl2JQYbJkuw3pTSXo4kwZ0sQ7QIpDRs4mNdB5dArp6XpzLhLtapXH9QJFZd4OpJT73sxdkzm21FP47MuNCSi7IVpPFp/txL2oNjR5CqgNzY1tPrLycOrthTOPd3CQJVACkjIzlNeVU2+nSwvzu0MUyS54gGefxgq
 xsI5ufXk
 CUfmRdaqDJJ8eDbR0RhCPDW1TDDcxlbeDqNqEAWhJUDWwccE3k3Vpxd/2yqE50k90cALibrO1pFbcMAZTqC3Sf6CEPVwIjH1R/8VTF54Pp1CuL8NWQv4DZZoqp+ezPd8N3vENZkO3kqSA4qLW+GNtIKlrPiJqsxd93zzWbpVprC+QZuWg1w2XLVyBASZtXwXj9dg6qgWEn5ls0zbpwWOEe4wAU3P4Dj1Dfe1FDWTaLxDudmv2+HMaTCW/U4Rxtpmr8gKbzhQ6gKSURUqNk4UVJNSihQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In extreme unlikely situations, total memory might be zero.  In less
extreme but still very unlikely situations, lruvec_page_state() calls
might let the caller show used memory larger than total memory.  In the
two cases, damos_get_node_memcg_used_bp() could cause division by zero,
or return underflowed value, respectively.  Handle the cases by
respectively returning 100% and 0% for used and free memory queries in
the corner cases.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260329154813.47382-1-sj@kernel.org

Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ad3657d356fbc..3060edf5e4fa6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2854,6 +2854,12 @@ static unsigned long damos_get_node_memcg_used_bp(
 	mem_cgroup_put(memcg);
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < used_pages) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 0;
+	}
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
-- 
2.47.3

