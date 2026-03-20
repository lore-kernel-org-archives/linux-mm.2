Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA47108B8F0
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE8D6B0088; Fri, 20 Mar 2026 06:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785106B008A; Fri, 20 Mar 2026 06:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BA66B008C; Fri, 20 Mar 2026 06:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4096B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:40:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0580D4F9B7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:40:14 +0000 (UTC)
X-FDA: 84566096748.09.0800602
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 829D24000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:40:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XTP04ZGk;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774003212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8cxqryyZslc+0au6kHOp8RKlnYLAKqQ15cL6fRqCMok=;
	b=hWzYbotgZ38Qr8mufJag97H2NgaER8Y9UKE1NL1jlSsKUJiTmgNTD02FXiPOg77xNTXsdG
	h0GXP4JqM/qtjmqckea+jjoWVtkFz9jwcJW5Q4JAGutSAiMIYM69kWp3NwbNXUOF0yPc5V
	zs669zsrri+My4+ixJKOQztYwI8RywQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774003212; a=rsa-sha256;
	cv=none;
	b=Af+rlTG9Gsf4e5pnr9f6dP231WhoL8lQ48u5ypiNvF7hpxnctAiFo8sovaWge7r095UFZM
	LAdx5jWN6AS73tyAH6zfUcrCaJWU6SXJLNjrNKVLkEWKq1Ia620bTAWb5DUagJ2VspVx2i
	PJPwsU4LCxJ3BtGbrGG9E+uN6XTzivY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XTP04ZGk;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C07A6013C;
	Fri, 20 Mar 2026 10:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70CEC2BCB2;
	Fri, 20 Mar 2026 10:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774003211;
	bh=jhOSmCqYQaS2DI24Bg78xyfLr/K/fkiEgn/15MWAEuU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XTP04ZGkahcK9b1vYtWAII4egDMA7ViD6CPQuR08AnZlAxqqDuWpTLYDeuf1s9y+k
	 Bxe58tvv79PZpwFR1av496x4mE1lFIfGlMo1oVPWYxT8onJGrzM3kx9c5WcUASJsmP
	 5YKkxHuKdg5bXFJVZSHEFiH6Je5WrKdzJWr7a+uZSmO+h0/PWe7ZWifgkhg8kdKA0W
	 HQiDuDTxMGwA5o653RD4zCyEiOrtcgbj2fpj4wT71RjRawJrksbcfbGlWV16ZoQ/nq
	 xvXQvJZUOroGzfa4zos8aCgqbt2QQNKiCH2GECGuUPpBb873LL6PXowpwclzgaXqEI
	 1k6U5dVdH9LyA==
Message-ID: <0b5765da-67e9-4e2e-99d8-08501730bf76@kernel.org>
Date: Fri, 20 Mar 2026 11:39:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 22/23] mm/vma: convert vma_modify_flags[_uffd]() to use
 vma_flags_t
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773846935.git.ljs@kernel.org>
 <98a004bf89227ea9abaef5fef06ea7e584f77bcf.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <98a004bf89227ea9abaef5fef06ea7e584f77bcf.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yhzk6xrncsok4gizfetiunxshe44g967
X-Rspam-User: 
X-Rspamd-Queue-Id: 829D24000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1774003212-769408
X-HE-Meta: U2FsdGVkX19oYIQcAh+CZq2z0rBIaZO6JllYeTTvw7DrLxu+Y16tVBbp82vRUIjuC2j2eEhY6XHGkrQd6W+GbeGShvLJuWFtejEWoc2MuYEaA9EwfyWoK7o+FcRvKcEJHIrJWGmec8uD8+ZZ/+HW9hzwHBVlzM7pieQXOMiQzi7LZThps1ZyMEpSw8KxiEPfEuKOHszlsWezt9yyLhlm4yoZHD7qF1XGpDmmsx6Fecbv3l4hern6SdcGNz4e7DJ+zxQnx7a6WfJUXNNVW014t4Z/SCcy3FYje89tmjr3L5MGz9OxlU1LPzD7SrYyRRKDOjkMJ0UvZIv6j5lNnOo8/mPmAH2E+1SDjEzRms1gtADcBfW7zaKJuRpOXyFc5sQenCFabQvBsdy7sGyQUKgHUvluPTU/qEbFA7iQMPN5Vc9vLXgs9hqVZddCLDbER+PW7RzVpPaAqrAprsQgSuWtEK41/6bkswfF/vJyE41g5gtAMwPSuKZ5A+JpuWTeD/62N2EFYiK1qOK/omzMZ4r37373ARL32LabIlELz7ZwBtBre+9eSZEJkp7AbijHPiRxrpC/8DFrneeapxWBGI7wamOdBqqLNO2mKrC5KkxeV1R5bmxJ9P2vsHUVVw4atJ4TYAh9s377hpsEGvTRAr33i2QFMrMs7y6cK53B9DbmMtt7BmZxSZyv6U8Z6BYZKD+Mi5bvnQf721mYRzMFPtOfue8Ok3b7GFgF9pc6WW4VVttIZioo9d4m+CVamr+IizuyGhE0buKHUuV7ytswf6wrc62RAP8Sq3qJSUQ0JOq7Ln1DEGqwV9+LuBa8tI1twSfKeThe6EDi4ze1eI5qNc2recUKkvmOx8G/Qn3ZI5jyDTZAbpz54TqMXypqyWTHpK3iV+f8HQ+OhPuF3bwADBSVROulgDIc3abFLRZuQBPdOYOLloljQGvNzxuKvBBr+bqirw1O/Zx3ySrXG9y/lD6
 zFq9Fuqv
 Sz0x27lwpxGuHk70PkWSNMeG6wHhV2glofIe2NSZN8SpMihGATUR9uDa1nDudwd8JvRz8OGy18FbRJE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> Update the vma_modify_flags() and vma_modify_flags_uffd() functions to
