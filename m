Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 727E7CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 07:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB82A8E0006; Wed,  1 Oct 2025 03:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FCF8E0002; Wed,  1 Oct 2025 03:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A69C8E0006; Wed,  1 Oct 2025 03:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 865A38E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 03:31:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2325287970
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:31:14 +0000 (UTC)
X-FDA: 83948724468.29.2FFC9CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B802A1C000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:31:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hd26c3Ro;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759303871; a=rsa-sha256;
	cv=none;
	b=qvvanpcCC3bY1AHrSTByoqqgneNSX3WoEyj5xRq9uTJ/hILXyRpjNO8p53aQ2LNxXrqH7Z
	r78gz1hzkOlNIAozHDq14Tu5lvq2LSiTazlk9asq7SKiMPDBRsYCfMJVcn8CXEn6Un2x8j
	giv7b6fE3nwx3smA8ylDEel05swL1Qs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hd26c3Ro;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759303871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzioRQMYs0JXuknC9NvQHMXej/prRFqOeEb6GzQXI4E=;
	b=LoLkJzdkz82YLBniL5728qXqgNM5JKQODfIbJdXQCbk6MyTWrXfRUg/xvN3dNIHZjNZ9Gp
	siNYPpZkcYPt2u8KvhYwRspjpdE0IU0oq63iIouTPWZum21hlo6IyNoFp2LZap5oQJhAZ/
	uylf6B6WGsrT6F3b4dEgGfI7iwVvImE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759303871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzioRQMYs0JXuknC9NvQHMXej/prRFqOeEb6GzQXI4E=;
	b=hd26c3Roin71Ge34W/MnkFD7LZoSidUkxCyv9b/iu5bTwUM9SlJP3aljadS9x3ve+9l2yS
	Ze3DhGY76Yjt0/PBb0wmAJEIkxUOcJVO3Rwp0YiLZnZxO5FoFxb0CynQ3B1zwJZzQ0Iy/3
	zA8cwRAS2zLKPpL+xo1MbJTmvuZt7qE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-6_uc5dc9O0qRun4D_B4BHg-1; Wed, 01 Oct 2025 03:31:10 -0400
X-MC-Unique: 6_uc5dc9O0qRun4D_B4BHg-1
X-Mimecast-MFC-AGG-ID: 6_uc5dc9O0qRun4D_B4BHg_1759303869
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b3cd833e7b5so498673766b.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 00:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759303869; x=1759908669;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XwqCn0F38LGIwrz+84m4s4y5WBK50BZnma0porbfnQQ=;
        b=s+P1Cyh1ARc0pVEarZkVlYl2Y1RwiDuKyTekeqE3pSPIaHoUfa2Dwz/D9+aVvrmbgu
         bo/n7nZIIxSO8yIWIgSR7Sx+H72ApHfejplL6vYAJciiPVAMysLjSpNrNkf6u/E0mYym
         o7Nau0tG/4aadV6/tdpnYeeRq7s0MGZy+SnewoJHZHcFOYmS0tESFIfzPTKcd/ly6hXB
         CxJPQi9dDbCpoE6/kyKX5mDBIguKFIy5R+NBkY1lp981NU/9Jg+7/o9nTW6+7REfkPwo
         8AjUE0wl16AeDV1v++ABOs8EoNL6K3sdvEGr/3OrzNCC68FJv+BQueA6nx8VVN1vaker
         PoNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5+zWp2+uGtFnImDBzQlpf7wi8poHiPiPAkiD1TVqDwx058Y8ZGtuCoYM9ZLtT/bpKzRU1UrofBw==@kvack.org
X-Gm-Message-State: AOJu0Yyrsv7fW2z4SOHBJLHRsffwDN5+2jHZAZA2+/8l60a8pTVjK99Y
	+oOjoePk2SIn2N6U+Oi1EeJXHBO8JqPq20sR2P4q4l2yFXHsW1whehUj8hPttZfez5S4XzNU8KL
	I7vKK+/JgDm168v/bM7b3Ahe8K2aN7QpXtLBHsPeWRKCe20rDjyc6
