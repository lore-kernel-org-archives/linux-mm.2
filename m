Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392F41098796
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B9F6B00D8; Fri, 20 Mar 2026 11:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C1D6B00DE; Fri, 20 Mar 2026 11:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BB56B00DF; Fri, 20 Mar 2026 11:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0956B00D8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:06:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40D3E57A81
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:06:32 +0000 (UTC)
X-FDA: 84566767824.15.CD3C864
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 97FD81C0014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:06:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c11vSApR;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774019190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Elxiw+fM0cLxx9UyvCmQFeSyh6yWLYKeCjqleADrGWA=;
	b=5evJx5wycefSTB8XkMp2gri3b0pkwg98bcEhUePYLKP+RbRXf/OabDsDuRDVQM9oeqSI4U
	+QVYGPbNSbKsbOHby1yvdZbJy+jjh6fNTxdKZElpA4DioPJQc8mFZU+53pdoQPf8TG6VuY
	o6p0pyT5zDyBnSAMxcVwzbGTdOSk/zc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c11vSApR;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774019190; a=rsa-sha256;
	cv=none;
	b=7W8f0a/Jp7K1p98JDbOp+q/NMJvOdXRvfIlKezvGIxuI5iJugC0Oz4AT/Anqls6LrVPTFk
	NxPZDnNY5t/iis+rQxrGh71f5DecQynLXLCblaNc0Tsv1BV0zqZYN+n1SGiyzMeyc700nt
	9YBv7uXuz7evAaWECqdpQYFJYZY8Bzw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D49042DAB;
	Fri, 20 Mar 2026 15:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB13C2BCB0;
	Fri, 20 Mar 2026 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774019189;
	bh=4U/RLB5BQTlqqUA+aRxQ/uoxRsEa6t8UeWu6iGAM7vU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c11vSApRocA25rRA6R1Rg5PoZbJKYkvTzPDMmIS8hDyX2AXYHd8mYvTvGHczpbW0e
	 ZICqmAxAG7qjbn/OIwttlwgweqfJ3T6xWbF6Jn4Ykx0PlThw+3A3UFYPQkowwyM+MR
	 xph2xDZ24qQOpQjw0PB/HBpsqSQshv8HCPxdObcRx0m/O9B6JgKfWn2YSzucm3bNUO
	 LGc+GK60aJmwylKmXisUdB28GjM0TrMGRhwdo3hoTW7hoBzOgalk4j+n72KHrlUXBf
	 swr5E6qUe0gXbEloU8Cxg7ZJR5ROhpNrWzLfTbBhCZSP8AXpxr+lme2+aRUwijSnnb
	 jet5knkPIKlag==
Message-ID: <7e2aea13-e047-4891-bd6f-ff6705c4fc28@kernel.org>
Date: Fri, 20 Mar 2026 16:06:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/23] mm: convert do_brk_flags() to use vma_flags_t
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
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
 <981ed1afcd19115432e61778e7d226a36f8f5c2b.1773846935.git.ljs@kernel.org>
 <1d300b3b-2476-4381-b8df-a680f486b284@kernel.org>
 <f47e24c4-3a11-4a58-96f5-871443660246@lucifer.local>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <f47e24c4-3a11-4a58-96f5-871443660246@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8sdfkdhar3kfibr5g93gim4pye9kxrmz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 97FD81C0014
