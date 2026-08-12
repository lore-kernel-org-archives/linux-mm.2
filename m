Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717F2C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385C56B014A; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310846B0137; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7056B013B; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDF366B0137
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16F5FA0417
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:20 +0000 (UTC)
X-FDA: 85093505280.10.0F58304
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0AE9C140009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uSQ8efAd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560558;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUmNMdCPwSOlvhtIXVapDF1LRnZgD7QH41euZdoxbHk=;
	b=acFqKn5Bxah6AWwZkA5/bII1LaBkuGcXPu4Gj1ZonZ6Z4GfXTRFscOSEeHzX+CxhnOEvlT
	YfZFLDtkudn3k5y7yxIQwOB9vp0jitriCi6zOrqxpBj8lAhEZiOm71ZfWpl4VzGXx9DB6H
	/RwcCzJJml1TPLYzoZ50QK+/52GZf4s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uSQ8efAd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560558;
	b=0J5PfU9q1Gw2jmJLAzaySTGhng5LRz5Mp4RpFGcGX9QTNXhVHIFzoN058uKpBORS1tNz4J
	uDM1/sCL8KitrXgeUU70+FUDXA6Rn4qmPeHFuooF3x9GkTwfuDrkB+ksn9AVMy5QfogRJX
	JYel4CJDKdMefqJfBax1kb4mqWLZ2Ik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9218B45008;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74563C2BCF7;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=VQ4ZoNoJZMPRFqoDbLthhcmmTCF8yiPpVD3DVjYnoC8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uSQ8efAdnnC/f0HcConXgoUbzfARsq08xJ9hH3toFzn24skonWID0nxG7L+yNla3m
	 ZqypZ2uexkFn0pX/KoWasonRJWWSeoogHe0N+SESBrS3s0aTvhLa7kaGYK7bCGhEq/
	 mSXR7FWLD4UzT9u3q2cJ2MFYdbs5MdZ4CftcFrHX+Dq7NLMMiB8CGDiC1IcnSh+1kF
	 0xVsaeh0L4+kRxdYGHvsZ3vqZQOa1lEaH+5POkjGYcW/jnjb5kbov1GtrTWXvbUPuT
	 WyfznjVe5+laSoOB50ajIHc3j4VdM7MMppQoRQYemnF8csURfb9M17J5fBLTdFuRDx
	 FxGajpJ8KlBiQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61BB4C5B56A;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:54 +0800
