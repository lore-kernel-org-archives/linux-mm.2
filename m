Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16375CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 02:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743458E0014; Mon, 22 Sep 2025 22:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71AF58E0001; Mon, 22 Sep 2025 22:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658558E0014; Mon, 22 Sep 2025 22:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 543BA8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:35:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 025C1C07E1
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:35:37 +0000 (UTC)
X-FDA: 83918949156.01.F825275
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 57E99180010
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:35:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BpzuDtiL;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758594936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSYGHNukA8d9c5/9l5vtbr6yTPTZwVknnlvEbRywswg=;
	b=8ljVrdFRLJujpxPuLM6w529aA69YkbyBsZyAoXDGa5B/0DIh1W9wtg7MiiVsgJ1tSXl2PX
	puR7+51a1sxb4P3JojzhPS+qGEI2JkqPsxOnIJj1/amIwSRxOW8YRWQdQT+R95BAIPb9Eb
	2a8jse2y1K4HxW+vkJKR0BgAGdnPLZc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BpzuDtiL;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758594936; a=rsa-sha256;
	cv=none;
	b=KbEtcj2VMTxzkOiEoVjpsUoNosZbTbsEJfHBE9CnnGR6QYzdifKuXqZUbZPgPRPpXFlWsQ
	Vh3MFtilc686fglqEOGgPX9rCP9KtMDcRUzSAISb7NNSjGV17np3wpXYsG0Okj543Q6Kxc
	nLi0tNbfxxrYiWLSTv6HS7a1o3ORP0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A7D7440D1;
	Tue, 23 Sep 2025 02:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C757C4CEF0;
	Tue, 23 Sep 2025 02:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758594935;
	bh=X3eaLEU60ObEERuu3aBppzOV/d8IvjBq57A8xIsdI/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BpzuDtiLH5DjM5xwj+bJZDUJd9H++v0wIsLaURYcHdL0CoI1iS/7Nfukchbsxnv3E
	 lIZ1PabU334X9eotP8NB1uz/fIbH6JT7sY/5vYsQPYY5W9rkznQ824Ix3tKT9Gl0ki
	 TDDxyTGZoq64m/k6l16BONshHAip9pM1EjyY4rZ0=
Date: Mon, 22 Sep 2025 19:35:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, "Vishal Moola (Oracle)"
 <vishal.moola@gmail.com>, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org, Oscar Salvador
 <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-Id: <20250922193533.dd6081d78e9e98f47fdf8d3d@linux-foundation.org>
In-Reply-To: <20250913001034.wt3iw4nyrmldblhg@master>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
	<20250911012521.4p7kmxv46kwz5fz5@master>
	<5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
	<20250911032751.khtgvdhcqzyf3rgr@master>
	<3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com>
	<aMMGbPX9uUj7TfoG@fedora>
	<20250912010721.zd67xbfdava2u26e@master>
	<ED7450E4-51F9-4749-A74E-C3AE8927E577@nvidia.com>
	<20250913001034.wt3iw4nyrmldblhg@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4gm35am6959doe4jukq3r9bs7o7c35q1
X-Rspam-User: 
X-Rspamd-Queue-Id: 57E99180010
X-Rspamd-Server: rspam04
X-HE-Tag: 1758594936-775475
X-HE-Meta: U2FsdGVkX1/Brk+/n8cYXzPiYFD+Ra66tIthNPgxnOKTv5HefKZSr2WOG3ylgEaTVV5NmEGkrR2Tys0pi9vEBWhfxeBY+Q3NhucP7VdLQm2z5ove+DMdUdIthP1ReMIEBXyZlhvRmpdos0ZBzb8tmTMsNjOZCbnqG0UUCRy2ELjWgbkNzMZ7O5AUulrpAuT7vH7m+OCp8WAhn4o2nmJl7WqtYQsZK7gi1C243HQsJzGQj8b3iWaTMsgtTNzKg/Lhkh/LCLgpg1G2YXZcp+dPrh0eqE/cEpgHxZ4Ztdtr+thHT8ZE2km7rVyoUrmhnFaIK6nBYBxhrK/YNnvHnK+dxyLEwAy+6jEPnV5w2kzja69XcBwjYFUAZ+JgRsKLDVhQiZEJZG5m9edIITywOZ0FjplaoolC6hYD6nocIqlpvmB9p6aMsI/FAkUtv1rpGq7jWl4Ws2jJym0HpsxSaBjZYMBhiyG1gTOvPhTkAXKMFfBa0QR76L5ApSm/EZW+vxUQWrfXtP5wG2hubqNLl3Mw23k6ijXHBoz7bGz9Zf33pUQ0OW1IskYmQv4elW7eAQ6fQfvc6DYaH/BumtP1lmJ47+VXvyY7i5g0gML7Tk2zQKakOIibjdklybJSwPNME38zv98/EpnuZEuDdV2PfLfCSTO57Q4gsEpShOcKO52im3RFhwjH8cdW4xdlccOZms/PvvzFeli8uXxc8THbM9JVXkPD9LCer+vlWK3EGI/ormgCRsuquYD7dMdcIDU3LpDk9Dt2EE9tl/4t/vA5oWDla6BJ7qUQVYOrroI5EKr/OdAvNUcIKSgLMIIPnX0zqttxz1/7kzSfdd2bGFTaKn3JZ+7h+4h65+dEljnOumt8enqnj7bNA/HtzVbOnb0xMJ8QJhcFHrPh+6G0pl80wN5AtgbP1+T68RXwQwtcPddqS5CEb4iZEgoJ8PQ75qjcd9mDlChJF9eqjLyO/4au3hY
 GaF+11e0
 Spy/1wPmM4r6gjR8u7gmHOQu4geeeDJPDqk8JGPdqpYQqOjhx1uOW2RIhIPxp+q0QF039
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


There has been a lot of discussion here, little clarity and no recorded
acks.  I'm inclined to just drop the patch and to ask that issue be
reopened.

Comments?

Thanks.


From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Wed, 10 Sep 2025 09:22:40 +0000

Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
isolate_migratepages_block()") converts api from page to folio.  But the
low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point to
head page.

Originally, if page is a hugetlb tail page, compound_nr() return 1, which
means low_pfn only advance one in next iteration.  After the change,
low_pfn would advance more than the hugetlb range, since folio_nr_pages()
always return total number of the large page.  This results in skipping
some range to isolate and then to migrate.

The worst case for alloc_contig is it does all the isolation and
migration, but finally find some range is still not isolated.  And then
undo all the work and try a new range.

Advance low_pfn to the end of hugetlb.

Link: https://lkml.kernel.org/r/20250910092240.3981-1-richard.weiyang@gmail.com
Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-low_pfn-advance-on-isolating-hugetlb
+++ a/mm/compaction.c
@@ -989,7 +989,7 @@ isolate_migratepages_block(struct compac
 				 * Hugepage was successfully isolated and placed
 				 * on the cc->migratepages list.
 				 */
-				low_pfn += folio_nr_pages(folio) - 1;
+				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
 				goto isolate_success_no_list;
 			}
 
_


