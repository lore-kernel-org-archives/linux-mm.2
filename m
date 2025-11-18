Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BE7CEE336
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 16:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E916B00A0; Tue, 18 Nov 2025 11:11:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F161F6B00A1; Tue, 18 Nov 2025 11:11:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53376B00A2; Tue, 18 Nov 2025 11:11:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D80426B00A0
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:11:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76B5DBA347
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:11:59 +0000 (UTC)
X-FDA: 84124219158.17.2CE56B8
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4B00940012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:11:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KL+hTn25;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763482317; a=rsa-sha256;
	cv=none;
	b=xwQYVEyO3in5CJaf6/vyvSW5LWAJr49sfmUnT0dU7Jy+FN9UhXb7YPcn179fbUc3LCVhbO
	KfD27HI53WxcKnh6KuNENVnz1mB9wVaxTXCbyumEyMQ0DtPuFSBLiEBjP3l8HwytgQXqXf
	LudAmA09D1g2tkTaTU1CjQ8w79YoVfc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KL+hTn25;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763482317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIeOJnxlLJq6unMitN9z5K1Cj1/iT1QGU36BvuUqR8U=;
	b=rBPB6PzdzE3rcwwiiCvLP4IfiDqB0mMP38+khs0Iwll6AFFzz0arz9E3OU3YNN91qFY/xQ
	n+SbV4H40YS/Dmzs/ME6nF+fvtuZDOU8pwqj1453IiXm91Eak4D4V6kWP8FnttiWm9mQGs
	efAsBozSsiYjTbcrTRcD0DnSqmGHkpw=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b73b24f1784so285451866b.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763482315; x=1764087115; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIeOJnxlLJq6unMitN9z5K1Cj1/iT1QGU36BvuUqR8U=;
        b=KL+hTn25Eh319nYxrMWP3AiAy/XKsL30kvqwW0n0IxNO61wTL+hqlbPCgal560MJUk
         taZNzpBJZu+yH77t8F4BMamIp7K99SztQjiXMCcrVOv8QQCCfc0yoywywzcnAXCBTHIE
         yqnxxpBcH8oBVOqJYg+lvMJK/MjWrwfXu/SMhGVxfUKkBSv95SO8/tNcPdH/9UTtm775
         /nY50Z0uQUUgV/VTAdG7pZiPnTYacrIr+S5CaCg0l1mi/EBxRFcXZ2iy+nsXYlB5rX8M
         zQpb9y24LPfBoBUd40UkgRAqxvaKwBV1q1T0day66nH0jHXVvD+liXENIAQYQ7MVOg+0
         7Ruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763482315; x=1764087115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yIeOJnxlLJq6unMitN9z5K1Cj1/iT1QGU36BvuUqR8U=;
        b=H7as1mnNBQNSSQXqqeENF6HA14+PUoZQsiMBJhXY39vKh787mbjZVnvDuyN0l5rwQ9
         yaWwZWyvGzxM81qvxC1GKCN1gBEVdkSIjCGvpD5lPOHfvHA4hVl0Rjz1+fR7IvwHsuir
         pPb/AzUOb+1CzmajO4bWmr1QG8JEdn/SYV1o5pRO0CW16iCYuGTFb5RSlIGkMJR8PY4Q
         LWHu5OddLyPn/NN/oZ9u+C3xrOKUIeVac8LK/ofKfeMATAiA62kB9PmCc7SWaKICutVB
         Bl+G/YXHKfuqVIKxu3E/yRgtYJBH/6rN1CVblAfAyWivN8tbaAc7HaLlP1EX0Qi9nu+J
         XAXg==
X-Forwarded-Encrypted: i=1; AJvYcCWzHvL0EDYzbwujqTm152TOlNkCTnwtNTOsQEbbEOYcOVxYlemuCrHzSoW82++AYHM2idTcmkIIPQ==@kvack.org
X-Gm-Message-State: AOJu0Ywtg7wy2nnbZKOgGaH1Cws1lxEI2fzRDLlPnkFPKBy+YuLc/NsG
	AC4Fga/7c0TPy4mIBTj/M2ekNzeqqmLLLADnu3+zJnDD7GG4rL3IyZ8mdMHACkYk4zCa2u5xzNn
	wMAR74uZseh3UTSgJzzgXvBOtJNBP2iNk5SNhrQYYmw==
