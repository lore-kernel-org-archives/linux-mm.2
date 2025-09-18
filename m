Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190F5CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 00:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A618E0094; Wed, 17 Sep 2025 20:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503E98E006B; Wed, 17 Sep 2025 20:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB708E0094; Wed, 17 Sep 2025 20:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 251838E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:29:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2707BAE6E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:29:06 +0000 (UTC)
X-FDA: 83900486292.30.C64226D
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADD401C0006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 00:29:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="y/ZNA6TE";
	spf=pass (imf20.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758155344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otTjDvMKcuz7B7FSDzuZ9ONktzk3szEQfjJL8I6CUh4=;
	b=zBMzJpysI4d2XPEdiRfoYc2A6/qCA1+ZcWAhwYDV0VrhHNcQceiR7YE01h0S8SN/rarLWq
	Qa5q1oQltTvy0lgSMbVH3bsfVaHH0oKZR2wGy3OeMEFP6yhXqBv3Mea9uyF5Hkr4r8gTBL
	euB5dbC1KsInDFMetO+T43GZnwD8HPg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="y/ZNA6TE";
	spf=pass (imf20.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758155344; a=rsa-sha256;
	cv=none;
	b=QY7j9IeLamhjIcWc6CSeP4ydIx978IzgtTAYA+g8Q+Rfv5xfZRcqMKvxHYUeOyFCvCgIyf
	X9g9N/IcSK0cUFBYu0MgCoO3H/FApWBbupLqwcyaPVzuu+nKfM0klctUFlDouBad/N7oe4
	ampDsn40yUKQbPX6H+SN/u8uzg1pQ8c=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-560885b40e2so4437e87.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758155343; x=1758760143; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otTjDvMKcuz7B7FSDzuZ9ONktzk3szEQfjJL8I6CUh4=;
        b=y/ZNA6TENsKqAcji40c2ZDeEQlai+n8geUtr5zBcC+kmNe+ZWd5Qkfho8nX48lDyOU
         kAUPCZh5EmetgHpbVoFgmwlIzpGPtuVztgQsK/IUJdPZVbLxF0eMbRdyqFjSMhwHR0Nh
         qpeu6/Wul/xnuoYEjdIQBwsTkjUqqM2Kl6lHvHFJ4yHI3yJY0f3oLiNv2pmNy7Fitctp
         0xm/VD0gfgl7+CiGZ6VTtrsqi8Qz9caR3vI5u0dai+KMrc2NV1jSCwdgKbXo0I5zuf/0
         NBPWGMqWZJOB2Fn3Ok5bb5vPgW0VARXFpaXgaVPKCIgyiRl6H4ED/M33z+paFkjlYnNZ
         w9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758155343; x=1758760143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otTjDvMKcuz7B7FSDzuZ9ONktzk3szEQfjJL8I6CUh4=;
        b=lgcR0vk3D0txbML4Vhrq/cpkWJ9T4E4hqlDLgWsa8WD68G7Cv34v3iV5uAWm4o1Ck/
         /hHsrfVp305Ew89LP6oTd1HW6z1QjkgNF8B45Z7VH1KbHlyFW3uLuHMSIWOeZcjNqRl0
         Vcrr5J9ePV/mCpzeO5PcEzXPcha7kaAW1fpdtcK2nmuGj/yQuZqTSLmD789B4P5BCYgr
         8QLLmNJtur4gEVzp6fldBqCP+NxaFQi05pUTRQuUfzeDoEehjsHZmkx4tlM7CtdukOSy
         Tvp+8PhnJOp1m9tyMpbQ/6/JK3qR7JFiuAa9QXdNkUBlfFH0T6yof3e0Z4VE6+jXVmYi
         rsiQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1+oCssmgG6gRLn20wT6kLQm0MlG/8pYLfyfzvvYMCv94qnzBVHu0uYAoaLrEmQUHeZWcgst6LTw==@kvack.org
X-Gm-Message-State: AOJu0YzEpxbDyxJS4kyLNX0YI7AxPK0c2xdIxjSAXt9Q78BkMuLoUZi3
	gvxXcceOan0ZQtr3dTpgGd+qtxpfpWE54DltH44WrGVUCqGkBMYXtNVj7N/z3Bfyq170yOxZynw
	MD17qQy2LrodD2W3DxSx94xu6WJB6H8XytTCZXgYy
X-Gm-Gg: ASbGncuiki5HkDxqwn6fB6GdvsAN8jMKUScMSdFl5G7DGoTB4mV0UZtJMhDFK9ffv9k
	BArY0X05Uu5KOGomi3FTVftzHDDXGtKT2Zo8yayM9urJkVBfOS9BSpaJawPNKwSzK39KEMBng9B
	OuV0zKSU7U4VCpWn2XgnYF1nEC08YJ6VwqrCYVnXSom2qG8Kr+VIBZdP7QfG8Gx6/CB4M0hFTGO
	B5ZNM7fIQ+V/agIf/c4hG2JCiIWTwPVRv48/m5Rpmsid4pt3f7ru7gYToQkxwE=
X-Google-Smtp-Source: AGHT+IHBOQjrzCEaZsycseI/wvvGjPucCWK4u9AySoDeQE47ePlR8NeAKnDsZf2mX/C9kzOariJXaqbjhJoYXdHQF1g=
X-Received: by 2002:a05:6512:2086:b0:55f:6aa7:c20 with SMTP id
 2adb3069b0e04-577502fde9dmr430214e87.2.1758155342586; Wed, 17 Sep 2025
 17:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk>
 <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de> <CAHS8izMjKub2cPa9Qqiga96XQ7piq3h0Vb_p+9RzNbBXXeGQrw@mail.gmail.com>
 <87y0qerbld.fsf@toke.dk> <CAHS8izOY3aSe96aUQBV76ZRpqj5mXwkPenNvmN6yN0cJmceLUA@mail.gmail.com>
 <87tt11qtl8.fsf@toke.dk>
In-Reply-To: <87tt11qtl8.fsf@toke.dk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 17 Sep 2025 17:28:49 -0700
X-Gm-Features: AS18NWDUfv05rf0NZaG4uxGpfp0qugFcIQfECemqL0cSXbjzvnAAJACWkN9nrA8
Message-ID: <CAHS8izNMHYuRk9w0BUEbXBob38NVkMOVMmvvcq30TstGFpob6A@mail.gmail.com>
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate page_pool_page_is_pp()
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: Helge Deller <deller@gmx.de>, Helge Deller <deller@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org, 
	Linux parisc List <linux-parisc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ADD401C0006
X-Stat-Signature: z74okt7hbtie69uaxj9dc37bwtwoyh5y
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758155344-719064
X-HE-Meta: U2FsdGVkX18PRtlyt+6XRwdZfhLMtmW0uJLZWDprgYCkT3yDCClcy9TwGAxiGss0ja4Qs/x5Y0WKkU8K8CLnyK4IHS+1OfW/T3b3jEDJ6KDbQ8sB/DylNhNkZbJg1ijbWzTJi/4b2FYFS+oGl4bOLRhggKxJSQy4VNf5q06Nc+x94pdvBCFD0pmUC2imxglBO3XwSI6r4dmCl+s0DsECjtkTqb/8p0hiUfpsRbIBPMTZ8LNP37VC/Tz+P0jKmVz4w/wQh0Jf42MR0XEugz5+qw7j791/MdCCB+tVVfotL+KHfAvs2Cahx2InbFp+EVnxx/FPOHY0roQKpUHK5sR1+bLCmOzitzBUOIPCOnDxkPz/8EDz2yBADnSSBpwKStgTaaCVNjBYn06hlgtgIov4r/XKPeRDbhLKT5GkIt7W/3C2BLP5vuEo2tiNthLkBAT5D2zTyIJZu0fvJoscyNl1gFoPY/wDOEdi0F/TxQZxEqupKqqrOYdrK2PF3ov9PH/l9nVCt8Fq09lB9eYCYyt+9RwX3zWddMnImoSSuLwCqBG8WwYjdpqIfSrsg40yLkEPi0IBvqRjnhY3+88NI/QMcW1rIijYsA/Mk1YVcewwDSzjoaQQMoEsmFbIKzxLxGqq0WLWs+wKP2QjnuFwujA/GAxsjnBlf9ywcGOfrEG71TJ8HON04Z/U0rHKe16StCF6ArV52xC1oHTUSFwBLxvEh3PnwIdJOIyPG/+tSp7Bl+4xcgr6WQml0aAgWR1iJ8OTpsNDm7oU0OOx47G4UNGuxYPCMgDriYlNINelMRTxghyrISfobmWpHp630HzmQ/oX64Ji1YVa5kjdeJeC1evJmMeEMnD6/zEo6ytx0O+YzcB5eNawjDwe9mXkWGS1gdBZQe5enfyTGBBZog2aE/PcrlcfVoTfOyB2LVCYQJ9N29XsQxEdss17+52ZLt9ODPdGr257gKupM9igIXFJHmq
 yxDQfxUt
 EF0+jmEhvTmVeRapR3IEi4Cx9Zv7Iq2g73ocuWRzvEWrOSKvSnHkWAJNVvZqmANXZ//AukpgCb9S3jk1n3y4Y88oC8NsrXPbFKNFm8KEEnIkYJcRT7DLmckpL0d4MEI+DIvntb6DB+gBi/3Ws3kIdSkDDQV1JZ00OPlpTRfL17JGieoCXjjldDDOifl2xTmw38eRTXB9x75ApJLUvlGVwT2bkWcdwSFGQx906k3EJNUdYIOLxZPnf0xLp39tpOQWvmR6sBzLJFypRjsbTRni522bn6//EwojQDBLL0ggzuEZuRJJZqTtkdYWrag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 3:09=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>
> Mina Almasry <almasrymina@google.com> writes:
>
> > On Tue, Sep 16, 2025 at 2:27=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgense=
n <toke@redhat.com> wrote:
> >>
> >> Mina Almasry <almasrymina@google.com> writes:
> >>
> >> > On Mon, Sep 15, 2025 at 6:08=E2=80=AFAM Helge Deller <deller@gmx.de>=
 wrote:
> >> >>
> >> >> On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> >> > Helge Deller <deller@kernel.org> writes:
> >> >> >
> >> >> >> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unma=
p them when
> >> >> >> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0=
xc000007c on
> >> >> >> 32-bit platforms.
> >> >> >>
> >> >> >> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identi=
fy page pool
> >> >> >> pages, but the remaining bits are not sufficient to unambiguousl=
y identify
> >> >> >> such pages any longer.
> >> >> >
> >> >> > Why not? What values end up in pp_magic that are mistaken for the
> >> >> > pp_signature?
> >> >>
> >> >> As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
> >> >> And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA i=
s zero on 32-bit platforms).
> >> >> That means, that before page_pool_page_is_pp() could clearly identi=
fy such pages,
> >> >> as the (value & 0xFFFFFFFC) =3D=3D 0x40.
> >> >> So, basically only the 0x40 value indicated a PP page.
> >> >>
> >> >> Now with the mask a whole bunch of pointers suddenly qualify as bei=
ng a pp page,
> >> >> just showing a few examples:
> >> >> 0x01111040
> >> >> 0x082330C0
> >> >> 0x03264040
> >> >> 0x0ad686c0 ....
> >> >>
> >> >> For me it crashes immediately at bootup when memblocked pages are h=
anded
> >> >> over to become normal pages.
> >> >>
> >> >
> >> > I tried to take a look to double check here and AFAICT Helge is corr=
ect.
> >> >
> >> > Before the breaking patch with PP_MAGIC_MASK=3D=3D0xFFFFFFFC, basica=
lly
> >> > 0x40 is the only pointer that may be mistaken as a valid pp_magic.
> >> > AFAICT each bit we 0 in the PP_MAGIC_MASK (aside from the 3 least
> >> > significant bits), doubles the number of pointers that can be mistak=
en
> >> > for pp_magic. So with 0xFFFFFFFC, only one value (0x40) can be
> >> > mistaken as a valid pp_magic, with  0xc000007c AFAICT 2^22 values ca=
n
> >> > be mistaken as pp_magic?
> >> >
> >> > I don't know that there is any bits we can take away from
> >> > PP_MAGIC_MASK I think? As each bit doubles the probablity :(
> >> >
> >> > I would usually say we can check the 3 least significant bits to tel=
l
> >> > if pp_magic is a pointer or not, but pp_magic is unioned with
> >> > page->lru I believe which will use those bits.
> >>
> >> So if the pointers stored in the same field can be any arbitrary value=
,
> >> you are quite right, there is no safe value. The critical assumption i=
n
> >> the bit stuffing scheme is that the pointers stored in the field will
> >> always be above PAGE_OFFSET, and that PAGE_OFFSET has one (or both) of
> >> the two top-most bits set (that is what the VMSPLIT reference in the
> >> comment above the PP_DMA_INDEX_SHIFT definition is alluding to).
> >>
> >
> > I see... but where does the 'PAGE_OFFSET has one (or both) of the two
> > top-most bits set)' assumption come from? Is it from this code?
>
> Well, from me grepping through the code and trying to make sense of all
> the different cases of the preprocessor and config directives across
> architectures. Seems I did not quite succeed :/
>
> > /*
> >  * PAGE_OFFSET -- the first address of the first page of memory.
> >  * When not using MMU this corresponds to the first free page in
> >  * physical memory (aligned on a page boundary).
> >  */
> > #ifdef CONFIG_MMU
> > #ifdef CONFIG_64BIT
> > ....
> > #else
> > #define PAGE_OFFSET _AC(0xc0000000, UL)
> > #endif /* CONFIG_64BIT */
> > #else
> > #define PAGE_OFFSET ((unsigned long)phys_ram_base)
> > #endif /* CONFIG_MMU */
> >
> > It looks like with !CONFIG_MMU we use phys_ram_base and I'm unable to
> > confirm that all the values of this have the first 2 bits set. I
> > wonder if his setup is !CONFIG_MMU indeed.
>
> Right, that's certainly one thing I missed. As was the parisc arch
> thing, as Helge followed up with. Ugh :/
>
> > It also looks like pp_magic is also union'd with __folio_index in
> > struct page, and it looks like the data there is sometimes used as a
> > pointer and sometimes not.
>
> Not according to my pahole:
>
> [...]
>                         union {
>                                 long unsigned int __folio_index; /*    32=
     8 */
> [...]
>         struct {
>                         long unsigned int pp_magic;      /*     8     8 *=
/
>
> So I think we're good with this, no?
>
> So given the above, we could do something equivalent to this, I think?
>
> diff --git i/include/linux/mm.h w/include/linux/mm.h
> index 1ae97a0b8ec7..615aaa19c60c 100644
> --- i/include/linux/mm.h
> +++ w/include/linux/mm.h
> @@ -4175,8 +4175,12 @@ int arch_lock_shadow_stack_status(struct task_stru=
ct *t, unsigned long status);
>   */
>  #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_I=
NDEX_SHIFT)
>  #else
> +#if PAGE_OFFSET > PP_SIGNATURE
>  /* Always leave out the topmost two; see above. */
> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2=
)
> +#define PP_DMA_INDEX_BITS MIN(32, __fls(PAGE_OFFSET) - PP_DMA_INDEX_SHIF=
T - 1)

