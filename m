Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE7B606A331
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zE7BkhM5
Received: by kanga.kvack.org (Postfix)
	id 6A0656B05B2; Sat,  7 Nov 2026 05:59:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650A56B05B3; Sat,  7 Nov 2026 05:59:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547BB6B05B4; Sat,  7 Nov 2026 05:59:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24CC16B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:59:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7803A02E2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:59:03 +0000 (UTC)
X-FDA: 85408025766.25.D75C075
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id B7CF210000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:59:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zE7BkhM5;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794049141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hTaXGgCslrRdpuberOOhKTY+3T0RrmQ/+ep+5hiKIg=;
	b=08nhjJniWypEX5nLN4DwYeZ2NUBbC0JhU4oO5GkDvx2Uc/zPiwVWlaP5ygYhMbolK2rSEj
	2KuD6oaikmzt4mpMaIrcDT1rG1/M2BbY2Vtvuz1UltNdrQwv5badbLU2vqHe9/15ZakFC0
	xD5Y1FlgvWR8299f/FFo/3OlChS2OoE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794049141;
	b=kYEyiNkC6JsffZxLPS+slvoBMCEdG38cCvAoNZGlaeBn/m3fyYiRZyLn6jwNRPlzwTzSWP
	8oM+gFFFu8MF2wC2+cZHSex5odwBCggvNtrFLj0hxci0rSh3zByydJJmQW2xhM5fHydWT2
	7uAUh7CfWiv2SWQJJn4I/u7JmudwgjI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zE7BkhM5;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b596afb4c5so1451912a12.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:59:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794049140; cv=none;
        d=google.com; s=arc-20260327;
        b=gh6vLQAaSG4BA+k39yJ5gXWVZjkK5KK5zARfMHvY09aP03YuqdtNY4lD745q1DsUx2
         WQ5omoaD0MwDNAiZM0WANAneSxhv3RQAASSNgO0Cb1jXn4ljBEpPkReAgQKQ9Qxi/KVu
         4rsjLasMCj5ocevpWzIUbSnMaCEuGUH/L6Zpyb7w83cHnLBkoo6Luwg62CyQvMTTE4ml
         XVQKHx9JldiJIz4X2tEw3VddDmN3hyHrmY88WGX8OdgLpt22i1Wp/ajvD3b2rFH0GXIN
         J5d6db0rvVfDFfkdH/ICTtiTDErudDaMVXykWCqdfOgzHIBuIvMS3UlcsBOPq/3Oxa5l
         0FKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1hTaXGgCslrRdpuberOOhKTY+3T0RrmQ/+ep+5hiKIg=;
        fh=nd7/snWhLcV0SHg5vHGhciwSAyODo09qg2UA2o26C6w=;
        b=Gn4vRxn7VaTwZhlTkukR/gK9IW741e/NFpS7mZl+l76tvre330ZrWb9I75IPM16nRz
         XMQeY+KpGUvvNYUw0BXEZEB7iJZQqsc8BmOURcyFCznrIXH5BTK+bSmBBjavevXPc6Yr
         KvnKV/xpc0Ugi8KZAey4A1zyIcr4JTdRaeAnSvh/74DFaERcjgKvXx2KgcjMkTEb9C6R
         5z5P3QDU2Oejm03W37yH/Y7UIrvu4HLTc6Hxq+Q0wRs8aJ+vom6rTeoWRM1hVPALkNNJ
         NCW0y6TTV19/lVTMqU5Ks/4lTVU1eu1mLfdufQg4sKycfX0njLWGjjKEpO8O1CNBVxHz
         GLqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794049140; x=1794653940; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1hTaXGgCslrRdpuberOOhKTY+3T0RrmQ/+ep+5hiKIg=;
        b=zE7BkhM549O0JHImMDhFEARWxyTRxulvbP6besz4lpiao/sUj3mOBIygta9fgi3ZDB
         n5778y9ESXVeaMRNMjchWCkePzw4ekKkIQO74kRXKsLgNpcVedHd9ky4D6qOjPkQ9eph
         6h20Sip6BTGxDIHrbZi70iXAVjuX29VPez6cadX4OZ/H0Sgohf6u95esWM8UoaVo0/Zx
         61+IW/ZUk2vy1yJnNubC0JhSOY9zN8p40OWVV7o1SI/ShG3iqVyRO5RCLZCioLSSP7nx
         nh7mwgg8TNhE/6zj2Zo1slAVaGJ8idFATeTZJuvNjqjULsqbWlyQRNFN4VEyJgcE6rxe
         thbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794049140; x=1794653940;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1hTaXGgCslrRdpuberOOhKTY+3T0RrmQ/+ep+5hiKIg=;
        b=aDVO4mCRTXapUDX4mEiNLtT32aBVGd9BWxBouHLqom3NnKZuBShM2FWa8TKByTYzIo
         31dR8kG1vA6tuVUM0Ver6B4Yu2w1N5F6omIMXe0lhsXBP5euc6z4Vku5sqBUgnke9K/m
         BfCnNutf9Jv2kT9OTh3qVjO00Xa/5el93BuJVt+EUb471qECmVoPn3QI6rzXFYDOTzkJ
         mXygv+d/c1SNlSmaSx0Ix+11UqnbnXYGqW6htcGUGsKW8eVjtFnNdsw51NdRm/2cMWt1
         0OuE1RkbXibRZNuj2/PZ2xuLN41bPQI5qkLJB4XdRAY+qjYdgbch7IBXpFf2Ca+D+AVG
         ZJ7w==
