Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788D6C79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 08:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70CB66B0088; Sun,  6 Sep 2026 04:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD8E6B008A; Sun,  6 Sep 2026 04:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4776B008C; Sun,  6 Sep 2026 04:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AAEF6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:18:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3D601A04AB
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:18:22 +0000 (UTC)
X-FDA: 85182635244.27.1F88B40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C77A740004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:18:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Al5dJpzm;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788682700;
	b=RAhMm0YQj1XiI6i9Jmy6Qcgw7iY9rZC9bRmFgauuyOrtRTCoxKKCP14LNQKYj5EASecE+w
	OVNE1zxw3G2XWjHY14cKXH183bfO1nNEFxIJufXKvx4jYuPQO5YLPsqN2lbcrE0d1MTCIE
	cCS1pbov+LtjWqRKvv1MCeixAzgoaoI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Al5dJpzm;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788682700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQZRDFZ3IOccz+fd+fDDFPiV3KsBwPv+BsJwqYRjyn0=;
	b=5Y7rRPSTR1Qxyp2C+UYEWdarqoQuJ0Hs0RiEHs6e4KwISzmA1csLZl+uAbjfBW9VGbBjE4
	Ikn5at0923q30HLkXq2A8W+954ZznMT14aDw1tBbWYFFWcWrVq79uI0eHtlfb1v+Ya+S43
	mfS7Yv/d0vBYR8y5Ed2h5V5MWatjLKk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF73E43A65
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB831F00AC4
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788682699;
	bh=rQZRDFZ3IOccz+fd+fDDFPiV3KsBwPv+BsJwqYRjyn0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Al5dJpzm6B1wU9XMtPcueJtAqov0f593Rm4tkkEzmPNh6Ua9LubeoIQHhI51yy71r
	 VN7vR/v8Es2dfaIyCeMxmbpbPrvOQt0qhU5MZv326M+mdQh0cn7NGgmVZb/9C/Crne
	 tGW0Cn8yhP8+wzIGZD3MXXRbS9t/55hOgktNFKxEepTfqLciWdeTh9wwMIhwbIqz6K
	 vnYYZITAYnJ43xp/1f4H51JaPI7iAcCnIKVlg0pmeLZFbU8nFT7Jk3DXMIPKm/IMQe
	 JNpfO3baA1jRH02KYx/UTfrqSLgftu4EduWqD4Bb6hM2TfENJ7JY8G51c/Uxw0BgnY
	 9/ptUGQG2WFsA==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9399a162f93so65596585a.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 01:18:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzLpj30/5HsJ7qwN4Tj11yihfpAGcatzk0UIy72wZtfjYztTJuS0tfwlqcvatPCfFa8gXcX7ROIPA==@kvack.org
X-Gm-Message-State: AFuF++njyDTtc1cNejXFRL8xI94byrrgB6e1uTtITHgRbxnIg5NckOtv
	cfltT2BtGGelN9OTjZHBejHhqN5J/11Nb50YtqTdBS72GxD8QR0eWo2zoWTWoCJwA95MxxC6s6V
	qQk0MiC5A+LGAqXpE9yU6oLf4tqenCbo=
X-Received: by 2002:a05:620a:254a:b0:939:78c0:a496 with SMTP id
 af79cd13be357-93980468659mr1711454585a.38.1788682698852; Sun, 06 Sep 2026
 01:18:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260901232421.40157-1-baohua@kernel.org> <20260901232421.40157-3-baohua@kernel.org>
 <ac1f4e9a-d45a-433c-b26a-23fd0d955243@linux.alibaba.com>
