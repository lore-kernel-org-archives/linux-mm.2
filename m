Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61D71112242
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 23:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AC06B0088; Wed,  1 Apr 2026 19:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004236B0089; Wed,  1 Apr 2026 19:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E066B008A; Wed,  1 Apr 2026 19:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCF9E6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:20:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 676F71601C6
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:20:02 +0000 (UTC)
X-FDA: 84611557044.28.8B1C4E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA9AE40005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:20:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TMkszWqQ;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775085600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsgicZcWks38AVRzt1F4N8P1z1WNcHUeTYQviXNMbpU=;
	b=sEHNOfRBQOaG5lWKVFvCb2ZBytVpjGOaF8XtOyTUq4jjR1du7KGO2EdYZhklyuF6O2eEsn
	520a7wNSm7GEOyRymBqkIS6IZ1U4xvss7vjbALdK2gFIMGeLhoqHvxrLBxF9+GY+5VT1BI
	GZWHPQEuVraphDrAAeuQubHMXc0QGOI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TMkszWqQ;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775085600; a=rsa-sha256;
	cv=none;
	b=DHKDEwzXhsw+wVlu6cDsQzBJkhpoQAFOpjUoZn9EYFtsU5/7s0w/iCaY8noZNC601SopkU
	xb6Z3DOHO1BlXGUW7Nef+b20e+9PCcVZ+Wu0TGHxJBBTM7vTqL1tZbnCaA5Na2/PzNSX4A
	m6I5NDVEDId7uI1ShQN/6S/nE0gYjNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A4B9600CB;
	Wed,  1 Apr 2026 23:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26513C4CEF7;
	Wed,  1 Apr 2026 23:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775085599;
	bh=tE1I6QqGm0tUZMScDuiyoHJK4m2GtY03FdDFEhbLMBY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TMkszWqQ7EaxmW4yhB5tGTUs1Tu1rc9aZVXZf/+1lHc2CQMdR/Sj2aa5QxfsWKMek
	 q8cphQkovBOxKE2l+OpHWdUv4ypVBEJazmcOs28A8oWpZiCKQZuo+CP9I48bHJr5//
	 FuuUX/5PKBn69LPTQbyXt1dHX7yLJXElk7f72hws=
Date: Wed, 1 Apr 2026 16:19:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, richard.weiyang@gmail.com, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kartikey406@gmail.com,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm: fix deferred split queue races
 during migration
Message-Id: <20260401161958.38ab50f44e7629e6475d3eca@linux-foundation.org>
In-Reply-To: <FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com>
References: <20260401131032.13011-1-lance.yang@linux.dev>
	<C4A8301D-C76B-430B-A6A6-8B642B80FE2E@nvidia.com>
	<FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA9AE40005
X-Stat-Signature: 4m7yh3nqbs144zx5eumzxw95qgun7kjg
X-Rspamd-Server: rspam06
X-HE-Tag: 1775085600-198327
X-HE-Meta: U2FsdGVkX1/uVJH2Lo3b4dWCegWnq8p25JpIDXssuRadWej0Q43V1OAdAH9hH6dnTShR1yqcZk2+79mWTUhz/JlTwIEsVqyF/Fiq0yZL5DxWTSDTFxQ/B3lKJz/cq7s6gfNptmLoEXj3uEgHrvbKsDo/zq7exB1KKBtdvYIMv4vR4S2h3HRvOIaJzrUukpSf5ie/jYS7HLdliuP7uPqCgVP3cEUTwJhD3GvjGpEiy8P3PnkekDZNeMlx9WVry0n7xZaQf0HnpnQRhhIhloODwxWCPz2v0Wi3a2nYBv+gzZyp1H9KTxw4DKzdO/kX3CRnMr7MoIuk7I0kTwsSFe24DOajl0uf5JGW3IUJpBiTL4rmg7rlg2R5w+xsa0tU8ogoAfoUc6thD/bHNtdxjHlNH8SEKXx0UiPtQZbTJdIHBW/lO8BEcgUJyzngYP5zoMSu8dSc9+FHZwS7CylX92ov8M+cxMpL6CIvokwBLOvEN3eU1TSxPxSi93U5u06Oq4JdYh9L9dcXCrt4ThaMSoY7gxOeVBgDf/bV1AagJnRsa2Pulq6pXaXonldzHYfk3aN6tCaUI+9FCgoFRu3ewaEl7Ia2HqdxzFkbbaJKKWKTVLekr5P916Lcf16jEf4vsaJ/pMN5uHOtXPDgNEBmH4EwVb7MU4TbA4shsa+NLVRXefaAUgKCj/hcLip+hxEAfMJ8erkOUtZjesyLLU2wSzOq3YhclW6pFMP3FLBk+jYYZBiGBFR4pHfEdQg/nfKJt+cV7n80MMhGruD1d//vweMo+LVoC8yYLRuDfxV4BUruER0gnMHWDHotQYq+Li6vWrC3HKpZhB3HtC3MrANdZ/edXTo9fT65/sZ9otyC2o2SqsSSkHdO1dgHUBL+ntHOTwZVRT3q5RzzxvrqeGmpwtjHvv3cEFI0CnD7jjyLXMxU/c3HGIWstruo0s/JTVxtLVrA3DKTwvNUwDWUIT4+cT0
 1AkRkxM7
 7uZ0zUjp2cHxu6D07ytXW+/Zt1JUWoFU5f4cwPSfpSEneVwXOpgE6Ea+TlNeiAyyygViMdRvk4S2cQ0kPZLMny1GHOM8AhKE3J65z9CIVjTIy+B63WHP2ByC7qwMzeRh2JRm8iLiYUkLY1kKc024bsCwhmdkObQtGl9fmbDPqnr/LSGcv4Euep4v9YWrIG42HGwjuj1YI+14t8S7/lAisnbaGSUE+KsHnnA2flIm6jJtZBuweP3Rim01yQ4HAtaR47Y4htW6XVmC1cQLXhnas21z1sXtenKtgNQKAmznZDzqxOVOZO9lYqK+YLu4TEoZEv9oEqajduQuZn1XlfOiXMoPOUWmor8oMlwqfW/6iPLQ1vhbRfiYBPjEadfl5KaYLRAO0UIbN6yG15bPbT6TmPq2IYuntBQ7YjsYQjs4duFXPiOSMOJVB9BqD9urX8ojuSbc28CMUrg/0zMh6IiweZtBjH0aJBjzo7DM8HDiRM469LgboDdETflTpiICsSMDMgIxgjLjdvkgQ9zM0bGCtqC/ADFL0JrIbRiIF2ktFLgZvcaAHYgT6EmXTyuzw9xO79QvTn0TYXuf3g1cMXtC3rH5KcowmfQ8HmZoWNnbqki1MrNKNtpyQsJICm0P05nVZAwc/E/UkON6NJQMCF1iJLiejXZ+yCvBpXWgXd3EFDM5QExnvBbVrlZByase2QcOe4dACi0Z7RnqZaWM8WfW9piWdLFGSKYDROCpHqs26BQBr+FdJktoMZCuErczVM3UFHj3ZoMwMkhO1OZLe++Z99UTOv9jRhYbtt6H/kCK5xA8rBWtt2xKCkU/ddKHenKb9Dn2eNEzbMDEZDy03+THtJe7VHZ/g/l7q/QFQgWZlZ6CqQHyZxVOjUYIjgODmEqCkQPSv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 01 Apr 2026 18:55:48 -0400 Zi Yan <ziy@nvidia.com> wrote:

