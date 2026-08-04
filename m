Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F6DC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB01D6B0108; Tue,  4 Aug 2026 11:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12896B0109; Tue,  4 Aug 2026 11:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A500C6B010B; Tue,  4 Aug 2026 11:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77E156B0108
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:12:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E10561C0102
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:12:39 +0000 (UTC)
X-FDA: 85063928838.14.022F1C9
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A827120010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:12:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sNNMoak+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785856358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+EEI8OmXFAV5iwPGEDdFyR14Opwttq92Jr4Rn38Aqo=;
	b=vn+ifu1PRVioJbAOH+FliNqSYnFIsenAn1BqVe+d/YibtYKlWcVKAPvwcorkpeKeJuZwse
	yQj0rerrfod9XMt7EcUewvH1Ni0XPSi19LD8W7BR2WHTwqqD2YB2P50w/jcP/nVM/DEMaw
	6Er23y2uaSRZ2I2emywqeAHqRbny6gY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sNNMoak+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785856358;
	b=gxqhDqf0bBHZ5I7Vpvd77i+sqhwxMVvjgz9Ppt35+GG/Ai3ZcnJyP2HbUF5JZZ74Wd9QK9
	h8cLJEOD1ByDis5/MKb94+IBTUXkDfY6XTVWLl+7Jr0UI0knXBHaHhaNWarCyHnh4vx4Ch
	yBCn7nV+MoQu3ATxuIQETMpStkO13GI=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38fdeaed181so2265373a91.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785856357; x=1786461157; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m+EEI8OmXFAV5iwPGEDdFyR14Opwttq92Jr4Rn38Aqo=;
        b=sNNMoak+4zbsJDObyLf4BT01hgbRmVI8D8FvSskt+pqZLQ6r1AJYCdc5QpNSoNQqxG
         RVcakyV6AtluJ4Z2FH1olKRnymCxw9bRSnbLaN67DffRKcr2a3WQkRV6i3m9/qCeIFsj
         0RJMgtiM1QgeDqPHZ9n49WNRzWG71lbbmCXOqwldAxEVNLRgBhMLQOIpO/UIyhHFp22g
         XsZrt7HVAbgtVh5T1srh46Ce09kbMabIHYNJM4vAqxTaRovvLGcGpAbf+HG3HZaIYeSV
         zJ97fCnVhzmYNiOZMeXY339wXAKoBUauymNJRWEJjRWHBRErRxaTVUZ4dPu4cGU4Urf5
         RhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785856357; x=1786461157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m+EEI8OmXFAV5iwPGEDdFyR14Opwttq92Jr4Rn38Aqo=;
        b=I2pwM+/clYregdGO6o+BCqIzE2gJtv6VEDhd8F5MrES3Vtads7HtZeIWrX53/Kz+pn
         3BMvl2C+d+OUbmuCZqbf7Etn1CIRrR/titsdH0wd4uXr6deUoDH8xvVp2sLjLC9OdC9S
         VIcju08wwJTL9x36iI5FCDT9VvxX92loJJca+x+PGzkdJPHVhnjUuvODeI/vPxed5D5S
         NDkrPmQZGe0wCc33+qdVGSK8Qm8ZcC4D/2vvARy5fW9sjI+GF3Dmyfc5BSDc+sr72IJr
         gyeUX5qdZU9tunf2LR+e9KnGI3AWxxW/bMyCnU1bAzUoFHRW2wKnIBhw6/rig73iSGQL
         Vwdw==
X-Forwarded-Encrypted: i=1; AHgh+Rq3RWiTS7lFKA+I3rkl7TlaI4srpdP03al1f4qZJIujM20MNkY5Po0O2zzBEN/w9HPcgqahsZFeSw==@kvack.org
X-Gm-Message-State: AOJu0YzpDDhaMw8YGpyFHZYrWSEw6giBIHaN5UsusIRoSJIUcslR3Fg3
	sljt42OkuRchQfG/uzA/LUoPzsMWIH+eKlfN4kqdN7WfjS6l1fe/13F2
X-Gm-Gg: AR+sD13rPMBCV55FKN0I2MV3ke7V4cb0Z4jyzfGE/e2zkcfUHgA25Z6dmVSKsCcyHvU
	f4DOLA/WgExiA0oFMkrebEIPYK0KDBF+dUqyaCPoaOWUdlycCW4UDSTSetl5xJ6AEiEuuQZY/g/
	ZC1jDItL45dDuOnUSr2jClWoh98ixhrgf+tUlIru7aQxiFUI+l67GKVCGHVpL8wJGF+WDShlejZ
	D6qaye9Uz/QOIGdKuUbper2LawZ8jGA5wI+LWkmehYlT065AzPeRmakZhe408qA0dynSV2tA18H
	SAYiYtaTbSYYUaIOyIchEtd+OdLJP2oS2eTpqCemnW0jd4nG1DY69jQzw1RcHkdSnc+s9nj6mWF
	ATyHs+EtHUL3kOS1MngiNC/KKha04KmZ2YJTAEUnDPZ8u42p/0ReCx0aA+SDPNCN2Lr0IedwXVS
	sl3DQ1calcyzntbipvE1cffsazdXjsSjmJSQJi1cMVwRJljnF+o+9oTjQ=
X-Received: by 2002:a17:902:e5c1:b0:2c9:d298:6c06 with SMTP id d9443c01a7336-2d0523fa272mr147650405ad.25.1785856356894;
        Tue, 04 Aug 2026 08:12:36 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4d67dcsm9219905ad.70.2026.08.04.08.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 08:12:36 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 2/2] mm/page_ext: remove pgdat_page_ext_init()
