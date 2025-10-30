Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44446CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 22:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6985D8E00D3; Thu, 30 Oct 2025 18:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649188E009F; Thu, 30 Oct 2025 18:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E338E00D3; Thu, 30 Oct 2025 18:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 461F58E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:19:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E626A1A0196
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:19:25 +0000 (UTC)
X-FDA: 84056197890.18.74854F2
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0B07E14000B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 22:19:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YTEDGeVK;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761862764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwT0gzXBjfVIjqUHMyMXwgTVGE+oE1n+ZnWlhE9CZ5U=;
	b=GDg9cqz7bOXjz/lda9LqWqFAWx8YqoKAimdNR72Sv5wTA4z2pkrz3VBljDOcCaFesEeJVy
	RJadnvqaN91+hBnRk97406fddqXS0WpRup1I7ysOrGXQ6ZGLYHmBXaDsH8jCtjJlxbhP5S
	ddZv7hD5ANDV6IYL8XnSWNmLVy0DcpA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761862764; a=rsa-sha256;
	cv=none;
	b=vDA1lrOGzOXtstTWag65i/sYN8T7yVU2r/WFZpOFlxhUUOK0Q04d+4KKjYDkBm897wOzdu
	F2OYs7Pb8fYF0ZHxFt4yvkyRmMcRJzspoCbLOgPCINqbQ89GC6xHZD9wlXm51/0nDJIcIX
	iEZbjN+MObkWs1Y56Fytp8cL+VbARAw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YTEDGeVK;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4710683a644so15034675e9.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761862762; x=1762467562; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwT0gzXBjfVIjqUHMyMXwgTVGE+oE1n+ZnWlhE9CZ5U=;
        b=YTEDGeVKxA2b0eqnf3cMTOiKYRBodaBbUXn6w1rqtwP9CXXostlv/BGN5XM7aj+VVv
         MtI4tYJLcCc8jG6IBYb7vs/x3cJr6Rw09rBNw9wWZ4rekpdc0jZIHpRF3sK6Ks7/7LEQ
         RhknGizCfpKq8BU7+yiKpHfQdsA8kecsfSDN/GeO7qnNYyFSbe4gQMwKi2wbZU4GI4xC
         pK4w3s8CBywrYTV475RmGlNEzypaLJL4f1V+gD4vdR0LWN9T7Pe2hiQVDr0776VRhL5V
         /pRpupk4JHQUxLrE3t+GT6dru632nGChvhZKvZbz59XI8OKIagcmlvDhr5DWYe7yknCo
         VMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761862762; x=1762467562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwT0gzXBjfVIjqUHMyMXwgTVGE+oE1n+ZnWlhE9CZ5U=;
        b=R79gdrIP1mVHumfNnkn7VWsBNkyj7IRoE0Q4sfe95bszvEqNocupU3PidSCggZuH11
         EnS/DU1PP7FOWtFLOjDkbgaL/n60g/nUoVoHhPo8lOyrGSA0MVRkMpxwgT4IahQ2hcBr
         QxQs1kZONvEk2hCcl/Rmg6pdUSfOdtxEGd1F1dFizudf8nC4zhpm+VWoSpXZ5u+XujmW
         RGiMmNNTh50u/OxbJJO2RdjFUQ5AX/+jcV594QlqEe0IKP3adilSYIlPcHuIprRHuwlN
         hbqYqHZR29j4BPsa9M0gtRKkIVk88/KJFbvsLCDgDW8TXtCuSk7EobIxD+txUiNAp9ej
         Q/eQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0SDd07Lr/YQ/0teMWUlutm6CX1M30dkC/7gqSzZkA3fkgZrUkdY/j/ePQ5QshKEosafUgeD9iUQ==@kvack.org
X-Gm-Message-State: AOJu0YxZKUEmYFHp5Ofqiewi93gKLwmSuxXWvAltF6zDLgmfeKrT2M2G
	GN4KwwCJitPY0XHfX3vakvr1A8DLUcVWJB1BVtuMkDso79svgGNZ3otHNLME7TW/2eT+tmuDCG/
	V2vZ1iGd4OuwdfhMCoUb3nNKZqmnCrzo=
