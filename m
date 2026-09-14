Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E27C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4A56B00B9; Mon, 14 Sep 2026 08:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FB46B00B8; Mon, 14 Sep 2026 08:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FB86B00B9; Mon, 14 Sep 2026 08:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46DEC6B00B7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6131C03E1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:03 +0000 (UTC)
X-FDA: 85212304926.01.754DA31
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	by imf03.hostedemail.com (Postfix) with ESMTP id C49432000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N9h+BqDN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xfYsKXImFywF+uuxwdUPaYqHk2l3dpxfVyDtEltpU0=;
	b=IxhGRHISm1RyxooiD+WQ/3mUr0iLs8RTyB841KDm5daE0MCi3Xm66+ES4Wqfd0315vToxr
	1kVQmQOE4hk6D2x3kVOdoelzEFf8/2vkGsEzSRD8Hs2FG37LqnRFej3cIL+fHkEcwkFBeT
	jvbrMi2R4mdWaG9QeyXAFGKidlb3ByI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389122;
	b=a+6jkuCsXyoHkAkLnsjSOLzBELs6vNgemoakGVwhue/69y5ZTkofeKEUiOW5kk8ZxUGDfC
	eo+GbCWFyncldm6PGacGiEZtRO3HAekubgIoD2kqwIs36VSkxN8YmHKh1dIBAABxIfo53w
	uJGNQBglxkbu4JmZYAnBqAP1OIQ7aUA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N9h+BqDN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=w0gztRkUfUOE/+G3kO+FMjzHwEfBAB20UzLM0QrOt9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389120; v=1; x=1789993920;
 b=N9h+BqDNu2H6KLMXdpMIXdLgPuFHyp95Bkge701twKjC4/Ib7B0+69PngqCU/zzAMUDuIkmE
 Foer+v+sMC0EmoxOhUWfpntEhbp8B+py4vPbufwTtv+ELhKFxV+OeLpTOEcaFNIpRTZbHjx1Axc
 4T7TZ4Qjboq10gF+2hNEvJDc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 95316f54d43a6e01;
	Mon, 14 Sep 2026 12:32:00 +0000
X-Mizu-Trace-ID: 95316f54d43a6e01
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
Subject: [RESEND v7 22/29] mm/mincore: report PMD swap-cache residency
Date: Mon, 14 Sep 2026 05:28:12 -0700
Message-ID: <20260914122950.3283997-23-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C49432000D
X-Stat-Signature: s9ew9xsisffqe8axhnbpkx76sc7egj34
X-HE-Tag: 1789389121-498706
X-HE-Meta: U2FsdGVkX18HZiH7ljQzVar1wljrSuwDSyyhoDjVNqNSE72QC8K8D2bcQyzPfewh0ZcRxihLUEzme5wnU+L4kGCswMhJxGFtunApxsim1YkA0ASeS85vyRnyDTCt0jbOXmtzbqCxUyPoGn35gzqG/r83RWA0E+F9oRo3mTlYPBPlbaEzc6YxMEf0c6s2ztpLn4fi5xMoU3Z6yTtD0HMs8SbA5iR1D8fveFiHLrEQs6IeT0mHKwdX8Tj/1dyJH2pOEY5irEYi+8SjBF5mFftZhjQdddcfo5G4Jw+XNMUxzDZ9rR8y3Lqy53UrQt276hM5QJu6fgo5OvtNk+5bhj7B3dZ//iNjHqfIWv1MV7u/WKUC0k+QsNeCNCfxPpPNmZkqS1iUiSVhYPxMcuvxcOHfT0ibWnjSo3wYCSRq49HQtANsh3om2KddBCaZf9SlnoUw8WXzUORmvekD68kB7VDw+sGeJX8yM+4VbpjdFsXo9NYZDzwaYi4O99qKM5HS3XbQD6mG4im0oFwO6U489bU1X3eny8GscvwQG/xCJNoqXimwqSjRHjACCW75c2LyTrCTGingNPU3rXTDYNMDD2o9F/hMW6btjvXL/3gTDo4LTZxrxP0iqdc0F9jAQMkETNaeaX17rIiV0WfZGTRKlCFEC1rCMSxxiIEVu90JufeF5mcoAnr/nigkMqbuhkC6us8OAiI2JWhd2Wv9dngxvBznpPEvPsVUS+5xIyI5HqiF/7C1d0Ta38NiHqaH0t7VEt2YLtA5vGKYJ2rLkEPDH+rTMeh46OriCaTpdx2IYfr/geRaR+XqJZeLcTRq0cNj+kWk5TwgGkXQ7utgjvGIfxAzEQijt02EM0S+qbc0V5WEZJYTG0CYLykqw3xYlsmx6fDOi7Rq7qB978eVWNOZhyUZS9fGz+ntYRA0FzyUg7A9Mikqih724dm29xpRV7HXM7vk3BxdUC5sRaXIXG+5Poc
 1IePEsiV
 eyQyCz2mZb0g1YJlFTpbWRVVi1x0RuXlGzT2BRltuScw2RQFK68WwhpbWIjtRVe521tr5KCmrZaRz6M1bypfx0X4TzpuKeFqxj6G9Bfi1hCXoRSyXKdGlS4RdFpnj/goWL5VTMqBaduoe9BqgAJa08REuwg5wp0kCFh93DjjY5AMAdQ6NKCX8kt/ebS+WlVnBKjiNXX9dvdKEFU4Peg9AnQbBLrpqFa+p5HNg
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


