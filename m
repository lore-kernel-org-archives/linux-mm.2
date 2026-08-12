Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B29C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130426B00DB; Wed, 12 Aug 2026 08:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0396B00DC; Wed, 12 Aug 2026 08:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10636B00E0; Wed, 12 Aug 2026 08:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB2EA6B00DB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:22:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44D2EA0352
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:22:46 +0000 (UTC)
X-FDA: 85092531132.26.E2FD823
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 424FC14000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:22:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zro8QyHG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537364;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=O8oMuFGY/RWc1R/6w9PRBui77J3o7xvI9nYea/XZIDc=;
	b=ifLyfBZLIZ32PUlz56rBKGsb+hlgOF5I/YHjra8p7UQ9zdbNGn+qOfXcdRM28XyD6LmI37
	zzP5zWPNqb2xWm+kbw+IIm2YLhlJkkx2j5v0n7EguA09hyYBP6x64nckO4rHncypPnZb+e
	JpkAZUg78rVNvoyVkJTcRG1olwK9oGg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zro8QyHG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537364;
	b=tbxaw3GYkq8WkWCNaoFiQYgmT6/YaDbDbUh+1NoZ1LUGKC6Xtw3cbAEACTZIF4ZPcpmzey
	j+PX3IP209yaGqcAl+Y9MUf7mYeRm+qxDUtGpFr05mb0kc+UZNZH4ARAhOsSrJPXQdZhM4
	Kuz3qln1HG9vrpFbwzl7tWezVQBTZpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70F8641FCF;
	Wed, 12 Aug 2026 12:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47E49C2BCB9;
	Wed, 12 Aug 2026 12:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786537363;
	bh=HVMwfutLbBsXXsWHnvBGp5CQQGmqwVQauY//gtIYMoA=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=Zro8QyHG1rL9hLX9SlK+QAEPmnlsQ9gx0NqL3b8vV0srMjDN7EbRE7fInubO/n6Vj
	 bcuub0Y4Mtj/hspw70BeQuak2r0pKCSHwBfkFlB+MR4d1xftmdnKGhDIxEro+eLAWd
	 4hB1f7Z7W/dJ1xl1NQFzfwW7mewOKUPiQV4DIO2so9LFIxwMVJWTl/HxRv1yOe/fYX
	 s4vR3xQVkTEt1oj1QFETbZa4dC7YWq2AFb+i1E4k96DHY/ldY9lFCpgwU+oe6qJXxG
	 saEPnqHyZJTBZOA0LFnRDvzfSkNgBImvIEiA6jTLqa+gZ/WK5tKRazehQUUJwR9+aA
	 Dv4gQvQvksXzQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B98C5B572;
	Wed, 12 Aug 2026 12:22:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 12 Aug 2026 20:22:39 +0800
Subject: [PATCH v2] mm/mglru: fix and remove redundant unevictable folio
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNwQ6CMBBEf4Xs2TXdQrTx5H8YDtAuUoXWtIVoC
 P9uwbPHN5l5s0DkYDnCpVgg8Gyj9S6DPBSg+8bdGa3JDFLIk1BEON6HMOE4eP3Ezr5RCqM6ZSp
 VnRvIq1fgHO/GW/3jOLUP1mnTbI3exuTDZ7+caev9t8+EhKqVpSQjmEx5Tew0u3TUfoR6Xdcvh
 zMrX8IAAAA=
X-Change-ID: 20260811-mglru-mlock-fix-20d8f8d4847a
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Oleksandr Natalenko <oleksandr@natalenko.name>, 
 Suleiman Souhlal <suleiman@google.com>, 
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, 
 Yu Zhao <yuzhao@google.com>, Steven Barrett <steven@liquorix.net>, 
 Brian Geffon <bgeffon@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786537360; l=4125;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=U29orzKk9D7il/dD5NUP46H8cRaJscTJfBNkl8jXS24=;
 b=glwH4HIia2IpuIdS3x5BsJrnJb+xJ61O2JdxsyE/WYO1gAglTuMnQhrPr7sy7LM1selJb22QA
 PMDF4R6eoApDe9EvRBQIRyjTjJ52/SV8EO0iUoQSgJdMLIxLo6cHncu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: ne7ez3qteyzcsbsqtmodak8z58xfprm3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 424FC14000C
