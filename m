Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D97CF34B4
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51926B00C0; Wed, 19 Nov 2025 09:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01296B00C2; Wed, 19 Nov 2025 09:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8F66B00C3; Wed, 19 Nov 2025 09:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 787046B00C0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:06:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D3871404F7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:06:46 +0000 (UTC)
X-FDA: 84127532412.05.FF81D95
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 370704000C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:06:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j96oD8Xj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763561204; a=rsa-sha256;
	cv=none;
	b=M6wOkIRwg3hC2jsa2YT18wuFrRs7wVDaQ9Y9TJX/lzHWF9ZmBVbF7xW8xMUU6FV9klcFHG
	6NCmrHZ4HgDF8uDf7bhBEVaLdiIFcLaFEAE5StYaxdwfNxKbjK2V75L5lJdOUA+cAWAQ+I
	Zbd6BLliyyHsQdcTe0AnNyaoZTghyOE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j96oD8Xj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763561204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrYlkbrAuW0CJVMNxIgwwlmGTnSuWrArad9fT3lU1L8=;
	b=JB4zY1oociDQHFMXHpX4Juwu5xk9Ev0t9itVGZimUYCzjffkfP8d9PpQCLwGjtgMoiBzzK
	KAiX+PkdOO4ippgCRgeuAWBw3Wpz6q8J50uAjDdRMmmPJMnDFCtQWRXdkFwXv4DRIFmPUk
	FPh8ux7e8WE/v5wsVyNHLCmD1MW0Npk=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b379cd896so3921050f8f.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763561202; x=1764166002; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KrYlkbrAuW0CJVMNxIgwwlmGTnSuWrArad9fT3lU1L8=;
        b=j96oD8XjUk7TwJYeELP+tGPv/XWxG4N+MYiFku/7PYM5TVHgmm0h9IJS74j9OoY5Pz
         KWlNmBXH93VGpW53bxsQ+TFflhXSpS4a45R2dOtJjDQut3DvAO0kubzt4ciCmE3LwGDl
         hvKYxS/fA5SNqsgUDgvSTPA13InHy2b7RfSrQP8d3BQy9BjHpKlUYJynIPns4eS8XAuC
         ZdUfWAX3lWi6yZEXp5DcWL+e7CgwE41w8K83t354lQhtpnzi6bngkUmkaDEUcqP5SXcn
         MPhWrn3H8RUlEr6CR8Yma7Si0MRjdhYEuyrmilRBO4NmL9GD2c+4W2tREdo3hYUx+EeB
         +3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763561202; x=1764166002;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KrYlkbrAuW0CJVMNxIgwwlmGTnSuWrArad9fT3lU1L8=;
        b=ky/C5WOiXjcQEgLVWOV7lKbE8QQh7GNzJ/ptcyaCcBgqSlcK51ojCGN24xbWSIv980
         t9aAFYNplFpItaL/C4vuW0vuz+ya+xoXM6xu2uDLLSkonKFnyiwLId/DtLMUQP0G+KZC
         Co4XDGiP2oM3Tnb1NT3KULHL620ChOCS3l8sSaRyx9M8YHwoaTTr9axqXl62BGldU3ll
         FpdYlaaNomqQXxbClKC9PuaE/a+3/VAQGIkLoahdxSvYNkxqSspgJtfu2mhL1opy0fu8
         YazNSPKsc1NNPkFOPAumGuLzuCXGzCKQGlM+q/85S7YShCNwCisI1CxffHX3QpPYowVD
         LjzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLWEBkaP7OLX99B902PjHXO31TIA55kDM5wPQdHN1xrfYtPwX/JP+ckBv5aaBNbc5+cDFSqu2NpQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0EjO+eSy49KJHmzN34Ku+bNMTKMfJpsLk9QLQzDZdP9nTzP3P
	0EL6clahJNM63m1r3V3pi0rM8GSS5kGxKvYiy6EHTLmYI/X1yPMGw2m6
X-Gm-Gg: ASbGncsWMQVDlrmVpiBGja+8gSWKbPC4vXbC1b+lW8QDsKdjd5lPbsCeq5T8BmYvFMp
	iODzZsolC6TPdCaKK3FRqfnHb1gypKxjqRSBTy3FDy9L0WXdd+JT127FkwCfERwDYFwQM5pMpEn
	vwCv0KcMa8h8fZ+1vsgJLNPRRh/6/ac3DctuY9XBxF+7GDfX/rzf5kwmNi3JJRMhwHcp4Dc6oyB
	NMtARijtgpPMvTaeO38ipM/P13kAx4FCszSWjGZ7xjVwsdcpjins5IeLBA+2c567L3nxNA9R54X
	hn30oh0PCMm4SZCkCgur4e9PbFuI47tLLmISJ9x0m0mzhKxzNT3SHsgzhlspPb87TlIj2/mxyax
	qXwWP+DbguThWlD9c8RgUIPd8w3GDA+OablsAKYsCi2g5XSjg8SHWfrdMgxWL1RPaX8Xwo1hUY9
	xo7UD6XCyvJVj1LJOxOGeya55Ga6kByfTai+ZffBJmSbOnJVfJ/DWOM+UCrv2p7ht5i8M=
