Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1866CA5FA6
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66436B008C; Mon, 28 Sep 2026 09:50:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17816B0092; Mon, 28 Sep 2026 09:50:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D266B0093; Mon, 28 Sep 2026 09:50:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82B5E6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:50:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1531A140217
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:50:32 +0000 (UTC)
X-FDA: 85263305904.16.F05387E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3051E160009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:50:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C6yTxntL;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790603430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzF82E4zZ6nxM5Y4/tKbnnewCR2Jh9fR2pKwojzSo4M=;
	b=m0UpsGJCtH9zsXzKMRPTS5jSJOSzmKATn0B8oM4MIrSlT2EhdCptkuujyTTCym+4mXmZw1
	Hm/fIUuGxfM4jS3HW6yApd5/P1Db7ocpIEQgMzM/YzgaECe4d46tpEu/rgppEthdTS1OtJ
	DsvIOwWVTkkuXYs2y2izasHLclxVLpo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C6yTxntL;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790603430;
	b=peUhnkAqwl9ZsUi1XzC5gxjH6pctaSLGucfS7btqOnK+2rfXALDW1SnjqKFQe9TfE1Uj4k
	Tl9gyLqXoMDMa6kqPiPYsIWowodQTkhf8s/ahOScc9ky6kdXdgeC/zYN4bBVUA7UsxkP9p
	ppHRjWhIGACr/Ttyqns09nN2KQrjI0s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA4C01655;
	Mon, 28 Sep 2026 06:50:25 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6346F3F763;
	Mon, 28 Sep 2026 06:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790603429; bh=3xb5/4gLWOZNOoh0bz4RtCRodVK49XjhDPLq6nhdnww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C6yTxntLWRLp6mdeRlk3M5pdaIoF+yUUjdB+wuC6pq0DDQGx9ZCG2B+ZBrhqPB6yj
	 +eZP/4yF/U/G1T0Vnsj6Z6hjxVZ5Tx3sfxYKbni7kCTMEEtBk2AHj0AZhYvtCX/TUm
	 bsV/KVunWuD5bdfLffJTFEfWcGmkRVhTTSlbnEfk=
Date: Mon, 28 Sep 2026 19:20:25 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH V3 1/2] arm64/mm: Move __check_safe_pte_update()
Message-ID: <4zgj7ok5c7dzercy4u6psfr3vx3n22dvwvztalfhfiwxx5y5ij@xv2lpuyba627>
References: <20260916044933.2689426-1-anshuman.khandual@arm.com>
 <20260916044933.2689426-2-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916044933.2689426-2-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3051E160009
