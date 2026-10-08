Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4D0CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 12:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CBA6B008C; Thu,  8 Oct 2026 08:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2436A6B0096; Thu,  8 Oct 2026 08:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132996B0098; Thu,  8 Oct 2026 08:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD8906B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:01:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 722D0120210
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:01:08 +0000 (UTC)
X-FDA: 85299318216.12.D4A253B
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 99A4618000E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:01:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZrEUx41W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791460866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sFAvEonzWsVz+E/ulC/KEIrSh4b/OG6L9cxESlyjugs=;
	b=aIZjdE/KzPhQR3mMESvL3SMOwlo0ordUzfm42+h69wlQFQnmBEwLGCjDQjrrIq3yvVT2VQ
	sRrR8HxIqSqxXQNUgfm1Vp/kvTeaebsWQ5u77PuIcnTjZ5KVSsDjUvpfqVB9LHMqTgydBD
	7bp8ePzIX7ZoaA859KspRmS6tZVhZxI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZrEUx41W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791460866;
	b=1D3ThXZORWkJcM+m3PGB8i7LhcxgzxqUd2yt+RE8tw6a/yPbFnpFld1HuUeFZSPl2O2CaD
	WuEJde4JnsmYIrxCO5YRAEXuNSvxg7sGcM6TRzXuOiZRcqyHEDDVSxS9tGW2QOTqRwmpxU
	1miaP30l5Wy3p2ZUjeu8O/2MVNzyCoc=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a49623b865so3202102a91.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 05:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791460865; x=1792065665; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sFAvEonzWsVz+E/ulC/KEIrSh4b/OG6L9cxESlyjugs=;
        b=ZrEUx41WqysdutcaTWrqZCeG6/e58JmbxqUu3z0wIjomng12335noY6QCOm2jYTaue
         tOFbziCXf/Zqnesv7J0uJrBJqXJDIL5NhT9EzwI0QgnnVuOuPZIw/K0tJ+oBKeOJEPyF
         qbT0lHz1Z6R0KYwfmTB+2wRFc5jNRmpzFXt/Zza0lEVoHUbB7H4j2lED+nE759GljUSp
         nlkQw++RzGzHMld4M3yThoUc8bFmpKYQOsXS1YmlD5Yo+gQwr0YOGkgT1TcMD0gW8A81
         u8WHNFfl9wpzCzJxXIQDDt4VLS7FnQhwM26NaVSj7cjns9lqucRsjF5IK7JflhJ6bxRP
         MbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791460865; x=1792065665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sFAvEonzWsVz+E/ulC/KEIrSh4b/OG6L9cxESlyjugs=;
        b=KYcIhqDNEWpU6sNX+/AHMPzclTfwUOtUohPTLVvDop6RB04GOkt7LL5+knEyhKxkE0
         ZboxBkVOgWLOdJwwRntbuulV0TKqvqAfKOIZdL90KgdmyE0Ac+EnSnMLGzTQZhZhLV+s
         Gpyl6V48+nkcWj8LGibFBb0NVpxBgU3viIM7RcdMqrFVQzMhaGktyZi8zPEZ/pkG347U
         JoHGkkDlB3ZhxNQqu2d/UwM+rXgybibfwWJa1RtJ/gGXhk3T+Ly5TzYifllgHZONex2e
         k1n5BgP/mnDSpWKq4aW0W/vSj5Gsi/jJL/GsnJ8NcMqlTbs6wttHQYaNumFdGeTR4yjz
         YyPw==
X-Forwarded-Encrypted: i=1; AKwUvBz7tbUDlNfTmLS+grfeTe6Hkms53SQ7FsRfHtZdBH99gzoSkdOdjD9yri6kbtlFISlkoyK52xcb0Q==@kvack.org
X-Gm-Message-State: AFq9FYLcgfmZeZLYbcvUqwPXxrxlC/i0Cuu4SzU3TWNsshUTVa8FDayw
	awLsHM9Eal38KM2iOWrW8vxOPT1nFDnvtslGg8YH5mpQzSiddV7gXzKVyCXw6T2zUUEVGQ==
