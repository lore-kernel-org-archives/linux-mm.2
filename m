Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273A9CF6487
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 22:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84ACB6B0005; Wed, 19 Nov 2025 17:42:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4876B0010; Wed, 19 Nov 2025 17:42:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EAFD6B00AD; Wed, 19 Nov 2025 17:42:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1466B0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:42:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 198A2895F1
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:42:59 +0000 (UTC)
X-FDA: 84128833278.08.99A6E6E
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4781B100004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:42:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b=2MSEAwWs;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux_spam@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight.linux_spam@runbox.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763592177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+Rdz9XE+xMk74y5kxcFhHgKXAV3hOzijtaYCtjqLa8=;
	b=yKkAsMSWTxIdLhDuu9zM/omK4Z/4SxgdhbFgfqCyGcRFuYNJESXaIGcjsgzOe8aC41vfcE
	YP7ii9rH8l3CXfup8/ap/I3/gcvZa/7XBXXDB3hDRKlIfJNYlrVx8nP54v3fGcZNHIX+HD
	1svqN/Ie22WR5ojydlkd9niOnbDtfkY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b=2MSEAwWs;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux_spam@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight.linux_spam@runbox.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763592177; a=rsa-sha256;
	cv=none;
	b=MZ4WseJIal1zZdO9tg+UC989ojey4TvXdg/72h9i/Qn1FRp7UlXsXNomnbTIF2ZxZJlKrk
	LSeyGYQU9CH3dgY5R7RC76ggH/9HjHqCwqRZ0sb4OgEl6NJllxFlJ0ExzYBBWFE2ZAZOZJ
	ZhnxxJCIbYLX26/PbGTDyABfJbenMak=
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqt5-006kz3-8R; Wed, 19 Nov 2025 23:42:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=o+Rdz9XE+xMk74y5kxcFhHgKXAV3hOzijtaYCtjqLa8=; b=2MSEAwWsRWnpmx2KozxLIc3TCp
	fQz+D+xxRjulKigGVoT2f8G/zFfb8Be2OpUl4PIgJjI2gG4p1DAgJabwb2ZJYDjx9uvyuWwAazeuC
	TihdwSi9vFZrMsO5atbzEaAVyo++vo4dyC+FxBToKwAafGMwgpD8StbcMCD5qv1sto7K0bPYYROdR
	2F3iF2wuR3QoPzWzzQh1YEu7Qhbj1+Ce44VCYVWJYvNycekAymvoTihGlp0lsBlG4c4iGH6GYZ9Bs
	fLqCcLMvnOd64VC0SWpdJIgzKyUa7C32ql6Chy6o06dF+6r0HL3jzWp9bqt/T92uQXcSwilM5CYbJ
	oX5wb5dw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqt4-0000EV-IL; Wed, 19 Nov 2025 23:42:54 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsn-00Fos6-8l; Wed, 19 Nov 2025 23:42:37 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@redhat.com>,
	Dennis Zhou <dennis@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 39/44] mm: use min() instead of min_t()
Date: Wed, 19 Nov 2025 22:41:35 +0000
Message-Id: <20251119224140.8616-40-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4781B100004
X-Stat-Signature: a1fn5gg9am4y1qy8fw5jzykmkjg6mzke
X-Rspam-User: 
X-HE-Tag: 1763592177-199156
X-HE-Meta: U2FsdGVkX18UuUYaGAWK3MIuc0CGILyPmn8C51nxayS5wnngYiAY+3CW7/j+X5z66QEr9W2gluBy71SF/3onyAZVRgPq8Kk2ZB9dp8gY6aOfnYwidGiRjlGzhrKCyxdozbXggQUx6KNmLY86+zyx9jYwXjV7y8ISkaUX4vaxUBpXHO04keY9v/JC1vWeuXC+V3BUyhjj6UNUjNwl9ik/eO+km0TdT1Cm8JvTr64S0zofGFmtEzYbzOekJMiBR0VppY/HXrdzVqJw47fQLuOml7BCJY/JJqS0UubAnyakQn/V2s8v33E64tarTXhiMtBFezKoOnCSyVrt+4wCJ8Jh2aOetDhQOalajrtLS7Y3yYh0RNJ3oD7I+GiiifUttpInwaW/i2a8ib0pVpVI1bIkLt2h2XtD2tjNCnuvaxtyWc5mgib5K6N9THooMbNnJbbXR5mVrs9ZltKaNaQO86EfcedTsX/zG7FBZWhE0kIUsMf91xWGwnVtxzFivdXOmCwXUnYXHaCdlsDdjn6gQj2iCPF5NhLQk0l5Zx7VXBTq3dLB1eexXX7s7I7+zxk26zV1ndiiajWQCGbQi6S/cPo+RM5QkAesbMhZn6n7/ELYdOtOnk5xB/iLxjVcAkctWVgDyKEbvLYxgLQsa1l8ZIFY5HJXNJfbS2DIZX7GY10T4DTaq9aB2KyAXwAy4jd/x1LfSXqOmOYWsH/Hx2JAbJ8KmuHnPTAxQolqjjf+v2IxwGQGWOzVUw/jBuy6dm+e4WYtRY00AiYNzRubQiYkhQN2tudjkgSiixU6lqu9y20frIWxj9qrzrG0nASP3mxabjGAgQxPaHXPddgE5cMIG1yHmaoUUf7dX7WsIz5QAXbGaveJsHjvlGFzWJuGqVEfFIlzKFxzThl07x9rfJlFaQJl+H01Rlnif7AIE932cM4cjolhOJrjiGO07g5S4A8PRn7bBrvIfzEkVxaMXD4bTpR
 koNxSibC
 ElHmSj8C3JQFQPOw+7zJP46rtmFFEBnm109nVPzJIzPEp7mXDzfZIXTNdpFr4B3Xt5XkJnXLirNJlIHmoElIALiQFpdHpNoxIi0Kb3rvPhfexCPvyFdP5xUY78gL1wbIVtZ/mCs3+ivrJrNXxZS913zsz6ia+k8RyULsN3CQv5Z7KdhWA0b3lPkJ4dqzdjcrWBYgD6YgnCjNdewVwBLs7LdT28tS312JDW1rVjEfP7xVkr0DNuc5alsKJ9N7OaahPoa2eG8HKFmZMXPCnTgIDrtcprJ5lT51qA8V/yKTD3eMgeu6gF8uNxsHrfk0QQXCiL9qA0EHnN9Bnl+t8WGjiHq5O2mVNbFOU3qzesNJk/2MHHGhVP1esAn3hx0SnrhDCF0YPLWOAarioDsAtueA/BPVjOoLYS+8dUP0jCPWkVCa8dAlBXu/nQFrT785VrQOgT/L+tzpFAHdUT1lPAzMpuIxBAGxa1hqISqlUT05HCpnaR+EKED1jpyCRrqxJ58b6KOaj0TCetTYKNc3xCM7Yq+BRmOLCLGjMvc71zeq9BoYgEqA/jXr0Cjd/fYNM14AgcVF1vzCxHwH4y/6yL4yJrMGCzFKLR0NQ3HTFxmE0846O05JkHCaJ3mXJyAbrcoQ9Kj2Qba2AfoiJG9Wcto9b4emFzM2QxdlUXBatbQjhceAyRhnkUsjvDybSBfZUqme/XsPd+6QXdIleCT8In3J10VKDtXPhoSRHDfra9pOpGckYuD1VJjX2MQLQtPS4/BvtJtwI0sb54CwDCcy63mSXU9Yn/gsxG0HmHN7AOTKEz5npitk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <david.laight.linux@gmail.com>

