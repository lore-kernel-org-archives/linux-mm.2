Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFA9CE9D4E
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D38E6B0099; Tue,  6 Jan 2026 10:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472CC6B009B; Tue,  6 Jan 2026 10:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F8F6B009D; Tue,  6 Jan 2026 10:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 262256B0099
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:23:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E15AA1AFD0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:23:39 +0000 (UTC)
X-FDA: 84301908558.22.B348E87
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 12132140007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:23:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V4s0ogbv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aha310510@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767713018; a=rsa-sha256;
	cv=none;
	b=IJK56Jt+DTWV9CXvlEGCZX22Z57Jho4mYVr1iIE+CaFIJZGLMyG7a1wwSe9zNpBk11ITqj
	74eYPV20TLVZve4u5PK+VWnVhzAQoXcXSfdsnHZjbOILY+3AIXYg4dAtjB73J6TJc0f4Fe
	Nykci/gQXjAdkXqKoYCJCWrw/FIqWhU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V4s0ogbv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aha310510@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767713018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBqM6O2fnhnvOrXryCzdHWp9tlzBg33CYRduSw1s71E=;
	b=a8NxIi73ZaJOqBQZ9mFmb9eN0UieMZUgssH+MeOOdIgfjzyUHtIIcvfBtU2gxz7hKIBsX6
	2EAvwgLbEJcTstfNRG7s0JgTNjdSHvGeieS0pzqaIxkMarv3f0ShdOq11HoZlmRK0gcekj
	VmNsF/53JW0j0X4sboLv49cFRzQeVDc=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso1190598b3a.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 07:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767713017; x=1768317817; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qBqM6O2fnhnvOrXryCzdHWp9tlzBg33CYRduSw1s71E=;
        b=V4s0ogbvP3XeW+YU29zy4VhXl38tU5OjhQKIPCrEiRukBXOQuEmtvMz33wUup03PMQ
         F6CZhmPStxDLu8o3df4MShg+moSMy5NhmbCNGZ5yJcn1+USQBNGy2r4DdRshWlLnErks
         Ojxy06KjlpXsJtCnmLh8CslN/8pli42QadhDLzWEZ+QtoLP2llSRg3fhSiiQpGZfI9Kx
         /iOFGZJMGmRbyiwmDCcQ4zzkDm9++/n3thGSpU+GVWgUWKZZ64AYWriSZxSyoXMEdA2R
         WE7130HjMutKkBSpt401mMJoirZlDKNEwHX8GBR04VB0kkhu3jZU7BaKBOQdkTIX2LZ3
         o6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767713017; x=1768317817;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBqM6O2fnhnvOrXryCzdHWp9tlzBg33CYRduSw1s71E=;
        b=BrTJhZGMA2Kvu5N1P0Qj7RWQVugK2HwWXiuttCX1CtJMLlybrur59MS6uQr4G+03Jr
         l6BPssN4+Ry/b4K+U2X6iWFbo4f8EGHy+M9FDGurlTFS1WkwkmGkWmtiOErcA/Yd5tAP
         24NGD8SLyorLtvXNZvqxc1Kv6LFe1AjLG1xfjLvPAcViBWM1uS+dhP0uFvva5WpIWf6P
         txZRRM3qiqBZ+qTZSU+0Wmd2EstUDXT7aq7SGTmG2pQWwrrmrGGzMmMaLlDXJa9ZvrKp
         5ykKiSK3zK7b5Y6fcCRywj6XssrETfSFZTQTryhKIc3wybAOHimINWlkRWpCwdZMF24O
         rMnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkX952+yOLYUgUcUwrg8kHSwJhIj5Cs+9vl6iyEvwBRHG1B9joxaZ2d/43PlVJ80srylQdkT4B3g==@kvack.org
X-Gm-Message-State: AOJu0YwIIg6aDKdU7NQR12oFQ57ttTE239Q056Vaomv9OIbe99DOoQUG
	EPR8TtEy+c2lTIrGezx060ZImXcbPwKKCHKSEvB2kQD5fECkPvg/IvQy3d8K65pVQRog83+Dv/C
	UBUm2iVbOMtHwZnBLgoGoulvvbvxugA8=
