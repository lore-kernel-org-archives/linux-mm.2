Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B68CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904536B0088; Mon,  8 Jun 2026 12:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBB16B008A; Mon,  8 Jun 2026 12:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1B26B008C; Mon,  8 Jun 2026 12:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0816B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:20:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 385B51401D4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:20:48 +0000 (UTC)
X-FDA: 84857258976.28.8EA140F
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D7C92000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:20:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S07zW24+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780935646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZELcPlf12Yzmbyn4ebaNsKuSouoT7BC2a4NKxUUWCk=;
	b=by9rsgYRNANYo60Dlu9+B6fD+ZtUKDvpVxSTSLsTa49tolr7lJNUxKmZ/aw3+BjlPR2rhb
	PYBTGYQB5ZVsdNA6mrAdHsABWcTBBQC9uDMCJwWEE8anCIUbDR8o9MixLaZnq+B/0JzKVA
	Zv7vz4OqoOaCwnni5vh8k8qk50elbz8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S07zW24+;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780935646;
	b=Z1ZuJBdQiE5DsAkEgZtY0KW9zKvDLPCNCj8xZwm3r5rWRqSWTDyEMUSAWCh0ODNbGS5p+G
	00qkDy0arAhaywFi9wNJVYfb0y7M0rXF5XEIZ2tG33w5v4ptW4oRtSywFhzzItAiBFgX30
	x7gCz7P8phJjfAhNDU0O1YyGAA1cmBI=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5175d339e8bso1901311cf.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 09:20:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780935645; cv=none;
        d=google.com; s=arc-20240605;
        b=QrPRkrG8AKMs4s/YTFn8B+xVP4SHQA9TEsjNBO9lDiQR9eY3dtq3w3/Kp4GT+nk9HT
         4WR70ncTPpc8K5vmV9+8uTvsvXz8sJ7SRV0v8s7PYZt+b8530fpJLjpMt2zF3L78bnNE
         02ic2ZNnREc45BtbbbumeziYZaT2Zt6KOFMUy5w/M/vFhOckcTsgIurEF6Z3WP5dIB67
         XYtSgZueOdVFhRCcHlLklP0NsJ0ND2W7nDDobPIEZeaYjKIyvXQWLeKFM6BLoVGBY0V5
         8o2F1vsOeOBKwilH/7XNBENcSvWMNMxH9416LBvjzmzl0TtiDEVRt8t3p8m4dYK41ZqC
         0YQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GZELcPlf12Yzmbyn4ebaNsKuSouoT7BC2a4NKxUUWCk=;
        fh=eN6VF+e8KN3h3WUhAfgVKlXlxFqwzw+iLPpo7I3mVSI=;
        b=XKQy3m4pS1ur1M3sjtlYwCkAiQfo5X3Vl6L/ILPyBX8L8TYLb91y7T7nyY5vbt0ksD
         t0Fi8Jblqjh8MabQSIn1/k5FPFTGi+wQz4hAi9cgVlqGHuuPFlFlcBbwJnQyEGKUFRQ3
         ELXm1Dbegr1BgHowACkriGCb5+m6hBYAjMdJdqDt5QKC91pDdW58ZPXQmlySkAs4eyYY
         tal6EO/HbHG2hbt8dZCi5oD3p5zVLot9xFWmRX8jpWK8NBfcUbhsgv77lZIyug0eQvlI
         4gz7/OH+ITrRQWM2UArt2+UdJEQs/APjqaMfHfYpteKTf8XU5MIR6uDJdY2undksdOtQ
         ibjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780935645; x=1781540445; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZELcPlf12Yzmbyn4ebaNsKuSouoT7BC2a4NKxUUWCk=;
        b=S07zW24+xS+O3vVdMZVxo7Z+boGSh5LqaT/Vj0O1vPHh6716wwZuhhuCgtcEJX4F3x
         avhDtg34iQBdUte9j0oJanYWnECvBBN2wOLYDCujaAd1Vl0TG4v/t2spQOBzVK7JjLnl
         oYP6uD5VTcP+uThTqa8pQFmSv+XsaP4lpLhVV0KmOHzsud/VOxurJ5e2EAjvnp/rneMo
         X4ILX+0GQneWhJZkXePVLcFyXkfMYdfZmKsDvF3VfZB8suQhqWOLwQT163o/Lfx0pYmk
         MdsnvN0jsR2nxSWHzsdroMlmt1ngU8UN1gvEOvYMRtgSwbPwPjfXCljAulpR0nePpfU7
         b9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780935645; x=1781540445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GZELcPlf12Yzmbyn4ebaNsKuSouoT7BC2a4NKxUUWCk=;
        b=fRDaZTXMlMFdgjH54YFWcMAGfLWDHHJMPAPW6z4D+kTi5axGFq16+beYSsBpjyKjZY
         p+pPy4en0nCiMsw+DNAD1OGOny6so3+VgfwH5okbIqKRAKWh3pQn2m4+g/dkLKoAWP8w
         Q0AyjdzR2oQOApnvdomWYNRI1zm6LgObz1xFOL27tTZvtV9QzsJLN9T34aIjMvvYYuIj
         lcevQOpBi3lYeSpKJRvOWHDkb2jtpXWKc4qnoSJpjdWTwarf9D5bDeWRsqSl9qpTqHlf
         c0dM3a61GdENo/uhPja1qAh2rJSg16709yaDfCZ2L2DjGZ8EMm53qdws7XY00G0HdMjs
         5P/A==