X-Gm-Gg: AYBFou2K7+HTvsrTf0S9AovusQNUsPoNDxAOYPFEGIO6Mb/8Wcp70Yy+zDdhY2oSjlw
	P+yvZDCjxtQHauVuINd5hlepeKaO8y+nM4MWRIG2KbzwdR4I/WYHNcOVt9ohEe0PlP5fa8kgBov
	79omckFFcDug11qrGQgT6+C7+cdVyg7vLfrG4qAoADJZXKdyAY7ZGFX45uZjiQmyJtqtCfelrFl
	IW2wLoCGSwtJZW3IvA6MwwMPeLD3ZaJp76EDiHYr9OyYTgIWowDr7JVg2szBl0QHN5pOMPIiZgx
	MbMb4pqnbyWELqQ+2Bs1gXjIT6B5ZPFzvJ1G1YTtPeb3N5+vlstWpVsbluDkcekKgBakCV8KVeV
	k7NPnJ3Uf4OYsBbf2ScKtjoxTfJHrTlWI1aNn9DYrG4FEdnuKwsY+woKvpA+jSc149vdpBZVNd9
	XBvTU8eFePpY3itGDmOY38lAmX2ueB5SnFkIbskISMOSpgowi3b2erB7U3VQFuP8prp8/V24J0m
	Bz7454vgLZc/WxTcA==
X-Received: by 2002:a17:90b:28d0:b0:3a8:768d:70e4 with SMTP id 98e67ed59e1d1-3a8a1b59a17mr4486706a91.17.1791460865210;
        Thu, 08 Oct 2026 05:01:05 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff817537sm3901580a91.8.2026.10.08.05.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 05:01:04 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhangbo56@xiaomi.com
Subject: [RFC PATCH] mm: vmscan: avoid over-reclaim in classic LRU direct reclaim path
Date: Thu,  8 Oct 2026 20:00:56 +0800
Message-Id: <20261008120056.575272-1-zhangbo0325@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ir77zqebudn9sftx81jca6rzn59rcmhy
X-Rspam-User: 
X-Rspamd-Queue-Id: 99A4618000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1791460866-948964
X-HE-Meta: U2FsdGVkX1/Nj/sNFC1V0WHHpOy9RNVOluPGg37p9GG/ZksbXKJVzwFc0xCUn9bppyeculgtXHq76D1kGDiZhvYADOnXdmP7idUFhix6qbnPBGshHaMbU79+EHGKrhr384YIdI2hkWhTMK63aEoBDLgH5oAxNljJOh66aCB82l3wyUl5yApz1EMxigKihDwdeaFJykJH7Nvt/Ho9W1koW5vzC2bp3S774YGYEUCjwcUtqjPFoX3a5y2XuJZf0ST19p21SinPc/e0aDL4a8gUs3kWJpM5BsThb0OFCocxM6d+IRZqIZ7oGvTtr8FDmtwKo1smzjvjyXg0MhoZ/JVBi1q4NhkSuAnMiSQ+n14vny5uhuTg1Pf1kceGKy7zdgLODJBY7FlNa7SvLECZWanr5e817CdKY8i7lxGCYqt+BxpM308c3cBusEC5pIWIZUslXfqYSlYePPLTXUBTkqS+yGApugNC/4rdTZFLJqFoOKO58wDct/kxwBfy/c/Swj/OimjzcrL6Cm3xAN/czFNfjUb5S8IeULxFpSSavVtz9jfZWTFA5x2Jojj4xk5oq0g2UDcJcVYzqZVaRtcdLhZRjpCf/cBwoUT+BwHx2Xh9EkXBZUJfpun63X04xnnyxey2hjvKcM4m7WfBxSGLpN7GnX7UWs1S3tdxh2Ogrxk5VzCJ1ugmCxrwR/dImF80oahYYan5TQp5Q1UswzvcSDWt/p5Y2uwwiNDe169vuTSOVjGq6TmW9KqXXESDApRYt8m8I28aN2hvDARr996itplXDPfFF49/g3pQDea1TjGYU9g4qB0zZA7/F1Y4TE9Zb/EGG4aUbXwjYjwIYPWLjcwKnpZBiXl6L2zelHW8lKNawwVCQ8hh593QehPf+qdrAe4jj1GkVRx0JJx5IGsYeJKwFbITGRi4uCJyOnXHWY+KDnfkDF/TZNYpJI7a+W8B2oUjwfalGrw4EdpdNGXu3ES
 /gDEDEG+
 i27YtW0c9IYr8nc/WmZNFh+MCPImpy09VHoW5GGEEB6kopXHre50U+Co5ylIqtvh5mqFMbWWZxg7qYOZbfbNaOwHV9dEWKgewux9XXJPR2S/XDPZJ51CsK71v9Hxp3cu1QvUbYAI/sjt4ZjvutRoI5e/WU8qBnWKY97dRQNhTWaO6fK7QvB5lzF5LJKMN1mf46hdW87Qr7aYJOM+uaoGiBe+bMeHLqCv15XVMkrOcqWJLfTvMk+XUrqsoTcintleXSNdDAqP7tJLKZ8f7GaRnPngap+u3HfLvH8n6R9l4y3aRcSDkWYo6FoAaHNxuf+1rZn7d7MgZOE2wQt3lCJJp8+zfy2d0hdBVl/MybnI05L61m4wAyvxKCdK6bVLbY/fHpmEjaaNa4Bl/aq87THzLlEbj9iQBYaBLj4Hp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bo Zhang <zhangbo56@xiaomi.com>

