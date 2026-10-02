Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6ABCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 10:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A286B00A1; Fri,  2 Oct 2026 06:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542FC6B00A5; Fri,  2 Oct 2026 06:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4312C6B00AA; Fri,  2 Oct 2026 06:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0CCA6B00A1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 06:02:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8234CA7618
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:02:26 +0000 (UTC)
X-FDA: 85277246292.03.EB48A64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 97BD7C000D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:02:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ecu3Fk6+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CRmv+Y72dCsjIW8cbfqo0pAeQe5Fj28kqP9pHRvXyY=;
	b=f1dnZCi1aBn5np/7f6Ii7+ZBfWkb4k6gft2I2flIxDhhy77Fiq0mnPslfGMsPlTuB0gl98
	R8LUw6IPJAVP5RGPVDnZCn2En+7adEFdsZHQybqd/fOhcuv/uW4PfSwRuTLoA+RD3MCUMv
	4B3HkKqURc6cCfEFOrXMa6JL4qviKuQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ecu3Fk6+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935344;
	b=OInnPiNNd20UfY+2Euyh4iH/xEr+F2RpnK4xbDnJfawT/WwKYkqqb8thmUSLbm4OchDTIj
	8Eul0tm0LrHrHl5NT8XKtejQ5bOuyfCWZQhm+3aNxB3JTiIeiQeYPtfCDnoCXMOcdmf1aA
	XyPwK56HcjvDdX4M2qXOS2as0kApQQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FE8D40771;
	Fri,  2 Oct 2026 10:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881761F000FF;
	Fri,  2 Oct 2026 10:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790935343;
	bh=2CRmv+Y72dCsjIW8cbfqo0pAeQe5Fj28kqP9pHRvXyY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ecu3Fk6+BBTt28XCj/0byPzPkF3oH2shcUtw4oGlJngrRwn1Kj8+1wkGu9qx2r/Dm
	 EqZ7Ms6pF87RRV7v8j7pImt2PTOzQt9j2kIo7RHaXDzq8rDlmqAB9qpi2rb3C/4qCn
	 Pb8wbIDWzOymVkDaUEBUeKNjSJICBfmbIb/dGwBOSluCbLl27Tb8HIyHSCKTSYfmjC
	 CkUyGNTvklmlPMrIsljFGeMQko9k9oWWc1U+ky3Y6tzCPJ9BgT4oB1llYYNFFl/evs
	 2piDM0acF9bX0KpAjim+Cwelo79TjED+uOqgLLoTD7OvYLMKK8QiZ4vhQ6gwsM5SbX
	 r5GMYWudfthVQ==
Message-ID: <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
Date: Fri, 2 Oct 2026 12:02:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
 <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org> <ar9omYD3HcTDBpGA@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar9omYD3HcTDBpGA@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bwijumnjg5ayj13dyjz5mjsuq9hh1ifs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97BD7C000D
X-HE-Tag: 1790935344-250244
X-HE-Meta: U2FsdGVkX1/JnnXgRwHwdr4r3OJFf6U/B5I/9PMpX58izczuBqXw7Qws79RmtuS2Al10A/UZhKSmSbKlUYB/x5RAQvLLpCkYnzqR+IPV4Jao8LBXByh4xUTQVyJTcfft+52kRzOumZ0WkJaKB4Os+ILJ/ua2JqglXKWrzgUoy9JzHlgB9eXEh3khxoUFiiRhyPtws1YDXinwS/Ybosgh04E2v71Wwz6Fv+rvnWHVSSEfnZlU04uTyiXozbAPX9m4ZNbfg/kO2mByuGjQMOHVLfLQfhbEPaOJP1rIvugiKiXop48rzUoCvJTe8bdgSyP7um7CtOGJp2pITPsW0+xRqC8H/2ykap+dX3hIm5H+arklU9+PHJTiPGF37pKsSUfWIKBs/VdfgUH19QI5LCvFYMYm25P8F5PFIpscd/wWqWUL7v9Tcu59xtHWZWCJIXEgVWu6PpHF5PKhQA3vEJJTxPeKnUktJ0WA6nDlLL/ycdPx4sTRrZjI4NLF+H8L4MgLFLVp6AdXpR2BE1GTTDhyEQ0nzmngaYySHBvYIq+0pE0BZ6MhbpTQ/aUTDnGM6Uo5obHdO89SkIKHcytbBh3YgMCGPdpPIFh7SHuVDxyxttMuilWhBLL23NfauooeBbZKsc/r30Z02VuglkMJQLBSW5WIkkZzqrukf7QCYLcyhAvP7ASM7laL7DABN2vQFvDzuNAxwH6LnwOEYLuhAztsDNoWFDW2uQF/bTbAy9o1pKwGpm+5sUKA5KWQvv3PkIe0roOY/nw7oTuBvE8u9C8a3jY8SqV7J/OKce8VYztMOaFRO2eLd+dVKyYa8nWnh2MFxEfMjnz0eCtKzci9S0TlipcZ1c/A69MPe465aJg+yIIor4nl1k4r2TawdXmvXLi6UQKPTQ/m74Is0yn09dggiUAXNVJM9rIn2CA1s/6pnEBMKcqavmYNiAyz19aq6dcxegcq1jhBJlE/6IoUsRi
 nMWo26RO
 D5EfEywHmmMYqmAk9kKu9gQMMQjZxjvX5RO7bqXvt2XebeURBwXiObdBSp2z4/xUDUzoZ7zl4cUT8OwS+f/KHh/sgrlcXGzIXJBMC7/dl4EXJtqkPT3eF43rfCyNf3oAym7dInXpu8Q1d8mxaX49l84JKvgJlbiXmHjVx11vQLBkXQLDvFlIgadx8Yl5/U2aws4UVQHAcPPP4i7xgt5jdEte1/+a7h5vkOZdEobIZ+mPiRpUcv1+rp+y/1cILOcsO8bRtlzulxvbk/sR+XtCkzp3IZrphwGfPK6JJLZDfajZROPoNgQCUwQOMQFRPs4++/WzmIVzOVwQMmqdSl3wr4NdLowYyni+NC/GhNYLmnaYRukqyHOL0Z6LTsJ4y86NHroa4mX40TlAtI0gBkSfh2MDkaN6jb0kiODNi8uiZjM/GpbwkrkR77CXnH1QTItc3LVvH/ZNgPudUHy0evuIL0mLw+pLxB/ES0dd3SCoMS4oNdKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 10:38, Lorenzo Stoakes (ARM) wrote:
> On Thu, Oct 01, 2026 at 10:22:29PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/1/26 17:25, Nguyen Ngoc Thang wrote:
>>> A MAP_PRIVATE mapping of iomem (e.g. a PCI sysfs resourceN file) is a
>>> COW pfnmap: a write fault replaces the pfn with an anonymous page, which
>>> remap_pfn_range() allows by keeping vm_pgoff equal to the base pfn.
>>>
>>> generic_access_phys() does not tell those COWed pages apart from the
>>> original pfns and ioremaps whatever the PTE points to. Reading such an
>>> address via /proc/pid/mem or ptrace then ioremaps RAM:
>>>
>>>   ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
>>>   WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
>>>   Call Trace:
>>>    generic_access_phys+0x130/0x4d0 mm/memory.c:7178
>>>    kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
>>>    __access_remote_vm+0x58f/0x890 mm/memory.c:7256
>>>    mem_rw+0x2a1/0x670 fs/proc/base.c:912
>>>
>>
> 
> Sorry to say this looks schlopped.
> 
> This guy has sent 10 series across 6 subsystems over ~21 hrs:
> 
> https://lore.kernel.org/all/?q=f%3Angocthang2710.1999%40gmail.com
> 
> Nguyen - please do not flood the kernel with patches, and please use the
> Assisted-by tag for generated content.
> 
> The original code you submitted is really not great even if the issue may
> be valid.
> 
> So I'd say somebody from the core team should take over this if we want to
> come up with a patch.

Yes, I'll take care of it.

[...]
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> This looks reasonable but I hate that we have 'special' CoW overrides like
> this :)

After sending this yesterday, I concluded that we can do this cleaner: just have

bool normal_page;

(naming suggestions?)

that express that this is something refcounted with a struct page, like
documented for vm_normal_page().

Then we can just refuse all of these.

> 
>> ---
>>  include/linux/mm.h |  4 +++-
>>  mm/memory.c        | 48 ++++++++++++++++++++++++++++++++++++++++------
>>  2 files changed, 45 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index c49ef99b4413..b90e547797a9 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3193,6 +3193,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
>>  				  unsigned long addr, pmd_t pmd);
>>  struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>>  				pmd_t pmd);
>> +struct folio *vm_normal_folio_pud(struct vm_area_struct *vma,
>> +		unsigned long addr, pud_t pud);
> 
> Hmm, if not defined before why would this need a new PUD handler? Do we
> even have PUD-leaf PFN mappings?

Yes we do. In any case, good for consistency.

[...]

>> +	args->cow = folio && folio_test_anon(folio);
> 
> I actually wonder if this should be changed to folio_has_anon_rmap() at
> some point :)

Not a fan.

> 
> Since a folio being 'anon' is vague, because we stupidly made 'anon' vague
> in general.

For folios it's an established term :)

> 
> Anyway I was going to ask does this suffice for CoW but having an anon rmap
> implies CoW so it does.


The downside of using "bool normal_page;" is that we should check
vm_normal_page() for any mapping, not just cow mappings. I suspect
performance-wise we don't really care.

-- 
Cheers,

David

