Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C826606D828
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=QmEk0DDQ
Received: by kanga.kvack.org (Postfix)
	id B45796B05BF; Mon,  9 Nov 2026 04:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D906B05D6; Mon,  9 Nov 2026 04:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B7B6B05D7; Mon,  9 Nov 2026 04:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2DF6B05BF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:59:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07DE680634
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:59:00 +0000 (UTC)
X-FDA: 85415132040.18.79A3F3B
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1FF8B20003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QmEk0DDQ;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qD558earAYl8br9aRG0HhwUdpfvjBgTnem7osajkDSA=;
	b=rrf2BkR1D6AIH/rIi1Sl6GuNbmKUv+uPPpooXsWNks68TcP/9Fmc7iwXHsYP9grCYfaq1f
	0IGPiuCDsQNRx0x1EgDZrKEW7tMCa8o51fV+U4zrsCaV9sJ43lNHD+o0KoVQEjGhCQw/Rj
	BkybfC2Cr5AutVG71yOmuoq4XYnrpEQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218338;
	b=c7Fji9GAtnYcqFIRleJZHE/dsH6BnUOZiJEcve1ofHzM/Y6xthUUb6bjfyR4IPeqB0tJJA
	vh7BMQlkfUXxZLXYX9rPE98xVY5ApJ1U8CTh+WRMURFsbrtQrq1h8cJ480+7Vy32xCJ7vl
	Yv4GJRjt+f22FdhYQsuGiyFLJDspoyA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QmEk0DDQ;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1438d9363fbso371291c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218337; x=1794823137; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qD558earAYl8br9aRG0HhwUdpfvjBgTnem7osajkDSA=;
        b=QmEk0DDQb2c3ZyXLLy5Bkzldp+ynN79MeJThNGgyjU3CEyiBqyneZ/HHkL/+XX/vcA
         a7ECTxEXMYoJ+OIQC9YK5SJvHWO1lj6IpIoSfJ2ZEyakhDu3b1xMI7f4WrOgeg/lSO5K
         SA3YctKL+QyeOO9reFU3RBYRV1hEHYZ+aqNaLl+cWc5kWEgnsvgaou1gYFjgoBTVA7vl
         TS+JVhv1SX4AnCGtpkZe5UTWVbpDoknTNrm0xnUuBKNwocDq+zIoqhvmNApKfuYrjR9O
         dUNTT2nBE4FkEsR1H95AvaKqaJJR9yIQED3XZdMSDd8uxPenKkeLnxDbdDVvUkgpcas6
         y0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218337; x=1794823137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qD558earAYl8br9aRG0HhwUdpfvjBgTnem7osajkDSA=;
        b=BsLYXYqi32SdNh/z6HyfowjNJnhFEphr8dlnpWY/T39WSYdVQRkUVFT04pOeBd3oAC
         dy/38f71VuwSD0r1Zya+7+wACTrBLR5oHR0aWyBS9r3+YTW9xLlutG9qjuiu0H4th6ou
         Rn0ogmt50QVXhf7F/wfY/vzMeA4XJAXWk0DF88a8NKxzdofObd8AEY245BOB6M0RrneT
         //1VoT45CSYV331CMMPvpPuMR6O6haZDrL7hN168EPyal8F4PwrDeoeN/cmvitB0k9iI
         TjLIhIiCIAYhd5B++D0jkj3j2cpt+UtONIc57jXcL0HSwzpBY44uKomuMaFcriMfbtES
         dpNA==
X-Forwarded-Encrypted: i=1; AL+hErHaHywDAvWc79sVPISjwBjiUOllOtu8IIatiO9Q8VHB+bXYI6vc8cDr/hRqEBikHAs7okQqJZIBXw==@kvack.org
X-Gm-Message-State: APuU4Z8zLH03rTlAiltC4dBaVePZT8BMNUqEJWkHdFuuVUQDX9FUrR0Z
	Z4xYfxxHOkL+swFHV536h11E73tH0VabDAmT2EUHdew9Uu8LIwCjtTHuNnE/ILaDPWo=
