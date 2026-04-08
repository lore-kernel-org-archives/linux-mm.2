Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8425CFD5F94
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3AB16B0089; Wed,  8 Apr 2026 04:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEAFE6B008A; Wed,  8 Apr 2026 04:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAEF6B008C; Wed,  8 Apr 2026 04:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE2BD6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:09:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62FFA8C4B7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:09:16 +0000 (UTC)
X-FDA: 84634663512.08.A4C5E2A
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 56741180003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:09:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iaI2x0WR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of komlomal@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=komlomal@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775635754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxOAFje5nPkMc5Q034nTfNvqywtXDIriDUwzfUf+f2Q=;
	b=fw/iZIl+37OUWoHBXbE4yEWeXShydvHtesVRJ192du76Iyv3+P6KNSx6Oqap/5l9XckxFT
	xkAwiCHqqKOkZ1ZedsA7VWyJGJqVQxgeSpuK8Wl/nZboB+MAj5X7VDdkt8TvuMxvzuQdQD
	qovavxiD4bNlhBh/bavcuLoQ/xYBD9o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775635754; a=rsa-sha256;
	cv=pass;
	b=OFuEiLNUqm9FpQ4LMLLJMtYUBhb9bkZgkjPprtc6LDDefHaiD4dokJYfGRLFxYxrcFrmeV
	NsI+xDWRj8SyipQjG7ecl6KbYRtFbtRq6FDK15YOA8kNlAPpAN1BLXwICmWi5AQ85RsUYp
	im96V9gKT0aBkoOG/7Rm0Qt2yz5IkTM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iaI2x0WR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of komlomal@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=komlomal@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-38704f70ea3so53623641fa.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 01:09:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775635752; cv=none;
        d=google.com; s=arc-20240605;
        b=cKyEjAbX5LTIIOXeDbRm03E2hxXdWZYUrkPMEi7gsHpRe/HsyRpIKXwubND8hq4PE3
         uxBhQGthUdrWFjaMALFtyD0hxcbwdrvAPZ3BEC3NHtoobYH92Lq7xrPTRRABiRTwALj8
         qGyt49RtgKrqPYG5zM5d+6CxllIOiDl90GeaYBPOdLYDhW2Nfb7c8Dgdqa5L4wBZWzSM
         XNUtbesxF57WWE2z/ikNr7mwvEo5s54BEx50+Qiz2D7PDmXS3kwoCeXqroJOzGAC5QOO
         UGDSUqF1ds9k+u8dT4NSIats0UDFDBfa1ajfgzIW+N0B7IaEkqv4t3fW9Jh/Dct42Q9A
         jeEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pxOAFje5nPkMc5Q034nTfNvqywtXDIriDUwzfUf+f2Q=;
        fh=O1IiTqY+DH3pd4QkC6otil88w6HOBgmTlgfFRKXQ7i4=;
        b=WE1BGmx+zvBJOE04RDM0o3x/CDVHGrSF6m257jCVGebuiTUQE1ZWVSST/mfv7VwHWr
         uvXuABUOozp6qO/d/k/dmosknRUCtK3RxQvGNAg6C6WifpYFV/a6hfq7wd7j4ZXLlTvE
         5q8y/kICagq6Ic5Ma0FwTxm3WIgk8kDai6uaREL9CztDNdfLro4vTzCuQFalNnD/bBLD
         huZk8aZjGH+1QEFp+IZnEMEGU3fLI3WO18n3HKOCD8d7N/IY6vES6GurCxpfdh4HBYDa
         Mj2MMZVMsX4uaLPqvcH09KrHYZsNqeyMmXFh1L6EZ/q6Q/ZegnznZ1/BgvaVnvkmy/6E
         0TqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775635752; x=1776240552; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxOAFje5nPkMc5Q034nTfNvqywtXDIriDUwzfUf+f2Q=;
        b=iaI2x0WRche7Stv0ZrmHPbjI4oSWeThT/hhp/KWu/wHqvaQSueWCZJOylnHbKry232
         RgCXlrIssJxa19vYdwRjcK5AkafR4alGqSkrUZ8/T46WvLTChpgFZ9vOHAprqibthjHd
         JsdWkQPlOqvJOF4McpB1ZyT58rpPRzE5Cy9fXAe0FGLKApnHfI03QwcLicUbyy4qUyAO
         8DrDgb5mCpV3FUvrtsp0YN5+SzVtiDsh753lz7HSra+tIWY4qk6bXJ0tR3/a/C8piSxs
         zpdptHtmY5O8qN16BP+pS8PVQMxyI2OzZj8fLJ4Mx+c9yMWeWBqFJp3Dm2rB9MhblOYp
         Aaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775635752; x=1776240552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pxOAFje5nPkMc5Q034nTfNvqywtXDIriDUwzfUf+f2Q=;
        b=LJe/CJtV+b/FvKJDRn/RXaIQQT6YobGw9+H9Z5OTZcd9d0oR8/L8zyStB8nfyelkca
         RiY6FSxnLAH8eR9qAe83nbT1ZzTLEKI8Kk2sxpfYr/a88GUMuzSUn7ECXyfwr3B4gOrl
         omQ3krK0CHEMTI5zqbtRP6E/kablhB9Tvj3bLS/HZjnlkTWY+mY85BNL0yFn81MYS/PS
         hRpSt0z6C75IgGq+/2SOTKD4XbAi1c54vId/cgIzI8KngK2odSq+MjBAAdjuuKsJG1cm
         orMIhgiyjBrVz/JllJILyzShMjqVsiFpuGG0PEF3TO1P4yxRlYZTa0jo3ruvKBosFfjT
         o70A==
