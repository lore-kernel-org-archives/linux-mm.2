Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F63CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED59E6B00C0; Fri,  2 Oct 2026 05:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FA06B00C1; Fri,  2 Oct 2026 05:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27B16B00C2; Fri,  2 Oct 2026 05:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD0E06B00C0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42F69806CF
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:23 +0000 (UTC)
X-FDA: 85277233566.21.3A8D864
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4B66DC0004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GaD7IpxX;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xfYsKXImFywF+uuxwdUPaYqHk2l3dpxfVyDtEltpU0=;
	b=dj7ZeR6zF3RhBmBpFlxoJlHkxP1al73SFJqXycLnO26E+4vbem6Yai7O5yoRUq5cwuY06x
	O6PWmP9+Z56TahtPvV70yPnjUQAFunmLkdayCDmDwLxNKvwLCoruyjfhGzo5YyLmcPzHQL
	DZdMpkBlKf05HmCrPBw5M1wayMgeS2M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935041;
	b=SR/ODlx+rjGpwQk5A7R/KNupdyZrzCR9s4ssOvndF52uTU9b4A3mXy9Q6Hx0HHuUS/3S4/
	Ug+7+K4RA+vsYsWIyrBXU1Rpxy4MidQcKIaRjNmT7BdPUtLc62fVrg7BHIseQTDVoD+p2j
	odIcyJGasvZN4WfCsYuD4jxrms8N2ME=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GaD7IpxX;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=w0gztRkUfUOE/+G3kO+FMjzHwEfBAB20UzLM0QrOt9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935040; v=1; x=1791539840;
 b=GaD7IpxXO6CM35PABCzhX2+LSFy/bQkY5xuuSW+0iIu3e9aJ4Tqz3X2BQde/PIJ+VaLyMmCn
 wgjwLykiwW7VFqjP1QSQ5r2uD2eKbYTEda3u3qBq3/djH5KE5ew9X1zhTMF6ghjbRstLUVDR75D
 beWR0HeEkh3ZVicmQmNo//4g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6a7be061ef33c288;
	Fri, 02 Oct 2026 09:57:19 +0000
X-Mizu-Trace-ID: 6a7be061ef33c288
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 23/30] mm/mincore: report PMD swap-cache residency
Date: Fri,  2 Oct 2026 02:52:37 -0700
Message-ID: <20261002095503.3585565-24-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 13ptnrqwu1gkkju6it7s946qbdiq6h1j
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B66DC0004
X-HE-Tag: 1790935041-639215
X-HE-Meta: U2FsdGVkX18R6joqA4ATJYzetwDmWG7CCO3WJ+8jdfbp48B2hNUpfbvRWgPddDQ7DyqKfmpfTtdbukvAsuFJD7IkD1EktXyCpAu3EfUC/gl8Q8Dy6tWY5Xl0iGEaOK6OGWoZyFNkPG/6e2jMjI2Riq3Ce0BPPiVCPfa1gKPoVJAUTug+iAhumAtbctWYDbQpo3xruFdxXl/snMOhatoRaK3+zMgvJ+tYqk/rK1IWYD9lJ7nmLLWkP0BiVvlr1REo8E8OAQpLmVPOAx+M6PCb71J0SL4+mh/QVcUd1ERCAwqkzvuX5HR1DsXC1Z7J5Ktk0BiqlhNyYXi3mh/yKXF32po7T+G6f9If8gb2mBr2CcajnAUZIWakHE5qnNfPMBbaQ7i5n84x1F215lhiDNdy4Hporn8O8RL/L33UD2cMsDQrnR2sNYoplMAd3jOGe0cvJBNzXfnwXcCgXKJAMKFZrbJ0LTQjzX4Cq6FSitF64Z0akVHg2GLSlVa9uEXvmEnJac3cogUcj8M/O1Zsm5dVWp7YICW/urJhu1GOBcwcGw7gfTngOkoy5pMKtwdXBR5o3zHQiN++Zy1hCSvTp8iqPovL5ScnJljllUUzVjvzIRmc3VoBpZGzAY1gF6jYdB3PPV9c8mPN/DAb+Gm0ApFzX2+4Ku0OHaQxWiiG+TeSP6sNslurDQ27gid9QfwldCc9fAWLwpMk9J3RXJZs+eLWBxa7W06UvhH8ZRSZbsqffWr8JjfVhJJw6vSLPjlLCHepYukGKQdTojjjS8irTH12F0hzkQQEPN8U7brpVxHjFQo7u4H279RjE9rBC7YCBgRlk/awfVAqn1y5vunpiYgdAivGDoCK1xVrO7vOzrxhUeDbyU9lb9MhvXTP9X6orkJLncSuEGePUBLZGahBMdZhFpul5Dr6T2SsmV56MMjCsdmeyiPKG19w7PNEtZZ+8hdwifG9Cd+ScduObez1HOw
 5QQcQuqo
 Via9LLd4LvkvnHhwuHbs6tsbd8KSZUsHI0f672tzUPs9c/HYzJSF7G1fGDLig7E+iA4LszpcFLkISdWFy//cBTIRqDEzVsjEtf2paWzuOWRcNfkMZbfkazzRJvqBxfJ8H0quTLnEFgnRRgN0qKHHB416EHhHd4JfbLwixxq2S/OdGYLr2r4DOB7RpCkpXnfwXp+Fd4GdTUHANPKecb0x4W0Cq7vxv4U1kraeh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mincore_pte_range() reports every page under a huge PMD as resident. That
