Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80163D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B046B007B; Thu,  4 Dec 2025 14:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52D56B00BB; Thu,  4 Dec 2025 14:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41C76B00BD; Thu,  4 Dec 2025 14:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AEB5A6B007B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76B451A0368
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:14 +0000 (UTC)
X-FDA: 84182779548.20.8D628D7
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 63C4D1C0011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZfYO+Tj5;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAt+yjHK5qQ7D8m5tBR+wGQlT8hgZz0lqkymiFojj+o=;
	b=xeulhmGoAthVTB5om7+GXHqfyhzodvXLUaZuWRpRe8UdiwbwwFcsacOsGY248fICrVt7Pq
	xqNY/tyPaVZns0mNjjfx+2FRmbaGzm9F053ah4G4jux2xBnJRZ4NwcXI5QKRA1LfR9ETs3
	rB8mj6wKzycpDxY38A+ApMGU3e5x2Qs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876612; a=rsa-sha256;
	cv=none;
	b=5/LmVAzSFkFpZwMQI5UdoTdQMKLbiHB9HFGjTiyve0yQ2MhnFU9b0DXHRrFi9mvsadxq6+
	d5GNGyAuZgogohmziBCSpcB4gE5DVgH45py9keotR4OORkLEIDcPddXQ0RHvVYbwYAozne
	+rWUAEowRULSL2odEOinJCvympnn6Ws=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZfYO+Tj5;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so1527067b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876611; x=1765481411; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sAt+yjHK5qQ7D8m5tBR+wGQlT8hgZz0lqkymiFojj+o=;
        b=ZfYO+Tj5rcM2SBnpUpRVAJTrX4+UnHuf2819Y9QkQR81Z+QNiE1Hoe8fEnTHLfenYo
         NPy6G+jfgz2BUjp4sP3vboogwigjC05vMHNIjNiNmbGLNlk8ahnmm2x1+dHnzBYd+bx2
         2swAzgn8SFfWS+SCmOxU5WlESBjAMOfTRG3ItdIaCcVOEZ4Fjh5DV1qSRf5N+DFx4oMA
         CDquA0YZsgJfosyuMSG0MptHF0lsVt3ruSepLBc7ALLnyon6pXQu22GHJ7w4+p16Eqfn
         h/hLM3n6eJK3EjxtdlmgZOjJBk1lBbdTH0sv6jtWk2uPOcNgHyhOwEUBKQcL4uOXV5EN
         jSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876611; x=1765481411;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sAt+yjHK5qQ7D8m5tBR+wGQlT8hgZz0lqkymiFojj+o=;
        b=Ae8PzsTtZHIqSH8tDMCmIS5C+5p1oNjsMel5WWQ4x9M4jEtWVW16NAHtgQjJ3vOAYy
         VNb49PKiGsK4uglbSRbKNRbM5u55hZb6tm8RkM5cYivA40r5rCDbY9o8MfxSr/XxgDlU
         NqXA/DhL/kfUVms9TGR7IfUhtf+ElBe70W4sFwEcK6flcrBwhTWIwFTu6VqsZeL0ss1m
         H88bduwd+ZJWM/5Ari6Qh5OrjkoZ7lNrnHL+7qVszFW7Y3jEeSpTpPpBvGvhX+TZILph
         +5cadvr+2br4ahEny7h5sl5N8eEazbRNxT3+mqgCgrBHiF7H7OjE+o+581DlITzKA3qj
         69fQ==
X-Gm-Message-State: AOJu0YzSVAAyFQlphbl1w8/bFtM1JJoZyJJ7DScO0UdGC9PisN1E/GJ5
	XynAWCrUpgSw17j/gWP2yLSAveX2lSjQMiW2PtDax6dsop4iXnnhTi5H
