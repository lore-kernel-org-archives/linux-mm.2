Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FAFCCF9EB
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C368E00B4; Fri, 31 Oct 2025 02:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC6A8E0045; Fri, 31 Oct 2025 02:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABDF8E00B4; Fri, 31 Oct 2025 02:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9F2D8E0045
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:14:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4978F87745
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:14:40 +0000 (UTC)
X-FDA: 84057395520.14.458AA88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6B0A6120004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:14:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rKCJJoCN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761891278; a=rsa-sha256;
	cv=none;
	b=noyyFMD3yMWUAPHFWO4WR2I0I4jsEOMX4quZN7Oj1blYd7w6YNBGP3ORKARkdkjnrPg4Ub
	kwxMlviPjZce417PRLH9fvKPrDhuV2gUcuD92m8wOElt0/d+ZVGUKrasgTN5gULihckjdO
	AVXMUpOEi+SI9HSneKYCXHK/ZV2akec=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rKCJJoCN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761891278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqIFCDAORF5RSMnUdfRBwmmN5X0pSo5mn0P9HMFha+M=;
	b=Jsl1YPGHbcn3f9dqmJ0lTr62AdVreYfiSFuCIVX8XI8pH8x6HALwLa40Thnd3fcghZezzh
	SSHD244peIIWkWVZA57K83Go5Ubbt1tEV/8LdKSPLXAOHDkprYIzABl6Vr35JENgtwyyYR
	3t7cgU/+Bk26285igIon9ONHXloZSK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CD2844B82
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23892C2BC86
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761891277;
	bh=ulqQ2Efc96Ndv0ALKnZyWiWyzX2vMFMpabUS/C/Sh3Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rKCJJoCNVl0Q5qtaH1Z+C7B1Oz+Fl08Rl8H0qpFx06zWBR66UY0lqEwb3iTi0T7bZ
	 iUo9iMhXwDO1C9+a/RSFlW0WTKwANQWJQ8up+KtwVzuAsT0So20658/XXdq0NWtphE
	 gkxQDiUHsr7C4T3wMDNAw3HFdzQLreVT717xnA/vyNUP8KC0C+zCtguLL8LVOJVhTh
	 ZtKH+qq8rbVN87I0SYHf2gnCjl8TbdTuDIGUVJSwLcNn6hCe162OTbkUhb0vZ2YZyG
	 TiXtol0bImMwkIReazkIjp2LKKFWPVssG+caVhcpP5V3ZVba/UK3e9lx3N681S99ct
	 WyIMCunGgs8qA==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87fbc6d98a9so15711886d6.2
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:14:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVkBUb1aB4Hb6uBKWO2TIK1z3y4uw16rztgNj3R6U99hkBgTS50x5ZKxgiNTamsKtV7+ld6I83i4w==@kvack.org
X-Gm-Message-State: AOJu0YwZtAwynY3foVJsNnGpIpZHlByGFZFzLSqPXjVXAmuX+74hauGE
	60R/p3IA+02ODtZOLGwNMfbbHZ24DU5eBmNgDGWytESdSw82XsjtSBmM3nwZ0VTnAesgWzRluCk
	jdWDWKvdWWrjVUZ3vsPNHVtCeXUxWG1g=
X-Google-Smtp-Source: AGHT+IERuBxgQd6R3EQpmFyFGBh/OYNUCmHcFdqHl5UpwHFlKQJ7KunNCXQLp2T8SUK1j4VkBMM2BQqqeY80Jp9bKs0=
X-Received: by 2002:a05:6214:2a8b:b0:87c:a721:42f3 with SMTP id
 6a1803df08f44-8802f450e57mr23817426d6.41.1761891276053; Thu, 30 Oct 2025
 23:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev> <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
 <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
 <877bwcus3h.fsf@linux.dev> <CAADnVQJGiH_yF=AoFSRy4zh20uneJgBfqGshubLM6aVq069Fhg@mail.gmail.com>
 <87bjloht28.fsf@linux.dev>
In-Reply-To: <87bjloht28.fsf@linux.dev>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Oct 2025 23:14:24 -0700
X-Gmail-Original-Message-ID: <CAHzjS_vRrxTLR0kFJvm4R3kO0s8hyN5Onsr6XfbA3Peyasz+Cg@mail.gmail.com>
X-Gm-Features: AWmQ_bndcOuOp7qdV3wXaWKIXpuAyFBwWSClkxOKSazNGGK9yzrR9MBHnc604rU
Message-ID: <CAHzjS_vRrxTLR0kFJvm4R3kO0s8hyN5Onsr6XfbA3Peyasz+Cg@mail.gmail.com>
Subject: Re: bpf_st_ops and cgroups. Was: [PATCH v2 02/23] bpf: initial
 support for attaching struct ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Amery Hung <ameryhung@gmail.com>, 
	Song Liu <song@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ui6i33ps1w9y1juoa9ctg93kyy68trsp
