Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8A0C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816FD6B008A; Fri,  7 Aug 2026 15:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7F16B0092; Fri,  7 Aug 2026 15:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695526B0093; Fri,  7 Aug 2026 15:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3300B6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:40:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A36D4140172
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:40:13 +0000 (UTC)
X-FDA: 85075489506.01.40DC4B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1E1340009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:40:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUjkBj+L;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786131611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tObqBrBE+jK71Z/771YmbMPfmsSJtcMhUMnfzseLsw=;
	b=o8NkEf8Ivw7rfE1IKvHEe9Nl7tRSWIX1e8OY9SK9vQouQxjw/7zoKZCTnrYKnhhQowvZIG
	H5xbtK+hx5jXQObLz8DiQ1QH496OAHyY4A4EBRT4dXgN11YD8bdbSJAY3398/6Ozfs34f3
	v00SgbW5z4yf325G5E2j9+rrhkiTKaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786131611;
	b=ZIjdpQKewDUe5FRclD5lw7UurfZBk6XqefqLHS3nPBeFkxRAkLZgm2bhjPAzD2IKvXWN+N
	I4VKqzkfLtUpl942VfwXubH4m4aCR5f5T3i4wOul3wMPEbqRhAjr4GlKfn9HbDqaUjaBq6
	74K80bqS+eV9vYFuC6522UvecIy/5cM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUjkBj+L;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AB3F60A69
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2AB1F00ADE
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786131610;
	bh=3tObqBrBE+jK71Z/771YmbMPfmsSJtcMhUMnfzseLsw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RUjkBj+LGuZuxgUjw3sgF0Ji+KE7yQaijmD6kiu8Vy1aagb0pgneX2ak+hmU1V20d
	 7zOmgKi2/urMsEs69E0uzAywfD/wAtfI1+OknDGipbRvw/OEqppAf2fKDS+MPcfeoZ
	 qf0PPKe58Zccx2ky+QpzAbTqU2h2GZdvRgcpEwfW7EtWvPcisU3Ku30RCUKmfwWmi9
	 2SepO1AAiVhEBsNUmPQq19xqSeYoACyx+NsZicoxNtFXf4aWGwleEBTjZmHyK/vsQ8
	 RSAwawtNGOASdPJ4BZWKdv2d2lXZ9/+Pzl35L2gz0Z2SuT1U9h5xHK5hLBNYKHwNKe
	 +YH3YdKJZsjng==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a10b20634fso6634533a12.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 12:40:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpyyaEPMkqGOG9d0jP2uYJAkjSin2wCu3EkHwhz5MDtWOvHENKBkBMAmFWpPli0mi7x7GHasGfvbw==@kvack.org
X-Gm-Message-State: AOJu0YxDl5HyMTqW1OV12ONv6rlTbqk9DnWnDcbCdvmyTL5MISBEtl8i
	/AMn28YvYjhhEr+IFIjC6YCclB/ie/Q7OsAVo2oAaWg9BfAXQYmjsI7kqjZjLZrh2OqHooiU1PY
	evm3U2XYD0uL3t8NiZgYE90JQilW4y8A=
X-Received: by 2002:a17:907:97c2:b0:c15:fc5b:6884 with SMTP id
 a640c23a62f3a-c2039cb18f2mr1201836366b.13.1786131608922; Fri, 07 Aug 2026
 12:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <anUgqnHKShicIK7C@google.com>
 <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
 <anUkfHGqI07cgSHG@google.com> <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
 <anXrH_6oQTtDxzX9@google.com> <CAO9r8zMr+bi95MzG93cPkVmDUzmHYt0obM_niNOyhFLqgcA_Dw@mail.gmail.com>
 <anYospX_XhVDHNGl@google.com>
