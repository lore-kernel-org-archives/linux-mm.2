Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA443606A319
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 04:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=j6Y+CCDN
Received: by kanga.kvack.org (Postfix)
	id B20FD6B0331; Fri, 23 Oct 2026 00:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA926B0334; Fri, 23 Oct 2026 00:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A546B0337; Fri, 23 Oct 2026 00:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7116B0331
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 00:09:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC97C1601D0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:09:49 +0000 (UTC)
X-FDA: 85352562498.17.CFA5E91
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B1D2180007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:09:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=j6Y+CCDN;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792728587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UL1xs+3wBpHHfuSwjpX6YqED9XSfjXDo9wVKeymLCdc=;
	b=w2xNhchvdRCmVeYEcTAwFPkKVvcBYS43AaR9fs+sEI2VKy8fcC34KNlD16NOieU0Wyv0Nx
	5knQfRQiWAUZEY+CLQ4r40f9pPjsDgarGuc3e6+v9ZyjEo8RAebhi1x0AFy24WG1sUAM9H
	lxvx8PyonOECmHtAxjAZBUA6o9dpdXI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=j6Y+CCDN;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792728587;
	b=xzNPwHau0QbZ7XJohfIOSotqr79uF6O7NoRKK5YIGu4sbBUPLSQuTRfyb86hepiQ0DLa+D
	qF4NL740LYFpGIeRWqJjBpDmeEvfhOhUH/r2quGKn5BjVDuq+lDk4gsmz4amIuIN0+LGzS
	lQaptmMzeBlQvzqPzpL+yeM+2YRrq0w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792728581; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UL1xs+3wBpHHfuSwjpX6YqED9XSfjXDo9wVKeymLCdc=;
 b=j6Y+CCDNyyR6H+i0gPIsCHJgUwltUiIsHmtRtM6smI0Ax48nLvW6TcmKtlVv8VrzlTruaM
 3in7r7HisapKhJLh7947sf2mCjlQxsmhjP/EST7EAGjwdqNwxCPtV3zb5kETx2Y3Xb9k5m
 x49qr+w1AWbJYWk+gMeBq84X6z+tzfGfbHzpOzfaXosI7iDx2vhDA4uIVlwqiOrehVkLey
 IRYM+XvY6OiOrTftjPqRDs8YK8dSdfKHYVnzw5B56z0yxXfo2CZxkvHs3oHwQpuZP4DW7N
 sCNXu2ueDjkgEkmFhpSfXOfB3cCVKY4/jc6mF/ToU6HQUC+5oOzeXQEIW7I3yg==
Message-Id: <7818e0c8-e20b-4dfb-a192-4d0c9fc8209f@bytedance.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <sashiko-outbox-181816@kernel.org>
X-Lms-Return-Path: <lba+26adade04+5d1385+kvack.org+lizhe.67@bytedance.com>
To: <sashiko-reviews@lists.linux.dev>, <akpm@linux-foundation.org>, 
	<david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<peterx@redhat.com>, <rppt@kernel.org>, <azpijr@gmail.com>
