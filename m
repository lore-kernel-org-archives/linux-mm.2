Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D222CD98F8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA506B0098; Fri, 19 Jun 2026 15:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F006B009B; Fri, 19 Jun 2026 15:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00156B009D; Fri, 19 Jun 2026 15:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C66D6B0098
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 085B3401B7
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:37 +0000 (UTC)
X-FDA: 84897664194.26.7D6066B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64F2C18000F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QgQozR+E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUk5Cck1sJbUUjMgjgxqdG3j5G1J/Fn/sddbtTw+llU=;
	b=2ql9uXWfgvZrQ8mVB0ej7maTSxTBNjoXNps7vJsq6QRgw7kqn1/ShwGTC/Vb2TO5bARmY0
	d9rImhfnFjce10OIjGtJZZRTyAd/khR8cf3z6HkJi7ZqlQM7oKwkYTejYF7FYAp+YPkOIB
	N7lY9CCK+o/3tCLl3DhqRFGmvFc5Vho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897675;
	b=Jph21xDiZxitHvgVMI/qQd+NuGdvrSoOvMV9Yj7XcKRi5D/eBPeOsSQPOYXooURJZsHIWi
	LrJtsbZp/bW7wkxQb8BDFFd1Ay3COCp5CqDzOdjbV9+PYfDQ6wclGJT2gR2eaS3TM9oJAY
	q5mVy3ZNMYafybOWDRBkZB6dRVfbjQQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QgQozR+E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E9774601F7;
	Fri, 19 Jun 2026 19:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E60A1F00A3A;
	Fri, 19 Jun 2026 19:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897674;
	bh=HUk5Cck1sJbUUjMgjgxqdG3j5G1J/Fn/sddbtTw+llU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgQozR+Evjxx196nYAkpmjcXIrwW+sdgpUxyCTAjW8wWiUIxD6/xkdbLciJckZvuq
	 VSgpPpKcMQibZqrAxL4gxG+23aw4+gas8EyJHsGfLK0G8588li0ummvEHKzgbe2bRd
	 ZAqk0iTZch+Ab+Mv7P+FbcOKb+M1V7XHie6vxs5xngV1cLH3xekB211UI02FFoC089
	 PNno4ZJqLjMQX4bU7LPIMmPthlrh4BNDS3zIJ8GCLf1J9OBqxjtzf/bR76SfkPNm44
	 bEwLr9oMdClEc5DWiyaxoq8y4GrbjO/sG43p61qLt9zzKEKJxO95sUercut2mEzzOG
	 NwC2TmaZxkgmg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/13] mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions
Date: Fri, 19 Jun 2026 12:33:50 -0700
Message-ID: <20260619193415.73833-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 64F2C18000F
X-Stat-Signature: 3htjprp9kuxh3fk9qpis7nb8m58zuuty
X-HE-Tag: 1781897675-653144
X-HE-Meta: U2FsdGVkX182RKchAiqLa0/DD+YSqCSpAKZfOiN25PiNN7SmichZRVLleFim5g4GGsq5yU8HS44ro5i46VB8UXpLrYr54Sqn1PNSmfXx90WN/Cb2tTdP+Wc0q877U7LedTWDdiNfQv7AhcruF6tDHWoj2iYM63MI0/MpNvgu5ZhnoJ690NLeLAD/6rEFmvtDCSO6hgzxw70jtcoEY5XSoUm63lVwe5g5U6rhrQaAxGY3pZoz1ZzpR738NjE3cQHMaF86xBLY6EU6Oa0nHPFQBI4R3z+AJMWVkJg1cCIjHEuE3kT1N2hH7SSvdiJuThKt1a4wed6ddylV+o3GcLb3oaDOABvzTzxA0pLBhEiKDrFtaMqkJrl598Jy6ZN8eAg8oq7JZIpPM7H2XMstTrRerdgt75iJgxLWF6rqy+b1gLdYfW5CNg7scCt3JDl69iiGP7HS1e5QlQEwZ8bg3gT+nMsKbqj6+O+4cqEAatsWZ9FYGwVBWNgJBv6UdlHFwjmQEfZlsfJS8watrtO3unXLbLJThffmXXCFHvp7kHixrZg8ApWcI8TFVSGchPCZ21mVNkMn/r7b1NlI85vEdsQmpwqZrfDi0hWqTLzhQVLHxPnP96MXGnuzW4tOp+DILwHf6meN/GgVRVpkTrAsLidokRkKuUMHbkLOWNEiOPu2dmqUpufE4rHI34uNQ6HM/7Q+AeIffJZL1WBzBGs+8QZhSfBS1PFVQ1rQenni/yqHa74nv8AD8pKmDMb2wjwhIXtJnXsGZ4sOJ440M3yW52uzsudMbsfJlaW4FC6BomgDA8Z12tnOqFssGrQHEPMAOL5ifquRLKNpJDLX0Z7fucq3B1Ehrnk0y0iUJWlHghrzaqtTK00DIaSUt1RJp8Xtt2N22ysHMBuEQQxDsSPqzZHuyzvIem4K+O4LYyTNi+riyqQGfC1dl87rQa+YjxXTLa7VSOqUMSAVn/98hvYkHY+
 YruJG5Fq
 LDoOiNsZawZ0HRxNiLgUON5N+tpmSCMNnj8lWPBS1IM8virKv5InpDPS9PQWYZA1SocObLgQ3SDfpXKcyH55oZt57etGVKrtWD8EhriYxiIgqLhkBzKrJGvoJFlbCF7c4xZjY0kaNo6V9jK/0M/M+YJ4YA5gXyDOgK5TZBjsvYqoEWC7CUOSJaO+p3gya5cNIRmI2UX+TK54TaRKOJtIugvYY5zV5Rg3ub2AN3biwmyZDfmp7QDTL7uI5b3eH8lL5ZQeJrAil1m+BsXlWZ+SsbW4HGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors.
Execution of the function would be more expensive than the simple read
of the field, but because the function is quite simple, the overhead
should be negligible.  Use it in the DAMON sysfs interface for
scheme-tried regions, instead of the nr_accesses_bp.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 9d8fab32b80f7..30a007bcf82f4 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -159,7 +159,7 @@ struct damon_sysfs_scheme_region {
 };
 
 static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
-		struct damon_region *region)
+		struct damon_region *region, struct damon_ctx *ctx)
 {
 	struct damon_sysfs_scheme_region *sysfs_region = kmalloc_obj(*sysfs_region);
 
@@ -167,7 +167,7 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 		return NULL;
 	sysfs_region->kobj = (struct kobject){};
 	sysfs_region->ar = region->ar;
-	sysfs_region->nr_accesses = region->nr_accesses_bp / 10000;
+	sysfs_region->nr_accesses = damon_nr_accesses_mvsum(region, ctx);
 	sysfs_region->age = region->age;
 	sysfs_region->probes = NULL;
 	INIT_LIST_HEAD(&sysfs_region->list);
@@ -3124,7 +3124,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (total_bytes_only)
 		return;
 
-	region = damon_sysfs_scheme_region_alloc(r);
+	region = damon_sysfs_scheme_region_alloc(r, ctx);
 	if (!region)
 		return;
 	region->sz_filter_passed = sz_filter_passed;
-- 
2.47.3

