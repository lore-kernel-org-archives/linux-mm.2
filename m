Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC60CCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 15:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AEA78E000A; Thu, 23 Oct 2025 11:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086D38E0002; Thu, 23 Oct 2025 11:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05408E000A; Thu, 23 Oct 2025 11:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E122C8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:21:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1F75129C8D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:21:31 +0000 (UTC)
X-FDA: 84029743182.13.BA18814
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id C1A3C4000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:21:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sJ5wzkwk;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761232889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2jwrgWQY1h1RtIcpPrpzP6Qz2BnEli8aRyjgsdjGiM=;
	b=JqIxuCZqrXnw8ZaEqfOC2M41aggcV5MwNPOSw7mtq6c8A/0fXVM84pXlEe+aHkvUAZmVJq
	E7yZ4JQ/GimZjut3CgQ/cQ5BImyTwmmwNLUsOG554ozaWrcLUUraCXRIUN5rwVdb1csvmK
	pJ10c2RMGh6ZNX0gvSPylZpdqcmj3ok=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sJ5wzkwk;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761232889; a=rsa-sha256;
	cv=none;
	b=fLXg48j80VWar10gubRJdXPP9q7bsYnOMOkwFk5Eb8dQF9OH1jPwbYRAO6u+VfPpiDrvEH
	U7jGTnI1gQhK/gh/whdX9U6pwgpcSSctpT6EGli4v2UTcGWYbZ0teKWiRfKOBpARc/ZHpS
	iObfrqnZzpXLFjQVixImC3D+LmXpHwc=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-26d0fbe238bso6796795ad.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761232888; x=1761837688; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G2jwrgWQY1h1RtIcpPrpzP6Qz2BnEli8aRyjgsdjGiM=;
        b=sJ5wzkwk1wbUi7C9uM/y1I/SMJIpG1ugJbucwbuX9kjpZXYHRmPFqdAq7/bPa3zwHV
         jrhULmZJXcc8mFzPlWyx3XPeOvlDcSgLAtb+NKAhkOhO/dOm4Y3b945z4drr3xKqcNfS
         8BF71rQKoVRX7qEL5ETi+EWoCxeDMDmyikaonmyNk4dZgPCnScRJJ4R5nObtZrKdhESn
         IfozcrlFenKSGNZ5nuR5F6yGk7xL1VW6ToUctsaJ4ndchXry+wkut0iiMcRHuZFRxvzU
         ZgDIZaHoUuKrDxZXw0mY2Yz1Oa/4Wde12Kd4sEH+H2y6YfrrUNW6KM+a9MSiZghna0c0
         PJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761232888; x=1761837688;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G2jwrgWQY1h1RtIcpPrpzP6Qz2BnEli8aRyjgsdjGiM=;
        b=XvNTohcnW+D4eUcpJSP2i3MENPhKiUIKkwJtiLEkhT9DoloqdvgRl8xrq83ll85Ih8
         WPDddat1mnoDNyeQsYfM33WyVZHz70lqxDcyWPYLhLTpxI5VtRU2r6yD3IPJ0NND1+j8
         3nIEkRIgsC1bUL/2VYVy27jOt7SJNK8xVzDtYH8p5iaLK+4a8QI6y/JwEEuR2ypQN4pa
         0teQGcUSOL9KJ6ht+2uOChMbrKeYUZdUp1p5KaHsc0uT8zRgfCD2xZ1IuVY3S5Qx2FQD
         Zz0xKYuG8iUDP8YPAQ0s+0EGjn+wOiGnYtpDZUqtooSAl50OdoWuTiq3YWO+BaG6jFYH
         r+Eg==
X-Forwarded-Encrypted: i=1; AJvYcCUrihXfNFc/DY7FEBNxS/Hi/5RHDzBLDHIdUHHNG6EBu5byelhfcm55Isx/I+XzQq6rlssiZzd9yw==@kvack.org
X-Gm-Message-State: AOJu0YwyHy/sU3R1arzTA4CO/oLyTfuhJlD5vfVWD35tzxFheuhtkQKT
	wBkovbQGUUJMS6yXH/3t65aCpGjx1MWiiuQ2ZR+LhEkQdwUoocbPAH+AAMIjVTv8NX/8SyWBkCn
	WakJzSEetPYVwFXihg6S6S7+JyiqOGzEFQxO9fZ3E
