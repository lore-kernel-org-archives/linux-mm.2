Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5692C606A333
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e0PDWy3U
Received: by kanga.kvack.org (Postfix)
	id 5C6846B05B1; Tue,  3 Nov 2026 03:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E926B05E6; Tue,  3 Nov 2026 03:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4C76B05E7; Tue,  3 Nov 2026 03:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224BC6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:11:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A44E314030A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:11:22 +0000 (UTC)
X-FDA: 85393088004.20.694F925
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DD0D9C0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:11:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e0PDWy3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQHiBdI0xyIEIllcHZs0yInsfxeb9r5VLhNWBGTa1x0=;
	b=CaM3guEoZt9MdZXKePB93QSwv+RpgCnC+OCD4cG7vsu4h9lJYpLwr71A9q/TgGpzdnrMnR
	ZwPcY3YevIqgvVcTS/4fRbhxk2W8dBojVKNQlzPSnfh4KMlN7fSokLqxLWErrGS60eUjrL
	2kXYr3dRtbzH8rUSBbWCPhCNq433Yas=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e0PDWy3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693481;
	b=R5Miuodx0zoIB/qXiEkq/+8QA0KYuCbVcVv2uXfGypmG17guEh9Yx7Raa03CEes9KImj/G
	Z3Hf4N/xCHncngomObkwGv+T2bRT2hw1mGyuaJW3Wq024b6L9kJjVLQHGtLuE0XPqqnCoD
	BVpcn5OgDPOpKs7YgLa/EPLPCIVtkVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34FCA417D0;
	Tue,  3 Nov 2026 08:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B821F00919;
	Tue,  3 Nov 2026 08:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693480;
	bh=NQHiBdI0xyIEIllcHZs0yInsfxeb9r5VLhNWBGTa1x0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e0PDWy3UxP/kvsGnXi328Pmi5xYrEFKmIm6BqK3JTDHYPF2tY3FoTK3QubpCeYr3F
	 l4oWg2OGY045IW9TtLzS46o8lWfHIL4QT7Ane9Ss5goUWsEPx82gTQyuFwMNgSJtVs
	 6M8Q4c//MKDtw/y3RK9ZpNNBZ9mHPdj0aBt+E9xk6hxDG9yYuJOVYr8Gpopn0voKmL
	 kAjxFci0tl/J/xHJEx9tO8vvhezHhrzK8+rzrCH8OmKa4+YLT0VtYOVGPW1tpl0SfK
	 fdFAJFE3teyviBmhf4zgRc6RoqfIm1Gq4udjutOQHlSb/yUI6NhTJoX5VCpGB2FLpm
	 6ql8XWecvmK2g==
Message-ID: <15b36696-91a0-4128-96e2-e2931a858f73@kernel.org>
Date: Tue, 3 Nov 2026 09:11:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory: use pmdp_get_lockless() for the pmd read in
 do_fault_around()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20261103014749.96764-1-hui.zhu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261103014749.96764-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD0D9C0003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: ayhua9nhba51n9r48afaumujgaus15pz
