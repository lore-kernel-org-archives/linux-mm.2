Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8ED6EF5862
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410006B0088; Tue, 24 Feb 2026 11:57:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDF76B0089; Tue, 24 Feb 2026 11:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0386B008A; Tue, 24 Feb 2026 11:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1878E6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:57:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D02C51B608A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:57:03 +0000 (UTC)
X-FDA: 84479955126.29.7FB92AB
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3BA71C0015
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:57:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZEk3o3EX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771952221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0eCB7dwrJeHLLRN+P+/uPGe09CSkD3LNrenach9kEw=;
	b=Usd9XFoLQ50jSWNsT41+Wo0kuMTpCwK6WV63Kk89r7Dxorm6lrw9sO1ySuJMhKikYyfUM0
	XY0MPayo0Zr6n04XYQ4nBRcSQc6KqEeMkxqXLAy8ujhUUSPsKhr6wVnW9axNc5GwhNg3r+
	5tz2D5z8Y/4mGFeShFHUpzXsUtj/JjQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771952221; a=rsa-sha256;
	cv=pass;
	b=W4GxOgG7OCrlaKhDW00pdL7UuIt+S8a8g68gVEKV4fEJwY2g1DGfeHjICYx5u+brbZlgbq
	s/4Af1Y9iooSg/2oQl5ErY3Qn6vcwtxo3zcWo4+si2+b6WJgieGABu8vZ4Y3GtOx1/5xoy
	TBdWnSWoW2ckgv2U9y04UcNH5PSsSuo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZEk3o3EX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-506a355aedfso75461cf.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:57:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771952221; cv=none;
        d=google.com; s=arc-20240605;
        b=KsoXim/z1i1qz2aWD71wJYiqHAPWivEMUjP8lr4l3XwPknnOcQzmbfgbHaoedgG6lT
         RZ0fRjLKTRTg8/y7i4DdnldN8SNP3BPPRGhaZgk6d5fjTYqNOpVpdDA7ZSOHn1Rdkp6N
         4bCpJIqNAhtDlk/5neF4EwW6+nUoBxcDOZbLDrxP/GYKP3kOrmVjCnWVcF5tRKjF2qBc
         1wmUAHAcjh0F56zCiduaBTxKCt8z9tADQGJ7/wDalde4j34XZjNIqKL5Gols/D4aoHpR
         AqTKnAd/yZcMZ9uaM5mO/GmzwTaXbNz8dHBctlp6SKPcnBPITTGwNamLFx3YPiGTFyCj
         rTwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a0eCB7dwrJeHLLRN+P+/uPGe09CSkD3LNrenach9kEw=;
        fh=UWazug6ENWueRCmukqKKyg8ksrm6JLl09Lfqag7eWZA=;
        b=aDRIDc/42qKxVEIXQkMZw+XTjRdIOYOyg+mkdtepkUqqyT1EOXQ47KAz2KX1fjShcO
         0RumKCEgQPR6LrIvAo3IrWLg+akFP8mAplUPhCfrSOnbYAgjQjM8h6ld4B9PNhpZsemr
         RtkrdhvT6l8DqxbnqdEsGxSzieye1F1dppGa981bThokEvtkiSpW6PB+qJK6Cb7cR4Hg
         0nKRkcfpdPyb4SmG0F/VVjrJIChiSzI++t3WLlQ75eodanntXJJCU9y8oy9NiL2HImJl
         bDqr3jaqG4q3/A4ZAzdXMHcJKRFffKFLuQyLNzhDK8C6OrdxVe7jNTg1LXNB8FeK8S4b
         W42Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771952221; x=1772557021; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a0eCB7dwrJeHLLRN+P+/uPGe09CSkD3LNrenach9kEw=;
        b=ZEk3o3EXrYkEcaRrUJC7lIeolmpISsoqQDeRxTf+kQofmc+MHI2uiPFbJRtZVDyoed
         wUKfVrovcAsljVrsMotOLtWWx39zB5QIE+6OigGVNqx6PBGLLS4znvWG2zz4xxmgNRVk
         DTlpUmzFL3sAGLzEx4lL88R1KnVVtvYRhG8ddyq2cK+msr8Um2TzitECDwJI9Tzzl9uH
         wldDY41HIy3Sv9881oT6yvO4AwbPkeomqtz1C3TsDr/FqhA0CK2CNpGR2nrR10OfD3Nr
         iMYfdjto0pioCnxz8GQPa8fDk26/niOKenMDwM8YcTR1Q1N3mKaEAgB5gyKyIqN0roW5
         bXBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771952221; x=1772557021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a0eCB7dwrJeHLLRN+P+/uPGe09CSkD3LNrenach9kEw=;
        b=v5lRZ6UeBGmLIk4zzkuvcGunMqg3lP1OgbNxeH6p1TCkKbAgFJROnY2Eit23BVIvTX
         7q3imSHHhxpU7kDIzytPUXfC0peF3IWbRXLHclTSdz1hFpGRl/lzGtpsVLynhe42EEQy
         sukXQO9UDlgwvBqXGOu1AF46LoiTfT3yNATeiK2mgQRBBEXO2XpYxTf5d+dI+/O/d/hR
         eTL4Ym05tcRL3F6U4V4WykZBV58ChZjxv92hXzNKwUrDhxI+fxYcj4yQp5S5FUeDTgnA
         6v88i4qZN/ZZGXoa+kO5DSZTzIYd0SNgDnzwKKMOSvV9AnhSCQlXe8F8Tnm0EAqFy/iL
         MiPA==
