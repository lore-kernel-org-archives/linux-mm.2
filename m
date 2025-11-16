Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD6CCCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF00D8E002D; Sun, 16 Nov 2025 13:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0978E0029; Sun, 16 Nov 2025 13:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6148E002D; Sun, 16 Nov 2025 13:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A86818E0029
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:13:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73DCE4DFF3
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:22 +0000 (UTC)
X-FDA: 84117267444.21.60DD19C
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65462A000E
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UBIcns88;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ij0vfNQQzZ3dAiPFZ1kFDjH/7On4+VkwSY7fIz5EehE=;
	b=OG+28zfxc6CHAjRuLqpT3BdxlumjjnAi/70h4LWUWvrFQ/sw9aH7K6r9CYDcOuc8WKKjxM
	e1gEhoeMS2Ya99tW5TNXYSZw0vnZULEbgCKnTAEZwuFNkYWSJGDf+KDNPZPNpn0jgIes/q
	HD9D92nPbtAvyxDfpOWGrhjJ0VBxLFI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UBIcns88;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316800; a=rsa-sha256;
	cv=none;
	b=2xe/hKmxdlH2O1tLFM+sSDWu+YZ743ofkRvB1Try5cVFzn051XQboX0Sj6gLy54nIWEV77
	ArCeGcfapxNX9/HGGkbc5bHWSoXpI4ORqlg0suFF8EUZTPs64jIP/p3SlAKgN8I1pj3Eu3
	OWnWfzDBUKX1WlIrMpY0z02KgptJyU4=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b0f54370ecso361654285a.2
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316799; x=1763921599; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ij0vfNQQzZ3dAiPFZ1kFDjH/7On4+VkwSY7fIz5EehE=;
        b=UBIcns88XHunRhFhf1iJTKdKYCgeoPMmdKrMCqCgR7Z1aNazQjTrXVd67nryGClubp
         a2NhFBlHpkdnq/Pu1rzgJJ3M1WvSicGTIga4RwNjRq9X3JyXctz9rVvbDKu/tG6Q9/Ta
         2QGOHSJ1DxsrC/g6Tzy0L+c01xlCKNGuc6mBVhKkDark+DX+tILWNtH826wzP/9RHsEa
         w18F/U6y1fzl0X+3cxfU4O+ux6YU6+PmbcvIbhD4h9gKkeRN0DnxIKRNNUqlDmp6MH4A
         3qGPxQI0D4VNBEfE8IhBTYKGpw6jcfzdMXncfnu1O0QdmYJhznz79t1Elr1+H2h5npgG
         vlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316799; x=1763921599;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ij0vfNQQzZ3dAiPFZ1kFDjH/7On4+VkwSY7fIz5EehE=;
        b=RpQL+/7lSftNd5lKPazs4T373VUQZPnU2M+2H7boBi43xjhL5PSbE3cO3ULWiPwlgr
         TnH1wMUbXhaNrw0vdaUBmPskp87FJ8sfAE0v2JgeeJ2ou1CQLhx+S1P3bPve6YOv15VS
         8hgfSEa7zcFO7mMJBn9xsfdqWZqMap0Mjp8W/E/IXeVuHAJKwiWdpr6TwzsoYnZU6ZhK
         hlAsogpx2NiH5vrHNl6SWhKiN1e95gjaRuSzEP/FJUsU/b4KMKs9yikTcV4oLcURCaOa
         MA3KrvRJ/5MZa+5U8hFL6ZcWkEc1Eedr7+y3wtDNdT7sAaUyJsMxNWgpFkrc/5jaCOnW
         757w==
X-Gm-Message-State: AOJu0YxMFsbyz9XVxeMgyz9EZQOdVQifBIIHwxCHc1fsVRCOts4kOlnQ
	mG+SlfVKVRrGp9qr7M1rMv9GIl1Y3r0I4wQFwKBLHZ+S0Rc3DTLflyiV
X-Gm-Gg: ASbGnct4oCusuGVwwOhb8jSKabQRUQpNDqDfWjtyLya+f56B7QcAgPPMvgzPCiaGoD0
	G8C7YYiuCGwcryQj/PutyBZGKZlXyJNJaQnAe64cf7FsS+dI2A5lRDMKLM6uI6000nr9TAH2GdM
	6EFCcUheLCHHl/PAnMFA587dkKxHcReKNV9eAEuYKqsBNgY7FqmBE3TkB9izYqbQUBHxH4zJUak
	EjiHNyof9srlW3U5lHxwbO8NPrzAKX/CQWy0JejseO/wtSfe2f3uI9zTZx8VWk4YP2HH3sJqYUD
	us4F/H29QyqbVPPE4+9D2w20AnECtr8o4Jk9olNd9KCO/QzQ0WS2nbM4Wz7YMjWyRgwes3PJCo9
	BfUPLkz7+4JzgWdxAbqxlsV/PY2mgFCJubap/KoORvqGOwXYyNAvbRbImdQC+okGhtBc3GsB4Np
	tSNyJtDyteQsrtdoMVQ12yTqBdVh8KLLbVxz/Upz2SSi39Mc8xmbWh