X-Gm-Gg: ASbGncsXtUGYx2RkAtItv6wOVtqzSszfjYKCfCW+5GKPOpCeuWO7N0VOUWW2W3EsWkI
	be5/r0Au7HdRN81cR/QqlZbCIkSHKtgijc3ZkpxrfPnpXO6E3+e2s7pPzVr8HWRBIXhBIBiE6kF
	MqrKjuZavzHa2AGin1PhcitDZ3x24Dr77Y7arm+HkctreYEuAOXibn/47nwm+ivXAhVUWor2r/K
	8WgcGBWHgEsogN6AMB7s329/5CXp2cUDzPDoS4RMpCxYJVFwLj/CSj2hfXOyD2ZtTG+WrWOTzRJ
	2CVvOnorudlzQc3s/fIbA7GD2F6y2tbQ0+o/V5MZ7kmIJDFnoLfIV07PEyCBugs1qGoGOF5GCkK
	/TvKeX6eyyWYTnYhFzoYRPBWg4ABi9q9UA2vyS6HQiaDCF+ahcgsx04pjmbQ9KyYlSJs8pFNVNC
	sHqIqB+8W2WM85IgSgRwWnwrXJhFsmIlPVHMo9tPV1PXSBPsvN
X-Google-Smtp-Source: AGHT+IFird7IDAtp3z6cM38SwIz7DzceXHZjQT0hHj1JkWSs1Yleu/kOjAP8i1LO8Znvzpyb60f+vw==
X-Received: by 2002:a05:6a20:a11e:b0:2e5:655c:7f93 with SMTP id adf61e73a8af0-363f5e6f5a3mr9553698637.33.1764876611072;
        Thu, 04 Dec 2025 11:30:11 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:10 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:15 +0800
Subject: [PATCH v4 07/19] mm/shmem: never bypass the swap cache for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-7-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=8383;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=IYfI3KkZoVNQ86T3ocsCHfwQQaumhNpA42xiQvDymTk=;
 b=49OGMjEFd0WljHDwp6ddjbasyOv2SjOP3yKoOjFMTosQmtuhrE3wDGlIZCtGx0P+ex8ECbZ6y
 QNzkyzflYt3AFCWDKegarXhBec7Sp5u2M/jiUiI65OjkYrO9gfD3eN2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 63C4D1C0011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: nrrnyme5kdwzkmmec7gp5rde1c3acbyq
X-HE-Tag: 1764876612-955401
X-HE-Meta: U2FsdGVkX18b98Xq9IVE4ylot/fetoleT999MdIocJp4z7vHwHOSXj21d8l6tgZ4VQh+64n8X9ApeR1t/NweQxHCIn23XrFLCquutkbf7q4IvMB4Yp79VvMEqNSOJaTNeImhTOaEKouqbPmbowH0fDbQrIMMrCkZ93CVLYIBLGaAifhPPpvkIIF5UDiVZkOrzFa1FD0IIHwNFfERyVP/0D+teIF7LWZCBLFGO5dnjP0b9QdGSP+wGFgKp2joOYbinjOP8TANjH5KJtzD1aT5N64f04+lWsAGiqrRpojFrJ4IwkH8uBB8stDCBfMujmOjefXe03FuWYo94WcJu6wjWCeEKbNjOyGTr5JpYD9CbTitJOYIlahs6E+i7PNojPWtssTFkKplNbNU5Iuu/VlqXIuxvV5ns4B0Gs7ppWSrmRXByDz0bZBSoofRI9+JhXqyo0loZwHIoxbpvfBWCuowU+LpDAXJODU2+Xe7XAjGrs2ecEwEf7spdNyzhPz2pd8X5uVU83UFZJbKgtPmWswgJVDdiaddOCpcp86alCDqCsBDGialdwvtBfNWbVW29nr8VGOulUq3jy5S4J8Ea67iRyER0OGjHbKDfjTvVE2jP853wQFg6GHMls23X7rZXbyDbfC382+a1+nQACpCt5zdw2TU/UDzHdDPeky04h8q2Teuf1pJG9NTMNE9jd6GSA05SxN6PUehIsI0AEuk6VRT3GML/70GpUOGck8uADlpN7rX2EJrn+uxIlDCdAUJLoscBh1Y72p7qYsSqJk95zxy+xQzWupA+tWgfKSaNCW3SjLMo3eqrYkUb8xWwnh7Ho2Xwyp4X0xvzQ7t9r3onpHTWNhUZ8g63DjjqEBbYNeRu0GFtGgmzDqfQ4aF1kvi3DiY58sV3/5t8CIJCgeA6R2IiD0mSV79RGYAPlqn/wY2spRJU53pzYEvNPCWsLHoHgUhS070XYdCZBZG62+F0ZP
 Wn5036cL
 tFYFv7IJmUIUruz/4onLOrF6b7xGu99XIBNO05uCraWmLKOOfHGf01sum2F8n4kVX4tmfDswxPrLKq4kRwpo6BxwBmxUgFFe9XLlM7v5KVDscLPqs77WiNJqHvcadZC+qvBqmk5lakwf6TpXofBC64IhH6zISrr7gZatvmCu0ADqwYjxuuFx7reGuWvJ1I0p501wWK/Z2xzO5lhb0M3AoijA5unL2pKleDIsW+4iDzBtUd2Gqtb14iH6SHr6rEXr2AKRetlF64nHq67FNH9h5LNz9nOT2mpln/v/eJa8vUVoE0yiY/Mmyi1TWOjR2CATY/hAcQZ9o5bECFCTjVu5o5/vSD8Hn6viVa8pvLuxcdWMU2DhOxS1yZ59W6VmSTDv5C85t//m+RBMyZ1um7pnHtXU6muirTU6v2ddquUgxYXW8c0s4bI6YL1kKytmazl9nOhgrkn2KmCWam+eLY9ldMeQVoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the overhead of the swap cache is trivial to none, bypassing the