X-Forwarded-Encrypted: i=1; AJvYcCW/oTOohxKjverJGVEeNT1z1m8U9RtYGyOf9MuRHrApm2Fj5/M0RyLKAazczb++JpxI46bvjr3OPA==@kvack.org
X-Gm-Message-State: AOJu0YwhRdry/Xrs8GKPUMLs2TgID9rt9ABns2tcaj0QpnvvWQxkZm6S
	qHXv5di3JPeZJelW6rQglL96c/onlF7RT6hwIilbnRFNWyrcYDhcr6mbr1tNsU7xo9RKf+fewCe
	6dY+SuKa39y+XOLHGaMLWJozDlDV2O1Vc4qj9v+xx
X-Gm-Gg: AZuq6aJTBHDd14fRvn6a5YRF4dZfK17qWoKVTdAyY9GLaJUmD1/CsuiiLQSvOrYP2hC
	oNuwNCIdFX5Pf++mLCyRD0TO7zDX+dYFFWFbq8cSm2pY3LSkqO55vPMS3iMPac1Hu07okHZKjAS
	ZsCLgIHrKsm+YsbgON4U0YB360QASNUkewJj0DGcV5VQyuyc/9jDn9gqxpGfuLIrdSZ8+yFA2WO
	K26kDlxdXcn3/lmfBxjULC/J+UkL1mBfBHVWTO+g3S2vfYIuY+0yYzSKQHtxneMWdMC3FWh+HMn
	2od6kDN8FOB6iu8utUsvFKmTh9OAlj1yhrQJYcip2HE51L59
X-Received: by 2002:a05:622a:254:b0:503:2e98:7842 with SMTP id
 d75a77b69052e-5072c94608bmr14236601cf.4.1771952219705; Tue, 24 Feb 2026
 08:56:59 -0800 (PST)
MIME-Version: 1.0
References: <20260223155128.3849-1-00107082@163.com> <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
 <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com> <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
 <aZ2yrEz2ZVggT7UL@hyeyoo> <aZ21CP0d-RRAjUCX@hyeyoo> <CAJuCfpHjeFW3xJii3ZcHD_CH8iagHaGGG35wv=ErU7Z8j1vbtw@mail.gmail.com>
In-Reply-To: <CAJuCfpHjeFW3xJii3ZcHD_CH8iagHaGGG35wv=ErU7Z8j1vbtw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Feb 2026 08:56:47 -0800
X-Gm-Features: AaiRm52mzjIVo8S1mNzF48jjAa0qsc9gWoXygaWGOMkzSAYsrNjGdAE634OqFIg
Message-ID: <CAJuCfpGGyrmmtKXK7jOhz-=6+J9D7En3RNwNGFP18Stvi3j2Rg@mail.gmail.com>
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during boot
To: Harry Yoo <harry.yoo@oracle.com>
Cc: David Wang <00107082@163.com>, Vlastimil Babka <vbabka@suse.com>, vbabka@suse.cz, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: dmiac7ojbzfuqzapy38t8qq5orpfus4a
X-Rspamd-Queue-Id: C3BA71C0015
X-Rspam-User: 
X-HE-Tag: 1771952221-863770
X-HE-Meta: U2FsdGVkX1/Oww5xEuAZZOXYtD2bY6AR8nd3stZAupbYtZozDk++MWpqWfXm0i8zqwkpcH53Fshc0m1CxFJ1v869Tzlhd+GlXytsMydoDQ8X58wABs9ohgsDJtsNuBsbF4QVTxh5A8hYAYIqYmLPmUD1mPGkCdSI5vbzMIIbXTBNnX5qBOLk6sMhudvzyzG6CvJOTzLisCEiv1GAswTsniLdg1Jxsh8KuSjEJFFdtCo+s3x813dMb2X++Y1hjRfBE61cmoqNQ1mmeoaCWvTXdoDPSgT6LGYR9XgaR9Z62V2XKj0IizCTwGltxfLEAiATHV4wQX7XhMKL6J2aYv5ygNTSgvJcsCwULgI3/vesQ9vgdQo+UfgC/0V9CmrQqTuPDE0Vi5rrIEkVrm7nNo6DmthEkFNx03P2LIlMSGqqttz2NGCSOPAUk+r2totfKDlMux1cbuXCPhKbgonYfe/yXDBv06skNSaSP6MESp9ZWz5HPlOBavh6JEX9zjK6ZSW5dKcSxylKkIDG6rh8GWJ5Upby62LCWIDLvO0T82cKj2SaGXycozS3frSZ5IyUw61MktNLw5pSSd71UFUuLtTZQ2nzbspYNZtDTiUnjrBBCpM8cX1l2/lHG9FOa8KHzyOJviGANX9etgJDeBFzzVG+5Y1eaopui9O+6Nh2uYOIex4ayCgnaVfXd8b4bjiSb0N1Hn/KAWgRFO/KEyp6Pjf0ycbzGOAmihSIzXYofji375H9P7Yw1yvox2v61fyZhSWA2PHsBmK6TPaYxcMbYSI1y0TvkzsWZVrNVIA8vYWuHZ6B69r6dAqZl78+fwOhvjYMVKluGwVMwNjikUbkpfClFhViQn0OZTzAmPOolme4a5HMHNmfnH/P68PDL/c4bi1hiCQ4MxWJTkPriEwbgImMkXfGZrED3w3waNvEtWAYWzdbgZhEOOfy3T9/EQiYDFXgCVBOB5hMzyTDsv50QWz
 Uioms2F8
 as2WV+hA7Uy1StPUAS2ZaAo8QUpoC7ba9MOsr/o9OEW/iK4+thd9diuM9TXimt5w2x02x5gNqH3HSEeX/KK4k7Ft7uQURv7clJUZow6OrCaGoWE1/l0sp2WLmNNtXbpkyMor8d+efyLYdcwrChFBkNYnPcXsCEtsWU9vCWPFYJjJEI831EKh4Ibfs7bu3jt4AN6bEFp/hVYDDv1/X+P9O5P+EyFw/Gmbgs1fUx1xABHHMjUBNdaxUgSnc6hFI7GdSIATY0+37JjpiNOTjGQ3rWVBPu8M6xei4iLLXKMk9T1ClDlcJ9+BGVazK6B36Pc8vUBL/R72HwHkp8QUckUFBsQfgcRzm+6YsAklC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 8:15=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Feb 24, 2026 at 6:26=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> =
