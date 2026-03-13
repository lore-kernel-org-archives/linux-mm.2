Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4260106FD61
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 01:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E456B0088; Thu, 12 Mar 2026 21:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDBC56B0089; Thu, 12 Mar 2026 21:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3D06B008A; Thu, 12 Mar 2026 21:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0036B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:01:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A4C71C835
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:01:00 +0000 (UTC)
X-FDA: 84539235480.05.A43B3FE
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id F157A1A0016
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 01:00:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ElCI8wDT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773363658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmWX6afwcKK+qAwiN0L3nTeMMcjlmmTvmcIb6kXEjoU=;
	b=R90z/Eq4AYJI0mzNAglHwlEgQ9Z+7PhTFkJXk8fOYYv6ve2ulopwO/6irmglctbus0RGul
	byl5QyFR26IFQxFNdepVZEZHq5/Q9tUbqiXEAr7X2UkF+if5DqQFA5rlI/Jim11sLr/nU3
	ZgzyIZAWEvAZ4DHJnQfSktEC7s7WI28=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773363658; a=rsa-sha256;
	cv=pass;
	b=X1d04BFfsqH8zZ8+UdVbfGILWESzHnaOXTNJEGh0agAcWv5FzMqGq1v/7DeVX8tQMBV4nX
	Wed+NXUcytbCDsAT9o4EDwPx6G4b4dRSXk3qqJJAlnKzFGAcVKrcKh4QNNr7kCcBgD5GJ8
	0+nrTf0V1MWJ7I/oEW+uVhxbmYoZ7I4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ElCI8wDT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6634d819492so3149813a12.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:00:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773363656; cv=none;
        d=google.com; s=arc-20240605;
        b=NsbZM/OFSOYCBOMl2xVSBfgN7sjkJQgyBH8avzFQEMkhQDOcB6KDyocUs0obLBJZEG
         UMMcwkzVqMwk6UJFuT/kKC2hhWS3R/7JtFFykX5OPKoWpJpP2DXRPh20X/9+GmaJWi+Q
         EfyInATEUBTwlEiP1Hah6BzNRqq0OiaMj5UUWck8KC81eYk2Dn92fGNRQyUPXRX1TcxB
         0lRh6dsIXzC6AoTj+DwGsqaUdbv5xEnegJc5Gk2lcQYuKxfjmCdJ6G0Zvfhd6tg8uwsX
         mQB+Gqkz3093Eoboz43q2ER/BwDJ6/qJSnYn56TKgeszOpycIYlolv0pvoHshaiMKGTS
         CQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rmWX6afwcKK+qAwiN0L3nTeMMcjlmmTvmcIb6kXEjoU=;
        fh=YhXT0VJyWqJ1YQ5Yy5K64o8T3By5lwls+Ng6wqdwcpQ=;
        b=fIHdt3e+EnGN8S3BfynKVEsxZdr6SGg39jGJgMs1kmbzksrZS4zN73WaSk75EwXXbl
         JMDDS0aEQ56KAJH5pBrHdhWVjYr/kM4gAkhVPcmUK3+v8xOqDws5kFd1OUwJXDSXwWWr
         b9b2yLwGtP8NU9oiTEvxpk0UjM4DVamD8pK8DcMktkxYBZOdzoiVMo0RMmTbfureFqbg
         KJdw9wWEzQPlwPg77oZTYSrelQZCKZuQ5gyA3pqyxwmNpeoERa6i4PEvFMGetAjKnHqz
         QxjnV/hlcwRB/krk9jtV57o/ju2bXZu7z239ZSPnk2Si7aaDz4itjUXWIugCQg2YcRwk
         9g0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773363656; x=1773968456; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmWX6afwcKK+qAwiN0L3nTeMMcjlmmTvmcIb6kXEjoU=;
        b=ElCI8wDTZ9L0v2QVmYs8etB5/7OoWDnkKwLHNj08PhQr/4pGZaKjBcSlUqW0mjYfFF
         ujjrnk97CXIlv3r+hQdioj6IkFb1V0nfrkC7kErccyG0vpncA/+4+SxyyBYQlAqZEHBA
         ajuq6dMTGBoddanEN66cQ7Dnh7C4tTbcfUiPx/bRiEWLf3dSMY8mJHOSd/ibu66OoK5L
         So+UIs/fGWrI0/m0/WWVhnJWjk9m++sZja/N2hFQXgLD604as0RuJPRjwDSU1VRx58sR
         InNezJ388LUaJw5ThZJQl7a4rqnGyPZgNhF7+4jKW/CodbBFIzGxpGYodn3yh3HRH1Fg
         27NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773363656; x=1773968456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rmWX6afwcKK+qAwiN0L3nTeMMcjlmmTvmcIb6kXEjoU=;
        b=L4pnFim20eUeHi5Ro4xbX1msOjDQRB8Y5D1yUp4JuWiIIxK6pBHfFkUYQ+8UoqHDGE
         QvD87E57TY57x1HEpJZOeFfa/jnCZmUUJBbjyizgblxh69oW77EkRn70VotAmwq1u+wH
         TzrcyJJ0UPgacG52aj2MeJrc2K/zaAcAYx40z8T2daKGvqnTggeANZkV2ga2OpTinLov
         +GBeCU3S3UP4kjMXZN7JX64a3BjnlkCtjT978VG2jjH9s3c87gOS0zR9zWoBnoKjiIu/
         /BVWHsMLJ2jtSO/LceYITsV/JwISI0TvLdHgwjgBdCLwFc5UwdH06mjXzqpsrVDw++Dk
         u11A==
