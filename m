Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70738CD8C89
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 02:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A526B0005; Fri,  5 Jun 2026 22:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2546B008A; Fri,  5 Jun 2026 22:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7A96B008C; Fri,  5 Jun 2026 22:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACA606B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 22:00:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B20BC18E9
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 02:00:53 +0000 (UTC)
X-FDA: 84847834386.27.8B2008A
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6381840007
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 02:00:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sJNEUrab;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780711251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3uN84pHMHR/C2UzmkBURXkAlMHc0n4HuIo+YW7P8R0=;
	b=RrVE6kO0DjsPt1Ta+HlRA8fTXSiwhXZE3+64yDapbVXZ4CC63qbs3kXICi25KOBziMhgZi
	UKv+RVvicOdtFe1GdtM+Wc7LWoy0ySWmu45Tr7XkAN3XWbOMwpqjJns2+RHA2vfWoXKVoC
	2/c6eVpPb28euoTwep01xQRL/KnIW+E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780711251;
	b=g5Jo1RmJdgNPv9jGozkVMV2K9LuaZ/bv8l3rzEGd40dQx6bVzg11vqhU5GoDv/cpoUmfj7
	ZApY/tJcyi4lj38HkNduQulQFxqtSPV4rhPXnGN5wVqo2WqlJFkKoLnhfP0g0UQvYkW6w2
	dBF/L/IonxUT/t3c4Q4ileI+FGujY04=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sJNEUrab;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5175d339e8bso956671cf.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 19:00:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780711250; cv=none;
        d=google.com; s=arc-20240605;
        b=W9I8CwjcY3c5U4AoQHHHh4+MoeTbV73LQqtrA7sCAflUjGHiwxZL3q/D/mFKarXCul
         fLxskIOZldM8OoC51KEPO4MKxTObw5hRhasE9OwpIzp2r5QQKxu3+fg17cfCqF7FFzdL
         s1F+7qvEbXqjj4YVg5YNIILtMqCXk94HCEf7nN/Z9c1iwSpVoYbGfxBHbVtukLqiZMEi
         4iS7wUG5diMdBUBaH5ggWOc+8bEXAPLNkhscBJ7iXogDlNZxg7CNSUOKXIHhbZah2D7X
         X+RrC5TlwoRRsGAG3JytsEIgxcf4Hm77WiFkyUlcnFJXDOHrwYti6Z0mLBqxEuJpTBGU
         hikA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W3uN84pHMHR/C2UzmkBURXkAlMHc0n4HuIo+YW7P8R0=;
        fh=3UGq/SsJWapbOAYZOAFqm03fqIgKpzibJRfFBz9RgBc=;
        b=eZvhf8DZ3HJMq9+bU0DN6py1aHqlJiy3sWUeEmMm/b+CiI+e6Ynj6ic8X/QYub0OyH
         +DOXT8Uq8n6gTrW0HSw1TnBoZpSHQvTM2p+Kwp6KWxzxMyq+lMxxumA3qj3ALc5AvpzE
         u0L4UG5QoyZExxlAEjN/9VQDAYJU47bSTdyfGIKSIS9U+nXBh1q9lVbYJ/zdJNpwkEML
         UAfvr7DwLxEL/JiWiKkr8J4EGNjMuGM2+qxXh2GRO6OgrT+dSI8QsBvcbdzd6F1UqqRx
         xkX+fzwmxSjAnBhEy3I52bIyYYbdku4msr1Wy5BkUU0/jCRfHSZm6CxWjFHs8teGbBN0
         Ub/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780711250; x=1781316050; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3uN84pHMHR/C2UzmkBURXkAlMHc0n4HuIo+YW7P8R0=;
        b=sJNEUrabdZju5PW3JZZaUvxldBqBx/C3yOIDFVDuJXSBC4OSICAEYhZRbnbBxFal7R
         7g+TcI5v95FrcFLfE3EYplLRvP9GBZQptLCjVfnC7NB5/2eKHYyx5jgdZu43AXK6v4bu
         AysrQmBQqeSFNqmHIYwCYjnGj4GJ4waEGjHALBPMQsFBB7fCurenM0mXj2ICFko2a1Rx
         EG6OA3zb9OoUePpJqdXe0v1YNJW5OJOPv+fXL4FuKCjyvF2HYK2WtGWPqptnaJIh3YT6
         m2xuLkDSf5Qf5EMRFPbHcjagD8rBR9qBRtcz5SUkHgecZtn1wLog0ClVksP72q3evhS7
         hOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780711250; x=1781316050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W3uN84pHMHR/C2UzmkBURXkAlMHc0n4HuIo+YW7P8R0=;
        b=daAYwvHhHFEkHq4rUrksjCseLFaEGTkuETG3rmU67x7dZNOinCqMcdk/GPoK5Dap2d
         tQoRda683JXmWEEaK2hxSp4QVMSnQS6OdDXHDT8F9znmNjrtSmGJsAywKFbfmlU1+YKJ
         LIsdprV54nf+/R5c89Ykkzdfa6oXI7bkJRqIIFXfCHO56kjithFDgOpo16z07s54nhh1
         iNGpugk1B2OCsyEvenPz8Xf53c53Ig1SWZ6fdqw3cS+Nj6rSQDdVTGQT3a1d19Q/KKbE
         YaqeuIxQhooj6iQvOoYWlAoeZ3+98IernpEcXQbwgJ1NXwOi4F6ODomKMJ4SkZvwAAGM
         gPUw==
