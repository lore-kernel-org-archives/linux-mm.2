Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C849F483C6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74B06B0088; Mon, 23 Mar 2026 12:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BDF6B008A; Mon, 23 Mar 2026 12:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61AB6B008C; Mon, 23 Mar 2026 12:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B54EA6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:19:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 886D81A0C38
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:19:22 +0000 (UTC)
X-FDA: 84577837764.14.26548F0
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 798DD80010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:19:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dqRqo0ED;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774282760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zu5V9IMpv53mt4/8sIDxzKgjYvxBsnh71mb2Wz907UM=;
	b=aYrkINAbCzJrdOOG77rMnpYIDdaqPRoVrkkEBKV3Ua+UFSbiy+AEKd6JqoJB6SDqzvF/9x
	82RM4rEN7FUPZ1oqHEFSFxEatRx5ensgZ8yU9tzyI2GvwB0yJcTsJWLkZz0jWa4a406aHe
	t6AjakUKosFohSxceoUQ3QNAek7Ohfo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dqRqo0ED;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774282760; a=rsa-sha256;
	cv=pass;
	b=EPSlNj8GjuArd16fRH6pSaVLIFd6CVyRw4/cxhN5nbl2SegcPDeVI2fGLMygMYrWoZtQ2o
	hQ2wjcGXWxEWfynYh+YWq+XA84W35psnfPDIt47wDN+mDSA1rxnWoMqLupZSFoyPfiLXLf
	uITBS0cmyaBSwd41LFJ9GeMCp4aRA8E=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-667cde0fc88so16428a12.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774282759; cv=none;
        d=google.com; s=arc-20240605;
        b=YiaW7sHDzbRto1gbXmcK6QA3AmlxCnYgNjjTaO5RijR2CP+bdMnZ+J8Vy7dGtHyJBD
         msGhwTmVCah0frfOpqjPR8jWhqdU7vU7EPnvUzWrLJisnB9s7z4INYXGPMDwEzVQwYNb
         2cielO9dY55NByWfSwHsqMkBstN468Aajy+0rRz7Rqt9IyY/+Xo3BuwDbpYoI6j13sVr
         zQ2MCX4n2ZQPrQljZaoUyfyoCzz7GbYNMremc3DvSn+nneHrcq1YXh+GM85RGjiIusnM
         eAhvvHK1N+6y3zGGrYEH5uOkrb8ARIu1rqY+6+eNNdgRpC6talvZiLyND4pSO8ML05H2
         pAvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zu5V9IMpv53mt4/8sIDxzKgjYvxBsnh71mb2Wz907UM=;
        fh=6j0UtxFXiW6cQh/3t6LYj1+amPmy0my19Vg03EkGAhA=;
        b=g+BiDVefAq90/+xeKtuGhdHnqZC8OCRAe1c8MW4Ia/9U9g3DIGX76kwiuy0q23R8n2
         r8w7XV2o/0Bg5BCbMqQe1VeoHfaXQrtvDelkWNjbx/remmcjqjjuve4l65h+xdw/o5Ff
         SLvhBAu2swa9gtMehMWRv+bWnK8xr/1AveQdbobZHFUURqRGEVSUCVAIEL5L/1dkHeKQ
         Rc2pVHaoFVAIwYrbq1+jEQB0BGZP3oaA/XMeyenop6dlkg0dHw4/LY/gjtz3+7SedflA
         uode0grPOK5u3Ex9tXg8XUnIrp2RxXhuFFjIcDtsr/x5EeEyVBCPYrWd5PwB+7uFkXGI
         lR2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774282759; x=1774887559; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zu5V9IMpv53mt4/8sIDxzKgjYvxBsnh71mb2Wz907UM=;
        b=dqRqo0EDfpk8yamVv8LFwEpN60TFhFYENOsZWYKriVzZchoaWvtaSf7Ow0qW5TMYro
         6/x/0Mg105K8pe2IwAQqTqHuNOrADfPXI0HpH+LxZeS1YLle9dWavWcMOcG05ioSx2EN
         ooBItO4tHNpWbqwyCBFUVXRgrHP0H1cPXEC3iH+P6SqYIQ2Nlw0g20SzSV+kn44rp6SU
         MoWN/XtQhRCFuG3DTfJXGqd53ClWuwT6hf0kTLPdkQ9K60IRCGnIipU3eZ2mP5tKFxHh
         P2Ozd5opQTgC739aksyJSfm/uR9Rj91JuyFJz/gX/kItlnCXXRiaMj9RU4AOoTW8ChtC
         NbYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774282759; x=1774887559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zu5V9IMpv53mt4/8sIDxzKgjYvxBsnh71mb2Wz907UM=;
        b=JENTnRtboh3dOK0jDS9lE24VYCME8RaRQxjQ+BuGpkbaO5V/kdcHuMLOgZU7azYIHx
         tgxA4EWTfaIfblA7HbfK4BkD+bIrs/1xdbi+P42JqUP8YtD+svUfOeyPbVTofKD8RoVk
         q9YiZ0U01Mt4KOKdEOFd6kRmQ9BhN1AMT6hHSkoUmYiLbvgkU0vycl7FC8wAki7QhlCq
         XlMWvBgxSUcluGWO8sCKXVk+6k/IrIsIdntJXG/D5K3C7jpc6KfxGWCAtkTr904kT4go
         vRZwclabg53hJiGVY8DJ3yp5H3N+Zs83k4PUiUoPyDU36l2Bptb0WQ6x2kQzrU4bJdnD
         lCIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg64c6pwICVLRjLEeO5l01x5LIBhJafvcJGolnnyQ1R5hemVMybogUQ0kWTCH/I5OfmrZuNCcPxA==@kvack.org
