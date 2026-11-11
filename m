Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A36606A882
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RVUpf2NS
Received: by kanga.kvack.org (Postfix)
	id 178806B05C3; Wed, 11 Nov 2026 06:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DAB96B05C4; Wed, 11 Nov 2026 06:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD2B6B05C5; Wed, 11 Nov 2026 06:35:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEA406B05C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:35:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49A5B12027F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:35:51 +0000 (UTC)
X-FDA: 85422633702.24.7A38F23
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6D70240005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:35:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RVUpf2NS;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giKqYnWzubQikXm12jGK16pXQcb6NbBHXFTnepSWaq8=;
	b=gEJJ05nSdKUoz/pVxAFFLcnUuHT2EjvdYozjdAYdSpwf4qCT4irHjDVF+nBd3tnCPTxmPw
	AP75rZyOuWluqVtTOL2XZkLkilPFQmOYow4KkkI4w2mOSosp1CXEmKaWkGDMLZFETnHTz2
	x3kOMv2N2fV2ZdviWes3BLCvf6H1Dkc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396949;
	b=0yZSMdv6/ThVHhysUY1vpVHFE9LFGeOv6OQxpU78krJ4WdDU6Mqmob89iJBJlXu9YXbM+T
	LN/UyGz05Tum8t9BzWJ0TQdsBgjZ+2/U9XdHWLz3eegoDcrRbVJxTd6y1Ab9B7hEsPovgJ
	aFgsUjDEaoX/kwbuw6UzWiC1IObaFGk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RVUpf2NS;
	spf=pass (imf07.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48dee593f18so2286337f8f.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794396948; x=1795001748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=giKqYnWzubQikXm12jGK16pXQcb6NbBHXFTnepSWaq8=;
        b=RVUpf2NSUhvkLydbbhWKMS5htifRyDuusRUYRtwhGz0s8CBVX5RDk0loGw2ldCkFVZ
         pzFz6f/BOr0xPaD9lrZlsr+OiCLalnxoA6xNcxQ+sVodxrvkgvFaTK+nqkq5EDKlmpHA
         uetOvq8HEATEnQAX66mF+jDKPdc0T2tT8bd1W1QzONVc9SVSQ3n92FdxG/G6appflYe8
         D2SB4/kRCEAe/+KmjHbVvLmq50TRv+n1xUw0RxEvkCHYaXHtFnb2fZIQiirhpeZOWbOI
         regP/JFzFPGVlCkyFdpYfSYV1Vc0VBBJWU7SNnkrShDLvNjXI4dl5Bwe2xobfeGMZOuX
         OQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794396948; x=1795001748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=giKqYnWzubQikXm12jGK16pXQcb6NbBHXFTnepSWaq8=;
        b=TLxkOsurbrRpxkZZyLSn74ABCRkKMPffmsktvD2ga0X9IcFft8K7+0PdA88gmP47Zg
         iVYC4XCuFKdIohiRDhk7/lwch/A8pLj4SyFjyqqWmDaMMFVqlHcLqJkGpVoHGJ6FA+qO
         h7YZe/6yP6Fv2qxlHPjKdlWIg9AW71P1cGlDEGDzz8BEfjiqKP9VqcQD1kHSj1BjikTT
         xYb+r9bV9T4dwVDQoG7yPP6S20ZEpRjjozUWjKlpolNerpkfqvlh1sSXv2vCj938dMIu
         /63jIBwqDqFpT02eXR597+G54bBebJVEoSA118a659ao9pjXbXRqlObmFiwOIHY+LpzS
         hftg==
X-Forwarded-Encrypted: i=1; AL+hErH7qQhBT3/9BlwfKgv61QopaWW9JxAJf8Qgpx+GMyCaxFM/d8hUjziab9urvHTjg1tB5RGkkA1Eyw==@kvack.org
X-Gm-Message-State: APuU4Z9LnbC+HwzpHxZ2FZfdxOs5+ArUwqv/QnSMnAnzE+qgYg2gTEM4
	c9WR9jap+XMjkRl/jsDYEGxdWmFz7QZoBZSd668/BAzLufURr7Yv0wbF
X-Gm-Gg: AYBFou2pguNvPT5czNPW8jjsOY3vFaFb4yXxRRpiRkvKBXEfm/j4mhjlD2BoXGbbLT2
	LxNmq3HVJPYYG9A3wziMmUjqA3KTqQqUfswST0685G+eEjuN6qwYKdvMG4UQitxWFY7xP44XAO5
	sdbTfBYOvBmkLENOcGhyIHC+lsyoGu0fPAV0XY6xf7LFNK0RQ8mS7yi6g+TkqLawARJf79qWhOY
	11Acq/lwPY5wPlAPfY1PaEkcHXH4Z7+GvFSAZ72/Bvq6NF1Ek7ZysyGVS8UU4s4Wk8P47o0AYK0
	pqQnAcjejrJWwVQh1CCtgJxaaRWzSW22aDGnwAlitYLg30QBiZnAkBBSua0Ock2PPG0SOLNGKCH
	PrEi3GdThXpSsZU+14Wr16EIZ70J63Ctm+VMxtSI6PKvbJXj7NNDCGOe6SVc18UnnOhaOPX8Tom
	zA1sPfj23u8+RdaNVpuadMFLWllxv2gPCWuwAjDZAN4Wl8cc6Myollzqxh/Swi58o8hgACibzAs
	SXQ871Ex95XTycOuxP1o2vgNBhFJNqXyscm1tFlxugwDkHgwgFLnSfQR7Fi/+jlopko8pB61yHk
	xRxZMQIn/M9y8w==
X-Received: by 2002:a05:6000:98e:b0:48d:f14a:9182 with SMTP id ffacd0b85a97d-499c898262cmr2615193f8f.20.1794396947836;
        Wed, 11 Nov 2026 03:35:47 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498365cbbe5sm11598683f8f.42.2026.11.11.03.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:35:47 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [RFC PATCH 2/2] mm/huge_memory: detect partially mapped shared folios without per-page mapcounts
Date: Wed, 11 Nov 2026 12:31:38 +0100
Message-ID: <20261111113535.330078-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111113535.330078-1-azpijr@gmail.com>
References: <20261111113535.330078-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: r4zoipcdjmmhbrsdniwundh4cjw7m9za
X-Rspamd-Queue-Id: 6D70240005
X-Rspam-User: 
X-HE-Tag: 1794396949-175465
X-HE-Meta: U2FsdGVkX188bV6EWpxQXyuAo8P+WDVjTy1pDKQA+2rsdxS6pA4MXkj0ahO3AYRQ5dcqnLn6epdPn76R1aBFAfM9zxygILJcxwIFAniXHxASeE1V+YDzUX6A+56MLEQk39tvNYSMVzUIPXyW2E9BAnFm//+CfuggT4PL8u47bMstFghGjX9LmdrxbNJQcAnS6BMom9M+hyrJtWY1azHV2yc+UWBg77F/kpJV9szTvQRlNWARWdCBwN7iZTBsNsdhH6NSw1Uk0Ps3VFVL2MYInu4E4CU84SXB3oCztrM7GKTIwKO4fstY5uvG1E9q4xoFitkil8byDDcfOR5hy+vQHFyQx+DMSmSF6xIUD6eY2v9/+RotIFl9WJ8k6CBQu/qel2q29uVt936+8aqAiWM1AGnW4Kegj86oiB6Poh8JTpCXXg1/2DHoPDgARwSbk3TZ9O+jrhdRD8DlRBeHauyTcrs1ZCLxfRUmvdj518Bpi0xDzpvBKnnFbsPKocKDMuxOVsNPoeke2fRtF/Fy7/o0EazepzIv0ZNJWQrxY3Z/dS7/HaOnWDhx1zYi9weP36TRZr8DKljFWjM1EsnmsxLjt5fruM5aUhoYN31d0guNfUr1lWfXY5q6WAIKFPYHepamVMuyF4qFOjM4MvDnM9uy3593x9l15oKuoDuXYqf5/adbIAdubUoHNtgTPaEoybSEufDVozrX7cLw/1SHTg6B/BpsUSboUtrjIoAJuBjpwsz114cEmpTyfG3KHC/LewWbB2kux7dpn0bOnr8/2H0JRRIVEogPqN1nVUjFqSLnYFqp08VTzT08grvN1RGbfKy/3k3l9hWz3+MJG76NgV84teRh3FIz58SeJdN5qeilcUnbba2XnBtJWVHTXrwyY2wMtKhqed31ua0BmMxGBdH0f9sDqLSKsov5MgJ9s6/KHx2u6mrEEan3mD4oWaDhmFnGVZdq0Q3C2NApgXhn5Ql
 ssdpU4k1
 M2vPfNW5PKkCWCDoCTlu9As1UKRzH6ZFzArd1jJ7ai9utLO+NOYBBCN5KWiEeChACW19hHPKpw9R3lHiXRBOrlWAZX4o/eZcOhOPGoATUrVAga3CviFL4MOBkD5p7u/wDCYsYr3xQBJVsomxXCa84lZIXzgP5PkVzLcP3pHqiWZUEmhz3d/eNWSapyu11Z9lcsXREIdiwdqwN8asCYV1bYmpXQmCnIETCoEaoL7FbQJte2a11TtBYaS0Lmbec9Qe+P9J48k2T/w6OGFrqhLIeZZiULQovRsdOz1n6bwgr/+Qxo9tcRvtK2yWcpnApUb79ydh9D09b9QhFqd9BvOmbqjQCMthoKYsgDF956Vt5vElm5SslkGeoJIdQzgrH8XON6FWho2NQFK3LMfH8Ffld+ESpCB6m2moJZnY3/H1+QDXK6R9eZuptSn1/QvjMwhO3Ka6wP83RTtITqY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With CONFIG_NO_PAGE_MAPCOUNT, __folio_remove_rmap() takes an anon folio
as partially mapped when its mapcount drops below the number of pages
and no entire mapping is left. With several MMs mapping the folio, the
mapcount can stay at or above the number of pages while some pages are
mapped by nobody:

 - parent and child zap the same half of a THP after fork();

 - two children zapped the same half and the parent removes the last
   PMD mapping.

The folio is never queued for deferred split, and the unused pages stay
allocated until every mapper is gone.

Queue the folio without PG_partially_mapped when the mapcount can't
tell, and have the shrinker walk the rmap of these candidates. If a page
is mapped by nobody while another one still is, mark the folio partially
mapped and split it as usual. Otherwise drop it from the queue, unless
the underused check wants it.

The walk needs one bit per page, which is too much for the stack with
large base pages, so it uses a static bitmap under a mutex.

Nothing changes with per-page mapcounts.

512 MB of THPs with the same half zapped by every mapper, memory freed
by the shrinker:

                                before    after
  2M,  2 processes                0 MB   252 MB
  2M,  3 processes                0 MB   237 MB
  2M,  2 children + parent PMD    0 MB   244 MB
  64K, 2 processes                0 MB   252 MB
  64K, 3 processes                0 MB   252 MB

The walk takes about 4 us per 64K folio in a TCG guest.

Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++++++++++++---
 mm/rmap.c        | 21 ++++++++++--
 2 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8c4a69c797ed..f80fa028dd34 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4632,6 +4632,10 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_order(folio) <= 1)
 		return;
 
