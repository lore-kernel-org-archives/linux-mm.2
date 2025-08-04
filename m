Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83D1C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0156B0092; Mon,  4 Aug 2025 08:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6984C6B0093; Mon,  4 Aug 2025 08:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE676B0095; Mon,  4 Aug 2025 08:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA316B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:14:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA558113FA6
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:20 +0000 (UTC)
X-FDA: 83738967480.07.D41FA1F
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf16.hostedemail.com (Postfix) with ESMTP id 10F7418000F
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=UqL2d18w;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf16.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754309659; a=rsa-sha256;
	cv=none;
	b=2A8aQiTR+1G6ZyP0lHWMpkVdrgLNsMs3uZwYF2Wlj9BgNm03bLkyR7MOPEbd/hgmPYuZ87
	7qo/l/lxcEZbM5Y4j30iz1f9C9Aa9oz9PE6/xWZJanNrjZ5GSB324vV+IBHIhk0nABa+KO
	GvqBfr3LOtl1Y/7kc0mj9nhIkHKpEho=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=UqL2d18w;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf16.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754309659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wg6vfvVQRpqn/feIP7hePbKRJwLF2oar9zj0xHqTXhU=;
	b=ME8YXRQTIG9141U+c4umCW+Mk3lulOPzNK7M8D8TzlqmVisS0oPyKfLoBgMNzojCK5/Zf4
	P+H+K/aDYV7SSLRy118+kKOphFWAlc0JWSA8RgDvYo4Pr0te40pOkXQtfq3H0EN4Q+uNRw
	vvz/mH9+2dzbYlJCqzOAfUtnMXBxul0=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4bwb871KgPz9st4;
	Mon,  4 Aug 2025 14:14:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754309655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wg6vfvVQRpqn/feIP7hePbKRJwLF2oar9zj0xHqTXhU=;
	b=UqL2d18wzvHrh7tJVeJYCXjGyxAtaFcs6MKVFbkeIkqEflCP4Dx6giEliPtbcnbWHyZDu7
	P51MPKLvSqf93s2tp3y0kyjk/cFhINFXyu/CixWPgy8iugkpGbQT0MzLmFQ7SdKMIM9iW/
	VdsYUqnPg/wxAYnDxCZlRu3iBvWowKQCoZgoUBDPxUwVHsT7x3EVmgjuhFl7Liv2ggwTUm
	I9TzT4YlcLDNf0AKGYKYedOlMnS6sLOEbkRgwuGIIKUOmUNu5W7jvCSvmxd4Cw8x6NtjBJ
	tCYS6XbMdIrkmm4Kn2SgHagJ+ipJV0xdoB6ACPdJnwr43ZnClFuU72io38LD1A==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 1/5] mm: rename huge_zero_page to huge_zero_folio
Date: Mon,  4 Aug 2025 14:13:52 +0200
Message-ID: <20250804121356.572917-2-kernel@pankajraghav.com>
In-Reply-To: <20250804121356.572917-1-kernel@pankajraghav.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nbq8xx3j1wz6ax8e6sceywesuwei71fb
X-Rspam-User: 
X-Rspamd-Queue-Id: 10F7418000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1754309658-271678
X-HE-Meta: U2FsdGVkX1/NAR623zlzPz5RxfW4Sg8BvYVqtL6FRx6rNqHS+homNPH6ERQGhEd21lXfnj3yai4iajj0ylcrywbXNWdB0syebH1RIaWjfkwf4yU6ixNu6Ve4pu8YGb5QQnSU+Vy4l9SbsflUM6OsRzj+Iyv6xS8EQ1R2MB72AcDQx4MLHnjF0q/EMyu42obht5kwHsbH+UqiZ4E8OEDNzAir/PelTywII4AvoeEBeuytAVrOFWMsL5qMkB+XVLq404bGaS7WgWpmCM+BirIJYx/faMaZRCXusOQPPSBMKfid/xsIiAgcnfZ0oRZ2PFsj3DLW5+AF+HIwNAlFnL8VQOjLnw0KgXANuc7AIhfJyJpVPFBxWsjFLoL1YO2cpWw6ojBdoKw5INPePZe0/iYetbyYlvq+NGxXyoK39J4YCb75HusKBLsmiQBJyEG67ZRlluTgDy1Bb8wbhm8E8LRg1v+amvgDpRPTegEAvazowYa8xygWQtCOaB6ddVVNwCjLvGnotjiSoohqUuW4hZTbuShVuDvdlOcrmaOUvhQ8T28OIXxYuZ1FYiwAifFYw8nmN9c9YJAiU1FpKQCQfslnfDUq1VV1cMx/9IbGVIDyAoav5kIQL820s1XOx2wBYZcUD0VKPjjSR4SMvjjZx0LvPFf3FE15DFBG4w8FF13q1UDbPNGntqJagPHRLhyoRxopW7RICg18ps2CDNtivOlAwt8gwslYxNmS+0FmUZpGS7iMgi0h0lqj4ZXK+dFhdhZqd1SGEPTpeXc8sQRIrRNBVjC4N1gZy6dsrHizqqPwpoxn/NK/Fj13k0SQ8hutNI1k3+zhYQ2CHM53Txl/WVqvke9Jo3GyTCjlu52KuEpJf4CA16DgP92lCtnoeL/ZJqLu4q39th4l3DnjEOvKGDC/3I7h8LwrTNjBY2BvtfsEnYXCAVsFnFU8zVvwcEdBTtMpVEadGA/Oj4AnhaL4iz6
 pSel2d9d
 QH2xq5/tNkozNviGV6DrAgEBpJ5V59An0L+ZaENp7RFp93Rq56QvKoZ6SGflLqmoeZ/HPcuiUOG3QZRyPkYrmfFeuKdD910BUU2tXWrKlSZqqWZSnLJa93e08jXTivbEuTRpzGUaUO3fW2Ahfq2P+6WNjM4MUTfxgmTLi59Z6sRbxb9zLFBUG+a5GkAHnUOvJ1bs5KPahIdVGXEWcFLoDRrWM0ARDW0WF+EQ81oGH5Vc7lXGgFNLnsMEqVXi7aVNRvWIzPFTnDq4AxEq0Pf9zzWTe4fXqjYNO1n65ktZt7ywegcfskcV6xll2YElhPc/69sP7AWYDGzBEAvX8+gx8VUslIzpSYHRp5h0TK0re0sJ5DK0ffPIgBKmFGaLtt6GjmBwgJG+GZE3WoIiYM+GQSwM9cKJMuI0Wbzz4A1Foc0UPQ0bS5Ii/73VGXkNzcOVVtY+54hIAg8BRHcV5ffyO/6nNFk5qfflSfRJH1MaqwqfDpyVwL/OxicjZ/Y9iEfn3Ty7JbsSUq63JfXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

