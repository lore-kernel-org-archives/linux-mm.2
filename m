Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FE0CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF568E0006; Tue, 16 Sep 2025 18:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA72B8E0001; Tue, 16 Sep 2025 18:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3708E0006; Tue, 16 Sep 2025 18:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDE2B8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:21:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60B3658842
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:21:23 +0000 (UTC)
X-FDA: 83896535646.28.56F52FF
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 74D53C0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:21:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LJShj+t1;
	spf=pass (imf22.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758061281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVdLglpxhRso4AWsi+Qr5Xu9puyLriieQDhQNzvchd4=;
	b=RoAs+p0Vq+CC2aVeU3i5311prICZxxBLH9TuboobADg+Ffq4HblNZthCrkYxg++wIqguwW
	+JrWJ0cGWCaNDVOE2xEGlfyLLI3CCGXzX20SAO2gltHcbl8eelumCbokZclMdIJoj4PcnO
	Fyb+QtjWhFeDBcTbI8nEnBCS82tsKNk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LJShj+t1;
	spf=pass (imf22.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758061281; a=rsa-sha256;
	cv=none;
	b=RguwGm1ZAzwteRYw6dWkiJuk3Jue2bFjsSIoclt2oy+JCjJLk600XdzjtVyNZOlk0gAkl6
	HMYSwwuZP+tSLtUbYa0Q/5ba6tFfmOSOZdmHVrBJss7yjHilayItq1hfkTgrpg/6ZlWCYA
	gTi6nZmTwaeQS9kn3DmPuvbl4le38xk=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-560885b40e2so3428e87.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758061280; x=1758666080; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVdLglpxhRso4AWsi+Qr5Xu9puyLriieQDhQNzvchd4=;
        b=LJShj+t1NldQsvBUO86+NEJgvPnTF0tZTSeJSY59Ynu0MykDBGk2gdIF8G0/LntJ7Y
         mVegAbqqgLdmX/o2N8gDR19sctJSmSmOy7mJ/R0OG9IBq69PpwrxgKS1X8hz2fX+oCsN
         ljglXZs/Zwmw/4axJ3YOJWzUpkOSKEcK9AtSqQwBeG1RWnd65nF65iqUBz6eJNpnMpJG
         RzS+MWv9euq9sIJpnPzm9DA/NyHmUnPsiFWLGd8MwUs3a2F8oRlbGEB0h1LiZfC5qm66
         A99KeRgxjZ9sxiYQUlR6ykCZEHT+cAgCju6TvpJLkr2QopWHeg9fpMIMOVSmfh1cT9EM
         FxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758061280; x=1758666080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVdLglpxhRso4AWsi+Qr5Xu9puyLriieQDhQNzvchd4=;
        b=Uz+7ZGKBB7MGmL5zEu5xLU//GQ9Jl83dEgEfKk3RYHim6Ie6orymMbsOeAPX7u5sgZ
         0+AMy5dp6pzPYyHuzsgUvVo1325c2BqHS9DvMd4JJf5oaurzVqehvm5uLZK6Nx2CiKv1
         Sy65cVZE4Dw0spUP94GyQvpeHZ0d7wo0LxSryG0YZEAcNcC0S//fgAlnpJD4m4yOzMoZ
         ToaPRyuBT0BLZtPgfshAHkjw3f5v70GFn0XV54/VHOe4IQUWirCupdxsPtCK8DOOD+18
         Os9EXPl7ECfKkyo9ttY3JmbPt0tk9OoA3bModGgnS9RjPZSp9G8AhdWf3EPI/yDYPYm3
         5UPw==
X-Forwarded-Encrypted: i=1; AJvYcCW6svG2DLfWVnvRRfXp7cWGsgSRZ2E/0uzXXszyNxmKV+uMDGVaz/KZisgFXc1T8F0C/VItvmd1Tw==@kvack.org
X-Gm-Message-State: AOJu0YxGP/mmrk2AWM7Qmqw+pzpmzKMHkczZIWAGv+ej7Yfvp4wBLt4k
	gihACdqn2VVsgHhPQaQUweRTilr5ngT+yo2+q7pPJUtWwxNaWhyMv6TeROrlapF1De4d4AfX+AX
	jQddKeYRKdiJk5pI4TMg6UG2gA7Fuuqxa6czGLfZ7
X-Gm-Gg: ASbGncuxiQWSJKsKJ3ngO3J9e7YNwKKkaLK8ch1+yMb+X5ltYkeg0uUVG9DNQEFWoeo
	66xzyzPikZQl+g0c7fVlixz50odxmlGfSEoZUd3MkpB1lblI1XOuKeoIdvoGjrYPRgAJ4SFsOii
	4vocIy2F3o4GW68N3aWcOgNx9JwnMkin7Lxdw2uOtQchZoQqHjabU461CUFZRTqB9+keEVnJqAq
	w7wZYqqyiYFRWhM/sFBpjqQMGzTpmpQdloC5YBS0LYiSdJoKBNdZSo=
X-Google-Smtp-Source: AGHT+IETuMnvpwfVigTN61m6CycwMEcPdpn0JfGM8MkTwo9jHq/f412owy6e2+xnogamcc5EfMS02Pn2xCx3TgBeTYc=
X-Received: by 2002:a05:6512:3ba6:b0:542:6b39:1d57 with SMTP id
 2adb3069b0e04-57778c48d17mr57515e87.3.1758061279366; Tue, 16 Sep 2025
 15:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk>
 <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de> <CAHS8izMjKub2cPa9Qqiga96XQ7piq3h0Vb_p+9RzNbBXXeGQrw@mail.gmail.com>
 <87y0qerbld.fsf@toke.dk>
In-Reply-To: <87y0qerbld.fsf@toke.dk>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 16 Sep 2025 15:21:07 -0700
X-Gm-Features: AS18NWB-7AWKLsrqIUr07vEaC8LUK6IRwvPrOQdWgLCThpwa-rYMqW2OhB3IAn8
Message-ID: <CAHS8izOY3aSe96aUQBV76ZRpqj5mXwkPenNvmN6yN0cJmceLUA@mail.gmail.com>
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate page_pool_page_is_pp()
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: Helge Deller <deller@gmx.de>, Helge Deller <deller@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org, 
	Linux parisc List <linux-parisc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 74D53C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tgikhm9tj6s3ywy4t5p6dyumqja6o9qd
X-HE-Tag: 1758061281-207020
X-HE-Meta: U2FsdGVkX1/9rZux5HJFpnimZwr2UoRBez6KuVVC4s4ByWXNxde5jx1WfCYdBXoTmFIGyahPwi++ObEcPyLcCqP5dZRgCLr2PZPd5O1sqbSsS/6fB59+BUNJzRD0DRT0Myi9QeAOOLEe9dyGaHOvdBwSF4EPO721AO9bXWlxcJujE+pzX7jWKIZBpSrpRFUOS1qO8k5rcAvF7hRjnxV/WwkZ6u/fqdDQl6l/DXo7TVka8oE2MHes0C+5jjjAY6qywisbNnUFVvvEYuzwxwWaLox9zDqfme6YLjEl7bP5hB8sqqKHthROv6Pt1uyhIIe+FUj3Q+Exw/W+zQfdtL/mU1C1LFPr1rJgiX+dnAHRoQUd8OBAv83ukiK7WImlHnLbffdRLUsaPdYwW6sgxRNiWN3UIGDD3el9jbMukS4A0E1mR/82DqW4sS41K55p7EDMRpxvcrQtcs9KFqiUlCoxQF4xCKdllPBotH9u6NSrvdCDv9rSlfFn4lrzJBsv7RDyJunw3KHhxXAskAYW01O9/hyP+Iihv4j6M2V3tgb0IsZ06Rlm+oUYT5/fSHRBDokraTIoTMMbSrALiTyYI2W3y6ebzr+LIsSatGRJYzrQ+nJxyo+0QuiyctuC575CbMCHb7tw5l0+SB5+ugHL9Gsxxyw0x1EKhgC//sWb7Uma+HsSCe5Rk11Gl6icBJjCu4bj39PwhtTCWAXoo243tDWZFukYjghJjnOyFfJGHrRAhMa6RlLs670o3JAA/2bxkGqct24p2zO8Uda1LItAdKLiHK+k/XycwKfIOjaT/8NyOurco4M+RwPpK7lM03NtHOBL0L7V8Wl1eyclAm2sUB2IzM/X/5ydccmTjvrh8AjKBZwX9BY3vFrmlbIaHDj0CezyiF7SzKm+AHYyU3NoHNCTDwcFui86Dgt3OYdwWg05RRgjSyQz8+2f6sr/aEMmarE5apub7IrmYqU6CgYua09
 Zde2FV67
 WAp9YlzKPBd6fypLHMOgWwisIcnCckCsLNuHJqE/6UYO4LTHsNghcRYhUcY4dV6Mlg1BjG6fhdDNMCa4sv1OFtGiqp9Sd4MQeCaJ7cnWN75IROBcOjC492fzHoK4pOxzdGZwI1OUiDZTVshu3SDHfGXx5k5JzVJyqOmd1CUt0to/9KRSDPjy1e8nTjCiaA7Bo3yke7IbNFRYfxlRlPPcIqViv/1w9aECxB1LupQTXCmiVYrjBlhADRiakXOdy9qQAjj39ikxu6MGf+HdKOjvDiHH0COdKKyUSQBiv+OjtzpXE35E+9LmqThZgHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 2:27=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>
> Mina Almasry <almasrymina@google.com> writes:
>
> > On Mon, Sep 15, 2025 at 6:08=E2=80=AFAM Helge Deller <deller@gmx.de> wr=
ote:
> >>
> >> On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> > Helge Deller <deller@kernel.org> writes:
> >> >
> >> >> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap t=
hem when
> >> >> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc0=
00007c on
> >> >> 32-bit platforms.
> >> >>
> >> >> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify =
page pool
> >> >> pages, but the remaining bits are not sufficient to unambiguously i=
dentify
> >> >> such pages any longer.
> >> >
> >> > Why not? What values end up in pp_magic that are mistaken for the
> >> > pp_signature?
> >>
> >> As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
> >> And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA is z=
ero on 32-bit platforms).
> >> That means, that before page_pool_page_is_pp() could clearly identify =
such pages,
> >> as the (value & 0xFFFFFFFC) =3D=3D 0x40.
> >> So, basically only the 0x40 value indicated a PP page.
> >>
> >> Now with the mask a whole bunch of pointers suddenly qualify as being =
a pp page,
> >> just showing a few examples:
> >> 0x01111040
> >> 0x082330C0
> >> 0x03264040
> >> 0x0ad686c0 ....
> >>
> >> For me it crashes immediately at bootup when memblocked pages are hand=
ed
> >> over to become normal pages.
> >>
> >
> > I tried to take a look to double check here and AFAICT Helge is correct=
.
> >
> > Before the breaking patch with PP_MAGIC_MASK=3D=3D0xFFFFFFFC, basically
> > 0x40 is the only pointer that may be mistaken as a valid pp_magic.
> > AFAICT each bit we 0 in the PP_MAGIC_MASK (aside from the 3 least
> > significant bits), doubles the number of pointers that can be mistaken
> > for pp_magic. So with 0xFFFFFFFC, only one value (0x40) can be
> > mistaken as a valid pp_magic, with  0xc000007c AFAICT 2^22 values can
> > be mistaken as pp_magic?
> >
> > I don't know that there is any bits we can take away from
> > PP_MAGIC_MASK I think? As each bit doubles the probablity :(
> >
> > I would usually say we can check the 3 least significant bits to tell
> > if pp_magic is a pointer or not, but pp_magic is unioned with
> > page->lru I believe which will use those bits.
>
> So if the pointers stored in the same field can be any arbitrary value,
> you are quite right, there is no safe value. The critical assumption in
> the bit stuffing scheme is that the pointers stored in the field will
> always be above PAGE_OFFSET, and that PAGE_OFFSET has one (or both) of
> the two top-most bits set (that is what the VMSPLIT reference in the
> comment above the PP_DMA_INDEX_SHIFT definition is alluding to).
>

I see... but where does the 'PAGE_OFFSET has one (or both) of the two
top-most bits set)' assumption come from? Is it from this code?

/*
 * PAGE_OFFSET -- the first address of the first page of memory.
 * When not using MMU this corresponds to the first free page in
 * physical memory (aligned on a page boundary).
 */
#ifdef CONFIG_MMU
#ifdef CONFIG_64BIT
....
#else
#define PAGE_OFFSET _AC(0xc0000000, UL)
#endif /* CONFIG_64BIT */
#else
#define PAGE_OFFSET ((unsigned long)phys_ram_base)
#endif /* CONFIG_MMU */

It looks like with !CONFIG_MMU we use phys_ram_base and I'm unable to
confirm that all the values of this have the first 2 bits set. I
wonder if his setup is !CONFIG_MMU indeed.

It also looks like pp_magic is also union'd with __folio_index in
struct page, and it looks like the data there is sometimes used as a
pointer and sometimes not.

--=20
Thanks,
Mina

