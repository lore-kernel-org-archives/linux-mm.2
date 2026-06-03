Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB348CD6E6B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 23:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9EE66B0005; Wed,  3 Jun 2026 19:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76ED6B0088; Wed,  3 Jun 2026 19:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C226B008A; Wed,  3 Jun 2026 19:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C512B6B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:50:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CB121C1287
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:50:03 +0000 (UTC)
X-FDA: 84840247086.03.A9CEB7E
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 798FDC0006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:50:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qKzXXPHX;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780530601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+STNoqDbTOil7FnpxSpmT3xZ1M95B5vs/FtTNlIr02U=;
	b=pb3XYKNSjbXj46runWvmO5DY4E2pQ/OIN1ll2Bbmk3oZkC5mHRvhTJKZgfyZ5JRxGnGRrf
	zyIUZrIDGF/v6THZ+OqBve1gvx0SKXg6gtX8HGvAE+ODUkDgQz1nKbCm7YFlXMZmGgOcpy
	7l2uvkF/13DawjqgGKyawU0+l7DGErA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qKzXXPHX;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780530601;
	b=NWfR79H2zDw7MPw0R4NEUmgYcmbLusY54perswpxUwFt/O31hNl9m/+oeVpGXTCPl/qJNF
	0XGv7d3LJA4JwXLPmTNEgnv1Gt+3gkGb4Y9M9B7y7Stx5iawIbAwRAZvfpBCyTnjMEMaIS
	u1Op4WYxEEZNbcZMxnbCdrgMJSvSjfs=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5177d1ff061so100551cf.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 16:50:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780530600; cv=none;
        d=google.com; s=arc-20240605;
        b=dT1MFBEDE7lA+TTwV7aMnQbccXhAu8yU/l4NTrvPDfF+TfTFH/kUBdRLWrg2UAS+na
         vP8GcYZpT8uUNY6uR30Wk2BQYGDrHWr81B6Sacah76qPPrGONfLlLZ0x44yxqhgVQhOb
         kG4ystzR1S0SMNvNSdeZ5Jfk4IC4EDuEaGalJGE2UQpk6uM1D06HPP7APMBqMBFq/llF
         t/pBX2wzuWyFMtrFkLEslF3J5L5ECLhUDoSrBGyb5950tSRd7UNBlqTgNH8ZImkTmpe/
         xsHLBGxrgl6FZi669JAEWZGcdIl+NmgVtz6pFwCuAa7UD9v27jV0QiCBLATMoHv4Jrp+
         xwwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+STNoqDbTOil7FnpxSpmT3xZ1M95B5vs/FtTNlIr02U=;
        fh=7SQ6izoStCErFMtbE55T6o3YstRtxZ5U9SmHLHG9Qdw=;
        b=TfJPANI90UCx7xYv1dsOsAlNDu/MllP9V9X8UKBSaua2Hweo4GR0ihSMGYoEuYlDhd
         CqLlgiUYEYU8ISxOkn1ik/RbDkzrd8cRrHgEnHPErGH1gDK5mSSGoSjSBNSDov7Q9kn6
         8SmnM34AcjOG/b/ErvQBz8LnawZZ7Zhf7HyooldFdqqBvdUOWAw27r3DhzZquYfznxJZ
         2AdyJg0GTeIlBQC6+KnAQ/zXnb7OWKOW+UaFLXblHplWPsgSgjLlKLqtLqYeA9zo/du5
         HH6CQPhNhCgihWUgQNEEwSiNC5xcot4foE2aE4stnOucQY8yypek2fyAEaKhe2u+SPFA
         /t6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780530600; x=1781135400; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+STNoqDbTOil7FnpxSpmT3xZ1M95B5vs/FtTNlIr02U=;
        b=qKzXXPHXClSVbX/TbY7FU1SbQg/pbnz80V4jjjfTQtzfJOct1zx/KqBUMs4FXbtB4k
         5s8csFmcscBEzB0FNeP7KYEudWGY/BKsMf02ez+fLHWAskdRNHbrDqLsSgsMSlPg83H1
         LWbhV7M6KWlU2PQ9630xeaF4gH5lMXc065DDk9SLA+BGIfJVnb7xagB935FPfxABSOcb
         Nyu8W31aUS35sxun4gRlLyOdwmtD+Suunw+0YWUPfHO1jBM6gkRp3FabyNnQVupPBE3C
         bTGVzKIEZ9t3FpR41mTyGvb52WBvkPnAoVr/bmemPMwtq4u10xg0eZdb/C6QwhVmtnLp
         3VsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780530600; x=1781135400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+STNoqDbTOil7FnpxSpmT3xZ1M95B5vs/FtTNlIr02U=;
        b=bCEcxEpYaaTpE62oqqoPk5M4eZ5LhrmDb7wYF9b8NUz7sEOuO8PSq6zSXkwe2PbJMz
         CNeVxbzrOSD7/+8dsG+ij2fuixFJ4W9d51XRl8HbvnZ/+QQhthGmXcTV0Myb2BTMyhq/
         SopDMErqNtP7vAhP6Jp9suH4EmgohXMXZekJ9uWi7oF2kbHxS0eIkU2DnjLPcuNwblvl
         9TyZ9NvLwXym2BDf+LQfTqGpmy9fBEBEjtRL6K7oZCGF8/UXia72FBgcYr7Gu68i6L55
         N8634n74OQKnE8CDmTKg9iIbUaK2yTVGjrEfgh2h2AiucF3bJ9uqRQnPXdEGBfucUNmR
         TZfQ==
