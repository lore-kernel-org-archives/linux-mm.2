Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 939C6C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF25D6B00EF; Tue,  4 Aug 2026 10:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9D36B00F0; Tue,  4 Aug 2026 10:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06BB6B00F2; Tue,  4 Aug 2026 10:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87AAE6B00EF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:32:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22EDC1A00E0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:55:33 +0000 (UTC)
X-FDA: 85063280946.15.18B8934
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 913C714000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:55:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JINp8CLc;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785840931;
	b=UQ3V1wacIU16xMiMKNRTUfTHwQjL1CM6dKz+m/PRDrE+m9J25g2WkSss20s4KVqarPKT/e
	oUq8BNvzPE3im6g+CKEKYxDDedmT0UoJMU/NqP5xCrVl3ejGWf/K+FGhunTdyHy2cpdCQb
	5ZqGTyJ9Sk8dF4acAu/hruJThAFD7yE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JINp8CLc;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785840931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfx/JXhnkvzzI2BW5XElJmPYBoq4OvslsVX7Sylc9YM=;
	b=6mEbfaplfXRla/BRZK04YX9es0hq/s4XTIK0y3SX5kXyN2AxA3sDK6EFgzbrZZpKal68bG
	46nEpi3Ha3B9obRxc8MxIfJSqPyzbvRNRoUFoTQP1PyAZyXEFh3QPb2wFAxG5vJqVFWtcn
	PPEPKqdXwtrRGhBp3wzEse3+Tt4MfTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC88860A73;
	Tue,  4 Aug 2026 10:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC461F000E9;
	Tue,  4 Aug 2026 10:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785840930;
	bh=qfx/JXhnkvzzI2BW5XElJmPYBoq4OvslsVX7Sylc9YM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JINp8CLcKyGxFVg0zs6zGF0WxOazH9C1viX2Av5FCxJcGkdot23Bx+NtDyXE2TQp4
	 Qi3bmokWHojVYhyMZBuqMwJRF4w1phDddQxizqP8c0Jxpp6ogEj3K6ZJIiJHoq3Iqg
	 8WTMfs25k/XwDxxK2l5Tz1ZseFoNgQkMCEqyDcVsy1CrnowkyETwrRYt/1UDrQTR7E
	 aMP8LAnwxDw8gEAOC+4rF+1auX4ZxRMi38y3pI5mu9flrrzWnmndtcNJtMDWDY+qUD
	 YT9R+5C948AydcYSJCE1zNoM7+FRoJlwlThzAqipqnTV1Mo7tWIozL8clLVYHK8VUU
	 8VuMRm0UMorNg==
Date: Tue, 4 Aug 2026 11:55:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] mm/arm64: constify pte_get*() and contpte get
 logic
Message-ID: <anG2V7KpvIHjNyVq@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-2-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803164400.531199-2-pfalcato@suse.de>
X-Stat-Signature: edsw4n4i7ox9s95jkt16xu5it1ixfd56
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 913C714000F
X-HE-Tag: 1785840931-817681
X-HE-Meta: U2FsdGVkX19L3DK15soYZoQ9hd7TNgrb2+vfLCjWPdp0iuqera+QD4f3sfgA/MdxJbLp6N0/m8zN6GR79GdeL0OYJyjEio6VFY2WEuHUQhiIB/9lLAKtCnNdRhktPy78l+DjmDMNXstMH3UCtyqCdvxrctse46U3w1ZEHtdWWSLZi/W+e40gNSEhXkB8i19jUw9mLzZuHycNTfROiVTHKbBwhJnjhZkkm+Ud7VX/Oui05EdUVPAb9akzE17seFQJwI0e74MKLZVKvP4vyu5nPXYn7qN1k/s62YC29evUEFKweYhx/KQoZtzJ5mJ/YiAQ5Zy5oOFqYb88aVso3K/GUgOm3ZYl2QRKZLpiThEb+NdjdHzm47dX5Va5No7Jw3mBk4Vx5m19alKfjmumEKVRShjiNRZZNgnkAA4q8C9rkqC5OItazE1PVWOPkxwdRhlEhq1blXGMQGf6F1A/QwjLfE4MKFX1JsMQYn4RcU/509APkkf+2senETpCPzWECcSGvlW+4ne/9Uw+OQT1zLtjFRCrCdeRfraxADskos+X/d+MDquU5N/awuKiCBvbBn8efA1/WAx6Pp0yksgqMCyNO9/qQWRh+Ah/NtGSI1AZXKs+CWF3jxipwIxt7uFDkQRXaFe3ZUJDUcGyQSUF+h99MHAzyx+rXFEFuyUB7m4NptoG5XwMNj4kJ1LcGcap29uUgBccn0m9TShh9E6Ay/3CteR2LJilfAHGo72kWpQ6sQZMguTd7QghkoIFOUBX2jJXxOG/b9MVRrHBdwETyCfmmhmTseX84EQPPcKb4k4XKOurkyHP952YhP9nSi0Sc6Qf5yd8ODX0PN/rdWBlwgDb0BZWOvgcXdSn5uC/Ai1JnvsUWVesChGSkEE1kQ3Fj6pGECjc4rDFYrOKWSnumK21IZCAdxuh2qUHMEUA8O3Z9CutNGvnBxTfZ0cTW1BdiSnYpMbNhK1kiQasXF7dS/s
 ad4OdDm5
 VelVgRJHJeBHq/NRMGTowwZMO6LgSMby7nTH+8KDuPFNiOZXlh7Qle5XLcfi9nFQB8jRKSDjb6icCade+WuoQR8C/EKmy/Dbwe0JetSLTi1wlW2HZ8j4D8ReaLwpkFjgitt9wyK96UtNQ1z/xVsKLRK9y55uMlzhrPbYlctuITec0NEiposvJZeW71mILEta8Au1zBaH+Sn7cdGh8gi9b+2Cr2XfU1KezJo8/vbgkGNUI8UFv+Hp12uyZWhjGM5OVGotDmhcz3fTTzANNTu65qMyVeKuQCvf7hJKGHOic7gMPk56xuSWDqB1MXKv3+GM7/THUQJDDqGMWO9RGUvoYsGE3ntm5jZiFHGchxFSlTwfqh5b5ZxPCRcRiCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:43:55PM +0100, Pedro Falcato wrote:
