Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFA6CD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 09:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1E16B00A0; Sun, 14 Jun 2026 05:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84FB6B00A2; Sun, 14 Jun 2026 05:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A476B00A3; Sun, 14 Jun 2026 05:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8F616B00A0
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 05:28:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 537641C3DC7
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:28:13 +0000 (UTC)
X-FDA: 84877992066.05.33FB2A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id ACC9B140002
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:28:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LuvD5wtl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781429291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJeMLnJVlGg+3yFfYY8ewvq+lahUXEA89ZCMNVqQriI=;
	b=DHfZIkbgLX5rMxoklObah5c1jrdKnpyxsyynWfxOw5EUPzw9bO0bHYtXHm8Ny00f8BfNij
	muFq06PlGGLoM8KlHvumit/abYzKLVVwuewUBPpX1GA3ueLlZ5YFxfkQRilA3B/0H9Ib+l
	bHVv8P1YOzranUBsyIEnOeWUhorlReU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LuvD5wtl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781429291;
	b=ewab5Z4g0E/blwT6/HxCQiGEVj2OhYTQ/fjjhzpJppPUWeEfd9RmKmtxmBHtvIwz45P23k
	0deVy5mWH1CMF9b60duEFvoixXEbk8yrPkLE2RjPhdgtLN3cij6Ll7lAlgAGgKs14z715j
	rwgrBdV73v9Se3z8r1QDqHQlLYzi19Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D19E543B27;
	Sun, 14 Jun 2026 09:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7E91F000E9;
	Sun, 14 Jun 2026 09:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781429290;
	bh=IJeMLnJVlGg+3yFfYY8ewvq+lahUXEA89ZCMNVqQriI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LuvD5wtlvmMDVWxQCRAKGP5Fk5Ua91zWTtmgGiEjyZl0naJm7QD2bq1IQErR3g4kx
	 5g1lq7n1S4JCN4MRC6H+pQfs6eWEWioGavXdi6/0+bma0C5rW5da6/fu/4xwuJvgKe
	 HzrTO4ttBCMkPgmdrFGCy/9oPvg6teWpN+L63Kw6eKG2HVCgK98SQ+ophIaIHfzCGU
	 iqfBrIBYurBTrCX4cmqNgI4Boz6FhWb39R+bblyb+UeqldQesf5cc1GFb79FuOhPzP
	 /+UhXK5vXox6n9KKV/D05ZUh267keaN2trcOykJqJLq99QW2h1NuPfnmYaqWvYKGCV
	 0pIzPn9odMx9w==
Date: Sun, 14 Jun 2026 10:28:02 +0100
From: Will Deacon <will@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: Add ptep_try_set() for lockless empty-slot
 installs
