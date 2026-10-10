Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC26CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 06:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9ADA6B008A; Sat, 10 Oct 2026 02:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B706B008C; Sat, 10 Oct 2026 02:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A0E6B0095; Sat, 10 Oct 2026 02:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62C4D6B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:38:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A2E9A07A0
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:38:12 +0000 (UTC)
X-FDA: 85305762024.26.E9ECCD2
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97439140002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:38:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jB9Fyvqd;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791614289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEZ9kNVs3FLih4w7q04wSSL1EKEuCKqTB4w9IOg1y2w=;
	b=7dm1I1dQc/pgATR8w66OD+byX91yV3PGARe2gTKNgF7R0OPfq7nMeTFqg+mq6WuLGikDIA
	6mBKqburS0qlPV+XcD0uddVd/uU+aCJxpOAXARkhTt1qeY8v1eQVbokX1r4z2xaeTk0uJz
	8WNvyopIzx8IVZ1JQLIGl1NEWV+utd0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791614289;
	b=cCfzj/cI/nX7303sQMBqRO3pVpdTJ0Bc5WtxgvNRANWlbOXzTPIwZ41iS4PeW/1157BsDZ
	qBrUAKAA6Yt9e4y7GVLJHf7kTY0Y3evsPjbAq93ZNXaiIh+7v+zakrF0IO0azEcQ0HjjWx
	2xekW7d7kR89MB6ioY9EohCD/RKlm28=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jB9Fyvqd;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791614283; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=gEZ9kNVs3FLih4w7q04wSSL1EKEuCKqTB4w9IOg1y2w=;
 b=jB9Fyvqd6RqyhpSdW85SivXeemIVq79I9saxVi3UJu53GQ0pI96qZ777rOu7u9uzdrZznE
 /PxzxZ0GLwuK24xoS0HRbWV4zyCdN13vf1MTeZNUaU8wbR2iLOuGBYmumL2YYx7o1DWHPi
 4R9mteazauYa5Rr5peZLWU4M212GWJtJHL23L0ikiuq0tx5jHdQXrQa0Bu1q2hA0TPhMvg
 TivyHRv18083Gh0Vzxbe6wfYAGNXvhNRICVezdcb8RmQfbCN4ahLrnIQvFmKAo1SpYZZd3
 9fk6EwY7YUirQ3G6ccTlGFqdu3Ba4Okxw1SvlgcD6+U6IpvcXh7YOdzIrINhKw==
