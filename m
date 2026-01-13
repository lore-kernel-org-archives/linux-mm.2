Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA70AD2D0EA
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE306B008A; Tue, 13 Jan 2026 07:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15CB96B008C; Tue, 13 Jan 2026 07:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0316F6B0092; Tue, 13 Jan 2026 07:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E16786B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:46:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADCDBB2E40
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:46:47 +0000 (UTC)
X-FDA: 84326914854.28.E7B2E75
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id D3B341C0006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:46:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ky0rmUo6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768308405; a=rsa-sha256;
	cv=none;
	b=foPZKLhXHxbA5nl4SwapXr8hh9/mubdBkTyW8AgZZkfGxxfryQKm5VdgmV3Zr7T3dcpBo9
	x1bfdFo/Sk+PSBVkbkp9CUmGl927XBH0WW0q+4mMG/v9xEBiRG64BjDj+Wme+9LyUcut0g
	/+m8AZqicMJYOee2oyyb9akbg1nmxmI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ky0rmUo6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768308405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eHj6eu8QUIhQT3379yD0LS4ETiuNh0tW9nXgScZlK4=;
	b=5ib8D89uJCks9frqEOlciaHCQr095p5mRh8By0M50W26ClNk3jk6Oo9pq91QlvJi1wWc4U
	33pbJoHLGLHPMm94Y4b+z3Cn6EWXVOHe+Y2R4X1C0L7FhvvEGKvP1go5uEKUZ2axlx0hwB
	Tg2VvQexMwn3QQeaWlrqsoOybJnSj0w=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-79088484065so75092047b3.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768308405; x=1768913205; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+eHj6eu8QUIhQT3379yD0LS4ETiuNh0tW9nXgScZlK4=;
        b=ky0rmUo65ZhMO93b/I2I3JSm8F1BG5aDxmxmbdSLKL+PjdG4gbUkoYuFUbjU+rfLQZ
         3TyczRnaft/RUrTsR/j6xDgoYlJt/Hu7WgoHgJuTT18eAXjwk3rammhniavZ9ZlOUfl5
         xNYFlBJv8rRFT62Z7CaVrBJ0LF1S46SVzYS+BUZMEFXBKOrdSED5nUs9qbRb3XzJKWcG
         ZrWDm66sMWiQwOCEvXsNUCegv+rFY9FHOWUKjpKkhVzcS6hNgP1BKjkKgomVLeQTZhds
         hYJbDp4vyHY0aHPyHs4gxYOWYG5FLzh694EKz9Fg2R7s+QC/tuo5osmbIwVrCaXP52jO
         BmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768308405; x=1768913205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+eHj6eu8QUIhQT3379yD0LS4ETiuNh0tW9nXgScZlK4=;
        b=kz+P1NVkrEOrKtfdwFxe+frJlxHqbpxJkaQyF07/feFJ4mhEIbAEfxv82N95twof42
         v4lEUaKCJhW4H1xYbNUatJBMjKSXZu+hSJ2D7OrlCKDzb/2v+YGqvatszSjYCbdweH12
         vNArkrpdchR0vUFW2caoqWd59XaFeyCtDNcrwGe9ssHvG2sLgAJksE2YUVT+vanKqxaE
         M7PNent4bxLlkY2kZl4xsy74XXyht1v+ovv3/L7qVn6hy0NzY64RaJL5rcVUm4UR7PP3
         OHGlFmBzFjvxIUIj3ctUxyLaujdD1kYDZ0V2kK77XocjViSrSTwW3Ssi2FGYqEUEqCUb
         Pb9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTmwZethwuZwpr7trSDI0EQfuro9lRYB7NrSXrfxaxcrKdxnhZbg5HcsYti0JIztZCJam7JsKyZA==@kvack.org
