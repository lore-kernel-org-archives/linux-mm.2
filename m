Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B1ACA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908788E0052; Thu, 21 Aug 2025 16:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFCC8E0048; Thu, 21 Aug 2025 16:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E798E0052; Thu, 21 Aug 2025 16:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7096B8E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:40:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44AF913565A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:40:29 +0000 (UTC)
X-FDA: 83801932578.20.A513809
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 68D904000E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:40:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=R6H4k+oG;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.219.173 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755808827; a=rsa-sha256;
	cv=none;
	b=WA4Juw5Xj+4zmE07OG/CRI98SkbQHYVB5z7iFAidJA3r6pIdm8eqsd7ivKR2yMKJpe6gj3
	CBio0/Rdcty8z7sWn/OPc7SbI7vYX8SeqJh1EUb0koTnkP7O2NimNkY4luDAfJPzYiwgzG
	b/+d0ifXq3ke0b57sNOQhA2ZjUwuqsg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=R6H4k+oG;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.219.173 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755808827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHa4LrampbSXQx1Wyi9Bh9OjrywcR0PvG9lus2xsnNw=;
	b=QPCICWM0k5NwW05l9pa4Uq5L7PIi8DcVaNXSH5n7S7S2xHnxF/9553roNIRMu8DTbCrMSU
	Jl+QxmmAFFsA77espMGXVHzqnnaox+gSY/VfDHcNtdluqpI7GGLkefZjVmWawa5X3iG0Yo
	futz80JsPc9hqmyxrU009m40smN/vII=
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e931cddb0e2so1169480276.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755808826; x=1756413626; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lHa4LrampbSXQx1Wyi9Bh9OjrywcR0PvG9lus2xsnNw=;
        b=R6H4k+oGWaHKuCtAhN+oHaiJxpHeZ4o+F5OUzImIso7+gQOQg0WEzxZc8tV9rXmmfR
         djXnrg1RwAzNxdbb7hp1SC4unEtgXpIFadMhm7CsDZ5g8SdHI9bAd+whkV5fyO/b/iJU
         k7RyW2EM97aHSa1Dxi6P+RnuD+Ej9rB8LyP+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755808826; x=1756413626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lHa4LrampbSXQx1Wyi9Bh9OjrywcR0PvG9lus2xsnNw=;
        b=jFqXJ/FWFlFWi7KgPuKpbCQTzTgdAhgu/3buEer99l5VHPqrJs5echDqDdWWCAfwGr
         E6wc4hGHb4ypjxruSXAfheYq5ZzijTS7Mo84YC0svbXTQ1nDfykkO5aY53VVUNaYkZrj
         7az1RP7Zd5IUHa1+z0IjVAILaFVO3lIb/KrPTMFslubCzGC6nMx3+82S9vBqne/gzjLr
         36COGnhRv+XQe2m6py1QGH6kXMGhHJ84JOOaOOefeo7T26QNqua92bc+kJcrFZCChUNV
         4bI9Q4Vamnl64OqkC3L6kVixDo8Ia6YW6LugNrxyadD97Hzjl0Q6L1GMKlvpXinWGqCC
         h2ww==
X-Forwarded-Encrypted: i=1; AJvYcCWFpO/uAZxjiQjb38T/LiTWLE2QH1nE+O1d4X+gxz7rL8CtNZ9Ogd+gqmg/k+J3Lr+ZNQbqArlANw==@kvack.org
X-Gm-Message-State: AOJu0YyMxAhZ6znP+YU0aGNE7X/xy+VCLZlhHj7gXUuzsKcawYJF6N0M
	LheyfUjy6IPVyUv8HnpJa+xU5NO/GYng7Fs5HtOrjhbfLHorJGmvRngfA13iJwbwugPFgl9vFnl
	B/Qhvt6CtFrQVlTVaMvixnyrmCLk5kGs8Ynixe93M+g==
X-Gm-Gg: ASbGncvaHlk2cZqPecjqyRdg4OUdqFW2dL6Tz8EGtWwNtWY88ownPIN0UoHXHt4zwnB
	CAQPXkw4iD17nuAmtkxnsptpEAn9zwWKzUYbTqsLwbQTqnCyWbyM+syht3W9eZdNCF7PYrhHxFU
	XOzhhK8xaB6mZvACVaLiFSpuJT6bMfs6BLGGh6xIcN5sA6x5ehCEvV6TwxdMhYi5701xn6qP1uO
	P3JWunMWKnNKbB0
X-Google-Smtp-Source: AGHT+IEDbX/Imr3oMuC/SvPpVgA4gK54+Q+BCEwHjysz7tgNECdpdXbU462KLrYXAP4tYmTYkQFLOtkp14xdKE7/w+U=
X-Received: by 2002:a05:6902:c12:b0:e93:457a:37b0 with SMTP id
 3f1490d57ef6-e951c33ee1bmr998901276.20.1755808826442; Thu, 21 Aug 2025
 13:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-32-david@redhat.com>
 <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com> <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