X-Rspamd-Queue-Id: 6B0A6120004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761891278-581962
X-HE-Meta: U2FsdGVkX1+Ch0YSmm/W43rbV2zHpUhhH/eigHS1U236F/mkRR7VVfwcGl86vn1vlIj0WjsppMrQvGUacaYqG1mn0DCLr4byb2UYVRs2YiYsI64u9Uqqs8deJoggVdH4u7femzNPawjvyirze+B17jvgDc/mt8nKTvZS8+sJULJbQIezSBTSFj3RNTMtPJ0DawawjSgvnBManG+ffDz1PNpLcDYKtd6jiehsPNiEAz8B0cUxPZES/tesGbx7Z81xCIFEHK0577Zae5vcod/ze/lpbPzn69ltano0mEet9losvv4U5RYjeov54wbRFNfh/SG76DRlkSP4B+DTAL7XXcG9I/2vTBp0SsKuXhcfXKfrc3UHwpK9XQ+vLlByh9V4l6FSfgs9/1O70jQQsrW2OqDmoS02KpBz498JwlcO4qYRPhXdU6uhWtoI5Z2Ik/lPCOxM6e549dBRdNgurieCVud1kbLsDqltEccZ4KWTkiIzJo0Za74nqcD9Fs/dNa0co6bzK+JGhDdBqW4nnO+4nXqK62jZKyM3rslVv3dMEnYfoGXcBuejdLsbC6n3T4yQ74b02L37hd4spgUGsevcfv8drY2m8Um3L6YTtFf3e5Zu5GSFi1KiU4ukBFN8H5Y3/zquyClgppVx2BMVkH17CDxBNONswODzzVW6Ho3KJzagv+BbVEq2rvuUFtyGl8Fe8nvEpG7nZvyiogDuEJJsvQp6gITBJC7tBc4xWlbBOYpb4sQgWyGpzs0tvfYo743Nr0AlPkn5uKw3oRO5L2itPUCSiABDyH3mRH97fAyv+seGxBHZJNOsUNf9DAvndh1LO94df90GCXlqDSAMfBMja3V+MiVO+dBL/rJngXN+fCObSmBobsA/DffWseFXrYiLmYHGRHXMkhZ4x0tmiQHuowkJayveHViPBcEWEhSRH6CzDnpFbV4VK61c52OuEy89WhtTJWmLvoPo0QqyUW7
 PrRgZUfO
 JuUHdmLr3HtoXvKBfrBszEW/LFAHgoSN62SsKCr0cwuSM2lrg+vIfFp+hL5GeL0h5Y5NKct4ussbxAh1GEl3ha0LuGz2FdvpjasG9Ucn60ojCCkM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 4:24=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Oct 30, 2025 at 12:06=E2=80=AFPM Roman Gushchin
> > <roman.gushchin@linux.dev> wrote:
> >>
> >> Ok, let me summarize the options we discussed here:
> >>
> >> 1) Make the attachment details (e.g. cgroup_id) the part of struct ops
> >> itself. The attachment is happening at the reg() time.
> >>
> >>   +: It's convenient for complex stateful struct ops'es, because a
> >>       single entity represents a combination of code and data.
> >>   -: No way to attach a single struct ops to multiple entities.
> >>
> >> This approach is used by Tejun for per-cgroup sched_ext prototype.
> >
> > It's wrong. It should adopt bpf_struct_ops_link_create() approach
> > and use attr->link_create.cgroup.relative_fd to attach.
>
> This is basically what I have in v2, but Andrii and Song suggested that
> I should use attr->link_create.target_fd instead.
>
> I have a slight preference towards attr->link_create.cgroup.relative_fd
> because it makes it clear that fd is a cgroup fd and potentially opens
> a possibility to e.g. attach struct_ops to individual tasks and
> cgroups, but I'm fine with both options.

relative_fd and relative_id have specific meaning. When multiple
programs are attached to the same object (cgroup, socket, etc.),
relative_fd and relative_id (together with BPF_F_BEFORE and
BPF_F_AFTER) are used to specify the order of execution.

>
> Also, as Song pointed out, fd=3D=3D0 is in theory a valid target, so inst=
ead of
> using the "if (fd) {...}" check we might need a new flag. Idk if it
> really makes sense to complicate the code for it.
>
> Can we, please, decide on what's best here?

How about we add a new attach_type BPF_STRUCT_OPS_CGROUP?

Thanks,
Song

