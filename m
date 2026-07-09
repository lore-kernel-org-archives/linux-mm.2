Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC256C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4C46B009F; Thu,  9 Jul 2026 11:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775A06B00A2; Thu,  9 Jul 2026 11:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667166B00A4; Thu,  9 Jul 2026 11:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB816B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:36:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB01B1C0D3B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:36:25 +0000 (UTC)
X-FDA: 84969639930.02.54D7EF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB87340007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:36:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c58V4tRt;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783611384;
	b=bDOVWgnIGoaGQuuDVu58okYEQo/VX7tHYITLnjs0T6hyAQMPnVJNo+Rmg0KdktGf/oaiI5
	YxlMJahZKvR7vxNGljlzC/Fx+sivxqoO3mwbyayB+7IUPReqZ89qtoWdDUG6k0txG6N9sz
	1XDwDOC/vTumlBbKeocbaLb1o/2n0yU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c58V4tRt;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783611384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mg2V0R7ROggXXchkyKDCKlOYU1ruVph4CL/uITEWhg=;
	b=zqb0UqbU5+i9UTQq68OZhmO9Ekv1OmRJCZVk2gMxlSFG4KvigOxTM3dStcbOfn1cTywDhU
	65FFkaE1wBoM6zaIo9IatG4MFyW6DEPK/V7PcslhTi/DKIsVpDX7vX+5LG0C33/4NNcbbv
	TnY4a6K7oxh/nnO1UZ3q7xJ99swbtVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D652341823;
	Thu,  9 Jul 2026 15:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BA21F00A3A;
	Thu,  9 Jul 2026 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783611382;
	bh=4mg2V0R7ROggXXchkyKDCKlOYU1ruVph4CL/uITEWhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c58V4tRtaxqpKPeZvomkSUxRufHz00GTZSdV7gdbR7tLG41wuZYPKtLskkkHtg/Wb
	 8jNv8LPawi649eM8ho1JXfSx1BMDPxHrymwneL/GvGyWdhek3KsH7zFC5e1JjQWnou
	 iOv4zpApjw7SbfT7AEw2JV7BD/tfMbe0uXK3kEa812I62T6vpYt5jUz7FpFtTe10CD
	 4ECqE0tZFBdePa8c3CMUA9bDBbgK2axaR9q94iDgV5sxxlRY58ZdX0Hk+O48jzlZeo
	 qTiDDqfpGfqIZ8KxE9OxS7usK9HxPv2ff2iR6va1vt9/CrJjbTxqFimlbYjuS1kNkk
	 JQbXGDOnK1ftQ==
Date: Thu, 9 Jul 2026 16:36:08 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>, Alexander Potapenko <glider@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, 
	Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Zi Yan <ziy@nvidia.com>, kasan-dev@googlegroups.com, kexec@lists.infradead.org, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: split a couple of headers from internal.h
Message-ID: <ak-5GEPVMrwT77uQ@lucifer>
References: <20260709-internal-h-v2-0-695631425968@kernel.org>
 <0970fec0-5c18-41e1-b63d-029c7a8354ee@kernel.org>
 <67bbfc47-a8f1-4557-9a24-298bad4f3591@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67bbfc47-a8f1-4557-9a24-298bad4f3591@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB87340007
