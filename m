Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D2BCD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A116B009E; Fri,  5 Jun 2026 11:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131DD6B009F; Fri,  5 Jun 2026 11:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047D76B00A0; Fri,  5 Jun 2026 11:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7D4A6B009E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:18:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4A0586CE6
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:18:03 +0000 (UTC)
X-FDA: 84846214446.21.993067E
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9ADB7A0002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:18:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="j92h21/L";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780672681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUirbwCPewTyFfnhv/ApKk+4P5ttqM6DO2JIqx8LspU=;
	b=vncChq1AaZD0jyNah3raeoponAM1g/yvllJqdK7wKohRlMZ13PA7HSlt6Lv72wT8zutPQE
	dz0Ph80D1fe1pl83gc6IRbw99eHOncg0YJHyF6ZwqkmXqDlAWPHf5ZiGzFYw/Lv5DjBecC
	phTaR/b0s7dc25/D/Rui5SFidGF8E9w=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="j92h21/L";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780672681;
	b=zr3k3p7TrDsRrXKj3wE1If48hBpcyULrlGjKlbaW76kl3haNqmqgI5KxJijlS/wl5EGwWI
	4Qs9gzAoLTVhX4MIhyd2pY6WuIBNbmrflckSHn8IKkg+CAjaC3eElcTFSkxbDCDRP02mgv
	iShlN3rDcC0vEOnP0ampUwaKG+Atws0=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-68bd7ec2371so10497a12.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:18:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780672680; cv=none;
        d=google.com; s=arc-20240605;
        b=hExtPVkpiD+hPYpFiqwIsyFC7+g38KJe65awkPXlb9bA6w0/t1c9mHyHHaj3gf/KX3
         D0LB/nxScIKOdXm3Zj+4IQRL7NDUpd4pgMj0GlDwsYrO3JfTps8xT1/0neCy+NQ3/sa5
         M6OGNyDV4agOIdqlwpxShrj9vFM6J18Bs6r/mYH61Y7bySXndr8Fb/DnQG46DdNtxq/H
         6hCv8S0wYCA4gLfbWKp4gFzS4Fuomg+r7Z7f8pGcAx8my9jlhFTm7XH44/DjgyMyPFCy
         Ksrm29LB1hvZtcqOdTEqFlM6LFrHffBH+ry7DRTmSkoEkg7CHVR2+Al87L+00rv+L2QS
         1veA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eUirbwCPewTyFfnhv/ApKk+4P5ttqM6DO2JIqx8LspU=;
        fh=MgSqigyKAUBg9ZDJ1cjNkAqG12z9biRqGUCZIxzfRyE=;
        b=ju9bWTs9DSEQ3B6+IELD71QKXbbTYJZ9BYuMX89AKSACQO7WHbbwZ1BbJ7VmJWBPW3
         6FoX0j7Rj3W10NEuZwl6kCjDmI6wnq65oNSlVX0Z9hPlx/46t/vO8taQdeLw4UfK7zQE
         d6KlRBB5DCAb935MTztn/Ua6bFMuoz/3gw0q5xh6aiWJ21BJSrjJ5gDEO0RS31yaqcse
         piA8cT0Y1c4J0hjZSQN/XmwqMw32RRd0beik1Go2Q94kl6WZk+XWc6l97sTtGEUNG+tx
         KeDNkXS/ovxYJKGPPVY4xbabBMn4q1VeCxdHyhiNdbOtnoK01T3kkPGU4fxMoiIirhLo
         xXVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780672680; x=1781277480; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUirbwCPewTyFfnhv/ApKk+4P5ttqM6DO2JIqx8LspU=;
        b=j92h21/LFGUTJl1NKvNfpDfx7I+Tv+jf5x0PkhRsY4cROVRZjLBkPcdwXrCINfMtgm
         qwqxhTmHOxnsAZRbhJzbWMebCYt6MNPSNqwGn2LSCNYRPdr8LZ84HKpB4peAAr/90NFK
         Ej1zTPn/oNHjUuaO8w7T72FcxroIKPQ271lnb8c/7ykUJ/2pfdsePMrMpH6vyP3qQNjA
         uFWzNmmrmqnd2W4eezyCl0S4PgMrKDCRccOJ85xm+/V3ora3sAlAvj0NSLB3oCIcNaWI
         O+5Yc/u99kHeDSSjxOo/zaagLqLk3Z9/LfHfT+TjWXfjuz71Recn+7HwdzD7OsDl1KZu
         1xgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780672680; x=1781277480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eUirbwCPewTyFfnhv/ApKk+4P5ttqM6DO2JIqx8LspU=;
        b=mYg3iDb5gktNEy+zgvI5BR+IyY+ekgbiUR7gOv3GfapJ6QzVZQpOCNTH7t2UEAe0WV
         iZef+kSyNpWQl88QvxEtmlEDDZawwIfN0OVRQthjwRpbDYxmca63e1iMSwyYeB0odnle
         46eOXUz9LHCyVBvYWvrX6K50xq/zz6Q/2BwAPxx+P4jNnRaGEkcYGlvAPWHwBeqXut7k
         mq6zq8FOkY/Ul9Kw7LIyJaM0k5dafm+uIPEiDAEC0cmy68r4QzcYDra1O8gw0Ja3uiem
         Iblf454/RLtnff/33Uqd9fO8lomtYsCeCLD6fOQ++/xexDSPHEnRJCUFfamxxgOqGQ9/
         e5aQ==
