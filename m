Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB73CCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1FB8E0017; Sun, 16 Nov 2025 13:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9B38E0005; Sun, 16 Nov 2025 13:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0148E0017; Sun, 16 Nov 2025 13:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4882B8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1191512EB46
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:14 +0000 (UTC)
X-FDA: 84117264588.30.C3E8643
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4A9EE1A0007
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bNG48V4B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGBxtnma5/6CRPD/17HTQjlSlOJnU7PIMQjp2Rfi9PE=;
	b=8BA1QutIffIkmVea8mA67Jh5vIeoiOzQk3uzXazPM/5iBZOfC8NnxWo+TdTYZaNR03uPzE
	2RCVcvqkAbB+HshvcQj3/PjAjQncQh/e3zA1t9Durehaavsa9CRxKoBRY8a4WBKzUNsBNd
	X0X77MqDKbEg+RFfrzW7fhzA5YyZwfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316732; a=rsa-sha256;
	cv=none;
	b=vIuT7IOPZxNEjf09QaoCZ9LuXh96hhytte334VX6bJsqbKbF4b4N6Meq2+nrPrxG8OBHJn
	OB/ZqDyjrTAfPRzxizdCXj4tyYB+tlALaIw5yCD3HIIC76l1B0nemfhJmtwJR+C+6OJvW4
	SsfOgRBWh6v71fh7c/VRZXnJ9JXPBeY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bNG48V4B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b2ec756de0so27791985a.3
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316731; x=1763921531; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mGBxtnma5/6CRPD/17HTQjlSlOJnU7PIMQjp2Rfi9PE=;
        b=bNG48V4B5O2UjmTY6r7cvi3qH1/3eeo54IYWOrKL/flC2KneC/dpk18q0DXXLz4cM1
         naguwjafie9FwSqvmMAw8IsAdWKBnoJRixyKXwoW42wxqK97IFXCEDQ3Z0ygB3IpaJAC
         lKalgqcDNhI+qKT/I72Vd8Y34Y67SFdaAd+Uazykliijecfj2/2Pa7L2pchRs6h5t3Eg
         v2MCv0Zg1BXKnIgsd1ptX6pTYOzoJP4QiabYZw1DTu824qPsTnuDHO04uR6lU3hs1RfL
         TF2ovnChya6+r8dc/zQMjgT2aLIldhu1BbiuWuEOaGKg/9nR6UlJJ4v8skfXQg05es3P
         DO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316731; x=1763921531;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mGBxtnma5/6CRPD/17HTQjlSlOJnU7PIMQjp2Rfi9PE=;
        b=k9eEUUBSEY97h6koOSRnn67s3X6o6TGKeYk2K1tDQ6KrlxP6oxY65SOyxfycxg5sbw
         jT00gVd5nP5SjT5se3EuuEgWexxYantsnNbXg1FF3vzRma1jE1rflcjFwJrTAgk7zdKQ
         MyjssQrwgNREtLFiel/JBCtyhsv59JW7kLKc2/a7o4L3+HuYR5RdIC9CcaV4i6hdWu3t
         T14IOZlrjNNEHsGYcv4vLPiUlGeW1ZIErLL2v6eVD1rDsELfng9ZmTIyRCgGF/LkvRKk
         BlbHqmJ9xQVM50rrBRcfCF93P6bXmqyx6xPl0gJUr5vOXSpEbA9dVlmmMx+IVzBGnorm
         Ovrg==
X-Gm-Message-State: AOJu0Yya0/f74ABNg1NZCYGG9X2QiKKRCs5OdHuXrmnA2P9F00mLzVYQ
	dqtsiCz42HNyMQXvl5JeYVvaB8Q/z4BsH919Gl4wteNpEnTwZO79risv
X-Gm-Gg: ASbGncvy6bNsNAdhJve5IZeYMz7PQkad0MBDtEgNSFktzVky3kcNO/sWCKNK492qxgI
	3RITrrghbmRQiaQdZekhsraL9EhJ+FjJMRuymWGHNQgQh9E9mMysONkkiJrHoDovDsshm/ghkRG
	7nlVxJVWtUnbBYVZGprmG63k9VC1xZO4VHHmZHmgILch2GCczXkzGwsqtmp27TXGeceGQLPFhn5
	+fsXkr6o1cm0C7A3XGmCv/HMGwWIv85FqvWJX9B6uU7UQD3TmKCMBrwZcePfy5NS5EvqWTmQFiO
	Q7/vj67fy/C5OTr6PJjbR2uEl+Q7+21OAaYuEnEK66gvw/BwVOml3T54p81L0byCJwdrSLg+Tnj
	DA8q2GaGzzsPlkaIoDRP3Y6ubKOxCSgzbXZDIIS6SIauYdTqF1zaHIeeqQYeOJ2I3z0h5wP16Mx
	nVCieT45lVAGQMyHqbqYMHt8pUPoF4Nds8Gg/27cfzhw==
X-Google-Smtp-Source: AGHT+IFAmDQLvz9ChsknK2+UT9XbixDr0Mb5i8t0t7mh9u4FpIBsqAVOsFmrY+Hu9DoXHb8U8WU1MQ==
X-Received: by 2002:a05:620a:710c:b0:8b2:ed71:ded3 with SMTP id af79cd13be357-8b2ed71e112mr170812385a.67.1763316731277;
        Sun, 16 Nov 2025 10:12:11 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:10 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:43 +0800
Subject: [PATCH v2 02/19] mm, swap: split swap cache preparation loop into
 a standalone helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-2-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=7903;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=sIVoG1dlSi/aTgaUaWI9AVQjLltQqhRg4QlbOjwm5FE=;
 b=P3ire7AGiwDuNNN02X8q5RU+/U/i3b54gfxktC4V9sFrN+VIe7j0m5+gICNVDYCDAYLhdzw8g
 ZQra9Q/sBAQA1bv1bIHiM6nh0h2Lc8wF3qi6sgypMf0/GmXaQV2r0LJ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: fui6ib3ka9g8astbeguqowwaus5krecd
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A9EE1A0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1763316732-872212
X-HE-Meta: U2FsdGVkX1/onOHu1Wqlp+v4K3vLeUXcc4UKl8h8nhQV4Y7AbJZLVnRM9Z1zQ6nz4TJJwdI8Rd2wMhJuTU2hrKyoPsS/z82ujQdKm5/WVVpPIQx2lKmioVPS9jx6ZMWmamcDZQh64XGMeZyDodFqPh3EoVkVm3iyZgeg/lMithJNYTXhWGarabXmj8hGbAXOD/FdmPVzjRf5LTcSFYP60D0YCpgcATnNqpik7T2Ks3elgIWJKwPhAqgW7Rp31qGJ6AImdFU8lntla7xt2xhPMvlwV2p4jGd9fohaa6ubgvpSd+HLM3abo95SAzDTuGCk7jH7tgKAHOYIHCdNoWEImhgdUiNUvBvzygpiHFkcLznRHrllthdeK47MrRDcJ99cYvEx30bPHKtBRSSBU15SLlcMpJZXByhuPkVaYJSRzB61aZjFONvDq7s1cTN4kgIc3TzlHnSNRIO37AYSQsN6ObqHcPsRhZiE28YJPZKn0VDqSkfpRIExGyo0f839wyDnT7crloRV8RBIHOKUo1OWKX3FTx1DKJ3GwjTmzI8p5agcp3ZO3edQaB49rtdJfhbhO3TQxcfNzgtS7/vdChAVC+ah2h2HQOWwJeiB0DoOJHn+VBphLzwTe+38e75uhTh2uoEppcCS+5WDyQyF+5AcAwfbr4maFBhn7DfS10ntSquCYuXdnBLD49vrqVNRbLJ4JUbhSjGLFgJozx07RzFx498hYlGft+c+podYhgg0HHeV2vOIH2l+IipiWIuhf9PzP5+UG/GKBRIRInNqo+entW6c2UvVTArBk8KikJnog2heRQdzUuTFXZlC8Y+Ix2NuzylYy9VFml/Mq0jSBSHyedBSekqmXKBXZEeT2/pfdLJgvUw9srJkUqYwuNHbO/36qniZDKBHTeGDSq2M59Q5WHarfErIFLWhW6+lgN4KQGST/jEQ2AKn//71kQABfHGR+UJDDHbgSPCAQNE+c5j
 4xQHJmvZ
 yieetNXBCTU/xzgFcj5qwxYNieQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for the removal of swap cache bypass swapin, introduce a new
helper that accepts an allocated and charged fresh folio, prepares the
folio, the swap map, and then adds the folio to the swap cache.

This doesn't change how swap cache works yet, we are still depending on
the SWAP_HAS_CACHE in the swap map for synchronization. But all
synchronization hacks are now all in this single helper.

No feature change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 197 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 109 insertions(+), 88 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 08252eaef32f..7b93704fcbe7 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -402,6 +402,97 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 	}
 }
 
+/**
+ * __swap_cache_prepare_and_add - Prepare the folio and add it to swap cache.
+ * @entry: swap entry to be bound to the folio.
+ * @folio: folio to be added.
+ * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
+ * @charged: if the folio is already charged.
+ * @skip_if_exists: if the slot is in a cached state, return NULL.
+ *                  This is an old workaround that will be removed shortly.
+ *
+ * Update the swap_map and add folio as swap cache, typically before swapin.
+ * All swap slots covered by the folio must have a non-zero swap count.
+ *
+ * Context: Caller must protect the swap device with reference count or locks.
+ * Return: Returns the folio being added on success. Returns the existing
+ * folio if @entry is cached. Returns NULL if raced with swapin or swapoff.
+ */
+static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
+						  struct folio *folio,
+						  gfp_t gfp, bool charged,
+						  bool skip_if_exists)
+{
+	struct folio *swapcache;
+	void *shadow;
+	int ret;
+
+	/*
+	 * Check and pin the swap map with SWAP_HAS_CACHE, then add the folio
+	 * into the swap cache. Loop with a schedule delay if raced with
+	 * another process setting SWAP_HAS_CACHE. This hackish loop will
+	 * be fixed very soon.
+	 */
+	for (;;) {
+		ret = swapcache_prepare(entry, folio_nr_pages(folio));
+		if (!ret)
+			break;
+
+		/*
+		 * The skip_if_exists is for protecting against a recursive
+		 * call to this helper on the same entry waiting forever
+		 * here because SWAP_HAS_CACHE is set but the folio is not
+		 * in the swap cache yet. This can happen today if
+		 * mem_cgroup_swapin_charge_folio() below triggers reclaim
+		 * through zswap, which may call this helper again in the
+		 * writeback path.
+		 *
+		 * Large order allocation also needs special handling on
+		 * race: if a smaller folio exists in cache, swapin needs
+		 * to fallback to order 0, and doing a swap cache lookup
+		 * might return a folio that is irrelevant to the faulting
+		 * entry because @entry is aligned down. Just return NULL.
+		 */
+		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+			return NULL;
+
+		/*
+		 * Check the swap cache again, we can only arrive
+		 * here because swapcache_prepare returns -EEXIST.
+		 */
+		swapcache = swap_cache_get_folio(entry);
+		if (swapcache)
+			return swapcache;
+
+		/*
+		 * We might race against __swap_cache_del_folio(), and
+		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
+		 * has not yet been cleared.  Or race against another
+		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
+		 * in swap_map, but not yet added its folio to swap cache.
+		 */
+		schedule_timeout_uninterruptible(1);
+	}
+
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
+
+	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
+		put_swap_folio(folio, entry);
+		folio_unlock(folio);
+		return NULL;
+	}
+
+	swap_cache_add_folio(folio, entry, &shadow);
+	memcg1_swapin(entry, folio_nr_pages(folio));
+	if (shadow)
+		workingset_refault(folio, shadow);
+
+	/* Caller will initiate read into locked folio */
+	folio_add_lru(folio);
+	return folio;
+}
+
 /**
  * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
  * @entry: the swapped out swap entry to be binded to the folio.
@@ -428,99 +519,29 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
-	struct folio *new_folio = NULL;
 	struct folio *result = NULL;
-	void *shadow = NULL;
 
 	*new_page_allocated = false;
-	for (;;) {
-		int err;
-
-		/*
-		 * Check the swap cache first, if a cached folio is found,
-		 * return it unlocked. The caller will lock and check it.
-		 */
-		folio = swap_cache_get_folio(entry);
-		if (folio)
-			goto got_folio;
-
-		/*
-		 * Just skip read ahead for unused swap slot.
-		 */
-		if (!swap_entry_swapped(si, entry))
-			goto put_and_return;
-
-		/*
-		 * Get a new folio to read into from swap.  Allocate it now if
-		 * new_folio not exist, before marking swap_map SWAP_HAS_CACHE,
-		 * when -EEXIST will cause any racers to loop around until we
-		 * add it to cache.
-		 */
-		if (!new_folio) {
-			new_folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
-			if (!new_folio)
-				goto put_and_return;
-		}
-
-		/*
-		 * Swap entry may have been freed since our caller observed it.
-		 */
-		err = swapcache_prepare(entry, 1);
-		if (!err)
-			break;
-		else if (err != -EEXIST)
-			goto put_and_return;
-
-		/*
-		 * Protect against a recursive call to swap_cache_alloc_folio()
-		 * on the same entry waiting forever here because SWAP_HAS_CACHE
-		 * is set but the folio is not the swap cache yet. This can
-		 * happen today if mem_cgroup_swapin_charge_folio() below
-		 * triggers reclaim through zswap, which may call
-		 * swap_cache_alloc_folio() in the writeback path.
-		 */
-		if (skip_if_exists)
-			goto put_and_return;
+	/* Check the swap cache again for readahead path. */
+	folio = swap_cache_get_folio(entry);
+	if (folio)
+		return folio;
 
-		/*
-		 * We might race against __swap_cache_del_folio(), and
-		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
-		 * has not yet been cleared.  Or race against another
-		 * swap_cache_alloc_folio(), which has set SWAP_HAS_CACHE
-		 * in swap_map, but not yet added its folio to swap cache.
-		 */
-		schedule_timeout_uninterruptible(1);
-	}
-
-	/*
-	 * The swap entry is ours to swap in. Prepare the new folio.
-	 */
-	__folio_set_locked(new_folio);
-	__folio_set_swapbacked(new_folio);
-
-	if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, entry))
-		goto fail_unlock;
-
-	swap_cache_add_folio(new_folio, entry, &shadow);
-	memcg1_swapin(entry, 1);
+	/* Skip allocation for unused swap slot for readahead path. */
+	if (!swap_entry_swapped(si, entry))
+		return NULL;
 
-	if (shadow)
-		workingset_refault(new_folio, shadow);
-
-	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(new_folio);
-	*new_page_allocated = true;
-	folio = new_folio;
-got_folio:
-	result = folio;
-	goto put_and_return;
-
-fail_unlock:
-	put_swap_folio(new_folio, entry);
-	folio_unlock(new_folio);
-put_and_return:
-	if (!(*new_page_allocated) && new_folio)
-		folio_put(new_folio);
+	/* Allocate a new folio to be added into the swap cache. */
+	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
+	if (!folio)
+		return NULL;
+	/* Try add the new folio, returns existing folio or NULL on failure. */
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
+					      false, skip_if_exists);
+	if (result == folio)
+		*new_page_allocated = true;
+	else
+		folio_put(folio);
 	return result;
 }
 

-- 
2.51.2


