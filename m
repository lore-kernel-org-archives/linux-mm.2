Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A28C79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 04:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4886B00C4; Sun,  6 Sep 2026 00:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA7D6B00C5; Sun,  6 Sep 2026 00:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0B36B00C6; Sun,  6 Sep 2026 00:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 546FD6B00C4
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:53:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCBE3140412
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:53:28 +0000 (UTC)
X-FDA: 85182118896.17.319512C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C53B0C0004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:53:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AfmVe5Dm;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788670406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBpLxV9K4fd0pw4R7ASGCgVLbVUR2ydI6gQ0iBxrJdY=;
	b=6sxSLLCZ3l33pQOL75QfU5jrbDGQ28cOZXXDx4QbsyTEEa7VRzbTK9hVmbNXYP28WfHlLt
	7Tqw4uQ7OMalHzjHBouYte6cb7Qe9ZhJ2j8cnVEV0NcqfnExTdxyI1AIwksqAwNFI/YopV
	jzLcNKge1Ugze+nhvDZrWu2SIX8aK1s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788670406;
	b=O7sQ2w0jtUYU99IKKvLI04dFwJ+BTmgb0lnBZfvhak5QMItXWn+4T/OZESSf/fvM48FVlb
	GsOW638w0wonmjteUsnb6oFxyhJDCPLFkAlw9Dx3VNI3C8e3RBl4wy/li/kJmNiTfjAMUT
	G9DOLZ3Ck0N30W0m9kuo71RRO47hBaA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AfmVe5Dm;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B2D8435F9
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9821F00A3D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788670405;
	bh=FBpLxV9K4fd0pw4R7ASGCgVLbVUR2ydI6gQ0iBxrJdY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AfmVe5DmUttmx7hbq0HSprK9Iew7fyroN3lU1jpnb/mqE8LLBddtmyvXFIqAFAjr6
	 /CY3x5OFfGovkWlPMrubDwuCHJrNd14pEqy/XW0gbc7Uqf5Tg838G+umJ/8/P+45nu
	 ulRVP7FoWCZzkeXqI+AuuDc8tSEn34wGZaqARyM6XPYGSogbiZ81xcOB5Qm2RVTatq
	 QTBAz83FqwEUe5Gatc17Dy/ZN/bizd4yt7arHLyk4uJS3/TuA4Do8BFZ7TdpOT5rID
	 wpBOJhi2nLcEaDYCF78KO3iH9Tjd6l4cTodTADPFFxBp3rsyKbl51TCZ3AoDGZC7sJ
	 lIJt72UVa/xqQ==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e50a650a0so244046585a.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 21:53:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy1mO6aNg3UAupnCYTkfbzf8ijhUKE4UBwJc2N2guajocpdkSwG1FlnLSrqLMclXl5pWoFYaK/Zqw==@kvack.org
X-Gm-Message-State: AFuF++lFyGEX09hBuNeqvUd+Nx7cTcfmzBkOiYe/nCfYaOBC6XWjr0j1
	BjfKQJsF62t0FYImdTkEgcNY8gK2xOxXDyao8PMwYMKqtiR465KKH6uMy+R86HrqZrQ+iEPxboc
	evhyjlkrRnBZBipzV8if3jDba4E/quWI=
X-Received: by 2002:a05:620a:3709:b0:939:6de6:951a with SMTP id
 af79cd13be357-939804afa10mr1607211385a.49.1788670404878; Sat, 05 Sep 2026
 21:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260903040131.4016290-1-zhangbo56@xiaomi.com> <20260906011820.382381-1-zhangbo56@xiaomi.com>
