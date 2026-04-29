Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1062FF886F
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274E36B0098; Tue, 28 Apr 2026 23:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225896B009B; Tue, 28 Apr 2026 23:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11AAF6B009D; Tue, 28 Apr 2026 23:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3FF36B0098
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:18:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 854EB1B9D60
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:18:02 +0000 (UTC)
X-FDA: 84710134404.11.9867596
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 831D380006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:18:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IZx51YED;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777432680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBNUm3EqKRX7L2G+NxGyN6o8RA1OnwacSv7d0wz3S5g=;
	b=DtByMkoXIFfL6jDe42HrVM5csS8nl13Y7DatIiY8vxy79cmHA+IBoVQzObDoCNUYl06VGV
	nNNevzKIWPYN2YTywJqZOa2tAqUBtX9d5YggpmlQpRWKz8NDa8E1DAhVkvZ1+u+Xn4sfFY
	BHAmQkUpkSBpng+xAHnvITM0tcqGt3Y=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IZx51YED;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777432680; a=rsa-sha256;
	cv=pass;
	b=uR+L0qtIRb43Faqy1AJYWu4c/QL9LR4/RHOk3G/uW4IOlNRjJt5NltXFchc3s5aFMKzLni
	W/iGO3hSloBpNNO8NqUe3ZIzHa9A4GnMU5VKAAcRUdvHFUjLf4vcuuBXYjrhWynv0DRsFG
	PNdBnDLmfu2rNMtp2oD01Do9LDtL6GY=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so715693a12.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:18:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777432679; cv=none;
        d=google.com; s=arc-20240605;
        b=JKZmQ4hPPImOYBPKKsDVt4S7/Jc3tysd/wAdnIP64ba+czkvZEU9idoHGhtJvq0gAt
         mnBU0m15uZMAUrOzGwjWcI9pr1f3UO7r449FmylNkShdMlBPSAUFiCq4yluFt8/gvr/y
         ATDOt4mgOki4yg3rei4jd2uZUtBf0lJCS3KhuatzSA7rwtgb9j1cz5VBeiqDeCHnnF3+
         2XHypR9lNNWtCCteR1qQ2tF75WeNGwLgupoRvQ2udlyGNfz+x1TtmXC6tOwKsbPGUsEb
         pKes655D3gpR1SRbTBaIieHKIAJPj/V1fjQAQLEJEsX++Nk2oLbmiLq7s2P8dB5heEhs
         631w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RBNUm3EqKRX7L2G+NxGyN6o8RA1OnwacSv7d0wz3S5g=;
        fh=8mZe3lFTbc8HLOiPa4B1gMIEz6p8WK7Mja1e54WT6gM=;
        b=QTO43BoCxLPpmKZ0AHQGWrgQMgZc9BKXMoGZvdlUFhuLxFiDxbFlPNc/tpf6Z0kCrV
         hAOWHeAC1lCTGxNB5tOV9yf45ICwXKX6fi56eHVoCa3acskFbNSrzY7cpzcOYyZTMkL8
         O/mnYis2JRfWzaqG3anXw/NEAfKLNwypBhULUGd80bb4UjQ88e02TKkdsOLbUf7/V0m7
         Nvo9ZFWIn0sLr/YyqHkj8hNqePi3cEJK2B3CTWbIwOB6Abbw4cUtUpk8y8glUxZVJSAU
         QDxr2akbN7AvwPcf2h4lsZkd9w9GY2lPS6/1VW6Mq3lsLlMDqMaLoRDEV3ka1costyfv
         xhkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777432679; x=1778037479; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBNUm3EqKRX7L2G+NxGyN6o8RA1OnwacSv7d0wz3S5g=;
        b=IZx51YEDIm5heC+3p6g0h9qUpEXPzdTuYThCexe/Mrtz4OUhGg4lKucxTPeNgLKDcL
         HWWZcLQIPOfsT1TMfCd9t3n1SbSXZm7i+xrlZwDm4kDdwO8wYPj/a4iuXJ3GHFli6RMa
         JLYgUXL9Y0XOS/lBrKctQscjEOWmwinYF25L4qj6SmIT5R0hRezt99InY/YJ8MwycRzu
         xPbyv4XnJJ5/yNuBfpCufO32ThsZMiA8RmyJkYoUXr+QnpMaISubf1oK+5hqmQoTCu6a
         gj0KaIcomNDgc9TqixtHaj07SDpn0wJt+10PWOc+FlygZ6FOYIY8X/nmwzCoRZIk5szn
         eg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777432679; x=1778037479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RBNUm3EqKRX7L2G+NxGyN6o8RA1OnwacSv7d0wz3S5g=;
        b=fJZ4k+vblLo5gguIxIP+zmJwlnZ78CJxyuQV6aU11+TzdDxGmc/ImGBYXFvPTcrAZw
         wptCjOpSOOVLtwEUV04/i75m6YVFQLX9UbNlsWw4MQUkQ3LIYFZjUhE/dWUa4yUx/1Wi
         0Hwnv6/vxjwIXCAEyUgwm16eCztLQ1wQleDc0RCXnCqJn7sC+E6lXRIENX8EhDSWKEyA
         JyzCEACd7GZk3Dr8xPu5tjs3R9sAzyPQg/AARDAIjdt3iXdjVpCxaZIJWAw4M3aJsMGg
         heqP3CV6GqhXlIo9gft/WM8Rxglsl88VN/G6wS3IB0Rmi0E08euwksizvavvuXzuTTEt
         SYUw==
