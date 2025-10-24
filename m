Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ADA6CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B96C8E0085; Fri, 24 Oct 2025 08:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768EF8E0042; Fri, 24 Oct 2025 08:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658588E0085; Fri, 24 Oct 2025 08:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52A538E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:13:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B94BBCBA1
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:13:50 +0000 (UTC)
X-FDA: 84032899020.27.F371837
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3DC12C0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:13:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761308027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X3sXu4j8MfMq52gqBAavsMTcndSosYtjB52S1c8LUjs=;
	b=omWz2og+/r4UOdUjrgotYSiG5lVLurWZBFHLqjbmCIpQeQlVur5UaPeJr6qUodC4z0+r0k
	SdcIgd4Qq0na/z0gjeg6j+Vzx2QK4y+OU6EvYJF+kDSHkmMbeVE50jgKeg5fSqRRdtjPBY
	rM5egbnvju9tM4Drlp3XE8LMigS373Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761308027; a=rsa-sha256;
	cv=none;
	b=G0l/mNYH0y/IcMBSJUZB2jXWx7WjpKPyhX97A9qroQCRaKzgJsGniw+8wg3V31wGkJWclL
	EA5yBYQ4NSI1FUnqWVBnqw24kDIY97QhuJ7p/tLkfT8UjBHe2vliK3ei7lOXm35pDPxktB
	wkbRV9K1qNquGbqR8UL7bxvfVEJxDQc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EA231515;
	Fri, 24 Oct 2025 05:13:38 -0700 (PDT)
