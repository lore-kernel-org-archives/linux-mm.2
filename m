Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33C9606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 03:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jz7ypLXH
Received: by kanga.kvack.org (Postfix)
	id 958A16B05B1; Fri, 13 Nov 2026 22:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2866B05B2; Fri, 13 Nov 2026 22:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA486B05B3; Fri, 13 Nov 2026 22:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45A1D6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:13:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5C1B80362
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:13:31 +0000 (UTC)
X-FDA: 85432254222.17.0935F33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0159140003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:13:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jz7ypLXH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794626010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9IOEBIrVS7EyMIq2HdtZ7KheCdcP8IiUqiO/KKgg2E=;
	b=FQ0wkkgCYRFsYqC+SDOPywc2wqKclqnUvAfK3qRfJE930vU0GzNSB/vxFz5I+kLic93Ydb
	ti3stqP18VDqh8pWgRWXQsw7D8F5sf0MCKgixoeenBOL5aHlSOZeYlH6UxMRE+/jLSAXZX
	jlYPXWwLhPM9Um9m1xwudotoYlB7gGM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jz7ypLXH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794626010;
	b=1voLyCygx5LSFlFacuD9HsafYRhWruZK3MwUNvaKpbOCIE35O1pcr3OZ5S85a8bKEdBUl2
	7Y/12/vWIddOQ4WKF9FS8Y+20k5UGgQOoUd+fkw1/2fbmP9aiNOMU1FPNKLqEm/nBTlckc
	s5uqMDyQgXKYn/yfTKjZXogjheLC9dY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35457400B5;
	Sat, 14 Nov 2026 03:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E851F000C4;
	Sat, 14 Nov 2026 03:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626009;
	bh=T9IOEBIrVS7EyMIq2HdtZ7KheCdcP8IiUqiO/KKgg2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jz7ypLXHDluqDFngyu4+kwvgOf0+mYjJ6nfs+gn/4WC09+swwjXYBA4PslS+0RsuG
	 X14cTka7M0TxE16SUC4n3GFHn0/RORi0TMhjo3AwFMXcdVavZPt7PicA5GeGY/qSN+
	 qmo+uvfOgz5Zn3heMSeX6zrpTVk6VjMYL/8SV7zEXdcF8+IUOx2xWzDBgw65qCOO9/
	 V2yQrL8EvCv+TCDwm7uGjlC5rKeOs0VC5xiyIbNaslyjIiiPwntTAkb33s5JHHuG4U
	 +JupLid3y5wo8imKaXcK9KMrKVvbHpIy8JkBdZIxdxyqLbvE0pR/UwV5xSZyg8g/tw
	 n+AjnHguwO4zA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: sashiko-bot@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	sashiko-reviews@lists.linux.dev,
	shakeel.butt@linux.dev,
	sidchintamaneni@gmail.com,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn
Subject: Re: [PATCH v8 12/16] mm/mglru: Restrict eviction accounting to eligible zones
Date: Sat, 14 Nov 2026 11:13:22 +0800
Message-Id: <20261114031322.19089-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <sashiko-outbox-214031@kernel.org>
References: <sashiko-outbox-214031@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0159140003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: i7x35fu8fs7bppsbdpiw61cabujyw34q
X-HE-Tag: 1794626009-829085
X-HE-Meta: U2FsdGVkX1+z241x211rLqPXwFx0seQyRgjvd+DKK63Itp4f0d/lFZHKYfkHZ5gL/yL+JSflWNSYTfAwFBEOuooZ4hj/31ghHPU5NuRaDlG7FsSTCjDMWFTgkIogrILogUmTDY2H1VV+7eEF9eRO9XnGj7aXEOSKVWd+FJdMH12HDvbXoc3CZsbOv/SOJiHbzadf7N/3f7aXVgYG2gusl8qNEGSuf9+ItGKacg6qL8unZulX7+1OHIqQdCmvpkSb7hRacvfVjnCcM3ndop02hdgqyJZapqDfc7TBD6RAu0N4hHMGc8yS4Hq03HKAAtG2smkZlkjT0wlGfQlxEZSX9A7+sllliZaJnEp6jFhejY0Hllg+8lnY5iNQnCX31r5kBIn4XgC9F8GEYmgsIbZO6flAeN9UpCF+7yinbHj9blBTjviciKMhN7Z8HyuyuVaQ6EVh5yBeSEsF/UFpOc1gRyBMg2Cwwrx+tAFZbIEtFxaE8+Iyqb7RKvuHvnIeJWUT9Rb2DlJUFXidkiqO329jUz9h/yroxKH2pQClrszgg8XoKIm9XYVhl4jI9Dwn8rICt/1h5xBjokCz2huI/NC6XFq9Xn1BUQTl2L2JH7PE/5kkD5m3/siAXyv0NqkKYqpiGPs+3KmCeIACKQ/mS4e5EIei1o6k6GhJg8HNXF3OBcCvVCbq5c0mBLZLn01K/CDeRowvZy1JZwiFjv8K9Yt+z7L/AKflO+ig6Xr4kouLntAFN6JptkaTZ8IrffN75AnPRYvD9r5VMrffApANVX5eZukGgc1NyFrox7m4dAxIBnLEmFQpvgFMYZFZlOvbZ0/Usm2V2xbVXh+yPMsM4Y6n+JwUeVhyR1blzgVDpeEmbt8B5B4Kf1RyD4bnMZvN+9/J3+cKK0hCEozFY4uzOdhokQgzL0p9syQ0boiYjmxD2QSv3vhzF4mIZkkk/sKvY+4xewf9DQiaIkrVhBU83nV
 7B7QIHTp
 tnePu8Ra/lLlEJQv5JJQp/CfMokVHS2S4a6vV17qNNqBzKfcanS5icnb/Seb5Z+g9MeoWFhvah1MGQ1beoMLqe0PsxoGnfYrqRi3EN1eS3hcCZchiciayscla0NjlG43XsG816U+7fLQRT0XvX5JhvSfmGf5rBkGciOu1SZOZB0PsRmEW5J+0ojIj/9OqsK4q/jo4tGaHthk6K7qO/44WtTTi1ZMmmQ+qLfmSH0L1aVGduP7omXvHgoSpvASXYEjpy2AXjj1M77D19Ohr/A1iqYaCamj8Km2idYaB9DW+fvePgs0cfJZxV9ElNNnYi+2kisdrBqpPO18ShLxqbnxYmED5b1Dtd1YEWMEOrDQxa2+C9/87bJLsIlj/zn7IaB2+YKP78ha7qHLpvEQr12w+uWjXSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 10:02 AM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/mglru: broken min_ttl and low-zone OOM checks in
