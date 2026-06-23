Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9099CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6C86B0095; Tue, 23 Jun 2026 05:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49AD6B0096; Tue, 23 Jun 2026 05:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938B56B0098; Tue, 23 Jun 2026 05:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68DE16B0095
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:24:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBC61166FDB
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:24:23 +0000 (UTC)
X-FDA: 84910641606.28.1130662
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 16AD61A0006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:24:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bj8mxPPb;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206662;
	b=wlyzuJAl+vODeYywUH+ElYBNYfDvNyNszojdm8zxjPVNmphLLSvemIURJ1bnJwXildNzqR
	RLYO44K9PKb9eR5Ww0COCQJ203Uhqn6B8Z7JPu4n9AZcspGkQm04sdr3ctSyi/0JWHla/Y
	kdz0fsW4ZI3bHUqEG1InmGqc2roGze4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=RVp3Vhe5h9XvULnnyF91DqOlIdeG3vZQ3kMZCgCBlJQ=;
	b=GXakdtT7s/s/N4ut20W/EQMQ6g0wEr8bivslodLJKzXtaSiXkD+vTC9eJxQtmGXM7AU/QH
	dw5NaxTq/HTLEel2bm8jIarEkcUa0Z128KatoRW8vXaip1kCwBdCffHXIouEUhHomZsWaO
	aPnPOehhkvQPziIOiIGki8x2KPBjX+8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bj8mxPPb;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c0c41ff84a6so444518566b.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782206661; x=1782811461; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RVp3Vhe5h9XvULnnyF91DqOlIdeG3vZQ3kMZCgCBlJQ=;
        b=bj8mxPPbh3aVyb6GjhjgS5aY6OxQmNkV9adyXMW0z2B2HHufjn82uAmsf9Kjgf+BOl
         OOZsmsrhD7PUe4CaGO3hYHNVep3nAKoqvlEsyvnawK9tNJqWC3LdsULthUffnpU0RcLv
         XIdWnMH2/+g4XyPNdh+gw/XV2g8rez7L2oWxd1IjroyuhvsK4EpMSdB9KxPT14Rv6Yus
         rataAcDtE4RcwsreDIVa7CfBRb1E+cDZL11NUVCTIGWicuPib//vJBJruv9V4ff/aLNJ
         oefj6uT6D7oAJLn2CaZ9RaP/TkcmNbcwVTc98l1ywJWh5bi0/iPxxdy4hDKOrcjXCI1m
         PAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782206661; x=1782811461;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVp3Vhe5h9XvULnnyF91DqOlIdeG3vZQ3kMZCgCBlJQ=;
        b=FNwY9cU7a9fzAO9QIQ8aH9HzIa5SCauHT9fDtpxohgAqBqBQyCx9nPW2liy6ciFZNC
         h+usROtaP6V6t5TS6JAe71yuujbAbhsZGJ1A6ab9ZBsvU+dTLsAx8u/FnzQUkRPRwYmR
         iZ5pJQRkMbIVbJcQrqhXo17TmUDhhAMvbHKL5O06jhwq61gXxjGWX/okFgOlCitd4Hxm
         ARd8vTixyyG8b7aqjFSuBm82nTm3Yw8HHzsEBVK72i2e48RHVunf8gSVNY527PZcC1aW
         R1vOxXPHZ9IruYqsqk1mDTHbDCd7TwB7nwKkzCDpUU3jCXKWCYhAa/tRz4t50bm1SYRL
         JQ6A==
X-Gm-Message-State: AOJu0Yy8wZY6flPIVD+IqozhrkH29qp1wJ7oR4ENr04gal70ht+ixAUD
	QYARWETST7egMrXWHIYMW82c+BBuhdkGo7QD7HRFWlRJVx4etEPqMiSv
X-Gm-Gg: AfdE7clu9o336FTGNGlhscUqii2mMX3yZLoLcU6BDxMxcFMwQrCAB3k9Xk1z+U0gpY5
	OqtJQaOAPr/3yTc8cWASi5ydY/Ja2g2b15DtPLruEXJonJsvkcJ0NUqetaNkUb6y6FLNIucIeuH
	pfVeMRr2ThlvgRCTuGESqxVLIfMGM86vGd9mF+twqz+RmnP3eYp1JZYDkzlg5RIpHV6TS+iGp+w
	Kxe0gSWIqki7QMxf8wVxUgNPJTKd2XMRXzdzIeagyveuzPKqyuc56Jh+zSJJuxKdLOMxJhyPKjj
	D+C30SMV6zKUMPd1Vc357G6bCjbc4PidZTuq26Qc/kUEBwvVNj9/e7Jt/1JpLQURZkiMYWRkPam
	ZhLRjcZpVGG+gwq736ND6lYrN6xO7XIAmRx8NNtUuAnlahDGecvOqiHxIw0nmfUGkY9VUIh8tSR
	8RgOMXt1ecKDs=
X-Received: by 2002:a17:907:94d2:b0:c08:1213:b552 with SMTP id a640c23a62f3a-c097adf5cbdmr957813466b.4.1782206660462;
        Tue, 23 Jun 2026 02:24:20 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c60ac8284sm486678566b.34.2026.06.23.02.24.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 02:24:20 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	izumi.taku@jp.fujitsu.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	yuan1.liu@intel.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch 3/3] mm/mm_init: remove special handling absent pages for mirrored_kernelcore
