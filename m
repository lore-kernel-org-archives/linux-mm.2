Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17EBEC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EEE26B0120; Thu,  2 Jul 2026 20:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8286B0121; Thu,  2 Jul 2026 20:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF86B6B0122; Thu,  2 Jul 2026 20:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B84A86B0120
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:44:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 171A91402D5
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:15 +0000 (UTC)
X-FDA: 84945069510.30.AC4EF8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88D7D40007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=orNg6UEf;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026373;
	b=xA9PVFINYwU/8F0A1ygYSeXUT/FO9JT/c/O77x/mBlSLjQfxMX+m/7OgwSaz2wBNHhZGRI
	4NH1I1lxdHkn7SPcWqH/ozx5ZhBw7gAvEssFSwxTIhIikPksMGaUEkev2HTWfZZjxcrcKm
	71DIPMN5GknQoSOSCjFVWwDuKpaoBTM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3unaNvAR5NVnY1x+9C1/8TjIcTr9Grgg5m5/eq+8dU=;
	b=S8xG1rQbOd7oUKY4rH8y7xU31GLp2xLdnVBJsyIkJWWzFyFDA7B1XQAEr/a6j9jJE93SNf
	YYzXeZNqGHGJ/WP2IUlZVDsr8e4HSHLUZxEQTRK8mVBlMjsDQKv4SnS/UOgWKzfbA/LwRc
	RRKpN/GITeip2Y+bKIWFGrg5duN5bIw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=orNg6UEf;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B890E601CA;
	Thu,  2 Jul 2026 21:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA37D1F00A3D;
	Thu,  2 Jul 2026 21:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026368;
	bh=Y3unaNvAR5NVnY1x+9C1/8TjIcTr9Grgg5m5/eq+8dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orNg6UEfRALfBkf+MUF1sxATuW6DAkntBOP2Ths4c4tIdvd8knG/Eo1ZukPI6Jkh3
	 f/piXPhqqrMeVEIBMKNN7Ix8Ju1Oc4EnRKOqs2k+mAk1jSo9UrgdezXW3/y+njxdnq
	 s+L0eGAB9/+uhyTkh+4TfYCQe1yT4MBpdLR8MdXaq6xHLZuzXz6T80jfM4selgT+2b
	 psULNGSkJnJpIVgehJx3fPxcmtGVGEtRkeiopTmR6YrViFKji/KvQd1wZVsoYOTffF
	 Q1SgoifP27p22AB7/MvwEzjmtLU8BuSanGLDCSVE+2u6KY1GlMNQUv2/Ow7KuE7ovX
	 Faujjikv7epAQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/8] mm/damon/core: do parameter testing commit on damon_start()
Date: Thu,  2 Jul 2026 14:05:44 -0700
Message-ID: <20260702210551.95167-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702210551.95167-1-sj@kernel.org>
References: <20260702210551.95167-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w8zkfu5pmu8mg7nhk6qr16wzm6gzd3bu
X-Rspam-User: 
X-Rspamd-Queue-Id: 88D7D40007
X-Rspamd-Server: rspam05
X-HE-Tag: 1783026373-705701
X-HE-Meta: U2FsdGVkX188SK0/pfkRII2Kr7VQvJKhNaBR9ufaccwLr1TQyBJsWoycHO2rN4I3+vm8sBAvMca/S0afvAEhqmpxc/zuHYUHR8AVS7rL2EdBrImq5Q5ovTnZBKT2FrcSl/QXAkkGA9fx5WzribdQ0940Ny4h7G8tqLq2JZsrkatCJ3oc5/Y2gNOBfT7vyQNwiY+7f1pQwtsajrTiP8JYA1sul1/YxLOErK4TV+XI94NkJYJ/8rSEXRjhj+Mt6d2fRcD5GUFm4mwdW0tMA9CsTvjULFSyPlK1z1ANjNOY98OCtLL6OEBGtMC5YaU+Yot4sd9XnbeX7zrJXCPkB/QzpZ6C2ZXxMz/PTDFJTXnlzXHzqINVElU+y8OL+Nx514ie0mss9OSp7FVk48MhYLxBeqZ0aJqVyfwgvkdxWmwkR3F1Y4OksUa6Zk1Rv+t/ZDDg0b7iVL0BijGPpp7ceP9lYzIeXIEpuV0KwvzIOPTbvUXTlhQ0+66PprJbGJ8clt+UT7LuDcgYIM4z/hnsaDQcAdvhe35UfdSy5WmcyXpjK5wnwjSwWGIbPHtDCogp4pgJK1WdMbaQLDjhxD5fqDF4KVecwIqK1nRRQ3k0GQp+L6i4AHXPOGxN1EoYV5N4ptLe1LNJdmuqAFjN9FTVksIngMuo3QseyE3hT3natmWROqnORAZSIaWzkaTlC5yx8z97/jSuRxKzc+X3nQLKWLUz1jw2kX10LVGYS6Wypbk7d0k5yAmWBefaVZVYFSviQXub4WmaVYRoCmDyb6ezjz2G89XS4+97413CQDXVx05Kf78Larg64b8CnOHuF+G6K969KSKK7KFml4LBw84GBEIk0QjSNWuYt2TlADskzBkPojJvBgpnzWSNw+WFNtjhc23X3xmLiHMs3S2NZTZPRY2ZWSR99/wmJR6VnqnJ20nNA/ipwErhZ/BThF4+wVjxgwm3dF1xNwyYxRfqXeWdxau
 es0H+7tH
 0Sod9az25mI2Gc490IztIaSPck5IihLvK8XpqlbvI9tMuCd+EM/gv+n+ieXpzeSB38kab1D4mAGW37H8Kq90IGCO2tQNmsN6V+qYswAxqxgE5y1OU9lnWbfUcERJiMsbyxGYHJZAkvA8AgHtFrTrZ7u6eirlBwshB4VDlTSPMGmAs69Hxu8Uz+d17hb7BwB4GQueEy++eR5jpAoH97AZjrMnd3va0aXW2TY09vLdNwibMAMpIWXL4VnGabb1WXUJs+2GUtj3ooSJxDLpn7OYxIQ/+0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_start() and damon_commit_ctx() are two main DAMON core API
functions for setting whole DAMON parameters.  While damon_commit_ctx()
does holistic parameters testing, damon_start() just believes the caller
validated the whole thing.  Embed the holistic parameter check that is
already in damon_commit_ctx() into damon_start().  After this change,
the callers can safely call damon_start() without validating the
parameters.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 018dd5ff80324..ca301abcb9ec5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1865,6 +1865,8 @@ static int __damon_start(struct damon_ctx *ctx)
 	return err;
 }
 
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src);
+
 /**
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
@@ -1886,8 +1888,16 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 	int err = 0;
 
 	for (i = 0; i < nr_ctxs; i++) {
-		if (!is_power_of_2(ctxs[i]->min_region_sz))
-			return -EINVAL;
+		struct damon_ctx *test_ctx;
+
+		test_ctx = damon_new_ctx();
+		if (!test_ctx)
+			return -ENOMEM;
+
+		err = __damon_commit_ctx(test_ctx, ctxs[i]);
+		damon_destroy_ctx(test_ctx);
+		if (err)
+			return err;
 	}
 
 	mutex_lock(&damon_lock);
-- 
2.47.3

