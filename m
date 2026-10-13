Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA64CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2126B0088; Tue, 13 Oct 2026 06:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52556B008C; Tue, 13 Oct 2026 06:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B418D6B0095; Tue, 13 Oct 2026 06:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8D36B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:04:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07B621603EC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:04:48 +0000 (UTC)
X-FDA: 85317169098.16.811892A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1F55D120009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:04:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gjILU8j2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791885887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1jYaJsJWKbtGzJy/HJoeJLXuIxCNsYYjZhCxL9zYpc=;
	b=p9HWrPLDbN5E9YVRSVRp8gr4pynxEtOSWAX9jXwJBvrPdZRI1l5rQI+iea+1F4NvZ/8Szd
	jzyog2LQORelhHpY6wC0D5DgTqYEppkve9TRBzAwEjL0UB084dgy4vSN9Dgf+8TBeuV0TP
	NgjVcOHYkKEvG/FOyqs47KreTbz9tec=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gjILU8j2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791885887;
	b=lrgkrHorc21jGRvYUSLLA57KYtZ2uZX5Qn80Djc9fc2a+TIFnmre+eIykYtPSd1aLOVgJe
	ZneBcmDwMXHMsqJ6olRhuN5IEbbJM5OWjwDUBELvbvFmlOFsOFSr70YEAKBRbjUqYxfnVQ
	VOarhJ4bmuTGMM5FC49Ab0RIYBs5og8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94B64600D1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF791F00898
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885886;
	bh=W1jYaJsJWKbtGzJy/HJoeJLXuIxCNsYYjZhCxL9zYpc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gjILU8j2DaXsj5n/G8+NiU66FRZ/Loe9pED8Ai9fx9nE6o8YUa00RK/ah7G2jS31f
	 MHbjHGghZ8gzZWbCR9ogyAs+9wttwr5OjS7BqM712p+PoqW2DKYJUITx3HT9h1RDBJ
	 F9sSTxCVlvoyN/HY02CKykl5hSEtURYbsXRC36CkenZFgpZWszl/6eAgMK18KnCCLV
	 jPbv/aZZxqnmc0/oEIk4ZMnohwuYuunpBp1rOZSAsetTyeemE/YZf3sMOzuq84lASx
	 +DTKHJUAreIy3FZRZDOzYa2Sp6O3E9Jf9NlybuI/0qAjM/15lUji3duEb3hZbYa9x0
	 uhakwT6fmbd3Q==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93cbc3ab2fdso117497685a.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:04:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByFk9N3M2lahPNwemhD5U1Q7msFQRWZeyJJ0iYGThSHffgw7Jq9BPLSeTTBlG4Y2L1PPO/l8NrEng==@kvack.org
X-Gm-Message-State: AFq9FYJXbLbjIXDzRSFNBnjsLjqPMXD/jnox6ATJ2AIDLNJL1mQPifmw
	Cq/zGBaV7+u4sWf6ssAphUWV+6NXsXcazWmw79kb5BvXIh42q7Ov03JDqTJN4eihtrTKiLxbx+g
	9eLkP/UqK0HjlKfQ60OL6Ejx02sCVghA=
X-Received: by 2002:a05:620a:4510:b0:93c:ba88:cd65 with SMTP id
 af79cd13be357-93ebd0bd246mr1824688985a.7.1791885885578; Tue, 13 Oct 2026
 03:04:45 -0700 (PDT)
