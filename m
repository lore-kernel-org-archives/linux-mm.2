Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BF8C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435C16B00A9; Mon,  7 Sep 2026 08:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6CD6B00AA; Mon,  7 Sep 2026 08:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5E66B00AB; Mon,  7 Sep 2026 08:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 069C16B00A9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:28:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 901D214015D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:28:23 +0000 (UTC)
X-FDA: 85186894086.17.FBD6C5F
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id CCD071C0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:28:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CdlrDAuy;
	spf=pass (imf21.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JTzF6RGmGUg4NezQEPwLNpok/5t7X4IGc6Kb6nHVcDw=;
	b=8gvJbxpMC1nnZ5NIQg6RWRYpBXqSLwq8VjzzYLXmfvnqaNF1C+HqipEdHhQ1EWORL4VMNm
	7yOdPaJsNIY36DJHRO0fTiC9iGirDavTe1lt546PaiCzGrunazTG1ZgmJdg9T+mO+V4sPC
	9NezLfbdIwPbAAV52eCMnE/QFPqs+Eo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784101;
	b=IqPqB8MI3kRnOfINdAFzxBEQm8FXvZJc024uXRCInwhCs4p2tQxLGbCbwPjEZMbGCnV0OL
	zZ+ku7D1mP8RPxzFYxQ/zebCUfKkNGd+NqBtT7NIRa8eYiEtlr4Jqdb6ul4OnZFlBrTlT7
	V8NMl9VccjB1Zw/Eej2mrLpE6laMSXM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CdlrDAuy;
	spf=pass (imf21.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-39675172593so2731971a91.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 05:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788784100; x=1789388900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JTzF6RGmGUg4NezQEPwLNpok/5t7X4IGc6Kb6nHVcDw=;
        b=CdlrDAuyCEYnXhp8yf9SrpK97ss177vigxQ3AbeGgnN3t5Wy2RWuoqgrEgFbnpJ1z+
         jYIDLSBO/AU6FH6AL5JkNH6OuhcV1I1XBOGw+cNQaBXAqfu4d63CBFzKT9OLhBI/n5b/
         dGC0bO7FkSHMPt1rwi/rsZRL4G/qjoluP0mJBHtatz/r95KGCIps+trtCcuKiV5Tpfue
         JjBMxvHjsw6jsql3GQsjUm9NgxIv42fO4awJAo9zLnuQwAB4aP1a85x67uzvNMC85Yxm
         7BEgjeZ/hdtPAaZZm+riCGrydr7gx7u3zyipI5SHBXAfylTO+JlxJhAo7BQPWsTALD9V
         dxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788784100; x=1789388900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JTzF6RGmGUg4NezQEPwLNpok/5t7X4IGc6Kb6nHVcDw=;
        b=pibKlF24vfKLvHe0+HwNYusNQ/uAfwDFNMU0SQ8hTQPqWkI0TAW/2jzuYxm3xlYGuA
         VIwEDwWhUvdEyZsrpeF9hJP/y+WksknJWyyqOlkazHs4qt7lDKPI5XkQeahwhjR9ZuKZ
         7DM/sxFeledSUfYl1SKUFo17AtN2BpYnkbOXvrqckztyUfU26BjjNUuN8FZg62i70ar5
         ewHjwU9VpiVQhbCk5kheqM7RpeSPpau+uSAqsBknBzmCe9k2K5cCJ/UrgRw+u8pPtmCg
         Dw2dA0cf6mjcWkRZq+n7fGgaVS4rEicVFTkcvPxx3e1erfQ4iVUO9343Ks5pMbu/P7jT
         AWsA==
X-Forwarded-Encrypted: i=1; AKwUvBycQFiTHJOEmZYJhqUGwMQc4WplXm9qr8mbu9O3oIq+L2vnwH4d/9bwOT08XjG9ibT0WPAYNNHftA==@kvack.org
X-Gm-Message-State: AFuF++lpSAl/lo8EOjE9iRwBLejwFnvF2fvYghGsNl8V8zb5aX6xUzD3
	BBR24pJg00jYh++LRMLobMERdQCeXBjzbQWYpqsg8wlebyjpHW18VHjh
X-Gm-Gg: AYBFou0K48DNzv+YZiLaRhbd5C+e3vZH1uYB7QkasgkVav26DrfJdLdJIpE+SrT2yNW
	JvAdnlvlK2KreOUhX/gT8Eyerm0xkhrCdFAOeSxaw4O0pq0xhutkef3RnrVPpccpQx0RfOG9zut
	e6I6YJbeztLblzs0cDMNQaG/7/tzFzHnC7niHnLxBPhRRxR7IQFEgjxzOOaxBFEEWFL71yNk6hj
	7Jzr1zCMnukz8MYHPBBBjdYzXo8P+x/j+AoQCHNLk1U1reh5jFucsqXHxXwpc7HaRbXhcKhz2y9
	Y5d/rBa+kSfDxvol2sdL1Cux+VEowJ8i+o+mEYNN8BkMnUGpMZvTtzDub7hGHbTdkcVwArFz7k4
	5p/k8ZuFkgKlSdnd6v47EVDvKtikQcmopiwpF30juHfg4i3b/pdyiXq2ugUFo+6qASfeWn3kedr
	UjodTfXaC+1IWOGwa6h5q9t2xbnjeOotHrP4Y23Z8aMdGkmfjvlFrCgWbiVjQcluqf6FGUNW6tM
	7ZChQ==
X-Received: by 2002:a17:90b:5106:b0:37f:c22a:c188 with SMTP id 98e67ed59e1d1-39b260feb03mr33390832a91.4.1788784100350;
        Mon, 07 Sep 2026 05:28:20 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b84cce64fsm2345266a91.3.2026.09.07.05.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:28:20 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: baohua@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [PATCH v3] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Mon,  7 Sep 2026 20:27:57 +0800
Message-Id: <20260907122757.748111-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CCD071C0006
X-Stat-Signature: 169m7k7qkr3gzjgxahcc495sxwasd7f4
X-HE-Tag: 1788784101-83116
X-HE-Meta: U2FsdGVkX1/oJa8c57kcJFZSu5vLBjQwym6TqFM0oJ5/irZ1OhoDQXECAd97VFuQ/12BtG56nQWVurXyxsonSkCZ31fcWHxmtyWQZgeEn6vJOOGpObGAgcWiZenafXxHpoQjG6jkY+YVCIAYiliObY/5Etc9dVPj1dVzb+KSU+Z6th3OjVy4r7NUJWUXSZ+4YYE2Vdo4TT2G5mkeZD341tqYgsoaae/crd31FH04XoDtaZvHoPqagcbina3RTI0VXoAjvYzPAW1m7mFOuNU++/wXPVAlR6qNFDYlJwcSOnbdfv+Mv8y47cIfvLDFUaRwdLQjcG5oX0oemE+vFsit1jxQj2xNIjjuO5z/tCA0XQgI1Dcbvkztd9uC/jqMx2KzenF+kcrl4FoOCknSpDBqWZIjteIRQbr8Om5ga3s/SDGrRrfssQVPVjpTFf14J6eTaa4xDm5ahUYOSt9Ligpi17us2HbXqFcCdHKh8yruOW3HAsLctM5pR+50EF5yKdXqXCsDluIvBlq5kwnrc8OIJVKtdgUXCAXJ6Yc8Wl6Yl7THKm0ImXox3hdN2+Y4dkc6cH+z0ZMl/vFLFZjQq3Xo+AMHXukVLwz7n/f9yfrUb7GEJgR3ips0Sgm/lATjpFROV02f9tJOToaTIlnE3IxVqL2G89Xa9qcc3nRy7inCuXemKZoHDNSVbvtbVxtE60xTsWLZDhIKKsKI1OeB3WGetRgMAprdf/mvz9RJ/lJ1maZevdmEbUf/Sy5UxduY0fYy4zVPmsdSADdEEr+vnfQnAd1xnOcfwON1mxGO5+CikbnysFCXgM3V8dyCvMy3W0IJVqA6zUJamVZpeAfjGVdqX1rjMAfkZ81gTn2Itx+kplcyHcXWn3edVXP9qrCXJtLFi7RaU6a+qU/lQjGTnZD80+h8Q9wV1TYAQZLRYw54zzUFemt1FUy9Ge79n5215PKy+yVnTH30ya/MJqiIp1M
 fOwuLg0K
 6C9vPnqBGKzWkLHNM9Z6+YeuMa+ygAsrsJxyqTBQEQKMzVeE8EK8kqrvh72DH0FXG0FhN+3p28jmUBC8QnGqtpJ0vgKEndrRel+Y/H8WTrpUjAbOE10zhE/1WC0CxKwyVBBXyvWeSzs4laEBBGo445bxB/80S7yah5Bo6mX8uYOb7O2nEPi6dfEFRsLfkoabZXM6zj6Okriq8dmO011CdWAcWp/ib1FRBtgYfE6nNbV9u575MctC8ZAyTwiq8LTEB+0AfbxVMunp6FW3BZfrvwoPEuAIpFa2bFsJ1kWctWf+ilVqSUyYZn0I5W1vRCuCpxv1ZCmKwYOkJSzUqMRKMmi2aPv5g1rNz1xTUpcfjghxE/KzBlo8hg4UhojAUL2yDzkvAi49pVGeIMs56L/c0qnS9sr+7qwzhSI7W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have observed some cases where memory is allocated with GFP_NOIO, so
we cannot reclaim any anon folios unless they are in swapcache. We can
end up spending more than 150 ms looping in `shrink_folio_list()` scanning
non-swapcache folios without reclaiming a single folio. This is pure
overhead.

This is particularly true on systems using zRAM, where swapcache is
relatively rare. So let's check whether anon reclaim is allowed by
GFP_IO and whether there is enough swapcache to make it worthwhile. If
the swapcache is extremely low, we're essentially searching for a
needle in a haystack, so let's avoid scanning anon in the first place.

On Android this is triggered by dm-verity hash-block reads through
dm-bufio, which legitimately use GFP_NOIO because they run underneath the
IO path:

  verity_verify_io -> verity_hash_for_block -> verity_verify_level
    -> dm_bufio_read_with_ioprio -> new_read -> __bufio_new
      -> alloc_buffer
         gfp: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN

Such a reclaimer can land on a memcg with a large, unswapped anon LRU and
a tiny file LRU (e.g. inactive_anon ~335 MB vs inactive_file ~4 MB, with
negligible swapcache). shrink_lruvec() then keeps feeding that huge anon
list into shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,000
anon folios scanned - where every folio is kept because it needs IO. The
150+ ms above is one such single shrink_lruvec() pass (not accumulated
across a reclaim cycle), and it reclaims nothing; the actual progress
comes entirely from the file side.

Aging anon alongside file does have some value for a later __GFP_IO
reclaimer, so it is not strictly pure overhead. But that aging is only
deferred, not lost: kswapd and other __GFP_IO reclaimers still walk and
age anon. Spending ~168 ms aging memory that this context cannot reclaim
is not a worthwhile trade-off in a latency-sensitive path.

To stay conservative, this only skips anon when the swapcache is really
tiny - below 1/64 of the anon LRU - i.e. when essentially no anon on the
list can be reclaimed without IO. Whenever there is a meaningful amount of
swapcached anon, the normal path is used and anon is scanned and aged as
before.

Note this only addresses the traditional active/inactive LRU. MGLRU
selects anon vs file scanning in its own path and is not covered here;
fixing the MGLRU case is left as a TODO.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
v2 -> v3:
 - Fix stats source in reclaimable_anon_is_low(): for global reclaim
   (memcg == NULL, e.g. from set_initial_priority()) use node_page_state()
   instead of mem_cgroup_lruvec(NULL), which resolves to the root memcg and
   excludes the child cgroups where anon actually lives. (reported by the
   sashiko bot / AI review, raised by Andrew Morton)
 - Add a comment explaining the heuristic and its rationale. (Andrew Morton)
 - Update the comments above the can_reclaim_anon_pages() checks. (Barry Song)
 - Note in the changelog that only the traditional LRU is addressed; MGLRU
   is left as a TODO. (Barry Song)

v1 -> v2:
 - Use mem_cgroup_lruvec() instead of get_lruvec(), which returns the raw
   node lruvec for a NULL memcg and would be misinterpreted by
   lruvec_page_state()'s container_of() during global reclaim. This also
   drops the get_lruvec() move. (sashiko bot, Barry Song)
 - Drop the SWAP_CLUSTER_MAX cap on the threshold; the check is purely
   proportional now (swapcache below 1/64 of the anon LRU). (Barry Song)
 - Expand the changelog with the workload, the dm-verity/dm-bufio NOIO
   stack, the single shrink_lruvec() breakdown, and the aging trade-off.
   (Johannes Weiner)

 mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 245f68c75b28..e5c07490f5b3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -362,20 +362,62 @@ static bool can_demote(int nid, struct scan_control *sc,
 	return !nodes_empty(allowed_mask);
 }
 
+static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
+		int nid, struct scan_control *sc)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long anon_pages, swapcache;
+
+	/*
+	 * A !__GFP_IO reclaimer can only reclaim anon that is already in the
+	 * swapcache (adding anon to the swapcache needs IO). When swapcache is
+	 * far below the anon LRU, scanning anon reclaims nothing and only burns
+	 * CPU; the aging it would do is merely deferred to later __GFP_IO
+	 * reclaimers. The 1/64 threshold keeps this to the case where anon is
+	 * effectively unreclaimable.
+	 *
+	 * Use the memcg's lruvec for memcg reclaim; for global reclaim
+	 * (memcg == NULL) use node-wide stats. mem_cgroup_lruvec(NULL) would
+	 * only see the root memcg, not the child cgroups where anon lives.
+	 */
+	if (!sc || (sc->gfp_mask & __GFP_IO))
+		return false;
+
+	if (memcg) {
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+
+		anon_pages = lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
+			     lruvec_page_state(lruvec, NR_ACTIVE_ANON);
+		swapcache = lruvec_page_state(lruvec, NR_SWAPCACHE);
+	} else {
+		anon_pages = node_page_state(pgdat, NR_INACTIVE_ANON) +
+			     node_page_state(pgdat, NR_ACTIVE_ANON);
+		swapcache = node_page_state(pgdat, NR_SWAPCACHE);
+	}
+
+	return swapcache < (anon_pages >> 6);
+}
+
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 					  int nid,
 					  struct scan_control *sc)
 {
 	if (memcg == NULL) {
 		/*
-		 * For non-memcg reclaim, is there
-		 * space in any swap device?
+		 * For non-memcg reclaim, is there space in any swap device?
+		 * And under GFP_NOIO, is there enough swapcached anon to make
+		 * scanning anon worthwhile?
 		 */
-		if (get_nr_swap_pages() > 0)
+		if (get_nr_swap_pages() > 0 &&
+		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	} else {
-		/* Is the memcg below its swap limit? */
-		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
+		/*
+		 * Is the memcg below its swap limit, and under GFP_NOIO does
+		 * it have enough swapcached anon to make scanning worthwhile?
+		 */
+		if (mem_cgroup_get_nr_swap_pages(memcg) > 0 &&
+		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	}
 
-- 
2.34.1


