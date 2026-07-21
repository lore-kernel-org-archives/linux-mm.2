Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCEFC44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 01:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4756B008C; Mon, 20 Jul 2026 21:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684CC6B0092; Mon, 20 Jul 2026 21:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DCE6B0093; Mon, 20 Jul 2026 21:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32E626B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:34:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 960FE140321
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:34:18 +0000 (UTC)
X-FDA: 85011063396.01.AC6FC49
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3ED4680005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:34:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bw8Mi6dQ;
	spf=pass (imf30.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784597657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ssCjc5RyO4iON0/B4Mm6pQ4p+Fnv9Wcq91/6zrguLIA=;
	b=OWhVkWrGa+8SojzrZyVZdD5k5zHV5Otjf73VWHPUAIkKdtrfH9MiQtF6YFY0rk/OisucXK
	XcMrqCceaK7p8bx/zRhDLfLseRHwvT8eOBtiI7lLe4i8eUIiecSmoV4GLBsVJqiPAGnriI
	VMTkSI2IVsB+ol3Q5n8txTs1oanZMgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784597657;
	b=PGoA9Gv5st2hqzdvHbqevY35UXyH3qWcAuflYLHh6iJamxzJOaoIKPSwFWHIUh63mAAIKg
	pyZijSGv/AFabZ9hyAy0t6vfMzwZlbgG1P3Z+4JB3HaXKGW5ztOc+uVHrZK0wdCJg5c0kM
	tcIHA2ccLPpB9kr/586zKQble5KSgFM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bw8Mi6dQ;
	spf=pass (imf30.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784597652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ssCjc5RyO4iON0/B4Mm6pQ4p+Fnv9Wcq91/6zrguLIA=;
	b=Bw8Mi6dQItJMykB2V4qA0T3ghdDWdAHjVAPr82lCKXtONIdiQg5xRnBKyucW9X5oV++0Kz
	jD5z8z8Li6CFZWs12EviQX77byjbHlaEBuTT1H64vyCmyjIGWfGew5KAzN01RLNukDn3ky
	nG8sQn+WoDqaIcKuRCJDUOYlwq3zBXU=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/memory: use folio lock/ref helpers in do_swap_page
Date: Tue, 21 Jul 2026 09:33:47 +0800
Message-ID: <20260721013347.65698-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3ED4680005
X-Stat-Signature: 671tp3gr9t4z6n7pkswki67te7bfakky
X-Rspam-User: 
X-HE-Tag: 1784597656-498472
X-HE-Meta: U2FsdGVkX1+R5/J75FXiouhzVsqz+OYnMUrNnCzx9b1i4GV+kXfEo+yyWNTNcPXhPEbSTO68QnW5g6rq3itAULnBw6zVeECr4PfeDJ0bc9DTjifBRNHU2i9nHIv4TetsZdukDcmFlJ28WJyCZ0pWwiVO0+PAzkeYNSepGHgwU6WygpwuQl4E6PHxzNCk2pdhmMV0lO9++gKzTBAUIdXONEweTl/fIpHozLi0LiysDLBmbuCC7mR8rlE4Amcum+1EsXknBb9LOIVxhx8ozGDb604cN4p1CB4mnQlPux29ZGyjLfgHLuikwK9cRmEnV4e6INbuHIO3c4RiPwwq36PY1EZYi2SiIkxgfFjKIEmf57wGc0D++WtTcKhRDq7TVJQYy+OsQLi9p8xM2tTHefDJglN4eg3SpgH5YVjav2NKipCIZGP+gD7gLdNkEtbRprIS9Azv28I4aGP0S2xdpofJ/r+fydhr8gbFQE35hHT7CPYyLAB6NeJ8EltaxZD63kjnBe4NsJmvSSOFc13nz0ltO5wsrzxWo4e/4ij4pOkSnH4z3IvHXB6NLAaNBvUkhqIwdW1ru0GZwVHCA8aMmYdUYflM70WBw/+YxWs6pZdEdHzyoTV4CoG81k6SNIIJbXYazL7rqXK3W5pkpW+oY5K/t1M8fu3XItoEurIl7azhMTU8WFP4I3MgBFDRKWch7T+WHgZFIqXeTPMggRdM5JA35h+FgaBEFjzgUozL33eocDq5JDYMb3T3apsULYpLY+3Uw51fFgVpk/t+rfZ1tsaKcvV0F6fYZQrQNW3kyVvdmAvpNIwpXjnr4wuIl82mvVJfQJSO1TqQv/HwqpeiMPQWncweTv/rV44O4JM3PazYxnU0iAfR9Vg+uo2DMj6uJdXdirgHPXjbvumxqqXeICrl0z64T7yElW+fPlTGdR20GzJGhYeKLJaKkUTTbV0ROm7OglNlpmxHrYIyQ+V/lvg
 Yfr5Lafj
 z355YdxhqDP8ZoVruPr/5Bv4n09OrlaqTL3pOGMNE23R8nKSfUJDlAm4CqhYlhhBiR3VL8aXdKj4HRXWv6WzQlBRv4fAf8+l1TKWeM/T0zeLXP7RjtQsetwfOgulwEax1JS6n0VX/EvCf2g/t+14OzpyVEOQjUNn1qQJ8MUhhCyEptSS6E/v4JuZKCcKsHKl/nWtHfzCnhIscavGnVU3TgCsyGVf1Q1qPlCKjeFaowNNnoDBqPEzzZ71Wzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Replace page-level lock/ref operations with their folio equivalents
in the device_private migration path of do_swap_page().

Introduce a local fault_folio to hold page_folio(vmf->page) to avoid
repeated page_folio() invocations.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f692..bd27372a1052 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4852,6 +4852,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			vmf->page = softleaf_to_page(entry);
 			ret = remove_device_exclusive_entry(vmf);
 		} else if (softleaf_is_device_private(entry)) {
+			struct folio *fault_folio;
+
 			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 				/*
 				 * migrate_to_ram is not yet ready to operate
@@ -4863,6 +4865,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			}
 
 			vmf->page = softleaf_to_page(entry);
+			fault_folio = page_folio(vmf->page);
 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 					vmf->address, &vmf->ptl);
 			if (unlikely(!vmf->pte ||
@@ -4874,15 +4877,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			 * Get a page reference while we know the page can't be
 			 * freed.
 			 */
-			if (trylock_page(vmf->page)) {
+			if (folio_trylock(fault_folio)) {
 				struct dev_pagemap *pgmap;
 
-				get_page(vmf->page);
+				folio_get(fault_folio);
 				pte_unmap_unlock(vmf->pte, vmf->ptl);
 				pgmap = page_pgmap(vmf->page);
 				ret = pgmap->ops->migrate_to_ram(vmf);
-				unlock_page(vmf->page);
-				put_page(vmf->page);
+				folio_unlock(fault_folio);
+				folio_put(fault_folio);
 			} else {
 				pte_unmap(vmf->pte);
 				softleaf_entry_wait_on_locked(entry, vmf->ptl);
-- 
2.54.0


