Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FD3D116F5
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 14:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F5B6B0005; Tue,  2 Dec 2025 09:03:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18876B0007; Tue,  2 Dec 2025 09:03:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFEB6B000C; Tue,  2 Dec 2025 09:03:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 897D46B0005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:03:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3370586E3E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:03:19 +0000 (UTC)
X-FDA: 84174698118.17.E344A12
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2686CC002C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:03:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G8UoXgOk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764684196; a=rsa-sha256;
	cv=none;
	b=IsW5FIha4N4ZqQ87qjOFtztzR0xTm23WEn8K7uYljMANIVz7P+nPSJ//t97brwLPdK3gWt
	w+M5aLaCoYVwpI4tpK4vWqytqob17/EPBgnvfyIWbro9wK3EqEj3eYMiIgjxVTWrErMYQv
	BgO+6yjbpdw6WajNPA+GCZcqPlTnKA8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G8UoXgOk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764684196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qv1K7J2piWEBLYsmYS5El8b8US/OwNpgXHLpQ7GMrlY=;
	b=xDIRBPze7gOa0k1STiGWT/hzIH8GaZLplD7hCMJHx2cIeSafhEBm4Pp/P54heRNmjhKY3V
	w87MdgjlVH+RiEzE6G5QJ52kq4sugs00dc5Zy5Qf4CN9/ap8bmXBPhj/nufwiL0kYX+TYI
	Jb3+OJlS0lY069CbhoHa0hjPPZ4bj9g=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-594285c6509so6527197e87.0
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 06:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764684194; x=1765288994; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qv1K7J2piWEBLYsmYS5El8b8US/OwNpgXHLpQ7GMrlY=;
        b=G8UoXgOke1JFgPYO3hS+VChryNWe9zQ/jDBcv3wZpbIzYfbStkc1NAEtEAGIlKNLpG
         HvzX6mzGfFgPhehto6duEfSaGeDoPNKxhtmDb5oh6LMaGFLWJMldsoxN1Hk5CiLFeN56
         GRutiv3d9NAPSmWXV9R8vnAKxq+zpl7YMq1qAsGz4MEV9AfCKTR5AMYFrxvjkVLE/Ny/
         9TC2RQ/lbE9N1aDu59+nrBxeol6mWwQtca7yHa7eBjniuTWUUoikChg7Ns8wegKiRlG6
         a72FU45g8JePIgmOEWBOdYDF2nhStXILZYM8w7peUHWwX/v7JYw+L1IvKCUSnNC42sIx
         xzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764684194; x=1765288994;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qv1K7J2piWEBLYsmYS5El8b8US/OwNpgXHLpQ7GMrlY=;
        b=kOCLJZlOdKNY4WG4TmvpuE5HayhTWQgUKyKubCsNZ8F/yUAUkfYl8dY03wVzJpoqwp
         Hw+UW9tQCFLqmZi6EN2WBdR7wsEYxhm8FR1xY/vuBNophn1eMTZH+gLtdjEwnoOB+cEX
         MDpnvqBNPZkYKqNr6NkNVZW0uLhmZxsK6GNiMEaQ+E1AgnBXriHwB7fDKiSQ0GBmYlT3
         4KzCEdZicq5FmqTnuGqLEO1SjVdM0auP5HH6sh5/Mjv5EiogOtkaJhpNWKiy3M8rYWvU
         Y5mbAOytXptLJGCdqM3LoIIgWOKFy+eb3fuXnCNiDwt3UJW/XXZK0SlNUMmA7L/dUV2I
         Eolg==
X-Forwarded-Encrypted: i=1; AJvYcCXD2HajMuhI3nEtBklLWJpSq7d5alcrxE1UgegQWrcqsNWtzBk8ZuNcrXfE2CB+P+FFndRYES+SUA==@kvack.org
X-Gm-Message-State: AOJu0Yxzp6st9yCu4YvGOZGOcxhQRq7mYozCMrUBTOPt5BDwws/RqKIj
	AeG76M4OZhwj8ykgzhK0B8ay7BfpIOYHnlNr8HnS2DFAQjuOyRGpyToJ
X-Gm-Gg: ASbGnct2hQUyu7zpFdfM/C0ADRTxCpUC52lvy42KP2VJhjXiZKKBE3JB31DhDqQNiw4
	5zlqGXHYSWCxrIunUykXviHI1jTzI8iTjPgPxFsrpGrK0qsO19hG94vicAlD72Z92CX8cxeLsfz
	2KvbKf7W2fFYI6fdy+xTCtkCqr6dxG+SAUeYQ+sPwIWeRokzTeG5Sqj4hoagv4LVRw+mJdWeLgo
	lKrsLrIum+yrppNzIUpjEZnYt9RFtkUaQ/MvkjrXAwxZpasQVIgYybtaV55HP9Stlxe750TlRhk
	DxbwmogS3FYzyqKVGhRNE3CE620RYeUHttX+exF7i7ymNOMRxZAiFybwRB3KZN8aJd5cZ4+Js2v
	qkgRI8hcga8K2zP6OunZ1ndfgtRJbhHhzktSta8d0rSp0uFhSK8PfnmuaO2Lb6M3v/0QPWZetZp
	XMB4vE7XhzBu0yCe9A6WGOdo5ItWCpfUWQ
