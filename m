Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4994CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 21:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA586B008C; Sun, 21 Jun 2026 17:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136626B0092; Sun, 21 Jun 2026 17:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E511C6B0093; Sun, 21 Jun 2026 17:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB28E6B008C
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 17:42:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 136E21665ED
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:42:47 +0000 (UTC)
X-FDA: 84905244774.21.326AF15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7538220005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:42:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7dwOt2Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782078165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJEseaHHCaR7alUdOrkcXmwKm0hManVh4CS4wmeZKl8=;
	b=3bXFgvjd2ZudmBmSYK7nmKeDDc5RdFBuxMnN+ezSh9iABWotPq74zMEbvt7TE/N/0vZ1sJ
	FBUkxJ4hEIY2w/lJmAON1ypcacC+KaavYPaRLDMceXrsah4W0mpiEtLrZ+ALDxRpu5NEcZ
	GkGWov/bstIA3K10+oWGEhyioSrrxnE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7dwOt2Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782078165;
	b=8L+d1wvrYq+1NoLXqoGKipzicFMNskW5N+DZCGaP+QTQ1EGSXwl+OmndF3LiZ3KbVDiWRN
	RlR1f71PUGWMevmtOHlyloPSrKjldVbmer5WMCU4Z6kOxCwaLmTbAKFQiqSKUzXnRERdmG
	MhTsqjZncaCb7R6ThiD76A+dU6xIxqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A185E419DA;
	Sun, 21 Jun 2026 21:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D6F1F00A3A;
	Sun, 21 Jun 2026 21:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782078164;
	bh=tJEseaHHCaR7alUdOrkcXmwKm0hManVh4CS4wmeZKl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7dwOt2QkmiBJlXfUdszrI5fH5+4hgFIvD7ZXE3Z/8a5xTRMbUNiPPS98OSm/zH2q
	 nWgEOb4ZB4urgWp1/s0MDh9avHxANqF8WOj405jXQiZpD4DHj2xUihgDLpRZAyS/Al
	 JgFHbfY+skYIjmmhrd8uJ90+/plH6P0J/tY6wWkgh3eYP2D3DzpvP3JU7J3pPiB6YJ
	 78hIffa8B8/LmlfUVAwwiqDm3ihxRr+QpAGSFhDIQfPLG013DRj/PQLWK4JMbD2IMB
	 /4ew415c6MkoQh3Rx7sbvPyAL/JpiKBWwxyzctgQe1QTA4wQNjVFfyKA1kxoQroG2y
	 q5wQNpjPsPBgQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/3] mm/damon/core: introduce damon_probe_hits_mvsum()
Date: Sun, 21 Jun 2026 14:42:29 -0700
Message-ID: <20260621214231.13449-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621214231.13449-1-sj@kernel.org>
References: <20260621214231.13449-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f4gzbz7isrmit9zbpfkgd8sb7ojuk7p8
X-Rspamd-Queue-Id: 7538220005
X-Rspamd-Server: rspam11
X-HE-Tag: 1782078165-915939
X-HE-Meta: U2FsdGVkX1+9AtOk6qEG1v1JRcXhKLOxhISqTBEVvOh01yvCHJb+CD3p1VRzikvM5Fnu+v+PrHCsJG5ZQUbeZbYAyoWZLiqbuGYZjkylveb4zKF5JVTKv699BgTRfzRzzLeie3MvKecqAPc1WZKDw4+IT3vjO7NTIOBgKY5fJMDuBhM48iKYew6OgR0HSOZlOsWCX/wdo4brP4HyYGyzNUy4GOB38xix7K08uSY/Myt4AWkxe/ZCq0dXro3ceD5hM98A+VcOHLGByhI3Fn3rqssmrD4Befkfo8HLJfyth90JLmW5GIFvkPxWlhIR4NkJhMmt+SdjtdVxJCfyTEz3cuj8ZDWSU01gkvwwtexj1XD703d3PbMKZHMBieHv2yUBNyNnV2bnqqD/hq9zb9GU1u/IFiShmTQ7kpN7HyHXOTStlzirIOvcGE955t5MXNVGQXVNFrlyh4gwxCFw4iCSoLIz6wcy/D5o/auqGva8P/QKT9ddT/erPOOIB+pQ5yP7kwldOoMlgP9k7jqiVHU61bZF0HR7U6Khw+NeiirybJsxOtKF5rZyMRZXT2YiwKtqjf5QhzuyCoUbFoKyEXWC2Dh0c7sVuP+NHQV9DpOHHDLzQ6l2rd2LBkaZh3dD4w9etSb/BLYnivUQgd6H8rj3ooxW7ZWTfTZXNlcc3MEeQBa8+g2i2KzOQW/XF71Aud43+20N21kYXZjO9grQtXMH116mi9JwUPlIVlFnX3sbsGDsUxCZk4Imm1EaFWd2ftZ52bsXgdap8TVt6316smaI+7nZB3ImYFwDcBldu3yquj0EfnQshDeJL+ZVKj/g96GyAzEF4V5A2C/JdChAgt34acwvj7FtgpkJenHjFX0/gcMUYwa+yJj+uQ8SlBABmosMCHQbemqQ/0BDfSVu8nnHwCX78+/Z48s3biSVkTeNCAEG1e3S2W3T5RjQ3Vua1XGKKQvP31JQ3bXwtjEtETX
 5/ixFdD/
 Jj4s2d0K4nkx5rWIot7sj/0NKEWlJRub9BqiU++hmghQ6KNdwLSzFczw3K5XPKViBeyBwLDhQA+cEfbZmdNPmnzfDWuu1kpNIlnGfybfVQBp+e75PMl8+23XdGz36tabc4OHO3Uwah6pAUPuZoFz6I5Io8bU9g/Z1IWL2CVoy9zSVFYndfAJiTKU5aG+k5e6PmDetF+FCcxQL1mJzx3CFOrS9pzjeVrap9KReipgtawzqfQxKu/MNUcXMN+UVReT4UBNsVZnbm1itQGBf0UFdXuGZzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a function for getting a reasonable best effort quality pseudo
moving sums of probe_hits on demands.  It reuses the internal function
for the pseudo moving sum for data access frequency (nr_accesses).

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f0dd45ca788f5..46394171cd2d0 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1005,6 +1005,8 @@ void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
+unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e84f2f1b07cc6..b5f63f2f726be 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -275,6 +275,27 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 			left_window_bp);
 }
 
+unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
+		struct damon_ctx *ctx)
+{
+	unsigned long sample_interval, aggr_interval;
+	unsigned long window_len, left_window, left_window_bp;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	aggr_interval =  ctx->attrs.aggr_interval ? : 1;
+	window_len = aggr_interval / sample_interval;
+	if (time_after_eq(ctx->passed_sample_intervals,
+				ctx->next_aggregation_sis))
+		left_window = 0;
+	else
+		left_window = ctx->next_aggregation_sis -
+			ctx->passed_sample_intervals;
+	left_window_bp = mult_frac(left_window, 10000, window_len);
+
+	return damon_mvsum(r->probe_hits[probe_idx],
+			r->last_probe_hits[probe_idx], left_window_bp);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
-- 
2.47.3