swap cache is no longer a good optimization.

We have removed the cache bypass swapin for anon memory, now do the same
for shmem. Many helpers and functions can be dropped now.

The performance may slightly drop because of the co-existence and double
update of swap_map and swap table, and this problem will be improved
very soon in later commits by dropping the swap_map update partially:

Swapin of 24 GB file with tmpfs with
transparent_hugepage_tmpfs=within_size and ZRAM, 3 test runs on my
machine:

Before:  After this commit:  After this series:
5.99s    6.29s               6.08s

And later swap table phases drop the swap_map completely to avoid
overhead and reduce memory usage.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c    | 65 +++++++++++++++++------------------------------------------
 mm/swap.h     |  4 ----
 mm/swapfile.c | 35 +++++++++-----------------------
 3 files changed, 27 insertions(+), 77 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index ad18172ff831..d08248fd67ff 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2001,10 +2001,9 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		swp_entry_t entry, int order, gfp_t gfp)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
+	struct folio *new, *swapcache;
 	int nr_pages = 1 << order;
-	struct folio *new;
 	gfp_t alloc_gfp;
-	void *shadow;
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
@@ -2044,34 +2043,19 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		goto fallback;
 	}
 
-	/*
-	 * Prevent parallel swapin from proceeding with the swap cache flag.
-	 *
-	 * Of course there is another possible concurrent scenario as well,
-	 * that is to say, the swap cache flag of a large folio has already
-	 * been set by swapcache_prepare(), while another thread may have
-	 * already split the large swap entry stored in the shmem mapping.
-	 * In this case, shmem_add_to_page_cache() will help identify the
-	 * concurrent swapin and return -EEXIST.
-	 */
-	if (swapcache_prepare(entry, nr_pages)) {
+	swapcache = swapin_folio(entry, new);
+	if (swapcache != new) {
 		folio_put(new);
-		new = ERR_PTR(-EEXIST);
-		/* Try smaller folio to avoid cache conflict */
-		goto fallback;
+		if (!swapcache) {
+			/*
+			 * The new folio is charged already, swapin can
+			 * only fail due to another raced swapin.
+			 */
+			new = ERR_PTR(-EEXIST);
+			goto fallback;
+		}
 	}
-
-	__folio_set_locked(new);
-	__folio_set_swapbacked(new);
-	new->swap = entry;
-
-	memcg1_swapin(entry, nr_pages);
-	shadow = swap_cache_get_shadow(entry);
-	if (shadow)
-		workingset_refault(new, shadow);
-	folio_add_lru(new);
-	swap_read_folio(new, NULL);
-	return new;
+	return swapcache;
 fallback:
 	/* Order 0 swapin failed, nothing to fallback to, abort */
 	if (!order)
@@ -2161,8 +2145,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 }
 
 static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
