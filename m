Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5D6C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53076B007B; Wed,  5 Aug 2026 19:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03F76B0088; Wed,  5 Aug 2026 19:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FE26B008A; Wed,  5 Aug 2026 19:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55E326B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:05:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA2AF1A0586
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:05:44 +0000 (UTC)
X-FDA: 85068749808.19.2F1B1C9
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD7971C000E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:05:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mAdUht0y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785971142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlxzOHV9SXarGbQu2ALQb7kVLbIhmFH1zBVGVgFSBuE=;
	b=HUneQI30NjMNkXuLq64/MVZRrwd6PrRbx4oSWDtmKs1Hdzw2ENxRPhgATWRVkST03KezcQ
	ku81KzLZzkLUTEei5fpOVN9YDmSLy+0lBgteLkrYYAoys37mQiETR1NZH46rEbYFcqAhRL
	33xlRfU/tHCU+QWr3KVqP0agoT9787I=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mAdUht0y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785971142;
	b=yBb9HU20iCLUKYGO+9sily4Qo20zccVKvLPEtRYIF6Mrjo1+FeepqguUgzLAJ3ffizoZt9
	7ib7/ybEU6MdUOUAYvPBpLBWKmNm3UlL2K473YC1s4gX7SGE2I6XsHDZw5VBGoGw0G5PS0
	XdyngxCk6W0zUNLuPZdkamDJs6TVBIQ=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso3062e87.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 16:05:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785971141; cv=none;
        d=google.com; s=arc-20260327;
        b=UV1r35fIo2Sjq5WW6zjfvezGPCRlGZNKMX1z5HuBP09WlO09ynaNj9gtaA9iXMy5OB
         jCt+7naoCZVlYmCXUA2iVQSThp3fwTV2M6W0hsJ+I8CraDRXy6YLG30psq6cEKgluyzq
         HKTOGmm2b7GoMtEiyobJbZ6FfXUJFQDGVtjN/z4bGmO3Ahmw7mctMByASB1+ydekZ+g4
         +Gsk8U8yye8IzpY1iHpoBOGc3dpTKi/psbHf7HrpcfpisDKto7J3PG/mMt+5Rb8cYkqg
         2yZZ66ZoQzVBXH1N8XL6cE/HHlaNRDdDiXiGXs+7l268kaDQXmFVrnEfcgmr9UD+syGg
         AHIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LlxzOHV9SXarGbQu2ALQb7kVLbIhmFH1zBVGVgFSBuE=;
        fh=kXOneJc2KiL2PKwufqbEeneT5GhIkEotQhNAoOBnC4w=;
        b=BbEgLehAzzxXmbVuuftOdNxji9yq/sObGAZHwoHKNuwwyvAjcpq14y84s4Gc8HYgcQ
         ffKuWt7o2sDG2Rqm8lSkLE+J4IGTwRj5m2HhqydU2GIda3JbiXbu0CvWjJZJZE4j8GNd
         INpo6jZPSsUfAhcE/46OVu4XrMxXRKlWsEqISLs5RfsNPuMdtbqDG2uIiIlvTt0+2Elg
         JjH/dAA0CaHfRw3DVj8BlqgaZYV81tZJikqZcBY7KwW1EalJOt1wAehyJ/JMFtIle2B6
         Z0pmIqrotjvpGr+BOSXjKroMXVFdc2yJf/MZw9qAfguCiByk0/gyw7bIIMRKG92d0+fq
         jutw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785971141; x=1786575941; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LlxzOHV9SXarGbQu2ALQb7kVLbIhmFH1zBVGVgFSBuE=;
        b=mAdUht0ybXmIYi4xFvqAz/IIIa/lRCQReeoc4XsOfTw8fl8cDEd5bVVEUDAwn+17kL
         ixGgaj/QEhEm29PcD1K8ip4i+NxaReokpt2JoOR/QL4gpDb73svKJau/goeLLp370qio
         lt92rGBjrUGXU5rUKHGwrmhFZYxtC/XGYN3STmAErXogzuTHI8NZQY/KvRXvrqXHPwOh
         tDIhBrcqbfX8WeIKeT56g1aO9MbpmjJ0Nz7fGDc7flKnsKLnzLRxqpaSxoJCIa+sBOf0
         v/5L3eHXpE2UagM5eTcAjIoEGX05a5uc3lP5DKPJvoR1D0GpSWHdAl90Mb3EroqSNO2Q
         cBxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785971141; x=1786575941;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LlxzOHV9SXarGbQu2ALQb7kVLbIhmFH1zBVGVgFSBuE=;
        b=BPOPv0kcszHixmCA49mPpaZxfJIxwAIS9O9a9yIY5ANUJ/Ig9BoFL1TVQw+lxnaVx4
         /+ZqyVWMiWYBBNi1BsRwqnNeNJ52c5vYM2y2+paW97NPUFjFR8VitD9fwhEtbORdvEEb
         9LFpaOpkzvL+RdJIVm2+VvesRbCLlW++5C/mb82I0mzX1h6ORnzjqAb2iMbb8Q6nFhVB
         Z16P5GuBIPmenBR+/4N19GAsHuvQJS0Cp5embvd767BVyE7TAvPvx+hle2bqNuHbq0Ou
         Iu6dsEWjfbJX0Ybua1jcclZC+iIr/b7sJbWAb/qga/eNnBTuCuDzS1diDZnB56dyLr9h
         RrTw==
