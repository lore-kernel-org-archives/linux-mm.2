Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 632C9C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC226B0093; Mon,  7 Sep 2026 17:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69DA26B0095; Mon,  7 Sep 2026 17:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DBB06B0096; Mon,  7 Sep 2026 17:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6B66B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:25:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96C5CA44BD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:25:43 +0000 (UTC)
X-FDA: 85188248166.07.D3F7AD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9EE1914000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:25:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iwm9d6OO;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788816341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8uWLgf2KcII+oUuy388tsezKw2Fquxd0BJBB5QiqWA=;
	b=aV6+rTDkgqkyDrtOor9vvrrhOLl6T7Usfl5wpY2L/FCwJla1+M518lKWHnOKu/HT2kdyQ8
	RveLaf80sNn+1nFpvspYtcMAol8MK9fDUndGLcvKJ4cqt/9gr8A6Odju2p/ADqvRATisO+
	H2WBoLyltjM5zgVfVDRGz1v8aMAvrd0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788816341;
	b=ZWpmg0OS/y7ucYC718TiGvrQkDfAL5FVP7CMLVqtUQq9PRzEKNchJuehGSEw5TzK3+hsMD
	aloEP/n/dIFCCg1y2L3LJbnWtj2idiA7QRZpjmJV77a4Bd+5L6ux8e9vA+SYu57Uivl2tF
	qn46O7j+iEqXZJo3jIQSEzPzpFtI8ZE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iwm9d6OO;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 773AD43675
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCB71F00AC4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788816340;
	bh=o8uWLgf2KcII+oUuy388tsezKw2Fquxd0BJBB5QiqWA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Iwm9d6OOiJyAE8AqAqjJUODvHCom7TDHELUEXfNkQjhyTDhuJecUTpIgBoN/5znrU
	 MjkmpiwzUNonuxc21m7dBV/viztyr+0LqZMZJGoXozpQigHBg7BBemok/9IzFryAHF
	 Jm7zs1//IzVfr+AKCEEwRQ3DKZgR82JKOlj3x6CbtFn5LfGYmNzQp7m6rFPl8NXien
	 5hw7m+n9J1Q2h/VFt20Beq4W2hexgzi0xD4Ij/9zT7Lr/gBHSCnYk1W477jW3htjs2
	 37+FJpdlU2dAYUREhyrYeT4kxelyhk8JAQvYQ1D6AB4QuTN7P+Hy1wPq2U6tvI+tnK
	 d1BnFqrfJRvqg==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e85499ffbso303138685a.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:25:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzR4vggzfGZJWKWxC3W/BV/SuObAxbfomuAdIohSCMdE9oXa/rAx16YJuVXzEq/VqWcYh6JTTDvWw==@kvack.org
X-Gm-Message-State: AFuF++maOqrf0zOH70ZrG7wNwxzKuXZEOOt6u4NxL1CgOXEnHK12GUPx
	rLaHY1+/KUynqH+B0WUqBT05kA+lHA45Fo4qZlwEwuhkVMFrO/OtMVYHRN6kFZBESIIMHdZ9DRh
	VwbLoXt9Y0P4KKvoVJ8/Dkgriz7jV1+k=
X-Received: by 2002:a05:620a:bce:b0:939:993e:bffb with SMTP id
 af79cd13be357-939993ec19amr1728644585a.22.1788816339633; Mon, 07 Sep 2026
 14:25:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260907122757.748111-1-zhangbo56@xiaomi.com>