X-Forwarded-Encrypted: i=1; AJvYcCUNIyQ4mcl76E9/0inRqxcvLBm+Tl1VTjw3POqhvQz5/TmjqR7QCDHq12ZktLdn8FlDQ8yO2AnjtA==@kvack.org
X-Gm-Message-State: AOJu0YwrUQQO2PSf+91wtfKEP8seE6CusuqarxjJ5fYryUUUKlZDqQLM
	gYd1bf+eeNiQSEdycgGxEL2Ml+OyYG2+uuL5t5OLftO+lgMO7slcIDQCAk4pRoJM2OcNfk4VXt8
	Bq24nj1ONNrBOZj1t6BjQMIjKgsjJx5c=
X-Gm-Gg: AeBDievPBcps85bNHRr1ysqZ6Yv03xYtlbuGYENj6YuBhdJ5hms7GeTF9q+VhxmQSTy
	u0Eq4QwEgcddKEe0oBqqhtB6Wk7Kach3KV0gAVntdHSVtC4wMYuzQPaIi+3JuOb6iMm+j33wMbB
	Owx/oufAzezXuUo7ORk37bIgv5vrBDX08sdfBjNOUEMd+o1eM04q6dw7fmddONapAPMKBMi3+Qr
	g5wsEtKjslDhPhDK0/B6cX2155LKtl7rWBwCkLQjgBbKb1CyAomGRDoTlXu5aYbf2Hi2SFbdaMu
	e0uFHrw=
X-Received: by 2002:a05:651c:1b04:b0:38b:e048:572 with SMTP id
 38308e7fff4ca-38d8d1dc57dmr59181801fa.0.1775635752037; Wed, 08 Apr 2026
 01:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260407081442.6256-1-komlomal@gmail.com> <adXJop1d0QdH2Mwm@hyeyoo>
In-Reply-To: <adXJop1d0QdH2Mwm@hyeyoo>
From: "Denis M. Karpov" <komlomal@gmail.com>
Date: Wed, 8 Apr 2026 11:09:00 +0300
X-Gm-Features: AQROBzBgCH4RjVweEEM1TCje7jtGEZHThFkvR0yPukwiJ1tBezDT9yaTd4pJIDs
Message-ID: <CADtiZd3AcY2LwPfCkb782TaY1h50dTPpEzhfLSyMeQeXG6VXfA@mail.gmail.com>
Subject: Re: [RFC PATCH] userfaultfd: allow registration of ranges below mmap_min_addr
To: "Harry Yoo (Oracle)" <harry@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	ljs@kernel.org, vbabka@kernel.org, jannh@google.com, peterx@redhat.com, 
	pfalcato@suse.de, brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 56741180003
