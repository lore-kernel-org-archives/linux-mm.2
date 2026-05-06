Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31914CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A96B6B0088; Wed,  6 May 2026 08:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859CB6B008A; Wed,  6 May 2026 08:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748C36B008C; Wed,  6 May 2026 08:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62ECC6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:38:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D778B40113
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:38:54 +0000 (UTC)
X-FDA: 84736949388.03.3073002
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id BCECBC0009
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:38:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A7MhpcDQ;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778071132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rx/XFBRCEQu8HDUik+31Ss6iYuF49qBC+wbiHhNEaa8=;
	b=vfHQxqbEIkKbCmfeCycKpw0oY/VkExd/iieI3Y71aI8pxXhGWA5ZPAK7v1jEUNU+/pOr7B
	MdsT/eWJSzNqbyWzrbULhiQjQ6noNeWFMCjecPSyyHKK35eoWMZeGVNnaayFrSVy+0vV7A
	sW3JcQbWUtm0iuHcd+2dY+qzyjZd+g8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A7MhpcDQ;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778071132; a=rsa-sha256;
	cv=pass;
	b=oQjQfIKIQ63Nin0VuFuEjgJoRa/Rzld336VUJYTMhPtCRCBZhJ0+XNusmZGJqRr2HXgNWR
	aPj3qpdY1gXC5pYpQVOif3rcZDS6fLlI93cqPVIHPmIGpJwUdGda0k1jX2hNJ5VXYfroa+
	wpPzQIRCiUKFpC34H24IKX2r+iWOR5A=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59e5aa4ca41so6850751e87.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 05:38:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778071131; cv=none;
        d=google.com; s=arc-20240605;
        b=K8y4djRwDDdH1jKe6aH2r+TktUbXAflpawuM090o/YBYcVBeB8rZkpRysSDKuEuDWP
         mHh//z0JGh0vwQXEMb+MQnjGe6589URDot326o1Rq9RCDhEYo/oyMHXJwQvZLJxEOvJM
         5Hck0/+3HCZC/RHAMVi2eQ8mJ9fmxpviLk/EygP8hWYPGbJhAww4hq2rX++uDLZJrZ4Z
         uDzEwk24jN1dHRj8ybMKien0JJ468/CBLkrGzbI29nnbKmj3D1o8fbCR2yUVDMAZXdih
         f2GwD+nvaDf7kawsDsWB8E2f2dzJWk+BPuG+UXI5Quzan6vXLi5V96MTmGPTU7Yr1Ck0
         CvjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rx/XFBRCEQu8HDUik+31Ss6iYuF49qBC+wbiHhNEaa8=;
        fh=fj99c2fCSaDrCJVLsJwGaKuWzZwwPh4bQTWZoPJgbKY=;
        b=IERqOfsvVUlkMqfKGHfY5yBYq/3/Is2D1NHeo3heOCHWV68msuhznitFx1w+x5AEqx
         6Rj4txtC6lqiKEx15106RLCVmYD97Ethkhj2XtJBXTS0clHaPmr9RT7McsKDYnkpjYnU
         hy6bbl2oAKFtzhrwB2CDgqiZe2urnXtER1xvxcsqlY5sG29qJB4UFagc+kA7Jtv5VSu5
         C+gh+uuJvHtTQkeaV4glIalQ31tw9YwtRu4yp2aYxubv9x6QX59LbYqpyIRSQUgu4nVl
         Nw9Kb5X8+AJujiqm8WW2vGF5tNNW5MBJSE288SipgnFkVRBCJXXPu7+mkbgzyBLnSing
         kFsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778071131; x=1778675931; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rx/XFBRCEQu8HDUik+31Ss6iYuF49qBC+wbiHhNEaa8=;
        b=A7MhpcDQ2J2OUtsWRRVB8+pbt0V5sOKoekxG2p4TyJ9fin8MMvd5WHEL0zjwWKBlzy
         yHeWDVSACJViMFMF/HPYRb+zjusE9G2J1oFbXKS7A7kqE9R0wC85+w1VYinMA7eUsjdv
         TepCbtDyXsFWvNRnuRh+3N+18xb6WD2frFe29YUMJHfc3I2tcdh/8htRkypQTsIajeKr
         VagO4WuzIknnkdYs5nOg137MtqNnVJz5DTPJjy33MC2xFk/AoiKH1R9h8AB+zt8MW/qu
         eXSA2tQY+JmBtNs/+XxFWJCVFHvZqWw302vCgw+DiyF+zcgG1pwWBCula6H9c5gNoGfI
         cFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778071131; x=1778675931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rx/XFBRCEQu8HDUik+31Ss6iYuF49qBC+wbiHhNEaa8=;
        b=rB/gRmXKhD8HsRzqSFLaGZN/Zu1FsDs6qvMJ4HKoTEEAjGGVW4we5z6GS+yiNxs9lv
         mJsQMN1KYo0nzF4gL06WNpBfTu2AxUaeOwhcQwMVgmWAqNf6R4FamFEkiHE2rL9AsHbX
         z5J7cra6/f6uBjrZ7wvxxcU8Kf2OOmCmldbJbTtyw5wkLh1W6Kvsl0RKugYq7SIJwG92
         8tmED1X3v9xfY7b7GDLINOTCoUHFMUXjhP06WPwmBlymvX2XYQAFweC46cIHvExcIqWa
         vLFhwYlatMHgmbs5Hk8A8z8uAM5+K2uj7oXq4bZ/wjClcgkg3aZ4gC7AP4HVzGXigkWL
         pp3w==
