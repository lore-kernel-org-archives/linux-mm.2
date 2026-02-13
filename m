Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A7A8EF99C8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 18:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742C96B0005; Fri, 13 Feb 2026 13:42:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0C66B0088; Fri, 13 Feb 2026 13:42:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCD46B008A; Fri, 13 Feb 2026 13:42:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 496EB6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:42:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E6101C647
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:42:36 +0000 (UTC)
X-FDA: 84440304312.26.6CD2F7D
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7A82DC0007
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:42:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Pv/xDQ7X";
	spf=pass (imf28.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771008154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRyqI2OlYJ+i9bGoT0WPB4u8JuJ7emTXqtyPAz2XLtc=;
	b=XJz3aR8ycKBqfq9hJ3FGNSU3FLg+M7T7f0/9ONkgpGBX2BKVjNdGcuGLAxCJ4/KiJy6YeV
	AMKqS2y0FPxPeviw+rEgOm2aO3mQUtbN5Uq/oAm7eSiGJeDWLPsWl+N8+Mn8uVLG8VEiZe
	BeLGtlcC1OoosuCxXXmdLJHjtJl36Co=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Pv/xDQ7X";
	spf=pass (imf28.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771008154; a=rsa-sha256;
	cv=pass;
	b=amGDjyRMi2k0uep5nrJ3rtdC8IM/4zsOHKZLS5+C/CJPTU4FC/dG8AS0kdkPwU/71+PUUb
	Mnu3425mwgs/gCqPRrZQnEfE3RH0Qu0psIMe0Cky6EljZb9JEbJJbqqLYgRie7KJKkR2U5
	AZeiaz7CLGg7fXuo2MZT/VAT1uP8Fvk=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b884ad1026cso166152566b.2
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:42:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771008153; cv=none;
        d=google.com; s=arc-20240605;
        b=WanhfCsdnkchRAn+AjB4tvfOi339LXsAl6GlUjhWXeBwTqF9byW+2JxrRCqPtTSgTj
         mi06yVfANgLKByebU1UTO6nymQifZVvz28VHJ2edKqQSsHIZdEhr1s45uTZfvoBb0FRq
         8XuUGxSlEgQWjfPsB9XrHZVwgfobz/4tzXJJfJhP9x408AzYtxBORqNh9kwTa2efrnmt
         DKNoglL4UgN9dGMtGzsibtH9vKq7cBErf7H3VI/lLsXIx9N243qBp/ygcrldspJCbNRZ
         dFIiRVxU4dLoAGnifMBna+pkjTfOx1dD7A8xTDC6VY7qd/iYcXPwz4+l9MQvzqALch98
         eYHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WRyqI2OlYJ+i9bGoT0WPB4u8JuJ7emTXqtyPAz2XLtc=;
        fh=EZCeb0cQNtVVg8KEOtyfbOEdGkzyiHapVaVBHLKTGMU=;
        b=N4+bLf4tkEDflRf665CMObvsqOnsVL/V+v/sD0s0z1yXUXIp9y+5YA+XySjntyYu8e
         /d4HJE9B+k9oAVOQtTQ5CPwRSLSJuJthEchuu1rX/IGxLMfoc8d+GoMipdZIPczt7cp/
         E4Slj6h7cZdDWaV2y3MakxYzD3v4lyizLvHOTD4X5xxExN8nQOGfXPmIemxA2tQltXyo
         URBl2+nnYoEzH7s4dO/2h/3Qq3Rp83DaTe3Zm/3/R4O2FAcH2YEpkm10SypEX5rgIY+1
         XGcPLBYMpxJygyvw2A9rTuGryJlBSWXsKgGcHbq4Xq2F0StUgbDvzXUodwf3ND2iJ2je
         nVUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771008153; x=1771612953; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRyqI2OlYJ+i9bGoT0WPB4u8JuJ7emTXqtyPAz2XLtc=;
        b=Pv/xDQ7XHhNh8x/3K9m/bnr+0EwEw4Tp9pBJzDIe8UM67acg8wUsD9fg0i8ZJ9/fjR
         EfRJASLC7Auq5WcfvDwKZo1kc74QW/3FjaZ9opCG/rLwBmlNGF1FuygSfha6AHHPQxV0
         yuY3DWusrUajdCh1V6suNvj5o1YMcPvyu2DA+VaeLeI+mTeq9eGVeZ9gxamubLvQ0SE4
         T7vvojc5wxt5BJybXi+AzkXj+9nlqPR/IoFR52mz+6hKxPPPgd24KTklR+2O3C1jwyAI
         MZvP0KpCtJhDlgu8K5UdM3U+H0NMyZKrB9PS36Q0IR/GRMYL2W19/hgDKlHG7kN2bEvU
         ct+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771008153; x=1771612953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WRyqI2OlYJ+i9bGoT0WPB4u8JuJ7emTXqtyPAz2XLtc=;
        b=Rbgfmbz+6wGWywaL5H5E6Ql1MDyysK55/CAIejIQufpPphxQ0CNKnogHCf4IWsc4pI
         IOxJkbYUOuYkwByz7mRVERsdGAnnbVzbfG8zC1TFAola7vgljkPaC0FJrO/nnMV9bTLw
         1BDgq/r/OYzFB+VMGE2erLRWNcMCSeJq/vTBYEJ9d56bSpRtWgjaeEkIbzhxrdq8RalD
         vrj9rWCSSGRDhYjjPGQuaEFymg9wtpWm1SD0alDaWCv3/DhLl9U9FMrboiw7qh8CylBE
         1spalynv0z6WUw38voW4eqP5R8OEt5qaWs94Wt852WQcR8DktxlWRTbK4aviiTmbbaQl
         Aq1g==
X-Forwarded-Encrypted: i=1; AJvYcCUfCi62B9hbH+8muN4J68l1UBrL8yIsQ9xam9Xz3cofEiH2+CpSCGaTqM0YWjBaoDxZdsNNpSbO5g==@kvack.org
X-Gm-Message-State: AOJu0YydC5jDOkMu1RGjvsEEPPQ/W4DmQAIc2VOqyBvGw/YljCsy4w+R
	+YYDoWDl/MtwChW/XPIY869JETe9pDHsIJQ3LmHSn6elF+jc0EGR+6SJ45glk70uH3cjDucsqBs
	RNEUiFz5hdlW+NbUwJ6bEca+QWYmVTvg=
X-Gm-Gg: AZuq6aLlAVzxEmAt7leEBkMt+IbDnTOeWuJOiiEB1yHNnaZil61X5/kBQUrhKCvikbk
	wNM8WVXTjeCTMD1GzE4eZxEZJiHFcF3pkguoNfX/g5FL+l9AFTHcDu+QWC19cU12hTDk19aH7RX
	PeDiyHW+CTMqFPCauFb3EZfQBai2RD045FdDWbxd2C4LOMwF//bbM+wzJmR1GzDFz6pvVBIxwsg
	oOMadtMzqaCFxuc3WeOw7NbYhKI3huCgGKtSUEYFN6B51jGTanAXfiOF/mkoxmcxxfxNcO28YN5
	k/aNAjrDIQ==
X-Received: by 2002:a17:907:7b9e:b0:b8e:2a8a:4320 with SMTP id
 a640c23a62f3a-b8fb451d649mr134117666b.49.1771008152704; Fri, 13 Feb 2026
 10:42:32 -0800 (PST)
MIME-Version: 1.0
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
In-Reply-To: <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
From: Yang Shi <shy828301@gmail.com>
Date: Fri, 13 Feb 2026 10:42:21 -0800
X-Gm-Features: AZwV_QgFs5A3ilN32WlLIr88IqlgxC9Q615P_hQS9G23bOKivbPazZKv43jJXtU
Message-ID: <CAHbLzkqRjuWg7ybdkuv5xdoPz7z_q2n+0Eh0pRNoVxq-WskRvA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>, 
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org, Tejun Heo <tj@kernel.org>, urezki@gmail.com, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Yang Shi <yang@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A82DC0007
X-Rspamd-Server: rspam07
X-Stat-Signature: tyjfn6nsaztgub67p4nr5up4sqygwusw
X-HE-Tag: 1771008154-180129
X-HE-Meta: U2FsdGVkX1+7mSdvtyofAFQrRss0PrnMUdXfREZMTrHf+P4l38QKymGnZ2srviP+KVs2vCkXybVMfNGEjk7ryVb3KWEuX/LaKjb/iFndBsCci6o6p37D6SCTHDmT6OYO2of+/1hXL0ryu42NfYgG9LS3u0d9PRFN66SAeaR5rNOW2Pa0xeSXNCd9aC/GfYUNYsFRzNqGCRsQuCcP7s3wQU7hgxrqYmdHPiAOqc2qHmDlLzL/xUSfpCfenhTqhTNIpTqxCVgmOa5OKgrTjXzzFXqgSBm6Ys+/33Apl0jvCGjZVGRtLAjkdcIn/+Ufmx2Qt4sy/3VimBVkFddZc6QF8NhKBmiFbzvlBDBqt08B7shQqrMJxXCMrB+re9+6exX9Kg08TlwcMLPkpbL/lU0Nk3xg57FJG4321oG4sIJdA5gn0z1wQx+72yUydxXIQ24f+AG9nuTBmPZklvBgCv98sinppMNBPzkTVsDdIXTwDRDuggCvXamHIwSXNsjbWC5+FSe/ciw4+Q9Wg54t9/gxwn4oMBqg/iJZ0lBkChO943xSBym2OGbDKE/j73rDlKGGsDNGVvSS4ii+nD4ClCNX839de6mmhoNvhWVKQROfNGTgihtbatW/G/QOaUxWYWwwp8xBZhhxrCkKfBsVcWN5HNb1Jrrb7X0freNY5CyMCPtitgs3sRCleoUhs9YcoZdBJba/oAl2ALTTAAyvkohelA6AjhXk9G+jJYaDHsyeFoNwCQvR676d6kI2AQLlMxJXZRi9six5iga/HJ5NcliWKmXdm/rfNtwKC6aIHKIjbNobu7IQAAF+g9XQ5ceUqnHl52anrOGdkT0Ix72ceMHHDuhKjbQa7U9kXRAkNlCj9kLJNqHHypahUbggIaXqTg5GNGyztUmcD4KBjRF+MAMV1Am2lUyyN/tiiB2gXz0+WxR+s0Wdtf+dyyduBED/qmZmaOGmtNjoW0dJrMWmMLY
 GndST/30
 C5vzRxHaUZcIhtZ3i08wC+qho6QJkqML9LsU8VnaN2k/YuDaEhy4XwMEChyjUeOCl4hV/dTF/dV7k41pHQXHyc+fb1BXHyPxq3jZpFUn9uI2qK8JKIUm5Ih+LAvanwCM3rVicfRKp1DaUT3BcaW9ucuS27mb4pmWgD35h+MTWYATrnd2Z/FreWjaamYHAHu4HLrmttpto0HNGn/YQ1M5Pu5IgWR13/WFgPk3HvfrqC1IhgIc9Cnbvh4RPL3n4Uv521yZl/7vR49VWZdSg2qzvR3CLkwXYcYFnGu1v4t4tJi9nWItzbahkHy96nmcA3AhUHPmsj0/kR5RcSfxfJJwwZj4ZxcV7oFLrrqVS7UvK7FDWf63uDqAtsgvy5JbOt8IVXJlmG3Jnpt/18nnibmiBHXzECUflhX6EbJBgGWmcSyHwYuFLAkt421OEvMeQMOdad9qZTbTfQesLbFpjuxJeN/0RmclPQ1kbrXutyfjU1pbV90P9kevicxWK1xQaZLy0eTwwnDxs+F1YSx5ZObbVl4x0oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 10:42=E2=80=AFAM Ryan Roberts <ryan.roberts@arm.com=
> wrote:
>
> On 11/02/2026 23:14, Yang Shi wrote:
> > Background
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> > The APIs using this_cpu_*() operate on a local copy of a percpu
> > variable for the current processor. In order to obtain the address of
> > this cpu specific variable a cpu specific offset has to be added to
> > the address.
> > On x86 this address calculation can be created by prefixing an
> > instruction with a segment register. x86 can increment a percpu
> > counter with a single instruction. Since the address calculation and
> > the RMV operation occurs within one instruction it is atomic vs the
> > scheduler. So no preemption is needed.
> > f.e
> > INC %gs:[my_counter]
> > See https://www.kernel.org/doc/Documentation/this_cpu_ops.txt for more =
details.
> >
> > ARM64 and some other non-x86 architectures don't have a segment
> > register. The address of the current percpu variable has to be
> > calculated and then that address can be used for an operation on
> > percpu data. This process must be atomic vs the scheduler. Therefore,
> > it is necessary to disable preemption, perform the address calculation
> > and then the increment operation. The cpu specific offset is in a MSR
> > that also needs to be accessed on ARM64. The code flow looks like:
> >     Disable preemption
> >     Calculate the current CPU copy address by using the offset
> >     Manipulate the counter
> >     Enable preemption
>
> By massive coincidence, Dev Jain and I have been investigating a large
> regression seen in a munmap micro-benchmark in 6.19, which is root caused=
 to a
> change that ends up using this_cpu_*() a lot more on the path.
>
> We have concluded that we can simplify this_cpu_read() to not bother
> disabling/enabling preemption, since it is read-only and a migration betw=
een the
> 2 ops vs after the second op is indistinguishable. I believe Dev is plann=
ing to
> post a patch to list soon. This will solve our immediate regression issue=
.
>
> But we can't do the same trick for ops that write. See [1].
>
> [1] https://lore.kernel.org/all/20190311164837.GD24275@lakrids.cambridge.=
arm.com/

Thank you for sharing this. We didn't know Mark used to work on it. I
thought about using atomic instruction to generate the address, but I
doubted the cost may be too high. It looks like Mark's attempt proved
my speculation.

>
> >
> > This process is inefficient relative to x86 and has to be repeated for
> > every access to per cpu data.
> > ARM64 has an increment instruction but this increment does not allow
> > the use of a base register or a segment register like on x86. So an
> > address calculation is always necessary even if the atomic instruction
> > is used.
> > A page table allows us to do remapping of addresses. So if the atomic
> > instruction would be using a virtual address and the page tables for
> > the local processor would map this area to the local per cpu data then
> > we can also create a single instruction on ARM64 (hopefully for some
> > other non-x86 architectures too) and be as efficient as x86 is.
> >
> > So, the code flow should just become:
> > INC VIRTUAL_BASE + percpu_variable_offset
> >
> > In order to do that we need to have the same virtual address mapped
> > differently for each processor. This means we need different page
> > tables for each processor. These page tables
> > can map almost all of the address space in the same way. The only area
> > that will be special is the area starting at VIRTUAL_BASE.
>
> This is an interesting idea. I'm keen to be involved in discussions.
>
> My immediate concern is that this would not be compatible with FEAT_TTCNP=
, which
> allows multiple PEs (ARM speak for CPU) to share a TLB - e.g. for SMT. I'=
m not
> sure if that would be the end of the world; the perf numbers below are
> compelling. I'll defer to others' opions on that.

Thank you for involving the discussion. The concern is definitely
valid. The shared TLB sounds like a microarchitecture feature or
design choice. AmpereOne supports CNP, but doesn't share TLB. As long
as it doesn't generate TLB conflict abort, shared TLB should be fine,
but may suffer from frequent TLB invalidation. Anyway I think it
should be solvable. We can make percpu page table opt-in if the
machines can handle TLB conflict, just like what we did for
bbml2_noabort.

Thanks,
Yang

>
> Thanks,
> Ryan
>

