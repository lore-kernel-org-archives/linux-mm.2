Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B3DC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 04:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E906B0088; Thu, 27 Aug 2026 00:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE9A6B008A; Thu, 27 Aug 2026 00:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD776B0098; Thu, 27 Aug 2026 00:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E85F36B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:38:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 724A180304
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:38:04 +0000 (UTC)
X-FDA: 85145792088.29.64578EE
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72C7FC000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:38:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UhuXhg8B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787805482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2htsjTtUphYSt5se8iPNa2KE41kzGCj3QpUGDniBOI=;
	b=ZQj7SfylzlyQC6QeMtPXRZ8q2G1R3OtKhieWgvOC5/M8JQMUvrSgrYyLww7//Rca+6BREz
	V2iiG6EvcvUAtlaAPi79TWdPDfIK8aewUl+0YrMqufuAORdQA0qbLMQfYRI5fPTTmsUcXC
	SfeN7CFYFsilttwyZY99h4KBeXPDOMM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UhuXhg8B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787805482;
	b=OM5j5Xb6Go4cQwlDdJFUzwG2BPhMm2xo6NHWkbIZqxhlAx0Nx7Rx0BPBNH8gEVHouE3xn3
	+9xrUHpJI9tATvLBKobvPgNKTJNyADJ5u411xdwQEo90DF2uf6+P815F0dKzqycd/jyqn/
	qENi1vN0sXBeAV3HnFRbGkg11L7tY9o=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69f7fa1c548so3177108a12.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787805481; cv=none;
        d=google.com; s=arc-20260327;
        b=LD8eS/7W3ks22u1xqGIx4Rh3wdcGRaUUXhkQi4oUb1+3grhDzuBamsCBlqQAZw0SS/
         Nv/D2h5ElNbu/McORCvrI23apeVlYoAvDhVWVtXV9D6WLtI0SQhFMxPFIqS3scXIfrri
         e8bi5F/FmNwX/wNemJRnEk9bdKfDYDEBwnZqZOkJ3PSv007XKVjqI3W3xsFpSOB9v/mP
         okMn7Md0nGGGfsRzLEJ/+FfpGpNfXv/Fq0TRskVkDsDvRy/ObBAw+AUjxO1/ddAhaOcK
         +68P5csmXvCXKEXbsmqLRCZtEtgjTMJAW2WXng2te//N0wE3suRXRsrRDQhpKtDYDLmO
         aJ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O2htsjTtUphYSt5se8iPNa2KE41kzGCj3QpUGDniBOI=;
        fh=MKC0aAxivMgMxs3rzf8nCSIGEHtpysIK/EUseD5lJbI=;
        b=iiNOyUxXlxrnibFv9wApneeEJ5U/0VxQ4C+jVyreS9ARoLAVyy648NI3JGh3u9Mqce
         KNfpodoeXyCI7cMQUkoLo215+zO1y1hlKqt4rVLYf3K9Z4RZZOeOjChJDx5PP0d8ohJf
         hMUzW9m127iiwhd0N8NOg2OPReCiDYF9xaBo2WHFRakiduXRbUEGgSsJ7HaFjLO3pR6o
         e1s7qVSsmppGHFayesdMFHn2KJaFht9xm3yXMqVjFwB2AZs3NaxHp9rUIY6hVZGbGzoV
         0xPLytjk+Tf45inO4FFR2ppqHwp9eBCQ1+MyvgkdjsuXPvFjfdTfInPFiaI8hOf1dfPY
         4EwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787805481; x=1788410281; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O2htsjTtUphYSt5se8iPNa2KE41kzGCj3QpUGDniBOI=;
        b=UhuXhg8B9+HImWBw+FaoLBO7VNMRNeVkGWKAHoiJabEQbwLw7PonBaPv2d33h48wRm
         G861jUGy1LaOVAbNIiKKfNde4opS+S1N2buUsKk5ANtgTK6m+jSR/Xv00im8vsV1+aYo
         FfjQn5nbEEGO1uHaReJaq73bmkZnqqsye8jr0xWCsnDf0qgi8WFLQd+caTqtsU83K07P
         kGEQNse9l39AQVfvSfs1VWNLqs933TJBR8+fLVRB9icuo4AEnzan5mX6MPfGCGIjMF+g
         itlgc+fmiTQkgrAAL88TybiZPVTwHqHxh1fvRnL3JGwZa0Btd/IN3wmty3G/ELvLAnqM
         cpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787805481; x=1788410281;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O2htsjTtUphYSt5se8iPNa2KE41kzGCj3QpUGDniBOI=;
        b=OM1dE78OM5y9I/lf6jK+pKYtih4yCwEJ/QpFV+X0jhb/y7rp7MBGEfELpNigw1TJiY
         qI/RymSE7XzhOUN9/uefi5enWas/9zjm5ri5DaQ8JGGFRkbsx1IdvlOw1Uk8bpPXAfA7
         j40cWWRYbBeGoCTuC4iMxe9u7GBHZ+0GCoMxYAXlvAc83G3RjXs9vBfVkm9Cxe1nUacj
         4PAGrXZ+2EBeK8XHg7mt6E3hGFG413Rad4/MB4K1SAVjOxHRI2CfXpZ9SJkzA/C9y3gI
         cYlEupiAeQyJ6AuPP85PqsVg/9zNMIG/4PUC3hJ+KI3cIvNxlwGOw03Xxmf/XFrc5RY0
         LZRw==
