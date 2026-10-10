Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2ECECA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 15:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378246B0088; Sat, 10 Oct 2026 11:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3288A6B008A; Sat, 10 Oct 2026 11:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217CE6B008C; Sat, 10 Oct 2026 11:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F02406B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:21:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8461C07A9
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:21:52 +0000 (UTC)
X-FDA: 85307081664.17.99B8AA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2960160002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:21:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlB0RSQ3;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791645710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVCmy9f7/nhqwyBbb2KH2ql3dyJAUCcc/ty4MtIkyWo=;
	b=53gt++G/Vom7vmWkcGoe8fTPBqOMqt5LwwqNPtAl9A6IsX7BfJBTYUvKSsSt3R0+RCeYMl
	C1c+Cezik8iEL0QSUvFI2VFno91MlnZ5vEQ6MNwiPXQC/zZ71T6gkSkSl0J8wKQCxu+snv
	Sp4hwtOC4cJCN4dmHqlq6RasW4fuDFk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlB0RSQ3;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791645710;
	b=rzqquLXynoccl5RaRVNXzHlBiv04JALkAog9JTUHkx8jUKrXNXHSuRvS4B0OOUk5aB0gKa
	m7qxFqfK03f3YlxAuW9V5G9ls43fQuiK6K4Ia2+845ZiRDIbDsnXj8wF4a1VhjaB2S/bme
	E5uxXrPZqdgEkCXRsjkIO0eoMyT7yvk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32E5940211
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DE91F000FF
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791645709;
	bh=yVCmy9f7/nhqwyBbb2KH2ql3dyJAUCcc/ty4MtIkyWo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YlB0RSQ3x+gZj5g/WlN0RgpHfeKcGT3gLqu7dDCpw9gSTwInhzU1f2IvXyoXMKLCo
	 PKtu3fyWVh27ULs5aSie21QlUtI2JOAv6y8ayKRwEfU/x71Vbx/mAb3mEeyVg324uk
	 ovMu/HY+FZfJ3dTpZCSD17qm/DeejYEL92l+CvQNBiSNYZdRDD8aRtxA2ljC162HWk
	 BhFn3IzdFM/xgzce21WiopqFiRgaNL8Iveuh9LFLbUneMOvaLGC5h9wdtSRVGN4TfC
	 C9Jf3tYKwSYQPvqgZubjghS2CSwK3e2EChm88lGZzIujOnEacw26DiHwuSJu4hyS0m
	 +YgHRgWAWz0lg==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93e635220b9so44902185a.2
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:21:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByHRmh27mhlcNyqe3u0UCUFRoprcv3mC2J9x+lBnBVCu4TNsc0dUQJLUXFwa4puiW+zOBZdZBr/8g==@kvack.org
X-Gm-Message-State: AFq9FYLVaXZ2CDojFUhyqle1uobQFSKspqOcfBad4zmb+vF5EFOcfxtY
	bNj2cLjDbLlN4vSoOO3yU1Qp5em1WTyjIX8ZZv/TVOlzaslT4W22YS1mJeXilTPnDpuyoFwmC2p
	IvxdPgGWrqpMCKzoBFSuuFIjJDtjrrO8=
X-Received: by 2002:a05:620a:3728:b0:93e:c12c:f119 with SMTP id
 af79cd13be357-93ec12d0576mr764364185a.69.1791645708337; Sat, 10 Oct 2026
 08:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20261010141057.599595-1-liuxiang.277@bytedance.com>
In-Reply-To: <20261010141057.599595-1-liuxiang.277@bytedance.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 10 Oct 2026 23:21:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xxawPzb7MpmdNm9u-fgge3w49n-Cu026BpKYAUZZf=pA@mail.gmail.com>
X-Gm-Features: AclHuK_An0Bs4sFN1u3GsKjmLeNq_6Cs8GACRNMMJL2VZeVjvrz0jj-Knms2-Cs
Message-ID: <CAGsJ_4xxawPzb7MpmdNm9u-fgge3w49n-Cu026BpKYAUZZf=pA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with low
 swapcache in MGLRU
To: Xiang Liu <liuxiang.277@bytedance.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, mhocko@kernel.org, 
	hannes@cmpxchg.org, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C2960160002
