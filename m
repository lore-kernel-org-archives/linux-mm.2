Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37D8CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ACF88E0007; Tue,  9 Sep 2025 09:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084A48E0003; Tue,  9 Sep 2025 09:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F034A8E0007; Tue,  9 Sep 2025 09:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFF1A8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:49:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DBFB1404E0
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:49:59 +0000 (UTC)
X-FDA: 83869845318.24.DF57BF2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7D9631C000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:49:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757425797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ox3PrAh+a33VGhYFNAvHhhMpvTjkSB7kiqY6tVIvUkU=;
	b=On5srBVEvph961migWOZERDD9HdlVRGyOBVASh6/TRoOdy/D/Az8GAqJ2x8dxolRZOR99m
	NDCkjNf+U/UlRID6UKoll8PpqouZXG85ZDjc4MW2QCT06a1QPa6p+6EIJfeoURAjTUD+Sk
	b0OpYVP/Fo6W76Fk58/GZQ1CUwlqimI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757425797; a=rsa-sha256;
	cv=none;
	b=57dkn0M17aqKuca769RRwVVgQ2Wgx+QAJS53KD/Oed4c3JUCYsMtKdYjkgghyuYOOx6MTP
	T7n0HR0cItStNjIIUSzEpQAQWm3gvIReaFR+Qd+tR7hk+rIqo5kfhjoTSNvY6Bum1gZsSF
	OaZr45eAbPZYNAIcOZbtDgd/amTPP7U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F1831424;
	Tue,  9 Sep 2025 06:49:48 -0700 (PDT)
