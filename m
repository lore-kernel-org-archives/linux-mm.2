Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B80AC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2446B008A; Mon, 28 Jul 2025 03:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3456B008C; Mon, 28 Jul 2025 03:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892676B0092; Mon, 28 Jul 2025 03:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 769206B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:53:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E478D8018D
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:40 +0000 (UTC)
X-FDA: 83712909000.25.FDF47EA
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 06498140002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VB2BazAE;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689219;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8Pr14kyOYq72ydfGcY9GMR3PRaWiTWL7M2lo2XD5cc=;
	b=INvFKFMLETn0rwyDF7WLDIBGZeyqsoh1U009Zv9b0AeTMXR2EcqGP4gpBAR3ezrVom9Gjy
	Ag6VnVHtB3OCVeFBKC4CW/Jf1KvzKctX9ZAGZ1XLegVkkHu4UX3yd9Ke0ujQvHlfEtoU19
	LBsPgu04sbw7BdhVgFdZznIX6ceukec=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689219; a=rsa-sha256;
	cv=none;
	b=LFMHyqP0ROdjOjItqCAJaT3oGgDt587Wt50cLkL6LoiWPFyORbeBbEbVU6YBvGw4IV3ifZ
	tpISf9iNq20NgQInQuJvUEsUPRsbt48E0bqR/NwKRM10bdPQBgNwGO5b9Fn+LR3KLNz3GO
	17PlX8gjb/7A6Hm0EfCXKYmTQIYggtQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VB2BazAE;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-240418cbb8bso1572305ad.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689217; x=1754294017; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B8Pr14kyOYq72ydfGcY9GMR3PRaWiTWL7M2lo2XD5cc=;
        b=VB2BazAEs9IlEomrQ4RxAo4df4m6xN30X/UfdTEVomxdt2/4pH1vi7YfgaujTfkFPX
         NakbwhEIKl0YOey4V4Iu8/xA/tAxOUxLxjBD7p7BH9jfdXdUP9Ohd/50kMCZD/qv62N0
         LXSkIm5B3UtCnfdRpZh5ZF5K7ZRBehVcu9w23VIZS2xI7stMQp8bAomPZj4+GkJMPI2L
         G+4MyskBXatZnat3jYzUsf359+sEUS3YTTsWw6Wouw9l/fjJj/6FYj/Y7NUpnclXaUlA
         od1n7L2qlemh3UGfpZp5jUq8bEwvtKbg9h0zfg3Ial9d7PVmDGZQFqiOCpxNll58MhCd
         GC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689217; x=1754294017;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B8Pr14kyOYq72ydfGcY9GMR3PRaWiTWL7M2lo2XD5cc=;
        b=b8UnpMH1zTyDmkvT4F9LhOvDiOzx2lZ0SF0iz4EzCxtcEGF3GlM4omt16LSWY+hhVW
         aOzFhcO3nD582mu0mWrCXC40QFtVcp4afGMqxn2uaSaOfKcbtfeSd7ZpoWeNoeF22dCP
         W0w1xutYpBL3VnCn94zRvsXh5ojXQJ2Tat7VpyQuWIw/5FPUrBNjylC3VjqAscSn/LR1
         PHOMnpXjYJELPwmepzpLtHHQy3T7qiudMeSo7M00RxsU2d3vj8XpB3NNkYVBTUxhIwB4
         R3mf0NwymIusN3fsC03GORq8k2FTk4DZdb6ln+kPAuScYellHYjeLZxTkoEIHt4Fbtes
         hIMQ==
X-Gm-Message-State: AOJu0Yx2BbhC+xT9tkhpqazh1xhDaDfIHcn5NOaVfRrWqdOHWPDiaX4P
	9IRYyDyf+YLo5jMZUEXB47nFGsafSxDjPIaHRqU+viRhZ7o/07rOIJGxnW35SsLxMXQ=
X-Gm-Gg: ASbGncsr9K1D1UHPf3xHnqCaBrGxsB8By2PT9cg0EQ8cclqPxIOZ14nyaNjRscIgbra
	WKpEEuzh5lbzWfB7I6t3WWs9ulICorIR8Xb8Hlm9flTowy9cWy7BwVDMzzLxbZV0kQK0ENQDEgj
	REEh+2Lta91dsAEkcm5OWoUMLPgr+cZTa/PXFACcYbqt57gp4vBfG8JDS30t5ajLUAag8aDQkGl
	egAQAvE3arhOrZwLJ87KRQzPgUd6nXUKujxCS5gsXJE8qh3BkjX0TSjZT3wwzZEUAISos/To3mx
	YqO17ZQH0a5AX68YI2tPjZCkTItYzAy+qpnK21/5i0Ep0qrEMwr6djSLwCspf0hZG2QQYNxXf32
	aq29W4xaoJi+N6Bo9w492UocQpv35KTeNoHCz
X-Google-Smtp-Source: AGHT+IEvIesUH1YbOiPROpyN5FUjpzPX3drCrroBBtxQEv/yuFOn6PDCSEDUoPJ7J0n+/n7q7KAmGg==
X-Received: by 2002:a17:902:da8b:b0:240:49d1:6347 with SMTP id d9443c01a7336-24049d16472mr5275355ad.35.1753689216928;
        Mon, 28 Jul 2025 00:53:36 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.53.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:53:36 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH v6 1/8] mm/shmem, swap: improve cached mTHP handling and fix potential hang
