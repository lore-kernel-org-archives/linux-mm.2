Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE54C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923D06B0092; Mon, 17 Aug 2026 03:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4BF6B00A5; Mon, 17 Aug 2026 03:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBBC6B08BF; Mon, 17 Aug 2026 03:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 610786B0092
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:11:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D57C1160687
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:11:40 +0000 (UTC)
X-FDA: 85109891160.22.12E4B46
Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0087020003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:11:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nc10nVhX;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786950699;
	b=m4Eo20VYrSH0Cr7vhfzfPYx23OvJ1PwCZZAu6yIWnfKYRG6Kl9cEFF6sYNIr8X3Oi3HTd+
	9w4zuXCWXZPy+i7uZ/iDAIjZqPQ/4+vYBbe88ErnKs/PvKRxWB5wxo1SQ0g+XWg5vq7Teh
	FnajlSl4DwcjjXkEEGqy+VQNUxkgVQ4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nc10nVhX;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.29 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786950699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EY3wPM/VK9NQAIn9wZDFkzZLNRJu+qewIVUiPZULaj8=;
	b=YLmXttKtvwSkGFOcJGFXmtqAVf0n23sIu8/T4gd5Fm9xC0UfXzVV2yiPus64IrRgcaTIJr
	SSes2LfYhI7rTJGCnom0KvjzFc6y6YS1mjhCagFt/jacSWH/pZUtGCpdyQ2nAsJQ/aj0rw
	uhwMcMyMLsCV7UbcsJRfycRVogbbJbQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+56yCAHiWCEnfO07Nsz8V8P0z6H6SKj/KxqPoT0BAcE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786950697; v=1; x=1787555497;
 b=Nc10nVhXaETKHyCOlbuk2OSkL0PS6bV/Y8GuhhiOjppqzkFDr2Wgtb0CVK990AfV4jfRy/wb
 B3dQCb2ktQ7p29b+guempao+MCZPpYzXCV1uEvS01R0jsUm/JdLot2VplhFb4a6oTDZ8YXvskih
 pUe29KJ0FVIxBFh0BK5T2qiQ=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id f4e3b92ee359ac79;
	Mon, 17 Aug 2026 07:11:37 +0000
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v2 1/2] mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Mon, 17 Aug 2026 15:11:18 +0800
Message-ID: <9635d3c027bb8a5a416df04ea891a482beb3de9e.1786950138.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786950138.git.zhuhui@kylinos.cn>
References: <cover.1786950138.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0087020003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3jg7f3fbb5mxt6kxod34s8zxjrotjxeg
X-HE-Tag: 1786950698-465
X-HE-Meta: U2FsdGVkX1+hrHYfuedoU4FS6oUIf2xk1deROzdpEUfFeMJ7vw62LQ9TIrTgvpbNqtkP9LZtdxJbqgBmbH+0Mkkq2cUJiXn22KiDcR1KLTfzJVtR4v28sc+Urun0hxElhgpdmx2F9lHUDGl7okJLXW+jqB12t1tAb30ZLyuSVKbcWoF64h2V1D0OTooyJHnG8dNsHgmDJHf4fKpKB0wp0v2ZegIB6ju+zVe/4wP+jqBRfshDBbkMcOL7HeaycQF3Tez+P70GPQcGGpg3mMNVtnVDL4JVXp5Yy+7eSd6is6lnR05pm7kN9Pf/pm8jIZqcsv3HAv7uP2k0F8hTSlVwuC4uqaznmOpQkEej0hfTdCiNqTndq0IeIR+tmKgPuJWYqZ1J9QONZZE6pGZi60enK5K9oiYARjemHo9ZRRIQ/sOK/9UH+J6QRUa+rWJxfaA32pCOqQKv5ZAoPa1SYfuzRiG3k5yywDY8bknVYhA3ozgeR3jaukLSPXCY1LpIOx8I1MGYZAjz+HicpPvxvYTNK4gecUjpEXs+djrOX2dgThsVVXMa8K+q0qPv2RfQpPX4gavznSysDdNuhBi90eA44+GYzQGo/fN2EpL8FwbPcT13xoYSZoCWfhl+SZVXZR2mXakwGHeTfvkcQuwz1kIyvSqHIlEG1ayxVNfIUn/2hT2WfIRO+YfC63xmfiSC6G8E9rnFWm1weMufJhIhdLk/sgn4z73fVW4w7fvqMJ9JFwe6lzNhxG1eqqoFY9rVz+G65/Ch4d6749XmGBkH+hslWNOAENEJsF9spyXUrigzJXXw1j3RCbD61z4W1Itd9hYgMUoiVd0kg36Jype6IqzTLq3z33BO4c/dxSvYX/OYxZofawDa0Dl/O9eZWqyn3/kQIrUcjTI7PJOymEviSPosRK5ElVm8oOru0duWdgqUu0zBX3VF4Lyl8yFHXTwKXY1pA53vQoqjQW1anoOjGWN
 CkNeYH0S
 gYnz0rOrt/icRNxdNSulPI/0gwZ1rpKbQjfODP47TDemwMBJw41XS3go/FQds5Rx8CG13YMAOHuwEnsLG7S+xfvL+/J05EbSo7/20fFIbkgW0P5dqNeDR/GiCBv6QRw8gfqSgXltNWA+vy1a+crQGOVJvEhmCHjMjn7ry1mD2nXyZEIDX0R4q/3OezXxtn2iW0sJ8z934V3OH/kTr5ve9DoFoab4q3ge7hOsjbA+sSxWJ2CI=
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
---
 mm/vmscan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c1404a59523d..fdc45d7d8fba 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4892,6 +4892,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
+	if (nr_isolated)
+		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				      nr_isolated);
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4954,6 +4957,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	if (nr_isolated)
+		mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				    -nr_isolated);
+
 	if (nr_isolated > total_reclaimed)
 		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
 				 nr_isolated - total_reclaimed);
-- 
2.53.0


