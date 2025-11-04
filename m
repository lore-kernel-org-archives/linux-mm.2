Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BA9CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 11:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316268E0131; Tue,  4 Nov 2025 06:28:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7018E0124; Tue,  4 Nov 2025 06:28:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B58C8E0131; Tue,  4 Nov 2025 06:28:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 072A48E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:28:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9486F1404A1
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:28:55 +0000 (UTC)
X-FDA: 84072702630.30.B77C2D9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C14211C0006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:28:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762255734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q8S8W8Ce89aAd6Lp63iqNC1/ehzjUmA4uJIWdv2wfyI=;
	b=Ib78qr/SVpDDFsdbJ3b3x54mNpLIOzWByg1rFt5dJL0emq7496UKMEReVbtrQA8tbXIwUQ
	amYbomv07MVvhpa1a66rpiMbg/lJmeB2amrMiPJWWdgv1ZSTV+7FNsZU4ZbPUori9PNBvE
	mL3HN90ix4a8HTfOhDU8MgOyX2bSEFI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762255734; a=rsa-sha256;
	cv=none;
	b=nc42Xh2owOsmU+QrD8JamUDMQcqEfRteZyVJ0+9bohb0m/lZhej56IjYFQa5P3ZpajfdCP
	kLkGuS7q1eptqqcgCzdfMYrG6XzesNanCnKXjiENEnR7lmVqdCCPDq/A1IAWvFCeo3IHIy
	dHE+aU/EWJNy2kCqpQlAoSNdA8zBLlM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D54651C2B;
	Tue,  4 Nov 2025 03:28:44 -0800 (PST)
Received: from [10.1.38.100] (e126510-lin.cambridge.arm.com [10.1.38.100])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15B213F63F;
	Tue,  4 Nov 2025 03:28:44 -0800 (PST)
Message-ID: <216d54f1-334f-4600-9ecb-f7788b1abd7d@arm.com>
Date: Tue, 4 Nov 2025 11:28:42 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/12] x86/xen: use lazy_mmu_state when
 context-switching
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-12-kevin.brodsky@arm.com>
 <c7c8a233-2103-4b48-b65e-ec81666d20e4@kernel.org>
 <285faae4-dab6-4819-847a-889bdf87d5d7@arm.com>
 <a326d1eb-62f1-4add-8dc9-cea7d7e4ed3c@kernel.org>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <a326d1eb-62f1-4add-8dc9-cea7d7e4ed3c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C14211C0006
X-Stat-Signature: mx4ofk7rq43yb9oi6ria4auajztcgp1z
X-Rspam-User: 
X-HE-Tag: 1762255733-749167
X-HE-Meta: U2FsdGVkX1+C1Lfg8qTo2OSvl1IG6L3A0OOPdO6dcYUzR8QrBW7lwawvf9LwlJVriTPnAcgXqbsdGR+1t/yaLaxTtDvLlXKQpQzFl1Cb2r8Hw6EYRIDOhG8gh9m2zA66kvJC9aGL0CpkJKiPeQ8jkluASgWuwFBArLv2VISjQo2ReWh75f4NfGg9YBV/XAFGW0iT39YQ8BtOjDBFW1R735GyiEjPFB85HxQnnrCpCNgVohma3kGJgbZZKVm8Vm0EUB0VIMyA+I3ppItXLNKgCNVBdjak30An4Si7Qtc+hY2fscgD14CRCYKXbDWw9Pyr/CVjUSBGKE2/k85oWaavziL03KMcCr89onxZXBy9w6fztnf3+9349xiCzHeLTnFJXuI7T7AjnwwLgAXKQQtjdWwSUwuvYjdofSRrr+Yo7qV+lHPxJggeW4gUZYVhjzH4tfCxJze2B/Xrh8JF9pjfw7VKgt+2rkvV4AWWZps/dZ8wYIipNHbQx9i2xNl68iD0jUg0vBuWGtPbh2fT8Oo55gALf9YK1h8Ph+HJ/QYAnKj+tjxEqhcXmgmpGV1nDFq1hlCYWf43/mCcY6nuO7EpawWh0kAJQ8yfXNinNnUP3Tpsc6j1S/WR7doel3xZ1QxiouBA7ncCUyfGF1DhnHu58YOeEUCurX1eL4URfJkvYK+6VpCXGlJ+0v9l2pNdaSHbYvASVlDUNzxZz1qwIepavRlk2i6fEp9SBCJYw4ObnKup1/Hck/AZfROwsGD/93rjNV0qfgq6AOvYRqipBYJznzIH9BvQ79eAdJfkG0+tB9sTPCX0m7QsqFtx514XVZoojcUK2fHCfC9va2QnedgWO1dm61NFuD95P6yrGIopvRdPJW4bKz95KoPBZMIeX8W2YDnRgnrU41LLhZYcm+w/MUnuNvu3kJjr2bZUuVVfFOuxjb6k4XbI8yCgAbVx9c7e1fxBAerg02Nr+/ZIkta
 1V2rfPyj
 ouOqoS7jm+Film/dpqExMQ5oIFHoWAR/dKDUwJUN6Ubq/pt1SM7A9pP3oJoUsPXRSUCmzdgbpaEXobKa1wFeDRBADk23lPNVXCWT6I28TfFWr0WdNRUoQHH9erVf51givEVE2AzIR3gEY0ZTvhAczcNjq/f+fInpfHeFtxjR6kI0LmWGfkaZ7ciRlWVJEePRfIaEdhahPjNY8PIt44MIKuhChVEkHm8ZMWO9/P2TSwoOrDIrgx7UE5X6laNCEm9weLSQf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/11/2025 19:23, David Hildenbrand (Red Hat) wrote:
> On 03.11.25 19:29, Kevin Brodsky wrote:
>> On 03/11/2025 16:15, David Hildenbrand (Red Hat) wrote:
>>> On 29.10.25 11:09, Kevin Brodsky wrote:
>>>> [...]
>>>>
>>>> @@ -437,7 +436,7 @@ static void xen_end_context_switch(struct
>>>> task_struct *next)
>>>>          xen_mc_flush();
>>>>        leave_lazy(XEN_LAZY_CPU);
>>>> -    if (test_and_clear_ti_thread_flag(task_thread_info(next),
>>>> TIF_LAZY_MMU_UPDATES))
>>>> +    if (next->lazy_mmu_state.active)
>>>
>>> This is nasty. If in_lazy_mmu_mode() is not sufficient, we will want
>>> to have a separate helper that makes it clear what the difference
>>> between both variants is.
>>
>> in_lazy_mmu_mode() operates on current, but here we're operating on a
>> different task. The difference is more fundamental than just passing a
>> task_struct * or not: in_lazy_mmu_mode() is about whether we're
>> currently in lazy MMU mode, i.e. not paused and not in interrupt
>> context. A task that isn't scheduled is never in lazy MMU mode -
>> lazy_mmu_state.active is just the saved state to be restored when
>> scheduled again.
>>
>> My point here is that we could have a helper for this use-case, but it
>> should not be used in other situations (at least not on current). Maybe
>> __task_lazy_mmu_active(task)? I do wonder if accessing lazy_mmu_state
>> directly isn't expressing the intention well enough though (checking the
>> saved state).
>
>
> Likely there should be a
>
> /**
>  * task_lazy_mmu_active - test whether the lazy-mmu mode is active for a
>  *              task
>  * @task: ...
>  *
>  * The lazy-mmu mode is active if a task has lazy-mmu mode enabled and
>  * currently not paused.
>  */
> static inline bool task_lazy_mmu_active(struct task_struct *task)
> {
>     return task->lazy_mmu_state.active;
> }
>
> /**
>  * in_lazy_mmu_mode() - test whether current is in lazy-mmu mode
>  *
>  * Test whether the current task is in lazy-mmu mode: whether the
>  * interrupts are enabled and the lazy-mmu mode is active for the
>  * current task.
>  */
>  static inline bool in_lazy_mmu_mode(void)
>  {
> +    if (in_interrupt())
> +        return false;
> +
>      return task_lazy_mmu_active(current);
>  }
>
>
> Something like that. Maybe we can find better terminology.

That's probably the clearest yes, will make the change. I can't think of
more self-documenting names, spelling out the difference in the comments
is likely the best we can do.

- Kevin

