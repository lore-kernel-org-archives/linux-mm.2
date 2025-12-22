Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3E6E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 00:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5496B0088; Sun, 21 Dec 2025 19:39:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0595D6B0089; Sun, 21 Dec 2025 19:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CD46B008A; Sun, 21 Dec 2025 19:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D34676B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:39:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40A7DBBEA3
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:39:57 +0000 (UTC)
X-FDA: 84245249634.30.B1DE120
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 579BBC000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:39:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ghTDwtNL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766363995; a=rsa-sha256;
	cv=none;
	b=w3/lg84YBmhCMYnb4oZDVY22gCx3X2DYaAZo/dKHMC/mRucHfcXyv/ReOufk3gO3Ef0hjM
	OBcX0ilkQYFj51Gtb3tEBehP1BSEQgYhJk02i+ML1htJccCDiQGyNjhhW+rjKG9n00+v8Q
	4pGgJHtGmOq7vxMN58fENpnTUuVwS5c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ghTDwtNL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766363995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/H19Q6tBd0UoTOXIGQ7f4tfksWDWCO13hxwp5+fi/A=;
	b=18AxScZBwps/eVixFI4LdUlCkg+/xLX5doBhxI/dH7i2oHuRM8L9lDI4eeslNkU5Oz/aft
	xyVaDRHml1qoIcBP0I9JpVzrcc1D8STzcZjdBW2SccS5gWakLU2e8wvARad3GRUiZ768Cl
	VZFiqJbl5imA6/yLoLmJqlHTirocJ8I=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42fb3801f7eso1801475f8f.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766363994; x=1766968794; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/H19Q6tBd0UoTOXIGQ7f4tfksWDWCO13hxwp5+fi/A=;
        b=ghTDwtNL6weVjRDZ5ZYwopwsReikT78SowLR+MI7eSwJW6qkp+vn/XUI5z1eDhhPYX
         UF6Cp/PEzmDn8p09ML9zPCwX7nCCAAIsJpjBCy5J+tKxhwMPWZhMEJNU856VgqA2oYHa
         s7TWUjlQ4gFxL5Gr7x4Pix21Ou6Bu5a/dB3rnYDXPz7p3ouEUy2s2UPoYtO1kN+ZfLLU
         s6zBJBK+pEM9FPJSenNHFR4U8Ns7a84nqXGcrda9F8iBuGP375aBeIabOk+oUlixKF79
         w/k618sTESb+V16D33DmFYnR1iIIaEFkZOwo/qy4zRndNsswN+4tgX87TPp0+yubUuS2
         IVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766363994; x=1766968794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c/H19Q6tBd0UoTOXIGQ7f4tfksWDWCO13hxwp5+fi/A=;
        b=griHgk8IVoNWlJUayZY5ugb8kKxzghzKxCtgEg9hiN49nxEV5mRLo6kwwkfComPm1r
         yab+0IWxr9cQmBbErI7Lw1txSYShsR7GaOi97llLnwYLmtOT696FkBdgrUnoEIqwMm7S
         6oWJvfGKXk6FcMAcz/Urs9GQLO3JzeCPGb0hMcITCfz418kUmdWfYGOdf7ehxnxEs42M
         GIKKpIcIdG6MXdng7nt1CBvydw/54ZZIsddxZIJvu2PdSnzh7Phox/n92TKjDVVnUX/m
         J+CzpqW0C/wn1F9KL/lWwLVVUlXFL1Og52si1DTHuW+bdTy4eCpI18mD+ArNEBBtGR0Y
         JJMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9cqJK2n16TPJUwUlC5NlV95PDLUwNf0r+x/WOjf4IICLd3ULUMF79q9MoFb7BMhdbUOW6JYIuMQ==@kvack.org
X-Gm-Message-State: AOJu0Yys+HUj/bNg/YIAwwOlLPAi7KzW5u5LqLsxizuLMraj5HVPskad
	Q3tgUu4mBO1t2nmM3kSKLU25uFwj3vtYd5osP44Q3Kkpxl/wepAe3Vst1I6QR/+6QdYrLJvp7ju
	r5LE7KOmIA+Cf0sqTs1Ru6IMel6/d7/Y=
X-Gm-Gg: AY/fxX7ENd/E1vDqkcr95zsJC5wsmj0Fh10OIkZIbY3bs51kJ6wOdA6ho362T5P1yoN
	79zfoGBSch4m+ljXfiT0jBqV5kpdmD8E/5LdjFsbqFlt87JGvaq4HccWPhUX4vXgGTHCr0uJ0XI
	FaMWrBcEq+N7IWYOSFu3B8lYPrTfll6a+uEDlUOsAbO8JAeXrfFUwiXsiO/8AjNlFx89mmYDw0u
	5Bkh2aRhvEZAz5SBf9j+YMiGUFC5QYWrEasmDIvp9SFGOHe9mrhwmFH55uXC+cS0vs9OTTT