X-Google-Smtp-Source: AGHT+IEmxPIP5/I5Dx+oQpMmwRAhA2KuxJ4hwNhsyRpP7RaNJhKoVbFoCOUjuV9jqUlF3MguXWwkkw==
X-Received: by 2002:a05:620a:3941:b0:8b2:6121:5aff with SMTP id af79cd13be357-8b2c3147db8mr1310044485a.8.1763316799348;
        Sun, 16 Nov 2025 10:13:19 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:13:18 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:54 +0800
Subject: [PATCH v2 13/19] mm, swap: remove workaround for unsynchronized
 swap map cache state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-13-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=7032;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=OrKeKXrrpV6Mi36w7nGzBW03Vnoz5A4xueUR0Ol7Vrg=;
 b=mnYO+q5j4m50upBMt3k/YhjNjLlUta2LJHN8Y3Fl/3RMo8BXE15cLtjth2BG6oqggTkK8g2A4
 psIfVs7opNGD2bk0KEe0/XzR5/vQUWIR/fgqvS2WBH40rwZzEb4frPD
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 65462A000E
X-Stat-Signature: 7eks3dgjs37icwmedm5z4p5dc1ozps4f
X-Rspam-User: 
X-HE-Tag: 1763316800-500713
X-HE-Meta: U2FsdGVkX1+2ChROLt6Z4z+cpYUGbfmz2fsL8RQel86oTsZhBBv3XXriBKB+uUJou2an6/TtI3XDo/iz0sit3D7qEOkHGQfI3TdB5PrFYdz5OSqwyutVl2gf4/Felr8if83nsdf89mwL1eXJDnkRLuWum8TvFDpI78rlnlmOVVIHROhGqJ+vI1gueoF6qxVUzX1ell+A1//CrwSwet7qCEByHuGCidLH1gKCr6Dr4NVLVcyniz/wcegIu1fixZigwPRoB3NcOk+I5gOicdbIlZooxPgGI25vOst7SQW8awHewUjsaz3S7r+TPkauEgW7TaR4SZN7fhh665NDeGL5xLwqacngWA6+MoQmXs7YYKaWT4LAVZ2ibwasHg0jU2wikaF3297iuMQqipaedGuyvvfdd3UPwovmR6Rwt8E88H18PqqTdWCk0T28V0FZ5S91rgLxptPc7fvkDdXUqInyk/+TScfHnCiLl7I85t81ERzrLkBQvU1+X0U7B8sXSpF66AzyutZBycVovuPIxaWjzeuy/ffWeiQDMB9tYvnLQgIBtw4tjR3jLXSeX8/P0r0h7U0QZY97W9e3kOnhsqhuY6Yc5SN+adfixzk9hm3OR435UyPxE49PXpSK8IMACFNQS0WUbQgeIGGQPov5ijzzi1ZY1Cm/t/F4ZWCrggIGs5qEcpKLcnW+klVsHULi8xF2akakieCF6gel0+eqWQ5x7B2xDvX2tEFghUXak6BO2iQoE5RjT8m72sMFVWDFmk8piupgUt+R6jilZKWMpOEd3567xD4fnQt3HSp78WZY11vTzFL/UBENqPvC3Yi6AeSzSP0VPRlr/2soPLGXkIAduXS8RHw46QzqsCw5gh/KnFS1jDvU3LiSJLc/LHWty2DmXB33Cz45VlKxzxSnTux+X9EkuvXUxHnp/2U9gW0ckIOVPpVQEy5lruevA8Oa8kT8cmUzRCESBIBro7UIzz5
 4fuA4TmO
 g7LjxCgP4bBPgZk6RjioWqxmq11y5CiXr8eqsj9Zga/7kpmbWgJCCsG4ATNGfGvod6sQscT15OXIerCItTcoiFY+JnMMyXhS07e34VhoKlrO3v/BN/bHCbKQsIsFxPfq3v3w45pAnrueslZ+tejuOQNa7DMYGWUXSUsihIJzBDlOOM+BSK3c6KjjfshRr4h3ZdLzH01YpflF+TEcmLuYpB2zhDKgxbvHDCW823dMEoEynnum7HCiKlD9OXewidACqZnY7TuM3fePtsP0mrWEIs9Ix/UCemcxmV/16sFxFESyHOieyuvTYk5Fi4/GSuvS3ojif1y9Bz0Qx02Jv2RwE7YeuGEr1O8iTUCXEkUfvaNQl/EyhlHLYd8vNVLCzte5cY3FNsSRzPsrEOcdtoQ5y047/SrMIa2NDYdaNHOpRZtlMql0/tMqjKOp0iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Remove the "skip if exists" check from commit a65b0e7607ccb ("zswap:
make shrinking memcg-aware"). It was needed because there is a tiny time
window between setting the SWAP_HAS_CACHE bit and actually adding the
folio to the swap cache. If a user is trying to add the folio into the
swap cache but another user was interrupted after setting SWAP_HAS_CACHE
but hasn't added the folio to the swap cache yet, it might lead to a
deadlock.

We have moved the bit setting to the same critical section as adding the
folio, so this is no longer needed. Remove it and clean it up.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  2 +-
 mm/swap_state.c | 27 ++++++++++-----------------
 mm/zswap.c      |  2 +-
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index b5075a1aee04..6777b2ab9d92 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -260,7 +260,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *alloced, bool skip_if_exists);
+				     bool *alloced);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index cc2524e74120..adf6e33263f3 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -447,8 +447,6 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  * @folio: folio to be added.
  * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
  * @charged: if the folio is already charged.