X-Stat-Signature: myxixgeyj8nd9ysxjejza5ai78w9h3xx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775635754-36817
X-HE-Meta: U2FsdGVkX1/8TtCTsSLBaj0LvAPCNdcVv8SfdldV8XSU4Livlq7ABIsHJRyExkDA/MrpQrf2pJZmn8grBVCvJLv8sGAva46G3GNvr1CzxRaVsF1hW5BPUkNaMxbfIhKVVQ4IztkCUzXjSoqQWmMl4gK9/bRAARys7Ia/DiHHLT1zjf1flWbIp6XpiNsYTzwPP+G0VCz9+7TiIqsy5zSBtfnct61c4A0mzLX9J8BSGhue7cIK0fcZidvMMwl16y+hS3xoEj52NzBEqL7lNOyt0lmmu+qYcntDIXroybVKYW2W+ggp3sSCwNYsTnS1cbQs6c68Suwh+REzNbvxx5UdvJAf+ZHzSJr/zV5f6GnDveMyKxVuhWwE1S+8CioV7u9e8WTzKhq2DpIcmiULGo18xwXlbTW/vNxy6aPnvF1Ueu8NhYXWPsVZwLINTV5jfhnMegMYVpvHxBKf7+K1yLiKU3KUTXurY2l6oz++gEEjn1GES1ZBxsg5u9P+cnzx/bgoRYtwgYqBWiONrOAhrxIqlQLg0h+jlNV7TK75y3UY6UHpHRZYKd1+noBUr31k3ISPRZEszoCS531sFX9rxVA8oJEdFSdD2h7PUuaeJyOyvrCEANH0vyvYUfqhwfkqDEvRV5KNJtYn6tMZoFOrncYeMhu1QG1YnsfC3w/W48kY2X11BQNmQlgZvpQ9TgEyZ/DRHW4oLmWxtdKqevDqCowVlpT2mSxS5RNIzAzP0NmmznMRmHVyD9ShSF3hqkwwHAAe0pMVCm6IItXR+gJRcyO9NCnAZxXQe+59ij1/Y24i020MwLv/038+5/G7BfgNJk3MS5a6jarBNO6CYEeBCC3tLBJyJSeO9MxFTeXqUtDjm3MMQ9zZLvVGbfUp2fDm0X3b6yhbZJYUBYtTBjNKIDf9pLBwJ78ovQi4FbrIkyDwvmEfC/2tr5KwzLGdLHNYoH7FnNEF9LMHTBYTc8+gk+P
 Auyrwq7L
 IbRi20twhU7oE9M4DGnrTyDpjTKJ9cBbIFCegsS45icy6KVuwUFmBSNcnj5h5YeeuePBc1IAQ5dUARuenqF9y4ehRqxp87LHmFenx/W4huJbhchEj0+g16b3KNidkjEPHh20k1ARvcfsTy6BLA0vgrRQFPe7AABhK+z6nbg/N08qLT09NH+V/gy7nwGR41+oWRfRsSs9Vxso2pmIvAx0Dd5Kt7dFwVBPr9RAFbB4k2wYvxr0yVU9MBunVIS5CTKP+FCrvr6/JUDLeQ6FjPEknOr+y0VihhP0hxSw0Sy+CqzlZ9+eqrniPqdJfmtQvtqFczz7iJ/SxNA+Q4WUJd2E/7cF5D2iickITwEcuXSAUmeiJz8py0scpX8UI4AvwSpmkHsfn9fewjVPteuMQp9JD1sbJIHGoFrP/HlHCAJaenGk1ZduD3x+g2BES0+a0ZE0a+DeLEwHjmGo8HDG8FBNoDycQYQfyCvaSO5HuDE81tkkAEn4qQj4D6ced5aylxaMfE3mQKVqw/pYxD1ronG5Is+rccg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory exte=
rnalization")
Thank you, I will add this Fixes tag in the next patch.

> Hmm but it looks bit strange to check capability for address that is
> already mapped by mmap(). Why is this required?
Actually, it's not obvious to me either, but I may miss something. My inten=
t was
to replace the current restrictive check with a more flexible one. I think
performing this check here allows us to deny invalid requests early,
before locks or VMA lookups occur.

Removing this check entirely would also allow using UFFD in cases where a t=
ask
drops privileges after the initial mmap(). This seems reasonable because th=
e
VMA already exists, i.e. kernel already allowed this mapping.

In the [BUG] thread discussion Andrea Arcangeli also suggested adding
a check for
FIRST_USER_ADDRESS to handle architectural constraints.

Andrea, could you please comment on this? Specifically, would a
check against FIRST_USER_ADDRESS sufficient here, or do we still
need to check caps?



On Wed, Apr 8, 2026 at 6:21=E2=80=AFAM Harry Yoo (Oracle) <harry@kernel.org=
> wrote:
>
> On Tue, Apr 07, 2026 at 11:14:42AM +0300, Denis M. Karpov wrote:
> > The current implementation of validate_range() in fs/userfaultfd.c
> > performs a hard check against mmap_min_addr without considering
> > capabilities, but the mmap() syscall uses security_mmap_addr()
> > which allows privileged processes (with CAP_SYS_RAWIO) to map below
> > mmap_min_addr. Furthermore, security_mmap_addr()->cap_mmap_addr() uses
> > dac_mmap_min_addr variable which can be changed with
> > /proc/sys/vm/mmap_min_addr.
> >
> > Because userfaultfd uses a different check, UFFDIO_REGISTER may fail
> > with -EINVAL for valid memory areas that were successfully mapped
> > below mmap_min_addr even with appropriate capabilities.
> >
> > This prevents apps like binary compilers from using UFFD for valid memo=
ry
> > regions mapped by application.
> >
> > Replace the rigid mmap_min_addr check with security_mmap_addr() to alig=
n
> > userfaultfd with the standard kernel memory mapping security policy.
>
> Perhaps worth adding
>
> Fixes: 86039bd3b4e6 ("userfaultfd: add new syscall to provide memory exte=
rnalization")
>
> > Signed-off-by: Denis M. Karpov <komlomal@gmail.com>
> >
> > ---
> >  fs/userfaultfd.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index bdc84e521..dbfe5b2a0 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -1238,15 +1238,13 @@ static __always_inline int validate_unaligned_r=
ange(
> >               return -EINVAL;
> >       if (!len)
> >               return -EINVAL;
> > -     if (start < mmap_min_addr)
> > -             return -EINVAL;
> >       if (start >=3D task_size)
> >               return -EINVAL;
> >       if (len > task_size - start)
> >               return -EINVAL;
> >       if (start + len <=3D start)
> >               return -EINVAL;
> > -     return 0;
> > +     return security_mmap_addr(start);
>
> Hmm but it looks bit strange to check capability for address that is
> already mapped by mmap(). Why is this required?
>
> >  }
>
> --
> Cheers,
> Harry / Hyeonggon