X-Gm-Gg: AYBFou3CTi5PHD3Mw/Tk43KFGHEvNONDkowYKmpg47JBMm90WlzzIXwSrICAY00vKKl
	AN1ASAQ5spcYi5r259vZj6fBFg51OUfqa7l83+vwXkAlQWwIO7BxJMiwvmRkLfyYtes5Xx01m0z
	sP+rExXQ3bRtS6CXLDaQLcT8ZZPCdld0B+A+w2mU+/WNY3E4eiBBRMZ71apcaY915UJYOHqfdCZ
	+PkisHsoWpXxLlmQh2n7dgqsZ5PzETgP/6/Fx+gp7X92bOsaSssbz+jUc/4P7lepBLHHJ32lr1k
	wQIlHEWqPyS1jrXpFcwadR8rTgqPuzqLzjc9QIaaJvbzAJiOAay0RwGf14XGNUHgpF5WMZoqjHU
	qa19LEaIDH1FLIoD7Xh02/7CLyk8bDrobB4xOabGM/BRoNkv6ee3lwiAhPxqZIaBcTw3pF2RqqC
	RSNMn/jncLwYW/HT5JNv5R/4b4G4xlPswkj97p5/unMpyYpscbllgPkrqHOPayfxBQSPjTqYCi7
	7GfZ5Tkv2cilLlI7DFYy/05a0hwwg24qww1zaHtGvLyGSpKrcQRU21MaPwAQ7uvryad49iJNhct
	vriWlqe+mrac+TVKE0Ss8PdBCer2rDOtForPhmu9nfmt7VPskT9DTJAG7qpdgQ==
X-Received: by 2002:a05:701b:4244:20b0:152:dd1b:4fa7 with SMTP id a92af1059eb24-1b39fece05cmr5579074c88.19.1794218336598;
        Mon, 09 Nov 2026 01:58:56 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:56 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 09/11] mm/cma: centralize CMA pageblock initialization
Date: Mon,  9 Nov 2026 17:58:04 +0800
Message-ID: <20261109095807.41547-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1FF8B20003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cjr84cqqjaf8shzzcugp8kneiyigrqk9
X-Rspam-User: 
X-HE-Tag: 1794218337-697459
X-HE-Meta: U2FsdGVkX19TTx7ra8S8zyhbLhL+3//GqbnpQgtW/1fbOIxeMNdd56SyHDEtg7snjVPBio18bU8d4r86a3GsGVFhAuP7zPpZUHTQXV8vtYV3QkVFCowfxjtAT6hGd/7e1/qtE5JqSaeFGqqaP7zDpKs9SQumQvUQoST35uT8tBw2sSQmaAGYl/+oZF7dqhdJZ4FtgEFnsQBAX0vTx30CGI9sLkLQar/5yDtn8AULZJ1vLaVRBw7LGw3jCYFBc6KithuZ5cUhh0N+Z+8hbGG+VwssTnotuNp6tukOJwo/xvkq1x4fMKwUY9uH/do0JmLDnsY4+qU1OmfW6R6JkDDVO0CLjC0/TLpueGiisf6cUrQh6P7vYVztf+Z73SH44KlYt4JzWJJUSJVUQOpRBdf2VJUZXWcnbN79W2rZyBiVz9tr6SiRju8mWGJBTAAgntkHFKxUVZQl9D4TnaWq2zdDZ0Ehe8NBVd+aA4QDJ2EFWwZy1IYZrcy67HnKZZHMoIBWUUEXPAqRutD5jG6FQGGXaSNMfURzoWhJk8NDqZl6FK0r+q3pPom85s9i1aCJ9W2oLjpOFSBXRgKkj8mWjfvjht+FtfxIq6F7CRBgBhr1KFpCTWxW9n/6E9D94E2UcdW5bseHXcfcfq6wIWrHpan5ehwvewlsDs8g2kevXEfdr9KdsrhvYzwiXvjzy90YT/+5ep7K96e4oqjCoLOoavTlJcbpQ5+VAKcujFxDrYkk9kATeRvy+oNsp/AO+vkatqZP/Zqor4Avhc5NAqfmn6iBdFJJHQ1+NzTxdJrHvtL5kyMIylV8iIWQN/LEFLyKyGO/aIwMfX1RFLoh3j7S45JyBdF+trOd13ih1GCX4msJoujafLD6DphX1NluuwdqR3BAMwvrsNtYNhU2WZ7+QW9EJrrbESrS+bJqzBmX5N1tGls85bNrhJJUq+KD+Z4qGzv+X5baaC4LNAuUgK8u9h6
 QyJtsQ3p
 NJd/EYbyECkkne6vgCM87F5C+t/Xe5hEFwxINtv40ucF4QNPYGwtoMfabv/nJYVIHxL24Rj99xTQaFlJ9dkaG3kN55fmD1AjPrn/IPzd/Nh/kBX5tB5zwJQ9TAF4B6CbP4hPhRlvd+GkXQ5CAKUxyi1RUTh84DoLw2iM9k6UPq4sgREbJjgh0NO73X5n1hZexUVwGheaswdPsP4m6tri7lUti6XNGsR2Rvk5CaaLvZL0CYYG09NrPoUPNpxbj6MZeekOUtKiTxWoJai/u7Kds2/jUleD2fFddZF35EjGgACvEEfxDZ/QcKiroOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Early reservations made with cma_reserve_early() currently require callers