wrote:
> >
> > On Tue, Feb 24, 2026 at 11:16:12PM +0900, Harry Yoo wrote:
> > > Just sharing updates on this before going to bed...
> > >
> > > I was able to reproduce it on my machine I have a working fix
> > > (nowhere close to upstream quality, though)
> > >
> > > The reason why we're seeing "alloc_tag not was set" is
> > > because SLUB allocates empty sheaves for kmalloc
> > > with __GFP_NO_OBJ_EXT and it doesn't teach memory profiling
> > > how to handle this when such sheaves are freed.
> > >
> > > When __GFP_NO_OBJ_EXT is used in alloc_slab_obj_exts(), it later
> > > avoids this "alloc_tag was not set" warning by marking alloc_tags
> > > empty in free_slab_obj_exts(), just before freeing obj_exts.
> > >
> > > And we don't handle this when allocating freeing sheaves
> > > that were allocated with __GFP_NO_OBJ_EXT.
>
> Ah, thanks for the analyses! So, the fact that __alloc_empty_sheaf()
> sets __GFP_NO_OBJ_EXT when allocating the sheaf leads to this issue
> later on. Makes sense. I only wonder why I could not reproduce this...
> Will try to find out later.

The reason I could not reproduce this is because with my config
free_empty_sheaf() just happen to never been called with SLAB_KMALLOC
caches. Once I remove SLAB_KMALLOC condition in both
__alloc_empty_sheaf() and free_empty_sheaf() I can reproduce the
problem.

>
> > >
> > > Passing __GFP_NO_OBJ_EXT skips 1) allocation of obj_exts,
> > > and 2) alloc_tag_add() even when obj_exts is already allocated,
> > > and this confuses memory profiling later.
> > >
> > > I'm adding the fix I have now. (I guess Suren might have some prefere=
nce
> > > on how to solve it though)
> > >
> > >   1. mark obj_exts allocation failure when slab has no obj_exts and
> > >      gfp flag has __GFP_NO_OBJ_EXT, so that a later obj_exts allocati=
on
> > >      will mark alloc_tags empty.
> > >
> > >   2. Set alloc_tag when obj_exts is allocated available,
> > >      even when __GFP_NO_OBJ_EXT is set.
> > >
> > >      Because it's already allocated, we don't have to worry about
> > >      recursive allocation.
> >
> > Wait, isn't it much simpler to just do mark_objexts_empty(sheaf);
> > just before freeing sheaves, if s->flags has SLAB_KMALLOC?
>
> I think that's the best fix and it makes logical sense.
> alloc_slab_obj_exts() allocates obj_exts with __GFP_NO_OBJ_EXT and
> then free_slab_obj_exts() does mark_objexts_empty() before freeing
> them. Similarly,  __alloc_empty_sheaf() allocates sheaves with
> __GFP_NO_OBJ_EXT (for SLAB_KMALLOC objects), therefore
> free_empty_sheaf() should also call mark_objexts_empty(sheaf) before
> freeing them. mark_objexts_empty() currently accepts only slabobj_ext
> but I think we can change that. I'll take a stab at it.

I posted a fix at
https://lore.kernel.org/all/20260224165250.1322946-1-surenb@google.com/.
David, please give it a try.
Thanks,
Suren.



>
> >
> > /me goes to bed anyway
> >
> > --
> > Cheers,
> > Harry / Hyeonggon