X-Forwarded-Encrypted: i=1; AHgh+Rp4+gHmds3PHYRHYp9e27sNi4aMqDo/xBq6uroaHkxYx3B4tAH1IyLaoeaRjhWCg/tn/7ElFCw9aA==@kvack.org
X-Gm-Message-State: AFuF++kupEQnDSIXwJ/7lafBTjjxAt8DGRvoUWjT/7ahJEzJvOEFk0yX
	3LAeTJCEv1Zmo7p1hmpmlX9U/sOqHBryTiUTnsIc4d1e9y/3RSGMspN2vW7ujlN6RvyDCZfA1VF
	AXB1/mVb+5S7jKJ7+Er8u/TvpQOCKsKA=
X-Gm-Gg: AR+sD12Y0TplK63NIdy0XNJkvU9WHsJjvqT5I45xszoDsTxC3HSjZVSth66cHwtPLJH
	yLeKXvAcAcFnql+R2MCJBkRX0j4PwGQSLQaFh9Zz5HG/5zltwT+ZCHQVHNcgb7K6ss2nD/Un+Dt
	BSpalKt8203tTzisnh6PAB8KKGniysxLCrMIP2el39LFCM85MpFz+xmA8XzzG+HvkaukRotokyb
	9yb2+qhQHnhLN4DqLJXTIH0jyZ/U1hiW4WidUW+Ix3Qcall7647jAlrOfIo3jNp7uiSN6NY/P+d
	lXVOy8Qr1l+G1NvYkCEScB+KAj32pHjSyh7ktXXMSmunDKYdx+Ps5BwKLKEp6H1stsRqoL5D9Al
	K
X-Received: by 2002:a05:6402:458a:b0:6a3:6d83:ba44 with SMTP id
 4fb4d7f45d1cf-6a5df5f0b43mr15774182a12.2.1787805480780; Wed, 26 Aug 2026
 21:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-4-baohua@kernel.org>
