Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6290BCFD371
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 01:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB396B002B; Mon, 24 Nov 2025 20:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1406B002E; Mon, 24 Nov 2025 20:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7AE6B002F; Mon, 24 Nov 2025 20:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0786B002B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:25:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16446896B4
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:25:50 +0000 (UTC)
X-FDA: 84147387660.10.64E8471
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id E5B421C0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:25:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=hPXNlz0P;
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764033948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqKMRjrSvi+tqRWkNIWke9++rsIS8F7SgGKQGWYYtJA=;
	b=Jze6UaRWrtR0Iu4dolGMPfVu1oJHvyp1tqg7FW+J1aTrDkO1XxCpqQljQ+rnArRSm/L1A+
	yO6FvgQAstBJYWXyNUsZ1/T/jEApkY7yB6SEBDkfBOxFwZ5Xp+HI1ZaH7CQT04zocXphT1
	Ss1D1HFHLgVpRk7sHJ7kX/SFSI7DbOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764033948; a=rsa-sha256;
	cv=none;
	b=NfmAHX+VtOCqE0+APD3m9kbmzepZ/T212Jg44NgpPLTg/L7GCjgnlA8QlCqeljbalFaeVT
	5IOoRYcpgr7CutGsDEn0glmIMOBVhODPles7xYAACMAwwFyNbAPNoyC69/xL7/XxMAD30a
	qQmQwPT2gOFNs0EiQLlWA2JRzLUVBnU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=hPXNlz0P;
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b73b24f1784so371910666b.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764033946; x=1764638746; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tqKMRjrSvi+tqRWkNIWke9++rsIS8F7SgGKQGWYYtJA=;
        b=hPXNlz0PrYpE8nsUPIi58hW3cXsUFdvj3kJn4oHOWoVYhH34q7JM2j+rGBdHdKbLhN
         /0pplqA3muivZ1buK+ZEiHG3wN6NsKOD27EOIsQ9k0mYcj4BhIab0QWgZ4gAJBO7hkYH
         EIXyd7mmQ5nlxhikdeXpd3KqPkbg2DgRBsI0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764033946; x=1764638746;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqKMRjrSvi+tqRWkNIWke9++rsIS8F7SgGKQGWYYtJA=;
        b=Hn0u9Mo5GSpPX7DjqR8AEYn5JQOrFFiLgY4n1u4wV5I4qYjbnNw7PwV30sOjKgr+7s
         d7+uPBsqsoc8EArnKjAkcaqF8cbQqYkaon9IWDtmI5MojGb7lpWaGfnMrnlzxt0Jfdza
         JqJxT2NIKlMCAY911ABEkFPoD5YGHi8cNaRZY6TNyR5obSLbOf2GJzBVtHsbmnzQj2/X
         NYfAbrEoyGS7DdxTbtCRa5c3v5BdemN9qReJ+QYy0MMGvB/zol35RQk7ePCRrk1P5ydJ
         ZejZv5P4toSXHbH6PBR+PC0bDAyr2qS10zwSYHifXWlJxqt8N1+LnqgGjA0T7DIfzuTd
         LCqQ==
X-Forwarded-Encrypted: i=1; AJvYcCW34aPuG4CcdD6Bbvn/a2IEuMEMV20X1g/C5LrBL3ZJn7zjdDP+/YClbP/XdAu5d+KVLhXBx4qHsg==@kvack.org
X-Gm-Message-State: AOJu0YzbOCZCK/m1/83Dj1i4MSiiGx6oPlk9rEFjYLqB8ZMeLrRTk9HE
	J2CySj4af1PkikLSfnfbsNw7jPeBDsqUmaWAKA0RN58pYisRGCmsXUPdRHWY1mQbBCW7E4wSccq
	M7U3A+wQ=
X-Gm-Gg: ASbGncsPrrlhExWX1JeDtd8O22QRlnSa3z1Tpc2x2872asYCJM1thhd44AOeQVJjuda
	soPuxnHuT3yKMFwmsk5ZeNTWJqymLW0NbCpp3/sNTDUflX/BV/BGt0E/jzxw3xSB/RTsL/Bm4Hv
	M2IB3V/CO6GT/SgdsM7qQ86Ti4GZHZw8o+uPNTeF2YaSA+b3eNcLhRsBTjCTsgU/zd7nWggrcQD
	O9SWp3qRu7NFvDAD5nCLu2lHMr+78QVvYzObvIsAZKdyvYfuaJd+OApLSAtEUyvtSA2GmWA4IzU
	k0hSTA/dFjZBvWo674WO1pV/RcoZ8Ki3HqMe0vCinDfZgYQLIHiZxTML+9qo84HPEpThs4JOMPz
	sFRK71XFX9OK94vYscz7ydY5M+mGYEAwDe5ZL5dRgSSFwvJRYJZuQZBNjzSowfrahPP5iSV44Qq
	I94rsybDfmbG8vXMrmPJATRE6eWq2HOewxKCE7oTlf9ANV6gE42m7SguHogiXa