X-Forwarded-Encrypted: i=1; AFNElJ/QFLtFd9kA71nO+he3MRU7affFOgQfiZaYxOSRwPlSTDdsassXohDL7NJv/KhT7YDBV++5wOtsQg==@kvack.org
X-Gm-Message-State: AOJu0YyMPRAzlQdcNpP3g0H4EUIV7LnaMTy2nAClSixgZlYH5UE5zPGO
	lMUioucHd51QLRMBUxNpbeZqDCDW2NPaU6MSawIrfCkyYcX1xbHohkMI2xh1tJuQTbJjYKr5oLR
	7QY6kcj5RUW6qroBbqAHd5bAAPjxXAMo0cSXTRDxF
X-Gm-Gg: Acq92OE1Ge+QmwxcNckPPlhS3wH4RyOybxyHxsP9ozzgJeGgyDtO1Y/doav3aO5za8F
	1U4rFVfi7x71dkPBL/zfxS+XtZQ3H1O075vMqghKm6njplBrJQyX50rlCTNzMdEkXQ3utjKXbx3
	ltm0167dlv4EQxvo6CGA9ZNX8dC8h02OWrE1i/ckrPBObu9Fv9hBLoIfpmhiVvRiNALNhUF3piW
	3LJWG0LCmMSyar9ZWg8xORwzmCo8nObCD03ALoeOE57LQa9hwetzpH1PZDMP71WRRTMCinPhfr6
	Y/s9FTqWHkXPPlnz
X-Received: by 2002:a05:622a:58b:b0:516:cc18:4760 with SMTP id
 d75a77b69052e-517982a0d84mr29047771cf.21.1780935644687; Mon, 08 Jun 2026
 09:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <20260606015729.1837935-2-surenb@google.com>
 <0d103616-56e5-4a31-abfc-f50f03253588@kernel.org>
