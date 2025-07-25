Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8EFC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 07:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DC26B007B; Fri, 25 Jul 2025 03:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023BB6B0088; Fri, 25 Jul 2025 03:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BE76B0089; Fri, 25 Jul 2025 03:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D98FA6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:14:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8987316062F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:14:22 +0000 (UTC)
X-FDA: 83701923564.20.9B04101
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 98D5DC0009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:14:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zR8xDQ3l;
	spf=pass (imf28.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753427660; a=rsa-sha256;
	cv=none;
	b=7d7H+sCk0uJPvbxlULdPDmouZwoKf39ZmiBpctpZjNCTpQEX3EVnzgnJQ8ILAWOkLU0f3t
	9FLc/5vhhd2yLpxWavmKz0rIANRmv4gyd8qNdLA65Uko6uHd7BlADT/TygmFP1FB211B74
	RDgrohGUdXIJpBR7/GEcx/5V6WmOvts=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zR8xDQ3l;
	spf=pass (imf28.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753427660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9vHt5UXfKsv8YlchEcAgj1SPpwPqe3D7/osin4AnlY=;
	b=cJiRylMA3+SiAJRjusQRzzYgV2JUzZtFkk7Jb/2PUh+2kMH7rpHPCwPTFsrU1A5YxOnfZ/
	FkGDVRK6UbXXtaf+7EsAcikOXmAjaONYQGnj7kENpy/HipuESdmsATXkF3D4dAXda0aQNP
	4hvfheaP5IBJ1GWH4E2FbhCZSuVzoXc=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4561ca74829so18753175e9.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753427659; x=1754032459; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L9vHt5UXfKsv8YlchEcAgj1SPpwPqe3D7/osin4AnlY=;
        b=zR8xDQ3lp7Y71bRzIgdkXW8zChvVAsfhi8g65BwHmQkb0ozR33t3rdQ7hEhbjhmJUI
         EIi8VPJjOfQN7gsZtDeSIDX3/bWozdjNhBXWaf7kXfGnEIuMzcjhQ7rTGEEuJ3cm9PY3
         FYuXRMuf/i8ZGc7jyJMhfyh5hL8RHvKIitI4cJxAzymXIodgdwkwEhHL9KkTUTfjtB/r
         Egtr6r7PcnPd/LoWt1jMHKZXzgf6QiarGfdXMrbbFQHAPa3ajaUpay0ChwPuzTv66MaM
         9VnzhXbq4qId31/9p0v2VlCCLQlVM1gvqxWVUtK4zjH9ZO0h299G1F8D80s1Kws4tSkw
         StsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753427659; x=1754032459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L9vHt5UXfKsv8YlchEcAgj1SPpwPqe3D7/osin4AnlY=;
        b=B2aM3YxfjytGBZGKxbdN+s8UhMZDBW47wyw0jHvBXVLtUoiNNWHDuEZtMkW7OHxAYY
         7vNUPIzXfpXBOyonInSUwC9i2WzpHIZ0uuvn39lImBQJddr9exLsUHlYA1wn3cVG10B1
         Uz8wKRJeb3hsXZ2EYxzEbEMdH5L6p89OfUibS1BU3OXU0rr1gQ/WZO1ee1It/zBU1rAF
         zMLFqXeZwKmkH6/pPRs1CG/PpY7VrQicCJKpcPb/D8SUDfe2qJ7loFEjik2/kL+VhDN0
         LP0GxVntrT4aL3JZzErU4VUgRb4+tfoJlKaKJ1o5zYvMd+TLf0+IlNufKKdyYpM6fTyk
         Z9IQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2kIsvB/5dk14i3Ooq2p7hdc7KtctRId81y/oC+efExubelcro8lNHG+VtDJl9zM4jsd/sTA9C2g==@kvack.org
X-Gm-Message-State: AOJu0YzP/jvLbC+Ftey9ocVYhjqQWD1tzJI9SZeE6jKzVpikpbaXgPWC
	65xfwQ38roj+8pGT0IOO2yhuh1+5YNURIpFukfJWQNqN4lmi9Ln7klS38KEt7WpPY5SUHTj6Ffy
	8fzgkehrv6K43v8NGmVbWue0kZX3ZJJgpZ1E14jE/
X-Gm-Gg: ASbGnctIrrejZnkyURw6w2NRlW3qoAfobeHHQEqPkngLXh75qI8IqaBNY0PDPWXTwqK
	7wl1ZO0/EJBnjtquL5exEGXRkTdGB7H92mgE7QVQNAiIgi3Ai2x7DMFDErFnM/8CVZ2pLP3XNgs
	iUcNMPmme3erYixQDFQhmXQ6ArbdHwtTZ+8Z0R0/RD386vOlslpRdYnEo1GtFOQFD5Um83J1KOh
	+0X/oD44lyV6lrZYeKlJOCySM3sjCoD6C/l3EWM/CtH2wtT
X-Google-Smtp-Source: AGHT+IE4kl/WAV/DJhHC0LW0odI/joljZCgor1iGezxfvCxEn51uKapoKTZqJK2GZ/JKTo8UOtRjEV7yfpgZ91zr4FI=
X-Received: by 2002:a05:600c:4f07:b0:456:58:1114 with SMTP id
 5b1f17b1804b1-45877447996mr3587685e9.9.1753427658863; Fri, 25 Jul 2025
 00:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se> <20250724135449.2cb6457b90926cce1b903481@linux-foundation.org>
In-Reply-To: <20250724135449.2cb6457b90926cce1b903481@linux-foundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 25 Jul 2025 09:14:05 +0200
X-Gm-Features: Ac12FXy3-hBwFSqnBK583mYkueFJy_LL2mllk3DPkZ3jUCXGxkbYOdiRiOuntB4
Message-ID: <CAH5fLgjatYenX_xPvRW11BnRw1wP_G19eY-7AqUctnuZ3rGBYA@mail.gmail.com>
Subject: Re: [PATCH v13 0/4] support large align and nid in Rust allocators
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, rust-for-linux@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	bpf@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 98D5DC0009
X-Stat-Signature: kj3ugycyfh4b416uquree79jiigtxhs5
X-HE-Tag: 1753427660-10136
X-HE-Meta: U2FsdGVkX19ikTWqeG3tlSzvyYx+MAEHtjmUNDDg2PwDtOgZslWCbbX5Tx+Pl03mK92X9Qg+N78RQxfdd4uPhXvOuTV7WxTEyoFM3kEtzdbSKJsJPoqNGO3r7Xbe7h1PduCP7BHhy7W0LcZ/mliEc3vF5acuMH6aBIBVupRXui05Bdc+3BftRkPzdiwDMjQLQoAJ8cU9qKa/CJInbwbMcITqMb/6EZoAiapt37AV3Vzt628HQDNR5Hd+2QmIYRmlDD+Caayex4LzGNxTxwpBj/po5woPHK13n0THfjRrWZo9aNfU5wNWLtUnFzSx2E3MhWhsRan/JlvutD2aaJ49j2cbcOceMFB21qFncJBNGDmflurqiM2j/vg6zkQVwEPFlzkypXznoc5fzRxOb2QVjyNCB0UAf/nma2inMjvoft8+ISqnyGQmZ7kDLvbMw6/rM4DPNZCeJpZp0eJtiCC/e9RwefDOw9cCEd7hTRU5Fso3bQ4rp+D6yEiHt1D3bVrE3koKN8Ltgc03sGRyelsgSVygT1ndvq8Z7W2FnbvFTjE4JsZ80C51zBpdAACwO4J8J3L8s5alltxYkgS06yRcGZrfsMuY6qP7DIXOqkNysJcnYiddkBWlC6eiplv63zAIv5Rt5vyO20TcJtFHvO4zOTinNZS4OkeHeizTPt1BRqrF7wLZMkHmoGr8VIUlo47ZgtqxyACd1XCHb4boPtXWqTdfAyxL7oTXPl/eKesUZYOmUgmmLjGUvvvSuqlPsQ4Anck7B5CuU6DZhVxagxR0RIMJyda5XB6Y3rbSZlkPqw22Ehid7h6pxEp802uXa47eQ+8DMtpqL4adveTifu5KM2Wrnuhb/Q0UP625KEdFZzPMdg4a1F0zaXqfPBNOmlPJY6vHSP4/z7TyKEQsLbzRUZaH+i0k3kKnYTJgY6OA3bQUJLui8M7BNqtBtWEgWZjCKgKwMJxtsJXTZQux8Ve
 p9P4JemR
 By2cxVkBx77wd3Cv98KbbGYLuLSp4Y1H0XZONj8AnYSdLy2J26Of3v4IvvjtT8TXl6M7uxD7mUhrpV4lg0/tnKopFoJVTwGZcJFqlZ0DETNHVppQ31PNGt8zNOqJ2HkxjY0FSJ7k4kKCGOqyMLbBd4P5xroZhwubx9qUW4x1rVa5HmjQt/EUPBCanmp56UOfIV0raK0n1kYMDt2aqPHRR37jMag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:54=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 15 Jul 2025 15:56:45 +0200 Vitaly Wool <vitaly.wool@konsulko.se> =
wrote:
>
> > The coming patches provide the ability for Rust allocators to set
> > NUMA node and large alignment.
> >
> > ...
> >
> >  fs/bcachefs/darray.c           |    2 -
> >  fs/bcachefs/util.h             |    2 -
> >  include/linux/bpfptr.h         |    2 -
> >  include/linux/slab.h           |   39 ++++++++++++++++++++++----------=
-----
> >  include/linux/vmalloc.h        |   12 ++++++++---
> >  lib/rhashtable.c               |    4 +--
> >  mm/nommu.c                     |    3 +-
> >  mm/slub.c                      |   64 ++++++++++++++++++++++++++++++++=
+++++++++--------------------
> >  mm/vmalloc.c                   |   29 ++++++++++++++++++++++-----
> >  rust/helpers/slab.c            |   10 +++++----
> >  rust/helpers/vmalloc.c         |    5 ++--
> >  rust/kernel/alloc.rs           |   54 ++++++++++++++++++++++++++++++++=
++++++++++++++-----
> >  rust/kernel/alloc/allocator.rs |   49 +++++++++++++++++++++-----------=
--------------
> >  rust/kernel/alloc/kbox.rs      |    4 +--
> >  rust/kernel/alloc/kvec.rs      |   11 ++++++++--
> >  15 files changed, 200 insertions(+), 90 deletions(-)
>
> I assume we're looking for a merge into mm.git?
>
> We're at -rc7 so let's target 6.17.  Please resend around the end of
> the upcoming merge window?

I think it would make sense for this to land through mm.git, so yes
that sounds like a good plan.

Alice