In-Reply-To: <20260906011820.382381-1-zhangbo56@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 6 Sep 2026 12:53:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wC78QDTrETC0WpnouN=8aF8ae6Yxgb+oKiOP3A76ATLg@mail.gmail.com>
X-Gm-Features: AcwNN1U31LSzO7YBa1SFKsy6rtphWk4ZWlZsnKoVZhU0-ugmakYQy57PdKBT6oQ
Message-ID: <CAGsJ_4wC78QDTrETC0WpnouN=8aF8ae6Yxgb+oKiOP3A76ATLg@mail.gmail.com>
Subject: Re: [PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org, 
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sa8imbo15o974kgg8ecpkbr8swgth67t
X-Rspamd-Queue-Id: C53B0C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788670406-786055
X-HE-Meta: U2FsdGVkX1+GySq0wnIi5WGBZEpcDHMp44ZqrWx/Edf3Xgg46r6mTfrARBN0T/HUHZfDvGpbf5mp0EKkmF5RoRTOBFST5zOrfApXovXMxHrFIhqDKUTPmH+Z+DjYw4WUeby5S11vn+dFyUiTBYAmM2/lVF5Ud+mlsXb3bWQ3RfIoeHxtjX63P+D+2Rp+muyUIZ+aQvmIy6hKyKZMAKcP7CcqeCMgw9/r6S7vDlLnSWfx9Ej1uoMqPVciynN1Vp8W0oATZYrOrxr5STw3hwViE8nykNv4lOkiUfd3Fvu8JZPYHOPBomfqLPy5qigKu+tFPjZ7IWnT5XaqqFT9kRiLEHtJnDcycmNSdGMQCU80nn6++/f6Nuxn6GBIRsoGCEAvUjNQHn2SNYwFfVKdQH8knmf2Ym+nToPW1CecaAE1OLJcDX8WPy8Up5uInMyPs7xfFMNjEW9vDbIr2SzxwzF+BkvQinlfcPSNEl804yVWlVPGay/Zo3umjjiw77Xr+rjXL7fSftOrZ++LuUZePmijnKJF6nFIVbJRDo2gnlcCXlr3ZUVXHK8sYTVnRiJg58UrSEjT1ZGy0J1B5Xg6VDWZ7kVp24BoyuZZSsLldP/tSYgK/Ad8RrtI6vaTIMUrqGEeEb9WbufPG95/tsCkDnzhKNKAcYr9RPR/71pO2YmXIIb2I3PjaLXqOZ49OanTJOwTD1kzNHNnIJQgZi5faA3r6cQN276UllEZ8qANIoGWppmJN2JjB+uUAp/dXJjifi+eaJv4CzG9jsUY9lXoWO/Gf9Uf2Fenr1/nhCa+p4C0wOkXgx3dZUkQVTFf9RUNsCz24g9DN2kvIAmH1/MlQmoIFB1zUPmt3ifWawXbMdRL9dW6eFFWIEjOb2SsuVqoi2AT1QMIOH6Db4j/3+LpPvAKOLydHXYX11n0FKxoSO8KsO6/p5hpX/RW2zf5rGtAt9jCqjbVzpc/n0gjqif7TF3
 fBVFr7GN
 RsQkQkpIldb/AOzkXgpmHSRGJ+oP08dtjcBYyr5D/xTYiC8p9nybN/U3cQBUfbspuVNyktcHq8P51w9nM8oL8YtMzG+F31TLgsvwbvm4yKnl0/X7SicHSLGFNCQ0H0V5UrVEWCUHFM3AB2A/YIX8KWG0MkFy5xWTvV3G0kSOzUW+PfVXbwdFo/5cd/+o4nVESSSFGyW/E7UbNVOydZY9D/gSWaDJBbDvmml4zwLw9+/lRjl1t1FMLEe74fW2GYICCvt6PSoJ0qi6uaXeK2cRM5wK2Ynho+pteWXKObswPpqV/Jlx5z/4I64+3csnwQMmYbQsYagGCdH49Dx0wMZH/TkOY7JvQUnrvnSzBBWnU2oZ1hQVldgACaZJN9JXgIiJbLCUL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 6, 2026 at 9:18=E2=80=AFAM Bo Zhang <zhangbo0325@gmail.com> wro=
te:
>
> We have observed some cases where memory is allocated with GFP_NOIO, so
> we cannot reclaim any anon folios unless they are in swapcache. We can
> end up spending more than 150 ms looping in `shrink_folio_list()` scannin=
g
> non-swapcache folios without reclaiming a single folio. This is pure
> overhead.
>
> This is particularly true on systems using zRAM, where swapcache is
> relatively rare. So let's check whether anon reclaim is allowed by
> GFP_IO and whether there is enough swapcache to make it worthwhile. If
> the swapcache is extremely low, we're essentially searching for a
> needle in a haystack, so let's avoid scanning anon in the first place.
>
> On Android this is triggered by dm-verity hash-block reads through
> dm-bufio, which use GFP_NOIO:
>
>   verity_verify_io -> verity_hash_for_block -> verity_verify_level
>     -> dm_bufio_read_with_ioprio -> new_read -> __bufio_new
>       -> alloc_buffer
>          gfp: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN
>
> Such a reclaimer can land on a memcg with a large, unswapped anon LRU and
> a tiny file LRU (e.g. inactive_anon ~335 MB vs inactive_file ~4 MB, with
> negligible swapcache). shrink_lruvec() then keeps feeding that huge anon
> list into shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,000
> anon folios scanned - where every folio is kept because it needs IO. The
> 150+ ms above is one such single shrink_lruvec() pass (not accumulated
> across a reclaim cycle), and it reclaims nothing; the actual progress
> comes entirely from the file side.
>
> Aging anon alongside file does have some value for a later __GFP_IO
> reclaimer, so it is not strictly pure overhead. But that aging is only
> deferred, not lost: kswapd and other __GFP_IO reclaimers still walk and
> age anon. Spending ~168 ms aging memory that this context cannot reclaim
> is not a worthwhile trade-off in a latency-sensitive path.
>
> To stay conservative, this only skips anon when the swapcache is really
> tiny - below 1/64 of the anon LRU - i.e. when essentially no anon on the
> list can be reclaimed without IO. Whenever there is a meaningful amount o=
f
> swapcached anon, the normal path is used and anon is scanned and aged as
> before.

I notice this only fixes the active/inactive LRU case. To address the
MGLRU case, it seems we may need a more fundamental change.

I'm fine with starting by fixing the active/inactive LRU case first.
However, could we mention in the changelog that this patch only
addresses the active/inactive LRU case, and that fixing the MGLRU case
is on the TODO list?

>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
> v1 -> v2:
>  - Use mem_cgroup_lruvec() instead of get_lruvec(), which returns the raw
>    node lruvec for a NULL memcg and would be misinterpreted by
>    lruvec_page_state()'s container_of() during global reclaim. This also
>    drops the get_lruvec() move. (reported by the sashiko bot, suggested
>    by Barry Song)
>  - Drop the SWAP_CLUSTER_MAX cap on the threshold; the check is purely
>    proportional now (swapcache below 1/64 of the anon LRU).
>  - Expand the changelog with the workload, the dm-verity/dm-bufio NOIO
>    stack, the ~168 ms single shrink_lruvec() breakdown, and the aging
>    trade-off discussed with Johannes Weiner.
>
>  mm/vmscan.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 245f68c75b28..e20ac2cb4dd5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -362,6 +362,23 @@ static bool can_demote(int nid, struct scan_control =
*sc,
>         return !nodes_empty(allowed_mask);
>  }
>
> +static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
> +               int nid, struct scan_control *sc)
> +{
> +       struct lruvec *lruvec;
> +       unsigned long anon_pages, swapcache;
> +
> +       if (!sc || (sc->gfp_mask & __GFP_IO))
> +               return false;
> +
> +       lruvec =3D mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> +       anon_pages =3D lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
> +                    lruvec_page_state(lruvec, NR_ACTIVE_ANON);
> +       swapcache =3D lruvec_page_state(lruvec, NR_SWAPCACHE);
> +
> +       return swapcache < (anon_pages >> 6);
> +}
> +
>  static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
>                                           int nid,
>                                           struct scan_control *sc)
> @@ -371,11 +388,13 @@ static inline bool can_reclaim_anon_pages(struct me=
m_cgroup *memcg,
>                  * For non-memcg reclaim, is there
>                  * space in any swap device?
>                  */
> -               if (get_nr_swap_pages() > 0)
> +               if (get_nr_swap_pages() > 0 &&
> +                   !reclaimable_anon_is_low(memcg, nid, sc))

Can we also update the comment above accordingly?

/*
 * For non-memcg reclaim, do we have space on any swap device?
 * For GFP_NOIO, do we also have sufficient swapcache anon folios
 * to reclaim?
 */

>                         return true;
>         } else {
>                 /* Is the memcg below its swap limit? */
> -               if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
> +               if (mem_cgroup_get_nr_swap_pages(memcg) > 0 &&
> +                   !reclaimable_anon_is_low(memcg, nid, sc))

Do we also need to update the comment?

/*
 * Is the memcg above its swap limit, and does it have enough
 * swapcache anon folios to reclaim for GFP_NOIO?
 */

Best Regards
Barry