+	/* Already queued, and there is no flag to set. */
+	if (!partially_mapped && !data_race(list_empty(&folio->_deferred_list)))
+		return;
+
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
 	 * queue. Nowadays that is fully prevented by __memcg1_swapout();
@@ -4655,9 +4659,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
 			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
 		}
-	} else {
-		/* partially mapped folios cannot become non-partially mapped */
-		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
 	__list_lru_add(&deferred_split_lru, lru, &folio->_deferred_list, nid, memcg);
 	list_lru_unlock_irqrestore(lru, &flags);
@@ -4700,6 +4701,72 @@ static bool thp_underused(struct folio *folio)
 	return false;
 }
 
+/*
+ * One bit per page of the folio being checked. Too big for the stack of a
+ * shrinker with large base pages, so there is a single one.
+ */
+static DEFINE_MUTEX(mapped_pages_lock);
+static DECLARE_BITMAP(mapped_pages, MAX_PTRS_PER_PTE);
+
+static bool folio_mapped_pages_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	const unsigned long nr_pages = folio_nr_pages(folio);
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
+	unsigned long *nr_mapped = arg;
+	pgoff_t idx;
+
+	while (page_vma_mapped_walk(&pvmw)) {
+		if (!pvmw.pte) {
+			*nr_mapped = nr_pages;
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
+		idx = linear_anon_page_index(vma, pvmw.address) -
+		      folio_pgoff(folio);
+		if (idx < nr_pages && !__test_and_set_bit(idx, mapped_pages))
+			(*nr_mapped)++;
+	}
+
+	return *nr_mapped < nr_pages;
+}
+
+/*
+ * Without per-page mapcounts, a partial unmap of a folio that is mapped by
+ * several MMs is only detected at unmap time if the total mapcount drops
+ * below the number of pages. Check the page tables to find out whether a
+ * page is mapped by nobody while another one is still mapped.
+ */
+static bool folio_mapped_shared_partially(struct folio *folio)
+{
+	const unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long nr_mapped = 0;
+	struct rmap_walk_control rwc = {
+		.rmap_one = folio_mapped_pages_one,
+		.arg = &nr_mapped,
+		.anon_lock = folio_lock_anon_vma_read,
+	};
+
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	if (nr_pages > MAX_PTRS_PER_PTE)
+		return false;
+
+	mutex_lock(&mapped_pages_lock);
+	bitmap_zero(mapped_pages, nr_pages);
+	rmap_walk(folio, &rwc);
+	mutex_unlock(&mapped_pages_lock);
+
+	return nr_mapped && nr_mapped < nr_pages;
+}
+
+static bool folio_needs_mapped_check(struct folio *folio)
+{
+	return IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT) && folio_test_anon(folio) &&
+	       !folio_test_swapcache(folio) && !folio_entire_mapcount(folio) &&
+	       folio_maybe_mapped_shared(folio);
+}
+
 static enum lru_status deferred_split_isolate(struct list_head *item,
 					      struct list_lru_one *lru,
 					      void *cb_arg)