On production Android devices, direct reclaim is a frequent source of
unpredictable, large latency spikes. A direct reclaim request typically
asks for only nr_to_reclaim = SWAP_CLUSTER_MAX (32) pages, and in the
common case completes in well under a millisecond. But the classic LRU
path has no reliable "goal met" check, so under memory pressure a single
reclaim can scan tens of thousands of pages and free hundreds to
thousands - far beyond the 32 requested - before returning.

Pooling the 20 slowest direct-reclaim events, before this patch the
worst case scanned 130,079 pages and reclaimed 1,635, and the average
scanned 37,955 pages and reclaimed 881.

The root cause is over-reclaim: the classic LRU path keeps scanning well
past its target in two ways:

1. shrink_lruvec() does not stop as soon as nr_to_reclaim is met; it
   keeps scanning the remaining LRU batches, over-reclaiming past the
   target.

2. shrink_node_memcgs() only breaks early on a partial walk. When the
   initial partial walk misses nr_to_reclaim, do_try_to_free_pages()
   retries with a full walk, which has no "goal met" check and shrinks
   every memcg in the tree even after the target is satisfied.

Add an early exit to shrink_lruvec() and shrink_node_memcgs(), and the
matching check to should_continue_reclaim(), all keyed on

    sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order))

The compact_gap() term keeps correctness for high-order reclaim, where
nr_to_reclaim alone may be too small to free a block of the requested
order; MGLRU's should_abort_scan() uses the same threshold. Using it in
all three places keeps the retry decision consistent with where reclaim
actually stops.

After this patch, over the same 20 slowest events the worst case scans
45,593 pages and reclaims 57, and the average scans 6,399 pages and
reclaims 38 - reclaim now stays close to the requested target instead
of running far past it. Removing this over-reclaim greatly reduces the
direct-reclaim tail latency, which significantly cuts the jank caused by
direct reclaim on interactive workloads.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/vmscan.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91295070ca33..b1efbd2a9bb6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6236,6 +6236,18 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 		cond_resched_tasks_rcu_qs();
 
+		/*
+		 * For high-order allocations, nr_to_reclaim may be smaller
+		 * than what is needed to make a block of the requested order
+		 * available for compaction. When memory is plentiful, keep
+		 * reclaiming until at least compact_gap() pages have been
+		 * freed so the target order can actually be satisfied.
+		 */
+		if (!cgroup_reclaim(sc) &&
+		    sc->nr_reclaimed + nr_reclaimed >=
+		    max(nr_to_reclaim, compact_gap(sc->order)))
+			break;
+
 		if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
 			continue;
 
@@ -6345,6 +6357,16 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
 	if (!nr_reclaimed)
 		return false;
 
+	/*
+	 * Stop once the overall reclaim goal is met, using the same
+	 * max(nr_to_reclaim, compact_gap()) threshold as the early exits
+	 * in shrink_lruvec() and shrink_node_memcgs(), so the retry
+	 * decision here stays consistent with where reclaim actually
+	 * stops.
+	 */
+	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
+		return false;
+
 	/* If compaction would go ahead or the allocation would succeed, stop */
 	for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
 		unsigned long watermark = min_wmark_pages(zone);
@@ -6442,8 +6464,17 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
-		/* If partial walks are allowed, bail once goal is reached */
-		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+		/*
+		 * Break loop once the overall reclaim goal is met. For
+		 * high-order allocations nr_to_reclaim may be too small to
+		 * free a block of the requested order, so when memory is
+		 * plentiful keep going until at least compact_gap() pages
+		 * have been reclaimed. This applies to both partial and full
+		 * walks: a full walk is only a means to reach the goal, not a
+		 * requirement to visit every memcg.
+		 */
+		if (sc->nr_reclaimed >= max(sc->nr_to_reclaim,
+					    compact_gap(sc->order))) {
 			mem_cgroup_iter_break(target_memcg, memcg);
 			break;
 		}
-- 
2.34.1


