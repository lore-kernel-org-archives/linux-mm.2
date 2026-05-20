Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB24CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D902D6B0098; Wed, 20 May 2026 02:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4946B009D; Wed, 20 May 2026 02:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C046B0098; Wed, 20 May 2026 02:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95F326B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B976120184
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
X-FDA: 84786820944.04.A098A2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB401A0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ID2DL7JJ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITBL4yRv8OcoOU4P8OrL5kgNMtEVib2v8kU4r8mcDLE=;
	b=Dv8ah7lQO6OtJ3U3I5D6bNKlZXjNy4UfwOTq742qbuF6kbA/lOns7qEZJymfydrTZgJxZj
	UJo1AfWlbuIeuqDnTxIf2ILRI+WRBDS888w9kumW2s6gvtS7+k0s+pnbxftEaMnF07apqt
	5d1Neyo8Mpuaxtm1ofUhjyzAcjs0uyQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258550; a=rsa-sha256;
	cv=none;
	b=fTaOOq2EHyxvoX5tTY++hDIXXxlgnEBo9IZEQ+UjAxHwzesXSLt/sKKjzX5J3KfTOfFTHc
	Rwx5qPM6XJ5Q8hTGbubThgWpiAMXQjUv5hOz92xzE68Tp4JhHYjvjumUJoL8CRrvFGPVx5
	tpymhttIidHlN8inMBdSLiC7Ta8CkF8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ID2DL7JJ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F2FD601F3;
	Wed, 20 May 2026 06:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D1C1F00896;
	Wed, 20 May 2026 06:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258550;
	bh=ITBL4yRv8OcoOU4P8OrL5kgNMtEVib2v8kU4r8mcDLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ID2DL7JJPYeZSQ0jjUwov/oRAgofEngWExW4R5qHk4QNfT3a1ueGBiU6/vghmEgOy
	 zXLmB+3CyWUq4Do47M2wUK4cixKI/r0Q/c6LcYCeu3aglhQscPBPDegJ9k1cVh2IRc
	 gYyBX4eB20CIJxroK3zzw5DOzGDTlWIVDq+VLH8Yc55J59LHhAJgkCveZ9h29XcUtF
	 1S8sU2LXEBv/gVz5CpWCEeNJItlChnBeOyg1u3ZPmd4yyr5MhtXJVkBeLB3otXfeZ8
	 +vbHm11QdydAhzpYAH0nRlG1BmAvHgCKkr29ooCS5lV/HshTj0ZCI8kptskSeFSxVz
	 tSx7A8pP1XHSA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/14] mm/damon/core: hide damon_destroy_region()
Date: Tue, 19 May 2026 23:28:39 -0700
Message-ID: <20260520062858.167011-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB401A0004
X-Rspam-User: 
X-Stat-Signature: nsc1db7ff4ifembyuxd6t6zscwwgggi5
X-HE-Tag: 1779258550-543793
X-HE-Meta: U2FsdGVkX188pr3WQpuT/wTEjDmxLn524XRfvwvjd/T1fRjx1K23SY6O0T7D//aKy1PbhmycxV1B6F2TFqIX+Fhei4CeH5Q4YCJy+xYZuNbsroqzl5MV616hY5ZIYKfZXUFjS+OV8ZNIi6/gv5qSv3M3X34ju18Lsp5gNEnVHjGpm9I6Sa7G2GFkJ8pio8rBVmXpUZrsIGDpq5ti8thlloRGlTHsBkzz8EKlrE8bmwlN1mkQTa4G3uT1RS+t3sKhHgucspIk81g7idegITFrMJCo/4+bxj0rItT65ZHDcgxc99GpPwoYs8HmTPurV4cGgzBpeNzRh76H7cwXi+u0c1tnvOEfdjk0E+R6jy6OrVlFpzFzt4JQEmQdNn+WsHikICkdLIt1n0OhcfF+9lgezTHaCybmhgQrQIHj49gCCOSe6wnTvN6bXb4jLXCUyxHo3FYXOz4GI8myx/CQ9GbpACddUDDVd0a4/Gx3bgkkVG7EIQcv59F1Lo1fwEA6/bTNqOU0cKfCTSvVOC4/THmTuGrElZByEuUWGnLIgdxGKz/qZmOAHsqJUIQVMBrND9I7cty0+u6thdMqOQCB3MjFuVMUd6Lh7JC8Iulu25/8AVZj32uTJecy9GzYe4+T0DHpioMnPyJ8yW6JDXeWtAV1mlvZcw+3LYfvT5n/Xzh8XvMV5VWrPYcaGgnyYAWfKu+l5/zxuoEr9vjcQ1SW+VTcVN7V1PWeWfc/SkmXU0d3FXxYreR3fM5Gt+A6yxyEDO9j63/uGn2IisHYCS/Wtq3VcGOkpE66UhH2AoqgZ0XStXJdF1ghOU9MHKRKJF41N3t6lf/7lQ8KkLh52e4HgUDrGKVzkpVgVvxg4EWxxm3GRTrHK3Z0DPamWVfp7dz5dMcFVpVaAdTvk1eUYpT6qpjRV2dz8Vo+AJ5MEdnNnbIcMOKLHLeF8nVupsSMp7W8cTi04+VTxrHc/ZNSQwRo085
 8I+e1li2
 WqXcbcC9AI3rcRim8FZNzLoW8gf+v8BGCSsuu2OkWJx4q2VG3uuxcClnnbZWoyubgmUbysWPe0ujdKXdZw8IlRmE6LKvKgMAhj6VSIdaYTUQtYFPVAaTH16DLbSomDBOPtLPjPXCmSZdL8Wx2+VC128lRgV8Izv9EGKBN55udR+KVFk2AELirj7eBThek5Tao8BK2k4WJDsKb7kWgn+xZeX1a1eS+iOpBxshHNf2yUBhll5z1Jr/DoNLnog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_destroy_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 1 -
 mm/damon/core.c       | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3acca7deb1693..638ee65f88dcb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1013,7 +1013,6 @@ void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
-void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 53b4bdd27b39d..8a9202937781c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -291,7 +291,8 @@ static void damon_free_region(struct damon_region *r)
 	kmem_cache_free(damon_region_cache, r);
 }
 
-void damon_destroy_region(struct damon_region *r, struct damon_target *t)
+static void damon_destroy_region(struct damon_region *r,
+		struct damon_target *t)
 {
 	damon_del_region(r, t);
 	damon_free_region(r);
-- 
2.47.3

