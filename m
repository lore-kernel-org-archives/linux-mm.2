Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D23AC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043CE6B0095; Thu, 20 Aug 2026 05:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01BAF6B009B; Thu, 20 Aug 2026 05:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50756B009D; Thu, 20 Aug 2026 05:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CAC596B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:23:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57CB6A04A7
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:23:19 +0000 (UTC)
X-FDA: 85121109318.06.D9670AA
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F816180004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:23:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VAm/SUI/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787217797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePfkOhlsQ94/rn6xdCoihpwu48VpMzOyCbVlher7Zp8=;
	b=XJpzAZXo76PL2X3hj6He83Fc8Q8nfwiAPS5UEWcrG61ihV4PaRuwV8JtPELhePokZvotme
	q941Go1566lsjK399DuC0vlOVJaq7YGxojghiAEYIar2ToiVqOxKpQ3+v1dXz5YBoml4V7
	y+7onSqKsNAU2NHKJ55naX06IJ1oJWE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VAm/SUI/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787217797;
	b=zBDMiB+1lhee6zqe92hLu22KSuLsmFmgrM2sOv3KNVVTq/1RPxL7xQSzVtwiPyrwvV+9UA
	4FchLpPlo39VwpjCGHeOaiOmSX0/HmfR2/+ALiWahYWdb6ovOgkHmQjR8NwcmW9ju9tW15
	/fKHBPN3yB5vlkXZ07vcTWfS8kk4Qds=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c197eaaab00so368293166b.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:23:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787217796; cv=none;
        d=google.com; s=arc-20260327;
        b=F6Bbhn4ZvqtmrHxqTdL3OdVVCTP3a3hIkplZQDnvn/lu5vQrpQG6qH6ScGHUaMaTwz
         Gx8ZJKrDQsk77lov89DHRNMu4e7WhnZS0CIgrkpafgLnjlzrxISxBqicwuhhA7TVBIw1
         yV02wyL2H6GZEWty7dHsGEW5bNByGv6Hz+mwkUF9p06MwdH7vXTlZXkLbTuO1JCQCtZi
         aQf0CiEXJNh0MdjBKxElUuZl4b4ExfRVvmYQR0afsOiYt57ZtgMIS1zrGkw0Y7Jg8KAY
         vtZWWstlTkoD/3SUKMe38eHQPbLOIQiN0m25RnCzcCiTnSuQI63vzZS4onVMQISHqwSU
         tpmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ePfkOhlsQ94/rn6xdCoihpwu48VpMzOyCbVlher7Zp8=;
        fh=j569bKUUzgC794TBzS4maiq6fApXVa7LiXlq/tzOZCw=;
        b=WR2PM07ZAj+zwm5NGFCE6eKOLQdzvJJU+j++7smXYjrSe3Aky60x3KwdxKy8n0Pjya
         Mk9Sphx7E056UkXeOcrwA1ZYWSyWdFIlywXSzi8o44yeQm2MsZKSFCnMGjRgDPPJAoeu
         ILihiH6cn5SBezXPBNZG1Kb0G1dpCQuwG3tXiEKn6Y8+vB9iLM8w5Tr+4s+Vr2a/fQzV
         Fmrdr4gRy5EY9RIxzabBgaRztppl5JSyKwkIIRiJXY2VZ/fP1L9HcX6/2orMK5eeAqUS
         Zo3ZH6tCJRAfaSG/yWjvm0nwKhMMOL4PC4C3DGUmhpKq0FNtHs9dJBZDkyWueZWKQ+pL
         gjuQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787217796; x=1787822596; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ePfkOhlsQ94/rn6xdCoihpwu48VpMzOyCbVlher7Zp8=;
        b=VAm/SUI/Y3NgRKPhSxIF51FU+aktd2bQHP9XoDLE5dtGnPFgXLvDk4EYttSphlzIdl
         GWlovAo2GR+BKPIR8tK01KAs4ezw6aA68/A81AG7UCpTlqZKGQpdyGsk+hppfC7wpmU3
         Yx5s0BSzmES69OFYOfPFS3Yy+pF/zZqLPYBiYdCXnfoMRadjKNbLdoegtaQeQ+uFqRVg
         GIwzGaqEe+4DIFG+7J/QjxuKtZV9ghkbzzckjjfmfXWT5aIq7gyxnerB255M3LTwk/Md
         YX4EOVXf4/852tL/RPcx0tDehl35tcskTSAH5pvJZfUvluMa/JvwJBOKU/sHLL+2JQaf
         kw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787217796; x=1787822596;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ePfkOhlsQ94/rn6xdCoihpwu48VpMzOyCbVlher7Zp8=;
        b=ElkCgp1Ov5Jo0em6Q44VarbWZXsfW032kegOFnvQJgCGO0pIi+Uz0Dj4w2yk2cuTjF
         H2cERShdvGkshdPwExvzl6iIUO0PADvgDLKM5qzgGGhr9avUtJ8diYfmHwokRO+Mqocl
         DIcPflxaX2R1pkjV3EbBig1jbT78/g/W2hnChxupokXRXU9um5SKHedtK+cQA7wIhqQB
         wrKxCZgg9sL72iPKCQi+Uew/1ggVtqsFhIk2/Thr29hQIcy2Cba6hChLdH4E+doX7ePm
         5358fCwUBCdEzIO1nCdn0VdYEHFimuFaI+vdQvmMM5CtFL7ranFR0QiGhGd5XDb+vFdY
         ftXg==