In-Reply-To: <0d103616-56e5-4a31-abfc-f50f03253588@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Jun 2026 09:20:33 -0700
X-Gm-Features: AVVi8CcoFyhnB1XjOcW5rIv4uaFa6g1DxGIO-CMd7PQfm-mRDJ6e3bxepTbhj0g
Message-ID: <CAJuCfpFYG1Y_K683w0eZF3hDPZYCFkxe_YZNmt8UVmDU7_6LRw@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D7C92000C
X-Stat-Signature: yqpngzrumn85buk6gf8yhoks3cf36wt1
X-Rspam-User: 
X-HE-Tag: 1780935646-193809
X-HE-Meta: U2FsdGVkX1/XkfUchUTu/W4u+jUAHlFO1W1xT3ko2pxTnmoctCGb3xftdbxmWMeymi7Byawt9ZrFaVrbmiaHUj9sgv0WBSgC0QsuFfJLMDtNA9Pm/X8AxCPzGG/WuV1dlkIiN+KIbGrB57NyZrTT/ZNiLFfMB3zaC7D1QD/vHeZ4yrXUd4iuqfYA6l/QPtpnBNgoFloe25WpZ3S9BtQrlykyLuNAHk3QODLmc2NV0ilAVmbNtJesbDlRB06LNl9oWX3g+w1yUqibwEF+tiF/0BUtiYnru3ucOOONwc5HSq7HurV1OvFN6sl14ZdnnCDVzX/ZvZoMoTmykOjohYNhjDsFtWpwAKtWaAIrC66w5S45L1bTvQg4JkfFIWdmhurb59b02PAuaSCqHXLb2TjFiGgEsdFf5soQhXETHJsPaI9JQsAyHmibcJKYczQ/dgYsOiYKzOvaW3rI+IHWJW6Ysu3fPH/NcpCQOONuRsOB0eBD4kThwTgQY/2iEUPqQLLMV+I2GbXmgWUMvQACn99A2AOIrH8h+NzRLQ8AJWNBknBkbl7BKA6Y8mFEN17i2qyvHFB4WYawOgmO8buRUZm2VVezBfDb8Qid/yVue7c5Tw6J/BVZI1t0AerZLsfH9EnWDOXKHKl75I8TZZHCmH5npj6WhlL6S5NjffbA/FiFbkQcNiCXXQMKUIVOLEk40R3qwCdvrwvLZTwHU035NhKDVmtqy0UtF+fu7MlB5eWvuRJubWBBpBDyQ6TpdPywjyFjyupXOhmLLQJeQXSyQFnFhPgx0vJ3axXc1UzOz/FRyYFeybaE7YQJkajMqbQVOJAcgXrhJD7ZDFdBh99DPQ/F4fU/xVX0x9+YR/ZpNq6fmflzoOGb4wrQkUmiNjQ5SIMmNH7k0gqiHniNbYpJw2HDJ8ReX2PM24+ZBPzdxbHsvg7JZvKT9UmfaFOegxIUdNCmluTgttrHKqbGhYAP+QF
 IHavX0H+
 J4T2gNyfHxUMhRu1cNx8JyZPvfg35nvpHSkSjGsA/zU8ACjabVubxSXfxEkZYmV5pQMpo34xlEt1ZPobOnPrIF7ogbXywPNeIo3g/vY9kmQBpxHvnOKHj9+hprOslKAYvj7g7u3PP1w2GzYop7WWnQ0Ro8vcnU8UkqoGEydmGTkmz0d84aLWehnVRsz4Tm77UYkcAhCoWXHMpcxg3Nt5Xnz2rguDhB7r8dDuCjA4RBQDAO9BWvwptW5NC0/KKj2Dm4E08ZXm52nTQgzvGw7G30nNM8pTYm1LKMzjzsBDUWCmd2HkftMYw2hsGaEYL1UT2p23xp0901h+hqfQvzA0uQd7fcBOnPbnxAmwDdD/vfuDelTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 8:52=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 6/6/26 03:57, Suren Baghdasaryan wrote:
> > proc/pid/smaps_rollup can be read using the combination of RCU and
> > VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> > required to safely traverse the VMA tree and VMA lock stabilizes the
> > VMA being processed and the pagetable walk.
> > Note that we have to keep the logic to drop mmap_lock on contention
> > because even when using per-VMA locks we might have to fall back to
> > holding the mmap_lock.
> >
> > Running Paul's contention benchmark [1] shows considerable improvement
> > both in median and in the worst case latencies:
> >
> > Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
> > --busyduration 2 --procfile smaps_rollup
> >
> > Baseline:
> >
> >     0.174     0.161     2.553
> >     0.174     0.164     2.663
> >     0.174     0.165     2.664
> >     0.174     0.166     2.679
> >     0.174     0.167     2.691
> >     0.174     0.168     2.704
> >     0.174     0.169     2.729
> >     0.174     0.172     2.741
> >     0.174     0.174     2.745
> >     0.174     0.174     2.755
> >     0.174     0.175     2.790
> >     0.174     0.177     2.809
> >     0.174     0.179     3.096
> >     0.174     0.183     3.144
> >     0.174     0.184     3.158
> >     0.174     0.185     3.175
> >     0.174     0.185     4.568
> >     0.174     0.198     4.821
> >     0.174     0.214     5.143
> >     0.174     0.251     5.220
> >
> > Patched:
> >
> >     0.007     0.007     1.952
> >     0.007     0.007     1.955
> >     0.007     0.007     1.955
> >     0.007     0.007     1.955
> >     0.007     0.007     1.957
> >     0.007     0.007     1.969
> >     0.007     0.007     2.065
> >     0.007     0.007     2.075
> >     0.007     0.007     2.146
> >     0.007     0.007     2.195
> >     0.007     0.007     2.223
> >     0.007     0.007     2.259
> >     0.007     0.007     2.488
> >     0.007     0.007     2.562
> >     0.007     0.007     2.599
> >     0.007     0.007     2.697
> >     0.007     0.007     3.030
> >     0.007     0.007     3.075
> >     0.007     0.007     3.145
> >     0.007     0.007     3.225
> >
> > [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 134 ++++++++++++++++++++-------------------------
> >  1 file changed, 59 insertions(+), 75 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 023422fcee12..c2bd9f5bbbcd 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -233,6 +233,16 @@ static inline void reacquire_rcu(struct proc_maps_=
private *priv)
> >       vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
> >  }
> >
> > +static inline bool is_mmap_lock_contended(struct proc_maps_private *pr=
iv)
>
> is_mmap_lock_contended() vs. mmap_lock_is_contended() ... really nasty.

