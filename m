Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4515ACCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 10:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7401080137; Tue, 28 Oct 2025 06:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F05A80131; Tue, 28 Oct 2025 06:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF0B80137; Tue, 28 Oct 2025 06:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 469DF80131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:34:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D72EC87E97
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:34:49 +0000 (UTC)
X-FDA: 84047164698.20.5FAFFDE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id ECF98180002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:34:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761647688; a=rsa-sha256;
	cv=none;
	b=5bleclP8vGmBlNSTQwg5VvGKBghEBW2Mio65eQMQhPYa1OWEBlorg847WVb7miOBaYUqDh
	47Xgo0+u/ihZuUN2+NUrc9MP+o0JSNGNs1HZNndOkjm9Aau52BUgfmAhwwUFin+er6H51t
	aswL866XwOQ/aFM5VKHeqtkSnytmdXQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761647688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HaFRhf1AjitWDNq9/FJXcfd6yha35h050b//Tq74Pw=;
	b=WfpC8sxBusrMy5p4zCinrWpNxBRcUZf17bg/9omUZc01uh3EHC86bc5UigV9BrGPO7bPdD
	l/xHF6oY8DDNj6wftF0WEkxjwbsoinZj5x+H05RvBj/r2Z0iurXUymSxh0n28hfQZ5PIpV
	5Jbrp3V+A7ogQrSpaqz5RMFuFbV7se0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07A50106F;
	Tue, 28 Oct 2025 03:34:39 -0700 (PDT)