> None of the contpte code needs write access to the PTEs.

This seems like a very broad statement? Is that actually true? I see a bunch of
ptep's that aren't const-ified, so you should explain why those couldn't be
converted.

Also you add a new contpte_align_down() macro, you should mention that it the
commit message, explain why it was needed.

In general more needed here :) it'd be ok if it was a truly trivial change that
was all obvious but you're changing some pte_t *'s and not others so it's
clearly not.

>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  arch/arm64/include/asm/pgtable.h | 10 +++++-----
>  arch/arm64/mm/contpte.c          | 11 ++++++++---
>  2 files changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index a2681d755358..043bc0649cee 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -378,7 +378,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
>  	__set_pte_complete(pte);
>  }
>
> -static inline pte_t __ptep_get(pte_t *ptep)
> +static inline pte_t __ptep_get(const pte_t *ptep)
>  {
>  	return READ_ONCE(*ptep);
>  }
> @@ -1652,8 +1652,8 @@ extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
>  				pte_t *ptep, pte_t pte);
>  extern void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
>  				pte_t *ptep, pte_t pte);
> -extern pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte);
> -extern pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
> +extern pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte);
> +extern pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep);

This is (very) nitty but - not sure on the policy on extern's (Will/Catalin?) -
but in mm we drop them when we touch the code since you don't need them these
days :)

>  extern void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
>  				pte_t *ptep, pte_t pte, unsigned int nr);
>  extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
> @@ -1732,7 +1732,7 @@ static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
>   */
>
>  #define ptep_get ptep_get
> -static inline pte_t ptep_get(pte_t *ptep)
> +static inline pte_t ptep_get(const pte_t *ptep)
>  {
>  	pte_t pte = __ptep_get(ptep);
>
> @@ -1743,7 +1743,7 @@ static inline pte_t ptep_get(pte_t *ptep)
>  }
>
>  #define ptep_get_lockless ptep_get_lockless
> -static inline pte_t ptep_get_lockless(pte_t *ptep)
> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>  {
>  	pte_t pte = __ptep_get(ptep);
>
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index 2de12656b4d8..3a5d6937fb51 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -26,6 +26,11 @@ static inline pte_t *contpte_align_down(pte_t *ptep)
>  	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
>  }
>
> +#define contpte_align_down(ptep)                                                       \
> +	_Generic((ptep),                                                               \
> +		 const pte_t *: (const pte_t *) contpte_align_down((pte_t *) (ptep)),  \
> +		 pte_t *: contpte_align_down((pte_t *) ptep))

I really hate these _Generic() helper things. So ugly. And it's a pretty horrid
cast now :(

Was it not possible to const-ify further to just be able to constify
contpte_align_down itself?

It also seems to contradict the claim that contpte doesn't need write-access to
pte's since you're going to lengths to allow non-const pte_t * here.

You should cover off why this was necessary in the commit message as above.

Anyway PTR_ALIGN_DOWN() is already const-safe so couldn't you anyway just
collapse this to:

#define contpte_align_down(ptep) \
	PTR_ALIGN_DOWN(ptep, sizeof(*(ptep)) * CONT_PTES)

Then describe in the commit message why you need to handle both cases?

> +
>  static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
>  					     unsigned long *end, pte_t *ptep,
>  					     unsigned int nr)
> @@ -310,7 +315,7 @@ void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
>  }
>  EXPORT_SYMBOL_GPL(__contpte_try_unfold);
>
> -pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte)
> +pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte)
>  {
>  	/*
>  	 * Gather access/dirty bits, which may be populated in any of the ptes
> @@ -367,7 +372,7 @@ static inline bool contpte_is_consistent(pte_t pte, unsigned long pfn,
>  			pgprot_val(prot) == pgprot_val(orig_prot);
>  }
>
> -pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
> +pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep)
>  {
>  	/*
>  	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
> @@ -386,10 +391,10 @@ pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
>  	 * because it is not part of a contpte range.
>  	 */
>
> +	const pte_t *ptep;

Nit but this is breaking the reverse xmas tree isn't it?

>  	pgprot_t orig_prot;
>  	unsigned long pfn;
>  	pte_t orig_pte;
> -	pte_t *ptep;
>  	pte_t pte;
>  	int i;
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

