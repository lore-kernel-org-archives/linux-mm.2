Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84984C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834956B008A; Sun, 30 Aug 2026 00:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5636B0096; Sun, 30 Aug 2026 00:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5846B00AB; Sun, 30 Aug 2026 00:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 454E16B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:28:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD1091C15C4
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:28:25 +0000 (UTC)
X-FDA: 85156654170.27.32ACD9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CBA37A0003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:28:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b6LdenXe;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788064103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwhhqAKQey/9CCyH5sr0Bsi1+3+p1VFmtEf1p7MZ37I=;
	b=L7iLHyp19ydY2+wYSmZmyoonnqJ3ogSzSHGEAgqAYFGmLNKH2gLw+M9C853Zw4CFssKe2T
	9bfFUPmj+MUsb32XslgBnkwH2MW6aNFFcC7pzf4ktmZUZt1Sf1+H0vI8Hp6ogA4VM4NHr0
	yUyN4etMjs9YuHpJ8fNqaz4jA4gZ1v8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788064103;
	b=ltRo65I4sWhLzp99W/GS+YF2BZwKcIC2fuNN7BXKhdtTQbS0YkfbikuvUGf6tvephIYdtR
	erIRHoC2ZHIKwG1wRuBgt8LNXC001aKdMt2vtNk3xs/e5hf0Z9Yt5U+nkaYTh0kUuJ/Ovd
	thYodstwihyUAdMY3yycmvc34J3AwZU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b6LdenXe;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 022DB43EFE
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADDF1F00ACF
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788064102;
	bh=kwhhqAKQey/9CCyH5sr0Bsi1+3+p1VFmtEf1p7MZ37I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=b6LdenXeqNNfz6OaQ3QpZEafuBQ7ReSjctgC8JdYp/65ku+3LoOcicUanoiiY7U6A
	 oAzX7k2tbTsQp6SDRyqg0qdpCcn3V3cYu/ZUgRGVTwz8A1koYQ3eDwtQX++OY/KiuK
	 itxGO2Y/ZUSH10Lx8QS75L0RIoasjl6N03ZicF2K5NevvJdap72baFEKgO9XGHRSiu
	 iUyanC09nnn/CGt6jFGM+aW3k3BEPIfE+wrWPaGpk4/SnjtAvGNhJGW+wquvjXTW+7
	 9eUxAEtvzIUdgOOip/ASQFJc4GhWEiUm3J5hGF53cpbpxaVcIH+2swlu2QSubb/R4w
	 1aR0t6o0MVStQ==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9390a2c8909so154450385a.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:28:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq7ZDovLAvqkfLzVb5uPw40TvNekJ/pxRmXh1/osIcyqsGVRlltd8kI6BAohAqg95OwRtbDvkCnXw==@kvack.org
X-Gm-Message-State: AFuF++kBr+5mXKBgXhxl5S3+E0+9v1jumodOElVrQMrndbkjjFsAU0MN
	XyLrTBVNqEI83vcA2amOYoPbqD7sbwgre+s+EsYX/XRwGuZC1bn8NBcQ3vNGQcDprHO1bDdssZu
	YSjLWN/am/j3OcfEhNTgcyL7KA8hx2is=
X-Received: by 2002:a05:620a:29d1:b0:939:1b82:47c4 with SMTP id
 af79cd13be357-9391b8249e0mr1079000085a.37.1788064102271; Sat, 29 Aug 2026
 21:28:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-4-baohua@kernel.org>
 <af26ac3d-30cb-47de-a295-6f9b4f2e2c32@linux.dev>
