Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F64A606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kwgg/iQx
Received: by kanga.kvack.org (Postfix)
	id 4A2436B05BC; Mon, 26 Oct 2026 05:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F036B05BD; Mon, 26 Oct 2026 05:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DAA6B05BE; Mon, 26 Oct 2026 05:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED7A56B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02C1D806A9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:19 +0000 (UTC)
X-FDA: 85364284320.19.4BEADD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 23BD2120006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kwgg/iQx";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iOrIoueXOP6L/+uHpm/s+Vo7ATEqaloXHKl0Gz0Qco=;
	b=Uo4Cdbmdjxp+BZUfdkIA0mvcfvEX5NGwRHf2STPmYQ48d9FS7erZptS3CNg1KSLAYwj1jZ
	vsJmq59KOcmpzDH/HgQEusuZI91+RuJjSHBi5ZqpkhhnrKkRls0dckqq62UB9SCIBxADgh
	HfamHsb90tQvkaLUJMdpUDfHj2Wk3IA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kwgg/iQx";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007678;
	b=oSmQLTuq9XYbC6bpFuss8Av30CZpB9XRQ5KFZd/nV6SCgjcaStUcPO10gguY/tpyvB3ttt
	WHLGp7NhrJJrI0T8XBNIyLzUG13GPwoM1Zip5J4YxAp+MEMHDVeK7m+W7JI581xqJ0W57z
	PZ440xQ4AjaQ3noWSe78Xnv0RF7S8PY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77BB5414C8;
	Mon, 26 Oct 2026 09:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0C21F01829;
	Mon, 26 Oct 2026 09:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007677;
	bh=2iOrIoueXOP6L/+uHpm/s+Vo7ATEqaloXHKl0Gz0Qco=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kwgg/iQxX7kHo9y4G4iDGUceHIqJWYyy3+JUfeAybFPxvlacpfWKxY414CthU/XlV
	 d/peBCBFfjlJDpx8TUxqU/1HeUKFB9wBT4kttgfNivU3I3tKzONvvcANR86zcgM/4J
	 /dpVpsmoXDHBPloOEpBQkPZHwOlLoQz+QdLtgeTPLJz4Kzqu4Yqs672/Wg5s3QSDjv
	 pcPCtUBOWrbz5YQcBPAhK+8CMv54IvrdijuZ2wblm4pq6DV0qNMR8uz4dkHnBUlQ5s
	 4pDEYf2yQcenJ2V9sCCkXXlyzzqJ8VOYuMLRT/QISQ7pEHeaQ53nfZ3HScbf5OtW9N
	 YJL52T3OgoMog==
Message-ID: <133caff2-34a9-4367-a19e-a37e277a8a08@kernel.org>
Date: Sun, 25 Oct 2026 13:47:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm/hugetlb: disable PMD sharing for UFFD missing
 mode
To: Li Zhe <lizhe.67@bytedance.com>, sashiko-reviews@lists.linux.dev,
 akpm@linux-foundation.org, muchun.song@linux.dev, osalvador@suse.de,
 peterx@redhat.com, rppt@kernel.org, azpijr@gmail.com
Cc: linux-mm@kvack.org
References: <20261022034543.51226-1-lizhe.67@bytedance.com>
 <20261022034543.51226-3-lizhe.67@bytedance.com>
 <sashiko-outbox-181816@kernel.org>
 <7818e0c8-e20b-4dfb-a192-4d0c9fc8209f@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7818e0c8-e20b-4dfb-a192-4d0c9fc8209f@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23BD2120006
