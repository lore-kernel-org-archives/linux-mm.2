Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DB5C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 15:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80836B0285; Tue, 18 Aug 2026 11:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E574B6B0297; Tue, 18 Aug 2026 11:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D466B6B02E0; Tue, 18 Aug 2026 11:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A693B6B0285
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:08:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FDE6A01A7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:08:09 +0000 (UTC)
X-FDA: 85114720698.11.5364DE0
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 44DAA100008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:08:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ATxpMKT1;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787065687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6U06V7bL4NIbJJ2+eurFAOdNZrQt2Iw+tEfDSrAYLO8=;
	b=XW7+kQhCh4kn22h29hs7iNIioTzHp5Ak9n8qmb83QWrHzLnE0N3aT7aUmnJuDo517mdECK
	nTJGdOUEV37v0wCQU4AS1nI7zoZSjJ+UcX81XVy2KV9HGihJI7UzZN61/tJA6ACpknKZg8
	zXZY8+O7/UwXIOZdRNMmQ3owVxL2yKA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787065687;
	b=R/gYTLsdWtBmi1xwYYTyvWK/bxlzSjz7tujeWlJPfIb27V/k6w2dpUvvTGe6lRuzHy945L
	uqvGhodxa05ZVjPD+KfR1pFXTZiRFdrCvQgcPnOmfaLeOjUDW6glJaskG/r8qw+Hfqv954
	n4US3Hkaz/ZSZTmCk61GVezLuQ4Ncac=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ATxpMKT1;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10ed63c0so235771cf.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:08:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787065686; cv=none;
        d=google.com; s=arc-20260327;
        b=VFNhkImkJxxoNgE362U/77QAtyLTZ4xhoLYpSnZ0/W54if1aXUoppQG7AonywG/CRK
         YrZK9hzMOr5oRQdu8p1FYBd468IZalZq0gYxi2VbmqJxUu+MC2D3URZZhtQ7MD0Jsdrh
         UVue6aon4/Y29CD+HpmhJWu0gxaqZDk5tkSdHiVX2XVlHf5Snlpo7nkogPt95ioNohEy
         aYxB1S5i0/bdOeEyGqDKTOzRWZRsI5pFesiVTCNBHti+DBI9srHPNNOsUT+lrQxqhX8e
         2ZmEES2AZVRph2KepWclNZrfGIFFTOgv+v5RY4EDNACFCna0oTtPRp74mc+UNwx5Rjo+
         HKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6U06V7bL4NIbJJ2+eurFAOdNZrQt2Iw+tEfDSrAYLO8=;
        fh=G0gbG+8ofiv/9jJn3ek8CMLy357JXWP3sLO3iO+zeOA=;
        b=PhGstk/XWFB/ESh0X3kiFvgy19EQLciSszhmqn/HciiDrwu35SYO3fTG/UCiARKJjx
         n1ZPURfLJ++uFa7WgqYrUvgeeELlqqd/BzhjsY1sGLrqE1h/mmJ3BNPr2o+cmMWSEQ6u
         9yh6JcZxpB/WSQadKb+56soRPNCGtQxTb9670btSunVFIbgDZh15/eZVJCqpvy3aLpX9
         5FxXWv4VRDyqZI80mF2C8Ln4MaAjjsQNO0+tQpuQaMSXV1A0D0u0UtvYaN2/pjRIpz0Q
         R5B4ZOEXtwrho3/JPs4JMOmF1ys3e+6YmK4T0+x6a6r0KiwpxPaX7LeiRWLQym+4pDxJ
         6vcQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787065686; x=1787670486; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6U06V7bL4NIbJJ2+eurFAOdNZrQt2Iw+tEfDSrAYLO8=;
        b=ATxpMKT1yz0r2RSXTa6w5FUpl6W6r76iPCWyErne6YuvAA9c93XX/DrefthzVaxpuI
         w5XOe+1K9QC37/pBJ8S4BKfB322wguIfu3Ak1wPbvM9qQyrbov/4kMAqKZiEmgmWts22
         Hf65R97ibtAUwpWauy3sw8v+D8mn+X4vsZ/lSLQ8mZTjvwGGyQyRcyUBKEDtqBNaqq8J
         gfYY5wgAFiX0vBZAf+rzesrD2y5JSE1O4SEgdexVFBjyPeMOer3T/1mO0ljstZryLoXT
         x84FLpR+r9W0xV0lNqYPkJQ2kbZCULQo1+2CLHvX1FFnRC+wg8Aa511i82iHkGGkwII2
         55xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787065686; x=1787670486;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6U06V7bL4NIbJJ2+eurFAOdNZrQt2Iw+tEfDSrAYLO8=;
        b=eK2PlXaDraripqRgopVAgdGtmMC5RWePckvIcA5JJgAbowUJcLQI2KU/tNNjsAgHZA
         4H9Y8SThQJw+PW1b+V4wx6H0DVM2LM0k3bnuYRernkg+0LMiIxUtGINtIAgvnUdKfp7+
         RG1Qf4abT4Ub2Ltl8iNFZ5O63oaJLcZjxt/Mmz/HVooJv7xWYZzrSeFDB16WYf05PI2o
         AWzZUIOlbBxDob5sgKz1C64XBzEY29CIXKpRq0QOouRXheH0hpHaQq1GF/TSPI0rvPFv
         TVFxIAyL3SDed3UCvuiGS5OpmhaXfqi60/kjOcdmEuEUmhTMrmJuN+rO381tqftfYsNi
         sBIQ==
