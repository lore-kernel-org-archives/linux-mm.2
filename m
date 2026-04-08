Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF2071073CBC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1C56B008A; Wed,  8 Apr 2026 09:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262076B0089; Wed,  8 Apr 2026 09:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177C06B0092; Wed,  8 Apr 2026 09:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F10B46B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:33:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A6A7C01D3
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:42 +0000 (UTC)
X-FDA: 84635481084.27.E4CE5BC
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0A5E18000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Byro1AdR;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7DEJ5+heQ7onPG4SiPavDH/m9STlxrOJvRAAYFCZmk=;
	b=HeuPG0rJJteX8j95Wpet6yqiVxVjEuR3+U8/cdp9++fPIsTdde9tueXOzOlm19D9/WHU97
	hYnXEK5mLCfJ/Rq1dPk+e/fPnGvQJhFPQEyL23mA1Jfvwp7rSPROom52wf45Hcc6YZMd4v
	fz+RmzEYWCXoVL5zGsXzmx41ZRqwYXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655221; a=rsa-sha256;
	cv=none;
	b=nlbh0jWih5dbtC39ui4POeb+9JXjnls15b1otYs4gGoLlZDdB7dRWn/R9/oWNQn0rxoFIb
	n5hE9ty3quIOkic8szKsxjJ7bkv4nwm9AWegLXyI5kVhgdsHVjQYhcKBoG34VOOoD+gxSN
	wF4VtxuY52Wjqm8ZICDl/1bC8qG2vp4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Byro1AdR;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 254D6BE713;
	Wed, 08 Apr 2026 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655219;
	bh=B7DEJ5+heQ7onPG4SiPavDH/m9STlxrOJvRAAYFCZmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Byro1AdRFmhHNV2ta5mXvcd4QswA/3naGRANsHBhr1wQ28PT8pgLRn035Guuocetb
	 j/svy96Ds3qH6v5rOeF5US4scV2Lovh/Bm4MVhW1hm0CNf8Ckjbx8VF++lezc/nDyw
	 1c0GRLkhoFbRK3O2fmavL0//C2Y028YHmGIiyb60=
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
Subject: [RESEND PATCH v2 2/8] mm: use zone lock guard in unset_migratetype_isolate()
Date: Wed,  8 Apr 2026 13:33:17 +0000
Message-ID: <b4a25c016b7b857fb55406baf2fd96b52a1f742b.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E0A5E18000E
X-Stat-Signature: n14ndrdw8sb66bksgq8k8hdpwp5fkx96
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775655220-509744
X-HE-Meta: U2FsdGVkX1/MlgTdG7Me5LSgnY2/0+j6x5pSkWWLeiA7yO3UE3IpuMRxX/oZe8igpVn5CiChKalX/B2dVmjnR8A5ngn8aktD2X3b49iSO0kkfFraPNhQgP0S2tcsPDDgQ94v2V1gWiFTGINGS59Me7DGMfKisJsUx/vBNK3sx0sBPcGeAvP4ymv0S4VO6FiYEvueaQZJykE6pgmkRsHbRBqj1V2iWIlMjGW+0KET8wTRl+Xr70a29EHmsN+y6oQ3dxptrAxOpeFIZz2lIYYssDhwKMCnAdnJPhPRUu4vjz5JoXxvMXWjA02RdbS7WawMvvqu4QrQOKa78Ok2rqVrVWjtpcl1Kwnnzo4b9wIcOsk/HU9kIbMVXkI1S1QX9KDBy7JcoQxXVMA1APy82AMP1+WZ564vX705aureV0el/wVo/CUXvayzW38bdUWV02/Cwp4MCzNaSS1DUKykJzsmXcBj8VIOEafj+jJn5F1HkWmdbLEgTdB2h25p7cwMbcrOmGdC345bcub+d7/CnjlYHnGD4+4KAY+8BYhXju6HoPNDN1qYuXwm8Vwxlg2S5+4+IEn+wtUok8KA4edrsX7OkZ5fy+VzqWmH8vg2N5j9c4M9giCvPiSTvNwCeoOJKy+E8Te7I7yu+TvAdGnLCY4+77U9HkdpgXyrs6ztWlRzlVaARIZO8nPhD3/mv0pF04tvGe/ySvdIOibV1WE8iAbe97MJdwTNIXawfBGKnJzUKJxfahQS3M3Armh25BrVzAB9CaW+5HI7TrwhwVSDmEGavt5O8GuwRxnzy4xqLyw27KcAdYZTsL8Sz8DYfLs1W5jFXkxWpwK+P/gtN+ZKVcLxfW8gY2ePOSjL71ercXO2oqn+UmmieIk5ZrmxEnEPGTVVcf0vKms6VHHcxX5v/XDRamnBBYaliYO8EOOBrVO85UlrsiNgP4RcITOBQbTwrhqPryBHcMnbWOrUTjgsyjv
 K0iX5c+l
 AXw8LAwlCtP9zodboxLz/UWAVBSXF7MEor99T6FrGDcCNsuwg4dVyVTvEPonoBue1uQqH7/je66cl6f7PDOSsf+iY8LNfa8JewilV31TLZqHLkAV/tNDdYan+RjtFsMgd6M8c2MUWNnNazRcGC1+LBCnyU61FeogNYWcHv9w7nVDu49saxZhvRjufnVbCg7YPrgii6ezoM2uS0IJsvr8cNWv5l5ZcCE9jnCIsgWzenuKdFP/LY2ygZZCsrCCp+6gDP/O5SxyHSdosC/Et3HbUTnBC6m0jnMuV0EvTPPLrLJ+fvWCksRAu8OGAKnY+mZhwkf19JaWUzA2VglkWIhC6W/iYlq/wp2VRV/9k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in unset_migratetype_isolate() to
replace the explicit lock/unlock and goto pattern with automatic
scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_isolation.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index c48ff5c00244..9d606052dd80 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -223,15 +223,14 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 static void unset_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
-	unsigned long flags;
 	bool isolated_page = false;
 	unsigned int order;
 	struct page *buddy;
 
 	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (!is_migrate_isolate_page(page))
-		goto out;
+		return;
 
 	/*
 	 * Because freepage with more than pageblock_order on isolated
@@ -279,8 +278,6 @@ static void unset_migratetype_isolate(struct page *page)
 		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
 	}
 	zone->nr_isolate_pageblock--;
-out:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static inline struct page *
-- 
2.52.0