In-Reply-To: <20260821102538.22642-4-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 27 Aug 2026 12:37:24 +0800
X-Gm-Features: AcwNN1W_iNwvnVYGqb9JLU7jABYknRmkiSpEp4pVMz6naKioEKLVJRixCPrb4j8
Message-ID: <CAMgjq7Ar197XNkGf-aeb-XXAL-5uwO3jodOTtrgX-w6p-sOwTA@mail.gmail.com>
Subject: Re: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dro7hejz4bego8urhgrb36gg7o39fxkt
X-Rspamd-Queue-Id: 72C7FC000A
X-HE-Tag: 1787805482-479820
X-HE-Meta: U2FsdGVkX181XfbCG+hVfgfjtfe/Xjd53XEXv/7u6E6wLX2ijJFP5+j5IT4C0TkQw1QpT7WL9Oxic08W8vZAWI0VeXdI48uGXboJt++6qKmZf87/E9cZpaO3UI2lPzvZUK9G6dSaLr9VQJufzM0HIGOuCR0jxbMcL1oXDEkCiWZ+GGfuc17Y1n2eMIW8VRUP7Z0kHTHVK4pPJ6L3tlD8I0IZHskW/DhRMfDSfqgnUCm+hZkjJl4lVxDO2O1XyRT4HHpbq9IevdLrpRoUCl0eHH4UPzIFSuzdl2im9rIAKIAQkMzW9yPhprAaTnauMgFdrFG41LxHj0YIt5aGFSyKZ25YPSra12uWbj1mSc2G42HBg8TA40koqOEtrbne0D2GTwgKHJEhAJtqrQdvYLp2JO0wXaHp0tDUYSOs0ZCpFWQvPwNdVlvzyOaRHDAPwLlWl/DnCtSBbCOhzt6uDv9s9+Fn13RgLbaw6zRZsgAaEoccy9FlZSiYe+YkHJG3heqtdJZ0AOShYAE0tbKRW9UojTa+F1tHrozplGEFc+scFjQ0ybUcb303DCXdMR40LFb+43RnaD8yJO02+RwvJzKwPQyPDR0LXIBv6IkAhll0a8FgV3CUa1kxADV80oQA3lowByvYlsYg9GIZcKi6h8SIi1IZWRtF2y34PXuDSMxIvunpm73bNSU8jjonn0/FhBvv1RSzmmqi5DwTGT3ih21ksK1ofR8KdF9zXZpENd4kbDXNfgvevTnheJr1+61bMaseHRS8dSOPqRCjxDeVSmhOsO3eJjlZQrRkr/AFw8fq9+G7JlmDC1Jj3XfOrALQ66OBR3jXYZhkJ5zn+AhyDUc5HtQCoVBxCZwqK8k6xyOUKOdMGNSfCu+YMabPhBa1yBev2GTsvUl8AfNaKJJuQIrqvg/1J6U+1ds1DCpQiYW4ipLr53QtrD/0W7Wp8GjubdMhBrr9tIfAojau0JK8hFZ
 lxf0FgZm
 a9PxLHKaJv6/mS21t0x2rd42KBaLdQqTFq+oi+Kd02zSBdFrJFfw2KfXGzLQEqoNieNmg/RjNBdUA2M1m0f1rRFKxaZAE5dcJplw0aYywR6UiK0T44t5S9NyCKcimGJ44bXjHB17MGRm2E7aXbNfGavWPlerRP7nlAa3pt8L0Qy49I6ddT0b/A2HHVQUAabEfc/ZsuPEBqFVM5caK5W8/p/hnJroomGysv0GMeik3TrYfmrDE9nk1ypQyroKdPpifzsrYZfGqLOh8dsEb+QStcbqg+0Kj6dOJ6MgPwUJgDX5DCRsSX+UUEiUwejtzv45PdC8dImpw9qm1mAMrbgrBarR7Cf9Ea1HgulAnnuWo94Vzz+2iUo9MNlC6NpAxTx4PreBsSrIlD9ke4qBYfS7bYp+KOiayajCGe0vFnWuiZtdHq9r+7s8lUhcE5gHHhtsdhNjJJjWGLV0eLbSYKoobI0Zs2X9x3ZFB5ZPafT1zIwggfKNFfbMnxQ0OWSOwWUtt9n8oqgOZEA0toUdUZf1Fm3qATbxuNLLgHxwuhC6kmzW3+ylCEzUHe4Z2jwTydTnikpBK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 7:09=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> During aging, a folio's generation may already have been updated by
> folio_update_gen(), even though it has not yet been moved to the
> corresponding generation list. Such folios are hotter than those
> already in that generation.
>
> It makes sense for inc_min_seq() to increment the generation of
> folios that were never promoted during aging and move them to the
> tail of the new oldest generation. However, folios that were already
> promoted should instead be moved to the head of their updated
> generation, just as sort_folio() does in scan_folios().
>
> Otherwise, promoted folios could end up behind folios that were
> never promoted, effectively inverting their hot/cold ordering.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 99ee3c833d54..3b618a51cde2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3946,9 +3946,12 @@ static bool inc_min_seq(struct lruvec *lruvec, int=
 type, int swappiness)
>                         VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) !=3D z=
one, folio);
>
>                         new_gen =3D __folio_inc_gen(folio, old_gen, &gen_=
increased);
> -                       list_move_tail(&folio->lru, &lrugen->folios[new_g=
en][type][zone]);
> -                       if (gen_increased)
> +                       if (gen_increased) {
>                                 delta +=3D nr_pages;
> +                               list_move_tail(&folio->lru, &lrugen->foli=
os[new_gen][type][zone]);
> +                       } else {
> +                               list_move(&folio->lru, &lrugen->folios[ne=
w_gen][type][zone]);
> +                       }
>                         /* don't count the workingset being lazily promot=
ed */
>                         if (refs + workingset !=3D BIT(LRU_REFS_WIDTH) + =
1) {
>                                 int tier =3D lru_tier_from_refs(refs, wor=
kingset);
> --
> 2.34.1
>
>

It looks more consistent with the one in sort_folio, the idea LGTM:

Reviewed-by: Kairui Song <kasong@tencent.com>

