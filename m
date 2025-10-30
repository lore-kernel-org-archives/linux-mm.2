Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 923BACCF9EA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 04:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FC88E0124; Thu, 30 Oct 2025 00:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07428E0112; Thu, 30 Oct 2025 00:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6378E0124; Thu, 30 Oct 2025 00:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 791908E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:33:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21FC9140A1A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:33:00 +0000 (UTC)
X-FDA: 84053510520.17.9FB4297
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1093A140003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:32:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WeJnR1uN;
	spf=pass (imf09.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761798778; a=rsa-sha256;
	cv=none;
	b=bpZHKdibYcFNKa2DKgf/lYNLKDNgSgGIBinZo+JFng2nw/eRHiIlxasnsYsCHuAfDyEB2t
	Ve65Gpjxjx6Qav1qesmV1mvOH5kHFdUeC3dPHKcLM4Gjh2BBDqbF8OeCwF8FNB+NdVYKzE
	ehpwNZ4V5rixuX0J+JVXByxypZw6T7Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WeJnR1uN;
	spf=pass (imf09.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761798778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+z1T5qe0BEWsRnoExln/Z4hYxDSCgwcWhQEzRmDVBo=;
	b=M4cqR+6cwTcXRZSHOcibeaTxpxdM20DlrQmAcyzCo945xx00H5X7sNMm+tLN0Uj9uOMClE
	HiEG5nuJ1qmHZxBFSGYJqVx0YqrPI4Zj2Ok9zSwr9ouj+SAyll/EGAdG+ESyRNNqKi6AKl
	ssQ90qBf80/m+A7/aq74CEf7/P/CS5s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA39644F1E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ABBC116B1
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761798776;
	bh=2+HmoIuuPHdF46s6IU1j+vbuARn+2oyq4R4SBJ4cmyM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WeJnR1uNJXyR/VIiggqLZKlHmEWtr8PryGvaMIFmduLJwWzm1WB3bNYZDNsL28ECc
	 MhDcS0HqaDu4a+jGMxGWRcOc3a9c3WeORfl68Q8MIVrn/3glItC3V/l8jPsSnetLWV
	 jgSiFHeJxzZfa4EdmfRpJBG4t0FtKzgdapHdkjBW7cXdWT+4JnANg3Y3vtkIsobS4G
	 QRziJ5k7RnLY1yelWNmBiZBFq2AxEhu1fa7zdDP4W3M3oplHLpwgHXEML3DEnepGmx
	 4+E3yX35xj2+E7UGfsPtOvB1r4EB9OTEHnDncfql3sxs+0VthaZ7+TzKGffw1AIwEf
	 eXybCRuKBpJRA==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-87c13813464so11125876d6.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:32:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVDU9UYyIrgbvINDvBiN2ws5yI3kG89+r/ERzPNomik8Pm/iChGpDyh++I+oL8XMAVae3RvjWAd1Q==@kvack.org
X-Gm-Message-State: AOJu0YxcBhee5fEjC4gWe5CUD0RX8vgEkAv8dnEsqzgJFwaTCjj76CXC
	xSse8R0NvcAj5H9s+oFdXIFkxcFD8Jm9PErR+rjTjbL/GZ4AUMWu3yJwa8VXvDyLNgQhE6pEdPR
	IWXlj5Eg9jUCA7iyA933qnihd4g207o8=
X-Google-Smtp-Source: AGHT+IHloxlOPCQ2Ts01dfa61gbcBoNiGNoZLr759SYfOuTvCEnTg7bX+Fomvk0pFNs84BbMxKlEaTxyHv6uOFm83Y0=
X-Received: by 2002:a05:6214:d4a:b0:798:95da:611f with SMTP id
 6a1803df08f44-880099a7c5amr62818076d6.0.1761798775656; Wed, 29 Oct 2025
 21:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev> <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <aQKGrqAf2iKZQD_q@slm.duckdns.org> <CAHzjS_tEYA2oboJ-SPq5wJLJTpJDNiA2Fk1wMRgyEpH0gjZRJw@mail.gmail.com>
 <aQKLCuX5v5aO3fDa@slm.duckdns.org>
In-Reply-To: <aQKLCuX5v5aO3fDa@slm.duckdns.org>
From: Song Liu <song@kernel.org>
Date: Wed, 29 Oct 2025 21:32:44 -0700
X-Gmail-Original-Message-ID: <CAHzjS_uqFLEzvU0PTQiXajdFDsjC4gfk0Z4qMoiRQJ2uVPw6BA@mail.gmail.com>
X-Gm-Features: AWmQ_bl3_-nL5SrQXZYMREaXDnsMqEHzXuINIJP6UEpQTMQi_qleUcR8dgaKd7g
Message-ID: <CAHzjS_uqFLEzvU0PTQiXajdFDsjC4gfk0Z4qMoiRQJ2uVPw6BA@mail.gmail.com>
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
X-Stat-Signature: pbkmzq11kdy9s8ekk88rg5j6ifoir7nk
X-Rspamd-Queue-Id: 1093A140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761798777-274827
X-HE-Meta: U2FsdGVkX1+TWzoLqmm4LrFXG/Xd1h/VMeRM+AnLa2UD/6C09ZxW4YFSU3o/u3ZVh0BSxEIwsYaktrsMBRqB5W0sBbKgmowy+R8KYINpyFetboD4LdBM4dFR96w09xueCq0KmqoGA0yP9KUIS8BWUnGwUPlgIopqcpTRdKVcyTchi8CVHRO1tEDu1atpACrMOCT4r8GlIgQbtygICisc4Guw+li7x2I+0phDNhxgwxdlTYkNijmHQqY0L5rgEQXIgoIy3bJSmotyKakDJXk+LE/N1PFbbYzC6oDno9EOx5ywcl3bS1SwiySXZLIoDa7w3bVBLCTQnYZcSVjPG7w6w4yXdaFaU2t+HN0zKw95zYUxXnCRJJ8kWyS5A9jXPKf11T+B6tew+/vAEZIUWVbhVby9Lo2etUtLykgPfCue9KtOYj/XVgcZx9dP/1el0F/mNalxP3S3XGzXhE4WoFdhqh/vPuGLTVeh1AJeFl+eXGkuB50+Kmftza7yCcZ8AoES0jx6bJrR6nMt/NEJr2VTZqo7OEI1KU1aZ1eCkp7o84kT0xTiLUfoIye3JbIs26Jp4zouKFMk58k2Neqp+ZyvkvTX20HaZHpOydzglgGlYzbYF8FbIHSIyjl9mKKkIa0nnN8HQ3ZdJ97WciutFP8fAB/5fC8vZi8LoWhHHoX3Kcpo+0HTidAu4awh/X577z29t+e5r7TdO9K+mh7/F1o92hQkRLNwKMeUT08HzJJCvD5+GUjigKXKiDmwIlK9FmXrYVKjmPX8zvNKjTDeRNg5y27S4c6f9a1N3efYvFzGjDFM9aVe9cnm7jGpM26+D9KIN6gaBE9L+tn5MPrn0xv1vUbUeT66lGi0N9AkQuJ6oCSLCzN09W7JK7ZIkJHGIbN9m5mUrnMOq1tAv9BohFSxnuPzfl88RXA2EVktImQ2JHQYFCeMwBmZxgR97K3VhjO5v4BYvmT49rLzNdGLgE9
 Ll1Ir8xu
 L3C2wNKwNEDZRW4XWo3/Rh2PGnOyWuKMYpTR8KVLypT9PkL05+PEIGuiaB4M5R606g57ZzChBcmCkPZgdqrjBgiObuDea1P+2oJUk11LEHHqkX4yPTJuPSjlgohQ99lgNofYbbXSLFSkBSUP//AlPqMmSEypwh9tNTH85tGFo3U8lQs0tbQxgupLemMEVWOPRBRJEl97PdBr+44FrdfMHc3RYIrx+lYk3H9phKsi5QV+Bca2JLG/DSmy+moWztI1gFnMvtWcRoR2pdjf6s2lTpa1tgzJO5q/kKh/DxrWVGIoiE/S0pceN+b0dcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 2:45=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Oct 29, 2025 at 02:37:38PM -0700, Song Liu wrote:
> > On Wed, Oct 29, 2025 at 2:27=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote=
:
> > > Doesn't that assume that the programs are more or less stateless? Wou=
ldn't
> > > oom handlers want to track historical information, running averages, =
which
> > > process expanded the most and so on?
> >
> > Yes, this does mean the program needs to store data in some BPF maps.
> > Do we have concern with the performance of BPF maps?
>
> It's just a lot more awkward to do and I have a difficult time thinking u=
p
> reasons why one would need to do that. If you attach a single struct_ops
> instance to one cgroup, you can use global variables, maps, arena to trac=
k
> what's happening with the cgroup. If you share the same struct_ops across
> multiple cgroups, each operation has to scope per-cgroup states. I can se=
e
> how that probably makes sense for sockets but cgroups aren't sockets. The=
re
> are a lot fewer cgroups and they are organized in a tree.

If the use case is to attach a single struct_ops to a single cgroup, the au=
thor
of that BPF program can always ignore the memcg parameter and use
global variables, etc. We waste a register in BPF ISA to save the pointer t=
o
memcg,  but JiT may recover that in native instructions.

OTOH, starting without a memcg parameter, it will be impossible to allow
attaching the same struct_ops to different cgroups. I still think it is a v=
alid
use case that the sysadmin loads a set of OOM handlers for users in the
containers to choose from is a valid use case.

Also, a per cgroup oom handler may need to access the memcg information
anyway. Without a dedicated memcg argument, the user need to fetch it
somewhere else.

Thanks,
Song