X-Forwarded-Encrypted: i=1; AHgh+RrpoxTfuCTq+XZknvirxdFJtLAA53ojCukz5e/3Ph7ldnGErzoHFbrFudCmPMOA2inCDrLib4w8/w==@kvack.org
X-Gm-Message-State: AOJu0YynG74zvIFSxnRYJWh9nBmSxEDjJoUKa3BCNwdLcPI/Bepnhpqf
	/YSBeRB3DV+mUh9PioTAvEsBhe6m0XdR5zLI2Us2sYVP+PCIpeScnIKyZW6cCoAro5TwmG7F/MA
	0YVfoYpeZ/mUadelmXdJ2XOUBh0+jWxefPN3q6B5G
X-Gm-Gg: AR+sD11hDlduZ2aJeLVM046+prbF94j5Gel/2DnHD8ul+qtLVSc6kxjQ3H1QJ9wBBB6
	Y3rI95X0jI4wFEUD3j84q0ypSPelrwA4opoGw5CqaEzSCkXuaMAtc4YOGUai9TXjtLOCNuDPuMW
	2Un5LJO+a5mkGmszeigXgjxlP9PjWdAxBCmPwHsRm62Qx7dxTCSRWKs4viHD6D8zqgthjhfllmv
	1/aB+nQzEY9gTqQkXcKkNsdbdg5R8WAkApE6N3tnhWu3AzEAcs+ay0CLc1iRqUwnT4dUZd1arJB
	2hIkg4sdbXgAXPEejT9nDeSahT66x7D6sZY7AdK1nVBIa6/O9QTnm33iLUP1Mon79qibVAC1RL5
	q8eHEoqYqsv4qqkeOSvh2g4zGjQCetHQ=
X-Received: by 2002:a05:6512:3ca7:b0:5b1:4fd9:ac with SMTP id
 2adb3069b0e04-5b301691cf7mr35772e87.3.1785971140452; Wed, 05 Aug 2026
 16:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260726072935.3513996-1-souravpanda@google.com> <20260805202444.1573218-1-usama.arif@linux.dev>
In-Reply-To: <20260805202444.1573218-1-usama.arif@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Wed, 5 Aug 2026 16:05:28 -0700
X-Gm-Features: AUfX_mwgnReueOVU0oGGjYStx2tB1pByRCuKlL1_LVxvKsjyMnjoP3jsgt05Byk
Message-ID: <CANruzcTRV0POtqD=9uscB=HxE9ZisjSZ4t1mXksRyq6jTswKig@mail.gmail.com>
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Usama Arif <usama.arif@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BD7971C000E
X-Stat-Signature: ua5h5cxdspxnebaqpy3wicpwzihwz1nw
X-Rspam-User: 
X-HE-Tag: 1785971142-362389
X-HE-Meta: U2FsdGVkX19DOEYShQZOXvlE2pHBctz0bmC/a9loMGAmS9Jpx2od8hv5Q3NeSBVdCAuAICnEs3887AkCpygL2pnAW/IINNUyn+UblxCqw02o3uygriSPVPxZBU8D02CgNaRIbHl7dco8xAuDIM3X9AILclmJBIIiZqCdaEfKwH71JjohjGPp63McnZqQH3TErftbv51UG5snb/Aq+g3xtIEmz2ju+PDG1EszLQQzFO2Jm5VSpN4rSsFL3fkPcItOWyppxzq8jCV0WT43Q37TlaElbK8qfeqQxNyEh1zAdn4LsrEH/QM16nNrlf4ZSW1gV577xNw9k9PHvv1ED4r2lN5EanMh8fG9RDgf2PoTmOQqyhuhtYud5zGw3JNnrpQh5RxUm4uaWu1X7B+wZhIYWkBLkVAoefQk5NJTJVHsC8Z65kPsxj19BPdIHE6xCF7ZhhRkESoccG5OZz043MxgH2fr34W9NpsImN/gOd25S6dOLeD6SMe7Z6s94GGCOQXIxGGRghFoEt2z0CAv8aU6fpNx2JemxnEg8sPBVbufScDglvcwjCtiiq6HZqo55qMV+vQqymOxk3Hou0FzNFhmcYZXzK9px+3UGK/BRZUXoKJ0OpcNngGP3tdotoSiowznJ5CQN6F88izqHzPLpowYbPtFJcE6p4D6Ywt8T51W8ySSrBAMq6XRTH4GhXQbzDzaOAdv4bx5l/49zyrcPezioZ+nWN0kSOTLQF4pHdr3O634VJdoLTK2vQ06gs69pbxcxSi36UUBWKR7I1XWf0u9KLLMKsewu6UodKGNJLZPbjDCz76HIWAZanr93jBaOWm/Em3dEoS8IajznkwJm3cb6WAj/FEURo4ZQkMG9fzEdIgMcy06USBjhd8tlUm8jZLxONp/+sOnPdmpqJF8XUTDSbjpf7ovbQySHquttIYU2UTh7PqIGzLgR1k/IZU0ynz7Uc7fovCS45BIZoWu1Zm
 /3YcIrC/
 kAqE4RKx0tVTR46VoISwW/J4GMF40X/GSYiLkUQMFCEkmDBWb54pEww/70bHVAKfij8kb9aSVndJ2Zil+l/eGSytcNHT4TWByb5C7eO1lSJlVkD1viqoI4bvVAJ6uiXynsj0sg0a0lT5MlmI5+y7zQVghomlNu4+JoOUFGc3eP/0yEhmimAITfEDdyJTduBIHK8i69WIwoSmzFvWUA3tKb9GxILonO5AYz/fRCjzKat5z+voHN2YaiOcQifVPSgLGS4AJNTiISwQ4ZUChb+CTOnUTIK4VMEVWkL3FpYPt9iROdyUikVCbE5WA4fx5qSco7RX0975uS1bL/tM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 1:24=E2=80=AFPM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.com> =