X-Stat-Signature: rkn8tr5uee1ox7mknoq4wh5sdx4d1y5t
X-Rspam-User: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793007677-990247
X-HE-Meta: U2FsdGVkX1/AoMJoJfBlDNrc7d92IshlvpD5aTS6tRThdXny2W3WlYMmHp099lPZxxgkOmgM1JkwyjwkT3VhP6WVYNqwGe+xMdRtcLtx0qWpsqsvOdYhBSYLWo1yezGMGlVSoAnR2PDzCFtmKyVl92bewrHYWAywbthmABtY8V14zsQSgSn827/xlrNI+LoN6gmN1ZmOlYDHJEvgIlRv1q3hFR/qGrdS+0P+BJpLkTb8a9d2J9rpYhqApih1BRXMu1cNxpKjAGGEx+piK6MQjbID6X1KkLwgQC+/kiYkSOvcUfqSJ0CaXAbAxN9Mg4YfzxKxi/ADpMG4lodDN5+WPacbvwxWMe8UAMZxSRwN/OkTGczzk+Wcuh5rdwZDGqHbCKvQB5wDTTipbqBplBN8MLP6HQg/6DscIkNrTRPg+upxiWGPr/dkY1M+ESNFyZ/fowz0Urzo6pewWZwLeCoit/vn9ooblnFZH8Y8LyVWvkgVTgTeuTcNnubobVnVwEoCuvXAumYRH5SVz0y6P+dbzWN3NYQlV6EmVolYTtHMdn5iDyz6qy0AKTvcT2G5KbGM1VCVGd+Bj1DvywfjMI0a+br+EAZ/4Y/oFhNkht2i/mz4nRjRGjPY/tS8Ssj0bCIee4b/Bp27nbgth0Osa8oMcSCA+AYuIU9UfmIHoWZc+RlTLrJvKMwrvehXZSbR2YguphexvlNO1Lun9l8yh5mswojPRqfUYpzm+T1h5hBaeSt28Uy3loCDWsHazbaf1ILcRMbZDJO8JTo4tJywdVuJ1JArTwh9JoPFpleo+b/nfl6gtuORn29I61jgoLuHh7dZ9SvYrNWa0XkLjA+kGesg0dw/NRtl1fBa0ox6roGRfj6OwQT9znT2Xma8IaPPwqk6RFfGIfEVx9pk4j3B1DlfaKwW/BXawg59nOXVcMu6C3FY3Ws1XQaCLtuGpGJFTWnHuBGWliPi7yD/ugIz/sF
 HXaDa4M8
 k/laoJLK1f2r5d3rRT4hymuVbddZTacK6bYnDeNVJZCSU8IfiTA2FrpHGDzKoIf/axWcEyY5d5Kz4r3x0vd8mxgWAX+vNTZx8Kjp2TiB8SHwjR7kbx6eIRaNuriYJ8AUh/CKxE8ZIwfOBUy5863YYzB7FkZn0SJZMblaB323isIAJy45wjab2CGpiMfAQqijWLy3teTGpx+xxBeXMKV9CrrDxyccOIzGTpu6yF5Cm1+KAIkvKh8au1ky28mHJ+A2cQkqIysN3ktXOCLeIADvabp6NX3fcCMZU6CvE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/23/26 06:09, Li Zhe wrote:
> On 10/23/26 12:36 AM, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [High] mm/hugetlb: uffd_disable_huge_pmd_share() leaks poison markers on unregister
>> --
>>
>> commit 5da87cbb6b8f2271fb75acc59e14e2d5860cb54c
>> Author: David Hildenbrand (Arm) <david@kernel.org>
>>
>> mm/hugetlb: disable PMD sharing for UFFD missing mode
>>
>> This commit disables hugetlb pmd page table sharing for all userfaultfd
>> registered vmas by checking vma->vm_userfaultfd_ctx.ctx in
>> uffd_disable_huge_pmd_share(), preventing poison markers installed under
>> missing mode from affecting shared pmd tables. It also adds a debug check
>> in hugetlb_mfill_atomic_pte() when installing a poison marker.
>>
>>> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
>>> index a14b8a9ffb7b1..ebd86677b052d 100644
>>> --- a/include/linux/userfaultfd_k.h
>>> +++ b/include/linux/userfaultfd_k.h
>>> @@ -168,22 +168,12 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>>>   }
>>>   
>>>   /*
>>> - * Never enable huge pmd sharing on some uffd registered vmas:
>>> - *
>>> - * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
>>> - *   tracking information is per pgtable entry.
>>> - *
>>> - * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
>>> - *   VMAs which share huge pmds. (If you have two mappings to the same
>>> - *   underlying pages, and fault in the non-UFFD-registered one with a write,
>>> - *   with huge pmd sharing this would *also* setup the second UFFD-registered
>>> - *   mapping, and we'd not get minor faults.)
>>> + * Never enable huge pmd sharing on userfaultfd registered VMAs, because
>>> + * userfaultfd state can be tracked per VMA or per page table entry.
>>>    */
>>>   static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>>>   {
>>> -	return vma_test_any_mask(vma,
>>> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
>>> -					VMA_UFFD_MINOR));
>>> +	return vma->vm_userfaultfd_ctx.ctx;
>>>   }
>>>   
>>>   /*
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 966d249469454..7566f2eed50b0 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -6399,6 +6399,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>>>   			return -EEXIST;
>>>   		}
>>>   
>>> +		VM_WARN_ON_ONCE(size == PMD_SIZE && hugetlb_pmd_shared(dst_pte));
>>>   		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
>>>   		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
>>>   
>> [Severity: High]
>> Can a pmd table containing a poison marker still become shared across
>> processes after the vma is unregistered from userfaultfd?
>>
>> When a process registers a shared hugetlbfs vma in missing mode and installs
>> a poison marker via hugetlb_mfill_atomic_pte(), the marker is written into the
>> process's private pmd table.
>>
>> If the process later unregisters the vma or closes the userfaultfd descriptor
>> (via userfaultfd_unregister() -> userfaultfd_clear_vma() or
>> userfaultfd_release_all() -> userfaultfd_clear_vma(), or remaps via
>> mremap_userfaultfd_prep()), the userfaultfd flags and context are cleared
>> while the poison marker remains in the page table:
>>
>> mm/userfaultfd.c:userfaultfd_clear_vma() {
>> 	...
>> 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
>> 				    &new_vma_flags, NULL_VM_UFFD_CTX,
>> 				    give_up_on_oom);
>>
>> 	if (!IS_ERR(ret))
>> 		userfaultfd_reset_ctx(ret);
>> 	...
>> }
>>
>> Unlike write-protect markers, which are resolved by change_protection() on
>> unregistration, poison markers intentionally persist after the userfaultfd
>> context is reset.
>>
>> Once vma->vm_userfaultfd_ctx.ctx is cleared and the userfaultfd flags are
>> removed from vma->vm_flags, uffd_disable_huge_pmd_share() returns false and
>> page_table_shareable() in mm/hugetlb.c considers the vma eligible for sharing
>> again:
>>
>> mm/hugetlb.c:huge_pmd_share() {
>> 	...
>> 	mapping_rmap_tree_foreach(svma, mapping, idx, idx) {
>> 		if (svma == vma)
>> 			continue;
>>
>> 		saddr = page_table_shareable(svma, vma, addr, idx);
>> 		if (saddr) {
>> 			spte = hugetlb_walk(svma, saddr,
>> 					    vma_mmu_pagesize(svma));
>> 			if (spte) {
>> 				ptdesc_pmd_pts_inc(virt_to_ptdesc(spte));
>> 				break;
>> 			}
>> 		}
>> 	}
>> 	...
>> }
>>
>> When another process mapping the same shared hugetlbfs file faults in that
>> range (hugetlb_fault() -> huge_pte_alloc() -> want_pmd_share() ->
>> huge_pmd_share()), huge_pmd_share() walks the first process's vma, finds its
>> populated pmd table containing the poison marker, and shares it into the
>> second process.
>>
>> That exposes the second process to the first process's poison marker. In
>> addition, if the first process subsequently unshares the pmd table (for
>> example via mprotect(), hugetlb_split(), or re-registering userfaultfd),
>> __huge_pmd_unshare() clears the pud entry in the first process, causing the
>> originating process to lose its own poison marker while leaving it installed
>> in the second process.
>>
>> Should the vma or ptdesc record that a poison marker was installed so pmd
>> sharing remains disabled for it even after userfaultfd unregistration?
> 
> Thanks for the report.
> 
> This looks like a valid concern, but I think it is not introduced by
> this patch. Before this patch, VM_UFFD_MISSING did not prevent hugetlb
> PMD sharing, so UFFDIO_POISON could already install poison markers into
> page tables that could later become shared.
> 
> This patch addresses the registered-VMA side of that problem by making
> hugetlb PMD sharing disabled for userfaultfd-registered VMAs. So new
> poison markers should no longer be installed into shared PMD page tables
> while the VMA is registered.
> 
> The unregister case seems to be a remaining pre-existing lifecycle issue
> around PTE_MARKER_POISONED and hugetlb PMD sharing. David previously
> mentioned broader poison-marker issues and prototype fixes here:
> 
> https://lore.kernel.org/all/bb72cc2c-a46a-44f8-99a2-b036abfdbd26@kernel.org/
> 
> So I think we should wait for David's thoughts on how to handle that
> remaining case.

I have fixes for the fucked up UFFDIO_POISON handling already. They depend on
some fixes Lorenzo sent out on Friday.

Don't worry about it here :)

-- 
Cheers,

David