>   lruvec_is_reclaimable()
> --
>
> commit 4a520d7db30ed5c782371c3ef4bdf4fd79c1de3e
> Author: Barry Song (Xiaomi) <baohua@kernel.org>
>
> mm/mglru: Restrict eviction accounting to eligible zones
>
> This commit restricts lruvec_evictable_size() and lru_gen_imbalanced() to
> count only zones up to sc->reclaim_idx, and defers the lruvec_is_sizable()
> check in lruvec_is_reclaimable() to low priorities when sc->reclaim_idx is
> at least ZONE_NORMAL.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9071f8889b5c4..6ed47089a3305 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4205,8 +4205,8 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
> >       sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
> >  }
> >
> > -static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> > -                               unsigned long nr[])
> > +static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
> > +                               int swappiness, unsigned long nr[])
> >  {
> >       int type;
> >       unsigned long seq;
> > @@ -4219,7 +4219,7 @@ static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> >
> >       for_each_evictable_type(type, swappiness) {
> >               for (seq = min_seq[type]; seq <= max_seq; seq++)
> > -                     nr[type] += lruvec_gen_size(lrugen, type, seq);
> > +                     nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
> >       }
> >  }
> >
> > @@ -4228,7 +4228,7 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
> >       unsigned long total, sizes[ANON_AND_FILE];
> >       int swappiness = get_swappiness(lruvec, sc);
> >
> > -     lruvec_evictable_size(lruvec, swappiness, sizes);
> > +     lruvec_evictable_size(lruvec, sc, swappiness, sizes);
> >       total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> >
> >       /* whether the size is big enough to be helpful */
> > @@ -4247,7 +4247,13 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
> >       if (mem_cgroup_below_min(NULL, memcg))
> >               return false;
> >
> > -     if (!lruvec_is_sizable(lruvec, sc))
> > +     /*
> > +      * As in __alloc_pages_may_oom(), avoid triggering OOM for low-zone
> > +      * allocations. Also, defer the LRU size check until reclaim reaches
> > +      * a very low priority to avoid premature OOM.
> > +      */
> > +     if (sc->priority <= 1 && sc->reclaim_idx >= ZONE_NORMAL &&
> > +         !lruvec_is_sizable(lruvec, sc))
> >               return false;
> >
> >       gen = lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
>
> [Severity: High]
> Does skipping lruvec_is_sizable() at sc->priority > 1 bypass min_ttl_ms
> working-set protection whenever any empty memcg exists?
>
> For a memcg with no evictable pages (such as root_mem_cgroup or non-leaf
> slice cgroups like system.slice under cgroup v2), lru_gen_prepare_scan()
> computes a zero scan budget, so try_to_shrink_lruvec() never ages it and
> lrugen.timestamps[0] remains at its creation time.  At priorities
> DEF_PRIORITY down to 2, lruvec_is_sizable() is no longer called to filter
> out empty memcgs, so any empty memcg older than min_ttl returns true from
> time_is_before_jiffies(birth + min_ttl) and sets reclaimable = true in
> lru_gen_age_node():
>
> mm/vmscan.c:lru_gen_age_node() {
>         ...
>                 if (!reclaimable)
>                         reclaimable = lruvec_is_reclaimable(lruvec, sc, min_ttl);
>         } while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
>
>         if (!reclaimable && mutex_trylock(&oom_lock)) {
>                 struct oom_control oc = {
>                         .gfp_mask = sc->gfp_mask,
>                 };
>
>                 out_of_memory(&oc);
> }
>
> kswapd_shrink_node() then runs and evicts folios from active memcgs even
> when all of their generations are younger than min_ttl, satisfying reclaim
> before sc.priority reaches 1.

