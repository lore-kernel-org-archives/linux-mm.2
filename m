Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06F9CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757026B0095; Wed, 14 Oct 2026 05:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F406B0096; Wed, 14 Oct 2026 05:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645186B009B; Wed, 14 Oct 2026 05:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4635B6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:01:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D46821A049E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:01:08 +0000 (UTC)
X-FDA: 85320637416.04.27A59D8
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	by imf07.hostedemail.com (Postfix) with ESMTP id AB8494000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:01:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o83hMz/F";
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791968467;
	b=CPFQfjbDnsYQp/20xf0qvzu0CW9WxDg9QnMw76GS7UZ+MRVfT8BK+kWtLKhZd5IpmcTVu1
	gT21+ariiZjsts1TacVyMnJvK7KoLRiP0f7Bg/mqXGibSoTbI8vOoaZvbbGsHNTkDc8K0Y
	x+WE+HqAWBidkDvP3Mj//GvYe9Q8ZkA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o83hMz/F";
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791968467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nso7RZN/VrkRuGNDX0LnExBJy4sD0cevVoQKnhfjkHA=;
	b=yMTlQoxa7AywB/F6eTVU3LzVO3LLllDECwRo6U8QAuk55ErFMti/B/Kj2cPokAkbuW5ibu
	ifYqMY8V4v7almtVa0/0UgXRyPg9wo2QsFFTxCUXdL6Lhb9iOi4TYwMaMrsatmh6tGQUg7
	6eLsE1ZZfmzgrXjP7rbjuk8pg9n3pjw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZQ4kJhYF+3X/w38Sl/rvW6wcqURly93fU44FB0RP9cI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791968463; v=1; x=1792573263;
 b=o83hMz/FdqQGjAlHq8XIEsLZBOMQD8D2Omw56F206lQUD/nwZTkrJnP5umI33FXdEOxyckZ4
 xrlcXiHNc5KyxZ1HvO6XTHJOvlbJQOTGIVatX/Bqpb7vuWg9Iyj898azY+EugWphvvsUUviZE56
 9eHaE1TxuJGZe56RmkxmMuPg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id abacb56748857724;
	Wed, 14 Oct 2026 09:01:03 +0000
X-Mizu-Trace-ID: abacb56748857724
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v6 1/2] mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Wed, 14 Oct 2026 17:00:23 +0800
Message-ID: <141901355a7d9e4bbca5c4840ae32ea5c65fe3b6.1791968227.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791968227.git.zhuhui@kylinos.cn>
References: <cover.1791968227.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AB8494000D
X-Stat-Signature: zwaq9csmk3ber7618x4189xmrpn35mdw
X-HE-Tag: 1791968466-892167
X-HE-Meta: U2FsdGVkX1+CdjkWFZ7LFPEwKNO4erUNgWAvQzIBt9qAOVhRtytd1HCk8LC5i8kFCKHZYsYgQB5Lpsh9h5n/z4UVPSZNTC/C0El5/4rphqYjpIzNv6J2XmEDmgNcsPVyQNxdPki9OQ1PH6u+FhCRJ1hqNpwU6RY9p/eNcnkUerVjyv+iShExW2/xKs44Y+Chuyk/nAUBbhJ3sP95DxrJJTxWk5KFIyHlbcdnCSXxw5pUh1D3T63Cvlf6oO3EOqv1R7djC6TaXG9cNbVaKoyVGIMOWUyUb9WydDTcfGr5PBy9EFb1D8Ev+L674TbYJKhjjeQSzPbzRgw6pMuV7biTtdcwbOBTdnYUgCQdLIKOs2JlPL0j3M0benviNLy33ubqg8oWwAdf+unaeIrjuUSp1D6Ew5FhKgFTY3g4ON3jRqym63xb5bNMalKaPb1eoju4vebCXOHvxUSIskbzY7M2wtmsEFHl9MUy8THAETIolbpL7Vrsi/wmL2VY72636ADtm19q90gx6Z0HagxpkZ3sIaQZ1jaV+CnQK5lxb91bbZ08JiHw66KL3xJB94qU4mmBbbJCIfGCqpVAE7pQ+zijVA39vD1BXFKuYj1y4p9xv6AWh642/i49iOdRccdJt16SiXhhuuaBjnvL2vkSNl07h/nxM4xroid/7E2fUQAZQNP/a5hwcrW1EMm7Lb1zn3YNtizyIuUjOd4cSaFM5yIkny2OJrgC3pJuULjx0RjXFJ6thUbhP6J7qkpHq7tUSm/T28DWFjFUUmMnMcNSPTrxBdjrJ6ViVSkmOsF/GkuoMGMF5Jrjj1Iw8X5l4LgnAlqzfqonMzl+i8jDqIDNZOMxj/5/OMS9DpLKSvOgKvVdekNYb6eZIt2i2qm6/kBIGQYGtBj63yjbUtuPCbCQSfPe33s8j8TT/wAwt2S+NlGZXHDx9SToUNGgKDRt6buaoVRuNvHFDB1IAJKwfmz8Nsy
 bGIJ01pY
 WJYfT6aVIBp7KbKtGSCx9qQoU7CE/ujG3YZel4ua6u6BBvcof2Xdh8ZU60dmCwyQAtfVsGkVCnNCMzWVP0ohOLBH1MrJH+O8vSF7OmiUPGI5t4wLeiu07UhRu7NkCqx5BFjr0WJyQw1c65+rWofyforwLGWDusxORF4Kw2MCRwdUEkmKaTOG6cHsGoO9vEkHOYINbY3nyFsvQl3q+yKlGYVpzteSA04aSR9hdJXpdwlNK+zkTqodnNMCrhxN87CLRPjrTYKfArl/ePCPO1eMiNdXPWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

MGLRU evict_folios() isolates folios from the LRU without updating
the NR_ISOLATED_ANON/FILE counters, unlike the legacy
shrink_inactive_list() path. This causes compaction's
too_many_isolated() check to under-count isolated pages when MGLRU
reclaim is active.

Add NR_ISOLATED counter updates in evict_folios(): increment after
isolate_folios() and decrement after all retry passes complete, using
the existing nr_isolated which holds the original isolated count.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 245f68c75b28..3bd604204ec7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4982,6 +4982,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
+	if (nr_isolated)
+		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				      nr_isolated);
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -5044,6 +5047,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
+
 	if (nr_isolated > total_reclaimed)
 		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
 				 nr_isolated - total_reclaimed);
-- 
2.43.0