In-Reply-To: <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Aug 2025 16:40:13 -0400
X-Gm-Features: Ac12FXw_AatpwCNNPCEiMwiwdQxQbayKDzVf5K7yc3iQ5tLY7APrv3zl2U8Z_SA
Message-ID: <CAADWXX_5AJxTsk5m_RvP58d=quRMqT4-XbnQQx=obBTKjHr1Og@mail.gmail.com>
Subject: Re: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68D904000E
X-Stat-Signature: uj5faibyna7daqk15rdur9zmar9o9kqj
X-Rspam-User: 
X-HE-Tag: 1755808827-516577
X-HE-Meta: U2FsdGVkX198sRPpF4yWUe20NtuzZLGqEBmNMjgqB6RsWNB0xHS0hlDyMzhEe/KcYylLjlS/wgYCyB6IjD6euBmDIfSA1y0ENAAxeuI7AtCiIEggSKXe80hivc5aY2TG3oVAe+7nz0sFwVIz34V1ThdEDw9c7nIrn0tw9u3HH/3VdNkVU2OaR4ZxvL2R3kEF4rR1Vy6usAMMrziqhf32mzQiAjRNEmuMpkcFn45slFkWHnocFHp5CsbFk0y1lEnX4FfOZgmLM1xy9Uv+J9vkOMWtYjqzlgGE7VJ03M0p6UKsX07kNdxLd/S4n6QjJXASZY2oLpLqV9YrvgNmoyF/OhjZN2vIEy067015zSRslkwx3bctcMwRk82mhlbyamYOVhZWfmXkN2vHjF6Qlf+O64N2WRin9mrXq5h5n0TKyBZYjLPK8yRopxec762Yqb3sTzEfv/IHC862Jlnv/xhp1AOeycv4m/q9TF+GhdxFMSc2V2v1+hUBPFDF7TFXvRmKoYsIslkhyJeryu7k5xeQu2C9VPfhryt/VBm/DwA892l9HGZOdNzNaKJ8oInnMaah0833bGDmeNY4w9qf64Xxvi7uPj+FPV1w6ZwXGWMFubaHz9fvIhU6qoAeocbwm3IEwdrgXyVq2f4Y41UdSbqkPt/BnFoVaVFpWYNn4V3iXb6VsOWbOO6KwaH5o8akqg75QPiyDVMZGaf+49+AB1WGXURZvGJGB2tA65FqqAwB5zffUG98dSGdsMXXtKm+IcYLl/mUiIelWKVXFetjiMxpYLyOL6pbD/Xn8TN9jigaNJxJGns/v4ViCIcNgRwpI9ExXCnb3D1zECfD0zl5JmcZOyOEJTFrC2XzZmw6QhgKXTAhnIDi2G23xe5af3hC8vImGYRmHyczmEd7Tu13YuhWDhWpNc6yG07ynB5cCk5x40zFswmJRbxuiZHo/QB6L7uwVtfoqV1ttZzWSihdq1T
 sskuYndI
 LzlLNGVUhfDuNqHyL4eKjoC9uuVxwft4HFnLFfujx/SQSVCUaIEKf9ODAP6mtwwU4wC+om1OC0W8ZYbYLn8DQFOtb/y1LR9ZT+KGzpN45Hri6XESQY2ESa6wMZVz2zZWSB5gHbKLNfKVfFT1QiAs00aJnTBo/m0i6uXXMZx1emy53wckfJ9FopaIsVgWh0lM1Z9Hby/T0Nk/vDfxLjz1BqIvhuahqClaZsUZirbIrEtsTNfUr/ap3fGVQ8NSnXRmyLpZyM/UYWS+HcjcJuHs1yJrs+ADqwX/STZRUYb+0ZKdj2x2S4doDYA1WuWv4nsU9EPdF4lzGMA4KbbcTnZ+51wH12NvmYsH2MtqNlGxdzyVGYo96aWQEKI1+QW8coTRXTxm5fINjhJvPPZBs0feFI2NaLKh0wEh63BTXuDFCPMYPmNmkOZfBkRXEUTMSxUbXbvjWIfUX7Al4RlqiMel8mpaVTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 4:29=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> > Because doing a 64-bit shift on x86-32 is like three cycles. Doing a
> > 64-bit signed division by a simple constant is something like ten
> > strange instructions even if the end result is only 32-bit.
>
> I would have thought that the compiler is smart enough to optimize that?
> PAGE_SIZE is a constant.

Oh, the compiler optimizes things. But dividing a 64-bit signed value
with a constant is still quite complicated.

It doesn't generate a 'div' instruction, but it generates something like th=
is:

    movl %ebx, %edx
    sarl $31, %edx
    movl %edx, %eax
    xorl %edx, %edx
    andl $4095, %eax
    addl %ecx, %eax
    adcl %ebx, %edx

and that's certainly a lot faster than an actual 64-bit divide would be.

An unsigned divide - or a shift - results in just

    shrdl $12, %ecx, %eax

which is still not the fastest instruction (I think shrld gets split
into two uops), but it's certainly simpler and easier to read.

           Linus