Received: from [10.44.160.77] (e126510-lin.lund.arm.com [10.44.160.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E3393F694;
	Tue,  9 Sep 2025 06:49:49 -0700 (PDT)
Message-ID: <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
Date: Tue, 9 Sep 2025 15:49:46 +0200
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
 <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D9631C000D
X-Stat-Signature: iia8y5gcq9sgrn43qpnznjqajwrch7y9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757425797-211455
X-HE-Meta: U2FsdGVkX1+Efi8nV1wf6TIGDJXUGoZpOI/KJlH+m1472vEzMuJUG0CPh1D35MPaEnp5fRtK/ijXaJkoxbY7lDYEu2u+Dy4zb0y090IMCl9MYG7jvHoD+XFnY8xHTrh0aIPtH1BXTBNXwpsTYPun7c08aBL7+4w1GJvRGWH/IdjJI8YRbF5+UwK+OiG10CmazgIe0L5qM8FqocJR5sHMbKWzZy34bsVdiUsyrRnhsMqfBzesFEfRh5KZL52pUIPz5w3Qc9CdMV5FvU49DQpRVhsoRf1iL0wJBK1cv6S7Hyhh0cZgE5TqvtSCD5WXE4/jELdKj8YqKgdzW9Zel7i6ZSxtPsiHT5FHqioQzXEQdSwZ/iSrDz5EzDP13OCum/HCBB9totpzMkQOxnmNk3QyLOSTT5nblXB7GRllS2QP0M6995RvL2GINl7EBcWtaUvMc+XfmkbqJ3s86AxIq1yQ1KPtWoSIV3zD1RZ3nYqPGMmuopB3VM3YsSivcFGKhRzaBqtOdyR2FpRgPhjKi9Dph9J5PviVHcTyRE6aC9TuwONdfuWWHkPFSbRoc6Q0SMIItOVsE1zEcPA/nuxjI5CgHGlmPpImrlnT9HOhDtF2RmlPNy1OcMj7seadHDXE6QrTSNpaLettqU6YFmH5mDXQF3DjBCMnYcbcLk4F28YneoJCMOaqNcbNSa5l4TX3steHw5i0+KGYdodB5yOkuv6ip3aCmmUpjKdDmzbCjhVCKYS8HSBkn3T1/inFXStufa5kL6sK7Xl8vHIRMXQPzFIfCHi7geIcqNaBrV6ZT3KXXOYW+HJcvJsgDnRU5DMmlS/n37XoeTkOnkRt00lCsA2y2JETAC+MGTUTagNKDnq1cvP52AyAGH/OqXR20zB0VGcTeA70CCzK8ob8m/VBOlD0Hyi6Q0msMHuj8tq+DoV8+YCBv+RzuVoE2kDKYxot1e9fP0a/RqtXWfYbWNk9DLb
 Ms106QJU
 34+J+BbC+rzUpm/Ml3LZwzKH6gyMff81MF3ufk7KUgDwfRij6ge3aM5yweuqZzrRG7+Dj/GYL6S9200RfJc5wkRsICDCN9uWxuqJGRzoMRdq6VlJaeMYD73J0uYm5sYZIRMWXXT56IqOYggJ2o6W7qXUM2Znrjx8ca2T3x+wZ2F5vCLEc/QeX7Plj6o2LAwmO98IkIVeckvInPRYOxe8ZYbNKKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2025 13:54, David Hildenbrand wrote:
> On 09.09.25 13:45, Alexander Gordeev wrote:
>> On Tue, Sep 09, 2025 at 12:09:48PM +0200, David Hildenbrand wrote:
>>> On 09.09.25 11:40, Alexander Gordeev wrote:
>>>> On Tue, Sep 09, 2025 at 11:07:36AM +0200, David Hildenbrand wrote:
>>>>> On 08.09.25 09:39, Kevin Brodsky wrote:
>>>>>> arch_{enter,leave}_lazy_mmu_mode() currently have a stateless API
>>>>>> (taking and returning no value). This is proving problematic in
>>>>>> situations where leave() needs to restore some context back to its
>>>>>> original state (before enter() was called). In particular, this
>>>>>> makes it difficult to support the nesting of lazy_mmu sections -
>>>>>> leave() does not know whether the matching enter() call occurred
>>>>>> while lazy_mmu was already enabled, and whether to disable it or
>>>>>> not.
>>>>>>
>>>>>> This patch gives all architectures the chance to store local state
>>>>>> while inside a lazy_mmu section by making enter() return some value,
>>>>>> storing it in a local variable, and having leave() take that value.
>>>>>> That value is typed lazy_mmu_state_t - each architecture defining
>>>>>> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is free to define it as it sees fit.
>>>>>> For now we define it as int everywhere, which is sufficient to
>>>>>> support nesting.
>>>> ...
>>>>>> {
>>>>>> + lazy_mmu_state_t lazy_mmu_state;
>>>>>> ...
>>>>>> - arch_enter_lazy_mmu_mode();
>>>>>> + lazy_mmu_state = arch_enter_lazy_mmu_mode();
>>>>>> ...
>>>>>> - arch_leave_lazy_mmu_mode();
>>>>>> + arch_leave_lazy_mmu_mode(lazy_mmu_state);
>>>>>> ...
>>>>>> }
>>>>>>
>>>>>> * In a few cases (e.g. xen_flush_lazy_mmu()), a function knows that
>>>>>>      lazy_mmu is already enabled, and it temporarily disables it by
>>>>>>      calling leave() and then enter() again. Here we want to ensure
>>>>>>      that any operation between the leave() and enter() calls is
>>>>>>      completed immediately; for that reason we pass
>>>>>> LAZY_MMU_DEFAULT to
>>>>>>      leave() to fully disable lazy_mmu. enter() will then
>>>>>> re-enable it
>>>>>>      - this achieves the expected behaviour, whether nesting
>>>>>> occurred
>>>>>>      before that function was called or not.
>>>>>>
>>>>>> Note: it is difficult to provide a default definition of
>>>>>> lazy_mmu_state_t for architectures implementing lazy_mmu, because
>>>>>> that definition would need to be available in
>>>>>> arch/x86/include/asm/paravirt_types.h and adding a new generic
>>>>>>     #include there is very tricky due to the existing header soup.
>>>>>
>>>>> Yeah, I was wondering about exactly that.
>>>>>
>>>>> In particular because LAZY_MMU_DEFAULT etc resides somewehere
>>>>> compeltely
>>>>> different.
>>>>>
>>>>> Which raises the question: is using a new type really of any
>>>>> benefit here?
>>>>>
>>>>> Can't we just use an "enum lazy_mmu_state" and call it a day?
>>>>
>>>> I could envision something completely different for this type on s390,
>>>> e.g. a pointer to a per-cpu structure. So I would really ask to stick
>>>> with the current approach.

This is indeed the motivation - let every arch do whatever it sees fit.
lazy_mmu_state_t is basically an opaque type as far as generic code is
concerned, which also means that this API change is the first and last
one we need (famous last words, I know). 

I mentioned in the cover letter that the pkeys-based page table
protection series [1] would have an immediate use for lazy_mmu_state_t.
In that proposal, any helper writing to pgtables needs to modify the
pkey register and then restore it. To reduce the overhead, lazy_mmu is
used to set the pkey register only once in enter(), and then restore it
in leave() [2]. This currently relies on storing the original pkey
register value in thread_struct, which is suboptimal and most
importantly doesn't work if lazy_mmu sections nest. With this series, we
could instead store the pkey register value in lazy_mmu_state_t
(enlarging it to 64 bits or more).

I also considered going further and making lazy_mmu_state_t a pointer as
Alexander suggested - more complex to manage, but also a lot more flexible.

>>> Would that integrate well with LAZY_MMU_DEFAULT etc?
>>
>> Hmm... I though the idea is to use LAZY_MMU_* by architectures that
>> want to use it - at least that is how I read the description above.
>>
>> It is only kasan_populate|depopulate_vmalloc_pte() in generic code
>> that do not follow this pattern, and it looks as a problem to me.

This discussion also made me realise that this is problematic, as the
LAZY_MMU_{DEFAULT,NESTED} macros were meant only for architectures'
convenience, not for generic code (where lazy_mmu_state_t should ideally
be an opaque type as mentioned above). It almost feels like the kasan
case deserves a different API, because this is not how enter() and
leave() are meant to be used. This would mean quite a bit of churn
though, so maybe just introduce another arch-defined value to pass to
leave() for such a situation - for instance,
arch_leave_lazy_mmu_mode(LAZY_MMU_FLUSH)?

>
> Yes, that's why I am asking.
>
> What kind of information (pointer to a per-cpu structure) would you
> want to return, and would handling it similar to how
> pagefault_disable()/pagefault_enable() e.g., using a variable in
> "current" to track the nesting level avoid having s390x to do that?

The pagefault_disabled approach works fine for simple use-cases, but it
doesn't scale well. The space allocated in task_struct/thread_struct to
track that state is wasted (unused) most of the time. Worse, it does not
truly enable states to be nested: it allows the outermost section to
store some state, but nested sections cannot allocate extra space. This
is really what the stack is for.

- Kevin

