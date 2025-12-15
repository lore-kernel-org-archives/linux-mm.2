Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C457D5B867
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 19:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA4D6B0089; Mon, 15 Dec 2025 14:12:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498876B008A; Mon, 15 Dec 2025 14:12:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C24D6B008C; Mon, 15 Dec 2025 14:12:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20E0B6B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:12:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD3E6C01B1
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:12:44 +0000 (UTC)
X-FDA: 84222652248.11.6FD316F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49C4510000D
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:12:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QV2LjExv;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765825963; a=rsa-sha256;
	cv=none;
	b=BildDsyqzqJsuhG58P3L2Y3CUURqRgGM5+xC7VPkF3+eLLVposyeNpAaAJ+kEvi876q2xn
	LoRxd16NlzS4pYJKzQLGTb42dHX4rX0zMbIjhoy+STY3VX/gm9F7UvXXrNs4LchInWlEaJ
	6uW/m2CyC4qcxKUQew4pVH3rzKDxHZk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QV2LjExv;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765825963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OsrvJtiIYG7Ous25bf0wO0Jl1RPsz8I6hTHU0s/dV9A=;
	b=5/p90IYa/R3iK2PIzSX6H90Gp1AIKiQWBGmKYrXxrQEyzVRuAwdgHo05zUTpve8lY/nMeY
	ipbjU5MlPVL8Bx5/C346s/YUYgug0OWBcL73613vVhWddm6FRPSdp0kCr3XavKYVdslYKI
	PWDYrH6fK4VS8JgHD+fQkE4gTXQG3DY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C6E442B6A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CACC4CEF5
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765825961;
	bh=r5g5zLPot987dKVuv+9VpsjA7T3StPMNMZ+Ufpi+VOs=;
	h=Date:From:To:Subject:From;
	b=QV2LjExv2F9btAjIJBV5vBBnslYalPJnWZfRirwHZcl3aFq4PuVhVaE59lh/QfJHt
	 mvE3PG38MP/YfVPW5tSXpMCabtxvSAb8YNi/skkdkwcHy1CeVPgvKNvConHQheuSLn
	 GFnlvsZgwi5b0qt+8KOduJNd6SbVSmGYziGiWvMw=
Date: Mon, 15 Dec 2025 11:12:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: [PATCH] mm/vmscan.c:shrink_folio_list(): save a tabstop
Message-Id: <20251215111241.c346395171e299a21064efc7@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49C4510000D
X-Rspamd-Server: rspam03
X-Stat-Signature: zg7dwfojh7zstcnojrhaemszuq71y4rc
X-Rspam-User: 
X-HE-Tag: 1765825963-623940
X-HE-Meta: U2FsdGVkX18dIbPgekL3IhzQqW3hoR+iuNI9sU2nBPPY/z8jBKM22Xe0nhz3HbcZbDMvnPoHFVwxQqS4EKW6fDbBHhkT1bHEbNhoafwt7CDcuRkpRwseeX4c+K1eIaV6lUnF/6ifKRCeZQifU+zkMCqDyWWEjGcZ+LhgkUzudH5TjX/Mz3NMErVS0V3rUMaAhc//78xK220jVTTNF3tRs7H/kpyUSHnLgqbAvsL8fkqGT04bz0Y2qMjhxuKwaPd5uCummXkVqbMXVTmyKBjhAwLUG0SvksGZQuIFJSDu5lW8BSpcuuB3WGDdL7IExEkteoIEOHHiCgydJbDdm5ahQwQY3Ko2mmgIXRg0My5WZvFqwjoPK93mo+j24WZb5HpXB1t8FMsli6/KAWQC9/EdUY43FE5FqCNfX6B5OrtgNLUlishbtf1WZWl3mv67K5OQv7J0SOAHaLi28rHLRdEob5CjPCs1EAyv8HxqTJyvU/pipqHA59eNUmPWR9aIloeo+SL294p1LI3KWuQctY+ifb0KwJsrmrOLTiezeDjkKLb/DiboN86Owfr9POz6vpThCjULa+H04iI+L6VD5GmA/VPnQkFnI2Cvpz0xJac+tubcaX5lcaemcTnB6WE3twTmuXkKQe2oZLnR6htS+d7ua//ZGGeUt870cSwC1NvVme/Bqx3NGHkirVDcoYI+EpZf8vJ//fa9UGt1Ta1BOZcNUogkEQUP8ni6h8K2jxr/QY3Tl+3P4P8eQ9ACM1LT/obogdDkEnEYhw1/WlvJhMfbMLAG3J2sbEzFDfzmZ6VMH5Ha8HSvzpkieh3XQ+dzBqHQjgIaL7va2hsIdq7a7rvWt4/i9Smq195xQMEWZJ29+h4XFprFMb9lBwcnn83TQPd5eRVZjiOwj66iLmkYv3qOCWwhgxPFe8dYKkrX7Kx+FNS03V2tntXSVnCCnk9mFF5C7uKB6kMXUbDec9dKbnq
 TcfWi/DI
 U7dpwrx9rWW7RJ7V3jDlSVcVr3vXGyEA5DzdKE+kxjwlBYjmQsLuey5eTKu6dIfjBJzEo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


