Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343A6CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4FF6B0088; Fri,  9 Oct 2026 16:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE1D6B008A; Fri,  9 Oct 2026 16:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15AC6B008C; Fri,  9 Oct 2026 16:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAA466B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:43:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48A5BC04EB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:43:14 +0000 (UTC)
X-FDA: 85304262708.25.88B0CDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8DA111C0004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:43:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SP23AZs/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791578592;
	b=THYrxsNoLNCQhidU6Zk33hGvv2w+fifPESkGqJgIrdBGHQMnO7yoNbEe0IAHUEOzTUSeIG
	XI1SuzVv6AV0iWmqCeDVt8rlExy3bR22INu4oNPqEZnz1ToyVvFY72lGUtKcQOaFHMTZoF
	bIqMsggCrnkUu2uTFv3w1nwm5KQGIeA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SP23AZs/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791578592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxCU4kgy6yuLL3vMKMbNFEILfGTC3AEpOEg/HFNIu60=;
	b=rU695Y3buTKdDheIPm9SrRUxnkCjOgNqr20uqsMRaTsdK9h1aELshGR2j1ri2ktg1vvdEf
	+8jAUDAXtIXAGFXJpz/g5ZvYaoE+boVZvOyLWNRzRcbhhjmah8lPahWUWkk6pbayt5uGXv
	1tFfIBUmpXPEbgING4p/s91FFJZ5+WI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1995060202;
	Fri,  9 Oct 2026 20:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA6F1F000FF;
	Fri,  9 Oct 2026 20:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791578591;
	bh=JxCU4kgy6yuLL3vMKMbNFEILfGTC3AEpOEg/HFNIu60=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SP23AZs/ZMLS1F7HAiY5z7X5nF2RAOysCWRarEHnTfxNiZ6ItX8IcZVYkiT3Xyrzw
	 Ts27Z3REnfSbgPcmeCHEvXQfI5R0zszY/WgI7oNDs5Uuk4RtQelzpmDtOVb/O1mgbC
	 ESJ+fGuVP07bnVnyI4wWN+oqUM/udZKJQpOIxZ7jC0KEakCwnj/veq68QxurhH1xPa
	 x4QNtZRPeZ9Z9OSE+fx43CSrHusaCl/LHAxjU2JLx+s5fnC628xxa9yw0FVkBWzqfI
	 F/V/SeQf2YozHcliqBqzshsNtBivlYnNq0VSVj9gwdZur95pXceUhTxA42KBjet0PE
	 DuKW2pGkIo/aQ==
Message-ID: <d47bdf83-1db4-4601-a516-7e23488ea9cf@kernel.org>
Date: Fri, 9 Oct 2026 22:43:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] arm64/mm: fix destructor for unconstructed hotplug
 page tables
To: Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, osalvador@suse.de,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
 kevin.brodsky@arm.com, bjorn@rivosinc.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-5-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261008073021.2512665-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kqikjunx1oq4puhsuncgtpywb4gkkrcy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DA111C0004
X-HE-Tag: 1791578592-734998
X-HE-Meta: U2FsdGVkX1/LLzmtW4SBMRaEbsVuyugvT2UtzHOV37YW4P2pS/KGiI1KOrUQDm2Xa2P3YKCSMc5vGWif8FBDdD5I9RNojcbkENTKpTVo24TuSUl23bxs3gMJ5vv+La1jooz5Cr4g2as79k+yY19tFdIs0TcujdZiIQJ5a/8OvIyzz4tWPndpz4qDpc/dcWTa9dvVSXZcBL3TFEa+coo9F3JLqCsIBhfZj0D817nz71hrHHd8L9Chf2RuAGrKBJZ6P2VDi2oMxN8RG4X2TtHCOZYM6xL+inPo6alsJ9jvwiOrIVB9ZX6TFSzaT9kweVuvY75t6tnNfUnQOkCPYFPpVAJfZ7hlG6LQmCljckygVJbSktJhSJqvMyjwXl6ZNBOdFvgoOQIXAiJ3WuicjHWDAPWCQ56YmpYP/XD+14A/pS6nvW+QLBRJSIHyebxfon9OjpAZCmEfbx5caCNzy1Zpgv9Vf6gfAAIwaR7DSvdUVfumzGZOYdAktxGi1/ySv39JjjsbPC8JFRTRCUmWpvOslEn72N46ZBsl3vpRK0BaK7p9bExQjRtcrlAfeQhVAZp0bAuZvNePkxS0fewcf8yiizUqUO9L2fxIYersZT/5ygIDuFM38u+aeZMYH8EIEht3FjS6WNeNB8qOk+Ux9eHU5C6hSNH8v+CInJ7JQOJaqwecZXrMvOgJ9iKvvhcV9+hekv217V8vK8yrFB0gBYFpOeqLoZINiOPmXGgKyLLQ0kPj+gAbVpm8iO3If85Vq+yMtIayhh+mWWO6WbywjGz7CoMxjHYhbV4IpKAezp5VtE9A9t1HZ7DjWN75DlvAlmL14uHZHzk/dIwLrLJYSypiSFRnngKmbPzO8F/GWwHYAyMUcmuBft3LBnqIa/m9RBZUb6tJLl79utGmqQjJjm+l0YrR62Kf7Oka5qqGfFDFQpelkhjUzJYNxsVkpwiguskJu1D/4z2oOrddX2HpdH0
 0g0x8OSp
 NvQMHsrPS5UlK5fXL/ELhwjogdo0oiufK8XexW3HuAsyJJerkc48Za8SbIuStT5h+ea/D1+PIrsoX/aIvgQIXv+eHTeyV5yLxNEo3q9ChkC+lnwMqMvlkxSrzf5y8vlfH8C+zC+v7rnIJqk0l6PSbXCUoUpzj4CNQuHVk1Ab4SZ4pJExzv9DUAbI/qijyyaClj86SrxXUba5onduYHC7o+ZMPYc5HyG1CHRJ2/+uo5/E+Cj4TfdBjBnzqLMxVLBg++KbMzqeDOIZ0Wllm4gzg8tLGLh74w+rZoi2nz5UJFFt36nzZZcWnZSmlKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 09:30, Muchun Song wrote:
> Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
> hot-removed page tables") made free_hotplug_pgtable_page()
> unconditionally run the page-table destructor. This matches page tables
> allocated by the arm64 mapping code, which runs the corresponding
> constructors.
> 
> However, arm64 also uses the generic sparse-vmemmap population code.
> Runtime intermediate page tables allocated by that code do not run a
> page-table constructor.

Why do we have that inconsistency? It seems to cause pain :)

> Freeing one during memory hot-remove therefore
> runs a destructor without a matching constructor and corrupts
> NR_PAGETABLE accounting.
> 
> Use PageTable() to run the destructor only for page-table pages whose
> constructor initialized them. This keeps the arm64-created page-table
> lifecycle balanced while safely freeing constructor-free vmemmap tables.
> 
> Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing hot-removed page tables")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/arm64/mm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 7343ac9294f8..688b33095651 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1495,7 +1495,8 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>  
>  static void free_hotplug_pgtable_page(struct page *page)
>  {
> -	pagetable_dtor(page_ptdesc(page));
> +	if (PageTable(page))
> +		pagetable_dtor(page_ptdesc(page));
>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);

That results in a __free_pages() for  ones allocated by sparse-vmemmap
population code. Are we sure that's the right thing to do?

This is all so inconsistent and confusing :(

-- 
Cheers,

David