X-Stat-Signature: ftx5mtsbjgg3es9fhkguq4hz3he9ersr
X-HE-Tag: 1783611383-883977
X-HE-Meta: U2FsdGVkX1+Y4foFqRi7TdTfM+QFAxGqvblKpC3nZjA9jMejYJ5Ly6W2+NByFxUv30seKotbQLdtXnvvu3XXy/HlidGLqi5AAkirPdUl4n1QQMyQ1JE+YJLqXz4eenhfV8yWIPQYsX+HFv813kPRfvLNs1avr8GbOYqQwC11U/jEtYln0MfsED4wc3vrLX5hvbN0BBqNTpEsthj9inYmDiqfpF7VlUhmo8bIQxU0EbMJhbLRAojG0acuGK/IexNs5inDNr6pW7hExGznJWotzUXeB9hgj4VUtDy399vEGw/oXry/HMMVb9UKDYzfucesE6ddyrCJmXCZtjncGcgB0WJ2tJ4eMIugJKuDnnKtOaV7S0LWDEoCyN9DFip0alGiURe4GDy0WMcn75dg4rWFbdi9Q2Q3U3tyeQbbiJ8xycYGOV1RB8qoXndxH3Fmoej4FkA6iiSppkKu+urQYSuTcuhPCB+1aeEvDlWoGIr57j7iovdciIZahEN6J2/D0Ys905ysmc4dbM0TQfj+SA4+V5znEaRGnvSiLdMFZqpwXHZySJ1x2T8/ub1OOtAQb8n7pgb5PaDo5iHxljc16M5wnVYaCfhIwMz315aesaJp/S1Gf7WkNxEY98F1d2I8Er68NYsS0DIwLlmutIOZfcD6Q4fXkGCnhL7+RLnuMwvY+rQLJQLuiR/60wu0qGJ4LDYWBQLRbegoUXTnFAWvaHa7qHSoJOa0wYHXUQme1oCqtSmZtufq6M9+KJ/YjayM/zNjXUoUNCPvKW3IHszuwQzjGLifozg+xSPEaYvOJPnpK7yPsn0an7sLa5dSrPgOS8AYE8Mx8mwlQkRsk+X7q3L3NmcJbcwq3Z3I8ySKJsmUs0GZ9ZY4MUMxC21waBiZr8pdEBbAthpXJmFdxEcUQL5M9bKZfelXDcILQ8J0TA0oavmIzARJs/5mpZnSXDn8JcJXa2echzH1YmnD1vwLq4d
 Vfcmj+Mx
 BPb/MGNe4XE93qMIfrSROMJ8d8oxGJg+zqjBUqu8b8glU1JTHauwBbBa4kIbX8Yd4S/YLWWzZ+QmCYtw4gCId84rCfx9rLsubKXqqDJkX6TU5RYgAFPJjWtTvSRd45Q7JYD83wyjigtyCcazzG2dStvVaXACoEj05OG3fJxzobt25lBrtsH7Dv8GxCZjWQMm3nTPK9HYTYPUMgrveUEywHHlymFEHJyA9YKdjm+K9WBWtrC+jwJbEVl6YX+/Yabik/7a94HhAfrxTUl63oWo1dno2akiqDwhpcOGDopBOZ62ax28Lz1zxwrWn0Tv6lyBqMnUN2jnGvC0ps7DBYHPaACmlBO9OcgY2f4aJLHSw8ClFBbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 12:21:12PM +0200, David Hildenbrand (Arm) wrote:
> On 7/9/26 12:09, Vlastimil Babka (SUSE) wrote:
> > On 7/9/26 12:00, Mike Rapoport (Microsoft) wrote:
> >> mm/internal.h becomes more and more bloated.
> >>
> >> Split declarations related to mm_init, memblock, vmalloc and sparse into
> >> new headers.
> >>
> >> ---
> >> v2 changes:
> >> * fix fallouts of rebase fixups of checkpatch warnings
> >>
> >> v1: https://patch.msgid.link/20260709-internal-h-v1-0-956d5092782d@kernel.org
> >>
> >> ---
> >> Mike Rapoport (Microsoft) (3):
> >>       mm: split out mm_init and memblock declarations from internal.h
> >>       mm: split out sparse declarations from internal.h
> >>       mm: split out vmalloc declarations from internal.h
> >>
> >>  MAINTAINERS                        |   3 +
> >>  kernel/liveupdate/kexec_handover.c |   3 +-
> >>  mm/cma.c                           |   1 +
> >>  mm/execmem.c                       |   1 +
> >>  mm/hugetlb.c                       |   1 +
> >>  mm/internal.h                      | 183 -------------------------------------
> >>  mm/kmsan/hooks.c                   |   1 +
> >>  mm/kmsan/shadow.c                  |   1 +
> >>  mm/memblock.c                      |   1 +
> >>  mm/memory_hotplug.c                |   1 +
> >>  mm/mm_init.c                       |   3 +
> >>  mm/mm_init.h                       | 120 ++++++++++++++++++++++++
> >>  mm/page_alloc.c                    |   1 +
> >>  mm/percpu-vm.c                     |   1 +
> >>  mm/sparse-vmemmap.c                |   2 +
> >>  mm/sparse.c                        |   2 +
> >>  mm/sparse.h                        |  63 +++++++++++++
> >>  mm/vmalloc.c                       |   1 +
> >>  mm/vmalloc.h                       |  46 ++++++++++

One thing to be wary of, and I mean I'm going to get a bunch of conflicts with
my mega series, but anythign that uses vma's should use internal.h rather than
vma.h directly (the mega series touches this).

But nothing you changed does use VMAs afaict so should be good.


> >>  19 files changed, 251 insertions(+), 184 deletions(-)
> >
> > Sounds good
> >
> > Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Agreed
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Oh hey me too! <3

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