X-Forwarded-Encrypted: i=1; AFNElJ9beHft1m/58KB6pgs/K+UjJwvdLSFh8uL6PTkFk7OV0ReDUsXYVOQa3ijaIiwmZ6qJV7bG5gHP3Q==@kvack.org
X-Gm-Message-State: AOJu0YxHhoMt8v11A/FkYOEH2ZbpxHFexvZTX4D1bbHTf78zD6TAU/lK
	vlK/S4FSnPhj+OpaHhr6SJBURLpbbvPluOMK+XBvClqkk/dQTwJSctB1swsajAIUt6ZSAqzRGwZ
	KLGCCpRTTG90TmS6xSfxpLM4SuZxzj6U=
X-Gm-Gg: AeBDiesSHzbe6Rsk+IykXIKn/etk321dYc1585bRIeMRnndXgO+NVg/Uzk6Z3h7QV1W
	XDVRE5rziBm7YV4TGa34yz9DUYS8hP/x4HNcGZvpXjkdpINEVf+J8qAqqydfuhaM13RMeZ6hnM6
	1mWEJcEIFDSgBIZAPl4sQr9uNKnQPx2b9Zq8Www7F4FOtC1K/37U5jU6UBHu/MGVbDyibLS7Vz1
	cIZnAf1uScb4IkPFKLmloflgHcDFc5Spo0HmldRRGa32FZTYJ9damVW3OKCOmgoUgxb8ZwxT1Fn
	1od4r/SBe1PA41rzjTmexbHJE5GkyRhg2qHmTu2X8O1ykOc/Pg==
X-Received: by 2002:a05:6402:3596:b0:677:1d09:56d3 with SMTP id
 4fb4d7f45d1cf-67b20f1c7e3mr533781a12.5.1777432678612; Tue, 28 Apr 2026
 20:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org> <CAMgjq7D5M6ru4bP0EsNmyODnnAoPcpa4GSB79=Gs4EUabzsgXw@mail.gmail.com>
 <CAGsJ_4wsde+xZDBysLFBFHvkoJbM07b5tWS-rvXn9x9+m24s3g@mail.gmail.com>