Received: from [10.44.160.74] (unknown [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3597D3F63F;
	Tue, 28 Oct 2025 03:34:39 -0700 (PDT)
Message-ID: <f3b8a71c-7698-4918-99d1-36e97bded97c@arm.com>
Date: Tue, 28 Oct 2025 11:34:34 +0100
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
 <28bf77c0-3aa9-4c41-aa2b-368321355dbb@arm.com>
 <14030818-52e7-41eb-8ad7-602f3476d448@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <14030818-52e7-41eb-8ad7-602f3476d448@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ECF98180002
X-Stat-Signature: wk1di9ykrf8rt5f6chmgokeao6p7ihto
X-HE-Tag: 1761647687-619183
X-HE-Meta: U2FsdGVkX1/Vwnz+5uLlnwRXUkjLsEj59QLC7y7QvYUxlIAlcXFWfvX9umachwy2YIRU+17Og8AGwGM7DorRB77udlUtcRNz9qYdeCscd+oz91BxTP7xEhp4u7PIPI1mgWNDgF0LGwRlONNf6+EP8PFEJibbm3mdiiC99MGey0YxBHwNvM4Tl62eNThNIcWLAJyi9/anIwGG3JA/g2fhyZBPxFxt8ycdtZMpwixH1/W2MxfN78e7zr7T87gWI98j0sSF7deIm90VVmWjAh9PslEMwFx4XXWwHVEiVzrtp2hJaVNbEOdMeibR/S4lJTg5ONuD+ej3KSqeeOpPRzUC19Cyrsbyeij1J0QLsz8/flk/Aaodtn5ZrhKJXoRo5sBGO1qBojPi6YoORwf7X7OIg09AkV0buvThP5iZ+VWMC5UKkjOG7IuS3iCHo+txgvVatxosD1rKYe8U+n02Fp6JFzpdzg3V8z+pLO5Qr1/7sfte1KGe2cZKy2u8VQdG977dEhEZ9dWNkmP4tM9JtvyHH4k776LS6IkJ4olesqBmogI2onMy4mh4nGEO1YA4ExLzAO+AEJHMc81kkraiMqWcRhzvy//8l+ZbmvdCFzSyKUN9i9VuCG+3AN6KCMB4VYy4vtkrdmw2ba3p568nTuzn+gmMXp5Q9ydRrcnorbeadWy8aDlynx7ywW34ibHrKyMzUAfnOY9ero6FEJFeSy96nZ7ZkkcAHUo+Jf/0P+tiIZibJUfk2ARGKsWeydlb+AafkbJZ0py7xp7o+TV3K/9+W2SJ//HfFCW6YHVHIRHw8dxL8oW8uau0FMWYmNQbgEcjHXMZn48jd9REm7KdNN5CRqqQ9bo8V8Fxn2ZHS+MB7hXonlv4v3T2fnymeMZVxi/pWeE9SjTruzA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/10/2025 17:24, David Hildenbrand wrote:
> On 24.10.25 16:32, Kevin Brodsky wrote:
>> On 24/10/2025 15:27, David Hildenbrand wrote:
>>> On 24.10.25 14:13, Kevin Brodsky wrote:
>>>> On 23/10/2025 21:52, David Hildenbrand wrote:
>>>>> On 15.10.25 10:27, Kevin Brodsky wrote:
>>>>>> [...]
>>>>>>
>>>>>> * madvise_*_pte_range() call arch_leave() in multiple paths, some
>>>>>>      followed by an immediate exit/rescheduling and some followed
>>>>>> by a
>>>>>>      conditional exit. These functions assume that they are called
>>>>>>      with lazy MMU disabled and we cannot simply use
>>>>>> pause()/resume()
>>>>>>      to address that. This patch leaves the situation unchanged by
>>>>>>      calling enable()/disable() in all cases.
>>>>>
>>>>> I'm confused, the function simply does
>>>>>
>>>>> (a) enables lazy mmu
>>>>> (b) does something on the page table
>>>>> (c) disables lazy mmu
>>>>> (d) does something expensive (split folio -> take sleepable locks,
>>>>>       flushes tlb)
>>>>> (e) go to (a)
>>>>
>>>> That step is conditional: we exit right away if pte_offset_map_lock()
>>>> fails. The fundamental issue is that pause() must always be matched
>>>> with
>>>> resume(), but as those functions look today there is no situation
>>>> where
>>>> a pause() would always be matched with a resume().
>>>
>>> We have matches enable/disable, so my question is rather "why" you are
>>> even thinking about using pause/resume?
>>>
>>> What would be the benefit of that? If there is no benefit then just
>>> drop this from the patch description as it's more confusing than just
>>> ... doing what the existing code does :)
>>
>> Ah sorry I misunderstood, I guess you originally meant: why would we use
>> pause()/resume()?
>>
>> The issue is the one I mentioned in the commit message: using
>> enable()/disable(), we assume that the functions are called with lazy
>> MMU mode is disabled. Consider:
>>
>>    lazy_mmu_mode_enable()
>>    madvise_cold_or_pageout_pte_range():
>>      lazy_mmu_mode_enable()
>>      ...
>>      if (need_resched()) {
>>        lazy_mmu_mode_disable()
>>        cond_resched() // lazy MMU still enabled
>>      }
>>
>> This will explode on architectures that do not allow sleeping while in
>> lazy MMU mode. I'm not saying this is an actual problem - I don't see
>> why those functions would be called with lazy MMU mode enabled. But it
>> does go against the notion that nesting works everywhere.
>
> I would tackle it from a different direction: if code calls with lazy
> MMU enabled into random other code that might sleep, that caller would
> be wrong.
>
> It's not about changing functions like this to use pause/resume.
>
> Maybe the rule is simple: if you enable the lazy MMU, don't call any
> functions that might sleep.

You're right, this is a requirement for lazy MMU. Calling enable() then
disable() means returning to the original state, and if the function
sleeps at that point then the caller must not itself enable lazy MMU.

I mixed up that case with the original motivation for pause()/resume(),
which is to temporarily pause any batching. This is considered an
implementation detail and the caller isn't expected to be aware of it,
hence the need for that use-case to work regardless of nesting.

> Maybe we could support that later by handling it before/after
> sleeping, if ever required?

Indeed, pause()/resume() could be used to allow functions that sleep to
be called with lazy MMU enabled. But that's only a hypothetical use-case
for now.

> Or am I missing something regarding your point on pause()/resume()?

Doesn't sound like it :) I'll remove that paragraph from the (already
long) commit message. Thanks!

- Kevin

