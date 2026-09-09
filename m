Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE90C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5497E6B008C; Wed,  9 Sep 2026 11:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521A16B0092; Wed,  9 Sep 2026 11:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4381E6B0093; Wed,  9 Sep 2026 11:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 196016B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:12:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A26F71C197D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:12:31 +0000 (UTC)
X-FDA: 85194565302.16.580E6F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE23B40011
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:12:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FuNxumcj;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788966749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQ4zaSpd9hBseSN7PJr6PUGSaD78UBfjGbysb66Jo3g=;
	b=lZcsIeM3kOOKX5bne4yjNODRfruDJvY5AQUZH8zQBigxy3GE0ADlVWPyYbgWhgmrBofAic
	wal0SSD48f84ParTq0Hc9idw50Xt0tc+ONqS52HT9RMiBMSTi7uzzo0kpykta+VyNQOVQT
	pCKddQxDZX5hCtDBfI0zzcPMT7SL5+g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FuNxumcj;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788966749;
	b=vHARvwKupgQj4ghJAqe/L6b8HZNIMGJNklGmpkCsPwDjzVP/NTQ2WEGCZ065qSpuVIoFil
	meGIiEZnaYupDyid+6FLTo5yeFXbFGWw27c9El/yPBlVOf73CD1BZPet6KxlDv/GIkzSsk
	6f0z/76OH4HkjYVHp0H+w7XA4ByGIUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 769D3601EF;
	Wed,  9 Sep 2026 15:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A4C1F00A3A;
	Wed,  9 Sep 2026 15:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788966749;
	bh=dQ4zaSpd9hBseSN7PJr6PUGSaD78UBfjGbysb66Jo3g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FuNxumcjhLbIUa4u7q0QITOPos6Jg58cZS6rJGrWsr8sUeAas/riDW9JQLodaznfl
	 7n2ltLxLtajU6693I6gVoqJU/MK6syCuIJbFclrsjNsuxY0AXR+nL4YJkj5CrigRDg
	 GOPnAkR8R1dHGkyjOEJf+At0Ld7Wn6d7+JgVHlnBH0Cnd4bixP9TjJmOWj17VZJo6H
	 qcCEfiiRJDCJWw12uhnSl3L146NYIwJ6PALn2wFyyS/VypGipDuB5izoyE7k9cIDjI
	 EXrp6x0pwZu6WvVS3ajxG7L6O0LaK3sfEItjEVT/6Obhm+N3Iz77DfviHAfIF+tPwr
	 i63FsXDy+ZHzA==
Message-ID: <04358f9d-3b64-47c0-94dc-f1ef19c22f78@kernel.org>
Date: Wed, 9 Sep 2026 17:12:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] arm64/mm: Move __check_safe_pte_update()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260909040005.4148136-1-anshuman.khandual@arm.com>
 <20260909040005.4148136-2-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260909040005.4148136-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: uta19i3hcuyezcstrimgd995ffo1jdw7
X-Rspamd-Queue-Id: DE23B40011
X-Rspamd-Server: rspam07
X-HE-Tag: 1788966749-326989
X-HE-Meta: U2FsdGVkX1+v37dpDz/9T/vyMWtBLW5gUub0kCAjIMIddPtupwP/MlLlK9P/GqGGYvFIXtD5eajSch0x34eAHkLhIyMsOeMyxpFp9tZqzHk5wBlgnkiDyP5t6LEIQeUoesQMPzwVgvuQG5p23ChUtfyOSLuXC465/16xOCtW+nGgpbgnQr04dp7CDweTf5wmSJx5ag1hRNhxA1aU53iTFKN+tl0vehuyvH8kyeAa+CX5Id1q7Y7H3qbFjLMHv8LVmDfWXWdyRpZnGlksar/DS5cWn9GfOo52EHPUacy+sY9iA4j1GAoQAVWgYF7vVL5+QGIvcdqXpc39RrpVAOSfirtgKgWYPjdIqPnh1esIaj8HzBO0Sk/Ah0sYjRPcAOdJgz/byCVbQEUhAihvV8wDXxHoVIq7HexV1opVLiFcL9TlkbeygKzqvdRGZjJfuZGIqqtUYcdMVpobmH9bvEf7E16xuPcVeUYxxDr1KXdPn1Ty9C/3UAJqj06SWg0mXXMRgNoEKkwuJDKKxmJ4G+OWlCgMMkcCJUYdQpZbp+EYWB+4MPa6hXHd2i4mly54Od31r9fa5vzpNP/8O+JxOX/aRDVCPJjiZ6ZTjNLwPbKSHEKHZ9KQt5NKYtlznC6LZ3SmpHpYJaJ2OTp/SFUeu+w6Gjy91Djp4JaB8tYzkp04r6iq/srodz2hb6tAIoaNN7VcBRgMoHejgZ2PqLZ0DEU1uozUsh2dJ+JMNvK00PyBIE/1apmp7g6nmaSbmwH9gSRH2Mr9zQ+QxoCCYeS13bZUvEYTSfTIx5vAW6ldhmybgPm/kjrcZ9CsaArTR27Rzkzpsai06V82vQZCD8vbGddJiqCuDLCaddpjSWXbMerzD5iVZzqfhMbZ1X6Mhcr+A1I2tPPb3VKwcXXi+WGfh3Drw1sIUjIRMRUq2k28ztcyh3vUFNZqGh1gFpYk2tHnckG+OH38jaFm6vVXcmJKS+d
 FgR/ur4k
 guYCJgxp1coDWbjvlZJTcBnseCToSeAUHGir1/wrUFFArKDJQ4ZFTirtdWBPAg+sjYkOu/gvyvpxGlielN4IRuW9+l34VYQ/6oRMqYDQLxiE1tauzDLu0RzCoK+wtLhaPoFGzkSXvpGqYgRq70I5BxvJN2YBoTSdFBu/2Grg34/N2HvyQ03UXhoRVT3MRNANRYMNvbGM7ZuKHK4j+0pKNQ2uZE6zIg5/l4jWIWYGuwh4H3oqOGM3mtEgT2A2XDUXn87PXDU591VjjAgMBiv2OMYYftTZDadY6fMHgS25H+X6WXGwbU8SoKZEtn7Acq9a8MV4FukpTuOecPYFiFABe2x9GMd4Y4RWc7FIrDQxUNs/vgm0Y9ZnUhfVCGTaoQe9WvrPPpIwsoRcBesxogSwX9loysACXN/RM8x9Gs7ZoGuLRkVEH+pA7DQ5Qj7xARbXnMm5O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 06:00, Anshuman Khandual wrote:
> The page table entry print helpers and related macros which are defined in
> <linux/pgtable.h> will not be accessible in platform <asm/pgtable.h> which
> is basically caused by cycling dependency.
> 
> Move __check_safe_pte_update() inside arch/arm64/mm/mmu.c as a preparation
> for subsequent usage of the afore mentioned generic MM helpers. While here
> drop IS_ENABLED(CONFIG_DEBUG_VM), although wrap __check_safe_pte_update()
> inside #ifdef CONFIG_DEBUG_VM that preserves the current code optimization
> which is achieved via the static inline functions.
> 
> This does not cause any functional change.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in V2:
> 
> - Moved __check_safe_pte_update() inside #ifdef CONFIG_DEBUG_VM
> - Added empty stub for __check_safe_pte_update() when !CONFIG_DEBUG_VM
> - Dropped IS_ENABLED(CONFIG_DEBUG_VM) from __check_safe_pte_update()
> 
>  arch/arm64/include/asm/pgtable.h | 49 ++++----------------------------
>  arch/arm64/mm/mmu.c              | 44 ++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index e89ec5f4787b..281a512f1fc6 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -387,52 +387,13 @@ static inline pte_t __ptep_get(pte_t *ptep)
>  extern void __sync_icache_dcache(pte_t pteval);
>  bool pgattr_change_is_safe(pteval_t old, pteval_t new);
>  
> -/*
> - * PTE bits configuration in the presence of hardware Dirty Bit Management
> - * (PTE_WRITE == PTE_DBM):
> - *
> - * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
> - *   0      0      |   1           0          0
> - *   0      1      |   1           1          0
> - *   1      0      |   1           0          1
> - *   1      1      |   0           1          x
> - *
> - * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
> - * the page fault mechanism. Checking the dirty status of a pte becomes:
> - *
> - *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
> - */
> -
> -static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
> -					   pte_t pte)
> +#ifdef CONFIG_DEBUG_VM
> +void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte);
> +#else
> +static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
>  {
> -	pte_t old_pte;
> -
> -	if (!IS_ENABLED(CONFIG_DEBUG_VM))
> -		return;
> -
> -	old_pte = __ptep_get(ptep);
> -
> -	if (!pte_valid(old_pte) || !pte_valid(pte))
> -		return;
> -	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
> -		return;
> -
> -	/*
> -	 * Check for potential race with hardware updates of the pte
> -	 * (__ptep_set_access_flags safely changes valid ptes without going
> -	 * through an invalid entry).
> -	 */
> -	VM_WARN_ONCE(!pte_young(pte),
> -		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
> -		     __func__, pte_val(old_pte), pte_val(pte));
> -	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
> -		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
> -		     __func__, pte_val(old_pte), pte_val(pte));
> -	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
> -		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
> -		     __func__, pte_val(old_pte), pte_val(pte));
>  }
> +#endif

[...]

> +#ifdef CONFIG_DEBUG_VM
> +void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
> +{
> +	pte_t old_pte;
> +
> +	old_pte = __ptep_get(ptep);
> +
> +	if (!pte_valid(old_pte) || !pte_valid(pte))
> +		return;
> +	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
> +		return;
> +
> +	/*
> +	 * Check for potential race with hardware updates of the pte
> +	 * (__ptep_set_access_flags safely changes valid ptes without going
> +	 * through an invalid entry).
> +	 */
> +	VM_WARN_ONCE(!pte_young(pte),
> +		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
> +		     __func__, pte_val(old_pte), pte_val(pte));
> +	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
> +		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
> +		     __func__, pte_val(old_pte), pte_val(pte));
> +	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
> +		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
> +		     __func__, pte_val(old_pte), pte_val(pte));
> +}
> +#endif

#endif /* CONFIG_DEBUG_VM */

Might be helpful here.

Consider the same in the case above

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

