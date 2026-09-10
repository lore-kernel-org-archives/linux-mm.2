Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3614CC88E42
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CAA36B0098; Thu, 10 Sep 2026 11:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352FB6B0099; Thu, 10 Sep 2026 11:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A386B009B; Thu, 10 Sep 2026 11:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 048106B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:36:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90B3E1C21BA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:36:01 +0000 (UTC)
X-FDA: 85198253322.21.9EB559F
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8E83540009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:35:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YSh2Cpsf;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789054559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ou5xudsvhJbATEEDYQzliV91yFmtfTC9oO8glygvNSs=;
	b=fvNx+yO+G20Fw7Ds7kfsubTM9SvWnBiZsyZoa6qoDjuEJtbbLgYl3qdCzCvYIebbgq8xrr
	WfJfDoJMy+OUSDpzx3kdENXbkMo7s+zW3eqo4NtyN54Xpk8m9WxvAaHIcC52+zkIXslNLt
	7C3jAKyHzr0lz5a+HQkhu7y2BtkMaNw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YSh2Cpsf;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789054559;
	b=WwuqQsgxNgZUddnjJAOxEaBA4rSW1jLlFa92kQfjfj4YlY3bOXvz8vjH7kRUjuixB+bk63
	jb7qeKYtImGHqx/aDLkUZ7xDpj/Xz+97eujBEcFdzdbqIvLBHOaTD62DO7i/TehlugZwQG
	GdmtqyKH1bEEI1SuAwUwhaxNO1d8Ico=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53012819c04so255811cf.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:35:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789054559; cv=none;
        d=google.com; s=arc-20260327;
        b=O6yAQXADO8T+WKYnruiKKmeF6I4/jmEMwEInujGPT7LuqUkT4xgnrbfiL43x8bqbA1
         xcsIzWW+t27EL8hFZy9SCWXvvFjG0EYZuPocEuBpSCNSfhJx6XaHLmS/bb96wWU74RYV
         vXakZxqkhI64ccAH0FybYaXlmYbSnDqotsi1e9N+37e+yeUT+qXXEhenTTFlrvvPhNAc
         zKXXfqGVNGN+Qk0klLmebPEPdOa4+eAm7N8SK5/Ib5vA9o1R8mIvGZoukO75azT9pd3Z
         g/Qx3L/Oy2MfF0JbzZ/IVzvgMgaKYfceSivEjcj2DJ6ro7FHgAIlTAmp2zBBONGPiLr2
         kXeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ou5xudsvhJbATEEDYQzliV91yFmtfTC9oO8glygvNSs=;
        fh=HTwnAdgEuXfqcf8rZHIK97g7CH6//ixRGiFUQ/lUVRo=;
        b=O4d+CBU4BrNq7HMwheeAv9m5yzcdTbJlFIqIE7hLW7T/ZGapXgcNbS2zjKYlgQfG2T
         1tmBZqU1PAKKKxeQp4tDAOHcJm/lCLMRzqUx9T188f1/pp2JBpLFaPehj34CYDcfn+/8
         UC9DgRUaECl9rnEwGFk3uYdVkzo0kPc+Dgln8QLflmObgCmKC05pN/QDne9G5mXXp06u
         kBOQWiqTKzrlG3iKiNb4mO4hV74o+WU8a7DdLfr8W2FUUgRKv+3zY/TGETAc6oKHrklV
         LpKFX/Y1OdVGfzcTp0MTYHlbESlE14ChemYYWU6NQWmTrzePYM1CU2b/+c9/Spp6DLfj
         0AHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789054559; x=1789659359; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ou5xudsvhJbATEEDYQzliV91yFmtfTC9oO8glygvNSs=;
        b=YSh2CpsfkHDrDxDrrkWitudjw8sAUf47KFYj7J0MMEKfU6Nf88RzK4oF9BBx2WZ/wl
         iXu2Y8DwDQQYLf6ZHzfqjlcdWoaLKdT/4F/z7CIy23xJeXvLD5qZo7ZIfZD1XSxhzkRW
         rfZybxHgava0P+hVXzfI6s0/xpG5ygY4bVGC7FMrql0OW4mqxJ24MNYcbbWg0+WsGv4+
         6WyqCLLwjWZ0oM/IWQzEFtGvPNrJmZrBKbE/oO1+3Pupf2XjCfXCdnmau0cbYHl+4RuJ
         VEy3lReaF0BnkIh+E5Uopp6eBpFa3VGHScyDPzD/5fW1bnGH+UNAdFb/PbVZtasyv6iV
         TFiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789054559; x=1789659359;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ou5xudsvhJbATEEDYQzliV91yFmtfTC9oO8glygvNSs=;
        b=tIr4dZ4vwQGr8YXPQcBLlJLT6FxAgeB1RIgn1FXCMMwQBbKXeFlc1yIIowaHLKb+yN
         THSAXyFtu9GvGg4hG6VQHHw7FPdV0ZDYLSDymIXb8JqVIAFHa5kl2plCKTQmujBPj6v/
         LyKgmcyycF1a5iDYFP7nLVr7o6nU++/jlubhDEzPdUfR0U4PIa2ETG+Z6hA2DgaGyXU/
         jZ/1RvRx01Uh7OOsAKaJtSeDMIVj6g+wg1GIeivbNO25OkIfj6AUzvC7/pLpCG5xVWeS
         my8NJ0nuUv530O4HdJuRgJ+STENg9e8F6uydOl17znpQvdIQS5s3eMxSYhPNqJFTijnc
         jvCw==
