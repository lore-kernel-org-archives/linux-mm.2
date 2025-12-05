Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55564D2F7CC
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 12:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221496B014A; Fri,  5 Dec 2025 07:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F98D6B014C; Fri,  5 Dec 2025 07:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137446B0150; Fri,  5 Dec 2025 07:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 005076B014A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:47:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EF9913311F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:47:26 +0000 (UTC)
X-FDA: 84185393292.17.5505F03
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C6C8140011
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:47:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764938844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bIPVyCSJgatZ7JLbD2Uja0xaWq0e923lFU6Qth2saH0=;
	b=xwJkJt6XYtxaTozrhb4wxKFaObhG3VukAHGNxYSX1D6MhNMWt8JclO6T/VyKwnQp+tyotK
	auPiXpd5KQ1r4BU5b/fLuBBke9iV1cUkOh8dPo3mT929GNiTYJJTRrzdjz+Qrj+bfGAPnw
	RhovQ4jFcx15CziAPCwONVDgq3mlaBk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764938844; a=rsa-sha256;
	cv=none;
	b=y5CpzEfiZFYGJZRRAq/dSAE40w8iDRQHnOuLhSB3bINJJH9iWEyXBuS19UHUSVt9s1cKX8
	9RbwM9bmDYbYC9JqjmFgLxbcirIKVJwI59xmSs7lQww6netUkB1fS2AG/4knWZDuORwCRh
	Ev98joEpMBVR6Y1xHeIOLptvz0Qh47E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD460339;
	Fri,  5 Dec 2025 04:47:15 -0800 (PST)