X-Forwarded-Encrypted: i=1; AFNElJ9qPVzyxrXlyaz26oPNhHuNFb+XG0O+SscfTAeOmMIwF4zHS9rlzl6q5BD3GE5oLYk0/SnMicq0Aw==@kvack.org
X-Gm-Message-State: AOJu0YyDt23VfxnWSBlgxknhCXYxXlpFoU6DY4AsEZB+jSJQh2tEflEF
	O8r+7xkXQ4RNU05oHguh1vSeKK/nuSD4JcNQXyUGEpi45uggqNRElBScVfMa3dB2AABTq6ZPL70
	9cmWVlz8aALgR7txAf2qiLMKnWcgEpx3tMnzxbDRg
X-Gm-Gg: Acq92OGiZlnfyD8hlHvpAikNj8dQpmMN9qOcTL0LR8n7stXxJ/GeQLiQChOaviUsrhO
	8K2WJbuWklIDo441dsZfJh04P1kgIUcWegKzAZJb6fJzV0MXBauV3mgGw+78lGIiWBeZ7Oz1uvd
	y0u0I+90Dkl+Re0eN9eyK4UV2Ma45y9WKc+wI5I//paVIIR4AOq80ktkhb1AUbgV5qxvG/3PRY/
	9EN+/EBaSWQn2p0SpzriecAR/DXxlCcofudzLeqB7FH56NCL4ziTHtyrwzXDX5SBUzb4xGUIjwE
	cjVkaYSgWg7WDu043VnOroE1ORI=
X-Received: by 2002:a05:6402:52db:10b0:683:33ae:8689 with SMTP id
 4fb4d7f45d1cf-68fe8b4cf79mr40043a12.4.1780672679627; Fri, 05 Jun 2026
 08:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260604065938.105991-1-hao.ge@linux.dev> <CAJuCfpFBcnS8thEbKnd74xTyuKd6qaOKk8+sogC17yL2XE0THA@mail.gmail.com>
 <d4eff260-1e11-47f4-84cf-80cfa6d45d2b@linux.dev>
