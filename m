Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B5A9D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 20:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0576B0031; Thu, 27 Nov 2025 15:44:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60D76B0032; Thu, 27 Nov 2025 15:44:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F8D6B0092; Thu, 27 Nov 2025 15:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7F86B0031
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:44:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F1465830E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:44:09 +0000 (UTC)
X-FDA: 84157564218.27.19613EB
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3471B140007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:44:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F2XIMoVp;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764276247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwCD3atudzQaR/LDn9XgIygiEi/nCI5QmZX0e0EMwzk=;
	b=ssgwa697MMKbG1WfWNrNxKeZaQZm95GhlrFjG1IgaVGYpp86bkNulftxW/zKyAryBOMryR
	NQ3aF2NTwG3LKExE9M8rBpVMLEI0iXsvWw3ULSQ46cj16pKItG/+cxP8NtWWIrEN8ntZh5
	tW66+mo9L+oFAeSHGylEkEbh/lY9MaE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F2XIMoVp;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764276247; a=rsa-sha256;
	cv=none;
	b=x4SM1oPkLjkc8kex42Cr7RrAezlm1xxwZqLUwpKF7pRx9Jn7AWdgMpNhYKky68qv63Hsvc
	9TbNcaXf8n0vU0JcU9C0gX6ghQnqaI44LM7E1+WWgBhqnOK0s9FHcSzygl8k9sYqCxp/cJ
	NWNf6BaOMEex3ibFXZk6Zyc3HbdHiKw=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-882475d8851so12568776d6.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276246; x=1764881046; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qwCD3atudzQaR/LDn9XgIygiEi/nCI5QmZX0e0EMwzk=;
        b=F2XIMoVpmHmKHaZbPbQJfOs7s3AwN647UhbSYksLEA9SGi+8r5a7pGGKcuyIgjQ7F/
         acss+1Nnf0fyj6Xs/XWJyV0qV5b2GE0cuPoB24Eh9f824KDQJK7TObmI96eTLUMWicZm
         SWIAlhoErr33CvB1HNbQLzFSeJYI7iGc4DSmxnVE2u/70MElmqaL2wWi6Wd0GZE/j6ay
         +qUxNnsbPmkBzI1aUxGeDY14DYFejHUpqy7bvfJPQcNDGL5zySoWyu0LIw9XaqEDScoL
         xlpXd5xrLln+fmFukVBem23lkivL5kFC3SwcQLUeaOdQEodbNQPNYWJXaxUTBMJxPtPb
         BWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276246; x=1764881046;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwCD3atudzQaR/LDn9XgIygiEi/nCI5QmZX0e0EMwzk=;
        b=hYYxqHvw9dShZfyL+EOv9pBlqHX17F8088NiWtHXGTJhuyoHws+4dGeTpPrFyBbZXe
         zzr0wkJULQp6mKdXQ5LU4FigvtTMbIWxX6sR6qUkBqXqi5V8XoD8bM6O0nRuafcjQg72
         tsyXJVyrIlHnFQgtwnw+3a9R5T3ZNAEFaBsdnNv68QnENjcxWC2Kj1bvqDPZ6WqLJyK4
         umWqffuFjCGf673nNtFTTzgAoO8Ie3jadtA6dW+ID2M6whm7JhaPaLom7bW9R0L9AMLI
         ZRs72GzAsaz/TlWO/zW/fAwMck4Bop7IbCABLV3m8FMgJpcyg9LfLM0ht/4dOJwiOZSq
         I3iA==
X-Forwarded-Encrypted: i=1; AJvYcCVVkEArYacezg7vaiurlkv+g6lx0LtgHq3zT/Cy4lYSg7XH+Uw84bvnRGQXYrRmq8E2ZKFM975jHg==@kvack.org
X-Gm-Message-State: AOJu0Yxv5YI/H25fuHTXDpHlfnu/SiXPe5Dtyu6A+GGWeXdbUsavgqT7
	DoFJQQnoqK3Qm+bQqy2AaN3BTyQm+Gieo5hZtQxdSKw/MoMX5hxQjwDmoeA7pid/S/JfkzkbcPk
	M6zsqn1wdq5QAUSGk0pgpx/ctmVzIO40=