MIME-Version: 1.0
References: <20261008120056.575272-1-zhangbo0325@gmail.com>
In-Reply-To: <20261008120056.575272-1-zhangbo0325@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 13 Oct 2026 18:04:33 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yVBZReovJhFXoBiyfkZiLB+dXDy10wN+1vncXAtkZViw@mail.gmail.com>
X-Gm-Features: AclHuK9Ccz7PwMZKiwaGjY52Gw4PLg7A_mwWuGMRFRo1982YaOvUkW7BK5afPPU
Message-ID: <CAGsJ_4yVBZReovJhFXoBiyfkZiLB+dXDy10wN+1vncXAtkZViw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: vmscan: avoid over-reclaim in classic LRU direct
 reclaim path
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org, 
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 68q6jsf1sudptfz3qz5h7hjizkjq6y8t
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F55D120009
X-Rspamd-Server: rspam08
X-HE-Tag: 1791885886-141082
X-HE-Meta: U2FsdGVkX1+O4DZbupW0r3+fRpS+C79Hkv4UswnjSOxakeOL1cv0Q6nGKKhlLJjgI1shlmJn62ej3ok6GOYH/Ihxrq9NbFLvbP2G6hlypM/DUFjQVTvrePA0WZ2gH9QX6R5Nn0anTk3sSOCRmeHsRL2ltT21JrMoWXnXncsYDT9zf8OTID6VRx/9DHqLLc+GpKjgDZ0YnESytd6Y2QZZ9/dLKcsZx4eGRV9zLlxoZ1R0dPAQnNwpIgC2nBUXTtnVlYL1XyvZ6T/Ypye+fRaiBxxUsWbcQtgJOOmsSWZysRywE04l7JX5ul4ND1xvUdTC6R6//FV9g7N8vwtitBUnrx2OIpIvEVRzhkMT593RReT0D/NyxNMDRG2iUMTi+zU1P5QBymczBr5l7XkHxHL9MG9vs7O+/9R9CvrSPj5QpmRrf2m3mxtSZTIfeWzXmeBz/2UGYrZcRGGeXBxnCJGq0rfzUzfyO47STNS/sF30kl/Ltw6swx3Dd2E18ViOOH4O1EkJ0uAAL9CHgQN3/Ke0YBf7L5Ah25FZM8GJPILX87+8egDXcRR15RE7tOf6anTDvA0Z7hz9+ctYJdB7jj9LL/jKfT1hgK/SEh89qokKmsNd4Nb4kRYtwMmBoqfq95mxt4aRS2I+LWvJORNJjCh6Atk22DX0dcEcr+KGs3TZPDIeWBaqNbbgqIEaXY3IIgjPWXyaBhvmavwOZxuZo9CiWJekqrv2QsDfIjOkZsw+GqygK/1r/uyh3YQkInTlU/D6kqEHS9CAhd2ikhv5lDmczbJgifE4EeOccOPlJnHiiIdPiaN6Ktif/0Wqweuw2B1jSB5AIkMELArSjD+BIatg9ho3BG04WUVzTP/LQojOiw1Y6TbhImWusEb+ACl3AMEU0A3hB8SJPzkmFEYJkOeSu4KlJTQObDccK0owN4DIpxmG8m1oW3Guyvb5pAgnG2Ocz8C03QIYFjqKcvp1K9b
 yHsmTw5S
 YfPnkD9M46gIK8Z0voCXL8G7B0PvRjZt+uXYTFgu2AQAMD5NI2THpmpG/S6vsgftKeGWmCv/1giuZlw3/1YT4ScFhTtC//um85IpzSFp8254YlPrqvcD1cax+rgNBGgv8W4UCvVrHaQz3aTj8546fkHqaO1bIxlKXSxy6i+Rw1LJ2gCz+x6Uj/YaSVK5S30HkZlBg5NuECsuCN5p/1r+CP2/KJDeT1aILpVE6kpRS5CQuKWDB9Hk7st2lGYb0pyPgTly4YTXYPxg7HW90APOxAr7K4H3UACWAx8MfeC4CiLnUUxfDm5FZeO5hsWCZs0x8WgF5jP9UM4UWEAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 8:01=E2=80=AFPM Bo Zhang <zhangbo0325@gmail.com> wro=
te:
>
> From: Bo Zhang <zhangbo56@xiaomi.com>
>
> On production Android devices, direct reclaim is a frequent source of
> unpredictable, large latency spikes. A direct reclaim request typically
> asks for only nr_to_reclaim =3D SWAP_CLUSTER_MAX (32) pages, and in the
> common case completes in well under a millisecond. But the classic LRU
> path has no reliable "goal met" check, so under memory pressure a single
> reclaim can scan tens of thousands of pages and free hundreds to
> thousands - far beyond the 32 requested - before returning.
>
> Pooling the 20 slowest direct-reclaim events, before this patch the
> worst case scanned 130,079 pages and reclaimed 1,635, and the average
> scanned 37,955 pages and reclaimed 881.
>
> The root cause is over-reclaim: the classic LRU path keeps scanning well
> past its target in two ways:
>
> 1. shrink_lruvec() does not stop as soon as nr_to_reclaim is met; it
>    keeps scanning the remaining LRU batches, over-reclaiming past the
>    target.
>
> 2. shrink_node_memcgs() only breaks early on a partial walk. When the
>    initial partial walk misses nr_to_reclaim, do_try_to_free_pages()
>    retries with a full walk, which has no "goal met" check and shrinks
>    every memcg in the tree even after the target is satisfied.
>
> Add an early exit to shrink_lruvec() and shrink_node_memcgs(), and the
> matching check to should_continue_reclaim(), all keyed on
>
>     sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc->order))
>
> The compact_gap() term keeps correctness for high-order reclaim, where
> nr_to_reclaim alone may be too small to free a block of the requested
> order; MGLRU's should_abort_scan() uses the same threshold. Using it in
> all three places keeps the retry decision consistent with where reclaim
> actually stops.
>
> After this patch, over the same 20 slowest events the worst case scans
> 45,593 pages and reclaims 57, and the average scans 6,399 pages and
> reclaims 38 - reclaim now stays close to the requested target instead
> of running far past it. Removing this over-reclaim greatly reduces the
> direct-reclaim tail latency, which significantly cuts the jank caused by
> direct reclaim on interactive workloads.
>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
>  mm/vmscan.c | 35 +++++++++++++++++++++++++++++++++--
>  1 file changed, 33 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 91295070ca33..b1efbd2a9bb6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6236,6 +6236,18 @@ static void shrink_lruvec(struct lruvec *lruvec, s=
truct scan_control *sc)
>
>                 cond_resched_tasks_rcu_qs();
>
> +               /*
> +                * For high-order allocations, nr_to_reclaim may be small=
er
> +                * than what is needed to make a block of the requested o=
rder
> +                * available for compaction. When memory is plentiful, ke=
ep
> +                * reclaiming until at least compact_gap() pages have bee=
n
> +                * freed so the target order can actually be satisfied.
> +                */
> +               if (!cgroup_reclaim(sc) &&
> +                   sc->nr_reclaimed + nr_reclaimed >=3D
> +                   max(nr_to_reclaim, compact_gap(sc->order)))
> +                       break;
> +

