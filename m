Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7712CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAC28E013E; Tue, 14 Oct 2025 11:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BCC8E010A; Tue, 14 Oct 2025 11:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AC28E013E; Tue, 14 Oct 2025 11:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4D468E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:01:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D00E5BFE4
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:01:42 +0000 (UTC)
X-FDA: 83997034044.29.1DB443C
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2EAC3A001F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:01:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mc3BGk1l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760454100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AB9j6O3TPji8YNEzc+bgFaMn1t+j1zQSsTJC9AP4fx4=;
	b=eScYgx4DDOMZDSU47n6VqvmRtc7jIzzkML6oJBYCbfXg+hpRsvH4BkwuTGt/ADEIQM9ssW
	7oNwOz0aa4q1tQYA7rMCiv8kidpp6R5DH9EYU5codSDA/uDKbSvdw/3rU8PTwZkPsjUJhb
	Ge2dTtxLgQXYF+34n2GolzIAFSWJgrA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mc3BGk1l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760454100; a=rsa-sha256;
	cv=none;
	b=MGAAa2HaydO1z7+IeRqufQiMHGEIoG0dRKxtQVbCsnZtAL3YM0kPNbFScLZOz6yY/uYDun
	G2Xw0I3b+xCL4eYFdeC56wUtf9lybCEaC1C0pRsWCvLq6CBoHX/L6cLRZApnG/JH4GuY5p
	e6bGp2EQENafCJNQpfxw0Mz0y7mGZ3Y=
Message-ID: <d2e5b099-94bd-444d-9946-182807443539@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760454091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AB9j6O3TPji8YNEzc+bgFaMn1t+j1zQSsTJC9AP4fx4=;
	b=mc3BGk1laLOWzAF5w/uZV0flGEZx0baY7aeoTRTSkf+Blbng98lexfcRFo5vWyJFzc98eP
	0pkpMSXcdutVbpE9GhGemQE1cLazHEkR0wheL8UQ2RfZeOpZEQSyeMDgmlpQEX2+LUQaC+
	WdXJX3Hr31s7/2r7jIDxnIUFzo2+4A4=
Date: Tue, 14 Oct 2025 23:01:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 hughd@google.com, ioworker0@gmail.com, kirill@shutemov.name,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com,
 npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
 richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EAC3A001F
X-Rspamd-Server: rspam03
X-Stat-Signature: bwurqetiywk4ardp8y45oe6korwp4wxj
X-HE-Tag: 1760454093-589079
X-HE-Meta: U2FsdGVkX1/JdlawDFhY2L1w3TaagoD3q/Et/4YywR2mkEnWjt1kOYb86eN0rrbZBXF0uQePKeiSaiQyWN4OC7d6pzcldFVi7YjqIfcYQb9S2n/wp9GGtcjhOhZ1URHb3jXfxO3hk3kwKou9kUXy1vbCmNkXEpCGuIDzZerWei8NJcjMrq79iGNM6tV9aRdzBr8RsskpcOSFUfGxwKmfazRVHz30xJ9NWSmKZeoPoOslyBq8MIMo+kG/MhVbN5Z8vChL4TtcZ1pdgctvMLorcBGqluPaggzHVJObH94Eg8vzh0YmvwPzowksE//YObaE6+IP8JuB7QGUx4P6VYdsbd7rAiqYDSMv/2WNQWyRKoFe8m25vgW9DAGVg+fhsZOCq+OUIzqno4i0mwma+kKEfp/lfhQzjZ99n3R1w6VUsN/Z8/AbUCVfm9sMzYtuAAVrJAN59myRXvncRBVhrfVgPo/SZj5uhIQAEzmUnvKWr8dzWFf7NjHF8xlHDYSNhnKVxqBSYg11sVyz3LEIouZKph0+QdRzfDBh61HdvyA5FIEgd2PECAk88hffY6QvsemnCRpqx8PYsRq817AFAGE3HonL+PLuJGKLZ5Y/rbDfnXD1UVfbD/YlbK7qhFQ6aE+K3XC6Nsa8rECFo7+H0VsxtORL3wrRFyNlNygqGkvNoloKbopwEvuPPlr8l0AAAYcsLCGvc8K8NBcOa5Wsg4uSW/tJLRYaC63kv2yn19wF8lOnV173GxsRC6eOJ/+YTCQDsZzjHYqRMyktKBBZmFlYC76z9vW4+nva5Pn6H4sgs8ijGVmsQp96hL1d1D+lIxZ/GW6YxjVzP+jdUx86EtcUKb1qb1iigvUlvgqUhZYja3pYlqovuEIBUmWCO4LfIuO7JoiUG4azL2Sxx8Rsqolh8KNaoyzrPGDxHMXpSPH5SCaVGkwXb1LUQ/QLwpmCywLcI1Gj1prIqIbLmwlJ5i5
 yszSk5o5
 wHC5TU+RSY4HweHluS3WJo477C6WNYUJEWdZNUUoFLLQK61kjCrsxNoKLrElpWaMd48q58prVz+yntRCJC7XJsdpJ+WkEU16gk6bQDCL59vCNAM6Jr6PHopZPT38FMyt/JhWiu9GqzhL1E7Fl6A53srZAHVz/1heVUn70ESDcy7elDB11sUWvNJt4SLFbPyw40ip15gDIBl+pYMCYLFgsjcD57UqVdLkg89acMbuWoR1GKUJrKbzH0CsxdwUJE3gsrf7XymBZyHL3Pcd7pe7B3seQ5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 22:39, Lorenzo Stoakes wrote:
> On Tue, Oct 14, 2025 at 10:26:20PM +0800, Lance Yang wrote:
>>
>>
>> On 2025/10/14 19:08, Lorenzo Stoakes wrote:
>>> On Wed, Oct 08, 2025 at 11:26:57AM +0800, Lance Yang wrote:
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index abe54f0043c7..bec3e268dc76 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>>>    		if (!is_swap_pte(vmf.orig_pte))
>>>>    			continue;
>>>>
>>>> +		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
>>>> +			result = SCAN_PTE_NON_PRESENT;
>>>> +			goto out;
>>>> +		}
>>>
>>> OK seems in line with what we were discussing before...
>>
>> Yep. That's the idea :)
>>
>>>
>>>> +
>>>>    		vmf.pte = pte;
>>>>    		vmf.ptl = ptl;
>>>>    		ret = do_swap_page(&vmf);
>>>> @@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>    	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>    	     _pte++, addr += PAGE_SIZE) {
>>>>    		pte_t pteval = ptep_get(_pte);
>>>> -		if (is_swap_pte(pteval)) {
>>>> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>> +			++none_or_zero;
>>>> +			if (!userfaultfd_armed(vma) &&
>>>> +			    (!cc->is_khugepaged ||
>>>> +			     none_or_zero <= khugepaged_max_ptes_none)) {
>>>> +				continue;
>>>> +			} else {
>>>> +				result = SCAN_EXCEED_NONE_PTE;
>>>> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>>>> +				goto out_unmap;
>>>> +			}
>>>> +		} else if (!pte_present(pteval)) {
>>>> +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
>>>
>>
>> Thanks for pointing that out!
> 
> You've deleted what I've said here and also not indicated whether you'll do what
> I asked :)
> 
> Please be clearer...

Oh, I didn't delete your comment at all ... It's just below ...

> 
>>>>> Hm but can't this be pte_protnone() at this stage (or something 
else)? And then <-- Here!
>>
>> Yeah. The funny thing is, a protnone pte cannot actually get here, IIUC.
>>
>> ```
>> static inline int pte_protnone(pte_t pte)
>> {
>> 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
>> 		== _PAGE_PROTNONE;
>> }
>>
>> static inline int pte_present(pte_t a)
>> {
>> 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
>> }
>> ```
>>
>> On x86, pte_present() returns true for a protnone pte. And I'd assume
>> other archs behave similarly ...
> 
> This was one example, we may make changes in the future that result in entries
> that are non-present but also non-swap.
> 
> I don't see the point in eliminating this check based on an implicit, open-coded
> assumption that this can never be the case, this is just asking for trouble.
> 
>>
>>> we're just assuming pte_to_swp_entry() is operating on a swap entry when it in
>>> fact might not be?
>>>
>>> Couldn't we end up with false positives here?
>>
>> Emm, I think we're good here and the code is doing the right thing.
> 
> I mean sorry but just - NO - to doing swap operations based on open-coded checks
> that you implicitly feel must imply a swap entry.
> 
> This makes the code a lot more confusing, it opens us up to accidentally
> breaking things in future and has little to no benefit, I don't see why we're
> doing it.
> 
> I don't think every little 'aha X must imply Y so just eliminate Z' idea need be
> implemented, this feels like a sort of 'mathematical reduction of code ignoring
> all other factors'.

Understood. Changing !pte_present() to is_swap_pte() will resolve all your
concerns, right?

```
if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
[...]
} else if (is_swap_pte(pteval)) { <-- Here
	if (non_swap_entry(pte_to_swp_entry(pteval))) {
		[...]
	}
[...]}
```

> 
>>
>>>
>>>> +				result = SCAN_PTE_NON_PRESENT;
>>>> +				goto out_unmap;
>>>> +			}
>>>> +
>>>>    			++unmapped;
>>>>    			if (!cc->is_khugepaged ||
>>>>    			    unmapped <= khugepaged_max_ptes_swap) {
>>>> @@ -1290,7 +1311,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>    				 * enabled swap entries.  Please see
>>>>    				 * comment below for pte_uffd_wp().
>>>>    				 */
>>>> -				if (pte_swp_uffd_wp_any(pteval)) {
>>>> +				if (pte_swp_uffd_wp(pteval)) {
>>>
>>> Again you're assuming it's a swap entry but you're not asserting this is a swap
>>> entry in this branch?
>>
>> As we discussed above, the non_swap_entry() check has already kicked out
>> anything that isn't a true swap entry, right?
> 
> This is a different function?
> 
> Actually I'm mistaken here I think - you check in the code above:
> 
> 		if (is_swap_pte(pteval)) {
> 			...
> 		}
> 
> So this is fine, please ignore sorry :)

No worries at all, thanks for double-checking and clarifying!

> 
>>
>>>
>>> Also an aside - I hate, hate, hate how this uffd wp stuff has infiltrated all
>>> kinds of open-coded stuff. It's so gross (not your fault, just a general
>>> comment...)
>>
>> Haha, tell me about it. No argument from me there ;)
> 
> :)
> 
>>
>> Thanks,
>> Lance
> 
> Cheers, Lorenzo


