Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13EC7CD13D2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 21:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786A26B0088; Thu, 30 Apr 2026 17:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7375E6B008C; Thu, 30 Apr 2026 17:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6749E6B0093; Thu, 30 Apr 2026 17:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA176B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:25:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 032A5A01E6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:25:47 +0000 (UTC)
X-FDA: 84716504376.24.3434A01
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3592E40016
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:25:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=OEA4Tg8P;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777584346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0FRn2xh+tixze1ELPb+tnTxd8VoDsShkAhtmqJ4LXM=;
	b=TFt1gn8pUYYPkQBzPlzdMRRjHac8daLSziqhoSoZ14IoQFaw09E753ChcjIBGPKbl7t21R
	uT92s409X0NCv8xuS1pNCvzSVEjT9QBaG/3MNMDggdDEwEQenq6cI5DFk0xnv0Dw2+t0QM
	Ts1w1m68dwm6pq577qfmyz4oOT1BoZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777584346; a=rsa-sha256;
	cv=none;
	b=xAy4GT8wOPCU+67nW0opfw1l3Z/o2aSiM0vNOJ+gmaZtH2WKhlCw6t/zBGxD6Kj3m9/7An
	YeUFXJz5ruIFXEcLMTZutzHe+6PhOPstKtqOUmI8c5KyjIj7nEHat/HlfI5t8RbIRIY9GH
	fs5P2IEmoIR2tvvdPOBzjKYBHJiZAiM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=OEA4Tg8P;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H0FRn2xh+tixze1ELPb+tnTxd8VoDsShkAhtmqJ4LXM=; b=OEA4Tg8P7rvdTlLOnC7LFpoy/6
	lsgPBlZCJ5hj0HO4wYvVFicRiv91aPUdPGGjgsb86mZ1U4ZECh+O00hSAYD0DYvK+Pyo8JReKwIix
	WTNL/qkYRZZggAyMZOg57XxL/3p2ggFlF27KyAgKyHZorpJ45ZIpTObQuJGIb/YGU1Jd5z8And8vF
	bM619+b/1pqt9ZS+KOMLyX6qqDJHHEB5Yf95rsNUCk/T66t7GO+SJTVwgglOJUcgPieA4EMMqXH6D
	eI3s+bwNylnj85mvolE+Qe57EzkxeGLLamiqAzGkmX3wCXhsf/8uv4Ijkd85pstUjjcfQKaAoVNhp
	pJPlTt7w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-14Wj;
	Thu, 30 Apr 2026 16:22:41 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 31/45] mm: page_alloc: cross-non-movable buddy borrow within tainted SPBs