Date: Wed,  5 Aug 2026 00:11:42 +0900
Message-ID: <20260804151145.3419768-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804151145.3419768-1-ekffu200098@gmail.com>
References: <20260804151145.3419768-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: he31krchb5t9zsjxsoui3zt3g98so8s5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A827120010
X-HE-Tag: 1785856358-761895
X-HE-Meta: U2FsdGVkX184SMQpoQOLUXVhMOIXEeCfplW4UwDmj0bjLSrtbtuEuRKfFH6ZWJcM86yHhUgumoS37TizbiSZRQHdxAYK3opR9lYJVpdw8Btc7jYtyY0czTZ4Igu3cCRt9LvYyWXtdQ20BRUkckCS3+kJT8Z+kCh2TCfZ0r3wNCqMaUo/p0SB8AGnxIcuv8WAK6S8N8+etPicjSkk2WInuoxsIbaNZjoEh3z0BC/ix3I7zpWrV/EpNf2LJEaqDYVUvnglNevZOq5w2M8nGvRzRlTRmmI9p6ryIQkA4XpSsKXPpdk4mpdQTcuCDJZwgbAY+JMyukHwXg70mfG+GpOjVgAJ8fzkkwmpwuimmVevhXuBu/WfVztI7x8FST7LdU4lm1TfAXuloVkNxHgEszByLW1Wh2rIo0+Yma+JoUKQfJi9Jnjpg/DawNvnaahCxZC730gBgQsRJ6T92u0m+8YkrxVk2Hdw7TABVxinedYWpPr/cP1KROAF6J37ubwk3MeAiFLoVeJKixufx/eI5Kd8X6PSFh3N4gwEWIjVqv2bnQnuyFPuBlaKlN87dD4o6qq7sVx99q6cOTrEdIQQCQK+Hz+xxTF0F4v/KLP2q9w8pCI7oFH1LLc298+bPIzYROVXclT/K2LLmKlx1ElXxcZa7KgpV8iKOkBPBjSIR261B8OiK3rgyDjBHEwksSzT2XAB6awc07WSsTvNqKfan227EG6Q7OFAlZmAgg9xx9Y6Cqp0+vDsivI5BukXDWnCsKryqHDO46UGQ2mUHOjMvf06e/S2NF3y2mSee94LDHi/9PRGpGT06Qs7uDk0Mm2qnZtTfPrFDsdiF7NhWH/hZaD8BUgO0egt9wasJDgGtIAQFtNlap3+TL2XxISZEiT3FwWxWeHPXGqp9zqyRP3Qvy06MmWVW3UhosaEujRY74R7Up2b/8He+629yNCEgWNzVXNJvzuYpAZMiGpyXCU7ikc
 1g0yGNfU
 DpmJM37OU3z0XlcCs7zX70a9kHuneGVfizm0gp4mv8rr7Pw8FV/bYxACTWTxP6WBZV470UmrObQUxUUzSHCOKW9rS9RIoUPc7Y9yKdIw5VOapi9CzaztcKLe+Qnt0LXM19WZDHzaCoo3hpbzixVwt+9xvO104B2RfPTwmF56N3IAzvFbMxz3gA7aYIxecg+pfaVWSuINuukh3RwLyu0v3g0Io2gTGEvZ9H/DBtJqhTsGBpqAE0sJKkfg+K2EsUOTzApC4S9jkD1ZETwuIUXP15+wRN75+Qcgy6vCsk87H6ahOLc9jZ96S4at5a4WZ6J9s0jLdZquzfqAIG6KMPHbw/hvzbxoaqDRW4Poyj4NL1RGjBoljOINNiaLVQNkZzxLdufVAfGVD1mjtogFWxybS+rosiZhUNlw5OYHxQZ5BcKZv0F2kHHy1L6QV9OjlVAQujqIv8IfYzj6Z5Qo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pgdat_page_ext_init() sets pgdat->node_page_ext to NULL only on
FLATMEM. FLATMEM depends on !NUMA, so the pgdat is always the
zero-initialized contig_page_data and the store has no effect.

So remove the call site, the unused function and its declaration.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/page_ext.h | 5 -----
 mm/mm_init.c             | 1 -
 mm/page_ext.c            | 9 ---------
 3 files changed, 15 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index f23d4b218da0..79c53ec45dfa 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -55,7 +55,6 @@ struct page_ext {
 
 extern bool early_page_ext;
 extern unsigned long page_ext_size;
-extern void pgdat_page_ext_init(struct pglist_data *pgdat);
 
 static inline bool early_page_ext_enabled(void)
 {
@@ -202,10 +201,6 @@ static inline bool early_page_ext_enabled(void)
 	return false;
 }
 
-static inline void pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-}
-
 static inline void page_ext_init(void)
 {
 }
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 711f821f7b3c..e9c4204b73ad 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1394,7 +1394,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 	for (i = 0; i < NR_VMSCAN_THROTTLE; i++)
 		init_waitqueue_head(&pgdat->reclaim_wait[i]);
 
-	pgdat_page_ext_init(pgdat);
 	lruvec_init(&pgdat->__lruvec);
 }
 
diff --git a/mm/page_ext.c b/mm/page_ext.c
index e2e92bd27ebd..b679a8c1f7d7 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -164,11 +164,6 @@ void __init page_ext_init_flatmem_late(void)
 	invoke_init_callbacks();
 }
 
-void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-	pgdat->node_page_ext = NULL;
-}
-
 static struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
@@ -494,10 +489,6 @@ void __init page_ext_init(void)
 	panic("Out of memory");
 }
 
-void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
-{
-}
-
 #endif
 
 /**
-- 
2.43.0


