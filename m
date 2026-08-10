Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4509C5B56D
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 23:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24036B007B; Mon, 10 Aug 2026 19:55:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4726B008A; Mon, 10 Aug 2026 19:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CB26B008C; Mon, 10 Aug 2026 19:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDE96B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:55:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D07A8802A0
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:55:07 +0000 (UTC)
X-FDA: 85087018254.25.A22FF77
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id E3D5DC0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:55:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BmOHmVLo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786406105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHfanZgIA8mK03STIk1FeUn57Mhb7JG9av6AGKnMHws=;
	b=icDp7/UrwTEPGXshqYwT+xnKbt8pDop33EL2M6J2CtsP6il+fI7kYaBernDnvZYfnrzoa1
	WWsDJdMzmEkeA9Hs8gn3bUD1rnhEIG3N/VE3vpm2F5wGpvnisDbsmIVgKr6Ei7Sm86AZqY
	mIOwIaIuTRGDS8bq8kzNaiEuOgUGm8w=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BmOHmVLo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786406105;
	b=h12fDJuNJJeVVcMzS/MLQarkWVM1SXrxD1oFyMQKiC2myYR5q+UX4UtkOJuj53nPgxym60
	SKmMUsvRwqcWIVHFaJpVKRtlAU0fKmzdqSG7tRLvNTV7zJCELdsXXmy6wNo6vY+oBXfgB1
	Q6QlElxHxFR76MxQ6nhhccp1Tl0T4qg=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4994d67d260so14475e9.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:55:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786406104; cv=none;
        d=google.com; s=arc-20260327;
        b=JpAK01jEx+rLRyvEJVZmSOcc6eWFOqOhJf3by1UbR/YZru8DRcX0NuF8yxGig9DWKv
         PhNVHetOyeQ2TajN4W0gDwZLLdJlxa/Z2jTLk2ElpDC0AaG+v/XJb08UiMr0CfYk9A4b
         PpFRL3CBWSMCEDuU7k/ZHg47bFmPK1o92bEfawtdpiYv/jqgw8uqcXnx9d0+19V60J/i
         E71ftraXdOVwC3WzH25v3CdBmJ/jDT3sjQNJLeSiZisHsOOWciB4pYhryT4BFbRcz1+C
         IWcaOzIGiP2jqtTNOXjNpfUMVvgGu3+oEeKeMTdAfktrD8I0WsK7K91T4WTQwTj0sdvS
         4row==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JHfanZgIA8mK03STIk1FeUn57Mhb7JG9av6AGKnMHws=;
        fh=0dy4Fw4WgQzHz/7RbdRLowgLkiLPzcBxmufDNRLedPo=;
        b=nNSllgkHplmVcpuDD+WX1sFU73bHK9Zc5oyUoq0JJHWxhZzCbfCxlGXu4n2NyROy7l
         /4FRNaFNOc8xGfBKoB2inuJOXrkBbsQUuYI6Lj0Ak9Hb2l6fGyUBaziZWGBZQpiFk6Gd
         sjzpVrWmowNzR5GPeGbH5yd5HJGiOO1kts9MncuMzUb4aKyOPzkz4OtKRrWe5gSKbstP
         c5Ur35Or958aZmB2NeZdsNO3rLj/GeyCsHPVUPMguq/pjZTDd0Gt4V0Kv5gQvEXeKGtc
         ng5J9PZWtBUyt+SlFoCXdHvJkinWjaVqZAiW7dHPzqoKTkIY4G+WCG6ht4L/xDvdD9R9
         Ze5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786406104; x=1787010904; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JHfanZgIA8mK03STIk1FeUn57Mhb7JG9av6AGKnMHws=;
        b=BmOHmVLoVp7OMVXHyDxTKdQxVNOmkWd7fouw/yAGpEJxpHv5y95hukBcTxDZ732Y26
         3UW4n/o9YQSiudo7VaFdwrJRhzjUbt/A17ebpS8iX2CZcCuP7Mlc9tXFs1s0mQVgop3F
         He/JeAKDQbuoCdZ5R37BQ87ygP6Kmrppydv6NtwFGvrvLv+uLzT06ewhyqJY4i0Idu1q
         C3C5+/ES9+JafV/r8JjlUcZMgiAiso6FDoyr6CKTG4qs1JNA22YjzWZS5AOBgWBylMUS
         O/6+9zE8nIysq/JQtVqJC/D4ln5nNtXwkUfzDesIkLYAEGktMHLRJ4+On5Gm35VBZZuG
         /Beg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786406104; x=1787010904;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JHfanZgIA8mK03STIk1FeUn57Mhb7JG9av6AGKnMHws=;
        b=R6qYB3V6JxIBiWsilPLuRON3JHHUqKVoiyqLDEb3sFoIZhvIL2qrrviVo7Frg2iwPf
         +A3ks/CybaDF3Z9gOgB4rgjSFYNp3UdnKfz5mdFCy6puElOrBv5ff2eIGUwvwLbTWeXD
         B9kNGUN5QT7fDAm1B2Vsnhf+vK5ca6uwJ8+uZPzT21G92/WStOFGEorIYHXS2RCQaeVZ
         lQ+N9Qjmt+Q+4M61XTN24g4yjEBxx6jlpMWjA9kO66Wm8xYy8NNBBzq5Ef8JUzNfAMod
         bcOLtYoLwZkqG9yK6JmkMXZDC/gAc1h+C+89s0g1LAehV4Rs2QkIEvNYyoRrEsxyXTUG
         btkg==
