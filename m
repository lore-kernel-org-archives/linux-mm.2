Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB90CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523C09000FD; Thu, 14 Aug 2025 03:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBB9900088; Thu, 14 Aug 2025 03:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4387F9000FD; Thu, 14 Aug 2025 03:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 311B5900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:18:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD14013810C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:18:41 +0000 (UTC)
X-FDA: 83774510442.04.975F95E
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A103180004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:18:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=APG3FsgB;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755155920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OVOlDlbXHrc0qK8WmHZtAp5nrF5N5O0JhEqs8GoP2r0=;
	b=3W8clahZjYFZKJf3lax5gdhoCZUjwTJKe/mYnB3fzPmVI+rOV3HTWonApsntQhyATbkRR5
	NkbPPP2DDt0PLv4ljN1zDyJbV8496RyvXcOHCmciOY9YHXGX8Rio2CPpl3ulQgYg7zmoxd
	drrmfbRev1aJIkTF0MiDShDSYbrMPgE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=APG3FsgB;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755155920; a=rsa-sha256;
	cv=none;
	b=eXtZ8j08Ud83TcHzYIJFMLOWU3xR4uCWUqQoWiPcSnn6InoK5mAoXcpsQS/v/JHbqrd/qc
	WBPpIP2hKf0rHdLWI3zSUApKYmg1uOjiGp/kkFBhZ+CvcjpBJOARWnoV3hOkw8KCJPz+Gd
	EHx/tEkQt5yvGIh1M2MLupYK3YEhgU8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755155917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OVOlDlbXHrc0qK8WmHZtAp5nrF5N5O0JhEqs8GoP2r0=;
	b=APG3FsgB0a+RYjpSJGO4c1LihqXy9QGPmiooaO7F924zT12UIEihe5lAkUpI3C5qKlMr1D
	Tat7tkAgarpNYBo1Fu43jewCfW+bu97m6ujIgpHpM9FdKtC0FbFlgifGyi8sx/D+0zv+Yc
	Y+F9pBg+ctgE+m9e7DpbHUgoZqe0EfI=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page_alloc: Remove redundant pcp->free_count initialization in per_cpu_pages_init()
Date: Thu, 14 Aug 2025 15:18:28 +0800
Message-ID: <20250814071828.12036-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A103180004
X-Rspamd-Server: rspam06
X-Stat-Signature: g9mehs4spq3fc6utijzoqbpw4udon7em
X-HE-Tag: 1755155919-310382
X-HE-Meta: U2FsdGVkX18fOza1TvGdLIed3xJBlv1ir945fqv4T6S9pr0aRWADR4tddZfr5gHBxNGU4iL7aWqfJmgvIvfh1cZcIOZWZ4KTExHTMOLRQz/tybnKYezH9EGugXbunmZDBX+DsLclsiuVU3vgpsAhNq5azL6KFoR0WjyfV0zJytlWyHrIwzgYuc4Sseu14k/wFYAIVOjcpAVw3Hd99rZaXOiBjBeqGvu3DrRLtwc3TpoRzX82Yoipg6ltVL1AoQ/T2/qfHn5Ir7eDBFC2WDLeESqBEXDhPtCdfuzLEYjriudf9gb43stGXKYlJloA1o53PgPIpYlE2uAI+2kx9QS7W2PIOaD+wlbu/YlQmN4B93xFq+yWOR/a0VGyTJGAh10Mke/tDZlPT+38jTlFTMgy6yDE5fKe37XY2wokCP8aHTPvzWnz5kemkbW658NHh41qBNPXiblh1Bo7XpqZAA276wuJ4DVCmIgmmfmDiXjpjrqAiJBE+3QIxMh2ZedeC/jDFLWp4y5cn8eRWUO9zwKuLQj9I0Vp10UdvzTBYm0TUNHxOD7+zcDnwkYLLWf5eGR8Sq3iTseOUHbwmCz207g9tfjnTrCJinNHbnL9CN2Ew4ygCcXTHQNnZRfV+u/INCh4LZeRBGAmFHdqD3xkGOBiL+N/lI0gi8LTXPTUml1lgOp25xdRWsCcweOSnmP2uUiAXjFCuxB8WB8CBSyJXITMQm/aUtb4qLwQHJpTh4Lz6zC+Wg8y1ygkKoNDUFxwAVOCyj//QCfc6c/WKzOq3BTYVouDTtPJy59xeF+XGYqaES0J+w44XkZGKxrnbWDzxoGqo45z80UIMRhAXsD+H1fvlHttnYmuSX5BtiuFay6vN+BBVsLxwK4Y6oamV0Emzh08YnaZevXZLYZ57mebIplGi1Sdvb7MR2hEqpm5YWi9nDsjuuIbqS9Tg0LwJH2IUd8KNcUkRCRkOeasn+3E9r9
 FHh7c4LB
 9tPhJ3bNZUnZFEsA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

In per_cpu_pages_init(), pcp->free_count is explicitly initialized to 0,
but this is redundant because the entire struct is already zeroed by
memset(pcp, 0, sizeof(*pcp)).

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..64872214bc7d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5946,7 +5946,6 @@ static void per_cpu_pages_init(struct per_cpu_pages *pcp, struct per_cpu_zonesta
 	pcp->high_min = BOOT_PAGESET_HIGH;
 	pcp->high_max = BOOT_PAGESET_HIGH;
 	pcp->batch = BOOT_PAGESET_BATCH;
-	pcp->free_count = 0;
 }
 
 static void __zone_set_pageset_high_and_batch(struct zone *zone, unsigned long high_min,
-- 
2.43.0


