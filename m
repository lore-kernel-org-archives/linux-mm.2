Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D3F7CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A208E0014; Wed,  8 Oct 2025 05:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAAC8E0002; Wed,  8 Oct 2025 05:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9998E0014; Wed,  8 Oct 2025 05:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3A2A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:05:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E66F1DDC24
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:05:24 +0000 (UTC)
X-FDA: 83974363368.12.ED654AF
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8AD8CC0007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:05:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZDw06kFJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759914322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4cYZmadA8mCAkJgxHGzRBrmoQCHtUHFnir9NGk0Mxs=;
	b=qXZ9ThWb8wk3kf9eipt2enBT+W0OwnasC1Ef3ISwaDS4930kSuuDmUbQ6BERGHXmoEmrZN
	1ymtVzI2nGLDAMCsGKyvemUCgQe39lHAuViOxDAh0t27d1mdmNd2i8ffLsuLSsgMXAYfgE
	ayTKxVQhCez89m+RDd6pKSe/UcJ3xRA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759914322; a=rsa-sha256;
	cv=none;
	b=auYQtiWyYJdON9olNqFX3S7nQTjzxsKDdsp31BsVHmK4Kshk8wLsQKqBVY2fysz9O+OEA7
	DM4npYTICcCeWZE1HmyGYXUDlUCtdS0XTq01t6PZNmayW51Kv1NKBtIoc2R/Z/scz1QwEc
	xkK3TbbQC9QOGjhdoeoYC3F6k6SRXv4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZDw06kFJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7957e2f6ba8so70402006d6.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759914322; x=1760519122; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4cYZmadA8mCAkJgxHGzRBrmoQCHtUHFnir9NGk0Mxs=;
        b=ZDw06kFJWCeVI64hkfexhT83L6BV7EirYIAmTp9Cl4he+i1csaiMWEkrpGMyCqed9z
         yz5WjAZw9ZWHE2p7TNkKyw7kNtbWuxgS7zLdJHsJdSJTwDfUI4fK6fuYoLM3ZKIwoo9M
         uTGfZ/Rf6vBMVlCXPLRPF0X5Mnq7z3DziM8pTX42f3QwdnaoIPYFWux4U9QHXceWF3Iv
         iDbQ86MlgcYif+cz634Rl3MAw02GQf79wA+yyqVpHF+p48wFi3Oe8DdSM7Qe2u+qVmG6
         OCd3Yx4dMXFQWTKhChrqtPxwgBU+6SP9Wr1caG0dQlmvI9mNYKUYWVApEl/XBy/+40r/
         ULiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759914322; x=1760519122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4cYZmadA8mCAkJgxHGzRBrmoQCHtUHFnir9NGk0Mxs=;
        b=Bobhcf8egZMWNqFHxtZkilLCEMZkWsIcuf1Ghb10jJlXyV2MfJrJpLzN49om6YLQHP
         o9U2TVAgS5LRLZabyA3G0FfJK14ngYxVOPei3XpaL405WwYYqGeguzrbaNPNic4GtZym
         X3Pdv0NM7A9m+MZze1BS+Q3+HK+8ZO+SBPGb893AoDeyn8ToghvxiAzEyEtwn6kQO0XY
         LLhbxYMcuv2ta3ZIO6cRqZQFjWbkYXbBFlj35I96duxkbQE+t94BTqJTrvP/5fwgpwOb
         taxkDG00oVnMFuyHvyjdtTjGB8651dyQY35eWimbmruNqqGlkqGIGshpsqFjGR41RmmG
         SFeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+BtyuufKSjbj6uh05s1UKyT+Rh1cIYp7nkaWLLZwi8wQMsnCHwooQKZxtJKCThoACQb26wBxzng==@kvack.org
X-Gm-Message-State: AOJu0YzcojlkJFwWNHUtZJSq72etywZjCYVamI/SylZtji+JtGePV62k
	Q/D2L3/V5jrF6VqR3r73gztWTYnejkpvySL3IVWCEwPaqDWhOeIGvPxxNelVzcBQLKjqWrbUdyC
	RxinoAtoDY6xORqugTedp0FE82a24HMg=
X-Gm-Gg: ASbGncsCsxx8lgECdWiyjw/NttMjcQ75yCzrVdCyhMxPMZ1Aa20KHqFGn+BZwjBRrgr
	vgxjx1itsyzus6rIQzQt/UbBhffK1FDr4hzCngi/aNy7IOKQ4ZqUklkmy7haYKETz86R1kmVpao
	Mf2KmHgGKx40xdR1gU3+oKzsJeVhlGnsCwlBCk4+cRh+dwcnYoXSSqBUg3hLd2IFY3s7gCHK3oj
	HjJLHWHWhaeygBb+oPHJmVYDsV1rxuMaOJ1FmY8RQegj91wVzxnPPzmNyg42XA1
