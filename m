Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4EACFD369
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 23:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE2A6B0027; Mon, 24 Nov 2025 18:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA56D6B0028; Mon, 24 Nov 2025 18:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBAE16B0029; Mon, 24 Nov 2025 18:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8F266B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:37:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA2154F979
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:37:41 +0000 (UTC)
X-FDA: 84147115122.17.2BCEB8A
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92FE6C000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:37:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FxePWskR;
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764027459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlci1y7yuwyEjVyvyPpVVR5+2jh2b1xf5fgy6sXkeBg=;
	b=J2Zsoc28ZYPgMHM6Sh0tUXe29IhxtgnFepYoP29HOtoFuemxf5VX5tQGt0ANUjTXfH0wV7
	EBm9ZxP9PSbphx/uZ+iDMdataDU4FdFOTDQbOtSr4DVpA1rCly1pPnAJI2rCRAUdMTgd1h
	B5gvsKXrJrvLvjaRl2lOfxKQLdSpfX8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=FxePWskR;
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764027459; a=rsa-sha256;
	cv=none;
	b=VtN3CBDu8flMAEemvih0JOhcKiyEETHNa1MbpMhITNuXKcgfhfimj0S1nfnIhI6aQvV2bx
	i6CiwMXCNe8jxt23ePm+qt1gos9ZoP18ZzQ6aR5khAkj3tvEG5tTzIj9zJHRBElsjLFCl1
	ISh1zSwWAqIjEDJZ+zFLfbnnEwdamEg=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso8730032a12.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764027458; x=1764632258; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlci1y7yuwyEjVyvyPpVVR5+2jh2b1xf5fgy6sXkeBg=;
        b=FxePWskRuDQqCceq2V4xIjwQ+LfPP/5N0LbAIeZ8fq0521KgCbNAIXQ87Qs5l1FtWO
         TBDG8y5raoYKXahvP6EvOeKea3onpu84Fu6V3t/E8mPdNyPM53S3bY6kfT9p3RphSOd/
         nHzWpwp1nH8Tf/tyOatW+w349UaCDkdxX3mrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764027458; x=1764632258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rlci1y7yuwyEjVyvyPpVVR5+2jh2b1xf5fgy6sXkeBg=;
        b=mSf7BcVyO0313VXuGV+Z5sHsQaN0/CU/uouKz6rUWC41qm1QQ1C9xJe5DXZZnGPJP9
         vUcqioTRN1aCBhRGdBy87FxtEstXLFdJsRSHxeus2z2rUl+/BPmT3kvRDvvOXZwdPGgb
         iQ+uwfgRroqENICbfxAUqVI3UapfDPP5qtwxc6JKAlLZCuvpT8BXYeoH1cFGzajPqSTJ
         8fZz3U2ZXkwLUwxqbjUKFPp1F3brINdRmTOlG1GzQ6uRigHzwYkvX9VrMZzMqzuFmEhx
         kd37FLuHUXG3KR+EhOoYpXMbLr0VXBqwaP+bESjjEe5pmED+vO1JmKd8l2Iw3Ck5sQZy
         ztLA==
X-Forwarded-Encrypted: i=1; AJvYcCVqNHnE19IDQb3OhdynbCFdQ5DKGWtua2ZeOcvN7+CBCeHBg3kL2w7eWcKOnLTUjihaRuUdLi7sEw==@kvack.org
X-Gm-Message-State: AOJu0YyYklKnQJ3EQ1vrrG8i5c3b57Ih6Rcq5LLAszNlAUFq0+C9U8Ua
	2nXmO6WnwRVGuL9hYUnnw9Ue8Fs4NPDnJHOrHI4eh9NF/KGBFKyJ8DH+yJf+8/C/n4fvXoRDQkw
	gBcEdbcs=
X-Gm-Gg: ASbGncsStNWALZEa5v7cpkonMmYv2EYVHlfYA7P6AKbmHE3YE5eyrd0NsVD6ZkfmQWL
	2mtX2h//Cv5HKOwnDCeg6KwEY9rAU9gzN98BpcQlzbAiU5GIsSf+7fT7XTFydoq2YwZera4W4Pn
	M/7LviXCYrHuJp1LvL+J8cbW4Kyj1/cIqwIMjuOkcPdpCh39SypDTnjCWocO1rGl9ceQcKBOwoN
	TDmcPECjEP1v6SZ1IXsMjvumFQReN92q1kcluodtBxSxa/bGSdchwiRW6LQAbW4LtBuBsm1uEaM
	1pvE1e3QaufLE/55gsGZ6xxnHFs1lb+sEURxEHm98GPBSW6HSszbC7r7txoLurSi0HSvlQh3BTb
	MzWLaco6BXQykMfQ1GHArSz4b+xsEJ+Vtxu3iBU/NkbN9lvANo+2Y97OoWj7qGtcwy0pEog2DZ6
	e6ZVyJMD3nO9bOanHWxQNEHxlQcCrQHABzzM5MJK7KVuFfkp2oqGYwsrhDrKby
