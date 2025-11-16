Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25699CCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7858E001C; Sun, 16 Nov 2025 13:12:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721418E0005; Sun, 16 Nov 2025 13:12:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637298E001C; Sun, 16 Nov 2025 13:12:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA198E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E519C09E0
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:45 +0000 (UTC)
X-FDA: 84117265890.25.1834F57
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0ADDB18000C
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZpjHl97S;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVfuGPNxRKcEEik/RBbTeVbte7PbV7mIRONZ8UMZ0r4=;
	b=551fY8zdkjS2sdnfs92Ng0Ja8nnPU4AFeoE50qZd6gBWDdYf3EdP/YBunDeu/JxopzOy2P
	a7Rs3u5/dwoAkaAhFEH+tVAhX01pJjXjbENwzbnNe/C1iLOALaM+BFLBIZLE/YWaX9KOch
	wHyvx0Lyf9i8ib5Sunp6119zrIQrImo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316763; a=rsa-sha256;
	cv=none;
	b=L26vAZVY/+8y8PTIsRZLWwCD+YElA241hm11vntN2TITFMXrd1pJ736lMLQLbTpKPqzcUG
	NhDsU9k+QrvG13jOmxBpXVzZr/KDtvg69Eg0AmSjvTJiWxg1+ovUMbTJbJaPDlaIdYogB0
	MgkQ7nEsfZIcC6Y+nFy7edRXgEqO9Po=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZpjHl97S;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b1b8264c86so371809685a.1
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316762; x=1763921562; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DVfuGPNxRKcEEik/RBbTeVbte7PbV7mIRONZ8UMZ0r4=;
        b=ZpjHl97SSUJLD3g1kpcDOx4yw93R5gLbCcY8pRuVxTOgG2UdiUII0IAeCVT3MSOrfF
         TgyqMju7ORyoVd2WpOWHdHrcVMzi9pmUtnfLH8ad6KjdN3C9VOkHvTDEg5vjMIyuUcKh
         xDRmNu7PL1oawD2q7V/DTskbR9OJzy2CYkueokYP+o2cOEKLb7P9nZWsKCr0RHqABzh1
         hrqIIzB4BGqlpCr9N8ijbCt1V/Ts44fQ3kAFYIjOB7JP6Z7G7VfhNaluGkFjg0xnee0x
         1aeKW1JWmGo4hGqmoBSZyFE8c1XANVuvbG/MAF4hlr2WJLsnqv/+nc4Yf4uq/kJvLek1
         edpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316762; x=1763921562;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DVfuGPNxRKcEEik/RBbTeVbte7PbV7mIRONZ8UMZ0r4=;
        b=IEB9ngA+RZqQVGxvNnd5SHGjt2dypWu8XF57lGhxoTA8u/nNiegnbkYsrcRoWk99Xe
         UUqnBgZ8zScOPm0BBDMP+XiKvGvIN+PtRQM4TcBIT5LH2X903XFtFPNzvb8PumZhUkvc
         4Y9NT9dSR+XhJrEwhkm2uPP+MBuY2lDvAuqI8lXKKPeZjHspzAHOy/OYWuqd0PCj8krg
         rCXkO2G6+76Cn1/G9dtcsDHPrri8cbAm2DPvGRPCitxn7olivrN4bal/8eVFJB64KFw9
         sNoIWLAcjpllhsMoqdMggIjRSTa7r7yiVHSpBvd+qphK3FT+v9B2j4YtHWu/eI6EnM+8
         6WlA==
X-Gm-Message-State: AOJu0YzR7VUYPWSFOwcfSytk/NcgseM6FFcIvR/j1HykmYMIkgl/S7xA
	rgUnZk5S3hk1HmjT8YBdI+u9WahFVs8rO5uY+Y/FU/u8NP33iUxIicqq
X-Gm-Gg: ASbGncu39eEZC1P151vfiH7EZFeUgMuiXQcnOfnodb+FmVtRBcxcHNfn3mDjxyrm2tp
	plCVuN14ZBoDwu0q+ZurjIoknwnPOTQgB+e09eywiglcAPVee0EzOWY90eFTUjI7/rrs6cCcewY
	t1jHm9YZZCiKaCfTceNJq6zHO1YYcyT7LsvxP9RCKuOj5zQ6BGR1V2ZwzdEvyY+lcn1NCi3hHjA
	iGxxvTEzgmjdYJR1KBBEQbD6DbRfGJZbwOG7IouUW7YWKzKQziGXQMNX19H8fjFPdXc1HrluVPH
	5h03v2fxhJhlhk5CVIQUnGtL+neZLFI88hp8eC81BSSWmbFd2gUCzSo3EbsLvEHhVaGxNw7LT/e
	HfGeka09jAWKA3X3L51bBBDAbKkIE/s6VateHUmc1d1ONhGLLPMo6NB8D9c8FxX36mcCo7AvJRB
	IKhbgJ1OmPhyiy/6b/btaLbveuEv3Cr9Y63D6dpYzgLI4PmL1suEJM