Subject: [PATCH v2 14/17] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-14-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560551; l=2084;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=J6ngCmgcSfN+77YLugUfoK2XwvgDSIEPy49r2taKtgU=;
 b=nv/FXOxUi/qyiP/D7zcPbetLgXwHnG2qIx3L69T9uE/2GdbdAXy1CbWexYNXJE6N1pJL77bSO
 RL1eMo/YHX4AVDELhD5AfWNEz84D+MRVpx1jgZy4LuqLstBpFrssr4q
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: js69aods39mdzort4s8o5wcq44ghxr6g
X-Rspamd-Queue-Id: 0AE9C140009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786560557-80834
X-HE-Meta: U2FsdGVkX18fgWMXnMDAes/BAl9Pda12e6aHYbyFMu6CjOIecatYOLHnk2hQaJevLumq4V05BkhmbJqkD6R9EIBOugIqwWY6L37Z7IatNljNnRwoy6RNQiZCGZlTIG7h6oXDxAUIiBe514+ItSbVx+oSLw76ZoerJyWxgsiLE6C3BbufUHKXWvS36GBkXgrG0WF1D1K50ZvSt9rv0HxKVrB1l9M3NKlIanGSLPwkVgV/9vfDZd8QExKN50rSSJVywp9qjms/74znjcSlWRS7d6vk8BqmoNTmLXDrN/8L1dvCI3vekvirAVCsdrmrGXOaXhQekwZKB0vI6Kn1+f3zChZr4wbuBM0znkswxwsXBBS1DrixkJpvHAJFr23m4UnGZej3VVS3dATDbvL76csMiqS/5ASMgu16IMAf1QtaksDl0MrAsd6L/8QHE6Gp0KX0w0IUYufWpFU2zPLCRevu8a7SCCm5PrLgHNWSojQPMoFj7SgJMS7/3I1KLzlp1c3UlIvTaB12KQ5Qa3M1L0VnPIa/N0KMoKn2/24WtuKzPYU05MR8/cfx5FbEnRwuwriicgiFHfUqXXHx0oLkUoe9lSOIaOulWkF92xT6festszPL1gbRvIgHeQSf9VprIA1ZAfkZqAxwbcX34/uqNa9SIWL89RDEvnX5XbnNi3mk7j3D8Z4OkTYoAewmJmtmbIzRmBYcy0XqQq9Vo0e5vBLqUyY6J+1jStmGuGrsSuDN8vuzscOBySXJLTbQlleJNQR+HjvppwYKRPSt/i0wyvAcQCF2F9Jm0BwAdOCEunb9mDNRE93thbLRFUw7MLeTVanG6xpjoAgURzuWMGw2iKmizgluo1Cml+sawC9bkb6GXCr/SToCaXBaE0HeB7DLn++5Kc1t4g2K3M3y/y+Jyvr2aGfOrhafo6mcoqi0UWhWCLzy0VCEBdQkaXk9EnyjL5A/elv2tO3JT7cXbptqmpU
 ng9jgJqY
 fYDSGhpGBetjeDEoM2cOMzNQsFKo9FQqRFYhvFXgC7PpFuXifXijsmLdFpOYKvqZ1gCJdtjvEm8fP3u35nFmr8F6yYagIW9r+q9XSX3sfgM+CTanK7rVRaGqTNzhDS8NrcrmF5giC5N0OqVIBlB8qbR3/RjRfW5AZxHRWYyyZnY8ZeA/wST1YbynqXlRLdSLZv972CXEhWOtmj8L9IXi18d7OY9TzY7EB09c5EqgnQiiF5pqogd2z0hTfbJSKqDdJb55igQlRVegohrat0zlUtubY20ACAR5+G+H9UARjG3ICcenrDwT0miiJQJB12A20VH9KnP8W1ptksymT/oEvNe4GY3J5HVlZjFWepriZidzsBIezD/Zq3gwM6Y57ZJLoaFN8XYZKoqupKMirGrvnpVYhfYlmhTO53xRISBiYKrVhav6cgIctWltNCklQUwkn0M+rKhY2tSo37HLJw+0cUxwA4qX8kivIjO/a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
and folio_put() in the after-split loop.  free_folio_and_swap_cache()
unlocks the folio, then free_swap_cache() must trylock it again and
re-check folio_mapped() before freeing the swap cache entries; if the
trylock loses a race, the entries are left behind even though the folio
reference is dropped.  The sub folios are still locked and unmapped
here, so just directly call folio_free_swap() directly under the lock,
unlock and drop the reference.  This makes the swap cache freeing
deterministic and the reference drop explicit.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 72e7d24139e6..503e3bd84cad 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4343,14 +4343,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (new_folio == page_folio(lock_at))
 			continue;
 
-		folio_unlock(new_folio);
 		/*
 		 * Subpages whose mapping has been zapped may be freed
 		 * earlier, but freeing them requires taking the
-		 * lru_lock, so we defer put_page() on tail pages until
+		 * lru_lock, so we defer folio_put() on tail pages until
 		 * after the split completes.
 		 */
-		free_folio_and_swap_cache(new_folio);
+		if (is_swapcache)
+			folio_free_swap(new_folio);
+		folio_unlock(new_folio);
+		folio_put(new_folio);
 	}
 
 out:
@@ -4377,7 +4379,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * isolated from LRU (if applicable)
  *
  * Upon return, the folio is not remapped, split folios are not added to LRU,
- * free_folio_and_swap_cache() is not called, and new folios remain locked.
+ * folio_free_swap() is not called, and new folios remain locked.
  *
  * Return: 0 on success, -EAGAIN if the folio cannot be split (e.g., due to
  *         insufficient reference count or extra pins).

-- 
2.55.0



