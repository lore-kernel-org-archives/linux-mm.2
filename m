Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC4AEC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23196B0093; Tue, 22 Sep 2026 22:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FADE6B0095; Tue, 22 Sep 2026 22:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937F06B0096; Tue, 22 Sep 2026 22:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64EEE6B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:06:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42FCEA06BF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:06:03 +0000 (UTC)
X-FDA: 85243386606.29.5D7CBFB
Received: from mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0C43140004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:06:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="f/0cdyLu";
	spf=pass (imf11.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.107 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790129161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irSD7WjgOYLBk17OQ4TUlaqUTRnGrxB+iu/WUNxKdNc=;
	b=ML3hWqWlchq22A6AixGS8Eyu0JCO6ChTc3dDFXnNYPqdsHhXJrGMImFUaWQHmWtZhS+3oS
	HybnP3QenvqKs6pe2GQ2L3ZN6LNGX+YOZNH2vVr/LVJX7lAPRZxhuYm4wlNojKiNo0T7in
	tO7GSxC9phZQ/d8DmYivPv5LmZY0rT0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="f/0cdyLu";
	spf=pass (imf11.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.107 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790129161;
	b=GR5WFzwWu110TAusJaLJ53ZILygAIKgENma98B+JE5hjsEGQvU4oURlWmtjKLvBD6QLhDG
	Vfich1zy7y90qqtUIY+zy2vLK124zX1pfIebdRXxR3ScGKC0wEkCSxh6k6IpseYuozLPu3
	/xUmluloui2bxGd9/TCy/S/zVnt21ac=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aoPVRLxrPlybDGOf83dbhyu8QddYp2j5TWPxs6wBNtY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790129159; v=1; x=1790733959;
 b=f/0cdyLukEQbsWLnrKukNEVVKVvjggtnAevgEMhHpeZ9D5sXbRO3DnMFGL/OgxVnXgIBa1ey
 g7IOjtG0bAq2Td6fqdtx4ZPmGmOon6K3vdyyZiAy/J2Fb8+mWBIhsJ10BMJ9p+DliDgvMb2aePT
 lHDkHXsv54Lz+oonbK5XkK7g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6ba19cbf58ee3a51;
	Wed, 23 Sep 2026 02:05:59 +0000
X-Mizu-Trace-ID: 6ba19cbf58ee3a51
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Wed, 23 Sep 2026 10:05:15 +0800
Subject: [PATCH v2 1/2] mm/hugetlb: account migration target folio in
 per-node NR_HUGETLB vmstat
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-for-hugetlb_state3-v2-1-e8a36245bfab@kylinos.cn>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
In-Reply-To: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: hongfu.li@linux.dev, Chris Down <chris@chrisdown.name>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790129144; l=3398;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=hXC+tx4GVm4EpdooEXfm8U4IGYo4XIxQaYt9Zm+Q5C4=;
 b=kG89fQSsfZPkZFrzZC8Xzjc44NNawhKI9hCnKQZ/QPjilZlfVLnsiEmBhYE8BfraxqNxICGa5
 6qVieM5YhGlDOWVhEg6crzKggJjGJCTSnS4bviDruMGHk9ZtmFo/aSC
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C43140004
X-Stat-Signature: x9yx393uphxadt3zoh8oftgamwaapuwk
X-Rspam-User: 
X-HE-Tag: 1790129160-588824
X-HE-Meta: U2FsdGVkX18NgRBzT6wvnLs9Hwa17f/akR9EwlT56VmYK3s2PJBR2Kvv4sw13kEsXFmLbPn6FvkhnvdVMGT+yDVe6FylHGb20fvmgUV0oFMPbzMR2tyXu5DuAevKYK2lv8p2WqxMDQrEw8edrrsXnwwyudjvmBXmPrzGnqyyocuIM66Ipjk1nzODcmOgCT4ZNtD2RVE5DLUStldE5VH6QRYGP8zLp1tviRMILHptZyf1ArccypOrj0FLZ9gyYTOLsqubn4pmjIFF7LHDimLlhPVt6pn9vl6eV7UB0VuKUjmunOlK0D1/XmaLVyWxqsuo4r0NFM7psxnMCWXsJWUCohYORYUL+wp+3NzT/1BEHI/WWFqdV/cancEFt4posmzBEXqssMsvpn++4GWOmTEN5+MyJ+VJnNChMAIA35nuWx2GX/twBb1SLZ+J09GCSsLL9VyhE6hSipy8jzN1V95l1sJF5wrySTOsCeGZkDssSh49CQHi/vcOET/Plrq6x9E0H+alAdiwibDJpzg22zIaOPqbD2cuLjr7ZyL/wEQpxTroT+uW5V/wgbl51BKn60YYmwq3Dc1f684jG+F95mj0bpmeKKaQ1nthLoqfMov04hFNuwQI2t5y6zF1KvkQGlC7Sn2zf3POXXT/FZqSw1qvjKjzKHXgDpUQkieYqiHBe7qvPMGaCNLSayRMSwn1INnJuBAKw12PtQRzzexqH1PkUBOqWxRbhiiAaD1qb1jMWSpxr1X7KV/jH8mVBT1Saa6vB3GuPZICTexAGYAy4/7cQTuJQzC5jDAChFZniH0v22Fgeg4wq/0NmJKWccSeAHR48bCOrGuuhLWRcAHxb+tRt/KEb7z0z1OXb4cDOq7qtVyxYeVeaIJajfl6XtOIjSoxWZqmTAKluTENJt3BvI13V+ds4GC3U5XsILubxea0HYLteQkI0BfQVCYfM2yiwcvIYansfkhlyIwo3bttBaF
 qpN7lOQ5
 SB9PyWyDv7Tfb/3xwP8o46tStXRhZ90Zfzzgs7NHggN6Cns9dTl2BmSJOLuFxSq9By2qsU7aBEM+uIafYcltae7x8hxZpm777XCevB6LFBZUYfSeXxGgHpwlq5+VZG8OzmqvfKFCMY2xOm+QKfQ+4Qse/5ihcQ3elm4llqcMQJfnqRd+tMWkM2NB33SM2vqvQm3OXJVISfLCKB0BHeoJAw8iCmU6peiDNx9bhgVF21sDuyd6n/zo8QpT3BmN2+2B5YM8X+VxHZRiqK4CeX3j7ly5MYrshJbs0V2PKMu4PetDBPpAbacA+f+cr71oZDNWbdUNVzj39YhtErvrywXyDEQ8c1qyZqe5vQTu/PCpavlxFbLqC193QGqYixQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
when a huge page is handed to a user via hugetlb_alloc_folio() and
decremented when it is returned to the pool via free_huge_folio().

A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
hugetlb_alloc_folio(), so it is never accounted, while its free always
is. For a migration target this means the target node gets no matching
increment for the decrement on the old node, so the global nr_hugetlb in
/proc/vmstat drops by nr_pages for each migration. The same asymmetry
affects the failed migration path, which frees the target again right
away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
same helper.

alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
folios, has the same asymmetry: the folio is handed to a user without
being accounted, while its free is accounted through free_huge_folio().

Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
decrement in free_huge_folio(): a successful migration hands the folio
to a user, a failed one frees it again.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Cc: stable@vger.kernel.org
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 mm/hugetlb.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da980377d353..519c30b338a8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2206,6 +2206,11 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB,
+				      folio_nr_pages(folio));
+
 	return folio;
 }
 
@@ -2213,24 +2218,30 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask, bool allow_alloc_fallback)
 {
-	spin_lock_irq(&hugetlb_lock);
-	if (available_huge_pages(h)) {
-		struct folio *folio;
+	struct folio *folio = NULL;
 
+	spin_lock_irq(&hugetlb_lock);
+	if (available_huge_pages(h))
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 						preferred_nid, nmask);
-		if (folio) {
-			spin_unlock_irq(&hugetlb_lock);
-			return folio;
-		}
-	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	/* We cannot fallback to other nodes, as we could break the per-node pool. */
-	if (!allow_alloc_fallback)
-		gfp_mask |= __GFP_THISNODE;
+	if (!folio) {
+		/*
+		 * We cannot fallback to other nodes, as we could break the
+		 * per-node pool.
+		 */
+		if (!allow_alloc_fallback)
+			gfp_mask |= __GFP_THISNODE;
 
-	return alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid, nmask);
+		folio = alloc_migrate_hugetlb_folio(h, gfp_mask, preferred_nid,
+						    nmask);
+	}
+
+	if (folio)
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
+
+	return folio;
 }
 
 static nodemask_t *policy_mbind_nodemask(gfp_t gfp)

-- 
2.54.0


