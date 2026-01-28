Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B9A4D35668
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 03:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08B86B0088; Tue, 27 Jan 2026 22:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB25F6B0089; Tue, 27 Jan 2026 22:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5CC6B008A; Tue, 27 Jan 2026 22:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9776B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:10:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37825D38FE
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:10:50 +0000 (UTC)
X-FDA: 84379895460.10.4A41F61
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5C85720007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:10:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sq93yZio;
	spf=pass (imf03.hostedemail.com: domain of joshdon@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=joshdon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769569848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/5XNX0NIr83WC5bOdhhJC5S1PzkaEr8t27CnKmRubw=;
	b=7XM7HRCpwAVrir76TaLc/AuUmz55AmuKPEtH6DzCmDD2Srz3RZLI/wga6JpiBAdNYacJgO
	9LoWbNCjCfkE6ZIHHssS7A8+k5Xu5PQIWv6NYnWqwaiWgUuWI9aBvbyT+Pv5VgLFZJ6Aje
	BgVb8WcnncP+aPkV4q1Te9aKASEGA1E=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sq93yZio;
	spf=pass (imf03.hostedemail.com: domain of joshdon@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=joshdon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769569848; a=rsa-sha256;
	cv=pass;
	b=RB56XGsuJCzIKoag/bmJRSgWMQyqg+1c45gdydTC3/1G+2PznS3JdOBh/OdPuaynyLc9M/
	G0Xif3vQA7/pqp+kMZiQtlZbfL3RTBEM5wXBy/rVF33rLQz28D8G8ZzWkMOKL4dlD20w7z
	ilFPZliHjt52q9vAh3DSuX14kQrn3BM=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5033b0b6eabso75161cf.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:10:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769569847; cv=none;
        d=google.com; s=arc-20240605;
        b=QM+CAMJM1Hp+PbDokkr4AMMTrxgo3D4cT8r+JV9vZTG4FC/bx1Qs+HxYweXBir/8QD
         KOY7EqlJKHZ/JcOGPJ9m9X1aJ2X2Q7PQHTwXl2bLu/rpGedLXIDHe/4ObPiRqubFsDUb
         1tdhYSZiHFQH5GYw6PoSNhwJvZsoPrF7SzXtViRTNCGgi2xv67B3ar9ukeRT8hoMYjpr
         g943xzQ1adiBYYuoFkVRTRAnVLZBtaTgJmNeNoaNSsZ68WVjTNpWlUxV/VcGpB4dHhwo
         xlapNsbVLyDJ1gqqOsZYcPyuYcHbdUt8uMIqE91vr/c03OBdELBzxQl+xCm+sXIg/svO
         Xqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5/5XNX0NIr83WC5bOdhhJC5S1PzkaEr8t27CnKmRubw=;
        fh=NlNJHSXoz2nxMPPf+B6l/38kTkTbuq9UoJTU6IZ8nSY=;
        b=lLBqvddqz0TLxRUjJZuuuP0dnIVuq3ZCZ2cdY/mHaeeXgTbztA/tvAwlu+VdRHJisg
         +inNoPaF3mwLl0uHHJRlPSeD3KyiVufCgwJERYFDYKOlhh6nQNaMULDwcg50PYn/9rpr
         AKqJhyAX200L3+/+u6bI477p2lTndTH8RVnUw1jJaX/F8vmzvYrkid5KdVxTZZIl4B/P
         o8rf6OJfpGWID0Aq6IuwDxaX39ba6AWhDGvujBSWYePZeTps8Qig5/CyzKvU8R/CupRI
         VmlDpS3nsij98sGtxR0tQZAadkKo/RyieLv/1AnYcAgWJlxDqpUtLlZCu15JsU0CM1xA
         Yb3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769569847; x=1770174647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/5XNX0NIr83WC5bOdhhJC5S1PzkaEr8t27CnKmRubw=;
        b=sq93yZiogS/t+nVRBhU6/ajTzYj4SyUHBDfzWMuOAuwWYtQKoOKpt3PKHYmE0CrYDx
         l1Aoc3CtMFsHThaBfDmIqyXYZSzOrf+9wJfSaMGmRVYexe+FgXLcxh2Emsoq5UBnHK6g
         iPdkMJAOh5KJWl45biNIdtIBzsL5zdv3WFEdePWBuwkqwgzfzpi1wq8oRtAwWE+PNFtj
         uiy9UL2/EGreOjohySIbxOAPobRedtVYgfhTVY9HgNlOvDUrRxrNYrs8bq3Zamjn0LtB
         i2u+jPezPvBAR/OzByuT5S6/u+c6pyGLU+rI/4v8stsyojM5CyI30EwHsG92WFNCSuIR
         EpNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769569847; x=1770174647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/5XNX0NIr83WC5bOdhhJC5S1PzkaEr8t27CnKmRubw=;
        b=QM8TWRy0VKhaGbIXxDwWV1uZr/Q3A+QDXq+6vbvXrvCIfa+8jLV4VKr1xa/cxVBnoz
         YM+kPpqX0nDpp9wIaai88qERqst/m+3Gp3qm9nUz9NqHIkmheYRKlj3T7AnmJi0pDdp8
         nerh0Eyo+yM3aL09kPruHJ4WWqKX9k1xtQ0wEwhNokCiTCo9Wg9SfCni9m6y9u/DUrpS
         eN6frs8Z28T2GQQTEHA2xDjONXdHTEXArxA3SXg9j7ktscUBTyXV5Ced35SUPr/GcdSF
         ovDsg+QUW6uhC/RNEFBAFXGneMcRTwWbtZfYNsRDcBmPG7cHrivkXRIYrqfgLdYmisXP
         oONg==
X-Forwarded-Encrypted: i=1; AJvYcCW2XkDesWZ4hxfxEmbIkRIGx/XUPKJZQqp4ZbLxIlwxXJuHUwWydj/tY74Xg7rO3bCJjfAZq0wXJg==@kvack.org
X-Gm-Message-State: AOJu0YwtUKA8189qbWnHfIiTeScICVI1Xhnk8VLSyK5KU6S2mQ0vuaiu
	6qwAcTItDBMx0NvB0K56Z0RVMOTs048vADu0fHMc0NgiBW5t/jOiNRejYvo7ZR7f4+rmi0y6sIM
	BYwfebKcadjTdoTQSUtyd8i9RQawIbGnK6aGYouCJ
X-Gm-Gg: AZuq6aIC+cKQKUNfc917UKTzcT4eQTinADgGUxhP/Db446yjBzUdRv77DtGz96WeavX
	AvqmGnMj6sz4NkAg8KFFtPd9Mui5/MG+O06kPIH94cCFW1IqIFVNWpOG6IAHm2Yg6OuUC/JeyiI
	n4hoRQOtIXAuZ5xOa9wZTr7XOsk7Yxv7fGaim6JI9dzMfeuCawc+f/BLqOhop4a/HhrueI6ue0R
	cEZUvm1J5StCY57wLXCuoK0VoI8sYhvdTsUDNmPRrL1DExB3lJ1okmyHLJl8JR4UhSkeo5W
X-Received: by 2002:a05:622a:14cc:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-5032f4c7effmr16160051cf.9.1769569847132; Tue, 27 Jan 2026
 19:10:47 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev> <20260127024421.494929-3-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-3-roman.gushchin@linux.dev>
From: Josh Don <joshdon@google.com>
Date: Tue, 27 Jan 2026 19:10:35 -0800
X-Gm-Features: AZwV_QgLB-AwxBPbb9RgtshaQD3BxstmR9oUwNC7yUpAS1o0R_J-bs8gRUVrEaM
Message-ID: <CABk29NvS+4F-a=Z7Jp27OUZCJ2YUWR3LJcwT-NBoWYAK8JeCEg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: allow attaching struct_ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 1fnrb395ub9ih1wdzt9ny7es6dhda3yo
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C85720007
X-HE-Tag: 1769569848-53849
X-HE-Meta: U2FsdGVkX18ZwDt+WKMDjoOJyri5KlK874dNVv5yC48muVPrcpxAEuSKj0kJXlXOsiMQCVxnKVyji9opcyiSuSmVIBse/8RpOIgBm/8PTLymBlOfBNWeAVFYQqoCqc2sVEKxuY9Awp7xH0OtXRXdsQ2+xHJaFSxu61q0OynNcKMx6J9J7/qLV4DQulYsRLQulMIW6krVTCPWSmStcKIun812H7pMUFOh7fzlhs32enrjHQzF4pOn9m5kXvcI4ak2B4jr7gWAuquVXFxes23XKWofhL2sAHLOYiSgPAU+uKqohp1kHStcydJ4HzrEHh2dNcfbrAjfPFRo5NZYoNHS4M7o1mZndt5IWTKYeDtp9newOCxJtXr4TkSP+JYfwZ2JSP9f5CW7qwgHgonRwVqpWTufZUJM6jbz1xcT/KKQsgygiJ1WpvemT/6d8ysJw4w9LAky1/AfD/wXaBZX9djL46Lol93MnD36lvSLOw3lNHkAyfSuMd+YqWPQkg6/3kqUFx7Xd/mYnQuVmrbIBghJnxIIxOTNQ6toih+n28iuQop4vVtImg3JojJ6jrP9oh55+Lwku2O1oVcHQgWXIck8LqsAx8r8703vWqlARsMhGBK49dKwLbdXHn9QxaGho1bMJvCmQWwIN9w6WrwyWQixPSgwkU42iyGIPDEkAJcYC9r79Eo5t7SLs8jGzbSlnePdDqwzDlbaJLvVabcBCyo7/Ip2yx1mzRCKQQ5YMjpVXx8trFHVYUjt8tTnnlEUPeZIjQ/V39mXFPo9Ko1SQyp0qY9EOOGExTwxv4w+RC682ttfCz2+Wlu7ySUbmVNWjHhlSw5Qjm/IHzImm2C2fh8fzay3dcaV67/3qUtTroJi0ILAepmb5YEfK3w+IrJJZ66ULu8i+OgazWbMpFw8sQKibfYR6WiZYGNlxOjmzAZVVpBCVvCWOtIoCFYB8ihP3i9+mOi90sZ5H7w8e4PAsFM
 kaoSSWIk
 6wnzCCTJEYxH16l4nNS4bcp7rYzkpOGgpA5wi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Roman,

On Mon, Jan 26, 2026 at 6:50=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Introduce an ability to attach bpf struct_ops'es to cgroups.
>
[snip]
>  struct bpf_struct_ops_value {
>         struct bpf_struct_ops_common_value common;
> @@ -1220,6 +1222,10 @@ static void bpf_struct_ops_map_link_dealloc(struct=
 bpf_link *link)
>                 st_map->st_ops_desc->st_ops->unreg(&st_map->kvalue.data, =
link);
>                 bpf_map_put(&st_map->map);
>         }
> +
> +       if (st_link->cgroup)
> +               cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
> +

I was worried about concurrency with cgroup ops until I saw
cgroup_bpf_detach_struct_ops() takes cgroup_lock() internally (since
you take it inline sometimes below I falsely assumed it wasn't
present). In any case, I'm wondering why you need to pass in the
cgroup pointer to cgroup_bpf_detach_struct_ops() at all, rather than
just the link?


> @@ -1357,8 +1386,12 @@ int bpf_struct_ops_link_create(union bpf_attr *att=
r)
>         struct bpf_link_primer link_primer;
>         struct bpf_struct_ops_map *st_map;
>         struct bpf_map *map;
> +       struct cgroup *cgrp;
>         int err;
>
> +       if (attr->link_create.flags & ~BPF_F_CGROUP_FD)
> +               return -EINVAL;
> +
>         map =3D bpf_map_get(attr->link_create.map_fd);
>         if (IS_ERR(map))
>                 return PTR_ERR(map);
> @@ -1378,11 +1411,26 @@ int bpf_struct_ops_link_create(union bpf_attr *at=
tr)
>         bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_=
ops_map_lops, NULL,
>                       attr->link_create.attach_type);
>
> +       init_waitqueue_head(&link->wait_hup);
> +
> +       if (attr->link_create.flags & BPF_F_CGROUP_FD) {
> +               cgrp =3D cgroup_get_from_fd(attr->link_create.target_fd);
> +               if (IS_ERR(cgrp)) {
> +                       err =3D PTR_ERR(cgrp);
> +                       goto err_out;
> +               }
> +               link->cgroup =3D cgrp;
> +               err =3D cgroup_bpf_attach_struct_ops(cgrp, link);

We have to be careful at this point. cgroup release could now occur
concurrently which would clear link->cgroup. Maybe worth a comment
here since this is a bit subtle.

> +               if (err) {
> +                       cgroup_put(cgrp);
> +                       link->cgroup =3D NULL;
> +                       goto err_out;
> +               }
> +       }