X-Stat-Signature: y6adfo177on5ynyztdpgkjhbc1k8uif8
X-HE-Tag: 1790603430-248570
X-HE-Meta: U2FsdGVkX1+7g8EsuoJRLiYv6aXvLmZAg9Lz8oqBNh+8tzyKmXpwZEyUVqz3iDdmJD1OaSBtX22zee6dSNMMJmz+BOXKEHW9JkIvlok1mGTlbg5oxCfYi5JVmcUbUyoeqhvEFpKJyiNsJfpyU68szGYddC+gclsTYlFthzeYitRtaLMjiOPhJypsR6eNuepywObc5MkrbnJlyAeG4CYtosOmrtccxzF7V4TUFHyhBmHrWRd4s3nBUehLsEcqsRRnhXoaWIL3bTtbpYoiLwQR/K3a/31rUtMhuxuWD23EHOGsCBfKugtrCS8QLBItPt9vUkNjloERcvmRNhzU3QLJk8Ajf8q51/+bQxaGXflkNpcURQEuW3ORNOCpktIbPPpNKgcIw1BX3tHDmjUPa4Vxi0tCS+IcYj1GktOdxKMX1ckZ1k2fFElXCpClOy4ygH19MZ5D02tmknOd9ATlzDnzNJ+NrsBVot0EA7aB2gqpDPNCcnj84gYL8QeVoTC0a1AdyJXiuYuAv4kfBMozsdkI5i0qHgLNANxjIaPSbJxgmuGffO63k64YotI6s676mle/MnCJXSrK01oYNHh5itHmK/itwQj9V3vhOKkpbs9srUKvct09LzEmvNYDWZNqGqSmIJeiT+MphtktBYUCbXMly3oCH4IqkJ8iyR91UUoAhaVZNb0MQEGBWI90et0H4kIKnr00eXCGTw3jS9LSk0eQCYWIG4++pbt15aT2i/4RD1ic8sUGR1cs7Ew/52l0DES7Jo7zbJzd1t9VQGggQIw5jt/yMenVyFzaWtlC6ydjwzD9t8T9yeeckZLZTQZLb21K/DiqQTtUi+0lOUlkTjeBikVZZilx8vkjvfJ+F2H4zwifBILC0raz2hV1dbZ+pzkLdHM6ZmQ0LNaz+w5lYfr1uTv1+8eho4hOqLms/Ioxf6WOkbYf4IicMO/SIWiRw3rKzuqmy6cNPKlAmWKMWto
 gpIQoyUw
 34plsFHINLTArTFL4+MeAf3olrC4cbeEbfY6eLb/rYLLVlyNtsmi5XpwnI86yu6M5dEpGnsLFwDiWOPNZpH5pnXIPtFflFczihBEltZV6OOizTWp3GklrdhGEo+SeePDfTA4X11X8z0r+BX6MJgt8VA005f/CGrv9g6ulgVn8iguzIgMNzLcNAUfAnCVeXXW7/X445VOMxUASYEqdKj0MjIzTVy4ZC198n73AsbleUXY4zKoJ+2N4zBs/4OK6d4mEVMCsaiXMGVS6pTxg6ltEYSp4OAf30mahdHJTP8tNy9HP0NqSgX3TEPf+aMWZYBfyDl9aPFZcoR8CRJ0LA+ZuczURYQItMlmNOJFqSeZ4iS2+wzgWLPabCdikP1CY1usGmoJ9+7S2SbUguFICXLmnffL4bNhPPeJQ6UdC3kl6QmwZYcNZcRMLix+ZC+Coq6lG6SUmDgMnSYSP0OO1Bb/ey/84aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 10:19:32AM +0530, Anshuman Khandual wrote:
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
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 49 ++++----------------------------
>  arch/arm64/mm/mmu.c              | 44 ++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index e89ec5f4787b..763c5a411d64 100644
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
> +#endif /* CONFIG_DEBUG_VM */
>  
>  static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
>  {
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 79d90226fd5d..cb49469707a8 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -2392,4 +2392,48 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
>  
>  	return 0;
>  }
> +
> +/*
> + * PTE bits configuration in the presence of hardware Dirty Bit Management
> + * (PTE_WRITE == PTE_DBM):
> + *
> + * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
> + *   0      0      |   1           0          0
> + *   0      1      |   1           1          0
> + *   1      0      |   1           0          1
> + *   1      1      |   0           1          x
> + *
> + * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
> + * the page fault mechanism. Checking the dirty status of a pte becomes:
> + *
> + *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
> + */
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
> +#endif /* CONFIG_DEBUG_VM */
>  #endif
> -- 
> 2.43.0
>

Hello Andrew,

Could you please squash in the following changes from David which fixes
the build issue reported earlier. Problem is the #ifdef CONFIG_DEBUG_VM
block was inserted inside the existing #ifdef CONFIG_ARCH_HAS_PKEYS not
after it as would have been expected. OR do we need a respin here along
with the change ?

- Anshuman

From 448f146f16394713b28295236588ccab3a173827 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 28 Sep 2026 09:42:06 +0200
Subject: [PATCH] fixup: arm64/mm: move __check_safe_pte_update()

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e589fb00d1e3..7343ac9294f8 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2392,6 +2392,7 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)

 	return 0;
 }
+#endif

 /*
  * PTE bits configuration in the presence of hardware Dirty Bit Management
@@ -2440,4 +2441,3 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 		     __func__, pte_str_old, pte_str);
 }
 #endif /* CONFIG_DEBUG_VM */
-#endif


