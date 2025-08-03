Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F257C87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 12:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B011A6B0088; Sun,  3 Aug 2025 08:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8AD96B0089; Sun,  3 Aug 2025 08:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A0E6B008A; Sun,  3 Aug 2025 08:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EFEA6B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 08:44:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF83DC0B30
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 12:44:24 +0000 (UTC)
X-FDA: 83735414448.19.6FD7971
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B2B620004
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 12:44:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d5b9cg+p;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754225063; a=rsa-sha256;
	cv=none;
	b=MVg0gkjB2aN21gdW476BRFl/Ho1LAH9i2XVhfust+Amc/Ow3cyF6UiX1MXcujyJsIN1sSw
	DbP70aQjsKLm4+bb5RHiqVlZ216klEbvvCMSZExOfm4LHOE0a3ndQ7lJ/kqUT9JGOPoH4H
	FPxWTwLc7SVm9Jnk9YacheF1IRUf+U8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d5b9cg+p;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754225063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyXXliHYkRsANTFZ/BhTtFGJcz7TAeDhl3fkIu9ScTo=;
	b=5zSKYHOGzQBBMKXQo9E4YdOJySf59gKpTD2/lEmsWLG4ZW0Qiyh3O4ZvbeVignffoVjOdF
	WHW7RivsNGldekVGuy1yfpszFbRiZyCELIY5m9Wh3X0ea94oFO670dZbovbCtlM+d2d8Sf
	BSbZp3jbkNJf8cd0xW47L1djBUpPH3g=
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6199e7dea32so245486eaf.2
        for <linux-mm@kvack.org>; Sun, 03 Aug 2025 05:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754225062; x=1754829862; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyXXliHYkRsANTFZ/BhTtFGJcz7TAeDhl3fkIu9ScTo=;
        b=d5b9cg+pPqw01HY7eFjs1dShrxYcsdGj8Rj7IXpFlUdXtcNnRG1Gg06tJq+AUs4IMW
         8FgJd2HVxhPGZdknjQIv92qTL8Ve8dxpj3aeXks8CKLBYyeODIKHSp04zdH46ElhOE/w
         phvaUQJIqL1sD3YB0vfBZ4bLni0t1LjAbbBUOeKmgvzq8BjdlsHShBnVbRTXsQH0SBMA
         IXzNTbV4vd59rdE7lCNkFZ1DdPHdQOFvUBOz4Z/4JXsCzMwBcLOcdwnHkNG6uOy1yhf9
         2aziuAlV/KvQ1onmeQZWDL/cA6Nk6inP1rJjVh+s1tBV3kkP3OccIBI5TEaz94mgup6m
         jP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754225062; x=1754829862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GyXXliHYkRsANTFZ/BhTtFGJcz7TAeDhl3fkIu9ScTo=;
        b=waDb7YRikAbZx4LT22xONaORn9GMIOcr6hyfbE4O9qckaleo54YhoqxS4b0RIxIml5
         QapfVQ0HoDGgvTT19C2u4JOizzR4GU4xHF3suYgzt2sfZjYILwt9oU6b6ADt9ucyOtPL
         Pn/DdaspBKtncWc+rZB6dw1saYoRUYbMP5jIVe5XRDs10k4MCIJWfcHp0G2BLxMwI76I
         67X2RPWP9XyZVzxEdu80J6LKsRIrLst2Wi03JY/3UXiC41r0PiLfj1ONv35cW/vP6yom
         SX9LxXC2JFzMjpxiekYrDw/QoUWIl44NO9+bPRlFA1kzNYDhhw8O4blWqt2EKLP1JkNT
         E/hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVphv8xWX2xuHl9fcc68TPn5+u3i0KWHntEFXdUGaBhlDCSSDiv2tqzkEsP5Yv7tPQEHu5hNqvJJg==@kvack.org
X-Gm-Message-State: AOJu0YwXhKBVDK7nXJgsd8jFB84E25pkYHRWANWVz7p3H2S0frHC4/5g
	IXWYc63qZtlOMAHgjoqKVjXnotviEmXLoh7Ozd+BGG35on1nOdiiknxR2JPjC6lIG8vbNzv0vd1
	u1jnihek8JyVnF+GGCN+zyYXFDiqskSA=