X-HE-Tag: 1786537364-42918
X-HE-Meta: U2FsdGVkX18UKBtlkOkz3I7I7vNux7tN86GsI7qHrmdxSrliHhb2SNN7F4iNF7z8DFsFEQZyeVydr6KHdRpMur9l84ILfyMgfiK9TOtj9HCLGXxWCj8FE+83di8W58A34AKvp31+gQJ12ODYaJlAc3hDN/TbBvq/RXcM5a+pqH6xPsQKyCAVsRwUObhsSDH8bUmL4Osv3Exzwk4677MzP1ubyZAI7D4TQNHySuQWGbVGta/xBxbS7caYbLptZ1jrYauTsyE+0dV1+wFqZmnvy/PTmpgpB/NnH8QzC4Ez8Duw9vXpLqqr/gr1FsFsxejEzMswWrzSN9SZS42J+vmScqxh3DKcHABZYuH9e8ph/KBIo7y2YUKJUQw4AlhdJ/tZICIwvWSjU5At4hd/KBNMtXFLVQkOTX8Qj/5FgFkwaDjgLaY8SFONOZRJGu+fI50o6B9KqS/1xQnAVXPDU6B2iSY0fpEfYUJzWChHZlV6eD/vMhf3tab+Oa/i4zBraFl/H8K77QeSoCds0QMorwgq1jmCQcAsTubNld6VzlloOigSYP3joBpPcCBqqGrFUZcllkXZOasIwZOu7hgftn524UCvbeTkxV8qlWNK9PR7ReFmejbwhDwZTkot+PPlCWgwPFjO7APRE1NgVMK+xfUDnjc+4ObnKbcbX+IJdbQ0/E42/FKveOTnscBfSoIG9v2sPaTJTjaBncT2Opr8xu8e+QeofTuHeu0cLDm9ye2gJSQJ+mDKLYzzKRNKC+PPpzcWOuI3TTIFx88pZTOlnacjxZOTNj05ENEC7kKMHJK18cQZKdEC0eJhqROGzY/Eh2A2hgRcqgOJ3iX9KD6xJ2nlAibBRZL1O4OLzMf9t2RQNT/lrx9/4Q4UsUPIQl14+OM22MWNOqtJoEMFvkn4ksG0k1WMN4nRv/RKjq4yO48RMG4wYHIHtBVoPm7lLhLHd3yLmIVbEM+NnSG7wbncij4
 pRhh+QVs
 vjbQdc0p8/Dqu/VIR0rSgqJhDier0DkGlRtSEMhcGUpLdX+442y3AqcjO1pmWWFIPhRWDBGdIfbgyXryReZwbRpVLYIEgYWjrGqmEjeDpl072gIrKaQorqBoz0Fbsrc3U8VAnhIGwFPMwtwRr2KktclmspmEgByv0n817Allvw4/dFt5RQP2XjmTFjmfsg0R21uAx7BiJkwJzyGUHP8jzeVX/LnF7QcT6alPZMMvERp0NhuWV2d7ARC76FbmAkGaadN/TEJvBoi5DIw4eGQYzJHo9LbaPsOv55fQ1SXd90s0n6XrDO3fu4mUrg0GtWR12CbV5jEBfGY2xV0TeoQryw9FESUOtFVdlE4mnLuiYuidVr28zX2+m34xu87/atpFG7wJ4wN0zzxoaA/dUqlc0qzmbz8D2yCwDK32lf5oEiPID0qEHnBpG50M1QbD1f1WaTblQ0xlH0GoHnPtFyk2BanlJxeptGEZlKCKgqE/Ygl6HV3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

sort_folio() has a shortcut for moving folios that are no longer
evictable but are still sitting on a generation list.  However, this
shortcut is buggy.  It does not follow the PG_lru usage convention,
and it has a more serious issue.

Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
folio->lru can be reused to hold folio->mlock_count (see the comment in
lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
and every other place that turns a folio unevictable initialises
mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
__mlock_new_folio() set it to !!folio_test_mlocked(folio).
sort_folio() sets nothing, and the lru_gen_del_folio() right above it
may have already poisoned folio->lru via list_del(), so mlock_count
ends up aliasing LIST_POISON2, which reads as 0x122, i.e. 290.  The
result is user visible.  On munlock, __munlock_folio() decrements that
bogus count, finds it still non-zero and bails out before clearing
PG_mlocked, so the folio remains unevictable and the Mlocked
accounting stays inflated until the folio is freed.

The shortcut also touches the LRU flags in the wrong order.  It calls
lru_gen_del_folio() while PG_lru is still set, so a concurrent
folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can
succeed on a folio that has already been taken off the generation list,
which may lead to unexpected behavior.

So fix it by isolating them as common folios and letting the generic
shrink path cull them. This matches the classical LRU behavior, and
there should be no visible effect on the generic eviction or isolation
behavior.

There is no performance concern either, such a folio goes through this
once, and then it is off the generation lists for good.

Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v2:
- Proactively bypass MGLRU pid protection and lazy promotion to avoid
  hot unevcitable folios staying on list for a long time.
- Link to v1: https://patch.msgid.link/20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com
---
 mm/vmscan.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3194da7dcc79..ca2b926520ea 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4648,7 +4648,6 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
 		       int tier_idx)
 {
-	bool success;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4660,15 +4659,9 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
 
-	/* unevictable */
-	if (!folio_evictable(folio)) {
-		success = lru_gen_del_folio(lruvec, folio, true);
-		VM_WARN_ON_ONCE_FOLIO(!success, folio);
-		folio_set_unevictable(folio);
-		lruvec_add_folio(lruvec, folio);
-		__count_vm_events(UNEVICTABLE_PGCULLED, delta);
-		return true;
-	}
+	/* unevictable: let it through and the generic path will cull it */
+	if (!folio_evictable(folio))
+		return false;
 
 	/* promoted */
 	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
@@ -4921,11 +4914,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
-		if (!folio_evictable(folio)) {
-			list_del(&folio->lru);
-			folio_putback_lru(folio);
+		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
+		if (!folio_evictable(folio))
 			continue;
-		}
 
 		/* retry folios that may have missed folio_rotate_reclaimable() */
 		if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&

---
base-commit: 1029098ee3275ea5b78e329ce132262affa2f8cc
change-id: 20260811-mglru-mlock-fix-20d8f8d4847a

Best regards,
--  
Kairui Song <kasong@tencent.com>



