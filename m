Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 448C2CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32EBD8E0008; Mon, 15 Sep 2025 16:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3063E8E0001; Mon, 15 Sep 2025 16:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243378E0008; Mon, 15 Sep 2025 16:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 121AB8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:41:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C281E870AE
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:41:28 +0000 (UTC)
X-FDA: 83892655056.22.66B2172
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id C7A171A0005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:41:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0DOJsMdN;
	spf=pass (imf19.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757968886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMK7NJwaESJbnK3s8EHaT9c8KoXak+YYX74sQNHhiFI=;
	b=EIAhth05ugkUyfra+UJQ6+bGyGdL8pihZGQkCZMzIEZhKFtdHSBSliHSouLsEnPzFPkpK9
	8IRryNrVMfsq/BFjZVxHqGfuZz5NjLe4dmKge6Uv6QIt/RqrBB4kQegG3v6j5A/rr7dXCh
	Q0fRJhCECPrMPFgJM7jw2/XeAfPA7KY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0DOJsMdN;
	spf=pass (imf19.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757968886; a=rsa-sha256;
	cv=none;
	b=BPMhMlNwS1/nTo0CnAY2oa2z2IQGD4MXQlLjJnPpovIml5qOT2zVN1BRQyQTjdFyGcNQse
	NIgCebP5og3F9m5iVHLVdgSjm7nMKHlXIzlh9dBwbX7xHUZszNvGY6+v480Rpf4SA4D/Qg
	+MCmvHKHYTFFIs8k2qetap10pI3e35U=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5694f0e29a1so389e87.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757968885; x=1758573685; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMK7NJwaESJbnK3s8EHaT9c8KoXak+YYX74sQNHhiFI=;
        b=0DOJsMdNrrIN7VIR3AftFyzQGF9PXbAvc7htcWxtsHq7euQ6tciykaJT+mJCepxCtj
         DQKFaraFxckl2mqDu65ipkNaDGOMAZMnqJP85qUdA8MPwmp/twW95xDNuT1iKxO5etVU
         NueU8N8tq6JpYQIQ/de4IvOZXBMm7ZTxoimnq9KWB9KGjRUzfMXmIs9fn8JJ7k1wYOtv
         csnAc07lMZmyiZyrbAj9CfphlLF1rx3yWh8sLlDeqXV1N1NX7ZSYcN7P+AFuay6RPgpk
         77O380YrrPH8btGk/Udn36SkWm8eI+qJ42H3NvusivId/Dp1NmnV8/H+WtbwjiGf6W3j
         ExcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757968885; x=1758573685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YMK7NJwaESJbnK3s8EHaT9c8KoXak+YYX74sQNHhiFI=;
        b=nk7V/sy1azPiTiHNQ9iWHtAxMkiy1QjvtzrdUitT95sOalyEMiY2g5GdtzljN6P5zd
         n1CA4iQ9TTT2lMsySkIojshdKYucOUsNfP4WSV4Ue3n/KPzsC1ZPk/5TSWGwNthdPuv2
         7V9b6ZUcVsAY0oeknjnAMXXb9Alq/v/hQ1CGHIL63S97/ZoioAH4fFrzHvMAWL9R79dU
         e4Jcd4mRHtcfTHkNrruobVM693aI3IbsFEBvQMuS1wPel7pgHB81xAlCQmmO2ErXpsBn
         xpnOlS9i+HwjGJOmicHJ6kO8XKoPOulq/k+IobiQUMbVB5KNhL2pTLTCfLD3ane/H3a9
         sO/g==
X-Forwarded-Encrypted: i=1; AJvYcCXp1g6fjYzxtykuLU7M9RrSsFEsjd6KaguOUccEuL/8yVFJU5xKGPTFVF5uxiVHXbsCFi9Y3PusrA==@kvack.org
X-Gm-Message-State: AOJu0Ywn5CT8Inq35CNwdhor1ExuQEs9+d8di9B4mfFDyjBTpqHSxzkI
	ZJJzlpfxM/QQy+sXrwvDr271tyCS0NxHobxx/3Q6hi1/iP18l/byAtg16PnT2s3hVaanykZTZuO
	TsfySdqfeiYT/78XQ1gYL6ij63p0Enq0pnNYC4ERW
X-Gm-Gg: ASbGncvG0birN13CmWdylo895pwrMeioJv4v/1JJz9UhBpLjrH70fHkxYp/oieDsfZ/
	mCgt6Sgw1D/iLggg8Q12pyGFkA2r13zfAjZJIfJISgKK6gcCYjKl0deMfEv82T1pOI543R6i0nG
	TKzr9kTkHQprXIDwDLkR3hnADVRYM76cbMZUMqX0kWij4FbMTEiExNp/gZE/tDR04O5Ioc9HZxB
	sawQkjokcHFbXU1vVtn3StcBL4wi3HIRSc7k5fr0AjxzJxd4vPyq5jHEzV0aRtxXA==
X-Google-Smtp-Source: AGHT+IHGFMFAHe3bY+DvDEhDPlvcqwc3mNHGgpeC6W2UaOALsJ4SgnArYnmlKWon5p86seALXadangeVhLFqm7q/dg0=
X-Received: by 2002:a05:6512:114a:b0:55f:6a35:dd47 with SMTP id
 2adb3069b0e04-575f227aaa7mr93342e87.4.1757968884595; Mon, 15 Sep 2025
 13:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk> <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
In-Reply-To: <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 15 Sep 2025 13:41:12 -0700
X-Gm-Features: Ac12FXw8iWJeTorsJMYkNtO9I0t4-r4gAX3swEx-NNU_3hrQub2lYzbBDyi4Y1E
Message-ID: <CAHS8izNiogfYx7YqfnAEUZX9NJSnHn7vykNx_X=b5chLpJ90SQ@mail.gmail.com>
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate page_pool_page_is_pp()
To: Helge Deller <deller@gmx.de>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>, 
	Helge Deller <deller@kernel.org>, David Hildenbrand <david@redhat.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	"David S. Miller" <davem@davemloft.net>, Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org, 
	Linux parisc List <linux-parisc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C7A171A0005
X-Stat-Signature: bw8n7g3yt5jzan83kg91xgjmip3yicgj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757968886-638095
X-HE-Meta: U2FsdGVkX186A0mfgtxbJ/xkuI8UZ2/EzZncptikL5ohZw1YZUyBVP7zY+jjmI1eTKg4URYmWhjbOjYp00LH3XusE15NgCjNVysk9IeHkqtM0aQxjHq0D31k6V+UDZ+ypS453UlZAlWSqKmPxkyofdEVUq2U9qFINsBtoyZpFdNGbz6sWD0E4OfVytrgRLP6mElvf13w8I1T7bHt37PGWZ9QV0z7sLi+JoqfSdUByE7gpHhSCQjbKAvu39Z66OLVof6FF5vAAyM+csrsVY/H32s4Q/u1eGb0ZoyJBxmMyfQNvi3sEmu0d17WNWJpSSRiPldUtjkZdoyP3k0sFIXv3SlrgtOt4V7HE/8o7ax/LfWYPS4iY9lqHt0OjDY9tcna53VUcQowTKu8YOAT+KPMND8VX+bb6qAAUyp77pXONXJzAc4fSeLiRsWkisNHvTnhScENHClewFCZyBL0W1S6b/vd0rybAMZTR5UjYjbbR3l7gw7rgbxC7AcA6ggn/CtxQRr3XWKua8IB3GofKxuVguy6lxJwOGbHs4TQbBoJrZ+8S1cccBw/92Z5df9riry2oq010WfifJWEED76o6Bx/tJXvmFDWATbULYK/NjxZJKRUNqk5M1fUHDKph0+khgtn7WARET2IgxDPULMTD2jq0Maxem9If1gf9Zcg/knY2xlbabTrZ4QanRkP8FAcam8bxBLFcAA8s0qWoEToPW8MbVl4yATrZxJyJtxaqDHEo+wAE8BdCGnTAqGOZWFE43WqFhOhgRrBd9Y4MsSZE7yElqvuh1NRzcLJ9VGbpB650WGRWt7I8XR8jNq3Ny1CCau7wNfcaZkIlGDAOeaDaoFDdRbdQNFtd2zt/gXeQJsQMsobXWbGAw6um2eDOuZY6XeDFDjTExWHXbwFDymEpVptGKJCITKYIH0jmPkLIMY+kKH1kNVN1jzvTN3J1kRE7dY4Bka8PU850v4aRjkt+v
 zJqApjSD
 kdfplySdPT4cN9dZwPicxzyg3hlw7G52rfOhe3v6hU7ERMkUSbUrmSEiZS2oBGC5yCtyptlwhFmMtnNpTUv/wlOenEvo+3tSai/x8VDo1JZyEhhk4YAqrXihK8LpgXkijTUnzgsP5r4Xs7HJTz7kBp0HxPa4tesJ1YX6PeJwQv07X8PFpps5GQSr1li06BBPkfhFe/ZE5oAEXGiDu+ixqIy0n8luQivdeu336WNtmWjd1GK7pqFTO4LyNLoUnV09DinwCpP6HngX/FrE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 6:08=E2=80=AFAM Helge Deller <deller@gmx.de> wrote:
>
> On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Helge Deller <deller@kernel.org> writes:
> >
> >> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them=
 when
> >> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc0000=
07c on
> >> 32-bit platforms.
> >>
> >> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify pag=
e pool
> >> pages, but the remaining bits are not sufficient to unambiguously iden=
tify
> >> such pages any longer.
> >
> > Why not? What values end up in pp_magic that are mistaken for the
> > pp_signature?
>
> As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
> And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA is zero=
 on 32-bit platforms).
> That means, that before page_pool_page_is_pp() could clearly identify suc=
h pages,
> as the (value & 0xFFFFFFFC) =3D=3D 0x40.
> So, basically only the 0x40 value indicated a PP page.
>
> Now with the mask a whole bunch of pointers suddenly qualify as being a p=
p page,
> just showing a few examples:
> 0x01111040
> 0x082330C0
> 0x03264040
> 0x0ad686c0 ....
>
> For me it crashes immediately at bootup when memblocked pages are handed
> over to become normal pages.
>
> > As indicated by the comment above the definition of the PP_DMA_INDEX_*
> > definitions, I did put some care into ensuring that the values would no=
t
> > get mistaken, see specifically this:
> >
> > (...) On arches where POISON_POINTER_DELTA is
> >   * 0, we make sure that we leave the six topmost bits empty, as that g=
uarantees
> >   * we won't mistake a valid kernel pointer for a value we set, regardl=
ess of the
> >   * VMSPLIT setting.
> >
> > So if that does not hold, I'd like to understand why not?
>
> Because on 32-bit arches POISON_POINTER_DELTA is zero, and as such
> you basically can't take away any of the remaining low 32 (30) bits.
>
> >> So page_pool_page_is_pp() now sometimes wrongly reports pages as page =
pool
> >> pages and as such triggers a kernel BUG as it believes it found a page=
 pool
> >> leak.
> >>
> >> There are patches upcoming where page_pool_page_is_pp() will not depen=
d on
> >> PP_MAGIC_MASK and instead use page flags to identify page pool pages. =
Until
> >> those patches are merged, the easiest temporary fix is to disable the =
check
> >> on 32-bit platforms.
> >
> > As Jesper pointed out, we also use this check internally in the network
> > stack, and the patch as proposed will at least trigger the
> > DEBUG_NET_WARN_ON_ONCE() in include/net/netmem.h.
>
> Interestingly it did not triggered this warning for me.
> Need to look into this.
>

I think you're probably not running into this because you're not
testing on with a driver that supports pp. There are 2 broad buckets
of places where page_pool_page_is_pp and netmem_is_pp is used:

(1) in the networking stack, where all the checks are guarded by
skb->pp_recycle, which is not set unless the driver supports pp
(2) in the general mm code, where the checks are not guarded by skb->pp_rec=
ycle

You seem to be hitting 2 and not 1, which just indicates you don't
have a pp enabled driver, I think. If you do and you're not hitting
the warns then that's indeed a bit weird.

The proposed patch fixes callsites #2 but does not fix #1, so I think
it may not be good enough. 32-bit setups with pp drivers will still be
completely bonked with that patch I think, although it's obviously
better than crashing on boot. I think we need the *_is_pp() checks to
work reliably one way or another. Reverting will also introduce the
crashes that patch aimed to fix :( I'm taking a look to see if there
is any suggestion here I can make.


--
Thanks,
Mina

