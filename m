Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75AA8C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331916B00AA; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4006B00A2; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074416B00AF; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBB0C6B00A4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59D3B160194
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:34 +0000 (UTC)
X-FDA: 85122551388.08.51CF3A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 210C640005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZlwNopf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252132;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q57cNuPBntlEk850iT5CDstZM9OFj/OzIAZ0ZaA7XiM=;
	b=Juz8JEwlgkkyHWJbau09WUAdEg2dHMNXL/4oNkoETh4qjDzpBfhK3rHWz7rlsMCjReCc7l
	WvQU7cdsRW+ByDyxr2RcXid76DWudLiRyd3mB7Ynpq1Y4iVfqAU4CnPRd+O/+vL07gKuc8
	Hh9bFK/W9YxPG2+1/kuMEJ2I3A5QFvQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZlwNopf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252132;
	b=IOih+OrG9Nj0tXzdNkoJS5pb18MPPOsLwDUYA/T1yXkDV4budRQEfBi+qJ6eB+089HJluA
	Vr4yK1U7uyqSDx9Azeg0/lcqel1HkAkjb6uAXTQOBtDSpJ0y/5KY8TB59dJErGIfVgE7Sk
	yRMW+EvWLWerzMlE9bmr+QUpE65//z8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3D5444EAE;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4FF9C2BCB3;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252129;
	bh=ZdMCHVoFYQCILSgXOuBnI4SarXdsYWmXjvhz54wwgc8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SZlwNopfxk4IoGogIaPtPK2wSYSJT5Nk1lsQ+oncbSqCgXPAd4L9t0kc1ihIJJFiU
	 UYAMmuK15Ts4vB9Ot3E3jBEN4w4rjtAIS/Mm8SDYlSVXXcCqdFnqJPqq3USdR38z6w
	 9No3+7LJ+GPd3Lur6B5MpaKSy+5zb8Xfpbkz05UanPVbE5wM6tRfkkeDCiiF3nZB+z
	 sF3oTFmNFLCkSyNl7XDiTk9H0t0zC/YAhKKPZDNBdQ7MaRu4cH6d10LPUW7gvPLF5F
	 IkeqQeH4pBmiohHazwQnkNVNaOiXONm3Hs80dzp16RNdcU0VxuIlDjDTs50nMW+Es7
	 rWJglXf3BdANw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02EDC5DF89;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:27 +0800
Subject: [PATCH v3 14/18] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-14-9b43f5163238@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=2112;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=inPttDVpThP3IDtiWZmKlScFOY7gDvdR6fwZyskm3d8=;
 b=TTz/tqeNbxw/fhpg7X6kae4SyHT4Bfkz02ieoBqhE+MPrhNF5KdXVm+oJV4VxPohoszYr5X+d
 7fpJSE+ijlEB4vYBXYxpkQUfwNZV6TdWvLt/zwSkULqqVG4rTq6UK8y
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: f33ndds5yw1aayr7fag5uk1naw8eg9aj
X-Rspamd-Queue-Id: 210C640005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787252131-952075
X-HE-Meta: U2FsdGVkX1+eup/4rb2iPHKBO0rNtJpDxtb9jizmf9F6X5Q9X3OOfoBiQK6rOB0uO7tyW8b7OAaAHM5BtFJN+zriX0foOQdKJmeScBTH3TcUzZNHnVLpz1DMoQMWg+P++uSMmp+CZWi+AUadDbLPHDfDsUvRSQgxwFj1ZUiSE3xnJnr8oZ3azxv3MCH16aT1q+qQoLT1LbujUX9FQdKk0xEcbbHE/MdXteyo2mOfEba/46L17Y+UOtCkuYQHsOBdAlKz7cJJ1eMq9HG7VnNuhKSjfV3I9GLkpt1bC1xe6/KF8TQkSfZ7sWiE6RH/ypx0hytMW0qzWuckZfQ92QcBfOdT++U7mZrK14BnxgHROxTdrxMnQQI++uDAXtYaklk8U9Qa2RJ+mG04qxmg56hMEnfbT1XzBEPJc6hLqEvulcE8OYrG4UIaY7nsFttFbcPMKCTL9oSJm/Lj++m4q2BMmN/dTLlXdR7mdMc5vjIsYNKoBf27i2negoNuiiIX0AzaUmqheCM+AzZYeDcMeNqzUWeCbyEyhqkDdoiT/x4rxtUfGvog3vjDMipm2vzjAOiVmIdL8zJ1MvzjkpApgEUnz1bycu5iPrpEiAGXYdcmZtKfi41dkyw9aFzVOJI8sq9GCJjdN4nHRcrPcXZWGtbCKBbTzegMnYEQoY/GbqW2JJ91Ag0BEL/khnvQ4VpBnnnptsR0OaXHZrsFVswqQYMA1T7xXPIDtWp7eZG8t7t1Qa2Ha8Np50kTECw/wdFKUT9c8knaBhl3O4n1VwZgPfb6zSGwMF9xwhu/oZBtEeyHomwO4EN2EYsZEft6iurnElezlJMM4K3OxDmLb4tyDujBluKVRhBd38gmiqk8Y0On11twNWjZEO7HkWLh0h8YMG896b2e+9uNhhPiilHSluIRxowAqUQ0w9ZLc4NFRNoQC2z5c5s9fhmPggQAme9C89QaGSWDPo7D0P7uP54F5TO
 M8x8k+a/
 TR/IFCPdvz4RGGtmi9kgGscGsvPFJfu2ldJoKBYHrv0wV6zZxVpw0vL7FXqOaynS6fKzMKS678wSF0HtzJKMWi/eQH74iC79hloWIBF6/vSY/ZFPWamzzf2ocxHT2E6PpzGi/T0WaxTdn0jMX4ypG85gqEpZAvvHZDqSH1VNue+hrtoJNJXLo/LZGUz4zIfo2iTxcL/Bh5UFirYiqR6rBqwdrmSPiLWyXsHoDS2TzTUUM8qE+m1pCAeVjRyXtP4bogNf9q1MucHVrEocih3Psf8qOpaabgdxxEr77Cja+dnrhRZFrCBQ3EhTxCvpNtBOlU0updZY+DNhxiAt3Jj6GDus044uzj/2LC+1WB5gyTkUvyYhvcGw8MzgM0/lEyXxA0fDGAZ468duW8oyD8vCCN1URtgVKZTSp6otLLR30xnCsG12XQewH9SGLn+R3urZJbLScaxHT2eNo39ooHF4mQed2Huk/SC6YSL+Y
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
index 84c6e4bbaa88..113a33cddace 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4337,14 +4337,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
+		if (is_swapcache && !folio_mapped(new_folio))
+			folio_free_swap(new_folio);
+		folio_unlock(new_folio);
+		folio_put(new_folio);
 	}
 
 out:
@@ -4371,7 +4373,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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