X-Forwarded-Encrypted: i=1; AKwUvBwsbvmQbwJ4lgIRhGfZ7kTDw5G8HYZJ+fV2I9glvQS3EIVbyHovP3DzMugl69zoNGKUtgNOY21C1g==@kvack.org
X-Gm-Message-State: AFuF++lYRzoAKpz9Vqhz3RXp0Mtj7wUqeSS66ADw+DhFjXNz1brbEChZ
	QluSA3EvxG5SoeEt4zysnDTO1HD+GEi91ImDZuHIkulqr45bvol2+rNQh/dZDbFWzoEfd9rO8Vh
	W5BOeBqY+BzjSJ9eeQq/fjUBQEbhpjHKFei4Ouk39
X-Gm-Gg: AYBFou1x8x1fcfPOKuNjWak4MiP97OCHIzrCRwiMJ4jClg/eHhBAivl/8TdoV5tqtIw
	IENoM9LLmEBVWK0h6FX9C6vuEGWm+0TDwn3+5LF8OJymf8bS17OTMFjR1RHOAyMVGIhpDt74q8N
	fnGKlTH0UkV96RhjHYLrQQz/ivLFRyB+TSt3E4DQDd47G6FnsBw2t/bJg/vH3oKMosgmKSUQqP5
	XRMRkqWaT0jrXXPGsFLvxVzGjp4tw2Ff1nk/2Xp94s2PxegsIhgnOqJ5tv62eDLQ/D0CID/yJLY
	uJ+clxG0lUUbedsstDH/r6EtbygRRA/n9rjsH/xw43eUhmW9RUYrakLqDMDPtw557BF8QonqQ5u
	peD9aaYJLqQ==
X-Received: by 2002:ac8:5a48:0:b0:52f:4a75:f840 with SMTP id
 d75a77b69052e-530b62a9367mr15603781cf.9.1789054557815; Thu, 10 Sep 2026
 08:35:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-3-surenb@google.com> <20260907164931.131215-1-usama.arif@linux.dev>
In-Reply-To: <20260907164931.131215-1-usama.arif@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 08:35:45 -0700
X-Gm-Features: AcwNN1X-343PX52UP9R_xuysezFhln2YO94sOY9W4QKq0I6lyVc17ep5qSeO2A0
Message-ID: <CAJuCfpHh1pmbhyJW5E2MZsGyMu7daW8aXvJD4A9_K4TRPt18jA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] proc/task_mmu: remove unnecessary inlines in
 function definitions
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, david@redhat.com, willy@infradead.org, jannh@google.com, 
	paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E83540009
