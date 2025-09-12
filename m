Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFA0CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576788E0008; Fri, 12 Sep 2025 04:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527878E0001; Fri, 12 Sep 2025 04:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417018E0008; Fri, 12 Sep 2025 04:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30D978E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:48:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8D5286FA9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:48:39 +0000 (UTC)
X-FDA: 83879972358.14.8780071
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id AB16DA000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:48:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757666918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x/O37A+Sj5/ENSKE8ye7ob3Qbk26KdsluByV9/ixxKs=;
	b=V5/Qj8BdZxYue1Of0oy/W50Rd5RJaeGPorR2GhWuphbl8IzZTzmBQaN7WyRJXZiMGQVYti
	5n4+Uc/B2eMjth8nLLnDoUUv6Eg2tJs+3+xvgjQE/hflEz35l4Dk702oAOFl9ULnawlaRW
	U/TgLMCzwuFEb8mUWs4tcrQKSHVsKOY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757666918; a=rsa-sha256;
	cv=none;
	b=HJmGzJkQMJf3/T8cb+7eKbGZUmbgdq8gR4C79MmnkzX547dwKenmZjA7HCb1rV7UH0Pn6K
	9JD38JIHjG6PO5YgwL2ubxz7/bvIfzXYGEmLSB3duITwNiQtOeRWZ3bMPnguvb+goYBa4k
	h6RX1DU1WbnpxQX8nHo/YclNvYftUgU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4134416A3;
	Fri, 12 Sep 2025 01:48:28 -0700 (PDT)
