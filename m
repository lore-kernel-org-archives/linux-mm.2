Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A06C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E506B00A9; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F72A6B00AA; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8356A6B00AB; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 597CF6B00A9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CCBE140177
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:39 +0000 (UTC)
X-FDA: 85212586158.03.2E1C0C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0AF424000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHui+Ibu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBpdI9GABjSpbOSBeiuA8iViUPE/b+K1BLYoiHpgDDA=;
	b=QZqqlkkp3zvBvr4O+GnVb+E4bcudoFErfZLJ+bc71Bov0TtMsOqRfvrR8wBNRRJkpOP4Me
	kwp7gl5N7JVGKUksLpvQQ1hAduYnDIuFUkvDIDJd2GR+7PeQW1GtUV45yQHmjdI41MGtT0
	gjGSe8+pJNPgsZcMCPwpkh2bYIioGqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395818;
	b=xxXlvYOluJVcVyp6HY6A641YFUjEqLLNSHsAMDZ5qVoCvNPzJ/iWe90cB3a6raXQPsYswo
	BNdpK4WdcsKZTuB0PJQz50mOlCT2QnjA2jO0dCBH4YYa1beGoZyrYFzCH5ut9oxn/gS7IH
	23aZFhnK3vmeQSOXjRJk9xRuHGqYvNg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHui+Ibu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 653FC43D53;
	Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C731F0089D;
	Mon, 14 Sep 2026 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395817;
	bh=MBpdI9GABjSpbOSBeiuA8iViUPE/b+K1BLYoiHpgDDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHui+Ibu6V4Lmbd00FMAKZfVJb5+IqZz8jTq/0v8I2B8+lo0FsxJlHmOMWSR0fMh5
	 JL2VXI5yolS7lMgfsDUfqWTgMynzKD3HyBjZgbvoQzMmJ3RlGf3eMtuFH/bmK2gMSk
	 YXToqSlnJMVRQmhYY9we8UpQMKHjy4V0hPjl1v0zyTEs6Qw/Haq7HPkh1kwds5bSOQ
	 jXArOAnECpOT850NqXI5lJoRHacAzEBSTVD1CUp1gLYdFXjPjM6cJiDZo+bYNaAQ6H
	 JGoi/mXF67cUwkrxdxos5vKiNjXPU/vRI39tUQCT3TyV8T+aF7HFba4PCsASHiy/K8
	 X14pGOEx9Ufcg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] mm/damon/sysfs-schemes: use switch-case in add_scheme_filters()
Date: Mon, 14 Sep 2026 07:23:23 -0700
Message-ID: <20260914142327.92510-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: <20260914142327.92510-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0AF424000B
X-Stat-Signature: bxue5qc85zdppxph17hqprpcpecahwur
X-HE-Tag: 1789395817-119453
X-HE-Meta: U2FsdGVkX19G/Du+RibzbBTCNzBTdCj6lARndqPV87WLQdy1QHTncylP0kqScObjDY+cCNy22kasRzDEOin1cy+PzPS1HX9p3R4TozgVWOomYpNVmnV2taKNtfHAEY4vcsFA2bMoOtw5bQ258M/GjrgM7PEAJ+x04xfi1jeuMw44rmaMvX8S+6MThEA+iecKFgn7ZwGsVxLtgyi4q/PwmIwP61/71x1FXTnYgRMohxG2bz9cgi4fZVNzZ8cIlXY4u5DafUQO+8XnwsYpr2IDem1OMql3TpTS6cSJukQLVw5J8vTF4+Kjyye9HcMcwc8spskI9zsS11V13Tjrp2SbUFBvTlIShBqPP2mXyKZBU8pClLW1oTA7k4Ax6yCY3kvSotIByoWRujdmbPfTKsb4dHgPe6iTVIbIEB9l6sZpXDpcGzmRQEd0EZDX1GjrBHKJVkd+Brp8MS7n8FOlAxSlvqawFHt2QkY4PIGBeX+7xOwng+oQ0a/7kToWvJ8WILkPl5h+7nY//7sT9MiRvZacfgXVXkXrO+wRATED0RwNtDfnefCGhDUeXlbuhYsT3hS+kO6CQ81koB57+q+6PmhITaXclhmvex+4uNys64TsrSCw2bJ3zY5hcKrXma5/sUKSLFxUa9SNT/u/V1vDjYAKjcCVTwh/AHSjWjvENr2OzsU4HVjYH51Ad4NgfAwmK1wYwu4nYjYLqASY1Ee56g9bZREmf5eKorGnHe41R11pTd/Mpl+1Fex7VHZ2UJNsmAsHhJPGn8q7MoqPkTT3Wpt69veKewNZd4BtVHJcmGCJZmuIsjS79UyFj3uMjk0MpnGZuQKKC0W0lrq1Du5qD0kaR2jMT7pTMUlbor/HNEZX+NWqO8T1AnkL+QwKZfQx1UvLhWnT0qyoJiowI1dkHbnZMiso67XxeCFRhOWPQrCXjM7GxQ4OvlYDc18ojwB4x6Hlimc54if9MxQoT2rRlKk
 UOsbiYt/
 P3Rwe4UWRfJCyKbuoWZ4NVMOnU4RU7Q1Af5/aoXrXqONNIatMYGMH3lXi5zfbLbWYZtxSiBpSFaQNp0am4yqVITfswenhMCaxe3gGz/hhn5CDxpDDdKENiX1ImmFVpsG2qz7wRq2JAqnrpeulpKzj0PIKxeoEqZ+RoijbaP3NQ65vi/P8pRwgQncJe40PR7hIMrDHI8VlmxTr8R/AJPAuwkD46LapoocVSX6FWaTCu5XSQCJl6K7FkTMgB9N6sFmupiZXEe1RuokNwrJkev3me1NHEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_add_scheeme_filters() has long if-else chains for DAMOS
filter types.  Convert the code to use switch-case, which would be
cleaner and more efficient.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index a4ec5d54cfbd1..bfb6f0bc3f213 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2822,7 +2822,8 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 
 		if (!filter)
 			return -ENOMEM;
-		if (filter->type == DAMOS_FILTER_TYPE_MEMCG) {
+		switch (filter->type) {
+		case DAMOS_FILTER_TYPE_MEMCG:
 			err = damon_sysfs_memcg_path_to_id(
 					sysfs_filter->memcg_path,
 					&filter->memcg_id);
@@ -2830,16 +2831,23 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 				damos_destroy_filter(filter);
 				return err;
 			}
-		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
+			break;
+		case DAMOS_FILTER_TYPE_ADDR:
 			filter->addr_range = sysfs_filter->addr_range;
-		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
+			break;
+		case DAMOS_FILTER_TYPE_TARGET:
 			filter->target_idx = sysfs_filter->target_idx;
-		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
+			break;
+		case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
-		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
+			break;
+		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
+			break;
+		default:
+			break;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

