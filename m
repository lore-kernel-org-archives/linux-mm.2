Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A71C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867AD6B008A; Wed,  9 Sep 2026 14:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F876B008C; Wed,  9 Sep 2026 14:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757B96B0092; Wed,  9 Sep 2026 14:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2336B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:28:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECE6A1A02F9
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:28:43 +0000 (UTC)
X-FDA: 85195059726.22.83B506A
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0279020002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:28:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u2Uvhh9W;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788978522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJDbFOIPiBEjqRCw5Yx9h+UnhUPff8j+dBiof+7K4sg=;
	b=YFejuFWGopn+YCnWE+Oc2XPyaOjir8icO3FtE9UWvqvp29gnzkHD2a3YllmRNmH/v5tFbj
	SQbtMDQrOvtjpkPWky2oXz8VXpcyiLICZ3pdskoFUlroN3gnRWnQg0RPe/S1+kNEs2YsVn
	BY8Seh/ERa3xqIxvxsHu24X2oelPm0c=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788978522;
	b=PFMjtRh9oInhRnRySqr89y7l3jx/6XwOFHlA4Stx6WsqmhtZlHqmGvGDkIA1BNvFLE/CUC
	bJPXG0LGwrm6AzPerqoXG5p5Si5Mf6N63C2suGtqwHg20xeVlZ8Fn1/9zW1AtnBzpBMJBb
	Po+KSbKUXsihVl4mM0eDpv71EEO8ChE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u2Uvhh9W;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so340651cf.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:28:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788978521; cv=none;
        d=google.com; s=arc-20260327;
        b=mODxnRb0foEzCfsDec2N/f0V2AKuv16NUPqKUaLNecL5F3LgGWOg9D4rqRbcoqrEsX
         6xaXdDdx9fCgkARmZU35mRYEp7CjB5Y8tKIIDbMUJBpfPRddv86ctN5cyEGopDg9WtkX
         HIful2835M8vMgxOZFZgKcOGM777RLlMB1QRSAqzBrPs4flyXYViISBbinB8mITnAqod
         X5Ue8cVnujdlCl7wrsiR48DFdDxuenT6kAD5sYbu3GtY2gxSO1qsF/BtM0Fj3Jtw3Cxg
         eH1syJDpn1/PHp/ZSyW2NIai0Lo2iaup/Y7Igfsyr84T/1+eJYHh6QEec5DlvZM6tOLM
         /WCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cJDbFOIPiBEjqRCw5Yx9h+UnhUPff8j+dBiof+7K4sg=;
        fh=h+6eO21oKo83jPy1/uE47kVYFZNnF1zitxGIISf1cB8=;
        b=lYT8FQhIUjXf9V3BInVSPpHlwrtqieeZwoGfYOP2IgA4WFNJ4NFPsxuE+1cs9VuPEV
         7tGasXqSrj0DHfdDUhSJORNAi6Q358Q8xSiQaIzOOgLroxy3hZJQ0R2hGm02SC80GxiJ
         oKu09lI6bFvokpzVpJyUL/ib1KW4v95YkpabUALVUxbjIPzD1OSP9qDATGW2Xo89JlL+
         KZ2jQ/qCUq46iir4Kr+s9wrHrBw5KoXYGOeokNFuUJS5MOPKSm2AhwnMgIAnvT9XzBYo
         2chmxLEkMnQbKXMxkjFKNyxZoe/3VcfRdCWvjD6Tb9/y8RlhzEqwZF6f3M9mjSe1xtMt
         N99g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788978521; x=1789583321; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cJDbFOIPiBEjqRCw5Yx9h+UnhUPff8j+dBiof+7K4sg=;
        b=u2Uvhh9WRPpwN4gTgy8MaLXDaleCHhxkShclAT2qhSEAJ7lIAR6vmmPbgQGdbW2FH0
         ExqKHStqfCE5FbLuY8XT2eppLEFbUWuQBIzNJx9Tknhr6/cG3t2sGTWe1EaK5RrPbagL
         RyCocib8L1rXrABOr3VgxHUr9fdBIPQVHtjXemc7v446jk+0SHOxMagk3RYSz+en0z2P
         FvN9KZPCp0nxPMEL90BOewej4+GbffryPBsLoFIwCB2zUqa4w2zdacVXu/TjfCjekTN1
         sLZZQ0h2QyGKLxVZjEcdEPI1NCXbv8NvtsvrbxDeYLP4oWjMYqebyr/5/x6w0NMdlucD
         gUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978521; x=1789583321;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cJDbFOIPiBEjqRCw5Yx9h+UnhUPff8j+dBiof+7K4sg=;
        b=B4Pwyx6KB6qyGxV95BYNZ96AxlzgquDjwWEa9PmMXIKyuQUh9piDxuC0jtPY3dq7YO
         OBK/3TB/o8YqURGQ+COqbu0ftlkRiv37ujY5OnoaREzgkhUvhkX7sfiygtWPYTk1n41K
         /wZ2JxSp4YztNVcbiSVz514kbaJmEKAPXZEc+XzzUA4C7bWsu2bK/CJC+oBbnCSraL6e
         +J6sovOHKyjqEdyYWEyKcGC7EMr7/RVHCHe3LU1XqYSe4cpm52P5Cb+JTXQXtSGyJY6+
         150RUG0e036f2b34b47SWlMJfib+XwJCaxFFZwHoVubOhlzJn1dgbTn98IV/R5L6V6XJ
         swQA==
