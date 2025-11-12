Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FFF2CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3F18E001C; Wed, 12 Nov 2025 05:43:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABB78E0002; Wed, 12 Nov 2025 05:43:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE93B8E001C; Wed, 12 Nov 2025 05:43:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C72898E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:43:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 663924CA2F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:43:10 +0000 (UTC)
X-FDA: 84101617740.09.C4A5088
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 34CAD100012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:43:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762944188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9CszuyZCpIAkXuMjAUxx68LzymHvfkndaeApzQvLhEA=;
	b=xHQddmUF0f8uS+ksbko8cIuSr3CxNwvVDVBHmfNSIWACsHj+G5DcOD+WUaOAxvvyieBYlr
	KjF9nbYYLLbNxpdkRONGouSK4IVX45DZMkFJS5XwH6xH/R51mQpUtxG+4aWTWUd3T9KkJp
	nLQ/J2BPocysK0Slxlk9HyIJVIENa3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762944188; a=rsa-sha256;
	cv=none;
	b=IDlZosozJQ4AzKdYRzzQKq1bKdYQpkNaCslQdlDGqkNVzBkkU5qBid4IqwgEBwxYj2P5CA
	2/mMQtpuahS5XOopSyG4SfW+AWzjWxHK86w23clHsw47r5/yluS/uQDY1iuPjY5XHq/e9p
	VxYyLoE4Alp1t+g4v6CHsNKTTrm1xGs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7755A1515;
	Wed, 12 Nov 2025 02:42:59 -0800 (PST)
