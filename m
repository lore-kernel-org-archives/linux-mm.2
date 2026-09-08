Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C0DC79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F816B0092; Tue,  8 Sep 2026 02:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E09B6B0095; Tue,  8 Sep 2026 02:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2886B0092; Tue,  8 Sep 2026 02:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 018126B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:27:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C3E5C03B5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:27:01 +0000 (UTC)
X-FDA: 85189612242.04.CAC5EAF
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC6F240003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:26:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g5kdhhTc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788848819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fhiEpm2qdQbWRM6RAj4bAjW4Pi/E69sJ1QXVjWM8dxg=;
	b=rqQeFshbdJ+4pBBd4lUj7/LdpZcEZR3MOwnysZuz0XYNEiSe0KpTelX3M3nPK0cr9UVLQk
	W3r7xbG0ZyB+5eiK7JfZRqnoKjSVoJ0HtpdhX6WfuHDgkn/uugGKqz29UQ2GBCbOqxzQIV
	CKoe8Lr+kZjTvJ6ezGS9MF1SvHdr6vg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g5kdhhTc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788848819;
	b=IvNhZSn0x2SbUgf+1koubOo93MBMipdrAPGam9MKOWGJK6NBzeUT2H2qWJ6R3/Xx2L1w4/
	iMTuKT7lY18emw4lyMvZWWbZee18DZv0rq/puSpTx31d5XMIXLYIJsStaFn6QzO2NKL0eN
	Zn2TvMSjy78NBdEBHnx14qpheF3My+I=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2db80fcdf8bso2070825ad.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 23:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788848818; x=1789453618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fhiEpm2qdQbWRM6RAj4bAjW4Pi/E69sJ1QXVjWM8dxg=;
        b=g5kdhhTcrFPUm/beVhVog6w/7wOf6zATDGAU6YKIyI8JGAgrW7QVBbTiQ9tYACuiIg
         a9hKjfmwJDuIpIqkHokspD5N3bkEVvaio9znbG/pIGKNcqZ4TLDltAVjw/3DvILTrUzG
         IB7FptA3OvEdJ/EtB2eM4N72wYcXA0/Ow0IvivOd0WEv/5Ur73pyv+pLIomILW4Okx/u
         djd8d6NxLzM54Gp1wKC7pevWWvopjC/vSvhmRIGJRSHJ0CgSzOdjiJxxKvtGLwJubCsm
         mSPOTUHv7X9/+sv2momlyujVcikDON2HaeeLCZqDzBkd2pWmmDaLil6NmetTS1XHhZNn
         ayEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788848818; x=1789453618;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fhiEpm2qdQbWRM6RAj4bAjW4Pi/E69sJ1QXVjWM8dxg=;
        b=BC2+JO9c5rZvthRoRSEAyuH2gqiBpiQ4TzIt1PCa39DiuWQJUz+KvNLfBjM95wPema
         VeCb0F/+4HquYxZafEeQl7k8CBdiNvvrO+k3GJ4EoDvRqbb4dByai6ap+5/v6jI2pg04
         4ofwojI6WUK6vrYGOPS0IqcWpQjaovjNflI+wE8eeUIqRLOD3s/rm5qN7ovpGGkzua1v
         vYtwGsRSWl1GFrZIXMY/Ubea86J4ERpOZFwBdgI6YE/M24Xmo/n9z/9523MNfKCCbRHx
         j3GLgwi9gSBgYFxYlzWLeF7e+SKCQVxqR9uW8DwoBMwCDphC5ZSzWS7WXNM+xK9hLzBL
         IY3Q==
X-Forwarded-Encrypted: i=1; AKwUvByT4a4aRKTDoDd55BbNV1Q1CTlh5GVN6BuaLzJoYUIPi/51HymfVIWJ3FoQ86cB3YjCtPRsmMnWTw==@kvack.org
X-Gm-Message-State: AFuF++n8ZPuQNm1YeZWP9qfhMLO2VoKkspXK5jr4G6+8vL/uHMw8dSdk
	IhAGbFoEkRsQBOmfGrO9ep/UUYj3ToEzgUNZsPi9AtHCTPg5n1kaiv/C