X-Gm-Gg: ASbGncsJzD7cs94bsGnZ0W1qnoYkO1IUQ3qGX1Iqp/guLUGnjW3NESlogAwnlkXWsrQ
	X/PmHIYQGnvmLorILbYGOu6ElYa18UIVAylwZUJijg6IkqBZQx+VK+yGcgpZ5XvTimWPHvMIfFq
	TYfk20JDL1ZpdY6fupsHW++qipXaXglut1BtB/suMhhysXI0aeyFAQNDTlG+pZPxFpxvD991f9O
	UVypMK16penUzoP0cRg3cp5SF7dlYVRT2i6BHuNnaOK43fUU9eC7gPnztf/77agRsS/lAWZ0o5G
	bRn3GUJVNqZ7hKIklE7t82IgTQ5x+LQ+5T2u
X-Google-Smtp-Source: AGHT+IEWgZ7UzgS2PohV24hBKhF9JtPcksvlA1uoFSx8c8CFEwNgsBYtAGAlA8K3H24IvkOMh8whAfHS8cAKsM7wQww=
X-Received: by 2002:a17:902:e746:b0:28d:195a:7d79 with SMTP id
 d9443c01a7336-290c9c897cemr312219295ad.5.1761232888223; Thu, 23 Oct 2025
 08:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz> <20251023-sheaves-for-all-v1-1-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-1-6ffa2c9941c0@suse.cz>
From: Marco Elver <elver@google.com>
Date: Thu, 23 Oct 2025 17:20:51 +0200
X-Gm-Features: AS18NWBMguvD9NqZ0MBG1ww1DA9Wez_eaadFg_kTQ6tj-ZGocLoyPMGw450Hbw4
Message-ID: <CANpmjNM06dVYKrraAb-XfF02u8+Jnh-rA5rhCEws4XLqVxdfWg@mail.gmail.com>
Subject: Re: [PATCH RFC 01/19] slab: move kfence_alloc() out of internal bulk alloc
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1A3C4000D
X-Stat-Signature: 16j9haia6i3q9dcmhsg7zr5mdcji14w3
X-Rspam-User: 
X-HE-Tag: 1761232889-681082
X-HE-Meta: U2FsdGVkX1/gqODmgLK407VCUJ6fjtb67nDDCI0D40UJMdyB2P1N+LXQSyBTeI13CvtYp4Ag3K5lnXFqDDca35IP7j+mJA19siHBBBMCmPYXKN5z96obtQ4vhmtq6roDWPTE34HgFZLSTubxF0hJwCNLakNahELjMEBIoB6T840fv/2WfWwVZnpJJuX6V9V4/WXQPSK/vVurwF2yQ0WQRMS/i73F5GgOSVL/swQhWnUv+2uSLX6lu4HHmcM19LFU6vFu5TzDKR3VojF7N9RHnlzFay/cRR5gtoUD6cfQ5GXH2631f24G84qKe3ePYR5H1B4Zl4fprN/XcfMzi1D0qGLYO+R4TC3fHzMlioaBtd8ds1vOL2ifsZz/iJTBUDRf88zBpR8gnEw7qtbdRIlKFrrYWFLFLXfD+64lgiTFJHqP9nmgoj6adMbgF3d/IhTqKI7bOglpF44atDkUBTy7YevBp+oqjpdDAiFrYxqNhts460iVCA8ZJbt332mzqxkaXs9EY+l2d2KUCU7fAnUZ6kVSafqb8148paImuZXdQNFLKgDMfxB5UX5O8pPieONq4khCxRWFPLO5U92UKQa2jP9Vu2txOX5lHuIgBY+kkp+T5W0DftEnV7F2Qc7CFiAlm9L9Kz8cY1TD07WlsLGbD7POnTDAs8GhQLSW/E47m7n0zNPD+5AvtU2dikTFm9A/HwxDGHZY0rrE8Ld1C3ICljWTz3LQA8tynaVg2NYT3+bb51W6PIdqY0p0zOeNcPpra4Ql77pNey5zc6i0tl3LN2RTAxjKXSn0vacqQDRpxxmRHBKTvCTx5xMmLdF65gGDswdQfgCiHqbl1a97QQxEWw18vS/zw8eMJ8DpTEGc2LC4t8ZLHu9ZpYZQf5a96wUwzpG477ixkfaeg9Vk8uQMNKdsVaB18mIi2SDIzkVIR6+VQablsAGS9zw6q7htNkuIpwuBL3wb+IXZxih79pA
 HOnJP77z
 /hy6LPXH5900x2hFCvKYrywf61a5cz71Qx0tSwcTNaGDNrUnW5jlx/CcRpLpJHf+ibYfgRBwZ08BZBKuRFkpbTumvlYCAHEZF6582BRmknGfJedHT3Ch2nd7l8VNKHYSKMFL9vu/MmH67jfzFQRr+VWgNgmR3t0wCT4KcZy5A4ikZRo0p27ezS5enrscl7wNfQgU/RDfiY5l8yq8t+FHfK0FRWCRX3hlbx3ak5Z5/uq+1m/pH78olKjz6KI+GuItJvBulQJ2FFOC4OF8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 at 15:53, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> SLUB's internal bulk allocation __kmem_cache_alloc_bulk() can currently
