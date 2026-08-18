Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE9BC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 22:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D6E6B008A; Tue, 18 Aug 2026 18:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E1E6B008C; Tue, 18 Aug 2026 18:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E136B0092; Tue, 18 Aug 2026 18:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8322D6B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:06:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E786E120381
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:06:25 +0000 (UTC)
X-FDA: 85115774730.14.435F7EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1B8D20008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:06:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8MeNpv0;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787090784;
	b=yCuhiY7n63Ou6GCmkT1nIz42nUkwMCFscxsOUzScRCTpjp/hy5Vx+VkjVIPtIuwtn6T70A
	HL7kbpaDgV/R8un33+TLsOj1jC9AndjWHbVWFgvEefzq/EI47Wy70CFk9jAAsTTkpyKXc4
	C0js4u6GFOMOmTXTcRt9PLUK65/xHag=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8MeNpv0;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787090784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wipR+WvOJ2T87OkiKdmw03QvkA2cYwhl4B+xewYZz9w=;
	b=szi2iP6fv3IhwZzlhz9M0InJbYMcEBtitSy/19fVk7PJZO6cLivtZs2saH7zPayjdo6MFn
	1QrCSrgon/ZaII5keHcoWlIfmTKQH7hIbgbzCxPdBVglZkYJVfgsBPxNauA0JH2Lvpkm7L
	8oCpD0jpqv+LrRd97sMlXWEyuf3ea7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 295A8401F7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC851F000E9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787090783;
	bh=wipR+WvOJ2T87OkiKdmw03QvkA2cYwhl4B+xewYZz9w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=U8MeNpv04JRRuy7upLQr/EOu3sy8+xSRlHoNkCTwQbssBM+1gDVWxbbh+JR5TchZH
	 giguUnWy77KXfteI1fhWe3QXwjlaJiGrKiSwbrQlqcXo82XeeEe2MD8cGi2AYcRB5f
	 3EXMkMorlzAGfTg6f6lNtH9S+6s4Ydpm+aSp8FKlqhRm4eyFpWFPwvzfe9XmwmHZji
	 yqw7rKOEtaEX8Hys9aGIJoEtwlLiKhloKdA9c8TxMWQCGS1z/uNddJa1OtMQPECGx6
	 wibU7M5p0nMbvuCcS3ZUzVQkr+SRAAPDEZ4Hhg8FAJzwrm/irWEK/mJUDUbgWi3/Fg
	 GBIHF/VRcSMnQ==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-934944f2d22so31245685a.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:06:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr3YoaHXSZ50LEHADSZLeIMCficzhnsaiD3cuHjHNOiSacgFiAyfbOrVx/7ydOoLuhcQmyr1Xyj/g==@kvack.org
X-Gm-Message-State: AOJu0Yx7jOGWFMV02HXAbT3Mc1vObcY8RH5NUI/vD0UASKr+YA12V2NN
	+6quBpCUctXfhKa7+W00y7yBbLqdkEwLHZNJIYhTD7bCTYPIakd3+SeNbTJiMhE+/TqaJMMiXbo
	8+z9vwqFJiyU4P8XMHDKNt8hNRHG4kaY=
X-Received: by 2002:a05:620a:4728:b0:92e:59b0:df08 with SMTP id
 af79cd13be357-9371e20514amr55853785a.3.1787090782378; Tue, 18 Aug 2026
 15:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1787056208.git.zhuhui@kylinos.cn> <4b4d4e3065e36f1b60dd69e8276cb92082f393a6.1787056208.git.zhuhui@kylinos.cn>
