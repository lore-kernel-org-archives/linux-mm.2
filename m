Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DA3606A334
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 06:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Kt7WslS/
Received: by kanga.kvack.org (Postfix)
	id 16FEE6B00EF; Sun, 22 Nov 2026 01:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1208F6B05B0; Sun, 22 Nov 2026 01:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D086B05B1; Sun, 22 Nov 2026 01:55:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6CB26B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:55:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AA7640660
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 06:55:46 +0000 (UTC)
X-FDA: 85461844692.24.E1C5D24
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2ED1A100003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 06:55:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Kt7WslS/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795330544;
	b=FgpaEn/Qz6+9wH2HiyS5pAz5oSWqMLyL8jeIVAXwitmXglmzj3v4a0rssn2j0qWY41+bd1
	C3RxkxRb5qbixTG0SXapP43Ddec1kL19CX6kNXcW0cEgltRMA6sI9BL3wI2kwS/yjr5fOP
	zPdXKWq9nNNWzL9TAzG/mBYCvpn/XXw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795330544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Wmi8+gU9wSz5TRuIdE6ondwceW9JjgoynshcbqtVNQs=;
	b=faUM+Tb+ji0ispE13VLYtERMVLwiHsZ5RvjZ1RrfVx8zLDCkzU3564MVxTh+vUxugvUzDv
	yuhBvvpD5iaFq+cBfjiwIGIHzY7GENKioRNqUfICIOwYt3F3zxAO5IulOluhWHTXggYDmw
	DyGBssIbODkyGqYMGwjqEyU/LF30ENE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Kt7WslS/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QDLkr1W5J3m1NZAazgRrXp2vVl+LPZJtkzX6HsnTQ1o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795330542; v=1; x=1795935342;
 b=Kt7WslS/zzIEtHnb4aXVS7SRvSMWnRU+/DtpabAg3+h9bdLeBbDKm5NsyD/TlSGBiE/fed3N
 ObloLFDDCNdNuC8aewQWBsf8v5LX6Ra/sCqajLusgtgLDvwVq0XI1bC6I6+5hOg1EIkaQddtAko
 lCJslW3ZM5Kz0r7QyPvKyCRw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eab61d17154b09f0;
	Sun, 22 Nov 2026 06:55:35 +0000
X-Mizu-Trace-ID: eab61d17154b09f0
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
Subject: [PATCH v2] mm: hugetlb: allocate larger early CMA pages first
Date: Sun, 22 Nov 2026 14:55:26 +0800
Message-ID: <20261122065527.33123-1-qi.zheng@linux.dev>
X-Mailer: git-send-email 2.48.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2ED1A100003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ba11sw8zyp5s3x4hyhextek34sfpy4nm
X-Rspam-User:
X-HE-Tag: 1795330543-95519
X-HE-Meta: U2FsdGVkX19PALmEMQK9mGoPDK6PMGtTTT28RlCGRhjmPe0Z2fRCycTTaphEttdR63LO107fKjjMj29W6Rxv+ZmFZSZOyRjkoFrzhbe/jcbmRpNrZ3o/1BFWU3YzufVM9WlLx7GZUm5cAiRjYUBdYDwAl2/wehCy39MmT4r0HN+opl3XjSKoYCdYmOhB9Rqk0DF1vcXmEzLWLloX7tauTHxjs5+w8zs62DSrm/0eUymCHaPixtfWsqBYDsHG/S4awMESSRpu4TaHxqeG4X4rFJYIPBxQPvl/MghWUsOxYbNGnapNRmi/7vvdaQizr/wyvRpYQ2xte2zsYzYFkupwYO/GqQ3+QXlzvW8RUOg6JrmiKD7HoDatoXPAIL7TU+6f3iJ32p8428hInbVBXAcvh9xwiSgZZXqhICt/EODJuP4DTvhjzhI85MLtMFylC3jl5dEtDzvOWadZ+Va7rk+9HkpiAT5efx6C3B3LjWy/JDvq0abbZw0ctKd0C0hF2+dbgvhlSspsjAo4dXkQ6vfJUhBsddRwEnBB6obZ6uAql0uTOMTYrfHX90pxmYrPMtjwRitb8KQ5o5DGGKAOJ8pMX/9hguTo74cHE+iLTkY97QJ5XqEaF92b1pbs/YgPPxNbgaONbr/vEHIS4x7JW/u0+KCm1w+RDRyWseGnZiLJHVnac1RA1PpRlEpjeWv8Co5Mg2tv/ts4mehWMA7xyMJxlSkO00r28TZykQ2bVONMtvAof/ew9JI0v7wIlP1wRwibGXTkM07Mth9/jFji6Bl+BF65GkWw86IRz40TAk2czJXCWKY+UVUOLTIl6/EU0oXiAssHcdmXSkvfvMqKgIefQ3WWDIemHd6hrpSwCZTRuIB4wKjDaQtr9sMjR2BG8w5rWhLy6w/I+6050Sx36oCMaN9nNsSdJA08ehzAKMkpFV+Is20Mxbo2e7/lu+RhCxhJ8MKarRK3YyrQPgnBmyG
 82iGMhmI
 otBCbyVaoxXlC37gzFhpRSUDikc++x3M9AxB9JfVWkdyd3hhH/L1sEn3AafezzGIQEOcHFDjKMzcDUVF8IoOd2t33V/a5N71Z5kULx/VJRIWIxdW4lRslvcSHs2khZs5w+lzcOAHQxsdxe2pUJYrbC1J/kcOtInkIfk8hgKs/tTX8Rlb9k9mAGQPYbn3T+nGctQt6HVj8FiGtKvHJ0rE65SHsnd+y976Wvannj+x0jl3yd9diZZNa60au5TBmL+LB0vOX4Khb8cyYihC35kdjeheK2sgCIL8EarFgoFC6ias4yicr1Iw17GgiLLLrKE5x/FoGYsgUyCfAQsk3JqPz32hMmMADjs40nmiZLY6gdRxPjXpbAOuMsDBxGmfhq8iLgQ9tLimv4Tp6Zc+W5zQPw1UnJUw8+kqX1Ga5tqk/hc+6PsRuUd64P4V3s5txOf9cTz6HA6jwU2SnoM7I/RIUi/c3CKuP1Fkj1nQJa4Bli/+oEWs=
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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
---
 mm/hugetlb.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a448c5909d36..96b97f012ab49 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4600,8 +4600,25 @@ void __init hugetlb_bootmem_set_nodes(void)
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
+	unsigned int order;
 	struct hstate *h;
 	int i;
 
@@ -4615,9 +4632,19 @@ void __init hugetlb_bootmem_alloc(void)
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
+	order = MAX_FOLIO_ORDER + 1;
+	while ((h = hugetlb_next_early_cma_hstate(order))) {
+		hugetlb_hstate_alloc_pages(h);
+		order = huge_page_order(h);
+	}
 }
 
 /*
-- 
2.54.0


