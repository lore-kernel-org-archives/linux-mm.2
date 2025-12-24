Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422C6E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB0A6B00D1; Wed, 24 Dec 2025 08:51:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C97B6B00D3; Wed, 24 Dec 2025 08:51:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5F56B00D4; Wed, 24 Dec 2025 08:51:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C20E6B00D1
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:51:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18F31137339
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:51:30 +0000 (UTC)
X-FDA: 84254501940.03.A878042
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5A19020004
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:51:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qlfSgkXrPPUfteCGen9BskymZlk+ZQwNku4KYIKs/xo=;
	b=DcIDSmk1/FxaMwZ1l8La0cDVabA5e5PjWguaYGBmHbwMSU+zGJlTmxhwF+8QBHTUWoZeGO
	cCNjyRoqLONtFn6OFtcr8xY2o6VehZAv0loh8I9dD2aUu2PWTa9yqX3Secfeb9dxbVuSBN
	ZX5LoZNUYuxX485RXXPC8ebsvUPIqrY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584288; a=rsa-sha256;
	cv=none;
	b=R/S6ZV+SUueDLcQ0rXQfQsIeMhjp3XvAc4iejeKeUtkoixHybvXl+8lPpVcP6HeHFnmS97
	eiVHBIBzD6QGvFJU8aCoG66KHm8E+ELU2PYEZFeDA0rb+KNPXddHVrZrPOj90zWgh/2gih
	v2R5izHE2nnnl317znN7mYNXITtcpbA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E673339;
	Wed, 24 Dec 2025 05:51:20 -0800 (PST)
Received: from [10.57.93.190] (unknown [10.57.93.190])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A15DB3F694;
	Wed, 24 Dec 2025 05:51:24 -0800 (PST)
Message-ID: <6440050d-844b-4587-8531-038038d32f67@arm.com>
Date: Wed, 24 Dec 2025 13:51:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] arm64: mm: factor out the address and ptep
 alignment into a new helper
Content-Language: en-GB
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
 <47e29030347c23ffce238ff5ed752da01a8cc7cb.1766455378.git.baolin.wang@linux.alibaba.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <47e29030347c23ffce238ff5ed752da01a8cc7cb.1766455378.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j3irtdf3xtk5y58qu3ap9ba1xa7k3o87
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A19020004
X-HE-Tag: 1766584288-636588
X-HE-Meta: U2FsdGVkX1/1W2QvFQ52IdjmXAsAizAu2h7wUXYBdJ4DVoe9fATMjkgZP8W3dLreUNQOu2AZ206V8ku45UV+pF4RcgtE2Z+MzAGYaQZFAJtyQZo4qtAoLxkqjYKaPZyyWiHng78NeXi3D2oIk7uon0yvMUEXvfSjargvVcyZgomCKxOSiyHiRWgOZJWlbetedvxPl201UTT0R42LBuQKhwFXiJWSM2WGya4OxfpwBb4zhhu/FAhYPGcFkZzp0JjEoCgQic1h61cMVz4zXNaV/O5gEIO2R+9RXKKpSaKrRx8vMtTCJr/qG0/Wqu5Wsdxo2Q5X3J0glaFzWsICWLRL9UxJJHt4cSUdh7vx3KwVvHiKuY2Pu/q781FQFySwJduidB7UBVBsXvo/Aj6cYW+n3bRCgLcCjNCWJ6LcNGoY/ao2L9BxLkCx48p5LmKQFMKCbyEzMMLjBz8YuBD0JSQniu2oUi17M9ebjECe7ilRTHfMIi7g5zJWVrYSYBuPeNp3ZAoujjV/Ayv8V2Bj0ugHF/v7kIPm1UrwVjKBAz7jvoaXb0R96c/x3SxiUGrCCtEwvFtw+nyw4ofn4PgJvfPO8iuQsWBgDE29s9qV0LGYPvjXB3SKj+xrAuYkJOos/S70qQf8oncYdlMDGV2JtE6bUTCf63PmTF7bmqE9tGJtFJUlYWOrQKSelhX8Iz/WaOlii3XJ2//+JO0x5Iask7WpsazFsfXQoDrXTUUD9jL2a7lD0iCH0P9XnGuSfGqcAT/FuYvyHspSDNKgi7dJ91OvxQrORQqwbYGAXsBjVQ42xG8AogZqk7G55PAx3k2WzunThKp4OJfSpcEwUXMh03pJ9MILWRc09fLb+Zw6lL2et0+/iiLd7U9aiCnf2WJK7Rt8sSfGEAFwYb0tlzMqpCn9NKxo5HFlADoMRjkssAvQkPRe3ekp+TtZW29rOkP5XpnGRozL1c2YbXc17B1ahuR
 If7SIeko
 wvGQHlJzqpOfWgHwi4taVVq9hAYlRp9SOuunyI+PexcT07RvJ0jEL2tDsEogzBWWhvX+UZq94hfvJtfAW1OrsZAjeRX6mY+xApCI+5DCKP+qzJ5t0WmFTOwnnnsdfWwRhlH+Yt1eGzz3QJn/sRidctHEcHFq/U/4ZbaKCHrFTDnGk7NCeAHJ+5KEjekEfFIsoUFyroKknYpqW4mm7WgNa8q91q9iB+rylGndSXgOJO1acZYL3O7MmXIwld1u8CjxPjP/Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/12/2025 05:48, Baolin Wang wrote:
> Factor out the contpte block's address and ptep alignment into a new helper,
> and will be reused in the following patch.
> 
> No functional changes.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/mm/contpte.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index 589bcf878938..e4ddeb46f25d 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -26,6 +26,26 @@ static inline pte_t *contpte_align_down(pte_t *ptep)
>  	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
>  }
>  
> +static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
> +					     unsigned long *end, pte_t *ptep,
> +					     unsigned int nr)
> +{
> +	/*
> +	 * Note: caller must ensure these nr PTEs are consecutive (present)
> +	 * PTEs that map consecutive pages of the same large folio within a
> +	 * single VMA and a single page table.
> +	 */
> +	if (pte_cont(__ptep_get(ptep + nr - 1)))
> +		*end = ALIGN(*end, CONT_PTE_SIZE);
> +
> +	if (pte_cont(__ptep_get(ptep))) {
> +		*start = ALIGN_DOWN(*start, CONT_PTE_SIZE);
> +		ptep = contpte_align_down(ptep);
> +	}
> +
> +	return ptep;
> +}
> +
>  static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
>  					pte_t *ptep, unsigned int nr)
>  {
> @@ -569,14 +589,7 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
>  	unsigned long start = addr;
>  	unsigned long end = start + nr * PAGE_SIZE;
>  
> -	if (pte_cont(__ptep_get(ptep + nr - 1)))
> -		end = ALIGN(end, CONT_PTE_SIZE);
> -
> -	if (pte_cont(__ptep_get(ptep))) {
> -		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
> -		ptep = contpte_align_down(ptep);
> -	}
> -
> +	ptep = contpte_align_addr_ptep(&start, &end, ptep, nr);
>  	__clear_young_dirty_ptes(vma, start, ptep, (end - start) / PAGE_SIZE, flags);
>  }
>  EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);