X-Forwarded-Encrypted: i=1; AL+hErGr7flxzg1DO8ZgITo+XY1z9Owp05BKvZCxx2XD3BkCdqeEXzzT97bvtCiVVp6KGKrtqBY91laRiQ==@kvack.org
X-Gm-Message-State: APuU4Z/7KQENzbDamKlSYgwigi8gSBYPfWRvz2V3E4XLzVUxduJKtlWr
	+oEE0zzWzo1TEVG0l2S/W0b2zfdiufnPuIzjAwWCyQPBMy+DVU6e+v0K+xFVAxtxKHhntieXQny
	rhhBR+4897AG8hGilyBPz6f83rCsNi2c=
X-Gm-Gg: AYBFou0z1pXH1sUJpPssdhq6fvyCPE8TwFsnvmedKUGBZgTHQ8+AkyLRe9HzkMCIkmH
	PliUqWtHkNKlSbt1xdAbsxCTOvqRfeuETqsWnpfAR+UNj21J7nmrvQHpUoUXqHiDmgLfIya25rV
	KF7HAkc5h7FTz7RNg66DUO9KUFzsWShWyHqApxbPRdgM8V2JJcebvhBsLJGyGneviO9JyhTAuzB
	j67VdbCMmD3fXa99q2GOzddtf6VZOIiKKb5FvFQg6HNXoNg6FSoLcX6HDacFhx6wHzDQ0Pl1hsH
	cloR3Y/rVu0y74OWj9OIpSqOz1YdU6vmxz/CsO819KlYs3KdW47pi5VBDQ90S/llTQZpgstG+Aw
	oyBUbnCxKZLmkknu7F7pnxwQvl23rUe7me+KTS4PgG1FPK73FmtjDz9eoPYUxZnUrBxayTp4uvH
	UU5CrpFys8ClNICA==
X-Received: by 2002:a05:6402:548f:b0:6b5:87cb:d8ce with SMTP id
 4fb4d7f45d1cf-6b59783213amr3988824a12.41.1794049140082; Sat, 07 Nov 2026
 02:59:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105155032.240457-1-alex@ghiti.fr> <20261105155032.240457-2-alex@ghiti.fr>
