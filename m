Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 249ADCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 11:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193CA8E0003; Tue,  9 Sep 2025 07:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DD68E0001; Tue,  9 Sep 2025 07:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27258E0003; Tue,  9 Sep 2025 07:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE4188E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:29:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BE1059105
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:29:03 +0000 (UTC)
X-FDA: 83869490166.09.0C1F90B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id BEC351A0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:29:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757417341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=axp0FTGXefGro3RhqluT9iJwb+PyenJkwISYzkbLArA=;
	b=2ZAv2WjxaPKCjzMAO2yU9hpxYtZIocisCjpq0AwbBAD7Dxhl58sxyBfAXcQ0Puo9qmhg5w
	3rL1xmSWrULcYaUXkGdDy1LKjyHhGZt/9bLzHeFFYHSWrcXeN6NJLuBUAAUVnsVw/Q9AGy
	5rta4rSlHoTthrdnHR0lh1LSeVopp68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757417341; a=rsa-sha256;
	cv=none;
	b=W60JahQ9sv4jsn8xW1vT/wqhnNlJ5zbidGp+xbmcxS14R2gnSm+v0ujd+Pw9KvkGgE+HlM
	18j/a2hcQP5/RsfThZvY8wfSmMKsWL3WNsNXO/Gso7w8r5LFFFrgDFrf9x7GGHL84cj7CZ
	nRLX1DxIY3g0NhzbwHXIKUwzRpNenZ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CB201424;
	Tue,  9 Sep 2025 04:28:52 -0700 (PDT)