In-Reply-To: <anYospX_XhVDHNGl@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 7 Aug 2026 12:39:57 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPTCjJdUKydhej6h0fV9rbpT5WFjfyVSXTbvaGs9XbX4g@mail.gmail.com>
X-Gm-Features: AUfX_mz8mq7JPbHLYyXPwfO-KNA3UcPMX4_H966hzho47wzxsYjTgd8iNROO_Jg
Message-ID: <CAO9r8zPTCjJdUKydhej6h0fV9rbpT5WFjfyVSXTbvaGs9XbX4g@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1E1340009
X-Rspam-User: 
X-Stat-Signature: mbnmztwfeq9ffp3feskka7ary3uw7tfy
X-HE-Tag: 1786131611-912621
X-HE-Meta: U2FsdGVkX1+ciDxUcItQvODgAc54JLorXF+PmJTO4cmC+W3bQy95/h6p0nK1SCLFGxoVtmXODKr7Rjf8TzjI/umyx0l2nzxxbkZzoAmI99C+uq+EsB/fO5ANmS+q4Wbc6b6J3Rxav4g5S4Ul9Ps7rHIHBmhNAZ37qd7MRUv1xcufJd0HKtaI4ALT02lfU/H1UBe3vRDQqmpmicItyR6c5G1NzjQTbso5OYTS/XlzBh2cpBzAYoUDeHcsKARjVB8+w+33iaVODqYwb0Z/0G+G20yBvxcBdZy2KBCYKKMb8fAJ8BJ/6BafVSQ/QasWpR7WVTK5mhCBMQ8jZ6lSn4OUhgxWsPpAA7rttsU/cOcucOkFhcRzUtjUBBDl8/xmN71fwEUUUKCTHeCQs96n4oFXS1tAQmnkJvfOOwz5eMIDnIf63PKVMtxKTxDIIaMkvJd/imErENG5myUNw4YiAjVIKDeJaX8K1UA7W9dsJRIwzETA1AUfZNsns67s/q5KjAtQ+reutBIiVp+VAfGuSwSUzy/IjxbiATSe5RcYHNlD9emDD3SZtLSqIyKcsz3Kg1+Ah17kOqAn+dvtldo5vn21L9vV5P8E6VDtp6Mdec9CMoyiRjjczoYoUbdkNlLnXxelt2J28JB2Zt4kG0nlvltsg/B/F5d2YKf+HQAwiHwpcl9aqc8SPDtva5q1R99Ihhwf9/XBHcHetW1e7abaLjGvVuij5lFluDchCvG3jG1KeOO2LfQNStKGEBYMxTrNUPLPoWqFfSl43CTjPAFMr2sieYOJp31TYxkos0oDofKOMLzWZTHK0Voxcc5kPO72v6PmRv9KLd8NE5xY6AQfihGO1hbgL1KwIBlgC8pd3OSxbQfCXaBhgwinASAz0vth1e8/wI4G5npMPZnzQ65RrrmSCgedCIOWk5zqhK9O+1ssxCRrT3KPE93km0plIlw6EhcBizQoAH8Lg0+OI+wZooK
 UyIuXLYr
 z070mhuYpIih0PehidqeevRq4/n+rPVa/cOhyybP3JlREB6/tG6StLX7axs6g4C+hsqmTvHdSuWHyOzrikZ2XeF/RGSfiXk+rSPIGHLFqNxOHU9+NIBu1pdDr+Ai/DUEvr/Sza1frfBEY0m1ZQ36NtjqgfHtOJUluO34CJLHONzrf0wdhX7BE1pU7FQgQJJ2Imix+NjdLvAbv+k6hLmC3O0x/qmXqKX4gm4g8r0Ztn7NPcsn0ZgTg8cb1INLuUV6o4Q0CcmssFIWOL6iysv/0DEIJ6lH0O/ZgK85h+uBOO1kAklWiE8yCheNDRpuYL92G7WT8M0m7Xt0TxljEVNfOHkGDpNJo6RUTlImMi1TahKSGRqb+zMbYrsivvsEts43uxtRH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > > > > At that point, userspace is basically required to
