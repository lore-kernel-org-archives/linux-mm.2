Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37759CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1D06B0005; Sun, 14 Jun 2026 22:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182436B008A; Sun, 14 Jun 2026 22:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071486B008C; Sun, 14 Jun 2026 22:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E79166B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:01:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 917C2140875
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:01:01 +0000 (UTC)
X-FDA: 84880493922.13.8813C28
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94C40140005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:00:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rq8R0M5b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781488859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YV4ABaGU36AUsGc4VJ0A3r+5UPPchYWDZya8U2LFpH0=;
	b=ae/dlTKGk5O6r3k2yIAXvC3U8Ere1METo52g+dazPud2A18mlogMxAm6iFjVvU9ZMIXCLW
	PreKYcI/6mY9JFNbYPJCqE3R9MXvUHwHhMQDasxEDqMiZe5+8J3nK8OIshzHXDM0CmAHMX
	ZfNQ7A0rPbayaHCtlz2V3Gpoq0sWFgA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rq8R0M5b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781488859;
	b=FywJxIkydqvq+u7DMu0ID4YHSvFb9g91irM7p6kK1PxVXO3w7kUvVDmBVIGwTqTCZsxU+t
	NLF/IaezODEZ/bAtIPv4sV8Audv1aHb6DuJg1TNpNfx2JppUyNgCZpHu7PgJYrxEB/TBpp
	FG2VgOr3ZS4dk6JGmLkpLxbKSDZWk9o=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5177d1ff061so668081cf.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:00:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781488859; cv=none;
        d=google.com; s=arc-20240605;
        b=ltWkhCYo6b/5bmM8ki0w8ZA5T6Lr4wV9On0Ts6GREY5m7dRQ3Z+ltgz1vnL5eIKAfR
         zrY17Xf6cK2/AmsiMLDV8CPLTvBgl4ZllxOJm9cHuqxGvxNsalynRN5H9rl1+aYhAH2H
         CVkfgkmnolZuE9fohAmmrfXeUF7sPwZGQydOdeTGpOmzFocOHphfpYs/Qsp13BNygrL0
         iiCCxhf6argZxfRtFdb0IAMyn8iSjaBsIIWvPRNn7Mq1vQSx+/3UvMbjsoL5MobBdwcL
         PlZHzX3ga+1coluz3tMNSDJccoudci2OExtYM1sYH8Ny2N73dO2jO/7i/RGSVAlIhCE6
         nHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YV4ABaGU36AUsGc4VJ0A3r+5UPPchYWDZya8U2LFpH0=;
        fh=HNfbIPGL4s4DvWnnIQdgCqH/h4Tq1fkee1dl85ZlliQ=;
        b=KiU1OMU/rbT5FFDd7F7R2EjWVzv/MQuJCDmov4G4M1fn6HB0SuPwgw+OLVsvum8/xM
         afQvZAMG9b9Eadf3nvsbWN5pf3WSENP8t3Ohga06i9+uPdeg9QKe/xVlQiLeY8KxQN38
         ScsOQ628fY6Ls1TP5gn+pc6AnrlXwhlUp8wxM3v+caAPJCe0tGeyP8A6JjhYaAsb1oQU
         Z9PDvvIe/Dp6uo7HpB8siS8lip9n3naEJzFAPkWqcHHEplz+YK7F0XPmEHHaoxN2uk2/
         gEf7uCg4AP0NJAjtZY0ELmRasDVTyEEPlEah2mRGUQpuHZTVWLU+L6HvmJtmlBiHGmvx
         xmog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781488859; x=1782093659; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YV4ABaGU36AUsGc4VJ0A3r+5UPPchYWDZya8U2LFpH0=;
        b=rq8R0M5bMVdNTAWRopoSNE5gH59DQYeVfMXP2fz0WOACb6RpRz0QamYGcR1gECCDe+
         /OckZ2kEVryff6cIEQKVmF0PbnY/h+TwNXKpw1Agm6/RsNn3KEepfLsMegIIyAjIdDOG
         nbpubmJIJykyXUy9ZtWcdhREy2Tuk1gzf8dh8xg+z3Yxc8RjHrUzJrsDLzhMvOQp/vti
         MJtTpdM1boxGFohfroWs/lDna5n4e1LxPH80HW0StlXBTnXeDQReb3ZLovzo6iNQhkmM
         A95dVVqwrlp9Bz3PvaLmkyI6GJLMlKL7hVyRwz3SLgcqXIjTx0odrIOhocq8wLMFspyd
         kkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781488859; x=1782093659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YV4ABaGU36AUsGc4VJ0A3r+5UPPchYWDZya8U2LFpH0=;
        b=ghVFvHv0EXcPFhioEmkpA/MWLtpyxXmW5PH927opEeDLGSKM6h4mggWiHxAoiWwQvR
         FUH2BGMrWQBCND4ppWjCRaYFWA4p95JDg8kMfrUfSCZNQnSZxTQYJgDbu2MHoQiHedqC
         rcNNnvF1QIFl0NR2LkOHT8awh6238tpMAGJ367dxDq6XBPCqhSN91+/FMl+HUtC3UdBi
         TwEynHze8f9+quCUaX5bSjFtwnKeSYTzm7AmpzEDfCyVMSSumDr6UaGRHx4hvrYTm2DH
         sKZD1/TFJOTK2UZzUYKm79mzeQS87NwIWH/a/ZdM49tsA2zd3IO1L2xP5pi/PQZF+X/V
         Ijgw==
