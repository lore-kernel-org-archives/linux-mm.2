Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114B9CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF8A8E00A2; Fri, 24 Oct 2025 10:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7F18E0042; Fri, 24 Oct 2025 10:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4E28E00A2; Fri, 24 Oct 2025 10:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2188E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:32:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E003588D8A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:32:52 +0000 (UTC)
X-FDA: 84033249384.10.5C6EBB1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id C26382000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:32:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fj3ap4gb/dH/jt4Kw1Iocq3iQjPpRmaLvXvbN2t9MVY=;
	b=Ret3z+NjXeo684jvxZjJ+D9P1qtmb91uwZB1HJQruvqEVVoAV6Rmj0xfxGfQDtplhovN1a
	2Fy8JSFT6sLHr+1qOob9OIHI9rv2+g4Nd6VevfVPZEv/ZjrWiVlt99uJtce1CFQcdcmV62
	mQExtyHuNiLdP4pvRm9LUIJJI3QEaCs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761316371; a=rsa-sha256;
	cv=none;
	b=wMR37vaFkNZ2hb4hFDRGVRijNaZQDXsSTac0/Oj+ZC36ZvlkcF4NmtUaBw7pTMUH1uaaam
	WZE8W1xzxkZpjUsuXDV59doVN8TfY5Htrsy5+4SCDQjucqaxxyJ8OyI+00nOFfdRTkY51k
	jiImiegfJ/Fe+YY4tFQwm40XmP/BWmY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDD53175A;
	Fri, 24 Oct 2025 07:32:41 -0700 (PDT)