X-Google-Smtp-Source: AGHT+IEs8XZMw6S8F2Z6/m0h21NiyOO5kx9BjsWA3AwwNLepGY1eYJiPspv+Tnw5dkp36FrawAGqKg==
X-Received: by 2002:a17:907:801:b0:b73:7b97:5bfb with SMTP id a640c23a62f3a-b76717053b4mr1310698266b.33.1764027457463;
        Mon, 24 Nov 2025 15:37:37 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdab19sm1503683266b.10.2025.11.24.15.37.37
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 15:37:37 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so8138858a12.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:37:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWB1QQKoYo5rBbzA2aBalIi9s5iwtA4d2COfeGwB0sn+WKt0d8sCe5Q5ge3p/8M3TpOCfjeADJ+pw==@kvack.org
X-Received: by 2002:a05:6402:278b:b0:640:cdad:d2c0 with SMTP id
 4fb4d7f45d1cf-6455468d57fmr11542593a12.25.1764027035833; Mon, 24 Nov 2025
 15:30:35 -0800 (PST)
MIME-Version: 1.0
References: <20251122014258.do.018-kees@kernel.org> <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook> <aSTKLsRNiEKtDqPI@casper.infradead.org>
 <202511241317.516BDE7B@keescook> <aSTRsIUPeT5EC5An@casper.infradead.org>
In-Reply-To: <aSTRsIUPeT5EC5An@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Nov 2025 15:30:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgn-2ieKtaHAXLLge1UFckLKa88vo3XOdLz+fP+DLpHGA@mail.gmail.com>
X-Gm-Features: AWmQ_bkk3_N4a125249CnpAkBAwWzpKOgurGjUm33RHuFAzjc01J9LWjmJhIWds
Message-ID: <CAHk-=wgn-2ieKtaHAXLLge1UFckLKa88vo3XOdLz+fP+DLpHGA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
To: Matthew Wilcox <willy@infradead.org>
Cc: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org, 
	Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Vegard Nossum <vegard.nossum@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jakub Kicinski <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, 
	Tony Ambardar <tony.ambardar@gmail.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 92FE6C000B
X-Stat-Signature: fejgrjxk4d9bigzhm6zy4ay7ac8mtrn6
X-Rspam-User: 
X-HE-Tag: 1764027459-139882
X-HE-Meta: U2FsdGVkX1+m40nO09/GUkysrS0pPHrWBtvuuQyz6DUe++zcBfWN++u3dh4d1jtxL/NPsCRHhDcq4OFoHUdNSvxII62APYVGX2Mu4Veko5sXAYf8TCe33Y3vUqzGQPCHItJeEvz/9nm+bEZRFd1sEmo3hTeX2Le4q5J5A3oDh0amT4O3k6e5Lv6CKijxYJlbVOg9NYparQrpj/vlm24DJTO6AGmlpM4q+xGNTMorHmBxsCD9cRkn2LizvxOORKhA+MAIWkKnJUsBNi/jcoWjcvQMXivyEWOCAIpQuf2crl+dveKqfSPigWIhTWiXli/KhKqINzAnqqm4eGCp7lVAKRaXHnkVC/Z5yMe7qIndKUIu5cxk2X0T+0ERAskJAkUqSknXBYKK40oEWm3/fmppYZSYtlsvZHLBUbNa/6zKsBwhoMTjJtdFUYDChSY+T4O6YGNyTl9gYpVCR1p6R+ICsNXeSX+PRVpA9RMfDR1IKAJ9jH3ShtcwcNYeL4yy5dUiOmAcv6AUhfmO39YOJb+fCiOzFHtBrti/cTArddfQ7+z+EyJIV3U0fxAN7AuLOLrUI1jQkK9/xfuRg+Ae/FQfuozFSJV4RGhCJxcQIVrTV9tC+B+ufUJNiCbWvAc/qThFGE+2/FwEOOABDczJARIVZuyFtwPrTODB6l2udAXQE0mPRWDnDI1pQSeNY6XoLqq7ym1eZFtpq3P/T5n8KJuBb0da2MxXAsZv5r7D0FJ03pvJYB5GgFXmxdmAkZOi2Z2MM1jBciYsdjKrA3Ca/HNmOKsK7nFzYJiGp4yLXF67NH68nmF2qvjAKsxbqeieu/st6H6qkENBIPtA5DD4v5cd+iiE/18qrEMZOiOjZBdURioq5/nJOVnxqp+4OqX71XwQgccCOjUqcjUcTEUn8tESZX8EuFGzurgu2YtIJNxCwYKukSZlZGDv2buuXD70mOLE0alF8jb0dLdTowh6YpU
 NOjX0XBa
 DsGy1xMqbooKQZJTLHmdbcf705dAmzRNhIGs4COFuQ/8Z8Uqy0qmklTNfXoAV5OTFKQ405hg7+zlPdodnQl2WJZ6N2VbK6pLAUTycG1hdeqU5IT+6faxOB9IoLzSS3afNBGoKIzsk/goEbyitl1E+cVxRzScJhOo6EsHZwdVRO3dzvgHj6KTMmp6WehiGyxTl5bsbvrw+3Gn/WWJu6J6RgfweacbDF2Dnv5QYgqqrCRgtKVagQiPhFA3gEQKAdmqlPzJBWgbWcxYRUJZ95c78FOBjq7kkDIe4axM9aSjAYivePpRJyDHsZezwvxZ5o/HHi0klaknxddiIxZ4XEXAIC9edvzN4ScqaL60n9jPg9ARRFS/r2VGuR3FzkO99oPXLEP4P+6Po6sBy4vho6r+dL618nVB5y4sf70l01fSSZ7WnjBD3bRnwAtym/pGd5bbERYxmB8lOZ/q4tW6R+nOp+n+kxtbbIEcWiFtBkQrs7gfBwCWwV7njp/T/QoukslGP4cBnzIcnXgJRuAzfzuJJ9EyoGSAZaztKSgB/3/BOMXF2bYepcs4NS+innls1wO5ltvjSl587AGfuTbaSb1xNjHg6wfBOCD32LOjSknr21OIJXXs26M7HRf1N4yCMr+8IrEDzhccJPz191qDnNVRqgVTsKfFiJToCr1SfmoTfzBN2wntKTTqVAhWnsCek3LnqlbdP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 at 13:44, Matthew Wilcox <willy@infradead.org> wrote:
>
> This third one is interesting.

Why?

> include/linux/jump_label.h:126:44: error: conversion to =E2=80=98long uns=
igned int=E2=80=99 from =E2=80=98s32=E2=80=99 {aka =E2=80=98int=E2=80=99} m=
ay change the sign of the result [-Werror=3Dsign-conversion]
>   126 |         return (unsigned long)&entry->code + entry->code;
>
> static inline unsigned long jump_entry_code(const struct jump_entry *entr=
y)
> {
>         return (unsigned long)&entry->code + entry->code;
> }

I'm not seeing the confusion. 'entry->code' is a signed 32-bit entry,
and we're adding it to the address of the entry itself (well, the
address of the 'code' member of the entry, but it's the first thing in
that struct, so same thing in this case).

The next function in that file (which uses "target", which is *not*
the first entry in the struct) then makes it clear that we actually do
all these relative offsets relative to the address of the relative
offset itself, not the base address of the struct.

But that's actually just a random implementation decision.

That all a very standard thing in assembly programming, which this is
all about. 'entry' is a signed offset from its own address.

And yes, the exact thing you are relative to may differ. When looking
at instruction sets, sometimes the relative address is relative to the
beginning of the current instruction (I think m68k did that), and
sometimes it's relative to the *end* of the instruction (I think x86
does that).  It could even be relative to the actual byte *inside* the
instruction, although I can't think of an example of that.

Sometimes it's relative with a shift (basically all fixed-size
instruction CPU's do that since instructions are all mutually
aligned).

So that's whole "exactly what is it relative to, what are the sizes
involved, and are there maybe shifts" etc just a design choice.

The whole "offset is relative to its own address" that this code uses
is probably the simplest form it can have.

> The warning is ... not the best phrased, but in terms of divining the
> programmer's intent, I genuinely don't know if this code is supposed
> to zero-extend or sign-extend the s32 to unsigned long.

What?

A signed value gets sign-extended when cast to a larger type. That's
how all of this always works. Casting a signed value to 'unsigned
long' will set the high bits in the result.

That's pretty much the *definition* of a signed value. It gets
sign-extended when used, and then obviously it becomes a large
unsigned value, but this is how two's complement addition
fundamentally works.

This is bog-standard and happens all over the place. We have things like

        unsigned long xyz =3D -1;

in various places, this is not some kind of unclear area of the standard.

And for all the same reasons, the programmers intent is obvious too.
'code' is s32 and is signed for a reason - so that you have a +-2GB
relative offset. And this is not some kind of unusual pattern when
we're talking about relative branch targets.

Now, if you don't know about things like relative branch targets in
low-level assembly, maybe this is code you have to look over several
times, but this code is literally ABOUT re-writing branches in
assembly language, and this kind of pattern where you use relative
offsets is traditional.

And yes, the offsets are literally smaller than the address space, and
the signed offsets get sign-extended as part of this all: that's very
traditional too.

Basically no 64-bit CPU has 64-bit branch offsets (and few 32-bit
CPU's have full 32-bit branch offsets - x86 happens to do it, but most
RISC CPU's tend to have branch offsets that are in the ~20 bit range
and if you have big relative branches you need to do those with a
separate constant section or something like that).

So honestly, what's the problem with this code?

The warning makes no sense, and is garbage. Are we not allowed to add
signed integers to unsigned 64-bit values now, because that addition
involves that cast of a signed 32-bit entry to an unsigned 64-bit one?

There is NO WAY that warning is valid, it's; not *ever* something we
should enable, and the fact that you people are discussing it as such
is just crazy.

That code would not be improved at all by adding another cast (to
first cast that s32 to 'long', in order to then add it to 'unsigned
long').

Imagine how many other places you add integers to 'unsigned long'.
EVERY SINGLE ONE of those places involves sign-extending the integer
and then doing arithmetic in unsigned.

                 Linus

