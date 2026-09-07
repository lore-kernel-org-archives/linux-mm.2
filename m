Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3185C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52C76B009B; Sun,  6 Sep 2026 23:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C044D6B009D; Sun,  6 Sep 2026 23:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B433A6B009E; Sun,  6 Sep 2026 23:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93FC16B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:25:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 282DE140612
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:25:27 +0000 (UTC)
X-FDA: 85185525894.24.CC3D1F7
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 456551A0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:25:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gxzmgzEc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788751525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rS6imTLMpSvjT8hbBugEkDfrPUjLonv/z4Zv4Tf3MOI=;
	b=i3Bk9Uv+tbrw1L8/sj/+pPW70zMrcGQ5ozYVGeVZy3DfCZd6nCW59dCyLj8n24K17wIc9i
	ga0uE90zYR+KRoeUPzlwvVhXZJdRcRo3tgb12/WsfWRiKWqpr1srIse8hLXvTQdKQm1Cim
	0OGB8npjQQPmatgEmubn/7hR9/h9S3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788751525;
	b=y5nd8YqBK3uqas/ugAhJdi+/gGnpSgOJWw8T7YxJESWiZr+fd9XMMqHDgWsGTolYyuGKlw
	h7/1tICOnpLZ/jWIuPeyfWLUGU6ED7ivScCa+uxH1gQvT4rPHAEW+vtRVqIhHAOf7UVbEQ
	NN8SMbp0n5VEZowtsa8lclUTth+tbOY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gxzmgzEc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788751520; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=rS6imTLMpSvjT8hbBugEkDfrPUjLonv/z4Zv4Tf3MOI=;
	b=gxzmgzEclg1VHA4ZgPubnUGguh2rbP/SNfNGIkRjEZDXb9SPsdFXcdp6AtnRVfzBtCLGWi57EHq4VKW/2T1k19hctSTKky+6zT7OIG9App41qxtqtg7XLWqOOAJscyqx/YrnntOfUAAaVZcLBOYY9Tu+pmJC8gJSKucjafA37rs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAOWTEg_1788751517;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAOWTEg_1788751517 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 11:25:18 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	ridong.chen@linux.dev,
	hebaoquan@kylinos.cn,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: mglru: clear the reference counter for rejected folios
Date: Mon,  7 Sep 2026 11:25:12 +0800
Message-ID: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 456551A0003
X-Stat-Signature: fz4pitcn1pq7aj567n7tzia9sk35gftt
X-Rspam-User: 
X-HE-Tag: 1788751523-242860
X-HE-Meta: U2FsdGVkX1/mSYVPx7zxG5HMXUm6SmjuyU/5/urXJqA5QtZtjCsPYdYnV/ythH9K+WyoMutjCB/nXtyNoOgu/nX8v3qPb1YKP1IDVlQ9BN5ZFQfKS2gj4eJq1cqyYN+XGWKGs9Y1hzqg+j0JiOc/zk+xz58pL/dWJeu5scG475Ktzed7mgo72sbvGylYCEjZU2i6AafDNoxHKHxQBS6il/Nnp3KUIFSZ96Dm2/MTK5wIivpP6Zs2OY7gVsGxc/oJQGC54M/xo8OYiG6y44ZDquY56K0zgJ6sazU2PYjqm30dz243/fIxjjbdsqX/R7ED3JLro9rkGs2F2hKTrowvfWKK3L8yn4r+i2z4uIDzYMZd/t/6E+IedC8DNuJY6LFFJSWTCfjseHRmQMEfAE8B+MzTZlZtmo5mqac7p18ot7Hn5DsxGxPxnHppN2HCcidkkNRv5H9dD080Lky4pY4SOWpHhD3tUQMZtUaUMJxZrtSe4kbLLgegqxn6WOK0tIXPEc6l/4UcYozpozCoOZPGTen/a9+lHkMfmN6o6x/moaPAD2zJwUOxwQNwbWGMRY9sFPBvQfhhD75+jf6TY3gWVQsQBoh7fBr415XqrIDawLaHfWrJrC5mS215wKjMzskl58tQkPTB5ovWbxvQLQlIxT3mEfcX67MEsPMRz7cbyspMrXca+c29n6hf5MjWNOk9d24zzyVJk0e/Z9fvqJthsmFQ9EXekgF3gDHCMtVk/zeSI6XmnV7/ErnM/zhQRgoWDk7xFKJc0BTa11hV5WjQnlSZ0iUz0fAVAUGqyAtMySL2NMwdx0dxjLkv5eJNHyAtl+3Ba+SYEsgkrYz+nsTRWrrk5X1T/ryvQk9bUBYFedo/E2b9HqHNc+UH5DgmyvVt/nP+g5zPuXaQ8OMmnnDbBfE8gy7y0EgwNhPAnGj774sOCHVJvqzjxVYCyllPkpVxjTkNerUCTyDu2eztFxc
 R8z6Nnxs
 1jdtwvmPTgYApvgTUhBNhL20G7IF+7ii+bnN3rnRwPANzlrwLvoPX4VdQlYjrSKJdP9h1lErwknUNL+cIQy1SRx9BoKH/mTVTPaPjefpvXi0cnM4g2JhBlDqaQVH3ozVfu2FedsZDAep66Ye75LGyMTDNXuCKT9L1wTuoI8vfWb4MI4FxDfgXGaqr56TJcBkH+RhgoSoPoe6exu90/VknoLmsSYreRRYzozIaK/j3BTeAWFSxyTeUjTeuFZrCYbzhvJb+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
a new generation, LRU_REFS_FLAGS should be cleared so that the reference
counter can start over.

For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
set the PG_active flag if the rejected folio is planned to be put back to
the oldest generation. That's fine.

But for those that are not put back to the oldest generation (which can
be treated as a promotion), we do not clear LRU_REFS_FLAGS, which can
violate the promotion mechanism. This means the rejected folio enters the
new generation with stale, inflated tier bits, which can inflate reference
counts and distort eviction statistics for these rejected folios.

Fix this by clearing LRU_REFS_FLAGS for rejected folios, and also do some
measurement. On my 32-core Arm machine, with the memcg limit set to 3G,
running 'make -j32' to build the kernel showed a small improvement in sys
time when using either a zram or NVMe swap device (averaged over 2 runs with
no significant variance).

zram swap:
		w/o patch	w/ patch
sys time:	1666.5s		1589.5s

NVMe swap:
		w/o patch	w/patch
sys time:	760s		741.5s

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 40d3f1b48a74..42c0a09938ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5021,10 +5021,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		}
 
 		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
-			folio_set_lru_refs(folio, 0);
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
 			folio_set_active(folio);
-		}
+
+		/* See the comments on LRU_REFS_FLAGS */
+		folio_set_lru_refs(folio, 0);
 	}
 
 	move_folios_to_lru(&list);
-- 
2.47.3