X-Google-Smtp-Source: AGHT+IFTs4HQ6abJnUd1QjizvoTst2B5HPSunTVnOjDw1OeUXi4ThwWARr8WVydprzCK0Aea2m5D3Q==
X-Received: by 2002:a17:907:3c8c:b0:b73:9fea:3315 with SMTP id a640c23a62f3a-b76572b24d6mr1471933266b.24.1764033945783;
        Mon, 24 Nov 2025 17:25:45 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654d73430sm1457951766b.24.2025.11.24.17.25.42
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 17:25:42 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b735b7326e5so1010365066b.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:25:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXWAT6G7V8SdSgJkdAChxCPuvbQV/7QgkUYzqmJLYnjhGrUPt6hncn47cIZBR2aV/wrVqNiOKa/jQ==@kvack.org
X-Received: by 2002:a17:906:f20b:b0:b76:b791:b58f with SMTP id
 a640c23a62f3a-b76b791b623mr277396466b.0.1764033941841; Mon, 24 Nov 2025
 17:25:41 -0800 (PST)
MIME-Version: 1.0
References: <20251122014258.do.018-kees@kernel.org> <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook> <CAHk-=wikqnc16e7yUTJuqnc5f4rL+y_-JpRzCLRu9WPnt3nmiQ@mail.gmail.com>
 <202511241612.6CF90E9@keescook>
In-Reply-To: <202511241612.6CF90E9@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Nov 2025 17:25:25 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh7jG7vUqY2JjkJmjxOYzXR+iUARN6W908pCVfmyprSvg@mail.gmail.com>
X-Gm-Features: AWmQ_bmW9etMzrFCL9DwpEr0x6CUkdioyCuxtdBlodJu1UMrkK3czrKtVUGlZJ8
Message-ID: <CAHk-=wh7jG7vUqY2JjkJmjxOYzXR+iUARN6W908pCVfmyprSvg@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org, 
	Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, 
	Tony Ambardar <tony.ambardar@gmail.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ozhztndr67rt1zhbjbpziwmnmoyqhize