X-Google-Smtp-Source: AGHT+IFqvaSN9st5EB/pf17WcYAMGeuJVHPhWIFo/7Pgr+DmtWwEbnQgzp3bcOWfFnwn7gaSooR7FQ==
X-Received: by 2002:a05:620a:179f:b0:8b2:1f50:ca52 with SMTP id af79cd13be357-8b2c31c1ee3mr1300567985a.59.1763316761946;
        Sun, 16 Nov 2025 10:12:41 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:41 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:48 +0800
Subject: [PATCH v2 07/19] mm/shmem: never bypass the swap cache for
 SWP_SYNCHRONOUS_IO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-7-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=7744;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VBm+UEMLrddKYoSogqdhFKlPao5i04J0iZkpSQUK7s8=;
 b=OMyWgLnxFZhhYXCBMOq7x6j0wLOxEOMfr4tgzF4mbDOUpePSfD6onGeAcusToycPpmW0tCFjg
 QnL39dn0BkTAzqNhPuujC2gwQcnuilJGoYGW2z3jlHfTckMXIjBbKiA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ADDB18000C
X-Stat-Signature: kocs8xhixma3kou9mrm19dk6i7188r3d
X-HE-Tag: 1763316762-648159
X-HE-Meta: U2FsdGVkX19D05p92nQ+5psqPBCzwwQwuoz4My072rFZgqdZCyAR+/wk8mGg5NzcwLrycmRIwWQUgwELpyFkYi2dEXcULAHiqFL7AMj+aS7Eo2oa0FSlFAbIHHilUj6lshOREktCc7+meEZ4YpzX1bpIcRhSzcnh6TngiCbX426wst94Az3kuQ24STo6uJpoJawQvbYOoLJ58bYarZGrSy4OU0OgffNqLH2QHjKnYpxWFk1QGoA21OtESOMXJyfTqdUc49hnUufXJoh7GM/jqy0LUFo87gd6V0Z4Oy2JpJJqzVDQDYwsLP2v0No6nPRkEnnceB3L8qM2mwUEF76p4FhVNoXugABhmWvgfhbTeSfoMuHUD3KIhJEzFufSuUW4WfnsNNp/Y1B1YiP6Ff8nchMu6Hz6oGtO3YfGm7lZTYw8KDCNM409EnvSpvqH7JFsSYUnzVk6e1FgsdvEZglgdFTN7+dvNwLKyBpOohSAuZ8lM8jPXGRFubEdqMWflQiQvpuxtkLg2hp2+9QY9RYQoSvY5DO18/bDeKW0hL+maq4GBVvXktb4rOETKK+5RHWyv2qDE6+waDOJMme86TmOduDB2lBsxuV+RI+p60ih8fcKp4nAYDcrajxoC/Rxrz5NqH4uukQEB6vkD12v7tca04si3mdRUzaTVdsN8EKPOVp0c4DqyrqBE2GzB4pRIXwyuscV3PuWcLUAwB7GbqLlpYPLblKiSEO344bPxa5zz3d52Z2mEIsRx8WoH1h6OqGpOhONY+DbF+qq9OAqBYgjpMsOSpeIwA5S7kuAcKBPM/np64oJtTYGTWxDVp1tBETqhSpfL+eU6BOjPb2J4l7n2fOU7TyKNH8tDyM5JdXH3WWg5BZEF61BrQexzyOb8d40N10ITADGEMtMLolytYZDahWQSHMWB7Jt2cqNbPXmz6t6+IsaU09a4SV1fTxTHuyZzV84aaC3RAvGveCOpAh
 L7zT99PL
 o1hoEPuWj4vFZDzS4fobyh6hFQNDYfrKVBZIhip1+L6bivODUV6qs4PjuLOol7tfQaiw1uYpQrFv/8kB+vw6+nhW6RlnLt/OiyK4tL7Wu/A9RUe2kQxTnfLtIEYfo01++CNFxKYl3gAY2yA16/d5KXcml4TAXLR1HumUTTCOTCoLbXAwv4BN7nY0+XaIg6vryiWc45jb/CA2aMjvqw5vTPJ7rHsB7EZu8xFojz56S7zkXwfgmQ7QajyMaFUfZv1Svkg9OfCU5YZMM7iHrVideyx26xJ0UiUNpOEvbXZbKPZ4eo2/I4W4a3MfoHQ98PsZqoWd4ZGpHLQ9YT9T5dAMCiNJOw46ltmFCUXI3LdGU7stnPD1y/zE4biFFihNGm4sacvuD4SCFgir65aCFye3Rv1kkBDoOSDWC+4QpcjSKL19tmmpCBgA2CycSeZJe5aes8RSg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the overhead of the swap cache is trivial to none, bypassing the
swap cache is no longer a valid optimization.

We have removed the cache bypass swapin for anon memory, now do the same
for shmem. Many helpers and functions can be dropped now.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c    | 65 +++++++++++++++++------------------------------------------
 mm/swap.h     |  4 ----
 mm/swapfile.c | 35 +++++++++-----------------------
 3 files changed, 27 insertions(+), 77 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fc835b3e4914..8b711b8bcdba 100644
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
index a2bb09867f1e..a433445e9225 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1613,22 +1613,6 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
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
@@ -1764,13 +1748,21 @@ void swap_free_nr(swp_entry_t entry, int nr_pages)
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
2.51.2