wrote:
>
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > alloc_gigantic_frozen_folio().
> >
> > hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask in
> > node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> > leading to a null pointer dereference kernel panic.
> >
> > Fix this by checking if nodemask is NULL in
> > hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> > back to any node with memory, keeping behavior consistent with
> > alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> >
> > >From a userspace perspective, this bug allows an unprivileged user to
> > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > configured on a subset of NUMA nodes.
> >
> > This can be reproduced by booting a VM with two NUMA nodes, restricting
> > CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> > hugepagesz=3D1G hugepages=3D0), and running a program that allocates a
> > 1GB hugepage area without reserving, restricts allocation to Node 0
> > using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> >
> >   void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >   unsigned long nodemask =3D 1; /* Node 0 */
> >   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >         sizeof(nodemask) * 8, 0);
> >   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> >
> > This results in a NULL pointer dereference:
> >
> >   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >   #PF: supervisor read access in kernel mode
> >   #PF: error_code(0x0000) - not-present page
> >   Oops: Oops: 0000 [#1] SMP NOPTI
> >   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >   Call Trace:
> >    <TASK>
> >    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >    alloc_surplus_hugetlb_folio+0x6d/0x100
> >    alloc_hugetlb_folio+0x3c5/0x660
> >    hugetlb_no_page+0x3d9/0x650
> >
> > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepag=
es")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > ---
> > Changes in v4:
> > - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach fro=
m v3.
> >   As Muchun Song pointed out, snapshotting cpuset_current_mems_allowed =
does
> >   not prevent false-positive allocation failures without complex retry =
loops,
> >   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() already =
handle
> >   NULL nodemasks safely internally.
> > - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_folio(=
)
> >   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keeping
> >   HugeTLB allocators clean and consistent.
> > - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpa=
nda@google.com/
> > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravp=
anda@google.com/
> > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpa=
nda@google.com/
> >
> >  mm/hugetlb_cma.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index 39344d6c78d8..5744de0ceeb7 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int ord=
er, gfp_t gfp_mask,
> >       if (!hugetlb_cma_size)
> >               return NULL;
> >
> > -     if (hugetlb_cma[nid])
> > +     if (!nodemask)
> > +             nodemask =3D &node_states[N_MEMORY];
>
> Hi Sourav,
>
> hmm what if cpuset.mems only allows allocation from node 0, and hugetlb C=
MA
> is only available on node 1. This will no now allow allocating a gigantic=
 page
> on node 1 when its explicitly not allowed?
>
> Would it not be better to check cpuset as well?
>
> Thanks,
> Usama
>

Hi Usama,

In v2 and v3 of this patch series, we actually used
&cpuset_current_mems_allowed (adding a seqcount retry loop in v3 to
safely read it without torn reads). However, during the v3 review,
concerns about using cpuset_current_mems_allowed, noting potential
false-positive allocation issues.

- v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-souravpanda@=
google.com/
- v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravpanda=
@google.com/
- v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpanda@=
google.com/

Let me know if you prefer I add it back!

Thanks!
Sourav

> > +
> > +     if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> >               page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
> >
> >       if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > --
> > 2.55.0
> >