Received: from [10.44.160.74] (e126510-lin.lund.arm.com [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F9233F66E;
	Fri, 24 Oct 2025 07:32:42 -0700 (PDT)
Message-ID: <28bf77c0-3aa9-4c41-aa2b-368321355dbb@arm.com>
Date: Fri, 24 Oct 2025 16:32:39 +0200
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
 <390e41ae-4b66-40c1-935f-7a1794ba0b71@arm.com>
 <f8d22ae0-4e36-4537-903f-28164c850fdb@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <f8d22ae0-4e36-4537-903f-28164c850fdb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C26382000A
X-Stat-Signature: fpdpxiswse5ppgi8sja7oq83ahwib9dt
X-Rspam-User: 
X-HE-Tag: 1761316370-691706
X-HE-Meta: U2FsdGVkX19kO3ayrgQbpPzo8/Utt0CkjokfV0ZEMltCcyfD1IVs+hU1pvrA4G/ioFsH8JPDfhuiDZweVj/qLTDaPIyn5Vca9tfBo+FQB9s1HegBK+gToK4GzENAauGoL2e6grFf+oIBo4c2ArJErcOQM3PNi1QFb2Ev6cU7UwpbwpLUH1rqaRGSlIyDehgllNMRvfnaT68xmlYFna0lQvIgKi+FBoeHbQP8kyT4u53jFFM8+F24Nsm+Ip1NhEM82iUdU1vbECo2xy7oOOk5hmwuHN/LpdeYspnNARrKivLwXBsZXu5/8nvHDIXc2iNs5d0VCvBisuQs0zzwOk6Q8YwONYfqC5vDm2CLiQ+jPsz87AwMBXUstv8gGgce/yid/aXplYt/LYYNwbCySDL/oOSkpsLoCdWyWIWEXjrqVYluCUa2ZxxpGjmm7at/7AOzN9kk6Dol2ljSGbqp8KLQjLVmgU8tS2Ihkq1TsZW4KvW+QxPT3hB/38BG/440OHw9kb4ZEB6390GybVAna11pZHP+ztCGvpb/riUBivIpOAPSkcCbtu2WPBC8Ls+CK0MUM8URx8HlOI+B2jmZkrp1kiOvLDbFV2FGRHtYrqJi+ioaZrRZ13GT4lEeXops3VNu8qXH/hsSnEgKyFfJaVufZPVk28/WCoXIuKZTmQ9ZkDHJ+sd9i611noMXAk1JCP+I9oDDCMJ2zDfCwQBRqa550tmtcz+aUVCmGWRJI90FTIeMqlW/dz6Iw1XbPyMW+04ksK9Z0RwWP9cdklkytPfCzdBa1sQt/RvK4BuRh+ro779WT+SqD/ACIiKCGXKG+3d1Kx4QcZ/KYAoIG+H5nhdOZPW8RYVbuekCOTf/5Wy0CvXzeTdf5P26bs4GVzqGM52Pj9fbvytW/3OysFtqbOa99Uiw16FjXStgw3/726jXaXB77ZHLG9Hv5VBYgAjdy8lJ1H2NFaEqUAEEPLnfjL0
 7QdBuA+1
 fPEDXMeiutjxVQ2V3tXH+TlUYKtoN5Z5v84iJundJ2lYRxS4RSxVCtBVRpv2FZ9eW02RJ2i1dl73965syiVkPTpv7kgry8l7Bgr7zLOEP4HczkzlFLWmCOeTtyi+6cjOcbhCsjKmJUZkTeImBqS62O7pNabG7AO9TaR5YwBZ9m0hxJkCTc8yvn6vSjiLKSONH5B+WyurLHp+PYEUIrreJ2DpJgJ2WdzP65nxRypy0lfDWuyYwUR03ln5rLG6CRMRjocto
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/10/2025 15:27, David Hildenbrand wrote:
> On 24.10.25 14:13, Kevin Brodsky wrote:
>> On 23/10/2025 21:52, David Hildenbrand wrote:
>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>> [...]
>>>>
>>>> * madvise_*_pte_range() call arch_leave() in multiple paths, some
>>>>     followed by an immediate exit/rescheduling and some followed by a
>>>>     conditional exit. These functions assume that they are called
>>>>     with lazy MMU disabled and we cannot simply use pause()/resume()
>>>>     to address that. This patch leaves the situation unchanged by
>>>>     calling enable()/disable() in all cases.
>>>
>>> I'm confused, the function simply does
>>>
>>> (a) enables lazy mmu
>>> (b) does something on the page table
>>> (c) disables lazy mmu
>>> (d) does something expensive (split folio -> take sleepable locks,
>>>      flushes tlb)
>>> (e) go to (a)
>>
>> That step is conditional: we exit right away if pte_offset_map_lock()
>> fails. The fundamental issue is that pause() must always be matched with
>> resume(), but as those functions look today there is no situation where
>> a pause() would always be matched with a resume().
>
> We have matches enable/disable, so my question is rather "why" you are
> even thinking about using pause/resume?
>
> What would be the benefit of that? If there is no benefit then just
> drop this from the patch description as it's more confusing than just
> ... doing what the existing code does :)

Ah sorry I misunderstood, I guess you originally meant: why would we use
pause()/resume()?

The issue is the one I mentioned in the commit message: using
enable()/disable(), we assume that the functions are called with lazy
MMU mode is disabled. Consider:

  lazy_mmu_mode_enable()
  madvise_cold_or_pageout_pte_range():
    lazy_mmu_mode_enable()
    ...
    if (need_resched()) {
      lazy_mmu_mode_disable()
      cond_resched() // lazy MMU still enabled
    }

This will explode on architectures that do not allow sleeping while in
lazy MMU mode. I'm not saying this is an actual problem - I don't see
why those functions would be called with lazy MMU mode enabled. But it
does go against the notion that nesting works everywhere.

>
>>>
>>> Why would we use enable/disable instead?
>>>
>>>>
>>>> * x86/Xen is currently the only case where explicit handling is
>>>>     required for lazy MMU when context-switching. This is purely an
>>>>     implementation detail and using the generic lazy_mmu_mode_*
>>>>     functions would cause trouble when nesting support is introduced,
>>>>     because the generic functions must be called from the current
>>>> task.
>>>>     For that reason we still use arch_leave() and arch_enter() there.
>>>
>>> How does this interact with patch #11?
>>
>> It is a requirement for patch 11, in fact. If we called disable() when
>> switching out a task, then lazy_mmu_state.enabled would (most likely) be
>> false when scheduling it again.
>>
>> By calling the arch_* helpers when context-switching, we ensure
>> lazy_mmu_state remains unchanged. This is consistent with what happens
>> on all other architectures (which don't do anything about lazy_mmu when
>> context-switching). lazy_mmu_state is the lazy MMU status *when the task
>> is scheduled*, and should be preserved on a context-switch.
>
> Okay, thanks for clarifying. That whole XEN stuff here is rather horrible.

Can't say I disagree... I tried to simplify it further, but the
Xen-specific "LAZY_CPU" mode makes it just too difficult.

>
>>
>>>
>>>>
>>>> Note: x86 calls arch_flush_lazy_mmu_mode() unconditionally in a few
>>>> places, but only defines it if PARAVIRT_XXL is selected, and we are
>>>> removing the fallback in <linux/pgtable.h>. Add a new fallback
>>>> definition to <asm/pgtable.h> to keep things building.
>>>
>>> I can see a call in __kernel_map_pages() and
>>> arch_kmap_local_post_map()/arch_kmap_local_post_unmap().
>>>
>>> I guess that is ... harmless/irrelevant in the context of this series?
>>
>> It should be. arch_flush_lazy_mmu_mode() was only used by x86 before
>> this series; we're adding new calls to it from the generic layer, but
>> existing x86 calls shouldn't be affected.
>
> Okay, I'd like to understand the rules when arch_flush_lazy_mmu_mode()
> would actually be required in such arch code, but that's outside of
> the scope of your patch series. 

Not too sure either. A little archaeology shows that the calls were
added by [1][2]. Chances are [1] is no longer relevant since lazy_mmu
isn't directly used in copy_page_range(). 

I think [2] is still required - __kernel_map_pages() can be called while
lazy MMU is already enabled, and AIUI the mapping changes should take
effect by the time __kernel_map_pages() returns. On arm64 we shouldn't
have this problem by virtue of __kernel_map_pages() using lazy_mmu
itself, meaning that the nested call to disable() will trigger a flush.
(This case is in fact the original motivation for supporting nesting.)

- Kevin

[1]
https://lore.kernel.org/all/1319573279-13867-2-git-send-email-konrad.wilk@oracle.com/
[2]
https://lore.kernel.org/all/1365703192-2089-1-git-send-email-boris.ostrovsky@oracle.com/