An effort to make shrink_folio_list() less painful.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmscan.c:shrink_folio_list(): save a tabstop 
Date: Mon Dec 15 11:05:56 AM PST 2025

We have some needlessly deep indentation in this huge function due to

	if (expr1) {
		if (expr2) {
			...
		}
	}

Convert this to

	if (expr1 && expr2) {
		...
	}

Also, reflow that big block comment to fit in 80 cols.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   96 +++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-shrink_folio_list-save-a-tabstop
+++ a/mm/vmscan.c
@@ -1276,58 +1276,58 @@ retry:
 		 * Try to allocate it some swap space here.
 		 * Lazyfree folio could be freed directly
 		 */
-		if (folio_test_anon(folio) && folio_test_swapbacked(folio)) {
-			if (!folio_test_swapcache(folio)) {
-				if (!(sc->gfp_mask & __GFP_IO))
-					goto keep_locked;
-				if (folio_maybe_dma_pinned(folio))
-					goto keep_locked;
-				if (folio_test_large(folio)) {
-					/* cannot split folio, skip it */
-					if (folio_expected_ref_count(folio) !=
-					    folio_ref_count(folio) - 1)
-						goto activate_locked;
-					/*
-					 * Split partially mapped folios right away.
-					 * We can free the unmapped pages without IO.
-					 */
-					if (data_race(!list_empty(&folio->_deferred_list) &&
-					    folio_test_partially_mapped(folio)) &&
-					    split_folio_to_list(folio, folio_list))
-						goto activate_locked;
-				}
-				if (folio_alloc_swap(folio)) {
-					int __maybe_unused order = folio_order(folio);
+		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+				!folio_test_swapcache(folio)) {
+			if (!(sc->gfp_mask & __GFP_IO))
+				goto keep_locked;
+			if (folio_maybe_dma_pinned(folio))
+				goto keep_locked;
+			if (folio_test_large(folio)) {
+				/* cannot split folio, skip it */
+				if (folio_expected_ref_count(folio) !=
+				    folio_ref_count(folio) - 1)
+					goto activate_locked;
+				/*
+				 * Split partially mapped folios right away.
+				 * We can free the unmapped pages without IO.
+				 */
+				if (data_race(!list_empty(&folio->_deferred_list) &&
+				    folio_test_partially_mapped(folio)) &&
+				    split_folio_to_list(folio, folio_list))
+					goto activate_locked;
+			}
+			if (folio_alloc_swap(folio)) {
+				int __maybe_unused order = folio_order(folio);
 
-					if (!folio_test_large(folio))
-						goto activate_locked_split;
-					/* Fallback to swap normal pages */
-					if (split_folio_to_list(folio, folio_list))
-						goto activate_locked;
+				if (!folio_test_large(folio))
+					goto activate_locked_split;
+				/* Fallback to swap normal pages */
+				if (split_folio_to_list(folio, folio_list))
+					goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-					if (nr_pages >= HPAGE_PMD_NR) {
-						count_memcg_folio_events(folio,
-							THP_SWPOUT_FALLBACK, 1);
-						count_vm_event(THP_SWPOUT_FALLBACK);
-					}
-#endif
-					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
-					if (folio_alloc_swap(folio))
-						goto activate_locked_split;
+				if (nr_pages >= HPAGE_PMD_NR) {
+					count_memcg_folio_events(folio,
+						THP_SWPOUT_FALLBACK, 1);
+					count_vm_event(THP_SWPOUT_FALLBACK);
 				}
-				/*
-				 * Normally the folio will be dirtied in unmap because its
-				 * pte should be dirty. A special case is MADV_FREE page. The
-				 * page's pte could have dirty bit cleared but the folio's
-				 * SwapBacked flag is still set because clearing the dirty bit
-				 * and SwapBacked flag has no lock protected. For such folio,
-				 * unmap will not set dirty bit for it, so folio reclaim will
-				 * not write the folio out. This can cause data corruption when
-				 * the folio is swapped in later. Always setting the dirty flag
-				 * for the folio solves the problem.
-				 */
-				folio_mark_dirty(folio);
+#endif
+				count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
+				if (folio_alloc_swap(folio))
+					goto activate_locked_split;
 			}
+			/*
+			 * Normally the folio will be dirtied in unmap because
+			 * its pte should be dirty. A special case is MADV_FREE
+			 * page. The page's pte could have dirty bit cleared but
+			 * the folio's SwapBacked flag is still set because
+			 * clearing the dirty bit and SwapBacked flag has no
+			 * lock protected. For such folio, unmap will not set
+			 * dirty bit for it, so folio reclaim will not write the
+			 * folio out. This can cause data corruption when the
+			 * folio is swapped in later. Always setting the dirty
+			 * flag for the folio solves the problem.
+			 */
+			folio_mark_dirty(folio);
 		}
 
 		/*
_