In-Reply-To: <d4eff260-1e11-47f4-84cf-80cfa6d45d2b@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 5 Jun 2026 08:17:46 -0700
X-Gm-Features: AVVi8CffJ306SAPzCbeeT2c_1PiUQyUhVbSOMhNwR1aYeIr8PK-Jk8P1XXkkzQI
Message-ID: <CAJuCfpHEf9=jCzy-9SwADc1oxut_hf0=Pxdwa8Um66itpMap6Q@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: fix use-after-free in /proc/allocinfo after
 module unload
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9ADB7A0002
X-Stat-Signature: 3ywawh6ja5krdnzud4y5mumxsia5ymcg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780672681-130538
X-HE-Meta: U2FsdGVkX19UTSlKq2VGiqHUJ9J8iOuU5xNh7boeVFvSYOpg+6LNztQwutuEa2NJ3xPOWJ4LpSiluSYyjbdCkWoXj+1wESKq85Sa9fku1ffMdDnjbjmhgEXbJ2pINDneMjvroe4ZMr2XeJj8xo/5GBjbrQmGbk6J5NaKbCEzLHj0wy/77f8tyxNoYHzSeGSitd2kLZoE1y8xIpMp78yR1i7SIlO5oFZki+VZSQwyx5ZPmLJ3RpCFTzY/tK+qPgVol64J9WCCJUhCfbeHnZqJucv6Li0R1MiAFEpNcTuemzJYlc+yC1/k/sAOXMGViJa3Jiv6PU9og0Jj6Hmb5gbpb2WIFNxkVLBtP3/pNDLKqZeCdw2gPfsq1oxUiS6TBdktcpDgjbp3nuBsEWimmviGFvcU2zB+Crt6Sm/2xHEXXpf0FK8unXGmLWjhtrZ1YcqmJ2SIxZSzk3bRznyK5rzPblBXN6/Rg7loOPc03LWH822ggbZLNrXPiwUYQ4jJo7BPLk9w832B0Sblikm/2fOQS8Uw8HgAUwMfdQ85Zl/l3AwvowiTELovts7tO0YCsRu/poSR+WRsnj9wD7OYoMSsI9BGRIwKWbgY3fZbJc3iF319edwkgLWfcMAEUsbuzEtlHmOX0O1wXrMyfFB4BsAc4JAXF42P6vC/Zdm67xNdke8aQ+rT/m+EADuIgNKjgq/01SQkfC1J6Hu32u5X86b+DkVv/Jl7mT5/SjJVED0Yys1oiJsaJRyb+rEWpCiJoPRYwiRJglDEYdzdc9oSIkBJOsTmhWdf6z4ZYnVh8B3Wnku8wGtZNIRalPXTU3xs3ahfrM9Fvqb1SZxmomvOLQzP0QnibYNYp/QlCMMJmHHr0LLPXxzGw1GVJ5q6zB+loElr+0kR/h9upkyKd/emVF08BOZOyEq+gGeklUQ0+2yOsUAO0xtoYPbcG2uWW5XvUVyrC6jwLUuc+2V1kgmMWoP
 FQvwvxLZ
 /WN0V+ZTCerqoUYMaMvq1lXVCEIP3wcMA8eQNrrISpxoXEnoAvetFv0O7UMkouXWmaPnVFBeQ0UdwPJJVwHoNMPkPLOlnQLrI0/j6fFv5KAePqGv1MaGpYfb8jCkc/8yP1imBb4xKSXJBNvb8B+RjYakinQga4aJ98UE6tiPIkw9hpK6rIE5PGlWFAwe1IZHtwNy/RieljptP4Y4uaCJ7YSex7YCbwm2e9lxjctE+1k+tQfu01XUGNTxuNvgAmsasl5pqOZ9zKL1Qp93iIya5/NuDXxcnq9Qf2p0cag8sp8RrzUzErmIpr4RUTAOy1wnxDQ/xkPOarmYwNsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 5, 2026 at 12:44=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> On 2026/6/5 03:24, Suren Baghdasaryan wrote:
> > On Thu, Jun 4, 2026 at 12:00=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote=
:
> >> allocinfo_start() only reinitializes the codetag iterator at position =
0.
> >> For subsequent reads (position > 0), it reuses cached iterator state f=
rom
> >> the previous batch.  allocinfo_stop() drops mod_lock between read batc=
hes,
> >> which allows module unload to complete and free the module memory that=
 the