X-Forwarded-Encrypted: i=1; AHgh+RqwcrxifxxNiq68wtp3d53rJ708musfip7xeQV8TBNImrMCrocNKipxZN1IpXLoxe/2soNx9RZs8A==@kvack.org
X-Gm-Message-State: AOJu0YwYg9b4wmKUR/Egq7eANm/K41X3WcTMp6aOCDfyDgaPqpd3HSAg
	zbRGXkMjz/bdE1uxLuU3BgIeS3IZ+qUMsqn/7sqRpgX5HHZHOZ/crVg0bZPd3YF5Dl+TVZCwKd2
	hJHivW6OLne9O+AyIucmmd2At5hqGpbI=
X-Gm-Gg: AR+sD13XdgoSYA+RUULrpaVCGrKIzte6mW26nMY6tzYP6+CSlibRdqOVobXE+HDW9qk
	aPxP+X1dnUTSCjgrBUWjbfssT5QbjW+l/4MO17V8One6urRbMZrNEgEfv2M10+LV+dsZS/fH/Xi
	9KiETd3nAp9QmrsBjC7yuyg3E9yX6b4ILAKD1y1v5nBuEdKyGN2coUMdOuSpLmh+YUdUR/nNcp5
	ARkFyI8du/Saczcm9eUV17njgVyitDrvjHtbygt6WyeZNcSdVOHAKPMhc8YPhc6K1PLNAeaKUWP
	sTWVJASpEQrgEywOvaykKfK1VuZVZCbyqxNxmx2xP/G5R9+tZTXXPzvusIkXTjHj1TJs/BDIqWX
	ARwzcBw==
X-Received: by 2002:a17:907:3e9b:b0:c12:83da:7eeb with SMTP id
 a640c23a62f3a-c242e2594bfmr691975166b.19.1787217795578; Thu, 20 Aug 2026
 02:23:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260820045603.68809-1-baohua@kernel.org> <20260820045603.68809-2-baohua@kernel.org>
In-Reply-To: <20260820045603.68809-2-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 17:22:39 +0800
X-Gm-Features: AcwNN1VflRKt9cREPuTvMEHanuLeIaNjdgtln4dLjrmUpMdqL-8vzWvSHbMbq6g
Message-ID: <CAMgjq7DAdj9HT7267-KpEqU+SwCASSZMihmtFSjKgGxdWq2DcQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/mglru: improve readability of isolate_folios()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k1zpkm7nn83c1938eycaz6p5aws4a76u
X-Rspamd-Queue-Id: 5F816180004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787217797-237757
X-HE-Meta: U2FsdGVkX19otCkyGjwH1ZoCWSe1+Nx7MP9MAdvjEelhNNEJHv8l+mezG15+ATDW1p3rWrWeJynXA1BadPs0bZROpGRuIi7ndDK6PUvkrlX+GsKesAnKJ8jrZqdyRNttOI58zovqepMG3HhAAEv6hl3sKr81USEn/qjBMyalBVGarEVzMFDrhwEpQVr78pG6IChBFIyjRuY851i77YNMUbRHHNYtjzEClI5iakFk4LgMnyjtD7GGKYvrMe2sAo2W7HuIoKpYBWtqRki7/CsHFvOsf7y6VrLjnabnUM2PvIHaCwnr5fhzIWtJjGPfKG/Pu48tb4ZQgJG7KnZGN5/1weItMgQbjsXRbxEYBJebYGj2IHhYc0vX+sK4cZXY6MHGIox9vmUukb5PoQ05cOIOaBZt4TlLz3lZaoFeJryKWei7GxBbJ1tuYMkXS4KZhjoyv/yytdtdORCgTtbMAEl4pju+XOWn2l4yO2IxRgXF0NzHiAw9YZ3uX+j8EQ4sQJKu65J2QsU14oQv+j8kwYXWDuIbrNN3A8dCIWopApGy12KS9UrviyjFR3XLqdEJkSFlrvLjjnjJrJ+YdOtPcHQRh/FUJvfBXQXQCWFyDS0aJfI+PbT9LDXQWpsXBQiwUjQzp/y7mvQK6ID6Hz+QBXrX79Wmz1TN+5PYRM1y7D3ziVsdDj8PFKLk9VRCkEzPZiVYpo8iGDb3/X+pDJtLAMgPjj0w4G9YvR6OHLXpiV1PGlG49b7YmH1P5MijNa8STSGKGfhFHviAQASmlXK/amV0xlItTTEfyIxsiw2WA5X47+Q58wiQjOJwY+EHO9PUDRXFeCAIEUWLL0Bn+tBOOKD3P663PLDc4YkQpNMpUapmZ45MgJfe9Y/tSqLmIj4UaoluVSsrolMtc7ch8xiCSZGIVoWZnSaCq5iPDZdSqdhPlSCW3d8FHAqk7SML6j/fftVm+z1VNFxRBNstdkKEpQd
 qMtL3YH4
 1S/nK56p2aGgHfjNF2Qtqc8y4UGywTuO4BXjUsQOqthL7v3FBxdvDmJY5Rvai/lNDOicFz+Uop3AaeFGjfpgTEtYMvJoG78Z5CrE+8Fr2i1qOdVsQBXsfvaGkOGmxcV+hUmVlHE3O5En3v7zlUNQCIqvXPH1bsZ0+8njVmBx2uS0mgfz1Eb5Qzx+N/IrXBEM5IxGGl6i7sNGvLSHK2wa3VhWSBxs3yb9/vcjCpfI95oig2f0MY60E2s8EzYkm69md8t/R5uOpQYB13uHY24w8/42kCcHMPPCRQtN2a4Ewo34UcAIphauEqzanW+oHdWFaxYcFgKEem/dj3t/cre8u0unkQOJPzED6wsQcmUdhqNTsx6zMoN4aDtTg51Zd4mBpaRikZNniVf6Hcsjf5rgvcNB3kE+D+Ki4tfh72ExMbAlYNAYgfU8HJxNw4XPBlhqIkWmQ27We8WN4oGo4adBpOTZfbgZirjDj8MXy6NqhhO0i85EaSp837TW8zOkoi6qwS+JIBq1UV/VRq1CNfnwenWww8rFAxqNE6lK98YzwepnJi44D6YHjM2TvA8hnVKYg0O75BhpbsZsf+8UOf1U98WrjJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 12:57=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel=