X-Forwarded-Encrypted: i=1; AHgh+RrpEkuSvtzI9mO7nYsWxuo/bHIlilzgwpJwSu8IgOsiJxbm65DcPT7oYRqUyA5vsYO1tWEMg09srg==@kvack.org
X-Gm-Message-State: AOJu0YxDNxxm1wBP9pyJS4Y6pVCbkakiWWbLkw9VaFp4Ee0IHvLIduXz
	XN0VHJNik7LXBHpqDnrWr4+odqU8E00u3YkMWRpDTs7CNcr66SG3q6/yfz0tSLex/zN0XXao6jd
	W5HS3g3Zi9yRwYGI4wF4iPh88ZyH8rDjWnEy6R1Wa
X-Gm-Gg: AR+sD10BSklE8ABi2GKkjihM9M5nWYph9pTMkt7Cfaz48o7ok4ozgW8JyponmBIftqq
	HpAGBqlmsK2JtkIga+MaPtWkoMzMP/EDMoOb1pHjwc7dZ4p1KJrByhFBIYn2X+snWnslk4tUmbU
	ysEqV+pu9EJQu3JEgdiHOGYmZWoxaT9U+xW4vxYDP8mdGjSEIZnz4l/W02icF32GLFerrxkJptU
	i2WEPmcEB3H6FQHiym5p2W++6ib8ABFmQO8FPEAFtpc2qGbf+pLpppGa9K98QGRYdsb1xE3B28d
	QpRwTWYfZ2ReMNbMLA4qFk3DNySDY9RTMGw7NlnSX3aIvnTy9ysWM4GTbJRatPq3ujio8SKyUcw
	=
X-Received: by 2002:a05:622a:608:b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-52dc47e5e07mr13386731cf.3.1787065685473; Tue, 18 Aug 2026
 08:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com>
 <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org> <ae1cdc48-4293-8b81-d142-3c656f2c2cfa@gmail.com>
In-Reply-To: <ae1cdc48-4293-8b81-d142-3c656f2c2cfa@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 18 Aug 2026 08:07:54 -0700
X-Gm-Features: AcwNN1WoLCd4yOrKxPS_iWcWo5deHdoeqZvT_8QBA38GwRSCvYL9Rly1dCIYaXM
Message-ID: <CAJuCfpEOF3=Uu3cvoiH0tJoJhhRmwR0YLy34tyPC-2EE09xWMg@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes succeeded
To: Foxie Flakey <foxieflakey@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org, peterx@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 9tj3a8ngqbq1snjii7dqoowthsyin919
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44DAA100008
X-HE-Tag: 1787065687-326044
X-HE-Meta: U2FsdGVkX19ceO6tGabR+1XrdTWbOFQZc6IAr0HNdvCdVa482gzKGThQKxYfbE0rjGy/xuS6c8gkp2R8UbsknykEnqHoxc3Ti9PrFVVHXy5kJgK0AihmsCvXvtP8op7LduGq4Kl2v6CxbykM1PQtSlHBUH6Cx8WAEQHyHjgzg4EPR2sUqiqPnoc/DKgCyzIEE1uE57ekItBftHOCHZ6dn64biXZMpQmeUy9u/aABT1VYd5sqJz3dtGc4ohncj0HbUk9NqBwu60blMsCiXaZ4whSPGd+PLMwgeVm2msAlLFcvlmrwUn3kjDj+r082pJ8P7k0jmbB0mLJZRtU39jReN8TxReBzl+XCh/lOosYGcsUH0+CEJb9xOL+A79OWmqEy7MlLc5HPnT3NrF1Hod6BK+6z8SE4HPV1oLxCRLTADKukNf6XegcwWC0na4FKuvfmjOra7VcHCNa8IHoarhhm0Z+EX7GxHD2BhcCFFhMMrJ2jmybjbt/8H4eF8lq5dexjVdZMc3Eguo2g6CiEZexRkHMwMZTGkWm3ykyidVQQVjthU1QcNaErpwTC5Int14BTjojtgixbiZ3l9teolVPqsxV0hXjfsCjhPZL9OsGzdUwx6Cv3fLecTmqVPkVz6WqAi5/ehFWu9sLtp1DjSChpZk78AG1QNxJEdcBZ4vUryPaB6kkVt5SO+/8eT2BX0b/cdUhHAY/EmSJZGbBk4CzRtzx8pj/KHnfCUTSuk8T7r5CesGyVSO4w1H7nFu4UBvIuQTIiR1oC2b+ING3Df2dB6K6NODjxy8FKDsD4v7xxNLx07oXnaQbL60/4er7GKEeDjg7AWYMeIYadX0HtLC6cpVeTKM3QWZdTGuzvaOxGdLOw1TPIrx+gToeEYuacJzDs7zhCO2K1QHKYgIr0uhah27mqCUi6a+VTNDRznYjOqV58iB2/BwryDrtaAHZXiXH4rwbdBcegwJyaafw9Rk5
 HMCJYP6X
 Sg5iWYzbM/8AxUHC7Hb+Xrt6bCzFR9vT9VFL8mlWtArOTUgtl3AL8jhgfXYa2Vx5N4p7FM8cXfrGxcl1FHQ6PexgCnB1ymeoo5Js5qZQ0YXL8cb1s6tjeqZzFnNN30nxy3vjuy/JN3JWxVH4ubI948EhPOn1E/6VoDah+KE5LRd68W9hvfR2zkgDtYHhfKA6m0Or4my1vj2rwSSzM/kEpltxoI3tbV/bgSsXPDuVlRSwU5/1pNWbuY6CCOsrGQPw27xLB+Q2A1yjT37dVK7C2da3r0R31tnfwRvcE9qAeRHloWtIoR01xaPwcFSAPcBAMRCiM4rGRTKUo0q8VjYwUMfpOEo0aN0OI9hoyBCTiG4apZc+ytUFdzarVkXwUlstZvczntlEEVMxTt61JL9eAPGYJmDLKLrVVJtDj33Yg61uEwps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 6:13=E2=80=AFPM Foxie Flakey <foxieflakey@gmail.com=
