Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01300CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 20:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632178E0005; Thu,  6 Nov 2025 15:15:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5705E8E0002; Thu,  6 Nov 2025 15:15:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3378E0005; Thu,  6 Nov 2025 15:15:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31FA18E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:15:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE7641A0261
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:15:01 +0000 (UTC)
X-FDA: 84081286002.06.355A3AA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 21F5C1C0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:14:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="IA/HAKHX";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762460100; a=rsa-sha256;
	cv=none;
	b=6SYk6gvY8A/8ie0+vDpI8MTEYag7nYNirmdBDNu6pNerxaLV20AZm7o37ljcnoq9lTW3Qv
	6NW/Lue/gKF/NFfl36EvWqq/5IhEv7dlLqqeAKNjUhLlv6JVCL4oFKLIkOvOaLVU1sTtbP
	h/AdJucBxtyfISlOCTvqYcL2qt42jMU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="IA/HAKHX";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762460100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hF5iOWIuCsS5/1DNaVVNOCjQLPxhtS93h933W9kXP/M=;
	b=eQ4RTaumpGEhju+ydmGD1xidqQbVq0Tu9a70wuZo8At2XjnvFmLqfNze7KKVQeeYFFioJ+
	6QQaq8wQsJETqo1A0vh8aPyAxKbbV8JUakeNLVOgklPMQ6pgW7BTUcPna4E/41LnOFDjoz
	aiHtvFeXx5fTZlsFVgD3sZcmA845DKQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=hF5iOWIuCsS5/1DNaVVNOCjQLPxhtS93h933W9kXP/M=; b=IA/HAKHXc6qlICqGuZOaRoJfaJ
	HtaSKPOdNZVuyfsbcnrSQf3/pGg3jKL1y3MApqZ9tZ2jXego20Z2Pnr02co2G9eq23KBMplbavX8f
	yoIuSpeeYZ3gqSN91S/GRYcpWzpxfDDul1PwIHdw5zcCH7dXgLUJsGGd5eNAenCnjAQFOi/5HRQmR
	yyHdR+210Gw1c64ICx1jTMOqF+xSdoYkxJUxRAr6boctE+FlgJPG6ExbQF7Yp1YmHtBgFDl70tehj
	MgSiOkSUFX+blUfP2jz3WVCFBepznQVQobmL+tkYhvdioefKRY8xNSi/XX4ZuermL95QBMfjfwiBm
	/TKQ/PeA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vH6Ni-00000009cTM-03hh;
	Thu, 06 Nov 2025 20:14:54 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 2/3] migrate: Optimise alloc_migration_target()
Date: Thu,  6 Nov 2025 20:14:49 +0000
Message-ID: <20251106201452.2292631-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251106201452.2292631-1-willy@infradead.org>
References: <20251106201452.2292631-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21F5C1C0002
X-Stat-Signature: a79qmwj8978yw9dm766oiwyqxj7uaax1
X-HE-Tag: 1762460099-425788
X-HE-Meta: U2FsdGVkX1+27vPYfWDqWq2ToZmIzSzYd89v5aco2b22TYb82aeZ8iUbC8a9YmfYyaxgV1s4Xabv9dkGjxaW8kdmL2dnzJFL7ITEAlCHlg5vR12v+T93mJV2TiaoJnR3kIvw40pprvInnQww9pkj6yVXBktguoRyxuii3YYTn2PE5Z9sEPvSSqefSskT+KYPAMVB8g/ZbJrdfbIa7JDpohKiygaV+ymwDESaRHvGb9At5FezL6K7Eet7Wc3MwUrZoE/eCxXZO5/W6zsiFw608uiNHSNJNIYoYwGCe7TN/KFzhsE8OGssjTNlHmyo4lQ9Y8OPpJZUd6BTxHcBeycyKZRKAaPh6GADPBWQ9NIGRar2ZujLyxZDFFe80ddqFdc+hcuRM6qcopsgKmInS1x1SN4tLuVtC9vDF+yVvP/JaXiWaUhEpijSq6pxVgePLxx55RbBGELXNv32xYGlIOfr1TF7IisuNI1YRa70BT7w4eaITxygQugCmoAtS8K/z9Efqb9fC2hnHrxZwp0woVe2+y47ACVu3nBbEO3dTsT4+Jb5M5v8M/iWmFnSEktWZGvxN9KRU2MceuM/66z+93IxZVYivn5lsvVqV7wPkCFyIX6d3+FtfQ0IAGnyM7saNVZAf9UkmhGU2VtEBaVMUMMVE3dcB5ND9UfvT/dGb72OuoYF4ey8t8ciKsVcpEOxil8/WAtkZqtfESYc0BF+nsku7NxJCvQZ7R7cqovFbTJiA+KcfvT52pvZZNSKfLP1p51jvtTEFVPArv2/2KLqegyiLmetd0L59XVQUaWtgYcUex0PpQEasYtlHvYo8uwwS8X8YbN33YT26J5a7iPWO3T517F503fIo1vUZv+o7s2m3cmXwpPrwshrsyEzDNLDBOar4FeHQR51G32Sx/fRA7JZEbExkBERpghwE/jJEoqkXmklAnG8YPV3zBWWvIza/PRQGseFS0t+2Zw4muhxsZ8
 nfUHuf0H
 61pym+KOMQKomueA8K3UN5E3gv2sawsGpag/pGgZFwpya3zHgqejPHa80ORYSDMHxXOUKAjpXPufGjOYDHYShG+yvbvT0OpY4nrU4yQGCraGUZYtVv94ytAoyVW5BGWyizXkrnMM27XGJvkHpBqMqN32gxIk8V9exnH7no5pTz2C3LLrKEwHSWEDvlgr3HLim82reITV1xy7yhKKMAdh/DKV2Txgv+W/IOYpBnghA6Hf+LwhV/BSno9IDn3TvUSBiKIUHXNs2jH31kzQR00qGK6/nYp+4RghbjfdexEyvyU9Vf9imn9LtP9w+uFIwy0zPElMC+FaEUKtRrUiDOSeJzPoyqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the zone number directly from the folio instead of using the
folio's zone number to look up the zone and asking the zone what its
number is.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index c0e9f15be2a2..cc8d71bd116c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2190,7 +2190,7 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 		gfp_mask |= GFP_TRANSHUGE;
 		order = folio_order(src);
 	}
-	zidx = zone_idx(folio_zone(src));
+	zidx = folio_zonenum(src);
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-- 
2.47.2


