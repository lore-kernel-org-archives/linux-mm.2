Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69EBFC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF6E6B013B; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E585C6B0158; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FE56B015D; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB3F6B013B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA13FA03FD
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:20 +0000 (UTC)
X-FDA: 85093505280.07.94E63B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 066D520005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i6pGYHAM;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560559;
	b=g8t1rsqmTZmQgbY4HFuJHS5WLFSuSunsbkKbGtyX+rIVE9l/54Z7JU1DwQ06tnNC0GZELo
	AHyv0ApQiv3DYK1mBB/wx7C5OGWbyS6APmEe6OzPyGjxiVvDYUS3pyXPAtY0K7D1gIPOcw
	DyIzCA7+xDncLJ/iOC5cRp9yNNlG8cQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i6pGYHAM;
	spf=pass (imf31.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560559;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFZAJZ+mfiQ6+mH8YNQDWJ44CQ7uLWaChaYrg/UdB/0=;
	b=XXmFiQLsHkj7ihcaM+5vzvRujy2PCXY0fpSD5HcxfIVIyrhDHnKzMvTbhgXLoARMntF2+b
	v0l4lxWVFAhBbk1U1HBEcP/2/jTPIip399FKqDYpR/2T5zo4+EPTJ7falrlILty4XPq0YK
	Zm/1kbI7OA1XCNSO1u96F2u7kqxLXbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B398343F01;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 961DFC2BCFB;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=dbNw8olNiA7PcXPkEC0v/OBVaIweQIwkkGj4cgBBAxU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=i6pGYHAMayR3Dh+K+OrmMvtsL/NqvZLIDElgb2IwqG+t0bPiBFEjU9dNGceWVWRWM
	 5oOcRzAZK4R6mi4E7l+6ZcGc/sIk8ugTN/sksI8zQVVsKZk8DTh/RsrXynjlhqnKXw
	 gvm1h2DIabdpDwX38NWDM52tuTsxdzinqZCEdWxOYb6d3eM/h0nAYL653ViMsC68Dn
	 f9gDC8Jj+0BLT9KBDHg2P3lI2xYoU/5DKZDLnCl6untu1lmFhM+sOs/Dl7UgGZ6cV8
	 HXmR2q1Xf7stlVjVWK7sr9DddKrYbsJ2mxMtPXAqQlQlxFlPXV0nYtvwQluGEVsKGb
	 8s5Uga6Z9ToVw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A16C5DF64;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:56 +0800
Subject: [PATCH v2 16/17] mm/huge_memory: clarify supported split orders in
 comment
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-16-d2ee48c6aa49@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560551; l=1942;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MHV5HzFK6Fi4cPV8SFNP30qZtKhPmUDpBG5x8ElzA/A=;
 b=ghP6fLeoLxLoroMH0xcm5w5WQj8k6/m3y+SZvLRMFwxVcxjdFYirWizt0zQPbmWw57lhiicW0
 5cVPzTHsKKrClDHF0+q3wVSo93k9BPwBjQ61TTQufmua/1apoI5yAB0
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 066D520005
X-Stat-Signature: gk7bshi5ew77wnui193zaomdc7zxza1f
X-HE-Tag: 1786560558-308331
X-HE-Meta: U2FsdGVkX19i1TYpjkUdH6b79nv9rmZuxvqJVpRoAR+vAo4FbKsePytWMd2xlf7r3Q3h42V0oUZd4iKzBJer1xjBB+Ow4jlizVKJ7lx8IK8qD660qz8mt9CGCyZ7KP4brzF4TsOVjfbSjLJ+Yz8uzMwcFbNZlLqlImox8JKu/WNTXFk6+16o+X6tUitmnTqz6hJ6v7FCigaU6EF08IuLXVK3dAz6iszx0bHD2h/C2fBQLZqwKmipa3efzhfapLp+CU8w/9NuKqSP9sLdG7OvxdNR+Wa3+kcM1hg9AmE5g1Bo/ZRdtRZEBdn8IDgjH96w8sAfALN0ok/DS5JvwLxa1bDomprRgGGRjvOIOKIi4yrwNfVFs4tAx7amOnqUxRLJtpVdgIiJwizne2saI8xLkR/7hlSC33k1cB4IFvrfhRUyQhteWSuJtjhO1NC6KngM8OfkhGwM7LjuN0xRE2j5TSfpGmjE1Gg+3QlTOjMpFewCv3KW83LRuXZKrT9fc20GWPzABELvwm3uUjfA5jyA6ptgVKWP0payp+T9h+MDzJu3blLo9SUmcVgf4lpdcqMVS+jry8vXjWzCjjDDFYRlWNdxDdv7UW8AyJNobMV5rPy3Eq07l/BIcCl9j4LaeqyFtjPUCkETT7yZrpe9Cs7xLCvesXe19JiGgjsu0UZQ6FvI4aSwU+DCSWZCcxFoA+a3frKQoN0G1gfU6bCLYFGZNzWM6sOAptxaj18/aEJPWVXNNyupVWuN6s39eWdbF3uVlApbNC9VoVGeZkyrVVBcilcP/cQW2qyTTiylQ5JygzOmiAYojIuyYN3Ig+EtzbW6xdfMUzynMGNUvcnI/m/k5akqFKAU3UzgyHdgXvqGYtBUH43g6LWWm8A9GaaQDzJ9/lQdTmAtYcnHDC4iGvUowQZ98NgS3jnyo5WQePC9B5/tL1zGVBdn0ym+yuyDvoehbNpAR29mwQkgVwwygZw
 mgizYpWS
 lvyrygK5j+cIx3aDBdZpX7yHZ5C6IAvuk0z0Bh2w3lIVczNG3RLIY7HpnF6mRmBr7qj1DY0Ti82g6tC3aDJEOlnvBn9wsJeSj8kWO3gcuRF2YDJ3LHOAzNrGZsvLrmvcqr3F8uhGaLVzGFU2xj23kmkbky9V39dsTMysFT3bepDl5QvxuzCWNOEzQSnhnPY9rvnpIfVAKHvYaup+M77PGmUIijeK1gfceDudzNWUoEHrlVttFIsHBo1McoFk7KpXeyp+/6qAeB7jo2beLY2cbxl+x9fPs0DE3226s9PEUTezpL6mIwcnBTNZGaV3hFEgmTc1utLuzTrVNlvnRcS7rNPpP8X7JLAy7HnRWBwKLp0//rpxY37i1HT+k31/EvG+NFqedopyT1VQ3IDNTHM4mxISUY3EcSl3bXI/+vG6uwSUtYE65roP1VJDICsUKPPbMiTvuI7MpXJFhLmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The doc comment for __split_huge_page_to_list_to_order() needs an
update: only order 1 is rejected for anon and swapcache folios,
matching the new_order == 1 check in folio_check_splittable().

Also realign the continuation line of the function signature while at
it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 317e5b63d44b..c8ec12f6f471 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4406,11 +4406,10 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
  *    GUP pins, will result in the folio not getting split; instead, the caller
  *    will receive an -EAGAIN.
  *
- * 4) @new_order > 1, usually. Order-1 is not supported for anon or swapcache
- *    folios: anon folios need subpage 2 for _deferred_list, which order-1
- *    folios lack, and a swapcache folio may become anon once faulted in.
- *    File-backed order-1 folios are supported, since they do not use
- *    _deferred_list.
+ * 4) @new_order != 1 for anon or swapcache. Anon folios need subpage 2 for
+ *    _deferred_list, which order-1 folios lack, and a swapcache folio may
+ *    become anon once faulted in. File-backed order-1 folios are supported,
+ *    since they do not use _deferred_list.
  *
  * After splitting, the caller's folio reference will be transferred to @page,
  * resulting in a raised refcount of @page after this call. The other pages may
@@ -4438,7 +4437,7 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+				       unsigned int new_order)
 {
 	struct folio *folio = page_folio(page);
 

-- 
2.55.0