X-Forwarded-Encrypted: i=1; AFNElJ9IDODzkhOfg8VZ9tAJBBaFpfpy/CXk9wGv6SnQsfSgLbrPH55zMcb8e7PcMWxyYF/zxG3EqUIinQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3BS9uc/TEyQtCy2tDiQbgNEOviiPjr3oZdZS0yDnWnyw19g3n
	7mWFEW2mKh6RTFs4mNhC/XJD2xCCjNuviUVfnFC1mg5BP0XXrSvHUg7vesTAS3TghgDJZIgLugf
	6bSW3+b29KygXrHlol7TtmelMDb8ueI0NROrcZR2S
X-Gm-Gg: Acq92OGFWJ7twCfi+FHgFq1cqlGsmsfHfLn+MED46mfyLL/4bWwOt2vZkgu4ThHu2pR
	M94Y5jAFh9B6d/8Pej7Ueav4i89vfjY6TSKEFkvU/UH/8gQwCJ+7PfH4g2iEOvPACntgieZ7oGG
	+GbQI5ONS2Fw2djXsYE8mNV5+glvqe4mhTTqT5x8NSqjjr7wsLpQQbrTBHok9Z+Qr84eOwceSMd
	k/0lm87k5U+mQaxs03DX7w+Bjc9AaR/R6shvDOtiV1GkRXMnIrdBDGr2+l5iqaN6n6st+8eiGOa
	pU/XVx5A+xlkD5UITBZRbvhM4g2dnIzjo+U+5ofkniGHFVC6
X-Received: by 2002:ac8:7417:0:b0:517:99ea:ab80 with SMTP id
 d75a77b69052e-51799eabf02mr8967011cf.26.1780711249743; Fri, 05 Jun 2026
 19:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <20260606015729.1837935-2-surenb@google.com>
