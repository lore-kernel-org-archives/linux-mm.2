Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B2AC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E22B6B008C; Mon, 24 Aug 2026 10:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793406B0096; Mon, 24 Aug 2026 10:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682476B009B; Mon, 24 Aug 2026 10:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD3F6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:30:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40F3480178
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:30:13 +0000 (UTC)
X-FDA: 85136397906.18.7271E68
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 797D312001C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:30:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f9h+3crU;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787581811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkA2C/lQgXcypv6Ly6gx3bJF+pwu7LTevogMVJJ14Qg=;
	b=bQiTr6WbX3yGqy3VQYLo7Wsd55x5Jbt67QueO6/k4+Z+8BPNQTCI46wQkz9XSoeJIeFc8i
	2tg+iMtTGg6S3uifFtP8hFCiMqLvZhGmEYBYUK8rwx/ckRB1C3AyxHCyBlE6JJLcJTDPYb
	SKiYhr7Cp/v3roMUPcdrdAfM//BE5iQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f9h+3crU;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787581811;
	b=tTQQLwvVDFgynUJB5exqmo1viBWdlnVY5QJKKkYLnVGr+sZUI+rfqs6ZE3Gu6OLYnT5RjB
	oBATdAAyZLAf/6iwxjYo95bRtgrvc4gtwNbaWWXQuYzLCuY1B85SmO1ct6t7EwXaLrVub6
	3AAVI8f8z+IpIDSkDIzji8JouARoI+A=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-84c4d4f68c7so38291317b3.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787581810; x=1788186610; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jkA2C/lQgXcypv6Ly6gx3bJF+pwu7LTevogMVJJ14Qg=;
        b=f9h+3crU7ulZoadwlDFPVc3wHh+aXzqzw4Wi3v1NPu/80DEGEbjEh+tPDIxAcS1DoK
         f6t07WKMOIswJUTJL5nrkS5ICEtLkTbUAEo12xta2qv731QrsbCr7AqcbM7yYLnjoyvw
         5CY1YXOyMG1qp9JKOizURjVvWO6iGwq03OZRwvMelhN665HglazGpyaWKocblUTc7lA3
         ERqI97w4YsYow4Nlbo6QClAEIx88n6BcBCrCzZDcFyw/4p3O6R5SU8EvCXOYdxiCe/sh
         bOzglMwky5tmD4NmnxQzp8YE433PK7zo6h3SGbJ1yrVPrkumHXFRotL55k+1CK8FAzOJ
         zfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581810; x=1788186610;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jkA2C/lQgXcypv6Ly6gx3bJF+pwu7LTevogMVJJ14Qg=;
        b=Q2pvZB29N1GOblzjjc+bVV/obt1qGKQ5np+89+fe4Ml9HPfdsFugGn/gSSoTGIENnW
         cYgd5XxMZ6JlP0F0JxD9iQE1zvdiUy/zldIEnHpR1UAmwIT5vcCYzAr39HvAuiUYQqnj
         17R4YO/ISdLVqzFyMzoiOfwsVxaCHPpjqBrDMC/AnB2VffPT6xIOWl8ge2a88+C/VjB2
         dzn0Bj9YziFPqgZoENYI/zFUigcYdYb7p1qkbUpI4dgEx3hTIGArHQQKKvteGulQ3TQx
         WtCsmNMdLwsB3dc3SckHn4kO2OO3pmbBdP9rkcLu6BmjwCSFYpD3oGOE7xTzcZ9K+Faj
         LUGA==
X-Forwarded-Encrypted: i=1; AHgh+RomKKtbsyu8/Wm7YvF2Gw8P5+5L73UguemE+ZthkFkxTTfYqFBDlQhkWNVyX/Up84bvsP+TAqmdjg==@kvack.org
X-Gm-Message-State: AFuF++lapdf7Q3N5Av1GoOBuA0fPvIvAqg0bWEsSzKaeuyTy9C5cqcQV
	QxsBZ9cHqAoJfTayYU5i8oQR2jivRlU8T0UHTMGlkE6SPUbjsZeCeqkxZR6ZGypMvA==