X-Forwarded-Encrypted: i=1; AHgh+RpvVbzEsEZBgTSEFkU1//W+qh10hNXx8nxwuOi8a1op3gx1lHJt5sRqU/yar/2+uI9qHD1VT6LHqw==@kvack.org
X-Gm-Message-State: AOJu0YxR2suhuDtVdWZ5E+EiJhRsPmOFPgpqEPUXf9639miAeP9B93tk
	qjmU+EULu5J4KBsOPJ4wOM6OHM/z0UbxBuNJTtYRRQ8EHpPvWO1bCzWAtW+XuQ2d78MR8IZDLHg
	AXHVD+LR94DyNqbH7b6G6iEsOfN25stMtk9c2Bcw5
X-Gm-Gg: AR+sD12hWWTvD4hQ5QjBX9HstDQiN58BYlQotC4iFBLEbX1IN9+Tv/llAi0qxGuZlBn
	VSrq1R3TwQw0487zOmiNg0RuOOcrNAkSmDbXsny5CMO0CQPOvll1czOYuj/mTi4ir62MWss6W+P
	+wwDGYzgzM9lPfHcOIfVHG63jnpToZqoyQgqb6Pfzkr84Af92hnNKl+a4ZnEeRzHN9WYfN9frv5
	uoBvUYu2s01knGABtmDCNoiar85r7R6BvgcT8M6TMgwHDtA4EZFRrhXhgntAXrtZZ89/reZGztd
	NLHdrOuwRaPr1IlfgfzFwbBIhENJW/j2UvAi8NuBNMP7tmSBd330jWwkn0+GfZ/JnO2lwNa0NOI
	=
X-Received: by 2002:a05:600d:108:20b0:495:4593:616c with SMTP id
 5b1f17b1804b1-49975c21896mr314355e9.1.1786406103959; Mon, 10 Aug 2026
 16:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com> <CABdmKX2i_vxs3EgJgydEbXoTxqWe9g9pj=hqPKuwf0ge0SjZuQ@mail.gmail.com>
 <anSyU_-zArFch-an@orome>
In-Reply-To: <anSyU_-zArFch-an@orome>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 10 Aug 2026 16:54:51 -0700
X-Gm-Features: AUfX_mwf0uw3dVpzklPu-Nif3rg3tPQMirUP9IgK_6gn-zY2Jt3_SUQapkz0Yvg
Message-ID: <CABdmKX2Hn0cDw_aFW7Xr9v5mr=WvfhhTXgX7tpRaMMGstYp4=g@mail.gmail.com>
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Sowjanya Komatineni <skomatineni@nvidia.com>, 
	Luca Ceresoli <luca.ceresoli@bootlin.com>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Russell King <linux@armlinux.org.uk>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3D5DC0007