Date: Thu, 30 Apr 2026 16:21:00 -0400
Message-ID: <20260430202233.111010-32-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3592E40016
X-Rspam-User: 
X-Stat-Signature: ynntewadektt1ppb55rf8ofc96nn88ic
X-HE-Tag: 1777584345-574327
X-HE-Meta: U2FsdGVkX1+ZS0SthjGoEDu+tj6yn5MNmFo7GMCZPGu8N9Pu/SztRLM7ObBh4lgR4C5hF9/h6qtwRoWu589JeKWFVdEg3lBh5JRWsiXD0/ICAMDnTgDDgPWB1KwbNZYNzbnGCYvP9LkSub0Mm8UKvV2jXB6afs/H1JkNsPrvXNMw1LtW3zeV3mmbncW/B6+Uve/OJvpqA3n8DKx1cL4AZgUZrVqw9j3N5JzoYXZRGm8S1kbmq28Hx5SotSOhyKt1hfh1ajUJgDwvRs0+3lTJaT6dVWH1KCyEOEGKUrsGRMzzj3aEdsiT8LBI3LZ72SdfLSK0g6HJ527N7Vx3g1hID43GvNt7Hin4Gg+vfHmdxwAv+NWXK9ksvNcJZMPjBV1eGj2okQslnl152V+PW8j/ZeHQ3n7nTtO+yxAH8yQ8OUXz3844JBFB02VD+wNMsp+mZRCWQvI7gcsTAZU6vmRQ6BOUH7deeu3AHvUsM5VR09j40F+2amffFIm0XMNiKdUuli5GFBV3j6Wo/kjtFK08SiVgfGzzckFyJc5Eua3kgvemp+YNXLGaYQIeB2nozqw+1hf2IDDe1hE65wfGEg3phUw76vq5eTCLrHfqiww5mszFZhtcchJmb9HIz4MmlkLSE95MWT2xnE86cgkaXPJNA2vYRsqVGxHW0cZRFdGb6KM7+Iwm1rRpzD+D4kGHdhy6wASKd48+FApaf3IlFvbM7Gc89Fx9DanRGNX8P+jeQPMM6SRg+Cy/eCe/mwgfj7x1yuAWVLKBj0bGMQPEFoG6vFoTlOMTLK0uiJWqwg6JWycnP9cZ9p6+fnPxlT6i9qbcrMCOcG6BPzf37l9HTPTDVZUB2baXRmMl6yX3salnsrGJ71wUwYxdixutc18U60w1rFx6DDb/8YgYtKZFX/eer1lFVZKXGY2THjcwdskS2VBMDzS5Vv+G/ejxNMUHJd2ytDjn7c3adhm/A46vhKY
 nbyYB0J1
 f1LRTG7yWL8ZuFF1/O5l+uUlRJfi1kfPCSc7I5FJQRMowEd2VDHyqOibvCAK9Y5ZWOWAb2jM0UIT2fXncqBxieP6DpUjQ/CAx0hXOPhmg9TiongmqF0+lf3xAtqxepW946uNU1FZqH32cij8R+ejizjaEioSzkMWjZkuq8blhcuqI4rdc2+jhktlw+jDDwoNEglkmODDP57H5wfq+LEyFwazIC0VUlBrkXJCFc9jDSbq6338orr5GPduiDdAB4Zg6crzclr2dCc5zvsEHZf6hhYjmC8AG5ouOYpPewO2P7+EjZGHX5DVWBbFrrAKymBEXoz4QVmUEwvnGtfeWgoji1LtLgg3oeWCcKCR7XzJoaDiGB7YI4tIcluSMdiLP6Zch5qFX1kicOZ+X45xbKNwyMbwOubnneaRMoSoU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

When pages get freed via __free_one_page, they're placed on the per-SPB
free_list determined by their pageblock's migratetype, not the original
allocation's migratetype. Slab-heavy workloads expose a structural
mismatch:

  - RECLAIMABLE pageblocks fill up densely with live slab objects (e.g.
    btrfs_inode caches), leaving very few sub-pageblock free fragments
    on the RECL free list.

  - UNMOVABLE pageblocks accumulate sparse free space from vmalloc and
    raw-alloc churn — tens of thousands of free pages, all on the UNMOV
    free list.

Net effect: a tainted SPB can show 87,000+ free pages in metadata while
having ZERO free buddies on the RECL list. A new RECL allocation walking
__rmqueue_smallest's preferred-SB Pass 1 finds nothing, falls through
Pass 2 (claim_whole_block on MOVABLE — but mov=0 in tainted SBs),
Pass 2b (sub-PB MOVABLE — same), and reaches Pass 3, which taints a
fresh clean SPB. Repeat per RECL burst.

Add a Pass 2c between 2b and 3: for non-movable allocations that
couldn't find their own migratetype, try borrowing a sub-pageblock buddy
from the *opposite* non-movable migratetype's free list within tainted
SPBs. UNMOV alloc → check RECL free list; RECL alloc → check UNMOV
free list. The pageblock tag is NOT changed — page_del_and_expand uses
the source migratetype for both delete and re-list, so the splits stay
on the source list, and when our borrowed page is later freed
__free_one_page returns it to the source list (based on pageblock tag).
The "borrow" is purely transient: physical page goes to a foreign-type
caller, returns to its native list on free.

PB_has_<requested_type> is set via __spb_set_has_type so spb_defrag
accounting reflects that the pageblock now hosts our type's content.
PB_has_<source_type> stays set since other buddies of that type remain.

Restricted to UNMOV ↔ RECL within SB_TAINTED — movable allocations have
their own Pass 4 fallback, and clean SPBs must not be polluted with
cross-type mixing (that's what the existing migratetype-isolation
machinery exists to prevent).