Agree. Once Dave Hansen's cleanup patchset is posted we will be able
to remove most of this nastiness. Maybe I should wait for it before
posting this patch.


>
> > +{
> > +     struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> > +
> > +     if (!lock_ctx->mmap_locked)
> > +             return false;
> > +
> > +     return !!mmap_lock_is_contended(lock_ctx->mm);
>
> !! is not required anymore, the compiler nowadays knows how to handle boo=
leans
> correctly.

Ack.

>
> > +}
> > +
> >  #else /* CONFIG_PER_VMA_LOCK */
> >
> >  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > @@ -268,6 +278,11 @@ static inline bool fallback_to_mmap_lock(struct pr=
oc_maps_private *priv,
> >       return false;
> >  }
> >
> > +static inline bool is_mmap_lock_contended(struct proc_maps_private *pr=
iv)
> > +{
> > +     return !!mmap_lock_is_contended(priv->lock_ctx.mm);
> > +}
> > +
> >  static inline void drop_rcu(struct proc_maps_private *priv) {}
> >  static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> >
> > @@ -1486,12 +1501,15 @@ static int show_smap(struct seq_file *m, void *=
v)
> >  static int show_smaps_rollup(struct seq_file *m, void *v)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> > +     struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> > +     struct mm_struct *mm =3D lock_ctx->mm;
> >       struct mem_size_stats mss =3D {};
> > -     struct mm_struct *mm =3D priv->lock_ctx.mm;
> >       struct vm_area_struct *vma;
> > -     unsigned long vma_start =3D 0, last_vma_end =3D 0;
> > +     unsigned long vma_start =3D 0;
> > +     unsigned long last_vma_end =3D 0;
> > +     loff_t pos =3D 0;
> >       int ret =3D 0;
> > -     VMA_ITERATOR(vmi, mm, 0);
> > +
> >
>
> Is there now a double-empty line? (it's getting late here)

Oops. Right. Will fix.

>
> >       priv->task =3D get_proc_task(priv->inode);
> >       if (!priv->task)
> > @@ -1502,89 +1520,55 @@ static int show_smaps_rollup(struct seq_file *m=
, void *v)
> >               goto out_put_task;
> >       }
> >
> > -     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > +     hold_task_mempolicy(priv);
> > +     ret =3D lock_vma_range(m, lock_ctx);
> >       if (ret)
> >               goto out_put_mm;
> >
> > -     hold_task_mempolicy(priv);
> > -     vma =3D vma_next(&vmi);
> > -
> > -     if (unlikely(!vma))
> > +     vma_iter_init(&priv->iter, mm, 0);
> > +     vma =3D proc_get_vma(m, &pos);
> > +     if (unlikely(!vma) || vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> >               goto empty_set;
> >
> > +     if (IS_ERR(vma)) {
> > +             ret =3D PTR_ERR(vma);
> > +             goto out_unlock;
> > +     }
> > +
> >       vma_start =3D vma->vm_start;
> > -     do {
> > -             smap_gather_stats(priv, vma, &mss, 0);
> > +     while (vma) {
> > +             if (IS_ERR(vma)) {
> > +                     ret =3D PTR_ERR(vma);
> > +                     goto out_unlock;
> > +             }
> > +
> > +             if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> > +                     break;
> > +
>
> Can you refresh my brain why we now have to check for gate VMAs explicitl=
y?

smap_gather_stats() skips the gate VMA anyway and after the gate we
will be terminating the loop. So, once we see the gate VMA we can exit
the loop. I could teach proc_get_vma() to handle the gate VMA but this
early termination seemed simpler.

>
> > +             /*
> > +              * If after retaking mmap_lock, already reported VMA grew=
 or
> > +              * merged with the next one, then iterate from last_vma_e=
nd.
> > +              */
> > +             smap_gather_stats(priv, vma, &mss,
> > +                               vma->vm_start < last_vma_end ? last_vma=
_end : 0);
> >               last_vma_end =3D vma->vm_end;
> >
> >               /*
> >                * Release mmap_lock temporarily if someone wants to
> > -              * access it for write request.
> > +              * take it for write request.
> >                */
> > -             if (mmap_lock_is_contended(mm)) {
> > -                     vma_iter_invalidate(&vmi);
> > -                     unlock_ctx_mm(&priv->lock_ctx);
> > -                     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > -                     if (ret) {
> > -                             release_task_mempolicy(priv);
> > +             if (is_mmap_lock_contended(priv)) {
> > +                     unlock_vma_range(&priv->lock_ctx);
> > +                     ret =3D lock_vma_range(m, lock_ctx);
> > +                     if (ret)
> >                               goto out_put_mm;
> > -                     }
> > -
> > -                     /*
> > -                      * After dropping the lock, there are four cases =
to
> > -                      * consider. See the following example for explan=
ation.
> > -                      *
> > -                      *   +------+------+-----------+
> > -                      *   | VMA1 | VMA2 | VMA3      |
> > -                      *   +------+------+-----------+
> > -                      *   |      |      |           |
> > -                      *  4k     8k     16k         400k
> > -                      *
> > -                      * Suppose we drop the lock after reading VMA2 du=
e to
> > -                      * contention, then we get:
> > -                      *
> > -                      *      last_vma_end =3D 16k
> > -                      *
> > -                      * 1) VMA2 is freed, but VMA3 exists:
> > -                      *
> > -                      *    vma_next(vmi) will return VMA3.
> > -                      *    In this case, just continue from VMA3.
> > -                      *
> > -                      * 2) VMA2 still exists:
> > -                      *
> > -                      *    vma_next(vmi) will return VMA3.
> > -                      *    In this case, just continue from VMA3.
> > -                      *
> > -                      * 3) No more VMAs can be found:
> > -                      *
> > -                      *    vma_next(vmi) will return NULL.
> > -                      *    No more things to do, just break.
> > -                      *
> > -                      * 4) (last_vma_end - 1) is the middle of a vma (=
VMA'):
> > -                      *
> > -                      *    vma_next(vmi) will return VMA' whose range
> > -                      *    contains last_vma_end.
> > -                      *    Iterate VMA' from last_vma_end.
> > -                      */
> > -                     vma =3D vma_next(&vmi);
> > -                     /* Case 3 above */
> > -                     if (!vma)
> > -                             break;
> > -
> > -                     /* Case 1 and 2 above */
> > -                     if (vma->vm_start >=3D last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, 0);
> > -                             last_vma_end =3D vma->vm_end;
> > -                             continue;
> > -                     }
> >
> > -                     /* Case 4 above */
> > -                     if (vma->vm_end > last_vma_end) {
> > -                             smap_gather_stats(priv, vma, &mss, last_v=
ma_end);
> > -                             last_vma_end =3D vma->vm_end;
> > -                     }
>
> That's quite the simplification.

True, that's why I decided to remove this comment. I handle this Case
4 in the new code and Cases 1-3 are handled naturally, nothing special
about them.

>
> > +                     /* Resume from the last position. */
> > +                     pos =3D last_vma_end;
> > +                     vma_iter_init(&priv->iter, mm, pos);
>
> I'll leave checking the VMA locking details to VMA locking experts :)

This is the same pattern we now use for reading maps/smaps/numa_maps.
lock_vma_range() takes rcu_read_lock and proc_get_vma() locks the VMA
under that RCU.

Thanks for the feedback!

>
> --
> Cheers,
>
> David