X-Forwarded-Encrypted: i=1; AJvYcCUVsMvHIVkF2pSGBwdR/0CnMgOp8VxAmUuwl68h/ngJgKe2Frfq7p94Y4Vl6tt18lMESBHJWPcMtw==@kvack.org
X-Gm-Message-State: AOJu0Yzvy0+868DZZQEcKhVhmDSOZT4mKcV3fBd7ya1cC6qgC0AlqjJW
	sJOJMB328Yr7NtuAN6SHZ2GZ/QB7VNEa+D6S8hF9irby6Vdb+6nQLI0l9iFeEGlVlbvgL6IVys4
	ebLhSiAMNfbCAiUFFfVJztWK4tvJl4LBBNOe3WsObrQ==
X-Gm-Gg: ATEYQzxlklp8QZ9JjFJr5ld9WuOnRf9jSyNW/sWa54DqbvV41qDALJzYDYSHW71OIgF
	2vJGasmAuECz1tTrPmhoVL7+SjLPuKPtDdJzS3BB7njeQcTpJCBv/tySs8cKTsa3B18GhJE7pb7
	rdHMOQo4fvPnKy1BjIqQnHC7WJMKQLBV9LeX53sdjecM3ic3mV5z8KPRqYjj2I24O4ioSMODtTO
	0V5qh4ko9qyXqGKIwcPv5VBg+fTCdGmyCsM40Own4rEIBGHiWAx8v48RI5Fx+wI+Q6Q3URQh5DO
	o+fZ4oBlv5JMoXyt9JaCf4LjKlcGGipwLwSUeRwhz8M8kgVf
X-Received: by 2002:a05:6402:1d49:b0:663:4560:aa8d with SMTP id
 4fb4d7f45d1cf-663bac0b2a9mr787697a12.26.1773363656161; Thu, 12 Mar 2026
 18:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
 <20251218155752.3045808-5-pasha.tatashin@soleen.com> <CALzav=cJmgG04+Ba82Rnr3iKpU0gKD5WD3oF-_43rdD7T+REEQ@mail.gmail.com>
In-Reply-To: <CALzav=cJmgG04+Ba82Rnr3iKpU0gKD5WD3oF-_43rdD7T+REEQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 12 Mar 2026 21:00:19 -0400
X-Gm-Features: AaiRm51GTpcl9Y1xewqBoObbD5fxW5xRQjRFOFdPyL_QXAS4XNVVlbgb9vcN1yw
Message-ID: <CA+CK2bDwNjiCbLXzBuh7Q89NFi59NHsQjwwBy8iRdyJ-5cMyrw@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] liveupdate: luo_flb: Introduce File-Lifecycle-Bound
 global state
