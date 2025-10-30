Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECBACCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 18:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C642180008; Thu, 30 Oct 2025 14:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15278E0153; Thu, 30 Oct 2025 14:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A9280008; Thu, 30 Oct 2025 14:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A15138E0153
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:20:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42BCE140228
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:20:09 +0000 (UTC)
X-FDA: 84055594938.19.6EB592B
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7C8B514001A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:20:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AqzD4wsG;
	spf=pass (imf09.hostedemail.com: domain of ameryhung@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=ameryhung@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761848407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=109chwgkwyzi06JaRr4D3LMqLJ/YTAxWxAAZVd/ElR0=;
	b=twjbT/zXujW5iz0pBjVm5Weok2BeIzEsnqqel2Y1xV6ArAlde+UHPt6up86XU2man8xCC+
	HDrK2MDy50N2c8GsFgdu9BLvYiza6la/EzcK0fLA4V5osCrBg1ClyYazHQ3migec0a1nW7
	UPLLVaM7W5e8jaq/5/qE60Udl3YEy0s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AqzD4wsG;
	spf=pass (imf09.hostedemail.com: domain of ameryhung@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=ameryhung@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761848407; a=rsa-sha256;
	cv=none;
	b=YywY9Azojn73cvWStGVAmAIni3V/1nfnuNM5MhvuMxHcda0SmdoR+dd/TH0zAjQe1zzs0G
	DcupfvDeJ9xBprQALBGAhfYtshuzkPCu0iB3eNp0CuLLVUemOc3KvnJmiVvlhCqykyIR3/
	IqcG/W5HmkVDNZ24rpKgcyx6GP6qqb0=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-780fe76f457so17197467b3.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761848406; x=1762453206; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=109chwgkwyzi06JaRr4D3LMqLJ/YTAxWxAAZVd/ElR0=;
        b=AqzD4wsGPwI+/AExAl/Ye6pK6Zjf1q8BLrM7si/EpI1fL/FFnJ/RWDFcw/kbD2nK1E
         AmblS9+4sQ+gCgMNTyMKQmJFh4OyuunbdAk7UxUR/ndPU76ZTlja4MxJza3G8eScN8u0
         yviJgA4g6tZeSZbzO6YxZM12og0tX6BvLNIpp1Q04ETZsRGDwO6alb3/SN4l63V4Bsze
         g0vjnTK+m/03iewTomP+MtQWAjUJvnSIj5vm2l//yvO5fHUPS5WMdK6a9CSYWN7aW37m
         IpkLOSaxoa8f8rLyfdIHU11GUHOiyyYbn3mvh9hB1/heStWOZIFTmPWOo096Pcv/C00b
         Ip6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761848406; x=1762453206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=109chwgkwyzi06JaRr4D3LMqLJ/YTAxWxAAZVd/ElR0=;
        b=B/YRRrGgLB3IiZChurNoH8DV4YKQymYBCByssW7CzVQLcTRq4rmcSKqbSd1oQsjYZh
         QnYPkQQfLzbw6lEZVSjyKlLaRTrj22pv3js3u7HlB3/RMSiTaBRNCa9iO7rLWQuyCUEF
         /gQlLepFC0wEKsYJl4MEfDwZRmpZ6pvNuAlgKucIP0O+456PdPcMOl6L3EFyOTeNl9Fk
         EdMwFl565Gb8/057vtu2fnI9/UQ1Gspm0K1Ce5hT1IxAz5wJZBF9VBu+XuFJ9zhV/g+l
         I8XQErpiNpDGm1A2A5XqpL2lgKBZHlh027HQpT90XKxRY8TXwzkzZtPcInOBb3daX8wI
         vRVw==
X-Forwarded-Encrypted: i=1; AJvYcCXwVVB7S8GhqZe64dzVl8lge8h7w/tXsriZjTMXEWDLLcYwDl7gHcRcGFCppPyVq1ft3/ESep9Ctg==@kvack.org
X-Gm-Message-State: AOJu0YxXPmgde0Nz5t9x7QtVjVNz2yYbXdMwCa8TZbfVJe1E5pDCHnSd
	f2zXhzvvrzKbxyG7PDXEoCJwdo2NtmfYRP83WXtt8BBsgFeO3YCB+XteuKH0C1uo/XPNCriUsl/
	4dp2y9efGW42adt141Djg9tr2nSLLG6w=
X-Gm-Gg: ASbGnctgsKnhURPMhGBC+ZqDb9ruj1UASCRQhaanKFclPKjz22FGWP1dHeGoihI5bP1
	JDRy94xvaBw/DHO6aZKqmKXTsqPsZFeJB3deznVqysBdtCCnacCsLIrxCXgObJ7lMDxmRo62Vkb
	41Ho3iG5pGLdPZ+EST8ISwKjWQlbSxYhlcJQpvqFmOrC3TKl4Bpt12GOUr4yBad9fXP7g9ChF1V
	76Ija7hiXDhPN+WSllgt0zVEBUiT54ceSM6sUXAh0JMxTKxpbucfxbT4mR2XEglR9lWMU9crgWR
	POxi1mqSgVY=
X-Google-Smtp-Source: AGHT+IHKbL8ofjlCsmGkHmIIbYHwwwbI3UCw8KC2XPnz0NNn+Py3t0X37OVPJ2XMR6wmDS50IynVTGupm5236DxxcP8=
X-Received: by 2002:a05:690c:6103:b0:785:c086:aa51 with SMTP id
 00721157ae682-78648435fc3mr8623737b3.25.1761848406521; Thu, 30 Oct 2025
 11:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev> <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
In-Reply-To: <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
From: Amery Hung <ameryhung@gmail.com>
Date: Thu, 30 Oct 2025 11:19:52 -0700
X-Gm-Features: AWmQ_bkLArZ_9Xo7aHFRx3Y_Fcg5RHa9nGJniHAp-qT8VVY1Zm9_Hwf5WmIwP68
Message-ID: <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Song Liu <song@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nn83efh4nopnynwc7p9wheppj5fpood6
X-Rspamd-Queue-Id: 7C8B514001A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761848407-275899
X-HE-Meta: U2FsdGVkX1/c6ywy13Ch47h10vO0yhXj6HoswfPf4+VZ84JIGmyBwCtHV2qa2rzlUApZfpABTGFcVFf+8U/RKYzIk28kzL5E+J7imYEUvUhTOD8itHF/GcubCLHYLCV652tqVDxkcEGrQUM/EfXmwAiDNg26ZETXMb+nEmYFPeyOY5mYhB5185pv3LD/SpMikPC13LpliZmYuZRlM6UuEZjzD9w27ZxQfx3DS2bmBUupXCpemxsd8wdm/jOOvkgJvmas7lDEXdhTYF1HRZVSzimZG5VDQVayy2tUCSQvRHGXbev7q5IWCjda67AcZEIfrSin5UvhuIEjPogdVTXxQDaMlzYGkA48m9mz15WywUyW8eELucAiTNRrGKjOiMVeXnOPnBDAHJas5YSlRuXOs4Kmg9fTDaCr/IQA58MutxeQPkilK+ZXC0Z012ZuKmDL4XX3aD8lxwSVXEdvouKuzUQ97WtHmWVXqXuvR62ZL5PgJ4aYCQI8fhYx9oSVu8gc7zMH5I29jPITdvT6mtNQHRMUehLK7v1gkoeDZ4XHMIekIwi/ubxBwH+ewJvTxLIcRF98abodwc0QHAHjjv+c6K0mYQe7A16jiLSMbzEgvh/IDnXB/m5A+KMZ/4CHnR3LTBEsMcp6nDixB7Y/Wr5sBLXRUp0KepOX2ICYYJ8OTkmADevmOFbHJg7wXR3gv0K3/jD4ezQRQXezBaV+nm3wvQgz/vpY6O8XuGa8hTwgWicBOozFZHDA0qAoWHd4Y3bnFKycizIsqKQrKEoU7VXEk3uze/S1ejTJSSR+gOXgTMhX77FGjp3aJtS2i+Ck1x8YD6wjU4A6N5MfIUv1sd79uzh1WU7nqepFQ/pgafIYdciD6AN2e67MzXQveGcL6BZxN++HHLyErEE4K9n/cdLYScgJRTpEeC2Xru/9VnppJ2glVsIOJu/lISv/8hzR0ej3adLq+Hn9F6F7+VmNUIk
 qAw/iigW
 NpyfnXadHYns7Ozw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 11:09=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Thu, Oct 30, 2025 at 10:22=E2=80=AFAM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
> >
> > Song Liu <song@kernel.org> writes:
> >
> > > On Mon, Oct 27, 2025 at 4:17=E2=80=AFPM Roman Gushchin <roman.gushchi=
n@linux.dev> wrote:
> > > [...]
> > >>  struct bpf_struct_ops_value {
> > >>         struct bpf_struct_ops_common_value common;
> > >> @@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_attr=
 *attr)
> > >>         }
> > >>         bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_st=
ruct_ops_map_lops, NULL,
> > >>                       attr->link_create.attach_type);
> > >> +#ifdef CONFIG_CGROUPS
> > >> +       if (attr->link_create.cgroup.relative_fd) {
> > >> +               struct cgroup *cgrp;
> > >> +
> > >> +               cgrp =3D cgroup_get_from_fd(attr->link_create.cgroup=
.relative_fd);
> > >
> > > We should use "target_fd" here, not relative_fd.
> > >
> > > Also, 0 is a valid fd, so we cannot use target_fd =3D=3D 0 to attach =
to
> > > global memcg.
> >
> > Yep, but then we need somehow signal there is a cgroup fd passed,
> > so that struct ops'es which are not attached to cgroups keep working
> > as previously. And we can't use link_create.attach_type.
> >
> > Should I use link_create.flags? E.g. something like add new flag
> >
> > @@ -1224,6 +1224,7 @@ enum bpf_perf_event_type {
> >  #define BPF_F_AFTER            (1U << 4)
> >  #define BPF_F_ID               (1U << 5)
> >  #define BPF_F_PREORDER         (1U << 6)
> > +#define BPF_F_CGROUP           (1U << 7)
> >  #define BPF_F_LINK             BPF_F_LINK /* 1 << 13 */
> >
> >  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
> >
> > and then do something like this:
> >
> > int bpf_struct_ops_link_create(union bpf_attr *attr)
> > {
> >         <...>
> >         if (attr->link_create.flags & BPF_F_CGROUP) {
> >                 struct cgroup *cgrp;
> >
> >                 cgrp =3D cgroup_get_from_fd(attr->link_create.target_fd=
);
> >                 if (IS_ERR(cgrp)) {
> >                         err =3D PTR_ERR(cgrp);
> >                         goto err_out;
> >                 }
> >
> >                 link->cgroup_id =3D cgroup_id(cgrp);
> >                 cgroup_put(cgrp);
> >         }
> >
> > Does it sound right?
>
> I believe adding a flag (BPF_F_CGROUP or some other name), is the
> right solution for this.
>
> OTOH, I am not sure whether we want to add cgroup fd/id to the
> bpf link. I personally prefer the model used by TCP congestion
> control: the link attaches the struct_ops to a global list, then each
> user picks a struct_ops from the list. But I do agree this might be
> an overkill for cgroup use cases.

+1.

In TCP congestion control and BPF qdisc's model:

During link_create, both adds the struct_ops to a list, and the
struct_ops can be indexed by name. The struct_ops are not "active" by
this time.
Then, each has their own interface to 'apply' the struct_ops to a
socket or queue: setsockopt() or netlink.

But maybe cgroup-related struct_ops are different.

-Amery

>
> Thanks,
> Song
>