X-Gm-Gg: ASbGncuz72Kp5xpra3dgrXrQx0Jnv84Qm7Lh58Zv0MZ0LYGCXHSxzIrvUAusJ6GsDxB
	84EwNDeaTLeu7h2i5OSQYGq9o0k2961p2pFJQKGC4TmYZR+84Z9NVSIA9Y9pkA4z6+OiS9o+lk1
	974lQqGZEt1Ki38bvUCv1+sNvmlF7lo7BOGwfipv/Zq53VFVu6PxGeE0nDvaJphLVt6OgWB2nUp
	6riDcJ9SG5hJ6VqvRzywLs1xOBoZPUrf/Tt0d+Sm27Yd74gkyJOXKqN/JTJMi8TRelWTw==
X-Google-Smtp-Source: AGHT+IE7voQiHDKLB4NwV8zGSE3REVdUO0e8yn38MIWlpfXSI6ZQdpofqkZUcP8t3D35swjRjPiF80F/keI36AiYhgc=
X-Received: by 2002:a05:6214:4018:b0:880:4c02:c49 with SMTP id
 6a1803df08f44-8847c49a3ffmr351784406d6.23.1764276246078; Thu, 27 Nov 2025
 12:44:06 -0800 (PST)
MIME-Version: 1.0
References: <20251122090343.81243-1-21cnbao@gmail.com> <aSiB-UsunuE7u295@milan>
In-Reply-To: <aSiB-UsunuE7u295@milan>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 28 Nov 2025 04:43:54 +0800
X-Gm-Features: AWmQ_bn1BA-EHgk099B5JdrbxARNS1wqxvNFJMmU7BmZqAfXIiS6yKlNivY5AG4
Message-ID: <CAGsJ_4z21fN2KSg6jt_qveYgrKZw1Vsi_kb+uhed=RJAbujMHw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/vmap: map contiguous pages in batches whenever possible
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, John Stultz <jstultz@google.com>, 
	Maxime Ripard <mripard@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3471B140007
