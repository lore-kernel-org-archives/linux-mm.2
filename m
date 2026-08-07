Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56320C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3786B0088; Thu,  6 Aug 2026 20:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C1A6B008A; Thu,  6 Aug 2026 20:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CBA6B0096; Thu,  6 Aug 2026 20:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF1F66B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:14:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4209D802B3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:14:00 +0000 (UTC)
X-FDA: 85072550640.12.AB4B418
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3D0D4140002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:13:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T37w6c2i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786061638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H72yQoAufs8DlJngZ8wldJQN/IpHR07Pbfs6IUxeFLQ=;
	b=mTdLPt+EaJHFq1Aktx+ssw47PNny4kXNB3Av+XLMUB8GL6eKyhiKEtbaNcqCmAoJ0v0wLI
	RlOvNcUPGulJ9xh/Tm0mSqycPkH4tugLl7cEjADtkuCqa9zGe+ZY97m8HlQgzRI6E5yAeY
	AI/uNgNvSBZT2tZHBO565TEomPQit0o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T37w6c2i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786061638;
	b=1v58E0OKRzpdq2MHwZ7O0zF69eb/62w39TgYKYJw0Xgsu81zrctgzupt48awAY+QeRAHJy
	zEi0icmu8ANPb+50s90doRwgjZGHtv01D/dBXu21/iFs6KmgI7G+Hq8+CUjnbAfFQFioWs
	k4ba3rgO3poogBWxg3dCBIsX9LR/edY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A42E4400A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7CD1F01564
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786061636;
	bh=H72yQoAufs8DlJngZ8wldJQN/IpHR07Pbfs6IUxeFLQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=T37w6c2iMnv4jap0HWIVpep29RS9VRvsWqsLLCMi8H1P6bEvQ624YdqD/jHB6R4eO
	 6LGDOrZLB0m+Lgg7UE9scDQL4RnZjfssh5PeJy7MkO9dQq/o0DbJHe0V/CME78Ir5y
	 UHM9FxX9sKFW3jjGtnM/0uDg/W2uOgcIl4OmG1Yj2VjOPSkhN2tyRm/Y593E9EJtSv
	 3YtClYB8Workoo5jh0KXgEicZWnQCx1QNDsd2f23K3pu1NAmfwg72bx6Yd4Ul4XKzP
	 L9D66/dhU0EMnWC173Wgz4y3e0OIyxQz/nepNlJJvkl56inRLeJOSh/AkOVsYkBiCi
	 iUC73w2dpct+A==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c20363107f4so291436266b.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 17:13:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqlfu4ULRlxnIhBZ08zM8oFyAsSqYlk5UXnMFJOCZChszOqQxTunnA8oDuRS6DxV/kH23wmV+kxUw==@kvack.org
X-Gm-Message-State: AOJu0YyZg5gdYiHmfSPXCrFcCe8+ozVFVgouxZqteVuU+H6loAJEiZjl
	kGL7uqNy4c94z5EtcYapnTcOyXq2hpZ1JGxapqtD32toOVmZVBPmg10pJwRojhh61ihXodrmg+X
	Gn7r9RDGCn0P5fnb84IRJ+QYTDeVjamI=
X-Received: by 2002:a17:907:1c07:b0:c12:8cbe:b897 with SMTP id
 a640c23a62f3a-c2039eeefe7mr787380566b.15.1786061635046; Thu, 06 Aug 2026
 17:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <anUgqnHKShicIK7C@google.com>
In-Reply-To: <anUgqnHKShicIK7C@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 6 Aug 2026 17:13:42 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
X-Gm-Features: AUfX_mxpibfj2n37cD4qkIB3b---BQbrIt0clnf2iRtdcuB1JrCsVAk8NuLW2Ns
Message-ID: <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
To: Sean Christopherson <seanjc@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, patrick.roy@linux.dev, 
	Takahiro Itazuri <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: xkhef4wcihm1q15gnb5gm49h61qqgxkp
X-Rspamd-Queue-Id: 3D0D4140002
X-HE-Tag: 1786061638-43531
X-HE-Meta: U2FsdGVkX1/iInAG86YRB/Wkot3tLgLtZxJl/Nx0FliqygFyzKuaiR+csD/Rpkfmz4P3xQ1FJQhbmxHuhGD7xNNdltZnhRTnHPq3vDHUKC6luAmLRuy8MbFIH+fnA8fRPcD2xqfET+WgoXKm3bv3sw5LNux0cjIH/aJGnROhH5XOfkEjIdN48mVK7AM/k/1UqVOZarkOL0/bSd2ESJP4Jd48MZSISX51ku2e6eYN6NVk9SPZyaLSHFiEmidl/tHcbDUY8mDAxfrnFLtlir63gB0LRMJSAKiOA57DFmB06Eiizl56koGfw7gJhPf1JY1ZxP2vsAu+k7TsqdTUrXsZgHPKw0CxtUqbrzKI/l+U8d6X2AszYofDzhGcDY26pelgoP6lGVpDaaE3Bv5g9BCzqhPoKGhku4qaAlC87hHjCBpnZmZgDuQw773kB1FxrAmapjmuvtKyq559voPNr5ExZVsJEu6DsTn5cPOkLEoKDsfIiwUxGEthOD3/RI5CdiyJkkNzJBsz8Z4jnp3O1xIUhaQll1j+JfYTulUJqQ2d9IzSmUf4QyeHUXeBWthvSG1b61TQ7vRROhoFCAKFJip1oubn1ZL61QIDaR5dpqhKeZ4Si0OGK/nSht7MG/ak91lfxIZqe/W/oe86YjZ7Zb4vPoTcXUdrrtcE+uxhIKTKD01rgBU6L+2oAYSfp8sLa7cD9+G/kRTb3bujHBDpCThve7V0sqLtTGpMgbEKIm5+4t7K5CaYE/jzijEP9dHIfmMF9F56huk3RHcZJ+nIftgSuafrvRXgyI1NOTqQAwic/VgEfPXmXVGHOdYoYgTRYaSMQryftEi0B/AUXXqBGaRabPW20fl/ki3lmwUWsQHBlJPyTEkGlQnk/p+AoaQB2yIp2q1kmsiTxh8schqareNjn7ouu1INZOo1sPgpo5FhdT45WXtcRCpGqXQ1A3mw766Ra8QywbwMQm7rTOOzUaM
 IgdJXPMR
 0rA2AP6QEkkupZ1+CVCC9+n4tZYpL1ilOipUS8OwvQzSnF1n3RPcKKd6SxUvRSCFN7l7wU9bfH4xz5gA9jpXwPZNG5Jw0RlRn0FAdFDc4M9rxtNfR9n2kcUg2jjk6kR0CEQ/vN5HXK9jc7zkrLhvo/LiYw8D1Z8fVQH/EM1qRDLex7MFD+4qxEn7H9RQ548MO+eIWeeAy9yWj2ELmYoSVJSG/EnVxEPjzkPmmQ5cV0s2PMU7R7xkRlcu4CsK7OoH639aqoBIqw60dGqDnIvktfTnbqawTp6LQx+0Z7RF+vxSzKJrQcYh+dQIP2uxEROoLTB98PXIz8Na0K9iwt+qyIdHWTYn4R757rCnT5vpeLprdnPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Jul 31, 2026, Yosry Ahmed wrote:
> > > > [..]
> > > >> --- a/mm/gup.c
> > > >> +++ b/mm/gup.c
> > > >> @@ -11,7 +11,6 @@
> > > >>  #include <linux/rmap.h>
> > > >>  #include <linux/swap.h>
> > > >>  #include <linux/swapops.h>
> > > >> -#include <linux/secretmem.h>
> > > >>
> > > >>  #include <linux/sched/signal.h>
> > > >>  #include <linux/rwsem.h>
> > > >> @@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_st=
ruct *vma, unsigned long gup_flags)
> > > >>          if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vm=
a))
> > > >>                  return -EOPNOTSUPP;
> > > >>
> > > >> -        if (vma_is_secretmem(vma))
> > > >> +        if (vma_has_no_direct_map(vma))
> > > >
> > > > Same here, and for GUP in general. For example, KVM uses kvm_vcpu_m=
ap()
> > > > to map guest memory and access it (e.g. when running nested
> > > > virtualization), which uses GUP under the hood AFAICT. So KVM will =
want
> > > > GUP to succeed, and probably create an ephemeral mapping as well.
>
> This has actually been discussed quite heavily, on multiple occassions.  =
Once the
> direct map is obliterated, there are basically two options:
>
>  1. Establish ephemeral mappings (for a fairly loose definition of "ephem=
eral";
>     some of the mappings would likely exist for the lifetime of the VM).

The mermap provides infrastructure to do this, but I think the
assumption is that mappings are short-lived. Keeping mappings for the
lifetime of the VM would probably need more thought. For example,
migration is disabled while a mapping is active (as mappings are
per-CPU), and I was even proposing disabling preemption (lol), so that
wouldn't work at all with mappings that are kept around for that long.
The address space is also currently limited to 2M per CPU per process,
which should be plenty but could also become a limitation.

>
>  2. Always access guest memory through userspace mappings, i.e. through u=
access.
>
> #2 sounds nice, but the problem is that it effectively requires hand-code=
d assembly
> sequences for anything more complex than basic load/store operations.  Wh=
ich isn't
> a complete non-starter, but it's a pretty big blocker.  E.g. see the mess=
 that is
> record_steal_time(), and then imagine trying to convert something like
> nested_vmx_prepare_msr_bitmap() to use uaccess.
>
> So, unless someone comes up with a clever idea, KVM will need something G=
UP-like.
> Strictly speaking, it doesn't necessarily need to be exactly GUP, because=
 KVM could
> poke into guest_memfd directly; KVM would "just" need to manually track i=
ts own
> mappings.

Ideally we can have shared infrastructure for this (i.e. the mermap).

> But on x86 at least, that's not really a viable option because it only
> works for map-rarely, read/write-many use cases.  For one-off accesses, c=
reating
> and destroying (very) shortlived mappings would be too costly, and so we'=
d want
> those to go through uaccess.

Not necessarily (I hope). I think the mermap pre-allocates page tables
(or some of them) and defers some TLB flushes, it's aimed at
short-lived mappings (e.g. for read() syscalls to map a file page,
copy to buffer, then unmap).

> At that point, userspace is basically required to
> maintain mappings for all host-accessible guest memory, and if there are =
userspace
> mappings, then not using GUP doesn't make much sense.
>
> Note, I called out x86 because x86 has the most extensive emulator and sh=
adow
> paging support, which is where the isolated, one-off accesses happen in s=
pades.
> Other architectures might be able to squeak by without userspace mappings=
, at
> least for now.
>
> So, in all likelihood, KVM will want GUP.

Yeah I am thinking that the check here to disallow GUP completely for
unmapped pages is aggressive. Maybe it works for now if KVM does not
currently have any use cases for accessing guest_memfd memory. But if
it does (or will very soon), we need to think more about it, otherwise
AS_NO_DIRECT_MAP is not really usable for guest_memfd. Since you said
KVM "will want" GUP, I assume it currently doesn't?

>
> P.S. In theory, there are other options.  IIRC, arm64 hardware provides t=
he ability
> to access memory via stage-2 page tables, but I also recall it being brok=
en and/or
> having severe limitations.  Using that also seems like it would defeat th=
e purpose
> of nuking the direct map since the host would have a full view of guest m=
emory, so
> long as it had the right "key".
>
> The other crazy hair super theoretical idea would be for KVM to hoist par=
t of itself
> into guest context, but that would be a hilariously costly version of uac=
cess, and
> would never fly for CoCo VMs.