References: <20260930064308.58159-1-lizhe.67@bytedance.com> <arzVaC2IYkqSb0_U@gmail.com> <9a7c026e-f5f2-40e0-84aa-919c988cc136@bytedance.com> <2b4571c5-8e51-4c91-9d88-11929f200875@kernel.org> <asjVUa6XBZ8ti-0_@gremlin> <70ea8ee6-6fc5-4209-8cee-362da37f5035@kernel.org>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <70ea8ee6-6fc5-4209-8cee-362da37f5035@kernel.org>
Date: Sat, 10 Oct 2026 14:37:46 +0800
Message-Id: <ab1577d2-a9ce-41db-a632-8e25652dab31@bytedance.com>
X-Lms-Return-Path: <lba+26ac9dd49+98d4cb+kvack.org+lizhe.67@bytedance.com>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH] mm/hugetlb: avoid recursive i_mmap_rwsem in PMD sharing
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Mime-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 97439140002
X-Stat-Signature: 116ziz9ke7dc353ixcaeykm1gsoe34xy
X-HE-Tag: 1791614288-150293
X-HE-Meta: U2FsdGVkX18UMZaSFCqmiYVV3eqzdi/4sFpSt0e+hKQYJ6u1Iw9D37Mbxf6vKmebERi9SMJrd+z6Cdx+m7baJQ7wmhsserQJ3K44k2rlYfBGcOQKMWsykiq6xhZokBvfU5IybVXhPZIdjgYYCB+DaJ2nVSyjB+59BFpCzotM7pV45UH04fzAWt+US145PTRv9Gnd253DxGE/UxuE9qhgFCbCPnscNAjjfTgW1BUtUVMb5Eg1+noihPZVexhTFc1JCtzUW/beBamI5Dp2ziZrzit2sBaBMfQ8j574sSrYAp27L8zrrH8bhEjJ9M6HggL/oH+oAT0FVDBpbgsAZFdd1uPBDuyTS8sk8gGQC8eb6HPI6x0SuIhRVR2uZxUqPTSny065q7lSCorrz10NbsV9Ct4bxt3UYdFyFt1K9zTfIXmECgzPDP1BHS9NGeFBcD+k6jXmEYnQ1unIPiW5p5L2E0PiVT8lc4m1ULtAA/22wTKKwd4Ph75ieUlYX1qgWixqgzQfk2l04fkFkiKL+okWj+rDkrUNLSdmD3Da/3Z6kXHhHS4k5ZIuLg5rtAd1BlGH5EIrP0d+NFnFebn/s/mMFJOkl1fhHJdl3dSB8nOGkBTcpibM32ZQfi5arOarrXneW/c8jmmFhmy8xdUDqRZ0hMrapipC4JmEGune0CVcxslyafZtgj7yQwsZQRwirC1/e71ijlM8MrjTtGRnVVec9WqRpr+ZlpB0VwkMzvLWiJ3xqt+BLo1cJV/5PlHZR79LNG9XE8is13nH0UWS30fGjef0n5F/XfF0lCHkYBcx3qGmXx1Y6PzySVgzsBu8TofPt0YxpGaVCSvHsSZexRkdTAX0eVR6f1yM4yH1OgR34bfKqVmo223fCau4jqdpG42lRj+jp07G9gwPxyTPWD1fWU29YeagupjHREEH0zvSNGGhlEo+H0FXZu6ZvSHbpmEc83xQziZ06r+FpeUw1a2
 JAvO/fS0
 1uLV7qaMhcT8tn+NpuiOQ4kIBFKG7x5O3KQyrMNGAZpcHNKotu55o25tqbBg7Bk6XtKKcEALOIEBMnkEpZ9suaC0SuLaipuYbIKuD7TaIbehXns7vylsDKqRT5rtPNwxjHuDdAVn+2afS85LufVuUWGy06ceha4hbpEKNILX7rM33xZsapc3bTPN113SwwYIn6cohIZ7EcByfniRIp2vi128Gf/Mvr5hPkCxCqTd9KpJOt/vPslhkKDWo5sZI06cXjxzbl0H2tpK/QXH3JQBU7HEDy+2HhhnjxwQGI9yCMQYzcGmkgoXgCH1oCqZIRPJ/9O9yoKkF3mh7NmoOSa2QK8mn/sG/qiKejNlR0ba/4gYt10umudv7EszRnpF5YmUR8gWJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 2:05 AM, David Hildenbrand (Arm) wrote:
> On 10/9/26 13:52, Lorenzo Stoakes (ARM) wrote:
>> On Mon, Oct 05, 2026 at 11:25:01AM +0200, David Hildenbrand (Arm) wrote:
>>>> David mentioned that Oscar was planning to send a proper fix for this
>>>> issue, so I will wait for that patch instead of moving forward with this
>>>> trylock fallback approach.
>>> @Lorenzo, if Oscar is too busy, I guess we can paste the overall idea for the
>>> fix here as well (publicly)?
>> Yeah I don't see why not! I don't think there's anything that needs to be
>> private here.
> Li, see below, can you work with the below?


Thanks for the patch. I tested it with my original mremap reproducer, and
I can no longer reproduce the hung task.

I also checked the hugetlb_change_protection() / uffd-wp path Jose
mentioned. That path can reach hugetlb_change_protection() and
huge_pte_alloc(), but it does not enter huge_pmd_share(), because
VM_UFFD_WP makes want_pmd_share() return false via
uffd_disable_huge_pmd_share().

My understanding of your patch is that we preallocate the destination
hugetlb page tables before taking the mapping's i_mmap_rwsem in write
mode. Then, while holding i_mmap_rwsem, we only walk the preallocated
destination PTEs and move the source huge PTEs over. This avoids calling
huge_pte_alloc(), and therefore huge_pmd_share(), while already holding
i_mmap_rwsem for write.

Does that match your intended direction? If so, I will go through the
details and make sure there are no issues, then send a v2 based on this
approach.

Thanks,
Zhe

