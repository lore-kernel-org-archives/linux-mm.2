Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF76FC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 18:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66D96B0088; Fri,  7 Aug 2026 14:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0566B008A; Fri,  7 Aug 2026 14:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8876B008C; Fri,  7 Aug 2026 14:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 605476B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:12:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC640140162
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:12:46 +0000 (UTC)
X-FDA: 85075269132.27.878DE10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DBF31C0002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:12:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCjUQ4Ig;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786126365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SDujoCYMSNCRRVPVd0Pu83F/tJl5awxY3L9ef8/NDQ=;
	b=05opZTrQ+YFwSJqdyckPxtqYGJTFcqawSwoBC+HpULce4Z5aH8AfYzC9C6uHcy8YmTyzhF
	rT4MuxxbPORX+tFApTzHo/0ubhDSIRYOIM5Q4NaGcLtUX3V5U7K8oaTuLUd4booBP+TKke
	7ZjrSQ95Sq7Uc3SvfI2w8asfVlVsu+E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCjUQ4Ig;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786126365;
	b=Zre1/Q7VNwqVRSCUuDS8CSkp0pF1t0Vlnl7vsWdUydKX17Xur8N/A6i+ZCbGcukjTq2QhI
	yv7mPK6ClAOIHBa/j5Eqy7//vvEhl8mmtTfDjCw3eUGaBovlbZ9GDcZhkJGDGE0Smc5bsY
	zyL63pPkHQXSWZ1Ov6Wydsf3ny3Lyxk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06E4443F99
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9AA1F0155A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786126363;
	bh=/SDujoCYMSNCRRVPVd0Pu83F/tJl5awxY3L9ef8/NDQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OCjUQ4IgwOEEv9ocbV2mRObeAgEnacEHWr26yoZYHRBF2/vZtT35DrClWEbL4IsJV
	 YjWkZis14N1JrCD3LyRQ2dPDbOuthCgGywKUFNvpkq8gduVCU2r/SIMB9+KivwhPxt
	 0uay+ifmQLA0u2L7WvyLXD6m+57XTHRAZU0VATsRaRIf0trF/OZlDhZ0X27a5giAX4
	 iT9oAVlLoGmTfOmuj3feRcuOpcGILWmrj1Y+tmwmO4M54ltU+QzpSyYLv63OSRmYY6
	 +2gQR+fCE6WuFc31uPzfgfM7doP5EbRJe479QUnC6wUF8p7/gON1f3ZRh+z/d7fRR8
	 4Pkpc9QaHX51w==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1c4c7ddaf6so578087566b.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 11:12:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro/jVBC0BC9wKjlA3JnVz4stnCxtzJuDn99I/Kc99HnNsPq+e/fnx9YWCuCbnWv+LCFzFbk7nil4A==@kvack.org
X-Gm-Message-State: AOJu0YxczdkkPOrsvD63hIyNtLt0664XjJvkQNqetv4WFvkd55itaYXg
	IdY6if0DwfoXZLmPfHTROwbabnnKwCG46ygXiisTSc6EsOQF69CiVroWjlBxxHyiLYWvtUbDUh2
	Blb0773nW++DrMvTySr9p95FA1gDmLvM=
X-Received: by 2002:a17:907:94c7:b0:c1c:1e4e:f911 with SMTP id
 a640c23a62f3a-c2039f918bdmr1097087166b.30.1786126362692; Fri, 07 Aug 2026
 11:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <anUgqnHKShicIK7C@google.com>
 <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
 <anUkfHGqI07cgSHG@google.com> <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
 <anXrH_6oQTtDxzX9@google.com>