X-Forwarded-Encrypted: i=1; AFNElJ8N49QOWuola+WO74njpKqIK4yglNsmsNXbm05eM9LqkZOD/Q6RHJb4ZqrhK/1rLcvOeQCDkKcJhg==@kvack.org
X-Gm-Message-State: AOJu0YxvfyMQ8mbXXCv487HeXjwxI7AeoenWl/OkMwaKyj55bY+wP5tN
	MFSx654FGWIsfC1iCgPe64kAZysv4QiHYT5t3c5WVOotA3nz3ybzuC4kkfWiP+2bDgQuWuqGEkG
	Cb6jwcUSYk3iW4mwveuQtSAldnlWnz8yW4VLL7/t0
X-Gm-Gg: Acq92OHQqEEsO4SlDGCiY10uAWVkKXFdhBFeW7x0EGyBNjxsQ2z0ChufBIZ4ofyze4u
	DeM49uFj2/MHIxSXzwFwIv8pq9LUC4kZTNNC2d5WghqsHDItJKnO8+FK14aMwveAfxkm1bEbQAs
	blHg/tXqbNayJebT4RNC2/8VOZ/VzrLNMCC+S/sZjFFGy/MMGA2UGtQFFUx2UiSZwHunzMZcFJ5
	wpAjNmoazNxgIHY+jBNqb3WLm5HRclXsecSuJ/KRhZbntCl9BvXpSm+CLuRRY1yBrEyPfQP6psP
	n2vJIg==
X-Received: by 2002:a05:622a:4a06:b0:517:5c70:46bd with SMTP id
 d75a77b69052e-51955e9528bmr12464811cf.11.1781488858160; Sun, 14 Jun 2026
 19:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org> <aiuBoDbQc0N-l7e-@fedora>