> wrote:
>
> Hi, Andrew.
>
> On Mon, 17 Aug 2026, Andrew Morton wrote:
>
> > On Sat, 15 Aug 2026 17:42:12 +0700 (WIB) Foxie Flakey <foxieflakey@gmai=
l.com> wrote:
> >
> > >
> > > An fix for edge case can occur if move_pages_ptes return -EAGAIN, lat=
er
> > > when checked and it is EAGAIN, outer loop would retry again on same p=
age
> > > and succeeded but the err isn't reset so the outer loop would think n=
eed
> > > to retry again so it goes back again and move pages again. On third a=
ttempt
> > > move_pages_ptes will fail because it already moved and returns an err=
or
> > > that is not EAGAIN when outer loop checks again it sees non EAGAIN so=
 it
> > > dont retry and break out of loop. When loop is terminated it did not =
update
> > > the "moved" variable from successful 2nd iteration.
> > >
> > > That behaviour manifested into this at userspace
> > >
> > > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> > >                           ^     ^
> > >                           \     Kernel moved this far in actuality
> > >                            What is reported to userspace on struct
> > >                            uffdio_move's move field
> > >
> > > When the previous behaviour is
> > > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> > >                                 ^
> > >                                 Reported to user space via uffdio_mov=
e's
> > >                                 move field
> >
> > Thanks.
> >
> > The text is a bit hard to follow.  I asked Gemini to redo it and
> > perhaps you prefer that?  https://share.gemini.google/cOWn3pQadvVw
>
> Yes, thanks. I have already make cleaner text from feedback on other bran=
ch
> of mails with Suren.
>
> > > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching f=
or present pages in MOVE")
> > > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
> >
> > Yes, the pseudonym is problematic - it is contrary to our written
> > rules.  But I'm a sucker for fixes, sigh.  Perhaps if someone else were
> > to send me your patch with their signoff also, the rules would be less
> > offended.
>
> I see, I'll post the updated patch and work on signoff issue later (there
> has been updates, I haven't posted v2 which updates the patch and
> description following a feedback. Why I didn't? mainly I'm not sure with
> answer for signoff)

Yeah, please follow Mike's advise.

>
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -2069,10 +2069,12 @@ static ssize_t move_pages(struct userfaultfd_=
ctx *ctx, unsigned long dst_start,
> > >                     ret =3D move_pages_ptes(mm, dst_pmd, src_pmd,
> > >                                           dst_vma, src_vma, dst_addr,
> > >                                           src_addr, src_end - src_add=
r, mode);
> > > -                   if (ret < 0)
> > > +                   if (ret < 0) {
> > >                             err =3D ret;
> > > -                   else
> > > +                   } else {
> > > +                           err =3D 0;
> > >                             step_size =3D ret;
> > > +                   }
> > >             }
> > >
> > >             cond_resched();
> >
> > Maintainers, when reviewing this please let me know whether you think
> > it should be backported.
> >
> > Sashiko did what it usually does when we make it look at uffd:
> >       https://sashiko.dev/#/patchset/9c936a9f-ed27-e510-872f-5b3b8c6809=
75@gmail.com
> >
>