is wrong for a swapped-out one: mincore() would tell userspace that memory
it will have to fault in is already in core.

A PMD swap entry is only a compact encoding for HPAGE_PMD_NR slots, so
answer from the swap cache instead. One PMD-sized folio covering the range
makes every page resident exactly when that folio is uptodate; an empty
cache makes none of them; and if the folio was split while the entry stayed
in place, fall back to looking up each covered slot as mincore_swap() does
for a PTE swap entry.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mincore.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index c086836bc4bcc..1846c6f68ae63 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -85,6 +85,48 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	return present;
 }
 
+#ifdef CONFIG_THP_SWAP
+static void mincore_pmd_swap(swp_entry_t entry, unsigned long addr,
+			     unsigned long end, unsigned char *vec)
+{
+	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	unsigned long start = (addr - haddr) >> PAGE_SHIFT;
+	unsigned long nr = (end - addr) >> PAGE_SHIFT;
+	struct folio *folio;
+	enum swap_pmd_cache state;
+	int i;
+
+	state = swap_pmd_cache_lookup(entry, &folio);
+	if (state == SWAP_PMD_CACHE_HUGE) {
+		memset(vec, folio_test_uptodate(folio), nr);
+		folio_put(folio);
+		return;
+	}
+
+	if (state == SWAP_PMD_CACHE_EMPTY) {
+		memset(vec, 0, nr);
+		return;
+	}
+
+	/*
+	 * The PMD swap entry is only a compact encoding for consecutive swap
+	 * slots. If the PMD-sized swapcache folio was split, report residency
+	 * from the individual slots covered by this mincore() range.
+	 */
+	for (i = 0; i < nr; i++)
+		vec[i] = mincore_swap(swp_entry(swp_type(entry),
+						swp_offset(entry) + start + i),
+				      false);
+}
+#else	/* !CONFIG_THP_SWAP */
+static void mincore_pmd_swap(swp_entry_t entry, unsigned long addr,
+			     unsigned long end, unsigned char *vec)
+{
+	/* Nothing produces PMD swap entries without CONFIG_THP_SWAP. */
+	memset(vec, 0, (end - addr) >> PAGE_SHIFT);
+}
+#endif	/* CONFIG_THP_SWAP */
+
 /*
  * Later we can get more picky about what "in core" means precisely.
  * For now, simply check to see if the page is in the page cache,
@@ -171,7 +213,10 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		memset(vec, 1, nr);
+		if (pmd_is_swap_entry(*pmd))
+			mincore_pmd_swap(softleaf_from_pmd(*pmd), addr, end, vec);
+		else
+			memset(vec, 1, nr);
 		spin_unlock(ptl);
 		goto out;
 	}
-- 
2.53.0-Meta


