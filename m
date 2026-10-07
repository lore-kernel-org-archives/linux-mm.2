Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED371CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 02:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5C16B0092; Tue,  6 Oct 2026 22:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E766B0093; Tue,  6 Oct 2026 22:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DC26B0095; Tue,  6 Oct 2026 22:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2FC06B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:14:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EDF9C03A3
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:16 +0000 (UTC)
X-FDA: 85294210512.08.D22D877
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF98140007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="URCbct p";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791339254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNjhHTiICdPRSkHBCtEN75cF7naElFR0UE3xeF4iQaA=;
	b=1xj1TtAT+TP4BDaWq1bnGv2j4Owf76YvVGUeSUNWupJ4AMDByRH1Ow9IWn2knCI4/Dchl7
	jBPhB4UjDvykRRbMKuZ78Bfu3V+rfjmZANp/sMNveIsNNIZ6t1T/p9uCR/RC7vbYbKUsZE
	+WWnp5olABdtk57/sCSxwGPttdbvcUA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="URCbct p";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791339254;
	b=V1JWZjpELvAqQKl1iBlp6hRlZb/xvg1r1wdSFnSks1pmTCnv7LZgSZ/QQkePgjQpUAriIR
	NnO6GmuO1U0zdHjh0Jjc6AdmQfHU0JRo78xinLT9oYG72Gpd8fvJqs6OUkse/psCU5ssSV
	x67GKbyXiBCOQT6rb2UwNq6oH0Bftjk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=yNjhHTiICdPRSkHBCtEN75cF7naElFR0UE3xeF4iQaA=; b=URCbct
	p7mmfcqizQvr/cK17TflxjdjyOb0wOoGm4Xfez+dEwA+x0bIRRzcFpw6fRcmG/vagoyK5Z7Lmp6SQ
	RpF64+w9oc3mO88qQlNk5VbHmKEv5IV/V+gSbxSsSOxEilv5dgdZeF6IA23Q/XuECQziKDqZEUGWk
	w36mETdkhgqN8hwKcwO3lqnb5XVO7y6ekDOv3qEIC1363UZvKQdAJupOrZXZY8nkcIN5spVeuU+YG
	mRcVvmNfvpur/h/yQv9eeW4xH6u/LxDbPfOcqtC8W4QGlz1fV8bzaW/NFrcX3UNiBhXOb+1I3eikt
	Upq4P+elZI2nn/DBOAUUOD9IxMDQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xEH9M-0000000B2cT-3wVc;
	Wed, 07 Oct 2026 02:12:56 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>,
	stable@vger.kernel.org
