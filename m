Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A5EFF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 06:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0AF16B0005; Sun, 26 Apr 2026 02:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC8E6B008A; Sun, 26 Apr 2026 02:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB1B6B008C; Sun, 26 Apr 2026 02:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A22FC6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:59:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F5C11B7BC3
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:59:51 +0000 (UTC)
X-FDA: 84699806982.06.0C7C418
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 313B8140002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:59:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e3PTW6v7;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777186789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAAvCnDCgoOpj9rykox+6dY/w0LBguxqachAIF6Qky4=;
	b=pF20AwLQYe4sLWuBleMvyj2Kmqs7Jfu5kyO/Z05XZw90tvbW8/CmYGyyBB0dkWF4Qyn3Nl
	g+xaDOXJFs+JiC5CfoEOb54sw7Vn1I2tom++5mL99BCrlEsGbtUnwfx75QQUcE4F68vKyw
	Nhr5k7/9SX+Y2fzgW/VZ5zvI8J4dXrU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777186789; a=rsa-sha256;
	cv=pass;
	b=ZA0mUXGD3ywX1DjajX59zyQF7/lt92JT1UR3ZLZ0TA4dVcxtTNwpgbDA0wETGZBEtLDDsX
	NK2qn80qW+c6LP7JCNZS0Vv3PU6JGK4v5zEHIzKUXTG0XrDf3+X+lgkiW0OSlPJlbxBNQN
	10j6rA14pNIv/fk8M05BltLy/cEcNEo=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e3PTW6v7;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so3756457a12.1
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 23:59:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777186787; cv=none;
        d=google.com; s=arc-20240605;
        b=b7Y3WdqitK4ZmipPVyjWubfk5dsH1Pgsm/QrPr2bAXfi7MoT3C0mT4caNx4M5m+d9o
         /L+UZtf9HFvVfk1s5eZrn5Y6QjwwZHpUjgzf5135h5f6Tw/h41E98LH1ikwUQMkOs/dy
         yqXVKmIiGGNhknsGgYSKl/Avno6nwoxj91BwUMtKH1DJT+EsSNmrYPNyFV+Bm0dV6bhG
         uDdY0gV2Xa3C/u5h4L7kKCZENDqw6oubtVVfUV3Sy+hHHAvdD5fSb2km10gvjJ1h1p9U
         VP0VUp8kLBRYEWzFDc6DL4if8oZILCVLNN97zuYHqM8W4YAB3htjozMaZ2GHBrTV0ZRy
         O8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IAAvCnDCgoOpj9rykox+6dY/w0LBguxqachAIF6Qky4=;
        fh=rx1i7R/Z5cAck6y/zqFhYY2xMOO+koq3kfvoqDHsxQo=;
        b=Crn/bNM6RCUYICl7se1bduf3921FowVBv1EC4pNSSxXQoyvR4xiR5YM98rzMoLi4Jn
         o3zAFAYAoXzKpFqZKbjvVy5/DzfdmGTek9o+2E/vBsQrPgHyazb/wTHhbZh9ONnYsat+
         B8ldmsZkzjfH2gWmPhf0zTfE/U8z9mDQd4q7jABI5TGf1qRCQVZTEn84xpeK8miB1m/b
         MFA+2sChc+FGgcGQJgbliv1oXtoeRvntVlQ/r1lh9L6gGjzzIfT+f8HUrvLu9Xx0hhv7
         xmXKgR600bpy4NNJAr8QVOWC/ArWO1z32J9f3vlV4qUF4iGmAkeS/hI6WWYlGCx+V2G/
         ZO7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777186787; x=1777791587; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAAvCnDCgoOpj9rykox+6dY/w0LBguxqachAIF6Qky4=;
        b=e3PTW6v7wypCut6WUsXeW+FlLFImJxVV8uLalDn/NXEq0dKL3T+flQxhlk4WOagcvt
         lHPYSZOnuDydV6TdYo0sKbtdae5CMat1RPiSjd52Q/Ntlee1MV/CbGf6+Dx4iVl5lzUK
         +YYMQGYFD/AgDiHiJKhNQO7XMSEIIsUnkTL42vBjSoKMO/hMm0Gm6jK3bHjndBkhDbvR
         21iKaidxAkVaFuHu0BamlJT5KDfBN80M/jFZnwXB/xm8FLnfhh8I/1IIb6UzBAjpwQHR
         cGmLEcuScheiyqBapKc5Xx/gOEGOwfvqqf4JWimOpylezDHjFouEDiF5Az6QqEleVYdJ
         hu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777186787; x=1777791587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IAAvCnDCgoOpj9rykox+6dY/w0LBguxqachAIF6Qky4=;
        b=T93pYbd3zyxkAFTe9j08j4Nxoe5aZ8ELS5dV008G0a4wxgbTEkolmNd832muWznWD+
         BMqo39dOUMdJBl/Vntho0+Dg6RdOPgt0Owp/5IVD22FVDFav4RTnI8FIbDS7n6kRxpDk
         iclvhTvlqeawEln16j+tXfrLjpyyz8iVARb2GlAwiz2pnmCWnU5ZZCuxltF+SdQmZ5BC
         lNJKzSsKGZ8bW27qHFoenwboK6SmD3dqVen36sVeK0O5pgoKwauDCVFxnpcu7QdXcfNv
         h9xJa8ouRYZOFB/hAO7V8m81MlwuRj4ikw2LmRdFvzrmOFtzf7zHV5c61j8qC4qvl2/T
         nyqg==