X-Gm-Message-State: AOJu0Yw4tjFn8bOdYIG1oDxqD/slTEYW4Ua9cUw1qposdpjXsmgGP6yy
	Tma4Lp0bM8zVwmKgBmiTOIzzkEavx9u/yAW36ffy4boyQL9+CUZ4JaqaN2jKvrJfQvBNiP5485Y
	/ddPbJAF9f024aCG/frRJ4ilrJo8W13A=
X-Gm-Gg: AY/fxX4fPY8wDK6wdo2P18aScTAqDotbXaMT740OpR2imqhmEP75UrGqKeqjVF2EMYc
	WgLgPMjHQ5vBpIwU8kla0zgHaiq9cHdJ0GkXAT4/fNMNZeMtqZ5IBwbQXR1BuzgMayvMkWMqBOY
	BKBXyfcT2caU8DJ0z2v1I74dEgAw0P5408zBINGatW13oWDP176+mJ+i1kIugOrlRePzts2BUcb
	qtz2j987a7xe8uIFrfmaiFY7NzNBME0CM3b7EMWNrXcr5SuqU32vasmer1UUtlXmg4RmSXO
X-Google-Smtp-Source: AGHT+IGjXbsHaf3qaC93Qq3o81HX/9/GW9BuCGijx83kAwgsR9hZFk8J5TZfoj5N23Vb/NFJCv8eCC+OG7V6e4dx/7E=
X-Received: by 2002:a05:690c:6209:b0:78d:6f35:bda3 with SMTP id
 00721157ae682-790b5829054mr422917867b3.53.1768308404771; Tue, 13 Jan 2026
 04:46:44 -0800 (PST)
MIME-Version: 1.0
References: <20260113121238.11300-3-laoar.shao@gmail.com> <be08950549a97cf3a2efd077cffc767395c208807f5f65af081db9a9a9623944@mail.kernel.org>
In-Reply-To: <be08950549a97cf3a2efd077cffc767395c208807f5f65af081db9a9a9623944@mail.kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 13 Jan 2026 20:46:08 +0800
X-Gm-Features: AZwV_QgV5cvSxlqXHAoUL5sRKv197J3ZXWpFD3iA2PJgz-IvQZ48HUKVYxFcyvA
Message-ID: <CALOAHbCv7UWpPg9DK4j_xH-_DYifmjnRFyK1Cfu_Asy1L093bQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa balancing
To: bot+bpf-ci@kernel.org
Cc: roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, mkoutny@suse.com, yu.c.chen@intel.com, zhao1.liu@intel.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, clm@meta.com, 
	ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3B341C0006
