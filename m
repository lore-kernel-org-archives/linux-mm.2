Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EA7D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 11:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76A96B002F; Mon,  1 Dec 2025 06:08:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26EC6B0031; Mon,  1 Dec 2025 06:08:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915A86B0032; Mon,  1 Dec 2025 06:08:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4616B002F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:08:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BC9F8404B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:08:30 +0000 (UTC)
X-FDA: 84170628780.16.3385A80
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 44C9440019
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:08:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MTM8EC4V;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764587308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apPnjqLgYv5KFdQVAUozAIQDApH/iP9GbYj6xjZKpNk=;
	b=uuI84FMCIj7yhVOayg/vEU/gCR4cfTcn8Jfhl3MRpU4mslRWGshDBNO+fXc4MSOIQZAFt9
	gJD6vfxiAwqDlG+Id/FOIEbUuYAgPWKvsc+lDPD6uMDu1OmETkiGteb98ySpAItyWZIWRN
	b8y4ft8ezAO3CAQqLRfgZ1hImqeeU3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764587308; a=rsa-sha256;
	cv=none;
	b=sY3mEh8f70CF0Wkhvdjj/QTJhx+vM2jZrSa62YtLldNFYHfzZhpL5lp4BC7Igxwxe+yqS6
	grGoBXKOFoHjT5zodV++YilqU+WQDh1z+lVCxLyYJ63EjJL9lTTVQR/kHcD+FmEEp+V8kT
	8jj8A6dnK8fSkKXp6hE1cdUh4tPulI8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MTM8EC4V;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-37a2d9cf22aso27121371fa.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 03:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764587306; x=1765192106; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=apPnjqLgYv5KFdQVAUozAIQDApH/iP9GbYj6xjZKpNk=;
        b=MTM8EC4VbTohaAo0ngBbqAI509prhzdyDgijbO4S4jMpfOp2XohI7nse58kalpdm7Z
         K3rfjx8uWGvJKv+giv8gJV5i9ibHSc0zXeMYzp+HA+RdKU66c03iUtE/s1OpepZR6W9f
         /+JC4Xpy2cBBsLiKQkFZZSRWTUH9GLFQ3jT8qaNMmVrGeYS+tg4vDUHqX7rixZAAYEu6
         FlyQm8Lh6yTOzJhIlE13FtqeGTgTGne9fqfhQR2514b5lXVk6JWl7zz0kGkh4ux8rIcw
         8jlklKgUQoCKwr7Im/YEbUzkFNKHk4oJgjVGYcSriAhydB77ihuwD/3QDUPZRzGGp7dD
         9D8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764587306; x=1765192106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apPnjqLgYv5KFdQVAUozAIQDApH/iP9GbYj6xjZKpNk=;
        b=goakZFrnzTcuVPU9T0RbfpMc4Oi4EfEI5Nd+E4KpTdCQQ64WuDHzVZGtmZ2l7LC1Ik
         3THUaRLq1TmqatRw6H/VAcYmQkkut+oYnsmpv5Z0RqXN1q8yK1ESEavLVo4jFEciYhTa
         1ua391D+KY0ff9eeyrZz5RLGIGOKBwFePGh8KT5LXkgB2ZSQgKIU/CPnIXuWwxDecbXg
         OSCF8SC+2Jti65sxw8vyLuovekaKn/w6Fzs90VDcHmUh+5HTQtb1iI/IGDysuDvwyyIo
         1H0JE25/3pVvOGVXZsUxdnwwruACYjIyqA75XEPGs1ATwhAR908p6bA1bdJgQdw4fRwG
         W6Yw==
X-Forwarded-Encrypted: i=1; AJvYcCXvSCcxBdMfpxBUUWjDjjzIuL33F8PWKB/wUddm5XVcUCirGcu8b0wJ+zh5T1Ao5Uaa7R2jrj3J/Q==@kvack.org
X-Gm-Message-State: AOJu0YzdoF91HdaSgRBjeRd9peKDqaaT+AAK1K/Iwndf3gsykWSfowyA
	NMiDUj5odbmrFY83TTwFP7UpqPxDXySVmiwXQES7pvtE6Qkg7zVNE4FH
