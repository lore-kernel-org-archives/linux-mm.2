Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1FF606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nCibtCOv
Received: by kanga.kvack.org (Postfix)
	id DDC736B0793; Tue, 27 Oct 2026 10:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C656B0795; Tue, 27 Oct 2026 10:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55E26B0796; Tue, 27 Oct 2026 10:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0776B0793
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:42:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AE23A86B2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:42:52 +0000 (UTC)
X-FDA: 85368672984.24.64C9374
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B978160006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:42:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCibtCOv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793112170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoLSuofN7cQ2tWXwUvc/DSgwxulevn9ENLUaotbNxMY=;
	b=WLoSQWC97kxZZ9q5NbtV8ey4W0SNY/B3zz1cVvTyETARd7kKk3m0pXc6LVDtbnPtIBPubT
	rKF0WSmzjeU7oz7XRUj61QvYNxZVAyv581Bd3ywmo2WjtADfLo/rRC3xk0hSkIy9MKw15X
	Dd/PtVOzagr7MLrYvFtpsk8ALPaOpPA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCibtCOv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793112170;
	b=TKYv8JGTAUHk1haJLb88gZVVz+AyEepMorNwTh0p17xIDrVOUHVHJRDNbam2SRXOmLND2Y
	l+FpZbsPNPv3xJX6dY2Zc8BlFPHoZpOS0Zao8rHAJAXfEoRJgbIy4DdC71o364o8hm1Ls3
	SbhMCVseJeTEJy4+1Y5b+udd+axj2UM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8842602BE;
	Tue, 27 Oct 2026 14:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6B11F031E2;
	Tue, 27 Oct 2026 14:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793112169;
	bh=xoLSuofN7cQ2tWXwUvc/DSgwxulevn9ENLUaotbNxMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nCibtCOvcqjhtwxq9rIemKZCtHNwaNf0BlFYC+FouftiBZosSYpxUL0mYyiauWLpd
	 T2Y6UhXpbH0x1mHHjwNPbem/AT56EcTY0wEs4ibeYgTQGRswuJDpCv2LXbJ+CxbD6X
	 a3MNJHAVtaQVmSxaDIlgWzSKkR19zx+tcBS53yPUPCaggBn1R319Y+LeTJTjoPQdt4
	 U9EtvqFBnxhwsG3bg1rjQB+ZU2EMtiGPYNKf8ulZoxR+zqhKLcr7A3W4el3jE2UZme
	 ESkSApBkTcsYRn2/FolhS5eGkQDuIExsSFIm+G8gM1QCufx8s3kvrSwfMUkqaeUqZg
	 7DbTbx3UW5nSA==
Message-ID: <829f5a0f-4d9a-4c65-9703-fbf6e49d2b02@kernel.org>
Date: Tue, 27 Oct 2026 15:42:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm/huge_memory: read a special PMD under the lock
 in copy_huge_pmd()
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 Sashiko <sashiko-bot@kernel.org>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-3-66f00b7a564c@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-3-66f00b7a564c@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6B978160006
X-Stat-Signature: 4rtyqxbutozxujgqo9g93ipq9wwb531b
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793112170-381077
X-HE-Meta: U2FsdGVkX1+m59Lji8rMVKEtiY6mV+S8iaH7B1+sJYhn6XklkbtO8LdsuGvKFgOdhHzJu4nk7cMDU14Lyr7j1feuJhLCYWGzwo36CLXRZ7AWSAWbizo6fO/AgwfMta3xCYMgvwfZOSz2cvptO/FQC3tE1hfFxzKfVInQMvilPqPOeozpvS47mWmkxlzZFoouv8CgEwpeJjbOckP8wgvppS98NA9p3dZ4S8I1nTLyrFGbFcV+uTIGp7mhaRmliTWOUJ75PBEeTky/OoIbTCkO30FwgEKE0TRjxltbewoxY1tCOq9146vnZF3/RYYN86L6VQ3/R4vEbqFtfKWgMWAlBToSMhqg0oFftR1aPaptHyRYvaOeAeaCU5o91DFpyDQcZ2+haHr5qjRGULHlIUhA1YUSq7UUbZXN+qzlGjnE9hja5QA+AJ/QUdBY2sbYy4p5k2GmMJfhRKiy2xJEpsi2G9UV0AdpsmkyN8sqO5zHlYw476SepcR4QSsvuwvkV78f5Cz8pW/perolykMg0j/rmI9oOS5kwFyxQ6D141GdI9Ez3l+kceJ8PXPPO5Heltmjoh2VB9CY0rJWGtE4xiuF7xbqK8cx4yS4edqE4itJ1W1t7cCaiOgNizSqkDd0t/7lGCss22e+N86ViHBXkQnzWbsV+0bFv97CI0btiIloc2XYD8eGe8V4+ssTTOv7bvqX+okLThWFqB2bepdy/DpWKgkEs4NQ+zFKW9At/8FfGdOkqOoWDUfANivJ6iQll34ZdG4OWzT+rsY/8XTI5/AM6bm8q4kC41dXgR7UAZKvuqw3vFE5h68cAe0MAGP1nyQjrdv7r+q5zJ/7RtvKT4PdO+JkEyeO8x01uqMfTj5Mr5V4DPbAuAB+WpHSMi4NqeDwlw2uHUJc5WVRJ8ejswXG1DF2DJncGj6CoM8rEIzP+YTT5XUgF3T79MCVilipKyI+q5+nnj47o97DJMlv5F7
 ywjvZkcg
 EeacLy0U7iHB0XbRS09gLcCZ4X15vDVpeUTiIhpUtdx1Mo8Pvps9/FfSm+c94h3EeGFY0AKYT0pzH9Olzd2OVBRoH6dDNSN/1mcR0TgiO9qfhTbOV3+xWB5klIVq4f8k0XdhgDjoEO/YEh7S4KcsIUrvNBM2SExV0o1WbA3qFCK6sp68SAXU1m7tRgue9Z/JwbrdfzwEzlD33uaUo6EfzTAnLJxs6CQyPdIlA4mwyDOe2eljH06ClGRgv6O096O9IOTUReJHxWFoa28OhowbbqK93RHL9XicKoPDnCrtjUGk/vvORVBHZQfrNYyu1BXiOMyUHpWCC+XM9rwMTVOOQp0jBN//1FuAKA7EoIOcz59p9WW1/YVZUB0oZVrx+O9QKHibOzVYzZOu+LwBajsuIBXwYc21AoEMdBE1IxGxu9ON852603N/9JCcIhqYDaehKn5sXbQ2IvUj6OqCyfFYdBqg6cUu3xIfSlaRFvR/FVwzTCOroKrPc6HCPY9G6QPBtvsA/bbvO7uYYtZQ30Mdt2C3U3+jwH4PUuvfpMa3a2MRxMSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 22:36, Konstantin Khorenko wrote:
> copy_huge_pmd() reads a special PMD without the page table lock and
> copies that value to the child. The mmap write lock held by fork does
> not stop unmap_mapping_range(): it zaps under i_mmap_rwsem and the PMD
> lock.
> 
> The zap visits the parent VMA before the child's, as dup_mmap() links
> the child right after the parent in i_mmap. If it clears the parent PMD
> after fork has read it, and passes the child before fork copies it, the
> child keeps a mapping the driver has revoked, for example:
> 
> - vfio-pci: the child reaches the BAR after the device memory was
>   disabled or the device was reset, instead of getting SIGBUS;
> - panthor: the child maps the pages of an evicted buffer object after
>   the driver has released them.
> 
> The same branch deposits no page table under the copy. ppc64 in hash
> mode keeps the hash slot array of every huge PMD in that table, so the
> child dereferences a NULL table on the first hash fault, in
> __hash_page_thp(), and on the zap, in hash__pmdp_huge_get_and_clear().
> 
> Take the locks first and let vm_normal_page_pmd() tell a PFN mapping
> from a folio under them, as copy_present_ptes() does with
> vm_normal_page(). The zap clears the parent PMD under the same lock, so
> either fork finds it none and skips it, or the copy is in place before
> the zap reaches the child.
> 
> The copy of a PFN mapping then goes through the same tail as a folio:
> 
> - it gets a page table where the architecture needs one;
> - in a shared mapping it is marked clean in the child, as a PTE is;
> - in a CoW mapping, which only VM_MIXEDMAP allows, both sides are write
>   protected instead of a warning being printed.
> 
> Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
> Fixes: d1503aa9ab80 ("powerpc/64s: Add support for huge pfnmaps")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  mm/huge_memory.c | 24 +++---------------------
>  1 file changed, 3 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 13e3674fb6115..da5918a0ade87 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1961,25 +1961,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	int ret = -ENOMEM;
>  	bool writable;
>  
> -	pmd = pmdp_get_lockless(src_pmd);
> -	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
> -		     !is_huge_zero_pmd(pmd))) {
> -		dst_ptl = pmd_lock(dst_mm, dst_pmd);
> -		src_ptl = pmd_lockptr(src_mm, src_pmd);
> -		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> -		/*
> -		 * No need to recheck the pmd, it can't change with write
> -		 * mmap lock held here.
> -		 *
> -		 * Meanwhile, making sure it's not a CoW VMA with writable
> -		 * mapping, otherwise it means either the anon page wrongly
> -		 * applied special bit, or we made the PRIVATE mapping be
> -		 * able to wrongly write to the backend MMIO.
> -		 */
> -		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
> -		goto set_pmd;
> -	}
> -
>  	if (vma_is_anonymous(dst_vma) || arch_needs_pgtable_deposit()) {
>  		pgtable = pte_alloc_one(dst_mm);
>  		if (unlikely(!pgtable))
> @@ -2021,7 +2002,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		goto copy_pmd;
>  	}
>  
> -	src_page = pmd_page(pmd);
> +	src_page = vm_normal_page_pmd(src_vma, addr, pmd);
> +	if (!src_page)
> +		goto copy_pmd;
>  	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
>  	src_folio = page_folio(src_page);
>  
> @@ -2061,7 +2044,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	}
>  	if (src_vma->vm_flags & VM_SHARED)
>  		pmd = pmd_mkclean(pmd);
> -set_pmd:
>  	pmd = pmd_mkold(pmd);
>  	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
>  
> 

Looks correct. Reading the above, I wonder about Cc: stable. It would affect
v6.12, so not too crazy to backport.

We'd have to backport patch #2 as well in that case (or have a simpler fix, but
I am not sure that's really worth it).

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