X-Stat-Signature: d6mrc59tojdwdnbmr4dqrxqn4x7r4fkm
X-HE-Tag: 1791645710-78542
X-HE-Meta: U2FsdGVkX185po4OwTV68c9RwpZ2KmadNUYHd95vsy12EOj5XK/pKuy8Q81MGOdzLZpEdpQmo2d0lxCv9UVJtTgAnzNqeYkS6GjvEP23+acJ36RDfi94/pDde3YcLwZ/i1T1/UQwEWNcot4y0KVtHFQX9HmV2zuVnSjbr1BslY99PMw5sPfg60vVg/tk247tLR2O5hakV2adCJGxdmwZp/yoOrzMAU3MVIlM+fo271hOXQn56Dx5Ib2QDjdKsy1zqiHX7i8WQ7nYj8S6pfdbeAA/W3Fm0DqaBDl7myyii9gCeDD3NSV11iL2TJZLksQxW4uBLQOyGqAzxygvcylI9Gcc/A7OEMo9Mig7+eJDp5jCK3sm9qkEQ55Koq2vkXo/xbLK96yyWVbhPh7ng08U8yz5t2HVDmBPFPzsAKvEFnxJRQe99YnLF2jia8Lh0RDL+/0M8JiVfE3R8Wn56E31d46uO8fqYCWSqjx/ErObuSCux/MI5LfsK0tj/Gsend2GuZRTgD/z+GW46ZITevMizRcRa7+UiGDcc5tIudJJsmY8U/vHXc+LU11UY2L965qx9o+E5pPzEpANSBQ8RC94O+O/jdfm/Q9YT42QAmiSkX/HYO7V/4Mkc2n7XSCv/+zTiXX/8+EQ19DHO6UIWwlMOckkuTTva/dlZRpfZKykc96fmRfzHxyis8sSJGNg+oFTlZJU64i2enS2m9h3gt6iKsBMWEgtztxH5iU4e38kLN1hmu1UcaHemuEHdPzsdcqawoLx61r5Fbtviwnid6IZ3kI1j1aDsQxpRzHriCkspCEHcfAwy3+zoNmTleNJK2Uv9Fe3JzljWl4+Hom5ilLGtn6MsJOi9L0+s3qLTnaErzXBdAlJ32Grx6GiDVwV7K0tbBsIp7LUWqnEDth1TK5VC6ILTalvvYRYl7Se018dqYpn1BE9djIqajB+RKwJus9sZbIxaibX/SLuVnC718A
 kC64G7/U
 jy5/UxEG7Lpjsb8xLCrZzQz5xASDMaNVQ7gTxG+hRqKRzHNpOG0XVWgETgiKHpX5+mCJ1LLAJwo1jX+KoM98rLVnu36hLQydJsmjZXFl8lTwVUyNAtJOxlExbKi+H2quONXTLDnQq0IY5spY7Ror7ahXuN7BAYB33wxyzPe5/mIAEge+7YKs5au6NemW5nktJ0Rae8bL3Ubj9ATPxJBmwT7c6/tCivngci4uoOhGIYT7IiY7ZFsZpBLcE1i2uqpPZ40rNyQXbvqoU5sNMP/BFiEaLcWpMEkNSamEEKH+D5XmJDQiWhDYSdCUemitA3mB+V3aTk3fH4ZS55YbR6KNyLMNV3vlrUuLPeO4VnnplLjwr6m9lBrNU03QF9o9/surX8YHFv609/jn5oSFVM6oh5yIIvRWUjGid6NuLVF451dtjpChd7kyBXGU938oRrYN7lJKUxPurvcbSGDvdjD+SFzw9Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 10:11=E2=80=AFPM Xiang Liu <liuxiang.277@bytedance.=
