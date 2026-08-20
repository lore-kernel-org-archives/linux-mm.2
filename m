Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0229C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667D26B00A2; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640186B00AD; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9916B00A2; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0161D6B00AC
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D7391A0292
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:34 +0000 (UTC)
X-FDA: 85122551388.20.CB46C5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 93A761C0007
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bfX1Qk9G;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252132;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/KYZFfKpD3qHwsE4Um8oGG3KPpRR+E7i1tnF4P7szc=;
	b=1AdyinT/cNDOtAAyzEikeVFPDM8NBlwa2UkOxdRDOo89YnEisIcbTwvlyb5DLJ+MVkCfp3
	V9BpDZvnS/RFBAJS8dKuV/tH6PuP2yp9otm1LJgSgeI+ii6moJCeVpsulL1K8DzTnndb3Q
	bMA03EW/wVpH6KVSV3g53z001Sbhj5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252132;
	b=BbMWvtJf3fFs73y7lV3TV+VA5aVCyzEs9nrx9GMNPuG85DvgT/paSjTBxUPPf6JFSlOC28
	WLRNhsSDX0M4NZ+nn4E4fsittITr2rcuOsMS354/Zj5VYdQSvEiMyBImytf9zzvGDJGmk4
	Y41mAXW5X0RJAbuZGSY9BARugcpHo3k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bfX1Qk9G;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CB6744F1C;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DB38C2BCFA;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252130;
	bh=D+uYtmzqMh1Chmlc5Iro9Bjk9B5bgnOe9YSwa3oEhv0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bfX1Qk9GSn5/3hzJsqKe5TXcVumqiTi0WOTOzHH0z7h6YBwO03NbIod7U7xRh3tSm
	 v56cgtj3YmQhgRyIx/5/LrCv5XYYS0nRS4yTzBBhAM0kfbtbvhWAgm/bnta/teokOP
	 w0J1t1Q0Y/B5UrZ3KlJLqQksarvZawVL8UoquUk0pvPHxie7GtK7AlyTVvTAN3ap6k
	 BKQtN1HLJ60enlMz/sovC/ZCGDnQ8YsSx6VdDFkN00R+yh3bU/FtsD19y2dtdbW8/g
	 7fwyEUtutCBqnDBGVqDJDK7xMAw+ux3i0CModc6J7V8CAdgI33rPyO88lWUOtsgmV3
	 oDUtp9JOkhwcA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024DCC5DF85;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:29 +0800
Subject: [PATCH v3 16/18] mm/huge_memory: clarify supported split orders in
 comment
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-16-9b43f5163238@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=1942;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ZOm4Nz3i3imY6j3a4YN28Ig3P8X8i5gtRVzey97AJz8=;
 b=VqkQiDNbmac/QvX+JvB+ToITPSitcf/coH2/Q8btONl7ekAFpAv0q6SURT2xGF1l7wRaMsQaw
 piVlB5Tca96AdnZuEGUjx9Nf/H4NFkwBG2eOAsTRk3q+rJ8cN0rBGAx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: af996z8zwg5zbwatsy8caxk95n51boiy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 93A761C0007
X-HE-Tag: 1787252132-36905
X-HE-Meta: U2FsdGVkX1+zQV0wAjHHlFzhUyz1VtcBj0xp+itXXGVufbtjlRMSja6J1zkv5m1fZiU+Htl0N82P8A6wVx4ThgHGdSbv1Fx0XhMtbSKrjdtRX28GJir4FI7XDtyQ6OVusjT6KiCOCE39RaADPNU81BWy7Kr85jq7pjP7t2i7XSgeSP0bJnESIffqIJHpe9OzSV2RoEk4LfzydVoJwnuU5QWiBWz1drZVn3qscLb4p5qhpVI22ZsFlH6YTOLR6HVQKDSoYHd3zZeC++gFyddOFYrv9SMy7lOpASGjzeQ1WHUHcjp5jhXcoE7qu9Iw4p3dSgSmJEBYMY5ER3D7auKhoWtHi8C5Z3BxJ3YlQExRBaAGc+4TJw7k7swXRr0pQtXMQ4sW+G58x404lL39Xnjb2b0KXi8nNr03OdYDp0Qmbs14/1MH8z2EQ9A35wqeIRipPZLDDbwWz02O8wZOs+hgb13RnWOo//phVUhBELKR0Y2J/8qZwCrJt/GqtBHv6kHr2O9plSUctbVwLtMb5Wy0Uc3lgwfd+og1WldWReV3GDtYRYrU8+Huza8IippzvufG5Ta3RerSrAQI0DZmPPNjlMy7wv3UG1Ry9/ZR+qmH7/KfecjC99cOq/hFZJdaELREB94+VG4qXYFOcrugIOSWbUG/Se04quSBjSVx0V1fZldBxhGzyVSiQRB/citBmX/WA2gYWZFWWIp7ntEt4rKY2Yrn4TwFIjsNV1YUSOY9Mrv08r7/OuJ5qx241TaddqK1Y5N06eRtSdGhs6IHLQk0/w7lfxdTn4CBrnBMenrMmkwjoecHHuH1R3tCYrPdS5ysOiH8915lvkftK/09WOT9vmdvBULkymmU5N23Ccuqgtw2z15P689JcKPO57rXjU2toR3llcX3p4szlUaas1AkbxXowlBcwGl80OuI2zLUkLLyPV0LLRvuzQ5eEuFDhsSwzY8dG1d+zqMMCxz+Uvt
 YqolTgVH
 CZ2dBHbruaYlwK9R74NIm5ZSBhZnZ78tI0+AEgFRu7HAlOLrHi7woLw3LO3LmmNbUjbsCZWfxigMVpOGPrF5JSJmc82zDtajVT5ocjrP8AdvI5WbhBsYpE0QYEaOMQt9EEl+7vCxz2BmeIWCcRLDdV2I8tl1EuJd77Rn5fqQHxO3n02EiK30EXQ8galfPUbnQwdU8ArRzkDWSb0irJRgxJMbuSojvsIzDFcDeZTlZbBwpmClr0dANKV0L6goDecCsr1AvQvpdKWZX6BzUMeB7ycgXJ7xWi/O3dLya+9FLyZ0uQoBhH4uFSbM5YPX+1cZ8IWwa3ZICSdYfgo2q/EFM4RHWRHQZz8jGLGIdWpUjqHUh3BgD3XUCdrIHFLttj00PAQykgG9a2BvpYkiWzMKns3y6ltfjaow6PF/e6JWvyDTSnoVXQL2usqp5/sEe2YZeja8YLG+xB1R9+9E=
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
index 06f353f937d1..0a971ca48151 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4400,11 +4400,10 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
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
@@ -4432,7 +4431,7 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+				       unsigned int new_order)
 {
 	struct folio *folio = page_folio(page);
 

-- 
2.55.0



