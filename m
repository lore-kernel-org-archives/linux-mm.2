Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A794CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 11:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD54D6B008C; Tue, 29 Sep 2026 07:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD826B0092; Tue, 29 Sep 2026 07:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C3E6B0093; Tue, 29 Sep 2026 07:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 738C76B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:49:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B748404D3
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:49:46 +0000 (UTC)
X-FDA: 85266630372.01.77CB809
Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 736C4180005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:49:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="O/bZUHlL";
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790682584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PinsfWb5o3H1N8+JPrpcg6f6Oxc9ozJUPh0iCkDqvJw=;
	b=t3LOwiK4BT//cqKYxSVthybCWUx3f8g/l2Xc31ehndr7ir2X/R/W2LAiXuM6A3iJL4BxJJ
	BJtfmrLXQWK4cSq8AxNXWGPqVExaCSOXP0DgdVMJN/fQwGHNd4+Gbt3Y959DMYA68xCR5R
	iYzpIkQCdA88rlYjLTQ8EyHbUIprcgI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="O/bZUHlL";
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790682584;
	b=vknGVXi9LkbX2PkD3yLz6cIbH5nvbuFqtVwV60eXyy4FZ7jREnuQPQ/nuxdBUgViCyY5ME
	7zhn0lO2epTbL2TM8l36HoHvWll0jrHsMykrGKuimedDQniKOeTKpumwV1cUtjrL5iQdfw
	tqSeVu6BaD1FYXMJNYydOq1cJfrDW1Y=
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-6729ca45e37so4173092d50.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790682583; cv=none;
        d=google.com; s=arc-20260327;
        b=fpvHfBHafzzp9nYkLsuqDaKjI65ukmX/Gxz2LGJek13+o9viqMpglLgDIBEIsxokEc
         iJq4r3mRTCvUJm5wyHJVPRr1GlD2EYfATTNKofXQ2xq8Cj15DnLxh3n4b+i9Zmy1wLTu
         xH5aXLpqXr4u4RtTgc1K3uS5lxVQcsgo9h0AKDPmmvJd1zb0i3wJ7xrLkrgx4JZ+HyA5
         lvvkthGgW65gBmbYxTy26rW2CStnUA3XGpjB726+TMi5K+UtT5TzLqvfKVQfLwL69za/
         Ydgg/kSKevTaTRrVKV9UmN34MKDg/yhNQsfE60oyuMdUgxJpXi+Hzhx5cqS7bu2V4dPr
         iwRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PinsfWb5o3H1N8+JPrpcg6f6Oxc9ozJUPh0iCkDqvJw=;
        fh=pkuUq68pwRsMwlYkOc5qHBZbMJg+KqbrXapK76X5HZU=;
        b=rnN2O9v+GYwKpc/oU5oIr2Ld90uNVLTsapA7SH4Uzs/TpuCMSznF9ybLSApPCZxn68
         YSx5pEsJNOZbxWYdj1aQown4ymG+4MoC6Ewh1BDOWUnq/N3fI+3BxQ5fx8IOAZw9wZLR
         Vqec25IbQTo13HMvxXmMqfr/IUeogv3Cgeyw0WMeEn3MnqzW1LXA2BhtQ8dW+JoCBV8t
         zDSe1Rf8lo1B7SER55OVPsp85qH5WxfmGy8k89FU4A68N/0p0m3C6oJmFT3tvMRrsJkg
         tz0sA30T62sUTtmDFxQBw51MNVHeTtZUwqJmS31uP7XDT/6BU6EXWGOuvPVi5QA43eMi
         BvTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790682583; x=1791287383; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PinsfWb5o3H1N8+JPrpcg6f6Oxc9ozJUPh0iCkDqvJw=;
        b=O/bZUHlL+KtQT0PiT39FkXUyOJI4vL28DjCu0RRyxvrU692ZsWhAL/NmJg6z8Y7BQE
         wAohdacyzM8XAhOVRkXu8/L4H8zqWEzmInxTongn8GN6J08d5v7MY5M3EdqcJxwpdvxp
         kSzD/mzO6fZVQ73mMYa3vV714AZMkklFJ+KExuGPZR+Z9bfvHC/4kAKlXdnQwXpbrgfS
         RAkB8zo750/MwaaGoI3C6Z9fpHJezj9Y9NMKXWERZ72tjocK8tNoHB+TFN0Oqj6GoX2e
         z/9KPD9znHHKIwe/xuTclHHWDEzuuEavaYsu3xaBWrPlZvZgUsZhPGP80e+Xfk+WR2WI
         t17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790682583; x=1791287383;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PinsfWb5o3H1N8+JPrpcg6f6Oxc9ozJUPh0iCkDqvJw=;
        b=2UrLX10xPqCgFgij+ooFZX0FnSO+XzUS59MR1GLmz9aUmczFB68HdmPYqWQjsf18xx
         vh4TZccOj6lFXzBnDIHpd6E6sufK0J24moHK/W4QpTxBBUJMy+tOyxjBNPcHE5M8pQDF
         lajhgi7LJNpuwrBv/quRRqxxvcu5Y3tEPhTSvAR4GOtiiPoQt4cyKxRek/bfdkE1I/FX
         N9tH5B0jiRmyujofIV4r539LYaDB6ztHIS7+cl3/XiU6+uYXtddLlkO/AfDc8nFHsAO0
         8dProjhVTaLJ6KhYxiJk/CGcEGtWLM6W97atdGvw3OBfI4P2mbLihS1UUdBapfv2sqyQ
         Q+6g==
