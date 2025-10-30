Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22A40CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 21:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828DD8E0108; Thu, 30 Oct 2025 17:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800F98E009F; Thu, 30 Oct 2025 17:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73DB78E0108; Thu, 30 Oct 2025 17:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64A018E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:34:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E55412A94B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:34:26 +0000 (UTC)
X-FDA: 84056084532.09.437D646
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D23CA1C0005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:34:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NVkgTo8z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761860064; a=rsa-sha256;
	cv=none;
	b=WC6gFeX41yZYLy1hACdWYtbkjgoq6I1iVbpPnce2f84fXxmak8lOaiGERq46u/9LGLSMCJ
	CWw74DSmMRvMXaPQ067ZzQLFdTEE/RLP+3VtLWLDuic8cYiJQDPO6cxVk0uWlRvakxL49N
	b35A4W1zma2I5oXbXhOR0mB+9S9sxYc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NVkgTo8z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761860064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YguSVADbTYC009fNcBqxs+hQWIvB3UNV/r/h9UqkYik=;
	b=lq7kR+lZ8RPdzrBIj/ADWhQuQ7PIqqcHKMGwSmiVxO1EZg4TWOHcJXCGF5kgH1lpuhznMP
	Zh8REPhLrYJfoladP37LIN9Vg75maJ01ThxmUFcqnHM2efXVKu4DtMy7uLmpc9tcTD8tLU
	2XBoLz5Mo22G/hgrTIr4DWbh0/hs0g8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87D0E448A7
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C819C4AF0B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761860062;
	bh=vA3cQcFFKPHYjkv/o095+U48maXEWxIDrmI8GV0FkR8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NVkgTo8zsh/oLtwCRGHu02MRlHkXjU+0bxw2XcUHuagq5PJLN22kQBFZbdeMY7efS
	 2MTJdgK0VYBtO97xuZ0uisPN4RrlxI/WvEcHqfuhrvNI/Y5a97boExAn4Ycg6oVNob
	 c02S5GXecCSsPAreWAfcsKrMVgQHvlf4rczHVAD6J79JtcmY7HPuo3NeP/vRGVLLEz
	 s4gfZsgjB54VRsiZrOJ1pViSDlr3dOfKN7Lk3KIpofVaxxCTc4e7BeCm9SUcQFrJyp
	 3NLPq2OIweWu/X2DT2D4jEpFhoyzaTcyKLubXPmJ4jVQBZUGX2dSXTf/JHgC7QaGFz
	 krQmQNvq4YLtA==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87dfd3c24ddso23211776d6.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:34:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXVhJmr/NHXFvlkuf/ibHwr4f+QTeYRF3JpufttwnmEFckaHw0IbcS3WSvixlse7SwLcFMl4qYpcg==@kvack.org
X-Gm-Message-State: AOJu0YzM33HecyC4fNXA2Bm9eJf1PSJI68mLbIdnVfMa5StYgPcMlW4C
	VWXoclu9YEX0JNRZhoB2Eo1g/tmLqhUqJ1aMnn4pPQd13zvAjkQpP3IvyCK/a04QEzzieMsx2BN
	75tVUWo6LQpq+jHHcNL6WWCiyIwD7qls=
X-Google-Smtp-Source: AGHT+IHMkX2vgEpmo54ScXG2z+0WIl2vpMLiW/fIKrF0LrJBFRJd62XKtruZSD0g4dhRrF2T+Nff4509mwhwddlY7x4=
X-Received: by 2002:a05:6214:21e2:b0:87f:c009:79cc with SMTP id
 6a1803df08f44-8802f4db53cmr14665996d6.51.1761860061351; Thu, 30 Oct 2025
 14:34:21 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev> <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
 <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com> <877bwcus3h.fsf@linux.dev>
