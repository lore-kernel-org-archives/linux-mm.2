Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB26C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1D46B00C5; Mon, 21 Sep 2026 05:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A4D6B00DB; Mon, 21 Sep 2026 05:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6996B00DD; Mon, 21 Sep 2026 05:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7C0E6B00C5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:13:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8CDAA05B3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:13:13 +0000 (UTC)
X-FDA: 85237205466.25.2E4481D
Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id B23ABA0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:13:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Miis2Cv4;
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789981992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGOdCj+LTnPCfp1jiuD7yU1wZsLnQT8pKvJYACmVeR0=;
	b=sEwcs5htDWSVVuX06GwuBcWy0IjDAmfznxfaxwq9AXUQag0foToUTxzlo7eSkgkdav0egW
	99ioqhYKYvNYlDHHQ12guidWMMcGrNjJXJPDNLO/O7KzPXeM1wkMO6S8K+35axt9SZ/qpM
	leb6QIFfOqNFq34LOarMNQ56s+eDuBM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Miis2Cv4;
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.13 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789981992;
	b=Pc9z4GuL72tM2f8piULUF/cpReSOKFc9qYi4d+ozVjBnbjhTGCpZCKBLM/z/kV5Wt66r3n
	VU263OwWxDApxQNn8WPGf50UY5VHyYOoTwhPS5PCYiFXDMxxo6CSaeRsAA1IkdtY/FmJ00
	qROeUbFlCxfU1CWDWNT2Fq9kkLccEfk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Cu2ExFzZ0wPeXHlo/H4RTvXS1GKs5wBwOLrGXeuqp+k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789981990; v=1; x=1790586790;
 b=Miis2Cv4MjcWjIMZzm2CtRBTMulDYVqwjxWv0zqNylRVpysSxP27oY6zsOOCZnraLLmrFyv/
 XVV1D2tJlPWCMeYMVBuI7M7Q14Cre+b7zjaeHfavZYFtRtBt/AeWhLMNC1AMwz0POKmoOnrOJ+F
 /17o2PHquQeDW9GpjHZ/m2aA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fd58ae7357b5b993;
	Mon, 21 Sep 2026 09:13:10 +0000
X-Mizu-Trace-ID: fd58ae7357b5b993
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Mon, 21 Sep 2026 17:12:34 +0800
Subject: [PATCH 1/2] mm/hugetlb: account migration target folio in per-node
 NR_HUGETLB vmstat
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-for-hugetlb_state-v1-1-8a6eec92661f@kylinos.cn>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
In-Reply-To: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>
Cc: hongfu.li@linux.dev, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789981974; l=3203;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=qFQURuvqIWZRduSFy2tOfQ/YWYqYpSChKzoedQvCG4U=;
 b=alqTdmVgU+bX1/P6i4lpe9eRPyzHnbFGO5R5WIL/PQfB4BeOJYPmPMpV6DQ7XbSba/uZrVhJW
 ifPbV5agVEODv7ZRdaHq4bMs4Yc+A/BUxoZMSwYZei0bAwbxGooDdMp
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspam-User: 
X-Stat-Signature: pjwq5xrirqu4yct5kq76rs6fbdma8k8a
X-Rspamd-Queue-Id: B23ABA0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789981991-43284
X-HE-Meta: U2FsdGVkX18u2YXx1i1gp/92uV37xGPQPSkNOHTHDtCH2bSXR8Ms5+JG6NxFLym8PIAgeprKmlg36o3NV45rdy2D1cE01vBvLDR+H/W/pDuxQxLYRuJne2jwD0sJrTf3cqT+niRJqBdLvFAo+wVEGmX21qyhAaL8gcG5RsmMwexmWI2aRrQ3FpPBJ9SwUj4mLsoAboopYJTPr4Q7uxJW2TNoP/5+CFBkXrzY4gX13Qv8sMS9uU2kZPDhvzl5nO9lyQvgK9u6iXzzPCgJJ0KI8OKOKmioxfvL8RT24aLHsTJKOZuOas2oiMs9nRde00/lLb4wsE9sgaIEraWQMU8IHU78FA7xgbUwRko/Eyb6ApyS0qLWkc1er14yMgy0JvKGeBxiEGyEPpJBsndSZp5tMRGT0pkq78BggexK71lCxdLGUSX5451asvtvuGGogkEttbCw37heyYJm68Nd1vUg3soV29g6xX/041rBIUUGm9iBIl94xbUXyFqqNrgUkrTeDyr+B2qmOgvCrxkqNvGcUE1EIsUuoAqQpGFUA45Pg8NtBobQOE8M1vbOI8KgHekOdyPIA6QBAepcIhwTPMZv2FRDEGk9GyGLo2TE9dUrStXMNLOcQ0NQXvK37/Txn7Hr62UxKevt8SJGFD2CJ3Qy5kG2njA5KjpS8gELeHTK5CPn8Xj5IsaQzQmkr4zwAcetoy3njImfc3WsH2IangbN+GdjQXT2EYv5PjN2Pbd/Laz6f4RRdfY0MwBhGOq1+dNxdJdlvJXq+HsST7s+VWston6w+PyFfITyHbPldG20WquwC2a5zfBtlBTTts5yLG+cn3dYnBXTXbJVlw7KgRKxhbUbQkhFzVUVyEMGH1zTzSyqPVP4iOf4iZ+6fDXyCJ82MrerRzpfsmfAVakgI6td2X36wNi/eMCX7XjM55egUnvFshaAS47jKXLbIijdFlE9ys2qIHH8Zu16UESrYkq
 wsWyu8Ay
 8h6LFT/3A8hN0qbs9/BJG96yWswhnHIvco+RkvGY+59Nvb9jzDKSQFtfBzIL9oKbr+E4lIZaLtIEkZe/bJY2c+LAhnn/u4AJJErcgG8FcL4Gq2b9eGtj55ixGc8gKZn1PtP5UNti7IeS3hJhgdhvI2ESL0qq4H2KSxk/fqnDc4bUGwXN1Z625IV5YPSEXLaUP8oQtSxpKPsEFdGdUC0GLVLrX+CjZI4EUFK2781kbbmh0uEc+55qIt6aMtSiEGccbaGRKBYwIEcGPuHmuzzMkLcEioUzzOgvPqutTs4L+ob4aGHffLJGPYj+AMxjr2uHusfaRhNxleAIdR48bpfcA5PKYxQ==
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
---
 mm/hugetlb.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1b53ba991d36..8ccc769bf48c 100644
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