X-HE-Tag: 1774019190-78319
X-HE-Meta: U2FsdGVkX19ddOtfmc/C3YoYFQoNvoT6KCkghdPXLYIUSqp0QcuJlsCgfJddQJnW5AporSuju31chm2HvRSjpkIp/8LU0GEP2KWmS+c426H7CCvnPmBqbfYcqTlVOhRyMT98JHaCSEAs3bQCXO9qHM21GpyJuuNc7DUbDF4lDBl6crM9GfVw3OprHhM3ORKMrRmvITxQXdU1tb3lLYkz1BNzkXcaQs4ksFlZPyMpqEt2uTLM/9mQ6Bc2/mVCN9Nv9hCszRVlbcpWLKhsOVZEvlS8i0JwMFsYo+Ix6VCgJ80/oMbm3aK+rdPg4g8WkWnZr73wWDGyT5iScuZc+emOQNe4xTlkeSFCSpgZSiC6BYy/HmvTFaQYLj++ymgZ28orbcMAdWxhIloYCOjzDFmhAueGU+iLiVQdSRdZuvTDukIWn4Dw2qkXjs1z7EfjzLJfcdONJgE8Wa/F0mB2mPQVPlo08/evloFejogYfcjRXy95W6vRHctsWnbx3rrfjzaDUtywIh9/ikJpL7hu0CPITjRrzaZmwNZu2/R89hvtyy8m7C40f6ptP6dJbYbWfMpvLf19rXEKEdQKu0hOQOkHwHsuh7EyLASoYBJOIOzym5DzJsRriSaUjmpRgck+y6spDxNLAZigpC0gKK0dvNBq5pwch2J3pJ1we6V5jUteJ77p0bmnFkjxnQ3lfV5LWEIJdh4FLbuofMsBBuX644XQG/3ji/lxH7564Em0bh9hg5zT6WzBm9Ro+jewDz6nKVhnu4sUawSyJtsjiH0ChGB0jqWEKOq7W+lpRR7wabvZGd4XbqrkFl9Z5LDNGvi0+ASR9S3OqEYKi1/M76UgFTkrVprA7uCqs1yat0L22eZglI2kIi/KEHfQInn9btu7qiPTk8WZtYrFF7X/t0sujYK37YIzthWk5nMD+6NPD6wVxXXBj5OxcriHkKsvH3C0XMbAwPRJHwwaS83iY+tSSIe
 No/v/pqC
 TPlIl4o/KVsJo2uRaxWE8CZTUntwGx3c+z4x1CKxxF9VRIFdswVyeMIg6y+PN8DWcpcRdRzLjuDQNi78BLok0dYBXcbqlqMB0D3SnGSko+y9/pTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 14:42, Lorenzo Stoakes (Oracle) wrote:
>>
>> More nits below:
>>
>> > diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
>> > index b39cc1127e1f..e25d0d18f6d7 100644
>> > --- a/arch/arm64/include/asm/page.h
>> > +++ b/arch/arm64/include/asm/page.h
>> > @@ -46,7 +46,12 @@ int pfn_is_map_memory(unsigned long pfn);
>> >
>> >  #endif /* !__ASSEMBLER__ */
>> >
>> > -#define VM_DATA_DEFAULT_FLAGS	(VM_DATA_FLAGS_TSK_EXEC | VM_MTE_ALLOWED)
>> > +#ifdef CONFIG_ARM64_MTE
>> > +#define VMA_DATA_DEFAULT_FLAGS	append_vma_flags(VMA_DATA_FLAGS_TSK_EXEC, \
>> > +						 VMA_MTE_ALLOWED_BIT)
>>
>> I wonder what's the bloat-o-meter impact of these #define's (this
>> arm64-specific one isn't the only one) being no longer compile-time-constants?
> 
> I mean there's a precedent for this, but the compiler _should_ figure out this
> as a constant value, I have repeatedly confirmed that it's good at that in
> godbolt, via make foo/bar.S etc.

Great, thanks!

> 
>>
>> >   */
>> >  #define vma_desc_set_flags(desc, ...) \
>> >  	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
>> > @@ -4059,7 +4071,6 @@ extern int replace_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
>> >  extern struct file *get_mm_exe_file(struct mm_struct *mm);
>> >  extern struct file *get_task_exe_file(struct task_struct *task);
>> >
>> > -extern bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long npages);
>> >  extern void vm_stat_account(struct mm_struct *, vm_flags_t, long npages);
>> >
>> >  extern bool vma_is_special_mapping(const struct vm_area_struct *vma,
>> > diff --git a/mm/internal.h b/mm/internal.h
>> > index f98f4746ac41..80d8651441a7 100644
>>
>> > diff --git a/mm/mprotect.c b/mm/mprotect.c
>> > index 9681f055b9fc..eaa724b99908 100644
>> > --- a/mm/mprotect.c
>> > +++ b/mm/mprotect.c
>>
>> > @@ -773,19 +778,24 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>> >
>> >  	change_protection(tlb, vma, start, end, mm_cp_flags);
>> >
>> > -	if ((oldflags & VM_ACCOUNT) && !(newflags & VM_ACCOUNT))
>> > +	if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
>> > +	    !vma_flags_test(&new_vma_flags, VMA_ACCOUNT_BIT))
>> >  		vm_unacct_memory(nrpages);
>> >
>> >  	/*
>> >  	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
>> >  	 * fault on access.
>> >  	 */
>> > -	if ((oldflags & (VM_WRITE | VM_SHARED | VM_LOCKED)) == VM_LOCKED &&
>> > -			(newflags & VM_WRITE)) {
>> > -		populate_vma_page_range(vma, start, end, NULL);
>> > +	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
>> > +		const vma_flags_t mask =
>> > +			vma_flags_and(&old_vma_flags, VMA_WRITE_BIT,
>> > +				      VMA_SHARED_BIT, VMA_LOCKED_BIT);
>> > +
>> > +		if (vma_flags_same(&mask, VMA_LOCKED_BIT))
>>
>> That converts the original logic 1:1, but I wonder if it's now feasible to
>> write it more obviously as "VMA_LOCKED_BIT must be set, VM_WRITE_BIT and
>> VM_SHARED_BIT must not" ?
> 
> Hmm, I'm not sure if I can express this more clearly, it's a pain either
> way. Could do:
> 
> 	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
> 	    !vma_flags_test_any(&old_vma_flags, VMA_WRITE_BIT, VMA_SHARED_BIT))
> 		populate_vma_page_range(vma, start, end, NULL);

It would be a bit more:

	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
 	    !vma_flags_test_any(&old_vma_flags, VMA_WRITE_BIT, VMA_SHARED_BIT))
 		populate_vma_page_range(vma, start, end, NULL);

(or reordered in whatever way the short circuting works best here, the original
code tested oldflags first).

But yeah, at least to me it's more clear what that's testing and doesn't need to
set up the intermediate mask variable, and VMA_LOCKED_BIT is there only once
in the code now. The number of vma_flags_* operations is the same.
 
>>
>> > +			populate_vma_page_range(vma, start, end, NULL);
>> >  	}
>> >
>> > -	vm_stat_account(mm, oldflags, -nrpages);
>> > +	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
>> >  	vm_stat_account(mm, newflags, nrpages);
>> >  	perf_event_mmap(vma);
>> >  	return 0;
>>
>> > diff --git a/mm/vma.h b/mm/vma.h
>> > index cf8926558bf6..1f2de6cb3b97 100644
>> > --- a/mm/vma.h
>> > +++ b/mm/vma.h
>>
>> > +static inline bool is_data_mapping_vma_flags(const vma_flags_t *vma_flags)
>> > +{
>> > +	const vma_flags_t mask = vma_flags_and(vma_flags,
>> > +			VMA_WRITE_BIT, VMA_SHARED_BIT, VMA_STACK_BIT);
>> > +
>> > +	return vma_flags_same(&mask, VMA_WRITE_BIT);
>>
>> Ditto?
> 
> I may do both as a follow up patch given the series is a pain to rework at this point
> and I want at least the first version to be like-for-like intentionally.

OK sure.

>>
>> > +}
>> >
>> >  static inline void vma_iter_config(struct vma_iterator *vmi,
>> >  		unsigned long index, unsigned long last)
>> > diff --git a/mm/vma_exec.c b/mm/vma_exec.c
>> > index 8134e1afca68..5cee8b7efa0f 100644
> 
> Thanks, Lorenzo


