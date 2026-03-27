Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A37F10F284E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7586B0098; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F9D6B009B; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5206B009B; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8D236B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74AA21A0F07
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:09 +0000 (UTC)
X-FDA: 84592342338.05.663DFD3
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2E81C0006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=wyYmjHEH;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEgctjadaPC6e1ht8UPND33GBVnpMY+JzCTIORsmJW0=;
	b=2uWk+ZGIKehx6oeokK2MUofWZgAGt+aK6jFye8nYumaBOq+vaAWMXlRaDJgHUE5lSjPauG
	QZLlnx7YNdwov97Hr3d55S49iaspMov/RiesVTIt9XbEdOCMG1sqRA/57kj30c3PSFYz+H
	/Qe4lPPr8zmXghuS7yhjB16yj7JSK0w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628107; a=rsa-sha256;
	cv=none;
	b=dqH21hCKBBTQCyG1SlH675/OMQ/H6BBNUHOmVcXg0ysxoM+1uacvNGI5Jotbd7s6puKDi3
	Ac5mJa+X9OrcAz4TJkkMlG1QL04O1b8ev96bEub8E3/YBsgjJM/MoErckBARtWGocDkAoe
	2RXB0MYCuZ8QF7kBK9XordrE36NrY24=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=wyYmjHEH;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E14CFBDFF0;
	Fri, 27 Mar 2026 16:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628106;
	bh=YEgctjadaPC6e1ht8UPND33GBVnpMY+JzCTIORsmJW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyYmjHEHeoLQV080hjixwgktMwryHxpYFkRCh2fkkH8E0djeIfdN8d/BPOEbFwwOn
	 IkobkraGWdidDzVni9+VfV1Om7zCe/jcHo4dF68x3hXOdlMeWr//qwWNbgayNjJh+O
	 XRv5p5gqJti/XTbKxBFkA5/76AR7WrKmGVTdKxTI=
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
Subject: [PATCH v2 1/8] mm: use zone lock guard in reserve_highatomic_pageblock()
Date: Fri, 27 Mar 2026 16:14:41 +0000
Message-ID: <a66962d540f16065100cc9bab5b2ed294c43c1c9.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B2E81C0006
X-Stat-Signature: re8tzq9a8p8c99in685ucqs16qzqpgiw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774628107-944885
X-HE-Meta: U2FsdGVkX1+or0r38KxAtHqXktR6bIKMQ+vkQKDgk0Qh4/Bi2WsDjJVFyycjtT0lke3vuKwHdjHFBWa9JuNpTJfB/iv35IObXfb2SasJEksHs/Fh2AwZSqCZPiHneGh7roRYyadMrDOyoJPRxiBmE9yUGZyaJpMGH1ALH93n7rI6VaFom61qvQ7v7S5NC2ljGR97Hf/qdsQP1gQglgzV9QMT6oRAwet/TnwsyAEfE1SWHvGES2S05X2YLoHwYHjgs6rul0Pibxi+r/SDPV5MJrgQgKbHl9lSpGdeGTKBEPIvkSThULmHmcjplQ/sBM24S4SAIL37BGhtlpzX07NwRopZ2Iy9M+XdLfu+MN+wsqD0YGQSRnJtK3mBOTrNNUrpxeliX5kMtcfugOTXFOcQBvBgs4eC0yL72o4nhFNZkyr2GjxtFDySFvs7F5j3/r/VctT2gaxscKiBzkdST7JNoymhjqSiy8VD+bAI5y858b4uua3xdpf40YjhpX6NhCfaojU5bNYbV+pDv8f6t25+piynNj8ogGXsEAO6pIkIQ7edvN9fSs5lm+SGZXV9eH/c9wuR+bicQXrkw+wisK8WqMDsRmsxFWcVXbJDsBvdWGCVvhqHqdCubOfS1QpHmlHXGeX7y6iMgAj7dipBjt01wFhsVqPhTLxK3B1+vdtF09J30ouN5XJgzM3v6HPEP5f+I+1pBZ5k6ccBtlmfPBoCJZty0xbP2ixM+3IDf7fqEB7Cy1pbbgciaV1pb8+0mvyg67D3F6dsgxzX4SsSeCXhgR9kexUyk5BsV5TaGMMyAaSVJ5D1s+4ErVr90DN45TMl5j/PsqWOCi/pDXSuV2WLujq0qG5+Y3RRxxkW86pqQEMccT/Qs7Ocbo781VIBYbEIixA2gZZ2IIBgzRMb/DxJtq2v/RXoVuMn58hFTqVr+wSQW5I8MfiKc9BpVKLVpbcPN9D2CCl0g8SAAO0Px88
 MrjeH/6k
 5IF70serb/qkUR4HNKVgF/7Jf79S+MUjEInQnaXAGsJ82sOkhHY36/6e71U1atWRDgoMfy8Jq7T+9FNN916Ega4W+1SoELvkVTE06Smyw4ctvmaHg7FsjLvhudtb6UsDo3xMwlv0coor3MwLhfUVuTnyWMJsQ+pzK8AFaMk8gDH4qrg9levY9X7e1APJviYsWGGsBxbj4RuMjnv1VjGb5wSoFuLTQYM/7G0Ss6ql1zdgrkZe6CFlCmjw0YKbFajNpZ9a5/Erl5mNVWNpWk9vTyEVUF1KuPe2E+Cy8SwlLN0Kz581xHcXnM6qunGBX+nfALzdNnvtsAkTf0I2E8GD6asU6st9H8v+9xNyc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the spinlock_irqsave zone lock guard in
reserve_highatomic_pageblock() to replace the explicit lock/unlock and
goto out_unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f11f38ba2e12..c7b9b82b5956 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3403,7 +3403,7 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone)
 {
 	int mt;
-	unsigned long max_managed, flags;
+	unsigned long max_managed;
 
 	/*
 	 * The number reserved as: minimum is 1 pageblock, maximum is
@@ -3417,29 +3417,26 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	/* Recheck the nr_reserved_highatomic limit under the lock */
 	if (zone->nr_reserved_highatomic >= max_managed)
-		goto out_unlock;
+		return;
 
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
 	if (!migratetype_is_mergeable(mt))
-		goto out_unlock;
+		return;
 
 	if (order < pageblock_order) {
 		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
-			goto out_unlock;
+			return;
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 	} else {
 		change_pageblock_range(page, order, MIGRATE_HIGHATOMIC);
 		zone->nr_reserved_highatomic += 1 << order;
 	}
-
-out_unlock:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /*
-- 
2.52.0


