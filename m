Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6DE4CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF076B0008; Fri, 12 Sep 2025 03:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6DB6B000C; Fri, 12 Sep 2025 03:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7826B000D; Fri, 12 Sep 2025 03:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D610D6B0008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:26:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D4AD1406E5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:26:31 +0000 (UTC)
X-FDA: 83879765382.12.FF7760D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6DF4040005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:26:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757661989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jHtH5ew5HJ7wpnudtpflMQ+7ZEEIn9+nbCJ8h1BOfgo=;
	b=IfWYjWCxDQoo+akBU+qs7tn2JSjsf9VbWMCKfsyX8VSkOSzWZC3t6gquzPQdeHaaRX6Hqi
	IH63xpMc9RqZJoXnh2MMtbmg1ef+XnpHS+wHBfTopmZoe3AYBohvDZ4UNroFCb/g3/q2GA
	E5jDkARrPCsz95JHzW8zSWXAnncEkuA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757661989; a=rsa-sha256;
	cv=none;
	b=uhMovT5bu/RzmoRKz3iXkRmttUO4OHp1lnMiFL3yc6nmTP4Dyw8ix1rAUWVZMZCcXI0NZ4
	QthxCgf62Za9Ft+ni+QHsVEoUM79BOgKTJeGl9AJekP08hgkjdfWo3G00Ek3epqty3Qbdc
	pVf33hhr1pwwnGaSJaEthnS8ekcoBb4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD76F16A3;
	Fri, 12 Sep 2025 00:26:19 -0700 (PDT)
Received: from [10.57.66.147] (unknown [10.57.66.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1E03F63F;
	Fri, 12 Sep 2025 00:26:20 -0700 (PDT)
Message-ID: <15d01c8b-5475-442e-9df5-ca37b0d5dc04@arm.com>
Date: Fri, 12 Sep 2025 09:26:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
 <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
 <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
 <29383ee2-d6d6-4435-9052-d75a263a5c45@redhat.com>
 <9de08024-adfc-421b-8799-62653468cf63@arm.com>
 <ef343405-c394-4763-a79f-21381f217b6c@redhat.com>
 <4b4971fd-0445-4d86-8f3a-6ba3d68d15b7@arm.com>
 <4aa28016-5678-4c66-8104-8dcc3fa2f5ce@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <4aa28016-5678-4c66-8104-8dcc3fa2f5ce@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 73448xiasftdpxbfsaz8c8ja7mtcc61x
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DF4040005
X-Rspamd-Server: rspam10
X-HE-Tag: 1757661989-898579
X-HE-Meta: U2FsdGVkX1/5OYvInuS1YPvOlGWZQMlX72ZlKf5Tj3cDeL1TUlBTK0WinwUkM9tpetc9y8ZiOvA5YBC/bvcSW9q+gez3Xu2E3ZpN2TWNaUIuS6fK6mr0KgQOjBzUr2EbxVW7lL/bWJ8vlHsgOZOOerJcXKeTjUEbDcvztJltMkN0NnXlIJQ0ltZ/oSubGYU2BsTa/g4vd+jBf+HDS4qxbG/4lThRGj0XRhLw600285urhsxMRoVtaP01mIfx6l3lrJ1GQBd6wFQ+W+pToODkDZU+keoDR+e7ptECfzXl31uyJYn1vwvQQ757Mem/8P65U/Br60XFkBMBU+2+8fxYBQlqNsL1sU+DWmp3afTyNVsTB3k+XM8n1CXBuqsZCLP1hMm14DjZjECzfsb7SyyCpgLcvh1YIhNNeLbxWFJHnuaiHr5ZHGitMhz0PWxYkDvKcSl+0v0f7dkY0vjdhi2hYR3jmSV0/AI2kmkghT4TXZGYwQnes6ox+8T4C+MpehDLh9kA65k+RslQU/1glbBAl0j4EUR0/qUM25atXeBSuAIlXlwNUnVs3vKCDRZ/u/qExQbpzumxwwb4Ov5EviT2i/lIlH8qn5940N+8wy5xVQcylbYCYfCTVlIykC2x6KeyAmnz49oIjSVpzO3pQGxkBH+X9m3+viQWse0szum/ILjKgcQJWuPgGV/rHOHat2VzgYlYCJIVE2sq7jAi9IYP65rZMgkfz/b+zmb9XEcZue5MEGqiBbQfuEUtN2WUfaNhDsob+XQ8CnoMB01ooi5WlZZjqcLeLCmSlXrzmHmnClrf67sM2n9iEtu3jygHpeAuZUPNQDXmH7yY5tK8goHRoCNE9hHesxhCeuTH+I5bl8ibpJ3JzuuImzp9dLgf5DZdasmvnsfILp7rWs7wwlslBy146tjqW2empaVqe+TgUVJwWh+Wtss1b7SAZnpeQEqfQYFrfaaZ2nbP6ndnPWs
 Vl/FqlHM
 xhLwWESZ054lhdRIL2hD6bDo1uVdamSXEoG4ga2HjrgAT1eeA069BU4T+ZmRaNxRSwDH8gpJFRaUsFZawLtblGQFiXppRSK45lGFJxx2Ac/RBrBQivKyVxMgTshSBATpqsl52LIff7aBWnlANIfhtZhIbNy8NCt1e2AJe0xQFNJ39IwxgRpeSyG5iqDIZn5RI2iuc4df5/GybQTLfBuLOY4QOkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/09/2025 20:14, David Hildenbrand wrote:
>>>> On the other hand, with a pagefault_disabled-like approach, there
>>>> is no
>>>> way to instruct call {3} to fully exit lazy_mmu regardless of the
>>>> nesting level.
>>>
>>> Sure there is, with a better API. See below. :)
>>
>> I meant while keeping the existing shape of the API but yes fair enough!
>
> Time to do it properly I guess :)