X-Forwarded-Encrypted: i=1; AFNElJ+eCoYrycQ73oZJrhAeyegBOQdIeCXkSnJLZaL0KLTREL97H7Dr4wAcs3myULHowXXNIMDeyYzFpw==@kvack.org
X-Gm-Message-State: AOJu0YxuRznWrZW/29FtJjXEvBw6SyTYYXi8rjwIEpUSYB03L8JMpcXE
	3v9twV6RJBUZ0dx3uV2OA9qFRkqOv4tnvkVf+VVV24G5S75AzMuTTQtV9bqRq7RgHoUEgolFq77
	6cRucOBKC2k7vatWeO+Gd9mWeAIbCk/7OWPaIreKV
X-Gm-Gg: Acq92OFDtzKv1W8VsfaVKzK0Bow2SsxUxdQFX5cXYSg3kE+hJyhVtTPLsmEkZCRCzIv
	IRarBaI4J3ddmdrjXZutl7j5vJPbt9i7nt+/l8Fhqw1UDik3KG82PemC9x1s8OHFKvtuMci/EzM
	h1zJ55+cOVXU2PePHTrYWp8d6JjEa0xogd69d2XJGmPfZeBcEPYXLzLngWYuJ5rw6yNwbrSbhBb
	IwL9LSSJ43lFxwAEyqMkvyM1uH8LRZEJaHzqec7wWmJW1Hxj+vzEd8W80QsJHwCv6vaTcuuxNoP
	urtK0/QozffEOS77
X-Received: by 2002:ac8:1492:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-5178924ac87mr1917311cf.5.1780530599046; Wed, 03 Jun 2026
 16:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com> <20260426062718.1238437-2-surenb@google.com>
 <ahhMEBYM9bixF2Lg@lucifer>
In-Reply-To: <ahhMEBYM9bixF2Lg@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 16:49:48 -0700
X-Gm-Features: AVHnY4LVowgcCqyS2rWzIKKmBhNJYxjGPWjhqH2BDatgz-xDpLvblbN-53wH_z4
Message-ID: <CAJuCfpFJvuFZkgKwJ11RjDXYhTz-a31HO9-5C+Yc=KxbsGvB-w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] fs/proc/task_mmu: read proc/pid/{smaps|numa_maps}
 under per-vma lock
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, shuah@kernel.org, hsukrut3@gmail.com, 
	richard.weiyang@gmail.com, reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 798FDC0006