In-Reply-To: <20260907122757.748111-1-zhangbo56@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 8 Sep 2026 05:25:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zRK8m_cfyNfO502=1guMN52dZipN+26HfpDya0gWE7GA@mail.gmail.com>
X-Gm-Features: AcwNN1W6YuLyePWvCuNneS0jRtJGGoa4mYoVops6zpx8tN8nObhQVDsZlT2VVA8
Message-ID: <CAGsJ_4zRK8m_cfyNfO502=1guMN52dZipN+26HfpDya0gWE7GA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org, 
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9EE1914000B
X-Stat-Signature: utk94z35h4f6z9mfcggg46jdm6w791sq
X-HE-Tag: 1788816341-466834
X-HE-Meta: U2FsdGVkX1+H1E6C6WD73Somjiyhxg2j5klJDyS3EcefqMDgy/wzj3cc39inCaHzGXUPHj4z1pj2M/jh82I9CayTSEKg7BXWVrLw0VKjtJAm9zePp5d5UgEo7Sua6srWNvSYuJiY6Lt/OjKVDlRAasHGpSk34nSrGkLXP0N7la/7KfyIATjNB7CfvIcCUIGz6b9OUc8vBiHsJXk80NslYol56KWLfE32Ki2XzU+lL5hpK4Luhk5O4wIYg7sEvkz1C3v3/Tit7dpfoi/JnINn+DNhBa55zDJlaAH3OyDXmmRB+72H6OE7Dk6fnGxBlMO5wshv4aYCbF0Sp52ySpGwPNLXs312ml9UStFs+QUg1vbDITVtAy4VOFWZPd6lmsfdXF+0xT53grp7vqyMNXGmZDeAC1kczLqnYPn1fK+QZ3kY1uj+S6gFAPuLDYlz2Fdeln5th0VCEoflUIhy4HApMb9ErRppaAeL/Eu8xL0uScn4lwjrIUGcFae3uTvrWNoW6fKbWJhfyd9qVM7kKeZGaGCcdq4pvK5I8ns02samOcPoEJioE+6jB7+N56i0ZljYzUpAdbagzTN6PN5QTakm3kZiNEqNQ9yhynyfVb4i8579Rg90xTqEYR68A+TGDcZZmXnvUlkcc1pqDzcfeC6/WiRLUsy2/9quVNCx5rYi/nN2MWpvJtZvMqApfnTvPV6hsNGKcjRD/W7gA5+6nkDHCnDlNnR8kjiI/Cs9Poq7YRnJoC32eJm5dNXydfgq6gmXFI51/hk34cpGAEZL4jpjasnap8pzoFfZsgV6L/jNcojBQzvfIE4AbutjToCvWrDLP7/oUTuBvBtlC2SygWOnNzYlyk3BNE+qswEvFL0e+rFlbiSQy4zVW8YaGkVf0fR3fZkTgNg7X3aQ85mug6/eb+5tL3gMYKlfRJ3qPHW4UnzAxBx3saQHaa+jseXJpVqeE8rpwC+soo4Y+C/5cW9
 VAC5ZOck
 veeBaMg7qftN5l/5EcGCT8ni1aYUi67i4uYroPmMt0PTO7yNr31oHmx8OsqVyvSuhMRqdgK2TXyOHQ6pExAz4hoM15d5HRlMmlbYoNoD7N3SbgDOBOVnl9s1ajatAJqZf4cW0A6O/kBaO0h2/5TAom6v7v4S5z/m2end7iG81N7B+kiKJflHYVrJaW1OhqAqWTEJmOBNQLNzxBcr5jzg+ezZVg+OOEYrggN8NGY3J1yGCtEbqDyz2GNNroAyG79wyWu3rG8cy898KV3sc04JJ1WKUaGpTwXBTxT7ibIf73m8kuA/Ks1eU1U2dgd/zmkEolEoaAH0xTU+Hpy40Ps5AZrQaLKy5Heqc1AAWK2BZPrgqVm+bhYLnW09fPiVMFUuns0CjxbFZKGUsCrClRuC646Pi5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 8:28=E2=80=AFPM Bo Zhang <zhangbo0325@gmail.com> wro=
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
> dm-bufio, which legitimately use GFP_NOIO because they run underneath the
> IO path:
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
>
> Note this only addresses the traditional active/inactive LRU. MGLRU
> selects anon vs file scanning in its own path and is not covered here;
> fixing the MGLRU case is left as a TODO.
>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
> v2 -> v3:
>  - Fix stats source in reclaimable_anon_is_low(): for global reclaim
>    (memcg =3D=3D NULL, e.g. from set_initial_priority()) use node_page_st=
ate()
>    instead of mem_cgroup_lruvec(NULL), which resolves to the root memcg a=
nd
>    excludes the child cgroups where anon actually lives. (reported by the
>    sashiko bot / AI review, raised by Andrew Morton)
>  - Add a comment explaining the heuristic and its rationale. (Andrew Mort=
on)
>  - Update the comments above the can_reclaim_anon_pages() checks. (Barry =
Song)
>  - Note in the changelog that only the traditional LRU is addressed; MGLR=
U
>    is left as a TODO. (Barry Song)
>
> v1 -> v2:
>  - Use mem_cgroup_lruvec() instead of get_lruvec(), which returns the raw
>    node lruvec for a NULL memcg and would be misinterpreted by
>    lruvec_page_state()'s container_of() during global reclaim. This also
>    drops the get_lruvec() move. (sashiko bot, Barry Song)
>  - Drop the SWAP_CLUSTER_MAX cap on the threshold; the check is purely
>    proportional now (swapcache below 1/64 of the anon LRU). (Barry Song)
>  - Expand the changelog with the workload, the dm-verity/dm-bufio NOIO
>    stack, the single shrink_lruvec() breakdown, and the aging trade-off.
>    (Johannes Weiner)
>
>  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 47 insertions(+), 5 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 245f68c75b28..e5c07490f5b3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -362,20 +362,62 @@ static bool can_demote(int nid, struct scan_control=
 *sc,
>         return !nodes_empty(allowed_mask);
>  }
>
> +static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
> +               int nid, struct scan_control *sc)
> +{
> +       pg_data_t *pgdat =3D NODE_DATA(nid);
> +       unsigned long anon_pages, swapcache;
> +
> +       /*
> +        * A !__GFP_IO reclaimer can only reclaim anon that is already in=
 the

I'd rather call it a GFP_NOIO reclaimer than a !__GFP_IO reclaimer.
But they're really the same thing. :-)

> +        * swapcache (adding anon to the swapcache needs IO). When swapca=
che is
> +        * far below the anon LRU, scanning anon reclaims nothing and onl=
y burns
> +        * CPU; the aging it would do is merely deferred to later __GFP_I=
O
> +        * reclaimers. The 1/64 threshold keeps this to the case where an=
on is
> +        * effectively unreclaimable.

Let's keep it a little shorter. Maybe we can drop
"the aging it would do is merely deferred to later
__GFP_IO reclaimers."

> +        *
> +        * Use the memcg's lruvec for memcg reclaim; for global reclaim
> +        * (memcg =3D=3D NULL) use node-wide stats. mem_cgroup_lruvec(NUL=
L) would
> +        * only see the root memcg, not the child cgroups where anon live=
s.

This is already self-documented, so do we need this?

> +        */
> +       if (!sc || (sc->gfp_mask & __GFP_IO))
> +               return false;
> +

Sashiko is concerned that this might negatively affect MGLRU,
so maybe:
/*
 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages()
 * for the scanning type
 */
if (!lru_gen_enabled())
    return false;

We=E2=80=99ll need to address MGLRU with a much larger patchset as commente=
d
by Kairui[1].

> +       if (memcg) {
> +               struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat)=
;
> +
> +               anon_pages =3D lruvec_page_state(lruvec, NR_INACTIVE_ANON=
) +
> +                            lruvec_page_state(lruvec, NR_ACTIVE_ANON);
> +               swapcache =3D lruvec_page_state(lruvec, NR_SWAPCACHE);
> +       } else {
> +               anon_pages =3D node_page_state(pgdat, NR_INACTIVE_ANON) +
> +                            node_page_state(pgdat, NR_ACTIVE_ANON);
> +               swapcache =3D node_page_state(pgdat, NR_SWAPCACHE);
> +       }

Sashiko is concerned that `NR_SWAPCACHE` might be undefined for
!CONFIG_SWAP. That seems reasonable to me. I think we can do:

#ifdef CONFIG_SWAP
static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
               int nid, struct scan_control *sc)
{
    ...
}
#else
static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
               int nid, struct scan_control *sc)
{
    return true;
}
#endif

Actually, returning either true or false makes no difference for
`!CONFIG_SWAP`, as `get_nr_swap_pages()` will definitely return zero.
However, returning true seems semantically more correct.

[1] https://lore.kernel.org/linux-mm/CAMgjq7B=3D=3DMqHXa6H=3DarrQ9a0bUXWpXG=
_a5EBxZGjLjYUuEf1gQ@mail.gmail.com/

Best Regards
Barry

