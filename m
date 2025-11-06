Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47ADCCCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63FC8E0014; Thu,  6 Nov 2025 05:51:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A420B8E0002; Thu,  6 Nov 2025 05:51:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978A38E0014; Thu,  6 Nov 2025 05:51:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83FA88E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:51:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B8C4140647
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:51:56 +0000 (UTC)
X-FDA: 84079867032.28.6517157
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id F2D0720005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:51:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762426314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9BUIVBWzSEg5HnaNi8EEWsgRtlWmX6rseREfNx4QEYE=;
	b=jVxIdO9yJ2MzCnCpgKxSIMrsbOR0BH2YMHWUBnHdPSLuaX37VaoriSxuDW5gXGOV5fqc2C
	kx0sihWAsM2e45PMycPRVUFzNaiZGS9BAFjrjWlkk5YFaqP8QWd47QlitBnbX0O4cGBNqK
	7c30glAjax0GMWXdeNTqPNHKUBO4g9w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762426314; a=rsa-sha256;
	cv=none;
	b=tdPThe8fPdJl8mvj8sWHYAihV3tOa+1YmfSVib+lDwP3vGmvRDJr8Sd617MxY35RkWggoT
	WjGwBZQcxcph8Z3S1WMvDCHCqAaVhBCHTsr7lO2/DoJUg9AYa7DdtabTIjZcm2nnmGuwSP
	vKAaOslowv8zhrGF/xz6qy1InwwkO6I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20A081596;
	Thu,  6 Nov 2025 02:51:45 -0800 (PST)