X-Stat-Signature: dceoudrb59767q16xg975agz35r5dyrx
X-Rspam-User: 
X-HE-Tag: 1789054559-675194
X-HE-Meta: U2FsdGVkX18mJhxbCgziJbTPsfcBVAAE4amAZboExjVItDPHVHkstVY1FIuiYLehCzUzPQFCMPZ+rsd4yYKPDziC6JQwX2B84YA9/Yi3VaBZChEDFwSisEd4u1tckib+yMzC8/ZUDIayY19LoEtU1YbsP7HhAFpkXjhoBk9RhfuVvw7vDtSiKW9v+2j+b1HrK0MBGk7O3vWDcCR9BayXhqzPIDvn31T2NjV10oCrsBEozSI6fs8cxL/rvPlxat0pCqLZMjx4zZF85hXel2RTIjOfJjTJQsiVtR02DacDzPLFF5K1sKYvgeeYKAm/8q8e59GprjxvpgE8AOVwhbr6V8ZDd8eRGfMZSnzhEDg6Rx9G5VQSFlC40S6oP5BbtNcdDtvQq7m9j4GOp3XXcDu16BOmmXsqi4TNv4byjF44zm+NCbuiPEbYCn+T1iSCpZ6XmIotIPc+C7DPurXDDQ5uKjPy7Y6OF+NWL0oMnpcuzl642l7Xj7f2F6J/XZZEnMNr4qSgn2jXKzZ2k9FYTw+7THaXJyyu+lWl894Ve0P9O4UnDRRO0u0g0YijeHqXY45Qof/i0kvkRik2l4BxQJTGtlDS3BW8WQCD+yKljJrV6p03utc98MjR/HlPSsHkbgroKmbKJ+zIs21t7hFZ436ODw/vQlXezW58NkLIJCybhCFN8Pdrvwotww9o/OMZBdYxQyWKKjneteWSqGFXTJZnXJFGuHZsZ6BDvH4b7Wp2MiiK9n5IAp1ysYVuKqSQgDPmMDdP/AinOC54gS0S4HpHFD5L8PV96hqYk7JjPwru39fvhhnm9f6SexnSHuWNpor6f4eUYrPq/abKaRUPzobgkVd84n+GH6+G9DlkHXdWgWZjGmasaYtCNdRhYoo3TyZ07NR9ycGoyOtW38IexCtTPOHSuu4cL3QsyN0a8bYZ8G2sjBRbodKESZdCdNVJK029Tb+PS+4PRbYi1NwQjTK
 qqf4n1sQ
 m1HtKRnYoWvkST+bVR+QOZAmQow2DhbceGMSlJ26WHajoHd4wWHXQqggdPtcFy4pPTFy8wLTGMvvarMXO33bs1bsX6RbmPD2l20hY+tSoobrGuTVRg3zHOVPSRPJxZM4I2hUD4jqx+rmSIm/ZrDu/8dbEvlG62thNe1bbZMeDJylqxyuf1lTe+qTDPl491SbRab0xmHNDERD5cGR3DyOvVoSO0T156ihaU1csvL/Lu9eeBrHPwxtPNvlmUwO63wWgv2bIkBup0QvcVS5XT3yZy5m9CXLh8SCrPne7I8hOEmMO5hMqTmBykSDugQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 9:49=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> On Sun,  6 Sep 2026 23:39:15 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > It was pointed out in the previous reviews of this code that many
> > functions are specified as inline, which is unnecessary as the compile
> > can make that decision by itself. Cleanup these definitions.
> >
> > No functional change intended.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 32 ++++++++++++++++----------------
> >  1 file changed, 16 insertions(+), 16 deletions(-)
>
> Most of these functions would be inlined anyways so should be ok.
>
> Curious if there was a change in binary size with this?

No change whatsoever:

W/o this patch:
   text   data    bss    dec    hex filename
31321399 9024030 1127028 41472457 278d1c9 vmlinux

With this patch:
   text   data    bss    dec    hex filename
31321399 9024030 1127028 41472457 278d1c9 vmlinux


