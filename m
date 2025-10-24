Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5852CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489348E00A4; Fri, 24 Oct 2025 10:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438898E0042; Fri, 24 Oct 2025 10:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300FB8E00A4; Fri, 24 Oct 2025 10:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C60D8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:33:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D45A988C64
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:33:36 +0000 (UTC)
X-FDA: 84033251232.03.752A193
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 27CA140014
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:33:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a+NzFcJxTQ88UObe6RCiomPcPFxCGLX+axvPSVA7A04=;
	b=QcYXgy69E0zyIaH9hZzxVT7wRLKdLQNLnaBL7ChiNA0Hr+HQrx58P9n68NOBdmaE7tVTLd
	xw3d0z4WO0MgLrBFFGKS9287NCB1QGuY+C87N2zqyro4U+lmdBhULK/rP2bT3B9aDVvaWA
	+l8Q8JuyOhRIReCVInyvfE10mPqztcY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761316415; a=rsa-sha256;
	cv=none;
	b=4LbmPHsQOpzymQgYLG9aRd7qrTt+lJcv49PyLNksCNyOvSlnHWB6oLtPNS/QciUBIpPji5
	6NeZRzHCB4oFWz6sEajfaZPY8HQoJeolAeQSfhG7OVmItaGl50KWh4Tz/89sF60Y16y3u2
	5U7ipO0GwM9QuOsIX2n6Sq6ykMwekeg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66B1C1516;
	Fri, 24 Oct 2025 07:33:26 -0700 (PDT)
Received: from [10.44.160.74] (e126510-lin.lund.arm.com [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7FEF3F66E;
	Fri, 24 Oct 2025 07:33:25 -0700 (PDT)
Message-ID: <f458fbed-266b-48a5-a6e0-745dc2893a34@arm.com>
Date: Fri, 24 Oct 2025 16:33:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] mm: enable lazy_mmu sections to nest
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
 <20251015082727.2395128-8-kevin.brodsky@arm.com>
 <2073294c-8003-451a-93e0-9aab81de4d22@redhat.com>
 <7a4e136b-66a5-4244-ab07-f0bcc3a26a83@arm.com>
 <af4414b6-617c-4dc8-bddc-3ea00d1f6f3b@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <af4414b6-617c-4dc8-bddc-3ea00d1f6f3b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27CA140014
X-Stat-Signature: 5edm6st4wdh7sjdmkt6jky3k4bacbei1
X-Rspam-User: 
X-HE-Tag: 1761316414-794564
X-HE-Meta: U2FsdGVkX18MC/eK7NYWT0+S/vqKYDwEWlXhlWrvlv61P7dDvEXiQlbLS7IDzoMSiWnUfqLYNt1v9zJv3dC7CYeyF8bwUBSpBLUuRjNpdh9Ej9/2wNkxc1zNyLJvs/9I5md7DIsgFgAmWPCf0rfx/F2eUEGzAh7pzl9CHykobvtj27sPvRaWDBDyOYI0iQWsgOm1SYS8bfZ1mWlo5GQEPRj274jCrxxlLjOgr2Int7JFRpMM/4JgFs2/dRv7tbV8VFvthgss6svrZeYKFLy9dZ7/b2WQ/hUU1OFQ+5Rrhf4cFMkHUIfF4Mb7DULPmgpBdkxF2izVQx2PJC5jABDyFg/qP9GPbh+7N+xRSjdzm7F7gy3vhp0GKFfSHeDyGyLQiF5IbGF57emDLU1keAGVe/8DeRMuiAGpsVeLL4vehBdV131CLi57HixfUeELvWa1WV+fJHpp0HS6OmjKPQtGQ67bO4TvGqvUnqKCNuoW+eHfWqhacnMKAq3k+gQGWyuVNKSV331lOBdyaa0RhLQI23lfe1KhAeTClC29xd9Wfr7X5BtSsCIPI/RMOQSki4y4wDmBaQVb5vCP617EB1UtAHhmFRB3zd7NqVf1Ut/e3Uv9xLf2CDWTqni9lQaNHVdLAfncl9n71WmIp0JJ4uuoXssoYYHvrmvXxN0b/IhTBpqPp8q4njBtiiwZDIOA9ALxFRYuH6oxjHzHrLQM60I6NSYP5JoJ3N2GhW0jSk2+AANeaKyytXb2keOMENV3T7uM0JzuYkQJVBqObKYmhnlFLf8MNdqGtsPpIz7yqrD5xIr22FIQfON5rZvDTZxl6JaHGG0DDJdQdlUlQ63FHu/vl9NzCLm1vM4U/ZE2uXhNTvVmiczq9aZ5MceVtFdVGYQMCAHFOqrcahg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/10/2025 15:23, David Hildenbrand wrote:
>>>> + * currently enabled.
>>>>     */
>>>>    #ifdef CONFIG_ARCH_LAZY_MMU
>>>>    static inline void lazy_mmu_mode_enable(void)
>>>>    {
>>>> -    arch_enter_lazy_mmu_mode();
>>>> +    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>> +
>>>> +    VM_BUG_ON(state->count == U8_MAX);
>>>
>>> No VM_BUG_ON() please.
>>
>> I did wonder if this would be acceptable!
>
> Use VM_WARN_ON_ONCE() and let early testing find any such issues.
>
> VM_* is active in debug kernels only either way! :)

That was my intention - I don't think the checking overhead is justified
in production.

>
> If you'd want to handle this in production kernels you'd need
>
> if (WARN_ON_ONCE()) {
>     /* Try to recover */
> }
>
> And that seems unnecessary/overly-complicated for something that
> should never happen, and if it happens, can be found early during testing.

Got it. Then I guess I'll go for a VM_WARN_ON_ONCE() (because indeed
once the overflow/underflow occurs it'll go wrong on every
enable/disable pair).

>
>>
>> What should we do in case of underflow/overflow then? Saturate or just
>> let it wrap around? If an overflow occurs we're probably in some
>> infinite recursion and we'll crash anyway, but an underflow is likely
>> due to a double disable() and saturating would probably allow to
>> recover.
>>
>>>
>>>> +    /* enable() must not be called while paused */
>>>> +    VM_WARN_ON(state->count > 0 && !state->enabled);
>>>> +
>>>> +    if (state->count == 0) {
>>>> +        arch_enter_lazy_mmu_mode();
>>>> +        state->enabled = true;
>>>> +    }
>>>> +    ++state->count;
>>>
>>> Can do
>>>
>>> if (state->count++ == 0) {
>>
>> My idea here was to have exactly the reverse order between enable() and
>> disable(), so that arch_enter() is called before lazy_mmu_state is
>> updated, and arch_leave() afterwards. arch_* probably shouldn't rely on
>> this (or care), but I liked the symmetry.
>
> I see, but really the arch callback should never have to care about that
> value -- unless something is messed up :)

Fair enough, then I can fold those increments/decrements ;)

- Kevin

