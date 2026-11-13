Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85719606A884
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E415J04L
Received: by kanga.kvack.org (Postfix)
	id E35E46B05C1; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A5C6B05C6; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B72276B05C6; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAEF6B05C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C278D1601C3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:40 +0000 (UTC)
X-FDA: 85431380160.14.5AECCFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B02AC1A000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E415J04L;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794605198;
	b=X+DWchzZ06BFWtKDRyipiYSSXXU1loBC02AB2NfbLP1T4epuBk6p28Lg4duT1VUIAoOKHL
	DQRWNW3QzbHMIs+c2Lqqs5R1IJxiYuxYCc623fjKH98VhfSZREumE1BFINWNgAHx3zNAIU
	m95FWirfPdZe8dEM7E5zISZg4/h8NVU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E415J04L;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605198;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kokV8MS4AjrbJUsUnghTwivEJWo8w3o73pC0J7zlkMY=;
	b=mwSDPc2lgfScmztPFrVyovBv7GiNspEanyYyCv7Ks8mDAfPYCUlPLZEOOiE0jOIcewLOGr
	/ftfFiSvPoE1yj4B+hvBOxXKLs/bRIocdIZoMCJ/ptTxtvnBpI3J17MzXV0Ok7FZSZxvyz
	Ga9hLnIkmOMl1gFbdE8pP076YgZLgK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E93F634A0;
	Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794605197;
	b=ZL2sVI7by+7MVTCzsdERDO2ZKkHOv1V2PTur+m0VUIqr05JwdiWkNe8NRXvyayIKt3JH
	 cOA8e9JhDKRkS0TPgPoNy0pN8yQ1IuP4MW8TVZ/qaOK+d5jI6/9KW55KaQUgMvMvC5yYZ
	 Eh8hV9NcRp4nQu0jfKQF1OM9qbVrtUbKqzdpi2aIRt5cFqxVeYcLgsfIRDUcxOLCB+ORp
	 epJwU9iAPEgAt0W1FO9SvsaPWcn7qmG3qtMSettBxsFrMkdbgZpdMJCvqcM74BxmyiRLD
	 LBHac+UfqT3rMeYxMtSXkzLVOtUc7iMvvaPZquiJ1HpihrgcsF0YSs5mTOqFQpeOD/A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794605197;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kokV8MS4AjrbJUsUnghTwivEJWo8w3o73pC0J7zlkMY=;
	b=mTr7IqNlewzAcfEzuuxxBukH5NoSkw7Y7qaGCt9bIBIYG81RWzmt4XrUtjI9j3GkbFmF
	 BhuxERdIdkRsgtN0ToH2I9EkSFiMzhk/zPp1yMzTjyqwErLonS1FU7OgVjcDx40sfOWjp
	 R6EnGqepqS5xlwF0tDr1x/9kN+NCcagKOiK5tpD2ema7Jx8Oqig0wuYs/70Lrs1wjCerY
	 /4ttaYthdOCVruDRhyxLy3xBHB9TQXXbF+GaG91KXaRyOe0lo7CwgA5vrASAfL0H4tNXV
	 H+qzE6d7BmHfuRZZZdYAeFXGIANC6F3v9MDQHnVYbkrDk3Su9ZDi/MABWr5x4cTiX5g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A65C81F000C8;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605197;
	bh=kokV8MS4AjrbJUsUnghTwivEJWo8w3o73pC0J7zlkMY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=E415J04LlZDvoI6xl5huyQggf0Rv1QEvHLMMszaW6J59t4x67esJQDaqiEP58YQ/x
	 sgYMlz/rVjYdWK3rrphtVcqP4V4I/g5EORG4SEI8YTq0Vm/y5VczUFr5OGHGBBOa50
	 OypNkqhMJMFm9m3zv9csiAlJD+16Wv2y8k2T6hA2YXpiKtimpQsAMu2bgLZoaxtB5F
	 /l1rbP5TRpwK0LdprAGshhscYwC9WbmZVTFTYwwPjAu0Fun71f5heccJ8+Z5wY3UAR
	 LpEKVRMdqbHOIiBWBwHIzCJeA9hvcTzLkvabhdQpTtHPTiu/XIqpuFpWI5rd5X/rh1
	 yiI11LGBh09fw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3181449B1E;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 14 Nov 2026 05:26:20 +0800