X-Stat-Signature: km9rntc3dhfphcnytjmh4sowx7pgytiw
X-Rspam-User: 
X-HE-Tag: 1768308405-895120
X-HE-Meta: U2FsdGVkX19UXNCJVWK76d4ewsG9fsIIPod4fLxpUVt3xRK19G+bsT1ryAu3PbhXiWxngwc4i5JFAmD8UOPEhQcthxfAdLVAlKTrZF9q1VoeEK1Z73ZJjn8rYBexljUe20GCgBG5gYDxJrhRPheqOGFNDXgyexpfOeEO6dF97qEmQI9pEsrIOA8t6toE5cHdpDMkHF9BzTmHxfgCYsfAT33T664bEiFTr1KYR3ZRrFl52vTLPgwCn7GtVawh0CmTMM+8CCcQ5t2A5Qag3i+o2UXyrx/5qFM4leeLoCm5sXFW3dpNItiBx32DNX/PLV2fG9OjjF7J3kGxCe4GRj14nInV6JmjAcw+pfebfrn8f67CyiSMVUa4ue+ZYpegrp6gAycSdUzvn/rHSG+o5aQ9KKBYcvzKBb7dcSrQH/LB5El2cf1Gyjap70Hs2NgfRamtSNoPm0fZjkn7+H6bWVn5rem9LGvxB+FUtRn21kWlZhWEtFToGtCpvu6cvdvwg1t5tBTihh6ocYS0UGKRbd3oGKAM3YxQ1Pau9jsBYYnaVk6ChbRMj+YgJNeBTNG71ZTcCkUPuAvCEA27jAOY0lY3P7XLFs994KjdhUS5PspYQ2uZ+JcsBx7j/TaV+fqtgXciZfMxFjIkMzOs2udMBrduWrF/vDGZyVe82LOMjDFmtRW+1JsVkTzEjzJNhYl7+8B/MK7WtshP+x0Jooy5sWnD+f73AdUVvsXUxOtJnwpTI0zTKU8aMGrGMb0NTGHkLuqGXa/pJAIw2SESxZz+vx+qZa2peHW7jDVZx7qN2SBXDfgsyArF3vwkXorGvFRbZf2XYnxIlhY0v3YCZvS35JCBTGlBjPAwIJBHTllk0ThKVEDt/8F5eF6uzcPLQNvHf5bGKS019q0/p9hBlWmxCtchyTmsdZdk8TNV6qZn3GKyB0FGeL9MSl88JQ3YTmYp7lESa2Pg5ge1c8KXvd2qo9n
 OetXIawM
 LjlmCerboP73GBTYxeXp40e3Ukzb3jokfrEqgzLCOE91fGB7nWujaiKRDhVlVqCGYUa/9L69fOIFT1dBdqVGLCTZnh8aawy+v+3U+33V0iTfJoqdxclUM8al8d0tQYmix7heYL3Wz7GuBBJYMNb5kvNEpS6xZ5Z87+A+RDhKr/IFMd7u89+bsceuQe0wZdPeSSTiLc8F77r9s7Y84GfnP4VFmZd2YcWV88JZYn0BUQhRp+PbxVk/DuSV8lW+r/YcKWfVxdDDfvEi+j9eZKBekie4gpdw5cD1nHasKTnB9zUxk5pIfTm6p8N1FIeI8eiOa8Y+si4de1HK80ForYtPJpQw3HDs+bRIBgpuvdK+ff6MFu2upmzITBv9dGO3DT3gD5BeCFXQHP/TQa4iPIxXHUCrnGO1r6YhdSgLXfcqLAYR594eZSv3yYb5faSGcxq6xE0wVKpDHwTtrs7v5kWDNf4HzqCjqHCAOA0OXqT6yefXlesY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 8:29=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > diff --git a/mm/Makefile b/mm/Makefile
> > index bf46fe31dc14..c2b887491f09 100644
>
> [ ... ]
>
> > @@ -107,8 +107,13 @@ ifdef CONFIG_SWAP
> >  obj-$(CONFIG_MEMCG) +=3D swap_cgroup.o
> >  endif
> >  ifdef CONFIG_BPF_SYSCALL
> > +ifdef CONFIG_NUMA_BALANCING
> >  obj-$(CONFIG_MEMCG) +=3D bpf_memcontrol.o
> >  endif
> > +endif
> > +ifdef CONFIG_BPF_SYSCALL
> > +obj-$(CONFIG_MEMCG) +=3D bpf_numa_balancing.o
> > +endif
>
> Should bpf_numa_balancing.o also require CONFIG_SHRINKER_DEBUG? The code
> calls mem_cgroup_get_from_ino() which is only defined when
> CONFIG_SHRINKER_DEBUG is enabled. Without it, compilation will fail due t=
o
> an undefined reference.

Yes, this functionality depends on CONFIG_SHRINKER_DEBUG.
If this patchset is accepted, it will be merged after Roman's series
[0] since it has additional dependencies on that work. This explains
why CONFIG_SHRINKER_DEBUG is not added here.

[0]. https://lore.kernel.org/bpf/20251027231727.472628-5-roman.gushchin@lin=
ux.dev/

>
> Also, should it require CONFIG_NUMA_BALANCING? Without that config option=
,
> task_numab_enabled() returns false unconditionally, so the BPF hook would
> never be invoked even if a program is attached.

will fix it.