Subject: Re: [PATCH v3 2/3] mm/hugetlb: disable PMD sharing for UFFD missing mode
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Fri, 23 Oct 2026 12:09:25 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
References: <20261022034543.51226-1-lizhe.67@bytedance.com> <20261022034543.51226-3-lizhe.67@bytedance.com> <sashiko-outbox-181816@kernel.org>
Cc: <linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Rspamd-Queue-Id: 0B1D2180007
X-Stat-Signature: kxw3ram4mnkasnf4a7wx1pbttus694z5
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792728586-929043
X-HE-Meta: U2FsdGVkX185rkSDX5085NpeW3smEeiSpN7BOGCUNrpSJVRJVhtZ68tnMqqxRD8v9eA/oywTx5jm+ebfJvxqtohphVXnRG+eP05xKH9UWCd5ZgnR6xlXAHC8Cfc3plkpMvlY2vMhoackoEUdg2xrE/iR6NV0o7oDWPwRORZrnJ5idtMWr6HPVYdFxDFEt773KiiKq2R9ljBoAvwt6b0HJHxwefYyakrVcgkylVKvvYJW1A9IYsyvd9UQjsRIkisFaojxA372h3PLKq4f+UE/yqgZlwrjqWKCf5GK0Qdw32sJcTwRUuI418YaQ6kZX310R48aGw9EsrnlUOkcgWFA5xQWTUKu+jK7mZYg2rBdoCu7XG5DHCHP/GPSpZ81JG2M96BSgU5wX6q+sRtz1+gsBvpdBsVsGs7s3I5anIBSF0ZwPQqIUoeFo3TebVyu9dkcBiQOCf1cE2HKJyTt4+07JWzdQg9GtFlwuFbcAq/UEHEeZ/XnB8A/0ZE0wVirUV1cM9mK97BQYvGsIktMWED2xw8qlQDmvfITeMnMScOY5oJHU6a/T43+WgOvkuuETGqvGcIH11taOUtBPQHh6wr/iS/JBPBX+ny36oksp3ZKwf39VOyB0di0XHuQhDSz9FJ1ImqxG7p9E2H7ZF6Dx27oPvXCkC5NQvjxBdAVHHtcwffPkJNxEGAqts7LgCxX3GM5gkRufDL4sGjxkq1kC1S5tA/Rr8XpJ6KMfBWGlefrP0vzJTgxKrZJTgoXmDv3wYw5q+Gy+hw6c38p/IWV4Bc1Zh2SmpVj2Lpd9sBcycH3Td1k3PSu4GC9o9GMCwrdvcCGiQeyVvvgblqT5C4d5vA0OJ7qs+CRhdQqLDPhoc+tji4/SwOCc5cjnvfPqXz9Aq/OT7BXs7M7qlvOX1+SFo9/j+91IVwRBq5GCgrYsznUsUZkCnT4/aAqKhpUE9CDC1vWcnNkasnW71Em5VHCHFK
 DQvDsUK6
 dDFu6Sy1IZEb52DN2dtChrNa+HN0IcIO1F3YlQOg5T5LDuL4N2YJx51HV+WEx6IjLDKuKH5Kve3EV8TgFUMYHgwPX70JZPWGicmP25Rq6/BooQXH8xylsLgCTqeVTQyqmTplVzgm7bvo9zxDEAFD4sTlWaDjo6dQFprniNQumPIGF1k7vrPpKKKYCLSyvHrIbYU8KWZ6bAjEYt/5uiIGwM0LKNRd63mXGBOJVDoTPC/jTpQbr+Q6T1cnVZm8BRfOkiOcAGLvyqDCbe5uVbpoMh8Fys9DOqYU/va+rFgP+VabBWfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/23/26 12:36 AM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm/hugetlb: uffd_disable_huge_pmd_share() leaks poison markers on unregister