> > > > > > > maintain mappings for all host-accessible guest memory, and if there are userspace
> > > > > > > mappings, then not using GUP doesn't make much sense.
> > > > > > >
> > > > > > > Note, I called out x86 because x86 has the most extensive emulator and shadow
> > > > > > > paging support, which is where the isolated, one-off accesses happen in spades.
> > > > > > > Other architectures might be able to squeak by without userspace mappings, at
> > > > > > > least for now.
> > > > > > >
> > > > > > > So, in all likelihood, KVM will want GUP.
> > > > > >
> > > > > > Yeah I am thinking that the check here to disallow GUP completely for
> > > > > > unmapped pages is aggressive. Maybe it works for now if KVM does not
> > > > > > currently have any use cases for accessing guest_memfd memory. But if it does
> > > > > > (or will very soon), we need to think more about it, otherwise
> > > > > > AS_NO_DIRECT_MAP is not really usable for guest_memfd. Since you said KVM
> > > > > > "will want" GUP, I assume it currently doesn't?
> > > > >
> > > > > Doesn't what?  Have GUP?  KVM heavily uses GUP, including for guest_memfd that
> > > > > can be mapped into userspace.
> > > >
> > > > Your wording made me think that KVM doesn't currently use GUP for
> > > > guest_memfd, but I was obviously wrong. So IIUC GUP needs to succeed for
> > > > guest_memfd pages with AS_NO_DIRECT_MAP.
> > >
> > > Yes, though as I said early, it doesn't *have* to be exactly GUP, just something
> > > GUP-like.  E.g. it could be a new API, if that's easier/cleaner.  What I don't
> > > think is a good idea though is handling this entirely in KVM/guest_memfd.
> >
> > Just to clarify, you mean that GUP (or GUP-like) should work in terms of
> > pinning the page and handing KVM/guest_memfd the pfn/address, but not
> > actually making the page accessible or establishing mappings, right?
>
> No, I'm saying that whatever API the kernel provides needs to ensure there's a
> valid kernel mapping (or provide one as a return value).
>
> > Looking at [2], seems like the consensus was that AS_NO_DIRECT_MAP
> > means folios are not in the direct map, and callers are responsible
> > for establishing the mappings (e.g. using the mermap).
>
> I'm fine with that direction, but in that case GUP _does_ need to be disallowed.
> I.e. _if_ we allow GUP, then GUP itself needs to somehow ensure the direct map
> is populated.  If GUP is not allowed, then IMO the core kernel needs to provide
> an API to get at "inaccessible" mappings.  Or I suppose GUP could take a flag
> that says "I pinky-swear not to try and access the memory via the direct map".

Okay in this case I think the simplest thing to do here is to disallow
GUP for unmapped pages like this patch does. Once we have a use case
(e.g. guest_memfd with unmapped memory using GUP), we can figure out
if we want a separate API or a GUP flag. I assume the GUP flag could
either be: "I know the page is unmapped, I will map it" or "create an
ephemeral mapping for the page".

>
> > [2]https://lore.kernel.org/all/aeemS2wm38Cm4qAf@google.com/
> >
> > >
> > > > To actually access the memory, I assume the guest_memfd side will need to
> > > > handle this by either using ephemeral mappings (e.g. mermap), restoring and
> > > > zapping direct mappings, or using a userspace mapping. I suppose for the
> > > > purposes of AS_NO_DIRECT_MAP core support we just need GUP to succeed?
> > >
> > > And establish a (ephemeral?) kernel mapping, because general users of GUP will
> > > expect that they can access the physical memory through the direct map.  That's
> > > why I didn't want to handle any of this in KVM[*], the rules and handling need
> > > to be kernel-wide.
> >
> > See above, I am struggling to understand where you think establishing
> > mappings should lie.
>
> Heh, I'm not surprised you're struggling, because I don't really have an opinion
> on exactly who/what is responsible for establishing the mappings.  What I care
> about at this point is not having guest_memfd itself provide a GUP-like API: that
> needs to be a generic kernel API.

Yeah that makes sense. I think the options discussed were basically:
(a) Alternate API to GUP.
(b) GUP + mermap (or similar)
(c) Just GUP (with mermap handled within)

I suspect (b) or (c).

>
> > The current approach is that AS_NO_DIRECT_MAP just means folios are not
> > mapped, and users are responsible for establishing the mappings. I assume you
> > agree with this (since you suggested this :P), but you don't want KVM to do
> > this ad-hoc, but to have a library for it.
> >
> > This library should be the mermap. I imagine (for e.g.) kvm_vcpu_map()
> > using the mermap under the hood if it knows the mappings do not exist
> > and using the mermap virtual address instead of the direct map
> > address. This only works (with the current implementation) if we can
> > disable migration (or even better, preemption) while a mapping is
> > active, which I imagine would be tricky or just not possible.
> >
> > The alternative could be destroying and recreating the mappings when
> > the vCPU moves between CPUs, which is.. interesting :)
> >
> > I imagine we don't have to sort all of this out now. For the purposes
> > of AS_NO_DIRECT_MAP (and secretmem AFAICT), we just need to provide a
> > facility to allocate unmapped pages. None of this is user-facing at
> > this point.
> >
> > >
> > > [*] https://lore.kernel.org/all/aeemS2wm38Cm4qAf@google.com