X-Rspam-User: 
X-Rspamd-Queue-Id: E5B421C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1764033947-891812
X-HE-Meta: U2FsdGVkX19vJgb7yiwGWMCFIauz2ebSz/lFme8jixWb21NOzBVgs7WR26RB7H3XMfDCfoaePwMy3tsgOTmpIG6xIPlVH3mJr5b+V+CoVLsnoeb8M6/5LvZOAv38ueReaPzpa63ziIz9NIXdkzDrG5cJEwxcKIrf5DmzJUuwUn2uIh1wgHSCMxqAVbqdHYvCxUuJUPBhLYIhbDZO6IyHgdV+5q5wdbCIvsJINGK0oD34hO+np1wL4VZKgSYSpGazZHTwM5QOAJDw2hXzuvwwsYyxISIC6DVXv3BRI6YIgN/gEbPBVPisFl/kGi8RaDXDR1Y0WPcD0fAqb7y0gIaPxLdHQUbYXNaO6VRoXHt4TnI2Nq1XxalYW/DhVe7l9y/RSOhVz22WGSDxuhxD1YH4P6IJUDBIfBmMUKoKryxw1BXGb1OrednCuNlzvk53WFEU8XN/xMgR2w+4FUh3F7v6o2HtY13exbFHsLZDmpU9xJQSHv0gwbsBiv+NuRR3wO4v19OoSSz+Ndlc+dB3YLLfngNDFiPC/arPExi60n6yIkDzWPK8AsTm3NN2WnKLKLiQk2kbokUmYKzKeYBWui1kBHOMR9qKMmqx7SoDpRraRwAqKWljikVQliDv5VlPdrlGChBcMhJnw9zNHPUDehWqZ4KPINX/lIwwfhVXTQGUBfKD5KrnbqgqgdSA2a0QoR7zJLePHUF0B1GqQj1nW384nhL4akQMFqEhzswIzyi9gvzBcY03QZs55gnXlMF9owlfPsUgMUA/kRCf6dgFYDLoeXp2EvnJHr9lBDW2osh11zSTAMLauRTvO6756XauItT2MphAbM3izbwVtjh86WH1U9iQWZbn7wQBFN/31WQYC1h86BiJzISfJyBT8Mz8JbhBaW4KCGaS+6ElVXr+RGSmllho1eRuRfbeoHMaSrBtXZY5X+9l9HiiKFzXXXP9a7XG2mWCE982BOlLDcnfFB2
 NsCc8zIw
 GVFWDP0rCgIpXTkvlsZQuLdqYsqj/jVf/4J4jTKi4f2ZxRD6Ju3qFv0v4VyiCu7lRH7xeXcBtGgIijHWOJsosj9DHY2oEh7CI2hui54RiqLHssdnQlnuciQyAQsXVwJuJ5rONSG+DYXlOd+EHKSn9QU3s22jiVLcAhQkyor4oMEQlyQPwDQKQ+8qypM64QQlMLk6mQ5S9mg1LI2Wso5R6R66266ZMgL0ovzDVRWV5PUM6xmOriW34rGkBsT4nQ/36Y4C/8YDo5dpekmf5vXXwdnJBWh97gDLYs5e6LQZEkQVK/piBkapLE3UbRRmj1t1oYDKFPU36HMXvVeJDYNEl9ZEd0vV82VnhtciZt3snEHDXrxh0qS3HLbf00pSDwWPmo2vWp5eZ3yz2FJoFjQ+Lua0UBmA1yBNz3Z1qBz5rk8j96s6bGp0j14mfNpCKYDKI//VvfLUDfcEAM4tOCggvD7QWg1a5imd7OwCvXHRHN+adFlPgDork+u3ggQKe/+wJFJKZ89+y8vQXeXPkp7jRAzdcaXVe9hbmFuozFF5JUQSi8nMAQ2JuWAMYzig1/V1NjZ5qXtaIbTN1G999TLrkDZC1c7+lhDWJYuFaBTFKTrV+xwST2WaV0x8xFf8atOPVizqfUs7eTfVfIpiQ3viomhvp4qLJ3VJiPVk9G8x9DeSKH8GlbvlJ7uEMsBdW77J5Udab
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 at 16:29, Kees Cook <kees@kernel.org> wrote:
>
> On Mon, Nov 24, 2025 at 01:35:12PM -0800, Linus Torvalds wrote:
> > Those macros are illegible. And 99% of all users DO NOT WANT ANY OF
> > THAT COMPLEXITY.
>
> Okay, I think you're saying "I don't want the common helpers to include
> the infrastructure for supporting the ..._sz() variants"?

I don't want the macros to expand the code more than necessary,
because that just makes everything worse (including very much my build
times - which have gotten worse over the years, but historically my
build environment got faster at an even higher rate - that is no
longer true).

I also want the macros to be somewhat understandable.

Yes, we have some macros that are works of art because they are *so*
obscure and are fundamentally hard to understand because they play
games with really really subtle language semantics.

And then I enjoy them and appreciate the insanity of them. I still
think our __is_constexpr() macro is truly a wonder, but we do have 40
lines of comment (!) for that one strange macro.

But this was not *that* kind of hard-to-understand macro. This was
just overly complicated.

> Fair enough. Looking at the treewide change I prepared[1], it's less
> than 1% of those mechanical replacements:

Yeah, I did some numbers on my simple version, and just the three
simple ones were the majority of cases by far.

I also believe that when we're doing more complicated size
calculations (ie the whole "struct_size()" patterns), then the
advantage of merging them with the allocation itself is questionable,
simply because it takes two different pieces and makes them one
*compilcated* piece.

Doing

        size = struct_size(ptr, flex_member, count);
        ptr = kmalloc(size, gfp);

is basically two fairly straightforward things and easy to understand.
You can *scan* that code, and each piece is simple enough that it
makes intuitive sense.

No, 'struct_size()' isn't exactly a very intuitive thing, but written
that way it's also not very surprising or complicated to parse at a
glance.

In contrast,

        ptr = kmalloc_flex_sz(*ptr, flex_member, count, gfp, &size);

does *not* make intuitive sense, I believe. Now you have five
different arguments, and it's actually somewhat hard to parse, and
there are odd semantics.

In contrast, the simple versions that take

        ptr = kmalloc(sizeof(*ptr), gfp);

and turn it into

        ptr = kmalloc_obj(*ptr, gfp);

actually become *simpler* to read and understand.

Yes, there are some other advantages to the combined version (ie that
whole thing where 'kmalloc_obj()' now returns a proper _type_ - type
safety is always good, and avoiding void pointers is a real thing),
but I do think that the major advantage is "simpler to read".

Because in the end, simple code that does what you intuitively expect
it to do, is good code, and hopefully less buggy.

             Linus

