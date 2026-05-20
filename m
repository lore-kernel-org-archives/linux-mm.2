Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46E3CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56F66B00AB; Wed, 20 May 2026 11:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2ED76B00AC; Wed, 20 May 2026 11:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0916B00AD; Wed, 20 May 2026 11:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A80926B00AB
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71CC940365
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:55 +0000 (UTC)
X-FDA: 84788110470.19.CC95B5B
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6FEBF80013
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="haLL/lLV";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=soU8EMGTnZp6JdKODlWY7ua2z0I6BshZRtKHimKYnmk=;
	b=WBTdLwvvnqGrvHAmfnG2URNYO1RAl8u9D3g2c1FFQqiuAHVDPtlc1BYySa8jyt+DArY9R+
	QWvdGjccAW5JuPx33wU5HcVmWPnbCJeAjyOPe2h/AAaGwMG7mGMo/JJlfHHXw26+/w1tGV
	CRd6hTkrF9NM/lZuFwC+lMoMANGLJNs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="haLL/lLV";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289253; a=rsa-sha256;
	cv=none;
	b=aqB764PBuvbPhySOFPQHA2mEIzn5x8xsOsdFB9FHddc54BSyAe9UxRqZiQeG8RrxJalIf4
	BirNNeW5v+ACTGIoWXFSz8TQSJRrUIVZ3PwiZJqOl4mxwBi4oLcTkJEsgdbC5RLfZlGLv7
	q21X42xEV29pVXp8RkZmAqLTb3bwvjg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=soU8EMGTnZp6JdKODlWY7ua2z0I6BshZRtKHimKYnmk=; b=haLL/lLV5W/Xd8lSRXfoSB0b0o
	bo6kV1YJOWQqBWKTQfPvFTKRclEZnxrTmDxof7eRKya0afSNS50EX80+u3tzEW0GxGwCrU1yDLK2a
	oyzWKlC73Hb+kw+jr3x5ddVLJ8y+0eddvnkNioVLy+BEt2IE5DeyBY7pT937YLuGPPEA9ZYj+RvxF
	LG92t4qfm04AXbL9xxWwAfFmJqT5i0omlKjQQNQ3s47G6Y9vidY/0ZIkQEcGgA5TaSL3mE/0NVNT5
	vjZC4+DVHelK4wQb7DQG2t+iP1OPLg6XaKfOgkG93ZSo2z/h6bOXnZO/Y/TX9aK7k3pyBTgdORLv6
	Mn9u7crA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-2atp;
	Wed, 20 May 2026 11:00:28 -0400
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
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 21/40] mm: page_alloc: adopt partial pageblocks from tainted superpageblocks
Date: Wed, 20 May 2026 10:59:27 -0400
Message-ID: <20260520150018.2491267-22-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r5kx34jcgfiu314bmczu4f4krb34fnao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6FEBF80013
X-Rspam-User: 
X-HE-Tag: 1779289253-834586
X-HE-Meta: U2FsdGVkX1+QMEJqlQ8WxhrZ1ZUfP1xmotPWgQ88mnI7bU8W2dcztWoIGWaVEYc/UM7OKSfRFKP9kXBvHEJrgQOGx8Z1wCvVaBXsDr95OHp0guyzISMrh+K0lSZufL1XYZCdlN434akvUsOv6qQZ/78x+GzqNzDTbisHlS48dn45WivagA9fnQYleUCmTFJOmepOyyEfV+HhSaHxB9yyZ8snz06yMAH4tUn/AMewwW6EuHSZ3Lj0Hgr00p86GR4QryHVyKlXL2k6F5rpZEwcxbnJ/sHtPgMUeiGgHS09ftd1EDhpT04q3Be4eGsy0FTZLob0HKAV5wnvxc7hld5RpQ4jbhLTVGaPxU0iCJyKASElB/fTontdz4F49xu80s8R5aLldzZENsjEnM7zGqG5wLU7dgoyrFnXsXRG4KbSl8eMhOnFFsk5Voxt1DZwcWPGH1t9C1kRcT/8xmlm4dN48dk9ZfpdsYfkWKBISCTeNdj0R1ruN6H+nP2sPLe+3co4IW9XeUG+6YZlIJi9Hi3iDGoa1dlUyEnbxB8RWNbPNMujbbIIuuaynzlXA4lRbzylW3CjFeEpicPWfY/jZ78tX8566ZmbfFHJvqeqj8AGwxD0t10mpNSR66U2Hm2NSuOAazVbK9hMZYzSqjWar4qG6B77Tr9DAlDBwpwD8SLvVCZq0/baKGn/vJBWUDvhRdwd11LktVPwlD9F4MWQXWjqHUTvsDxO+udgkWcGSzFu+ibL0Oxweshd7kSp3TwvjDZGU3dnA3vPMd2HZsHBn9oYDAKD1qhBJyYy74xJXpX+JapBjBbtqdknivhaxpcNgbEZ9K1dOr6OtEyvayxt1lwxjImcAUt4j11pGZGYP/51injtu+R1fJ3u6pdkxNZvR8fb8Y5U4wug/yU5zVQls6lcMjMs5/Kzvfj8WfwKMr3724P/E+aPcBYUR8yFISVSlq7qRc+mJrJP98UqO3LOctm
 qYy8fuqz
 FQ6bTvzt7CUzJd36YIGgez7tGzE5KrLHnAsANCfyl6I4K36RaJsbgWZ1kdvk5RxMOqrfHA4ep6Tez0eotPC7t8dlYzzOVsd/T4r9IQAOH2sd3xz15n/oeJay7brB8dgjvXVNvs9qj82bPGY1UG5QP8Cd6LTlLriFPF/k0hGEg4S4b4JUB6lX4iE3il93Ah6UA2hTPWm6GnZ8i7elPEpq73GcPjUe8s5uEg/ve4idz6brQ82Y6JtyZLfu0BxMNm4LMR9tUo+6E9yGa+rMU7WrUkneyUH29LWMt5nxtZ/KooSlNsCHrrCgatOYIiy5rynbjZmpv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Phase 2 to rmqueue_bulk: when refilling PCP for unmovable or
