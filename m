Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69FFACA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6076B01F9; Tue, 26 Aug 2025 08:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476756B01FA; Tue, 26 Aug 2025 08:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364CB6B01FB; Tue, 26 Aug 2025 08:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23ABA6B01F9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:03:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDF7D1DE566
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:03:52 +0000 (UTC)
X-FDA: 83818774704.04.E6C55AD
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id 17D2E1C0005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:03:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gj4TG0zT;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756209831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nINdU7ZKfIKy1EEWB7ufRqfr8Zsb0d4U8Sl/GImC+Ww=;
	b=J3ItkdhOiVTxtG40FcGEpdb/2qBp3e92tuheyFEU1odyqQwZjCmKSFggt7oFHnHTEN1WEg
	95Wd6Ythwdi3CL/1lCxJxJbYgvLix2My87Fq+GqVmmAAzUW8pTTmKWmED6ReRJb9dkzSWE
	MNWyq81Shx5am32J8KD+SCwFwBpFY0E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gj4TG0zT;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756209831; a=rsa-sha256;
	cv=none;
	b=QzALcUQziNltZOYAmmpCWtj9AvQZOGIzJb12b+EDlmqSeaevc6Oc19t4Do+T8BBB/YKxpr
	YQz6wBhJppXokTXrjuxENJEnKUJUzeepyq9gfKDw+PxRZKxCwMWq9FHa/LyAUrbf37DGGx
	WefnySK0lV1ASsGIgxPMLyjsaHFFjFU=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-70d9a65c328so33755206d6.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756209830; x=1756814630; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nINdU7ZKfIKy1EEWB7ufRqfr8Zsb0d4U8Sl/GImC+Ww=;
        b=Gj4TG0zTihjE3Yh+pg92PF6bAsRDi/ht73sWHI/i6uJKne4tx3R4q3bpB+fG5q8bpp
         PzCA2fjNtTI6A9dCa1TFh+BugA8bdEaozjVtLmuPInRBLva7ATJHgD/Fswt0Ltm0imwS
         xowyq+3PpkiA79VqEHmSwaPyYIDWd9vLSzyUiuG+lJedmX+Wnk35+JWDK9fKLR98Z44z
         ZNpwiXgFSsU+zdLk9yuChq5FGjJ93YLL5DLI7t0Ih5rH2NzvEqUn80sIyBu4jTLzOoWf
         NzaA7+k4BQtutwABvzn975to2D2Ug44G/4UU+Fxkn73c/5U316N3heiNhDaTz+bLfySY
         sOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756209830; x=1756814630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nINdU7ZKfIKy1EEWB7ufRqfr8Zsb0d4U8Sl/GImC+Ww=;
        b=Cp3ayhKvSZz9yuguqyfWoMG789BiJV16PyiBc+HF9m5eoESQPAoS02h3DmYscHOWSm
         bXRmqeEgUWFAMP715wDSw04xmFYQPoPf9nFKZN9cmUBZpkC2nDNgZPmkDvbuAqO3r0Vl
         3hLfyMI+BWC8RNkrAW+GO0kB12oJOBvolIp/U3wGeAL7OY1gGJQaVFAtlzHiKtI9wZew
         OzM7aAHTghozohbHwP7Oev2dnHl3RFvoiyUq6UJm/2S1x5n49zsd7i0Z27+irbsCpZxy
         IZ2XoSw5E4u5jYkprRgsJxQ/AhcQ2L4taNPZJLqAHTzJ7RZnbcReExhyD1DPKrxwNXiL
         b71g==
X-Forwarded-Encrypted: i=1; AJvYcCWaW1J7BKtWIwZUnI38PDEDhSq2xi4LnFpWMgp9ZozMcjbkTiMtLkpGsaca8iPWEIsXj26OQ6+sPQ==@kvack.org
X-Gm-Message-State: AOJu0YwF1qSqgOLTT99GiPcf8kYzo9TnXfLJK1lrWqpTDFfTCi9jqLor
	TqmjdMqgZZxlzkk5cz8pQ4zeCVUyW6DlNzNZfUmr3Zstz6dKvADiQxk5MYRYaFjFE+k99T0zuta
	ur0huL8jE+g0IujDQmO0qltfITXtEuUw=
X-Gm-Gg: ASbGncuHfPr1aSrIcPmJsqWKxmtnvZ/6nFVwRONUEaYG/YBcFvuDepwwvru/LdPdaLt
	z0L5+j+jxwMg3ecQx43F8gIVU5mX3oQW4EA+OErk+6h87nsUojx5U2J6Dk8h+QBqeJqlNEUABnn
	CfNsVdk997mbGjOcklPY+R5wp9BCVMnVPWnCZmLExdIMB6invHMRaay70a02YMvjuOfzZjiqALn
	8Cjaims3kkQVGuUPIdyXKWqJ/EgPSVuUhB1u8d/cSnc6UgKn9c=
X-Google-Smtp-Source: AGHT+IGfNLNHfEjbYUBZOTOvD+RrHO3QOGRLRnNPyHmbopSrERqyuL+ygoKpCg+N0F63//8tBx/jLH2XA0mYvdF5J1w=
X-Received: by 2002:a05:6214:e44:b0:70d:6de2:50d3 with SMTP id
 6a1803df08f44-70d97212ee2mr175699806d6.64.1756209829711; Tue, 26 Aug 2025
 05:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