X-Gm-Message-State: AOJu0YzzuWjXW5yedO5HuevQQYmzZL9AmN408x0wQs7lY95oQfL1Cmjd
	SPMLx55W7Zu4KyCoyQIUo5XdOajvzJIYdWoJ+LzN8CD8IPIFkWkAuHNy6rMg2ASaR3BLtC9VwSy
	dk7v0u4p8o5EnXtqPiyiEjibEqN5A1GwxXQMWWCpm
X-Gm-Gg: ATEYQzxdYJOjPTv0aJSKf2nIx+cb7pCI3VGrMfi4WdRRZAp479SMqIBJlEX1oG790tx
	zkkB/UYNz4bkmDrwQF1mPDKojH5XUfM4aWBeNLVL7NbQRFy15BKZm/av3PW9jWI+RnniJp6sjfo
	NWxHbzXgVJjPMgiEIrEXgWKx2giV3q+oTqDgFKCmJ4khLTrkwFT7CNAyrBsViEoE9d8GmHP/iPt
	j41AYUiiRscjpYoXKIfyqknq2qxDboIaydZB1uoHiDxoBe4xNNhLCPcUTiCQhFnekxJ/k+sd3zX
	SSjBieJmlv+Ppzhn
X-Received: by 2002:aa7:cd6d:0:b0:669:afec:ac72 with SMTP id
 4fb4d7f45d1cf-669afecaceemr35591a12.16.1774282758308; Mon, 23 Mar 2026
 09:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260322070843.941997-1-surenb@google.com> <f22cb9d9-7fc8-4a79-ada8-02d66a1155b2@lucifer.local>
In-Reply-To: <f22cb9d9-7fc8-4a79-ada8-02d66a1155b2@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Mar 2026 09:19:04 -0700
X-Gm-Features: AQROBzBNO8QqxgMFmZ2aB9SRIVpvneuOke49Oc7vqMiJPC37lWn9OxjIHjUh7uA
Message-ID: <CAJuCfpFqz3OvOrJOnYG8NF0gjzkzmSaiM0LZKD_aLoW9Br2srA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning address space
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 798DD80010
X-Stat-Signature: spoh6odqpc3nmcag7xgh8h8zgaaw9dxg
X-Rspamd-Server: rspam06
X-HE-Tag: 1774282760-99479
X-HE-Meta: U2FsdGVkX1827ydbFeYniiw/+VhKfEU3oNbud6K4sYOE64qC1zAqdDFiT7LE9O2KynlaO5Jc6bdE408H4i/mQggyqKNGRkkxJLQlDsbp/eZ4/mHAkfgRO8F0pjvAQY2KZzgArLE/rwzDd85GAo/mdHz/y7JvQV4TiaV19t/vmsscgnMDv1zXS8UtGzr48S8itSiiuTb4Hf0IZtX2qxdWEpKWyjeif1E9/3tzD4NIviAS0IU/XNCo44MBFge2SXYbTEr9g0MDqUye2wdNH3lTZHXfCzGSH6v+60Z0IAzfQkjQi+DOSOcB4d80blANs55uhT/qP4XHioZXh8mfmUPgdEC1bgN9IlD2ma14oFxK34IdgijxqozpHsFu1Os7dVD6lCy3azAheW6TnhV8qlBwVMyIh0/b8yegNS+fYAdhWvvfw7JHiKgC+EnwwoSsKRpb2UzGU2HSyXFVSV+bElPo5PmdjUdLXY+k0FWRSeDkKZzhAo+Mquc3+vB7Ysx+108NnpBR0zagUT7/ORRUq1tVCpLksHr6YjvW1DQyFOWKb21IEYdScJ4xZ8mrq+TwToeoO3E+EfhyAXHKDkVpnYDZncQDYcU+XBdLw1rFFjLC70PcvjRKHchpO5sY9DYfFjEcCY+zkw7qbOAEKrTcsAT7mviZwXDuIv2qPTKBhFzi8+ce2eUhUgZZXB3vqhokf7YEEDYzW4fBLRcgch68LMnfM2ewq3pxluBbNqjsqxripjvoW4WHSP3MB9zryaIrqptuGdfwO0KQ1qTNXmjs4D+84qNmSYXhqk2hTO3vl6hBVdDG53HTAveQzgGlUcdakwAS4yDXDzMe0em/iuhMFcjxMB8u6d//viLpARs3oU05L7L+SZJPD4YTAs3+qDgWNmPEiiTjsmRGqzWOWu7ItG9gad2DLZJX0wtrleiIVGCLkmVLGT6BUvXsnUXNTebNbVV6tmIrxdS9gj3AdtmnNP7
 1qWODxx6
 VA/Z58xUj12qKsgatUefaJ3NVNlouTbFrl4SRvff4addyfdEmlE/b0uyA3pcW0i4fP9pAU7FGbEY5SesRkLxgMYzw58gxYDmy0GOTDHnnIpDz5yDDKjREVUYLWmS34RvMeDg6A+qEc5kUIpNeMwqtpATNapqEThtl/Q2CjLkJ1S4CUUFImYMDjVziMPOh1d4LmvK54m4SRmgCiSVdqU1aZ/1LVBEpcD87z6FWaF0ABUbAXeu0ru+o57H1GlHd+wjm7eTr4MWZN29b6BKSXxIVKebetFSJEM4MhSLRjcTJfs8KjfuX/aXbY/zw+QU5kDANxi1n19O0Mi/q5b+o/lw4b4RW3gSDX7MIpVVzr7POqCvW9rXqQD3IT/wnem48w7PC3mxMFo2LnEFHwQ+ADyh+TzApiJ3Y9UxOAwGAESWgNlWzDOU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 6:43=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> > When shrinking lruvec, MGLRU pins address space before walking it.