> Can you apply the fixup below to move the comment? Lance told me he
> would be away for a while, so he could not send a fixup to move
> the comment.

Thanks.  I folded that into Lance's base patch so here's the whole
thing:



From: Lance Yang <lance.yang@linux.dev>
Subject: mm: fix deferred split queue races during migration
Date: Wed, 1 Apr 2026 21:10:32 +0800

migrate_folio_move() records the deferred split queue state from src and
replays it on dst.  Replaying it after remove_migration_ptes(src, dst, 0)
makes dst visible before it is requeued, so a concurrent rmap-removal path
can mark dst partially mapped and trip the WARN in deferred_split_folio().

Move the requeue before remove_migration_ptes() so dst is back on the
deferred split queue before it becomes visible again.

Because migration still holds dst locked at that point, teach
deferred_split_scan() to requeue a folio when folio_trylock() fails. 
Otherwise a fully mapped underused folio can be dequeued by the shrinker
and silently lost from split_queue.

[ziy@nvidia.com: move the comment]
  Link: https://lkml.kernel.org/r/FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com
Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
Link: https://lkml.kernel.org/r/20260401131032.13011-1-lance.yang@linux.dev
Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 ++++++++++-----
 mm/migrate.c     |   18 +++++++++---------
 2 files changed, 19 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-fix-deferred-split-queue-races-during-migration
+++ a/mm/huge_memory.c
@@ -4542,7 +4542,7 @@ retry:
 				goto next;
 		}
 		if (!folio_trylock(folio))
-			goto next;
+			goto requeue;
 		if (!split_folio(folio)) {
 			did_split = true;
 			if (underused)
@@ -4551,13 +4551,18 @@ retry:
 		}
 		folio_unlock(folio);
 next:
+		/*
+		 * If thp_underused() returns false, or if split_folio()
+		 * succeeds, or if split_folio() fails in the case it was
+		 * underused, then consider it used and don't add it back to
+		 * split_queue.
+		 */
 		if (did_split || !folio_test_partially_mapped(folio))
 			continue;
+requeue:
 		/*
-		 * Only add back to the queue if folio is partially mapped.
-		 * If thp_underused returns false, or if split_folio fails
-		 * in the case it was underused, then consider it used and
-		 * don't add it back to split_queue.
+		 * Add back partially mapped folios, or underused folios that
+		 * we could not lock this round.
 		 */
 		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
 		if (list_empty(&folio->_deferred_list)) {
--- a/mm/migrate.c~mm-fix-deferred-split-queue-races-during-migration
+++ a/mm/migrate.c
@@ -1384,6 +1384,15 @@ static int migrate_folio_move(free_folio
 		goto out;
 
 	/*
+	 * Requeue the destination folio on the deferred split queue if
+	 * the source was on the queue.  The source is unqueued in
+	 * __folio_migrate_mapping(), so we recorded the state from
+	 * before move_to_new_folio().
+	 */
+	if (src_deferred_split)
+		deferred_split_folio(dst, src_partially_mapped);
+
+	/*
 	 * When successful, push dst to LRU immediately: so that if it
 	 * turns out to be an mlocked page, remove_migration_ptes() will
 	 * automatically build up the correct dst->mlock_count for it.
@@ -1399,15 +1408,6 @@ static int migrate_folio_move(free_folio
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
-	/*
-	 * Requeue the destination folio on the deferred split queue if
-	 * the source was on the queue.  The source is unqueued in
-	 * __folio_migrate_mapping(), so we recorded the state from
-	 * before move_to_new_folio().
-	 */
-	if (src_deferred_split)
-		deferred_split_folio(dst, src_partially_mapped);
-
 out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);
_