To: David Matlack <dmatlack@google.com>
Cc: pratyush@kernel.org, rppt@kernel.org, skhawaja@google.com, 
	rientjes@google.com, corbet@lwn.net, akpm@linux-foundation.org, 
	kees@kernel.org, davidgow@google.com, pmladek@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nicolas.frattaroli@collabora.com, linux-doc@vger.kernel.org, tamird@gmail.com, 
	raemoar63@gmail.com, graf@amazon.com, Bjorn Helgaas <bhelgaas@google.com>, 
	Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: aq7bdxznqxspiajg7mtc5c4acn9fse5j
X-Rspamd-Queue-Id: F157A1A0016
X-Rspamd-Server: rspam03
X-HE-Tag: 1773363657-453805
X-HE-Meta: U2FsdGVkX19mmxgaFZ9J9NZHNY13QCuFSP12aWyH1pgUvq21/+obLfq6on1BYXe2DNWjQqUFX6txpTv1XYsJy/WkeOMKjewXWQZrdpLqP/zOfqhy3KUbaFZsd4WaWKWZWLWLWbO9BukgDlN9ggpZaAiN+nGerFv4JVZi/W805kVyuX2YQx7Cb8EdgTKV286VCZVByk/X52csDdsLw+s2bkS04+09iC7zExpd+hIFVCObmmCskHq+aQ+OY7M2+oYPfaW1E1sB+QGeF7pwaPT/S+nsRF/1qygYDYFqa8b3LJj/NtpGdKgWZh2lpfxF00pbPSFrR4jgwCy4WkNCvzqBPzwZMPWWTfk1G9BWnB6JABlR9siRFCESLu4UCokjM/xQ/5Z8NviPN6cCUq9fxLHHap3DcNWKcxNQltpcJK7PndaKQRj/oCXPBzLsCDlS+bKwGdZSN+ZyIGuM8mul5cVWZTFwHFe1ad9JY9RoT1prrVOeRM85n1x+eg3tH1VscSp+s5DMxRBknfTGfB09WPc2KvkiDvLj3Uf+6pEkUdt29W9/VSJPJo9SnXLpEn7HFwSqtsjouubzTzijOE5j5d5P2PMAH7pahXzXRT0aB9Hzhsj8wIoYW3FM1TT6+RyaYWpJtUVStoINIKEIxF81neBz+iGoOdLG7fh2xs0w115oKlobVFX6kq1s19Qo4Gk+pOuqolUpVby8cPeOhnP7qDRUSJv0WfYg8Xe3tBZ9c6YvyeiuMkkSseISfQEwk9h5stLX4xaYCf5co3DjHJxCwMMHsYNqQxq3HUwAhubrfsYwR1/ByMCc5xW3gBVsAoRzfUrv40Tsa7o6EaP9jWtodOpe+Lqlze3Ewin/O3cFWkL1I0HBWGMgVr5WAM+E9sbBcXd+1JzApE0v8qhbU4CqU93Xge8qyorO4aN8jd9V9xIdLCW4Q3BuII89SPnjRJd3wZgtoMvk5OYgkx/g3FAvYgh
 lZCWVx4x
 v75VxkeTDcKTP/VXjfAuAkhM13Z/U/45S8kpbSsKZgzrIPlSZANC2bIUgNzzG7ZSQg4hs97SpdW9wKNopLAcFzWPbe7wpOioqumbUjtCmvAc6c+qDRNmyiBK2jJpRv+HFk4a9vzOWCLABIvfWLiU7i6eaasjIMAPm8AHcPg60HIXoWX6UuHhLzRfPdfSP5kHB17aI/46GqnRwFYEW9fFUM29nzm0uhV7dj4IlbAA1boBqfyuGKICyVEReh6PAY7sjvRywzFXZHBBSDD68+SZyErwcfX9gf4vJuQTKwhizP3kluXKTmHkz3fKHTHW73NoRefxUw7V2f2kB7NhWOwTj299JFkGXIma7g77SXppyrlrPeeJe52OaB6cpalj5K8diI/sw2VU7A9xAIkgVrgn37jWAI8Gm4rSvFMY1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 7:59=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Thu, Dec 18, 2025 at 7:58=E2=80=AFAM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>