As we already moved from exposing huge_zero_page to huge_zero_folio,
change the name of the shrinker and the other helper function to reflect
that.

No functional changes.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 mm/huge_memory.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d..6625514f622b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -207,7 +207,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	return orders;
 }
 
-static bool get_huge_zero_page(void)
+static bool get_huge_zero_folio(void)
 {
 	struct folio *zero_folio;
 retry:
@@ -237,7 +237,7 @@ static bool get_huge_zero_page(void)
 	return true;
 }
 
-static void put_huge_zero_page(void)
+static void put_huge_zero_folio(void)
 {
 	/*
 	 * Counter should never go to zero here. Only shrinker can put
@@ -251,11 +251,11 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
 		return READ_ONCE(huge_zero_folio);
 
-	if (!get_huge_zero_page())
+	if (!get_huge_zero_folio())
 		return NULL;
 
 	if (test_and_set_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
-		put_huge_zero_page();
+		put_huge_zero_folio();
 
 	return READ_ONCE(huge_zero_folio);
 }
@@ -263,18 +263,18 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
-		put_huge_zero_page();
+		put_huge_zero_folio();
 }
 
-static unsigned long shrink_huge_zero_page_count(struct shrinker *shrink,
-					struct shrink_control *sc)
+static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
+						  struct shrink_control *sc)
 {
 	/* we can free zero page only if last reference remains */
 	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
 }
 
-static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
-				       struct shrink_control *sc)
+static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
+						 struct shrink_control *sc)
 {
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
@@ -287,7 +287,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	return 0;
 }
 
-static struct shrinker *huge_zero_page_shrinker;
+static struct shrinker *huge_zero_folio_shrinker;
 
 #ifdef CONFIG_SYSFS
 static ssize_t enabled_show(struct kobject *kobj,
@@ -849,8 +849,8 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 
 static int __init thp_shrinker_init(void)
 {
-	huge_zero_page_shrinker = shrinker_alloc(0, "thp-zero");
-	if (!huge_zero_page_shrinker)
+	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
+	if (!huge_zero_folio_shrinker)
 		return -ENOMEM;
 
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
@@ -858,13 +858,13 @@ static int __init thp_shrinker_init(void)
 						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker) {
-		shrinker_free(huge_zero_page_shrinker);
+		shrinker_free(huge_zero_folio_shrinker);
 		return -ENOMEM;
 	}
 
-	huge_zero_page_shrinker->count_objects = shrink_huge_zero_page_count;
-	huge_zero_page_shrinker->scan_objects = shrink_huge_zero_page_scan;
-	shrinker_register(huge_zero_page_shrinker);
+	huge_zero_folio_shrinker->count_objects = shrink_huge_zero_folio_count;
+	huge_zero_folio_shrinker->scan_objects = shrink_huge_zero_folio_scan;
+	shrinker_register(huge_zero_folio_shrinker);
 
 	deferred_split_shrinker->count_objects = deferred_split_count;
 	deferred_split_shrinker->scan_objects = deferred_split_scan;
@@ -875,7 +875,7 @@ static int __init thp_shrinker_init(void)
 
 static void __init thp_shrinker_exit(void)
 {
-	shrinker_free(huge_zero_page_shrinker);
+	shrinker_free(huge_zero_folio_shrinker);
 	shrinker_free(deferred_split_shrinker);
 }
 
-- 
2.49.0