reclaimable allocations, search tainted superpageblocks for partially-free
pageblocks with sub-pageblock buddy entries of the requested migratetype.

Claim ownership of the pageblock and move the found entry to PCP with
PCPBuddy marking.  Pass 0 (the existing owned-block recovery phase)
picks up remaining buddy entries on subsequent refills, so there is no
need to sweep the entire pageblock eagerly.

This concentrates non-movable allocations into already-tainted
superpageblocks, reducing fragmentation spread to clean superpageblocks.

Pageblock-ownership handling: a pageblock encoded as pbd->cpu==0 is
unowned and may be claimed; a non-zero value means another CPU's PCP
has frozen pages from this block.  In the latter case the refill walk
keeps following the pageblock (the merge pass at __free_one_page can
reabsorb the other CPU's PCPBuddy entries in the same lock acquire,
clearing ownership before the walk finishes), instead of unconditionally
skipping it.  Without this, busy multi-CPU systems with high tainted-SPB
occupancy would skip every already-touched pageblock in Phase 2 and let
clean SPBs taint instead -- the exact failure Phase 2 was added to
prevent.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 131 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 117 insertions(+), 14 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 093be0d930c0..8027412da866 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1090,7 +1090,7 @@ static inline void set_buddy_order(struct page *page, unsigned int order)
  * - Set when Phase 0/1 restore or acquire whole pageblocks.
  * - Propagated to split remainders in pcp_rmqueue_smallest().
  * - Set on freed pages from owned blocks routed to the owner PCP.
- * - NOT set for Phase 2/3 fragments or zone-owned frees.
+ * - NOT set for Phase 3 fragments or zone-owned frees.
  * - The merge pass in free_pcppages_bulk() only processes
  *   PagePCPBuddy pages, ensuring it never touches pages on
  *   another CPU's PCP list.
@@ -3871,15 +3871,15 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
  * under a single hold of the lock, for efficiency.  Add them to the
  * freelist of @pcp.
  *
- * When @pcp is non-NULL and @count > 1 (normal pageset), uses a four-phase
+ * When @pcp is non-NULL and @count > 1 (normal pageset), uses a multi-phase
  * approach:
- *   Phase 0: Recover previously owned, partially drained blocks.
- *   Phase 1: Acquire whole pageblocks, claim ownership, set PagePCPBuddy.
- *            These pages are eligible for PCP-level buddy merging.
- *   Phase 2: Grab sub-pageblock fragments of the same migratetype.
- *   Phase 3: Fall back to __rmqueue() with migratetype fallback.
- *   Phase 2/3 pages are cached for batching only -- no ownership claim,
- *   no PagePCPBuddy, no PCP-level merging.
+ *   Phase 0:   Recover previously owned, partially drained blocks.
+ *   Phase 1:   Acquire whole pageblocks, claim ownership, set PagePCPBuddy.
+ *              These pages are eligible for PCP-level buddy merging.
+ *   Phase 2:   Adopt partial pageblocks from tainted SPBs (non-movable only).
+ *              Claims ownership so Pass 0 can recover buddy entries later.
+ *   Phase 3:   Fall back to __rmqueue() with migratetype fallback.
+ *              No ownership claim, no PagePCPBuddy, no PCP-level merging.
  *
  * When @pcp is NULL or @count <= 1 (boot pageset), acquires individual
  * pages of the requested order directly.