X-Gm-Gg: ASbGncu2x1vGPMVxvGz6CbB9/J3GjiTRGMstzXI3c1qNz72NetXezVqRPeg4dBE6elL
	81TizaGv+CyUdVhJdhXFUSBIw1FsOTneHsdBBUIE2sY+FKTGngUiIbIdmI4I0Bp3nu/mdsIay6a
	Vyte1I/1ewoKzOPXy5mZmhmwFyhYB/zoNn7coKax1Ugt9lGXpXJhx2CbRkPR4IHOBnmJCaebZgD
	kHp4erLpcmvc5h/shCOPkvmTP1SKUKrrK/RC33lkXosXFgckDsjui+XeNPd8clciS1cfRSyoI7Z
	HmJJw+mDKPbUtHeLxUJ1NnCTUYTDN+TmMnyBie8i466ytkejLM9DahEz5QGtV6MxvLqzX6GKtFk
	UcIEhHohsp/d0E2Ly4ILW+LHE6yGJslZ6Igf5VkLnzqUqZPf7V+YsFA==
X-Google-Smtp-Source: AGHT+IFYuTqVq/XXzpVDPZNlji0QpaJTMsgY/VJiO3ObVzX6tMfBu+vPiuyhJLxl2QXQDIY11tZWpg==
X-Received: by 2002:a2e:bc26:0:b0:376:41f5:a6ca with SMTP id 38308e7fff4ca-37cc8213bf3mr101258641fa.0.1764587306127;
        Mon, 01 Dec 2025 03:08:26 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37d240981cbsm27895361fa.24.2025.12.01.03.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 03:08:25 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 1 Dec 2025 12:08:23 +0100
To: Barry Song <21cnbao@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	John Stultz <jstultz@google.com>,
	Maxime Ripard <mripard@kernel.org>
Subject: Re: [PATCH RFC] mm/vmap: map contiguous pages in batches whenever
 possible
Message-ID: <aS13J6U-QMOrwwbs@milan>
References: <20251122090343.81243-1-21cnbao@gmail.com>
 <aSiB-UsunuE7u295@milan>
 <CAGsJ_4z21fN2KSg6jt_qveYgrKZw1Vsi_kb+uhed=RJAbujMHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4z21fN2KSg6jt_qveYgrKZw1Vsi_kb+uhed=RJAbujMHw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 44C9440019
X-Stat-Signature: 1m1ekxcg536h4uoeyrbma9kdpft4z858
X-HE-Tag: 1764587308-487834
X-HE-Meta: U2FsdGVkX1/A1Y+xywkmGelchXZIOgbTjuTn8gUmbCcy7/sBwS0GSMKPEYBRwQp6G0F6VZTYMQYbEvX5ReMsX0HgEWy3U/WwrTJbkMPdFYIKaUfypIEXZ0JAhScQukN3ib5hL7pg72mrC78m25I3y17PttypQb9wkbJGIORyNzKrHfCNAAbs89QwaZEgF+8YUmgbxNU7ZqJOrVhrKrGpmM3MA3TQQZbYZtbAcPkAxXIMP3486EsWPO8fXjQ+1+2qPjeiHrp/8k7WZ2MtzVv7Uskd5Ng2J3JfTBIP31hGTV86LL6Ls5579afdY4nvz615QH1WDvNg36JfKNJSiUVFZg44Wku9bpVLfiSeer65DgDy90UK/sH8uuhXWXdn3c45AU3z9ZmW5ySnXNlx8CUfD7/D3HAnBXaSB2aqbr/TSvrbAB284mv1rS7thrHsA+2tHGJDvROZ6MJPzuipimyWqluLMDuG8AHpVoHbcUUSTMLLyGBYlYj4kwAUeULJGa2E9U9uGhb9RA+z/fi1CRnw4+aWTAJKY7uEfF9SVQtwyvV9fJrJdf5MwukX+w8SzeRy7X9r1g0pp1HX66Ycl5JtkyBlOdjhVN29U0JCDGavrXskp95REhdRhWOhE10qTiC3MEprew4SJpWeClnlAzjTAUckvadCXnOY7/xu91r81ZT17Hi4BBQCZE0F8TV3Mxst6fmsg9lRqqrOZKQ3/Dfq1Cdn9zPfsGVQ6ZXGquDmqA1lnJsDY6deh6p13j9baVa64LPCJ/RAzIbkbenJ2zqx+khw7Q72oLaOLuOvGyag3jxUWAEBb/SaGs5zBu+ntCxBmN7zVbp0H+3fx+ANgNQln8Dtq/ukpjcQ9ANZf8FJBfEDdyNbrQhuVoX3EIPbb4yx+EKpwDhhvPdl5W/Z+KhGOsQB+jyP/C09zJd90bS/2aHF9pxAkuJ7ykzXMu7c3plNFvmaoGXNePvDajd9OJp
 AgFK9juD
 3DZr0ewT/Rdfzzh9JyDXpyOUJcTvSXveYZALJFd1BP2mg/3e3lNM+6oTyeXUU+StQT270UKl4gaKXvpEgICSyHM8zfjR+27CwwX9tM4j/4/JI7366OS9uUMmPQa2KHXxHyXxcA152ZgIIGnL5LWTLhcfR/P7eGS8ZNWhK4LyiSqdjM9/BK6VMPoQQnCyJgxztk4trQA5qxEKvUgEAHole2n7318PKNH9Z/rZTG47zsBT9LoLbfN1vTWWSqkmSmyMDSe+4eE6oy7cTos+EPzoCiM8r0WYQFSadHeGJ0S0M1C9HbQ3v4vHBK4iF1C9SnFAn5Sh7KM+LTykvfryXJvAFviudPoXraPUvuA5pWBPY5pF58bpY22FNO+34SNPNqnBs1GhpZS8eJ6kk3dQvRCSNDB1nZgnNb8EDdFamvcMDZB6JMq5iq+9NunnqLNYcrS9QjdwHFkKIO5jakRKdRG8HiuUQhV0N+LCPF3UU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 04:43:54AM +0800, Barry Song wrote:
> > >
> > > +     /*
> > > +      * Some users may allocate pages from high-order down to order 0.
> > > +      * We roughly check if the first page is a compound page. If so,
> > > +      * there is a chance to batch multiple pages together.
> > > +      */
> > >       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > > -                     page_shift == PAGE_SHIFT)
> > > +                     (page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
> > >
> > Do we support __GFP_COMP as vmalloc/vmap flag? As i see from latest:
> 
> This is not the case for vmalloc, but applies to dma-bufs that are allocated
> using alloc_pages() with GFP_COMP.
> 
> #define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO)
> #define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
>                                 | __GFP_NORETRY) & ~__GFP_RECLAIM) \
>                                 | __GFP_COMP)
> 
> >
> > /*
> >  * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> >  * This gfp lists all flags currently passed through vmalloc. Currently,
> >  * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
> >  * and BPF also use GFP_USER. Additionally, various users pass
> >  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
> >  */
> > #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> >                                __GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> >                                GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> >                                GFP_USER | __GFP_NOLOCKDEP)
> >
> > Could you please clarify when PageCompound(pages[0]) returns true?
> >
> 
> In this case, dma-buf attempts to allocate as many compound high-order pages
> as possible, falling back to 0-order allocations if necessary.
> 
OK, it is folio who uses it.

> Then, dma_buf_vmap() is called by the GPU drivers:
> 
>  1    404  drivers/accel/amdxdna/amdxdna_gem.c <<amdxdna_gem_obj_vmap>>
>              dma_buf_vmap(abo->dma_buf, map);
>    2   1568  drivers/dma-buf/dma-buf.c <<dma_buf_vmap_unlocked>>
>              ret = dma_buf_vmap(dmabuf, map);
>    3    354  drivers/gpu/drm/drm_gem_shmem_helper.c
> <<drm_gem_shmem_vmap_locked>>
>              ret = dma_buf_vmap(obj->import_attach->dmabuf, map);
>    4     85  drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
> <<etnaviv_gem_prime_vmap_impl>>
>              ret = dma_buf_vmap(etnaviv_obj->base.import_attach->dmabuf, &map);
>    5    433  drivers/gpu/drm/vmwgfx/vmwgfx_blit.c <<map_external>>
>              ret = dma_buf_vmap(bo->tbo.base.dma_buf, map);
>    6     88  drivers/gpu/drm/vmwgfx/vmwgfx_gem.c <<vmw_gem_vmap>>
>              ret = dma_buf_vmap(obj->import_attach->dmabuf, map);
> 
Thank you for clarification. That would be good to reflect it in the
commit message. Also, please note that:

>       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -                     page_shift == PAGE_SHIFT)
> +                     (page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
>
we rely on page_shift == PAGE_SHIFT condition for the non-sleep vmalloc()
allocations(GFP_ATOMIC, GFP_NOWAIT), so we go via vmap_small_pages_range_noflush()
path. Your patch adds !PageCompound(pages[0]) also. It is not a problem
since it is vmap() path but we need to comment that.

--
Uladzislau Rezki