X-Forwarded-Encrypted: i=1; AKwUvBxpTKv1sOrepWltaLyENAUjy3O8/IbIz20D4jD+CoDWAyMO6CpqLDST3ubEuIwj4d4zTeRbUp3NpA==@kvack.org
X-Gm-Message-State: AFq9FYIlHFkwiAR45uN40nfEwkc69EVqsaxIDHx37nHWw2D/cj9V3h17
	xEYmVHdPwem9pJzezWDqagNQaGSRBw6cbtR9OLWeUW5G7jjp55O76t4aLF+8Q8nozigBJ4iwCZe
	o7u4xnrBD0b54F1EAeStaxvXDRI4KcwI=
X-Gm-Gg: AYBFou0HT3yXj7g75BGD4rr4LxRSO7kxm4VJIZ7eQb87PKX7k1/T+EEnNsL84cOlBH8
	4NRuFbwNFftfPrbpzWPhjTMyA9eqI9JVQAQS7vTLUTrUtznQbAJzveo4pD1GrcyFABFXxpAuwT0
	BV5+ABh/lPju40bC5Jpa+HA9NgegwkhuG34Yla4KxLAdmLx9KsgFrGhPA/Lif/bA3XPrF54HFJB
	XsDfyAqfXGq7XY7xh6c1UD0phHbxwdc30rd81ATRmidURdMg3MSg8Y/3Ndr8qm8TXDNwedOZa2J
	8826qEnKwNgC98P4foV5iMG85y9nuOq/aF/gcWEb/5kbvK14hbQ6BeADBgrQi8KZ3M5S39GHq2n
	0YrDCKvsiiw==
X-Received: by 2002:a05:690e:144e:b0:668:9230:e266 with SMTP id
 956f58d0204a3-674112442a9mr4372761d50.46.1790682583424; Tue, 29 Sep 2026
 04:49:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260921192559.2619635-1-shakeel.butt@linux.dev> <20260921192559.2619635-2-shakeel.butt@linux.dev>
In-Reply-To: <20260921192559.2619635-2-shakeel.butt@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 29 Sep 2026 19:49:02 +0800
X-Gm-Features: AclHuK-nFEkgx8S0aZZQyW2aKsafwpBB_ccNYji7zHIK6DtT7XurPCTCqUpsYEY
Message-ID: <CALOAHbAb_aKHNxKV3ecUW6ZxK3VR8XAwxD0vHiaZa__6e2pKwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] bpf, cgroup: fix cgroup struct_ops query for a
 second attach type
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, 
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 736C4180005
X-Rspam-User: 
X-Stat-Signature: fe7sidndamzore5usbu84eig1nj6zxcs
X-HE-Tag: 1790682584-726373
X-HE-Meta: U2FsdGVkX18zcuV5dpWg6nMNFYd5WJxeXTQZQqgHlY1UZwqsEi/d1k0+cuArr2vKdqj2QFIpQVMjO6rciSCyqWU/LqYjqWqb2x9qWDZAJnqLSG0bkGPqEWNk0ikNRCd3D7pyXN1lUhivsJHv6mYNoXDjyfF9sWjDQ2DXUx1WUINxolKNvHqs6n9JYEMS4wLp1rpe1Q+BqPus3YGiqfH4JIkeB7YHdZacDZ/5OTYjJEIYFzdCR/Us1AgPZpFILzV3sW3oSOrDCeEnJlVJbqCX5M+LOk1MiuSYONg4jkN/o870EW2nkPAu34kYXjudij03XpevqQTLZ4C8gauz/lqq0nwF8ubibSUbUgY+vubXdaldUSyknnKnQ/Ub/C/wM6JVpxii66S186oTBU88SHK2R+TckuiD8KYvf+Sk4Hdh9hRvXcmGzy0tLSLCpcujcWmE9bndy9SM0Em5MV3y5SKtraj6QsPNoYc9NkrKvJMhVIyy3PZAJJiC7X0t8/9QrJck/PIi57UyiHtdGynOw5n0AOiuEOivEo44qa4KRu8/Y/n9wh0cW6uJ/WrkPVwQwaK/9HAk+AsaUIe5DlcaJDBdl2+p43uGecsFv9FKC30+zznQ9ZmAMQF9TRl2IMJlzQe+kNgN0FjbJ5RtqG/QzAYJD+40jxB3ToixCI/EGGFz7D9NKiOQfBZUwSMx3T5X14Gn6vzv4StOuT4p9j8HX6PVAaZu1VN0yeKRWdwjFLu1/pS3rC3lGk/lIXFr7gfzD2fLnfVE/k8NkVPnCyjafaj2y2VQh/hPS6NZrU4B4QtItc6OaR3IVfqPT0P2/49v53g3HX0Gg2gDFwVGXBwbuGbdRcDAGxyvu4Zg6p9mmAng0sv0+qM5va5Ps8hAcA7402RrbIjdLUrJNrxnjSRPqQ6inNgREhoOEdPgNmTG2xPi2lLmTY4eaODMU27tivEo2rwfP3VgzK9j5gJ0zK8HvKO
 5H0rFxMi
 6H9OHd5qHL8woODMX6/+J8t73F/TKZF+FOWr646ruZgIjngrvFPPZS8lTA2beQZUvG389pq+vjTGFCXQVnBlHccsTGtS8X5OtDkcEwcCIu8EWlh8Zp+vfXThaSuifBP76aJjasev/XnE5aINQ0Iy2NJSCqxYBl4w63dn+m7WDs8lv3inuGy9DktenVugxvdJovLDB8Y+gbLpBS9xyVDZP8/vRoH4RUq6c8geo+tu3dNvIb/PWFhukstzki5mdq9BtUv2Mw8vFb3npT9RRPQ3HEVgBudLnAsIIuA8mMQoVXl9g0woqhJMUZRHIyI3IQf/ZoECKgYt3KUruzQgdefBchiXGQkLiEBQXRfkgV8Zeps3ZFv0fPM0bYMA0Agl0R9b57SEX6SpAh8DszH9ga5T4VQttXWO40frtC64XWVYSlaJfkIJwrWrtTe0vyeJTsyGMF3rOzsD/3lw6xIfcV93200NA+MsjuuDPXQtUZ1VJUaV5ndYGVFJJZrjF2fIFZtkAUWSsSzI8Jy+JjqVoYYUy5A8R0IvA998A8nekQXw2nBRjBbPLAqnq6We9jv0msH/cSH966fYUxy+migk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 3:31=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS =
is
> the only one struct_ops attach type.
>
> It calls cgroup_bpf_enabled(atype) with an atype that
> find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
> goto and needs a constant.  Today the compiler can see there is only one
> value; add a second type and the build breaks with "impossible constraint=
 in
> 'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead, a=
nd
> use it here.  This is a syscall path, so the cost does not matter.
>
> And find_atype_by_struct_ops_id() matches on type_id alone.  An attach ty=
pe
> whose subsystem is not built keeps type_id 0, so a query for type 0 finds=
 it
> and returns success with nothing instead of -ENOENT.  Skip such slots.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Yafang Shao <laoar.shao@gmail.com>

Could you please send this fix separately from the series so it can
land in bpf-next on its own?

> ---
>  include/linux/bpf-cgroup.h | 9 +++++++++
>  kernel/bpf/cgroup.c        | 3 ++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 8a75a6cd7309..3b2c127d401d 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -76,6 +76,14 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_=
type)
>
>  extern struct static_key_false cgroup_bpf_enabled_key[MAX_CGROUP_BPF_ATT=
ACH_TYPE];
>  #define cgroup_bpf_enabled(atype) static_branch_unlikely(&cgroup_bpf_ena=
bled_key[atype])
> +/*
> + * Same test when @atype is not a constant.  cgroup_bpf_enabled() uses
> + * static_branch_unlikely which creates jump-label site and requires sta=
tically
> + * selected key. Since key is selected dynamically, use static_key_enabl=
ed here
> + * and keep it off fast paths.
> + */
> +#define cgroup_bpf_enabled_runtime(atype) \
> +       static_key_enabled(&cgroup_bpf_enabled_key[atype])
>
>  struct bpf_cgroup_storage_map;
>
> @@ -508,6 +516,7 @@ static inline int cgroup_bpf_struct_ops_attach(struct=
 bpf_map *map,
>  }
>
>  #define cgroup_bpf_enabled(atype) (0)
> +#define cgroup_bpf_enabled_runtime(atype) (0)
>  #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, uaddrlen, atype, t_ctx) (=
{ 0; })
>  #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, uaddrlen, atype) ({ 0; })
>  #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 696b27383974..99b4e96f5db7 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -45,6 +45,7 @@ static enum cgroup_bpf_attach_type find_atype_by_struct=
_ops_id(u32 type_id)
>
>         for (atype =3D 0; atype < MAX_CGROUP_BPF_ATTACH_TYPE; atype++) {
>                 if (cgroup_bpf_is_struct_ops_atype(atype) &&
> +                   cgroup_struct_ops[atype].type_id &&
>                     cgroup_struct_ops[atype].type_id =3D=3D type_id)
>                         return atype;
>         }
> @@ -1448,7 +1449,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, =
const union bpf_attr *attr,
>                         return -ENOENT;
>                 from_atype =3D to_atype =3D atype;
>                 flags =3D 0;
> -               if (!cgroup_bpf_enabled(atype))
> +               if (!cgroup_bpf_enabled_runtime(atype))
>                         goto skip_count;
>         } else if (type =3D=3D BPF_LSM_CGROUP) {
>                 if (!effective_query && attr->query.prog_cnt &&
> --
> 2.53.0-Meta
>
>


--=20
Regards
Yafang