In-Reply-To: <ac1f4e9a-d45a-433c-b26a-23fd0d955243@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 6 Sep 2026 16:18:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yRi=YQi9ooV-EZJLzzv2eSCiCCHiG4aC6FMb5QMXWoMg@mail.gmail.com>
X-Gm-Features: AcwNN1UYQN4xnLf3vWTUQQebCDawV3qL4PRiq8gfcA3oguAOfDAy6RaLtERSzg8
Message-ID: <CAGsJ_4yRi=YQi9ooV-EZJLzzv2eSCiCCHiG4aC6FMb5QMXWoMg@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C77A740004
X-Stat-Signature: i7kiudd3yn11e7ygawu64xhdjpmqs975
X-HE-Tag: 1788682700-281343
X-HE-Meta: U2FsdGVkX1/SLvQu2I3XlWYFlGB1INbTtyMFlfg+wCBtZfjp0BsNNUxKJ5SsUiHDFgpo4B7wX6gFntoC72RDhtUYEj4Jp/T6+SUCoFKzGv97Y7v9Qj1Ijv22j+q4tsZC4RI4CKbmZ6HnC8xu1Mj/24bRmXUEec7/N0EccIgTdwwNqMXXIC/WgbZjxa5PSQJIsF5a5d6y5B3WTgR9zcAedA7y911+p7Jl9B7KYs5GAcUIF4OgnkkwNecGTMSaDv9stXWnvsVztTrBbLyPGwJm2PEMF+dOC8r7veK2l8EfisGvxVIEpnMIxuDhsiQX9KlgnKZRMaZbxLD4leEYCl0LH4zrkgkq2AT0M4fAB7aZQ5E48iXuc5dd+kl5aaV6Rydj9xJHM2J6VAjM/Sn1Dip/daIAokIyEvjCiUYLIr3cWj005bDnGasMf3Dw3TO4H2118q5ASmd/vLPObdfm9t6SVX6PoSW8jpBzd/Uhs4dzK6a2IDegGDpsEImibbptuwdiJaMDotNP0mx8mWY8H945z7HWtmcbOAnMsqg/wKK6Pe7XBVJEvA2BUwesNAYc/yOrHblMtWIsHlqS4HIMwLtIXNx6mL3QnwQFP2TcrjaszfFKPJ+A1pbBzjA2fT89NhR5rJ5C4akVmNRqdTnGhBsfd0oBurAhDxcO+4/7UaE2guq4kzdYBmtbjIAN01zkMgHtJvzGW2s7M1EY2UHHZrWYUMcXKLbZLzxAZfdasdKnHE0HpWoaU6xjU55G4xFYqjsSkFevDcc6iaEl8c8cRM2FYd8XO9GhHAyOfYIV+HgP6QiYFjHB9tkSotp03gvs/s0WvJVkn/zu27pIYaos9+YFnIa5cVs/WGvyMJy+kZe83peMdxCO7seCbOx+L8EyiZIn0w7XQCk7C68JpX0y9wFHiaaqKQZ9usGjL8f9kUkeClR9uHJpZt/AI1988sBbnca9V5wTsiXr9OIqaY34Yt8
 HPfa4AIE
 JjClqqVGifoIzQijxHQoUOKDEx9b1EYSvokZOYWyl3f4k5eZcQC/yFeufNg7vIQ+M5WoK52RBn9xIy87hk4ntJphcoSOpDsJXLRcArW6kniIiIqKmHZ3Q6zAqOkA42kNeBOAh1yVxIKu0e+OJ0xJoSVAcRKcGy3P2vD4VqJavF+ltwhssgElYWfnK5y8p5wAN6BFIIBXNn3GCURgrd1vb5oSLr2/y6mxNk36m7hlP0/c6IYHEnDeLNaUi73sIt3AHDJVZMfeJHyQvPXsfss0PAZlW0gIKquDyKfq7s43jAIvopiGzsC9PzF5p/YnSx9jFwi9NvC73ETYyk+pIwJ3hyQ4T1ACwVGInCtty/8/F4G/vfc9o037dxbl9WhAdwrGBO3Vk16Q9Fp3iyW7fKsBbVXuHUdTGao6y/QFgYFFjZPgE6WO4Z0yiNKoTudedDwlulkxBbDJeAMNuWmFYBh+H3VjGeFlRGIqFKdtF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 6:06=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
> > Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> > as it advances generations. Instead, accumulate the size changes
> > and update lrugen->nr_pages in a batch after scanning the entire
> > oldest generation, or when the scan stops because remaining reaches
> > zero.
> >
> > Since we only move folios from the oldest generation to the second
> > oldest generation, the active/inactive state cannot change. We can
> > therefore skip __lru_update_size().
>
> Make sense to me.
>
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > ---
>
> LGTM. One nit follows.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks very much!

>
> >   mm/vmscan.c | 23 ++++++++++++++++++-----
> >   1 file changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 54bce2f608ef..27494505cecc 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3918,6 +3918,7 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> >       int hist =3D lru_hist_from_seq(lrugen->min_seq[type]);
> >       int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> > +     int target_gen =3D (old_gen + 1) % MAX_NR_GENS;
> >
> >       /* For file type, skip the check if swappiness is anon only */
> >       if (type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY))
> > @@ -3927,35 +3928,47 @@ static bool inc_min_seq(struct lruvec *lruvec, =
int type, int swappiness)
> >       if (!type && !swappiness)
> >               goto done;
> >
> > +     VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) !=3D MAX_NR_GENS);
> > +     VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) !=3D
> > +                     lru_gen_is_active(lruvec, target_gen));
> >       /* prevent cold/hot inversion if the type is evictable */
> >       for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> >               struct list_head *head =3D &lrugen->folios[old_gen][type]=
[zone];
> > +             long delta =3D 0;
> >
> >               while (!list_empty(head)) {
> >                       struct folio *folio =3D lru_to_folio(head);
> > +                     long nr_pages =3D folio_nr_pages(folio);
> >                       int refs =3D folio_lru_refs(folio);
> >                       bool workingset =3D folio_test_workingset(folio);
> > +                     bool gen_increased;
> >
> >                       VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(foli=
o), folio);
> >                       VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), f=
olio);
> >                       VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) !=
=3D type, folio);
> >                       VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) !=3D z=
one, folio);
> >
> > -                     new_gen =3D folio_inc_gen(lruvec, folio);
> > +                     new_gen =3D __folio_inc_gen(folio, old_gen, &gen_=
increased);
>
> IMO, it's better to add some comments to describe why we don't need to
> call __lru_update_size(), in case someone thinks this needs to be fixed
> in the future. :)

We have already said this twice=E2=80=94once in the changelog and once with
the `VM_WARN_ON()` in C :-)

+     VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) !=3D
+                     lru_gen_is_active(lruvec, target_gen));

I guess we don't need to say it a third time, do we? It should be
self-documenting.

For a possible future change, I know Kairui may change the definition
of active/inactive=E2=80=94for example, by no longer using generations to
define them, but instead using refs. Kairui knows the MGLRU code
inside out, though, so I'm not too concerned. :-)

Best Regards
Barry