Subject: [PATCH RFC 4/8] mm/huge_memory: walk the after-split file folios
 in reverse order
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-swap-thp-split-v1-4-dfa8d4fa448d@tencent.com>
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
In-Reply-To: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794605194; l=4209;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=5RcEb+SDUe2Odh3xMkEh76RLv2cvnpFfdB3Sf/OMRkM=;
 b=SpVjGzS1NGVb8J1ELrgC77295ZiYjOgl2efqf5zi8EtFc672KCE7Kk65kpazdOgAQfDUTkuo+
 P6SDBWUz2HcBQrZZvr6HWVIPvnE27x83Wsb5L3gxtYagCMSe9e5cFsA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B02AC1A000C
X-Stat-Signature: rmuewa3yx3wg3mzdcnza4xf98q6dtq9s
X-Rspam-User: 
X-HE-Tag: 1794605198-753585
X-HE-Meta: U2FsdGVkX19yGW28a0r/GxGoLKv0+E6nEDulJJ1mQIcZkETQYcSxl3Fvd7auqSuTfpCkOXvnNEGiFwFTiV490Yc2B6i261alowmvsRs7OnDAlCAnZWyfyfCTOU7Z/p07cwFkCZpSDKs3rakaONSA7A3gdGC+S1a5EpnxAIkMAxIIiwr/uFw0BGCp/rxwbIlJjwTcsgvNR6wADX1mqjWknuB8k6JBmPs+3LvV96oNvK+w7U8UhgRAHQ0OOn7LjkQ7/MshQPtfCJBaFlN3pR25XmaovIkkIF+o2dqlBneab3pOGeR8QPd0GU2gkDBN0hGnbS1/xgyqhwayDZmTxpYZWK4fKggSFgJ71JOg+UEYzEtwm/2xAqUceTXJZ6XUSlyYZp3J+/ldh5Zbn26ytR35Da7JeBW1UpbRTYK4VT4zC/LXs/gdiGlr7TuidRC8j7NRwmiE7tPzJ4bBNBs9ui2SLxIpj/sJPwV8DK9YwO7ZDxzCiqcJ2dI9vR0uC8sF5fbcxVCnxn1xclrFEUf9/hTgemVBjspzIdmypXTyIirSRQWDPrxlJ5QvS1UPBTBoQvmxUtR8v0Fwmmwl5C1glpuIbIctvy6qxsuiSu6e7192wG7oVIPaV4Rtk92fVf0U0DbtdxbYi5f5fH7W7Br8gNRjA67+l1GEHFwcha86pkyQXbv6aHhCNIu9ZiVmMCxGLPuFAbHanTMXzNaRS7C7c0IWVVDUPXg/HUeyxc2mXVqpHXyK7ZyKDjlAL1+qnLNbpEc8IVzYB2Euizh5eRPkRRrY/7kdw6cZHhe5IuQcyQzFfZN58M86Wnq/rUaQDk6Q2EGvz0wHxfk5vAPXNmBQ4TFFID68AzsEZMtrcKusgmU34jbae3GMWdOBqYDzFwwZQPUpJ5caJVe0jJcFUY64yUNAngkuK3BqREW2WqcuLicbcLwtr49AKdNlag1jkOjFDwS680lUaUnMWxWVCnnduwb
 9WccGCQL
 H2123Sz9IdupcWbGfn5cfY51XLiKPewNihVk9VBz0xCzVZx9YpMXU3Duz3Nrk7UJlqNiMI0o6fXfLkc1K4oZjdX8zG19wD0BCh1GCkmxRLw8fajpd/FVa1ESkRIcwI2lKUdde/LLVXIEWhe6wX4ZeySZXQ7owogb0/LwVCvdySMOWMS/FGtQY2rXIgF4RGgESMD3TJLJDYSriiJ+Su4HKbvU+fhqCps+Pm6bzRMNBr5+9K1xkmkXpCEEnNYHsypR3012+S1/SYjZKbBpKkYLeZiI95iz1iu0OB/q1Y6YoRS6SRmASJMa2LqQ+M9n4ixuLO4TTZJjNZAg4knzpa5YYJoBRrcjzd0HZ+ecvj2Dbdr9N/6hVr3TwQEuAx9eaNIpEzLIbQb2XyZAhBQ6KVWGpuZMe5qbt+Bdjs4//Wp7MMq6nwxyOFtEI1sBz8AO/0Urp1RQ2FAdEhednKe3KlRC+gkDjlTFEJ7uhkYBHgn4LCee0EyvasdM9Dpus1TLnPrKGIK6xGDVVwbN8AwsKNCjunvA7XpJJdpHZZ8JAmgRo5XKpRjrkYnx6jnG2xIfzv59Qcpdv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Use the new folio_prev() to walk the after-split range backwards. The