X-Stat-Signature: 9jzsyqbhkn97zexg8tpyq43gjeomzzkj
X-Rspam-User: 
X-HE-Tag: 1780530601-27014
X-HE-Meta: U2FsdGVkX19N3v1VKq5ZOQnPLcyVft/x5Yl1kTJ6WrzvGHqDVeldFGvglz9EFd4g9iQfCJSCKYyqITygXt5cMep9iB+QnZ1+IuBe6Iof04xOyYICdJmmaX2Y4DceQqHdJnbDC6XBl8ZagNya+8XQEBu8aDClfXozQsBFs0FWmqkFzk257MyuLpd/R8bI1lbNEOGYIZdqwKO/u8zbA1IJr/nnSqZ6ZfKR9Fka3FhOzIm5hTzpvxqVOlScNkGG3hARWEENCgg1UAJd12a00gtG/whGjcsKveOOoLLx/HI9GubNj/Az30XHe6FxwiSx4/RfxU1WwZ8wivctQ4SjYROeaOxKR+/CVz12NiDBsa71472Q8/2BqUXtqbPKPJaoAUn6syd7GttCJL0AYlhDWZvyZeA4fTLPQqozdd/6BMWLwAGxBu57/zgvzPSt/5Kdxujqu3rUOc+Ixhf5ru7wGT0tp6iXnBDC6N2XsH0c+OyjuTvZLLlUwI9oi3tT8p2y+SActv4jLjEPJxiThCLBqffrrX8ynnsyKHCABjnKdD/3b8kiCf2uSZ3Agbh5l8J7I0Usi8ecb2Zl6+tuLVK40Icn5uLE7sHwxScZsOm0NSUbtBTjb4nB/904wd3A+oHHSF+foVvSZ0UotuSvN3oBdeFPddXiZz2DlbOOevbdCDID6dpm2yYFYuZQqCXbIWBTfrR7VpbwV/erBkf4uW8E7zuInFJzqDsLnEcK9mn0igYvKAapVDtBOalZ08ZVM/A+wKf2m5a8kNthXr4H/DxXj96eEOQo6atVCL9gDDjvTDjGcOlkat6Z805Y5yCg1bjICEso52/ul9AF4FX97U38vWSwghbiHhZ/dVSpF02W2wkyu38Qo+V2K2MwLyOk+ucl3nOPgTqsqXWej8JeTamttTJUt0D2X1kZfJ1RQfT2x02mrPea45dOjIUziutYwYSLV5yQPs9CqhzLPT+SzhYIEIu
 T8pgw/Lf
 Ss1stqIprjqHZEMSlCGPs7tayQFRde06rPYT67Px9dbeHOb3RrCuo02KjZtsONwCn4tVyeEm1eIp77+d4QXzymxg591Bovx3Eho4Lt1EdzMnQdYCBYirUrry/P1chFmWPdh+fKYEYSPGVifqf4gXpH4ASt/Bp0RkB7PhhioKBefX9350xoLDetbt0J+vULxfLC51Y+nDEsl/edzX5ROBOU8x8WHloYh5f2tDY5XppF93jwaJ6ZQR3O0+MHQQX3BY9bowZ9+Viqj4UI2Hx8NpRUiitEuwyT8svhhPgQ2IwB48xMLBl8iCzSN+8jWXlPJJfNyAUbqBpXoAs6k+wGYOHVJuRQW/lEJDx4ZkyBAQEJBbS7OKaz4YwuLQ8iVmiZ7dVbUMQXHN6CXAl8Zfy4YUC7ga6LF6hcqGAnolPVZQTDj4eoDEf+5KxsmRSkvAsurMDTyMUR4nkbpng3QwzGx7yTL4XgW/1s/Okj87XBxczDXzHL5ejnPKVwyIFYQJUvmvfEDLeWUdxTPeLE7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 8:17=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Sat, Apr 25, 2026 at 11:27:16PM -0700, Suren Baghdasaryan wrote:
> > proc/pid/{smaps|numa_maps} can be read using the combination of RCU and
> > VMA read locks, similar to proc/pid/maps. RCU is required to safely
> > traverse the VMA tree and VMA lock stabilizes the VMA being processed
> > and the pagetable walk.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Liam R. Howlett <liam@infradead.org>
>
> The logic LGTM, some nitty things below but in general:
>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Thanks!

>
> > ---
> >  fs/proc/task_mmu.c | 195 ++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 156 insertions(+), 39 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 751b9ba160fb..1e3a15bf46f4 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -132,6 +132,22 @@ static void release_task_mempolicy(struct proc_map=
s_private *priv)
> >
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>
> NIT: But these inlines are unnecessary in a C file. At the kernel optimis=
ation
> level the compiler already decides whether to inline or not.
>
> However in the kernel we redefine this so we lose function tracing and al=
so we
> don't get warnings about unused functions [0], so this is actually a bit =
harmful
> - you can end up with dead code and not know abou tit.
>
> Same goes for all the other static inline's in task_mmu.c.

I see. There are a bunch of these small inline functions. Once the
dust settles, I can clean them up. Dave's series and my folloup patch
to change smaps_rollup will be changing this code. Maybe after all
that is done?

>
> [0]: https://elixir.bootlin.com/linux/v7.0.10/source/include/linux/compil=
er_types.h#L235
>
> > +{
> > +     int ret =3D mmap_read_lock_killable(lock_ctx->mm);
> > +
> > +     if (!ret)
> > +             lock_ctx->mmap_locked =3D true;
> > +
> > +     return ret;
> > +}
> > +
> > +static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ct=
x)
> > +{
> > +     mmap_read_unlock(lock_ctx->mm);
> > +     lock_ctx->mmap_locked =3D false;
> > +}
> > +
> >  static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       lock_ctx->locked_vma =3D NULL;
> > @@ -146,25 +162,11 @@ static void unlock_ctx_vma(struct proc_maps_locki=
ng_ctx *lock_ctx)
> >       }
> >  }
> >
> > -static const struct seq_operations proc_pid_maps_op;
> > -
> >  static inline bool lock_vma_range(struct seq_file *m,
> >                                 struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     /*
> > -      * smaps and numa_maps perform page table walk, therefore require
> > -      * mmap_lock but maps can be read with locking just the vma and
> > -      * walking the vma tree under rcu read protection.
> > -      */
> > -     if (m->op !=3D &proc_pid_maps_op) {
> > -             if (mmap_read_lock_killable(lock_ctx->mm))
> > -                     return false;
> > -
> > -             lock_ctx->mmap_locked =3D true;
> > -     } else {
> > -             rcu_read_lock();
> > -             reset_lock_ctx(lock_ctx);
> > -     }
> > +     rcu_read_lock();
> > +     reset_lock_ctx(lock_ctx);
> >
> >       return true;
> >  }
> > @@ -172,7 +174,7 @@ static inline bool lock_vma_range(struct seq_file *=
m,
> >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock=
_ctx)
> >  {
> >       if (lock_ctx->mmap_locked) {
> > -             mmap_read_unlock(lock_ctx->mm);
> > +             unlock_ctx_mm(lock_ctx);
> >       } else {
> >               unlock_ctx_vma(lock_ctx);
> >               rcu_read_unlock();
> > @@ -213,17 +215,45 @@ static inline bool fallback_to_mmap_lock(struct p=
roc_maps_private *priv,
> >       return true;
> >  }
> >
> > +static inline void drop_rcu(struct proc_maps_private *priv)
> > +{
> > +     if (priv->lock_ctx.mmap_locked)
> > +             return;
> > +
> > +     rcu_read_unlock();
> > +}
> > +
> > +static inline void reacquire_rcu(struct proc_maps_private *priv)
> > +{
> > +     if (priv->lock_ctx.mmap_locked)
> > +             return;
> > +
> > +     rcu_read_lock();
> > +     /* Reinitialize the iterator. */
> > +     vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
>
> OK good that we reset this :)
>
> > +}
> > +
> >  #else /* CONFIG_PER_VMA_LOCK */
> >
>
> We need to pull out the patches from Dave's series and remove this option=
 and
> default VMA locks on by default :)