In-Reply-To: <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 26 Aug 2025 20:03:13 +0800
X-Gm-Features: Ac12FXxAMWmgXqxqMn86i1pgaDl2fr9t1rbnFdtwuYwKZ28ngZsdmxMlz2l-U7E
Message-ID: <CALOAHbDZCyUCMYkChVtWgYJci_rXVmMMpGtpeYQWeXW1egVNAg@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 00/10] mm, bpf: BPF based THP order selection
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	yu c chen <yu.c.chen@intel.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	libo.chen@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 17D2E1C0005
X-Stat-Signature: gj7eoj1a1bot6oas16xxgm6pmir5tcm8
X-Rspam-User: 
X-HE-Tag: 1756209830-955772
X-HE-Meta: U2FsdGVkX19JX7vzP4DoCXvgwmKXKHOCr2y4BwmGuMXat/IvwUoq8cIkO4EzV8s92PPROnNIk9w5/Az8361B6m6rJ59n3SeDXvY75LPzd//7DRmGm0vmdoFh1LKnyLIvXpD3ftZN5r0PbUgntwhgzEbfNw8f9QAZlghhrP1e7wMb5wvy6eY1QOF0z01MSHOY/kY3EeXEGkmBJRK8kEdqKxQDsw5Wr2KNeM22ZhirFfhozBioQGGsjb7eGi+AhGk2+Z5CNJ91x3z4YvuoUV3rtvHMXmRdI5k3DmxI44tltQRrtY6rWY68nddn1OiVP4S75/Wll7w3pJDoLaqz1d12mm4mO6QxCBTGfpiKKA8Hi4pDMbQdEKGSJGTyDY2gWMx1pAdxXAF9Fyu23swJuvcrhcK1if7+AT7lGsDj2voDYCAHO5JflnCsX0ey+EDSgyCZnNVlF1OGDwHRPiQOdHERpYGX9TTa6YmWORpanrTmAjSWIlQuZ4JmrsvoNaoZfrC64g1vynyU8aXTeMldYifG1S0SYLSPvtLecWN67UW+M/aG2PSbQ/FwSk9YgKf+bcmK0jxLuH7HJPQILcgmLi8I6Pk6fqQFTwCMztM8cgVi6n2n/n0o2FmugMW+C9XznmskohaZ+bcLaZwV27NYmgaferictDTHTyinOV7d7XdA+pW28OZdU+IENTRLMKki16YeSjiJd4IYroVz2muAHhTmWxKTR0dmyUdtYt/jbR1MBX6xMhJqCgV9sOlcpzCJJjLCLSA1krF5rBJcBF1v5dKTzrtPigatNUlGT3cu+dsu+4Yj7qr9Zl+4mOppLUZ/bB1Ky1X2Zlr2oQwplSlaEjy3sxbEjh7u+RlbWtLpH4d6yesxp8/dq589+yI+DLRJivo7z3s18UsqsxZMjDYT5MxzfRm4BM7RfbZ/dpT2cir5wmLWBQZig8ehoocAkL+DVLjAGVgGOULtvpeXQbFW7aP
 SA7PrxW6
 L2ocJ9ZAzdtlgn6wme0cspvEK7nB1NG7ru3EWdrXbfUoNxX8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 3:42=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 26.08.25 09:19, Yafang Shao wrote:
> > Background
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Our production servers consistently configure THP to "never" due to
> > historical incidents caused by its behavior. Key issues include:
> > - Increased Memory Consumption
> >    THP significantly raises overall memory usage, reducing available me=
mory
> >    for workloads.
> >
> > - Latency Spikes
> >    Random latency spikes occur due to frequent memory compaction trigge=
red
> >    by THP.
> >
> > - Lack of Fine-Grained Control
> >    THP tuning is globally configured, making it unsuitable for containe=
rized
> >    environments. When multiple workloads share a host, enabling THP wit=
hout
> >    per-workload control leads to unpredictable behavior.
> >
> > Due to these issues, administrators avoid switching to madvise or alway=
s
> > modes=E2=80=94unless per-workload THP control is implemented.
> >
> > To address this, we propose BPF-based THP policy for flexible adjustmen=
t.
> > Additionally, as David mentioned [0], this mechanism can also serve as =
a
> > policy prototyping tool (test policies via BPF before upstreaming them)=
.
>
> There is a lot going on and most reviewers (including me) are fairly
> busy right now, so getting more detailed review could take a while.
>
> This topic sounds like a good candidate for the bi-weekly MM alignment
> session.
>
> Would you be interested in presenting the current bpf interface, how to
> use it,  drawbacks, todos, ... in that forum?

Sure.

>
> David Rientjes, who organizes this meeting, is already on Cc.

DavidR had previously reached out to me about this patchset.

Hello DavidR,

Would September 17 from 9:00=E2=80=9310:00 AM PDT (UTC-7) work for discussi=
ng
this topic? If that time isn=E2=80=99t convenient, I=E2=80=99m happy to sch=
edule a
later session=E2=80=94this will also give me some time to prepare a brief
slide.

On a related note, I=E2=80=99d like to take this opportunity to also share =
a
short proposal on BPF-based NUMA balancing.

On our AMD EPYC servers, many services experience significant
performance degradation due to cross-NUMA access. While NUMA balancing
can help mitigate this, its current global enable/disable
implementation often leads to overall system performance regression.
We are exploring the use of BPF to selectively enable NUMA balancing
only for NUMA-sensitive services, thereby minimizing unintended side
effects. A similar approach has been proposed in [0] using prctl() or
a cgroup interface. We believe this use case is particularly
well-suited for a BPF-based solution, and I=E2=80=99ll briefly outline why =
in
the slide. I=E2=80=99ve included the developers from [0] in CC for visibili=
ty,
in case they are interested in joining the discussion.

Looking forward to your thoughts.

[0]. https://lore.kernel.org/lkml/20250625102337.3128193-1-yu.c.chen@intel.=
com/

--=20
Regards
Yafang

