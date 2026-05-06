Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 171A1FF8855
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0DF6B0088; Wed,  6 May 2026 09:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7720F6B0096; Wed,  6 May 2026 09:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661246B0098; Wed,  6 May 2026 09:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 566B56B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:06:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E03C21C05C1
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:06:38 +0000 (UTC)
X-FDA: 84737019276.11.31B1ADD
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id C0D4C40006
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:06:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rCM6h3Iw;
	spf=pass (imf01.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778072796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIha8O8IglA0EGFTspNtQXsJyVziplf6EjUrxckyjaw=;
	b=G0bkZ+IpAZBvfmWKyg0LW/xtFzGmgiv0pc0d4pxx/2EMx3hrRFxjpHH6xayye5xtuzQBod
	S4fl0TOrAt0SwGC0Y1HxOJO7lI++qiX04K7XpDhvrMiIyeI24BRaTxL9sPd9hgvrgZLN3L
	uF2eTEw4RioZmaoDiLkBISXYibeyn2o=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rCM6h3Iw;
	spf=pass (imf01.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778072796; a=rsa-sha256;
	cv=pass;
	b=svKBd8T8jQ4fSqUT+yD5zeoLOTlw09WfR513dXGySpaDYRHRIXO7sD9DfGMkGdxMqmqKW3
	UTYFvQeAqMKf/o75a7uTMNwXfJ+5kxF13U5Y/NPjNxzgpE9DOYj1gadVtBKfliaT7Mfgu4
	0pne6bnPGRrNjd9ehNPT+zTxe7tzl7s=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38e97e73234so61815891fa.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:06:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778072795; cv=none;
        d=google.com; s=arc-20240605;
        b=Ziv1ATGdX5mXZlnZ1+BQQVtIeKc8Wt/HPdTofLsUzbmxC/4mXOk20Tgx4lzBDf7xvK
         1askqQ20Bcin9+9qA04/oYbyzkdDuQ/jnF1CRliiWOj6NxEN6dF4LmmyroNQVAUI84gq
         Agb+GNWo5ivyPLEUfxoBRAN9sPgdOoi9CYN04Oq3KLg3W0XU/xBDTKe1JCBtLK9vMhaL
         u55/UtKq9kgx8OQnoFpm0K5Fo46hbCStxaXPDa3WAloz208D+OyV+47N9GaLcF/RIc5a
         XGnQxkxKtFdAaA9icZUiY6v5i9URFYbZZGOSm0hkdFnW4M62tDSEz+0p/Li0Bybdcnvg
         dTrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qIha8O8IglA0EGFTspNtQXsJyVziplf6EjUrxckyjaw=;
        fh=z3Fwobmdit0YNEomcs+AYtTHNp6Fp+n7uaRZuWc0flU=;
        b=RXbO+xr+7BlabHVdcaSPizsKwo4lrwYHWbTTkz+8sMpHiDVaqyVFF1jrhfpLO6veuJ
         Ew1kRzvZqCbrsKPeYy6D3Ka80nzuBJp7Iukg3grh+UUzZKqZfPNSS0eqLAy1Qc4le52S
         b0D+kpOfEpMLLC3aX0oCpeA1We3q+2Nh5RTCGVomNZh70dZvurBN3+ZOTRsLhQUh+qqT
         BQd+ksBDMvEK706BPaMlHc0U9fAMphov+hhMMgVo7HkgugkNYjKLQf8W74IuBfwYtGXE
         augPo/5hKu1YMnXxoLawZOaUtDvbf1U4qYRoEkdreE9pb9+wtvwkptpxo5NexFEdTwnf
         ZNGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778072795; x=1778677595; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qIha8O8IglA0EGFTspNtQXsJyVziplf6EjUrxckyjaw=;
        b=rCM6h3IwDP7Qtj3IDU0gwh6lY3rd6gY4hnKLeYH5KjYGyNS671uB8WSGu92tE3Ormk
         HkL/CqvjyaRukCyJPTBJdCHu/QE9rGkatqQG4NgB+wDYKc0f1ZTUK01GNuHSEXVuvByX
         HwNNdKzFdBag/K468Ku7VSCHvfdsJnEYDmSmj3ISPMZpyA4TLDVc4aVQBIRU78aFhmTL
         yWTX5VvbsRGb9M/AmH467ivhL4eiWFZEZ8BpM/FCdTe+W6INxGRihiRJdAdLdrwUl7e2
         tDljw55zSOnF9ddKiW9Zc9xfsIH9D4VW17qnr38NC+JpGuM1LG0oBKnuG06COMjIdHQo
         oUfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778072795; x=1778677595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qIha8O8IglA0EGFTspNtQXsJyVziplf6EjUrxckyjaw=;
        b=CLDKDGVLSQKWwkEHRlXEKB+wW4iMJhKmzz+Tj+g8CuIvfTsqDil8WQawPQpp45amwY
         BE+9h99VM6GWzhoXP6xs0u2EWdUhvRiqHz0BY+XMO+/r5sL2SfodQOqQaalEVQIMA5qP
         oW6grXfRldLvrJup9cL8DquYGP8/LQwvLb4Pw7nLgIZHKXJQN0gozpCH89dbMrfPfSpM
         dSWbPGhzrTGP1RGI79gNFpNZgsYo5vRE44nvlp2cYZwpGPas0hPAcNbOatV76hmB+hdX
         52fF2tYHPgyg4/O9jpaOrhGnGxwZaTeWEj6bIoekRXze+xoLtwg69omcabxYt0OyuICf
         ifEA==
X-Forwarded-Encrypted: i=1; AFNElJ/CNm0/Oy4euPxscfboAF0OSmNFMXUnmaYK9nzVl7StrvTOrQd8Zj6F3RlRii1r13RB8mPZEn2sNw==@kvack.org
X-Gm-Message-State: AOJu0YxiYGV1vrsVn9l7Z2unYTCrYZRxvtLgihKTRS/pHMC7xcyGNRYc
	M/xLfItK6sar85Xazq7PVrctRCNqAAXmioWfwA8v+zmuGPA4WoDQPnsfn7VU8yq7+VqWBf9tLiw
	D9Vx4v61v3kGGmoyoT04Mhliktsnt3Jw=
X-Gm-Gg: AeBDieugr+9dwGh9rUbzXHhL9fqYWA9AFIG8mw5X18kJbMS/IW5qZX+hhuOHsaMoohG
	pbEE13RLFRWrJPEu+DsQHb7qBksQrvy0uxeh/S8o/8JFcI4h7kLLp4Kh06TBJEp8X97hkyzJU4U
	Dg/jiMKkhggou+EBOJ3q/xe6U9oG+VFwdJDxDm6/gv3PfFL5DvhirxxYz8YYBPoqRhfd4ttwB0q
	Ugv7XzYYsh8E8qVr5Ib8sju2/TmITWiQ0ED0MMDBjLRFGadlGzB8RjXJJyEXjWMj1kMbzM6r85r
	/UHV8v2C+1PPJwPTpeoMmjrfPmE=
X-Received: by 2002:a2e:be85:0:b0:38c:c36b:8221 with SMTP id
 38308e7fff4ca-393c3f0d59fmr14338631fa.0.1778072794477; Wed, 06 May 2026
 06:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260503165024.1526680-4-vernon2gm@gmail.com> <a74b6b1d137439121917216ef386bbab9107afcc89819d1fd94e389b8c54b4f1@mail.kernel.org>
In-Reply-To: <a74b6b1d137439121917216ef386bbab9107afcc89819d1fd94e389b8c54b4f1@mail.kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Wed, 6 May 2026 21:06:23 +0800
X-Gm-Features: AVHnY4JugtOdbG81NqtvS8OnnXg2CeaCnqaekvuLdZtxK-4PsvAJWtwh-SV06ig
Message-ID: <CACZaFFM-o+oFKbnpnHKL9tk01-i=h7Uc2uh_KH1BO9x5NapQUw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: introduce bpf_mthp_ops struct ops
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0D4C40006
X-Rspam-User: 
X-Stat-Signature: h7b4tkrfabdccnskshhryecgmke3iisz
X-HE-Tag: 1778072796-33952
X-HE-Meta: U2FsdGVkX1+ilnmFRqAEyogFbWeFgUaNhAcs2FxIrRgmD5sGKu0c2rOqONvEuSpBYUtL9rXXguUOCljVW3+YZEWhbieOU1qZepYgA8KQleNYnDHRKVyWfxsr4Mqwkj99AHXGqGBkR/M7QJQ1OEwqhLCe6VHdl6Cog1DMA9XpExNza3Es4EdQNrY+z9orD2eahBNs3KNSBWqank+sv9Mqj1a/Bp/59Y+C0SxW77xBVkbG7hU9kwe642gk7s+A4ipi2OBQe68jt4ixxzmaIp2jPm/B9ttfu4LxnyVoS1DbOgwUzxb/RtixQfNgsCjfT9r7E816Poq9gb4xte9jjZDFjs5proQdmpicuGbsqEIqKyQ6e5AJWnD5SUTv40h91dobzkGLwtSk/3DAy4I9S1RD5QZSI067cRdSNt2utcHpk2nPYSegEa5ukY0T1/sz6lW0u9J6VQZpedyxPRA9pkUaosRO0zJJMNywMyV1ER6NvXyjC7WJOGrpMPjZ6kvW/AlAd9zCjRzGTtVRknETvDkji9h9q8xBc1lJxXG04y+kdXKqO8Pw+VTw3gxCQ1vUbH8QLqk83RCEZz0WaTPrPOpN8elBDN8ae9R6nCRxHHdEQTwDee7tdGy+G3qyyIytw5Rxf2WJM+DrISrdc2gUS53+X/EOJmyCdad79To7+ZztB02P8R4kOzry3QSy6RvYAMCihn6Ga/zLRb2f4PdZQDk1p1qEzrwvoPt1+9q35GFl7b3u9/wgiemGrGfwtwcRzjt7a3gPCqkMPlSeufQoXwvHtT+vI91bkNbOcUQHtnnINSSofjPKKLshwJZktO3V3W9jERdNAhisxgkMwtDXlFNrpVdJEHb0YTs0GHnu2oZ/ceHZglGVuptyu0dwSSJdrmJyypXRHFFRLLi7pzKdx6sDcVvscpxxg8OQgFXAziDSNoWEE7NWc8WLffyub7gSbhN8ug8VdHoT7YNsf/pnJNB
 8D6NWiUN
 0WS9e7lnZ+0s9bmcddV8bFZRdhN84wc+2QSbH5xM3T+Vzk76XPUt1ksSEyMis5td55zKUX3DBMXXyEjGChbfZPYI7qqCP0u88eWd8u9ggSICZBbCvDW04mpuJtheh1DmDdl4uyaZzWxX2w3tHdk41BS/NT1NZ5E/M5QqliHCoEfm8EaMS5vOz67ij5fWDw+D4pwoYGSgpHZIFsPjjH9bzBOFTiJ5h6eK+QIx5k0n1/tGf4plubhooGEQyzEoZr91NQ+IYiaj3hQue23iAYUJNjYY9DL19l6/mh1poQCDAbF0aVS4KzlKKVrfnChF1xppJnRGnEPNNC3ZrxFc5QtWssx4uBkSI+SAk7yfIup3qYxC9t+KsdDUpVq3gKcle+L1OppS6orq5JMH/3WFQBjhRYKMz0nQZ0KbgQfxkelO1CAwz1jruzchKK4P8NpIvJLTeX75rx172a3NT29XEvw3gB29t7RqZa+nBElQuEziL3A3BCIQ8gic7YwKdE+tjb/36IqTCZc6gZyx1SCo4wh+d55svoIt69CTJY8ukTeawV8YedgNfV+4yBzeNW/sctWMVHzAx21/cNjcdcFCQF5rsQOsx54zUOvzfstDAlHXdUAGsW3KtzvMlQQJF1C2DFiYcDAW4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 1:35=E2=80=AFAM <bot+bpf-ci@kernel.org> wrote:
>
> > diff --git a/include/linux/bpf_huge_memory.h b/include/linux/bpf_huge_m=
emory.h
> > new file mode 100644
> > index 000000000000..1c8a6f7ad8f1
> > --- /dev/null
> > +++ b/include/linux/bpf_huge_memory.h
> > @@ -0,0 +1,35 @@
> > +/* SPDX-License-Identifier: GPL-2.0+ */
> > +
> > +#ifndef __BPF_HUGE_MEMORY_H
> > +#define __BPF_HUGE_MEMORY_H
> > +
> > +/**
> > + * struct bpf_mthp_ops - BPF callbacks for mTHP operations
> > + * @mthp_choose: Choose the custom mTHP orders
> > + *
> > + * This structure defines the interface for BPF programs to customize
> > + * mTHP behavior through struct_ops programs.
> > + */
> > +struct bpf_mthp_ops {
> > +     unsigned long (*mthp_choose)(struct cgroup *cgrp, unsigned long o=
rders);
> > +};
> > +
> > +#if defined(CONFIG_BPF_TRANSPARENT_HUGEPAGE) && defined(CONFIG_BPF_SYS=
CALL)
> > +/**
> > + * bpf_mthp_choose: Choose the custom mTHP orders using bpf
>                       ^
> The kernel-doc format for functions uses parentheses followed by a dash, =
not
> a colon. When scripts/kernel-doc processes this file, will it skip this
> function documentation?

I will fix that in the next version. Thanks!

> > + * @mm: task mm_struct
> > + * @orders: original orders
> > + *
> > + * Return suited mTHP orders.
> > + */
>
> [ ... ]
>
> > diff --git a/mm/bpf_huge_memory.c b/mm/bpf_huge_memory.c
> > new file mode 100644
> > index 000000000000..e34e0a35edac
> > --- /dev/null
> > +++ b/mm/bpf_huge_memory.c
> > @@ -0,0 +1,169 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Huge memory related BPF code
> > + *
> > + * Author: Vernon Yang <yanglincheng@kylinos.cn>
> > + */
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/srcu.h>
> > +
> > +/* Protects cgrp->mthp_ops pointer for read and write. */
> > +DEFINE_SRCU(mthp_bpf_srcu);
> > +
> > +unsigned long bpf_mthp_choose(struct mm_struct *mm, unsigned long orde=
rs)
> > +{
> > +     struct cgroup *cgrp;
> > +     struct mem_cgroup *memcg;
> > +     struct bpf_mthp_ops *ops;
> > +     int idx;
> > +
> > +     memcg =3D get_mem_cgroup_from_mm(mm);
> > +     if (!memcg)
> > +             return orders;
> > +
> > +     cgrp =3D memcg->css.cgroup;
> > +     ops =3D READ_ONCE(cgrp->mthp_ops);
>                 ^^^^^
> > +     if (unlikely(ops)) {
> > +             idx =3D srcu_read_lock(&mthp_bpf_srcu);
>                       ^^^^^^^^^^^^^^^^^
> Could there be a use-after-free here? The pointer is read BEFORE entering
> the SRCU read-side critical section. If bpf_mthp_ops_unreg runs on anothe=
r
> CPU between these two lines, synchronize_srcu returns immediately because
> no reader holds the lock yet.
>
> Race sequence:
> (1) Thread A loads ops (non-NULL) above
> (2) Thread A is preempted
> (3) Thread B calls bpf_mthp_ops_unreg, clears the pointer, calls
>     synchronize_srcu which returns immediately
> (4) Thread B frees the backing memory
> (5) Thread A resumes, enters SRCU section, then dereferences ops->mthp_ch=
oose
>
> For SRCU to protect the pointer across its use, the reader must hold
> srcu_read_lock before reading the pointer. Would moving the srcu_read_loc=
k
> before the READ_ONCE prevent this race?

Good catch, I will fix that in the next version. Thanks!

> > +             if (ops->mthp_choose)
> > +                     orders =3D ops->mthp_choose(cgrp, orders);
> > +             srcu_read_unlock(&mthp_bpf_srcu, idx);
> > +     }
> > +
> > +     mem_cgroup_put(memcg);
> > +
> > +     return orders;
> > +}
>
> [ ... ]
>
> > +static int bpf_mthp_ops_reg(void *kdata, struct bpf_link *link)
> > +{
> > +     struct bpf_struct_ops_link *st_link =3D (struct bpf_struct_ops_li=
nk *)link;
> > +     struct bpf_mthp_ops *ops =3D kdata;
> > +     struct cgroup *cgrp =3D st_link->cgroup;
>                                 ^^^^^^^^^^^^
> Can this dereference NULL? When bpf_struct_ops_map_update_elem calls the
> reg callback at kernel/bpf/bpf_struct_ops.c:873, it passes link =3D NULL =
for
> maps without BPF_F_LINK. When link is NULL, st_link->cgroup dereferences
> NULL before the check at the next line runs.

Yeah, I will fix that in the next version. Thanks!

> > +     struct cgroup_subsys_state *pos;
> > +
> > +     /* The link is not yet fully initialized, but cgroup should be se=
t */
> > +     if (!link)
> > +             return -EOPNOTSUPP;
>
> Does this comment match reality? Looking at bpf_struct_ops_link_create in
> kernel/bpf/bpf_struct_ops.c:1397, the link was fully initialized by
> bpf_link_init and bpf_link_prime before calling reg. Also, struct
> bpf_struct_ops_link does not have a cgroup field in its definition at
> kernel/bpf/bpf_struct_ops.c:58.
>
> Also, does struct bpf_struct_ops_link actually have a cgroup field? Its
> definition shows only { struct bpf_link link; struct bpf_map __rcu *map;
> wait_queue_head_t wait_hup; }. The patch does not add this field to the
> struct. Would this cause a compilation error?

This series is based on linux v7.1-rc1 (26fd6bff2c05) + "mm: BPF OOM"[3]
first four patches.

All of the above definitions are in  "mm: BPF OOM" PATCH#2.

https://lore.kernel.org/linux-mm/20260127024421.494929-3-roman.gushchin@lin=
ux.dev/

> > +
> > +     cgroup_lock();
> > +     css_for_each_descendant_pre(pos, &cgrp->self) {
> > +             struct cgroup *child =3D pos->cgroup;
> > +
> > +             if (READ_ONCE(child->mthp_ops)) {
> > +                     /* TODO
>                     ^^^^^
> This isn't a bug, but per BPF comment style (subsystem/bpf.md), multi-lin=
e
> comments should have the opening /* on its own line in BPF-related files.
>
> > +                      * Do not destroy the cgroup hierarchy property.
> > +                      * If an eBPF program already exists in the sub-c=
group,
> > +                      * trigger an error and clear the already set
> > +                      * bpf_mthp_ops data.
> > +                      */
> > +                     continue;
> > +             }
> > +             WRITE_ONCE(child->mthp_ops, ops);
> > +     }
> > +     cgroup_unlock();
> > +
> > +     return 0;
> > +}
> > +
> > +static void bpf_mthp_ops_unreg(void *kdata, struct bpf_link *link)
> > +{
> > +     struct bpf_struct_ops_link *st_link =3D (struct bpf_struct_ops_li=
nk *)link;
> > +     struct bpf_mthp_ops *ops =3D kdata;
> > +     struct cgroup *cgrp =3D st_link->cgroup;
>                                 ^^^^^^^^^^^^
> Can this dereference NULL? Looking at bpf_struct_ops_map_delete_elem in
> kernel/bpf/bpf_struct_ops.c:936, it calls unreg with link =3D NULL. When
> link is NULL, st_link->cgroup dereferences NULL.

Yeah, I will fix that in the next version. Thanks!

> > +     struct cgroup_subsys_state *pos;
> > +
> > +     cgroup_lock();
> > +     css_for_each_descendant_pre(pos, &cgrp->self) {
> > +             struct cgroup *child =3D pos->cgroup;
> > +
> > +             if (READ_ONCE(child->mthp_ops) =3D=3D ops)
> > +                     WRITE_ONCE(child->mthp_ops, NULL);
> > +     }
> > +     cgroup_unlock();
> > +
> > +     synchronize_srcu(&mthp_bpf_srcu);
> > +}
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