> accept a vma_flags_t parameter rather than a vm_flags_t one, and propagate
> the changes as needed to implement this change.
> 
> Finally, update the VMA tests to reflect this.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -415,13 +415,14 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>   * @vma - vma containing range to be mlock()ed or munlock()ed
>   * @start - start address in @vma of the range
>   * @end - end of range in @vma
> - * @newflags - the new set of flags for @vma.
> + * @new_vma_flags - the new set of flags for @vma.
>   *
>   * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
>   * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
>   */
>  static void mlock_vma_pages_range(struct vm_area_struct *vma,
> -	unsigned long start, unsigned long end, vm_flags_t newflags)
> +	unsigned long start, unsigned long end,
> +	vma_flags_t *new_vma_flags)
>  {
>  	static const struct mm_walk_ops mlock_walk_ops = {
>  		.pmd_entry = mlock_pte_range,
> @@ -439,18 +440,18 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
>  	 * combination should not be visible to other mmap_lock users;
>  	 * but WRITE_ONCE so rmap walkers must see VM_IO if VM_LOCKED.
>  	 */
> -	if (newflags & VM_LOCKED)
> -		newflags |= VM_IO;
> +	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
> +		vma_flags_set(new_vma_flags, VMA_IO_BIT);
>  	vma_start_write(vma);
> -	vm_flags_reset_once(vma, newflags);
> +	WRITE_ONCE(vma->flags, *new_vma_flags);

It's not clear to me, how is switching from vm_flags_t to vma_flags_t
allowing us to simply do WRITE_ONCE() instead of the full logic of
vm_flags_reset_once()? Won't it fail to compile once once flags are more
than single word? Or worse, will compile but silently allow tearing?

>  
>  	lru_add_drain();
>  	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
>  	lru_add_drain();
>  
> -	if (newflags & VM_IO) {
> -		newflags &= ~VM_IO;
> -		vm_flags_reset_once(vma, newflags);
> +	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
> +		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
> +		WRITE_ONCE(vma->flags, *new_vma_flags);

Ditto.

>  	}
>  }
>  
> @@ -467,20 +468,22 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	       struct vm_area_struct **prev, unsigned long start,
>  	       unsigned long end, vm_flags_t newflags)
>  {
> +	vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
> +	const vma_flags_t old_vma_flags = vma->flags;
>  	struct mm_struct *mm = vma->vm_mm;
>  	int nr_pages;
>  	int ret = 0;
> -	vm_flags_t oldflags = vma->vm_flags;
>  
> -	if (newflags == oldflags || vma_is_secretmem(vma) ||
> -	    !vma_supports_mlock(vma))
> +	if (vma_flags_same_pair(&old_vma_flags, &new_vma_flags) ||
> +	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
>  		/*
>  		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
>  		 * For secretmem, don't allow the memory to be unlocked.
>  		 */
>  		goto out;
> +	}
>  
> -	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
> +	vma = vma_modify_flags(vmi, *prev, vma, start, end, &new_vma_flags);
>  	if (IS_ERR(vma)) {
>  		ret = PTR_ERR(vma);
>  		goto out;
> @@ -490,9 +493,9 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	 * Keep track of amount of locked VM.
>  	 */
>  	nr_pages = (end - start) >> PAGE_SHIFT;
> -	if (!(newflags & VM_LOCKED))
> +	if (!vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT))
>  		nr_pages = -nr_pages;
> -	else if (oldflags & VM_LOCKED)
> +	else if (vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT))
>  		nr_pages = 0;
>  	mm->locked_vm += nr_pages;
>  
> @@ -501,12 +504,13 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	 * It's okay if try_to_unmap_one unmaps a page just after we
>  	 * set VM_LOCKED, populate_vma_page_range will bring it back.
>  	 */
> -	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
> +	if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
> +	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
>  		/* No work to do, and mlocking twice would be wrong */
>  		vma_start_write(vma);
> -		vm_flags_reset(vma, newflags);
> +		vma->flags = new_vma_flags;

This also does lot less than vm_flags_reset()?

>  	} else {
> -		mlock_vma_pages_range(vma, start, end, newflags);
> +		mlock_vma_pages_range(vma, start, end, &new_vma_flags);
>  	}
>  out:
>  	*prev = vma;
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index eaa724b99908..2b8a85689ab7 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -756,13 +756,11 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  		vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
>  	}
>  
> -	newflags = vma_flags_to_legacy(new_vma_flags);
> -	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
> +	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma_flags);
>  	if (IS_ERR(vma)) {
>  		error = PTR_ERR(vma);
>  		goto fail;
>  	}
> -	new_vma_flags = legacy_to_vma_flags(newflags);
>  
>  	*pprev = vma;
>  
> @@ -771,7 +769,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	 * held in write mode.
>  	 */
>  	vma_start_write(vma);
> -	vm_flags_reset_once(vma, newflags);
> +	WRITE_ONCE(vma->flags, new_vma_flags);

Ditto.

>  	if (vma_wants_manual_pte_write_upgrade(vma))
>  		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
>  	vma_set_page_prot(vma);
> @@ -796,6 +794,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	}
>  
>  	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
> +	newflags = vma_flags_to_legacy(new_vma_flags);
>  	vm_stat_account(mm, newflags, nrpages);
>  	perf_event_mmap(vma);
>  	return 0;
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 316b5e1dec78..603df53ad267 100644