Shouldn't have this been:

#define PP_DMA_INDEX_BITS MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT)

I.e. you're trying to use the space between the least significant bit
set in PAGE_OFFSET and the most significant bit set in PP_SIGNATURE.
Hmm. I'm not sure I understand this, I may be reading wrong.

> +#else
> +#define PP_DMA_INDEX_BITS 0
> +#endif /* PAGE_OFFSET > PP_SIGNATURE */
>  #endif
>
>  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS +  PP_DMA_INDEX_SHIF=
T - 1, \
>
>
> Except that it won't work in this form as-is because PAGE_OFFSET is not
> always a constant (see the #define PAGE_OFFSET ((unsigned
> long)phys_ram_base) that your quoted above), so we'll have to turn it
> into an inline function or something.
>
> I'm not sure adding this extra complexity is really worth it, or if we
> should just go with the '#define PP_DMA_INDEX_BITS 0' when
> POISON_POINTER_DELTA is unset and leave it at that for the temporary
> workaround. WDYT?
>

I think this would work. It still wouldn't handle cases where the data
in pp_magic ends up used as a non-pointer at all or a pointer to some
static variable in the code like `.mp_ops =3D &dmabuf_devmem_ops,`
right? Because these were never allocated from memory so are unrelated
to PAGE_OFFSET.

But I guess things like that would have been a problem with the old
code anwyway, so should be of no concern?

--=20
Thanks,
Mina