X-Gm-Gg: ASbGncvCCzQlccLFO2QwMgpcQUrYlsF/v8lWHlNk65jgn6Cwo8oDNjfL4B3zYMB6A0p
	+fyajdl4uOxO/ybZh7vBcUd2ZrmmDuZcWq0GTLQ9xz8A9typ75y944tiSkasdEFQfaV9Bl+XGqj
	PkinXR1+l5goAmjqCZESAdLMLoTFysenrUxapq9yaopOjHNKAynuBKZwp05wYTOGB9TEyvipPvw
	2PKKY2bzmUXQ7tVyFdQzpCC3Ga4WxUscRVhXatEsiZskWyNG8w3JOJXa/tGVXlyksHo
X-Google-Smtp-Source: AGHT+IFHXvld5bm2qlzNd0Y2ybfozdwR8s6ttYI14x44odTpSeo2AgXFTy6L97nlTwnrr84Th1Itshlxng9A7gKWAlE=
X-Received: by 2002:a17:907:7e8d:b0:b73:1b97:5ddd with SMTP id
 a640c23a62f3a-b7634736285mr4050866b.8.1763482315319; Tue, 18 Nov 2025
 08:11:55 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-2-pasha.tatashin@soleen.com> <mafs0ecpv4a4q.fsf@kernel.org>
In-Reply-To: <mafs0ecpv4a4q.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 11:11:18 -0500
X-Gm-Features: AWmQ_bnCG4YfqGfoAbQTxY2D5ZCM-y47-VoI150hvneRrqrf0ng4Jg42xOKdVlg
Message-ID: <CA+CK2bDfxMhNQKjZD1uRSrg+wJYcFamji_oBvGBn+bnsb4Bbog@mail.gmail.com>
Subject: Re: [PATCH v6 01/20] liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B00940012
X-Stat-Signature: zkuj1n3eph1dqboo9xpdrswn7xf7k8s6
X-Rspam-User: 
X-HE-Tag: 1763482317-311458
X-HE-Meta: U2FsdGVkX1+EDjQwR4KiaOoE0DHGASfzOEokv0mguI7DpDm3yuoCG97zzd76S+dHYDCKOWx9sBvTm6awfGuZhswkjiGa+GlvK7PVvWwGrnowEIdgmCRDFlVFIDcsIjVQmLxoSQDyL+oz2Lz8ct8gKnhgZT20G4TjGtLkVOaAILaWPwSVHLqT3OM9HKT1rT8Hg7bsx8n3aVKGkUbvQfjkfbggkNnt9jgQAd/E2ejtUgODaGHRvx0ihJvFKD8dyogNWUAR7cqxyM1zTa1j+trF1WnpNnFPr5vamWxJzAw1jQ0Nj0SoZdD2SLknknesN6BWbdSvUhQBwr1HDovvCWnJg4eoZtnGrpewiXqSfqWz36rFTpQXJx8DsS+K8a6DDBtZDguGGXTR7vHqfNSrGqZmNthpCDSy7Y16GilQlnbljmAg4ru7897WHOD1C96QediT2aP7XuzfpkAkRsqnFYwNP0uWydyFfUd5TxMYUQuPNeINQ095g4qaa4ZxEFFlY6h840mH1udmPVLFnJ6RPs2YRB+XtVdJ+qILxTCNTL5mNytaxuNRyc6b2XCczw/ozKMMrWl5L3Tu348NRuLUsFtnphxsCQkART9aUi6fJgEpYGwqN11NiI57yuWf92WeD5+ToyndANR69px+aq7hX/o0YhrO53RQ5sdDuk7gzrTecK0TpT2onnJQSVGwfa2O5FV0MyLolXpjfj7Gw52RD1s/p42zd1ZPfLLLii5oqgxUvEq/dGjotffq/rxCTQ3COfUtAJ9hh/DQFTyPy9MwgtPE+uZTQYRknxrREoeg/NHS1r7T3wTbuJHgsYAZyoT8MupMwPiCwnwZKXx8GFqogyiWciM2MB2Wkfa6xjfgS4WFJke8/gSrQnPKf7BnGD08o0rZ2Wf+Gy2V/P8xPW87igD3cYvJ6K/5M72KfbWaBMW8bLgiGkvFwsuCHSbTzZGS8Y3sKebd7OWG1Qx9y/MFwQ8
 0ToeSZic
 MwDumTqU5ck0/ZOH3tperpFJorVP3IMDBq0RcVKJZwsGkM4YEoTKWoj+YS+9+Mvr1w5NL8O1VefV6CywmS6FVzyWeGl6D3JCKEDm9zqicph+hdgaJjjccpFLPL/4nmVChhxjxdFnC9/LZmHBM1FHv8AciFqOv8VaTYBvqqOeMc8BdZFeZKraUQEhz0sENf0r2khKJn1yZo5QcOtfY5iP56x8yaTlCsqqBh0eHI2yHcBAEEbis26Ngk4QRYHwqMcF4lwtSp+cvUAxRyDG9Yps75FodNoS2QY6A4fz8TEqhZAp16Wnzxchcp/HoOGgqnTZm5E+jUPgyyB2s1GYzWmUeK3ORxj+JlRNcnJ72UcBYrIQPuvCXPL6c5Kv3NY373FCjR0UTtvwg6wf900s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:46=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Sat, Nov 15 2025, Pasha Tatashin wrote:
>
> > Introduce LUO, a mechanism intended to facilitate kernel updates while
> > keeping designated devices operational across the transition (e.g., via
> > kexec). The primary use case is updating hypervisors with minimal
> > disruption to running virtual machines. For userspace side of hyperviso=
r
> > update we have copyless migration. LUO is for updating the kernel.
> >
> > This initial patch lays the groundwork for the LUO subsystem.
> >
> > Further functionality, including the implementation of state transition
> > logic, integration with KHO, and hooks for subsystems and file
> > descriptors, will be added in subsequent patches.
> >
> > Create a character device at /dev/liveupdate.
> >
> > A new uAPI header, <uapi/linux/liveupdate.h>, will define the necessary
> > structures. The magic number for IOCTL is registered in
> > Documentation/userspace-api/ioctl/ioctl-number.rst.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> [...]
> > diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.=
c
> > new file mode 100644
> > index 000000000000..0e1ab19fa1cd
> > --- /dev/null
> > +++ b/kernel/liveupdate/luo_core.c
> > @@ -0,0 +1,86 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +/*
> > + * Copyright (c) 2025, Google LLC.
> > + * Pasha Tatashin <pasha.tatashin@soleen.com>
> > + */
> > +
> > +/**
> > + * DOC: Live Update Orchestrator (LUO)
> > + *
> > + * Live Update is a specialized, kexec-based reboot process that allow=
s a
> > + * running kernel to be updated from one version to another while pres=
erving
> > + * the state of selected resources and keeping designated hardware dev=
ices
> > + * operational. For these devices, DMA activity may continue throughou=
t the
> > + * kernel transition.
> > + *
> > + * While the primary use case driving this work is supporting live upd=
ates of
> > + * the Linux kernel when it is used as a hypervisor in cloud environme=
nts, the
> > + * LUO framework itself is designed to be workload-agnostic. Much like=
 Kernel
> > + * Live Patching, which applies security fixes regardless of the workl=
oad,
> > + * Live Update facilitates a full kernel version upgrade for any type =
of system.
>
> Nit: I think live update is very different from live patching. It has
> very different limitations and advantages. In fact, I view live patching
> and live update on two opposite ends of the "applying security patches"
> spectrum. I think this line is going to mislead or confuse people.
>
> I think it would better to either spend more lines explaining the
> difference between the two, or just drop it from here.

I removed mentioning live-patching.

>
> > + *
> > + * For example, a non-hypervisor system running an in-memory cache lik=
e
> > + * memcached with many gigabytes of data can use LUO. The userspace se=
rvice
> > + * can place its cache into a memfd, have its state preserved by LUO, =
and
> > + * restore it immediately after the kernel kexec.
> > + *
> > + * Whether the system is running virtual machines, containers, a
> > + * high-performance database, or networking services, LUO's primary go=
al is to
> > + * enable a full kernel update by preserving critical userspace state =
and
> > + * keeping essential devices operational.
> > + *
> > + * The core of LUO is a mechanism that tracks the progress of a live u=
pdate,
> > + * along with a callback API that allows other kernel subsystems to pa=
rticipate
> > + * in the process. Example subsystems that can hook into LUO include: =
kvm,
> > + * iommu, interrupts, vfio, participating filesystems, and memory mana=
gement.
> > + *
> > + * LUO uses Kexec Handover to transfer memory state from the current k=
ernel to
> > + * the next kernel. For more details see
> > + * Documentation/core-api/kho/concepts.rst.
> > + */
> > +
> [...]
> > diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioct=
l.c
> > new file mode 100644
> > index 000000000000..44d365185f7c
> > --- /dev/null
> > +++ b/kernel/liveupdate/luo_ioctl.c
> [...]
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Pasha Tatashin");
> > +MODULE_DESCRIPTION("Live Update Orchestrator");
> > +MODULE_VERSION("0.1");
>
> Nit: do we really need the module version? I don't think LUO can even be
> used as a module. What does this number mean then?

Removed the above and also removed liveupdate_exit(). Also changed:
module_init(liveupdate_ioctl_init); to late_initcall(liveupdate_ioctl_init)=
;

> Other than these two nitpicks,
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thank you!

Pasha