In-Reply-To: <877bwcus3h.fsf@linux.dev>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Oct 2025 14:34:10 -0700
X-Gmail-Original-Message-ID: <CAHzjS_u5oqD3Dsk9JjK942QBL8UOMkqdM23xP0yTEb+MMuOoLw@mail.gmail.com>
X-Gm-Features: AWmQ_bk7HNuiosItrXA1dyLcCJexg7C-WNSjzhjZ-UrPmMqZcQrRacrRjcLhdZg
Message-ID: <CAHzjS_u5oqD3Dsk9JjK942QBL8UOMkqdM23xP0yTEb+MMuOoLw@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Amery Hung <ameryhung@gmail.com>, Song Liu <song@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D23CA1C0005
X-Stat-Signature: d4m57rmi1bb3kebhjx71qifxkhnk1mqs
X-HE-Tag: 1761860063-676630
X-HE-Meta: U2FsdGVkX1/U3siizUVKdwQxcyUBLp3nfEf9dQehowHmqZEwn7S28CGK85bfjuH9uapMZnslIwC7kwvcyDG8swUmSRQUtSk0i9jwpnwbIV9gyWqvaEBWnQn8eqHzRDHDuX7mDBlCAGJ28s+dHhiqFn5cviJJfk6+vm2HAyynRBXs6khrimBRgHNLNkBuhgkz3aDkC5tEUPwIxp3TmB2cPhMERCP3A18Y20pX/P7peOr/1ZdKGveusJ8Fh+7j2XZg8eRG1dNNGLHGTnxI1/LDB/RWZu+C6U9ex2CuNqWP30DsN36Z6RP1Q11iCgMHMmJB8113WVGa52xre6dI/FRvnIbW7LRsAvO7U//6J3R2fHamwNMqx/hrpyhh6P6lMDwxwac3YpF1mvNZx+6JqNoIbZZY4QxdWVW8NQVW+4qfCqq1jDjhCWaq0jlpeBuCddaQO46cdu1wo89NKe/iq5tNgMIOqG9zYGs6fWrBydRfchxtpp8ufqtNY43SyWlB0J/DZ6V2mW3wFh9vzosCPIn2XA6wyiHHhuXLS70YhAqCGx6v7FlhGb2gLV1lfSaLT7tCEK+dcWezzATQmpLOnKXYDlouKWV0jPI7uFBIcUOQ4jHxLIBn0/UuRKB9r4ZtAG7QjN9C4dToLqk+dFZIjDwZcJZfEqkZ8XDugLi245R2M1sbMxx7kpWjtT1O+bPiEYQGKjqfFlmsMTzkraudZiLdxTyBaBZMTUIXo7Z/t11mhiLtbHZvQ31tnrYj4ppDb5GyJ7guDU3EU3xtNgJ/tPWFOz2JpndnkJJRFM2Lv3wI2U7PonJULvrk668YWopL7//3uhDWYPm4qAUqRFZlekhejq6jsU+TVkNqhdiGtLn43goYaqmjRpMSpU7wnfbtHgfTrAhkG1W4UiL+xv0t4N8AwK0KH9sZR8wNnCSLfrgjeIhU+oO+RLgnlLpdpOX9tG+7ZX1OU+iiT/ODThLw5I/
 5YKrFFHb
 47G+IVII0EJRXccqeFx1SP3z6NKj9vRwA02WY+ZH60BB9t5HYD0eEbfhALowfBGVqPKj+dmzUEYImissHdlIMpioqKD+7+Y5FK0LFEC0a3oXWHcrvrBQxuj8ZtDnrItpshIVL6aw23Ar6PQUayZyRAw4epJgvDDXTHuH1YDs0ryCk7XMZr41fwsrZhjdr4O0iYPu/9sk+vPvSTVlJP/oCPw2Q5aXf+ZBVNgZnPJ462E0puNNF+/adLp2EPHN6r8XHH2NAy8NyBgfwnvNv5Ny9pj7HtF3RWjGsaOdy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Roman,

On Thu, Oct 30, 2025 at 12:07=E2=80=AFPM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
[...]
> > In TCP congestion control and BPF qdisc's model:
> >
> > During link_create, both adds the struct_ops to a list, and the
> > struct_ops can be indexed by name. The struct_ops are not "active" by
> > this time.
> > Then, each has their own interface to 'apply' the struct_ops to a
> > socket or queue: setsockopt() or netlink.
> >
> > But maybe cgroup-related struct_ops are different.
>
> Both tcp congestion and qdisk cases are somewhat different because
> there already is a way to select between multiple implementations, bpf
> just adds another one. In the oom case, it's not true. As of today,
> there is only one (global) oom killer. Of course we can create
> interfaces to allow a user make a choice. But the question is do we want
> to create such interface for the oom case specifically (and later for
> each new case separately), or there is a place for some generalization?

Agreed that this approach requires a separate mechanism to attach
the struct_ops to an entity.

> Ok, let me summarize the options we discussed here:

Thanks for the summary!

>
> 1) Make the attachment details (e.g. cgroup_id) the part of struct ops
> itself. The attachment is happening at the reg() time.
>
>   +: It's convenient for complex stateful struct ops'es, because a
>       single entity represents a combination of code and data.
>   -: No way to attach a single struct ops to multiple entities.
>
> This approach is used by Tejun for per-cgroup sched_ext prototype.
>
> 2) Make the attachment details a part of bpf_link creation. The
> attachment is still happening at the reg() time.
>
>   +: A single struct ops can be attached to multiple entities.
>   -: Implementing stateful struct ops'es is harder and requires passing
>      an additional argument (some sort of "self") to all callbacks.
> I'm using this approach in the bpf oom proposal.
>

I think both 1) and 2) have the following issue. With cgroup_id in
struct_ops or the link, the cgroup_id works more like a filter. The
cgroup doesn't hold any reference to the struct_ops. The bpf link
holds the reference to the struct_ops, so we need to keep the
the link alive, either by keeping an active fd, or by pinning the
link to bpffs. When the cgroup is removed, we need to clean up
the bpf link separately.

> 3) Move the attachment out of .reg() scope entirely. reg() will register
> the implementation system-wide and then some 3rd-party interface
> (e.g. cgroupfs) should be used to select the implementation.
>
>   +: ?
>   -: New hard-coded interfaces might be required to enable bpf-driven
>      kernel customization. The "attachment" code is not shared between
>      various struct ops cases.
>      Implementing stateful struct ops'es is harder and requires passing
>      an additional argument (some sort of "self") to all callbacks.
>
> This approach works well for cases when there is already a selection
> of implementations (e.g. tcp congestion mechanisms), and bpf is adding
> another one.

Another benefit of 3) is that it allows loading an OOM controller in a
kernel module, just like loading a file system in a kernel module. This
is possible with 3) because we paid the cost of adding a new select
attach interface.

A semi-separate topic, option 2) enables attaching a BPF program
to a kernel object (a cgroup here, but could be something else). This
is an interesting idea, and we may find it useful in other cases (attach
a BPF program to a task_struct, etc.).

Thanks,
Song