In-Reply-To: <anXrH_6oQTtDxzX9@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 7 Aug 2026 11:12:31 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMr+bi95MzG93cPkVmDUzmHYt0obM_niNOyhFLqgcA_Dw@mail.gmail.com>
X-Gm-Features: AUfX_myDHjTdF_-SPjQWdvmsyfWgIQnbQ1E0CIUwtEisuVCRvvvNhDHa3oXdcII
Message-ID: <CAO9r8zMr+bi95MzG93cPkVmDUzmHYt0obM_niNOyhFLqgcA_Dw@mail.gmail.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DBF31C0002
X-Stat-Signature: xw5gknbwzdrr51z49ep73uc79wywyka5
X-Rspam-User: 
X-HE-Tag: 1786126364-350025
X-HE-Meta: U2FsdGVkX19K4H3uZaT7Soitsby5tDExzJf5TJCfyuFgN/W0qYkrOqD2PFtx8+I+sw8vqUWbjdTGjNuAd21IF2fb0CYwLwWS/4JJ/OAUIVciG7JIxUFjoEBOCPeqfVDfvghMJosWWCqemk+5rHdrcT7BFnqFlX6/IOA4xeR/C1IJ9W/XT42aogs37t2tUoyVgprTakehLuec8PoG9PSzAAjIF38rZLM0KKycIpn2vlKQ4fRsam+p2K+MBoC8wPqbIW9eZ4+yuo6/lVOnhBSyrU/q/NPhPh49Xk40jNlalReuunQ982fPul8S+X4PDbnhIP1A8J4voCnUQZiSnDILTtlboC9/G8BfE5esxgtw0qWXRoMnq5/0x66HNEjMExuTcZswfEEVGTjSEKDDD4oUnkAYy9stLvVU/ddAk0Aqia9wR+SztluSD3/wrQC5HOMS0IGYT1uzvCvlIgWxJhs6ZKezMPu4xqZ8ZySIjM/CRVXOT+oNzzo/mWrJN/Keqs+LC4N99Xsd2mQXc6EPhoS+kVA7EkXXCfwaTxsU+kHOVxt18e3WejAFioKmUl/JXoBxo/eNx3WVZ/WkjJ3zfS02QN8YQpO6R6RtCZl225y5QC+ZG4PQnkp15QP13WydL67sqpjUwQjvKg4OFfCVaeEd+/tRTGzOEyUDGyW3vBc/RGf6Q1IgcqsYNmsm1db/kDX6JpI32rbrZmcy5DBjs6FTf/dHx7YodeqNnIYRVARny+ACp2kdeUhRkYgMFSxL1gxkGSBI+LpjY0omQb/V8LpNnk1d2/59SxOSnmPNz0iWT3urB+vZ98botlkKJ2PKjRKOHQRI/4JVUZgCjzjO3WrgfZt+hoppdergjMbbxCmYBHsKRCfRGtwx+XTWwjSbxVV4KogUmmy8OQoimuQj0G2Iv8Wg+UUmwIrdDUWt4CYPypETZfi7a5a31KDlzPHPTv+drbU80TD4WQqQLNVoq9V
 fXDZU9fv
 61zgw0nnOP48dJffNbKATPj6zgNmTfxHbISwb8wPAzNkIxT0ggC3gOwOfWOMsJpPkncg7xkGrF9LO+84XnRd0poUkoVNMiSGYvpVYwq0uaAZKRKLoijWBVI9JCPYrYTduwNni3NISBgVAC9HE8Xu03LC+t/+q0s+qQsabYIRRncCDNfopYl61D6yRE4p/abHf1UzSG/pCGgVm1hXozYRVJv+9Mjy7M4pV93op+NNyhXV4+q3Vk07jLdSbrXVIaHgY+0vPZwsHwD0PCDv40v8LNRofqCgItdiv8FBphCJ7DdZ3FpZurzjY0BQ+QhTjtdh4v0ZlIgkJs3NZDkGpHyLO5RXvLMga7s+LjDuggWbAVsBvpZa3Sd6fm6IhkvDVW8s27m/GYnyKSWZ2FrOjCG4QCFIq3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 7, 2026 at 7:26=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Aug 06, 2026, Yosry Ahmed wrote:
> > On Thu, Aug 6, 2026 at 5:19=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > > >  2. Always access guest memory through userspace mappings, i.e. t=
hrough uaccess.
> > > > >
> > > > > #2 sounds nice, but the problem is that it effectively requires h=
and-coded assembly
> > > > > sequences for anything more complex than basic load/store operati=
ons.  Which isn't
> > > > > a complete non-starter, but it's a pretty big blocker.  E.g. see =
the mess that is
> > > > > record_steal_time(), and then imagine trying to convert something=
 like
> > > > > nested_vmx_prepare_msr_bitmap() to use uaccess.
> > > > >
> > > > > So, unless someone comes up with a clever idea, KVM will need som=
ething GUP-like.
> > > > > Strictly speaking, it doesn't necessarily need to be exactly GUP,=
 because KVM could
> > > > > poke into guest_memfd directly; KVM would "just" need to manually=
 track its own
> > > > > mappings.
> > > >
> > > > Ideally we can have shared infrastructure for this (i.e. the mermap=
).
> > > >
> > > > > But on x86 at least, that's not really a viable option because it=
 only
> > > > > works for map-rarely, read/write-many use cases.  For one-off acc=
esses, creating
> > > > > and destroying (very) shortlived mappings would be too costly, an=
d so we'd want
> > > > > those to go through uaccess.
> > > >
> > > > Not necessarily (I hope). I think the mermap pre-allocates page tab=
les
> > > > (or some of them) and defers some TLB flushes, it's aimed at
> > > > short-lived mappings (e.g. for read() syscalls to map a file page,
> > > > copy to buffer, then unmap).
> > >
> > > I highly recommend testing shadow paging if you have aspirations of r=
eplacing
> > > the get_user() in FNAME(walk_addr_generic) with an on-demand mapping.=
  I would
> > > be (pleasantly) shocked if dynamic mappings can provide acceptable pe=
rformance.
> >
> > Oh I was thinking of existing cases where KVM uses kernel mappings (e.g=
.
> > kvm_vcpu_map()), as these are the ones where KVM uses GUP now, and need=
 to
> > work for AS_NO_DIRECT_MAP to be usable. I assume the get_user() calls a=
re
> > already a problem for guest_memfd.
>
> They aren't.  KVM doesn't yet support in-place conversion, so when guest_=
memfd is
> used for private memory, the backing for shared memory must come from som=
ething
> other than guest_memfd.  If the guest does something to prompt a host/KVM=
 access
> to memory that is private or doesn't have a valid backing, then it's eith=
er a
> guest bug or a host userspace VMM bug.
>
> When guest_memfd is being used for shared memory, i.e. was created with
> GUEST_MEMFD_FLAG_INIT_SHARED, then get_user() Just Works, because again i=
t's
> userspace's responsibility to establish mappings for memory that KVM may =
need to
> access.
>
> All of that holds true for when in-place conversion comes along: if get_u=
ser()
> hits a fault, either the guest or userspace screwed up.

