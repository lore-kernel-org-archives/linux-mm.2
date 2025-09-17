Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399EFCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6171E280010; Wed, 17 Sep 2025 14:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF01280002; Wed, 17 Sep 2025 14:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C28280010; Wed, 17 Sep 2025 14:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA59280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:58:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2750BA7C6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:58:54 +0000 (UTC)
X-FDA: 83899654188.26.0DC3A6D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7C4571C0010
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:58:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758135533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fe6MMyezrpEMFfpdK9szCBHQyXGkvJKTY5DNaPLALKM=;
	b=I5oAIRhmCCe1vOKQ+y6OcYuSAv/J35pPQVzfFhK8iY1NnQCUyqWXZVKo2tYpPDTADZEuba
	RO8N6+NRjD0BShxcmi1SuE+qIDjUBXO1Mdc6mr0LjFGj+H968ZOodlxMhLnzgYATNgzD8a
	agKTooq19ZON98bdtj/pBzp7fFxTrwI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758135533; a=rsa-sha256;
	cv=none;
	b=VzAcPhScFyRDBeq7HN02kR+2X9JaQtrqS04LGq0bmPD1CKU59NtjJBf/EaoLeclCwIDhdz
	FU/MEr/M4zBfKFkTUgd5SHos7/RZNqz/IQswONoUZUKrB4tmvD9Po1zAk7eB+jHLrZAlTq
	XvpTLuu6IWkhV403jZaRN7LPXtNm0tw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 285D52696;
	Wed, 17 Sep 2025 11:58:43 -0700 (PDT)
