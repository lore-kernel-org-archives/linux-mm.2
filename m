Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E97DC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703506B00A1; Thu, 20 Aug 2026 14:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4416B00A2; Thu, 20 Aug 2026 14:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F12E6B00A3; Thu, 20 Aug 2026 14:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26AAD6B00A1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD378A029E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:32 +0000 (UTC)
X-FDA: 85122551304.01.71E6E13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C10CF20007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LKIyxWIm;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252130;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTTMsfeRtdT1cMeNKQHBuIkCN+iOzL46sfOmDeX2CEk=;
	b=r9xIqsjDVKwvDPqqPmoxlYU7yyQf1gHuLIgywCWlcEp8pSKHLMWC3sdXYi5TjbjR5kYxOP
	2IZA49zdV+pq+2LVs4BDB2uo9VF8Yd05d2ZkgoUK/5VUMrD2bMKgdhR4laHkwmxVcIYLeA
	Eg4F42i01Bi8cNv3AFupA/8rKO002yQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LKIyxWIm;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252130;
	b=lGZrrE8TUH+DI3m8qtXmJ8w6l29r5e6Sb2Esl6bZ0wgdX9/ajDDu6HwkFyc3CJzVcGuA16
	159NUWP7WtRfO8u7Beot+xHG/oaIddSiNJbCCleVesiO9hIgnzu/sFpvnxD2W3ad7/eyDJ
	nOVd8bA+TC1rJS/WwQcM2lzHDU0eeHE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5959460A7B;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F38E3C2BCC7;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252130;
	bh=ya21pIxQSsux3BlG3ZskOAeG3L0c/ADEJFGxjEU1tt4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LKIyxWImlc2IcOOlxch9s/7zFW9lEp5rgR0mu2ye+Cky5ByyonJwK68+lV1wamnyW
	 Z/ueTo+9MZ/4JCX1rQz6TnUIBnZR8o+HQOh9Y7aTc4ROmRTwSNhGSEA1IHMDdlL2WJ
	 BdJqFI2FI6CbWwZPm086VksDdqG1jRQrlUjEHUhpHZYLBnNp3UirIsisZQrklKbVmt
	 Ibe/Akj08kwkVjp6JcjCRD/kaXTYNycm9dnfsBDNtgWtz4tRTrYDwU4kfmSRW8Mh8c
	 l3LUQY5sUz9D/VyglViS5xYZ7n/uxN0hwQYketPlIF4wUDp5zB+qJrdSc6ZKDF1qBn
	 oHL4w3d6t8CsA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE71FC5DF86;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:28 +0800
Subject: [PATCH v3 15/18] mm/huge_memory: lift order-0 restriction for
 swapcache split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-15-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=4239;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Ck/sQwhNsEW7aOrpnl5OtjvomBAG/W4r8DcOvIJa0P4=;
 b=KLUkvjpHuIejSkFjYK0HMSbyzjaxKoIAJ+uo9IzE7hImYJ+OOK35RtL0A1PuF+MuXjplnbn8O
 wCoG1pOHgkgBZikpmNMeb57klT4fItMH6zmloALB+tQjIjeQVp8zy+z
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C10CF20007
X-Stat-Signature: 7rqx7r7yz8i1nds7tb5txkdgw4hf1zua
X-Rspam-User: 
X-HE-Tag: 1787252130-158057
X-HE-Meta: U2FsdGVkX1/HNbIx6QGcxlCs2wQtM0c1sCMGHXZ7OutyH5MYBdfwjG6RO8g2ozJELM7BIY9ahoHYHD/FALTTXgFgZB6k9MvPkxcZ8r1fF1q6atPZ0w8EQNdAL3YPe8Ej6Im+A76bVG5L6zyVGigU/gTvwrXicoq3jKD81jwYK9/BTlEsDKtSxWa4HbGS12jNB4CufRBO+8BhNHhx/Gv5rnenru42uFINE++yy9egW5pmGu4E0lM2e3DEzT5lLgc+NuwSWxwqqqULSkGA82LaOhWs9XBMznc2PZuS82Yljkx1T3b6ITlbHo5/80xW3yH1aar4nTra0ShTWJpxaCl0EWnVb3+6iEkwQYW4rBh5uBMKBa5KBNvAPQOiNAwa5EbduGaJhJDMoP3Wa+lz7q9K8XGuW27UKDX+7HAIKVp8Niielh/6z97NQFs7RDwARDXta8BdGV7b102fDuxxfhmcjHP+MYcJGRexfIdbmT8q1N5P9knvCVNWrfJjjlCREOaizo88wrIxBtLrse9spO/i+mh6WLOB5re2aZg3RlJs6hUisKTjoFWdsNsDhpFFd3kvGt79ttzJlyRx0C0ArJVZAq9N/gZgTD/bLt7WGEsOYOrzTWF0QaIVrEEJDiSB7zJhXLCFrEXWACT06OopbwXTLNI8TJ56qP5jf5ovC4wM3pRMrhMQ1CI2zp2q2WvnVc6/98AIyMqbiufR6fAONdsJshWrwRBQX2k9iSmep8WMVwfIc26G4UAJ2qZSAwC3Dw8jfiGHUR379JlEVKI/reQzxOBa3Ach8W2uuqcwnFwCM9xoY80KuzzcjgH1+aVRKmTeYQJ2g2ERaaq5qfXvTYVr7gVe/+bOZI1OMT38zib9xDPTFpyRTN5kHz8CXHEI9f280Nh6/aKcYtVZ39VqYf7vrJnQ7UWW9b1PPXgM+gujBY5FPgplJNmQRUX/pixabXArr8wxM8yqp0YuKZo/b+C
 2gy9Tqb2
 9i6Bo4ObQ1/fv5yakIa1OjhLD5lBxnIyHfa5O8OnFcczlCOyojqAKLPBgcKB2WgcAB20KH84LoOTXPqbZE17+tALmv57YbsbwRF5pmTXKYUBHH9btWE97e/QeITpl+FACIj3pj3OM15ay+B3bWHZt8+sMli7VLdNq7b523XJ8O+lpkUk8ij6W+UryfM0CelfFNrT7Ab65hHP84zub+2wjpVa45Km4Kxiu6XIasYKd0Msh05pJpCwUcKfPb8iB0dA3vk3jQ7yeWGc8jhm9jXddC0VcAHci79CFPS74v4Wm6NNvxXt8XYYg6Qa4Q289V1TYG1X6yIf+pI+nbqoEOS8F1d1PUuN1eVEf/ni22JwdqSsDaT3Nu/tcPpEI/IZwV3xV+KoLzXmeQcXjTeRSWRCeyEotb3XJbQsbjZrtv8peOvfda+3sRpjlPWwj+jfLEaOPopda72sZT3L4NpGxKgDxoEAois2X5dtraJGL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The restriction that swapcache folios can only be uniformly split to
order 0 dates back to when the swap cache was managed via address_space
mapping (swap_address_space).  The old split loop only created order-0
sub-folios with a fixed stride, so non-uniform split and non-zero order
were rightfully blocked.

After the swap cache switched to swap table under a cluster lock,
__swap_cache_replace_folio already gained the ability to replace any
number of entries for any sub-folio size in one cluster, and the old
swap_address_space locking and limit was removed. The restriction
became obsolete but persisted through multiple refactorings.

Drop it now: swapcache folios can be split to any supported order with
either uniform or non-uniform split, except order-1 which is not
supported for anon folios. Mappingless swap cache folios could be either
anon or shmem, so for now we just simply forbid order-1 for all swapcache.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 113a33cddace..06f353f937d1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3797,6 +3797,7 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct address_space *mapping, enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
 	struct folio *old_folio = folio;
@@ -3811,8 +3812,8 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 	     split_order--) {
 		int nr_new_folios = 1UL << (old_order - split_order);
 
-		/* order-1 anonymous folio is not supported */
-		if (is_anon && split_order == 1)
+		/* order-1 anonymous or swapcache folio is not supported */
+		if ((is_anon || is_swapcache) && split_order == 1)
 			continue;
 
 		if (mapping) {
@@ -3887,19 +3888,13 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (!folio->mapping && !is_swapcache)
 		return -EBUSY;
 
-	/* order-1 is not supported for anonymous THP. */
-	if (is_anon && new_order == 1)
-		return -EINVAL;
-
 	/*
-	 * swapcache folio could only be split to order 0
-	 *
-	 * non-uniform split creates after-split folios with orders from
-	 * folio_order(folio) - 1 to new_order, making it not suitable for any
-	 * swapcache folio split. Only uniform split to order-0 can be used
-	 * here.
+	 * Order-1 is unsupported: anon folios need subpage 2 for the
+	 * deferred split list, hybrid shmem & swap cache folios are not
+	 * splittable, and a splittable mappingless swap cache folio could
+	 * be either anon or shmem, which we cannot tell apart.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
+	if ((is_anon || is_swapcache) && new_order == 1)
 		return -EINVAL;
 
 	if (is_huge_zero_folio(folio))
@@ -4405,11 +4400,11 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
  *    GUP pins, will result in the folio not getting split; instead, the caller
  *    will receive an -EAGAIN.
  *
- * 4) @new_order > 1, usually. Splitting to order-1 anonymous folios is not
- *    supported for non-file-backed folios, because folio->_deferred_list, which
- *    is used by partially mapped folios, is stored in subpage 2, but an order-1
- *    folio only has subpages 0 and 1. File-backed order-1 folios are supported,
- *    since they do not use _deferred_list.
+ * 4) @new_order > 1, usually. Order-1 is not supported for anon or swapcache
+ *    folios: anon folios need subpage 2 for _deferred_list, which order-1
+ *    folios lack, and a swapcache folio may become anon once faulted in.
+ *    File-backed order-1 folios are supported, since they do not use
+ *    _deferred_list.
  *
  * After splitting, the caller's folio reference will be transferred to @page,
  * resulting in a raised refcount of @page after this call. The other pages may

-- 
2.55.0



