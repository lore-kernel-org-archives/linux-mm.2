Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4B9F531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29726B0088; Mon, 13 Apr 2026 14:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DAAB6B008A; Mon, 13 Apr 2026 14:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C93B6B0092; Mon, 13 Apr 2026 14:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77BC26B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:07:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAD8DC151F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:07:21 +0000 (UTC)
X-FDA: 84654314682.15.1CFF58F
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6070B160009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:07:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E6kAE1AD;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E6kAE1AD;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776103640; a=rsa-sha256;
	cv=pass;
	b=Tdt/a6zdEkr4AIh8ZthRuxtUMKglHQwYOL7OfTUADl3jjNU+yGcjAcG5FatUkjXCDj67MH
	yKX36naX/jxMhjV0+NSWASs21sLVcJVqwCCLgn5G7WSVEsQeca9zyVupBkZGaSMgDTMJJN
	RfYLQ2Xk2YXa8lVNacTLwY/hZXP0htI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776103640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0HVfEElE8T2sVeoLvHHdJl3de5adQ+rg6PPxuJ5QdI=;
	b=1o9MSBeHll7hmnGCN85wzx+0+H5vG6obvXcVspdx+u+DYHKC5pqoY4Nzh8vVmEP2r7EuZv
	WLqul+846D1hOELeQV8uCCfJ3nOOgCe/ia0Rbh+KsQDDY8jghEYqRs54Gby3LqW8gxTyRw
	/EB3hcY2nw4DemdCVm9TBLztpc5oGbU=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6719e2372a0so1469317a12.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:07:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776103638; cv=none;
        d=google.com; s=arc-20240605;
        b=UghVG7/CqViS3VbUnIiXCnv3Cfhw++LMjh/mgftynVgaxG/XfzZUTqXOh4ANqLzCce
         5Lk6YFbbSfxZJXuKBU9XUEy8AXnW1zkQ55e5T0vOVwmGAbPyl8VHPT5n2n1zfA0I7USY
         pIEsaIK03IVUuVQmFu5xzMeuqxwsHuBQIuhLLx9f3gO3r9DSVlU8zRPPUdKvTMyVR/Ui
         pRv8nzm6kqwEK9wkf30l+yFw7PwiwlxYW1hsO9pOftRKviWn1mHR64EnBu6KK8sIEoDJ
         1hjqE3EgJsEo6hb/u7ESMs1+CyMx1lFc3isUdGApopssQnTbSMeqO5h3Hu/XlK9bT+D0
         qbCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q0HVfEElE8T2sVeoLvHHdJl3de5adQ+rg6PPxuJ5QdI=;
        fh=umFgxacB8iYRVeGIbWfaomqPzKxwe28I8+9d2Xoyb+w=;
        b=hsVcStU0U05LUB5Lap/WaSbyRqADr3Zx/f9ZTuh+W/YNuTxfV9cTTbmSKR0LZvJU63
         fPTG7w9p+tuEfdNimy6Og7wp4iiFsNDaWom68K9+oR6wLGorb8aTBrdugI99SI1dyjGn
         lUm05NvwYDHb0K+VRnJJDIAL9qkp3vhcHh4r01bmWQsW1cv32P0vPio/p+facRgJ9JVA
         qHbbfEp9MhC5OeMyy9zUSPF31+bUzPicZKPa8xxFZJ8lSgId+hWpDNHkOHGcuSliC8KV
         HVfViYl3y9fiCtt4NfxfZPmhAwoC7NuVgf+gQEzkkYBjlHsBgE8sY2BeJM/jo2D4Hs5T
         0bKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776103638; x=1776708438; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0HVfEElE8T2sVeoLvHHdJl3de5adQ+rg6PPxuJ5QdI=;
        b=E6kAE1ADK8E8OKNPlw0KDV89YDp+DgYgQVQhtf+Cmj4LUqhaxID5GeFwZTjMA2r/ST
         84gjzTpQ6LXkTqQKKIW5oVmz3f3AK3VfhBgodnd3N2flqBcGV1VT8Y0HuteXzXIgv3B5
         7GC+NI/Ddm/kbnoRBko9l7fwU2l60sLHZ1dVAu2CQtnUGw3gnHkxsT/BIITLkA4ac0VA
         st2OdET1Po0lcWhiQ3yBGhFHlyq0P4t0/0FlB+IQNWzzHLQ3dTXnGTeql/tTJOlIDh3P
         BYeBtJTac2lnxig/0d6wPP4cG40toFvL/946i8ukukmsH3Vu/gk01F9XkRYYbTF3Z8jF
         LHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776103638; x=1776708438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q0HVfEElE8T2sVeoLvHHdJl3de5adQ+rg6PPxuJ5QdI=;
        b=j/X/s32W0fM23hDYNc9kg9X/NIxdwMkMqfErx6FgYoRYFRjLRKTXzDTfkPNNkKBVfh
         LRoY1I7Lra7D72FWEGkvmJZ3U/xe+3jfxLAuGJEowFvHwDg7/p1jby6QFu1fDP+iXyqe
         KHwI8tvcsYpSE/MjvDd2LN+vsMbJ192ZMtoPFd2o+/QnYaGzuHa1PGLkAfKUVMCy5d0L
         mOjrbusJwvluhGd6IJN4I485Aiar3vLs18rsZT61sWU8rPUeCis1LOXWUK5+fAs371Q+
         S5wKvrTJuED/fzN071ln9VVF+mOJOYPpmgwkyMMd+lT63nDN/L6bsgtvcIpyvVtYdVgx
         0T7Q==
