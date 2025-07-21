Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BF6C83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586448E0003; Mon, 21 Jul 2025 19:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D758E0001; Mon, 21 Jul 2025 19:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A968E0003; Mon, 21 Jul 2025 19:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7B28E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:50:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B783F1A01F3
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:50:48 +0000 (UTC)
X-FDA: 83689919376.01.340FB89
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id DBF0212000B
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:50:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2HYgAOD4;
	spf=pass (imf29.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753141846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IB72aB1pAV9dq+XvFFbs2e0X7c42HGWgrt5SuJCD/0=;
	b=YxABBCyLJgnkdQQD93Wz+WWcjRAqBvM2wtZfmtRP+CmzK0Iz5psMFcqVbQzMt89nGzXC5Y
	RUJ4sCbPU8BvcQKhylkWNBguGqWH9h+sDESye7g36Fc6xNDowgvD6w3B0pI0T77K05pYIB
	boDQ3rymLxyAkZm5M8nPGaMlwkYhiHo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2HYgAOD4;
	spf=pass (imf29.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753141846; a=rsa-sha256;
	cv=none;
	b=Jfoukv6JoWjFsi1AfrfTIxTMbF3i6tUWfPfMa4gyFpuypDAVnuxV19ScpN97uzauvhjDyA
	gztft3rkP2DnXjBpiPrLrqvches6sXdetCyTuLBje/hxPk1CDBvaK+s4UljY+E7s7UQAKf
	IhSvcBwxgKK4mY6mNFv9OSHI5YEY2XM=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-235e389599fso90725ad.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753141846; x=1753746646; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IB72aB1pAV9dq+XvFFbs2e0X7c42HGWgrt5SuJCD/0=;
        b=2HYgAOD4E2hIldyEBK4U/LeAcA9tmrKCog6eXhkr3wVNoHbtlT69Wvnjt2S1dtR96Z
         iM8MUMLMEJ7lxu1ewCqGIugizSMeElyR8KICh8aarhkrlcuVnqeIIRieDwi+RxmtlnOl
         gtLiMusDD8xEVyIjWYkWUy08kC5lEqGiGd87tns34D0BCzzf1LnvEHuovV81Gg7JLlwD
         g0XTmYCKJBk8Gp1T8ohsK4WLE8/zXzx23J5EAfDkbshkaKiLWufoIVON4rabWcw2OC9Y
         /Ojkm6ZRlxvEYeXxtxJxlVkEVdsIdxCqt1GhZBDxK4Qsku6Yo9N1K1Ivn1Qzg1yfEywx
         4tRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753141846; x=1753746646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8IB72aB1pAV9dq+XvFFbs2e0X7c42HGWgrt5SuJCD/0=;
        b=obnZ2clOdfvR6fymmXGCAPd2vLoqyyJ4KJZxX1RadMqs3gFZX3B5xcKFRO5fScZ+Kg
         iNe2FRHHoqf88MuyADrweW0z7uuGrEc6Rxaywcsja3x1LROywvCUzCsIJs1Lr0wjTQQt
         2zJ6xLCCMJfKPP8Fae2bixpNEAgt/iSSuEvMBVXTJ5Syl+3RSEUe/hd+clhpxhEIwSLa
         VG8Ce0YwMnO6CCHkCWKT2wxl3/HknjiOfrxSMp4D8AmSNQh09TUVXUG1a2T1WR3DnA/L
         xCZ+oLwFHqfOAAf8Z1S5l8+CqzeQQ6cZYPyZ+2jJf3uSXCkYYRY/oKVbJhZM8EmzlYHZ
         6HoA==
X-Forwarded-Encrypted: i=1; AJvYcCXX1EggZEBcd2xHtGkg6Xu6fx49Y6Zp5X6sz7ywL0ku7/KBC4vXRSQu2cKcun8X/izVE+Nw2q7M6Q==@kvack.org
X-Gm-Message-State: AOJu0Yyl0oWvZlbW+9T4l+albl00JUPNghqYti43ZXIlwQ/1nzgGrUeM
	R/b2meMfr+btrkdArSDDy0ov+U+Thaj4n78XsZfo6kC7pBimzkJ//u+to91gFzNUWVkB+ckVqa5
	WPH3hEQBW73cyOl9z29UHvt6vwB3wJKN98gMQfC2h
X-Gm-Gg: ASbGncstV461BrI5I+HuL02lHT3pAubHEb6f7lLUHl7g6XlLCPTw3zlOSZXrSaBi9jE
	2bUjeEWLwiigbZEaI+B5jNaT5e4S3E4Z42jAXPLNH2h1trcZw4It1dkD5uqvrJ2ZcB7rUBUhX8b
	Pb2E23mUuGrwNzN31rPVIIvwh25nNaYO4NhITa3/04R9f4onAJeR61Qtwcoc0Q0klafk4NRPFq5
	+QNASjAhrgAfL20eJcx1KiZaDj1Vs/xM4ZtZHTLy9sOp3JP
X-Google-Smtp-Source: AGHT+IH3YiQMKqSdvOi3Hl2chQEQjKBZYYncsqU52df1Cul+060EhTbwEXWwh9jGrpqKQQvBZjZc/wdEQOaLY9BZwWk=
X-Received: by 2002:a17:902:e5ca:b0:215:65f3:27ef with SMTP id
 d9443c01a7336-23f8b590f46mr1250935ad.12.1753141844936; Mon, 21 Jul 2025
 16:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com>
In-Reply-To: <aH69a_CVJU0-P9wY@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 21 Jul 2025 16:50:32 -0700
X-Gm-Features: Ac12FXzatYxpj7dOmCOTU3y6raVwJgub7Hc67jtCHL8r3j1EPu7lx3yUXCqmwaM
Message-ID: <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: DBF0212000B
X-Rspamd-Server: rspam06
X-Stat-Signature: bury6netbiw1nunx8cwps538hhgqp9ng
X-HE-Tag: 1753141846-377297
X-HE-Meta: U2FsdGVkX18cdzrIxqC+Dg/zS3bOSP0BMQlIBxNi5RRC8gbcR3Ah1suaJfaZa72HiNL4D+U9QNs55Xdp046ZlxArmjz9t4W+sxrwXvQKj0PP6aTi27xHoHiuy+lNi205axL3KtRYjtFvofQniekzxgxB19wpordv0dAW0ABHnOwTOXUKquIqEtYaQrtosa96DzUS7ozVBP3JJWQA6BEGNJC3Wk5OGRS+suoFX2JQm9nUhvG2HCssxLwqNnGdFnUzo+ZBFTkLvvGh8FM3TXd5jzjAHoYBijQkM1Fc787LHcyAOd9GpGLYzCro8/cf2MuL1CJUtCN0UX9BWQc0vDjPJUL0O+8YkeEtL8nPq1xqqI85RY8/3b+4sOrUb6iptf4JwwAjEdWEylFl7liF9FhTGLZaTgV158spuW0QVIeJIECo3YSVm6cViO5SJteyJORRnocEihlVBCQ+z04OSYt+63neqQ7Yp2YsJxxqF2xpD7SXjiseINS7SoHjfg1QS6xkbHM88fNfmFE8BjlBRtObystdLtZeBrfarrMJuhEqs5qTr2vYV2yeNdWRDMtMtOHPtLcXzQmBQg28yK/1K7hD9mEGTUnhM83ExKZX6C+sxbniv0fJByHha8QKYiiEj0sYZH6ccwMOoBuRT2qwhvRGt6oB0Km5uiX8t2tsV1wKP+nyaDZcRQLc+vQ8L0ipZF4hllffpN7RBppF34ROus35YWg6nuFJPpeh5mtLSI3PiNrn60sLwypopq9MoCeNMhgPU5XjDjaw0+8JxkKd9lc1xK1039AYox7DOpvUqmSEL/nCm0GsFJXML7FTJRiLqmGTMO71NzlQsV+XUN2poUAezbT79PzvbbBi8t/4DsUKxfPdvV/jzc8x9xDmWG/h4hUklh5/CfO/obTgHBAtJ1dEtV/q+gPRL75KTRMXbMSZ844vPJ7eEKQ0JzPuNMAHfKNsXmDrATzsRQ/GPDApvdr
 sxEhIS+S
 C9eHtV4K4fDOeLEdWFGVbKfqNP9jygvbH2lYW6qfsbQaxOb0z7avYdsOV5j6SzXtczJljPMFvwER+1FCGpfEzusYw/k0X0G0UNV9NChGgGcakX6Gxom4oIM6RjG703Ycy0k0Nhxx1huhv8ZbLjntxP9hO5a42v0nCW1RDtlRr9HHndkEyTqbOdzNaLzZ+lfE46mraHjzqgI2je+XaQ0FATBsDorKa3joYthr5AWJuumauoMqw7jAfqZgpzZqR73k5vGm6Z4/JhUO7AANqqBK/B5/fHZUyvFZYjUIRBuqhbykMyMt6dal8csnCYgyeINDBl0J+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 3:21=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > >
> > > > > > 2) KVM fetches shared faults through userspace page tables and =
not
> > > > > > guest_memfd directly.
> > > > >
> > > > > This is also irrelevant.  KVM _already_ supports resolving shared=
 faults through
> > > > > userspace page tables.  That support won't go away as KVM will al=
ways need/want
> > > > > to support mapping VM_IO and/or VM_PFNMAP memory into the guest (=
even for TDX).
> >
> > As a combination of [1] and [2], I believe we are saying that for
> > memslots backed by mappable guest_memfd files, KVM will always serve
> > both shared/private faults using kvm_gmem_get_pfn().
>
> No, KVM can't guarantee that with taking and holding mmap_lock across hva=
_to_pfn(),
> and as I mentioned earlier in the thread, that's a non-starter for me.

I think what you mean is that if KVM wants to enforce the behavior
that VMAs passed by the userspace are backed by the same guest_memfd
file as passed in the memslot then KVM will need to hold mmap_lock
across hva_to_pfn() to verify that.

What I understand from the implementation of [1] & [2], all guest
faults on a memslot backed by mappable guest_memfd will pass the
fault_from_gmem() check and so will be routed to guest_memfd i.e.
hva_to_pfn path is skipped for any guest faults. If userspace passes
in VMA mapped by a different guest_memfd file then the guest and
userspace will have a different view of the memory for shared faults.

[1] https://lore.kernel.org/kvm/20250717162731.446579-10-tabba@google.com/
[2] https://lore.kernel.org/kvm/20250717162731.446579-14-tabba@google.com/

>
> For a memslot without a valid slot->gmem.file, slot->userspace_addr will =
be used
> to resolve faults and access guest memory.  By design, KVM has no knowled=
ge of
> what lies behind userspace_addr (arm64 and other architectures peek at th=
e VMA,
> but x86 does not).  So we can't say that mmap()'d guest_memfd instance wi=
ll *only*
> go through kvm_gmem_get_pfn().
>
>