X-HE-Tag: 1793693480-973008
X-HE-Meta: U2FsdGVkX18syBm6j7l+nRVrScD9DS26k6/T+AdjQtumw51GFNH/+Q3nv5i1SslIWmNyDRS8ZQf/GAuTs6dY3CaGcqRrFP5JZr54DrZ2450IUVrjz09J90t0gYvzcGu3DR8xelZ6jC0uKVFd5FrvKiDwpuxQx5m2b50uEZ9OGDeuebP3+nfycCk7lEzYSz1bMuSK0uWxJXNLQxmfoE3AQ7V7U/UlP59alrZwuZFVtPzlKHBeXdWHmKLpF2tk9nlarykoggJLK7m76JWkgLTExiKDVsci1mMlaFtjSY57rihSHmtEBzQnD0FcMcw2HIPWdrGA4ulea5KC4dkmZ0IYVM1kq5yoNqPuRyXc8SXYPlcwqa7d9cICL8udsqKP6WSqJp3DMm64wQNiXEZffni1KcAfmXwHeCQweFGD+8M/jU0jIhXxezmKc1eDllgv5DB0QTTe8dKUTdmfhDYAHW8hd67QLeS1/bzw4QV7NesokxgdjtLv592CQjV9ErOL/lxItPCpq5UaQKOwHgnsWQYSBu98a9lkkK0N2548TzSs6Dpm7lpjN3zFY82/0Onm3RKrt7qwI9O5T3D7b3eKoEwQ2tETOu9LLPcJ4kdaIBRFPr8YM0ZwxDxUsLRzlgSzRgsNWNbwzubcf89aTxOgJK7gnlN4ya0vCzU4mkfQ7pwUiuPqXCw0+zdXRgLC1nk36YCdY7WM2GHYRFcAC9hlk85e/859R+zeaT81idN9InNN+RuCbsA2wmAe8GEgc4tsUEPoqb4cKJm14k8ZxL/1mkwbavtL8dJ0KlTtFAteCLgSO3j6vC0p2X1NQJD/3J7IJ/Ul0tlQP3qAjQs+xZMTPJ96hv7ZQUejcl9CUppyRG9JYxRKHNS9LlOh1plWZVhaDQFGGuKPRAolcf8g/SDLQeeGwbs/NEY4gz+Jl4MYLBsop21/Dv0QAeehAAxuILKaKAZleZyVhlfqIQzBMh1bjjK
 1tU8701B
 hHJ+ew9zDF6/Q1jK0/7+bxaQEJt6tB2VULuDqIa1MunokY8a0OkZt3XlSQeUaJljdlwR3ZBKm6+HWR/8J7B6aC5A/Zp7mL3fdYZN1BNMnpJ+r2iRyHWnmkeikkjIIKz2Qnedx8M4RikvgrY11IP04KFp1Le/RmaB2udsLTwbR+eFhLN0MBh+BSzNE8trVNuOo79j9aKDRERDyxRoiCIRh6WQOfrV5BhgYP8JZKUS9Ex7G+QwNuyqVFButcnHTLXjdQVnvTjD97W/HtegU9sa9i7FzDr+AcXA71D0Xsjbe2M1+rvsJcWLR5b7hug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 02:47, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
> is in mainline:
> 
>   write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>    native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>    pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>    pmd_install+0xe0/0x120 mm/memory.c:444
>    finish_fault+0x5bc/0xb00 mm/memory.c:5204
>    do_cow_fault mm/memory.c:5432 [inline]
>    do_fault+0x5d0/0x6e0 mm/memory.c:5526
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    __mm_populate+0x144/0x270 mm/gup.c:2207
>    __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
> 
>   read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
>    do_fault_around mm/memory.c:5341 [inline]
>    do_read_fault+0x162/0x670 mm/memory.c:5381
>    do_fault+0x31a/0x6e0 mm/memory.c:5524
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    faultin_page_range+0x227/0x530 mm/gup.c:2156
>    __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479
> 
>   value changed: 0x0000000000000000 -> 0x000000001386c067
> 
> Both paths only hold mmap_lock for read, so do_fault_around() tests
> vmf->pmd while pmd_install() populates it under the pmd lock.  The race is
> benign: a stale pmd_none() only wastes the prealloc_pte, which do_fault()
> frees again, and a pmd seen as populated only makes ->map_pages() find no
> PTE and do_read_fault() fall back to __do_fault().
> 
> The load still has to be lockless-safe.  pmdp_get() is a plain READ_ONCE()
> and can tear where pmd_t is wider than a word, as on i386-PAE where
> pmd_install() publishes two words with a single cmpxchg8b.  Use
> pmdp_get_lockless(), the accessor for pmd reads without the pmd lock and
> what __pte_offset_map() already uses on this very pmd a few instructions
> later.  It is pmdp_get() everywhere else, so the report is silenced the
> same way.
> 
> No functional change on architectures that can load a pmd in one go.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v3:
> Shorten the comment to one line (David Hildenbrand).
> v2:
> Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).
> 
>  mm/memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0fb676dd2bd63..f25c2ce0ef153 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>  	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>  		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>  
> -	if (pmd_none(*vmf->pmd)) {
> +	/* pmd_install() rechecks pmd_none() under the pmd lock. */
> +	if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
>  		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
>  		if (!vmf->prealloc_pte)
>  			return VM_FAULT_OOM;

I'll wait for for review and then pick it up.

-- 
Cheers,

David