Yeah get_user() should be irrelevant here, it should still work
regardless of AS_NO_DIRECT_MAP. I think the discussion was prompted by
me saying that uaccess is not necessarily significantly faster than
the mermap (don't know, never measured it), but that's besides the
point.

The main difference is mappings that KVM access through kernel
mappings (e.g. kvm_vcpu_map()).

> > AS_NO_DIRECT_MAP will surely make it a bigger problem, but not a new on=
e :P
>
> Well, if it disallows GUP, that will be a new problem.

Yeah I think we should check here and allow GUP on unmapped pages
(more below). One thing that confuses me is that the
GUEST_MEMFD_FLAG_NO_DIRECT_MAP series [1] seems to also have this
check that disallows GUP. So I am not sure if KVM needs GUP to work
for guest_memfd now (then how does [1] work?) or it will need it to
work in the future?

[1]https://lore.kernel.org/all/20260410151746.61150-7-kalyazin@amazon.com/

>
> > > > > At that point, userspace is basically required to
> > > > > maintain mappings for all host-accessible guest memory, and if th=
ere are userspace
> > > > > mappings, then not using GUP doesn't make much sense.
> > > > >
> > > > > Note, I called out x86 because x86 has the most extensive emulato=
r and shadow
> > > > > paging support, which is where the isolated, one-off accesses hap=
pen in spades.
> > > > > Other architectures might be able to squeak by without userspace =
mappings, at
> > > > > least for now.
> > > > >
> > > > > So, in all likelihood, KVM will want GUP.
> > > >
> > > > Yeah I am thinking that the check here to disallow GUP completely f=
or
> > > > unmapped pages is aggressive. Maybe it works for now if KVM does no=
t
> > > > currently have any use cases for accessing guest_memfd memory. But =
if it does
> > > > (or will very soon), we need to think more about it, otherwise
> > > > AS_NO_DIRECT_MAP is not really usable for guest_memfd. Since you sa=
id KVM
> > > > "will want" GUP, I assume it currently doesn't?
> > >
> > > Doesn't what?  Have GUP?  KVM heavily uses GUP, including for guest_m=
emfd that
> > > can be mapped into userspace.
> >
> > Your wording made me think that KVM doesn't currently use GUP for
> > guest_memfd, but I was obviously wrong. So IIUC GUP needs to succeed fo=
r
> > guest_memfd pages with AS_NO_DIRECT_MAP.
>
> Yes, though as I said early, it doesn't *have* to be exactly GUP, just so=
mething
> GUP-like.  E.g. it could be a new API, if that's easier/cleaner.  What I =
don't
> think is a good idea though is handling this entirely in KVM/guest_memfd.

Just to clarify, you mean that GUP (or GUP-like) should work in terms
of pinning the page and handing KVM/guest_memfd the pfn/address, but
not actually making the page accessible or establishing mappings,
right?

Looking at [2], seems like the consensus was that AS_NO_DIRECT_MAP
means folios are not in the direct map, and callers are responsible
for establishing the mappings (e.g. using the mermap).

[2]https://lore.kernel.org/all/aeemS2wm38Cm4qAf@google.com/

>
> > To actually access the memory, I assume the guest_memfd side will need =
to
> > handle this by either using ephemeral mappings (e.g. mermap), restoring=
 and
> > zapping direct mappings, or using a userspace mapping. I suppose for th=
e
> > purposes of AS_NO_DIRECT_MAP core support we just need GUP to succeed?
>
> And establish a (ephemeral?) kernel mapping, because general users of GUP=
 will
> expect that they can access the physical memory through the direct map.  =
That's
> why I didn't want to handle any of this in KVM[*], the rules and handling=
 need
> to be kernel-wide.

See above, I am struggling to understand where you think establishing
mappings should lie.  The current approach is that AS_NO_DIRECT_MAP
just means folios are not mapped, and users are responsible for
establishing the mappings. I assume you agree with this (since you
suggested this :P), but you don't want KVM to do this ad-hoc, but to
have a library for it.

This library should be the mermap. I imagine (for e.g.) kvm_vcpu_map()
using the mermap under the hood if it knows the mappings do not exist
and using the mermap virtual address instead of the direct map
address. This only works (with the current implementation) if we can
disable migration (or even better, preemption) while a mapping is
active, which I imagine would be tricky or just not possible.

The alternative could be destroying and recreating the mappings when
the vCPU moves between CPUs, which is.. interesting :)

I imagine we don't have to sort all of this out now. For the purposes
of AS_NO_DIRECT_MAP (and secretmem AFAICT), we just need to provide a
facility to allocate unmapped pages. None of this is user-facing at
this point.

>
> [*] https://lore.kernel.org/all/aeemS2wm38Cm4qAf@google.com