X-Forwarded-Encrypted: i=1; AFNElJ98PxYMC6/wPY7s9qRYploTxLyK+vppRaRHWrip/OYf/QOD7Cxs96QKQ+Qyp2/WsMOtZ4b0y5y61g==@kvack.org
X-Gm-Message-State: AOJu0Yy8EP9f7QIuVTxTKCWfVNdUqMJlskPHZrq+sAcd6VJ703KbNgml
	SxonczGQTQMy/UwEz3T+Ed63TIPizHpJhQ6NXllKfCVbqKI3d25GONQtU10UsUsbckEWfHf8jSD
	OIFDxG34gGKrxK/YafdGLnjJmyRfRp3s=
X-Gm-Gg: AeBDievmILnmPvyZ7Wj6ardCzRMIc//L2TwP/pPJSFftkxJZb0+iNCo3t8q/xAjQQGk
	BwhpzJ2KvokgVYpk33fRb5QH74Rq9ECAHXybsijIu64/nRpTZGk0p1AKfvk5EQS2M/XzokQcrnz
	Ln8HC1ED6bp5A+uBCdzS0qVZ5TuPxeq4jfRjIaxizemVwg2WzACoI8B4HQd6jTlxuDc3uSYfkuX
	bSxL6/p5YgKGNy3VCSjZHOtCTyxG8xfkouMlH+PIikRvfgMazfXFa9nJBT/54kfxTYWv8PfLfJ1
	C12x4MzOw19hQ+wnW8oYvmFNcemLNftJsHXBX5n8L8QNznm3wac=
X-Received: by 2002:a05:6402:1cc2:b0:677:1d09:56d3 with SMTP id
 4fb4d7f45d1cf-6771d0957d7mr6183533a12.5.1777186787256; Sat, 25 Apr 2026
 23:59:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAMgjq7DM6Sd5EYx=PLtYHBYk6gAPFupYg2a7nib2KrGBO=HtGw@mail.gmail.com>
 <20260425205759.1701-1-baohua@kernel.org>
In-Reply-To: <20260425205759.1701-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 26 Apr 2026 14:59:10 +0800
X-Gm-Features: AVHnY4LCm6V6KfvqRZnvYTi6GhCOX4rMTVEtEUYP14hfo-xsVzd-Dr0edQe0yYk
Message-ID: <CAMgjq7ADH89OVheesAPBUCK11pYmje4rXTLkxRW2nAw+8r54Jg@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@huaweicloud.com, chrisl@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, kaleshsingh@google.com, 
	laoar.shao@gmail.com, lenohou@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@google.com, surenb@google.com, 
	vernon2gm@gmail.com, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, yuzhao@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 313B8140002
X-Rspam-User: 
X-Stat-Signature: odqy7p6uftemdejwmwy8ec8p3ccio41q
X-HE-Tag: 1777186788-226900
X-HE-Meta: U2FsdGVkX1/CGNDXo6RUTf9pociuSHt9wMRsJn5/5t9cnuUJQmx6VGowNCwtQyscCDxtnoXpbFaU1ekraqcCRn4sMi256KQ21gxQj/9DU/wtXFQYiNniNhp7iNGmvSH6ho7kPd95hqXwAEPvhYs3l4c3dwiGrHoAbimwFGblDkSpdjo7LIh1wxidwpYAu9/GwWMmvNVegekj1tKiaeUlC7aVoJfyObxVF1CahlMSm/UDJrODrtFy+VbGAnHxXRqihySNePyhGryKws5CYd91jjd76jxyt7bJ5SmCDl6X92zU1puQQjDLJwqin8zSdCY/JWFiOZ3mHocJFKir1lC/0aWhjJUCeZUta3Ap2iG9lGjVTq3kP7lDsPYrD/PGSFzXM8x4+4bf8pjYjN3KPnOEy+cVDuajnImPBszUJusNK7Kbusy1plwPpSWCkgmx3Et2lXFDWYt7jn+GK3PfftVkTbeUV2ft6Kc94/AbVIboClDKq0C90turQ3ih8/+u2/8b3LoYbNKTfKwHeMX9yhA/yyf+2xEwbfTf9yilp0ShK+VKaaNDX4K1vJmgoqdigzsc+4AjKmR/vaN0cO/WogdA/+R0ckJEmW3lGtc8Uqmy2nOneYZ3jm42mDTwc3rbUrH7+9GAf18W4fiKdhE77EjiyLZHp5TVaJXPayJv38+lhq07X/MRZxBVSpdh/zLzpToHEbPv3yfZiJPIJ5k8/4F1ulSyMR+XWhZycwrVOP3zilUanKOaHFO1lz0sA7FUfP4rArbMHUcF6zsHb7ASzfqLaaZpUuEdQOit1s4DMjo5TyFQ+2DvLDBWJBM4Q6UlAVugHkYhv5vc2qmALOMYJGk+IDl7Ypld9gDz1EsaB8LEXKXh5a7d1xkywS0SD4z5NWVAiWM/XbF0EJVOLRkKOs1fGXICVgr9eVJKoLhylfJ6xpXWLNuo06wMHvHF3UMIM2MXpKHZdbTMG/dclP2FVPD
 OrSf9CHc
 Ys2E1TqxgBHoHmAAd+8JejGTNvdmuElHDHPPDqhbM1bghMTXCBtOB17XZHnVElRMe9e0yg6xEG3vB/WSRgkAtkkQ3cXQRCyKO7v7tybgShK++ELLLfNzgTUuzQwkTNy7llLvGiY+jZhZOWAmTRbTCw6M5QRj1otlKpe19aB1a3+Y43nZw5IHfBWexr7wYnDdvzKsM3UqzLlGXFsemPhHShZlCzoCbt2WcjS6MhcgGjm1BE/UgWKX5lJqUHKbqkajjBYS3b0dspdLCNucceIlaqm86k4lDhDpxaXdTOfR+5hhka+QHRF1EuAK8tAPBWPmHAHIm9ucphi4R6IE3rj1Z2JTf7tgm45fkwnQjhfaciWOI/ChO9hFgD8LjMtb46dTWIfrsqrN2fia73fRhBreoNqsuWO8yriLZHPLDrF6XJST1FY9Hq5XaFISY0x1bciPoz/W6Gs6cJZfZeh2A0yUeEpggB6OiN0Ll/6KKqeNv4Aftdz1Dqjua7Fpq+BLMU94OwA60UlHSYYE0p20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 4:58=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> On Sat, Apr 25, 2026 at 9:30=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> [...]
