Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570791075270
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB54D6B0545; Thu, 19 Mar 2026 13:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FAF6B0547; Thu, 19 Mar 2026 13:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06FF6B0553; Thu, 19 Mar 2026 13:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5236B0545
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:28:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49DF71A0622
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:28:00 +0000 (UTC)
X-FDA: 84563495520.05.1C79F06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A1B4640011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:27:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ni11x5qH;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yq0Z4EvpFDaoTFhe2HEhJ8Ykr3BfFmyB7X6eG+YCHX0=;
	b=Aoo9WMewIvSsVoqKGXAoe+n2caAB4DrbE12NzpiTDnXpCXTzUIh/1JtNTxjDh9O2jSuhKX
	KdlfCNLZ9cM0izn3mNJzRUt7PiJgpnYrBMg8RzkB57xz3pBp4pBVL6+g3hxY64sdw19b2/
	uAVWD2Z+cp5rRZFIJrOxb12Fy6TiY5M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ni11x5qH;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941278; a=rsa-sha256;
	cv=none;
	b=spkYq3ihfO66gB3VczRakL/zFPzzYPJXKdZiqK0LR6pGDMc/of5A6suvCaJOFRspqfDi+4
	wCcSWeIhaZgZJT5GMrqvC9XW/pm96YKwlPan6rCMQMr/Th3DwEUL+Huz3rFGQBRN6w1qgX
	m96kvUpVfaE9A3CFDzBl8W3AWZlX9Y0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C229960053;
	Thu, 19 Mar 2026 17:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C008C19424;
	Thu, 19 Mar 2026 17:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773941277;
	bh=wnmsKZ1D1KfzQIEHQIk8Eq+6eKtEf+x/yXH1sCkJxLE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ni11x5qHEQ6U2LG6CI2Vjyjh8t7GcOt+96zl91V9r2Di7PZwwNlUqIZVECtb5H2w5
	 aQAItB7sZ8iybPVrttsTi0XPAtP+zr/ASNQ1euqvkmHf5ydGP6UZqDwpxf8ALEXyxe
	 8pCPJtXU8n7uKWcfbNhSoQVeIfHgpw1D/+DaX6oVnt1IqKlW7ofgHpLFNeb9PCwYJO
	 z9xyzSEe9mrHUJmqAXRi85ear0h0WPeoMl9z5fS+NVNSAnh6OhiWOJtu46EqEDWHpx
	 ropdkm9HGkEYmJPnTkidmpipti0N5Xx1ibqNhPY2cRQYPPciTZ+SLEtNcx/Gs/2xYI
	 UmlXn7wXZROVA==
Message-ID: <624d9f1f-656a-4a63-888c-e953b90bf56e@kernel.org>
Date: Thu, 19 Mar 2026 18:27:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/23] mm: unexport vm_brk_flags() and eliminate
 vm_flags parameter
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
 <297c7690f17257ba11a7b8c94fe54709a64d89fb.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <297c7690f17257ba11a7b8c94fe54709a64d89fb.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A1B4640011
X-Rspamd-Server: rspam08
X-Stat-Signature: cifmpxft1oknx373zn9di3a3dd8abb9t
X-HE-Tag: 1773941278-312534
X-HE-Meta: U2FsdGVkX1/JES6LSx/KdNfng9wlbULE8WjtuVYV9eEXcHvNyKAuyVPpMsO+kOcJRRB0ijJojkAI7wPTorgizI28LzuzlaMKD/jgc2BJuLMgKwEm8IVxxX+qyChx3XCpEA2KXl9CRbHjuPB9M/d4AmZdRU565M9inFh5u24EYC15ep5z1c2bu+TaxNz5xIroG7r/gQc4TqNfDfqJkqacsAWmkGr3sd+z9iOvyvNPSTi2BlLB8ECzaV89hPU9cKkX0YXldVqGZj08n+mBhzDO+wJDD2UctwgybWNsd5U6P4HQgR8vrTULJs/YFl0tt3fMnmG0tFxpnqXQCRNMY/m1N3AUTypvec8x7MS6Kt2r1wc0cJBd58fl+OhgH1HZW4M/AL6K5OqT6gu4HwJjIM5ty712nA8yzvSjx9VdVbpd0QRoJ84RWXQMJS7l/+OhJT5V5KnBR9QtBIKWpTSTkc6PRP9+xx76vfgl/ijw2atYA2alVHgJuS/mzOnG8NuQcyx3H2/lvQfPlOxiSeidbz92j+JZ1HlLSdFAb0disJEJm+7wd4pdTUCdNu6Rg8R9FsHDPib+xot41GrZ43BLowkazAEmo2ucSAQnRjbV43UHhAuQBxw9c7aURxHgPBp09oWcIEIs3yyT4DzB111303JH0ulYWPnlESA/+mOmBfP7l5JmH/uiKixTUccUrXZsFKqfpQmyKnxVetgzmw2MW0KbX8a2UBnfGAvJJE3GxO5tdLB+oEwJW/F/Ba8zrvvHI3YxXHR6ob5TUN7ZTkpRs0a0Xwqn3LEunUwEh3pL9Z3iXEJmEao/5ZPjTN90YQIUOw32eJnuLUHyOS+xspM+VhiNDjxsOBq6Pss1tasyNiblhdDS5I60O4cRkuvgYHMReKrWpfOIxMXo1rhnH3AyKphG8rx789DrhUbIn3sGeMEQIBmdihAZT4mPQcp5c8PhFUoOoac3nNFfWUBFBuq3jOv
 vhf2ws5k
 5JghINuJ+M/cuish0xcYvXeLhb6uD3lwSdHWn1RcHf+nZnHLA0Hd5n3IDN8wOtJkBlkeRtKqMsZ8lsQH3fE830K+y26JlyKYq//sFLFzJQobG01avkWemy2lfPSh2NADnZVowQswPIXYgAG/X9KZ9zeudphCTeG29hzD8N4E65BUewT9DRY4aNO0l9cK4Vedu2KudYh+/WJx61/Y2Fh5VNW6HW0BRi0tazTfqkOWVMa5/xzYgeLzpwf59BUqDHjP3YqOJnRUhMXwGTT7SR3hYqwj4R64hC6JXSfQWCuCVuwuM0jV0wSMvny+7jXBwRVre0F78DoIDW5hNQQAD7mxbOmGM4c8KE95y8MAkLmVSeMrkiLEK9CB3/t8+/EgY0VCggJJv68bpDSl45LvT6udPyKGslncaJa8gSUhnSbbvU08RYajRDnQG/BImTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> This function is only used by elf_load(), and that is a static function
