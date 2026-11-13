Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12B2606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oikIjxjS
Received: by kanga.kvack.org (Postfix)
	id BEDB56B069A; Fri, 13 Nov 2026 05:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76D16B069F; Fri, 13 Nov 2026 05:39:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69D86B06A3; Fri, 13 Nov 2026 05:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5516B069A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:39:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1A6CA0184
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:39:42 +0000 (UTC)
X-FDA: 85429749804.29.5A075E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1073320002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:39:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oikIjxjS;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794566381;
	b=hiRIPzaF9KiXWbNNYzXJmXfF5i6mXEQ/dBrmDDutBshsxwXGq6wgsBT/IzfdoGnz/+eRwE
	jsf2oEH4p0OtnVAwA0P9a3JuJI9/bnPA4uKHdplg73ztvhGIFdyMrC0XcPm4aTd/4mJqYu
	xJrEhHwZs6vNcIz6/zoPXimjNGMuuy0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oikIjxjS;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794566381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Nwzk4hxferb9G9G6d7KRjbkhkRCdOn7hm3bsXHy8vw=;
	b=xWV+9j6VuQABkamawtMMc7Nylra6SE2lMDIkY0afivkpuR5r3jyY2zCE7v3yAZqM5XtDES
	G/q6GL8DJSNXm4C63bklMMOtlcQmizYrTmiHA+z2Mnz040OCp6RN+NkhAwZVgb2mR/v7Jc
	fPQq91YE/nUfVWMycP6zIG/OBb9sngo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8111E6122D;
	Fri, 13 Nov 2026 10:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3131F000CC;
	Fri, 13 Nov 2026 10:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794566380;
	bh=4Nwzk4hxferb9G9G6d7KRjbkhkRCdOn7hm3bsXHy8vw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oikIjxjSW/M3ldlbTICtnub5xkYFg1ViNQG9Nw0xmdg4Z8H6Oow3vzougdHwkiiqr
	 iDlXhmbsdFDMNTEMRspgNB8hc7M7RUv9+eeKZz45hk/j/7SYqqrzUNRKBbeIjpf1U5
	 Y5zPfblV2wKwr4t6/MAY9nF2P+u3QfIW2adYe1H20ozRsZlu88NJSEuyZSv3/LjC6B
	 RcoHav9UN2OzsVWsG7vR5B6yzFFHACZJg94CyfpGzymJyOSOFFGJ9ZsFNn6EcB5SrO
	 clQai4laO0w8SaQ6Z5mnAJt5vqU2zXV567BlDyycdQ7OEYyiDcrPzmVJGcLoPRkdOQ
	 aEaCDQbty4x5Q==
Message-ID: <29bf5516-36bf-490e-ac35-d89893fa61b3@kernel.org>
Date: Fri, 13 Nov 2026 11:39:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok()
 helpers
To: "Farber, Eliav" <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-3-farbere@amazon.com>
 <a242ede8-71c2-4f75-b5e5-dcfa98ab25d3@kernel.org>
 <BY3PR18MB47227EB15146F8F16E1C005BC6702@BY3PR18MB4722.namprd18.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <BY3PR18MB47227EB15146F8F16E1C005BC6702@BY3PR18MB4722.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1073320002