X-Google-Smtp-Source: AGHT+IGkS9dOdEhg5+dCkmUmeaWzy4PZ0nHJDOAvsq+qfntVAU3c0jXqwzhWWTxM0175xdfDO/eCyt7iUEHIffnxA0A=
X-Received: by 2002:a05:6000:2089:b0:431:9b2:61c0 with SMTP id
 ffacd0b85a97d-4324e4c92b0mr10844629f8f.24.1766363993525; Sun, 21 Dec 2025
 16:39:53 -0800 (PST)
MIME-Version: 1.0
References: <20251220041250.372179-1-roman.gushchin@linux.dev> <20251220041250.372179-3-roman.gushchin@linux.dev>
In-Reply-To: <20251220041250.372179-3-roman.gushchin@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 21 Dec 2025 16:39:42 -0800
X-Gm-Features: AQt7F2oyBrROwRVLxqymS_B6UpKn5g9mpaj4yyV5pWKX0A3abRXIXQm-DHsTaoE
Message-ID: <CAADnVQ+T2_=F-885FtYZ1K8+UBfxmanExrfA+-0v4UdFVhmeDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/7] mm: introduce BPF kfuncs to deal with
 memcg pointers
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 579BBC000B
X-Rspamd-Server: rspam03
X-Stat-Signature: xicqf3gjk67nqi5rrik7qa5rkmdnumi4
X-Rspam-User: 
X-HE-Tag: 1766363995-903941
X-HE-Meta: U2FsdGVkX1/s8J47YRwQ9/rvRDOTK6bRfUMw4ayYaxTmbL/mwF0U5xxRrbz+1p3VdJj0Fd6jSsXvajyCBU+2XMqIjIuoogxMxN9/qTtOrynAhEdPqN67lONzl/COE4zAmaFnrn+BcM4+yQKpkz2gnK+uy8ybmDqA4LD4rK/Roz6DbLaSWv92D5BzGVFLU0nejXEJR6pJ7Q+RnyRFqU9Hq1AP37tLoSnQN2gm/6l9d1/TFrNpC3FkP7fTjnWNsGTNh6jL8GcPJSWZKNCyEWTagkmsy2SBaNaRUJ76OWr3okz66KF7vro2y1gdqXAeNz/MEca5BTTu+f6dauEAGnVLcluPwOqabSNEOxHBq6XBZUxZww38FKvs8VTV8j0ai1TZ8d5pOwgfqY+Wyj+GjHiNjlLMkzGKP2Mh/cNtpiOfrE5oii4Py3p0fTBreqOCVFCtznkO1JiBhwyFhXFtRbVOh6nWOd870wf+U38xkYQetgoHCuqA0Y2HO2xx/hLEDkcg27loMPnDfRHXXGd0ImOS6F9DzgrXQ2nSququ5ubAoxUQGHr4y46pods4lsfGyVKzwRD/X7ccBuY6TB/QVX2WZizrtFtQXto2tGZp0NWDGRcJCD5o4u0l6T3Wivpu1U7ySKI7T0VPawQgijK6SWp0HLNEDEXAMdiVw4ldN9Mi2qm/I0IE6e/E4oFJNzopHbDqYJjLHWRV+8F9VQ7Cs9P5PO2QWLYcuRKfg3YiXGSv3som4Hf1JlxVvTMTKnAqY/LvIPfQdhzw/qLAmOvoBZZx0K82dEigKynbOiXw1jbq/MxBgyhNTx7pfjlO61mZ+6d5AKvyKamDEEJ7KFG8wMkwLL6MQ5eQ+v5VmCRMScBWIEelk0XfjRPjVdYqq4J6DdLYR+FXv7oMLz+IFoV0N9SjjYaJcrXNbzbRwVSAc9S0ENlOv82W4gjBktNlx1IwRnfpusuPfMuqb6AX4BfOOd6
 SmZmgF5w
 2sRBuIDWTm2FskTW+iIONr0gieTASEQ99i932n1iNvHmnwdznn1Q+u5nEeYsjdxH4prC4X+vU+NHw9W76ip64BcOQdgt57qmlVW2JN+o2EV4Uq6NmOQA6cNDNeBhpAAr7bvdNwop66OIUhHeqg2ZuYhgry3n0nSlzgJftTH9453yNVwkIzjBmjZMUnr+MnEJNkt6f/XJjiSazq1f++o1Uc3yklDmEgzr8CxsuvPIeP7fH/sgxZEbWf0SIeRzUQabQOuVUQJtR3OITOo2CdrPdG5+M7iLvs7FB1czN2uvkGTLh0+7KrlJ//Lk0ExGSyK2l8dPgtXmueYXRqAhyAKimMNVR5g91i/IXDC6U4xOOigE7jMrunRglKLfydxrOi5u98mvj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 6:13=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> To effectively operate with memory cgroups in BPF there is a need
