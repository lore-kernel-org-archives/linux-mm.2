Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACD9CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 16:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884AC6B000E; Thu, 27 Nov 2025 11:57:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D026B0088; Thu, 27 Nov 2025 11:57:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7994A6B0089; Thu, 27 Nov 2025 11:57:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 692276B000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:57:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01F37C0218
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:57:13 +0000 (UTC)
X-FDA: 84156992388.06.570FDC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 381D34000F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:57:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764262632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TxhYQLxHx8Y/NBwByNSBoA8AyO0F4q6taUvEPDCbEI8=;
	b=1JdqVLVbMu/SdADwYdFSF3EgJhT3ls4th05G/GMcMqMtaDN3fPBaZk++g1bJC2go/cd9kt
	k3es2M/icLthFrAolzY4tv4QBSHI0C18B95E/lFnBl7zcOpIPZk17xHufOWPteD+r5YLY/
	wqnR61EaucMUtGbAvaq4al39swsY5dE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764262632; a=rsa-sha256;
	cv=none;
	b=f1tBciRSD99r/hJ4LupogZocC9E7D/DXDpFnv0G4srFJ/XaSRDJp6rA9GSbBPecO6mKdmg
	XUYFxLBYEtStTcW8/m3tnv00m1pLCI6FmYXk1lsHNjdw70bG8r0u5SY81ItbTrXJImpUW8
	iQVwXpkTObAHRX1jgLRMEZP50bprNfw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA0C2176A;
	Thu, 27 Nov 2025 08:57:03 -0800 (PST)
Received: from [10.57.87.167] (unknown [10.57.87.167])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 199DA3F66E;
	Thu, 27 Nov 2025 08:57:07 -0800 (PST)
Message-ID: <fbfef7fc-4030-462b-b514-498eea6620aa@arm.com>
Date: Thu, 27 Nov 2025 16:57:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/22] mm: Allow page table accessors to be
 non-idempotent
Content-Language: en-GB
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-9-samuel.holland@sifive.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251113014656.2605447-9-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 381D34000F
X-Rspamd-Server: rspam11
X-Stat-Signature: zxzqmrdircmqpj6yo96jh3uz56x3frqf
X-HE-Tag: 1764262632-787399
X-HE-Meta: U2FsdGVkX19csDFEB0brltReDWQm0rvNRjWtk5+NxHowDPSelA+OBFWGX/1LYAiK3M2sCGqlKm8/YgKuyQ0MdzKqdHvVuI9/ScQwIZ5iXJZ0v0hHC/IvQs+YGUmwGdjiMLzY4kUrFhP3ZI+SMSXBi8i/uvZFVZ5R44V/Z3e5NoLRt8iCf2tPOLgj5WeVe0S2k0BzVqTKe3zWFhxyTEkont9x4/+9pZL4YCQ05LsmicrzDfBTDcgDbIyE95MP9lAmSrgqZ9b6h2PQPn8DSJ4ThKxg/mZuSIXXOfJFjDt4CbSQEb/GlBBsexCnkNXZoPZm0jHV6Bj99Oy1QHZUB4b7a1KZ82r2B3lk31BHkgnqA4h5Yzmb8WnK+YJnii45vRzCiayn/3DngM6T2AqPVQFewgJBJuRq9a4zSWP3C4c/aPdwzzakA76Yfu0s22H0Bl6OOBLNEccs1Gf08tK7MoSL8dhnvIIsDp134Wa6LcMPBbHKrKoVvfPdbgRZw9MoghpeJ4alOTyzbRbEO6GkFJ88QU4lJldNlG/gQj7DkLIz3m8mSz5axEgexcUPOALxfXERD3DeKTaRiv6rsv+dZm1sYbDg31aoXMtHJd7vWox1NCS9477J/fKcseAGQMBR76V/XUiWNTBFUgMzc5zkRrfOH+DoGmgGWTYH3sW2zE4dAzav1uPNYwu9vZwGOt00pg6UoY8Zj4jvxx2/RPtHTce/lzm1gyDm7EffQOR4VHJsW+7FMPvYMMszPx897EeAu4GMbhFGi2lwBNNHff0EZLn1aMoGhDdlldcSn3laN1O4qISIp3H6kTfzpijlSX6yCUSW+riG5ZfIsAKhZLV1gICqTlbISPpc7dS0hsZh7Tgkm5Zoru8kZ3gZdaEzGbyv6aOPLd3YIBBnLP6gYHSN3BnrDK+vv99AINLVmGCO6vN2aObttyf9P9BR182Y31tv9SSo6MvpiKf9BuYDEiZ2Tmm
 NHYQwZM4
 W9OOKQ+rE7gnui6CfW90guTM+/aN6oc/qVxoNkt2F9cIRc4QlUtDN7mnSqIzEibOiI92wYris5yjFsBLvgm4ksXuvQRI7CQp63EMnUKOnW4YbX/0O5MVJlXu9p0E4J7EgfbceAyShdm00vtdg930amGqvfkmZdph6R1sF8UyUakLpnnXBfueoy+uxGzvzcw7XxoRAQ5LaEGwnxQ6tSeFvndsTLsbY8qiT6nL1akcUN0k7jAOqVx1sob0llrvoFaL4kp7/WAoXsBdUQXKmuXFq2OEjzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/11/2025 01:45, Samuel Holland wrote:
> Currently, some functions such as pte_offset_map() are passed both
> pointers to hardware page tables, and pointers to previously-read PMD
> entries on the stack. To ensure correctness in the first case, these
> functions must use the page table accessor function (pmdp_get()) to
> dereference the supplied pointer. However, this means pmdp_get() is
> called twice in the second case. This double call must be avoided if
> pmdp_get() applies some non-idempotent transformation to the value.
> 
> Avoid the double transformation by calling set_pmd() on the stack
> variables where necessary to keep set_pmd()/pmdp_get() calls balanced.

I don't think this is a good solution.

arm64, at least, expects and requires that only pointers to entries in pgtables
are passed to the arch helpers (e.g. set_pte(), ptep_get(), etc). For PTEs,
arm64 accesses adjacent entries within the page table to manage contiguous
mappings. If it is passed a pointer to a stack variable, it may erroneously
access other stuff on the stack thinking it is an entry in a page table.

I think we should formalize this as a clear requirement for all these functions;
all pte/pmd/pud/p4d/pgd pointers passed to the arch pgtable helpers must always
point to entries in pgtables.

arm64 will very likely take advantage of this in future in the pmd/pud/...
helpers as it does today for the pte level. But even today, arm64's set_pmd()
will emit barriers which are totally unnecessary when operating on a stack
variable that the HW PTW will never see.

Thanks,
Ryan

> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> 
> (no changes since v2)
> 
> Changes in v2:
>  - New patch for v2
> 
>  kernel/events/core.c  | 2 ++
>  mm/gup.c              | 3 +++
>  mm/khugepaged.c       | 6 ++++--
>  mm/page_table_check.c | 3 +++
>  mm/pgtable-generic.c  | 2 ++
>  5 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index fa4f9165bd94..7969b060bf2d 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8154,6 +8154,8 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  	if (pmd_leaf(pmd))
>  		return pmd_leaf_size(pmd);
>  
> +	/* transform pmd as if &pmd pointed to a hardware page table */
> +	set_pmd(&pmd, pmd);
>  	ptep = pte_offset_map(&pmd, addr);
>  	if (!ptep)
>  		goto again;
> diff --git a/mm/gup.c b/mm/gup.c
> index 549f9e868311..aba61704049e 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2844,7 +2844,10 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  	int ret = 0;
>  	pte_t *ptep, *ptem;
>  
> +	/* transform pmd as if &pmd pointed to a hardware page table */
> +	set_pmd(&pmd, pmd);
>  	ptem = ptep = pte_offset_map(&pmd, addr);
> +	pmd = pmdp_get(&pmd);
>  	if (!ptep)
>  		return 0;
>  	do {
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1bff8ade751a..ab1f68a7bc83 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1724,7 +1724,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  		struct mmu_notifier_range range;
>  		struct mm_struct *mm;
>  		unsigned long addr;
> -		pmd_t *pmd, pgt_pmd;
> +		pmd_t *pmd, pgt_pmd, pmdval;
>  		spinlock_t *pml;
>  		spinlock_t *ptl;
>  		bool success = false;
> @@ -1777,7 +1777,9 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  		 */
>  		if (check_pmd_state(pmd) != SCAN_SUCCEED)
>  			goto drop_pml;
> -		ptl = pte_lockptr(mm, pmd);
> +		/* pte_lockptr() needs a value, not a pointer to a page table */
> +		pmdval = pmdp_get(pmd);
> +		ptl = pte_lockptr(mm, &pmdval);
>  		if (ptl != pml)
>  			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
>  
> diff --git a/mm/page_table_check.c b/mm/page_table_check.c
> index 31f4c39d20ef..77d6688db0de 100644
> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -260,7 +260,10 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
>  		return;
>  
>  	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
> +		/* transform pmd as if &pmd pointed to a hardware page table */
> +		set_pmd(&pmd, pmd);
>  		pte_t *ptep = pte_offset_map(&pmd, addr);
> +		pmd = pmdp_get(&pmd);
>  		unsigned long i;
>  
>  		if (WARN_ON(!ptep))
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 63a573306bfa..6602deb002f1 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -299,6 +299,8 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>  		pmd_clear_bad(pmd);
>  		goto nomap;
>  	}
> +	/* transform pmdval as if &pmdval pointed to a hardware page table */
> +	set_pmd(&pmdval, pmdval);
>  	return __pte_map(&pmdval, addr);
>  nomap:
>  	rcu_read_unlock();


