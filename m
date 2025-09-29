Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 914BDCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00518E0005; Mon, 29 Sep 2025 06:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD80C8E0002; Mon, 29 Sep 2025 06:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7238E0005; Mon, 29 Sep 2025 06:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE3C8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:07:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28553B86AB
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:07:40 +0000 (UTC)
X-FDA: 83941861080.19.1E0BA4C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id B56CC40005
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:07:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SnvdoJ4m;
	spf=pass (imf04.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759140457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNhsAZ197fXLkKx/HifCds6KCXexvnVvwkp8EfKfNUs=;
	b=FcwY/mcxZWGNadtQ4620zeMkjSTnuyhytP1J6rtG+mjHj5k8psTVxbRiFRP4b2AnyiQLPC
	RmOumCIz1QuWbjY0QKgtOW5Bhmlgz5Q3aP3aUgyxibLkMD44fojbNFNDdKftBGZMI26C8e
	EZQ01KQgbhga1tVKWkaaANxd3VjyDM0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SnvdoJ4m;
	spf=pass (imf04.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759140457; a=rsa-sha256;
	cv=none;
	b=2+PorF9dI8ykzGoqxhlZKja+X4z9EawLjabk4APj+oKuU6wxZ0EaUWl0Jl2PuGoXhkhjuI
	5pJcRkq4N+9tAvf2GZzOivDKWsnkSsfm5zi4LHKHCQRDs1dGX4/aaxQ4MJOcDFqvTsfXXv
	rimRD9UxlgmYzVAareV/1feqZlpbRfs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759140457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pNhsAZ197fXLkKx/HifCds6KCXexvnVvwkp8EfKfNUs=;
	b=SnvdoJ4msGk6xSeaE6t7CTdiXHWSEq/G92t3BQ2vIHBU3hTeDOuOdlHg8KXgVidjrfANoi
	74VTEwAiOjYuTh/4kpjw9utZFt4NT3pA0rVLyvIEOqJE5LjrTdwcLJ2iqm8KoSwaIeg62B
	LcCPuxBxJQ73IMW7Xei9UumCe5hCWGM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-KjtECKilMD6ARIxgLDgJ9A-1; Mon, 29 Sep 2025 06:07:35 -0400
X-MC-Unique: KjtECKilMD6ARIxgLDgJ9A-1
X-Mimecast-MFC-AGG-ID: KjtECKilMD6ARIxgLDgJ9A_1759140454
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b36f970e2abso328466166b.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759140454; x=1759745254;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNhsAZ197fXLkKx/HifCds6KCXexvnVvwkp8EfKfNUs=;
        b=h8ZVfqYKrHgHUKmyYseWXC0DnGixWSSipNOM239ElZ/bZVTbf/BmBtFeXx05CotYNO
         lWvd61kbjR2ZFdUlhHT6yOLSZDv57r0Zb914YfK+kG8wS6B9JHkylzrPD/4VUw6M38ND
         Na5c1W620uCAVubjxafl3w8vzN3QNYHmwh2h9aayZPh6dd9T5a2PwFodXmJ0PJS0cBEF
         a/2cEEkD0HnejktC2gydEpgU3LI+Qv0TAuoccb1DjC2nLKXaifcKZ+0t4c6CW5Ifnk2P
         toi9+O28md0Wv1PmLFKkeUTa0zZqDJGJOZywfkRFZ8KBKBm1s57UGR29QKJgtjXbq0jZ
         pH+A==
X-Forwarded-Encrypted: i=1; AJvYcCUtsQZScjBo5LJG0WUenSRsudGw0Vpn3oX1Jqjz2x7zgNShR2p2pgDFuCx+Vv5jAZHOW6FESjdXSA==@kvack.org
X-Gm-Message-State: AOJu0YwHS1HkrCUmPRD93qB91l7ETCEPexUZB2R+GL88ER+4xfKkg8uU
	0GqayX6CPidB5Q4zQ4lTXhfSw7HCRNdMSFYEyc+z/lVT8KESlGTTqkEeyQUiEV5Ht57W8QhYwxs
	mTEoEO3ZsRlAVC7x6cKlz7EZWudkrqnfgwCPCHgRYC1owTsaM4S0N
X-Gm-Gg: ASbGncsiGV3Qt+N0UyPXQMyPaKMvUdjUDgeqfYaz+cmFCqQZ0rJ0Dx7DRbK0YVOwklG
	nYP+HRMa1hK6TLzj1iOkuxVczL1DUGFX3j3sSV6ViWZGqR02oMyv0ZAg2V0gnXxzDTs0ITRn+jD
	/iR0iwpXJ22upEDoqRcIpgbNvxv1Mn2Jc/x2bfTJb3fGmY9dg368N4akibDwRkHNBSOAbTPcYCm
	kJiUsoSVN0FEmViztyaqkyy6GkFzSbCgvGMqFVmjbSU39D9oXdZBjuYwD/MhALVajzuBZQ/m+8b
	Eol5NnvZKIcS9MlNwBW5tO9PTkPq2YJTroibZRnl6mtSkgWx1sZGawhyNkwOZ/pE
X-Received: by 2002:a17:907:724a:b0:b3d:200a:bd6b with SMTP id a640c23a62f3a-b3d200af74fmr521501766b.52.1759140454296;
        Mon, 29 Sep 2025 03:07:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9a2plHTKeOP38PeLzjOKA1MCGusAp8NTkLyvlpvfnkmlHt9UG5mdCvqBSpRviAip/7snxFQ==
X-Received: by 2002:a17:907:724a:b0:b3d:200a:bd6b with SMTP id a640c23a62f3a-b3d200af74fmr521498666b.52.1759140453816;
        Mon, 29 Sep 2025 03:07:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3fb818fca1sm101904466b.101.2025.09.29.03.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 03:07:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 10A41277657; Mon, 29 Sep 2025 12:07:32 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Helge Deller <deller@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Mina Almasry <almasrymina@google.com>,
 Jakub Kicinski <kuba@kernel.org>
Cc: Helge Deller <deller@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH net] page_pool: Fix PP_MAGIC_MASK to avoid crashing on
 some 32-bit arches
In-Reply-To: <33e8db9a-7749-44ae-a2a6-27f3e6e8a3e0@gmx.de>
References: <20250926113841.376461-1-toke@redhat.com>
 <33e8db9a-7749-44ae-a2a6-27f3e6e8a3e0@gmx.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 29 Sep 2025 12:07:31 +0200
Message-ID: <878qhxo9lo.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pl3t8EBeTzPiD6aNCnDH6URWW6w4jaUxXrAXFLc5kyg_1759140454
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gjizgzbjyiaisynjdf9aojp1e9abb3f9
X-Rspam-User: 
X-Rspamd-Queue-Id: B56CC40005
X-Rspamd-Server: rspam04
X-HE-Tag: 1759140457-947369
X-HE-Meta: U2FsdGVkX192pxwvzUP5n26/zKI8oO0uf6biJKqEh55BLuaMH/laBcJZjoWnNyOZQbc6+74Mttql8R+zLDvdrqtp+B+PigmKcTRSdGfkavB5BgSqV0UQvKd+FWZkkdJA++zAT2HGfeERmHDLihNnoLlHfIeyV+C5yPzY9f2u3c6bNwIWT4jzxHKc8kUTdioU1hifcmojyqxAUKJRZVuLZubOvTIoBRQatFGRAuqI/XL7hnug5P3FD0RlT6oy9DJlQnRJgbhbop0piFD15BHorc9UXWiaaTO0mrf//n4OONJuptNJKo86fTQZr5ya55ykqmkLue5B/CYw6X/wedXZbPLu5+hnCRPR3uPXhvayOZ/1d+GRTPVOP/OaHTjzyqGyNOs2NZryoTWQJMluTAz6diCJXCbeKaSlK5mK7+DEET+d4zXApkzawOKXx0rw2fbh9BrH0mLlyyOZyRn1owH7unU/VN/nM+Pml1+EoLCXG+R9U4NSS6g3oG5mvqTwdm6WK3MWf7zRTpjnwDfXnlvHRZSmsTQ5bAV6HsJUTjnKUmEtssFLcnYXu4nHfhHfiKJPUa+70H03OcC8TUw1iE4D3J+xX047xBBfJY9C+mzNPaTsPMwcXxw9MKqw0B+xfSW0Rec+DdAH08o/PFb0M1bShvOPkxghJ0NjTzvg4mGDAZiZteHu3iFyoZtqKNEAuLk+VacVTPK4/XRQm2gIBFhQwVGmarPyffMBM447RW1ETSeTlcd69cvCigMRbHk1f5L+FpLgJl4X253xbDlRJSnHsqxUMh+YMum8sNqIDVpLU1+LfAoDksqE/ysKEiXDD8vJcDLBwbqZ9R3TNa1YP296lBYMKvvIQwGI8dh19/ylT65lQ7f3cq6c/ThYpovNA1xcSno7ksvkI+VyfW3CrI+xCU7+uiQt1kNm0GRU5TO8sLu3UzZQ5ilewXOSJBx6enTwnKo0kudO33nEOFXAU9f
 dfuldWyY
 7i9UlgttON69dsi4hNThwPqoAC6V3Php45EAz27rDZ7fvqbFtI5pjh/0eyVtxZpVTr5uoeNqNZtCwS/UntKjMNq9pOdCS30n10TwclYOSFYyoCz3312s7fH2QSSp4nVVA9IZscd4Yf3zA5h1Kw0XZUMj/Hh8RMxlnL9JQJSXZc3cWkgp7/0SLQVGHLDfuzoPPwf+Sr6CaR/AovwQjf8D/48oC8fF8lafxw1sEKqu6Tjv47ZGKGW90VhCXHn1CyPkgQxntuUxgFuGsUAy+ktiiEz2G6ZoUYPuLJCTQ7vyN9r/wjr+BiQdzy4mMgHffJIyD1ZG7UpAXZqNNbwUDgUxsXRbR5verPKDsw3pQ182nMAe2ADTlONeQSWvk3zb5ANVceZo0FxwdX8TJ42YwZBcC38JJ+nx9SKBP+8eUpE7sAdpJwW6J9ixmB6NnuicvS/v55fIeroIMl6doxoqQMqvZJfZGZTH6kFg4nNfu4aGLWb5F+RK47cA75icfLkzuk8gM12KN68UdtFyVio6SuUE3zTjwS0vcfL2UVHMjj8anx5DBHwwQUWw0dBUq+gVa9H3Dg48vWtn0M68shk1uoc6kKlMiJhff9L5Aqe6guz0gznIrPf3GJFOXlxQ+1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Helge Deller <deller@gmx.de> writes:

> On 9/26/25 13:38, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
>> boot on his 32-bit parisc machine. The cause of this is the mask is set
>> too wide, so the page_pool_page_is_pp() incurs false positives which
>> crashes the machine.
>>=20
>> Just disabling the check in page_pool_is_pp() will lead to the page_pool
>> code itself malfunctioning; so instead of doing this, this patch changes
>> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
>> pointers for page_pool-tagged pages.
>>=20
>> The fix relies on the kernel pointers that alias with the pp_magic field
>> always being above PAGE_OFFSET. With this assumption, we can use the
>> lowest bit of the value of PAGE_OFFSET as the upper bound of the
>> PP_DMA_INDEX_MASK, which should avoid the false positives.
>>=20
>> Because we cannot rely on PAGE_OFFSET always being a compile-time
>> constant, nor on it always being >0, we fall back to disabling the
>> dma_index storage when there are no bits available. This leaves us in
>> the situation we were in before the patch in the Fixes tag, but only on
>> a subset of architecture configurations. This seems to be the best we
>> can do until the transition to page types in complete for page_pool
>> pages.
>>=20
>> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
>> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them w=
hen destroying the pool")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>> Sorry for the delay on getting this out. I have only compile-tested it,
>> since I don't have any hardware that triggers the original bug. Helge, I=
'm
>> hoping you can take it for a spin?
>
> I can't comment if the patch is otherwise ok, but it does
> indeed fixes the boot problem for me, so:
>
> Tested-by: Helge Deller <deller@gmx.de>

Great, thanks for testing :)

> Btw, this can easily be tested with qemu:
> ./qemu-system-hppa -kernel vmlinux -nographic -serial mon:stdio

Ah, neat, thank you for the pointer!

> If the patch is accepted, can you add the CC-stable tag, so that
> it gets pushed down to kernel 6.15+ too?

I find that networking patches make it to the stable trees based on the
Fixes tags, but I'll try to keep an eye on it just to make sure. I can
also add the Cc if I need to respin for some other reason.

-Toke


