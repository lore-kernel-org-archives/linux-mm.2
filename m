Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34525CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 10:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2A28E000F; Fri,  7 Nov 2025 05:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8824F8E0002; Fri,  7 Nov 2025 05:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7719B8E000F; Fri,  7 Nov 2025 05:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 660558E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:16:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEB891A03DD
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:16:33 +0000 (UTC)
X-FDA: 84083406666.11.D5C48A2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id A2C5640004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:16:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762510592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WiC9ywZ2pGQE+sxxwQfRLPFc3pThbZLAIj2W54RHOeo=;
	b=DBRaeCBVQ2XmEEy4/H1pof8AZUJ88gJhu9FKohfVh+5Ywh6erFcbIFvHgdDDm0O6OOEjgj
	KILaz2x1mgDJz0KSXdORbhUzE5GxbfCfguL1WdxLe2ZMJArl9oqgzI+QW0iP0NeZCk1bWY
	BkUZcugps87vLYMlZvAfrEa3KV/3S/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762510592; a=rsa-sha256;
	cv=none;
	b=u7c2vtcF+q9xze29IHZFDCrJs+TtewoOXnTzw3PGnT7kKDMTOcBlpq4ddqC7c+D3csWcrn
	1NN1qx/0mors7btFGWCnZR68LTj09EcvP0losyvo9JQJRc5I+zWkqL+W2z5tEElX+idEGW
	dPsPfou/0e5+WKeGFxjJ5LEAfQ8OPIs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B30531515;
	Fri,  7 Nov 2025 02:16:22 -0800 (PST)