I didn't see any followup after Dave posted his v1. I agree it would
make things much simpler but I don't want to delay these changes too
much.
I'll ask Dave if he plans to continue his cleanup. If not, I'll pick it up.


>
> > +static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > +{
> > +     return mmap_read_lock_killable(lock_ctx->mm);
> > +}
> > +
> > +static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ct=
x)
> > +{
> > +     mmap_read_unlock(lock_ctx->mm);
> > +}
> > +
> >  static inline bool lock_vma_range(struct seq_file *m,
> >                                 struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     return mmap_read_lock_killable(lock_ctx->mm) =3D=3D 0;
> > +     return lock_ctx_mm(lock_ctx) =3D=3D 0;
> >  }
> >
> >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock=
_ctx)
> >  {
> > -     mmap_read_unlock(lock_ctx->mm);
> > +     unlock_ctx_mm(lock_ctx);
> >  }
> >
> >  static struct vm_area_struct *get_next_vma(struct proc_maps_private *p=
riv,
> > @@ -238,6 +268,9 @@ static inline bool fallback_to_mmap_lock(struct pro=
c_maps_private *priv,
> >       return false;
> >  }
> >
> > +static inline void drop_rcu(struct proc_maps_private *priv) {}
> > +static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> > +
> >  #endif /* CONFIG_PER_VMA_LOCK */
> >
> >  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t =
*ppos)
> > @@ -538,12 +571,10 @@ static int query_vma_setup(struct proc_maps_locki=
ng_ctx *lock_ctx)
> >
> >  static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     if (lock_ctx->mmap_locked) {
> > -             mmap_read_unlock(lock_ctx->mm);
> > -             lock_ctx->mmap_locked =3D false;
> > -     } else {
> > +     if (lock_ctx->mmap_locked)
> > +             unlock_ctx_mm(lock_ctx);
> > +     else
> >               unlock_ctx_vma(lock_ctx);
> > -     }
> >  }
> >
> >  static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_=
locking_ctx *lock_ctx,
> > @@ -1280,21 +1311,75 @@ static const struct mm_walk_ops smaps_shmem_wal=
k_ops =3D {
> >       .walk_lock              =3D PGWALK_RDLOCK,
> >  };
> >
> > +#ifdef CONFIG_PER_VMA_LOCK
> > +
> > +static const struct mm_walk_ops smaps_walk_vma_lock_ops =3D {
> > +     .pmd_entry              =3D smaps_pte_range,
> > +     .hugetlb_entry          =3D smaps_hugetlb_range,
> > +     .walk_lock              =3D PGWALK_VMA_RDLOCK_VERIFY,
> > +};
> > +
> > +static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops =3D {
> > +     .pmd_entry              =3D smaps_pte_range,
> > +     .hugetlb_entry          =3D smaps_hugetlb_range,
> > +     .pte_hole               =3D smaps_pte_hole,
> > +     .walk_lock              =3D PGWALK_VMA_RDLOCK_VERIFY,
> > +};
> > +
> > +static inline const struct mm_walk_ops *
> > +get_smaps_walk_ops(struct proc_maps_private *priv)
> > +{
> > +     if (priv->lock_ctx.mmap_locked)
> > +             return &smaps_walk_ops;
> > +     return &smaps_walk_vma_lock_ops;
> > +}
> > +
> > +static inline const struct mm_walk_ops *
> > +get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > +{
> > +     if (priv->lock_ctx.mmap_locked)
> > +             return  &smaps_shmem_walk_ops;
> > +     return &smaps_shmem_walk_vma_lock_ops;
> > +}
> > +
> > +#else /* CONFIG_PER_VMA_LOCK */
> > +
> > +static inline const struct mm_walk_ops *
> > +get_smaps_walk_ops(struct proc_maps_private *priv)
> > +{
> > +     return &smaps_walk_ops;
> > +}
> > +
> > +static inline const struct mm_walk_ops *
> > +get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > +{
> > +     return &smaps_shmem_walk_ops;
> > +}
> > +
> > +#endif /* CONFIG_PER_VMA_LOCK */
> > +
> >  /*
> >   * Gather mem stats from @vma with the indicated beginning
> >   * address @start, and keep them in @mss.
> >   *
> >   * Use vm_start of @vma as the beginning address if @start is 0.
> >   */
> > -static void smap_gather_stats(struct vm_area_struct *vma,
> > -             struct mem_size_stats *mss, unsigned long start)
> > +static void smap_gather_stats(struct proc_maps_private *priv,
> > +                           struct vm_area_struct *vma,
> > +                           struct mem_size_stats *mss, unsigned long s=
tart)
> >  {
> > -     const struct mm_walk_ops *ops =3D &smaps_walk_ops;
> > +     const struct mm_walk_ops *ops =3D get_smaps_walk_ops(priv);
> >
> >       /* Invalid start */
> >       if (start >=3D vma->vm_end)
> >               return;
> >
> > +     if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > +             return;
> > +
> > +     /* Might sleep. Drop RCU read lock but keep the VMA locked. */
> > +     drop_rcu(priv);
> > +
> >       if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
> >               /*
> >                * For shared or readonly shmem mappings we know that all
> > @@ -1312,15 +1397,16 @@ static void smap_gather_stats(struct vm_area_st=
ruct *vma,
> >                                       !(vma->vm_flags & VM_WRITE))) {
> >                       mss->swap +=3D shmem_swapped;
> >               } else {
> > -                     ops =3D &smaps_shmem_walk_ops;
> > +                     ops =3D get_smaps_shmem_walk_ops(priv);
> >               }
> >       }
> >
> > -     /* mmap_lock is held in m_start */
> >       if (!start)
> >               walk_page_vma(vma, ops, mss);
> >       else
> >               walk_page_range(vma->vm_mm, start, vma->vm_end, ops, mss)=
;
> > +
> > +     reacquire_rcu(priv);
>
> OK I was going to say that this RCU lock dance is a bit iffy, but I see
> that we're sharing code such that this is necessary.
>
> >  }
> >
> >  #define SEQ_PUT_DEC(str, val) \
> > @@ -1369,10 +1455,11 @@ static void __show_smap(struct seq_file *m, con=
st struct mem_size_stats *mss,
> >
> >  static int show_smap(struct seq_file *m, void *v)
> >  {
> > +     struct proc_maps_private *priv =3D m->private;
> >       struct vm_area_struct *vma =3D v;
> >       struct mem_size_stats mss =3D {};
> >
> > -     smap_gather_stats(vma, &mss, 0);
> > +     smap_gather_stats(priv, vma, &mss, 0);
> >
> >       show_map_vma(m, vma);
> >
> > @@ -1413,7 +1500,7 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
> >               goto out_put_task;
> >       }
> >
> > -     ret =3D mmap_read_lock_killable(mm);
> > +     ret =3D lock_ctx_mm(&priv->lock_ctx);
> >       if (ret)
> >               goto out_put_mm;
> >
> > @@ -1425,7 +1512,7 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
> >
> >       vma_start =3D vma->vm_start;
> >       do {
> > -             smap_gather_stats(vma, &mss, 0);
> > +             smap_gather_stats(priv, vma, &mss, 0);
> >               last_vma_end =3D vma->vm_end;
> >
> >               /*
> > @@ -1434,8 +1521,8 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
> >                */
> >               if (mmap_lock_is_contended(mm)) {
> >                       vma_iter_invalidate(&vmi);
> > -                     mmap_read_unlock(mm);
> > -                     ret =3D mmap_read_lock_killable(mm);
> > +                     unlock_ctx_mm(&priv->lock_ctx);
> > +                     ret =3D lock_ctx_mm(&priv->lock_ctx);
> >                       if (ret) {
> >                               release_task_mempolicy(priv);
> >                               goto out_put_mm;
> > @@ -1484,14 +1571,14 @@ static int show_smaps_rollup(struct seq_file *m=
, void *v)
> >
> >                       /* Case 1 and 2 above */
> >                       if (vma->vm_start >=3D last_vma_end) {
> > -                             smap_gather_stats(vma, &mss, 0);
> > +                             smap_gather_stats(priv, vma, &mss, 0);
> >                               last_vma_end =3D vma->vm_end;
> >                               continue;
> >                       }
> >
> >                       /* Case 4 above */
> >                       if (vma->vm_end > last_vma_end) {
> > -                             smap_gather_stats(vma, &mss, last_vma_end=
);
> > +                             smap_gather_stats(priv, vma, &mss, last_v=
ma_end);
> >                               last_vma_end =3D vma->vm_end;
> >                       }
> >               }
> > @@ -1505,7 +1592,7 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
> >       __show_smap(m, &mss, true);
> >
> >       release_task_mempolicy(priv);
> > -     mmap_read_unlock(mm);
> > +     unlock_ctx_mm(&priv->lock_ctx);
> >
> >  out_put_mm:
> >       mmput(mm);
> > @@ -3291,6 +3378,31 @@ static const struct mm_walk_ops show_numa_ops =
=3D {
> >       .walk_lock =3D PGWALK_RDLOCK,
> >  };
> >
> > +#ifdef CONFIG_PER_VMA_LOCK
> > +static const struct mm_walk_ops show_numa_vma_lock_ops =3D {
> > +     .hugetlb_entry =3D gather_hugetlb_stats,
> > +     .pmd_entry =3D gather_pte_stats,
> > +     .walk_lock =3D PGWALK_VMA_RDLOCK_VERIFY,
> > +};
> > +
> > +static inline const struct mm_walk_ops *
> > +get_show_numa_ops(struct proc_maps_private *priv)
> > +{
> > +     if (priv->lock_ctx.mmap_locked)
> > +             return &show_numa_ops;
> > +     return &show_numa_vma_lock_ops;
> > +}
> > +
> > +#else /* CONFIG_PER_VMA_LOCK */
> > +
> > +static inline const struct mm_walk_ops *
> > +get_show_numa_ops(struct proc_maps_private *priv)
> > +{
> > +     return &show_numa_ops;
> > +}
> > +
> > +#endif /* CONFIG_PER_VMA_LOCK */
> > +
> >  /*
> >   * Display pages allocated per node and memory policy via /proc.
> >   */
> > @@ -3335,8 +3447,13 @@ static int show_numa_map(struct seq_file *m, voi=
d *v)
> >       if (is_vm_hugetlb_page(vma))
> >               seq_puts(m, " huge");
> >
> > -     /* mmap_lock is held by m_start */
> > -     walk_page_vma(vma, &show_numa_ops, md);
> > +     /* Skip walking pages if gate VMA */
> > +     if (vma !=3D get_gate_vma(proc_priv->lock_ctx.mm)) {
> > +             /* Might sleep. Drop RCU read lock but keep the VMA locke=
d. */
> > +             drop_rcu(proc_priv);
> > +             walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
> > +             reacquire_rcu(proc_priv);
> > +     }
> >
> >       if (!md->pages)
> >               goto out;
> > --
> > 2.54.0.545.g6539524ca2-goog
> >

