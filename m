Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1DEC5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 02:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E847C6B0095; Thu, 20 Aug 2026 22:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5BE36B009B; Thu, 20 Aug 2026 22:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71406B00A2; Thu, 20 Aug 2026 22:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3BD56B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:16:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B6734031F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:16:31 +0000 (UTC)
X-FDA: 85123662582.20.73EDF15
Received: from mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	by imf20.hostedemail.com (Postfix) with ESMTP id 32DF21C0002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:16:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wq8oJGAk;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787278589;
	b=bl0L/GKyb8UBo9LiiDN3ZU4rRE94fJ7hHEUut7y4Nie8tOIzeFU85OMoEDQxxjvV0IJPbw
	wvIe9D0hivYfOAcziDHYTGKC2ih3qccL2OGfj//np6Njs1Babmd58vW0ah3VyuUfZNILz8
	cJ5z2zUPR/8myWuthKccPchhR5vmfnI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wq8oJGAk;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787278589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=06VJ/cKIWm4xTkcOWePNqyqX4k9F0vE6a/UnptulOyM=;
	b=f3CkKPcvUBR7kpvv6RrccUQLwgmJVjMZWqle+VD9QA4OG4WqzE9YWXf/LOmWsX8iEVgmHL
	fQ1ahujZx4Rd1/kv02Fm0hfvaDmtRqsChXynSqbbjLviKgK/IDdKdg/l9i/8fDinmRa/d3
	8NLjxv/jXEnO8lBd0hKokGurji8Ks7M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cQfTML8jAwykpKy6eZpPxbBffY9ZWjQHa+xVmDcrmew=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787278587; v=1; x=1787883387;
 b=Wq8oJGAkepwUhI9Og+QnNlfn63D+3A4EDQ3ua4Sr+Dn9HkM3xa6pKEAY2koWxPRUcnAIKHUK
 D6rw7hnJmdg/508lDpEccAzQnVyy8lMtzc4NKqHBWYUmnmuv+Hn+6+ZHvdgBYF9BTBnHqrtF2xP
 Hfz7SAtH0j275FFo003t7erQ=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 2ae2dc645df94b93;
	Fri, 21 Aug 2026 02:16:27 +0000
X-Mizu-Trace-ID: 2ae2dc645df94b93
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Steven Barrett <steven@liquorix.net>,
	"Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2] mm/mglru: preserve inactive placement when enabling MGLRU
Date: Fri, 21 Aug 2026 10:16:06 +0800
Message-Id: <20260821021606.877330-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32DF21C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: m1ujwyzkswkmz6p76znpwsdkpfskd7pq
X-HE-Tag: 1787278588-19399
X-HE-Meta: U2FsdGVkX1+jJYJF4ylntbbhtqCz43SazcpjHMTFwUuLjY/KUanL0PjZIJigmo/kJBmLCF0bveR0ss2WOLVYFpyd8buNtSZ9nBqpy8xXfzAGhKQh13/zXoNUzu6S0Kf+745LdoTcF5VLhQ81gDV2EzQmpBwuFytZi1ir/OgQaH76TBkR9Onmey90hzytASjaR/Od2CK57Uz/1p/YBwsEjYskM4ZCV2xZt5feYYLPsP1n1GzS8Lk+2zyNnnEwSZf3xoUUaW8OiVlkkrpb/xlokRCFzGgDTPkPKUJ3CHlIqZkRA0iYxItMrWOxL+T7KHeJLGbdvz2ajQkKbZZre+Nigq85E12J0+7i8k/GdzVMNF6InYzARN0EHgyHqW4L83WEHdsC9JLU+3ljOs+ZQzxOOdLXQ47SZ4eae3YhGM8oNg4YqxGyNlMtrLE45DVpwfFblFpYPBCNrh5+8eRpPVk5Jx16c2xH7taB/mX1FKBDByYMP/7UDQd3BNffu99ggwNF/11uI7S9w0kxfv0mOvNHEVO5ExzK0mQhxY/HBGlKCAERS9NiAYGMsAXo9ltvw1jb2CH6p0mezLwzb1ypj9BM+TCWPvWTIm8vxCk6RBBzi8ayblMvyzqsBhZjowhvH3rqZhZrvBqSK1rQlg9CbAsR0wkYLfo0zlaKJpojyK8SnSQYg464ZML9Suc/2xUtD/LJDIf1zUchfA+0ntG/BTCrgLe4XU6GVY1EixdoG0TTr2pFN89YCkePifDaD/imZYa/+2FTdiWoUmIOBBnpU38YngzY5b61FqLJjEDFcsK01FrdCYWFuImXLpT0N72Oq6+3sddsINFYkbpTmiC01q9KVZsUCSuGHNTuZwzdzLUo5m0OVkjLywD6oXIjfbXK+KuI2i4u6VoTPZ2LMST4iyGMpk3tEMmOoLPXKgByh1tMTm08Si2RiQ8imGjYf/YuuaoiZzx+KTP/mepoMJMZgUz
 PQr7aZyP
 IWys2CQRjAl1sfU1SHW6EEQtj7ewfaPVZ27DkhpTl9wDvnpQZwtIT86t61trMHMzufy9bFDohv/wdh8vrQcsSkg92UBsoLCLozWXP0eBVPuCuVO9ls+bjtoS3w3EwsLRqnfg4s5m0chCF8BNp+KvGZURgbDTlBoaiLODerFy5V45vDHqlnHqDnjC/udyb2iTXTZCbHTqLsnETt60JtmyOCUZ+s87yGF5V3JVEiQnFDIkWddaJdiJmxeNSZDDbPnoLhKGlZS3emzIsG0v0mwQDVnAomQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
