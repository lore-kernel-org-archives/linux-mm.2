Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 707B3C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6046B0098; Sun, 20 Sep 2026 10:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CCE76B0099; Sun, 20 Sep 2026 10:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809CF6B009B; Sun, 20 Sep 2026 10:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59C106B0098
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:25:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D54491A0484
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:46 +0000 (UTC)
X-FDA: 85234364292.09.BBA88B1
Received: from outbound.st.icloud.com (st-2005d-snip4-5.eps.apple.com [57.103.79.58])
	by imf12.hostedemail.com (Postfix) with ESMTP id D127F4000C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:25:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=WQgQc6Sf;
	spf=pass (imf12.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.58 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789914344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pw+tpdHx2j/84yt3i8Fgf/shxRk6ErVktUyAKNdLp4=;
	b=rZAonvfq92DM0iVv1ZPZWjznCzhSrpuJ2fdSqG4NWLLCLpHfJeWOz26PM9YgijwSkK22Uc
	wGx8RgVtbnuUhrrVOcr5rrZJQLZo/5dny8YKU/qzv5jMWcT/focEA1bD5NYeiD301K4oYW
	xYXuHcZR6kWpm0LojbNxfaTH0x0bOvo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789914344;
	b=PJOjYuJk79PFeUOWkN1WDuRq3UVJ02vDZ0t0BoqaPYis6hyX+aJeRVeoU8OQ2lilENK0HD
	4D4wUMSbF9jR9TxB3V2yCJD/yY/tmJIGLN2FTMrdlSRhWHLcQjEfcdlWCYTxf423u8eT3E
	g3Ik6XJJhYpVp2DyVJArktD+i7m/Ovk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=WQgQc6Sf;
	spf=pass (imf12.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.58 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id 99F261800297;
	Sun, 20 Sep 2026 14:25:41 +0000 (UTC)
X-ICL-RepId: 01a0bf35-60c5-75c9-8b47-8dffd66b0e93
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhKB0MGWQReCEsEQwFbEhVdRUkERxtXAlQXXQZSEnIZWhRcGFNFUR9UWFUJCgJRHFYNV0NUBF9QSxsOXABLWhVVFw4CQh9QH0wWV0NEHxwZWhRcGFNFUR9UWEMZRVZpQQtPHV0ZWxxCZFhXCQoCURxWDVdDVARfUFQRV1ALWQJCD0gKXwdGRB1KG1IDGhlXFlgbRwJFRkRBFEseCFRbBhQOSVAPAF0DME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789914344; x=1792506344; bh=5pw+tpdHx2j/84yt3i8Fgf/shxRk6ErVktUyAKNdLp4=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=WQgQc6SfBU1UTStyIAAHOgOXwoYXMfQzpHOvzXm9IHBmMIbz2YcQnssNwdomRlhZcSVIYKLlZxSnrXYTLFwwYetyubsGxM+RHTByhTnUhkwhvNMSc9dHGXPQnoxFzytkIhJCNTEHt6SRtzMrEJu+g9Z3+hIs/YbXtvLo4SnvtbTr4Du6Z1Qmhcs7KXoYPNRoHWg1imQrC2O8pIerTGswULO1lREstEw8yKLP+Bk+4OqKiuoVDp3AStlipTBS088F5LAvqiCV58ft1B4K1977IwJWs2e5nlNveYsmljdUpX/9vrSrVZHRgcI7htP3LMT3SByMwd/NkjNYTOdfGTQ92g==
Received: from [127.0.0.1] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id C7131180028A;
	Sun, 20 Sep 2026 14:25:33 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sun, 20 Sep 2026 22:24:16 +0800
Subject: [PATCH 3/4] mm/vmscan: extract folio pageout from
 shrink_folio_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-vmscan-refactor-v1-3-ec04d71cb761@tencent.com>
References: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
In-Reply-To: <20260920-vmscan-refactor-v1-0-ec04d71cb761@tencent.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIxMCBTYWx0ZWRfXwXrX+1CQ9OqP
 qilit9DWHNxX4siHZVf6yDfELsJncHnl1Wz2qrUCrtD5BkDyowPT93npjQEtO59kiJTf456CAAr
 ZZIRJwAnM2UT0chAQ5i0V+F+hmeKfJl+3SHm7h86FYoZpU/mKff54IZZuFTGl/jHVHPPg8JULDO
 CZYJRkqZGE/TrJhrTaFgxKa8GiVzgt0SVbhzvYwB6bKOHELfdZAVC/86BfaOpZtHlHqGIGbWhnO
 hR9crLe0LUsT0rjYdR5TaXASz9rhqdM4lhbCTEHPUTPK3oy5E4+e4FFyIRw85fWHJ/sidiVtBMQ
 NgQVIsiSuVTbqIAQkIu9xLQxkcwBU3aE81FQQf7HdKKhxLILE2vENci9/Ifsbg=
X-Proofpoint-GUID: XofwOTYfrX-FMP0KpQDBM3g2zGkwMuyn
X-Authority-Info-Out: v=2.4 cv=R/8O2NRX c=1 sm=1 tr=0 ts=6aafece6
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=qi0cjtEbl7ftujh0onEA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=J6hPbylVjWXjVQVODqME:22
X-Proofpoint-ORIG-GUID: XofwOTYfrX-FMP0KpQDBM3g2zGkwMuyn
X-JNJ: AAAAAAABG7IOrnmuE+3ctHcDD1SpVCi8wFd7Y1nUCln3xQ4L7NRy+RFuTFtVb17auVdCj1wVa8U6mbkl2n05vciIle+2zIfFgbd/WaPl5grtx2yf9Di2w6fdDmUGGVhr3F8aiyZ1c33YFzc0f5JFcgLCnUEd6igfR+KNYSIuH1E5sOwDTw7uBu/oddl/5g2uOOL54ASip20vvRObHg/+tLBg3utbeAHfvuqnvaTdHi5ut8BC3364ZyTmwDLfXkNefSpgk8kmpKYBX3DEOBBRu2WNbtgFo+nIESMDsnUeJZ2jEyRW5eb02eOcyHrYsKGIg5MHYptGtOLryTSvqhG9y3WE7T2m7bd1tLr/qI6OpnLxjZA5iPHi2Em/KA6F31EXGETlhygko5tpuZQi6lqZTABbAzUgE/hxZHkBJVV26ayVZQ+fnf2H/GmGh1jKGSHZ+ewyRqv+TdEilJus4wAwHa1UFbBn5SiDw3xY2/4hlEF7Km+h8Dao+dOYhAdv2ccn1d3inOE1vf9uQuMze9anQ4z+T6jzTZchGsw2hfAdufFbMclgEhfgIFnE9C4aQIVFM5y+YZYqmIxmczZtLSpPgF9sUXpY94o5zYmSWnurj4bNf2dGnJGzdnRZt44hkYkfC8YKJt22jZglXy1IuvBaKmFXkPmY6PQVIGbxgrzfbUq+/Y8tg4+SJjsJBF3soD+mvVSBbEQnwCyH0wSoAVNgGK5IVqMpHxUrBJl5VEU+D0anjidG6msxHyw+jPNB1/gNM1fprrUICmP1gSqoYmQV24ml04CWcvJR10pzEAGtBCqnNqXYQe/Pbfois3PPbCHzU6CQQ0No++pDsArC6qjMIoA7+3cjglmIBUi1kkZGFBynmgEQTsd6QcfPbdfXceSicU3zy94Zeb7cxZzzapYhMku+Q5/rOeVQMob3DmSsknmsrhGtJU/zGw==
X-Stat-Signature: gry6jcphhzz8t5f5rrdkcike7fbkq6kb
X-Rspam-User: 
X-Rspamd-Queue-Id: D127F4000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1789914344-619311
X-HE-Meta: U2FsdGVkX181rSagWmcAWBriHTXp8IosBwefr10Xb8CT3tmpYfeJu3EM1sWY6XpsFtvxDOaATC6uiP5tZkMdni7BntMDQiBjdJxZrZ0vx7zse380JuhTR3rHHzPjVsU5HbbHGFbh4R+xyCKFrojSv+CqMwC2hNk9lt3qJ69/GBhUDonczgOLpI2WLIXEYphXCMOMB14s9BlRJp5FLqgQyartT2RZINj7S+UQ/IkZLjH4I5nvFvRH7ifIah0BQogWv6QWSreeXCADiPUF5Z1M0pyeuhqIWVLkxiCrVqf5lR1OA5cE7Yp9V3+QBJ6OipVf3VGnBLVQIDbSREie6RQB1l9HylNyVDWnztqeDqMFPryOCmZC2KTJuMOcT+bspReEwYmnqUXVX4w0yY+ApI4/q4mTw9Gr33ZRRYH1XxuC2rtKU3575ei8gr6rXwweCk0CcY6UVNIEuUowJtNNaL5g3DkiNlnhe0vV7bQm7muTmfDPHfl1Uha/7QCbIFhMUKnSEiAT3voNG/PVBKwQPy21XCg10cMAJdiDsrUMhh7jElmyDo9m7a8akfvhVSusxNbnYsuhZ1wl3pRpIPtZLOIBLBx/6+l9iB9qg2xlqut5LEBN1kf7AxQuq9bcDkFXW9nbF+8aqsLDVgKAT/hGnVit7ihU5IFOQ4wz+JnvvLj7lgSCkhz6JhKNnn9cntlv2VPVA1aZOWIfCQBDV6W+SF3n7xugSZEqhWugk7APhbUG2ydD4G1JJxBkWl7RNkLJKsZMBkIiQweB03PDhuSfscRWZy31nO/otMOkLGuYwHJ+lay/QrXemJB09MCdZCgJMa3i2wBJeczJ3G1SJIYpfr6WucnueDtZfVfAS5IoSN7fp9ofc/m1jH28BmyoRuT8XG7s3FFfmujtwj4t9dcD88kWCZ9KCEFCEdy2dOeO8gSGNbGFMcYdXTJ+lIjt5DkzKY2inUK7fbAinlnteEIs1IV
 hvVAYkmc
 dfx7ahMejcXvAQ8lCUoM4UHUeOAgnEl1hc0IiiBUIBOsQ6qOEwHTMao4Kj2e1Xgdlddp6JlCubrqYNf3PJ+Aj8BFQ/Xk/Jv36UwAjdHefO2mJRYxK+34xFKcwfp4bTtTJWGpi1tU/EGYcrBG9SBK9f5kbU/MYRLLOg5wTKMi3snJXkwI25eozd+WMkNQze3TdwJpzoE5YBFstZ5BkcRKMcF+uKjiUDijPSH33/FpDKiT+/aPT//c5ZBY1f/7sixJq22joAI5LJMuRk8xp0oc7D0QG/v50bUHTN7V+Q6PbH3C7hXK0iZRpnT/T6jBRxXxaP0ut4w8N2Oyu5QeAiEhbzD9hTfA1D9gPaw/6w6QD5WsvkKjzQRzvhGy47pwYy9C5xqB6L/zdpJfbLDwoDEBg/5I1I6zs7mEaC7ADPISKdBvqkWkcNKLJeN4ME1434FeswT1jdANGhPHxSv34O41syLjx4wD8hefJEPPp6BSncMTGvPKyr+cOkfdIV4sshLebgrB7gTSUPKJnj3BTUqyJH+EegCb5DEzhS1k/t4d8cN4Kxyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains a self-contained pageout() dispatch state
machine. Extract it into folio_try_pageout() so it can be reused by the
batched pageout path.

Return an explicit pageout result instead of a boolean. This keeps the
important distinction between activating and merely keeping a folio
visible to the caller, and also records whether a kept folio remains
locked after pageout().

The clean and synchronous-write cases return FOLIO_PAGEOUT_FREE: the
folio is still locked there, and shrink_folio_list() then runs its
single folio_try_reclaim_free() call, so the reclaim-free step keeps
exactly one caller.

The PAGE_ACTIVATE arm no longer normalises nr_pages to 1 after a split:
folio_activate_locked() derives the count from folio_nr_pages() itself,
which is equal by construction once the folio is order-0.  Note this
makes the patch depend on patch 1; applying it alone would over-account
nr_activate for a split shmem folio.

No functional change.
---
 mm/vmscan.c | 100 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 39 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 120085dfa2fe..3bce7ff89293 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1266,8 +1266,60 @@ static enum folio_reclaim_result folio_try_reclaim_free(struct folio *folio,
 	return FOLIO_RECLAIM_SUCCESS;
 }
 
+enum folio_pageout_result {
+	FOLIO_PAGEOUT_KEEP_LOCKED,
+	FOLIO_PAGEOUT_KEEP_UNLOCKED,
+	FOLIO_PAGEOUT_ACTIVATE,
+	FOLIO_PAGEOUT_FREE,	/* folio is locked, hand it to folio_try_reclaim_free() */
+};
+
+static enum folio_pageout_result folio_try_pageout(struct folio *folio,
+		struct scan_control *sc, struct swap_io_ctx *ctx,
+		struct list_head *folio_list)
+{
+	struct address_space *mapping = folio_mapping(folio);
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	switch (pageout(ctx, mapping, folio, folio_list)) {
+	case PAGE_ACTIVATE:
+		/*
+		 * If shmem folio is split when writeback to swap, the
+		 * tail pages will make their own pass through this
+		 * function and be accounted then.  There is no need to
+		 * clamp nr_pages here: folio_activate_locked() derives
+		 * the count from folio_nr_pages() itself.
+		 */
+		if (nr_pages > 1 && !folio_test_large(folio))
+			sc->nr_scanned -= (nr_pages - 1);
+		return FOLIO_PAGEOUT_ACTIVATE;
+	case PAGE_KEEP:
+		return FOLIO_PAGEOUT_KEEP_LOCKED;
+	case PAGE_SUCCESS:
+		if (nr_pages > 1 && !folio_test_large(folio))
+			sc->nr_scanned -= (nr_pages - 1);
+
+		if (folio_test_writeback(folio))
+			return FOLIO_PAGEOUT_KEEP_UNLOCKED;
+		if (folio_test_dirty(folio))
+			return FOLIO_PAGEOUT_KEEP_UNLOCKED;
+
+		/*
+		 * A synchronous write - probably a ramdisk.  Go ahead
+		 * and try to reclaim the folio.
+		 */
+		if (!folio_trylock(folio))
+			return FOLIO_PAGEOUT_KEEP_UNLOCKED;
+		if (folio_test_dirty(folio) || folio_test_writeback(folio))
+			return FOLIO_PAGEOUT_KEEP_LOCKED;
+		fallthrough;
+	case PAGE_CLEAN:
+		return FOLIO_PAGEOUT_FREE;
+	}
+	unreachable();
+}
+
 /*
- * shrink_folio_list() returns the number of reclaimed pages
+ * Reclaimed folios are counted in the return value.
  */
 static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct pglist_data *pgdat, struct scan_control *sc,
@@ -1585,7 +1637,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (folio_maybe_dma_pinned(folio))
 			goto activate_locked;
 
-		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
 			if (folio_is_file_lru(folio)) {
 				/*
@@ -1606,50 +1657,21 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
-
 			/*
 			 * Folio is dirty. Flush the TLB if a writable entry
 			 * potentially exists to avoid CPU writes after I/O
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
-			switch (pageout(&ctx, mapping, folio, folio_list)) {
-			case PAGE_KEEP:
-				goto keep_locked;
-			case PAGE_ACTIVATE:
-				/*
-				 * If shmem folio is split when writeback to swap,
-				 * the tail pages will make their own pass through
-				 * this function and be accounted then.
-				 */
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
+			switch (folio_try_pageout(folio, sc, &ctx, folio_list)) {
+			case FOLIO_PAGEOUT_ACTIVATE:
 				goto activate_locked;
-			case PAGE_SUCCESS:
-				if (nr_pages > 1 && !folio_test_large(folio)) {
-					sc->nr_scanned -= (nr_pages - 1);
-					nr_pages = 1;
-				}
-				if (folio_test_writeback(folio))
-					goto keep;
-				if (folio_test_dirty(folio))
-					goto keep;
-
-				/*
-				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the folio.
-				 */
-				if (!folio_trylock(folio))
-					goto keep;
-				if (folio_test_dirty(folio) ||
-				    folio_test_writeback(folio))
-					goto keep_locked;
-				mapping = folio_mapping(folio);
-				fallthrough;
-			case PAGE_CLEAN:
-				; /* try to free the folio below */
+			case FOLIO_PAGEOUT_KEEP_LOCKED:
+				goto keep_locked;
+			case FOLIO_PAGEOUT_KEEP_UNLOCKED:
+				goto keep;
+			case FOLIO_PAGEOUT_FREE:
+				break;	/* folio is locked; try to free it below */
 			}
 		}
 

-- 
2.55.0