Received: from [10.44.160.68] (e126510-lin.lund.arm.com [10.44.160.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5F6D3F86F;
	Fri,  5 Dec 2025 04:47:15 -0800 (PST)
Message-ID: <573881f1-60f7-4eb3-a484-1df4858aa1b4@arm.com>
Date: Fri, 5 Dec 2025 13:47:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/12] mm: introduce generic lazy_mmu helpers
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
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
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-7-kevin.brodsky@arm.com>
 <e43c147f-bff8-462a-88dc-4345500f4ed7@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <e43c147f-bff8-462a-88dc-4345500f4ed7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C6C8140011
X-Stat-Signature: czxymf9fwruw34hn3xzgi9eijihezjbb
X-Rspam-User: 
X-HE-Tag: 1764938844-654979
X-HE-Meta: U2FsdGVkX1+oDbVEN7R1/f6h7n31Vc+AVsK2YSOxgx3SH5tv+B/uAU6umAdZTOMTzehWph4w35ewbCtLrXX+NeOo+6pZ1pTDRvLiFYVkOZuZBii8OVQO4SCs2fQMopervs94xwF1BbSD2iGF756D2A+0zMl2gv+EC6m/sm9iLA6eynVAHd1D68zzSOm1j1BOhq4GxS5IRGsiElaTM7W9fGKaF0ul7GaWU3unCQfcw+OnmJTvshhIam15ZQqrzz9cayku2XBYX5EhmOk2acF18lQHwe6RYc1XoG9dPF++RF4zprQQIj2nTDTUS4UrdiNFDwxZHP+opw1SEEXkNuSDy5x1weRD5WhHfYMtZ7lNyba7kTeefVUidR7NxH1F7bRxfrIEpiXGgQ03ykYoWjlpO9lL+slRqAz4gaWWtNCbQctxJreT7EGr/Z8xPHg7Q2/2Nfvgs3R23MxHLdHfpApHgPZiKbagY2Mg3d6dktzJEWYshFR7IIEgJntWEqy7BQGlgcH2kQGmiS3jWsGqTPnBMJY945nx88l0soBLBa22c+mqVgIQCmV94rHc/eAW95d6GgQpF4vpVwBnlx7M+TeMn3LxIKaqE0vIlmMVyet/klbL084srcLuYhLsXF4VLHGbcHTdIzIV7RBDXcoNJ9LpsUBvTZJE0+3DlxrRexuc5y2qxaRQtOh60SBc3tPNnGzYsE2nHuacc1O6EX0bfv2b3hbF7W+8r0tcL3nn+GjcYdPl6FfFJNvfJr4GcNMu8sFB3qaiLHjO+puCAskvJpgv8wynrti1nzZT7k4jld7P9juc6WnRzbyDeEIBdEmMiktPAdM1HQYItINnwhrtZsIJT9OD0Qq/EVTW9m29GVR7OOeFte9CUcB1l/SJIi3wGML34Smp2JP6Q/B1Wavv/IxrwnKHRORJiRtKWFBE64oPFYZptjc7PwiM08mrB3+BZoHzAPwMBbSsdrHSSBN73sx
 VsjMqK52
 TvjZt0YgflvSXVY0TkHVtKdiifDXRum81LTjyfubVRR1RWH8vVzYWlcT0a0QBYus/793C8xYp4baXMkgoSwVlih8SP1Xgiet0OWMLh4iHVuEDu4MDo2Y5h1kK6U84HEYOyqGylFHKCTjvyIisCJSa9tB7ANP4/p77/RtiXD2F56fnmXxcJj1oV+vN34PF8alQZzKam8B0AXWAKdkCh43G0h2bLnz/tiKpFwmvCJTrPWORUOIcyINkyQ2f3YRiZhvN81jcyPERhQsV71A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/12/2025 05:17, Anshuman Khandual wrote:
> On 24/11/25 6:52 PM, Kevin Brodsky wrote:
>> The implementation of the lazy MMU mode is currently entirely
>> arch-specific; core code directly calls arch helpers:
>> arch_{enter,leave}_lazy_mmu_mode().
>>
>> We are about to introduce support for nested lazy MMU sections.
>> As things stand we'd have to duplicate that logic in every arch
>> implementing lazy_mmu - adding to a fair amount of logic
>> already duplicated across lazy_mmu implementations.
>>
>> This patch therefore introduces a new generic layer that calls the
>> existing arch_* helpers. Two pair of calls are introduced:
>>
>> * lazy_mmu_mode_enable() ... lazy_mmu_mode_disable()
>>     This is the standard case where the mode is enabled for a given
>>     block of code by surrounding it with enable() and disable()
>>     calls.
>>
>> * lazy_mmu_mode_pause() ... lazy_mmu_mode_resume()
>>     This is for situations where the mode is temporarily disabled
>>     by first calling pause() and then resume() (e.g. to prevent any
>>     batching from occurring in a critical section).
>>
>> The documentation in <linux/pgtable.h> will be updated in a
>> subsequent patch.
>>> No functional change should be introduced at this stage.
>> The implementation of enable()/resume() and disable()/pause() is
>> currently identical, but nesting support will change that.
>>
>> Most of the call sites have been updated using the following
>> Coccinelle script:
>>
>> @@
>> @@
>> {
>> ...
>> - arch_enter_lazy_mmu_mode();
>> + lazy_mmu_mode_enable();
>> ...
>> - arch_leave_lazy_mmu_mode();
>> + lazy_mmu_mode_disable();
>> ...
>> }
>>
>> @@
>> @@
>> {
>> ...
>> - arch_leave_lazy_mmu_mode();
>> + lazy_mmu_mode_pause();
>> ...
>> - arch_enter_lazy_mmu_mode();
>> + lazy_mmu_mode_resume();
>> ...
>> }
> At this point arch_enter/leave_lazy_mmu_mode() helpers are still
> present on a given platform but now being called from new generic
> helpers lazy_mmu_mode_enable/disable(). Well except x86, there is
> direct call sites for those old helpers.

Indeed, see notes below regarding x86. The direct calls to arch_flush()
are specific to x86 and there shouldn't be a need for a generic abstraction.

- Kevin

> arch/arm64/include/asm/pgtable.h:static inline void arch_enter_lazy_mmu_mode(void)
> arch/arm64/include/asm/pgtable.h:static inline void arch_leave_lazy_mmu_mode(void)
>
> arch/arm64/mm/mmu.c:    lazy_mmu_mode_enable();
> arch/arm64/mm/pageattr.c:       lazy_mmu_mode_enable();
>
> arch/arm64/mm/mmu.c:    lazy_mmu_mode_disable();
> arch/arm64/mm/pageattr.c:       lazy_mmu_mode_disable();
>
>> A couple of notes regarding x86:
>>
>> * Xen is currently the only case where explicit handling is required
>>   for lazy MMU when context-switching. This is purely an
>>   implementation detail and using the generic lazy_mmu_mode_*
>>   functions would cause trouble when nesting support is introduced,
>>   because the generic functions must be called from the current task.
>>   For that reason we still use arch_leave() and arch_enter() there.
>>
>> * x86 calls arch_flush_lazy_mmu_mode() unconditionally in a few
>>   places, but only defines it if PARAVIRT_XXL is selected, and we
>>   are removing the fallback in <linux/pgtable.h>. Add a new fallback
>>   definition to <asm/pgtable.h> to keep things building.
>>
>> [...]