> > +static inline int liveupdate_register_flb(struct liveupdate_file_handl=
er *fh,
> > +                                         struct liveupdate_flb *flb)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
>
> I think LUO could use a cleanup to return 0 in all the register
> functions when Live Update is not enabled via CONFIG or parameter.
>
> I think all of the users of these functions are going to want to
> ignore -EOPNOTSUPP. memfd already does.

I would think EOPNOTSUPP is a standard return error when a feature is
not enabled. What if a component would need to do something different
by knowing that FLB is disabled and therefore perhaps it would also
skip some of LU related changes? I think it is a very minor think to
ignore EOPNOTSUPP when checking of other error types.

> > +static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
> > +{
> > +       struct luo_flb_private *private =3D luo_flb_get_private(flb);
> > +       struct luo_flb_header *fh =3D &luo_flb_global.incoming;
> > +       struct liveupdate_flb_op_args args =3D {0};
> > +       bool found =3D false;
> > +       int err;
> > +
> > +       guard(mutex)(&private->incoming.lock);
> > +
> > +       if (private->incoming.finished)
> > +               return -ENODATA;
> > +
> > +       if (private->incoming.retrieved)
> > +               return 0;
> > +
> > +       if (!fh->active)
> > +               return -ENODATA;
> > +
> > +       for (int i =3D 0; i < fh->header_ser->count; i++) {
> > +               if (!strcmp(fh->ser[i].name, flb->compatible)) {
> > +                       private->incoming.data =3D fh->ser[i].data;
> > +                       private->incoming.count =3D fh->ser[i].count;
> > +                       found =3D true;
> > +                       break;
> > +               }
> > +       }
> > +
> > +       if (!found)
> > +               return -ENOENT;
>
> FLB users have no way to distinguish between "there was no data
> preserved" and "there was data preserved, but it was not a supported
> version".

Strictly speaking, FLB doesn't have a concept of "versions", it only
operates on compatible or incompatible data strings. If we find FLB
data but the compatible string doesn't match, we have no way of
knowing if that data was even intended for this specific handler.

> This is especially going to be important for PCI [1] since there's a
> big difference between "there were no devices preserved" and "there
> were devices preserved but the incoming kernel isn't compatible". The

If the incoming kernel does not find preserved device state, shouldn't
it just be treated as if no device state was preserved at all? In that
scenario, the subsystem would fall back to standard initialization and
simply reset the device state.

> former means there's nothing for the PCI subsystem to do wrt Live
> Update. The latter means we should probably panic the system.
>
> [1] https://lore.kernel.org/kvm/20260129212510.967611-3-dmatlack@google.c=
om/
>
> > +/**
> > + * liveupdate_unregister_flb - Remove an FLB dependency from a file ha=
ndler.
> > + * @fh:   The file handler that is currently depending on the FLB.
> > + * @flb:  The File-Lifecycle-Bound object to remove.
> > + *
> > + * Removes the association between the specified file handler and the =
FLB
> > + * previously established by liveupdate_register_flb().
> > + *
> > + * This function manages the global lifecycle of the FLB. It decrement=
s the
> > + * FLB's usage count. If this was the last file handler referencing th=
is FLB,
> > + * the FLB is removed from the global registry and the reference to it=
s
> > + * owner module (acquired during registration) is released.
> > + *
> > + * Context: This function ensures the session is quiesced (no active F=
Ds
> > + *          being created) during the update. It is typically called f=
rom a
> > + *          subsystem's module exit function.
> > + * Return: 0 on success.
> > + *         -EOPNOTSUPP if live update is disabled.
> > + *         -EBUSY if the live update session is active and cannot be q=
uiesced.
> > + *         -ENOENT if the FLB was not found in the file handler's list=
.
> > + */
> > +int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> > +                             struct liveupdate_flb *flb)
>
> Alex Williamson and Jason Gunthrope both suggested this should return voi=
d.
>
>   https://lore.kernel.org/kvm/20260303210733.GG972761@nvidia.com/
>
> I suspect liveupdate_unregister_file_handler() should as well. I don't
> think there's anything callers can do if unregister fails.

Thank you for the heads-up; I replied in that thread. We can clean-up
some of the return erros, but I am not sure what to do about -EBUSY.

Pasha