> >> cached iterator still references:
> >>
> >>    CPU0 (read)                        CPU1 (rmmod)
> >>    ----                               ----
> >>    allocinfo_start(pos=3D0)
> >>      down_read(mod_lock)
> >>      allocinfo_show()
> >>      ...
> >>    allocinfo_stop()
> >>      up_read(mod_lock)
> >>                                       codetag_unload_module()
> >>                                         kfree(cmod)
> >>                                         release_module_tags()
> >>                                       ...
> >>                                       free_mod_mem()
> >>    allocinfo_start(pos=3DN)
> >>      down_read(mod_lock)
> >>      // reuses cached iter, skips re-init
> >>    allocinfo_show()
> >>      ct->filename   <-- UAF
> >>
> >> After free_mod_mem() frees the module's .rodata, allocinfo_show()
> >> dereferences ct->filename, ct->function which point there.
> >>
> >> Save the iterator state in allocinfo_next() and resume from it in
> >> allocinfo_start() with codetag_next_ct(), which detects module removal
> >> via idr_find() returning NULL and skips to the next module.
> >>
> >> Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between =
read()")
> >> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > Acked-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Thanks!
> >
> >> ---
> >> v2:
> >> - save the iterator state in allocinfo_next() and resume from it in
> >>    allocinfo_start() with codetag_next_ct(), which detects module remo=
val
> >>    via idr_find() returning NULL and skips to the next module (Suggest=
ed
> >>    by Suren).
> >>    v1 link: https://lore.kernel.org/all/20260525072117.112779-1-hao.ge=
@linux.dev/
> >> ---
> >>   lib/alloc_tag.c | 9 +++++++--
> >>   1 file changed, 7 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >> index f2f574bcf383..551cc14bb1fd 100644
> >> --- a/lib/alloc_tag.c
> >> +++ b/lib/alloc_tag.c
> >> @@ -45,6 +45,7 @@ int alloc_tag_ref_offs;
> >>
> >>   struct allocinfo_private {
> >>          struct codetag_iterator iter;
> >> +       struct codetag_iterator reported_iter;
> > nit: I would call it maybe prev_iter since it's not yet reported (you
> > store it in the allocinfo_next(), not in allocinfo_show()) but that's
> > a minor detail.
> I see...
> >>          bool print_header;
> >>   };
> >>
> >> @@ -58,16 +59,20 @@ static void *allocinfo_start(struct seq_file *m, l=
off_t *pos)
> >>          if (node =3D=3D 0) {
> >>                  priv->print_header =3D true;
> >>                  priv->iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> >> -               codetag_next_ct(&priv->iter);
> >> +       } else {
> >> +               priv->iter =3D priv->reported_iter;
> >>          }
> >> +       codetag_next_ct(&priv->iter);
> >>          return priv->iter.ct ? priv : NULL;
> >>   }
> >>
> >>   static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *p=
os)
> >>   {
> >>          struct allocinfo_private *priv =3D (struct allocinfo_private =
*)arg;
> >> -       struct codetag *ct =3D codetag_next_ct(&priv->iter);
> >> +       struct codetag *ct;
> >>
> >> +       priv->reported_iter =3D priv->iter;
> >> +       ct =3D codetag_next_ct(&priv->iter);
>
> AFAIK, in the seq_file call flow (start -> show -> next -> show -> next
> -> ...):
>
> start(0): iter =3D get_ct_iter(); next_ct() -> iter.ct =3D A
>
> show():   dump entry with iter.ct =3D A
>
> next():   reported_iter =3D iter(A); next_ct() -> iter.ct =3D B
>
> show():   dump entry with iter.ct =3D B
>
> next():   reported_iter =3D iter(B); next_ct() -> iter.ct =3D C
>
> show():   dump entry with iter.ct =3D C
>
> The same holds for the overflow case in the Fill loop:
>
> next():   reported_iter =3D iter(C); next_ct() -> iter.ct =3D D
>
> show():   overflow, output rolled back, break
>
> stop()
>
> on the next read:
>
> start():  iter =3D reported_iter(C); next_ct() -> iter.ct =3D D
>
> show():   dump entry with iter.ct =3D D
>
> So reported_iter always points to the last element that has been
>
> shown to the user.

Yes, you are correct. I thought there was a case when we move to the
next but then do not show because of the overflow but upon revisiting
that code I see that is not the case. All good.
Thanks!

>
> I'm fine with prev_iter as well,  What do you think?
>
>
> Thanks
>
> Best Regards
>
> Hao
>
>
> >>          (*pos)++;
> >>          if (!ct)
> >>                  return NULL;
> >> --
> >> 2.25.1
> >>