X-Gm-Gg: AY/fxX7S0GpZAOcZ1UPg7X56YLiiSUPIeYWFLMb5GdYymw/zRJmtpZhf1Dp0iz5suT1
	6bWosVMaJc260Mn+s49rR+7nZyV9WJCg9indRDWOp0awwsQ4umIZeIjjsK2+26+IChSdwqGjtJZ
	JwMCaeNMw2ceNiuidkik/SmTNqZs+glF06KZMeeFbv/R2QywfPMvnqJ28LZ1hNVH6Qv7GC7tphk
	8y3OkFQKraIUaEAYfLqBAh/vmh/jEtB9Zg7raYKdAe87xQ3S/Od+D9URDteRU5GOt/8sKUBgw==
X-Google-Smtp-Source: AGHT+IE9bORTCKypDc1PqvfFYjBUroDU53PJJo0MGyxWQYHEr5KM77iPPkHbhUj8qhDxQkqMgPnoXv3nxwQwen8Z7gY=
X-Received: by 2002:a17:90b:35cc:b0:34e:6b7b:ded4 with SMTP id
 98e67ed59e1d1-34f5f3441femr2128630a91.36.1767713016818; Tue, 06 Jan 2026
 07:23:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com> <6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com>
From: Jeongjun Park <aha310510@gmail.com>
Date: Wed, 7 Jan 2026 00:23:28 +0900
X-Gm-Features: AQt7F2rDC-SGpZkUK_mRW6olBAMMdVnAp0c1TY11Bej_aJLGQIuJ38xcVtBFQ_g
Message-ID: <CAO9qdTGp3KxpGjwfsKj3rADXsZLPbBY_XYyHJTy6NVgBF9U+0w@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm/vma: enforce VMA fork limit on
 unfaulted,faulted mremap merge too
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12132140007
X-Stat-Signature: cwc18639zikdxzuoeq7sjayd1mtuuk7o
X-HE-Tag: 1767713017-439510
X-HE-Meta: U2FsdGVkX1/L5ZsB2ZChIaPh7x+3mjYORLbNJM6ImPWqiB5BF+J/oWd8TCSbb1itDTiIn1cpvz4dTDnZRgtqgieRE6iorZxzI6rjLqHtrSOER66wdMtHG/0WDnGUrKsaNSLV/Ckl5tr2Xu+hRegguVSef61sEa5BUbnYsNo7z8f0sexuvCv8sVuQ80+2796hGTtJ2T3+Funfl+lrWn3ADxycrqKQavnoEd7wFGQCeTZAE6p3h4S3yUin1bP2jZ+1jL2ZtHo8r4na+lgbX0OdQv4gCnEAQFgxlArROm5++Z1sti4dfdsE2ANiN930JxhbUpoPm2r/EeA3sOLcm5knQRaYs+5bHJ5TYmtWyJ8mkyKqKk5HpV8iKXV6tIsv2lVm3WIK6ue80lPo/WROfICsgWzxamCDMLSdG21dVceIG6CwKFshI9+XYsrNbmaCfAndLFUTqcE0taEpyDZ6h90zEZUwPQv/9ImIk/+YkQESbRhRCtnwhLBGAUG5T0GwUwWKqxcPfEEoQKhpCPbissX2lNFOR9wsqmRx7qJ1CqcfGy3SECVpPH+P7HGyo9itDGE6skWYRyA2AURczfQakb9UVs6/pS6GBq0/H9sNILNIWXo5tf5EQ7y6qZGKiz1OvVxOBgh3U0A8sUjqGf+2Efzdn8mzj9LQJropJLvFKXrAluuZK99uMteizgKz/ckJXOk+Z0ABzhHfFoWKCLc2w67JOXgg1M98O3baLSf8s8kBHhelQ1xYjeXuSkHBg+b1m89yaqmLJq2HT3jAT7MT0kNM0TB2wq5WQd9Ikcj6na6dbF7tZbALWgwVw+LOSCQkbsb4DyMRHtHYeS97+uupR1sRYF9aFQB1Bm3d4xQtiJSk3zM8vJmYSWsuXldIcEP9IJTygyBPaCgGIM/5EwH6uO5897P4RsK6GsL544lrgO4K/rrCpoKMuprfturue7Xa/LTiPn35TpmuUC9FOfqbZl9
 iRSS7VFb
 xpsjTqQi9DK9G/qZAHypvpQvOzDgmuQjfcWoahTzPn0E2+eNGqKxFeKKVjR7AOHE9sZguEgUTXzewJYPTeqe8bbSyFtgaP4yVMJC6PY8fOQdYB10fSof4SiqkBW3k5YVHxBU1/PhvRhnVi9PNu49wD1gp1D0XyQYsUtHTXokYXmTMtCDI/scY1gAF2TXh0EmekAUOOXYp/XIy+BBkBorcOO6ClWv0dA1MtjLuUroLuZcw1NLgg04zuHyklq8hzxj0I9cgrgC+2qMu8ASviBcuEH4CxZHrovgnC7Qmc+LCgQ28/eQgMwpauGPU25xid3Yek/ALP+Ph5c07Zz41l2Y71SCAjQaw3bzQMZ4ATX4RpALIeDfyVdi/2uDNFEJ6WtG9fWRdFfFbUbJn6ryZJ6KXAErCJGaV1HVNRK8srLCVeUYbqcg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> The is_mergeable_anon_vma() function uses vmg->middle as the source