X-Forwarded-Encrypted: i=1; AFNElJ9cw+ReCpN7hhmfIx7m4YHFfD0dRtpYUZGnkraAKOaWN3wFj+6h9o9JnSFUEyCeAPXpuhEvjDbPBg==@kvack.org
X-Gm-Message-State: AOJu0YzmKNMVOQTbyVegYNhPv1PBqw11AVeeFSdtqConauNAmGkoWTjt
	GdxapwQz2NWwDEeCaPyyo4V2PdikNy66F4UEG3DZZ3JYnhdaIbdWneZeppPpL7mb8eSMmF4Bo0d
	o1ITJgEcaLe9qSWWuwejrQ7KHCKgrN8C8SBeZI5CzEw==
X-Gm-Gg: AeBDieum3Ghddo1MvfnD7/D6EZznjH4iesB89Xomhzdcxw2ouYpIX1Y44+AdJ50GWy5
	VBvPZoWCVIQXUmqlH/MKIw6KP2gf4ZG6u/fsHc94K73jbenplBdxxbrT3o+FNcwb9zLqQFwF8ol
	OPHx575VmqsdwlAvFH0gAZugNvbHoVScZeBRsHX1jAEMCQQZ/PtJbXxyr9o85aQG+fjv1Vk2SJs
	3bRGAZtU5qbAuY30tJcsfGoNjT8KNzTbp5TxSNl1Vbh6U9OyQ0WjfL0+bAJi45vJjpYQIWnEcnl
	QFTzt21vbu09wk5vhNpnboCpYdgXUwDUsCNCfQtT8yUk2rFh
X-Received: by 2002:a05:6402:46d9:b0:66b:3cb7:f638 with SMTP id
 4fb4d7f45d1cf-67079508262mr5777846a12.10.1776103637515; Mon, 13 Apr 2026
 11:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-8-pasha.tatashin@soleen.com> <2vxzika8e4b9.fsf@kernel.org>
In-Reply-To: <2vxzika8e4b9.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 13 Apr 2026 14:06:41 -0400
X-Gm-Features: AQROBzB52iWeNQz-4lr3HRveWwgXmnyK1n-oXtMiOda6eKIXmX6zne1YunZoE1Y
Message-ID: <CA+CK2bAHAdQnq0Q8DTE021BjMVOZizOvGE-DeNs-TVnhRe1KoA@mail.gmail.com>
Subject: Re: [PATCH v3 07/10] liveupdate: Auto unregister FLBs on file handler unregistration
To: Pratyush Yadav <pratyush@kernel.org>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6070B160009
X-Stat-Signature: ep7is9p7ukjk7gebqg5d9rkkpb7kaet3
X-Rspam-User: 
X-HE-Tag: 1776103639-284074
X-HE-Meta: U2FsdGVkX18umollEeBwHlv8Vp9SGuaRxcKUg6oJ6jVatDhZftERs0bT3KXgFx3ChYojKGcxhsH4KOpyaNg/wQ3S2PCGvLBLI3EVxEGhTfoQbJ4Jgu9Lm8OKTdgvsXZlNzraBQZzRDeE0zmVLSEh49MtpAwOFtWduBtOpgnLA527GEcXQiP1D7XRGdSoWeczEWhivQrA0H+AdDxuf6da8j9qctXtDXiExpHoWd7Auh7bjUecjH1xdRpuEHC6SrUPxE9p5wHKzoEdCC5XHf8krT/54n//D3QgTdP12bwXXrDRxsaOl04rr3NOZc30HwxtfdLJ/3DnjxuhDaT/6CAn/AkplL5x/c5AVvXicRl8+gtTKe7cWbEtlCKfDDDnjYG1Ki91i/GSC3gHL3Ygf1Lzcp8+akysjosnET2OIIM7EEecXaTuaEQDHXAgxuewPFPgDe1Vt5H6ZELr4VNZDHDbmgwZCaWtKt5IyxGtxorfAdVPckFojJ5ss1UeBxXCVGkhJuv5mhF3AhaTmymda75cfY3FRfP5BE2XGYDyJJIcfJ6yDwAYHV1VEGJpey8HmMCeULOgnFsOnhaLJN37P55Jqo5KsqUg6oncAFz8rzirqrByO54jEr146GDAgR9FUeGCrPXhLJmyvceWwG8Ff0Blm4wi8e9kC8WCuuwa55gYw9LJf5Qxx1BI2JSgzmuTunhoBQARmPfQqWwEdajxb6N8clwfQ98slGQqDPRqe8v0cKOf0Tr9wEneR1IxwSkptKztkuq+91Ldb7ox/hT6GLadfxWm/X5rDNbjzS4dCsPs9PBKshFONZEe8aJDqVDQa9ry1IE2qBBRm0GZaXfymsn2eZz5QsQrU8AdHyyPF7O4WcGmcLInpCkm2sHCIMyoeHbPlMNaUo7m94TD83jt0b7kebB0ZXTZ7CmYUkeYNaDo7MrmmvehACOf4394vctU+Ilo16qvI4pzpWSJBaqXpbY
 /msc+ZnF
 cE2W2S0IXyZVvEZF19wDxFIAFu3avMdqsae2YVdyflfCdwlRNIzEDgv/NDZn1ZA3m9m9JAZrUwMtOPuDujuP6zJXpGJT/YlShD3CzoeX0V9A2GEHn0Yk9CY8LosDDSaB1twR5GpDNW3tgDzAR6MGT9/qdHk8yM8UTfajn8Bv32x9dRIq8yjjSXl9pBBnU/HgP9aIs78nxvd0NXRm6kDlD5Ls3LZ8LYAxpJ9Idgn/7FRCzTvgf2N52r7VTIS1blpZlDcmo8sz8FsrkxdAnycNL1xIV0g6SjFry7ENVatVJX2KO6G0sALpw0bwfItpbH+NnlhPW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 3, 2026 at 6:17=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> On Fri, Mar 27 2026, Pasha Tatashin wrote:
>
> > To ensure that unregistration is always successful and doesn't leave
> > dangling resources, introduce auto-unregistration of FLBs: when a file
> > handler is unregistered, all FLBs associated with it are automatically
> > unregistered.
> >
> > Introduce a new helper luo_flb_unregister_all() which unregisters all
> > FLBs linked to the given file handler.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/luo_file.c     | 14 +-----
> >  kernel/liveupdate/luo_flb.c      | 84 ++++++++++++++++++++++----------
> >  kernel/liveupdate/luo_internal.h |  1 +
> >  3 files changed, 60 insertions(+), 39 deletions(-)
> >
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.=
c
> > index 439177c10723..80f4e3b796a6 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -895,26 +895,16 @@ int liveupdate_register_file_handler(struct liveu=
pdate_file_handler *fh)
> >   */
> >  int liveupdate_unregister_file_handler(struct liveupdate_file_handler =
*fh)
> >  {
> > -     int err =3D -EBUSY;
> > -
> >       if (!liveupdate_enabled())
> >               return -EOPNOTSUPP;
> >
> >       liveupdate_test_unregister(fh);
> >
> > -     down_write(&luo_register_rwlock);
> > -     if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
> > -             goto err_unlock;
> > -
> > +     guard(rwsem_write)(&luo_register_rwlock);
> > +     luo_flb_unregister_all(fh);
> >       list_del(&ACCESS_PRIVATE(fh, list));
> > -     up_write(&luo_register_rwlock);
> >
> >       module_put(fh->ops->owner);
> >
> >       return 0;
> > -
> > -err_unlock:
> > -     up_write(&luo_register_rwlock);
> > -     liveupdate_test_register(fh);
> > -     return err;
> >  }
> > diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> > index ac6fa5b34b43..f8348138de70 100644
> > --- a/kernel/liveupdate/luo_flb.c
> > +++ b/kernel/liveupdate/luo_flb.c
> > @@ -335,6 +335,62 @@ void luo_flb_file_finish(struct liveupdate_file_ha=
ndler *fh)
> >               luo_flb_file_finish_one(iter->flb);
> >  }
> >
> > +static void luo_flb_unregister_one(struct liveupdate_file_handler *fh,
> > +                                struct liveupdate_flb *flb)
> > +{
> > +     struct luo_flb_private *private =3D luo_flb_get_private(flb);
> > +     struct list_head *flb_list =3D &ACCESS_PRIVATE(fh, flb_list);
> > +     struct luo_flb_link *iter;
> > +     bool found =3D false;
> > +
> > +     /* Find and remove the link from the file handler's list */
>
> Nit: it would be nice to have a lockdep_assert_held_write() here to

Done

> clearly show that the luo_register_rwlock must be held when modifying
> the list. I know that luo_flb_unregister_all() already has one, but in
> case we refactor later or add another caller.
>
> Other than this,
>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Thank you.

Pasha

>
> > +     list_for_each_entry(iter, flb_list, list) {
> > +             if (iter->flb =3D=3D flb) {
> > +                     list_del(&iter->list);
> > +                     kfree(iter);
> > +                     found =3D true;
> > +                     break;
> > +             }
> > +     }
> > +
> [...]
>
> --
> Regards,
> Pratyush Yadav