> --
>
> commit 5da87cbb6b8f2271fb75acc59e14e2d5860cb54c
> Author: David Hildenbrand (Arm) <david@kernel.org>
>
> mm/hugetlb: disable PMD sharing for UFFD missing mode
>
> This commit disables hugetlb pmd page table sharing for all userfaultfd
> registered vmas by checking vma->vm_userfaultfd_ctx.ctx in
> uffd_disable_huge_pmd_share(), preventing poison markers installed under
> missing mode from affecting shared pmd tables. It also adds a debug check
> in hugetlb_mfill_atomic_pte() when installing a poison marker.
>
>> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
>> index a14b8a9ffb7b1..ebd86677b052d 100644
>> --- a/include/linux/userfaultfd_k.h
>> +++ b/include/linux/userfaultfd_k.h
>> @@ -168,22 +168,12 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>>   }
>>   
>>   /*
>> - * Never enable huge pmd sharing on some uffd registered vmas:
>> - *
>> - * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
>> - *   tracking information is per pgtable entry.
>> - *
>> - * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
>> - *   VMAs which share huge pmds. (If you have two mappings to the same
>> - *   underlying pages, and fault in the non-UFFD-registered one with a write,
>> - *   with huge pmd sharing this would *also* setup the second UFFD-registered
>> - *   mapping, and we'd not get minor faults.)
>> + * Never enable huge pmd sharing on userfaultfd registered VMAs, because
>> + * userfaultfd state can be tracked per VMA or per page table entry.
>>    */
>>   static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>>   {
>> -	return vma_test_any_mask(vma,
>> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
>> -					VMA_UFFD_MINOR));
>> +	return vma->vm_userfaultfd_ctx.ctx;
>>   }
>>   
>>   /*
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 966d249469454..7566f2eed50b0 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -6399,6 +6399,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>>   			return -EEXIST;
>>   		}
>>   
>> +		VM_WARN_ON_ONCE(size == PMD_SIZE && hugetlb_pmd_shared(dst_pte));
>>   		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
>>   		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
>>   
> [Severity: High]
> Can a pmd table containing a poison marker still become shared across
> processes after the vma is unregistered from userfaultfd?
>
> When a process registers a shared hugetlbfs vma in missing mode and installs
> a poison marker via hugetlb_mfill_atomic_pte(), the marker is written into the
> process's private pmd table.
>
> If the process later unregisters the vma or closes the userfaultfd descriptor
> (via userfaultfd_unregister() -> userfaultfd_clear_vma() or
> userfaultfd_release_all() -> userfaultfd_clear_vma(), or remaps via
> mremap_userfaultfd_prep()), the userfaultfd flags and context are cleared
> while the poison marker remains in the page table:
>
> mm/userfaultfd.c:userfaultfd_clear_vma() {
> 	...
> 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
> 				    &new_vma_flags, NULL_VM_UFFD_CTX,
> 				    give_up_on_oom);
>
> 	if (!IS_ERR(ret))
> 		userfaultfd_reset_ctx(ret);
> 	...
> }
>
> Unlike write-protect markers, which are resolved by change_protection() on
> unregistration, poison markers intentionally persist after the userfaultfd
> context is reset.
>
> Once vma->vm_userfaultfd_ctx.ctx is cleared and the userfaultfd flags are
> removed from vma->vm_flags, uffd_disable_huge_pmd_share() returns false and
> page_table_shareable() in mm/hugetlb.c considers the vma eligible for sharing
> again:
>
> mm/hugetlb.c:huge_pmd_share() {
> 	...
> 	mapping_rmap_tree_foreach(svma, mapping, idx, idx) {
> 		if (svma == vma)
> 			continue;
>
> 		saddr = page_table_shareable(svma, vma, addr, idx);
> 		if (saddr) {
> 			spte = hugetlb_walk(svma, saddr,
> 					    vma_mmu_pagesize(svma));
> 			if (spte) {
> 				ptdesc_pmd_pts_inc(virt_to_ptdesc(spte));
> 				break;
> 			}
> 		}
> 	}
> 	...
> }
>
> When another process mapping the same shared hugetlbfs file faults in that
> range (hugetlb_fault() -> huge_pte_alloc() -> want_pmd_share() ->
> huge_pmd_share()), huge_pmd_share() walks the first process's vma, finds its
> populated pmd table containing the poison marker, and shares it into the
> second process.
>
> That exposes the second process to the first process's poison marker. In
> addition, if the first process subsequently unshares the pmd table (for
> example via mprotect(), hugetlb_split(), or re-registering userfaultfd),
> __huge_pmd_unshare() clears the pud entry in the first process, causing the
> originating process to lose its own poison marker while leaving it installed
> in the second process.
>
> Should the vma or ptdesc record that a poison marker was installed so pmd
> sharing remains disabled for it even after userfaultfd unregistration?

Thanks for the report.

This looks like a valid concern, but I think it is not introduced by
this patch. Before this patch, VM_UFFD_MISSING did not prevent hugetlb
PMD sharing, so UFFDIO_POISON could already install poison markers into
page tables that could later become shared.

This patch addresses the registered-VMA side of that problem by making
hugetlb PMD sharing disabled for userfaultfd-registered VMAs. So new
poison markers should no longer be installed into shared PMD page tables
while the VMA is registered.

The unregister case seems to be a remaining pre-existing lifecycle issue
around PTE_MARKER_POISONED and hugetlb PMD sharing. David previously
mentioned broader poison-marker issues and prototype fixes here:

https://lore.kernel.org/all/bb72cc2c-a46a-44f8-99a2-b036abfdbd26@kernel.org/

So I think we should wait for David's thoughts on how to handle that
remaining case.

Thanks,
Zhe