X-Forwarded-Encrypted: i=1; AFNElJ81nDTb1bX5VlbY12GugG9a+fPhQDBUF0s0t9+v+HeU2mqlTYXEvJQRodQJg9Dim0reD7qK0MQL9A==@kvack.org
X-Gm-Message-State: AOJu0YzfvtRqn5i3MiJpZIhZMcsa3p3UUAyj5xoRc0Cq3tWyJngTPftW
	1yPKCuEGV78c36l9FJ8ClMTzNKzefaJUMtRKyHlN8iycEwaJwV/X2da4/0nSTSUCg5GFw056XO+
	26C2CH4bCtrXjZ/TMAxfg0fB1N3EMN60=
X-Gm-Gg: AeBDieuucRIL3IyNw03qUbYp7xOwEp6VXZHAvqZ+JCdMq5+u2gUbqChUctFHh79i/QF
	eLOWYWUcTWaMH09Jdt+wddEfeYahOKGm39nd/B5sQxX3ft3/gMgolAvw8W8l3u6tsuHHkeT9J48
	mppoP6LLmpUldY4smHj9xyUiW7/bUYXnT0LnsncCP+UbaIdTG/uGfpTMuR33eGyMq3QXX2BHNvd
	jOHF4Rzjo031DRggr0tqIwRg0pkla1PxcoWi6WllIEdY4V3BhUaPWYbIMDy0WmtJNhHgA7NBLsa
	fuYDC+aSrZqzS7F59sha
X-Received: by 2002:a05:6512:3c93:b0:5a4:11e:5c7e with SMTP id
 2adb3069b0e04-5a887adff04mr1090469e87.5.1778071130517; Wed, 06 May 2026
 05:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-3-vernon2gm@gmail.com> <91c02dbb561c7a4d760ff3314c99fed77870e0d7665848b5832f6719d21feb17@mail.kernel.org>
In-Reply-To: <91c02dbb561c7a4d760ff3314c99fed77870e0d7665848b5832f6719d21feb17@mail.kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Wed, 6 May 2026 20:38:38 +0800
X-Gm-Features: AVHnY4KNmriAzvSUTSBe2OOUqmXce4yr6SLVLgUurI33PcXDXqVQ_V3zHDt9EOA
Message-ID: <CACZaFFPAv4PdJBfdsT5Gzk3quvGYHh15gt9yxLdKLYW=sq0LOA@mail.gmail.com>
Subject: Re: [PATCH 2/4] bpf: add bpf_cgroup_{flush_stats,stall} function
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, 
	ast@kernel.org, daniel@iogearbox.net, surenb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	baohua@kernel.org, lance.yang@linux.dev, dev.jain@arm.com, 
	yanglincheng@kylinos.cn, andrii@kernel.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, clm@meta.com, 
	ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BCECBC0009