X-Gm-Gg: ASbGncsqzVxDM5yAzDa9NnH3w+WSxzYbMp5PK7dX6Co0NEGbqUgF4oeGNyFmj817wwF
	IhCqLLNA0Q5cdPVZ8ToFsnoaiJcqYxVSKqOZYcaqbyFztv3vi7OmTaSjjw2jNVe6n4tnfyL8U1k
	jK0mZi92uGHZvOwEyJOjof1Yds/KV0vkYP2KFTaVSE20c5UjhwiWlHswS5tq+b4vgkPBoCS+Tma
	Gm2WWKwnIb7kvWlnhAlZYr9a4cINU7HRcZCtMOXzw6vAvqGFEUeAngdMkzwgvMUt6nrpw0yT2EH
	PcVMudulJgZQaDLXUfl1idWHVYgG
X-Google-Smtp-Source: AGHT+IFiyX3dJnURSNNpVr0vY2zqjAiRZhDfNNfk8vGHPMc1PF33QyAD/7tk5XU1FaTuD+gAkKoljP+gHiDD9PWESHk=
X-Received: by 2002:a05:600c:8189:b0:475:de75:84c6 with SMTP id
 5b1f17b1804b1-477262a941emr44348555e9.12.1761862762377; Thu, 30 Oct 2025
 15:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev> <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
 <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com> <877bwcus3h.fsf@linux.dev>
In-Reply-To: <877bwcus3h.fsf@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 30 Oct 2025 15:19:11 -0700
X-Gm-Features: AWmQ_bncjILdks5wFOJTGOLbyWVnc9Lf7_PQRe6yc5ZnQYFFDm9_YYMU7X8G_V0
Message-ID: <CAADnVQJGiH_yF=AoFSRy4zh20uneJgBfqGshubLM6aVq069Fhg@mail.gmail.com>
Subject: bpf_st_ops and cgroups. Was: [PATCH v2 02/23] bpf: initial support
 for attaching struct ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Amery Hung <ameryhung@gmail.com>, Song Liu <song@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: xdyfn4iftji51ygu3uz3j9i98gaps1rc
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B07E14000B
X-HE-Tag: 1761862763-38070
X-HE-Meta: U2FsdGVkX18vRQP1hNgKKdj9y0xCIhUvMMkceeM0z3QrV0TUcWN65t2xAwbVZ/YQJDeHokcTX4KyfvZBpL1/8r41eYy+kZ05KexjP8Ps0Xa3D2PwI/k4awZuq0NsUXUJBA6paKc8N/WFPxbBkIQ/+NW3RaJJB3QroKF4aQkf82FQlGB8eh59loabuvYoChvqWMlouwd4BSUTaKfpsle1ETCqWYkQRMRaJUJOvaYqu1sTIs95cFRzQozYk2SZA0w5QWsTLficy5T8ZaSz6Nx9YZC10wZNhfNABE/Z03UxoIBX+YaVXw6hKITpl1rt/bBB9GkdHDIv/O357WVio+LpxH+usNcWpv7J7OIAW2U5jphIVKkeKd/pMMJY0CMCiJramfuA7erHEUhxx2mZ91r3C0GvHGbjQhvfDHMmO5QTZii3k9lhQMLLyBOjIPHmdro5945wzByWslfq3/TDtUNm79JiukB/S858nmYvG6ovFg2tc0DZBUgJkpsgbLECFQhoOM2PDUvgDddQvLNGS2aHMeHqjYUxBv7ChrNntur9frISGndUMHS259VLrZeXm8l9e9ICvTxuxXp7SlIMyTx24ukShA6qToMW3cepeWwLJd8tA35JqTJaD4vjtSZ+6tu0vfR/bvOKJgGEBq4ATdRpSsn1Px1V7GAu9q2aHLDOKr7U0lYoFFks3qaSHOnBxlfhG6klhL4k31sTugeXSFADZ2a+SXurGN9aesStBWajxK69Ss3O9sWEm3hBiI7eneuoPLeGPkj8X4bzaxq3mtIhBfqD0znFJOI50Uoxs0nGMO6IQFi5WtoL+HvmrMaZXYSmim1PyEoQvcpu4CY/8SmMWo727laA9ZcDQ6BoGDBw0t4fVrNKRUm17K1Ouo8C3Hu093ynHOQKv4Of83n03qGdAGHLsln7INLku9lo5spHZDB4HGFoNu7Ryk3Yu11OfWLgWxB2kblksnXLiNzUwb6
 TYQ/GW52
 ETbPe8C37guLe3Pec7gRx3YkZ5lbHm+Nix6pcbY5hjgk4/IPFs3jYivgHrgcJSwO6IenS2cxILK4Ni+S/gJRuYkhQwCHZFlfznB969zNt4POmnYvLnIxIPuygqGw37M+H6a602znY17F2nNuMAlQpnP7GtOgMmuG8Di+IEVtLH5PZzII5uYo6n3hCszPfbPjLgZDY3orK1m1a91FeYJFlGduRZ75dzBYtmRvBI84ZY4PXq8t9zTu4C+RSzrtr3yc+MJRDF0Jqg6pVKZ0WgHe+6yuOCq8lRRPmZu/jT+i0kbJ0IJrDDaBbEh+iJjywWhDKBdBj9Z5YegbCIMuchUaXFCvTibUxKWUfYHFgKM1ntp45oL2BGFtWVNcY8OKdsikt6NhrmUD1Wuh6B06HTzqcFSSiWdKRpFr2zlIjtJ2rhWdnuVL1Nx6r9PCzSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 12:06=E2=80=AFPM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Ok, let me summarize the options we discussed here:
>
> 1) Make the attachment details (e.g. cgroup_id) the part of struct ops
> itself. The attachment is happening at the reg() time.
>
>   +: It's convenient for complex stateful struct ops'es, because a
>       single entity represents a combination of code and data.
>   -: No way to attach a single struct ops to multiple entities.
>
> This approach is used by Tejun for per-cgroup sched_ext prototype.

It's wrong. It should adopt bpf_struct_ops_link_create() approach
and use attr->link_create.cgroup.relative_fd to attach.
At that point scx can enforce that it attaches to one cgroup only
if it simplifies things for sched-ext. That's fine.
But api must be link based.
Otherwise cgroup_id inside st_ops all the way from bpf prog
will not be backward compatible if/when people would want
to attach the same sched-ext to multiple cgroups.

> 2) Make the attachment details a part of bpf_link creation. The
> attachment is still happening at the reg() time.
>
>   +: A single struct ops can be attached to multiple entities.
>   -: Implementing stateful struct ops'es is harder and requires passing
>      an additional argument (some sort of "self") to all callbacks.

sched-ext is already suffering from lack of 'this'.
The current workarounds with prog_assoc and aux__prog are not great.
We should learn from that mistake instead of repeating it with bpf-oom.

As far as 'this' I think we should pass
'struct bpf_struct_ops_link *' to all callbacks.
This patch is proposing to have cougrp_id in there.
It can be a pointer to cgroup too. This detail we can change later.

We can brainstorm a way to pass 'link *' in run_ctx,
and have an easy way to access it from ops and from kfuncs
that ops will call.
The existing tracing style bpf_set_run_ctx() should work for bpf-oom,
and 'link *'->cgroup_id->cgrp->memcg will be there for ops
and for kfuncs, but it doesn't quite work for sched-ext as-is
that wants run_ctx to be different for sched-ext-s
attached at different levels of hierarchy.
Maybe additional bpf_set_run_ctx() while traversing
hierarchy will do the trick?
Then we might not even need aux_prog and kf_implicit_args that much.
Though they may be useful on their own though.

> I'm using this approach in the bpf oom proposal.
>
> 3) Move the attachment out of .reg() scope entirely. reg() will register
> the implementation system-wide and then some 3rd-party interface
> (e.g. cgroupfs) should be used to select the implementation.

We went that road with ioctl-s and subsystem specific ways to attach.
All of them sucked. link_create is the only acceptable approach
because it returns FD.

