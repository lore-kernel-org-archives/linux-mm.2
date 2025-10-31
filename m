Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F02EDCCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 00:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050218E0072; Thu, 30 Oct 2025 20:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0275D8E006B; Thu, 30 Oct 2025 20:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA64D8E0072; Thu, 30 Oct 2025 20:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8ABD8E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 20:05:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50848B7FB7
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:05:39 +0000 (UTC)
X-FDA: 84056465598.13.37C5521
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 43EDD140010
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:05:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S4LwM/Pa";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761869137; a=rsa-sha256;
	cv=none;
	b=Ei0BkTC93Rpyaat4hfIa5axX7CrBwGzJsEcCN5iS97TXlEydvQ4XArDwdciXFmBG6VjTU6
	WDKte0iRB8Q9BYvG9wuH6VZu5Ym4eD42WO3vcNkTHm2i6UUDyrjfIU56XnifIXbj6Kz40I
	Co+9xWnzZHRkGo4T8rv3hmH1NboDINU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S4LwM/Pa";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of song@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761869137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lL44yd5kym8YMQUQn8UATM02q+rFzlKezIb629r05+M=;
	b=wT9yrmVTCKjoe+OoP6dz7XUsUVsIVvVS4DkXQ2R5Mo0zczprQS2h5Q+eF+9lhAGcS+4bwE
	3cfV74sFIjOp49P7dPQA89ek5XIW/PMdmNrdAicJD45DtJAOvzkCB9GYjARWLEBYm7gfxX
	gSRlAtHRTBI1pN7CUhBVsRComhGLfhQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CE89600AE
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023B3C19422
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761869136;
	bh=9VKqbvQ0H9Mj3WzCt4xuE6UVqwjCj2GDyeee2UsBLTE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=S4LwM/PacmjvNT/z+BGhXQR0bFJ/AA5NKaymAjclz9J7EzSpv+LW76C4QZcu470KF
	 Wpp/feMOtLlKKVaQLHvyL1Nw6Yfqc3jWAY2q6ccxUV7ao9L4oa7kFRDIe5rgoxd4Q6
	 9ZS/ZlWhsXw6bJkL75nXtbFGUqFdF4YbhGw37wTBuRuRHSFuQnvmR3eOkLmX7oz/dR
	 zKZy2PQgCm3cfb/J84aEubqUhMShsFMkskGYMWuDafUlu+sjxMIpg5jGXsGAmHCBxC
	 RH53HtgXAxUPYGHr+xZ2ce9gGpCfQgT8AYLMGEvnQXQIh626Hu/wb/FvOXp1bNYSDc
	 yqYalBOOJWfEw==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-87c13813464so25996126d6.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:05:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUzb2umAxZy4cWrgZ8l26nlLitwInz1C0FFEcK6LqqLk+M0EUeDu3UaGF6e1PKHs64kzVvd7D2KNQ==@kvack.org
X-Gm-Message-State: AOJu0YwGH2/Y+G4ZYXCSZTIg7oDCKzg6J/9xtDWmosUf3yLgii8r0u4/
	GMdiWfZcyoony1cXkVXJrr7S1Qij1m5OiwDDhhNSKGtYxEt/raCRHsv9gBsAo92UTs5vRcXpw93
	GSwMXKyXkoIkZybt5+v8OkEkHGykJEDg=
X-Google-Smtp-Source: AGHT+IGIzNtfwNoDxezTaQZKGKWrOwEoUfbbhhapkjPj6bQRt6E/XRKTdN4NkyT+j42m2qLXtYIu1gkkBiOYxBVeCbU=
X-Received: by 2002:ad4:5bec:0:b0:87d:ff71:8fe6 with SMTP id
 6a1803df08f44-8802f2fe005mr17787766d6.24.1761869134901; Thu, 30 Oct 2025
 17:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <CAHzjS_sLqPZFqsGXB+wVzRE=Z9sQ-ZFMjy8T__50D4z44yqctg@mail.gmail.com>
 <87zf98xq20.fsf@linux.dev> <CAHzjS_tnmSPy_cqCUHiLGt8Ouf079wQBQkostqJqfyKcJZPXLA@mail.gmail.com>
 <CAMB2axMkYS1j=KeECZQ9rnupP8kw7dn1LnGV4udxMp=f=qoEQA@mail.gmail.com>
 <877bwcus3h.fsf@linux.dev> <CAHzjS_u5oqD3Dsk9JjK942QBL8UOMkqdM23xP0yTEb+MMuOoLw@mail.gmail.com>
 <e027a330-8d51-44e5-badc-7c3ec4d41e23@linux.dev>