X-Gm-Gg: ASbGncturlw5R+t4n8IS5pR9R6G9O0cnxns/bY0BqtT5vErO1FTA8nG4lTVVvBof2p2
	w63foqcBTCYLTEjZaAxW5mDWlY9MD2hapCaUxP+giHwoUOMI14iYWRV2w0HOLQ3wXdBnwhWs0uv
	L7dVgzsVi/IqLWuZ5gM+JeT6Ui4bO1qv6afWDK00lPD31CyJS3sRyYWpv34tk2fRSZwDXK+y5A+
	dPF
X-Google-Smtp-Source: AGHT+IFjKUOh+KeyE08rDNkVXHT8x/gmFVbAcXE87p3aPPCD4UC1L4QICQk/l9A/N3vMB3az3LC3RFYnYoAhZ5NtAX0=
X-Received: by 2002:a4a:edc5:0:b0:619:844f:2d0e with SMTP id
 006d021491bc7-6198f2a39c6mr2981579eaf.8.1754225062000; Sun, 03 Aug 2025
 05:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxMGh7-vDgNzepJKtrhdOF40_U7=NT6Jvm85qtdwGpBZawg@mail.gmail.com>
 <20250801170231.8532-1-sj@kernel.org>
In-Reply-To: <20250801170231.8532-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sun, 3 Aug 2025 21:44:10 +0900
X-Gm-Features: Ac12FXwNKGXN07u7GF6ggxSzpPebZHeA4eQy-Z85lrBCXYiqs3Nq__NxBhynJ7I
Message-ID: <CABFDxMGUO88-CkHa8E79TTkoEm_j5FX3ZBVjChXJ5w0eL3mNSA@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B2B620004
X-Stat-Signature: hekgaa7dufzfamqjcunyokcs8g73xaht
X-HE-Tag: 1754225062-951222
X-HE-Meta: U2FsdGVkX19/zBOFJ4dOChThtQuIBUFzHjhgJ0cWjbEx5QyinAl2YrwCJFilKkW8Xh7WznB0oGw16LYhbRW+Qgj4ZVbWogunjKmoTD6HPNKFdbUG3ebMfA+7axGzSasD97rWH0ZcAKq1dfeaTNuyaARH+5QrJhR5PwgwoTIccKXM7W8uOY3kJS2FnYl/WBVK0aNiquHpmFRqo/lqsEgJ5QnfySnfCs8zAri522s16CFBEwjnYr+gQ3OOQG+4KnSJUAwyczZzXCDbVtboNfiRPH1FQ5QP221UGWEI0UqhV9ODZY4urIGZeSYGutnrs3hSWrsxUsCfcv4X6dxVS4uXyjhH2OlWKn3+DaQIXC1G4Y1ZEzHMGn9oKbFp3zP4idp3MkSAyCJqQZbanRzFbSeWYg8ifQGTrsUKGwafb2ffDBzmDx4dQC7SYZiVpV7AuemVszaeJ+9JukXNLTJMC1HScdOAghSu8bb69vgAd2GVL1obMCGB9DQXHP5zn/22mjMZ2EH19R9UVA/MAa+XYGcZdP4ZEq4jqh0paYbJqEQMaorA0T1pzdeY3DDvD0kj/K3loiljw5ca+fY25vr/6iCmBRTAUA+AQG1QMvjgOCH0/3swW7qVJ3wGtwqxXoCneGNGu0iuqoqBU8l65EAjSatUreR4D03E8u0cq+9z6osLvtYfPEIUHTy9L9q8L59uFmmXE0HdC6YoZHh5TvbJE07hB20l74rDMvNtmeWozciR+K7AA4Ze0+0tekieBLd+YeLH4/MlVbpwlp7kYLN6xFQDC1j72b1nii3BvxtAFXWU09bAS8x/F2JT6p3fkvmKE1AOmCiuKF6Us3out2J0/1i3MtHPv43yq5fmozt9bUJ30L9wf7YsWV8S780M3dq9ZyI2nxsCtU1W2UUNKk3t0kjSy0Ui8MbOh+iR0UOEa+WIGSgCpT3C9/qTiQiUz+FR0tDTuhxdHKCWdOLXSUQrSph
 BzEGNiMg
 Nzxh3v66Yg7+PbeNiZASYlS4MHE1kk0LJffYg8yCAOQTGX/J5b5u35BKkM4cig0vJ1QUh3vz7fPbqbgH+eM7OAimSO5pQcFXTzWc+vgBHmrJUOm65x8J0eZ3Aq0M+1sRJKuVhwbbe02JI2Ht8NJgora6npra4xuc6jk8sS0h+3Gh2WUWbfqJ0GIQtK+pVkOKAMJYNVGJxzfT1lNxQbOL97RzEbxqTGy7NPhhJrYPmRKZ0O6ceSkc7Rwdpl9ApTu7HK9aXngatNpU3K8HfWcArQ+ruO2izwnoR7M+N5CMS+ncWETBewvy0D9YgMX+ym+Mw58d+q95/PinKDKxDSD3KXLKS5fWCIPlKo3FCmZ9PUgLYGz16GZHTbB+p/BaT2zQt17wc7qfDOshnQMkorL4kcsSje9p24e5UEYc4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 2, 2025 at 2:02=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:
>
> On Sat, 2 Aug 2025 00:34:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> =
wrote:
>
> > Hi, SeongJae
> >
> > On Fri, Aug 1, 2025 at 2:58=E2=80=AFAM SeongJae Park <sj@kernel.org> wr=
ote:
> > >
> > > Hello Sang-Heon,
> > >
> > > On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.=
com> wrote:
> > >
> > > > Nowadays, damos operation actions support more various operation se=
t.
> > > > But comments(also, generated documentation) doesn't updated.
> > > > So, fix the comments with current support status.
> > >
> > > Thank you for catching this and fixing!
> >
> > :)
> >
> > > >
> > > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > > > ---
> > > > I also found below patch(https://lore.kernel.org/damon/202507302002=
39.60984-1-sj@kernel.org/T/#t)
> > > > So, Is it means that DAMOS_STAT is only supported by paddr now?
> > >
> > > No.  'vaddr' supports DAMOS_STAT.  The patch is not adding DAMOS_STAT=
 support
> > > on vaddr, but extending the support for DAMOS filters.
> > >
> > > Thank you for checking the thread and asking this question, though.  =
I see this
> > > as an important signal of another rooms to improve on the documentati=
on.
> >
> > Thanks for your kind review. I really don't want to bother you
> > anymore. But I would like to check my understanding.
>
> No worry, questions about DAMON never bother me.
>
> >
> > So the basic operation of stat is covered by outside of
> > `damon_pa_apply_scheme` and `damon_va_apply_scheme`.
> > If it's not too much trouble, could you point me to where they are?
>
> It is covered by damos_update_stat() in core.c file.

Oh, I see, Now I can understand the flow more deeply :)

> >
> > And some extension stat (maybe it only renewed that filter exists) is
> > covered inside of upper functions. Is it also right point?
>
> Depending on what you mean with "upper functions".
>
> damos_apply_scheme() in DAMON core layer calls
> damon_operationss->apply_scheme() callback of the current operations set.=
  The
> callback may handle DAMOS filters or not.  The callback of paddr.c handle=
s the
> filters for DAMOS_STAT.  The callback of vaddr.c does not, and Pan is ext=
ending
> it to handle filters.

Oh, I see. Thanks to your help, Now i figure out the flow from
sysfs(or directly set) to damon_select_ops().

> [...]
> > So, I think that I need to send v2 patch, If that's right, which way
> > would you prefer?
> > reply to this thread or make a new thread?
>
> I prefer making a new thread :)
>

When the discussion of "reclaim" finishes, I'll make v2 patch as soon
as possible.

> Thanks,
> SJ
>
> [...]

Thanks for your kindness.

Best Regards.
Sang-Heon Jeon