@@ -3897,7 +3897,7 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 	int cpu = smp_processor_id();
 	unsigned long refilled = 0;
 	unsigned long flags;
-	int o;
+	unsigned int o;
 
 	if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
 		if (!spin_trylock_irqsave(&zone->lock, flags))
@@ -4007,11 +4007,114 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 		goto out;
 
 	/*
-	 * Phase 2 was removed: it swept zone free lists for sub-pageblock
-	 * fragments, which are always empty when superpageblocks are enabled.
-	 * Phase 3's __rmqueue() -> __rmqueue_smallest() properly searches
-	 * per-superpageblock free lists at all orders.
+	 * Phase 2: Adopt partial pageblocks from tainted SPBs.
+	 *
+	 * Phase 1 only grabs whole free pageblocks. When a tainted SPB
+	 * has partially-used pageblocks with free sub-pageblock buddy
+	 * entries, Phase 1 can't use them. Phase 3 can find them via
+	 * __rmqueue_smallest, but without ownership or PCPBuddy marking,
+	 * so they fragment further on drain.
+	 *
+	 * This phase bridges the gap: find a sub-pageblock free entry
+	 * in a tainted SPB and claim ownership of its pageblock. Pass 0
+	 * will pick up remaining buddy entries on subsequent refills.
+	 *
+	 * Only for unmovable/reclaimable -- movable should use clean SPBs.
 	 */
+	if (migratetype != MIGRATE_MOVABLE &&
+	    !is_migrate_cma(migratetype)) {
+		enum sb_fullness full;
+
+		for (full = SB_FULL; full < __NR_SB_FULLNESS; full++) {
+			struct superpageblock *sb;
+
+			list_for_each_entry(sb,
+				&zone->spb_lists[SB_TAINTED][full], list) {
+				struct page *page;
+				int found_order = -1;
+				bool claim_pb;
+
+				if (sb->nr_free_pages < pageblock_nr_pages / 4)
+					continue;
+
+				/*
+				 * Find a sub-pageblock free entry for our
+				 * migratetype, starting from the largest order.
+				 *
+				 * Use a post-decrement loop so the unsigned
+				 * counter cannot underflow when @order is 0;
+				 * the previous signed counter relied on the
+				 * mixed signed/unsigned comparison wrapping
+				 * to a huge value, which UBSAN flagged and
+				 * which let the loop walk free_area[-1].
+				 */
+				for (o = pageblock_order; o-- > order; ) {
+					struct free_area *area;
+
+					area = &sb->free_area[o];
+					page = get_page_from_free_area(
+						area, migratetype);
+					if (page) {
+						found_order = o;
+						break;
+					}
+				}
+				if (found_order < 0)
+					continue;
+
+				/*
+				 * Found a free fragment in a tainted SPB. Take
+				 * it from the buddy.
+				 *
+				 * If the source pageblock is unowned, claim it:
+				 * mark our pages PagePCPBuddy and register the
+				 * block on owned_blocks so Pass 0 can recover
+				 * remaining fragments on future refills.
+				 *
+				 * If the source pageblock is already owned by
+				 * some CPU (us or another), take the page as a
+				 * plain non-PCPBuddy fragment -- the same way
+				 * Phase 3 / __rmqueue_smallest would. Setting
+				 * PagePCPBuddy here would let two CPUs hold
+				 * PCPBuddy pages from the same pageblock, and
+				 * the PCP merge pass could then corrupt the
+				 * other CPU's PCP list.
+				 *
+				 * Set PB_has_<migratetype> either way (bypasses
+				 * page_del_and_expand which normally does the
+				 * PB_has tracking); idempotent if already set.
+				 */
+				pbd = pfn_to_pageblock(page,
+						       page_to_pfn(page));
+				claim_pb = (pbd->cpu == 0);
+
+				del_page_from_free_list(page, zone,
+							found_order,
+							migratetype);
+				__spb_set_has_type(page, migratetype);
+				if (claim_pb) {
+					set_pcpblock_owner(page, cpu);
+					__SetPagePCPBuddy(page);
+				}
+				pcp_enqueue_tail(pcp, page, migratetype,
+						 found_order);
+				refilled += 1 << found_order;
+
+				/*
+				 * Register for Phase 0 recovery so future
+				 * drains from this pageblock can be swept
+				 * back efficiently. Only meaningful when we
+				 * actually claimed ownership above.
+				 */
+				if (claim_pb && list_empty(&pbd->cpu_node))
+					list_add(&pbd->cpu_node,
+						 &pcp->owned_blocks);
+
+				if (refilled >= pages_needed)
+					goto out;
+			}
+		}
+	}
 
 	/*
 	 * Phase 3: Last resort. Use __rmqueue() which does
-- 
2.54.0