Received: from [10.44.160.74] (e126510-lin.lund.arm.com [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C2833F66E;
	Fri, 24 Oct 2025 05:13:38 -0700 (PDT)
Message-ID: <390e41ae-4b66-40c1-935f-7a1794ba0b71@arm.com>
Date: Fri, 24 Oct 2025 14:13:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] mm: introduce generic lazy_mmu helpers
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-7-kevin.brodsky@arm.com>
 <73b274b7-f419-4e2e-8620-d557bac30dc2@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <73b274b7-f419-4e2e-8620-d557bac30dc2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3DC12C0006
X-Stat-Signature: happu8ywa6ibzjo8wbkuerdd6rjdb6jq
X-Rspam-User: 
X-HE-Tag: 1761308027-183335
X-HE-Meta: U2FsdGVkX18x1seQcb9fLKFcy2S1XDkEKXn4S3lcG1t0G5qnEyiwqrD7snHjk6brj6uzciEG1WsJgRKMzt7EoafxSYakLKlVbOVGznt0CEPU5WrAPkgNSOO9GBBirrTIydoAPx2n3JW9JAqy1ek5ykdQ5Gk8AGGhFkPPqjAY8bZjsRy7tLX9Fhe7dEPCNvbeYMPIBKTIZOlCm2NSgD0mGWE1ndm9sPkD1ypS4OItlnGrrI/bIi8Pf0QM6PH4laTMLgVHqlSfWQOxBmobs45EV9kgWFaU+uMpYjZ8ZeSeJNhzW2XoXbMFjvymsQ7YBn7Fu8c5322KgPt1zc0Cvm+nA7WNW18bUvcxoMwUAy1PuP+P8yV+idA10gof5fmZpT/EBAz7kJFgtHSi3AuBipdwv0sJR6orToU+sRDs7vrJ9fryGi9nR46BKsmE4IJga34W0a3c8iT/IZ6Sq7NFKTHO7gjpXSaagdlpWTc1fZlUfwoxSg2vbURNTfhJGgW8LZc3A+lMTKaRSl3o3zau4gRgraW/X2PRoOXHOm7SNsMKopmMX2vKARkDwUKAVcc+2sVpz4K12BqkIlc4bMAwkvoh8pg2sXU4X0HYRSHxyezkVSCSOqRsMnkkvX9VOCL1pSSneNGbX2+KwLRLiaxWaNEfARt5TbkhNrqQYUljrK3S0yAlY3+YbFqAh3UuDEYBqhDVPdfSmBlWBWWT4OuAX+Ipzq2Tmh7JgFq1b1+4Ld3PySwQt7XjuvtJxqBomp37TigYII4IWgo3GAWFLYbqy6mYOr8pVdIQdsGDwGhgxplICwMWzrUwA1jFudsCdjXuyy6b/KQ2VQjkv/CbKiL6+2nE8N59NSKAs9aRJdwYy983Pq0ycxkoKRjbBMvGal36rZkpYLf//63wOdACujQ8z5WLv5CyywIeowZdPE+YMJIbP5hroJmMVTsxaexlEKnekH2FaLNTw0i6ar7xVQ4tTko
 VWTmdvWv
 82ARVZnflU7g9OgkoHaFrXxpXN1ivb++OWJVr4MFA6MBCnLAKgAbpQbzl33kxi2t0nJ1YdthzEIFktM9zhFYcLRi6CQBpiM+5h19IFrnpQBK1TDbJcetJECkCyS6GdN9Zzv126Z/3LCyA79vcrgLnYH4MjEBtBd+nTPDEEMxTTkuviqmBqSXy1IsrbpbvEY54PtKcCKev8Pgm0OaVm9TlcUqhHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/10/2025 21:52, David Hildenbrand wrote:
> On 15.10.25 10:27, Kevin Brodsky wrote:
>> [...]
>>
>> * madvise_*_pte_range() call arch_leave() in multiple paths, some
>>    followed by an immediate exit/rescheduling and some followed by a
>>    conditional exit. These functions assume that they are called
>>    with lazy MMU disabled and we cannot simply use pause()/resume()
>>    to address that. This patch leaves the situation unchanged by
>>    calling enable()/disable() in all cases.
>
> I'm confused, the function simply does
>
> (a) enables lazy mmu
> (b) does something on the page table
> (c) disables lazy mmu
> (d) does something expensive (split folio -> take sleepable locks,
>     flushes tlb)
> (e) go to (a)

That step is conditional: we exit right away if pte_offset_map_lock()
fails. The fundamental issue is that pause() must always be matched with
resume(), but as those functions look today there is no situation where
a pause() would always be matched with a resume().

Alternatively it should be possible to pause(), unconditionally resume()
after the expensive operations are done and then leave() right away in
case of failure. It requires restructuring and might look a bit strange,
but can be done if you think it's justified.

>
> Why would we use enable/disable instead?
>
>>
>> * x86/Xen is currently the only case where explicit handling is
>>    required for lazy MMU when context-switching. This is purely an
>>    implementation detail and using the generic lazy_mmu_mode_*
>>    functions would cause trouble when nesting support is introduced,
>>    because the generic functions must be called from the current task.
>>    For that reason we still use arch_leave() and arch_enter() there.
>
> How does this interact with patch #11? 

It is a requirement for patch 11, in fact. If we called disable() when
switching out a task, then lazy_mmu_state.enabled would (most likely) be
false when scheduling it again.

By calling the arch_* helpers when context-switching, we ensure
lazy_mmu_state remains unchanged. This is consistent with what happens
on all other architectures (which don't do anything about lazy_mmu when
context-switching). lazy_mmu_state is the lazy MMU status *when the task
is scheduled*, and should be preserved on a context-switch.

>
>>
>> Note: x86 calls arch_flush_lazy_mmu_mode() unconditionally in a few
>> places, but only defines it if PARAVIRT_XXL is selected, and we are
>> removing the fallback in <linux/pgtable.h>. Add a new fallback
>> definition to <asm/pgtable.h> to keep things building.
>
> I can see a call in __kernel_map_pages() and
> arch_kmap_local_post_map()/arch_kmap_local_post_unmap().
>
> I guess that is ... harmless/irrelevant in the context of this series?

It should be. arch_flush_lazy_mmu_mode() was only used by x86 before
this series; we're adding new calls to it from the generic layer, but
existing x86 calls shouldn't be affected.

- Kevin

