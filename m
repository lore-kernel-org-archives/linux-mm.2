Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE79C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AFA8E0030; Thu, 28 Aug 2025 13:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74148E0023; Thu, 28 Aug 2025 13:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF278E0030; Thu, 28 Aug 2025 13:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 982B68E0023
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61E83C02C7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:55 +0000 (UTC)
X-FDA: 83826811110.16.C18F127
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CED3A20005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XQZRxrmn;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SSW5wEQ6w1OdqHOYU6skUzAFDuwAqGEF1dVm9/worw=;
	b=B/exwUxesvdnMq/63goEcs81MoWOsKOCmFLr6XbKKLKwgYbanb+2mBIL/Yof+FFxfTqn9p
	dEwCOFIi3GIqzYl8A5fdb0i2F0im0+NtTe7olRcnUJYRfa9UP4sTddZcTQcPRKlZzaqmnQ
	EDrV0+NHY8y3t+S2khQ0/xBMiE77arQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XQZRxrmn;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401174; a=rsa-sha256;
	cv=none;
	b=AF0ek/WgG7LjaBGS4XfB8P4ePyP4VHysYG/YT8X7+aFKYJL6ISLXG8PI0MtNMEHRbFIQR6
	I6Lg5v+yUDbFrtPxAVBjSkL0hHuKlRkPxdtVeJOZew8+H7vbxX+2NV6rcMXk2R7DLmjvR6
	dTVkvzKbEp7KKJ2y+83dEesZAm5hEOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4AC4451A5;
	Thu, 28 Aug 2025 17:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E56C4CEED;
	Thu, 28 Aug 2025 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401172;
	bh=rgx+uucpOxswRbmVzaNKcGMA1yTfBZgSAqGGyfaZrnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQZRxrmnUXCJGUkcjyA/VIU9G1NHvXvMntxG/GelRHsRAbEEZMBDh8r8YO8d1weBx
	 SUqEv/LszGwvNbwYUsUtZIjhU3WOk8YWG+/8zZZ5jRraXy3tb7C9RSwk/RQm/Z8emv
	 U3Pyq+fmqntP7Z1vUr20VrpirTo5kdXjOgZIkobDOB+yrYD2QHLsDYWl7mxVog2bZi
	 fe6w8yzC8ScLgoJ+hd73ITXEv4/lduJgqP/nTKNsPOmudRPIaGtC01nbkZUPZT7n02
	 txxPetFCNvbWV7Ng6aNFmsoEZbGPGup5MyPte5q0EidokvZsFXa9eHGLeKuxF1wEaZ
	 +LtcFsTl4cFFw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 05/11] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Thu, 28 Aug 2025 10:12:36 -0700
Message-Id: <20250828171242.59810-6-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CED3A20005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gikfckk8s3nydptdyucoz38xgrt7yf3n
X-HE-Tag: 1756401173-665790
X-HE-Meta: U2FsdGVkX19a8cVwPMN4jjkGVYTbzGAfTthNq+psRCNWzkNDTiiz+O5k4Agsev92em81EWXwll0BxWVYpKXk6IiPZd3QDWT2nlJ3m6imDltq1y49pLDlCvCwxBk04O4ghNAXW6I9Iw/9hUzA+Ct8cSlBzm4vrbLeIHtOIbpN7Js2/STaFiUsrMrrFgHAkNOFxWuoNUr3A/NuubDl52BzS1CS3MhFSHHsH72WeS5Oz2gA9Kj+uOQdLJnKhd2gbJo/rcKs3Up0+4Tz5NGnB60ar3lGYnfG4noZBP5AmW5x0z8HuzWJXr9lM6tcbzgthqD/PVKqI9Ey7Hk1UoxnpvqJUwWLCH21dm+Xj4eqDnC0CoqgYsgGtQg7ZidcUbq2cX60MnE//QIAeyNS9wrhNAoyVpM+VV12WwkvjyuPBzQna076rrZcNCOL3ncEmMoHtSwOi5T2uS61Lta0fYpX+wTutskdbJXKkZbERqrQgiCveKsPuutzQ66oTViL3KVvhIbmY5ikKhyc3BItLyX2UpIbWzd4Do3v3SIsZsFSDsgAZpNl1KEnxPL3h1LG7ldlaCOzwexdNy7l0CfJ5WJsLuzUAUHiH8ZgUhJZzXMo6+0H7QWxniFzWJG8mv9HXmp5clyPg7BZ0ERtJPxPlNRjxi8niqv/+YwL4F6VrPSV5q0QPo6yKFQYY4gMpteu6TL7JHvrohkrzHhC+PcfULhmujnIuv/uaNgzqH9I+vXqMaspJ3lJ98bYj/NSMUu0RqEWwtqzuTqGyO8vqaTYhtBc0A6QKvuIo5mrVZBhTehLiVBNDodJRLJmnaeungMUz9ixn5zc6zb/D25R371FWMTlFERdQPbjKII8nWmo0ZwfnkAxct10TYBjo55pz1AfvLP6NggMcIxq71BCMRuAyCkEi5NTKRuKvZOnp5PQQDwVLg1hubC5IJohH+hqBiLQXU6R29vF4VjT8dAJA01ad2mbOx5
 fRAf24wp
 uLPiSw5vmtAfoNNOP+pslDLWhr2d2amuRKgIvDLO/CrZ7iw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support of addr_unit for DAMOS_MIGRATE_HOT and DAMOS_MIGRATE_COLD
action handling from the DAMOS operation implementation for the physical
address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 2cd1c9953983..0a122a8a9f1c 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -256,15 +256,16 @@ static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
 			sz_filter_passed);
 }
 
-static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_migrate(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied;
+	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	struct folio *folio;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -274,7 +275,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
@@ -286,7 +287,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
 static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
@@ -332,7 +333,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 				sz_filter_passed);
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
-		return damon_pa_migrate(r, scheme, sz_filter_passed);
+		return damon_pa_migrate(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		return damon_pa_stat(r, scheme, sz_filter_passed);
 	default:
-- 
2.39.5

