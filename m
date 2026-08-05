Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57327C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6E16B0098; Wed,  5 Aug 2026 07:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329FE6B0099; Wed,  5 Aug 2026 07:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218286B009B; Wed,  5 Aug 2026 07:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1F336B0098
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:18:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84D9F140468
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:18:57 +0000 (UTC)
X-FDA: 85066968714.28.770EB1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EA1D318000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:18:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLkYj5ZC;
	spf=pass (imf06.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785928735;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=arhx8D5Jluxa94xkx/7MGOoRzeQO4N8YPm9nIJbGa/Q=;
	b=ky5INl2bY8gS9M672mvePavO14phCW/MraavJ05ETNvMBT9inloQa0AKDTJRXZix+INGRM
	0t3eyt2FRQ4z28YhVeULngnuYN2ju7xGVqdi9xo6kU3Q5YJgmqaw2eljl/ps4ZEeFE6o3I
	9fVaeZn84MpKUokVA7AuDC3CZ6wyxGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785928735;
	b=WHX9bKZKWlXcbu9DNGlrkF1bnRG6aza5eeyWN7QQqzJp1vJamSrJSLjgn+EpNSotljtJbL
	ZMHqgddWMKkw7s+y9wcHQqq39I1WBsImGH4sLIT0/4kRvjtZVhp2aj3RQdggPnWZ7L8OlI
	VdehvhYzq/C/Tv+YMUO27DoRtEgk0+U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLkYj5ZC;
	spf=pass (imf06.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56F564574F;
	Wed,  5 Aug 2026 11:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96480C2BCFA;
	Wed,  5 Aug 2026 11:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785928708;
	bh=ty3w0m+qsJ+EdUZ0OVSMoR+uIMa3yGQbVbQdJHySOxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NLkYj5ZCS2eu1VzZ5NrkLjDOHGMSAmZqWjrVLbHr5u05W1pMfRSHQixyGNk67STBG
	 f2Ybhg0qyToeMfOFJYV2LZtpSFmd8w4SEJg1W/pUlqIbrcbJa7c+OozGxL3YE7p23b
	 v9gx3xpArrvMInBP1lYnJ8vCGSvvb3UTMMFp3zNz8FM/tSTc2fcfVo6dUTnFq8mRPy
	 dUHA0pdK6smL+KuamHpHjaWBmEvYtLQHidZMLhJUooQnhsY8N9a22WLtQxdHLnDIpr
	 WGXC/9sZhT51GBCxNGU3jHrXQewsATYscWjgUvtsDJ6tz5eDB7TeABqmRpm623M64H
	 Eeo4YnuS5cU6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801D3C56201;
	Wed,  5 Aug 2026 11:18:28 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Wed, 05 Aug 2026 16:48:24 +0530
Subject: [PATCH 1/3] mm/huge_memory: allow splitting mappingless swapcache
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-b4-mappingless-swapcache-v1-1-b1d78ba257ca@zohomail.in>
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
In-Reply-To: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Nico Pache <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785928706; l=2824;
 i=shivamkalra98@zohomail.in; s=20260402; h=from:subject:message-id;
 bh=8FMzJVK2ktfmBA3br5AL94P4EAWSWFZ1bi19CraqMDc=;
 b=vFVVaOmpFpx2FC4WlxGKq8HT1cGRL2x/naOSV50p6GJ3D5FhoW2agZET2hqyQ2/wsIkR5HfUk
 holeEC7s6tKAc9aKP5Ewd/xKNVTkdHwvi2HoPABOU3FeEYcq5KCwa8d
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=U8kQSxcte8P8iZ6zB7phIj+Yl+i/5ntifBGuclgypx8=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260402
 with auth_id=716
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EA1D318000D
X-Stat-Signature: ufsdcbpmsad9bt4wq5qptxe5us8ecoh4
X-HE-Tag: 1785928727-595164
X-HE-Meta: U2FsdGVkX186cUiT4I7tgLxlmxRe/fuyLpXDnZTsjwlimbwAM2gXJeWDKKlKnnRwfyMaQaa28pFCFZNc6hcLLTi9Dqe8gw/HKv9tKS6GW8GXWVp/gCLpwU8k+wsDhJHRUkFEjzWx85lBSAOKn6LFla5rVvO0kdlr1YLtpcfHwe9fo2duuphRyy8fQZuLY4unuSzGFs3M7R12RXMkFvW88zNZd2er/3FADZNk3SIwu063xV600but2mXUWHrH8q6U9c/J79DLgD4iim6CA2qyHtZFsfA5E7ZHoAmoxbyzfy2l3PQ1cifEhuN9rkTy71RYOPbJX6D3+H7B+OWztFGEp1+RKn34HjkqvuCFWBngwRxnjHH6w1IKxsWB+yYPaIDzre0A926rEyEYdeeFbpm6AsY5OhgcTthDVYelqxLBNFvbMEV392v/FCyAYKNjD2yYe+YH9GyOSysejGc4Aik3djYhG+Z6P/UDZtMQzpd0IK/qUMGzG8MzhlgJUfPUyyNuhmRZTQ92sdx+ueCWVL6RiD/sRIrOJ7fJKBtdpJUHj8Qeymdyu+ctbqki+RqQFoc7Xq+FNjFSGyPieTN5mrqVOGhavSwELUwEUJ9974SVSfil/dtp9Jp2syd3BGlxmPGN8Mon1Odo6cSdSWVZIZVAPuo+hEn8GJHLvO9zqGYzRnyP+IerBbR1J1uXM4BKPmrgcu+6m6ygiWeNts2mMfMvJ4iUBypyjgWvSJ/C3ZKy0ttY7pzKJVLVf7L+MK8kLIQpnQ9zZrpuvWS4xdaqy5vWrnXYEM1vIuoqAvOQDfNTO6Dn0jyjeEBSLfq+M2ttSOyBRKjlChvAdHQFFQV5gV+5e1ztSIaA+zATACAIO9evOybd69RlLo2cIUUb31tQNms1Rxa3v9R+evPH22uPrSaMarkxm9M4/IzLUKTK74ov51vKmRbwEJeWBwMW1nvzqDvUCG2ptys7vovI7JiVz0F
 JdqEqc/n
 z8zUzjgNasm2Mks18ovgenbkMp2WqYilCddyCckk0mD0tjuLl2aMgNwdc7vmJGs1Zc5961ShWNEA3Ajlo0OW+uBrY60CZIxGLkFd4NuRwu/N8rS3aT8dNgYVbyE3/sK+T4oer09rGaflfBfXmnWhID9QFhnTC6ftRbVvs1VIGW3P+kW7hDOe4xAZsEM1ZOV3t6414dJRKTv+/a7I23ogGTzLuLQJhZAMek/pLtrhl/DlFLWUr5Mqns8B8kllMYmeHNHQnjMTC3nvboXImRhRCcRHpwCjaaWDyXfKw3TKEf0T5B4IAhK6CfihCYXWfructwu4Pc01cjVAe3jtDkKg3GbbinqermXDAxnbXDGA4IV88JBl73LsSJLoodtmAC8Y2kkjpUMH6WGXqkX3XTSS4ph+G/Zdo+9ZbbkZE9hsUQ3InyCXNuID8nW1ifpKI0jlpn/9hAvQxzhccae4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

A shmem folio is removed from its page cache when it is written to swap.
While it remains in the swap cache, it has no address_space mapping, so
folio_check_splittable() mistakes it for a truncated folio and rejects the
split with -EBUSY.

Allow a mappingless folio when it is in the swap cache. Initialize the
XArray state without an address-space mapping, then assign the XArray only
for mapped file folios. The split path already replaces each split folio
in the swap cache while holding the swap-cluster lock.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/huge_memory.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 804b8f6aa557..ecfe40b1400b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3882,12 +3882,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
-	 * caller that there was a race.
-	 *
-	 * TODO: this will also currently refuse folios without a mapping in the
-	 * swapcache (shmem or to-be-anon folios).
+	 * caller that there was a race. A mappingless swapcache folio can be
+	 * either shmem or not yet associated with an anon_vma, and is valid.
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !folio_test_swapcache(folio))
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
@@ -4022,10 +4020,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			if (do_lru)
 				lru_add_split_folio(folio, new_folio, lruvec, list);
 
-			/*
-			 * Anonymous folio with swap cache.
-			 * NOTE: shmem in swap cache is not supported yet.
-			 */
+			/* Folio in the swap cache. */
 			if (ci) {
 				__swap_cache_replace_folio(ci, folio, new_folio);
 				continue;
@@ -4103,7 +4098,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, enum split_type split_type)
 {
-	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
+	XA_STATE(xas, NULL, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct mem_cgroup *memcg, *old_memcg;
@@ -4158,11 +4153,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		}
 		anon_vma_lock_write(anon_vma);
 		mapping = NULL;
-	} else {
+	} else if (folio->mapping) {
 		unsigned int min_order;
 		gfp_t gfp;
 
 		mapping = folio->mapping;
+		xas.xa = &mapping->i_pages;
 		min_order = mapping_min_folio_order(mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;

-- 
2.43.0



