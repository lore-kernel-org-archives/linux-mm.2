Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0F3CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2498E000A; Wed, 17 Sep 2025 15:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3128E0068; Wed, 17 Sep 2025 15:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DC68E000A; Wed, 17 Sep 2025 15:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED5508E000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:40:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 698A11A0670
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:40:49 +0000 (UTC)
X-FDA: 83899759818.28.0FC6A9E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F84C140012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:40:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758138047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J0hPBJsMDSHhtjWW6Qz6GlIph0BIhPgebyqCeNJNb4o=;
	b=pvK+60175swoCzXOriYEhiMLdtVlr8ypZXxVozb/ukFXq16vXOpddKtclLu5owONZG9XTT
	D2xewAKqfUnbpU5fQFCZlOXTzs5I7/sH5cYbHnWIgpgWwQcTtsogvcUKGI6nFQbpJako5b
	6BWhmfMLvanQl1Xnw19RUY4nhlocLQA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758138047; a=rsa-sha256;
	cv=none;
	b=IodXabWY3wZLvwZGpCdwPc5VHkhXBUTUL0NQzZPPNqQlJW+wvExG7yCQWRqTIB8EQ4RJ2q
	JFjUhRNLcEHX6gz4I7t6UDBcZhElHQUixIEzpmyZ2cH/CwEc0vJ9rYjtcmKC0g5QGd0K5/
	mDS0jeua/lPitxxwIfv9G2EDSiQD3d8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 803762696;
	Wed, 17 Sep 2025 12:40:38 -0700 (PDT)