X-Gm-Gg: ASbGncu7JpNaGB1ExouJY6sa1DwXsCYAIIXaz8Y7nrt14Z6Pac06YJEKA/sQ2HY0sHP
	LVLQz7JtnYZ0MwAyuZqhYUjRWRAxAGqwbKVEOTGawIVWGUOe25SHRNutBAnczEjsoh+iGZ3s2Ni
	egL/oo0jF9tHq/YYgegTLb5/RYCfJw8X4hC1e+l0ogyuTfLyIjIzFYNYE3n8smw8ucX7Ay1J2NC
	Y6K77jx56Ml5ZNWbEfz0aOpHPQHcqJESPN8RPLRztRScEAohqt970uuhtwsPaGmlMV7T7IZ4Dzw
	/p8OQo3QavqoUKFFdHKu/rcLhhEU3abLmOU4XJLmw8J8hBQJJkm953aS7I1dSBLn0Mpp9SFx
X-Received: by 2002:a17:907:3f1f:b0:b45:1063:fb65 with SMTP id a640c23a62f3a-b46e82a70a0mr303996666b.39.1759303868654;
        Wed, 01 Oct 2025 00:31:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaIeVy1GaiMx10rrLM9SRhGSq3TBVSFud/vfhJoekCF5qafntVq/Ev6Ut7hpUPRh8DghTnmw==
X-Received: by 2002:a17:907:3f1f:b0:b45:1063:fb65 with SMTP id a640c23a62f3a-b46e82a70a0mr303990066b.39.1759303868123;
        Wed, 01 Oct 2025 00:31:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3dc2cf61dbsm648421166b.29.2025.10.01.00.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 00:31:07 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 455952779A0; Wed, 01 Oct 2025 09:31:06 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Mina Almasry <almasrymina@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Jakub Kicinski
 <kuba@kernel.org>, stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] page_pool: Fix PP_MAGIC_MASK to avoid crashing
 on some 32-bit arches
In-Reply-To: <CAHS8izPGxvdDu7JwEWK2=fk=qHoYgFzOs1FjOWjmNwqrU2r0kA@mail.gmail.com>
References: <20250930114331.675412-1-toke@redhat.com>
 <CAHS8izPGxvdDu7JwEWK2=fk=qHoYgFzOs1FjOWjmNwqrU2r0kA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 01 Oct 2025 09:31:06 +0200