Received: from [10.57.41.24] (unknown [10.57.41.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A008F3F5A1;
	Wed, 12 Nov 2025 02:43:00 -0800 (PST)
Message-ID: <cdb4b97a-415b-4dba-877b-0cd570381a6d@arm.com>
Date: Wed, 12 Nov 2025 11:42:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
 David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <999feffa-5d1d-42e3-bd3a-d949f2a9de9d@arm.com>
 <cc9dc398-b9c5-4bb8-94ad-7e7f3ddd5b4f@arm.com>
 <824bf705-e9d6-4eeb-9532-9059fa56427f@arm.com>
 <58fd1a6e-f2c4-421c-9b95-dea4b244a515@arm.com>
 <8f70692c-25a9-4bd0-94ab-43ab435e4b1b@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <8f70692c-25a9-4bd0-94ab-43ab435e4b1b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 34CAD100012
X-Stat-Signature: 5imyqwtmgd8t8jmrwazcgfigamefq74a
X-HE-Tag: 1762944188-437216
X-HE-Meta: U2FsdGVkX1+WvWCPD/5SvknTAUlbhocUk/3iTEgJuA5wU8ojmhvFsAheWRJHFIuHF4ZkQZmnskzcQZJJiq7eJ7zFFDeEZfhLWn4nYVuZbmcJTqBB5j6eoX/pQ8Z/mGzjsIAu8uiwj+IrVmy4jUI1iJ0fbNIJ9B226nOaL9eg4DQQpHZwFIomVyXJ+n2MD3v+qvOFjwNwmYi431U1IUxnYBYOPJlGSQbP/Jqcgzm1Txc9mEev4ZHvqKX8JmmLxmtzlLMpJrfOQcx2oKwYxeihT9sliGgNe2QTssfpPweT8xdehBdArQTdAwsUPuVgYQJnLZaaHE7KwGkfQJ72vx2Sd1NkWhWIkWQXO6jYWyBUQbP/89WCs3x6dP+i4KaLN0nwm/Wi/0fZHGAXkdJ0qYaKZDG4F6PEgyvZhJZY2fh8PlqvgnJ+vrEtc6omSWYmwy6YnhOKbmZRvO4O1e6dB67Tr6TomGoqYuT32zerRHDaGryxBCQe2i8w1uHdks4s11t563sP02RbbOb5NnTTjUuzJ4R+laj/0OtqxIP0a0C7+aZqLRZElosdHeIDr/h7yr31mpYukjn7nWEvD7zTO6aEsSSftf8vgA/xAnMrSI5Rz15GTk7pJNsnVepKeDlUytRdHrTORNqGWLHF+q0/kt6vetHJVSKeU0Rw7RPCbLEqLtwwnt/KmRlHiLny41v0viTjCHDJmhN1KxaVx2/5QBbZN7huG8Gdvaok9XLXbFExzlp9rYqPQfPLDTjIzdSiWFL38yDsaOq4R4XeSy66ei51CVEHZVbDAknEZ+mdmfwUT6Coz9df304yzQ/LOujp8n+fV352q4+gxb+bwvzXF5lZlbc7UfNOPwbpm9E9Stp/mGbRX31AMCBukyMev7nhXScSJ7EkvHNOPLHdmz1FXWMz+aijBk+flnOrbxLCeyH5GKGZzz6cjtyoNbFJy/qBqwqiXpprZf1tuNDV9iuP8eV
 +lRIoLLQ
 hPgMdV2hBjBd9dpkv5d6fxxXGS3dxxamH8Et7Ocp1/Aoop+aZN/Wst4CUHmVw2YpmFKeuzn4kNqOSGdq54xEfAT39PGDCEe/IPTqW83VTwTl2a7ICGOCwXlUbWDJKBc+QkXksUai7pAVRgCIiGSpeTdaQ9K48EpwS6JRoU4RBxV3gEItM+RuMytpJkUboUji44KRfUOCo63lH8/mQ4grXVHxtVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/2025 17:03, Ryan Roberts wrote:
> On 11/11/2025 15:56, Kevin Brodsky wrote:
>> On 11/11/2025 10:24, Ryan Roberts wrote:
>>> [...]
>>>
>>>>>> +		state->active = true;
>>>>>> +		arch_enter_lazy_mmu_mode();
>>>>>> +	}
>>>>>>  }
>>>>>>  
>>>>>>  static inline void lazy_mmu_mode_disable(void)
>>>>>>  {
>>>>>> -	arch_leave_lazy_mmu_mode();
>>>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>>>> +
>>>>>> +	VM_WARN_ON_ONCE(state->nesting_level == 0);
>>>>>> +	VM_WARN_ON(!state->active);
>>>>>> +
>>>>>> +	if (--state->nesting_level == 0) {
>>>>>> +		state->active = false;
>>>>>> +		arch_leave_lazy_mmu_mode();
>>>>>> +	} else {
>>>>>> +		/* Exiting a nested section */
>>>>>> +		arch_flush_lazy_mmu_mode();
>>>>>> +	}
>>>>>>  }
>>>>>>  
>>>>>>  static inline void lazy_mmu_mode_pause(void)
>>>>>>  {
>>>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>>>> +
>>>>>> +	VM_WARN_ON(state->nesting_level == 0 || !state->active);
>>>>> nit: do you need the first condition? I think when nesting_level==0, we expect
>>>>> to be !active?
>>>> I suppose this should never happen indeed - I was just being extra
>>>> defensive.
>>>>
>>>> Either way David suggested allowing pause()/resume() to be called
>>>> outside of any section so the next version will bail out on
>>>> nesting_level == 0.
>>> Ignoring my current opinion that we don't need pause/resume at all for now; Are
>>> you suggesting that pause/resume will be completely independent of
>>> enable/disable? I think that would be best. So enable/disable increment and
>>> decrement the nesting_level counter regardless of whether we are paused.
>>> nesting_level 0 => 1 enables if not paused. nesting_level 1 => 0 disables if not
>>> paused. pause disables nesting_level >= 1, resume enables if nesting_level >= 1.
>> This is something else. Currently the rules are:
>>
>> [A]
>>
>> // pausing forbidden
>> enable()
>>     pause()
>>     // pausing/enabling forbidden
>>     resume()
>> disable()
>>
>> David suggested allowing:
>>
>> [B]
>>
>> pause()
>> // pausing/enabling forbidden
>> resume()
>>
>> Your suggestion is also allowing:
>>
>> [C]
>>
>> pause()
>>     // pausing forbidden
>>     enable()
>>     disable()
>> resume()
> I think the current kasan kasan_depopulate_vmalloc_pte() path will require [C]
> if CONFIG_DEBUG_PAGEALLOC is enabled on arm64. It calls __free_page() while
> paused. I guess CONFIG_DEBUG_PAGEALLOC will cause __free_page() ->
> debug_pagealloc_unmap_pages() ->->-> update_range_prot() -> lazy_mmu_enable().

Well, I really should have tried booting with KASAN enabled before...
lazy_mmu_mode_enable() complains exactly as you predicted:

> [    1.047587] WARNING: CPU: 0 PID: 1 at include/linux/pgtable.h:273
> update_range_prot+0x2dc/0x50c
> [    1.048025] Modules linked in:
> [    1.048296] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted
> 6.18.0-rc3-00012-ga901e7f479f1 #142 PREEMPT
> [    1.048706] Hardware name: FVP Base RevC (DT)
> [    1.048941] pstate: 11400009 (nzcV daif +PAN -UAO -TCO +DIT -SSBS
> BTYPE=--)
> [    1.049309] pc : update_range_prot+0x2dc/0x50c
> [    1.049631] lr : update_range_prot+0x80/0x50c
> [    1.049950] sp : ffff8000800e6f20
> [    1.050162] x29: ffff8000800e6fb0 x28: ffff700010014000 x27:
> ffff700010016000
> [    1.050747] x26: 0000000000000000 x25: 0000000000000001 x24:
> 00000000008800f7
> [    1.051308] x23: 0000000000000000 x22: fff00008000f7000 x21:
> fff00008003009f8
> [    1.051884] x20: fff00008000f8000 x19: 1ffff0001001cdea x18:
> ffff800080769000
> [    1.052469] x17: ffff95c63264ec00 x16: ffff8000800e7504 x15:
> 0000000000000003
> [    1.053045] x14: ffff95c63482f000 x13: 0000000000000000 x12:
> ffff783ffc0007bf
> [    1.053620] x11: 1ffff83ffc0007be x10: ffff783ffc0007be x9 :
> dfff800000000000
> [    1.054203] x8 : fffd80010001f000 x7 : ffffffffffffffff x6 :
> 0000000000000001
> [    1.054776] x5 : 0000000000000000 x4 : fff00008003009f9 x3 :
> 1ffe00010006013f
> [    1.055348] x2 : fff0000800300000 x1 : 0000000000000001 x0 :
> 0000000000000000
> [    1.055912] Call trace:
> [    1.056100]  update_range_prot+0x2dc/0x50c (P)
> [    1.056478]  set_memory_valid+0x44/0x70
> [    1.056850]  __kernel_map_pages+0x68/0xe4
> [    1.057226]  __free_frozen_pages+0x528/0x1180
> [    1.057601]  ___free_pages+0x11c/0x160
> [    1.057961]  __free_pages+0x14/0x20
> [    1.058307]  kasan_depopulate_vmalloc_pte+0xd4/0x184
> [    1.058748]  __apply_to_page_range+0x678/0xda8
> [    1.059149]  apply_to_existing_page_range+0x14/0x20
> [    1.059553]  kasan_release_vmalloc+0x138/0x200
> [    1.059982]  purge_vmap_node+0x1b4/0x8a0
> [    1.060371]  __purge_vmap_area_lazy+0x4f8/0x870
> [    1.060779]  _vm_unmap_aliases+0x488/0x6ec
> [    1.061176]  vm_unmap_aliases+0x1c/0x34
> [    1.061567]  change_memory_common+0x17c/0x380
> [    1.061949]  set_memory_ro+0x18/0x24
> [...]


> Arguably you could move the resume() to before the __free_page(). But it just
> illustrates that it's all a bit brittle at the moment...

Difficult to disagree. With things like DEBUG_PAGEALLOC it becomes very
hard to know what is guaranteed not to use lazy MMU.

>>> Perhaps we also need nested pause/resume? Then you just end up with 2 counters;
>>> enable_count and pause_count. Sorry if this has already been discussed.
>> And finally:
>>
>> [D]
>>
>> pause()
>>     pause()
>>         enable()
>>         disable()
>>     resume()
>> resume()
>>
>> I don't really mind either way, but I don't see an immediate use for [C]
>> and [D] - the idea is that the paused section is short and controlled,
>> not made up of arbitrary calls. 
> If my thinking above is correct, then I've already demonstrated that this is not
> the case. So I'd be inclined to go with [D] on the basis that it is the most robust.
>
> Keeping 2 nesting counts (enable and pause) feels pretty elegant to me and gives
> the fewest opportunities for surprises.

Agreed, if we're going to allow enable() within a paused section, then
we might as well allow paused sections to nest too. The use-case is
clear, so I'm happy to go ahead and make those changes.

David, any thoughts?

- Kevin

>
> Thanks,
> Ryan
>
>> A potential downside of allowing [C] and
>> [D] is that it makes it harder to detect unintended nesting (fewer
>> VM_WARN assertions). Happy to implement it if this proves useful though.
>>
>> OTOH the idea behind [B] is that it allows the caller of
>> pause()/resume() not to care about whether lazy MMU is actually enabled
>> or not - i.e. the kasan helpers would keep working even if
>> apply_to_page_range() didn't use lazy MMU any more.
>>
>>>>>> +
>>>>>> +	state->active = false;
>>>>>>  	arch_leave_lazy_mmu_mode();
>>>>>>  }
>>>>>>  
>>>>>> [...]