> that doesn't need an exported symbol to invoke an internal function, so
> un-EXPORT_SYMBOLS() it.
> 
> Also, the vm_flags parameter is unnecessary, as we only ever set VM_EXEC,
> so simply make this parameter a boolean.
> 
> While we're here, clean up the mm.h definitions for the various vm_xxx()
> helpers so we actually specify parameter names and elide the redundant
> extern's.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  fs/binfmt_elf.c    |  3 +--
>  include/linux/mm.h | 12 ++++++------
>  mm/mmap.c          |  8 ++------
>  3 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index fb857faaf0d6..16a56b6b3f6c 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -453,14 +453,13 @@ static unsigned long elf_load(struct file *filep, unsigned long addr,
>  		zero_end = ELF_PAGEALIGN(zero_end);
>  
>  		error = vm_brk_flags(zero_start, zero_end - zero_start,
> -				     prot & PROT_EXEC ? VM_EXEC : 0);
> +				     prot & PROT_EXEC);
>  		if (error)
>  			map_addr = error;
>  	}
>  	return map_addr;
>  }
>  
> -
>  static unsigned long total_mapping_size(const struct elf_phdr *phdr, int nr)
>  {
>  	elf_addr_t min_addr = -1;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0c35423177bf..42d346684678 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4005,12 +4005,12 @@ static inline void mm_populate(unsigned long addr, unsigned long len) {}
>  #endif
>  
>  /* This takes the mm semaphore itself */
> -extern int __must_check vm_brk_flags(unsigned long, unsigned long, unsigned long);
> -extern int vm_munmap(unsigned long, size_t);
> -extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
> -        unsigned long, unsigned long,
> -        unsigned long, unsigned long);
> -extern unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
> +int __must_check vm_brk_flags(unsigned long addr, unsigned long request, bool is_exec);
> +int vm_munmap(unsigned long start, size_t len);
> +unsigned long __must_check vm_mmap(struct file *file, unsigned long addr,
> +		unsigned long len, unsigned long prot,
> +		unsigned long flag, unsigned long offset);
> +unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
>  		unsigned long len, unsigned long flags);
>  
>  struct vm_unmapped_area_info {
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 79544d893411..2d2b814978bf 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1201,8 +1201,9 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
>  	return ret;
>  }
>  
> -int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
> +int vm_brk_flags(unsigned long addr, unsigned long request, bool is_exec)
>  {
> +	const vm_flags_t vm_flags = is_exec ? VM_EXEC : 0;
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma = NULL;
>  	unsigned long len;
> @@ -1217,10 +1218,6 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
>  	if (!len)
>  		return 0;
>  
> -	/* Until we need other flags, refuse anything except VM_EXEC. */
> -	if ((vm_flags & (~VM_EXEC)) != 0)
> -		return -EINVAL;
> -
>  	if (mmap_write_lock_killable(mm))
>  		return -EINTR;
>  
> @@ -1246,7 +1243,6 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
>  	mmap_write_unlock(mm);
>  	return ret;
>  }
> -EXPORT_SYMBOL(vm_brk_flags);
>  
>  static
>  unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,