Message-ID: <878qhvm62t.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gLAkihQRL95eM6_XiLlfNJEFhTWhmo12boxgXsHzMHs_1759303869
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B802A1C000B
X-Stat-Signature: p3nhsc39e7wpycr3pt7dksanjajbr5ii
X-Rspam-User: 
X-HE-Tag: 1759303871-773766
X-HE-Meta: U2FsdGVkX1/D99pd2fqxG29psv+GTtZHLM3ukQUlA/qjOyeOnbyZLDXiLFCW4j/jUIeI3gYwltCfq+b3XOzzsMiS3EBRJoz6SiZmGgJ/9DrsBHrU7/H3HBP+w5DxKXlnokQwkoz6kISnVFM9KX4jfCTFptMqK/KXe7PRm1gjAPFvt5nTAk7bvzamqxukq8Z6XjICy6RYD+Shp7M/DkuQ7bHELYAmB/Wocz/x7w1lOUFqEBT7m8WmGTziVBR+GzuSFixwyyp2obFgdfJMWTVWKN5RDivW4JbGi3mudsYNb//LtQLq3+sdLW4Q3jJQ6JttRnuZqxvehX+LpDCPIP+kOlxi+YicDHTJYnIe8L3/+X2k35rOjiJOmQ0l+WcLu3VD4lJneeixcxYfoqyWDC0y5NDPbfKc9wjbgXBv6NCUurhFMnHCkLVxugKbmCTYsrMs16v0CqO1yqdgmvMp62wEZfvA27Te5G1iAxCzR260dfvW7ed9vDC9jGIIYlSrtS/eGUjLpvhhCRDCW6wGFjJy5QdMUb/UoSHeAIl8PAsw3aXB31SBQqNVETMbpTaeAWL6pMUSpu5H/5dm8GJi2RbhYtOHDKYpVf5F8mKObveUio7SYh5R/KJ+rF6O9vYADAdWf0I4h4ESNPdcuTODAXFk8aHt7+WteCbMK8qWLXHklcfq0rDJW2gJTfki7Gsrxh96HAu1iSIRUjCHDpo1yKmV2rWKo6wgErvfDxJkz6bikNqjX9Iz1oVteZMmQp+n1WhZc5VkC0u9+PnDDddYOvOfacP4LkSKDCthjhmre7UMsDXLI5ISaOKTTuI6yNuyoAL3ViDOVnUrUle+iGR/nQBSxJqSCJHD1QWqX4qSR4a0QEjXknyk5UN5wi7O21YLNI/TBf538oTEUNAMSUEzQdTOVk7hyGhqhHYNxbv3XpL9BWo+wqj0jNnyIkF7wYoAI6LGaVLuZbxSpkis3sQ68jH
 wolmDVgu
 V88lrXGbLe3NBC4g3IpKIgQRtP6HCqHlqCfZfmUWVill5DBYdnora68HcVHfNxMYSN9Kd+dAQpySGJP1gGaK6taGdwdpbLiZpEVW0D/pO8foH0TfjLmYePebvu2rVtWnS66t680FADD6RnvXV8+XyWt3ygHLxZ0NaHXpmiMv8NJA3FBUCV3wLTmHUHV/VPwR307vsR6rhXiySjIYapRpBGDBNcmOi/t1isIjkkzesN3YZvZLLpEUaF3dIwKXY2PjLwtt5iGOkJnGNwUJXjpocIUxKBsN3Eqqk7Fv60rRhM9dt2hfH4iaW7znf9D4GJq5d4GuEIjkBgjCh3AgyFI76NDSoxRr1HPnExUMWwe8fb39qXrUGvF6qbjhl6kq0iEzF2F7h6paU5QxOtYd44DQ7mCvg6zDrMjzWctDB0XXUSvJQAfb2nS+R5H6gCMV+qNeylaaQ2zTe0NpUaE4IDFc0PYkw/MiVWvjuy6PVLxsfPoSraZbEgJQMSssiSKNIl2xbW407G2NaPM+ABZQwMZndgSuxQcwJK5FeJJ+s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mina Almasry <almasrymina@google.com> writes:

> On Tue, Sep 30, 2025 at 4:43=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
>>
>> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
>> boot on his 32-bit parisc machine. The cause of this is the mask is set
>> too wide, so the page_pool_page_is_pp() incurs false positives which
>> crashes the machine.
>>
>> Just disabling the check in page_pool_is_pp() will lead to the page_pool
>> code itself malfunctioning; so instead of doing this, this patch changes
>> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
>> pointers for page_pool-tagged pages.
>>
>> The fix relies on the kernel pointers that alias with the pp_magic field
>> always being above PAGE_OFFSET. With this assumption, we can use the
>> lowest bit of the value of PAGE_OFFSET as the upper bound of the
>> PP_DMA_INDEX_MASK, which should avoid the false positives.
>>
>> Because we cannot rely on PAGE_OFFSET always being a compile-time
>> constant, nor on it always being >0, we fall back to disabling the
>> dma_index storage when there are not enough bits available. This leaves
>> us in the situation we were in before the patch in the Fixes tag, but
>> only on a subset of architecture configurations. This seems to be the
>> best we can do until the transition to page types in complete for
>> page_pool pages.
>>
>> v2:
>> - Make sure there's at least 8 bits available and that the PAGE_OFFSET
>>   bit calculation doesn't wrap
>>
>> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
>> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them w=
hen destroying the pool")
>> Cc: stable@vger.kernel.org # 6.15+
>> Tested-by: Helge Deller <deller@gmx.de>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  include/linux/mm.h   | 22 +++++++------
>>  net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
>>  2 files changed, 66 insertions(+), 32 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 1ae97a0b8ec7..0905eb6b55ec 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct task_st=
ruct *t, unsigned long status);
>>   * since this value becomes part of PP_SIGNATURE; meaning we can just u=
se the
>>   * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA),=
 and the
