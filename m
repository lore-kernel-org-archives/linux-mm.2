Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E30C1606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V03ycYNv
Received: by kanga.kvack.org (Postfix)
	id D65426B05B4; Thu, 29 Oct 2026 11:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3DFC6B05B9; Thu, 29 Oct 2026 11:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F176B05BC; Thu, 29 Oct 2026 11:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 826216B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:59:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79DE4404B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:59:20 +0000 (UTC)
X-FDA: 85376123280.22.2E2FBC9
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id CB9F9A0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:59:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V03ycYNv;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793289558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=2Iavpt0xD5+NOsPxR52uOxmq8ZYkCHkAdBvsyZeTFxk=;
	b=TNoaxETApZ8/DjTmsZotL0F7NOOorz2ZmKdkmtpqnU7K+dwppYuY/yiHW3LdplN5tYuozk
	j1ayGKi7TmNnGwymYlMbfgYJfThEGrnorhiDTG2UsQFFsGdAIn7xtIamLLIy+OvOwQ745P
	+FudRwlcHCyovak9swQMyX12NLGUi9k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=V03ycYNv;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793289558;
	b=MAGsMPsQiE9CyYCfrg1TcLbed0thxuP6+gmPapnTcNolKliLll0jonV4pwq0bfR+8O6JTy
	hW1+sw4WfG8lTnEDUcb7EvFGBUWY6ZLcHPY6aeRSYiTaLYgbBMQ3iDRK0bf65wle5Ug1El
	3/upxl9luprJhfGHVMBLGOlUKrVzbOU=
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6aa9606ddadso1839755eaf.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793289558; x=1793894358; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2Iavpt0xD5+NOsPxR52uOxmq8ZYkCHkAdBvsyZeTFxk=;
        b=V03ycYNvs0BV5qtpSsnjKftRhjjP0uwLegPDlGQTNPX61BLyqIUqxiZwAEDCn1OFZl
         GZ2iEdmOAcSGItz3Js9/cLRSYNAMq6iDSsLLNivA48KkRdWSym43fQ7x1vuGyLl6FaaR
         EQwYaes63vtWrLAs9Uy2b2gJlB+r6fE5WLbt3g0uGsjVJR0xel+P/WHTafy+DMAYefGg
         hwA3pOIKxyW02HfQH4N9/rirBB4ISGyUejDWh28gTp6Q9Ud7GMym/hNJXUsiwvLEJq52
         YdOOAoFj60yhNvL+RLLui55af8vRMirDV7VjHlPnbr1X8VXbComyfSnwee1G8Q1jkeaL
         QQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793289558; x=1793894358;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Iavpt0xD5+NOsPxR52uOxmq8ZYkCHkAdBvsyZeTFxk=;
        b=SbwDubTGV+qIy9NLxDnfeb09y8GZkdSfG85g9cCDmOo6GWFnKBqiq9CQB7GGEopxPx
         /b4jpcwHdVt0rdw4If0NOAedVHpa0EWFavbM7vrhkDBVzbbWF7UXVBIAcQpH+jb6W/Qo
         r/dOKZUuKOyrBcN0l3yBJvjgui3mhK4jilHsROQPLQ1MJVwTgwIcc4U5cqQAJY9jvGZc
         1DHvN7BsIV48yspmSplObEOPihvp4vqLWdKPAv+fK1hrI5wcAdQIfl8PsXXVwxGlyHhZ
         XEbL1imMiXOAk9W7xte2ezbpfZuiKD7XwsSzT7LTJQXoe6n9erNz9T6JuByFhxSw8dR2
         o6/w==
X-Forwarded-Encrypted: i=1; AKwUvBwzenQJuYh7HN5l0iNjAt3SkGkyVIJpwz/qxETqTevOBFJVh5exfSqj+pBK9s3uw8r+fRMF7NcBWA==@kvack.org
X-Gm-Message-State: AFq9FYIj+8z37WhlHNXGpJm8AwJMBWoAL7qtj86iFLkcr/uC7XrgHHZz
	1ChvThmCeS83U8Fru2uHQaL+TkYCteUhM9h0Js1twhES3seuJNkbeOnZ