X-Google-Smtp-Source: AGHT+IFtF/lJgRUwcJ1lVxRX1vX8QykTlCWe2klEiz/B5NPbX3cSQGIv9tHJapmtZwhENtdJSXzQ5eGIRt0iWburmhc=
X-Received: by 2002:a05:6214:2a8a:b0:782:1086:f659 with SMTP id
 6a1803df08f44-87b2107dd72mr31942296d6.26.1759914321370; Wed, 08 Oct 2025
 02:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com> <CALOAHbBFNNXHdzp1zNuD530r9ZjpQF__wGWyAdR7oDLvemYSMw@mail.gmail.com>
 <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com>
In-Reply-To: <7723a2c7-3750-44f7-9eb5-4ef64b64fbb8@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 Oct 2025 17:04:44 +0800
X-Gm-Features: AS18NWAJwXG18rE8UjAVYGwSMRoVGqsV4lXBJi6ePSpLgxcjj8cRCthEf3HoP2g
Message-ID: <CALOAHbD_tRSyx1LXKfFrUriH6BcRS6Hw9N1=KddCJpgXH8vZug@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: David Hildenbrand <david@redhat.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	Matthew Wilcox <willy@infradead.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>, 
	Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, Randy Dunlap <rdunlap@infradead.org>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: hs5xdejcczdi1etgnmr8mogoinaq76as
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AD8CC0007
X-HE-Tag: 1759914322-983606
X-HE-Meta: U2FsdGVkX18GUOzFbBj9lSDob9snswo86pIQPIjijmRf5gY5Ei/lerW/fz5MPbFJq9x6GHm9bPMz0KP/6HS6nyUnx/NjJFH0l/GbzxLFeR0+ZDQfkpDYDAot6v9r9defhWV7chscYXMQp7voTnziFu41hWVLn451A3Sdq+zwYJTSvvSLXgDVD3Yplsgz0khTpWYI/owaBCCXLa79vogSxSyDPTtykGvTHsmTyTCUjcPX3DnFgaiBVsfuS0TlHupxie5yuJGrww5+DK46bKWvCSU30+9wt66PHpczafc8LZF0SDg2eIBNr8OAMXKgRXQFBNRz5t/T3CuqhUaL5orZmxoAGseLb1wvZd+wFmvAb+jt44WYMdEv/LY9C7CxDZArcil6NbFFgy6j3M24QW9hU/6ZnO/j9bdl6b8Oqu2w4IZidR7XoJqPn0h8FFI+IbBacZy36dGLiamSNuOPHsWfXJZm5pU41gFI0006iwJEK3T2m+VaLOjH0mxYaEttwX2A47nWvhGLmRSg5HEjJKfYCebJOrNdng5hJk1r+dEL5YH9FdKlh/nNoMU75reuWFn2/9JPBuND8g+BKidWQ05nQiHqPdvBSNcs2ePbg8GFOrqwav3Y6LBumJaCswpIsnmy+YkTHZz61C9xj9DwN7U0uram1hEa0XfIzqoviSMZcw784zvvKJrhvy6ivqRNj/sqNBwsn+ydfOjZnDCsD7jGt8vtmg0WJnxBpbfpcVC7bhiCL9rot0lJUUsZ4gEkaVNgKW1A5CFps45LKHrg0xlcFHJr9Q5Bgtp3GP3S6WxhfJvkrz65zDcWiShmzqGO2+A+xVGzxGoqSJ6S22ovCvuo4oHCINqZnWYw8aG+SqzDANfBAmm22RCOHdHelXuq4sq5Gxif1o50DJ+td1a3lADuJQrH97f9oU3QilTSljLCJCbH4zglLwb0NvjK7muBzLXK8XFWaMocGhEIi/3qsVw
 Sc2Meyyw
 y2Z7VdHxw8rxeHD+Bcza/sGSFlDhI2hN/PVUcFBlksUq8+stQw7H81Gn7sdYhnVx7XuijI68dM+seb4GgaWFgsn9liply6bmkEmJHcEo1nqhG6NX2yo8n6rg+nWY2+ZV7X8baE+HGgCn/B42kbJMjT38Gp1+c/QdUsK3i43HaWeN+F7lnQp8lDZY7n0YHMGEJat2ZwjpE5ICOsdSkc7mzqI71SCTlLyxdjITEoaZeyq28drhjDxpFGnQSqeNQlHQyytfCznGw9O97y+Dn768LIRVC+6TY3HwzoeflASZxbFFXx19Xa10wLferRkzBjYgK5ove761LcuBWeYKK4Q5LneIwO8PY+mchH7EZ1qfEldrpc8n1wIwZT2aI8mDnnXgJx3k+oPizcIqG7n0uWbqDAWy++rgUOmjSVIKPBkyUKxsqqnBQ4sOlG8pzNFcEIEHwVDjmUZxbwZVircZCN773F2kfRtKT2I+6BR1hp3so+oiJ5zt2B2V/eX5QLeqkXZYxLQOb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 4:28=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 08.10.25 10:18, Yafang Shao wrote:
> > On Wed, Oct 8, 2025 at 4:08=E2=80=AFPM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 03.10.25 04:18, Alexei Starovoitov wrote:
> >>> On Mon, Sep 29, 2025 at 10:59=E2=80=AFPM Yafang Shao <laoar.shao@gmai=
l.com> wrote:
> >>>>
> >>>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> >>>> +                                     enum tva_type type,
> >>>> +                                     unsigned long orders)
> >>>> +{
> >>>> +       thp_order_fn_t *bpf_hook_thp_get_order;
> >>>> +       int bpf_order;
> >>>> +
> >>>> +       /* No BPF program is attached */
> >>>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> >>>> +                     &transparent_hugepage_flags))
> >>>> +               return orders;
> >>>> +
> >>>> +       rcu_read_lock();
> >>>> +       bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get_o=
rder);
> >>>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
> >>>> +               goto out;
> >>>> +
> >>>> +       bpf_order =3D bpf_hook_thp_get_order(vma, type, orders);
> >>>> +       orders &=3D BIT(bpf_order);
> >>>> +
> >>>> +out:
> >>>> +       rcu_read_unlock();
> >>>> +       return orders;
> >>>> +}
> >>>
> >>> I thought I explained it earlier.
> >>> Nack to a single global prog approach.
> >>
> >> I agree. We should have the option to either specify a policy globally=
,
> >> or more refined for cgroups/processes.
> >>
> >> It's an interesting question if a program would ever want to ship its
> >> own policy: I can see use cases for that.
> >>
> >> So I agree that we should make it more flexible right from the start.
> >
> > To achieve per-process granularity, the struct-ops must be embedded
> > within the mm_struct as follows:
> >
> > +#ifdef CONFIG_BPF_MM
> > +struct bpf_mm_ops {
> > +#ifdef CONFIG_BPF_THP
> > +       struct bpf_thp_ops bpf_thp;
> > +#endif
> > +};
> > +#endif
> > +
> >   /*
> >    * Opaque type representing current mm_struct flag state. Must be acc=
essed via
> >    * mm_flags_xxx() helper functions.
> > @@ -1268,6 +1281,10 @@ struct mm_struct {
> >   #ifdef CONFIG_MM_ID
> >                  mm_id_t mm_id;
> >   #endif /* CONFIG_MM_ID */
> > +
> > +#ifdef CONFIG_BPF_MM
> > +               struct bpf_mm_ops bpf_mm;
> > +#endif
> >          } __randomize_layout;
> >
> > We should be aware that this will involve extensive changes in mm/.
>
> That's what we do on linux-mm :)
>
> It would be great to use Alexei's feedback/experience to come up with
> something that is flexible for various use cases.

I'm still not entirely convinced that allowing individual processes or
cgroups to run independent progs is a valid use case. However, since
we have a consensus that this is the right direction, I will proceed
with this approach.

>
> So I think this is likely the right direction.
>
> It would be great to evaluate which scenarios we could unlock with this
> (global vs. per-process vs. per-cgroup) approach, and how
> extensive/involved the changes will be.

1. Global Approach
   - Pros:
     Simple;
     Can manage different THP policies for different cgroups or processes.
  - Cons:
     Does not allow individual processes to run their own BPF programs.

2. Per-Process Approach
    - Pros:
      Enables each process to run its own BPF program.
    - Cons:
      Introduces significant complexity, as it requires handling the
BPF program's lifecycle (creation, destruction, inheritance) within
every mm_struct.

3. Per-Cgroup Approach
    - Pros:
       Allows individual cgroups to run their own BPF programs.
       Less complex than the per-process model, as it can leverage the
existing cgroup operations structure.
    - Cons:
       Creates a dependency on the cgroup subsystem.
       might not be easy to control at the per-process level.

>
> If we need a slot in the bi-weekly mm alignment session to brainstorm,
> we can ask Dave R. for one in the upcoming weeks.

I will draft an RFC to outline the required changes in both the mm/
and bpf/ subsystems and solicit feedback.

--
Regards
Yafang