X-Google-Smtp-Source: AGHT+IFiPKDX5IFAdREjtpo8183tGXmuo5NUyGi0LIKpf84NFghKB21kVVGOB/anTbdap2sFnDN4RQ==
X-Received: by 2002:a05:6000:2007:b0:427:9d7:86f9 with SMTP id ffacd0b85a97d-42b595ade7dmr20655507f8f.47.1763561202173;
        Wed, 19 Nov 2025 06:06:42 -0800 (PST)
Received: from f (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7ae5bsm38214170f8f.8.2025.11.19.06.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 06:06:40 -0800 (PST)
Date: Wed, 19 Nov 2025 15:06:32 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com
Subject: Re: [PATCH] fork: stop ignoring NUMA while handling cached thread
 stacks
Message-ID: <2a3ftlongim2m7nk5wbj4se47prwagiw7uxzbk7f2isqsqezyo@b76y3afffhea>
References: <20251117140747.2566239-1-mjguzik@gmail.com>
 <CACRpkdbNxKh7ySjffhzCncgBroOOeOQP689k7dgBKgV9annLpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbNxKh7ySjffhzCncgBroOOeOQP689k7dgBKgV9annLpg@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 370704000C
X-Stat-Signature: e6me8z49jfftzycmuramas4h5zr6uimb
X-Rspam-User: 
X-HE-Tag: 1763561203-109918
X-HE-Meta: U2FsdGVkX18/v+UnNC6d9TISCIeOSRIekRSOV4TyAdRinA3D9CcFkWdfoKUsOHUOPdJ+E9sxwwiZLq7Z5jn9jaoarvXk/uM/ETjcxLGB0rTLn4N1Ba/pBlMG6SHXEsERdGzELlJaUK8cfeFu4L25CgkHlAJhVKQ9o7qHD5Rzax35rUIpRiN4QXNFsnHotbGNhJ9UxcpWbtkVDiTaa6yfHwdPIjYySOMCyLUAbx4cbx2DZVDzJuQclLXuA8TggKHhQrpdp3hs4UO/pqeaFDbEqzU2qmtQ+lt+xhmsOrWMstzMSoyTRdgwJn7ka45CcXcWV2Ily3I7I+hcY3ApwSRi0551xgWzdh9uKuDxPud7o5e7vCRzkEGyyX29071pUPSclDvdPnb44lF4Gu3Qpa6EwXwTCWCAekvxRpbyxrG1+da5PKTVPX5sRdPNJvlBk4uiTpVwIACm17ddf9347oxnEmxWTa0CDrZBiZvBsKDaBj39b5U+JEGI8qhe5ApiPTZ27t3mvCzd4j9Y+4UwivSztSkdz4oCG+UlLIWHm7TYi5HoGyn5DKYQP9/A68dNLrNo6umbms5gHwgm7bZWPWTexRyaJFguQUZMrqHSQfwP42+96xd13RrTdHFo0UEZzZsHPRPDKf7pdq28LsvKS7yS/TKhHobJKzn+734IdufnEZpFRC2tl1IsnGor2cFPdWUoN/ybjLA3J4H73Xrist3VBWgtUh/fRsw64Rf7SvRfgccQ6R7hnLHx9kIXgPfhffTfOqjR93I2IWxNfdnLzMWBJSmkInfHnzakCqdL3qD3XoazLgpsTi4nPniiWAzrYJFPz00kTnR95Fb5H+iCDbXUvbnrgT9SzMgSa3Dl5np0IUY+Akf7hblOWyKI3BAjedUAsmpFWrELzTxG0vuG0yJdTOSw15KJtLXyZS4yLgPy6k8hk2/NMoPJsQDitWD9Z0Ow3gTyRxEmlu0sKG5gsas
 PEL6bJnM
 CGkTa/oLjjSik4oE5LzyCbvpa1D5A3KTdhbTBF5ZvQCsaH1YAa8WEUNj4HJghJyQeARHSFtEKjWY5+iaT7Ax7ksA5OCXcqNAiYymkFX+c8bErXeF21ojaiL/allssLn6UtNCmhzFyzBnJRFvJPMm4POKqzhL8Lfo8Z4UQBBzlybBLq/VksE6TYg0NfCp5awdjuDG9qkCIzDPOSM/YilFDqpq/Ruf8DyYS5yRYEh/HZxl9HID4c6slVOmvC+0J8BKBqCv2i8fn1VMnZpfGspcGqyoyph3ZEPO95/stQKppITmD3J0GXLo/YEOsWcXaGuC4SmAmTDmbZZuZYECObe7k1pNmBzu9lTY5+tTVzpQ59E2390GEy+eafTPgHtQ+xZ2E18ClUe3FfpRKmsrsAPKQ30QVnbRwCuiUvzeQMujTk4h/TraKpWnjjC9rNd01t/AJ5kXD7LoLan+hIJooZhR10kwZrz9qxj+iKVGNtoXVypj8dpiGLZj8VVHa/QVCqzKcQXvF8EDmTykgx4wTRM530jGDx+bUYe4d6na/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:15:04PM +0100, Linus Walleij wrote:
> On Mon, Nov 17, 2025 at 3:08 PM Mateusz Guzik <mjguzik@gmail.com> wrote:
> 
> > Note the current caching is already bad as the cache keeps overflowing
> > and a different solution is needed for the long run, to be worked
> > out(tm).
> 
> That isn't very strange since we just have 2 stacks in the cache.
> 
> The best I can think of is to scale the number of cached stacks to
> a function of free physical memory and process fork rate, if we have
> much memory (for some definition of) and we are forking a lot we
> should keep some more stacks around, if the forkrate goes down
> or we are low on memory compared to the stack size we should
> dynamically scale down the stack cache size. (OTOMH)
> 

I mentioned the cache problem when writing the patch $elsewhere and an
idea was floated of implementing vmalloc-level caching. One person
claimed they are going to look into it, but I don't know how serious it
is.

Even so, my take on the ordeal is that per-cpu level caching for
something like thread stacks is a waste of resources.

Stacks are only allocated for threads (go figure). Threads are allocated
using a per-cpu cache and then proceed to globally serialize in 3
different spots at the moment (one can be elided, does not change the
point). One of the locks is tasklist and I don't see anyone removing
that problem in the foreseeable future.

So there is no real win from per-cpu caching for threads to begin with.

Instead, a cache with a granularity of n cpus (say 8) would be more
memory-efficient *and* still not reduce scalability due to
aforementioned bottlenecks.

All that said, I'm not working on it. :)

> > +static struct vm_struct *alloc_thread_stack_node_from_cache(struct task_struct *tsk, int node)
> > +{
> > +       struct vm_struct *vm_area;
> > +       unsigned int i;
> > +
> > +       /*
> > +        * If the node has memory, we are guaranteed the stacks are backed by local pages.
> > +        * Otherwise the pages are arbitrary.
> > +        *
> > +        * Note that depending on cpuset it is possible we will get migrated to a different
> > +        * node immediately after allocating here, so this does *not* guarantee locality for
> > +        * arbitrary callers.
> > +        */
> > +       scoped_guard(preempt) {
> > +               if (node != NUMA_NO_NODE && numa_node_id() != node)
> > +                       return NULL;
> > +
> > +               for (i = 0; i < NR_CACHED_STACKS; i++) {
> > +                       vm_area = this_cpu_xchg(cached_stacks[i], NULL);
> > +                       if (vm_area)
> > +                               return vm_area;
> 
> So we check each stack slot in order to see if we can find one which isn't
> NULL, and we can use this_cpu_xchg() because nothing can contest
> this here as we are under the preempt guard, so we will get a !NULL
> vm_area then we know we are good, right?
> 

This code is the same as in the original loop.

> >  static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
> >  {
> >         unsigned int i;
> > +       int nid;
> > +
> > +       scoped_guard(preempt) {
> > +               nid = numa_node_id();
> > +               if (node_state(nid, N_MEMORY)) {
> > +                       for (i = 0; i < vm_area->nr_pages; i++) {
> > +                               struct page *page = vm_area->pages[i];
> > +                               if (page_to_nid(page) != nid)
> > +                                       return false;
> > +                       }
> > +               }
> 
> I would maybe add a comment saying:
> 
> "if we have node-local memory, don't even bother to cache a stack
> if any page of it isn't on the same node, we only want clean local
> node stacks"
> 
> (I guess that is the semantic you wanted.)
> 

I'll add something to that extent, maybe like this:
/*
 * alloc_thread_stack_node_from_cache() assumes stacks are fully backed
 * by the local node, provided it has memory.
 */

> >
> > -       for (i = 0; i < NR_CACHED_STACKS; i++) {
> > -               struct vm_struct *tmp = NULL;
> > +               for (i = 0; i < NR_CACHED_STACKS; i++) {
> > +                       struct vm_struct *tmp = NULL;
> >
> > -               if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
> > -                       return true;
> > +                       if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
> > +                               return true;
> 
> So since this now is under the preemption guard, this will always
> succeed, right? I understand that using this_cpu_try_cmpxchg() is
> the idiom, but just asking so I don't miss something else
> possibly contesting the stacks here.
> 

I think so, but unfortunately the typical expectation is that routines
are callable from any context, which I'm retaining here.

If one was to modify this to drop the behavior, asserts would have to be
added this is only called from task context.

> If the code should have the same style as alloc_thread_stack_node_from_cache()
> I suppose it should be:
> 
> for (i = 0; i < NR_CACHED_STACKS; i++) {
>         struct vm_struct *tmp = NULL;
>         if (!this_cpu_cmpxchg(cached_stacks[i], &tmp, vm_area))
>                 return true;
> 
> Since if it managed to exchange the old value NULL for
> the value of vm_area then it is returning NULL on success.


This bit I don't follow. Seems like this flips the return value?

My patch aimed to be about as minimal as it gets to damage-control the
numa problem, so I kept everything as close to "as is" as it gets.

> 
> If I understood correctly +/- the above code style change:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Yours,
> Linus Walleij