enabled), fill_evictable() re-inserts every folio via
lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
inactive anonymous folio (no PG_active, not in the swapcache) takes the
"gen = MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
seq = max_seq - 1, which lru_gen_is_active() treats as active.  Its
inactive placement is lost and NR_INACTIVE_ANON is folded into
NR_ACTIVE_ANON.

Pass reclaiming=!active so a folio from an inactive list is seeded into
an older generation.  Folios from the active list carry PG_active and
hit the first branch either way, so they are unchanged.

reclaiming also selects the insertion end in lru_gen_add_folio():
list_add_tail() for inactive folios, list_add() for active ones.  Both
the legacy LRU and a MGLRU generation keep the hottest folios at the
head and the coldest at the tail, and reclaim takes from the tail.  To
preserve that order the folio must be taken from the end matching the
insertion end, so take inactive folios from the head and active folios
from the tail; otherwise hot/cold would be reversed within the
generation.

Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed onto
the inactive list before enabling MGLRU:

                         Active(anon)  Inactive(anon)
  before switch (legacy)        2952         1548792   kB
  after `echo y`, unpatched  1552052               0   kB
  after `echo y`, patched      15144         1536636   kB

Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
preserved).

Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
Suggested-by: Barry Song <baohua@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 94fc4f25e99f..c17ac77b08a4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5311,7 +5311,17 @@ static bool fill_evictable(struct lruvec *lruvec)
 
 		while (!list_empty(head)) {
 			bool success;
-			struct folio *folio = lru_to_folio(head);
+			struct folio *folio;
+
+			/*
+			 * lru_gen_add_folio() uses list_add_tail() rather
+			 * than list_add() when reclaiming is true.  Match
+			 * its ordering to avoid cold/hot inversion.
+			 */
+			if (active)
+				folio = lru_to_folio(head);
+			else
+				folio = list_first_entry(head, struct folio, lru);
 
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio) != active, folio);
@@ -5319,7 +5329,11 @@ static bool fill_evictable(struct lruvec *lruvec)
 			VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
 
 			lruvec_del_folio(lruvec, folio);
-			success = lru_gen_add_folio(lruvec, folio, false);
+			/*
+			 * Borrow reclaiming=true to place inactive folios in
+			 * the older gens.
+			 */
+			success = lru_gen_add_folio(lruvec, folio, !active);
 			VM_WARN_ON_ONCE(!success);
 
 			if (!--remaining)
-- 
2.34.1