In-Reply-To: <aiuBoDbQc0N-l7e-@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 19:00:46 -0700
X-Gm-Features: AVVi8CeUw0W_EslN4JUfmO-ybZYKHjgOAgJIjaWoAT60L70xQw7t8VlC106Tfg4
Message-ID: <CAJuCfpGSHfNUvL9AzbftSg=uGRW4cJLbO6iB15keyN6A_eSWEw@mail.gmail.com>
Subject: Re: [PATCH v2 05/16] mm/slab: introduce alloc_flags and SLAB_ALLOC_TRYLOCK
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94C40140005
X-Stat-Signature: t7uo1m4diy3qrtbnbe56cnrdg933fe5o
X-Rspam-User: 
X-HE-Tag: 1781488859-46169
X-HE-Meta: U2FsdGVkX1+mblzRRFI1wqK79UNi75tNgWxGeutwe9GcKv5+ZIHWuVuwpeO2hWmDM/H1VlaCYHWuVzoJGtjoHgtDRslxk1NkS98mM1DManyWb1kRyhX7XCOECnF8jpx+R3Z0KKLx2XDsrbHmcI5E0t95tcWAbszHkuo7TexiGu6ped2cj2+ZrAEHkJjPDozZzrVgzYhFha4mBaNkXD50jhJGu9GjbNHAkNi+yii97suJhSQDVxBbg6NittcOM5+IybwD+AAwpYpaakiqQaC1ApfmaZpJisKmpwWKtCcEVND25NShto4CmbH8AEayTZKO0Jgpo9tUufLVbxq50bSfdNn2ERKOKn3zzrD3NOQ4UYOIICb39MN1uRHChguuOIp9ImBHJ5T4LuwKfOTmbqJHGlQR/5kwOSUy3GfNap8tstwSgDMRFRVgEkyxM/uZ8fiFpj1pYwBVDfU287e+2Ye/Sd3Wt634C2c4JnU2OlzOp70HwuRPY46CZbFDunBXOwyBV818OR+olACTtJ1oE6hrTjVcJ/uk93xT+5ASJnaAHKos7lLqGI1msIh2E8JqV6Q97KKDcniQS/bAvy0UlDQRiS2tDxzSmm8gcbg74bXVRyfk6fVtrdOsstQIktv4XasiDZQhAaiUK1c1znLBFk1CdOpdHlf1NgVQW05sYu3CKTc8zCJ05hksS3bG+Xbq7qazZZ/Ye/E8+hIdDinH0nPkXgtDS2xldgYKuFA7slKoeudlMWq5+KyW3wcuXFI+APJSXgT2GYRS3qFrdoO1Xk2ATxIT95NxMzzdaQvLyl+Emz5pxDlcPdF4/0ZxV6KJx3lJeQK4ddD/IubzL+8aKxzqfyhyfP1yPFG74cQG+xiV9dKpnqX5YD6fON3cRCoD5ivROpM6r0xyEYhWhzMvm3aT0QhFr/KriOMUKPwwS2xeYOk330c27f5Hj2Sems91qVKWc1iwzek+semcr3m9pgp
 0ZhMEw7D
 PnMOLzINP8+fo2aNCpxEX2gZ4X2QJ3PFoUEHjQwDyRmuZrD3cPdqaqWiTjan6sQdYIFfq4GkVckCGhprZfN2Uzb4O3ZJ0Qf0+x0FYX85eTXLEkDWQah3dfYynBqL8NfzX+Ziuf/CxeoCcde3g/Iau0pCYlWuV3keOmdwJ8JMWzr6hIoASDaq6W90ELC9OxTy2+ZAapwLSU/UYUsxHHMLshzNHRKPJHYG+OrNdGr8A5yVudrLueHxWtiab+1wQdvaLk8nLwhi91b+GBuyMBVtFLRrjCmOU0juxggz6M90SwmjhYzTv4li0InY61yCJW3Gnll5fVIWoe6bzAeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 8:50=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
>
> On Wed, Jun 10, 2026 at 05:40:07PM +0200, Vlastimil Babka (SUSE) wrote:
> > Similarly to the page allocators, introduce slab-allocator specific
> > alloc flags that internally control allocation behavior in addition to
> > gfp_flags, without occupying the limited gfp flags space.
> >
> > Introduce the first flag SLAB_ALLOC_TRYLOCK that behaves similarly to
> > page allocator's ALLOC_TRYLOCK and will be used to reimplement
> > kmalloc_nolock()'s "!allow_spin" behavior. That currently relies on
> > gfpflags_allow_spinning() and thus the lack of both __GFP_RECLAIM flags=
,
> > importantly __GFP_KSWAPD_RECLAIM. This can give false-positive results
> > e.g. in early boot with a restricted gfp_allowed_mask.
> >
> > Also introduce alloc_flags_allow_spinning() to replace the usage of
> > gfpflags_allow_spinning().
> >
> > Start using alloc_flags and the new check first in alloc_from_pcs() and
> > __pcs_replace_empty_main(). This means some slab allocations that were
> > falsely treated as kmalloc_nolock() due to their gfp flags will now hav=
e
> > higher chances of succeed, and this will further increase with followup

nit: I think it should be either "higher chances of succeess" or
"higher chances to succeed".

> > changes.
> >
> > Remove a WARN_ON_ONCE() from refill_objects() as it's now legitimate to
> > reach it from a slab allocation that's not _nolock() and yet lacks
> > __GFP_KSWAPD_RECLAIM for other reasons.
> >
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Reviewed-by: Hao Li <hao.li@linux.dev>

I would call SLAB_ALLOC_TRYLOCK something like SLAB_ALLOC_NOSPIN or
SLAB_ALLOC_NOLOCK but naming is hard and I don't claim myself to be
good at it. So, feel free to adopt my suggestion if you like it or
ignore it otherwise.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao

