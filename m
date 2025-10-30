Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926ACCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 17:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25188E0130; Thu, 30 Oct 2025 13:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFCC38E0089; Thu, 30 Oct 2025 13:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12628E0130; Thu, 30 Oct 2025 13:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B00718E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:57:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5EE7314021E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:57:01 +0000 (UTC)
X-FDA: 84055536642.05.AFB0E71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 724661C0002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:56:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bNy1TNIH;
	spf=pass (imf20.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761847019; a=rsa-sha256;
	cv=none;
	b=KFnso2z5cSEVVDY0XAMB/VB+uvwfH309hVIRYxQcmMXpZBdOXq+9pGHO05fxUDeDQE1Pnt
	/6lwMpxicPPqPInP7L8Z0NtKEys2mOBpYyUbxzAYlBr+Ln9SWDL+GGIhzFIi/oIMUkGSO4
	aTWnxe4F3wl5GhlvQrPe9HLFCG/HEZ0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bNy1TNIH;
	spf=pass (imf20.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761847019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4R81vMmD74JblHD6qEjugpyOXos54O6IHtUH422ALuY=;
	b=y8vueULBzroRCVvVEuG2v6i7ikPv41+aeSd95u+ExJwlmEBEUioxDAdKXeo6cSs2yIpAV5
	6nXRFcT7ncSBVbCEb6S/CTMpQtKni/er1/PXeaqVniRwndWXHOnupvhBhnFh/oKKy+UzjG
	AdEjExLeP6WY8OFjPQ56fs4WZjnDIN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9B8362119
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3380DC4AF09
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761847018;
	bh=L4e38dPwrZFuVUdrOXcK15IuGB2HADfsVSi/LH7EXVY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bNy1TNIHT4oh1zNcC8sVErbqeUGH0NdpOLL23T5ZLdkao4z9GIIVqIiseSkcpwvnR
	 ODrApNwOMu49aC8f4/Ay41C2Z5Rl/jRXuTbwc9uutwpuYKYafqz0lfzpHPZaFkjPBq
	 /Gv6wJwGllB3EB5b7c/8Udarnxn4FJqQmba34/yh/jurgpBWzaUJ4WEGVxChmZmPJy
	 Lbw1PHiI9glZW16qK1noe35LNZQ++1PZHp+hRcUyFMgZh4Ha0OmebYoBHW3ZaQiJcs
	 pGoSX9w/5hQsrXHv9WVMNE0RFVMjDdhb6XaZv79XOUPhKxk0fCz2g8LLZt+FKlZGZT
	 lHoN6TphqhRWw==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87c1f607e72so17106906d6.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:56:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVzY7fEA3FAWDiOS87tYrI0nJMhNYRU6USGgTMwbCvoKPXPYiimr6PmG9hNzQC4jpWDpVeWq/AWbQ==@kvack.org
X-Gm-Message-State: AOJu0YyFgk9QQvHRV6yuyr/qrkNVfdXZFcfUBgy3Fl5T0UrLyXGxtwqv
	axT0n2sPFHHhb7C2DBK0HDW2c0t3wguiPKywGbL9M+pPhiZUYMN8vpEk04lNkxlyP7OPMPzeqdB
	4/IYobBV+8Sm3N7BORxKrIxdoI/DziLc=
X-Google-Smtp-Source: AGHT+IGYyUVn099A8jUIhDfDtH7YzdBkaylMEjjWSMZn4ZGTG4lQaMNVRWm1lO7yUAm0bhxQuqgolicbaQLQisRUzJg=
X-Received: by 2002:ad4:5e87:0:b0:87c:2405:5d93 with SMTP id
 6a1803df08f44-8801ace00d3mr46673516d6.26.1761847017110; Thu, 30 Oct 2025
 10:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev> <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <aQKGrqAf2iKZQD_q@slm.duckdns.org> <CAHzjS_tEYA2oboJ-SPq5wJLJTpJDNiA2Fk1wMRgyEpH0gjZRJw@mail.gmail.com>
 <aQKLCuX5v5aO3fDa@slm.duckdns.org> <CAHzjS_uqFLEzvU0PTQiXajdFDsjC4gfk0Z4qMoiRQJ2uVPw6BA@mail.gmail.com>
 <aQOOxybyymnUk8fr@slm.duckdns.org>
In-Reply-To: <aQOOxybyymnUk8fr@slm.duckdns.org>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Oct 2025 10:56:46 -0700
X-Gmail-Original-Message-ID: <CAHzjS_vp3xpCx8w9k7ct1RHOLnwu5og59Uxqs9DE_Ye06x3m4w@mail.gmail.com>
X-Gm-Features: AWmQ_bkz9aBpQvreSJqyHHlBR3lFj06W4EhoUxVWBl9_g8_PXU87iBGP0a7GP5w
Message-ID: <CAHzjS_vp3xpCx8w9k7ct1RHOLnwu5og59Uxqs9DE_Ye06x3m4w@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Tejun Heo <tj@kernel.org>
Cc: Song Liu <song@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: iffag8ta6an9kt8pbduez7rs1esazb3c
X-Rspamd-Queue-Id: 724661C0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761847019-378631
X-HE-Meta: U2FsdGVkX1+aaK2u5k3dqQHeViP09Ytq0044fNXltWI9X+Uub6zNwWfB2ME/+f4eADPFoCnd0nq/b8w6DbPX5Puk+91NCqYthw0AdJESsqkdEmOViZh4ikxqsazHBK1rDMBWLDIAlPqdDV7WCO2hiXOAINj1qSLZr2534Tpuyt7Nvk7aiX+UHXuKxb73JEkq/gD8Bd2VyaxvK1JOomLi5CjtJLfmPStf1PFmnvLNJirF8lr9+e9ndNQfeuk8wsritezCqrrgrudqDeEv0WKy4GESRNzT3+kjEbiMz0elhqVlU7dH/SE70NrxWpjv2/ymxFxXeakjvMDrsFTJcPynfLcq29CpT3GlVeeIg4NPFkMXBJsoEJx9Go0quKhcYctDqX5jLGhbfGkjir5yZWQ4J7Vx42ayViEQmN2MtHQI69nZpH6LohnGvl7Hr//4/7NbfWDSQ73XYEt4Bzv4SxjXsjxnZ+WwHK8pQqTKdXSTzXe6i1Q1VYE5F260NOy+YPcnRmJ18ata34r51/Bi77/R9meNfj1r4TijdKDjKGk0NmlKCWyb22Utw3mqE5DY2EmFdtdnEU/0ZpY4lfTPP7or8E9m88ZfDy/T0OWMMaxZqWejCw8zR3kDyfK89p/M52AmOhfY2PlcSbyX382D1180ExFHv9TZJqddK3BGtOIS7GUmlrKCwcUnB1AGchuU7v/aCwWIf0nhwulu6qlSP0aYJPjWCrj5dqiC7GfMjqKq0i0jpS8f+HxyVWFLfeH2rwTklgmxf3SP32LhifGWCxag5hdbTLLHU3e3neiPInUNwpD1NcRrUe5JEGWCm8PGyVmcyLv6By4qXFZLAJZw9ZgE3PdQFxWy+X+bG4WThQUqO69k8a2hoFbn7g+15SlLgqpQ1W6tC1RRsYaeER53qWpT47KpjNM3XYzr5m64Iz5cI2hv9l7a1DFBz5dweSELtc7whcyOTMK1iGWUD5W+Xve
 7dvAvQix
 ZDPceQhg78MJH+hekZ3i7ayC1PtcTCW3W3vXReX+9/VxQcZznJhwYg2w21DCCT/RmEcsFhodZ+Tl5PwX8dYDiqvG5xWPHS0f8Q3/zVsTObwNhowEGNx/3y3dUDvmFczyp5F2bkxqslSAJC5JEH6woTui387PvbGHX06WsNswRY6Jp4jL1Nme9CXhMERLyNJnSC205lTtMptkBKoxfY0go04RqEYaprxR32uwf9R1EWpZPZJVpl9+xnPCIMBTIaqxsM3kUwUh0PYLtvZZqenWbW1Bv4HwDp8Ziae8j4CseeeeWpW+23GMfvs0x+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 9:14=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Oct 29, 2025 at 09:32:44PM -0700, Song Liu wrote:
> > If the use case is to attach a single struct_ops to a single cgroup, th=
e author
> > of that BPF program can always ignore the memcg parameter and use
> > global variables, etc. We waste a register in BPF ISA to save the point=
er to
> > memcg,  but JiT may recover that in native instructions.
> >
> > OTOH, starting without a memcg parameter, it will be impossible to allo=
w
> > attaching the same struct_ops to different cgroups. I still think it is=
 a valid
> > use case that the sysadmin loads a set of OOM handlers for users in the
> > containers to choose from is a valid use case.
>
> I find something like that being implemented through struct_ops attaching
> rather unlikely. Wouldn't it look more like the following?
>
> - Attach a handler at the parent level which implements different policie=
s.
>
> - Child cgroups pick the desired policy using e.g. cgroup xattrs and when
>   OOM event happens, the OOM handler attached at the parent implements th=
e
>   requested policy.

OK, using xattrs is another way to achieve this.

> - If further customization is desired and supported, it's implemented
>   through child loading its own OOM handler which operates under the
>   parent's OOM handler.
>
> > Also, a per cgroup oom handler may need to access the memcg information
> > anyway. Without a dedicated memcg argument, the user need to fetch it
> > somewhere else.
>
> An OOM handler attached to a cgroup doesn't just need to handle OOM event=
s
> in the cgroup itself. It's responsible for the whole sub-hierarchy. ie. I=
t
> will need accessors to reach all those memcgs anyway.
>
> Another thing to consider is that the memcg for a given cgroup can change=
 by
> the controller being enabled and disabled. There isn't the one permanent
> memcg that a given cgroup is associated with.

In the current version, bpf_oom_ops is attached to the memcg. As long as
we feed a pointer to memcg to all struct_ops functions, these functions
can be implemented in a stateless way. I think having the option to do
this stateless implementation will help us in the long term.

Thanks,
Song