> > This is excessive since all it needs for walking the page range is
> > a stable mm_struct to be able to take and release mmap_read_lock and
> > a stable mm->mm_mt tree to walk. This address space pinning results
>
> Hmm, I guess exit_mmap() calls __mt_destroy(), but that'll just destroy
> allocated state and leave the tree empty right, so traversal of that tree
> at that point would just do nothing?

Correct. And __mt_destroy() happens under mmap_write_lock while
traversal under mmap_read_lock, so they should not race.

>
> > in delays when releasing the memory of a dying process. This also
> > prevents mm reapers (both in-kernel oom-reaper and userspace
> > process_mrelease()) from doing their job during MGLRU scan because
> > they check task_will_free_mem() which will yield negative result due
> > to the elevated mm->mm_users.
> >
> > Replace unnecessary address space pinning with mm_struct pinning by
> > replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> > within mm_struct itself, therefore it won't be freed as long as
> > mm_struct is stable and it won't change during the walk because
> > mmap_read_lock is being held.
> >
> > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  mm/vmscan.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 33287ba4a500..68e8e90e38f5 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2863,8 +2863,9 @@ static struct mm_struct *get_next_mm(struct lru_g=
en_mm_walk *walk)
> >               return NULL;
>
> Not related to this series, but I really don't like how coupled MGLRU is =
to
> the rest of the 'classic' reclaim code.
>
> Just in the middle of vmscan you walk into generic mm walker logic and th=
e
> only hint it's MGLRU is you see lru_gen_xxx stuff (I'm also annoyed that =
we
> call it MGLRU but it's called lru_gen_xxx in the kernel :)

I don't have a strong opinion on this. Perhaps the naming can be
changed outside of this series.

>
> >
> >       clear_bit(key, &mm->lru_gen.bitmap);
> > +     mmgrab(mm);
>
> Is the mm somehow pinned here or, on destruction, would move it from the =
mm
> list meaning that we can safely assume we have something sane in mm-> to
> grab? I guess this must have already been the case for mmget_not_zero() t=
o
> have been used before though.

Yes, mm is stable because it's fetched from mm_list. When mm is added
to this list via lru_gen_add_mm(mm) it is referenced and that
reference is dropped only after lru_gen_del_mm(mm) removes the mm from
this list (see https://elixir.bootlin.com/linux/v7.0-rc4/source/kernel/fork=
.c#L1185
and https://elixir.bootlin.com/linux/v7.0-rc4/source/kernel/fork.c#L1187).
Addition, removal and retrieval from that list happen under
mm_list->lock which prevents races.

>
> >
> > -     return mmget_not_zero(mm) ? mm : NULL;
> > +     return mm;
> >  }
> >
> >  void lru_gen_add_mm(struct mm_struct *mm)
> > @@ -3064,7 +3065,7 @@ static bool iterate_mm_list(struct lru_gen_mm_wal=
k *walk, struct mm_struct **ite
> >               reset_bloom_filter(mm_state, walk->seq + 1);
> >
> >       if (*iter)
> > -             mmput_async(*iter);
> > +             mmdrop(*iter);
>
> This will now be a blocking call that could free the mm (via __mmdrop()),
> so could take a while, is that ok?

mmdrop() should not be a heavy-weight operation. It simply destroys
the metadata associated with mm_struct. mmput() OTOH will call
exit_mmap() if it drops the last reference and that can take a while
because that's when we free the memory of the process. I believe
that's why mmput_async() was used here.

>
> If before the code was intentionally deferring work here, doesn't that
> imply that being slow here might be an issue, somehow? Or was it just
> because they could? :)

I think the reason was the possibility of calling mmput() -> __mmput()
-> exit_mmap(mm) which could indeed block us for a while.

>
> >
> >       *iter =3D mm;
> >
> >
> > base-commit: 8c65073d94c8b7cc3170de31af38edc9f5d96f0e
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >
>
> Thanks, Lorenzo