@folio is still unfrozen after the loop, so it remains the last folio to
be unfrozen and stays frozen until every page cache entry that used
to point at it has been repointed to an after-split folio.

This improves the code in two ways: A local variable is saved, and this
is also the order the LRU wants.  lru_add_split_folio() inserts each
sub-folio with list_add_tail(), just before @folio on the LRU, or at
the tail of @list. The LRU is drained from the tail, so with the
reverse walk, @folio goes first, then next to it is the
first sub folio, and the pieces are reclaimed in ascending order, where
the forward walk left them descending which is not the correct order.

And even if the folio is isolated, almost all split callers drain the
list from the tail (lru_to_folio() is head->prev). With s1
.. s4 the four sub-folios in ascending address order and @folio
holding the first pages of the range, we have:

  For a folio on the LRU (list == NULL), reading head to tail:

  Before (forward): [ .. s1 s2 s3 s4 folio ]  reclaimed: folio s4 s3 s2 s1
  After  (reverse): [ .. s4 s3 s2 s1 folio ]  reclaimed: folio s1 s2 s3 s4

  For a folio the caller isolated off the LRU, reading head to tail:

  Before (forward): [ .. s1 s2 s3 s4 ]        consumed: s4 s3 s2 s1
  After  (reverse): [ .. s4 s3 s2 s1 ]        consumed: s1 s2 s3 s4

Migration is the one @list user that walks its list from the head; that
list is only a work queue and the order carries no meaning there. We may
unify that part too if needed.

The effect is not very measurable in real workloads but we can get it
right while reducing stack usage, so let's do that.

This also helps avoid a for loop pitfall mentioned by Zi Yan [1]:
folio_next() needs the folio it is given to stay alive until the
increment, folio_prev() does not.  So the cached next pointer and its
comment can go.

The anon helper still walks forward, and will be converted separately.

Link: https://lore.kernel.org/r/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b60fd73fe35c..3d3a82a03149 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4187,7 +4187,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	struct mem_cgroup *memcg, *old_memcg;
-	struct folio *new_folio, *next;
+	struct folio *new_folio;
 	int nr_shmem_dropped = 0;
 	unsigned int min_order;
 	struct lruvec *lruvec;
@@ -4273,20 +4273,19 @@ static int __folio_freeze_split_file(struct folio *folio,
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas, split_type);
 
 	/*
-	 * Unfreeze after-split folios and put them back to the right
-	 * list. @folio should be kept frozen until page cache
-	 * entries are updated with all the other after-split folios
-	 * to prevent others seeing stale page cache entries.
-	 * As a result, new_folio starts from the next folio of
-	 * @folio.
+	 * Unfreeze the after-split folios and put them back on the right
+	 * list, walking the range in reverse so @folio is unfrozen last.
+	 * It stays frozen until then, so a parallel lookup cannot
+	 * folio_try_get() @folio and see a stale page cache entry.
+	 *
+	 * Reverse is also the reclaim order: sub-folios are inserted right
+	 * before @folio, or at the end of @list, and the LRU is drained
+	 * from the tail, so the last one added goes first.
 	 */
-	for (new_folio = folio_next(folio); new_folio != end_folio;
-	     new_folio = next) {
+	for (new_folio = folio_prev(end_folio); new_folio != folio;
+	     new_folio = folio_prev(new_folio)) {
 		unsigned long nr_pages = folio_nr_pages(new_folio);
 
-		/* compute next before the folio can be freed below */
-		next = folio_next(new_folio);
-
 		folio_ref_unfreeze(new_folio, nr_pages + 1);
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 

-- 
2.56.1



