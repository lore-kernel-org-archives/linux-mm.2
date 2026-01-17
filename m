Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720E3C98332
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9C86B00A0; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744036B0099; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573D76B009E; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35BFE6B0099
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7D7213A764
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:09 +0000 (UTC)
X-FDA: 84342202098.07.F6928D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B5A320004
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXkEbTix;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672388; a=rsa-sha256;
	cv=none;
	b=14WtKCvfXa6Wpqh5MJroL/Y3KdT5j66ETYoW2AlZusZG7Ug9xGDHI3W1afV1efac2CV7Mg
	hCoq8H0g+jzACeA1MGaeLsFbtDdvTuMkVrlWBNwttQfNVLd/b9/epOGjaHYT5741J+QTii
	eRMsAYJIdH2vKcyjEhCJ+2Uq5vzbhhY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXkEbTix;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZF/vYNu38b8wNyMi+8JZJIy9lZqeQceMD2Nw2hW1yVU=;
	b=yD1HTIQ6kVsbsbjvm+OEtr24oQM9jhR7ZdROv3gQZ0UQTYPTOAQWDZ+xiEFj2+5U69B0r6
	unwq+IkS0Gwia830YhhcJ0wTOsYp2GLsCL98prgyKierWLBwIIsSpDisvEhYQkK8eBaMfy
	n5ywf/Lym8/BQctb9uymHlisfgrZp8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABF3A444FE;
	Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CCFC19424;
	Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672386;
	bh=Xy1TOQuzIdfvAfcqzCUwqYv5IDB5V3zJCVUE3twZeQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXkEbTixnHyVk3yJ9OgZjXGoQK/cD+60CYlgn4UQIR1mT4RWUQ1VZZtgKDtOaYWEe
	 PgkdBDHBhhevYJxLxqBcMTAd838PemlUmYF8UKzpKQN5QST+zvbt7T47T45BYOTn/9
	 H8EguF1uJ1LCzMMnEC6aP3qqPi29keM2Uks89J72aYmyEJQ1jBI4CFD2cniIhNsI/7
	 hPy6murXrIEMhpIHETC4ca7PtuCoxcmkyVYDZIjr3jfYlRMMLnHBl3Gg26tdg8wllO
	 sGFI7862/JoifkJKccnKRTNhv4E3JKTKWETqq9EbDWXFvzTVfvIqsSGSCljrgrDUe8
	 daGnWPZk1fztA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] mm/damon/core: rename damos_filter_out() to damos_core_filter_out()
Date: Sat, 17 Jan 2026 09:52:53 -0800
Message-ID: <20260117175256.82826-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117175256.82826-1-sj@kernel.org>
References: <20260117175256.82826-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B5A320004
X-Rspamd-Server: rspam06
X-Stat-Signature: 4gpikfxsjnb587s7b9cuuowmfj4fkmsc
X-Rspam-User: 
X-HE-Tag: 1768672388-310449
X-HE-Meta: U2FsdGVkX19lwqeFE5H+Alh0eW2NcgPkAvz1/K5XrUDyZlpu50kLZUp5epQe1JDNUgjWTzM3QCD5fjMb+TTCw5Qah5KeFSNWfMNA7EMJAvUkM63hm/CbpbDOnmhrkdVxXtpM3n33kY/QY90jLMunaX9enVCUjBgQbL8e+3MvD/CxJxgRT9OC1DHU9QeRsUbSDlCr/dX71cwaP9iL853pHiIvIJuc7zIPAUJo9hrSKD9H7hiaUW9wNqlSBLxBLRF7RnrRpuOyksL+qZegx/+kqU0mY15gwl4yqQjwNKMRL11DfzJDQGEZHz7u6LKlNWa8tTphq+9YOOLcLjOPEYCaBv6lEFgBsP/9Kil/XSe4Vxxaae6bXvgP1WZGl0yVmXcN3/NPmi2ixrmRNmwF8EIJl5seaf7gvEfVYRP7HclDgYfkqAmrckaKEnrnocdJHcHx05RKld+yiDECKcc839yV87fYgRUq6fXcuSUsh+QDE4gCuxE4ZJ31Tq5ALqbhMsgFtgwfeop2bWrO5hjBLHNdxOytBn/Uld0/w7zOQFuQUiFjYXgXZ2JSwy00cRdzOrKuxjVGOdb6FxMU0E/e9VOeWfIt1GQtGN1sq0F3TQ+ejpYO8RgemsasLao9B29GG9nzcvR1/xsed0BZZSa2fP5u+2u5akl+uZAGsQd2c3mn2IP8C6qqgBYVPz2wkQ0fN9YoNxbVyBiSmdeY2Yfud+X8KUgPCR4YZ73IxYWui1BWjeZBP0+yWeQxrNvsoU+uTI/O00bxu3OBZbqI0ow9xQjcOwjM/gtwOa1Zvd0JH+0IB1+MCYNS7/4n2Je69JNwthEosWAmJXoDyl9d7MYIEIvV+xMvEVO6G0EPG0MNd2QwxJnH4MvtCJyxDappL73jmcuiAeyW02lqTvF9dZFOHJ5xIHSgOpBWovGGNSdGHYCd4OmcJvLkAZQjhWbtnBjAbZETif8YJFBYl5kRj2rdaLV
 Uc1p5Y1p
 i2HgcManNwvC9Ecbaj+ShyEnBIeX1DAo7/POd6FVwbmxhdlWifMZqxRcSwfH4hjeXBQZ5mZLSAivhUv4/n9cxNOYaTBeBnX+DHLipQPZo4SvaHGAIOwG9GFgNL3CCuIQ+TMJFDKVTQFNqwD6ILvykXEuJgjdsQZqJ08HyKBa9JsfO3b5Uv96qw7ZSaOYssab+ACyWqfub/6aed2NGrmmS0ETPg1LTD07gh7ft3FdiRF19kb3Ku4ItVjMdywp5FU9H1cnxDp5xWwIyOIMIboWcJhu1lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS filters are processed on the core layer and operations layer,
depending on their types.  damos_filter_out() in core.c, which is for
only core layer handled filters, can confuse the fact.  Rename it to
damos_core_filter_out(), to be more explicit about the fact.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 54a7ea98340a..ae5b772ceffb 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1813,7 +1813,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 	return matched == filter->matching;
 }
 
-static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
+static bool damos_core_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
@@ -1960,7 +1960,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 				goto update_stat;
 			damon_split_region_at(t, r, sz);
 		}
-		if (damos_filter_out(c, t, r, s))
+		if (damos_core_filter_out(c, t, r, s))
 			return;
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r,
-- 
2.47.3