>
> Acked-by: Usama Arif <usama.arif@linux.dev>
>
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 2f500d639db5..9908ba32f180 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -130,7 +130,7 @@ static void release_task_mempolicy(struct proc_maps=
_private *priv)
> >  }
> >  #endif
> >
> > -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > +static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       int ret =3D mmap_read_lock_killable(lock_ctx->mm);
> >
> > @@ -140,7 +140,7 @@ static inline int lock_ctx_mm(struct proc_maps_lock=
ing_ctx *lock_ctx)
> >       return ret;
> >  }
> >
> > -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ct=
x)
> > +static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       mmap_read_unlock(lock_ctx->mm);
> >       lock_ctx->mmap_locked =3D false;
> > @@ -177,7 +177,7 @@ static struct vm_area_struct *get_next_vma(struct p=
roc_maps_private *priv,
> >       return vma;
> >  }
> >
> > -static inline bool fallback_to_mmap_lock(struct proc_maps_private *pri=
v,
> > +static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> >                                        loff_t pos)
> >  {
> >       struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> > @@ -194,7 +194,7 @@ static inline bool fallback_to_mmap_lock(struct pro=
c_maps_private *priv,
> >       return true;
> >  }
> >
> > -static inline void drop_rcu(struct proc_maps_private *priv)
> > +static void drop_rcu(struct proc_maps_private *priv)
> >  {
> >       if (priv->lock_ctx.mmap_locked)
> >               return;
> > @@ -202,7 +202,7 @@ static inline void drop_rcu(struct proc_maps_privat=
e *priv)
> >       rcu_read_unlock();
> >  }
> >
> > -static inline void reacquire_rcu(struct proc_maps_private *priv)
> > +static void reacquire_rcu(struct proc_maps_private *priv)
> >  {
> >       if (priv->lock_ctx.mmap_locked)
> >               return;
> > @@ -1230,7 +1230,7 @@ static const struct mm_walk_ops smaps_shmem_walk_=
vma_lock_ops =3D {
> >       .walk_lock              =3D PGWALK_VMA_RDLOCK_VERIFY,
> >  };
> >
> > -static inline const struct mm_walk_ops *
> > +static const struct mm_walk_ops *
> >  get_smaps_walk_ops(struct proc_maps_private *priv)
> >  {
> >       if (priv->lock_ctx.mmap_locked)
> > @@ -1238,7 +1238,7 @@ get_smaps_walk_ops(struct proc_maps_private *priv=
)
> >       return &smaps_walk_vma_lock_ops;
> >  }
> >
> > -static inline const struct mm_walk_ops *
> > +static const struct mm_walk_ops *
> >  get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> >  {
> >       if (priv->lock_ctx.mmap_locked)
> > @@ -1572,7 +1572,7 @@ struct clear_refs_private {
> >       enum clear_refs_types type;
> >  };
> >
> > -static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned =
long addr, pte_t pte)
> > +static bool pte_is_pinned(struct vm_area_struct *vma, unsigned long ad=
dr, pte_t pte)
> >  {
> >       struct folio *folio;
> >
> > @@ -1588,8 +1588,8 @@ static inline bool pte_is_pinned(struct vm_area_s=
truct *vma, unsigned long addr,
> >       return folio_maybe_dma_pinned(folio);
> >  }
> >
> > -static inline void clear_soft_dirty(struct vm_area_struct *vma,
> > -             unsigned long addr, pte_t *pte)
> > +static void clear_soft_dirty(struct vm_area_struct *vma, unsigned long=
 addr,
> > +                          pte_t *pte)
> >  {
> >       if (!pgtable_supports_soft_dirty())
> >               return;
> > @@ -1620,8 +1620,8 @@ static inline void clear_soft_dirty(struct vm_are=
a_struct *vma,
> >  }
> >
> >  #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
> > -static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> > -             unsigned long addr, pmd_t *pmdp)
> > +static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> > +                              unsigned long addr, pmd_t *pmdp)
> >  {
> >       pmd_t old, pmd =3D *pmdp;
> >
> > @@ -1646,8 +1646,8 @@ static inline void clear_soft_dirty_pmd(struct vm=
_area_struct *vma,
> >       }
> >  }
> >  #else
> > -static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> > -             unsigned long addr, pmd_t *pmdp)
> > +static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> > +                              unsigned long addr, pmd_t *pmdp)
> >  {
> >  }
> >  #endif
> > @@ -1846,7 +1846,7 @@ struct pagemapread {
> >
> >  #define PM_END_OF_BUFFER    1
> >
> > -static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
> > +static pagemap_entry_t make_pme(u64 frame, u64 flags)
> >  {
> >       return (pagemap_entry_t) { .pme =3D (frame & PM_PFRAME_MASK) | fl=
ags };
> >  }
> > @@ -3388,7 +3388,7 @@ static const struct mm_walk_ops show_numa_vma_loc=
k_ops =3D {
> >       .walk_lock =3D PGWALK_VMA_RDLOCK_VERIFY,
> >  };
> >
> > -static inline const struct mm_walk_ops *
> > +static const struct mm_walk_ops *
> >  get_show_numa_ops(struct proc_maps_private *priv)
> >  {
> >       if (priv->lock_ctx.mmap_locked)
> > --
> > 2.55.0.979.g7e5102b832-goog
> >
> >