Received: from [10.57.80.26] (unknown [10.57.80.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F053F3F694;
	Wed, 17 Sep 2025 12:40:44 -0700 (PDT)
Message-ID: <3cbda17c-4c1c-4c04-a1fe-bd6ea6714de8@arm.com>
Date: Wed, 17 Sep 2025 20:40:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
 <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
 <bf1aa0a4-08de-443f-a1a3-aa6c05bab38c@os.amperecomputing.com>
 <39c2f841-9043-448d-b644-ac96612d520a@os.amperecomputing.com>
 <d7cd4004-bacf-47b0-9cd8-f99125e02238@arm.com>
 <fe52a1d8-5211-4962-afc8-c3f9caf64119@os.amperecomputing.com>
 <8c363997-7b8d-4b54-b9b0-1a1b6a0e58ed@arm.com>
 <4aa4eedc-550f-4538-a499-504dc925ffc2@os.amperecomputing.com>
 <1cfda234-1339-4d83-bd87-b219fbd72664@arm.com>
 <55a79826-48e3-41c0-8dbd-b6398e7e49a6@os.amperecomputing.com>
 <92719b15-daf8-484f-b0db-72e23ae696ad@os.amperecomputing.com>
 <e86e2aa5-c66c-41a9-a56d-74451df0d105@arm.com>
 <f8898c87-8f49-4ef2-86ae-b60bcf67658c@os.amperecomputing.com>
 <047c0f7b-e46d-4a3f-8bc0-ce007eac36a7@arm.com>
 <45dc2746-153a-482d-954f-11fe1cd8d18e@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <45dc2746-153a-482d-954f-11fe1cd8d18e@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6j8b3e8gemqngehmjgyoag8th4w5a9ox
X-Rspamd-Queue-Id: 9F84C140012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758138047-629653
X-HE-Meta: U2FsdGVkX18R9kVD+ZxIw0RbMvsnnNkSJd+RNUiLjc1wOaLs7V3vSrnwkDMPTqbHf77SQVdX5xiFy9h51xSraM9gtyRTIBlUfUXrBqUr9TDfgDO23IKgqcirlJ5WLh2cJNLwTVKoYHLyDHficKzxUe9BQXbeVmwdv/pFSnNvyVCbiD6lM2WTsDcS+XvBSuLrLhxMYZ+8+fwn78F887K22+WRoYpiSrZZMX3GrRAWIBfrhwifJ2rDZLNUfaoMYck1ePg0Ce42J3aFpW2TngoUItdxYRACMnfAu437s4a5hgp3htFl8x0e2ZAzX3yQD+l5trhU4Oj6Z2+XRnOoxskzHRDB+57V7RCHdga01P/T8sj7zV72vWuZ0RQknFMlWrrQpyhjAT3MVCM83non36FlCCC3/UzGAhVT8D/OPbdxVtlVZWbSu2/tFhJSQUArOzfIn/8KPxg2Doqu8323lY4YCHG+fWU/9PwajR3apXZZVlZ8G0sGgQjVVbhRyuOzgrX6dXniANij0czdHjJ+kIvPj5Qj8USv4KfNvEs4NtzGYNQCMie5+BJ14FVUSql1SxyZWppE/isPMl2f+4iL76nwou5oqerkg+oSICS/w2prnxVPR5l/hd20wnz2WfjtheBu3HhFBy0Kkz/v8KpIDSXQFsz/fODv8jkUcY7O3tszSaqNi7od1drhZHf6G0a3ZRaOlpmKLE5QVsC7Xm1V1eLhVqbN+JWfrsalDMcKbatPgCKyudvXEcm2vBBIde05OUiREVp2uuZg6HJ5lEklC5PYcfhtcm34fxl3Ew3CD7aMQI4iKZQQ0/dTYNRLJUSMeek7XRpiNgxrmTMycQ4MBZieTMvX56YNGhIPfoM09WkQWL3Pe6/lxqNhUFKfpw9fgPxyfCP9ZY9e4waBUpilRwMag90QxSr9GzRYsayaDFrSfEJKsJUvDhxsuqEbRdp9LA0yRfaMSoVrOk8NOP3IRn1
 chU8gs/v
 mepgj9AYrbMH1eaWDvv7oFNdogMeRFI8oQeky43p4qfi0q2XKhYaej4GCu40YWuqftNP/GqeZTnrBhsfb230Lbpjc8GsaVxSxurpbAakq4cCkHDXVfIh3DLvjwu8r8P4MTbksrTtq1vqMGRAt25ucz7CfcfCNOiEnajjdQVmIP+3VdLeyWW0IL0MifzxNCJCZlZLbXxgk07NYTN4D425AUo/gWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/09/2025 20:15, Yang Shi wrote:
> 
> 
> On 9/17/25 11:58 AM, Ryan Roberts wrote:
>> On 17/09/2025 18:21, Yang Shi wrote:
>>>
>>> On 9/17/25 9:28 AM, Ryan Roberts wrote:
>>>> Hi Yang,
>>>>
>>>> Sorry for the slow reply; I'm just getting back to this...
>>>>
>>>> On 11/09/2025 23:03, Yang Shi wrote:
>>>>> Hi Ryan & Catalin,
>>>>>
>>>>> Any more concerns about this?
>>>> I've been trying to convince myself that your assertion that all users that set
>>>> the VM_FLUSH_RESET_PERMS also call set_memory_*() for the entire range that was
>>>> returned my vmalloc. I agree that if that is the contract and everyone is
>>>> following it, then there is no problem here.
>>>>
>>>> But I haven't been able to convince myself...
>>>>
>>>> Some examples (these might intersect with examples you previously raised):
>>>>
>>>> 1. bpf_dispatcher_change_prog() -> bpf_jit_alloc_exec() -> execmem_alloc() ->
>>>> sets VM_FLUSH_RESET_PERMS. But I don't see it calling set_memory_*() for
>>>> rw_image.
>>> Yes, it doesn't call set_memory_*(). I spotted this in the earlier email. But it
>>> is actually RW, so it should be ok to miss the call. The later
>>> set_direct_map_invalid call in vfree() may fail, but set_direct_map_default call
>>> will set RW permission back. But I think it doesn't have to use execmem_alloc(),
>>> the plain vmalloc() should be good enough.
>>>
>>>> 2. module_memory_alloc() -> execmem_alloc_rw() -> execmem_alloc() -> sets
>>>> VM_FLUSH_RESET_PERMS (note that execmem_force_rw() is nop for arm64).
>>>> set_memory_*() is not called until much later on in module_set_memory().
>>>> Another
>>>> error in the meantime could cause the memory to be vfreed before that point.
>>> IIUC, execmem_alloc_rw() is used to allocate memory for modules' text section
>>> and data section. The code will set mod->mem[type].is_rox according to the type
>>> of the section. It is true for text, false for data. Then set_memory_rox() will
>>> be called later if it is true *after* insns are copied to the memory. So it is
>>> still RW before that point.
>>>
>>>> 3. When set_vm_flush_reset_perms() is set for the range, it is called before
>>>> set_memory_*() which might then fail to split prior to vfree.
>>> Yes, all call sites check the return value and bail out if set_memory_*() failed
>>> if I don't miss anything.
>>>
>>>> But I guess as long as set_memory_*() is never successfully called for a
>>>> *sub-range* of the vmalloc'ed region, then for all of the above issues, the
>>>> memory must still be RW at vfree-time, so this issue should be benign... I
>>>> think?
>>> Yes, it is true.
>> So to summarise, all freshly vmalloc'ed memory starts as RW. set_memory_*() may
>> only be called if VM_FLUSH_RESET_PERMS has already been set. If set_memory_*()
>> is called at all, the first call MUST be for the whole range.
> 
> Whether the default permission is RW or not depends on the type passed in by
> execmem_alloc(). It is defined by execmem_info in arch/arm64/mm/init.c. For
> ARM64, module and BPF have PAGE_KERNEL permission (RW) by default, but kprobes
> is PAGE_KERNEL_ROX (ROX).

Perhaps I missed it, but as far as I could tell the prot that the arch sets for
the type only determines the prot that is set for the vmalloc map. It doesn't
look like the linear map is modified at all... which feels like a bug to me
since the linear map will be RW while the vmalloc map will be ROX... I guess I
must have missed something...

> 
>> If those requirements are all met, then if VM_FLUSH_RESET_PERMS was set but
>> set_memory_*() was never called, the worst that can happen is for both the
>> set_direct_map_invalid() and set_direct_map_default() calls to fail due to not
>> enough memory. But that is safe because the memory was always RW. If
>> set_memory_*() was called for the whole range and failed, it's the same as if it
>> was never called. If it was called for the whole range and succeeded, then the
>> split must have happened already and set_direct_map_invalid() and
>> set_direct_map_default() will therefore definitely succeed.
>>
>> The only way this could be a problem is if someone vmallocs a range then
>> performs a set_memory_*() on a sub-region without having first done it for the
>> whole region. But we have not found any evidence that there are any users that
>> do that.
> 
> Yes, exactly.
> 
>>
>> In fact, by that logic, I think alloc_insn_page() must also be safe; it only
>> allocates 1 page, so if set_memory_*() is subsequently called for it, it must by
>> definition be covering the whole allocation; 1 page is the smallest amount that
>> can be protected.
> 
> Yes, but kprobes default permission is ROX.
> 
>>
>> So I agree we are safe.
>>
>>
>>>> In summary this all looks horribly fragile. But I *think* it works. It would be
>>>> good to clean it all up and have some clearly documented rules regardless.
>>>> But I
>>>> think that could be a follow up series.
>>> Yeah, absolutely agreed.
>>>
>>>>> Shall we move forward with v8?
>>>> Yes; Do you wnat me to post that or would you prefer to do it? I'm happy to do
>>>> it; there are a few other tidy ups in pageattr.c I want to make which I
>>>> spotted.
>>> I actually just had v8 ready in my tree. I removed pageattr_pgd_entry and
>>> pageattr_pud_entry in pageattr.c and fixed pmd_leaf/pud_leaf as you suggested.
>>> Is it the cleanup you are supposed to do?
>> I was also going to fix up the comment in change_memory_common() which is now
>> stale.
> 
> Oops, I missed that in my v8. Please just comment for v8, I can fix it up later.

Ahh no biggy. If there is a chance Will will take the series, let's not hold it
up for a comment.

> 
> Thanks,
> Yang
> 
> 
>>
>>> And I also rebased it on top of
>>> Shijie's series (https://git.kernel.org/pub/scm/linux/kernel/git/arm64/
>>> linux.git/commit/?id=bfbbb0d3215f) which has been picked up by Will.
>>>
>>>>> We can include the
>>>>> fix to kprobes in v8 or I can send it separately, either is fine to me.
>>>> Post it on list, and I'll also incorporate into the series.
>>> I can include it in v8 series.
>>>
>>>>> Hopefully we can make v6.18.
>>>> It's probably getting a bit late now. Anyway, I'll aim to get v8 out
>>>> tomorrow or
>>>> Friday and we will see what Will thinks.
>>> Thank you. I can post v8 today.
>> OK great - I'll leave it all to you then - thanks!
>>
>>> Thanks,
>>> Yang
>>>
>>>> Thanks,
>>>> Ryan
>>>>
>>>>> Thanks,
>>>>> Yang
>>>>>
> 