> allocate some objects from KFENCE, i.e. when refilling a sheaf. It works
> but it's conceptually the wrong layer, as KFENCE allocations should only
> happen when objects are actually handed out from slab to its users.
>
> Currently for sheaf-enabled caches, slab_alloc_node() can return KFENCE
> object via kfence_alloc(), but also via alloc_from_pcs() when a sheaf
> was refilled with KFENCE objects. Continuing like this would also
> complicate the upcoming sheaf refill changes.
>
> Thus remove KFENCE allocation from __kmem_cache_alloc_bulk() and move it
> to the places that return slab objects to users. slab_alloc_node() is
> already covered (see above). Add kfence_alloc() to
> kmem_cache_alloc_from_sheaf() to handle KFENCE allocations from
> prefilled sheafs, with a comment that the caller should not expect the
> sheaf size to decrease after every allocation because of this
> possibility.
>
> For kmem_cache_alloc_bulk() implement a different strategy to handle
> KFENCE upfront and rely on internal batched operations afterwards.
> Assume there will be at most once KFENCE allocation per bulk allocation
> and then assign its index in the array of objects randomly.
>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 44 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 36 insertions(+), 8 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 87a1d2f9de0d..4731b9e461c2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5530,6 +5530,9 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
>   *
>   * The gfp parameter is meant only to specify __GFP_ZERO or __GFP_ACCOUNT
>   * memcg charging is forced over limit if necessary, to avoid failure.
> + *
> + * It is possible that the allocation comes from kfence and then the sheaf
> + * size is not decreased.
>   */
>  void *
>  kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
> @@ -5541,7 +5544,10 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
>         if (sheaf->size == 0)
>                 goto out;
>
> -       ret = sheaf->objects[--sheaf->size];
> +       ret = kfence_alloc(s, s->object_size, gfp);
> +
> +       if (likely(!ret))
> +               ret = sheaf->objects[--sheaf->size];
>
>         init = slab_want_init_on_alloc(gfp, s);
>
> @@ -7361,14 +7367,8 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>         local_lock_irqsave(&s->cpu_slab->lock, irqflags);
>
>         for (i = 0; i < size; i++) {
> -               void *object = kfence_alloc(s, s->object_size, flags);
> -
> -               if (unlikely(object)) {
> -                       p[i] = object;
> -                       continue;
> -               }
> +               void *object = c->freelist;
>
> -               object = c->freelist;
>                 if (unlikely(!object)) {
>                         /*
>                          * We may have removed an object from c->freelist using
> @@ -7449,6 +7449,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>                                  void **p)
>  {
>         unsigned int i = 0;
> +       void *kfence_obj;
>
>         if (!size)
>                 return 0;
> @@ -7457,6 +7458,20 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>         if (unlikely(!s))
>                 return 0;
>
> +       /*
> +        * to make things simpler, only assume at most once kfence allocated
> +        * object per bulk allocation and choose its index randomly
> +        */
> +       kfence_obj = kfence_alloc(s, s->object_size, flags);
> +
> +       if (unlikely(kfence_obj)) {
> +               if (unlikely(size == 1)) {
> +                       p[0] = kfence_obj;
> +                       goto out;
> +               }
> +               size--;
> +       }
> +
>         if (s->cpu_sheaves)
>                 i = alloc_from_pcs_bulk(s, size, p);
>
> @@ -7468,10 +7483,23 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>                 if (unlikely(__kmem_cache_alloc_bulk(s, flags, size - i, p + i) == 0)) {
>                         if (i > 0)
>                                 __kmem_cache_free_bulk(s, i, p);
> +                       if (kfence_obj)
> +                               __kfence_free(kfence_obj);
>                         return 0;
>                 }
>         }
>
> +       if (unlikely(kfence_obj)) {

Might be nice to briefly write a comment here in code as well instead
of having to dig through the commit logs.

The tests still pass? (CONFIG_KFENCE_KUNIT_TEST=y)

> +               int idx = get_random_u32_below(size + 1);
> +
> +               if (idx != size)
> +                       p[size] = p[idx];
> +               p[idx] = kfence_obj;
> +
> +               size++;
> +       }
> +
> +out:
>         /*
>          * memcg and kmem_cache debug support and memory initialization.
>          * Done outside of the IRQ disabled fastpath loop.
>
> --
> 2.51.1