X-Forwarded-Encrypted: i=1; AKwUvBz68aJcKt1wxNgFi+0+sHEZButZeww9FWE/i8iYpEqrUDLxn0dvWa1N1IkRHjSysfnmH155MMEyKA==@kvack.org
X-Gm-Message-State: AFuF++mGC7OpxyVhMxcMXi45blI+wa6Ea/ZER3pTWPAp9pkKERU1vSNV
	2vjqDqyeejA3dXzFWeDBq8keB7RgqykZebPL/71qMB5fMkKoyhS+DsSJi/s75xwbGcfMZCkfZUT
	chpLDM/AcF+myfAL3IifoH1/HL653DixC7pHOxksb
X-Gm-Gg: AYBFou3sCFJXCbxKxmTwsH6IPJK8XDN+PWuZwuuLBn7BfYFsUJjUH0Oa2qcJgSfrlsL
	83kP8kNYTAWPBBslB24OUmQ6pYZ7uTFkrGzOM/R1rE1n8bcacS5kiMY11rwXjVUNkVVxFCjwfbe
	4GghjE5NdlVIGKLvwocmqTzzi5yZhph8UhxohG21d9MjGPRsW9Kw0alOzltPgIq4+P/HtFZWGIs
	vi3ArMQPyaaOveOk1gLcFScrZ/NlD+YoH9t+9mNELnn7IXRjK8SqgVQg8iN1F5qAQZ19sy+kcTm
	DxiXHosuy0ixrTMYe7FqqP0hxHMWJJQ5NZjiuH6SwI/0KuEnXI8ufMCr/A==
X-Received: by 2002:a05:622a:4a8f:b0:530:4381:e745 with SMTP id
 d75a77b69052e-530b48fe16amr625971cf.10.1788978520364; Wed, 09 Sep 2026
 11:28:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org>
In-Reply-To: <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 9 Sep 2026 11:28:29 -0700
X-Gm-Features: AcwNN1UhCxMjsN-ZvXY1SXXIlCU2WXXFiLWmPzRsbEUiUvDAd79GPKH9ucEAeVU
Message-ID: <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 16masxffgryc6iybsewixsydzw5fjbbw
X-Rspamd-Queue-Id: 0279020002
X-HE-Tag: 1788978521-483494
X-HE-Meta: U2FsdGVkX1/2BkocHar++46N2+s1wp/72y2UI3dchYvr2m57m2LNY92uBqm/ByyoIHMv9mLgpGIqdjqy3k8Kw5fzMB/ohmtc3gYwBPktaGGlgymmcbdHctoPtdB9KfFxuIRHNGbS9JqQM84uppzdymQ9ftAC/dOkVgqApKUtsFlJIeFyVm1m32lMbV75Td70GxNOrBh07m/TEFEXqvP8o3tXd6AVDGYG8a3r1kg/rFzDb0JEGK//zz/lpdikRm8JH3RnOQ1XM6epTQUgHoSptCboKuTsNwsz26MqstTnbsrP5N/l52kUic0zjWaCALEXNliwe6vpnfPfM5jNMq6Hel5ERL3QQAdNj3fJEN0D/kxX1XEy2eqvZQvwGD2lT0kyxry416CeRGH3d0mtIFy+e1yDiUcGPJZvZ+T3+wJZpv3A30LjtanwV/PRus98LtGUxPQJRys1qC/tbpW3boLeEJKyIOp0XPYle/8vuf6a8si1d0h+uCjEexGbJyNgo5ugwleNWaxkGu0KaP3KdUWrYr+ZlLp2HLs6JwUzTIHYNEEu0GJz/G7G9Z0v/avBJqer6Ia19BnD6AB3BiG15sokCd2Z3h59mPamvJWYyew1LH/nYueCW2Ovftv0jPh1FoDZhv0ioHEQy9ImkJ8IzyMt+giS2AskiQl+AXP6EPfSeL4MjrAOM7NLJogZeCLzuVd8dNajT3QOikmDBEwVP6+du3Jc3HinGu/KPTrZlfDiOEDDyHvOWd6qyyJQBnQLCpB+jRgY8d2TAruqO1veRT4Fop+YwxLZPPuc8p12Z0J5QUia4CN+eH4rPXGO2T6ZIUa0/AxCxeKT6IPjm+8pNA6MsKgS2DkK/xSW+51svk4FaKO/GyGEyTdmZ1YhbMSiSXnqlQsoUVx3v/AcbY1bg9Uy2wFgWJG2fvv8TyF2Nj7lsaayZ6gyyocAun6aLMfxxrvyOcN7c1W+axQvy7pPT7y
 AnlINg9s
 CottbwxwyWk+3O4QbI5vsBWlOsX4jWxOb5PBZ1wEkT5hG+VL4UE3sol9G9b0Z2z9lXWIfQVFm4zTwMo27KWTpAKe62DbuNdR6QJ/YVGQDBxxGhC61/nCz0uXFTUzERL+ZOVmPSTi71V4bLdiCwQrtV2rMQ9Azc/rw75iM+V8fCp5KEavrKF+ZZZq7Ti7iYxyqiiO7/otv8zJw8Qev9uypF63Js2HwlZCEu/Pc2sGSPsFmzUgWkJg08cc5pep59UTup1VMne9EfujP61RVOD8qtu5M9iwiICyP4LFvC0Qf1kTMCGlbFAHZgjn5auDTd50GJqYswT7JVyp4Ge8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 10:16=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/7/26 08:39, Suren Baghdasaryan wrote:
> > smap_gather_stats() interprets its start parameter to mean vma->vm_star=
t
> > when it's set to 0. Eliminate this special interpretation and pass
> > vma->vm_start explicitly when needed.
> >
> > Since smap_gather_stats() operates within a single VMA, we can replace
> > walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> > which is simpler and also can be called while holding per-VMA lock.
> >
> > No functional change intended.
> >
> > Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 40 ++++++++++++++++++++++------------------
> >  1 file changed, 22 insertions(+), 18 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 9908ba32f180..3351decd1172 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1246,20 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_priva=
te *priv)
> >       return &smaps_shmem_walk_vma_lock_ops;
> >  }
> >
> > -/*
> > - * Gather mem stats from @vma with the indicated beginning
> > - * address @start, and keep them in @mss.
> > +/**
> > + * smap_gather_stats() - Gather mem stats from @vma.
> > + * @priv: proc maps private state.
> > + * @vma: The VMA to gather stats for.
> > + * @mss: The accumulated stats.
> > + * @start: The address from which to start.
> >   *
> > - * Use vm_start of @vma as the beginning address if @start is 0.
> > + * This gathers stats for the whole of the VMA unless the lock was dro=
pped
> > + * and VMA grew or got merged and we found it again, in which case we =
only
> > + * gather stats for the remainder of the VMA range.
> >   */
> >  static void smap_gather_stats(struct proc_maps_private *priv,
> >                             struct vm_area_struct *vma,
> > -                           struct mem_size_stats *mss, unsigned long s=
tart)
> > +                           struct mem_size_stats *mss,
> > +                           unsigned long start)
> >  {
> >       const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> > +     const bool is_partial =3D start > vma->vm_start;
> >
> >       /* Invalid start */
> > -     if (start >=3D vma->vm_end)
> > +     if (start < vma->vm_start || start >=3D vma->vm_end)
> >               return;
> >
> >       if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > @@ -1279,20 +1286,17 @@ static void smap_gather_stats(struct proc_maps_=
private *priv,
> >                * Unless we know that the shmem object (or the part mapp=
ed by
> >                * our VMA) has no swapped out pages at all.
> >                */
> > -             unsigned long shmem_swapped =3D shmem_swap_usage(vma);
> > +             const unsigned long shmem_swapped =3D shmem_swap_usage(vm=
a);
> > +             const bool shared_or_ro =3D vma_test(vma, VMA_SHARED_BIT)=
 ||
> > +                                       !vma_test(vma, VMA_WRITE_BIT);
> >
> > -             if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHAR=
ED) ||
> > -                                     !(vma->vm_flags & VM_WRITE))) {
> > +             if (!is_partial && (!shmem_swapped || shared_or_ro))
> >                       mss->swap +=3D shmem_swapped;
> > -             } else {
> > +             else
> >                       ops =3D get_smaps_shmem_walk_ops(priv);
> > -             }
>
> Horrible, horrible code, really. But not your fault :)
>
> I think we can just make the shared_or_ro less odd by just checking for c=
ow
> mappings (as described in the comment).
>
>         const bool is_cow =3D vma_is_cow_mapping(vma);
>
> ...
>
>         if (is_partial || (shmem_swapped && is_cow))
>                 ops =3D get_smaps_shmem_walk_ops(priv);
>         else
>                 mss->swap +=3D shmem_swapped;
>
> That's almost in a form that I could understand what's happening.

Hmm. So, are you saying that !is_cow always implies shared_or_ro? Or
maybe you are stating that vma_is_cow_mapping() was the actual intent
here?

shared_or_ro =3D VMA_SHARED_BIT || !VMA_WRITE_BIT

is_cow =3D !VMA_SHARED_BIT && VMA_MAYWRITE_BIT
!is_cow =3D VMA_SHARED_BIT || !VMA_MAYWRITE_BIT

so, !is_cow would impy shared_or_ro only if !VMA_MAYWRITE_BIT always
implies !VMA_WRITE_BIT. But I think it's possible to have a VMA that
has VMA_WRITE_BIT but not VMA_MAYWRITE_BIT, right? For example, a
driver can create such a VMA to allow writing to the VMA but to lock
its content once mprotect(PROT_READ) gets called.

>
> --
> Cheers,
>
> David
>