X-Gm-Gg: AYBFou0eYKdB7G/4n5mFqsWpE81+/bVCOhQXKHscg/1m3x/xDcQKslprFxMc0Ncp4y2
	uuuH1aqp1rcf0NtxVKScDypZiOyNEm9FTqOF64iMRxhzlWO1RqCZXZdgxk7tKK6esFa/tsbZgja
	BOKJ2qD3XWwKnQ4liRnFvmvXxPNMcbZ8++46adZS4b4J77EfoBiZnAK/agZsLujUy3sAkP2XMWZ
	deeon+MJdWciL55yNQHRUQSGxGeq/FyzDSKRFMn9KqzMRzQgNXr2wIlueIDsdvMEDJQmU1TcNnf
	fZCDoEIKO3din9cCUx0MmZK+HJDKSZRMu5sswQhvcb4c4iXqU4W+dPiBvupNEzJAA8d1yf/BokZ
	pyFD76W37XX0Y/j4PhsE0I3NWI0RMkks1jf7nvyBGX8nECkuwOopG/naJp7Hd5xE+mlw10Zfu12
	K52Z9ElXXWf/adf1/Xp2IdrKa1kxXxGGpR+TPUJYbPi+KQHp12rMFj/7mZlfnLO6iiSx2EwwLHb
	/h8hQ==
X-Received: by 2002:a17:90b:3944:b0:392:b509:b1a5 with SMTP id 98e67ed59e1d1-39b261b19d9mr45738602a91.14.1788848818241;
        Mon, 07 Sep 2026 23:26:58 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ca63b3sm30556614a91.11.2026.09.07.23.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 23:26:57 -0700 (PDT)
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
	ryncsn@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [PATCH v4] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Tue,  8 Sep 2026 14:26:49 +0800
Message-Id: <20260908062649.1045883-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dyfke3m6fuhke4tyxubb44gciir61je9
X-Rspamd-Queue-Id: AC6F240003
X-HE-Tag: 1788848819-212553
X-HE-Meta: U2FsdGVkX1+6R+v3Mpo9DBrg0BkPSm1DTESK/s2tmtSVRk5zZto4DY4A9s96lZXjNfrwhK1td9tT34CxOR2Mq3zjapuVhRwEqRMEZ/bQh1hOrZcwhPZqLSI9umKUdSbJOXFMmd2ckWlgUrbCaq1KoHdlpNrpantUi0u4rzEMsgkVSkyiEX3RAOUq7JbKqJKm1AgRxnAjCMjaXpnKTXydrRcwNp1y3xDpPHwb6UHAFy9Tfuy713qVlye1raTtlL+ipb6o4iipSKjC5JZ+ZYWvM49EUTYUtINm4xzdPphbLHhoXGipFCtLm9nM+lNIF0CSV845YvscMUOfh3ewr60dDz64MrvJzqbCFh6y3idMQUgcHvYXw+XsFFL+g2wDxVJbWHaaPihQOLLMIIC4xK/Ho/jAadEwkC287EifgF5XGXvQ19+HbgocOZCSw7S+p0QDY7DYc+wLANplpoLbb37uoxpSPxRPbEoJzeZuxz2Qjo63dOPc6x5FYvFnezpufkYgRASpdBf7O6ENnxexMzO5hBtIlZeQK9zIIahQUj2Iiz2pmZpz+x77bE67zOhMdN4WPZSX8xR2Ks3LXZeYGZpXMibicRNeJyhGOhLm6KO+5ffwwFFACCw2D0kA4uDcdJjSYk7h05RU/I26DQH6efm2YHqzilh7w3fwUlY2BWNw3teDxoyQ6/6xFyqlUb67kwqBMwIt4G8LTkEn4pqasjQBHqabuzEWPdZllPlzt3xPZt/SMgbVmDASzuGA1ixFHF/W3xk45ybrN+EVw36GPmt2Yp4Mwlizhnmc0dw4iuDhAbfxVAQ9ku3ED7KnTpGqyZ7yeIO9uMHdw17EfWJw8dDerMunwHksAvHrdw/ih4r2qlgbLkGv3VOw/gjzuYCvaxIWO25FUWRI6ILOlqczs9o+MqbtAMr93wSn3iUL6P5E1X9RXmFdEG4Ye2fIMsy8+WOjDvC5lmrSUHfM1WfNlbm
 sJtW3USb
 xAXzQfiNjyUbs0RjGQo0xt+itn/2FAYcHQ0ySDKO3BrPXFb68b01Q7G1kJydxeDl94nB0NJhzlT2SvB99zCrqn5yEQw+aWQV5cTIUj+gAA4zKNGwgkYRze2avdos2DAzBBl1J8oCblB+AbFABzmexroIj6xsWipBW9z4fDoLpSLsFWvBCF59gmI+jb4onUIK23cxngghTwQzt70TxVosGXVLjCNp3YgqJqHsnqNx1g9fyXkCezD8Fz3cSamYizMaVECOHBs5cCzstDRT3WnK0SMGGz9DCd8aMiKFLWovF2JjlzsVE/1SH3ViFq41fDR832VtaLunuZI/72NbGhPjXhb5hYybwUE7SsUdXa41Zbs0s2BSx3QmyFC9AWmAYkwXZs9UG+akWNeq6XOmugQ7dov/wIQLu+QPytVKFhLUO/PDr88Y=
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
v3 -> v4:
 - Do nothing when MGLRU is enabled (lru_gen_enabled()). MGLRU selects the
   scan type in its own path without consulting can_reclaim_anon_pages(),
   so returning false there would not skip anon but would still lower the
   priority computed in set_initial_priority(), potentially making MGLRU
   scan more anon. Left as a FIXME; the MGLRU case needs a larger change.
   (sashiko bot, Barry Song, Kairui Song)
 - Guard the helper with CONFIG_SWAP (NR_SWAPCACHE is only defined under
   CONFIG_SWAP) and return true in the stub. (sashiko bot, Barry Song)
 - Say "GFP_NOIO reclaimer" and trim the comment. (Barry Song)

