Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D67CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 03:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601668E0078; Thu, 30 Oct 2025 23:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D90F8E006A; Thu, 30 Oct 2025 23:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDCC8E0078; Thu, 30 Oct 2025 23:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3CCF78E006A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:04:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03C3A140341
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:04:10 +0000 (UTC)
X-FDA: 84056915502.28.2976978
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 20ED9C0003
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:04:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m9EW43Bn;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761879849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rB1+LZPkwFY008oY4N4SwT8A6lc9mI9L3ZvDOPN4piw=;
	b=B1370Sl/mkFvnF1M1eF/ETyiaxKHbux2QK9VXc7av84VTtpAFYmazUWRkSHFYR+310TcAr
	Xu9RwiWuJIwqucYGZyfonA9wzneFrrVHQleI773G9Xp938QsCQlU2GGiuGmJiT8wIzuIDG
	pJZLr2q7T32PVtBy9v9LRtbDY7gxKzY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m9EW43Bn;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761879849; a=rsa-sha256;
	cv=none;
	b=bKLPWOcnYSVH/O2rhPPnHv7skEVsP/zeyye/P/+Wk+1Su92AwsuzOyKxZit8sbFVhK0Xas
	bK75uJWRScGTpMTf1ij4lly9fHSA+hkYZLOskALysrDHGsB5V8WTFaJaGrrdVSOQRDQ1QY
	vBqzSePF2aF3MWg8vsEJaalg4c3nv9A=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-63e3804362cso1870039d50.2
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 20:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761879848; x=1762484648; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rB1+LZPkwFY008oY4N4SwT8A6lc9mI9L3ZvDOPN4piw=;
        b=m9EW43BnzHBV17OG5BZf7Vn84Plj+fa4M+wEAVO4EQi6A19OhmVWHN9knduqr4JuxK
         f6X4MGNQm1pkAtxVHiU6g35x26WT3W+evwAHfrUuUliADDZ7tGMiop2iRS2RD0nGFb11
         JX+LgfegpuasJp4FnBw714c2JvZbV0OC0Ew1LEvzsGvsPIK6x4hjBlInBU/Yup/JojPb
         5zNQIezFps1JbulkVrFTduMYrcurs9QMC3gAeDwgCFdLl82qwZQxA/FrqqHwoz1JpyXU
         kMcaVav8hnp2Jef1CnazumKeIB01zv120teJiheKwsqirmANFjWXlXXl56yBHYPa/+DN
         m39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761879848; x=1762484648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rB1+LZPkwFY008oY4N4SwT8A6lc9mI9L3ZvDOPN4piw=;
        b=JTgqPN3SO3GiY1hQEQBBxSxpcrnQFTR+ZDL39tYq1CRu4nEfZovRCTyMw241oXDauy
         PNXw0l2cFd0vMBu3KYgzod4yPPBJJBPPsl/VgZu86Ob5wtMIc6EnNwrEF2D7cSIYPn34
         OL69Q6JUt9tzDEReIqwJcj2ZslbiDZZPV9jFLPRCmMOKiGOMHP3IGaqth1vXl0Lr6uF7
         4QEy3FxaBeUj4wnprbXHLhPn0R17XRG+Og/vwLoJVqYLjRERiQo/x6WWYABaT1TaAnyr
         4PLuwPAwvF38f4WioEmjHB/0pv6ntg98JczgUgDUzcbg8wNPKWJCTMt34e5+3ONuVzgj
         K9lg==
X-Forwarded-Encrypted: i=1; AJvYcCXqUwty2XheNRm5h10esVA5uC8qiRZyUpllo4WUGFLBthilgPdw88+TlcoxkF3EHGUAVKr5muXsyw==@kvack.org
X-Gm-Message-State: AOJu0Yw751JuxfglnXqjmzbl8m36tYhxYS/0YCmwOKYkFzD1qeLdh254
	L9hXOF+wj5lOxZaHBb+Yrl+Jv7pNqZT1fWA+c7CXSM5CsrNz1KI85SdBeWaTkvHEsTRy3uWa6Ur
	PqMM+urNvtMp4OBZXsEERnpjYedk1d7I=
X-Gm-Gg: ASbGncuoBxsz+QD5uyiY1soaFhFKdA7Cq0s4vt2tcQWfx96o1Jb5u/TJCsJ5jAbaItD
	0Hc3PaN0gA/fjdsxFt+CTj2IIC8nJbjKJ8mlg5Gt2CIJbvCdKdIFpkdSq8QWXRjtF6Nlp901/P/
	WYGToUDuF1Rl+SPY5YD4F2I11cQGUtmUmH1sfWVsX7N0NDyKzCQMOz045MQ1FIqDxMxckD0CTpx
	hWy8hoYfOLBG5LZwigVgLXSl74cyNxgZ4mNFxADqbZg5SLaXy+opirXQvRm8xs5dGnvQAol
X-Google-Smtp-Source: AGHT+IEsp6bhgRsy8ZEn85Qr6vOIkt2gdB3bVnGU3Gq1UCl2kGI49jRJiPmXq7RgqzS4b09IRWebGz2bLvXPLAd+uuk=
X-Received: by 2002:a05:690c:45c4:b0:717:ca51:d781 with SMTP id
 00721157ae682-7864841b780mr30065937b3.17.1761879847982; Thu, 30 Oct 2025
 20:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev> <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
 <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
 <877bwcus3h.fsf@linux.dev> <CAADnVQJGiH_yF=AoFSRy4zh20uneJgBfqGshubLM6aVq069Fhg@mail.gmail.com>
 <87bjloht28.fsf@linux.dev>