In-Reply-To: <4b4d4e3065e36f1b60dd69e8276cb92082f393a6.1787056208.git.zhuhui@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Wed, 19 Aug 2026 06:06:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xKM1R95TEpKoicGYQB8Qafez6hKJF=Z98A_2j43X5GAA@mail.gmail.com>
X-Gm-Features: AcwNN1U4fZLy0pc8rnJme6NJBelm16pSnJijH4xJAehX4qTfxwf0L2zftPuxePc
Message-ID: <CAGsJ_4xKM1R95TEpKoicGYQB8Qafez6hKJF=Z98A_2j43X5GAA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v3 2/2] mm/vmscan: apply too_many_isolated()
 throttling to MGLRU eviction
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F1B8D20008
X-Stat-Signature: fmwege1t8xwy7n1qt6fswszz6z7qhntb
X-HE-Tag: 1787090783-740282
X-HE-Meta: U2FsdGVkX1+CAvAu8Fq5s/WnROB637HKChct72DBw+LBeznIvHIJuGXHgprjmdOSGUBwHTsG7F3Gj4bhX/ENTFc10BqOZfzT6ug9U4lZN9XNmRhrr6va5STKgtpP/BZuiNtJxms85iFivs4hjR9sJ81TvFSHFBPgh1l3/VrJtMOzbHu5t6caHT/it6VKvZ7RTBb91upku5C3WKR/9cR4LXUuQTmXlDNCpFUjboiwVlYobK5PDo231EgUaaCcbJlzO3hcCNYOfxw/RFaFEMRwvS+a1mqvEKuof1S14ABuvcTZZlgAaM3gVd6E0gWW5SDNP82eq9flKQ0oaz1ESR3AtN3JgyN8SBBByhXnxAdTJkYImYS/lcPLyNje2D1XLFDqD+gjPfy8OoAbjjf6Cra5SW4+eWwF0G2/+KR894L6i4RAvvtF1modMSrDveHj5GMf+aX47HG0HwfsZmjco3E9AQvpYtHD/afPJYr/+iMtmCffy1rP+I8bn4eSeuNLLPt5Fj6/AM/pNpYlPZDISpv4NVWmYcmMUlmVoTUaAVobsfhOo1Z0/Smg7QroKDyuj70d9cyzqs9Lii8TJbwzpGBEHvCBnd+7mxEwkPJcIKou4Wz0wWcziNrQgjS51SZbT0Y/X4htPENpdfijVZ3CWcLCR2f37Dk1jy08WCHeviNe54wbbQsViA6U+dDtUJ/D0qc7JxPH3NG+3WA3IZRIrSezllz7pPLm3E/TRTa5uJzDZmXTcW9zzeRdKbovADCuny6zzzcqJL6Q8UDGXv/nzyUurlEaiJfmw7qipOIj2foTnLugr077dewDYsEBt2KR1hAmw9Hzgyib8VFN0G3xk8rffeNHCFu8DagbIh5U0bhdDDNt91n7toekZfHEtAb+nEDJkswLrhAKCp/L8L1p7rCWNwA31kicDFtM7zPdBmtv2nx2Pihipmwth3BxQHYBpgw5jr5DtlWU3bUQ4QYXdv5
 5TwroaMG
 D4cbZig5C/xr3Ifz2hoFtjYOws9/Bx2sX6U0yDbmR/eIVcsWrby+xsgtBpU6ajoQeN1SCZ91BshyLOC3TKFyLaFReMhVs4Me62XQPxGhhipsLvigNtUyBzrg2dn2Lnn6N5jGvmjkafRIRV+hWhX7WgBNJr4e5q3htKK9uVnSSdp1wxD8Z8Jnm17D+tPYuKddl32BR2EP95iU4lH0JVJmFV4s2jPnL6KIPCN5Xs8ntOxG+5bYyh14Pa/9TmY4yOhmkhP39ApYsRVzhHCelWNSYB5C42l29q865/RXX2WImDQj2k7DhMF9FTDjjoJ30WwGt4akEa1o0yxQmVro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 8:49=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> The legacy path throttles direct reclaim in shrink_inactive_list()
> when too many isolated folios pile up, but MGLRU's evict_folios()
> isolates folios without this check, which can lead to unnecessary
> swapping, thrashing and OOM.
>
> With the NR_ISOLATED counters now updated in evict_folios(), extract
> the throttling loop from shrink_inactive_list() into
> throttle_is_throttled() and reuse it in evict_folios(). Since the
> type to isolate is unknown until isolation and isolate_folios() may
> fall back to the other type, check all evictable types with
> for_each_evictable_type() and throttle if any of them has too many
> isolated folios.
>

I feel this is unlikely to work. MGLRU behaves quite differently from the
active/inactive LRU, and its `NR_INACTIVE_FILE` accounting is also very
different.

With the active/inactive LRU, shrink_inactive_list() ensures that we
always have an inactive list with pages available for reclaim. With MGLRU,
however, a generation can legitimately point to an empty list, so this
assumption does not hold.

try_to_inc_min_seq:

        /* see the comment on lru_gen_folio */
        if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
                unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;

                if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < =
seq)
                        min_seq[LRU_GEN_ANON] =3D seq;
                else if (min_seq[LRU_GEN_FILE] > seq &&
min_seq[LRU_GEN_ANON] < seq)
                        min_seq[LRU_GEN_FILE] =3D seq;
        }

At that point, we have no inactive pages for the type, so the
throttle will take effect when the following condition is true:

too_many =3D isolated > inactive;

With MGLRU, however, we can still fall back to the other type even
when there are no inactive pages for the current type.

BTW, if we are hitting isolated > inactive with MGLRU, it probably
means the generations are quite imbalanced=E2=80=94we are running out of
reclaimable generations. In that case, we may actually want
reclamation to proceed with aging instead.

> If a fatal signal is pending, fake reclaim progress the same way the
> legacy path does, so the dying task exits reclaim quickly instead of
> being held in the throttle.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/vmscan.c | 71 ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 59 insertions(+), 12 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 98226bb021f3..6fe8824430ac 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1819,7 +1819,7 @@ bool folio_isolate_lru(struct folio *folio)
>   * the LRU list will go small and be scanned faster than necessary, lead=
ing to
>   * unnecessary swapping, thrashing and OOM.
>   */
> -static bool too_many_isolated(struct pglist_data *pgdat, int file,
> +static bool too_many_isolated(struct pglist_data *pgdat, bool file,
>                 struct scan_control *sc)
>  {
>         unsigned long inactive, isolated;
> @@ -1856,6 +1856,37 @@ static bool too_many_isolated(struct pglist_data *=
pgdat, int file,
>         return too_many;
>  }
>
> +/*
> + * Throttle reclaim if too many isolated folios are piling up. If this m=
akes
> + * no progress, the caller is probably looping on unevictable folios, so=
 give
> + * up. Returns true to tell the caller to stop reclaiming, and sets @fat=
al
> + * if the task received a fatal signal while waiting, so that the caller=
 can
> + * bail out faster.
> + */
> +static bool throttle_is_throttled(struct pglist_data *pgdat, bool file,
> +                                 struct scan_control *sc, bool *fatal)
> +{
> +       bool stalled =3D false;
> +
> +       *fatal =3D false;

TBH, I find the name quite weird :-)

Best Regards
Barry