Received: from [10.57.79.24] (unknown [10.57.79.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF8BD3F694;
	Tue,  9 Sep 2025 04:28:49 -0700 (PDT)
Message-ID: <0fd00f60-d3f1-4c86-925c-6947decb5159@arm.com>
Date: Tue, 9 Sep 2025 13:28:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] x86/xen: support nested lazy_mmu sections (again)
To: David Hildenbrand <david@redhat.com>, =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?=
 <jgross@suse.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-5-kevin.brodsky@arm.com>
 <aa28c1a7-82fc-42af-9904-a4d4db078a19@redhat.com>
 <360712fa-f7a0-4674-acc4-76f79141fe4f@suse.com>
 <57f49b72-2126-48f0-a4ef-4b138bd0bead@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <57f49b72-2126-48f0-a4ef-4b138bd0bead@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 11hxa9cxs95bhw9qgz9oj9aw1omou165
X-Rspam-User: 
X-Rspamd-Queue-Id: BEC351A0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1757417341-97569
X-HE-Meta: U2FsdGVkX180nyFH1TAD+fW5KSCbniguGhF3qDm7t3gwq/LevatiATKbUlyxw+MEU+lj/+FhSK6uEzdG3YOslRxIOZFMxJDfQz2r9zwei5Ihetu9DsoVEKJx9HKOeAE2Cj8nYc6o9pTb5x5BybLGakSYrv919nup5go6pI3PKBhmQoU9dfy1uCKpm8Hxhy573dNsNd8TunOobwnSyBZIqIfFaN5L8XftHuwGVNmqjpena+doVujt60QoPON9v+F7+GViHwMdOJ3oRJivQrQZZVyJd9kDpmlkITlh+MCxEU+/8w3Ykzqc5rytNw+fqrp+TNEIoHXbyRx9bS/KjyCQ7dW9mbVShUIULIndZkiZUghPm6Tf17qyGIwlhChd4WyOsGGgovu9YE0fkqUTm1x2qfmUq3KlAOHPnLEgoWlSUhTsUEvTA3WLuzvKXZ7j092q0l798Ja2LlU3nYAfOmg7cQ1h7qYHic5Prm9AAWiAXz1Vs0ASLbKibeph2IsGPChb6S8RzWCy9T5VZqkpwWstprkVM44hyTcR8jgOGQCSTgccRP6VAwFMeFtQQPGGO6hnZ1WNbrTGD7JNevz7vvlslHRSrjHxShfjPcyl+hclgzBlqnanPSHeR4OoX4JFu7lVOzVmhpRDAyBnxEWxlACzoA+Z7n6cb0jxsT/IE5PBUMQKh9/6CfuE32z1biuU4W7PaQIXLHsOCP4mHEPTLWRs/UgJxh/j9AOVNw7kFAIBmgtcxz2Vz7PNI0RtSoP6xdzmyfvztmegvMOhrY+eS4PNq1FKAB+2AUb5EznhTkfGAw8qSAekUz0CnOHo6IFdoQH8h8HRQ2YQ301ZZ+8ADlKkNCi/plKjVTTzmRUG3fTcfq52cOyM5kscttOPmk68Wv3cbT8arOdX0TEP1pNd4AH53eholhV+dYQrNn4cXUkHq7hT5qam0ymEx81CuxfPBWo2RDcAKCRtdMCh9xOmttS
 jMinG/X3
 ZwDy0Sb3uB52984abWtelUAYFIvhAwCQmVXc7I7OQ+bp9uVo7gcdoA2b7HjCkcQ2SVQgjWxPK2pQRmAbQanvITO98jNrMVLkUS2Z4mHTQCfowQ6O0B7RPH49+Igy6YPisUkFrt+QF8hv15tRqK7JGYTlHmncL/fMIad462+k4L9fsL4oBjtBf4YDoDTUYwu7WAber3VYLW8Htp/tW+gHayAzFdAQ9ohhSYHzGHsPfLg8jl+QcTQVQAWIXe+JCoWmlhPrizN/4G2hx55cxhqTG/HDa5sdM12TBRJQVTy+OO7HjKUu9+rPFVQd8ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2025 11:56, David Hildenbrand wrote:
> On 09.09.25 11:37, Jürgen Groß wrote:
>> On 09.09.25 11:13, David Hildenbrand wrote:
>>> On 08.09.25 09:39, Kevin Brodsky wrote:
>>>> Commit 49147beb0ccb ("x86/xen: allow nesting of same lazy mode")
>>>> originally introduced support for nested lazy sections (LAZY_MMU and
>>>> LAZY_CPU). It later got reverted by commit c36549ff8d84 as its
>>>> implementation turned out to be intolerant to preemption.
>>>>
>>>> Now that the lazy_mmu API allows enter() to pass through a state to
>>>> the matching leave() call, we can support nesting again for the
>>>> LAZY_MMU mode in a preemption-safe manner. If xen_enter_lazy_mmu() is
>>>> called inside an active lazy_mmu section, xen_lazy_mode will already
>>>> be set to XEN_LAZY_MMU and we can then return LAZY_MMU_NESTED to
>>>> instruct the matching xen_leave_lazy_mmu() call to leave
>>>> xen_lazy_mode unchanged.
>>>>
>>>> The only effect of this patch is to ensure that xen_lazy_mode
>>>> remains set to XEN_LAZY_MMU until the outermost lazy_mmu section
>>>> ends. xen_leave_lazy_mmu() still calls xen_mc_flush()
>>>> unconditionally.
>>>>
>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>> ---
>>>>    arch/x86/include/asm/paravirt.h       |  6 ++----
>>>>    arch/x86/include/asm/paravirt_types.h |  4 ++--
>>>>    arch/x86/xen/mmu_pv.c                 | 11 ++++++++---
>>>>    3 files changed, 12 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/paravirt.h
>>>> b/arch/x86/include/asm/paravirt.h
>>>> index 65a0d394fba1..4ecd3a6b1dea 100644
>>>> --- a/arch/x86/include/asm/paravirt.h
>>>> +++ b/arch/x86/include/asm/paravirt.h
>>>> @@ -529,14 +529,12 @@ static inline void
>>>> arch_end_context_switch(struct
>>>> task_struct *next)
>>>>    #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>>>>    static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
>>>>    {
>>>> -    PVOP_VCALL0(mmu.lazy_mode.enter);
>>>> -
>>>> -    return LAZY_MMU_DEFAULT;
>>>> +    return PVOP_CALL0(lazy_mmu_state_t, mmu.lazy_mode.enter);
>>>>    }
>>>>    static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
>>>>    {
>>>> -    PVOP_VCALL0(mmu.lazy_mode.leave);
>>>> +    PVOP_VCALL1(mmu.lazy_mode.leave, state);
>>>>    }
>>>>    static inline void arch_flush_lazy_mmu_mode(void)
>>>> diff --git a/arch/x86/include/asm/paravirt_types.h
>>>> b/arch/x86/include/asm/
>>>> paravirt_types.h
>>>> index bc1af86868a3..b7c567ccbf32 100644
>>>> --- a/arch/x86/include/asm/paravirt_types.h
>>>> +++ b/arch/x86/include/asm/paravirt_types.h
>>>> @@ -45,8 +45,8 @@ typedef int lazy_mmu_state_t;
>>>>    struct pv_lazy_ops {
>>>>        /* Set deferred update mode, used for batching operations. */
>>>> -    void (*enter)(void);
>>>> -    void (*leave)(void);
>>>> +    lazy_mmu_state_t (*enter)(void);
>>>> +    void (*leave)(lazy_mmu_state_t);
>>>>        void (*flush)(void);
>>>>    } __no_randomize_layout;
>>>>    #endif
>>>> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
>>>> index 2039d5132ca3..6e5390ff06a5 100644
>>>> --- a/arch/x86/xen/mmu_pv.c
>>>> +++ b/arch/x86/xen/mmu_pv.c
>>>> @@ -2130,9 +2130,13 @@ static void xen_set_fixmap(unsigned idx,
>>>> phys_addr_t
>>>> phys, pgprot_t prot)
>>>>    #endif
>>>>    }
>>>> -static void xen_enter_lazy_mmu(void)
>>>> +static lazy_mmu_state_t xen_enter_lazy_mmu(void)
>>>>    {
>>>> +    if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU)
>>>> +        return LAZY_MMU_NESTED;
>>>> +
>>>
>>> You mention above "preemption-safe manner" above, so I am wondering,
>>> what if we get preempted immediately after doing the this_cpu_read()
>>> and get
>>> scheduled on another CPU?
>>>
>>
>> This should still be correct: preemption needs a context switch to
>> happen,
>> so xen_start_context_switch() and xen_end_context_switch() are involved.
>> Those are dealing with this problem by doing the right thing in the old
>> and the new context.
>
> Thanks, that makes sense. Would be valuable to add that detail to the
> patch description. 

That's a fair point, Alexander was also wondering in v1 (and so was I
when I worked on this patch). Will clarify in v3.

- Kevin