>
>
> ----8<----
>  From 9e1c0676ea6c9cbcabf91cd8badf81a9d88fd3ef Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Date: Wed, 29 Jul 2026 18:33:08 +0100
> Subject: [PATCH] fix
>
> ---
>   mm/hugetlb.c | 103 +++++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 79 insertions(+), 24 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e93c4d2456aa..88ff2c4ad483 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5077,6 +5077,79 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
>   	spin_unlock(dst_ptl);
>   }
>
> +/* Returns last address processed */
> +static unsigned long prealloc_or_move_page_tables(struct vm_area_struct *vma,
> +		struct vm_area_struct *new_vma, unsigned long old_addr,
> +		unsigned long new_addr, unsigned long len, unsigned long sz,
> +		unsigned long last_addr_mask, struct mmu_gather *tlb,
> +		bool is_prealloc)
> +{
> +	unsigned long old_end = old_addr + len;
> +	struct hstate *h = hstate_vma(vma);
> +	struct mm_struct *mm = vma->vm_mm;
> +	pte_t *src_pte, *dst_pte;
> +
> +	hugetlb_vma_assert_locked(vma);
> +
> +	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
> +		src_pte = hugetlb_walk(vma, old_addr, sz);
> +		if (!src_pte) {
> +			old_addr |= last_addr_mask;
> +			new_addr |= last_addr_mask;
> +			continue;
> +		}
> +		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
> +			continue;
> +
> +		if (is_prealloc) {
> +			if (!huge_pte_alloc(mm, new_vma, new_addr, sz))
> +				break;
> +			continue;
> +		}
> +
> +		if (huge_pmd_unshare(tlb, vma, old_addr, src_pte)) {
> +			old_addr |= last_addr_mask;
> +			new_addr |= last_addr_mask;
> +			continue;
> +		}
> +
> +		dst_pte = hugetlb_walk(new_vma, new_addr, sz);
> +		if (!dst_pte)
> +			break;
> +
> +		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
> +		tlb_remove_huge_tlb_entry(h, tlb, src_pte, old_addr);
> +	}
> +
> +	return old_addr;
> +}
> +
> +/* Returns true if preallocation succeeded across range, otherwise false. */
> +static bool prealloc_hugetlb_page_tables(struct vm_area_struct *vma,
> +		struct vm_area_struct *new_vma, unsigned long old_addr,
> +		unsigned long new_addr, unsigned long len, unsigned long sz,
> +		unsigned long last_addr_mask)
> +{
> +	unsigned long old_end = old_addr + len;
> +	unsigned long addr_end;
> +
> +	addr_end = prealloc_or_move_page_tables(vma, new_vma, old_addr, new_addr,
> +			len, sz, last_addr_mask, NULL, /*is_prealloc=*/true);
> +
> +	return addr_end >= old_end;
> +}
> +
> +/* Returns last processed address. */
> +static unsigned long __move_hugetlb_page_tables(struct vm_area_struct *vma,
> +		struct vm_area_struct *new_vma, unsigned long old_addr,
> +		unsigned long new_addr, unsigned long len, unsigned long sz,
> +		unsigned long last_addr_mask, struct mmu_gather *tlb)
> +{
> +	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
> +	return prealloc_or_move_page_tables(vma, new_vma, old_addr, new_addr,
> +			len, sz, last_addr_mask, tlb, /*is_prealloc=*/false);
> +}
> +
>   int move_hugetlb_page_tables(struct vm_area_struct *vma,
>   			     struct vm_area_struct *new_vma,
>   			     unsigned long old_addr, unsigned long new_addr,
> @@ -5088,9 +5161,9 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>   	struct mm_struct *mm = vma->vm_mm;
>   	unsigned long old_end = old_addr + len;
>   	unsigned long last_addr_mask;
> -	pte_t *src_pte, *dst_pte;
>   	struct mmu_notifier_range range;
>   	struct mmu_gather tlb;
> +	bool preallocated;
>
>   	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, old_addr,
>   				old_end);
> @@ -5106,30 +5179,12 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
>   	last_addr_mask = hugetlb_mask_last_page(h);
>   	/* Prevent race with file truncation */
>   	hugetlb_vma_lock_write(vma);
> +	preallocated = prealloc_hugetlb_page_tables(vma, new_vma, old_addr,
> +			new_addr, len, sz, last_addr_mask);
>   	i_mmap_lock_write(mapping);
> -	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
> -		src_pte = hugetlb_walk(vma, old_addr, sz);
> -		if (!src_pte) {
> -			old_addr |= last_addr_mask;
> -			new_addr |= last_addr_mask;
> -			continue;
> -		}
> -		if (huge_pte_none(huge_ptep_get(mm, old_addr, src_pte)))
> -			continue;
> -
> -		if (huge_pmd_unshare(&tlb, vma, old_addr, src_pte)) {
> -			old_addr |= last_addr_mask;
> -			new_addr |= last_addr_mask;
> -			continue;
> -		}
> -
> -		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
> -		if (!dst_pte)
> -			break;
> -
> -		move_huge_pte(vma, old_addr, new_addr, src_pte, dst_pte, sz);
> -		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
> -	}
> +	if (preallocated)
> +		old_addr = __move_hugetlb_page_tables(vma, new_vma, old_addr,
> +			new_addr, len, sz, last_addr_mask, &tlb);
>
>   	tlb_flush_mmu_tlbonly(&tlb);
>   	huge_pmd_unshare_flush(&tlb, vma);
> --
> 2.55.0

