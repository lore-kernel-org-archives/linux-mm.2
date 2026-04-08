Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4E7B1073CBD
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E216B0095; Wed,  8 Apr 2026 09:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A79D6B0098; Wed,  8 Apr 2026 09:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BDBB6B0099; Wed,  8 Apr 2026 09:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2269B6B0095
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:33:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2719534EC
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:45 +0000 (UTC)
X-FDA: 84635481210.15.9E93CED
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf16.hostedemail.com (Postfix) with ESMTP id BE1DD180005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=bhtlSTwf;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nf+JuPEE/jp8A+2PdYP2O6YgayTSpGEteEGx3VKZEwM=;
	b=CiZR8uCM5lzL2VF5dIRcS8zH6wbP0R1HEpNNdoW++ionCOVw5zcGYyRKfGq4GKFiXxpLnU
	u1tMLn4gVIoFnKrlQpMIuVa439u0ngTl+7ZPpcUatjp9Exp4ynB6Qywx5sLm5+mP/S0zAP
	SMiOV/Y/R5NdzM4IuoFAk6HH398sV/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655224; a=rsa-sha256;
	cv=none;
	b=7RaywW/xWIf/jnqvKB6IiT1gEzzmdWcp2h2l+UIRRhZR6izQvqOfEsrmkAlsQigOJ4OfaM
	u9V5EkUST+zQvN6u+oYX/vRRsCXzPZRyvg/ZlzHJyXc+dKzwbNrtbkjkX+1Qt0bNAk1bkk
	grTlAdFMCVDil2OGxO0klEUusi4ddLs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=bhtlSTwf;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 9AC46BE727;
	Wed, 08 Apr 2026 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655220;
	bh=nf+JuPEE/jp8A+2PdYP2O6YgayTSpGEteEGx3VKZEwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhtlSTwflFyzIun/pkj53UHMDknnPfyBwaNmJiJdop/TjpXEBE47MclZwzdhTxbrn
	 kX3SRbMi/dWR6jXgz8zlaWNT8y2hN8fANknXtgLvypFaiWel8Of/YBaT/aioCaU57f
	 ly8rOQKQsKo5nA2Te4SI6Q/ESxwJBcUEBU8iwpVc=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [RESEND PATCH v2 8/8] mm: use zone lock guard in __offline_isolated_pages()
Date: Wed,  8 Apr 2026 13:33:23 +0000
Message-ID: <0da769d4078fccbde4182a5ee655ea673ccbd5a9.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE1DD180005
X-Stat-Signature: yad47najoc4iotwkmty55cfpy19x6xp9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775655223-211579
X-HE-Meta: U2FsdGVkX1+AM+es+8AUnSeqYjvEIRmF6zwfI3e4zrt4gjV3ta32EkuvOi8FrVopDuUvzijjA92nAy2rPuZfOq44LmiXQb6il4g+016N/nCUz1tLb6et3OFvsrFay89D4bhPKj8GdvcUZ6Ebn+A4iEr5gSKflAPwnZVjbJ/DD81QUzq+aTQ8FtZlfvTG7M9Ii60pfUfNbM9YD4hdNJpOLNqZCl7YSU69MQZ1sSNBIm5BuziOCxHb3wy7/w+T2xKWoVeJ4NjN8HEs0ODDyo8qv2amH2Vy1QR5rEn6K3GOpP4821zQJ6o9/rJvOB+ejsqMUQmBdxp0f/igH3KegXhv7AIk9uD0ZfqENrx8Fc/67lbW3nySipHwEGcWM+QZ87lfQWnYW69kxe0JgNEWJqE2d/FoR2Ifr/Yz25+Q1ZsICYpRSkd8gT/S2GJLZfU5dWKd9+7/T+IbV4F/iEDYTQc7WH37hOfcSM62W0IYdYU4zA19xP8wm7DtcH9wnb1UqCGmcDnNMamPqXXiKyLg9InvXjcFUCdtNzf7ImrFDGqoU1MStJ4vIrTfht2zaOBpguK0xU6AtX06EAGHDKwynvOTHQBV5xREGKQn6CERrlh+3Mm0+EmFgb2zpt8Y7Fgap29XC3Vac7DydhDsAAijYp7w21SfHdhAO5v4iGaihE3OkXXgeTE1w5xOr88y2cr+iz4ZHSa82ki50iOlSfW4s/VmtRTSzsGehJhXdseQOfv7ULR9IjunTaNS0V08uqI7B0TIKIi6KiUrsRaF0vHMR6o8R1p6PoAICdeVkWBriETO/adAgO1kYD3V1DtJZXXRbhjHDppix8lBmPz6Fetg2bSjdXYG9J/WK0AdGB9m62RzVIN1pe6aruwkPLvibCF+z38xVHnK5Va0JjTTqd2Oas20kLebi26auAh8qn6VxysuR/6pOY+TNw58Na6wN855t3MKoTX5/PybKcETBotNos2
 Gqbb98/a
 7pqszGJYlcF13PYA8I1MDBOmZfbSk+tqXoSxUUdRI1O4hVUxMSjIyrfoxwwTGrU+7+cXTye9/+7PbQYwZVSJ9RX2MsQpf0wwkZH5S2Ld5O2OVPDuQ9iZfRuORpUFpUwEdtwLejpjgpVMriUb3pus4oY9drx81UBuCIGR9s1wvQauTuZ+IqFYsgWnRj9aNC635krifgcMjudTwSEj10oHNBq/V9tufSbUMraUHh4O8LXKe5WHg7vdwEPo965QkAhbUoQV86CY0tZdzN5gfol0VjkPQ8a5GoHmB8iKnAiU2P2zncaatWak1U8q03Ye1Yh+FxZ2xy6pXj7k155UnEIXXjHPengzpkSSLRSLD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in __offline_isolated_pages() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6a7c548a7406..bda0282bcb03 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7396,7 +7396,7 @@ void zone_pcp_reset(struct zone *zone)
 unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn)
 {
-	unsigned long already_offline = 0, flags;
+	unsigned long already_offline = 0;
 	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
@@ -7404,7 +7404,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7434,7 +7434,6 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
-- 
2.52.0