In-Reply-To: <e027a330-8d51-44e5-badc-7c3ec4d41e23@linux.dev>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Oct 2025 17:05:23 -0700
X-Gmail-Original-Message-ID: <CAHzjS_ub0KBECge8DhaEZts1aYL5bBFaU=fJ3U+ZV5XdSjq1WQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmvv5xFRVlfh5B0U--valCRYKaA4OXxb-nAPkWaZTi3-DVpvDlxN5zRvRE
Message-ID: <CAHzjS_ub0KBECge8DhaEZts1aYL5bBFaU=fJ3U+ZV5XdSjq1WQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Amery Hung <ameryhung@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 43EDD140010
X-Stat-Signature: mnf71fteq3d53h4bbwr3pc3dkkkoao8a
X-HE-Tag: 1761869137-402399
X-HE-Meta: U2FsdGVkX19EO1JalG0CaUNa8VvY6FzqIOAqdYEccA/3FfKWkR/dwkF+AbxSqJJ0iXlvckFfCzQDai/rPd8S5mi4XUYN+cmOgvzg/2aUDPw0vZGdPmZOUGw2HjTpwHlrOXN2cMwzwWzTmd1o80paToACkLImVRc7VBZKYxWqki9YWFuoHr9zpeSmRTP2H35AIjxpI3F+3NvGzd81p3pqvjFWK0xk+IV4yh06/QMYFTbGK3CeJS88/QCBUknTKuT6GfYJ36cxEsijlAz68p21uqeqdOyvAUD8ygeWxdHkZxsXotCcx2vMefaLU+EEflE/jhnUMhim2Z2PwqwRaUjBtQbczq6u1C8/2Pzx3Wvhd+om4BlgO7Wd+VGR7SFlNzp9t1woEdPA4bFsxllpzGOoHj5dyJLu9ypdEk7Rmgnz9eALnOkqGjK0VkDqr2EydF8G/s4+TzUV4jhSJuaIfdGyeCCDQq7YMo/77+HiiIga/l1g5EJTLL80Js1P/I/gnyfXrhtaMUjxbcPyJVPORFtzS3780iw4YJ47Eo5fSvMmtwWEKh0OAFj998vkEaPtnCPklEJI1wnA0wgtCzLi2qWwZezM8/tC7Nts46e4gcX9PDiBv3a0v89oINpnjLz4HRf3HebFPQYoYXbMm+8l5TR3s745dGr2ELAs01jg/TwCu/7hNMKw3HnCgew7BrCqJ9mVq+octM2GDQdvgS0cW9UcS3ByGxniJ9JSiIuTJfYsI/XNjZzRSj2We+Bu9H/kU6BR7Iu39zCIHKu8usIhHUbCCnoIH5PwJKn9VqvV0j72AXm0ZX8r89OTjb4XlJW/WzqMMRMONy0bdZpRAy5LBvSlWKimGNWUuPyGFjetNnQ3fL95VoAa3KZdJKZxYOv/wDtEQnmkFAPucmakX9Jpp45vtaIC0EFBmj7sMCEWL3sr7HdeAZmkpiYdDpt1w+igB/qDlNwHzsEuEr8+E9oG6jZ
 QNGsXKWm
 DP1BVYcfmUAneiPPgZ1zziIA+vy4c3LdNI3AB9SScVHvnBLyfsXNJTqGRP4d6yCAhOCq5L6VB2+j7oqTT9yeG+0JuuLBywpz2tFRweWgGNDUl3QpMRoU5YPeiOnNui2ppWqyQ24aN2Dmo/nSG3M2wmrBx7UL57EshjVx/wr6/DD05r060TFSJM873VVa/XpS4KsrluHOILDf8njKuZvFRTC+8XxXHLuCh5gSy2AWP7vHZV26yOKFySjd56xfaGBws15RPz+qjsxPbwIJOQK7LpfsnGEteEJM1MUeAfzuDXzKay8LNIp6zUeuTvclu06L/wKFCUAXKE/r26mY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 3:42=E2=80=AFPM Martin KaFai Lau <martin.lau@linux.=
dev> wrote:
[...]
>
> The link can be detached (struct_ops's unreg) by the user space.
>
> The link can also be detached from the subsystem (cgroup) here.
> It was requested by scx:
> https://lore.kernel.org/all/20240530065946.979330-7-thinker.li@gmail.com/
>
> Not sure if scx has started using it.

I see. The user space can poll the link fd, and get notified when the
cgroup is removed.

> >
> >> 3) Move the attachment out of .reg() scope entirely. reg() will regist=
er
> >> the implementation system-wide and then some 3rd-party interface
> >> (e.g. cgroupfs) should be used to select the implementation.
> >>
> >>    +: ?
> >>    -: New hard-coded interfaces might be required to enable bpf-driven
> >>       kernel customization. The "attachment" code is not shared betwee=
n
> >>       various struct ops cases.
> >>       Implementing stateful struct ops'es is harder and requires passi=
ng
> >>       an additional argument (some sort of "self") to all callbacks.
> >>
> >> This approach works well for cases when there is already a selection
> >> of implementations (e.g. tcp congestion mechanisms), and bpf is adding
> >> another one.
> >
> > Another benefit of 3) is that it allows loading an OOM controller in a
> > kernel module, just like loading a file system in a kernel module. This
> > is possible with 3) because we paid the cost of adding a new select
> > attach interface.
> >
> > A semi-separate topic, option 2) enables attaching a BPF program
> > to a kernel object (a cgroup here, but could be something else). This
> > is an interesting idea, and we may find it useful in other cases (attac=
h
> > a BPF program to a task_struct, etc.).
>
> Does it have plan for a pure kernel module oom implementation?
> I think the link-to-cgrp support here does not necessary stop the
> later write to cgroupfs support if a kernel module oom is indeed needed
> in the future.

I am not aware of use cases to write OOM handlers in modules. Also
agreed that adding attach to cgroup link doesn't stop us from using
modules in the future.

Thanks,
Song