Received: from [10.57.80.26] (unknown [10.57.80.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ECE13F694;
	Wed, 17 Sep 2025 11:58:49 -0700 (PDT)
Message-ID: <047c0f7b-e46d-4a3f-8bc0-ce007eac36a7@arm.com>
Date: Wed, 17 Sep 2025 19:58:48 +0100
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
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
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
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <f8898c87-8f49-4ef2-86ae-b60bcf67658c@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C4571C0010
X-Stat-Signature: na6zjowrw9upx3571zg11m9bufz89896
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758135532-884795
X-HE-Meta: U2FsdGVkX19HDQMdzyb/53Zy0uBJebK8GGDWWWU6297h2XrmBjtQ3/KnqJ2ZtaU2b4fCRFKlQDznJlW7vJRIwSzFLvrX3R493IPFDLZCmRSSlxOWHHT1L2vGxRooItE6JsVF8Ol/4AyfzxXwsqJE0LkIUPMMULxX6PHJiHTEeZZYX7a6ZHocq+XkBKOVnyPbGROW4j4i7d03nvaxwWf3tvw18rJMb0xFMapmWhe6GwWQulgaDm1cJfEx3Gkts3k7rJCbSXaKErugoKLdeTYUohNA9w7Qb7NSibN3soInPdgFfABAJANrHdEv5IeHHZFSg5gMOjMyOHx91L0IV24t/q19jtjVEcBuXTMt61paE6NQsmkEChWH8MjGMXj1cmmhhtefSep+X4PlJ4cdmah1uK4uj8nuYoQgyE6MJuSCMgMLPA6WTKzfip2k2RN308T9w9I68/cAJG6Jlxe27vrRi09ntXSG+A0gt9pVrsw93t7KrJvZgcTimZw1h7W+B0q+txWQzMeCBK9f4WLODaRoppa/eOx1vLfpNWab0OmsbOpVGUCrUxTVG/XK1teywmdn9TSmA2nm2JMbL4wNip0NY0LtcZPtNG8bnmM/yX3ztDBGvpDSJNkLHRW5KW4F21aBnggFKGGDoC4ZH4heoMX8L6vuUKr22JJZkZBplR+s7ekkajLlGuEzcIw7yB+4k2eeTsh4Q9GNnws/uNniDtqn7R7fN3ipnrnqiyYMN6mJg5NVQYj29geS9CiXdkgE05SWKnS4LMeVJiSWA7U9aoe5BmWlmcnBLNzkLwLz5r5Iv6Dl1/8y328/SlNXi2qhyde8rduOxEcQ8ojRTqkhYAeTzu/45Hs95rcnBd2NjPkTqH2CvQNoir//TEqT2B8w47F+OwA8gB5rIx4wXyj68hNCel6ZF/nfRRqFt4BC1/Y8PbS2+vqBea43jlEB8VSJObJMySsCykHDdnOZ9hzCn4+
 m1eVGaH9
 ChQCp5ETfg7Vn69WRVozVeK5yJ9sAQ4qeQNYsgs9uo5dc+3k00XEge7lTvD7DWr4lo9NnNXTx0de0TlWqBVlCp229XT9xzn15lle05nZhWMKhzi0Gsnk81z4yEqBD3eCEWb5xGdnuzt9P72AxE7c49YOcBfTaQkqonI94GNPmjsw6kXlDBoUtW0DJy2OwhnQ7Q3roYG57L/k1PwoRLaxMZvCWvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/09/2025 18:21, Yang Shi wrote:
> 
> 
> On 9/17/25 9:28 AM, Ryan Roberts wrote:
>> Hi Yang,
>>
>> Sorry for the slow reply; I'm just getting back to this...
>>
>> On 11/09/2025 23:03, Yang Shi wrote:
>>> Hi Ryan & Catalin,
>>>
>>> Any more concerns about this?
>> I've been trying to convince myself that your assertion that all users that set
>> the VM_FLUSH_RESET_PERMS also call set_memory_*() for the entire range that was
>> returned my vmalloc. I agree that if that is the contract and everyone is
>> following it, then there is no problem here.
>>
>> But I haven't been able to convince myself...
>>
>> Some examples (these might intersect with examples you previously raised):
>>
>> 1. bpf_dispatcher_change_prog() -> bpf_jit_alloc_exec() -> execmem_alloc() ->
>> sets VM_FLUSH_RESET_PERMS. But I don't see it calling set_memory_*() for
>> rw_image.
> 
> Yes, it doesn't call set_memory_*(). I spotted this in the earlier email. But it
> is actually RW, so it should be ok to miss the call. The later
> set_direct_map_invalid call in vfree() may fail, but set_direct_map_default call
> will set RW permission back. But I think it doesn't have to use execmem_alloc(),
> the plain vmalloc() should be good enough.
> 
>>
>> 2. module_memory_alloc() -> execmem_alloc_rw() -> execmem_alloc() -> sets
>> VM_FLUSH_RESET_PERMS (note that execmem_force_rw() is nop for arm64).
>> set_memory_*() is not called until much later on in module_set_memory(). Another
>> error in the meantime could cause the memory to be vfreed before that point.
> 
> IIUC, execmem_alloc_rw() is used to allocate memory for modules' text section
> and data section. The code will set mod->mem[type].is_rox according to the type
> of the section. It is true for text, false for data. Then set_memory_rox() will
> be called later if it is true *after* insns are copied to the memory. So it is
> still RW before that point.
> 
>>
>> 3. When set_vm_flush_reset_perms() is set for the range, it is called before
>> set_memory_*() which might then fail to split prior to vfree.
> 
> Yes, all call sites check the return value and bail out if set_memory_*() failed
> if I don't miss anything.
> 
>>
>> But I guess as long as set_memory_*() is never successfully called for a
>> *sub-range* of the vmalloc'ed region, then for all of the above issues, the
>> memory must still be RW at vfree-time, so this issue should be benign... I think?
> 
> Yes, it is true.

So to summarise, all freshly vmalloc'ed memory starts as RW. set_memory_*() may
only be called if VM_FLUSH_RESET_PERMS has already been set. If set_memory_*()
is called at all, the first call MUST be for the whole range.

If those requirements are all met, then if VM_FLUSH_RESET_PERMS was set but
set_memory_*() was never called, the worst that can happen is for both the
set_direct_map_invalid() and set_direct_map_default() calls to fail due to not
enough memory. But that is safe because the memory was always RW. If
set_memory_*() was called for the whole range and failed, it's the same as if it
was never called. If it was called for the whole range and succeeded, then the
split must have happened already and set_direct_map_invalid() and
set_direct_map_default() will therefore definitely succeed.

The only way this could be a problem is if someone vmallocs a range then
performs a set_memory_*() on a sub-region without having first done it for the
whole region. But we have not found any evidence that there are any users that
do that.

In fact, by that logic, I think alloc_insn_page() must also be safe; it only
allocates 1 page, so if set_memory_*() is subsequently called for it, it must by
definition be covering the whole allocation; 1 page is the smallest amount that
can be protected.

So I agree we are safe.


> 
>>
>> In summary this all looks horribly fragile. But I *think* it works. It would be
>> good to clean it all up and have some clearly documented rules regardless. But I
>> think that could be a follow up series.
> 
> Yeah, absolutely agreed.
> 
>>
>>> Shall we move forward with v8?
>> Yes; Do you wnat me to post that or would you prefer to do it? I'm happy to do
>> it; there are a few other tidy ups in pageattr.c I want to make which I spotted.
> 
> I actually just had v8 ready in my tree. I removed pageattr_pgd_entry and
> pageattr_pud_entry in pageattr.c and fixed pmd_leaf/pud_leaf as you suggested.
> Is it the cleanup you are supposed to do? 

I was also going to fix up the comment in change_memory_common() which is now stale.

> And I also rebased it on top of
> Shijie's series (https://git.kernel.org/pub/scm/linux/kernel/git/arm64/
> linux.git/commit/?id=bfbbb0d3215f) which has been picked up by Will.
> 
>>
>>> We can include the
>>> fix to kprobes in v8 or I can send it separately, either is fine to me.
>> Post it on list, and I'll also incorporate into the series.
> 
> I can include it in v8 series.
> 
>>
>>> Hopefully we can make v6.18.
>> It's probably getting a bit late now. Anyway, I'll aim to get v8 out tomorrow or
>> Friday and we will see what Will thinks.
> 
> Thank you. I can post v8 today.

OK great - I'll leave it all to you then - thanks!

> 
> Thanks,
> Yang
> 
>>
>> Thanks,
>> Ryan
>>
>>> Thanks,
>>> Yang
>>>
> 


