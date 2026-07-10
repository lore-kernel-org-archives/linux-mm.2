Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3939C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B02D6B0098; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9623D6B0099; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FD86B009B; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62E1E6B0098
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F01871A0467
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
X-FDA: 84972993168.14.2829638
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 629A7140007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yr8PFReo;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Afvkxg7JDGHDzuDLSPibRSpczK7Yb0J9zCK+iiS9Hlc=;
	b=ucDyzpWFnqDV1tYRL5+E7ewLafrukBtmYBZ6STLeGkjcbBETwrlxXinE25ZiNMj8siDAY/
	zH8MmiSwX1lxv5LrUidgbAZAjA3cqPA1vFNXRyk7cJjYGtzZpElzCjPKlWXF+wfdl7grB+
	9ThmljZHu3W56yYAkOnpB1W9duTvCDw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yr8PFReo;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691223;
	b=mvKAu0PPVy1TjDEsw6m1e0EZCn1sVzikijIFqJfXXHiE+NsWCEnJJHPX7+d4aaZ+BBRWaN
	3Nb9j+R2iDN2VzzIXeBQz/MpD+KbV+3oRv89jiS4OrNAM3uPqcg5rYXjd2PWp23qwRNOIg
	h6H1s7wmssmEDRC0waHLp7EmKe340Ns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F256F60EEF;
	Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DC11F00A3A;
	Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691222;
	bh=Afvkxg7JDGHDzuDLSPibRSpczK7Yb0J9zCK+iiS9Hlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yr8PFReoBPl3zYLmz2T93VhX5MJC7W+HZSn7HB/qd5lNm5UaPeDz+/2+DycWuKFBv
	 uFXxG/L2UvfnwJV04i7R8fZ6n/ydO7HuK5eGKNUNKDxSZBbkq/ac5Vk3XOmeDheP76
	 +hG9OHWUT5Y/L5kU2OdkqiZKDjVTMloOe6osgqdDRg3KRG7Bu0xEXDsgy3h5YrOzv7
	 q90P/u4K6MsKdYFxdwRf8NAihKC4osM4k9m4uqvW2ozZ23rmR1gpQR/KwFGsanRRNn
	 rbl046o7zGWhST9gGFlyFTXzBxY14fmDKrxLE7/blWzc4MlknZOVQ9ExhtBAn4unu/
	 4d+LZNz4r1YDA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/19] mm/damon/core: use abs_diff() instead of abs()
Date: Fri, 10 Jul 2026 06:46:36 -0700
Message-ID: <20260710134651.18084-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 629A7140007
X-Stat-Signature: d5fhd4sjkijfrerrjset14sx6ahek6en
X-HE-Tag: 1783691223-342076
X-HE-Meta: U2FsdGVkX1/XPAEvgywrOSgida9RJ9XzkSnmb+KjrKXadRQ6EW5CMpAzTATJnywiUKMsDbrI8bCG10krLNWw++U+URI2sIr9NC+KfWfNk9QdlJ2MV43Mh03z+NuAqIHMzRd2mvouP1w8t/e/4MTYvYJwgi+x6rH8u/OvEkWvkV9VDt2iIz5PvM9w7B7L5bVH+GVBgArgdUSCKiWE+Mew1PRThE6EIPPQ/deDZ4u/71/M5pxj9R41ESFhJWY16+P6Lyk8MCgkRZ2FLwP3WQf3Yn9AYP+kWWq5EyaRzIZXHUbPDDmgv8G+q5HRre7y43ml2koj9ODyvQOHpVxQaIProGMY5QgaG8mrerm1xwc6YtgjRUzi0w1676Cm0u1S+/+qbgFG1xNoa2kOeL6Ef40UwJC8GSKO7+cZiUMutHRYNOcXOkhEVnUecfys9PjilNfshwSltaRn8obvXJOd0o4EJ+OwFDpqGB0CDQXuXIynaKwR8Vl3M6696eALfiWYNiZvlUJJXcFtTbdFAXnDIv9Mr7eTaHSxCon9tTOZJNu0gdbGDviC+d+tEDYJO6VE6ogNWAB2zd8iI+Ijn6sG0LUj8dpL1AatLD0eAs1aPcqBLLY3ighX+SPKZRq6fTQ7/5F/DBNmXrWF8vvLuliF+npzx25c66Rkz3c45USKAh7qSZk9KsYXUC2JF3wq9b8QG/aIC4ZJYG/X2WEsIZG80sWmSlvxewZZZQ0Af1KwyjK1vtQve3WcET19Q0aVriOdiiTSmTowUhUHBObSdBNEA5HVP04D2arggzfV6g9ZshcYYmncX2pbTra8xLigGGAtSMq2NUvi+jO78Xk84xYe6sv2mGu9gFkZjzO5OERrXffqtRg0wo5FO0UKuePXdbMSj0aRzVVuV/Kf2KoBcTZUVvH/PQaKHTtG9w10PmeGe4u142kg2xUNlhOFXB7Eo5WgutVP9yufz2bs0Tz2bLCpWju
 PTx2l+Te
 UXtydfdX2ma3Iskcg0Snnsz4SlbySudnjjhAYRei5eSFPEx+j+wWRBLiNp37PEaQzY3nCXEWt+9COeEnIlr5N1V/+zfsvHdMhfGQo64Lv+5j5LRJJFF5iBI0LvQ25Nsci6wMU27LRRQC/mTrSUFkOsyRkPdW7jxK5xXJPEJjhW2Qq99rVJI6fbSv89SDf7BQ0Izh6YK33I4wq1np3urtmDsJhGkDh37ykaLGLeUrxRMBSoosYS19YSGZQgwCb+kq6XoG5SFmXDc5ozLhyORW2lSswDXMJ2kZp0fiADiPSUTqbt+VMUgq2fb12NlBmGRrIMNlSwFmRXq/2/2kiA+a0ygjAEcQYenrM+Tb7+dMEaBXo71M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use of abs() in damon_merge_regions_of() could cause a silent integer
overflow since the macro casts unsigned int to signed int.  It is
unlikely to have such a large value for nr_accesses.  Even though it
happens, the user impact is just degraded monitoring results.  Users
showing bad monitoring results for weird setup is quite trivial.  But
the code is obviously wrong.  Use abs_diff() instead.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260705213817.100841-1-sj@kernel.org/

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index fea97399b5754..4c7e8a12a9b67 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3261,7 +3261,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
+		if (abs_diff(r->nr_accesses, r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
 			r->age = 0;
@@ -3269,7 +3269,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 			r->age++;
 
 		if (prev && prev->ar.end == r->ar.start &&
-		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
+		    abs_diff(prev->nr_accesses, r->nr_accesses) <= thres &&
 		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
 			damon_merge_two_regions(t, prev, r);
 		else
-- 
2.47.3

