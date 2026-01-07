Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C92D8D0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB196B0092; Wed,  7 Jan 2026 16:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69286B0093; Wed,  7 Jan 2026 16:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B1D6B0095; Wed,  7 Jan 2026 16:48:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDC3D6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4159357D51
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:48:06 +0000 (UTC)
X-FDA: 84306506172.29.9AA7CF4
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5179380011
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:48:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=schCRv+P;
	spf=pass (imf30.hostedemail.com: domain of maze@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=maze@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767822484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Xuw3GyJneoJXhtItWJQfrXCpjg3jylhpc8+LuV20Gk=;
	b=syWTwsiP1mBgopD6iv4lNIF6p17+Pn980NKK4yZU0wvNxVhWHkxGo5GpHmCFxAjaDB7Ns5
	XTQb9xLU+0YsFiM5myXFtOjQ7CZDSm9I2fqdpqBAfudDCru93tQg2Rm5Bqalxw4jRQk3RN
	HTVfRG2NM3z2mzpj56AIb8P0Al0oXwU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=schCRv+P;
	spf=pass (imf30.hostedemail.com: domain of maze@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=maze@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767822484; a=rsa-sha256;
	cv=pass;
	b=8RP+m8CpJxrC03+eDr8pHd9XB3exWNDNEpIeGOFqimbGwIaI9x17i4nSofBDsVALWcedKt
	Iv+NLmhHMm1YZlIQLuQwxnjyHSus/gDi9cG2w9Om6XCLsnZlfnOwXZwnALWP0Ylfch+w3t
	VqD8j7mhXqujFVa2qa4Oev/Ano047gA=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ffbaaafac4so411321cf.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 13:48:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767822483; cv=none;
        d=google.com; s=arc-20240605;
        b=APrAymo4Bkpn01GZBGQxx8zd8dHg5ReTcjmw8E8/SdxeeaAINy23oGD1wtbAkptLHa
         KH9XVwp+vhSbAA2orFSZZS5+U2n4lqFGFSpGqh5Q60iIPOsl1G8//f09xpb1Ax4jSLLX
         4+YftAbvmX3lQWb2BAuTLBx8/RecIenAIyYSIkuvWutyzq6oQQVKNdn5XVQsVoMWoJOz
         DR5vXmAzRlOpoYSJjxOY8WF6fA5LDf7wIvOqQbSRLyk2UOGXbBiPMEbuLkfihJLKlZ1K
         yxQg727vBQ8Zr7/HNxIe2U/WmHnu/8ZvS4rxFFm5SQpxhSrHbexlQuMCmhDAANeVZBmk
         1yTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2Xuw3GyJneoJXhtItWJQfrXCpjg3jylhpc8+LuV20Gk=;
        fh=zlYCz+TP5nI9dgjo/L4NIVlGkyvau0d6o09TItsuNvI=;
        b=QE5t/1he10Xa+w05ZjVkoLwse4SwIcNH5gvzj1Ihno2Hrg8R7kjz6gqJC0yln8HLhM
         8VaSaoTqA4zJJ959XAUSvkDdvfir+n9KHq4p/HS+uIUGmaYgmAg3cD7ncp/XD9OuPsfE
         2Oikc9YyUUkJX5Q1drn7yB4a6vTxNelrt6/tvD58gIXbO2IDq0pihjCngPx70s94lDl/
         MldErzAxCfZja7WxjNjAy6OpXhjyJ3q4XMYnZw2Cx9RATpy590Ie6IT+UrI+OqMKoD5o
         LN+VsM++Nmrhw+X2bzYciS0tQNTRCZ3Oy/eB9JjRsNjO1S09yooPTP232Rz21H5h8kIi
         O88A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767822483; x=1768427283; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Xuw3GyJneoJXhtItWJQfrXCpjg3jylhpc8+LuV20Gk=;
        b=schCRv+P8GQcluobknXmTbx10RDODh5eySfICLTOhJoiRDj06e9UTHyKtUms/htMIG
         c9pYlYOL92dNxt2Q9PQW+OQwEoYy21zd9mMG17p3ZFte4AdosWRdeLS3IM7eMvhu8Cro
         AGBIa5RZKoA8UEJ7Rp6M2qLa3iMJWf6sURcyW1vuWk1jjeCFaz5IN7ye18LqKAVdmedh
         R59DrOMzlPTojSvSN5al2tRkfBP9zJUO95aoagYy+N0gsm2ohizUb+3KwKhq2s7t467R
         wqpUiwH2l3I8RZV/TA1wUBBxAEYCcoVwki3w4ZmXZUZjyuSz4SNzM8eUxFBggEOHkUke
         iH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767822483; x=1768427283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2Xuw3GyJneoJXhtItWJQfrXCpjg3jylhpc8+LuV20Gk=;
        b=drCt9PVihPnvXKFVvLS1uUFz1hWRtW8DXLXINYQnBq8tAsW1y/VZE64BKhXPMYJRXJ
         KewFSQNK2kBruR1v+iyqok2GtjnKcqpnGwMiEJVNc6u7j9Q8p00c9nN9ygxEHgeTbG5y
         952lAj/dyoG4xTUUOYRSY9urMwqx7Cwcbom6oEZYVEob+eN4Hwcwdei/o0T/IZBIUA5S
         miVm3VfR+tmdHSj8N0j2RwRf5cBjvPssjXQX123bGFb6sTMmEK4VFNQqDN4kfNYRIBMz
         3wdqZKL+ZcEH2h2785Sth/beTM3Z5n422FdYqHpTMYO4qpKG6ApjxjIoFfU+KtvDgSi+
         NVIw==
X-Forwarded-Encrypted: i=1; AJvYcCUCDovNX1vuuWA4xiY+Dt/jAVDKYH/CVcRuQ9aSyPqaaC/WMLxXz3HbGRye93dF6573v6cgH0yrew==@kvack.org
X-Gm-Message-State: AOJu0YwLEHsVA6SazmvoaFmPr7TKiovXIhygRwm/Puml62ovqGw+CZvr
	qNX8iEN0mZZnd0RgZQMwUWUT5d9SYViC3+2xmurSaTd/Nfq34SU0Boi/WdpFo9rZy+skAfWZlqc
	ALNyiJjdJQrqjlqVrNHcyey32rC690Tf/fDK/gKw8
X-Gm-Gg: AY/fxX44pZGaaIrWbz73ja9XSfebfRf+OIewRTFci+diIppj8YtBOV0XEwVTfdmWUvZ
	vyjx9gMTRf/Liz+WiBHum9g9VTM29WmguL/Ar4cYcW1RSoYmLHv5oSe4/J3D9skPq5lLAAobA3t
	Ug5W344pJyxkmiPr5tT6zStoFq8nsHjSKzixGVHLdFmXEjWJAITz7tTiSKk9NYXzr5U8hiWY7se
	HXz0LKPOKeJ+A6VNV7VIuVmZaIpj3q64FOkKZ7tIjWCN9P12cDfCFVxx6my6Oclq+OQ9IynPT0u
	EnRKEZ12z5vuulws26+9uABxexFVI4nabG4jZNM=
X-Received: by 2002:a05:622a:146:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-4ffc0974a7emr382701cf.14.1767822483032; Wed, 07 Jan 2026
 13:48:03 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <202601071226.8DF7C63@keescook> <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt>
In-Reply-To: <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date: Wed, 7 Jan 2026 22:47:50 +0100
X-Gm-Features: AQt7F2oLlltuoY9YvVgls7adU_ueUzLWJwptnTTXOpaTyMJmGfkWuXu7CND03a0
Message-ID: <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com>
Subject: Re: KASAN vs realloc
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Kees Cook <kees@kernel.org>, joonki.min@samsung-slsi.corp-partner.google.com, 
	Andrew Morton <akpm@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, 
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5179380011
X-Stat-Signature: nq4it1c6gnx5w95mp3aaxzbj9espkz9p
X-HE-Tag: 1767822484-10499
X-HE-Meta: U2FsdGVkX1+6mJyDTlLX66v+1Or/zcxdSuAu8GmkJKPkHZead726b9+BdA5L3z0jAgkI2lpBH/C8kLNCVBhGIYZNS384KFnN6eoFitJ5+De2FrixWDpbUDCqiGi/WMTDH/iqlfaIoqAPAukNV0buc8AHlCnnLikh+2BkyFAkiox79JP99FUh83tovHOzlfLEVVg4yyzmnhRKUMSjHYy5sgUk4qvyZdM68hVBi9B6aX6C41NO5D/fdifkeOX5FF355Uhjy5Uoes9k9vOKkBFQjWxaSG9GTcIleWjDs5abqa8NFSSqemm/krZSTUYW80e5Hc6HA8fOHJX51Mxg9Ch2fhwn9pi3gNtgSIXzXXD2yhH6PlQZh3L8WJg5htE9vzdWc1B9txYN9CPqGFHFZ1C2MtFC2XgXRSHw9yT+wfZIhA378K2cFWfIus9PRulTZmF6CZS2Rn7aqsUwlxaRqWJHxgbrMGJBEclVYbaQ+eL6RhzbtX628BXHLwLm8mZSdV0je+vHB+H28S5KXYYk1rwmunxADMbKRqmo6t0i0o/kN8qdQUCFt4XsU62PoIOCZ2EN/0fvXYrxHvlFZ9TX0KLWiH3qu0fT69hggaf9fCCcY/F+nxWrDGwXo1Exrk3OJhAWmPUsaix6z/GkW9QYvGrtQz+wHLMuNlXzYuCcycKRp4r7l9XR6dixY/ZNbcoNobLw1CCIuUp3fyxxhttvYsJcyjNKCWTuvq7lnQeLxwHcM0QIgMpIv9zeMYBW7FAPsD/ZIR1qbLXZ0XS7/wEuj96639RqaP/yf2o50rKox+FeQAkFuGfwKaIVQPZ2O89aiTtgpBq6qOLcubdPKtOENW0ks3h4U0XmoggAzn//rlLK23vEVX5h7A6VDwm1Bq33qJY7SM7dkwfHLlLhVxGvVby05iKzFq5kauDaZCLHVRWp5iqWJ3Jwl+czK0xRuY/4B4YqeDKLJO8Ga9sRVZgM6n6
 SJCt6WlP
 gA5L6lm8rOjGxEZpPEzX4fVBmVy+wbQfQ6KUDb+mISgmWEZeLJ2L3sY6jpA+oPRby6haVkINd/Vf0J/4oztaduiyqR7aSqspY39n8hNsOYrlS0AlwPP6UMHTJlbzQ4ETBVVmPyssYnaT9tE9ihciCHtVttdkaq2GN8oGJACt9HVJqlscbzqW+fSy6hERYZ+1Qv3W/dpthSguhiQkpRKniIpYtx9o4dOZl4ML5z/1pNwRwDodHAo88rT8qygW+mG935wioML8wiqFzH0UQz5+3noBba8CDcEWEGy6Jg+zJSS+735mfEsiG4M31VEKCJ5GNYHmH9vVf83zscIbRz+GZ9CIjmTHvNcofX/gG5xIqHd59+JT0odsohM5vEiq4goObJY95HnkbQnPX5k242QULjiPWFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 7, 2026 at 9:47=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> On 2026-01-07 at 12:28:27 -0800, Kees Cook wrote:
> >On Tue, Jan 06, 2026 at 01:42:45PM +0100, Maciej =C5=BBenczykowski wrote=
:
> >> We've got internal reports (b/467571011 - from CC'ed Samsung
> >> developer) that kasan realloc is broken for sizes that are not a
> >> multiple of the granule.  This appears to be triggered during Android
> >> bootup by some ebpf program loading operations (a struct is 88 bytes
> >> in size, which is a multiple of 8, but not 16, which is the granule
> >> size).
> >>
> >> (this is on 6.18 with
> >> https://lore.kernel.org/all/38dece0a4074c43e48150d1e242f8242c73bf1a5.1=
764874575.git.m.wieczorretman@pm.me/
> >> already included)
> >>
> >> joonki.min@samsung-slsi.corp-partner.google.com summarized it as
> >> "When newly requested size is not bigger than allocated size and old
> >> size was not 16 byte aligned, it failed to unpoison extended area."
> >>
> >> and *very* rough comment:
> >>
> >> Right. "size - old_size" is not guaranteed 16-byte alignment in this c=
ase.
> >>
> >> I think we may unpoison 16-byte alignment size, but it allowed more
> >> than requested :(
> >>
> >> I'm not sure that's right approach.
> >>
> >> if (size <=3D alloced_size) {
> >> - kasan_unpoison_vmalloc(p + old_size, size - old_size,
> >> +               kasan_unpoison_vmalloc(p + old_size, round_up(size -
> >> old_size, KASAN_GRANULE_SIZE),
> >>       KASAN_VMALLOC_PROT_NORMAL |
> >>       KASAN_VMALLOC_VM_ALLOC |
> >>       KASAN_VMALLOC_KEEP_TAG);
> >> /*
> >> * No need to zero memory here, as unused memory will have
> >> * already been zeroed at initial allocation time or during
> >> * realloc shrink time.
> >> */
> >> - vm->requested_size =3D size;
> >> +               vm->requested_size =3D round_up(size, KASAN_GRANULE_SI=
ZE);
> >>
> >> my personal guess is that
> >>
> >> But just above the code you quoted in mm/vmalloc.c I see:
> >>         if (size <=3D old_size) {
> >> ...
> >>                 kasan_poison_vmalloc(p + size, old_size - size);

I assume p is presumably 16-byte aligned, but size (ie. new size) /
old_size can presumably be odd.

This means the first argument passed to kasan_poison_vmalloc() is
potentially utterly unaligned.

> >> is also likely wrong?? Considering:
> >>
> >> mm/kasan/shadow.c
> >>
> >> void __kasan_poison_vmalloc(const void *start, unsigned long size)
> >> {
> >>         if (!is_vmalloc_or_module_addr(start))
> >>                 return;
> >>
> >>         size =3D round_up(size, KASAN_GRANULE_SIZE);
> >>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
> >> }
> >>
> >> This doesn't look right - if start isn't a multiple of the granule.
> >
> >I don't think we can ever have the start not be a granule multiple, can
> >we?

See above for why I think we can...
I fully admit though I have no idea how this works, KASAN is not
something I really work with.

> >I'm not sure how any of this is supposed to be handled by KASAN, though.
> >It does seem like a round_up() is missing, though?

perhaps add a:
 BUG_ON(start & 15)
 BUG_ON(start & (GRANULE_SIZE-1))

if you think it shouldn't trigger?

and/or comments/documentation about the expected alignment of the
pointers and sizes if it cannot be arbitrary?

> I assume the error happens in hw-tags mode? And this used to work because
> KASAN_VMALLOC_VM_ALLOC was missing and kasan_unpoison_vmalloc() used to d=
o an
> early return, while now it's actually doing the unpoisoning here?

I was under the impression this was triggering with software tags.
However, reproduction on a pixel 6 done by another Google engineer did
indeed fail.
It is failing on some Samsung device, but not sure what that is using...
Maybe a Pixel 8+ would use MTE???
So perhaps it is only hw tags???  Sorry, no idea.
I'm not sure, this is way way lower than I've wandered in the past
years, lately I mostly write userspace & ebpf code...

Would a stack trace help?

[   22.280856][  T762]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   22.280866][  T762] BUG: KASAN: invalid-access in
bpf_patch_insn_data+0x25c/0x378
[   22.280880][  T762] Write of size 27896 at addr 43ffffc08baf14d0 by
task netbpfload/762
[   22.280888][  T762] Pointer tag: [43], memory tag: [54]
[   22.280893][  T762]
[   22.280900][  T762] CPU: 9 UID: 0 PID: 762 Comm: netbpfload
Tainted: G           OE       6.18.0-android17-0-gef2f661f7812-4k #1
PREEMPT  5f8baed9473d1315a96dec60171cddf4b0b35487
[   22.280907][  T762] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
[   22.280909][  T762] Hardware name: Samsung xxxxxxxxx
[   22.280912][  T762] Call trace:
[   22.280914][  T762]  show_stack+0x18/0x28 (C)
[   22.280922][  T762]  __dump_stack+0x28/0x3c
[   22.280930][  T762]  dump_stack_lvl+0x7c/0xa8
[   22.280934][  T762]  print_address_description+0x7c/0x20c
[   22.280941][  T762]  print_report+0x70/0x8c
[   22.280945][  T762]  kasan_report+0xb4/0x114
[   22.280952][  T762]  kasan_check_range+0x94/0xa0
[   22.280956][  T762]  __asan_memmove+0x54/0x88
[   22.280960][  T762]  bpf_patch_insn_data+0x25c/0x378
[   22.280965][  T762]  bpf_check+0x25a4/0x8ef0
[   22.280971][  T762]  bpf_prog_load+0x8dc/0x990
[   22.280976][  T762]  __sys_bpf+0x340/0x524
[   22.280980][  T762]  __arm64_sys_bpf+0x48/0x64
[   22.280984][  T762]  invoke_syscall+0x6c/0x13c
[   22.280990][  T762]  el0_svc_common+0xf8/0x138
[   22.280994][  T762]  do_el0_svc+0x30/0x40
[   22.280999][  T762]  el0_svc+0x38/0x90
[   22.281007][  T762]  el0t_64_sync_handler+0x68/0xdc
[   22.281012][  T762]  el0t_64_sync+0x1b8/0x1bc
[   22.281015][  T762]
[   22.281063][  T762] The buggy address belongs to a 8-page vmalloc
region starting at 0x43ffffc08baf1000 allocated at
bpf_patch_insn_data+0xb0/0x378
[   22.281088][  T762] The buggy address belongs to the physical page:
[   22.281093][  T762] page: refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x8ce792
[   22.281099][  T762] memcg:f0ffff88354e7e42
[   22.281104][  T762] flags: 0x4300000000000000(zone=3D1|kasantag=3D0xc)
[   22.281113][  T762] raw: 4300000000000000 0000000000000000
dead000000000122 0000000000000000
[   22.281119][  T762] raw: 0000000000000000 0000000000000000
00000001ffffffff f0ffff88354e7e42
[   22.281125][  T762] page dumped because: kasan: bad access detected
[   22.281129][  T762]
[   22.281134][  T762] Memory state around the buggy address:
[   22.281139][  T762]  ffffffc08baf7f00: 43 43 43 43 43 43 43 43 43
43 43 43 43 43 43 43
[   22.281144][  T762]  ffffffc08baf8000: 43 43 43 43 43 43 43 43 43
43 43 43 43 43 43 43
[   22.281150][  T762] >ffffffc08baf8100: 43 43 43 43 43 43 43 54 54
54 54 54 54 fe fe fe
[   22.281155][  T762]                                         ^
[   22.281160][  T762]  ffffffc08baf8200: fe fe fe fe fe fe fe fe fe
fe fe fe fe fe fe fe
[   22.281165][  T762]  ffffffc08baf8300: fe fe fe fe fe fe fe fe fe
fe fe fe fe fe fe fe
[   22.281170][  T762]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   22.281199][  T762] Kernel panic - not syncing: KASAN: panic_on_warn set=
 ...

> If that's the case, I agree, the round up seems to be missing; I can add =
it and
> send a patch later.