In-Reply-To: <20260606015729.1837935-2-surenb@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 5 Jun 2026 19:00:38 -0700
X-Gm-Features: AVVi8CeX40G7QLU5oGSI4qQlj7diB0CQ5YrZ_KNxk7OTfs_4cG4fys0JJTzkVwg
Message-ID: <CAJuCfpGMAe_1ne7cWAoug=zyh+H6CQbcwzaSK_tEnMoN8xnnrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6381840007
X-Stat-Signature: p4k8gnzdbb9pzitmsge6r34str5fqfyf
X-HE-Tag: 1780711251-253396
X-HE-Meta: U2FsdGVkX1/iGW+Z59KX+0VrJ7E04ZlJvu4KiQyYJG+2Ek2ttnKpUVHE2rWArLBK5r1zE9YVMX6tOQeCY9+PUOZ4grflbcTuR2E9/nL1dtb6oPE070I8fI3u5Bt/5R8PJxoZzb0TMkdTFcqbJz4GD0ZAWhRc5UOQHT+eFOamYKlR2cMc1VipYY9e7JD5a4weRR361GuegNgAlc/9ZccNC4yV3TkZxu0HhuyUKyO1M8uELtn2N5pT+l/6aFaqh0vHCuG5jHa28DCWg/Hrmy4HMLSqOyemTB6DHVKvrA0+N9IN09gnbu4UWuGZx+lzAFeURXgrgdtCyciBkRqIbkEYmmylrVvEQBUqY6QkJpFmkUFUaLGYufeaGqEbmtxXf9C0mHVl3B/McvFCvnLxIiR+BWCsYifGOZm+JWgQUf5RUuUu93INw0eslKg+sv+oimveaLG4um+LDDuiGCEvKAAI/MejdTcHZESCqtWg41+R3WviP0XhTel9yRhXtxazO/WC0K6D9NdyJCiL2p/+yVsQsj/lnp8RlGFDP14JLjAQPnJKR7nVVCUSqrKlHKixR79UNbXR0wxs9PB6joGWuBuHzOcJ/tt8i4OhBgEg7uDabFTG1iL4lthhIBFbElA0ySZeCc+Z3Qv9ICgAuEnGZFScbSJyV9kzIVPcDc96AVsAihNd7vo88fIiY1WPnvbRrI8ccTUOb1XSvM5defXnYhaNHdoUxJp3n8UabYT4WE4t8HSAAI83WjDuUCHNr4Q/6AKNoOnWtaeBzbJYCVtiO3aZk/ZasIjhVTN2cMApXUUlxtCcNIfTQ3NTQo+kth4jhERHTkwF9CCZba2MuFugXt3Lr2vPw8r9wVr0bCBUrR55xvae1vO5qWEs7DW+aGVcSmFTzm2tPrfF1PjGo6pro/lbfkSELSwwS7e+Q/q7cY5Xo8kZwsxlodfLgeT/l+iyYY13F5t0f8KwKV3CN6/v+Me
 fDCd3z86
 rbjtT9IYDanHBJq3MRe499xrMWvs2RfFrEpSWDVgDyd6zXpURZWXLIpEg+O1ZY5qd4TgMYJ+moPso5Y9NVtfzNc3zhOXT396qawtkOKEnWufg8e+bewoMebULYn90a5jQDdFjlvivYuM+B5ovYre+iTmeNpieKwgUwQslo1hLlX0iQYYeone9+Z3aGj+UMO/9pFCBPvdC1enzmRzzCSYefrByDQtj4GUE41EXINtOw+JngDaGxW2ApXRxcX0Ls4Z+jd1TxKwTQNsZN8uDJlr9hiXMBiNGp3VCF2O7W3VXrc056qTdcSktU4/BdhGVUyucjxd+EWGfIm+m4Jo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 5, 2026 at 6:57=E2=80=AFPM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> proc/pid/smaps_rollup can be read using the combination of RCU and
> VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> required to safely traverse the VMA tree and VMA lock stabilizes the
> VMA being processed and the pagetable walk.
> Note that we have to keep the logic to drop mmap_lock on contention
> because even when using per-VMA locks we might have to fall back to
> holding the mmap_lock.
>
> Running Paul's contention benchmark [1] shows considerable improvement
> both in median and in the worst case latencies:
>
> Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
> --busyduration 2 --procfile smaps_rollup
>
> Baseline:

Forgot to add the names for the columns:

#  Median   Minimum   Maximum