> to convert css pointers to memcg pointers. A simple container_of
> cast which is used in the kernel code can't be used in BPF because
> from the verifier's point of view that's a out-of-bounds memory access.
>
> Introduce helper get/put kfuncs which can be used to get
> a refcounted memcg pointer from the css pointer:
>   - bpf_get_mem_cgroup,
>   - bpf_put_mem_cgroup.
>
> bpf_get_mem_cgroup() can take both memcg's css and the corresponding
> cgroup's "self" css. It allows it to be used with the existing cgroup
> iterator which iterates over cgroup tree, not memcg tree.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/Makefile         |  3 ++
>  mm/bpf_memcontrol.c | 88 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 91 insertions(+)
>  create mode 100644 mm/bpf_memcontrol.c
>
> diff --git a/mm/Makefile b/mm/Makefile
> index 9175f8cc6565..79c39a98ff83 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -106,6 +106,9 @@ obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
>  ifdef CONFIG_SWAP
>  obj-$(CONFIG_MEMCG) +=3D swap_cgroup.o
>  endif
> +ifdef CONFIG_BPF_SYSCALL
> +obj-$(CONFIG_MEMCG) +=3D bpf_memcontrol.o
> +endif
>  obj-$(CONFIG_CGROUP_HUGETLB) +=3D hugetlb_cgroup.o
>  obj-$(CONFIG_GUP_TEST) +=3D gup_test.o
>  obj-$(CONFIG_DMAPOOL_TEST) +=3D dmapool_test.o
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> new file mode 100644
> index 000000000000..03d435fc4f10
> --- /dev/null
> +++ b/mm/bpf_memcontrol.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Memory Controller-related BPF kfuncs and auxiliary code
> + *
> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> + */
> +
> +#include <linux/memcontrol.h>
> +#include <linux/bpf.h>
> +
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> + * @css: pointer to the css structure
> + *
> + * Returns a pointer to a mem_cgroup structure after bumping
> + * the corresponding css's reference counter.
> + *
> + * It's fine to pass a css which belongs to any cgroup controller,
> + * e.g. unified hierarchy's main css.
> + *
> + * Implements KF_ACQUIRE semantics.
> + */
> +__bpf_kfunc struct mem_cgroup *
> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
> +{
> +       struct mem_cgroup *memcg =3D NULL;
> +       bool rcu_unlock =3D false;
> +
> +       if (mem_cgroup_disabled() || !root_mem_cgroup)
> +               return NULL;
> +
> +       if (root_mem_cgroup->css.ss !=3D css->ss) {
> +               struct cgroup *cgroup =3D css->cgroup;
> +               int ssid =3D root_mem_cgroup->css.ss->id;
> +
> +               rcu_read_lock();
> +               rcu_unlock =3D true;
> +               css =3D rcu_dereference_raw(cgroup->subsys[ssid]);
> +       }
> +
> +       if (css && css_tryget(css))
> +               memcg =3D container_of(css, struct mem_cgroup, css);
> +
> +       if (rcu_unlock)
> +               rcu_read_unlock();
> +
> +       return memcg;
> +}
> +
> +/**
> + * bpf_put_mem_cgroup - Put a reference to a memory cgroup
> + * @memcg: memory cgroup to release
> + *
> + * Releases a previously acquired memcg reference.
> + * Implements KF_RELEASE semantics.
> + */
> +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> +{
> +       css_put(&memcg->css);
> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> +BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF=
_RET_NULL | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)

This is an unusual combination of flags.
KF_RCU is a weaker KF_TRUSTED_ARGS, so just use KF_RCU.
We have an odd selftest kmod that specifies both,
but it's unnecessary there as well.
Just KF_ACQUIRE | KF_RET_NULL | KF_RCU will do.

Similarly KF_RELEASE implies KF_TRUSTED_ARGS.
That's even documented Documentation/bpf/kfuncs.rst,
so just use KF_RELEASE for bpf_put_mem_cgroup.

pw-bot: cr