min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
and so cannot discard significant bits.

In this case the 'unsigned long' values are small enough that the result
is ok.

(Similarly for clamp_t().)

Detected by an extra check added to min_t().

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 mm/gup.c      | 4 ++--
 mm/memblock.c | 2 +-
 mm/memory.c   | 2 +-
 mm/percpu.c   | 2 +-
 mm/truncate.c | 3 +--
 mm/vmscan.c   | 2 +-
 6 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index a8ba5112e4d0..55435b90dcc3 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -237,8 +237,8 @@ static inline struct folio *gup_folio_range_next(struct page *start,
 	unsigned int nr = 1;
 
 	if (folio_test_large(folio))
-		nr = min_t(unsigned int, npages - i,
-			   folio_nr_pages(folio) - folio_page_idx(folio, next));
+		nr = min(npages - i,
+			 folio_nr_pages(folio) - folio_page_idx(folio, next));
 
 	*ntails = nr;
 	return folio;
diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b..19b491d39002 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2208,7 +2208,7 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 		 * the case.
 		 */
 		if (start)
-			order = min_t(int, MAX_PAGE_ORDER, __ffs(start));
+			order = min(MAX_PAGE_ORDER, __ffs(start));
 		else
 			order = MAX_PAGE_ORDER;
 
diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..72f7bd71d65f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2375,7 +2375,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 
 	while (pages_to_write_in_pmd) {
 		int pte_idx = 0;
-		const int batch_size = min_t(int, pages_to_write_in_pmd, 8);
+		const int batch_size = min(pages_to_write_in_pmd, 8);
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
 		if (!start_pte) {
diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..cad59221d298 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1228,7 +1228,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
 	/*
 	 * Search to find a fit.
 	 */
-	end = min_t(int, start + alloc_bits + PCPU_BITMAP_BLOCK_BITS,
+	end = umin(start + alloc_bits + PCPU_BITMAP_BLOCK_BITS,
 		    pcpu_chunk_map_bits(chunk));
 	bit_off = pcpu_find_zero_area(chunk->alloc_map, end, start, alloc_bits,
 				      align_mask, &area_off, &area_bits);
diff --git a/mm/truncate.c b/mm/truncate.c
index 91eb92a5ce4f..7a56372d39a3 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -849,8 +849,7 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 		unsigned int offset, end;
 
 		offset = from - folio_pos(folio);
-		end = min_t(unsigned int, to - folio_pos(folio),
-			    folio_size(folio));
+		end = umin(to - folio_pos(folio), folio_size(folio));
 		folio_zero_segment(folio, offset, end);
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..82cd99a5d843 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3489,7 +3489,7 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 
 static bool suitable_to_scan(int total, int young)
 {
-	int n = clamp_t(int, cache_line_size() / sizeof(pte_t), 2, 8);
+	int n = clamp(cache_line_size() / sizeof(pte_t), 2, 8);
 
 	/* suitable if the average number of young PTEs per cacheline is >=1 */
 	return young * n >= total;
-- 
2.39.5