X-Stat-Signature: 6ya1de14firzrwrhqec4uam8aw69w6fu
X-Rspam-User: 
X-HE-Tag: 1794566380-903646
X-HE-Meta: U2FsdGVkX1833Q9kLG086s/fFNPyeh80q+j6B22rI+3ClQYjRp/PEwM4j3G3DsWZcjRr4tDV4zy3BvNKFREWO7egZvQ2pn2eNBMP4qHfj7QALlpoQwfoCg6RuS1WaYMdqtXPH1Jt4+6ZMwlMJxF5egjZnrPYAOrYKwS1C9wYR9cys97YblZXmHjhlGEyu4tnswIPsHJtkTo46Z5TipM9jj+BTqgbSh2t0b1/ZyYFWTGC28FVcaJW13CejEQLfrv+4lLbn2zpGkbM/6tVf40dGnnHm/viyCKzcLpB42LuhYi+B5NqP6TsRHn9KsnnTLdv2kyaG4wO+ED69TGHwh/anjpfJntfarMUpRqyAAvTiZzqzS76hMeCUmwt2lauYlcyfb19+b4gpO0QMSwkXr6qhvA1lPASYYL/IEL7z39W3x0+n6GFSwSkP+6lAQOnC6CqIEYThxgTy+Q3njIt6G52eXCCiQQ6+zdaY1WUBJ96/Cl21CyiWLYZR+nQ2E9uJDQbXF056VfNnLASjGtMHh67aWMjPUDAE7VRSCpa6MZOaAUSwBq5BmXNA2+s/zx0t8lAtVs0WsKM0KaqllO2BXq3T3Hvr5eD88IGCeJ8KpM1qNmyO8ertmNiJTc0eL+dg97+skrGmaoGu733G1JIsT+toqUWwmpSyTnLNpWe2IDcSzKWs+FlotiU/9oHoeRH00ng9lzsLN7M/ZmJJsBdRMfhBLkFiW6LXKDZaUDv5iRyBSawVM/AwGhhWH43Z7ihR9Mn7HElgrv+m0INcjyp3WlzV8v5NEPUrwq/Uz3IVMRObMAdTjx1uCaiM/DNhbYF7E2A3NNUcNR6UsXaOc9qQPC4S4ppItL7Du++qviMuD8uAllUTK2/gDBQVgDsvLhF7Gjvw1F6yLYJXOzT4BAce3IMgcYX7r88QPmVX8Ev7Jds2aU2UejUxJsAVBWJp3EgKBP2ruF8y7IfF9z5/VdAP0T
 4ykCLfww
 24CPnyf0iJyNmNlC0tY1cRHWYUyfm1p9I2ZVcVyJJU0QRP9dRaFERUg9aNtZYp5HVhKuNNY1023CJgF5iA2PSEnrLkBlDUUUFoqNPDVuNSLZbCUmHkj93mMU2uDNK7gMfcAyv+hWlxu4/ADKbZlO3bXfXr1TgwY+bATXcxNZ8/b0Ojz4izOU7Wy5tl4DD4Q1+s9r8qyikOvuGLbvwxPi5MZcNjmEoDngaG/NCWS+ADV8QCtlGRuozCPilPLE10uRgyBZw4kazW0fZhx1Gdy9qxGfrUB24qOYKp/OKL35IR2+yX0uEBpWTuT9YD2BsJ6DTgvGViwlxO6hxo04r2XFhJjr26hViYwSeoOHossQDiEkxwIjGvTTIj0G5z9oI9KLTl7ggAjIHqFczBE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 16:55, Farber, Eliav wrote:
> On 11/12/26 14:02, David Hildenbrand (Arm) wrote:
>>> +    return !order || (addr >= vma->vm_start &&
>>> +                      addr + (PAGE_SIZE << order) <= vma->vm_end &&
>>> +                      IS_ALIGNED(pfn, 1UL << order));
>>
>> To make this somewhat consumable for a human,
>>
>> if (!order)
>>       return true;
>> return start >= vma->vm_start && end <= vma->vm_end;
> 
> We crossed in flight: v2 went out about six minutes before your mail, so
> you were reading v1. I posted it to address sashiko-bot's review of v1,

First, wait for human review. Always.

Second, read Documentation/process/submitting-patches.rst

"Wait for a minimum of one week before resubmitting or pinging reviewers
- possibly longer during busy times like merge windows."

Because we have much other priorities right now :)