com> wrote:
>
> Bo Zhang's GFP_NOIO patch [1] addressed anonymous scanning with low
> swapcache in the traditional LRU and left MGLRU as a TODO. This patch
> addresses that remaining case.
>
> Under GFP_NOIO, anonymous folios requiring swap IO cannot be reclaimed.
> When very few anonymous folios are already in swapcache, scanning anon
> can spend substantial time isolating and processing folios with little
> reclaim progress.
>
> Apply the existing can_reclaim_anon_pages() check to MGLRU.
> lruvec_is_sizable() excludes unavailable anon from its size estimate.
> In try_to_shrink_lruvec(), file-only scan_swappiness is passed to
> get_nr_to_scan(), should_run_aging() and evict_folios().
>
> The tradeoff is synchronous aging. With four anon generations and two
> file generations, advancing max_seq can require moving the oldest anon
> folios to the next generation. This patch accepts that cost to avoid
> low-yield anonymous scanning. It keeps the original swappiness in
> try_to_inc_max_seq(), avoiding additional use of the inc_min_seq()
> single-type shortcut that advances min_seq without processing the
> oldest folios and can cause cold/hot inversions.
>
> Tested against the mm-unstable base-commit below using dm-verity
> hash-block reads through dm-bufio, with unchanged NOIO allocation flags.
>
> Allocation time spans alloc_buffer() entry to return with valid buffer
> and data. Reclaim time is the time spent in try_to_free_pages() within
> that allocation. Eviction and aging are the time spent in evict_folios()
> and try_to_inc_max_seq() within that reclaim.
>
> 1. NOIO allocations under memory pressure
>
> The workload triggered NOIO reclaim during dm-verity reads, with
> generations allowed to evolve naturally. The table reports median
> times for successful allocations that entered direct reclaim.
>
> Time (ms, median)            Baseline  Patched
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D
> Successful alloc_buffer()     181.196    0.465
> Direct reclaim                181.185    0.131
> Eviction within reclaim       179.147    0.091
>
> 2. Synchronous-aging cost
>
> Prepared four anon generations and two file generations, with zero
> swapcache and pages in the oldest file generation. The tests varied
> the oldest anon population to compare baseline eviction with patched
> synchronous aging.
>
> Each row reports a successful alloc_buffer() call and its reclaim
> costs. Oldest anon is the measured population of the oldest generation.
>
> Kernel    Oldest anon  Allocation   Reclaim  Eviction    Aging
>                 (MiB)        (ms)      (ms)      (ms)     (ms)
> =3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D  =3D=
=3D=3D=3D=3D=3D=3D
> Baseline     1755.266     131.704   131.699   127.985    1.672
> Patched      1840.422      38.316    38.311     0.307   37.785
> Baseline     4835.418     681.796   681.766   675.477    4.382
> Patched      4813.180      91.161    91.140     0.450   90.407
> Baseline     8941.582    1474.245  1474.202  1469.084    0.488
> Patched      9012.660     143.748   143.709     1.026  142.341
> Baseline    13104.676    1098.372  1098.354  1087.976    2.307
> Patched     13046.621     139.450   139.390     1.083  137.954
> Baseline    17187.043    2694.909  2694.902  2686.470    0.784
> Patched     17124.902     209.240   209.233     0.638  208.270
>
> Across these tested sizes, synchronous aging was substantially cheaper
> than baseline eviction, and successful allocation time decreased.
>
> [1]
> https://patchew.org/linux/20260908062649.1045883-1-zhangbo56@xiaomi.com/
>
> Signed-off-by: Xiang Liu <liuxiang.277@bytedance.com>
> ---
>  mm/vmscan.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 29b31446fc11..550c16cad9f9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -379,13 +379,6 @@ static inline bool reclaimable_anon_is_low(struct me=
m_cgroup *memcg,
>         if (!sc || (sc->gfp_mask & __GFP_IO))
>                 return false;
>
> -       /*
> -        * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() fo=
r the
> -        * scanning type, so only apply this to the traditional LRU for n=
ow.
> -        */
> -       if (lru_gen_enabled())
> -               return false;
> -
>         if (memcg) {
>                 struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat)=
;
>
> @@ -4357,6 +4350,13 @@ static bool lruvec_is_sizable(struct lruvec *lruve=
c, struct scan_control *sc)
>         unsigned long total;
>         int swappiness =3D get_swappiness(lruvec, sc);
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +       int nid =3D lruvec_pgdat(lruvec)->node_id;
> +
> +       if (swappiness && !can_reclaim_anon_pages(memcg, nid, sc)) {
> +               if (swappiness =3D=3D SWAPPINESS_ANON_ONLY)
> +                       return false;
> +               swappiness =3D MIN_SWAPPINESS;
> +       }

Hi Xiang,

Thanks for your patch.

I'm not a fan of this fix, as setting
scan_swappiness =3D MIN_SWAPPINESS will force a cold/hot
inversion for anonymous folios.

static bool inc_min_seq(struct lruvec *lruvec, int type, int
swappiness)
{
        ...

        /* For file type, skip the check if swappiness is anon only */
        if (type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY))
                goto done;

        /* For anon type, skip the check if swappiness is zero (file
only) */
        if (!type && !swappiness)
                goto done;
        ...
}

We should try to avoid this.

Best Regards
Barry

