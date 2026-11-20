Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB841606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ek4Q8C0V
Received: by kanga.kvack.org (Postfix)
	id 75EA26B05C8; Fri, 20 Nov 2026 02:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735EB6B05CA; Fri, 20 Nov 2026 02:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6754C6B05CB; Fri, 20 Nov 2026 02:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4670B6B05C8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:47:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F9711A0DA8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:47:47 +0000 (UTC)
X-FDA: 85454718174.29.69485C4
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id 670FC40004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:47:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ek4Q8C0V;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.35 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795160865;
	b=5JhgnHNUOJcKsjuP98bA1nqNO5iCoGaXMJPc4Vc6sh4iUeHJQG5PoIJa0VasrO1iDgyFNE
	foHoZejRe3zoOIMiTqDYrvCMYfK+BaHzfAw25wY6BK7vNId2v205HI3zNiWWU3TwXibu8j
	EFzre/5ckZjOeOUczUPLyp/Z1T8jaVo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795160865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/y1qXQ06BKv4Qawqii9E8uutLP6R4HWSV0iDf6FGFuI=;
	b=5J/rqaSJiFBiK0yDLKuMuenzgUMlN7dpbU/dbtX5jLcF/Bewn2bU6UWqs7JYmz98BZBlbs
	DiaGW9FZecaLCWlXy6Kjc1tgxYmklkPoPrQeYpikJP8j3iCj3LOrriEGAqc15pQSV6Lg2N
	udLI7gBIrofxfft19sCLIokaoS+ntRY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ek4Q8C0V;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.35 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6vVXslyHXg7KTNISx0U4V6507R5r4hQfQTf1zEh+K4c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795160864; v=1; x=1795765664;
 b=Ek4Q8C0VwK7Wzmjg8QZgr4LA67nhKYQi0tIMWKDSuozuQ2nhjWYld1275sfpe203q6gf0rM7
 vgnM+kTkFU/tIvY4epWnL3OfSmmi9hgjeNYlKtTV9nPCbIrQNRRQhS1iULFRqI99IP6DcO83V5w
 XajCBgblgpEY96r8/LVX1mcs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1cb2d6027f8dda27;
	Fri, 20 Nov 2026 07:47:43 +0000
X-Mizu-Trace-ID: 1cb2d6027f8dda27
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	fvdl@google.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm: hugetlb: allocate larger early CMA pages first
Date: Fri, 20 Nov 2026 15:47:01 +0800
Message-ID: <20261120074701.48298-1-qi.zheng@linux.dev>
X-Mailer: git-send-email 2.48.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 670FC40004
X-Rspam-User:
X-Stat-Signature: o9y9dq5ydg5f1nto6jijdkjw7w8iffgi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795160865-820038
X-HE-Meta: U2FsdGVkX1+EDISy+4r2jHG+AuldGxnYjQRMLXteHMMcffqP4e4JPVRWDvlklZrzhjZJs/ZSdaLybQiGlBWSflyaMBcaevqCY+xL2tcX3muxOoC6bSDTqtHtf6OLnF1Z8tNy6Vl5yFLimen884u7nhffrs86czcvQGKSmpCMtXTdBLkfs91gDwDwZMbbl3dcTUd3SdVRUxaEb25Z9DlSVJGygpU9hnFyZRnQHoAa0fBwX7fBT07MVeS5BH2VeK8zvtUpeAh04RX4th2/aVfvktaOck7Sct2CbtlgkAC1fvpMghK4VH7LQb5hfVxfaBsZVRxvOsgaZHlLUjaXGuZF7FRe+NPI2Eq4QnZWTsu6oG/6NjRwAVA3Nq1OXA1N8oI34BkcmAA+2NMN2tcQh8y+66Fif4y66PFkOlzMCWpNUEPSuX07raWETkpBQhXyuv4uRH6SIOGCMoEdN77enXJPvNxsEPQtK8Ns5rgn41IjMba31UMWhNoohj1BLHJb+zY02uXxrmstwo8o4OqGtHfv06XLzieY8cGp5zajrHVZN+1DTNJezb9jQaCouPB+mwqA+sgCvsB1W5M2JXknpkK6aRiM0RrgD5T27wZwiAfFs9dMGMNKYF65SHuzSkNNSt9qbDDEFbAGBMh0GC92QugL4lw0//k4OVCnyOgdU8Xqj0VUD9bcDa52w6siJMNhLgmnr5pQ/rbZEI/tRqiji1MebgKDJT02ff4s5xYi9nusFJOKXUT7QyFgRx/BBANkXm7TEEBVbJAc6mXNosUXw/Dw1aMk9VwKgCah24UrFG71gEnVwJtclEoSB6eNC1hiKfziiHLh1wH2p2Q5FgQNHebwZ0Wvl3eSyei3lEJhUyRzy1nrpp93sBeIyFKaWKCAJQ/1CyRLRBMZaAoVpKrOFX0fbVcqJQkGowM2hgOgfsiNtAA02ysWxStOszSJS+tois7r0sKRGdBHNV8rMfVBhmm
 Y0EJxaEa
 650Zduq4DFTcR/ByBDtn4RL6OrnKqJqSUDfBPRoIhFhEg3YzYLK8ly4iQEHKaNTEojS+LvL6lcZZ8K6OsOmjP0mJZXY30Z96Z4uHMgjqj2xyozwdPF5SCMjV+CA7GnDRbVPXLoh6Uwhgw2YrGSlG8MwXPYcbYeKxkmx7tiwQoNgQVkXkjEWrEKEhvTSUNUUPVEKLPNObfK6c4gIyVBIHS5fmqfvoVwffUpcgSCcvJ5TFUkklO0JL044PRS6q+7ssluoHWOvg17tGfGOJkOE/bKB+X0Ttfyj2WAT5O3H936emhAaugVOVrYVUbJvqoYT82LXozr1MWV84ec4lRh6EsN6FjWWBIhvUSmvHVrPwS+cO07axGwHgmzb3RCvQesrduPqBlgOqQh98jA0/806Hpu33JSwpkI3egQG56PTh2CkWxs7T3Q4xbWX7BvYAbpjsqLvTLDMHj2CikpPJQHhbtH04hv+EhixE4Bxb2Um4Dt1tyGEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