In-Reply-To: <20261105155032.240457-2-alex@ghiti.fr>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 7 Nov 2026 18:58:23 +0800
X-Gm-Features: AclHuK-K-9lQ_cnfM0Ul_urH0Jthae2EmrE_EfpDXhjQgSbXVeW5otSmGXBYcd0
Message-ID: <CAMgjq7DpCCiEK00Es7yU_i_wyf7NU4fFN7QFO_RptF9tGvPZWA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm, swap: only prefer nonfull clusters on
 synchronous devices
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 3pjzsmjxrphh99n3an9babexah9itag8
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B7CF210000B
X-Rspam-User: 
X-HE-Tag: 1794049141-537641
X-HE-Meta: U2FsdGVkX199zc7T8Tj06AQG4ELJuhyTOoGEQE9niqruJgKyZb0GPrjazb9iqkkCKAbYfcwmrCDO/hhQnQfzjhEyjC03uHwYkBDHmg+1fO9y9/Qtf4cpDSSQMoRMf/GUzstMXlTs6CZEsGxFq28Yc8k79+REJ3GyfpaakkZ9iY4bIp4AGGXVOrEM6xyxY/nyRaQdpBTFp0CzwM7KHgYaTwAX9VCbl3rMnwrlYs+cdiSSHtseyPhJpwXv67uxPxTIsXUL+cInPYc4QrpLy1YNVukElHPIQOAno0mun8e6pPLicYWQ4rShupWysKWDG+p6hWM5XhZ+y8YDVa/rZgRn50LpxKJKiQ2+wJ9ILSlxkj0U1bi/6nmY+uLWJjBl+CNYScY+vGd88CBnA0f/dm5IFiuIaPTqwxNpjBQ2FCMMC12ALH/A2JPDy6aaw8Lr18hfpQcp8YF0fhEppM4jJmUR08pr3zKCecfWf1KUR1Cp8ilhSXGvgcODJ/WblVfxZunQxkPSsw902HYtmbwlVYEazomraUP8S2RTXUjazn8P0bK5uBYmjQTDj2PGNRbCYZ1evTs7qprs0QN9S3vabxQ0Uo3Ox2zJSgoVEO943KKJ8TE3rqL0SCxivRzk2+2ot4e5DSsPhwzY+Y61M7GAPpQNG1cMbLnAR73TYmDM4PIVppYsgG5/jBT9CY+U/ZIopmIAgQ5ozPMMSPMQ0eArmqZpC2lluSme6nG2ndOy/MMIDZhDwtVjXSCvF16em4O8SUR5LNoQZdUFPM5Rn3eq94nK7SL+mwNvtckSEg4PxzpEOA+a6FgmyJVwjsPWKfaL+/sqAhvseA4uBWGmc9t3OP8WBPUM4mcfY6w0Xh1EsZ2ZXIxVhvnVxflrDpfNa5NgX2vYuJAMuvVl/dQOYt8rPubEz71zBBXv2hlQHhVyXIqzlSAmv9ICkq/v2eAPOxll75+6PqcsXQpPCckPqlFrpb+
 rM7e99uQ
 XuyFf8ly/FxzNeucu5fohTPrDg9t0n5L8qzFmfx2L5IavJMDZNkVLcmBHVz+Clfhdw8YIm5a+wcmgk4jI5cKo8snlbhytLJUwfhvDt39s4cNUFaNL61Mezzt59aOXdrDhzHKTWtrLKYdTQBtliJpu9zCrh32u70g21SjmVTTES62pAn5Sg07uncOlsY/y/dSrWKmaG6WDxbV/JQrPedQbGnf/1XX9MkPewn/m6/ymlCLqAqeVjJ++a0i8FmwZpovvpOClFUkiFIG3ywCPR5yLXzP/nlIeZ02Y+RnRZukFgbya25vcSXTt0JrmRDZBtX++p+fCGF9TD3chfUqdHwmQBzudBwOuIAphxx87nsntWyzL4digv5XjAV4IH4m/sEXd9B4ezqgnDjPmL2z7+HmSj7iDEzoLBTG4bqHrunth09SJYCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 12:05=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters") made
> allocations fill the nonfull clusters of their order before taking a
> free one, on every device without discard. Since commit 3cedb745d354
> ("mm: clarify the folio_free_swap() for do_swap_page()"), an exclusive
> write fault frees the swap slot, so a workload that rewrites swapped out
> memory leaves holes in full clusters, which then go back on the nonfull
> list. Reclaim allocates slots one folio at a time, so a batch of folios
> gets scattered over those holes, its writes can't be merged and it is
> written with many small requests.
>
> So partially revert commit 9a42aed48421 ("mm, swap: prefer nonfull over
> free clusters") and prefer free clusters again, except on synchronous
> devices like zram: they don't merge I/O, so the contiguity of the slots
> doesn't matter to them, and filling the holes first keeps the free
> clusters for large folios.
>
> Fixes: 9a42aed48421 ("mm, swap: prefer nonfull over free clusters")

Do we need Cc stable? I guess no because 3cedb745d354 is new?

> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swapfile.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 189f04d8838f..1c1b5d0b724a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -973,6 +973,17 @@ static bool __swap_cluster_alloc_entries(struct swap=
_info_struct *si,
>         return true;
>  }
>
> +/*
> + * Prefer a new cluster over a nonfull one if the device needs discard, =
to
> + * spread out the writes, or if it is not synchronous, to keep the slots
> + * of a swapout batch contiguous so that its writes can be merged.
> + */
> +static bool swap_prefer_free_cluster(struct swap_info_struct *si)
> +{
> +       return (si->flags & SWP_PAGE_DISCARD) ||
> +              !(si->flags & SWP_SYNCHRONOUS_IO);
> +}

I actually wonder if we just want !si->flags & SWP_SYNCHRONOUS_IO
here, but still reasonable to keep the two checks here.

> +
>  /* Try use a new cluster for current CPU and allocate from it. */
>  static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
>                                             struct swap_cluster_info *ci,
> @@ -1143,11 +1154,7 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>         }
>
>  new_cluster:
> -       /*
> -        * If the device need discard, prefer new cluster over nonfull
> -        * to spread out the writes.
> -        */
> -       if (si->flags & SWP_PAGE_DISCARD) {
> +       if (swap_prefer_free_cluster(si)) {

That's a pretty nice helper, thanks!

The patch itself looks good to me.

Acked-by: Kairui Song <kasong@tencent.com>