Received: from [10.57.66.147] (unknown [10.57.66.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63FC83F66E;
	Fri, 12 Sep 2025 01:48:29 -0700 (PDT)
Message-ID: <781a6450-1c0b-4603-91cf-49f16cd78c28@arm.com>
Date: Fri, 12 Sep 2025 10:48:26 +0200
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
 <15d01c8b-5475-442e-9df5-ca37b0d5dc04@arm.com>
 <7953a735-6129-4d22-be65-ce736630d539@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <7953a735-6129-4d22-be65-ce736630d539@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB16DA000D
X-Stat-Signature: bj6uzgry99yk9ne7cfkhcmo9fbfax6e9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757666917-386798
X-HE-Meta: U2FsdGVkX1/GrKftC7Z3UGMmBPcARDCfiRNjkoxgilI4OAdiARgernZ4IMYGctE5Cm+EaLtFDPnbL4AyF2Arhs0xyRDsT9Ptni1SNsUE1hK7xVUPhYf9IlZJ/ZO4yXQ4iRoabHYd0W7pKCnNgC46ITyBijmT3y5LNd15hGC8yUJ5w+MlRhoCKs+2yUfluQY5PYSphjuPjVtvvMvtcL7kNG2D3i2Qy4c5lGJT+Q/kSTbZgJzAxaa0JeNMWTdvNIIOfsSyKqQWKdwRLEXZAeyD2xf69u2QaBbxlrn7APNJC8mG4scJhw5dXEORZ++jekjcLHvpF5BGTTqWQE34NAVH1eZ5Gg5eWE4VSc9R/F+6iSYoq3Bt9fOpjRwIzB70xl/Z8QBksoBW5C9L+NkU1lWzk/dV1rwIIo3A2Rw5o2cUUd9MuPYbay06oYAed6XQDsFXI8ajSsj1ecPFFqMYRp+60rIFoDFG7mwKAv9UkNj0XW/gMfCWU89Zbf2vWhr1kfIgKQ0qYEVXTJS1ztiry6JkNfYHPbDdoVDVIz7HizzAv/blfQmBpOdGPVEDPiiENgcECiRVg5eEZ2JCi7cwdAd427gAPcaXJgtUynoS/jZCEAw3mInfiounKFEWhVUsasUhSPOyeAhM/Zu89GOUusekwbeqlbZr/2GYBFsbucLsrIcM41qE7D2e/KMcQPiqW0mXzAiKB67uHO3tH94a+KakNWMUPRMtRUfaQS5dvlK7m0wCVJ7OnYKNwGuPoT9aUSlYgRQRGb4QS+KYMmh7yvUEsKQclaGT5ZIaqbOeLVHI0lFMEk5nq91WYEtYi08HN8lzIX3WmDRw+l6J4vgLMy3aDINadvjKf24mLegN7PPLLshFXetrBk1dYElLOI4YAEpWV29TkrW/L0WhIIBVSxsizdHTUAGK2hrXj7hIG4R8L9Y4J4PgMexv4pE+Ay9827l6LDUG2RTCaSzxdMoEE7z
 1qBmLWYa
 S9MW9y9zBvkK9ionp5RdeiDEZ+8uomZ476KCQ2gR/Orqz4/YaJdntIsmBX1tnqVfKMRpdJSLw3+ovEuPnfDjwN6mJmDP1q/SUcNallCy+E6DUEZwQylWt5+FwHPqcZc0eSFj3Zf0WFeVG1VuVAgmSu/Xx9VC7eGpFHplOs24uH9Fezvsde5FTrcArPNXVVCvuSx9m/xGQd/LheWdD+jSgKNBZTTJffbv4ZdcIgMLFFtNx+YIALtu+OZ1ejrd+pLp4a0HXvLWQyaSUiekocl477mzyCKd0DeN+orECGoXns23SWJs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/09/2025 10:04, David Hildenbrand wrote:
>>>
>>> struct lazy_mmu_state {
>>>      uint8_t enabled_count;
>>>      bool paused;
>>
>> Looking at the arm64 implementation, I'm thinking: instead of the paused
>> member, how about a PF_LAZY_MMU task flag? It would be set when lazy_mmu
>> is actually enabled (i.e. inside an enter()/leave() section, and not
>> inside a pause()/resume() section). This way, architectures could use
>> that flag directly to tell if lazy_mmu is enabled instead of reinventing
>> the wheel, all in slightly different ways. Namely:
>>
>> * arm64 uses a thread flag (TIF_LAZY_MMU) - this is trivially replaced
>> with PF_LAZY_MMU
>> * powerpc and sparc use batch->active where batch is a per-CPU variable;
>> I expect this can also be replaced with PF_LAZY_MMU
>> * x86/xen is more complex as it has xen_lazy_mode which tracks both
>> LAZY_MMU and LAZY_CPU modes. I'd probably leave that one alone, unless a
>> Xen expert is motivated to refactor it.
>>
>> With that approach, the implementation of arch_enter() and arch_leave()
>> becomes very simple (no tracking of lazy_mmu status) on arm64, powerpc
>> and sparc.
>>
>> (Of course we could also have an "enabled" member in lazy_mmu_state
>> instead of PF_LAZY_MMU, there is no functional difference.)
>>
>
> No strong opinion, but to me it feels like PF_LAZY_MMU is rather "the
> effective state when combining nested+paused", and might complicate
> the code + sanity checks?
>
> So we could maintain that in addition fairly easily of course from the
> core instead of letting archs do that manually.
>
> I would probably have to see the end result to judge whether removing
> the "paused" bool makes things look more complicated or not.

Agreed, it is a little difficult to consider all the cases ahead of
time. What is clear to me though is that [paused] can be inferred from
[count + enabled], and conversely [enabled] from [count + paused]. As a
result I really wouldn't store both paused and enabled in task_struct -
duplicating information is how you create inconsistent states.

We can very easily introduce helpers to get the enabled/paused status
regardless of how they're stored. Since "enabled" is what we need to
know in most cases (arch checking the status), I would rather store
"enabled" than "paused". But indeed, let's see how it turns out in practice.

>
>>> }
>>>
>>> c) With that config, common-code lazy_mmu_*() functions implement the
>>> updating of the lazy_mmu_state in task_struct and call into arch code
>>> on the transition from 0->1, 1->0 etc.
>>
>> Indeed, this is how I thought about it. There is actually quite a lot
>> that can be moved to the generic functions:
>> * Updating lazy_mmu_state
>> * Sanity checks on lazy_mmu_state (e.g. underflow/overflow)
>> * Bailing out if in_interrupt() (not done consistently across arch's at
>> the moment)
>>
>>>
>>> Maybe that can be done through exiting
>>> arch_enter_lazy_mmu_mode()/arch_leave_lazy_mmu_mode() callbacks, maybe
>>> we need more. I feel like
>>> we might be able to implement that through the existing helpers.
>>
>> We might want to rename them to align with the new generic helpers, but
>> yes otherwise the principle should remain unchanged.
>>
>> In fact, we will also need to revive arch_flush_lazy_mmu_mode().
>
> That's okay if it's all hidden behaind a sane core API.
>
>> Indeed,
>> in the nested situation, we need the following arch calls:
>>
>> enter() -> arch_enter()
>>      enter() -> [nothing]
>>      leave() -> arch_flush()
>> leave() -> arch_leave()
>>
>> leave() must always flush whatever arch state was batched, as may be
>> expected by the caller.
>>
>> How does all that sound?
>
> I am no expert on the "always flush when leaving", but it sounds
> reasonable to me.

This is a core expectation for lazy_mmu: when leave() is called, any
batched state is flushed. The fact it currently happens unconditionally
when calling leave() is in fact what stops nesting from exploding on
arm64 with DEBUG_PAGEALLOC [1].

[1] https://lore.kernel.org/all/aEhKSq0zVaUJkomX@arm.com/

>
> Which arch operations would you call from
>
> pause()
> continue()

I also wondered about that. I think the safest is to make them
respectively arch_leave() and arch_enter() - the flushing entailed by
arch_leave() might not be required, but it is safer. Additionally,
powerpc/sparc disable preemption while in lazy_mmu, so it seems like a
good idea to re-enable it while paused (by calling arch_leave()).

- Kevin