X-Stat-Signature: 35eta9ibws19kp1pqsdapfz6ctno1uxy
X-Rspam-User: 
X-HE-Tag: 1764276247-154245
X-HE-Meta: U2FsdGVkX1/pdklQikNCFs0Yn76huxGwBvlln1Arw5nyLCHoAxyKScmmZlk7AFuzVrrRVmHZiD6I26Lzn2sU28dOhPe77kK88E4OPT96/2YbvjkxocL7gkSzjA5V+6oYbgTooKaewGz9HCv/fujGJI79iJDupoduWNawogeYmsHTrn4HsB7Ko7wLED3IaV1gMrnLi33OLf22Z4U5dR+biGByS4qoEaXYXOBi5QnRgv+GtwXMuSPsUpN5qEQlSkevvovb/cThzyXPmCH8RINHVuJjQxIxUKNuK3TNit5RU11HhEvmm+HJlHNph9j7whxJHQxA6CF4oISjXpmcHhsxUHefgZBUuMHd0ne7RdwRtIhI8NjlfltfB2MSLRskL+Gv9oGZjfiDWA0fGPxa+ARuIX0fywxUt0XsNHjpQHf+Bnp0nG6FOb0HRuHKkIIAE+bib82MwnHC29KQiWaYZrZN8kdP7BEr6MIKE+Tisstveyx/wFdfxSwwN1W6sJ/88/BQylsbjsljHpb542KruhBY/vxDh0M10diKNAtGKPd2938REQPpT/BX5juLa47Bn3F6HigHrMLn1mpVLhYSec1PLvB/47ESzdGjUcWNwZlHt3+mQw5TDs3LZpYw1quQZ1KukD93tMFxQItXsOOAakX4sGvAysG56X/01s39gw/SQkEI7VGb2FXiSYAvzL4g+iIoausshLxaD8zuvOkuyDnHKnFUOmsdc+ao5JhhZspcmc5/yGalZckAjxaaJfVwSobBRPvp+Zgt8VOzLNfkQ2pliQDq3sR+/tHC3qP92PZy6vtioQFsz3aJ62lC8qBfS5iTA+BLFDIw1ETxgb++M1WLdkoHbvWKxsGMsr/VaerpNxwEvXDu0huowfJ6NcwivVpd0zHYsSS4FqIfuOwMh4ugLj0g43BjcRO2v8yFFxLJm4h+Ep6zUwNoJugRrqezgz+hKr0N1aQ9S7VjQ3wYgBp
 cWAxEOBD
 mtpzDUBdByv8SADF6hfU7xpEQKnz+LbUd9LgWiOQVPX4ikGHopSRSpLPlHqnbh+QFI90NX5CRz7Ut55T/aruhrwxmmjMWJ5nkKkk5gVRi1wkz9ZePDnAbCi1mdeI1/+AVnpwj8oY/4SDDLVW9J6lhYL9Yn1/bm61MzwDYe2085L7XY0fGxMI8b3Ssz9eVHBuIZ27p6GFfBRb1S4DQj5WKemSk58nNXIX34wLY6xuluxnYVar+GJUcleQN8HNMQIvpdHKL+dSdAtACVhIqupP3pKmtc+zyzoz8fi1wXz+R7yusaklKf05U2T95fXlDxCPJuvkolGkk9PzJa2K9RYWdboMWPwKmYQO5dAM6GE3NwUrLRVE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > +     /*
> > +      * Some users may allocate pages from high-order down to order 0.
> > +      * We roughly check if the first page is a compound page. If so,
> > +      * there is a chance to batch multiple pages together.
> > +      */
> >       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > -                     page_shift == PAGE_SHIFT)
> > +                     (page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
> >
> Do we support __GFP_COMP as vmalloc/vmap flag? As i see from latest:

This is not the case for vmalloc, but applies to dma-bufs that are allocated
using alloc_pages() with GFP_COMP.

#define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO)
#define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
                                | __GFP_NORETRY) & ~__GFP_RECLAIM) \
                                | __GFP_COMP)

>
> /*
>  * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
>  * This gfp lists all flags currently passed through vmalloc. Currently,
>  * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
>  * and BPF also use GFP_USER. Additionally, various users pass
>  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
>  */
> #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
>                                __GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
>                                GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>                                GFP_USER | __GFP_NOLOCKDEP)
>
> Could you please clarify when PageCompound(pages[0]) returns true?
>

In this case, dma-buf attempts to allocate as many compound high-order pages
as possible, falling back to 0-order allocations if necessary.

Then, dma_buf_vmap() is called by the GPU drivers:

 1    404  drivers/accel/amdxdna/amdxdna_gem.c <<amdxdna_gem_obj_vmap>>
             dma_buf_vmap(abo->dma_buf, map);
   2   1568  drivers/dma-buf/dma-buf.c <<dma_buf_vmap_unlocked>>
             ret = dma_buf_vmap(dmabuf, map);
   3    354  drivers/gpu/drm/drm_gem_shmem_helper.c
<<drm_gem_shmem_vmap_locked>>
             ret = dma_buf_vmap(obj->import_attach->dmabuf, map);
   4     85  drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
<<etnaviv_gem_prime_vmap_impl>>
             ret = dma_buf_vmap(etnaviv_obj->base.import_attach->dmabuf, &map);
   5    433  drivers/gpu/drm/vmwgfx/vmwgfx_blit.c <<map_external>>
             ret = dma_buf_vmap(bo->tbo.base.dma_buf, map);
   6     88  drivers/gpu/drm/vmwgfx/vmwgfx_gem.c <<vmw_gem_vmap>>
             ret = dma_buf_vmap(obj->import_attach->dmabuf, map);

Thanks
Barry