> VMA. However when merging a new VMA, this field is NULL.
>
> In all cases except mremap(), the new VMA will either be newly established
> and thus lack an anon_vma, or will be an expansion of an existing VMA thus
> we do not care about whether VMA is CoW'd or not.
>
> In the case of an mremap(), we can end up in a situation where we can
> accidentally allow an unfaulted/faulted merge with a VMA that has been
> forked, violating the general rule that we do not permit this for reasons
> of anon_vma lock scalability.
>
> Now we have the ability to be aware of the fact we are copying a VMA and
> also know which VMA that is, we can explicitly check for this, so do so.
>
> This is pertinent since commit 879bca0a2c4f ("mm/vma: fix incorrectly
> disallowed anonymous VMA merges"), as this patch permits unfaulted/faulted
> merges that were previously disallowed running afoul of this issue.
>
> While we are here, vma_had_uncowed_parents() is a confusing name, so make
> it simple and rename it to vma_is_fork_child().
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Cc: stable@kernel.org
> ---

Reviewed-by: Jeongjun Park <aha310510@gmail.com>

>  mm/vma.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 660f4732f8a5..fb45a6be7417 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -67,18 +67,13 @@ struct mmap_state {
>                 .state = VMA_MERGE_START,                               \
>         }
>
> -/*
> - * If, at any point, the VMA had unCoW'd mappings from parents, it will maintain
> - * more than one anon_vma_chain connecting it to more than one anon_vma. A merge
> - * would mean a wider range of folios sharing the root anon_vma lock, and thus
> - * potential lock contention, we do not wish to encourage merging such that this
> - * scales to a problem.
> - */
> -static bool vma_had_uncowed_parents(struct vm_area_struct *vma)
> +/* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
> +static bool vma_is_fork_child(struct vm_area_struct *vma)
>  {
>         /*
>          * The list_is_singular() test is to avoid merging VMA cloned from
> -        * parents. This can improve scalability caused by anon_vma lock.
> +        * parents. This can improve scalability caused by the anon_vma root
> +        * lock.
>          */
>         return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
>  }
> @@ -115,11 +110,19 @@ static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
>         VM_WARN_ON(src && src_anon != src->anon_vma);
>
>         /* Case 1 - we will dup_anon_vma() from src into tgt. */
> -       if (!tgt_anon && src_anon)
> -               return !vma_had_uncowed_parents(src);
> +       if (!tgt_anon && src_anon) {
> +               struct vm_area_struct *copied_from = vmg->copied_from;
> +
> +               if (vma_is_fork_child(src))
> +                       return false;
> +               if (vma_is_fork_child(copied_from))
> +                       return false;
> +
> +               return true;
> +       }
>         /* Case 2 - we will simply use tgt's anon_vma. */
>         if (tgt_anon && !src_anon)
> -               return !vma_had_uncowed_parents(tgt);
> +               return !vma_is_fork_child(tgt);
>         /* Case 3 - the anon_vma's are already shared. */
>         return src_anon == tgt_anon;
>  }
> --
> 2.52.0
>