> >
> > I just ran a matrix of for kernels (mainline, mm-new HEAD, before this
> > series, after this series) X 3 different memcg configs (-j96 3G, -j48
> > 2G, -j24 1G), and none of these showed any regression but all
> > improvement. That's really odd.
> >
> > One possibility is that I removed the:
> >
> > if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS >
> > lrugen->max_seq)
> >     scanned =3D 0;
> >
> > Which will make the reclaim loop go further and trigger aging.
> > Previously if reclaim drained the LRU's cold gens, it may go reclaim
> > slab instead. So idle inodes will be dropped with the mapping and
> > reclaim more file, and we won't see any refault data from that since
> > the mapping itself is gone. Sys will be lower too, as IO isn't counted
> > as sys. Checking your data, despite sys is higher, real is acutually
> > lower, which matches my guess.
> >
> > Will the following patch help? I'm not sure if this is the problem,
> > but this added back that early abort, personally I don't think this
> > really makes much sense as it's more like a workaround for other
> > issues, but if that helps we might better keep it.
>
> Hi Kairui, after five hours of sleep I=E2=80=99m feeling much more
> refreshed and should have identified the issue. I think the
> problem will be clear once you look at the patch below.
> Feel free to include it in the new version if you find it
> helpful.
>
> From e3a0b50dc53a3a5f2ef1adfb73111336e3c2d08b Mon Sep 17 00:00:00 2001
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> Date: Sun, 26 Apr 2026 08:34:21 +1200
> Subject: [PATCH] mm/mglru: Avoid falling back to another type when
>  scan_folios() leaves no remaining pages
>
> While remaining reaches 0 in scan_folios(), we quickly fall back
> to the other type in isolate_folios(). This is incorrect, as the
> current type may still have sufficient folios. Falling back can
> undermine the positive_ctrl_err() result from get_type_to_scan(),
> which is derived from swappiness.
>
> A simple fix is to continue scanning this type for another round.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ef45f3a4aa38..169fbbe17c7b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4788,8 +4788,13 @@ static int isolate_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
>                         *isolate_scanned =3D scanned;
>                         break;
>                 }
> -
> -               type =3D !type;
> +               /*
> +                * If scanned > 0 and isolated =3D=3D 0, avoid falling ba=
ck to the
> +                * other type, as this type remains sufficient. Falling b=
ack
> +                * too readily can disrupt the positive_ctrl_err() bias.
> +                */
> +               if (!scanned)
> +                       type =3D !type;
>         }

Thanks so much for catching this! The fix makes perfect sense, it
restores the pre-patch behavior. I was too aggressive with the
fallback; positive_ctrl_err() should win whenever the preferred type
is actually productive.

Would you prefer I squash this into the original patch (with a
Co-developed-by for you?), or keep it as a standalone fix on top? I'm
fine either way.

One related thought for a follow-up: scanned =3D=3D 0 from scan_folios()
is essentially driven by get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS. So
when the type get_type_to_scan() picked is the one that's
gen-exhausted, maybe the right response is also to age that type
rather than fall back. Right now should_run_aging() only looks at the
combined evictable_min_seq, so the ctrl_err preferred type can
silently stay starved while we evict from the other one, that could be
an old issue we can fix later.