X-Rspamd-Server: rspam06
X-Stat-Signature: 95fj18bmzx6w7snp9jefhm5td4z3d4hh
X-HE-Tag: 1778071132-794802
X-HE-Meta: U2FsdGVkX19l+JlLamJBBGKYZKelg/JFb5314IR1wUllfG3pChTsNBfbZJO6R5Zmg3SkzJiubs9arkwwkxz7XzVIkFDV+F60zUrwXT2Ore/oRbgsNOA0qgqFp+v6xcQjgEMmZeA3xRIkF23CGUnbElNd616iXIBZ7nBubtrkem+nAUVe7SosK7LRPKwB/ji7K00s/kn2OBSz7ecWvXtKS177k47ZVeTHQwAoGcY8Sj63PT4hgrB4CPrFDX4SrRn9MQ89UV5+RUrbqP9GPhZKV2ZVI7omZf3Xlj/CDPocR4BXq0zIzFCjBiQ9ogQDMZA1xGZ8pXSzT5tmo1bXrfFepumIYHzBWDm4OzHSREjpxPlbb7RcKmojkNQTWv+NZALgcdG2ZyCQzxJAHVFPQeEQbriazbmUe3YTavNUGa2+L77+ffEM6iIG3/w5XKp5vNjq0U9hdJ6Vic7OQLB4fIpNTT7ZnfT9G7bi9/U2Yv2RyUXDG6ayXHjvvjHV01ppuMoITnsxwPQQzFiY7iyj9ZLGJ1o+oI2vm0eStjnaJku3dwD44bnfMwjGvICGYBVhu4VPHYyIb1eCMO2itLybNYuNZMUb0mVnI7PRh9QlD/Jl1fWNW9p7hfm3aZpc+IZI5w9U+LHWEfvGaQ8CyGp+ZmL+Ksf6LxMgxl6ymXSHn5BqWFAPzR9g2x8/nGQpShlx6bl3OfankrwJdXJWKvODNDibmCO3R8rzxVSifd3hkQpXr1uVYmeNz95wxV+i+LV5INiLY0KhMKud4ro4gehTGBVIjpWd+aYnRZK4knL7BG4XQ0Ai3iRze3/XmM046ASBG3WOGGibwbVHiJ0jId1VLsyIZkEmQXPoUvUBcD9KWlAHw7CDCt1uHRvPShbDV/ooNXCZsN1TfXER0vBZGgZSvVVNCRz8ALBX/HZVrARq2njL3R4w7Si0mpnYXo8tJz2zhG9W57ICTYe54PZ7tGEqhMg
 XiLZ4EYv
 yHTq//s1x9ic5s/yXdmqvNYIuajoDmeR457NmjRBNoRpu+szcdVxllJ1jVxMKOZ2/hL/6fgvksAsfbrNE1Iw+PdZnKmclbimb1LIaWLDzjM8lRGpTCX9ilQgvR/RJHTFHs/vLSF29n+9k97LcOtjDT7KLcdrtCktozUh1ksqdfWpV+LQ52gY3BEcKmfh1XFZhl9L4Sf+1JdlxDaRUzzupkISam7vvM/gbNcR49+2oCuTr8Ul5QZnonOXTJeRh65W8tJ9tzNslqQoDN4lM4ZTz4iVz7nz4p/8dKk3yiq89j4Yo5N/+J1F90zlbtk+fHJKA3AsnLv9bQI5MAl8nWR3CB/W2onBJ6ojDwXHzKWyWXyCOnSTw8t1APl2OngaQfGdGtxQ+A02NgUDKSzRPl+1WgHwUr0uIGi4q0nYsTf2LFAVkomm7WOhXadc6fFOple0PTGiBosxzTY44cM8rmmzXMey+rmYchaCwvfDcShET+fkQbHGX+e07it8Z9mISl64c0kiYRQCdahQwwjHDskh7UTDMGT2tPINRRdz9jUjnItj/IeNNQLjXuEE74n0hWc+JWNHdAfMSo+DrwGru+3D+ZdfW5JUkPO1XkzxwhQSlzf8tSBzkjEm04QlO0yCzQsP0P8a7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 1:23=E2=80=AFAM <bot+bpf-ci@kernel.org> wrote:
>
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index baa12b24bb64..d7b04f1fc9f1 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
>
> [ ... ]
>
> > @@ -2819,6 +2820,32 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u6=
4 cgid)
> >       return cgrp;
> >  }
> >
> > +/**
> > + * bpf_cgroup_stall - acquire the total stall time of cgroup
> > + * @cgrp: cgroup struct
> > + * @states: psi states
> > + *
> > + * Return the total stall time.
> > + */
> > +__bpf_kfunc unsigned long bpf_cgroup_stall(struct cgroup *cgrp,
> > +                                        enum psi_states states)
> > +{
> > +     struct psi_group *group =3D cgroup_psi(cgrp);
> > +
> > +     return div_u64(group->total[PSI_AVGS][states], NSEC_PER_MSEC);
> > +}
>
> Can cgroup_psi() return NULL here? Looking at include/linux/psi.h, cgroup=
_psi()
> returns cgrp->psi for non-root cgroups, which is allocated in
> psi_cgroup_alloc() only when the psi_cgroups_enabled static branch is tru=
e.
>
> When the kernel boots with cgroup_disable=3Dpressure or psi=3D0, cgrp->ps=
i remains
> NULL for all non-root cgroups. The sysfs *.pressure files are gated by
> cgroup_psi_enabled() so they never hit this case, but these new kfuncs ar=
e
> directly callable from BPF programs without such gating.
>
> A BPF program could obtain a valid non-root cgroup (e.g., via
> bpf_cgroup_from_id) and call bpf_cgroup_stall on it. If PSI is disabled f=
or
> cgroups, this would dereference NULL at group->total[...].
>
> Similarly for bpf_cgroup_flush_stats below, passing NULL to
> psi_group_flush_stats would eventually reach __psi_group_flush_stats whic=
h
> does mutex_lock(&NULL->avgs_lock).
>
> Should these functions check for NULL after calling cgroup_psi()?

Good catch, I will fix that in the next version. Thanks!

> A subsystem pattern also flags this as potentially concerning: the `state=
s`
> parameter is used directly as an array index without bounds checking. The
> backing array is declared as u64 total[NR_PSI_AGGREGATORS][NR_PSI_STATES =
- 1]
> (see include/linux/psi_types.h, struct psi_group), while enum psi_states =
has
> the range 0..NR_PSI_STATES-1 (PSI_NONIDLE is the last member).
>
> The BPF verifier only checks that the register is SCALAR_VALUE and does n=
ot
> validate enum ranges. Because the parameter is not marked __const, a BPF
> program can pass any scalar, including values derived from map lookups or
> arithmetic.
>
> Passing PSI_NONIDLE (a valid enum value) reads one element past the inner
> array; passing a negative value (legal because enum is signed int in C) r=
eads
> memory before the array. This would leak adjacent memory contents to the =
BPF
> program.
>
> Existing BPF cgroup-stat kfuncs guard against this pattern:
>
> bpf_mem_cgroup_page_state (mm/bpf_memcontrol.c):
>         if (unlikely(!memcg_stat_item_valid(idx)))
>                 return (unsigned long)-1;
>
> bpf_mem_cgroup_memory_events (mm/bpf_memcontrol.c):
>         if (unlikely(event >=3D MEMCG_NR_MEMORY_EVENTS))
>                 return (unsigned long)-1;

Good catch, I will add bounds checking, in a format similar to the
above. Thanks!

> Should this function add a similar check, such as:
>         if ((unsigned int)states >=3D NR_PSI_STATES - 1)
>                 return -1;
>
> > +
> > +/**
> > + * bpf_cgroup_flush_stats - Flush cgroup's statistics
> > + * @cgrp: cgroup struct
> > + */
> > +__bpf_kfunc void bpf_cgroup_flush_stats(struct cgroup *cgrp)
> > +{
> > +     struct psi_group *group =3D cgroup_psi(cgrp);
> > +
> > +     psi_group_flush_stats(group);
> > +}
>
> [ ... ]
>
>
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a =
bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/READM=
E.md
>
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/252852=
79315