Date: Mon, 28 Jul 2025 15:52:59 +0800
Message-ID: <20250728075306.12704-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 06498140002
X-Stat-Signature: 6tkhtetgcfo7d8erdfzbrcfiz6suzxes
X-Rspam-User: 
X-HE-Tag: 1753689218-415382
X-HE-Meta: U2FsdGVkX19cDVhzIXxvL3uLz/iXVbclufZvxvHsqns2g+tsa2DbJlRJN2OHQmglW1eVTwHLfr3X6OoQWQbAcfCWqtotdbNWG7yRzI0LIhiX4mJNEoq1G4/StKomDx/b6vdTeVjDlN4zkCTkijyxP+G4Rb7SgneFBMPrYTH1CEHoyMTBxVZqIFGN3pcvoT8qFoo6N19YEPXy0kKZFIHtwX3MrmcleiDCvPIRWPqreOHczGZ4ssRz2PBfVa253W/puRLxUvVwvFjqr+M2GcANBZONKLMq2hHz4Fzx2hSpk9eEbqBStDBv3JCjpnY5hgSLl/nximHyjbijAQuo7/tBFaR+NpdWXo+0mvJaBdlgDa6Urg0244Byse8L56Sg4RBqxg2MMKTAqbaE/CunxrAYbUhh3yW53/74XxQiCMJpX139pVXZJl90JcOV8vPDMWGZ5Azu5VKRF224phZX6DWrkZaoYh0pNONqRdZ934W0M99A2xYsVjBLUcnytxtqG99PepLEM4QQJqPXK3w78LNqrKENysJ2e5JM+Qi+IPGoGr/k8/ZD30rDprAqHntI/wVesr7sZUqK/bHF9lldqP3xTah41vAdTUHxPCdEijDxdupXR8uqbZP2IC6OcEtlY1J/Vj2yWnMKPUs42AydQNnaYkCdeCw7cq8lMoNkKvlVmtWhntfQ4zQfv7fgpsVLBKeYBMTeWofmfLHHjGJrfvwEpfCE9CnheaUuLIuS3qxvY+bFk28YwY42nuWofWRVgf5APQm34IJNtkB0dH3LMdAfnBaXGgpny8tXHgl6sRxjlPYAuLte/iygOG+sGNwvYRV+VtDkUklcG0FDFhobyagrmz2a17TjXbJDPGx4WgM02US6BtETa4kZCKJDygDKasnbnPX3KFFuWG223qpfzO3yqeCQjYclr2cQ4UkLzdiPQn7Anx1rPtyZum7pyJufSZaBjJM5gSQ1EmQNx7Af4Mb
 TrZ2Nx+W
 ya2DjZ8E0VNE1oTFQqFVViS7RPlJYo0ucgPPDhGeWHM1H5yJ/0YXJe8s2uLXa58p6rFpZmPKjT4hK/HbbaZw00T+Y0LFDEpZArMBOv5uS+onmcY92IVNIrle5r9DwBgnYJaMeYR4JjKpizrqGF+sPafKR0Unhdzfd2E5ezWBESC7rECh3HWpm5+JXlvtVtRXD+A8ngCvebJ40OtASmrj2nhkZSa8/SgR6+1j7MPW658G1PLbTu1ApKLcklm6qY7PyiKgNgKDroHx1ZUgCu+kZGDrjHp+KFfiNJConyg/KWxM+kvUVGUpowFCOUthuoT8fcQbbObw1ksnwhAQMN4ymGjGw9RAYmMWa/hjJYfjK1odBXuzfeocrTR/+G+Y7xVv+5Vn/Hs/mJO+O0ThOrSvVxgHIbv2atx1Yim2HNyuiCiXNdra6Bp/+hUOLB/+gYJHDrS0jF4+W/tpIvG/cnKSZGMhSyDb7CxThNzUx8XjfpajAXTXWB3jpa+kVpU2tAQXO5n16wcb8a3/559N8Xd5IBaUUg2SwWJ/qxmln8lqyx1t4/NRIlKM5UViA/3W/6tPRPzHKJ1A1qm1fo0pIqpU/0m3qqN/qepW9ypW4iPIBczfYlx+Y/84ys5Xv4Z2kCyRt+vJ+Pbs9dkJvRIr2F3+AZytSV1CzE8j+jXYFMjxWJEC0dTQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

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

Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
---
 mm/shmem.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 7570a24e0ae4..1d0fd266c29b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -891,7 +891,9 @@ static int shmem_add_to_page_cache(struct folio *folio,
 				   pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
-	long nr = folio_nr_pages(folio);
+	unsigned long nr = folio_nr_pages(folio);
+	swp_entry_t iter, swap;
+	void *entry;
 
 	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -903,14 +905,25 @@ static int shmem_add_to_page_cache(struct folio *folio,
 
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
@@ -2359,7 +2372,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			error = -ENOMEM;
 			goto failed;
 		}
-	} else if (order != folio_order(folio)) {
+	} else if (order > folio_order(folio)) {
 		/*
 		 * Swap readahead may swap in order 0 folios into swapcache
 		 * asynchronously, while the shmem mapping can still stores
@@ -2384,15 +2397,23 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
 		}
+	} else if (order < folio_order(folio)) {
+		swap.val = round_down(swap.val, 1 << folio_order(folio));
+		index = round_down(index, 1 << folio_order(folio));
 	}
 
 alloced:
-	/* We have to do this with folio locked to prevent races */
+	/*
+	 * We have to do this with the folio locked to prevent races.
+	 * The shmem_confirm_swap below only checks if the first swap
+	 * entry matches the folio, that's enough to ensure the folio
+	 * is not used outside of shmem, as shmem swap entries
+	 * and swap cache folios are never partially freed.
+	 */
 	folio_lock(folio);
 	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    folio->swap.val != swap.val ||
 	    !shmem_confirm_swap(mapping, index, swap) ||
-	    xa_get_order(&mapping->i_pages, index) != folio_order(folio)) {
+	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
 	}
-- 
2.50.1