With hugetlb_cma_only=1, early HugeTLB CMA allocations follow hstate
registration order, which can depend on the order of hugepagesz= and
default_hugepagesz= parameters. cma_reserve_early() advances early_pfn by
the requested size without aligning the start of each allocation.

On arm64 with 4 KiB base pages, 32 MiB and 1 GiB pages share a CMA pool
aligned to 1 GiB. In a 2 GiB CMA range starting at 4 GiB, allocating a
32 MiB page followed by a 1 GiB page places the latter at 4 GiB + 32 MiB,
violating its required 1 GiB physical alignment.

Simply rounding early_pfn up before the 1 GiB allocation would leave a
992 MiB gap and advance the cursor to 6 GiB. cma_activate_area() marks the
entire prefix below early_pfn as allocated and only frees pageblocks after
it. The gap would remain reserved with its bitmap bits set, and releasing
the two HugeTLB folios would not reclaim it, permanently losing 992 MiB
of usable CMA capacity. An alignment-only fix would therefore also need
to track and reclaim such gaps.

The same alignment issue can affect non-LPAR PowerPC64 hash MMU systems
supporting 16 MiB and 16 GiB pages, with 64 KiB base pages and
CONFIG_ARCH_FORCE_MAX_ORDER=7. The 16 MiB size then has order 8 and is
also gigantic, sharing the 16 GiB-aligned CMA pool.

Allocate early CMA hstates in descending order. Each range starts aligned
to the largest supported size, so this preserves alignment for subsequent
smaller allocations without creating gaps.

Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/hugetlb.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a448c5909d36..d69a9532ad5ef 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4600,6 +4600,22 @@ void __init hugetlb_bootmem_set_nodes(void)
 		node_set(nid, hugetlb_bootmem_nodes);
 }
 
+/* Return the largest early-CMA hstate below the given order. */
+static struct hstate *__init hugetlb_next_early_cma_hstate(unsigned int order)
+{
+	struct hstate *h, *next = NULL;
+
+	for_each_hstate(h) {
+		if (!hugetlb_early_cma(h) || huge_page_order(h) >= order)
+			continue;
+
+		if (!next || huge_page_order(h) > huge_page_order(next))
+			next = h;
+	}
+
+	return next;
+}
+
 void __init hugetlb_bootmem_alloc(void)
 {
 	struct hstate *h;
@@ -4615,9 +4631,19 @@ void __init hugetlb_bootmem_alloc(void)
 	for_each_hstate(h) {
 		h->next_nid_to_alloc = first_online_node;
 
-		if (hstate_is_gigantic(h))
+		if (hstate_is_gigantic(h) && !hugetlb_early_cma(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
+
+	/*
+	 * CMA ranges are aligned to the largest supported size. Allocate larger
+	 * sizes first to keep the early reservation cursor aligned without gaps.
+	 */
+	h = hugetlb_next_early_cma_hstate(MAX_FOLIO_ORDER + 1);
+	while (h) {
+		hugetlb_hstate_alloc_pages(h);
+		h = hugetlb_next_early_cma_hstate(huge_page_order(h));
+	}
 }
 
 /*
-- 
2.54.0