> which found a write-flag asymmetry in this patch and a COW problem in
> patches 3 and 4. vmf_pfn_order_ok() is unchanged there, so all three of
> your comments apply to v2 as posted.
> 
> Agreed on the shape. Your version drops the pfn term, which is your next
> question, so let me answer that and then propose deleting the helper.
> 
>> And maybe rejecting IS_ALIGNED(pfn, 1UL << order) with WARN_ONCE() as this
>> sounds like the user is doing something stupid?
> 
> A misaligned pfn is not a caller bug, it is what userspace asked for. For
> /dev/mem, vm_pgoff is the base pfn, so an mmap() at a page-aligned but not
> PMD-aligned physical offset gives a pfn that cannot be mapped at PMD order.
> Falling back to PTE order is the correct answer. The selftest covers this
> directly: it maps /dev/mem at offset +4K onto a PMD-aligned VA, so the
> window term passes and only the pfn term fails, and it asserts both the 4K
> fallback and that the data read back is the data at that physical address.
> A WARN there would fire on an ordinary mmap().
> 
> Dropping the term is worse than a WARN, because nothing below catches it.
> x86 pfn_pmd() masks the pfn:
> 
>         static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
>         {
>                 phys_addr_t pfn = (phys_addr_t)page_nr << PAGE_SHIFT;
>                 pfn ^= protnone_mask(pgprot_val(pgprot));
>                 pfn &= PHYSICAL_PMD_PAGE_MASK;
> 
> so a misaligned pfn is silently rounded down and the mapping points at the
> wrong physical memory. pfn_pud() does the same with PHYSICAL_PUD_PAGE_MASK.
> 
>> But looking again, this all looks like sanity checks where the user is just
>> doing something stupid?
>>
>> Why is that required at all? I'd get rid of this entirely.
> 
> The check is required on the fault path because mm asks the handler to do
> it. From __thp_vma_allowable_orders():
> 
>         /*
>          * Check alignment for file vma and size for both file and anon vma by
>          * filtering out the unsuitable orders.
>          *
>          * Skip the check for page fault. Huge fault does the check in fault
>          * handlers.
>          */
>         if (!in_pf) {
> 
> thp_vma_suitable_order() is the same check: the order window within the
> VMA, plus, for a non-anonymous VMA, IS_ALIGNED(vm_start >> PAGE_SHIFT -
> vm_pgoff, ...), which for a PFNMAP whose vm_pgoff is the base pfn is the
> pfn alignment. mm's own huge handler honours that contract:
> do_huge_pmd_anonymous_page() opens with
> 
>         if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>                 return VM_FAULT_FALLBACK;
> 
> and the pfn-mapping handlers each carry a private copy:
> is_aligned_for_order() in include/linux/vfio_pci_core.h for vfio-pci and
> nvgrace-gpu, device-dax re-derives it from dev_dax->align, and fs/dax.c has
> dax_fault_check_fallback(), which tests the PMD colour and both ends of the
> window.
> 
> So I agree with where you are going, just not that it can be deleted. I
> would rather move both terms into mm than add a seventh copy. insert_pmd()
> and insert_pud() are the right place: they already reject
> addr < vm_start || addr >= vm_end, and they already hold the pfn in
> fop.pfn. What is missing there is the end of the window and, in the
> non-folio branch, the alignment. Concretely:
> 
>   - Add to insert_pmd(), beside the start test:
>     addr + HPAGE_PMD_SIZE > vma->vm_end, and, in the !fop.is_folio case,
>     !IS_ALIGNED(fop.pfn, HPAGE_PMD_NR), both returning VM_FAULT_FALLBACK.
>     insert_pud() the same with HPAGE_PUD_SIZE and HPAGE_PUD_NR. The
>     alignment test is gated on !fop.is_folio, and the window test is a
>     no-op for the folio callers, since dax_fault_check_fallback() already
>     rejects (pmd_addr + PMD_SIZE) > vm_end before calling.
>   - Drop vmf_pfn_order_ok() entirely. No caller needs it and no new driver
>     does geometry.
> 
> That removes the helper you object to, fixes an unchecked window end that
> exists today for every implementor, and leaves vmf_insert_pfn_order() as
> the order dispatch plus the huge-zero and pfn_modify_allowed() cases.
> 
>> Why do we even care about the order? Why isn't it sufficient that we get called
>> with "insert this pfn range" and we see how to best map it (pfn/pmd/pud)?
>>
>> Why does the caller even have to care about *how* something is mapped?
> 
> It does not, and it does not choose. mm picks the order and tells the
> handler which one: __handle_mm_fault() tries create_huge_pud() ->
> ->huge_fault(vmf, PUD_ORDER), descends to create_huge_pmd() ->
> ->huge_fault(vmf, PMD_ORDER) on VM_FAULT_FALLBACK, then to
> handle_pte_fault(). vmf_insert_pfn_order() only dispatches on the level mm
> reached, which is what vfio_pci_vmf_insert_pfn() already open-codes with
> the same !order / PMD_ORDER / PUD_ORDER ladder. The patch de-duplicates
> that; it does not introduce the order-based shape.
> 
> Changing the interface to "here is a pfn range, you pick" means changing
> ->huge_fault itself, for all of its implementors. The folio-backed ones
> need the order, because they look up a folio of that size. That seems like
> a bigger discussion than this series, but I am happy to have it.
> 
> For VM_PFNMAP specifically there is a narrower version of your idea that
> does work, and patch 1 is most of it: pfn_range_track() already gives mm
> the pfn range at mmap() time, so the fault path could insert without
> calling the driver at all. What stops it is per-fault policy, not page
> table walking: /dev/mem must re-check range_is_allowed() because
> revoke_iomem() can zap the mapping after mmap(), UIO must test idev->info
> under info_lock so a fault racing unbind gets SIGBUS, and vfio-pci holds
> memory_lock and checks __vfio_pci_memory_enabled(). That is why
> ->huge_fault exists for these mappings.
> 
> Does the insert_pmd()/insert_pud() move look right to you? The missing
> window-end test is pre-existing, so it could equally go on the
> huge-pfnmap mm fixes series rather than inside v3. Say which you prefer
> and I will send it that way.
> 
> What changed in this patch between v1 and v2:
> 
>   https://lore.kernel.org/all/20261112125638.12209-3-farbere@amazon.com/
> 
> Only the order-0 path. The sashiko-bot review on this thread observed that
> vmf_insert_pfn_order() honoured the fault's write flag for PMD and PUD but
> not for order 0, where the pte comes from vma->vm_page_prot. v2 passes it
> at order 0 too, through an extracted __vmf_insert_pfn_prot(..., mkwrite),
> so the v1 sentence you quoted above the hunk, "The order-0 path needs
> nothing: wp_pfn_shared() resolves that fault", is gone. I could not
> reproduce a user-visible failure on either new target: /dev/mem and UIO
> both modify vm_page_prot, so vma_wants_writenotify() takes its escape. That
> change therefore rests on consistency with the huge paths, not on a
> demonstrated bug. It does mean a first write at order 0 no longer calls
> ->pfn_mkwrite, which the kernel-doc now states. v2's cover letter has the
> rest of the changelog.

Before I reply to anything in here: did an LLM compose most of these walls of
text? :)

-- 
Cheers,

David