v2 -> v3:
 - Fix stats source in reclaimable_anon_is_low(): for global reclaim
   (memcg == NULL, e.g. from set_initial_priority()) use node_page_state()
   instead of mem_cgroup_lruvec(NULL), which resolves to the root memcg and
   excludes the child cgroups where anon actually lives. (sashiko bot / AI
   review, raised by Andrew Morton)
 - Add a comment explaining the heuristic and its rationale. (Andrew Morton)
 - Update the comments above the can_reclaim_anon_pages() checks. (Barry Song)
 - Note that only the traditional LRU is addressed; MGLRU is a TODO. (Barry Song)

v1 -> v2:
 - Use mem_cgroup_lruvec() instead of get_lruvec(), which returns the raw
   node lruvec for a NULL memcg and would be misinterpreted by
   lruvec_page_state()'s container_of() during global reclaim. (sashiko
   bot, Barry Song)
 - Drop the SWAP_CLUSTER_MAX cap on the threshold; the check is purely
   proportional now (swapcache below 1/64 of the anon LRU). (Barry Song)
 - Expand the changelog with the workload, the dm-verity/dm-bufio NOIO
   stack, the single shrink_lruvec() breakdown, and the aging trade-off.
   (Johannes Weiner)

 mm/vmscan.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 245f68c75b28..226cbd9e4836 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -362,20 +362,72 @@ static bool can_demote(int nid, struct scan_control *sc,
 	return !nodes_empty(allowed_mask);
 }
 
+#ifdef CONFIG_SWAP
+static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
+		int nid, struct scan_control *sc)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long anon_pages, swapcache;
+
+	/*
+	 * A GFP_NOIO reclaimer can only reclaim anon that is already in the
+	 * swapcache (adding anon to the swapcache needs IO). When swapcache is
+	 * far below the anon LRU, scanning anon reclaims nothing and only burns
+	 * CPU. The 1/64 threshold keeps this to the case where anon is
+	 * effectively unreclaimable.
+	 */
+	if (!sc || (sc->gfp_mask & __GFP_IO))
+		return false;
+
+	/*
+	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
+	 * scanning type, so only apply this to the traditional LRU for now.
+	 */
+	if (lru_gen_enabled())
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
+#else
+static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
+		int nid, struct scan_control *sc)
+{
+	return true;
+}
+#endif /* CONFIG_SWAP */
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