In-Reply-To: <af26ac3d-30cb-47de-a295-6f9b4f2e2c32@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 12:28:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zTHhkBjzL-Q2N9kk6ggjYeKQOmkXBPofRyQno8QrE5LQ@mail.gmail.com>
X-Gm-Features: AcwNN1VbJ6v4Z40lv3fn5JDjk7Qgjnd1FigfVZYZsefYA5vPub56D-6w5qqkpCk
Message-ID: <CAGsJ_4zTHhkBjzL-Q2N9kk6ggjYeKQOmkXBPofRyQno8QrE5LQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, lianux.mm@gmail.com, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ac96ot9w5nmrcjs6ehbge8dhh4qou1to
X-Rspamd-Queue-Id: CBA37A0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788064103-938151
X-HE-Meta: U2FsdGVkX1+4iXXaV+UalEd9hjwuh2xFcDWE/1f5dbBAiBjWm8IFz8JGOVvdW5BeIk5RfoViiuyQ4qHMx/1YdAeEuGLIT0qK9GWuk6nTEWnfsr9lfZyilmQc/vztRmJgJENfH5RAyK2owhtRoFAbQM4/5PMZ8Ky6R6YcYk5elQEIuQ4siuOzwswbrNZuttuD9Ak+B7Lm6pDPm4lRhwgVX+VpK8K8ujqty9WpR7gthIE25jH9FoDwesF0oPCX6mcDgHBSWqnABlbFySto6vBZHYV9eynQQQvtfRKhaXU6PRjBUkXUQu40KI3f+P0OHZjXnyjV+q8qvCsv12Ls5kWWp0rriuLtI9AlCAdByMM2eZxcqwcwLRK/BlxSeKEU9A14B5YF3RUFpOPb957mz6gg6MuSTzEKlI3iNVXzUpRhZwpRc9Ft9qcqC06HNdThNZ2NWCydJD7XEArKnM3NA+w/t41bM9JN7jOwIu2mWA00OTSQYqAyd84WSchYUz6Bk57GfcnNLQEHvTTx5HZdrcUzaRkH6v4YFcFrRfyCUsydGnnmJteAhEerhtbq0rPSdPT4n2HskEgW+ALY0WQHvVjP3BNgISUlv69icYuAGwXMlFlq9FrohxyGUFbDjMiE0igoVHhQ04C5fncD2hJQwDoja9R3NNMgi7qO9FKbnbRr/vK73iAGNbYFY9yxlnDroJFa+NK0rZoj31z4NWUrpmNpKAfku0FoNi89vSTKEGaJv8L7h2buihSiLdJsGr72wHcEYrbK3beAYeTerLqNVWoAcn2t07N4z99sVa1FItWzuzihbuQrwKk+ZnlVBFm0rtyGREFQaj1rbTNsu1hAdA0Z68pEPMA7S13/TW0xYcnir55avtvMdF6bJxwZHM83d0Ljv1wvlYsv7RrU7f2cG/rDMJisBeh7+K1sEni9P+zvJRW1XFwfTxZVwmpQDneTskZ+icL2RMSilu8kohGPD7T
 CoWSw5iS
 FtgzCHJ0/HDOzIuspWT8i5eV4RnHwhGBAOMsXwRvHyhyhD97zmj19tIxCDak3WsBVEgLbXYkyjAEQftmNghOWucNzA5dbzSLTu6uFVvxCvxuLtz+aAPUeQEVn90e3LJtRCg+DzfB+BN1rj/uOPyd7JTN36rQ3HB9B6pe2T3zsd6xLxjMoYQCq59Rh4SbdSXZ5HCMGMXku/qVNEJ/0ivUGS88LfE3wNKkwalnK/H4aFkkeCa6E+3ylh3P5RUrUcpLhcW0jVI1P76P0GE3pk1NUNfTN2CJYyUIy/r8DUJMtPvkAhB6hCHMmGOELgEGik42EQdLcUcms4vGL80aQDUL/Zm7NYI2Cby3/2ilxMz10ja6cizyR5WEqAJJ9sAm+gE/e5Sa0xJlTpXTQJDSnnm1hfrAqbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 10:44=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
[...]

> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3949,9 +3949,12 @@ static bool inc_min_seq(struct lruvec *lruvec, i=
nt type, int swappiness)
> >                       VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) !=3D z=
one, folio);
> >
> >                       new_gen =3D __folio_inc_gen(folio, old_gen, &gen_=
increased);
> > -                     list_move_tail(&folio->lru, &lrugen->folios[new_g=
en][type][zone]);
> > -                     if (gen_increased)
> > +                     if (gen_increased) {
> >                               delta +=3D nr_pages;
> > +                             list_move_tail(&folio->lru, &lrugen->foli=
os[new_gen][type][zone]);
>
> Nit.
> This is a bit confusing to me.
>
> When I read the code, I thought this implementation contradicts what the =
commit
> message says, which means I thought that we move the folios that have bee=
n
> promoted to the tail.
>
> > +                     } else {
>
> Maybe adding a comment would make it clearer, like:
>
> If gen_increased =3D=3D false, it means the folio has been promoted, so m=
ove it to
> the head.

Good idea. will do it in v3.

>
> > +                             list_move(&folio->lru, &lrugen->folios[ne=
w_gen][type][zone]);
> > +                     }
>
>
>
> >                       /* don't count the workingset being lazily promot=
ed */
> >                       if (refs + workingset !=3D BIT(LRU_REFS_WIDTH) + =
1) {
> >                               int tier =3D lru_tier_from_refs(refs, wor=
kingset);
>
> Overall, looks good to me.
>
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

thanks!

Best Regards
Barry