to set the pageblock migratetype and update CMA statistics.  These
operations maintain CMA state and should be handled by the CMA core.

Move initialization of early-reserved pageblocks into cma_activate_area(),
alongside the remaining pageblocks.  If activation fails, restore the
managed-page accounting for early-reserved pages because they remain owned
by the caller and are not released by the CMA cleanup path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/cma.c     | 16 ++++++++++------
 mm/hugetlb.c |  8 +++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 9ec1d1fd5dff..46e72734ba72 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -163,6 +163,10 @@ static void __init cma_activate_area(struct cma *cma)
 			count = early_pfn[r] - cmr->base_pfn;
 			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
+
+			for (pfn = cmr->base_pfn; pfn < early_pfn[r];
+			     pfn += pageblock_nr_pages)
+				init_cma_pageblock(pfn_to_page(pfn));
 		}
 
 		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
@@ -191,12 +195,13 @@ static void __init cma_activate_area(struct cma *cma)
 	/* Expose all pages to the buddy, they are useless for CMA. */
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
 		for (r = 0; r < cma->nranges; r++) {
-			unsigned long start_pfn;
-
 			cmr = &cma->ranges[r];
-			start_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
+			end_pfn = r <= allocrange ? early_pfn[r] : cmr->early_pfn;
+			for (pfn = cmr->base_pfn; pfn < end_pfn; pfn++)
+				adjust_managed_page_count(pfn_to_page(pfn), 1);
+
 			end_pfn = cmr->base_pfn + cmr->count;
-			for (pfn = start_pfn; pfn < end_pfn; pfn++)
+			for (; pfn < end_pfn; pfn++)
 				free_reserved_page(pfn_to_page(pfn));
 		}
 	}
@@ -1110,8 +1115,7 @@ bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end)
  *
  * The caller is responsible for initializing the page structures
  * in the area properly, since this just points to memblock-allocated
- * memory. The caller should subsequently use init_cma_pageblock to
- * set the migrate type and CMA stats  the pageblocks that were reserved.
+ * memory.
  *
  * If the CMA area fails to activate later, memory obtained through
  * this interface is not handed to the page allocator, this is
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 290e7859b2d7..ee47a3b09df3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3240,9 +3240,7 @@ static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
 	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
 
 	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
-		if (folio_test_hugetlb_cma(folio))
-			init_cma_pageblock(folio_page(folio, i));
-		else
+		if (!folio_test_hugetlb_cma(folio))
 			init_pageblock_migratetype(folio_page(folio, i),
 					  MIGRATE_MOVABLE, false);
 	}
@@ -3305,8 +3303,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		 * in order to fix confusing memory reports from free(1) and
 		 * other side-effects, like CommitLimit going negative.
 		 *
-		 * For CMA pages, this is done in init_cma_pageblock
-		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
+		 * For CMA pages, this is done in cma_activate_area(), so skip
+		 * it here.
 		 */
 		if (hugetlb_early_cma(h))
 			folio_set_hugetlb_cma(folio);
-- 
2.54.0