Received: from [10.1.34.75] (unknown [10.1.34.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6866A3F63F;
	Thu,  6 Nov 2025 02:51:46 -0800 (PST)
Message-ID: <48a4ecb5-3412-4d3f-9e43-535f8bee505f@arm.com>
Date: Thu, 6 Nov 2025 10:51:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Ritesh Harjani <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <87ms5050g0.ritesh.list@gmail.com>
 <50d1b63a-88d7-4484-82c0-3bde96e3207d-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <50d1b63a-88d7-4484-82c0-3bde96e3207d-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2D0720005
X-Stat-Signature: q8k5u8e3sq3mrmjp7e8e6bpazeqmkujs
X-Rspam-User: 
X-HE-Tag: 1762426313-28509
X-HE-Meta: U2FsdGVkX18sK9PRaXFsabTPcbY8iT5h1riaGzqCysquSH6V4oxXr/3nP+osspLl011G7M9QcOXUS9VD9aam1R58JkmNMDR+Ne5JRzWi3rU1zg19veZagCAOHMOiymT04oK5hSWTRwXFVhrgTzEKB7dZVXkWD3zqcsedygfezwQxqnlnPDqITawOT7mR5mD+WnsXwN8NJlz6QM7FeBczUXQeQftbPZCqqiro78O5vl5yEOCMU040FeMnLdy1m/GGxsstbecPh0ZXsHAhiQqNkUERWxw2W9nzhazq8+rogAevKNqek48ou38ZHazMHBQvEwgt3AqAg8jw22EgJY8KsXesbN3pAorbXj3CXlDgehCK32l1pWkfNXHiCgY4cqic4EpY7kwSkwx/cCbi2ELst8BndClig10MkjFVY7Ys++HGfxJ1B/rGrh5G4ZXicnVJVDMzn6MoeDAVDHN71K3gluSf1BwcobXmM/gEtch3PJwN/rcv/Ud7tE7oxTEjOs90ioMCsvoezMHMgvGRGX/Hx+th1Hp/cqYF2f7yAPjgceUiazl4wI9vxkr3whqW2PPVuhcJec8OUd+edtUVtIpLI6JQApdEet9gWk0QGV9kFkt9DVrjrMYln8UqyYX6aSiaF77CgMywD+1YFtJwMFG9i7qpJwX7TkEzRYOsuErdmXmzpdj9DejSR5GX+v+GqEnRsLIBZERE2x6eoYQIWAz1kvbMzZ4PdUBO5f+MaI5bdGnIjRR6T195kDKInDfP9pLBKXENuPWvO2fAoEa0sU1a8K7GQMHCJpzMgkVsx30JG3KFDlBifSRIyM7MzmHoQ0sHZhv+M7ZOcaQk+OBigNBPh080bgq50uGk5U29S7lxliq/YNiJKWE2bFFBLHUMFP+kfgT4vmQJ8Th25ktwv2tJStUThgzpcZVVIc3+GukqAOEfhkrObuySv5yTkYYAsrRyEwTN5hoYQkFaSnFwMjo
 Ov/fvycs
 2kX1HL0x7H/0n8CIhqUUAxNMqxVo6PSagNtOdj2UTyNpyis8mXmpF0l/kigPhS8Ixa77bz3nS2EDIr8PAY6wGeQofAViMGRQjvkB5YAbaBBfCKF5GTeOBYsEBjonEbX4fbPqywWZgcIWfGwt6aVfw/7bV85SwIaWKP6xhz3CLiHNhhuZKGnwGzbcwJUiP2D+yxuCf1IURdObxlVLpPl1eoKhjzgTbViqEy9EeufNfiCBEudFhUW84SVvRVhJ/fxRGWvIPMt2gT4PgDATsgg2vgN9FCpBIzOmBjiHYMIpYOhBBwNEINf2zOvoLjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/11/2025 16:12, Alexander Gordeev wrote:
> On Wed, Nov 05, 2025 at 02:19:03PM +0530, Ritesh Harjani wrote:
>>> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>>> + * currently enabled.
>>>   */
>>>  #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>>>  static inline void lazy_mmu_mode_enable(void)
>>>  {
>>> -	arch_enter_lazy_mmu_mode();
>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>> +
>>> +	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
>>> +	/* enable() must not be called while paused */
>>> +	VM_WARN_ON(state->nesting_level > 0 && !state->active);
>>> +
>>> +	if (state->nesting_level++ == 0) {
>>> +		state->active = true;
>>> +		arch_enter_lazy_mmu_mode();
>>> +	}
>>>  }
>> Some architectures disables preemption in their
>> arch_enter_lazy_mmu_mode(). So shouldn't the state->active = true should
>> happen after arch_enter_lazy_mmu_mode() has disabled preemption()? i.e.
> Do you have some scenario in mind that could cause an issue?
> IOW, what could go wrong if the process is scheduled to another
> CPU before preempt_disable() is called?

I'm not sure I understand the issue either.

>>   static inline void lazy_mmu_mode_enable(void)
>>   {
>>  -	arch_enter_lazy_mmu_mode();
>>  +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>  +
>>  +	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
>>  +	/* enable() must not be called while paused */
>>  +	VM_WARN_ON(state->nesting_level > 0 && !state->active);
>>  +
>>  +	if (state->nesting_level++ == 0) {
>>  +		arch_enter_lazy_mmu_mode();
>>  +		state->active = true;
>>  +	}
>>   }
>>
>> ... I think it make more sense to enable the state after the arch_**
>> call right.
> But then in_lazy_mmu_mode() would return false if called from
> arch_enter_lazy_mmu_mode(). Not big problem, but still..

The ordering of nesting_level/active was the way you expected in v3, but
the conclusion of the discussion with David H [1] is that it doesn't
really matter so I simplified the ordering in v4 - the arch hooks
shouldn't call in_lazy_mmu_mode() or inspect lazy_mmu_state.
arch_enter()/arch_leave() shouldn't need it anyway since they're called
once per outer section (not in nested sections). arch_flush() could
potentially do something different when nested, but that seems unlikely.

- Kevin

[1]
https://lore.kernel.org/all/af4414b6-617c-4dc8-bddc-3ea00d1f6f3b@redhat.com/