In-Reply-To: <CAGsJ_4wsde+xZDBysLFBFHvkoJbM07b5tWS-rvXn9x9+m24s3g@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Apr 2026 11:17:22 +0800
X-Gm-Features: AVHnY4Ijwgap-tf42b1mugd6ohMFEX7Q0gipsCcOXiBJU3HHI6UqJOUVsyN_bDo
Message-ID: <CAMgjq7CryC_c1fv_-fSfqPXVvo0BO_23P9FkSnWikOtL_nF8=A@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6dpkbjyfbp8sgd9eogoa3qtjqzjwu5ny
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 831D380006
X-Rspam-User: 
X-HE-Tag: 1777432680-121396
X-HE-Meta: U2FsdGVkX1/wlYb8SnF/NhceDjm3/B/YcWHeowW6dsarawsq3yWAYFzZ21B/3KxcTajtAqC2MQtA7BmMOru5fnr/LZySvXtJ3H6BZcdRcTc+i/4Yii5ZwDmcAscqtIUQjULHyusqoJquRcZP1aELH4xAQyJSuC/UKns383rMVieqdhPJiMxMSlVPwi5ka15+BJ4en7bJ/ZeRnW5JQMPFtnGT9lLpysGbwDadHBHzlQB0CY01qBaSKkcEzvv/Cxdk7TiaoJcacsR8S8rywCE+SHGAo//TBZq/GhZz2Elbw3+2fm1s4psy4crplVEDR46IkpyP5nfZTt2qKFFEFsgCY7jFwcTymjRrGY53yG1Vu1cuHJRRaFGgiKPAGylTiEE30bau/M0gwLbRZN/ilNT1f1LzA4XP/o+7JLCmObAY0kY3gUjWoM1BMGWuiPOaJgJvO4+qWD5GHWs6XdxtP2wHuv4ANYv142906ODAHK/4Yxobq0UyZGJ+5hzw0joSdn1Fb+bMFyJtMloCS4meXIa6jZPQb6bkH3ZgApAqR8isHiZ9LUyacTrfAr0hdf0lGf+RkBxLU4snZmVpj2n4ywaK1btIluEpVM+94HJKWz1ONqWHDLlp9Dz3SXY9rXrA1uO0CxwKClv5r4UYSokEwkY3Uuu3bRQyZF0oyGxP26JRLH9DtsLWChK8wzHiLI/MKBc+LfF2fpN1xVca8JclUKjgmcTwUiIv3hnEDDUJMKnPs5UbTgwPoiF8eqZgYDYp2nv/vN0JAh9VjYLPkoDLCEWWz80QzRh0Y3FxCyHcqG9Ni333InbJD2HLgngAE1zbYtd5ybwdwVZ7eCQH2Wwuwu5NfmdreXgDy4xNjJG7W+F/frrQKbv+Qi/wL7oLTaom+f0I/HwG/RzdhNcCOQdL238EgOQGdY7rlXc/Zg+5Sx7jzAdFgF9PJigTaBtZqVOrZBkEJtFNk+C1aEtPbIVlHcx
 M4QpsMe4
 JTJUjsSVDbyQXx8d4hl1w58v/dxKfWaru44Os0niY6iH1OCiKrA9Bsj1czqUoTZ1iItTXKpMH/hXnSQ9AOOh9TXbNxrFgFfp+m6eL3ooIu9vc6nO2bLb0P6mJf4RQHjsYnaQ7OfsN6nZ/4u6drGCzVQKg2F3941WRjHFd+IXaPa0/icptH1CwleVZQwbru88xqeAkA8PiFUyPJ9BGh3ZmFDXN9MpW0egfAlcgekVU4kS1iZRbKurcvFmR6o1shbJ8AYAieN9C0stDu/EwYvA9lpj69mXdBAFGROZ313hszezwJuFqOFBHlxVVHDLmQFT7sE+Ks/QfO6bdQZSZXt8e8tlykGXGiF8tnxTffS78jnU4UxWcbDUBNA2T3NKek7P02uPAT+kMjoQpeWylJtN7Q5gJ9bhtjJ9p1cLY/B+7158LnWvlpoHEvI8EmfjJTUymCzWZWUU6O7m+k0wxq6bO1cnu4WlcNGZkWOfZG70gi1THnGuCPVAYkdUoP5a2wqOXec9MeaF3mKoGQoTKlIJBkO7NOnu591kFl3N0GRqHCWsiFs2GTd09k4ptj35XrB2IRrYFqDoDq4wnvmiSpyYt737vhW4INxsTPmHfMBmY+HHIcMs5FcNYwqnbreGHUnsbsabzhZBUI0nMTqdu/lIPFYjwfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 6:26=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Apr 29, 2026 at 2:55=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Sat, Apr 18, 2026 at 8:03=E2=80=AFPM Barry Song (Xiaomi) <baohua@ker=