X-Gm-Gg: AYBFou2SU2l1FvtEx0H0HInFkOZX3MXYhbbRn/gwHHYtnLabkyRa1v2GRaGPAtG5omL
	xi8Kul8FVMwYBsXcMko4ZuMxE7tlcuG6mSEhw1u7wjGPvbPzKl+obHU2N+tiYIz2/GBuDXdhwSU
	YiarXy4302EiTfmJUhBTgUQFmhblZie7IN1npG2wqlgz9mKM5mF39HP6DixEszU4yIBC1vXlLFI
	ZQffIKJddI+1LMUNZvDpVyT2W4mBXxOZT9eFshG2ua0qdw3pqaEH30Uws6hc3OFlqBjXqNF0Uut
	PbTRDl3hyWk/+QZQMsypilIhVebV1ImSLDsgfEvDYPqQltd2CCOUrjU0PMGiRh6oN7pfk3FmMoU
	rIcx8gPHvbj4sS24qLteYCDfZBjFRbH3zlLsLUD4Z//lwjg3bWNSS4kH2EXPLfvjKd5w6ZDscBO
	saIRAYwHZSHmceSUvFDSgaGg50QANWxpyJRbbtvBB4dOR6qsv4AgjilxRLcFn87kIDFSJG9/v80
	FxKm331YtrjwOia72RuUGmiytCVTQu6fTYsdzN65VGOIt/5CmbtN8aFCKI3pW5CM9sZ+ul1oUIC
	LSe2rVaffeEKgnUrgejMYiAbozM=
X-Received: by 2002:a05:6820:1629:b0:709:529a:478f with SMTP id 006d021491bc7-713ef240bb2mr3244491eaf.60.1793289557756;
        Thu, 29 Oct 2026 08:59:17 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85d33f57805sm182778a34.6.2026.10.29.08.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 08:59:16 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <songmuchun@bytedance.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Pavithra <pavrampu@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH] powerpc/mm: fix uninitialized ZONE_DEVICE struct pages with PMDs
In-Reply-To: <20261029063601.1961415-1-songmuchun@bytedance.com>
Date: Thu, 29 Oct 2026 21:15:10 +0530
Message-ID: <h5i4wlx5.ritesh.list@gmail.com>
References: <20261029063601.1961415-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB9F9A0006
X-Stat-Signature: cgxjhqu37ohhryfgpibwye4jsguhbb7z
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793289558-679070
X-HE-Meta: U2FsdGVkX1/tvjH1YqIk6IdhXvj2Q330vOt/Ggp26ZGvznQ7BhCM3SXJkMej1kP1RtO9KYP31YDgAxCbiS8K8rMO4AD3DX5KNYzY/ep/3V89tp6Ctu6U+jzf4vm5gRo/eAoBp1+JzMpo1B1vfxoGXUGqcAdkB9t/entBuDWQ0VU+Qp6xtqit8exyNVLavCFPXH9IMoVtFB0Oe0lScLnGrPVFdtrY3z/mKuq+IXuUwLqsGMH/nSAlzWy8bfOz4ouKjeafEcvTsn8Df77Rq9O3mnJUsJcprvLrAzNt1dqQFED0G0CRTs7qJDEiAKXPAxziTdAuuEkizKQyJ8zFUaMi4yGkCYEAeQqNJ1C5wN4gaOCMwwOxYH4ivbHC9zeJ1W/u81Tle+xWAfycLYgOKp4GS99LF4CVVsq/s7NQthFo/PnaRvvQ6bof7/5pBiXUu+VvTEFEDHE1XWugFC6bTteg0VvXe9Gt0qAKA33fdjMRUY2dkFCUEHFHymYapz17n7aFOP1hI3L0Dty4be7xF0YxkIhiQ+N9aqZSxsmLOKi+LV7uZ4A/XeqVlt/UiLp5BYpdNUEaIt8DucD/f/v6N0CKZjNuUK0PaUta5OHenbPOa27qWbBitxPNczGv5JtObFll2cUj4bJL5gy/Sqv4XgWyrDFTNiCWlaia4JZVY58sCixGjopKFVf80sG4UTbQwXKi+RVPthN2HZJP8LsQInvNqjoZ7rrYlHEk4bTD8AjiHDqe8c7iWKHEdpfYPTJC70EggBGQn4dKAT/shwEQULnv5s/EkSQQcoYAOftixF+ZgEzSIraGiTGADkTjjjX9JwRETlTLynmRcRRBJFeh9Ksppqc0MJ4gC+5joI2GXyWEDwMDaL6Fh3ZDK82ZCrFpuChRJqRQRKQcQuXmFUhm928j4GNxxHrm2aiB9yClNrB7fgb+dIZGjmXM/NSd3puIiPkllpoeljYjS91e8+6OZNV
 bEb9do6s
 1r6XH870kRF6ofYqX7i4HtR6RdIc/fj26hgSzJ7ULP/DcdR1XPxvSmVD8bS9tO45vGsTzCU9+3DV4fBNx/qPlwffQHpAP5ReE5kMvrNgxjyKE18glLmEZveWVUDRFxDjHmY+on70NJIE1VQaixEGly09HiaU7R4PbxZ+cn+qGM9z68s8rSnT2LLlcKh1ZGT6caI9/TiDzHsUSUHnrvKIoE0viC/0+7B3wvUrDRM188vzHXZMHc/q990PUL3e9ZobkvnbOq/8d2SMTABHkC5o4B2Gu92a2eBOLSkTvjHbDXv5eZwcz3jA3hZxIez6Xh34NOU5xRkJt9HltFbN4x21zkTBhQzXXJdyXwBIhcy3z1OY+9o9SY4pYbuEUk843zN5nKfjfkQSF/DrptCMG0KE0qEN95fNGsselEe4cLXZX4lzGOJRYT/w1asu63pq7kcRsvFTEIXWP4Fk/b92TwqWGQYRlViWdIEYsIiR9mbus6hImLrUYV4beLNK2BwEJTTFr5G8kcG9GWfq86khPB0ut08j7Q7qXlOTOaupqv8feOEggBIyPLHU+CKGMmU/qWm1rB1pNGALeCVr7jEI6vnEHwFj0V6Vqwlfw6p5e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Muchun Song <songmuchun@bytedance.com> writes:

Thanks Muchun,

> PowerPC radix vmemmap population can reuse an existing PMD mapping while
> populating a device DAX range whose section is marked as HVO-enabled. The
> reused mapping is an ordinary vmemmap mapping: the redundant tail struct
> pages are not remapped to the shared tail page.
>
> Leaving the section marked as HVO-enabled makes later ZONE_DEVICE
> initialization treat the range as optimized and initialize only the struct
> pages that would be backed by a real HVO mapping. The remaining tail struct
> pages can then be left uninitialized even though they are still used as
> metadata for the device DAX compound page.
>
> This first triggers a zone mismatch warning in __init_single_page(), then
> faults while initializing the pageblock flags:
>
>   WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
>   Call Trace:
>     memmap_init_zone_device+0x164/0x430
>     memremap_pages+0x43c/0x93c
>     devm_memremap_pages+0x3c/0xa4
>     dev_dax_probe+0x264/0x3d0
>     dax_bus_probe+0x140/0x1c8
>
>   BUG: Kernel NULL pointer dereference on read at 0x00001400
>     __set_pfnblock_flags_mask.constprop.0+0x34/0x160
>     memmap_init_zone_device+0x358/0x430
>
> On kernels without these initialization-time diagnostics, the
> uninitialized metadata remains latent. When userspace later maps and
> accesses the affected device DAX range, the kernel operates on those struct
> pages and panics at that point instead of during device initialization.
>
> The Fixes target predates the section-based vmemmap optimization
> infrastructure, so older kernels do not have section state that can be
> marked non-HVO. Backports to such kernels need to handle the PMD-reuse case
> in powerpc radix code directly, for example by initializing the tail struct
> pages that core ZONE_DEVICE initialization would otherwise skip.
>

Actually that would be totally new code right? It won't be a straight
forward backport, correct? ... 

> Mark the section as non-HVO when reusing an existing PMD mapping, so the
> section's HVO state matches the actual vmemmap layout and all required
> struct pages are initialized.
>
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
> Cc: stable@vger.kernel.org

... then should we mark Cc: stable here with the above mentioned fixes
tag? Because this patch cannot be backported as is to older kernels -
for the reasons you mentioned above.

> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Closes: https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>

I think, this patch should go via mm tree, due to all the dependencies
coming from there, right?

-ritesh