>
> > diff --git a/mm/bpf_numa_balancing.c b/mm/bpf_numa_balancing.c
> > new file mode 100644
> > index 000000000000..aac4eec7c6ba
> > --- /dev/null
> > +++ b/mm/bpf_numa_balancing.c
>
> [ ... ]
>
> > +static int bpf_numab_reg(void *kdata, struct bpf_link *link)
> > +{
> > +     struct bpf_numab_ops *ops =3D kdata;
> > +     struct mem_cgroup *memcg;
> > +     int err =3D 0;
> > +
> > +     /* Only the link mode is supported. */
> > +     if (!link)
> > +             return -EOPNOTSUPP;
> > +
> > +     /* Depends on CONFIG_SHRINKER_DEBUG */
> > +     memcg =3D mem_cgroup_get_from_ino(ops->cgroup_id);
> > +     if (!memcg || IS_ERR(memcg))
> > +             return -ENOENT;
> > +
> > +     spin_lock(&numab_ops_lock);
> > +     /* Each memory cgroup can have at most one attached BPF program t=
o ensure
> > +      * exclusive control and avoid interference between different BPF=
 policies.
> > +      */
> > +     if (rcu_access_pointer(memcg->bpf_numab)) {
> > +             err =3D -EBUSY;
> > +             goto out;
> > +     }
> > +     rcu_assign_pointer(memcg->bpf_numab, ops);
> > +     spin_unlock(&numab_ops_lock);
> > +     static_branch_inc(&bpf_numab_enabled_key);
> > +
> > +out:
> > +     mem_cgroup_put(memcg);
> > +     return err;
> > +}
>
> When rcu_access_pointer(memcg->bpf_numab) is non-NULL, the code sets err
> to -EBUSY and jumps to out:, but this bypasses the spin_unlock(). Is the
> spinlock left held when returning -EBUSY?

Nice catch!

>
> > +static void bpf_numab_unreg(void *kdata, struct bpf_link *link)
> > +{
> > +     struct bpf_numab_ops *ops =3D kdata;
> > +     struct mem_cgroup *memcg;
> > +
> > +     memcg =3D mem_cgroup_get_from_ino(ops->cgroup_id);
> > +     if (!memcg)
> > +             return;
>
> mem_cgroup_get_from_ino() returns ERR_PTR() on failure, not NULL. If the
> cgroup was deleted between reg and unreg, this function would get an
> ERR_PTR value, the if (!memcg) check would pass, and then
> rcu_access_pointer(memcg->bpf_numab) would dereference an invalid pointer=
.
> Should this check be if (!memcg || IS_ERR(memcg)) like in bpf_numab_reg()=
?
>
> Also, mem_cgroup_get_from_ino() takes a reference on the memcg via
> cgroup_get_e_css(). Where is the corresponding mem_cgroup_put() call?
> The function appears to leak the memcg reference on all paths.

Nice catch.
will fix it.

>
> > +     spin_lock(&numab_ops_lock);
> > +     if (!rcu_access_pointer(memcg->bpf_numab)) {
> > +             spin_unlock(&numab_ops_lock);
> > +             return;
> > +     }
> > +     rcu_replace_pointer(memcg->bpf_numab, NULL, lockdep_is_held(&numa=
b_ops_lock));
> > +     spin_unlock(&numab_ops_lock);
> > +     static_branch_dec(&bpf_numab_enabled_key);
> > +     synchronize_rcu();
> > +}
> > +
> > +static int bpf_numab_update(void *kdata, void *old_kdata, struct bpf_l=
ink *link)
> > +{
> > +     struct bpf_numab_ops *ops =3D kdata;
> > +     struct mem_cgroup *memcg;
> > +
> > +     memcg =3D mem_cgroup_get_from_ino(ops->cgroup_id);
> > +     if (!memcg)
> > +             return -EINVAL;
>
> Same two issues as bpf_numab_unreg(): the check should handle ERR_PTR()
> values, and there appears to be no mem_cgroup_put() to release the
> reference taken by mem_cgroup_get_from_ino().

Thanks for your review.
You are awesome!

--=20
Regards
Yafang