Let's assume `nr[file] =3D 300` and `nr[anon] =3D 100` for now.
Breaking out of the loop earlier would break the proportional
scanning of file and anon.

The current algorithm is:

for_each_evictable_lru(lru) {
        if (nr[lru]) {
                nr_to_scan =3D min(nr[lru], SWAP_CLUSTER_MAX);
                nr[lru] -=3D nr_to_scan;

                nr_reclaimed +=3D shrink_list(lru, nr_to_scan,
                                            lruvec, sc);
        }
}

This results in the following scan pattern:

32 file - 32 anon
32 file - 32 anon
32 file - 32 anon
32 file -  4 anon
32 file -  0 anon
32 file -  0 anon
32 file -  0 anon
32 file -  0 anon
...

Eventually, the proportional scanning balance is still correct.

With your earlier exit condition, however, we could end up with:

32 file - 32 anon
32 file - 32 anon
32 file - 32 anon
-> target reached, exit

In this case, we scan file and anon at a 1:1 ratio, which
doesn't reflect the intended 3:1 ratio.

The original code maintains the scan ratio by setting the
smaller count to 0 while keeping a nonzero count for the
larger one, allowing it to continue scanning:

              /* Stop scanning the smaller of the LRU */
                nr[lru] =3D 0;
                nr[lru + LRU_ACTIVE] =3D 0;

                /*
                 * Recalculate the other LRU scan count based on its origin=
al
                 * scan target and the percentage scanning already complete
                 */
                lru =3D (lru =3D=3D LRU_FILE) ? LRU_BASE : LRU_FILE;
                nr_scanned =3D targets[lru] - nr[lru];
                nr[lru] =3D targets[lru] * (100 - percentage) / 100;
                nr[lru] -=3D min(nr[lru], nr_scanned);

                lru +=3D LRU_ACTIVE;
                nr_scanned =3D targets[lru] - nr[lru];
                nr[lru] =3D targets[lru] * (100 - percentage) / 100;
                nr[lru] -=3D min(nr[lru], nr_scanned);

This simply reflects the need to respect swappiness.

>                 if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
>                         continue;
>
> @@ -6345,6 +6357,16 @@ static inline bool should_continue_reclaim(struct =
pglist_data *pgdat,
>         if (!nr_reclaimed)
>                 return false;
>
> +       /*
> +        * Stop once the overall reclaim goal is met, using the same
> +        * max(nr_to_reclaim, compact_gap()) threshold as the early exits
> +        * in shrink_lruvec() and shrink_node_memcgs(), so the retry
> +        * decision here stays consistent with where reclaim actually
> +        * stops.
> +        */
> +       if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc->=
order)))
> +               return false;
> +
>         /* If compaction would go ahead or the allocation would succeed, =
stop */
>         for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
>                 unsigned long watermark =3D min_wmark_pages(zone);
> @@ -6442,8 +6464,17 @@ static void shrink_node_memcgs(pg_data_t *pgdat, s=
truct scan_control *sc)
>                                    sc->nr_scanned - scanned,
>                                    sc->nr_reclaimed - reclaimed);
>
> -               /* If partial walks are allowed, bail once goal is reache=
d */
> -               if (partial && sc->nr_reclaimed >=3D sc->nr_to_reclaim) {
> +               /*
> +                * Break loop once the overall reclaim goal is met. For
> +                * high-order allocations nr_to_reclaim may be too small =
to
> +                * free a block of the requested order, so when memory is
> +                * plentiful keep going until at least compact_gap() page=
s
> +                * have been reclaimed. This applies to both partial and =
full
> +                * walks: a full walk is only a means to reach the goal, =
not a
> +                * requirement to visit every memcg.
> +                */
> +               if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim,
> +                                           compact_gap(sc->order))) {

Sashiko raised a concern that this might break memcg balancing
for kswapd. For example, we might keep reclaiming memory from
the root memcg. This seems to be a valid concern, so perhaps
this should only apply to direct reclaim, not kswapd.


>                         mem_cgroup_iter_break(target_memcg, memcg);
>                         break;
>                 }

Thanks
Barry