>>   * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER_=
DELTA is
>> - * 0, we make sure that we leave the two topmost bits empty, as that gu=
arantees
>> - * we won't mistake a valid kernel pointer for a value we set, regardle=
ss of the
>> - * VMSPLIT setting.
>> + * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that valu=
e is
>> + * known at compile-time.
>>   *
>> - * Altogether, this means that the number of bits available is constrai=
ned by
>> - * the size of an unsigned long (at the upper end, subtracting two bits=
 per the
>> - * above), and the definition of PP_SIGNATURE (with or without
>> - * POISON_POINTER_DELTA).
>> + * If the value of PAGE_OFFSET is not known at compile time, or if it i=
s too
>> + * small to leave at least 8 bits available above PP_SIGNATURE, we defi=
ne the
>> + * number of bits to be 0, which turns off the DMA index tracking altog=
ether
>> + * (see page_pool_register_dma_index()).
>>   */
>>  #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DEL=
TA))
>>  #if POISON_POINTER_DELTA > 0
>> @@ -4175,8 +4174,13 @@ int arch_lock_shadow_stack_status(struct task_str=
uct *t, unsigned long status);
>>   */
>>  #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_=
INDEX_SHIFT)
>>  #else
>> -/* Always leave out the topmost two; see above. */
>> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - =
2)
>> +/* Use the lowest bit of PAGE_OFFSET if there's at least 8 bits availab=
le; see above */
>> +#define PP_DMA_INDEX_MIN_OFFSET (1 << (PP_DMA_INDEX_SHIFT + 8))
>> +#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && \
>> +                           PAGE_OFFSET >=3D PP_DMA_INDEX_MIN_OFFSET && =
\
>> +                           !(PAGE_OFFSET & (PP_DMA_INDEX_MIN_OFFSET - 1=
))) ? \
>> +                             MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_=
SHIFT) : 0)
>> +
>>  #endif
>
> It took some staring at, but I think I understand this code and it is
> correct. This is the critical check, it's making sure that the bits
> used by PAGE_OFFSET are not shared with the bits used for the
> dma-index:
>
>> +                           !(PAGE_OFFSET & (PP_DMA_INDEX_MIN_OFFSET - 1=
))) ? \
>
> The following check confused me for a while, but I think I figured it
> out. It's checking that the bits used for PAGE_OFFSET are 'higher'
> than the bits used for PP_DMA_INDEX:
>
>> +                           PAGE_OFFSET >=3D PP_DMA_INDEX_MIN_OFFSET && =
\
>
> And finally this calculation should indeed be the bits we can use (the
> empty space between the lsb set by PAGE_OFFSET and the msb set by the
> pp magic:
>
>> +                             MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_=
SHIFT) : 0)

Yup, exactly! Thanks for walking through it and confirming that the
logic is sound :)

> AFAIU we should not need the MIN anymore, since that subtraction is
> guaranteed to be positive, but that's a nit.

The MIN was originally there to limit how many bits we use for 64-bit
systems that don't set POISON_POINTER_DELTA, since xarray uses a u32 for
the size of the limits. Not sure if such a combination exists in the
real world, but I figure that having it there doesn't hurt in any case.

> Reviewed-by: Mina Almasry <almasrymina@google.com>

Thanks!

-Toke


