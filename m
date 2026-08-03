Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BEBC55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46606B00A6; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D807F6B00A2; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CED6B00A1; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 742096B00A5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 001851A07EA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:28 +0000 (UTC)
X-FDA: 85060992576.29.79556C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01CF11C0004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GlzGBOqy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786447;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxP7z+CiBCZCgTfGQxVk59qGgu0P8A6ucUX7PT2Tv1M=;
	b=ofBKxJKG1L0oKg8gf6LQRNBrxZSf06KVonqaV5857fLZ/hcx+i0v7nMtSk2Wv+7hmFhB9b
	ScScVw1tgNHhZZIJrFomxn2Wws9hek+0VPyc8U4GbnyAS5jXXKyOXJDAUsHKniLb4K9h8Q
	Hr1lH29Cds6K3O5zbdcs9GR6PbbUF1A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GlzGBOqy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786447;
	b=bE6FI/gnDyXuNoqzmd/xG7A4KbIygtX+i5JLB4lhNJgy/YGdattakqfZPPlMQ1tN0ESXXD
	HCqgQSrfXZ1+WDzvqDmUWma1pYPcNdeGF/wS1IIC96Vt98yhYQPHuL8kgatWalRtgZPeT6
	MDEY3kveQGU7MH+7ixkrnQNXU/vETQI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DED84507A;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A2B7C2BD01;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786443;
	bh=ozlP16v/HxlVKrcEOAOjQCQyb4sgtwD0X3QHzHntDkc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GlzGBOqyDrbpUYrwIhtK2XJ3zvl+rkTFDs9PAIpQWtKeWSEXbz4Syzhc+hM9k4SHc
	 3MHiEprVgCIkXc5yiqHKgW0yb8YXDKugvRJ8hsVm1hwiI3hDjYGdKdC23zYhSK1uPV
	 y55wgrUR3NM8Q/Ue8nH3GE1QyRBdmUJddSBV9GZsmcdklwrwLoVO0mWmrsAqu+FF5a
	 vRpK7fMS/rOrRjB8vm0mnj0xZIuTvXlbCydOLJ2lm9bEj9L3v+mD5as1JeYgL3Xmhv
	 6XKgsb8jwSErBUj/R41/6gaiAR0OenavrSznfQ6Ep4b4gMcfwekSUvgRrL/koQOhNG
	 hQ47cJDYQnGkg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F34C55184;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:08 +0800
Subject: [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-12-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2528;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=w6RlPQJYy1xwfLtM1LXlBT4HMO6wCueMStGvS21qkQ8=;
 b=cic1gW3I0SoP78woxinTEezcXi3rjJJlFplB1hZ3sbyv9AiX0gCSAui2nXMP3uCgUxCTP1R2d
 5cvp+hpla5+BDyG2oQdBDsnw2Dj9Zc4FvGYKcB/svhLvwI4iYWV+la3
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01CF11C0004
X-Rspam-User: 
X-Stat-Signature: arqtjj3y4bdxt1smub4hedj8qu5ow94x
X-HE-Tag: 1785786446-283741
X-HE-Meta: U2FsdGVkX1/2Qia6KEbVh8NFbFrc/dAX7QDUSEoZgvEtiHWXQNEdTpv2kx9g3nGbiK1AWTKx5Dvw8ujy6xmG6LlGepwJ+rVuUd1sMWJYEOAroXNks3JW8IxaV/P2eiVfgAX9Rmby5IMMyz1UKD/tFxuIrfMFFqAbMszL7lgBDZANrqozcJOIBoEObb17ChoI0JgahL7T73F83vCt5zq5sDRks/nyGK4kspWdF4z0/tuYh9XQ0BjVAj2k9EwIC3fXthEj2W7fYeSocVnuXZ/MOCgMZuoKNIdMW3tiF39e4gKQOnWxI7IvUetyIp2ud7eXVC6yBaD2OTzkVk0N7kN7m2eMShDv8/e6PltyJMPpQsn0dbQyRPA4UezSvJyAE9WEe0ZnewY1FVqFa36YgNwBYeFQqSkrncxu2IzhK2gshVIuOXGtjhuxA+/HSF2jFLwpmA8llm+XdXJWbpCr9wXkl39GhFCx2VkDuRIvBNjnB+rkcofH8+vb6lzLDUP++HLDAQMHu4H/YogmYeIP8xbjWIDLmgrmff8Nqsb3L+HsvGgoXbv4bhJGAlAlD9WiNKPE7Dwav/mtANHnR+aP5plUjrw5bmoH3Vq+gy49uscXCcfKH/OS7t2lBNFdpPLcRudOKyFnszPCcjbuY0kjmKmEB2TqWPnhawtR24r1Iyj3PYqfAkn8SdVokLLtXJOFoPhg4Uo3/1kAufM82qL5x/un8ENsTVNlM2QjUAXMjQYu/WsfrfSVqhykLf4qWWTLfqw+uiswGgUNNRuicXBPII0XgGTo4Kxp4eM9V0pqfWnp9JK8pfTpLM/VzXpJv3Q2m2AsqHfqpQ5c+wkVC50S1bIip5n55Gbe58cOh6bTDWPJZGvIo6NR4zERu7uhr909ykO1h3EgctUGEbNmbJdkbNtrQmkeoS67yxlzPuUUbOww5sRrVGcefXHxqrl3VFmY0TaNG92PuseUIKfIwL3Ufxw
 nxOUxb5o
 q1gEaYZgKvOgeCD7dNsK41kDMKDTpyHPyvWBoPqxFiZBSZ1YPhcgcCqfV1cXt5SzqACxk9Wuz5Xo1yhvtt+28eMyAEhnnMwVzblDZSZFLv26M6ILY6NigZQbIGJ4ZEpom4GWu7mQrr5ebO6hZ/e/gqhddvdmxYbDDdCT8aN6mh56O8fFyb4LCMg0X5cbPcgBRmtdECwMmn1PYvisIwA3slGSm5/AtFUrZ5wEWPlWK+zW61UGQcWy/lCJRHUaYSLPqsVT5swD01VBLv745284QhiYi3ZArLRvjmm7FXJF62BQ7a0/XoY6m/HCW7v0llhpnmebPI0/D/IuHTo02tfhCBF/zOVk0amUWIOs6HIdrG0HVxcKcNEQDhRPUPePwYAMrIWiwaZcPZ4gDcvP8H4pKqrIBnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For MGLRU, switch smap to use the folio refs count API so smap will
report all folio with referenced count >= 1 as "Referenced". Current
smap checking PG_referenced is causing folios to flick between
referenced and not-reference status, because for both MGLRU and
active/inactive LRU, PG_referenced may got cleared on second access.
(Increase of LRU referenced times count for MGLRU, and movig to active
list active/inactive all clears that bit).

After this, we will have a more reliable and useful reading for MGLRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 fs/proc/task_mmu.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 817e3e0f9194..c5c96c523291 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -944,6 +944,22 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 	}
 }
 
+static bool smap_check_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_is_referenced(folio);
+	else
+		return folio_is_referenced_by_bit(folio);
+}
+
+static void smap_clear_folio_referenced(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced_by_bit(folio);
+}
+
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
 		bool present)
@@ -970,7 +986,7 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || smap_check_folio_referenced(folio))
 		mss->referenced += size;
 
 	/*
@@ -1791,7 +1807,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1820,7 +1836,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		smap_clear_folio_referenced(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();

-- 
2.55.0