@@ -4744,6 +4811,15 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		list_lru_unlock_irq(lru);
 		rcu_read_unlock();
 
+		if (!folio_test_partially_mapped(folio) &&
+		    folio_needs_mapped_check(folio)) {
+			if (!folio_trylock(folio))
+				goto requeue;
+			/* Sets PG_partially_mapped and puts it back on the queue. */
+			if (folio_mapped_shared_partially(folio))
+				deferred_split_folio(folio, true);
+			folio_unlock(folio);
+		}
 		if (!folio_test_partially_mapped(folio)) {
 			/*
 			 * See try_to_map_unused_to_zeropage(): we cannot
@@ -4752,7 +4828,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 			 */
 			if (folio_test_mlocked(folio))
 				goto next;
-			underused = thp_underused(folio);
+			underused = split_underused_thp && thp_underused(folio);
 			if (!underused)
 				goto next;
 		}
diff --git a/mm/rmap.c b/mm/rmap.c
index 0faef46806e5..95444ed6189a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1803,6 +1803,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	int last = 0, nr = 0, nr_pmdmapped = 0;
 	bool partially_mapped = false;
+	bool maybe_partially_mapped = false;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
@@ -1821,6 +1822,16 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 			} else {
 				partially_mapped = nr < folio_large_nr_pages(folio) &&
 						   !folio_entire_mapcount(folio);
+				/*
+				 * With other MMs mapping the folio, the total
+				 * mapcount cannot tell whether the pages we
+				 * just unmapped are still mapped by anyone.
+				 * Let the shrinker find out.
+				 */
+				maybe_partially_mapped = !partially_mapped &&
+					nr_pages < folio_large_nr_pages(folio) &&
+					!folio_entire_mapcount(folio) &&
+					folio_maybe_mapped_shared(folio);
 				nr = 0;
 			}
 			break;
@@ -1850,6 +1861,10 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 			} else {
 				partially_mapped = last &&
 						   nr < folio_large_nr_pages(folio);
+				/* Only PTE mappings by several MMs are left. */
+				maybe_partially_mapped = last &&
+					!partially_mapped &&
+					folio_maybe_mapped_shared(folio);
 				nr = 0;
 			}
 			break;
@@ -1888,10 +1903,10 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	 * Device private folios do not support deferred splitting and
 	 * shrinker based scanning of the folios to free.
 	 */
-	if (partially_mapped && folio_test_anon(folio) &&
-	    !folio_test_partially_mapped(folio) &&
+	if ((partially_mapped || maybe_partially_mapped) &&
+	    folio_test_anon(folio) && !folio_test_partially_mapped(folio) &&
 	    !folio_is_device_private(folio))
-		deferred_split_folio(folio, true);
+		deferred_split_folio(folio, partially_mapped);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
 
-- 
2.56.0