Yes, I think the discussions on that series have shown that we might as
well refactor it completely. Once and for all™!

>
> [...]
>
>>> Assume we store in the task_struct
>>>
>>> uint8_t lazy_mmu_enabled_count;
>>> bool lazy_mmu_paused;
>>
>> I didn't think of that approach! I can't immediately see any problem
>> with it, assuming we're fine with storing arch-specific context in
>> thread_struct (which seems to be the case as things stand).
>
> Right, just to complete the picture:
>
> a) We will have some CONFIG_ARCH_LAZY_MMU
>
> b) Without that config, all lazy_mmu_*() functions are a nop and no
> lazy_mmu_state is stored in task_struct 

Agreed on both counts (replacing __HAVE_ARCH_ENTER_LAZY_MMU_MODE).

>
> struct lazy_mmu_state {
>     uint8_t enabled_count;
>     bool paused;

Looking at the arm64 implementation, I'm thinking: instead of the paused
member, how about a PF_LAZY_MMU task flag? It would be set when lazy_mmu
is actually enabled (i.e. inside an enter()/leave() section, and not
inside a pause()/resume() section). This way, architectures could use
that flag directly to tell if lazy_mmu is enabled instead of reinventing
the wheel, all in slightly different ways. Namely:

* arm64 uses a thread flag (TIF_LAZY_MMU) - this is trivially replaced
with PF_LAZY_MMU
* powerpc and sparc use batch->active where batch is a per-CPU variable;
I expect this can also be replaced with PF_LAZY_MMU
* x86/xen is more complex as it has xen_lazy_mode which tracks both
LAZY_MMU and LAZY_CPU modes. I'd probably leave that one alone, unless a
Xen expert is motivated to refactor it.

With that approach, the implementation of arch_enter() and arch_leave()
becomes very simple (no tracking of lazy_mmu status) on arm64, powerpc
and sparc.

(Of course we could also have an "enabled" member in lazy_mmu_state
instead of PF_LAZY_MMU, there is no functional difference.)

> }
>
> c) With that config, common-code lazy_mmu_*() functions implement the
> updating of the lazy_mmu_state in task_struct and call into arch code
> on the transition from 0->1, 1->0 etc.

Indeed, this is how I thought about it. There is actually quite a lot
that can be moved to the generic functions:
* Updating lazy_mmu_state
* Sanity checks on lazy_mmu_state (e.g. underflow/overflow)
* Bailing out if in_interrupt() (not done consistently across arch's at
the moment)

>
> Maybe that can be done through exiting
> arch_enter_lazy_mmu_mode()/arch_leave_lazy_mmu_mode() callbacks, maybe
> we need more. I feel like
> we might be able to implement that through the existing helpers.

We might want to rename them to align with the new generic helpers, but
yes otherwise the principle should remain unchanged.

In fact, we will also need to revive arch_flush_lazy_mmu_mode(). Indeed,
in the nested situation, we need the following arch calls:

enter() -> arch_enter()
    enter() -> [nothing]
    leave() -> arch_flush()
leave() -> arch_leave()

leave() must always flush whatever arch state was batched, as may be
expected by the caller.

How does all that sound?

>
> [...]
>
>>
>> Overall what you're proposing seems sensible to me, the additional
>> fields in task_struct don't take much space and we can keep the API
>> unchanged in most cases. It is also good to have the option to check
>> that the API is used correctly. I'll reply to the cover letter to let
>> anyone who didn't follow this thread chip in, before I go ahead and try
>> out that new approach.
>
> And on top of the proposal above we will have some
>
> struct arch_lazy_mmu_state;
>
> define by the architecture (could be an empty struct on most).
>
> We can store that inside "struct lazy_mmu_state;" or if we ever have
> to, start returning only that from the enable/disable etc. functions.

I'm not sure we'd want to mix those styles (task_struct member + local
variable), that's adding complexity without much upside... Also having a
local variable at every nesting level only makes sense if we have an
arch callback regardless of nesting level, which is unnecessary in this
proposed API.

>
> For now, I'd say just store it in the task struct in the
> lazy_mmu_state. But we can always adjust later if required.
>
> In the first (this) series we probably don't even have to introduce
> arch_lazy_mmu_state. 

I suppose this could improve the overall struct layout - but otherwise I
don't really see the need compared to adding members to thread_struct
(which is fully arch-specific).

- Kevin