Message-ID: <ai50IpfcvBiTZ7Ss@willie-the-truck>
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-2-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522172219.1423324-2-tj@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ACC9B140002
X-Stat-Signature: 1rkfqmmycc6pum6wftjmi6niy1fjpjjm
X-Rspam-User: 
X-HE-Tag: 1781429291-623732
X-HE-Meta: U2FsdGVkX1/kNmbq/o8h4BzNxNrRdQ3v0YixE8x9qISuocYa+gTReg9DSoSq6sdbkeCNN9y1LXtNq8gcz+E/IWTB9ubzT2+hW1gcvrhsZtNHXqb6h5akpySaoX3OTPDq3DqPdwN6UCqdggaYybvheyBqgImJurIAntgQPGhtECaEOklmfXL7kCjZPs5oRGxOZFzIyo2e2Dz+YNXre7eje7oJ9FJ3ocYeYHF4h1QP3uvGXq61opJTxKiC0n+Dmo7hz7+/GTx8bePa4qI1a1AHOizRKlpzz5Bk8G40ZMxyz7zf663e3jmoV1a3NJHNGKg80MGA8f70OLYYMKtEAOd/1t6JnGDO0LW7gu2qpGs2f4oJ8D4Z7edtqcbBZJeBlZzF2oIWV5bzCaCOWjCdP9tzZl9GijmfztIPr0b0gHV7l6EwQkKrz8CsnXuWTzpyvA/slDDiwozQUmHiN6dmTQg1RPP7ZIjIMW+LSs3iwaA+0fFBRIYp2CpOzRKiUp9gETU14l8PihdCVozaoTHvaRg1pCxDUY4Q+VSD1yakpohpvTmQScDZYnkUFwWd33PPr3+mUnl9vkr2tg9sDty2uY4wbQDeGo185UB1vusqtMP977Or5oZl9qj7qQ5DrFFfHQAFjDmf2H4TFU35y62CjYeUlkctVui2ZeJjLZ5PClPB0CVJMz9VIX2Nl+ps+LeBV7ZcKOZNhbAAFlkeAWP05RXSUXnur8OQ7EiPOiOd/A74D+rvsC7DBqRm3l6fpzlaRH/FtdXNgoKyhbol6Bcbi6zrNyVFtJVG/P70h6xa13OA/XDewFA7S+edBQn+4F2juLUqartCzji4rive+1EFgiRsVcOjSaqAHyh8ODm1Zb6rIaPQXBW6oFqXbE+Peh9sdvZ5IQoJlQdm1GHir9EOgs3SXIE6KNSH/MWLTDW9gA2/ljcZPCYIMu0rFDP2TnyOHmBKAxwzqfYLKdrp2PKdanB
 GzRF8hl5
 z1BD6SQGqMguvzOYxqZlX86+FOndyxU9ldJPNmAnulCpN9qKLWDJVaBqeDznscCvFYeeNxcfCeLFN8wkTllLOhwnwXjv6b0fjPFiF98hpFIKeJLOeplYIcYMBgVfCHD8uH4OhM5K/8ewj57hGrPUSCXoiDyGoC6uVt9lM7ourOO4BEXpe/Pr/tc1Hu/cc+D9iL2SJLKkWo2pYZW6BezXFIA89D/C1OyNhTSUeX6UkziAyKMHRmHGKHwzq5zWu4550UjJUfdY1TNAsgU38lKOIfmEr9NEEDjZzcMMMWVe4OCRteO5WbJP25xDmp9Qem0JEhfUDzMS/BwvN7WzoajZLac3MdRlcYodf8qtEWqg7F0KzL0MpfwWCC/dODA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 07:22:12AM -1000, Tejun Heo wrote:
> Add ptep_try_set(ptep, new_pte): atomically set *ptep to new_pte iff it is
> currently pte_none(). Returns true on success, false if the slot was already
> populated or the arch has no implementation.
> 
> The intended caller is the upcoming bpf_arena kernel-side fault recovery
> path. The install runs from a page fault that can be nested under locks
> held by the faulting kernel caller (e.g. a BPF program holding
> raw_res_spin_lock_irqsave on its arena's spinlock), so trylock-and-retry
> would A-A deadlock. Lock-free cmpxchg is the only viable option, which
> constrains this helper to special kernel page tables where concurrent
> writers cooperate via atomic accessors.
> 
> The generic version in <linux/pgtable.h> returns false. x86 and arm64
> override with try_cmpxchg-based implementations on the underlying pteval.
> Other architectures get the false stub - the callers there already fall
> through to oops.
> 
> v2: Rename to ptep_try_set(). Tighten kerneldoc. (David, Alexei)
> v3: Note that strict-zero cmpxchg is narrower than pte_none(). (Andrea)
> 
> Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Andrea Righi <arighi@nvidia.com>
> Cc: David Hildenbrand <david@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
>  arch/x86/include/asm/pgtable.h   | 12 ++++++++++++
>  include/linux/pgtable.h          | 25 +++++++++++++++++++++++++
>  3 files changed, 49 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 9029b81ccbe8..28bada97d443 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1830,6 +1830,18 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>  	return __ptep_get_and_clear(mm, addr, ptep);
>  }
>  
> +/*
> + * Note: strictly-zero compare is narrower than pte_none(), but the gap is
> + * harmless: a fresh kernel PTE has no software bits set.
> + */

This comment really confused me :/

What is a "fresh" kernel PTE and why do you specifically call out "software
bits" if the CAS requires all 64 bits to be 0? Why is that narrower than
pte_none() given that pte_none() for arm64 is:

#define pte_none(pte)           (!pte_val(pte))

Will