The empty memcg issue seems valid.

However, reclaiming from active memcgs can happen even without
this patchset.

For example, consider two memcgs:

memcg A: Its oldest generation is younger than min_ttl.
memcg B: Its oldest generation is older than min_ttl.

In this case, reclaimable can still be true because of memcg B,
allowing reclaim to proceed against memcg A.

Therefore, unless we enforce min_ttl for each memcg during reclaim,
this behavior cannot be avoided.


>
> In addition, checking sc->reclaim_idx >= ZONE_NORMAL only around
> !lruvec_is_sizable() does not prevent low-zone OOM kills: when
> sc->reclaim_idx < ZONE_NORMAL and all memcgs have timestamps younger than
> min_ttl, lruvec_is_reclaimable() still returns false and lru_gen_age_node()
> still calls out_of_memory().

I think this is expected behavior. If all memcgs have only generations
younger than min_ttl, out_of_memory() should be called regardless of
sc->reclaim_idx, since we are supposed to protect folios younger than
min_ttl.


>
> Finally, because lruvec_evictable_size() now sums only zones up to
> sc->reclaim_idx, if kswapd reclaims with sc.reclaim_idx == ZONE_NORMAL when
> user LRU folios sit in ZONE_MOVABLE or ZONE_HIGHMEM and ZONE_NORMAL has
> fewer than 2 evictable pages per memcg, sc.priority drops to 1 and
> lruvec_is_sizable() returns false for all memcgs, triggering a global OOM
> kill while higher zones have reclaimable memory older than min_ttl.

I'm not convinced this is a problem. The allocation requires memory
from ZONE_NORMAL, but we cannot satisfy that request if all memcgs
have fewer than two reclaimable folios in ZONE_NORMAL. Wouldn't OOM
be expected in this case?

I think we need a separate patch series to properly address the
min_ttl issues. Even in mainline, min_ttl does not work as expected.

The first problem is that reclaim does not enforce min_ttl on a
per-memcg basis, so folios from memcgs whose generations are all
younger than min_ttl can still be reclaimed.

The second problem is that the LRU size check is coupled with the
min_ttl check, which can lead to premature OOM. For example, consider
a system with 100 memcgs, each containing fewer than 16 MB of
evictable folios. At priority 12, shifting each memcg's LRU size
by sc->priority can yield zero, causing all memcgs to be considered
unreclaimable even if their generations are older than min_ttl.

I think these issues deserve a separate patch series rather than
being addressed as part of this eviction accounting change.

For now, I'd prefer to preserve the existing min_ttl behavior by
continuing to count folios from all zones in the min_ttl path,
rather than adding more complexity to this patchset.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 18a3332c71e9..0ab3c60cd2f9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4199,7 +4199,8 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 }
 
 static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
-				  int swappiness, unsigned long nr[])
+				  int swappiness, unsigned long nr[],
+				  int max_zone)
 {
 	int type;
 	unsigned long seq;
@@ -4216,16 +4217,17 @@ static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc
 		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
 			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
+			nr[type] += lruvec_gen_size(lrugen, type, seq, max_zone);
 	}
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc,
+		int max_zone)
 {
 	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
+	lruvec_evictable_size(lruvec, sc, swappiness, sizes, max_zone);
 	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
@@ -4244,13 +4246,8 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
 	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
-	/*
-	 * As in __alloc_pages_may_oom(), avoid triggering OOM for low-zone
-	 * allocations. Also, defer the LRU size check until reclaim reaches
-	 * a very low priority to avoid premature OOM.
-	 */
-	if (sc->priority <= 1 && sc->reclaim_idx >= ZONE_NORMAL &&
-	    !lruvec_is_sizable(lruvec, sc))
+	/* counting all zones to avoid premature OOM */
+	if (!lruvec_is_sizable(lruvec, sc, MAX_NR_ZONES))
 		return false;
 
 	gen = lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
@@ -5151,7 +5148,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	unsigned long total;
 
-	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
+	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
 	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
 
 	total = apply_proportional_protection(memcg, sc, total);
@@ -5332,7 +5329,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	if (need_rotate)
 		return MEMCG_LRU_YOUNG;
 
-	if (lruvec_is_sizable(lruvec, sc))
+	if (lruvec_is_sizable(lruvec, sc, sc->reclaim_idx + 1))
 		return 0;
 
 	/* one retry if too small */
@@ -5915,7 +5912,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
+		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
 		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261113185541.70203-1-baohua@kernel.org?part=12

