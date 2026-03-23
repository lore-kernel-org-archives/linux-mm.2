Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D228EC01B6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C156B0088; Mon, 23 Mar 2026 05:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023C76B0089; Mon, 23 Mar 2026 05:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55576B008A; Mon, 23 Mar 2026 05:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D31F16B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:40:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88100BC4BC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:40:22 +0000 (UTC)
X-FDA: 84576832284.12.F3CD619
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id BA1C71C000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:40:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="j/QTnofo";
	spf=pass (imf21.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774258820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ek3QMzzuCdQ2kmTVHTH653xAneszL99lr6ZT2m0+zdo=;
	b=WRJ5nma83ciE3IcOpPt1+jlFFX/aM/Jm9YBs+kknnizZ8Gv4lz96ajmu2NXYUDhZm2D6RH
	GqGHp3c5p1c4gTuBSnmTwliIh6ZydcY7wEu4AehXv6QKBIW2qozDexXr99qsPJP+AWwq9V
	mCA7yvW74HO38fyCVXM0SbiBTSnGeUA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="j/QTnofo";
	spf=pass (imf21.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774258820; a=rsa-sha256;
	cv=none;
	b=rag1e3PtSBllGI3r/wuusoPIhXqPTrWcOk557zP4g47PcCD5KlJWmUTU/Nr4RgVLqngzrR
	yc6MiynGF8L0NxSaL668aPfzeLt+uwL9rzO3kFRB9XQzPxYAZDrM+x+SB9Uz0nes3xMGAU
	lEXfCejnijYBJFihfztqpK92ouXuwQo=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79a7109f568so22318817b3.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774258820; x=1774863620; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ek3QMzzuCdQ2kmTVHTH653xAneszL99lr6ZT2m0+zdo=;
        b=j/QTnofoOyqBTcVAObYjHemx1Y7VNl5B/QZwBqTQShMHCl0dZFDhQR3xqetz6PZgfJ
         I/j/7fp7zx2+JdR+yGM1J536hSCOv2afKSbw1WY+tV6U/uUgmevx1wvlpRxtW+v1iKdi
         AKqtST4EBXnUPdYKLj85S9M/G9eAEdctFAC1NfteGkAWb0n07X/EPGlAvyoXpVEAZiul
         eRf1VMx7Ck0Eql9UI++Me9Do9D4SDlqjg+HmnfYqlsaUqPCCSLTMPzn2EHJtrjCSX6Ik
         VuDi7Aahc8lHj5HlMjfMWgSvRDp/od3pk36/it55s4d4zwvQxBn5/G9RaXq4wjijattU
         aRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774258820; x=1774863620;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ek3QMzzuCdQ2kmTVHTH653xAneszL99lr6ZT2m0+zdo=;
        b=XHKcrw1bETNqJVrYPf7+hUssnk7MjwlXZoBhlgb3sygdRlJpe6e6Y3DTOqUeFqCRYC
         CrQ2Zv2GrQsoCSbS2/VFqX0+5ZxnCbcF7KCeX5ml8/jWZDU1tMpi53muqs+l4ykcjAkX
         01NER8h2uTxgkuCBaN/mwx395gMdhQZIT1YkEKLzLvFM4LQzJJK9YdY2zRNkE131WB5C
         cq1r2NIo0mk+/zs8XMKHhIh5UxrkeNEhagz51TE/PWxZwcat7o897p014nBApFAz9raZ
         PXNecqhFuWOSBrTrM+D2OZO0+1z6wISOUMktp7Ez08dS3fLZhMpQD9hgBRtbdtWjXBrT
         HK+w==
X-Forwarded-Encrypted: i=1; AJvYcCU19mhr3GFMSPQrP+et/g2/9aevV06QXsdHhI62Wd9M90ZBSf2Z06MWbmkCVAxKxwy+Tmo57Z3Zeg==@kvack.org
X-Gm-Message-State: AOJu0Yx2YNL6w9NgVPTP8RIkhzH71XnOnnVqhKesnqW25zD1EaCtRcdX
	y/7yOzgrslGFTUg/4mknh3kKypn1g+MKE/yr1VmWByZb542uQq1rSfHJmzzTOPW24A==
X-Gm-Gg: ATEYQzznULujIDIT1gygmNL9Uo4d3v7W79+XyNdVWVt0LfailinGGDkKMWuk+UgVE+p
	vD3+t/Ie7cvZvB2dSieSpKdUhEmnYRXkTF6w9eevHYc65+AFNZryS9BCMRvwv1r1H2AwPauEyNs
	fBHXb5H6Bc0fGu7ebbnvpw4GL6e/ah8jAMSD4bGhuGdgAPqRos634Xg3WDtlphak9aulnyfZtzb
	h/9JQ6JPVF625w0sZgDDHSOVbpPugCwqTe1rwcBzBdtyy2kbp46vUbp/zRC/t8yI6RPbRgs5ZoB
	BNEKWkYmXF63Kv9W8b/qW7CC0g0FFg76qmGs+x0g3je63EegWwnQ0ogpFtDg5qakAbfX/wm2Bdy
	a51ontz+ND0aDL3iOpF5KlRln5M8zcUtCjR+MUSCVe7vZYMVUi8NgA3TT4s8VuWDy5WTsdOmPit
	ln/vKtb3Hi6uhYKqRxXbZtzC7mM8tUVwzuZawjQPIFBtDaiTg+uzS1qwjczHUtEgxBu57wAAUqI
	5+gi7Kdobc2ly5/RThrAg==
X-Received: by 2002:a05:690c:f14:b0:79a:4f03:b2a4 with SMTP id 00721157ae682-79a90bd0735mr123494717b3.29.1774258819463;
        Mon, 23 Mar 2026 02:40:19 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a90554a03sm54544347b3.23.2026.03.23.02.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:40:19 -0700 (PDT)
Date: Mon, 23 Mar 2026 02:40:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
    Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
    David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, 
    Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>, 
    Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
    Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
    Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH 6.12.y 3/4] mm/shmem, swap: improve cached mTHP handling and
 fix potential hang
In-Reply-To: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
Message-ID: <318493ca-2bc3-acad-43bf-b9f694e643b0@google.com>
References: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: BA1C71C000F
X-Stat-Signature: iccugrr7nb6xsd7bixotasnterxxuxj4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774258820-231933
X-HE-Meta: U2FsdGVkX183OZmAxiLMmC0h0EtrM4vQIVqsmUI8qeMtYrtuIl7/u3+8Spr6p3Ago2T9cydlYHBM6C9fmpJ94Wad1mkV3I5ry95F2ygn0KIPV0UHoRvsssVAB3KTmVQ1R3vBkkJiTHTpHm4+z2MST2XIffy4U7eAE2Nh0zd4bXNXalH05MFqfAZImsRrWaLEsLYa6sxGJL2NtPylPTc6lpwlFe5AS28rA3QVjCg5RvbZuNQc5LJUwKWRzyCfrCTqo9sb0GgYr6Nfds4qXLWQE7zpC52Kfk2xwfrhvauv9o5LIMadhOmRmRzHnyYkLtg1zdO0JM/pqVYZt//v1Hqj118qmDzTvIxBzpsnfsu+XqbMrnIxvhKiF8Pa87QlY5jptv+NcOpSg0hsys/XJ/S6g16Vpy7dJwKEimXdU+KIwOqSflXrQwnFGVOnK9LKcMR2RjLCu8LXaYjPMpG5NP3ZqJc04+xEpHhiJboSxG+88iDuVBH/TWWqvKgpTecDeGT2Qb63F5CQHnCo8eb2wQ/a1MqK/3ypvzwB5yVC1lx+i3568I96iotI9Kut4hMqlng+kRSPfTW/5nJ5lc5WFasvxQcnQ3uIpAXZxYf0wlnkinvTufV1QOhw2j9J/UpSkchX3LzIFWeFbieZaCATVhDns/3M5emkpOkRALqo1eJx3eFjJj/koWNxbQLcRs7jOEPzDuZCuVtPDwFggi8qSrebmwZeJnyhMfMM7Xmsqv1Zz4QsIrgucFw+2eD9dNYVCdQvE1VodJEX74q0lvvIczWn3jYWe/iLA/WIQB9/3kPIANIRNBLoUymBq0cAjf0dY3zvX4t6ZgjHQbc4KUhEdcbbQpXcw9hqGR3bsyWUVFtw/mguomVGO/KKpWzdtfqNPPXUykbiZJfpVC8DQyCyoNFG1QO0YU1+gCyGAh2Jp/6CsP0HOTHWp9H+cg2acab93KzHGiNbMGx2aqAvTeaRKLu
 YZRnrDit
 iaC01AECdfelX4qnfYpyU096HVGWNTK+Bu6sSCpefjhfhPkx4k8AESEqGGVuUsCuPSiNVaAVnONIo/iw80h4D0+ye8Sjb0/6aA0sowK0EWqGK2UH+96BNRztX3MiYvFXMCg7AcZczFyEVN/+PnUG8/4tfJrD5Kbv/abF2rmz5TSFcxqNEEWsrgpn7Ms3dpdbRPMLIkF4Ysm4dIrLTzvXWyxToedY4B7d3l39GFbWaSazDTRVnE1Cb+Gj4yjHtigc43q0S+5H1FjaMFq8rp3K3vE40i4v0D8emm8+EoqTs/OccgJtLIy2ENorhl54+hSv3DrfbgKi7RHJ+LMAIn29frMmKS2V/vBfUI3CRtnZMyq0Pj2B7Fy+P6Tw4GMMUV5OpZdTwjrbsw1YUH5jpuyTle4yGENnNZxKSXPBHSWP1nLIzK4j2CD0yCWZABJxJbPuh1ndsSQOqdZ4YBOUqG5clBWvlcrfdDBxs7oR6v73LDrf+umLYhcc7OcHfdPYKLE0ADkrlHK6NnD2IvwJLgNYBWNFXAPvLhLT0w5uGa3AqMkrzTMI2xPH0aEMqN962BccjpDT8+bEbge7aoDijf1opTnhn1CN+1cl/gXFPrckhDRGLYh6TBS/GgDrPFr7OdH1GMoopxmNree6/cGMZzpeQt3tc5CVVGOOlrKFZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

commit 5c241ed8d031693dadf33dd98ed2e7cc363e9b66 upstream.

The current swap-in code assumes that, when a swap entry in shmem mapping
is order 0, its cached folios (if present) must be order 0 too, which
turns out not always correct.

The problem is shmem_split_large_entry is called before verifying the
folio will eventually be swapped in, one possible race is:

    CPU1                          CPU2
shmem_swapin_folio
/* swap in of order > 0 swap entry S1 */
  folio = swap_cache_get_folio
  /* folio = NULL */
  order = xa_get_order
  /* order > 0 */
  folio = shmem_swap_alloc_folio
  /* mTHP alloc failure, folio = NULL */
  <... Interrupted ...>
                                 shmem_swapin_folio
                                 /* S1 is swapped in */
                                 shmem_writeout
                                 /* S1 is swapped out, folio cached */
  shmem_split_large_entry(..., S1)
  /* S1 is split, but the folio covering it has order > 0 now */

Now any following swapin of S1 will hang: `xa_get_order` returns 0, and
folio lookup will return a folio with order > 0.  The
`xa_get_order(&mapping->i_pages, index) != folio_order(folio)` will always
return false causing swap-in to return -EEXIST.

And this looks fragile.  So fix this up by allowing seeing a larger folio
in swap cache, and check the whole shmem mapping range covered by the
swapin have the right swap value upon inserting the folio.  And drop the
redundant tree walks before the insertion.

This will actually improve performance, as it avoids two redundant Xarray
tree walks in the hot path, and the only side effect is that in the
failure path, shmem may redundantly reallocate a few folios causing
temporary slight memory pressure.

And worth noting, it may seems the order and value check before inserting
might help reducing the lock contention, which is not true.  The swap
cache layer ensures raced swapin will either see a swap cache folio or
failed to do a swapin (we have SWAP_HAS_CACHE bit even if swap cache is
bypassed), so holding the folio lock and checking the folio flag is
already good enough for avoiding the lock contention.  The chance that a
folio passes the swap entry value check but the shmem mapping slot has
changed should be very low.

Link: https://lkml.kernel.org/r/20250728075306.12704-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250728075306.12704-2-ryncsn@gmail.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ hughd: removed skip_swapcache dependencies ]
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9b7df8397efc..1b95e8e7d68d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -794,7 +794,9 @@ static int shmem_add_to_page_cache(struct folio *folio,
 				   pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
-	long nr = folio_nr_pages(folio);
+	unsigned long nr = folio_nr_pages(folio);
+	swp_entry_t iter, swap;
+	void *entry;
 
 	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -806,14 +808,25 @@ static int shmem_add_to_page_cache(struct folio *folio,
 
 	gfp &= GFP_RECLAIM_MASK;
 	folio_throttle_swaprate(folio, gfp);
+	swap = radix_to_swp_entry(expected);
 
 	do {
+		iter = swap;
 		xas_lock_irq(&xas);
-		if (expected != xas_find_conflict(&xas)) {
-			xas_set_err(&xas, -EEXIST);
-			goto unlock;
+		xas_for_each_conflict(&xas, entry) {
+			/*
+			 * The range must either be empty, or filled with
+			 * expected swap entries. Shmem swap entries are never
+			 * partially freed without split of both entry and
+			 * folio, so there shouldn't be any holes.
+			 */
+			if (!expected || entry != swp_to_radix_entry(iter)) {
+				xas_set_err(&xas, -EEXIST);
+				goto unlock;
+			}
+			iter.val += 1 << xas_get_order(&xas);
 		}
-		if (expected && xas_find_conflict(&xas)) {
+		if (expected && iter.val - nr != swap.val) {
 			xas_set_err(&xas, -EEXIST);
 			goto unlock;
 		}
@@ -2189,7 +2202,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			error = -ENOMEM;
 			goto failed;
 		}
-	} else if (order != folio_order(folio)) {
+	} else if (order > folio_order(folio)) {
 		/*
 		 * Swap readahead may swap in order 0 folios into swapcache
 		 * asynchronously, while the shmem mapping can still stores
@@ -2214,14 +2227,22 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
 		}
+	} else if (order < folio_order(folio)) {
+		swap.val = round_down(swap.val, 1 << folio_order(folio));
+		index = round_down(index, 1 << folio_order(folio));
 	}
 
-	/* We have to do this with folio locked to prevent races */
+	/*
+	 * We have to do this with the folio locked to prevent races.
+	 * The shmem_confirm_swap below only checks if the first swap
+	 * entry matches the folio, that's enough to ensure the folio
+	 * is not used outside of shmem, as shmem swap entries
+	 * and swap cache folios are never partially freed.
+	 */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
-	    folio->swap.val != swap.val ||
 	    !shmem_confirm_swap(mapping, index, swap) ||
-	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
+	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
 	}