X-Google-Smtp-Source: AGHT+IFMPwW4Ci4ma2kd/bf6E5zfBDbaLqbg0ejouUGZkkjz6Fd31OThqfP5IxcvJU8zZMZi6pGF4A==
X-Received: by 2002:a05:6512:1149:b0:595:90f9:b9d2 with SMTP id 2adb3069b0e04-596a3ea67c2mr17072594e87.3.1764684193847;
        Tue, 02 Dec 2025 06:03:13 -0800 (PST)
Received: from pc636 (host-95-203-3-14.mobileonline.telia.com. [95.203.3.14])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bfa48c5dsm4644152e87.77.2025.12.02.06.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 06:03:12 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 2 Dec 2025 15:03:10 +0100
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
Message-ID: <aS7xnhxNhJ71cJRb@pc636>
References: <20251122090343.81243-1-21cnbao@gmail.com>
 <aSiB-UsunuE7u295@milan>
 <CAGsJ_4z21fN2KSg6jt_qveYgrKZw1Vsi_kb+uhed=RJAbujMHw@mail.gmail.com>
 <aS13J6U-QMOrwwbs@milan>
 <CAGsJ_4yGLdhk84Ent8VRcE4_2Am_U=bXTVdV2LHDBtD2OZs8xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yGLdhk84Ent8VRcE4_2Am_U=bXTVdV2LHDBtD2OZs8xg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2686CC002C
X-Stat-Signature: zmjshij5sf4skeo47udp7buxfj7ewhak
X-Rspam-User: 
X-HE-Tag: 1764684195-589046
X-HE-Meta: U2FsdGVkX1+Wv7qt7f5D9xQIAsGTX2GSWpghqvCfE/NOp3nLz0XJTzm7nftciItNX1RlBwZAdaxBY1ZDj3E4imO5ris7JcJ5SJ1VnArYjlAarQlson1itbIm9LoTwEbPQTVup+/AvyLD9PXXlB0Im0MSYByg4xyO79jk6/C5bW5Rma+A0mqVC9qVv49DUYDfo7tsr7a+HrbuqHAEGiEETNf3xSBFlYdr5LUEnu0XAztwFgf26KYU0uy4zTqPi4mTpuauWSI1WUyEpOlpdAD/nEw7NPSdW5sgyhGuP/HhXk3Y1f5pJFTiDteqCEOgoJKbhKbSecPla9l2YUdcpKDRdbToZjoYra56epL5F6vevcY/OuhcHk5aL+jsgJK1gAwd9B2bMNM6oIERCuNufw1ynDi+Wn3XSdWNjrU/3fKVL21qhLyuaIYpgJZHVeKMlAEDcJjHGHl2iZJC+aXMlLzUPCfoZuB1JjXhO9hY4ZuP17AKtKEDdzIu1UiYOSvBZlNLJrPv/MpWDhAno+QcDmLS4dAMuVmU4cNWstAKA3Ro4uaC/ACgK1R8zjnlYLBZbwxW6GR332zvLA8YsDW6/fvUxHcLpq+F43z4V9q038V/FOvSit/n2bwmMwATub51rLcuGTOPLbtEOyRLanOR0yU6YNrgb/DZlJuAyxUhcHsdF9DuD+ex/hFqrzB1uQ845XtOuxAHtDSAlbLrXeObyLf3X7qwSqUEXu2BDWATskmA/L2PBelTuHCTDdDUqfj0qYMhmW5ppEUBM9akGUA729e7tl2pYy57upOebSMLAqqmthCjzml/ftL0n8LXXSgTTv2VERxXtT0cvXY0dF2m/VYzueEylkklq8wZ7qbqXPJJZoslz9t3l4jzTvauoIa8fAluSvhcC0lF3P7sEsmmWsztAfN0sD7oBu+mFjO5tFbMNvG3eMpq4PQ1CvK+gkFG7ff5hnEW3c1YyDeFVrnscRz
 mPMf0sn2
 TzY8SxQsDuiMvub6OQ0bAvx0UKHw9wACvGRJCf841SNkzAJKa0V4FLq0tZ1JkHoMOrztz0DGV6epV3WEHU9/vgLuoZUgdK5U9VNwJQ4BCEhx4am5LcXI2qGcXzH3+SAn7o4ntnBXAQyDQwaY45YmR3zkFHMx4XET9Fl3TWVJDzoC0Lw3O7KoFwFtumbh9YUaOwbv/jcAiVt8Bo/Cgvc3diEe1u5XL+wokA+UvZGKBsWemST/79h4yoC34Krv2JQ8ztX4I/ACAYroyIzRNm8JayAmUpOBbli9jztMfHx/LRrATdeq7Lgt7heHtURtuNVw8B0xfb+kMGwNnqffVe5DkCbb7Lvb5ny0eByI+5lLf9uq3uAm4O6FzhE+nPRod1H808aFvMxTGPMweABfw66wmTCO2Qogm2ULD0gKoHqpLHtZ/acqBeL1R/qjW4mUN18latagE1sWHh1pp72nRDr5HLWg329wCEFnmi3oigbbmSb8C23PW4huKekUlVu/55Tws53Ip4o5EUrwklq2NVzBJbz6gtfh5qOTs/bkGbhybe4tZePwszi1uy1XazsHcVPm8a7gC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 06:05:56AM +0800, Barry Song wrote:
> On Mon, Dec 1, 2025 at 7:08 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Fri, Nov 28, 2025 at 04:43:54AM +0800, Barry Song wrote:
> > > > >
> > > > > +     /*
> > > > > +      * Some users may allocate pages from high-order down to order 0.
> > > > > +      * We roughly check if the first page is a compound page. If so,
> > > > > +      * there is a chance to batch multiple pages together.
> > > > > +      */
> > > > >       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > > > > -                     page_shift == PAGE_SHIFT)
> > > > > +                     (page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
> > > > >
> > > > Do we support __GFP_COMP as vmalloc/vmap flag? As i see from latest:
> > >
> > > This is not the case for vmalloc, but applies to dma-bufs that are allocated
> > > using alloc_pages() with GFP_COMP.
> > >
> > > #define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO)
> > > #define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
> > >                                 | __GFP_NORETRY) & ~__GFP_RECLAIM) \
> > >                                 | __GFP_COMP)
> > >
> > > >
> > > > /*
> > > >  * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> > > >  * This gfp lists all flags currently passed through vmalloc. Currently,
> > > >  * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
> > > >  * and BPF also use GFP_USER. Additionally, various users pass
> > > >  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
> > > >  */
> > > > #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> > > >                                __GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> > > >                                GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> > > >                                GFP_USER | __GFP_NOLOCKDEP)
> > > >
> > > > Could you please clarify when PageCompound(pages[0]) returns true?
> > > >
> > >
> > > In this case, dma-buf attempts to allocate as many compound high-order pages
> > > as possible, falling back to 0-order allocations if necessary.
> > >
> > OK, it is folio who uses it.
> >
> > > Then, dma_buf_vmap() is called by the GPU drivers:
> > >
> > >  1    404  drivers/accel/amdxdna/amdxdna_gem.c <<amdxdna_gem_obj_vmap>>
> > >              dma_buf_vmap(abo->dma_buf, map);
> > >    2   1568  drivers/dma-buf/dma-buf.c <<dma_buf_vmap_unlocked>>
> > >              ret = dma_buf_vmap(dmabuf, map);
> > >    3    354  drivers/gpu/drm/drm_gem_shmem_helper.c
> > > <<drm_gem_shmem_vmap_locked>>
> > >              ret = dma_buf_vmap(obj->import_attach->dmabuf, map);
> > >    4     85  drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
> > > <<etnaviv_gem_prime_vmap_impl>>
> > >              ret = dma_buf_vmap(etnaviv_obj->base.import_attach->dmabuf, &map);
> > >    5    433  drivers/gpu/drm/vmwgfx/vmwgfx_blit.c <<map_external>>
> > >              ret = dma_buf_vmap(bo->tbo.base.dma_buf, map);
> > >    6     88  drivers/gpu/drm/vmwgfx/vmwgfx_gem.c <<vmw_gem_vmap>>
> > >              ret = dma_buf_vmap(obj->import_attach->dmabuf, map);
> > >
> > Thank you for clarification. That would be good to reflect it in the
> > commit message. Also, please note that:
> 
> Sure.
> 
> >
> > >       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > > -                     page_shift == PAGE_SHIFT)
> > > +                     (page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
> > >
> > we rely on page_shift == PAGE_SHIFT condition for the non-sleep vmalloc()
> > allocations(GFP_ATOMIC, GFP_NOWAIT), so we go via vmap_small_pages_range_noflush()
> > path. Your patch adds !PageCompound(pages[0]) also. It is not a problem
> > since it is vmap() path but we need to comment that.
> 
> Sure. Would the following work?
> 
>         /*
>          * For vmap(), users may allocate pages from high orders down
> to order 0,
>          * while always using PAGE_SHIFT as the page_shift.
>          * We first check whether the initial page is a compound page. If so,
>          * there may be an opportunity to batch multiple pages together.
>          */
>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>                         (page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
>                 return vmap_small_pages_range_noflush(addr, end, prot, pages);
> 
Sounds good!

Thank you.

--
Uladzislau Rezki