-					 struct folio *folio, swp_entry_t swap,
-					 bool skip_swapcache)
+					 struct folio *folio, swp_entry_t swap)
 {
 	struct address_space *mapping = inode->i_mapping;
 	swp_entry_t swapin_error;
@@ -2178,8 +2161,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	if (!skip_swapcache)
-		swap_cache_del_folio(folio);
+	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2279,7 +2261,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	softleaf_t index_entry;
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
-	bool skip_swapcache = false;
 	int error, nr_pages, order;
 	pgoff_t offset;
 
@@ -2322,7 +2303,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 				folio = NULL;
 				goto failed;
 			}
-			skip_swapcache = true;
 		} else {
 			/* Cached swapin only supports order 0 folio */
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
@@ -2378,9 +2358,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 * and swap cache folios are never partially freed.
 	 */
 	folio_lock(folio);
-	if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
-	    shmem_confirm_swap(mapping, index, swap) < 0 ||
-	    folio->swap.val != swap.val) {
+	if (!folio_matches_swap_entry(folio, swap) ||
+	    shmem_confirm_swap(mapping, index, swap) < 0) {
 		error = -EEXIST;
 		goto unlock;
 	}
@@ -2412,12 +2391,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	if (skip_swapcache) {
-		folio->swap.val = 0;
-		swapcache_clear(si, swap, nr_pages);
-	} else {
-		swap_cache_del_folio(folio);
-	}
+	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
 	put_swap_device(si);
@@ -2428,14 +2402,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
-		shmem_set_folio_swapin_error(inode, index, folio, swap,
-					     skip_swapcache);
+		shmem_set_folio_swapin_error(inode, index, folio, swap);
 unlock:
 	if (folio)
 		folio_unlock(folio);
 failed_nolock:
-	if (skip_swapcache)
-		swapcache_clear(si, folio->swap, folio_nr_pages(folio));
 	if (folio)
 		folio_put(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index 214e7d041030..e0f05babe13a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -403,10 +403,6 @@ static inline int swap_writeout(struct folio *folio,
 	return 0;
 }
 
-static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
-{
-}
-
 static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e5284067a442..3762b8f3f9e9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1614,22 +1614,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-static void swap_entries_put_cache(struct swap_info_struct *si,
-				   swp_entry_t entry, int nr)
-{
-	unsigned long offset = swp_offset(entry);
-	struct swap_cluster_info *ci;
-
-	ci = swap_cluster_lock(si, offset);
-	if (swap_only_has_cache(si, offset, nr)) {
-		swap_entries_free(si, ci, entry, nr);
-	} else {
-		for (int i = 0; i < nr; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	}
-	swap_cluster_unlock(ci);
-}
-
 static bool swap_entries_put_map(struct swap_info_struct *si,
 				 swp_entry_t entry, int nr)
 {
@@ -1765,13 +1749,21 @@ void swap_free_nr(swp_entry_t entry, int nr_pages)
 void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
 	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset = swp_offset(entry);
 	int size = 1 << swap_entry_order(folio_order(folio));
 
 	si = _swap_info_get(entry);
 	if (!si)
 		return;
 
-	swap_entries_put_cache(si, entry, size);
+	ci = swap_cluster_lock(si, offset);
+	if (swap_only_has_cache(si, offset, size))
+		swap_entries_free(si, ci, entry, size);
+	else
+		for (int i = 0; i < size; i++, entry.val++)
+			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
+	swap_cluster_unlock(ci);
 }
 
 int __swap_count(swp_entry_t entry)
@@ -3784,15 +3776,6 @@ int swapcache_prepare(swp_entry_t entry, int nr)
 	return __swap_duplicate(entry, SWAP_HAS_CACHE, nr);
 }
 
-/*
- * Caller should ensure entries belong to the same folio so
- * the entries won't span cross cluster boundary.
- */
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr)
-{
-	swap_entries_put_cache(si, entry, nr);
-}
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's

-- 
2.52.0