.org> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The for_each_evictable_type() loop in isolate_folios()
> is misleading: it does not actually iterate over each
> evictable type. Instead, get_type_to_scan() selects the
> type to scan, while the iterator `i` merely bounds the
> number of attempts.
>
> Make the fallback behavior explicit in the code and remove the
> opaque for_each_evictable_type(i, swappiness).
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 46 ++++++++++++++++++++++++++--------------------
>  1 file changed, 26 insertions(+), 20 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d..d5cc30b667ad 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4833,35 +4833,41 @@ static int get_type_to_scan(struct lruvec *lruvec=
, int swappiness)
>         return positive_ctrl_err(&sp, &pv);
>  }
>
> +static inline bool is_single_type_reclaim(int swappiness)
> +{
> +       return swappiness =3D=3D MIN_SWAPPINESS ||
> +              swappiness =3D=3D SWAPPINESS_ANON_ONLY;
> +}
> +
>  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruve=
c,
>                           struct scan_control *sc, int swappiness,
>                           struct list_head *list, int *isolated,
>                           int *isolate_type, int *isolate_scanned)
>  {
> -       int i;
> -       int total_scanned =3D 0;
> +       bool type_fallback_allowed =3D !is_single_type_reclaim(swappiness=
);

Hmm, this is the only user of the function and it takes the negative
of the function, will it be better to just revert the conditions and
rename the function?

e.g. is_mixed_reclaim / is_proportional_reclaim, return swappiness !=3D
MIN_SWAPPINESS && swappiness !=3D SWAPPINESS_ANON_ONLY?

>         int type =3D get_type_to_scan(lruvec, swappiness);
> +       int total_scanned =3D 0, scanned, tier;
>
> -       for_each_evictable_type(i, swappiness) {
> -               int scanned;
> -               int tier =3D get_tier_idx(lruvec, type);
> +retry:
> +       tier =3D get_tier_idx(lruvec, type);
> +       scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> +                             type, tier, list, isolated);
>
> -               scanned =3D scan_folios(nr_to_scan, lruvec, sc,
> -                                     type, tier, list, isolated);
> +       total_scanned +=3D scanned;
> +       if (*isolated) {
> +               *isolate_type =3D type;
> +               *isolate_scanned =3D scanned;
> +               return total_scanned;
> +       }
>
> -               total_scanned +=3D scanned;
> -               if (*isolated) {
> -                       *isolate_type =3D type;
> -                       *isolate_scanned =3D scanned;
> -                       break;
> -               }
> -               /*
> -                * If scanned > 0 and isolated =3D=3D 0, avoid falling ba=
ck to the
> -                * other type, as this type remains sufficient. Falling b=
ack
> -                * too readily can disrupt the positive_ctrl_err() bias.
> -                */
> -               if (!scanned)
> -                       type =3D !type;
> +       /*
> +        * We are running out of the current reclaim type. Fall back to
> +        * the other type if allowed.
> +        */
> +       if (!scanned && type_fallback_allowed) {
> +               type =3D !type;
> +               type_fallback_allowed =3D false;
> +               goto retry;
>         }

Looks good to me, the nitpick can be ignored.

Reviewed-by: Kairui Song <kasong@tencent.com>