>     0.174     0.161     2.553
>     0.174     0.164     2.663
>     0.174     0.165     2.664
>     0.174     0.166     2.679
>     0.174     0.167     2.691
>     0.174     0.168     2.704
>     0.174     0.169     2.729
>     0.174     0.172     2.741
>     0.174     0.174     2.745
>     0.174     0.174     2.755
>     0.174     0.175     2.790
>     0.174     0.177     2.809
>     0.174     0.179     3.096
>     0.174     0.183     3.144
>     0.174     0.184     3.158
>     0.174     0.185     3.175
>     0.174     0.185     4.568
>     0.174     0.198     4.821
>     0.174     0.214     5.143
>     0.174     0.251     5.220
>
> Patched:
>
>     0.007     0.007     1.952
>     0.007     0.007     1.955
>     0.007     0.007     1.955
>     0.007     0.007     1.955
>     0.007     0.007     1.957
>     0.007     0.007     1.969
>     0.007     0.007     2.065
>     0.007     0.007     2.075
>     0.007     0.007     2.146
>     0.007     0.007     2.195
>     0.007     0.007     2.223
>     0.007     0.007     2.259
>     0.007     0.007     2.488
>     0.007     0.007     2.562
>     0.007     0.007     2.599
>     0.007     0.007     2.697
>     0.007     0.007     3.030
>     0.007     0.007     3.075
>     0.007     0.007     3.145
>     0.007     0.007     3.225
>
> [1] https://github.com/paulmckrcu/proc-mmap_sem-test
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 134 ++++++++++++++++++++-------------------------
>  1 file changed, 59 insertions(+), 75 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 023422fcee12..c2bd9f5bbbcd 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -233,6 +233,16 @@ static inline void reacquire_rcu(struct proc_maps_pr=
ivate *priv)
>         vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
>  }
>
> +static inline bool is_mmap_lock_contended(struct proc_maps_private *priv=
)
> +{
> +       struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> +
> +       if (!lock_ctx->mmap_locked)
> +               return false;
> +
> +       return !!mmap_lock_is_contended(lock_ctx->mm);
> +}
> +
>  #else /* CONFIG_PER_VMA_LOCK */
>
>  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> @@ -268,6 +278,11 @@ static inline bool fallback_to_mmap_lock(struct proc=
_maps_private *priv,
>         return false;
>  }
>
> +static inline bool is_mmap_lock_contended(struct proc_maps_private *priv=
)
> +{
> +       return !!mmap_lock_is_contended(priv->lock_ctx.mm);
> +}
> +
>  static inline void drop_rcu(struct proc_maps_private *priv) {}
>  static inline void reacquire_rcu(struct proc_maps_private *priv) {}
>
> @@ -1486,12 +1501,15 @@ static int show_smap(struct seq_file *m, void *v)
>  static int show_smaps_rollup(struct seq_file *m, void *v)
>  {
>         struct proc_maps_private *priv =3D m->private;
> +       struct proc_maps_locking_ctx *lock_ctx =3D &priv->lock_ctx;
> +       struct mm_struct *mm =3D lock_ctx->mm;
>         struct mem_size_stats mss =3D {};
> -       struct mm_struct *mm =3D priv->lock_ctx.mm;
>         struct vm_area_struct *vma;
> -       unsigned long vma_start =3D 0, last_vma_end =3D 0;
> +       unsigned long vma_start =3D 0;
> +       unsigned long last_vma_end =3D 0;
> +       loff_t pos =3D 0;
>         int ret =3D 0;
> -       VMA_ITERATOR(vmi, mm, 0);
> +
>
>         priv->task =3D get_proc_task(priv->inode);
>         if (!priv->task)
> @@ -1502,89 +1520,55 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
>                 goto out_put_task;
>         }
>
> -       ret =3D lock_ctx_mm(&priv->lock_ctx);
> +       hold_task_mempolicy(priv);
> +       ret =3D lock_vma_range(m, lock_ctx);
>         if (ret)
>                 goto out_put_mm;
>
> -       hold_task_mempolicy(priv);
> -       vma =3D vma_next(&vmi);
> -
> -       if (unlikely(!vma))
> +       vma_iter_init(&priv->iter, mm, 0);
> +       vma =3D proc_get_vma(m, &pos);
> +       if (unlikely(!vma) || vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
>                 goto empty_set;
>
> +       if (IS_ERR(vma)) {
> +               ret =3D PTR_ERR(vma);
> +               goto out_unlock;
> +       }
> +
>         vma_start =3D vma->vm_start;
> -       do {
> -               smap_gather_stats(priv, vma, &mss, 0);
> +       while (vma) {
> +               if (IS_ERR(vma)) {
> +                       ret =3D PTR_ERR(vma);
> +                       goto out_unlock;
> +               }
> +
> +               if (vma =3D=3D get_gate_vma(priv->lock_ctx.mm))
> +                       break;
> +
> +               /*
> +                * If after retaking mmap_lock, already reported VMA grew=
 or
> +                * merged with the next one, then iterate from last_vma_e=
nd.
> +                */
> +               smap_gather_stats(priv, vma, &mss,
> +                                 vma->vm_start < last_vma_end ? last_vma=
_end : 0);
>                 last_vma_end =3D vma->vm_end;
>
>                 /*
>                  * Release mmap_lock temporarily if someone wants to
> -                * access it for write request.
> +                * take it for write request.
>                  */
> -               if (mmap_lock_is_contended(mm)) {
> -                       vma_iter_invalidate(&vmi);
> -                       unlock_ctx_mm(&priv->lock_ctx);
> -                       ret =3D lock_ctx_mm(&priv->lock_ctx);
> -                       if (ret) {
> -                               release_task_mempolicy(priv);
> +               if (is_mmap_lock_contended(priv)) {
> +                       unlock_vma_range(&priv->lock_ctx);
> +                       ret =3D lock_vma_range(m, lock_ctx);
> +                       if (ret)
>                                 goto out_put_mm;
> -                       }
> -
> -                       /*
> -                        * After dropping the lock, there are four cases =
to
> -                        * consider. See the following example for explan=
ation.
> -                        *
> -                        *   +------+------+-----------+
> -                        *   | VMA1 | VMA2 | VMA3      |
> -                        *   +------+------+-----------+
> -                        *   |      |      |           |
> -                        *  4k     8k     16k         400k
> -                        *
> -                        * Suppose we drop the lock after reading VMA2 du=
e to
> -                        * contention, then we get:
> -                        *
> -                        *      last_vma_end =3D 16k
> -                        *
> -                        * 1) VMA2 is freed, but VMA3 exists:
> -                        *
> -                        *    vma_next(vmi) will return VMA3.
> -                        *    In this case, just continue from VMA3.
> -                        *
> -                        * 2) VMA2 still exists:
> -                        *
> -                        *    vma_next(vmi) will return VMA3.
> -                        *    In this case, just continue from VMA3.
> -                        *
> -                        * 3) No more VMAs can be found:
> -                        *
> -                        *    vma_next(vmi) will return NULL.
> -                        *    No more things to do, just break.
> -                        *
> -                        * 4) (last_vma_end - 1) is the middle of a vma (=
VMA'):
> -                        *
> -                        *    vma_next(vmi) will return VMA' whose range
> -                        *    contains last_vma_end.
> -                        *    Iterate VMA' from last_vma_end.
> -                        */
> -                       vma =3D vma_next(&vmi);
> -                       /* Case 3 above */
> -                       if (!vma)
> -                               break;
> -
> -                       /* Case 1 and 2 above */
> -                       if (vma->vm_start >=3D last_vma_end) {
> -                               smap_gather_stats(priv, vma, &mss, 0);
> -                               last_vma_end =3D vma->vm_end;
> -                               continue;
> -                       }
>
> -                       /* Case 4 above */
> -                       if (vma->vm_end > last_vma_end) {
> -                               smap_gather_stats(priv, vma, &mss, last_v=
ma_end);
> -                               last_vma_end =3D vma->vm_end;
> -                       }
> +                       /* Resume from the last position. */
> +                       pos =3D last_vma_end;
> +                       vma_iter_init(&priv->iter, mm, pos);
>                 }
> -       } for_each_vma(vmi, vma);
> +               vma =3D proc_get_vma(m, &pos);
> +       }
>
>  empty_set:
>         show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
> @@ -1593,10 +1577,10 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
>
>         __show_smap(m, &mss, true);
>
> -       release_task_mempolicy(priv);
> -       unlock_ctx_mm(&priv->lock_ctx);
> -
> +out_unlock:
> +       unlock_vma_range(&priv->lock_ctx);
>  out_put_mm:
> +       release_task_mempolicy(priv);
>         mmput(mm);
>  out_put_task:
>         put_task_struct(priv->task);
> --
> 2.54.0.1032.g2f8565e1d1-goog
>