- * @skip_if_exists: if the slot is in a cached state, return NULL.
- *                  This is an old workaround that will be removed shortly.
  *
  * Update the swap_map and add folio as swap cache, typically before swapin.
  * All swap slots covered by the folio must have a non-zero swap count.
@@ -459,8 +457,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  */
 static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  struct folio *folio,
-						  gfp_t gfp, bool charged,
-						  bool skip_if_exists)
+						  gfp_t gfp, bool charged)
 {
 	struct folio *swapcache = NULL;
 	void *shadow;
@@ -480,7 +477,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 		 * might return a folio that is irrelevant to the faulting
 		 * entry because @entry is aligned down. Just return NULL.
 		 */
-		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
+		if (ret != -EEXIST || folio_test_large(folio))
 			goto failed;
 
 		swapcache = swap_cache_get_folio(entry);
@@ -513,8 +510,6 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  * @new_page_allocated: sets true if allocation happened, false otherwise
- * @skip_if_exists: if the slot is a partially cached state, return NULL.
- *                  This is a workaround that would be removed shortly.
  *
  * Allocate a folio in the swap cache for one swap slot, typically before
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
@@ -527,8 +522,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
  */
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 				     struct mempolicy *mpol, pgoff_t ilx,
-				     bool *new_page_allocated,
-				     bool skip_if_exists)
+				     bool *new_page_allocated)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct folio *folio;
@@ -549,8 +543,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
 	if (!folio)
 		return NULL;
 	/* Try add the new folio, returns existing folio or NULL on failure. */
-	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
-					      false, skip_if_exists);
+	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
 	if (result == folio)
 		*new_page_allocated = true;
 	else
@@ -579,7 +572,7 @@ struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
-	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
+	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
 	if (swapcache == folio)
 		swap_read_folio(folio, NULL);
 	return swapcache;
@@ -607,7 +600,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 
 	mpol = get_vma_policy(vma, addr, 0, &ilx);
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	mpol_cond_put(mpol);
 
 	if (page_allocated)
@@ -726,7 +719,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 		/* Ok, do the async read-ahead now */
 		folio = swap_cache_alloc_folio(
 			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
-			&page_allocated, false);
+			&page_allocated);
 		if (!folio)
 			continue;
 		if (page_allocated) {
@@ -744,7 +737,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
@@ -849,7 +842,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 				continue;
 		}
 		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
-						&page_allocated, false);
+					       &page_allocated);
 		if (si)
 			put_swap_device(si);
 		if (!folio)
@@ -871,7 +864,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
-					&page_allocated, false);
+				       &page_allocated);
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
 	return folio;
diff --git a/mm/zswap.c b/mm/zswap.c
index a7a2443912f4..d8a33db9d3cc 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1015,7 +1015,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
-				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
+				       NO_INTERLEAVE_INDEX, &folio_was_allocated);
 	put_swap_device(si);
 	if (!folio)
 		return -ENOMEM;

-- 
2.51.2