nel.org> wrote:
> > >
> > > diff --git a/mm/swap.c b/mm/swap.c
> > > index 5cc44f0de987..e3cf703ccb89 100644
> > > --- a/mm/swap.c
> > > +++ b/mm/swap.c
> > > @@ -512,7 +512,7 @@ void folio_add_lru(struct folio *folio)
> > >         /* see the comment in lru_gen_folio_seq() */
> > >         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> > >             lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> > > -               folio_set_active(folio);
> > > +               folio_mark_accessed(folio);
> >
> > Hi Barry,
> >
> > Sorry I haven't checked everything yet, but just a naive idea: What if
> > we just remove this whole lru_gen_* check chunk here? Only keep the
>
> Do you mean the below?
>
> index 5cc44f0de987..499ad49c1b51 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -509,11 +509,6 @@ void folio_add_lru(struct folio *folio)
>                         folio_test_unevictable(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>
> -       /* see the comment in lru_gen_folio_seq() */
> -       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> -               folio_set_active(folio);
> -
>         folio_batch_add_and_move(folio, lru_add);
>  }
>  EXPORT_SYMBOL(folio_add_lru);
>
> If so, this essentially resembles the active/inactive LRU. But I
> assume Yu Zhao=E2=80=99s earlier point about mmaped folio access still
> has some merit? The problem, however, is that readahead and
> prefaulting may have made this assumption less accurate, since
> being mmaped doesn=E2=80=99t necessarily mean the user actually wants
> to access it.

Right, my question is that, foundunmentally, it depends on which
assumption is true:
- All allocated folios should be treated equally.
vs
- Page fault allocation folios are more important.

Some databases have the option to use mmap or read, in that case, it's
only two different methods for reading the data in that case.

Classical LRU also used to treat anon folios differently, until commit
ccc5dc67340c and the series following it changed this.

Still I'm not against the idea that page fault allocation is more
important, I'm just not sure about this. I think taking your approach
first then improving it further might be a good idea.

> I mean, I=E2=80=99m at least convinced the following might be correct:
>
> @@ -509,10 +511,14 @@ void folio_add_lru(struct folio *folio)
>                         folio_test_unevictable(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>
> -       /* see the comment in lru_gen_folio_seq() */
> -       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> -               folio_set_active(folio);
> +       /*
> +        * For architectures without old prefaulted PTEs, we need a first
> +        * PTE scan to clear the access flag set during prefault, and a s=
econd
> +        * scan to confirm the folio is active. For architectures with ol=
d
> +        * prefaulted PTEs, we can skip the scan that clears the access f=
lag.
> +        */
> +       if (arch_wants_old_prefaulted_pte())
> +               folio_mark_accessed(folio);
>
>         folio_batch_add_and_move(folio, lru_add);
>  }
>
> It could also be the case below to check whether fault_around is
> disabled, if it=E2=80=99s not too ugly :-)
>
> +       if (arch_wants_old_prefaulted_pte() || fault_around_bytes =3D=3D =
PAGE_SIZE)
> +               folio_mark_accessed(folio);

Seems an interesting idea!

> > Is there any evidence that folios that are allocated through fault are
> > always frequently used folios? Because classical LRU has the exact
> > opposite assumption on that. Refault distance based activation is more
> > battle tested (I'm not saying that is absolutely right though).
>
> I agree with this. I=E2=80=99m also queuing some code for testing
> to check whether reclamation has occurred very recently.
> If so, we set the folios active:
> https://lore.kernel.org/linux-mm/20260428013520.47417-1-baohua@kernel.org=
/
>
> So basically we=E2=80=99re on the same page, just taking slightly differe=
nt
> approaches to checking recency during refault?

That's a very nice idea too!

And actually I hesitated a lot between using refault distance / gen
distance. And didn't find a good reason to make a decision on that.

Using refault distance makes the result much more accurate, its page
granularity, and aging is a kind of random thing, each gen will have
vastly different lifetime, and could be very rough.

Using gen number makes things much cleaner, avoid the bucket in
workingset.c and might work better if we have periodical aging
support. Also avoid to deal with eviction root problem which will
somehow might also help to make the swap table more compact :)
https://lore.kernel.org/linux-mm/CAMgjq7Aq5ckraKtNtet8+1ANuqnitFsXxefbDJQZp=
BxNmaW7Cg@mail.gmail.com/

