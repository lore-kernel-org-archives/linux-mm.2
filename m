Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BC9C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13766B0092; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D2F6B0093; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1676B0096; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AEA56B0092
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1A5DA05B0
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
X-FDA: 85206071076.19.DCE4AF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11BADA000A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pb2rwd3i;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAIupWOiZk1Nz5VeipyYWCDtbEHKa9N+XsP7giaox3I=;
	b=z/cx2BB2ZgeHv7MO8JX0u/p7YfGXH0/oKnkzo3Tw58p3cuJ7rOOTLh+vGjXV/ukCkJQ/NL
	V69Yr8d3JwjxOEURPyu0BK1zQyhwj5+/0Gfeiy8YbvpIly1c0VS7iMMr7ZLE01sZCa9UqV
	wUf75/K+TSkk5GgeSnwEJ08YB2j3kMI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pb2rwd3i;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240697;
	b=MzFGZcS65mV9ErQJJj30J8NqKCeVQn4ACk51GHLM6rS7EkfB2ad8Q4DP6t0O6XnF4ztduA
	Q/xu/2y6wuynD42YRV8BKtnIMtD1FyMGfF0tX+s7181WxZ/UbwpYbP6BbIhoP6Ujjz0Kqs
	QUfnudzqs/Jw1OGCZqOkgJfvS1YAWsY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5059F44004;
	Sat, 12 Sep 2026 19:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41E81F00898;
	Sat, 12 Sep 2026 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240696;
	bh=hAIupWOiZk1Nz5VeipyYWCDtbEHKa9N+XsP7giaox3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pb2rwd3i7YJEayi20uaPGc3CcA5bXzPFyUFJ6I+PnkBjhyagDQ/JtJWVamOJZF+QZ
	 GOBKiyeMwZ2GNRSpemAIE2yOVYItKsiz4HeJIasjJF1H5qRlhCmaYsdsXBXGAf71Cs
	 f6nfS73vDuIkg1HclAThaPxtO/A0l6G2sVUFkjxrWD2axGUwu1JD4t/zORtLzmv03T
	 sJwuVILiLssQCHhr8TbmtAavsdYwv1yVDyvdGmvvpC4XgP5d2RNC/j77EjuD4XsH1r
	 N5pcZq3qd2B3sCy6+ISy6uggHu+ZC3xFc8mETLPmp0lWmE5pqCmYuZ156H/9E8vh3u
	 FEBDLK2vkmtew==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/8] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Sat, 12 Sep 2026 12:18:00 -0700
Message-ID: <20260912191807.138502-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912191807.138502-1-sj@kernel.org>
References: <20260912191807.138502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11BADA000A
X-Stat-Signature: frknjxrrwbzb15jnrnot8pria6jixx99
X-Rspam-User: 
X-HE-Tag: 1789240696-432157
X-HE-Meta: U2FsdGVkX185JsahaDdC3NdrjjPZMQvscGgDpJ44BiV0ITDLESzENShD6fFyLzaEC7WuoxhDsrKbTp+zRi0oKc87tqg2kYKxRxcCSBWOqBnZ5V2NEQY9YTDE0TUEjiuJMHb95o1Y+k6LHDJ+S81Jo+5+vJTEBa3rt7iFZZfEgisp5717uzzWucfjIAt8gwZqVvjAscp5onIGKR+zn3DN4bzQ9+1qIPRow4LJwROTXmcvDBg/+2yrAiwAdUXkO7URIqcnQN0PEbrrDZBEQKPuqpoEyclLn27XUXgnO8LN6wbc07vdJVEOcFk5GdPJCeNDk90puuycjcR7upLNiwENZyFqH29LPe+8841NyUHc5Rt4/KRsD8lsbmeILoS36iKG4xjbUSW56/B1+CQZ288jGjndqPHZT58fh/P1pD8asMW0bpxEg4W2PN8LQQsiQjepWONuabK8LJMLx6LYAeaeoTu2opBg1FBvyjOSaIDPyPP/+CK/UG80jsfUFz9yWGs0RfeysFz8YvrohGut2QtDyfp6Q7gZcA6trJe+6OS5L41hwz540H/47pl09N/zghISx6TdfqN9H0Qq3vvPMVu3XCzyocf58MBUe3276Wbu2EXwLW2anpMgzQctGq+zvIXiDPFNOTTWYBUCaaRlDLXpjFLqlZ5Xtwg/1vpPsTMR2Ikf0oCGD/dIXUClFMrLhqv2m04xcqsXUg3cmZyqN5QRGWoIm99z72XnHOWbrLu0WCmsjN8JnUyEk4atsIMcXHiH5pJB+P03aZiRP31k2u2hWxcnmPThb9Tq1XDDC1H36HppfDgEqSNxp9zGNhoXix/3KVvxIBy4dSgeqZBjYLfazzjNw7qqYNxvzeqVU/rJnATXf45oyVgpMu/ButUyc4T5RFqfI2Um6D+zvXyqnxym2TVAkvTp0Z8wod2qRQq/7KQLXu+dsBMBlrVJMaaQtISCawCbVutj3QJuDZgJory
 6fLM2gXt
 ef5+es2ywS21XgomMn35gF455X/gSL0dkvzRa8pqceVLpDcjneAtVs9/jt09/vEsMtMI8i2S4Ub0wbznxBsek6Wm7oFr98xRsANlQoTfxXFibtDMdjOG7rHoVG62QJaHv+pWYI6zQc1a+EvsEDAvz+TUcFiEohAfgF76Y50Dm61TlU7fotoeLhHwZyI0uL0oxEZ1tYBYGQ9ltkg9RJj+5eZKsm97f5/H03L/Ufp2DBTGjPwW+OrAITXdpkO/yM/IavNg3MRyPhtRhWq3n/3kwEDMzsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface reads the user-provided size range arguments for
hugepage_size type DAMOS filter twice.  Once for validation, and once
again for assignments to the variable that will be passed to the core
layer.  If the user updates the arguments in parallel, an invalid size
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid size range is not really invalid.  It just
works as having a weird size range.  No critical issues such as a crash
or a leak could happen.  And sane users ain't do such parallel arguments
update anyway.  If they do, such racy behavior is arguably somewhat
expected and deserved.  That said, there is no reason to keep such
races.

Fixes: ea1f204ba29a ("mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3c1c1cb387fec..8c8ab82c8facc 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2840,13 +2840,12 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->range_min >
-					sysfs_filter->range_max) {
+			filter->sz_range.min = sysfs_filter->range_min;
+			filter->sz_range.max = sysfs_filter->range_max;
+			if (filter->range_min > filter->range_max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range.min = sysfs_filter->range_min;
-			filter->sz_range.max = sysfs_filter->range_max;
 		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
-- 
2.47.3