Subject: [RFC PATCH 1/5] mm/page_alloc: count guard pages as free again when their buddy merges
Date: Tue,  6 Oct 2026 22:12:46 -0400
Message-ID: <20261007021250.1665929-2-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007021250.1665929-1-riel@surriel.com>
References: <20261007021250.1665929-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF98140007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: tgujsc5fn1rp3erhyqg4yhtp3k5xbwds
X-HE-Tag: 1791339254-193697
X-HE-Meta: U2FsdGVkX1+z83RxFZSG94+MBSUUZSaQiZEDbDrSaR+ZsLI6Cn0n99kZgXpueHlH6GvUI82dsOLSLGjAXszuGozDR9J75GLMnilgXa96bXCt4iumujs3jjVFOHKymXkoYjsk6edz/qlXV7EcKgm+zuM76B+irNVEZH+2YhfdSqtDUQjsVZSM/OJ8aEZyLCLRivsK5xqWcCUE/ahChu81XZQS7A/iyuUxjUpa7i0ReCsEYEG//r8J8pceB6dZgZSk7LgPkVV8kdqybQiNUAM/hsoF/kb8Pl6XXXqb5BZSEXbZwe6/Bz72wivSPTOMiyflTZkxFJ3yxZCWVifoAxOLcolmlN56hxTpZmWjTJAvratSyCYfykueGlc+gAFi9baucBTO05TaQIus14rugTURZpeBGtxfEtcYYS0mmWfWffW6C9ABhN4uJd/yGPvHdlCUkEFly6PxYkk87dUJ8dxEIFBuKYgDWYPgUhet8ot98CcoZx8cGHqCAyzWBLM44crjnWU564E99TlGuBn6T8FJdP6Gx16618O8uusWQ45mYcTsZSR2dmICfkTA/PPVosw/t+twQEHkSsdt0rRdwdBmkx/9R/XGGgOmKbuywj67ZlwcrwUBn+Cn3dFoZ1JiJ7GN7IB9Ius2V4jXdwRwR6Fx6hhxB3KE21xcpNjTOc9xB3LrLbpVEqdt/6xQpBeZxSTSg5spGjpHiq533cqslXFx4W17tywfNAOWd4nJb0fCgR9Yp5v5/sbKHW9fQv9SfZqGil2mnzSdPIKDOcBlAsByOwq0EX4QCmgsItlNzTlCDuo32mWWWZ/SokVIcTH2qkGx5HliSZcGxG9AkHp8OfmsOJGqLTh53vl0e6iPtiZt7iVyU99DHJqfewov/7CRJYmeuRDpTnMuAA1f8DnFFevmDUPXyP8tO/OTVrKFdeiT+RewB6UBwXfApMpJUfXjVLoCebhdQL3PXTtSPCjM+xb
 a7HeSFvK
 NRxLC5h4feRc4+b8dsJKa/LPN8I9INf1wp1wZ6fAjOHsO4ZfcHtkEDwykbaEcjo3AK8L+TTPSwA0LsGsakejciFw/+rD0Vb8U27K31LmtreOB0/tQf/fg4Xtvl+NcLloTS5qah4HURm4ORd8gNLQM4UqigMLQoB3I7GQDsCFyYdx/pKMim+Bdg+TdGP09agh8+1m5u7JfTbavObPqlmenT+KNBhP1AefM+beOgAO33/KjYs+JNKydJRyufkLOaGv6DFn4xXJ07a560UemlvUU5MNEmSJBcj5fPOvqhXJf77hoMxk5UFouoQ8vQawILIka6UQUSQu5SeJyHOrfL0ygZlOrcG+0KeV2yrg2DpWshDzYbIP4IE6sOU0v1r63D3Rg9WjFMWG3NufnTHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With debug_guardpage_minorder set, expand() turns the unused halves of a
split into guard pages, which page_del_and_expand() leaves out of the free
counts. Freeing the allocated half credits only that half, and
__free_one_page() then merges the guard buddy with clear_page_guard(),
which no longer touches the counters.

The merged block goes on a free list with the guard pages never counted,
so NR_FREE_PAGES falls behind the free lists by every guard that merges.
Before commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
accounting"), __set_page_guard() and __clear_page_guard() adjusted the
counts themselves; that commit dropped both adjustments but kept the
subtraction implicit in expand().

Count the guard pages under the merged block's migratetype when the
buddy is cleared. account_freepages() skips an isolated block as it does
for every other free page, and moving the block off the isolated list
counts it then.

Booting a 16GB VM with debug_pagealloc=on debug_guardpage_minorder=1,
check the difference in free pages reported between /proc/vmstat
and /proc/buddyinfo.

At three points (idle, after a read and file-creation load, after
a second load), check the difference between nr_free_pages and the
buddyinfo numbers in the normal zone, as a number of pages:

                idle   after load   after second load
    unpatched   -130        79205               99121
    patched      -16           45                   0

The small remaining difference seems to be due to the numbers
not being read at exactly the same time, and is also seen
without guard pages.

Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/page_alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c483..4658af97be010 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -988,10 +988,12 @@ static inline void __free_one_page(struct page *page,
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
 		 */
-		if (page_is_guard(buddy))
+		if (page_is_guard(buddy)) {
 			clear_page_guard(zone, buddy, order);
-		else
+			account_freepages(zone, 1 << order, migratetype);
+		} else {
 			__del_page_from_free_list(buddy, zone, order, buddy_mt);
+		}
 
 		if (unlikely(buddy_mt != migratetype)) {
 			/*
-- 
2.53.0-Meta