Date: Tue, 23 Jun 2026 09:23:51 +0000
Message-Id: <20260623092351.13031-4-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20260623092351.13031-1-richard.weiyang@gmail.com>
References: <20260623092351.13031-1-richard.weiyang@gmail.com>
X-Stat-Signature: kt89797k4dbn479j44sg1t7iingysn6h
X-Rspamd-Queue-Id: 16AD61A0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782206661-633005
X-HE-Meta: U2FsdGVkX1/I29JOx980ULQHdAZn/uhnzvVIeay9ttybwUi5SxvpfCNBjvZsjv658M9xyZZyPgf1oIZIE5UV46/b+bVZ37nFmmksmki89HQ0QIFXGR3BwAVwbuCFKWXsYCf6d1NpUTNB3G047dOXgcW/xy7Kwz40OXjO90rAbsRc6Y80Mafh2ZIQakN21rJkGH82IKZSuQhF+P1syFx8OrnzkaxchXvp63Rw4lfCq9WRecZtYBc97IeswdKUHw3zPygWrpxneTXr8kF6skwXm9vT2kd91k45vc5JyEDogMeLH9BXHTJ74qB3UhJvTqfc7goJyB3fwl37NMJrsUQSDQ1A/3EjWyqRz6njlBdQGBXGGRi1/jkIRF8CizP/oC0VQD5GbxX4yWyfjuu7iMrAA5LbB3yVRJ1Bskdn6Z79lVYVqAqThM96mp/b2k+ez+RvRTwl9Jwk1PLf0v0KH+Z7F01ENdzvBqo0LtG7+LuZnPFhElzS5xUvsN+Yat4g/ffpnXNQ4n3sOWXhYNzBQD1AbuBPqxskFA8ogMicsC3QpFwK/AnR3FPmO9+WDQyGMDlWyP9wzZ4HhiI5c82+TafJOZnUrDRrjzUAl1CNAgoi5NyEJ2kkISlA1CLhS2ymZqAOpzGgnq1FBIPJF0Y//YxnXJw7jjBXOxjQ1ctbMUJxhFbWL6VBXc0FrC6587EX8JTK6NX7MH0gkx0TkyvgDKtvnyDXV30LVwGay93c42sICQUgSUfKd1vG9HHTH1au/nJFr9Uks0eKbq270my1oYr3uZAw4lpEv3KcG04B3hxjDNKGv3BluF8IPbp3fl7QAEuovmL5zIHdlYgkbM/rojLTG3Ybjrcg/tTVhKZh0GkYa55oFZOuKE4ywh8a1sHTJuOGTvUDBQXYCOrXhWkQsXeh5r0Rz0PchtC+njgRWxZDcUyc/iRI0qBZpYt6EWX6rOR/GiLDBSlvHKkkKJKSkZY
 mJtkj+88
 y2pHsxTS3h20E0D04vIl/MVV2r1y0Jl91aXqcdczD86H3EYAdgjiSF4eqJXA0MzFazYNSWPEbTXAGiD4neD1LL0hVYcxdYh0i2OBMjJX991afJ0+mpdv9vrxhkiMwNom44RWMHgB69Q/Mv5oUujeaqL6G1TmAPPSR4pGtdCp6GmYEa0OnE20Qw5gB+9/sD1pwkzNIu/P8hB1UIzxP6t78HyWJ26MP1dVaC8QYBNCdx5ZEb/EKyRkggm8g6JT9Kt3bIPINTdijLN/U89nSf1g9WqeTFkQ5nYLZcF2Ty5BIeNRFIOZDfgmvPJadi8Cx/R9ZmxoDL7uUS6tdf86v5zu5/3qp8sXSrEYS7NWqMc9O2nW97WjzgHOWCPlVY637G0ftcLEGzMPcNc9bYk53CaVUB7hX5VIkFM+PZ+kIHLG+1x6KhEt1Z076NmqRQnjSCwDcXu5qSoyJ3xcSi2aEstYdxlNowZ+5WrOJMSRswxfP3rueH7VVWIVprdmAbF5cdBUhpQHwtNBaEgD6SIj/T8XGz7d8qE1aA6hEFt0xfpCKBmYC1hlY7uNcxh7m/nvzEf5a+V/Lx9SDiviXcGqIuTIKNnaSJ7/VuKNWLX9mdPmEkevM/ejYmXX9B6u9ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After making Zone Normal/Movable non-overlap, it is not necessary to
calculate absent pages for mirrored_kernelcore specially.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>
---
 mm/mm_init.c | 31 +------------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index da0e65bf8d02..b34ca1cf117f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1195,40 +1195,11 @@ static unsigned long __init zone_absent_pages_in_node(int nid,
 					unsigned long zone_start_pfn,
 					unsigned long zone_end_pfn)
 {
-	unsigned long nr_absent;
-
 	/* zone is empty, we don't have any absent pages */
 	if (zone_start_pfn == zone_end_pfn)
 		return 0;
 
-	nr_absent = __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
-
-	/*
-	 * ZONE_MOVABLE handling.
-	 * Treat pages to be ZONE_MOVABLE in ZONE_NORMAL as absent pages
-	 * and vice versa.
-	 */
-	if (mirrored_kernelcore && zone_movable_pfn[nid]) {
-		unsigned long start_pfn, end_pfn;
-		struct memblock_region *r;
-
-		for_each_mem_region(r) {
-			start_pfn = clamp(memblock_region_memory_base_pfn(r),
-					  zone_start_pfn, zone_end_pfn);
-			end_pfn = clamp(memblock_region_memory_end_pfn(r),
-					zone_start_pfn, zone_end_pfn);
-
-			if (zone_type == ZONE_MOVABLE &&
-			    memblock_is_mirror(r))
-				nr_absent += end_pfn - start_pfn;
-
-			if (zone_type == ZONE_NORMAL &&
-			    !memblock_is_mirror(r))
-				nr_absent += end_pfn - start_pfn;
-		}
-	}
-
-	return nr_absent;
+	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
 /*
-- 
2.34.1