In-Reply-To: <87bjloht28.fsf@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 31 Oct 2025 11:03:30 +0800
X-Gm-Features: AWmQ_bmM-gv798v1iqUntXkV_a5zia70abL0uoWQ696LNsBFCfXEwG0AGFz5jnE
Message-ID: <CALOAHbAnH=mRmWUX8v_8GcnvEYTN6cDR+w9AM1p+nYezA+LD4g@mail.gmail.com>
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
X-Stat-Signature: 3ueyhyt3y6stx53c84z5q1h6ub3x94fj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20ED9C0003
X-HE-Tag: 1761879848-329602
X-HE-Meta: U2FsdGVkX1+gK4ARU5wqkhvDUkMuPYA7cZoWnYV+FYeLgC0tA3CJc6ELsF+rwTBczVba4RSnKKxyKfFrCNMBj2EXg60i+p/MjCJuSJpduGx+hWyC9zo/8toGCfel11hWI/fqq7wMN9wiNM40Aki463lp6rb3g6+eC+8+kw1ZbfsSfUSGPScTu6p2oXhdqxYl/ofx6gIQUdYP6clzwc5Hy/grQUqG9PRHJPNWmRLHBOqwi+OSk6hq7+3CgmsNCadthfJuybtpxext131clILuJX7uQFTK86mgoU1Vbd+/1sgaMtJWgLcfRdqGAItcO+r+szPWUCzMFvvvxyiWyZNfrVv5V9vbyuLoxUq7joTBeUovK3MBY1RJURGwV7UQ9O6HDFfddj8/HTshyCp+d0npDhRTFPjoDs09WXNNznfdiVacoF3dTmeejYGlwjJ401Lgq2hRZxTNmHt4XoDL+NtT4P/KiF40kDmUiRwnGuIGdo1mZIYdwklpKrLZEVRiPKv/MHtN+SI7KYiOdXf+TzFwCxOypdLx+59QrdLd8Y5oUZFGyPX9mhO3cPIBhQsRFv3PtfDAfZtGhc7M+jGP0nTQO3nVT826UqmIFALXpG6VWS6iSpJdJZ0KTSHweoXW7sXdqv3QVLrxQLjkEAHUNFJpzQqju0Pgkqn4x68+rN+/EEtsc0djLyMJlTgU9ajQMfhFJhwDaAsMP741NqQbZ3pJIO9Gn3pDoMMmXhNgSHiR6fiLRvPLjIe4FeZdHyD1+IHSto0sI4a8+08nR70B0/7k89cv3gLM8iMXVQ4XwV3reTgRkdtbjheIHIm4aGYeQ2BmE0Jl4ofFX2rzSqOmAjEw8RuUEJVxp/j6AkbpiLKZIuJIG8mklq7g6Hir5lF2GomxINn8w6wQKdTrKa066D3MjdVcMyjW7ONzUuVJwKMG/QbE6z7UNxan90O8wqCJLil22xDlFRzl74ed2StRHdm
 9I0hHemi
 uoFTcsXbLXP6XAPQxugHXGQ0NpUsu52OF9oFqGMfd9t0/Z5KYMfrkvCoN6a6k5mGEfhPzjljwy24Y+nCvR82P7X6U4abGXZaQP+hshFUh64O7eWDaJVF2fNlbfjCWcbT/tdIaAhKxP2x3a5AUPH4LCVSWQsWDyuHSSiexNIlb0pljb1hPOXU/8hsCWLfXoWKrEuYuuK9H+AW9YisPwZcApyFRHQIxs65HWiNmmtjzyLmMYsCytTSauXqtWGbL7VGyxW/lw9xGHOXrUB0MwjJO90teNr6OHiZiEuKMf0VK2B28eu0gLkonMTnQ0sBwAzh9a3qP8FUKO5KPaplKQie5/R1Aa+QAvxdn//hTkaugixIjXzqctbK9WJC5UsBROSCZcHHV/vjMaOo0ExtjSazTnMkjrfstcWz36vjUdL1Sc4SQtR2TqbVX5fFEvt3WjA/iUAcnQ2QQzl2XsgZ4HFTDNg0t4HNM8rcQCXxUZ9qL9SDyxuMpM90KSl5wmQDmECzNz2pm5N7fiFhtSwG6vBZjNZMNpn4H2TtZB/mqjFD5/O2QvoNCi3LRb7HvMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 7:30=E2=80=AFAM Roman Gushchin <roman.gushchin@linu=
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
>
> Also, as Song pointed out, fd=3D=3D0 is in theory a valid target, so inst=
ead of
> using the "if (fd) {...}" check we might need a new flag.

I recall that Linus has reminded the BPF subsystem not to use `if
(fd)` to check for a valid fd. We should avoid repeating this mistake.
The proper solution is to add a new flag to indicate whether a fd is
valid.

> Idk if it
> really makes sense to complicate the code for it.
>
> Can we, please, decide on what's best here?
>

It seems the only way for us to learn is through practice=E2=80=94even if t=
hat
means making mistakes first ;-)

I can imagine a key benefit of a single struct-ops-to-multiple-cgroups
model is the ability to pre-load all required policies. This allows
users the flexibility to attach them on demand, while completely
avoiding the complex lifecycle management of individual links=E2=80=94a maj=
or
practical pain point.

--=20
Regards
Yafang