X-Gm-Gg: AR+sD10surt2LwQ1kqkPAde6GPhSwz1n/oQ/a90L+wBzplsqoa3w3XxaXyoRL8VlDbK
	DREyhdOqWyKi8YGLB+BUwZegVhE2wR4xhTJ0BESU8k8F1ZtuipXc/vdk8dKT9wJ0cCt8SdWJKhW
	mnYOcG//pFW8NjnVdFlze3E+GjASuQG9C3TAKc203GokgWrlWvr+lEokqSNOuF96CboQvNR1zFX
	CEKcCHhCtvvwN5KlemsXRpbiJETh+k+b89S2M6JIvsI/5pB9G6DiLLoDGto1nmT41v2NfPgpxZx
	79GXBx+5CLdfzg1mQkGgKqTCeHgHyAJoxo+POiEWH//yVmU8Hp/6P2yDN6Cv+SM7er8u640t4MY
	FT6d1EzFHG722te9u4IRqDBPXeRAbM/UFkT1Tb1+deqA9uoL6Y74KySY2V2DQZv5bK/1DwoFjkk
	7bYSu86wI9beNWHD8iBnKa8UcVVPGhkGcQ7m9hJXBZ+D6RObJ0vlLojpSHUdW2NbWLJUZgRa8Bo
	Wt70cjtFw9ddRWx1/1Qu5AO5ZmUrVQzkKaml+QHbfBS8bTlVC/306XxPZA=