Received: from [10.57.40.58] (unknown [10.57.40.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9F5E3F66E;
	Fri,  7 Nov 2025 02:16:17 -0800 (PST)
Message-ID: <9f749c3e-4f93-40c1-b5c6-74d2ead92d00@arm.com>
Date: Fri, 7 Nov 2025 10:16:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
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
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <87ms5050g0.ritesh.list@gmail.com>
 <50d1b63a-88d7-4484-82c0-3bde96e3207d-agordeev@linux.ibm.com>
 <48a4ecb5-3412-4d3f-9e43-535f8bee505f@arm.com>
 <d5435e75-036b-44a5-a989-722e13f94b3e-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <d5435e75-036b-44a5-a989-722e13f94b3e-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yn4k9y71cyadxhtam1h5b9ppwq5pajtt
X-Rspam-User: 
X-Rspamd-Queue-Id: A2C5640004
X-Rspamd-Server: rspam01
X-HE-Tag: 1762510591-128262
X-HE-Meta: U2FsdGVkX1/udkcLof65RzNcsMKbrtKyzr+y+04l7Exryr8vKxU73xoulFbyLHLGqSZYf2AP3izsnuVYfU7FX3x7YnN/5jef47t50lS0oSW6bEfUXTwL3TVILRYXgbmaidNhKT7cVGNslcP6RdRXZeFE52ci/TyScFIgadW4FmQ4PCCYTMoAYnafkUD0QhRAoCick/wJQHbcC8I/xgndYiMt6br+0eo/M7g9zGzIXvH/NY/XXaQ4QtBMb+VOjNqu6xFiSlWgDgm8geyqm/gMCDUE9giLP1U9aeQzrQCiTzgEobiIhtimzL4aJAZdVX3wHGl7tDyEUT4k95PLdTbqH/pRcOpk+Y3Fkwq3D+F9onincKDX227TN9wmLgQ79/VcB4Gok0W1EGuDWyrBuG/fo8Ho+qHwGgbcrNIQkwtjip5MEzUo84Fxxzdb1P1AFlv7rL/6sES34ULoJaH8CN7Hp/zFHphKbqDayRb89uPXZdwI4pMlU0JQR2thZ+7BtVGssjn4SKBQr9WT3uxdtGjqjlJq7T202b96t8ewlTWEHHQ/SwiRqQCoxxnsvEYQxNeMKrUW5fpwCpPo9eLKEjHoZG549NINm0i3sEnBcIjGymnQDtyagY/lPoKXG9X500EPX9fBxGf71m7X1ggunSSE9Zyx5PtSAQvTTNrM4a0qdvVRag/ok2lQbtRwqIRQWILysAr2stZYM0kyMUBOJu2PX6NrD5LMFZpJAM3K2GzfJTWg0jVHJ/SbFeVy5SzLbWU7fvKyFuqq1GXZbiU1oRWqf6wo42Q1SNL9MqutfnOYgXN15mFoeCXIBNiB0J1T7//2II915UpC+5yyg8Zn2DbgtqfrNH4TWwjXLlIQVsFBxpX9acrecYDIdq3m3Jiq+CY/u0kp8PUass/sVmaxkrnEOhH72sQERHNlo5q1vGwgzjdrW/5rhalDoRW2FApbhncpCMUk1mSTwocDldla25m
 qqMHyGMz
 pu8NEV93V4pAqpzhJcZo3yh/EWzn08CK57c7+lEVWTBmn86fsZ86Y+lUHMieW/5wKR0cTQkegKTji/fPYZGoD35l8hXdKeCVUZljx1FP78q66zvWeoy9ecZgi/oTeeSjoNcszC1W4Mf5J+pQ1qjpeVt0Q/tcVggE3YwogQnN2pOUNIg38TZv1fUjtUGBGg3RmRmGf5+DAda/KxvSMOkz2fOgA7UqZ2Eqho8Y09jGwqUqG/1PEMyHlvplwqwZCU9p/yRXrzoeJOGngtoFisIF/UJAZrhR03zop6RvtnapJa4z34sqd7xc1TaR/mAbTHy58Lybtb7716veuaUo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/11/2025 15:33, Alexander Gordeev wrote:
>> [...]
>>>>   static inline void lazy_mmu_mode_enable(void)
>>>>   {
>>>>  -	arch_enter_lazy_mmu_mode();
>>>>  +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>>  +
>>>>  +	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
>>>>  +	/* enable() must not be called while paused */
>>>>  +	VM_WARN_ON(state->nesting_level > 0 && !state->active);
>>>>  +
>>>>  +	if (state->nesting_level++ == 0) {
>>>>  +		arch_enter_lazy_mmu_mode();
>>>>  +		state->active = true;
>>>>  +	}
>>>>   }
>>>>
>>>> ... I think it make more sense to enable the state after the arch_**
>>>> call right.
>>> But then in_lazy_mmu_mode() would return false if called from
>>> arch_enter_lazy_mmu_mode(). Not big problem, but still..
>> The ordering of nesting_level/active was the way you expected in v3, but
>> the conclusion of the discussion with David H [1] is that it doesn't
>> really matter so I simplified the ordering in v4 - the arch hooks
>> shouldn't call in_lazy_mmu_mode() or inspect lazy_mmu_state.
>> arch_enter()/arch_leave() shouldn't need it anyway since they're called
>> once per outer section (not in nested sections). arch_flush() could
>> potentially do something different when nested, but that seems unlikely.
>>
>> - Kevin
>>
>> [1]
>> https://lore.kernel.org/all/af4414b6-617c-4dc8-bddc-3ea00d1f6f3b@redhat.com/
> I might be misunderstand this conversation, but it looked to me as a discussion
> about lazy_mmu_state::nesting_level value, not lazy_mmu_state::active.
>
> I do use in_lazy_mmu_mode() (lazy_mmu_state::active) check from the arch-
> callbacks. Here is the example (and likely the only case so far) where it hits:

Sorry I didn't mean arch callbacks in general, I meant the ones called
from lazy_mmu_mode_*, that is arch_*_lazy_mmu_mode.

Patch 8 also makes use of in_lazy_mmu_mode() in set_pte() et al. on arm64.

- Kevin

> static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
> 				      void *_data)
> {
> 	lazy_mmu_mode_pause();
> 	...
> 	if (likely(pte_none(ptep_get(ptep)))) {
>
> 		/* Here set_pte() checks whether we are in lazy_mmu mode */
> 		set_pte_at(&init_mm, addr, ptep, pte);	<--- calls set_pte()
> 		data->pages[index] = NULL;
> 	}
> 	...
> 	lazy_mmu_mode_resume();
> 	...
> }
>
> So without in_lazy_mmu_mode() check above the arch-specific set_pte()
> implementation enters a wrong branch, which ends up in:
>
> [  394.503134] Call Trace:
> [  394.503137]  [<00007fffe01333f4>] dump_stack_lvl+0xbc/0xf0 FWIW 
> [  394.503143]  [<00007fffe010298c>] vpanic+0x1cc/0x418 
> [  394.503149]  [<00007fffe0102c7a>] panic+0xa2/0xa8 
> [  394.503154]  [<00007fffe01e7a8a>] check_panic_on_warn+0x8a/0xb0 
> [  394.503160]  [<00007fffe082d122>] end_report+0x72/0x110 
> [  394.503166]  [<00007fffe082d3e6>] kasan_report+0xc6/0x100 
> [  394.503171]  [<00007fffe01b9556>] ipte_batch_ptep_get+0x146/0x150 
> [  394.503176]  [<00007fffe0830096>] kasan_populate_vmalloc_pte+0xe6/0x1e0 
> [  394.503183]  [<00007fffe0718050>] apply_to_pte_range+0x1a0/0x570 
> [  394.503189]  [<00007fffe07260fa>] __apply_to_page_range+0x3ca/0x8f0 
> [  394.503195]  [<00007fffe0726648>] apply_to_page_range+0x28/0x40 
> [  394.503201]  [<00007fffe082fe34>] __kasan_populate_vmalloc+0x324/0x340 
> [  394.503207]  [<00007fffe076954e>] alloc_vmap_area+0x31e/0xbf0 
> [  394.503213]  [<00007fffe0770106>] __get_vm_area_node+0x1a6/0x2d0 
> [  394.503218]  [<00007fffe07716fa>] __vmalloc_node_range_noprof+0xba/0x260 
> [  394.503224]  [<00007fffe0771970>] __vmalloc_node_noprof+0xd0/0x110 
> [  394.503229]  [<00007fffe0771a22>] vmalloc_noprof+0x32/0x40 
> [  394.503234]  [<00007fff604eaa42>] full_fit_alloc_test+0xb2/0x3e0 [test_vmalloc] 
> [  394.503241]  [<00007fff604eb478>] test_func+0x488/0x760 [test_vmalloc] 
> [  394.503247]  [<00007fffe025ad68>] kthread+0x368/0x630 
> [  394.503253]  [<00007fffe01391e0>] __ret_from_fork+0xd0/0x490 
> [  394.503259]  [<00007fffe24e468a>] ret_from_fork+0xa/0x30 
>
> I could have cached lazy_mmu_state::active as arch-specific data
> and check it, but then what is the point to have it generalized?
>
> Thanks!