X-Stat-Signature: 796tsn5iw5xnmp3qr1t6zdea8kgw6red
X-HE-Tag: 1786406105-906048
X-HE-Meta: U2FsdGVkX1+DL/iK3xS1daKmpgckQox+zeUcI5LAW840lkx+qjB7sohxkYeCj6tAr0HFsI91aQfiqVpvHtSUFwxMChGLjtRS8HgpixRBYY35V3tQ/A1l6+L9BOZPA/xqRGG9pMaQgqxO46SQq4fRsWameUSQv5cUc/gDwT/Ltu6q303ZHRQVuaNDpHNShc7M4f8uw4Bf6E3nkNRPTyP2UDZzew8oKPf7MUPcUs3IRBXNKYB+8deeiOybP2ahNhAhr5RiJfZaHDcQ0u5Ku/saM2+PYMkp1A3QahuJPeqOUPAfLtsIkh4h/2jDwz0TqnlADGwyaLb/O+A9TjQwlk0oxUNlERNjIub1HamYdUtyf+hP7flkxaIiCXharB8HQO4msBMZONlJqMWrBSCffKMXYO2+GmH7GjSAMFBBm1V8Vkvw12sUy1kuElc+ay4ZiuLbbnqzjxKTDDTQuEaK8DMFonMX2l9yhzwkiXLeEmyCutpCxCvMguNf86J7UJ6Z20nYg9NgrA/J6/1jLNfgL+DWjJ01WGCOZdnbxYgQ6YCabxfW77dRIonUQ5DIfgQV0nAA3h57hWtg1D42+hHAVbZTfZGD9yNOBENjIxZxwRY5mztIVbLWnjoenuHLKywEBJDSOSu13RA2zqj92us6gpFNCeZTrnRGJb/AaR+ABwVKWhCs8QVD0gmmTvoIXmFCvMVXMGGyePz0we8fhUElTPQChQP2oCqf025gUHkWJCeFCqmkdaNoHJtbX/UrCtcrQc6+n2Llweuc7reGgHPi0pDD0EJk7kfrsZGPrUkYirELNBRfNH0zyl5Vv3qr10p3lB/c8zNZ64QbpYbEAa2TEfxX8KLZ0kT/SDgjk/zUecPLl95qwe0k7jI5YZp0jQENylbilDIA3+dOQsD/7Lp5O7+7b55bnvG2apwAxhpex8NtkJbr75+sObvyZfo2FgH6Sp7Dm6quJtPkaksQSq2QDbI
 srNsg8h7
 3WoS9STTudX85keZsJEdEIARST5Qd9c1VpwtvG7ysFqgEFBGOVaihDMqHvDTdq5oLx+pLdZKatbL1JCDCpHfQjPQxs84alEfVBuKp+9UMMZDLhn59iEJ1Nt9Mv4SgMljwJQoMmv0iKqekm4xXpfEHWDZEt4o0ogIPfozZipEX3qAlBXBVDPmgoL04J7Y4ZIaRntPLmZqWOnnT0Af0FmVC89pUlukDj7QNkVtxekIy+dUrDBnvlm8VJf1LL++PNX4DVD3VQheH2YifMhTaMjJktGba8wGGASyfxSgRU3UUCF0dOHn2SowXtSG98ZoAYrA+5lAXcXM7+ByaN6aQhujbXZJE/v2bJPCCUCxFJEOzkIcx0gu2N3zaeksUcR4u9tGxAWAZ5xVCxnhk9eo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 9:21=E2=80=AFAM Thierry Reding <thierry.reding@kerne=
l.org> wrote:
>
> On Wed, Jul 08, 2026 at 04:49:31PM -0700, T.J. Mercier wrote:
> > On Wed, Jul 1, 2026 at 9:09=E2=80=AFAM Thierry Reding <thierry.reding@k=
ernel.org> wrote:
> > >
> > > From: Thierry Reding <treding@nvidia.com>
> > >
> > > There is no technical reason why there should be a limited number of =
CMA
> > > regions, so extract some code into helpers and use them to create ext=
ra
> > > functions (cma_create() and cma_free()) that allow creating and freei=
ng,
> > > respectively, CMA regions dynamically at runtime.
> > >
> > > The static array of CMA areas cannot be replaced by dynamically creat=
ed
> > > areas because for many of them, allocation must not fail and some cas=
es
> > > may need to initialize them before the slab allocator is even availab=
le.
> > > To account for this, keep these "early" areas in a separate list and
> > > track the dynamic areas in a separate list.
>
> Huh... going over this thread again I could've sworn that I had replied
> to this before, but I can't find any evidence of any reply.
>
> > Hi, It looks like you'll also need to update the CMA dma-buf heap's
> > add_cma_heaps init function so that it adds all the CMA areas, not
> > just the early ones.
>
> I would actually rather not do that. The case that we need this for is
> creating a special purpose dma-buf heap that's composed of multiple CMA
> areas. These areas must not be used by anyone else. Exposing these to
> the CMA dma-buf heap would allow anyone to allocate from individual
> chunks and throw off the accounting that we need to do in order to keep
> the protected memory from working correctly.
>
> Besides, given the dynamic nature of this means that the CMA dma-buf
> heap might already have probed when these dynamic CMA areas are added.
> So we would either need to have some way of notifying the CMA dma-buf
> heap of newly created areas or we might end up with an incomplete set
> of registered heaps.
>
> If you really insist, I could look into this, but I think it's actually
> a nice feature that the CMA dma-buf heap only registers these "early"
> areas and exposes them.
>
> Thierry

No problem, thanks for responding. I see there is now discussion about
subdividing a single CMA area for this, and that seems like it could
end up simpler in terms of the CMA code for this series. So I'm
supportive of that idea.