X-Received: by 2002:a05:690c:e29a:20b0:81e:eaaa:535b with SMTP id 00721157ae682-849f6c946f8mr72860737b3.35.1787581809761;
        Mon, 24 Aug 2026 07:30:09 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84caabb9e88sm34055617b3.29.2026.08.24.07.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:30:08 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:30:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 16/25] mm/fbatch: remove lru_cache_disable(() from NUMA folio
 migration
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <a5147dfb-cefb-fb9b-7162-b537e54d9bb1@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 797D312001C
X-Stat-Signature: j76fea3mwwowwyfu71tmkdi498g46znx
X-Rspam-User: 
X-HE-Tag: 1787581811-962991
X-HE-Meta: U2FsdGVkX1+02KaonbrWX+W/b//X2B3eEltiufqivnUpHOVdQoLQFmYNexgGK+huUQDBXrdP/ZMXnlKNhN4T8SZbzpkOvMsg37CmRPPxGtTN7OMb0JIarGYncaSC0geMxTPAVn4Od/D+K/RjprALOxC3VhhGveZOuosqdKrE0knL7IHrdKKyPOyT+DmefOVR/7DuWufZ5pQJrhpNG72zjzuof4bV5wPNQ88f7YrP/Y3NcEXglc5sUYz/rTYCnWZneQgOCcdwRP5/KixZmhtUTBuoe/j7um5IdBE3AvkH0zwrNu60r9tb2N6cDZJNp7VBkjDPRPmQEH3HXKYi1cwU2gc4AMuHxzLvX5Gng1yj1stmdxHOE3zTYqMWSjWXCJoshurQlKWRormWHtuglDcPNlvWXyth5xEb2CLyMXz0+bjJrmIjfsyE5ttTSUxe05XCJibMFVsf1XN7rJ82U9REUg6z5okooI85+Fnf+BaHbmFfDH8rbQbsuUUj+VCDw4GyEUs5RKvCGFZ4BniwgNQKsXUdzQpzXEAy+n8LQ3w2Xll586kfKEpb/+Ht7/p5wrKwaFTFcGxftHaQdWHHHvePlxXNs6SMFPGV7zBKR2Q+GshCg1tQI/02X4ueVJSIBbjCTvy/Vr1qMXBftRvDrq1j47hc+TqBEHpxq6EHRPEhgcB+8sp1Quo1hYvbxHdEKjDLLYVkcY6CmjwRd6RPfSB6ydbFLnazSl/TtxvPUN0X1U7FMWyCw0KWRpJv83oovOV2axU+Eac6rgYl8f6Q4d4491+VJvHlS4IJFF1KsUWOP5TUO+Cf2Fodv8flFX1L3/zAdx0OKXBwNeiYy6y00OuYsjustYqWDrSIRxbXxVaFiHMDzT3L2RyZmp+4Iwp56oEbNQyAMX11r8GbuXETnMKjwI2+UdTOJyCa1v5RTG9wT2vphlykafWnKD2pBY//Gp5moSxX3m5kqSnWaOPZgdD
 IBShfM3m
 MBoJblenfvwFFFdbPI3bcyAAmyC+CEGXalQWf9q7fLRRMGaO265LXVlp5ipkHKrQpgZndI4dNehDbEsPpqFeVdP6v8FGZbLtvXcTsi+mKwbhkwJ0MVo7WWPwiNYY8X/J3NbCgHWlmiQtuptytlWKUN+9b8hf6VoMADOn5pX4wCFxCxUvzMDZFeIpes152cGY2ZLCkRmPNsBTkCro70z5imndkBRv1Xs3p8u2KQIHyvNinJWkABfbc3QKDicQ2Df//+udxicfeFXO8xa9BNxW6izyoeg1kywuELDqPisdN/I4Bdp1NlvMMi8OdRR9k9w6pDUQ5mJq+E+qG93Ap8ny5tErmwEUHUfkiVV7o/8KJE3XTtWAzuCKGbKIAU3+Y+Moawys1nETNUzScAWUhzxAzktpQDe5G1/h19FFIeZSZhOfbPNv23XzfpEmI7VK0G+IyfIWkJPCiYMFcfOmAPbzeynrDMW97dqV8uLQ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove lru_cache_disable() from mbind(MOVE), migrate_pages and move_pages
syscall handling. They do not now benefit from lru_add_drain_all() first;
they gain little benefit from invalidating buffer head LRUs first, since
5.0 commit 80409c65e2c6 ("mm: migrate: make buffer_migrate_page_norefs()
actually succeed"); and it's a shame that (even without CAP_SYS_NICE)
they can prevent concurrent tasks from enjoying the use of those caches.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/mempolicy.c | 7 -------
 mm/migrate.c   | 3 ---
 2 files changed, 10 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 501e0b80d7da..44912d707d57 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1343,8 +1343,6 @@ int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 	long err = 0;
 	nodemask_t tmp;
 
-	lru_cache_disable();
-
 	/*
 	 * Find a 'source' bit set in 'tmp' whose corresponding 'dest'
 	 * bit in 'to' is not also set in 'tmp'.  Clear the found 'source'
@@ -1425,7 +1423,6 @@ int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 			break;
 	}
 
-	lru_cache_enable();
 	if (err < 0)
 		return err;
 	return (nr_failed < INT_MAX) ? nr_failed : INT_MAX;
@@ -1530,8 +1527,6 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-		lru_cache_disable();
 	{
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
@@ -1626,8 +1621,6 @@ static long do_mbind(unsigned long start, unsigned long len,
 		putback_movable_pages(&pagelist);
 mpol_out:
 	mpol_put(new);
-	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-		lru_cache_enable();
 	return err;
 }
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 534908a0839a..bf9fe533a5fb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2360,8 +2360,6 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 	int start, i;
 	int err = 0, err1;
 
-	lru_cache_disable();
-
 	for (i = start = 0; i < nr_pages; i++) {
 		const void __user *p;
 		int node;
@@ -2440,7 +2438,6 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 	if (err >= 0)
 		err = err1;
 out:
-	lru_cache_enable();
 	return err;
 }
 
-- 
2.51.0