Live measurement on a 247 GB devvm with btrfs root, kernel 397 (Stage 1
+ simplified Stage 2a) at boot+7min: 12 tainted Normal-zone SPBs grew
from 4 baseline despite the existing 11 having between 825 and 87,062
free pages each, ALL on the UNMOV list while the workload kept
allocating RECL btrfs_inode slab pages. Pass 2c lets those allocs
absorb into the existing UNMOV-listed free pool rather than creating
fresh tainted SPBs.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a72cb2da606d..f2db3dd86a84 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2806,6 +2806,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	struct page *page;
 	int full;
 	struct superpageblock *sb;
+	int opposite_mt;
 	/*
 	 * Category search order: 2 passes.
 	 * Movable: clean first, then tainted (pack into clean SBs).
@@ -2985,6 +2986,90 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 				}
 			}
 		}
+
+		/*
+		 * Pass 2c: cross-non-movable borrow within tainted SPBs.
+		 *
+		 * If we're a non-movable alloc and Pass 1/2/2b couldn't find a
+		 * buddy on our migratetype's free list anywhere, but tainted
+		 * SPBs have free buddies on the *opposite* non-movable type's
+		 * free list, take one of those.
+		 *
+		 * Why this happens: when pages are freed, __free_one_page puts
+		 * them on the free_list determined by their pageblock's tag,
+		 * not the original allocation's migratetype. Slab caches tend
+		 * to be dense (RECL pageblocks fill up; few sub-PB fragments),
+		 * while UNMOV pageblocks accumulate sparse free space from
+		 * vmalloc/raw alloc churn. Net effect: tainted SPBs frequently
+		 * have tens of thousands of free pages all on the UNMOV list,
+		 * invisible to RECL allocs (or vice versa). Without this pass,
+		 * the alloc falls through to Pass 3 and taints a fresh clean
+		 * SPB even though the existing tainted ones have plenty of
+		 * unused space.
+		 *
+		 * We do NOT relabel the source pageblock. The buddy is taken
+		 * from @opposite_mt's free list and the splits go back on
+		 * @opposite_mt's list (page_del_and_expand uses the same mt
+		 * for delete and expand). The pageblock tag is unchanged, so
+		 * the page returns to @opposite_mt's list when freed via
+		 * __free_one_page. Effectively a borrow: the alloc takes a
+		 * physical page from a UNMOV-tagged pageblock for a RECL
+		 * use, and the page cycles back to UNMOV's list on free.
+		 *
+		 * We do set PB_has_<migratetype> via __spb_set_has_type so
+		 * spb_defrag accounting reflects that this pageblock now hosts
+		 * our migratetype's content too. PB_has_<opposite_mt> stays
+		 * set since other buddies of that type remain.
+		 *
+		 * Restricted to UNMOV ↔ RECL. Movable allocations don't
+		 * participate (they have their own Pass 4 fallback path).
+		 *
+		 * Restricted to SB_TAINTED to avoid spreading mixing into
+		 * clean SPBs.
+		 */
+		opposite_mt = -1;
+		if (migratetype == MIGRATE_UNMOVABLE)
+			opposite_mt = MIGRATE_RECLAIMABLE;
+		else if (migratetype == MIGRATE_RECLAIMABLE)
+			opposite_mt = MIGRATE_UNMOVABLE;
+
+		if (opposite_mt >= 0) {
+			for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+				list_for_each_entry(sb,
+					&zone->spb_lists[SB_TAINTED][full], list) {
+					int co;
+
+					if (!sb->nr_free_pages)
+						continue;
+					for (co = min_t(int, pageblock_order - 1,
+							NR_PAGE_ORDERS - 1);
+					     co >= (int)order;
+					     --co) {
+						current_order = co;
+						area = &sb->free_area[current_order];
+						page = get_page_from_free_area(
+							area, opposite_mt);
+						if (!page)
+							continue;
+						if (get_pageblock_isolate(page))
+							continue;
+						if (is_migrate_cma(
+						    get_pageblock_migratetype(page)))
+							continue;
+						page_del_and_expand(zone, page,
+							order, current_order,
+							opposite_mt);
+						__spb_set_has_type(page,
+							migratetype);
+						trace_mm_page_alloc_zone_locked(
+							page, order, migratetype,
+							pcp_allowed_order(order) &&
+							migratetype < MIGRATE_PCPTYPES);
+						return page;
+					}
+				}
+			}
+		}
 	}
 
 	/*
-- 
2.52.0


