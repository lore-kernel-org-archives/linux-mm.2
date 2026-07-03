Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401EFC44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6615D6B00B8; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2826B00B7; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED086B00BB; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 157D16B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7802912022E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:06:13 +0000 (UTC)
X-FDA: 84948093426.16.75F26B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E152A40017
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:06:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFvYdYsR;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783098371;
	b=1HnXsDU7VyayIgadSUfBwaf3+0uYbUfyY7Qb2nzUWZh//Cxxc03vEpBuU4aFMFw5HnzXvQ
	JHgaShfAJozVhAupE6wd9W6fWnWuw8eI44ZSskEcOWpNOAI01W7yj0BJYoeQuLzni3I5lu
	E9IaPVh5NlspQ4jcTd1I5HQKX5WeP9k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783098371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7SpLxZbspL6XS8P9x+tydUy80YkcthGS0kwmq/oA40=;
	b=C/o5a2wWX1CMipPkCTTHe9Dz4YgHUa975A7vnEeQqRozCF5KLHOB2viSXy/wM+53A9TNg5
	RImCA0IHK+fEVLxDLXVkhoBhVdo4AszM8394tixtziDgg3nqbpVVWr2vxfzujd8wHK5HfK
	P97W/IPczU4lE4YG2EBo/mopSynvrkY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFvYdYsR;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2F5E4099B;
	Fri,  3 Jul 2026 17:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8141F1F00ACA;
	Fri,  3 Jul 2026 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783098370;
	bh=r7SpLxZbspL6XS8P9x+tydUy80YkcthGS0kwmq/oA40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFvYdYsRL3i0VEf5ne4/mdRbJd6k/LyiQ6cT/yD5mjChsv6HxuduBrzDW25dgMVUV
	 Q53P/QbWdSK9vkZzxZntzJFRQ4JEC8REyaX+sBZtMeUbRujrFsfC+6nCemRuZKnpkm
	 VBxQtFp3GA9f9v7Mur6hs25dW02jcermqNQw1M9APQZgcP4U4ub2y7Uz9jOk0k7iHw
	 OnUhGys8xahJI4iYlPC0Due/m3O6T2BYLDoKZUXuEhfvGWgCTPCsu7F01yrbF6x56f
	 mErZviqFxfC/F98XeV9ur3HzY9mO8KHLwI8Mf1vAFdqaPgZzzdLXrRxLnn4vKXKHxL
	 7fgyGaHUDkMiA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] mm/damon: add damon_region->last_probe_hits
Date: Fri,  3 Jul 2026 10:06:01 -0700
Message-ID: <20260703170605.94472-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260703170605.94472-1-sj@kernel.org>
References: <20260703170605.94472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E152A40017
X-Stat-Signature: nwiotehf1pkftb9waygqargokizt8cnm
X-Rspam-User: 
X-HE-Tag: 1783098371-628843
X-HE-Meta: U2FsdGVkX1/OmYFXf/x+gKkxynsw9fKk8EDKZsl/5frB+0gRbxenvPqZHxEHB4OhymJvcwOsnKRRcslwoFRtcUlLeqzP3AwsMOA+nyLGVPOYozI2id1D+2Ebkogs2ClDoInmf7xc/OLcOtSXKZ4xe0fMLVBRFa15DvxCpNJ9/E0rTkRN69OZgyugbBr6eAbewwAPalSamC9c6mD7rVvU9auq2LSQY8XUEw4dv9FKgwRgkX2myHRwG9pW8qu2I5yHLrMLmTCYvJIL/C/7SAzUkRP18hYQbg7DMBueIxeCMwLPsbacNmBxcOdWZqVh7da5JgB+SKgRIUuvdKUYYJF8MdOPcYHUrd/6NZ0W5cSpOf7YvBEZJmr1op1PZZrr7Bpih6Ost28MP/Cs1MewZpc7SvSoFeJYcEmJzLmuGdZoGCm0qtE3J4q+GsF9TZXNmoWwwqACKLj+y/e07RIWux/NOKUF5Os0vxCpPgOhIOyCF33/DgOwa9DLCwjHg2kKN7eLc6NfPvm2qmXgsYRRvytdmLKQgqNbWyNESyMGqvhrXj6kDfYcgeWtZqBE0lch1LKPiElC916sgFLg9ss50O6sFkzAn/reFoVTa0L+MLxqzbLjLc1m5Er4uoh/RxP+AeqqaQZLRHpvHguCjtRwZGs6mzkb3dtSOyxFxH2H5MXhrDQDmP7rqI82UljVS+G/7DhGhcCg6WTon/0HUnwW2tqetMOmARbYeqfj/vfNQKcDJb5IXrB3L9nBarNjiJedGYm8/rLetrmbT5Vy1lWMCX70vbmHkwqzeTv1kjtKiP6vDnPlCR5P9owVwv3qRTtX06jt+meTtuwhQQKgKydIV3k1Jr5nc/oieBOWx00BmvcZ6f4cBb6HX992b8xeoGOcSwX6wipCrQbXn6bCAfZsJzEyz2P8uCytM14XMf8j11fujHWHoOmur5ASaGxHP0C6hw2op8B7mSZ2pFHCawW5Iej
 mhzf7sfx
 KUqRPe2x59g+FayDFYQpdWsnroPP2ZP1fpzD0sQetxEmqxV5CUpsqK5CvfYAQTOBOMNGDxBK0qRg4bypSni6Bl+VgFDrIM8FhfNY+XoOaw7D0km4BxrgNd9nBVjgbvFcKw3x25+LUUkAuhVMM9RIlZMGVY63cITXFP2X+zp592tRmwQRmwsnkPsEqoZIHNCLrQ+lCRYUkoi0zyrUurFk+1gcAUXskuKGmXLEZ9aXoGfHaht5UMPx4omQl/b3PbWNjiuFq4HOrOhgI0hxqnJtpOXSpfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new damon_region filed, last_probe_hits.  Maintain fully accumulated
probe_hits values from the last aggregation interval in the field.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 +-
 mm/damon/core.c       | 10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 805e089ff4f2f..4f7e305b261c3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -68,10 +68,10 @@ struct damon_region {
 	unsigned int nr_accesses;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
-
 	unsigned int age;
 /* private: Internal value for age calculation. */
 	unsigned int last_nr_accesses;
+	unsigned char last_probe_hits[DAMON_MAX_PROBES];
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index b2fc15a3804ff..d45dc87fbbd9c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -302,8 +302,10 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	for (i = 0; i < DAMON_MAX_PROBES; i++)
+	for (i = 0; i < DAMON_MAX_PROBES; i++) {
 		region->probe_hits[i] = 0;
+		region->last_probe_hits[i] = 0;
+	}
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
@@ -2047,8 +2049,10 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 					damon_nr_regions(t), nr_probes);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-			for (i = 0; i < DAMON_MAX_PROBES; i++)
+			for (i = 0; i < DAMON_MAX_PROBES; i++) {
+				r->last_probe_hits[i] = r->probe_hits[i];
 				r->probe_hits[i] = 0;
+			}
 		}
 		ti++;
 	}
@@ -3239,6 +3243,8 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
+	memcpy(new->last_probe_hits, r->last_probe_hits,
+			sizeof(r->last_probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
-- 
2.47.3

