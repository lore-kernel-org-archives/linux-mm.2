Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3013606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=fcSVGhck
Received: by kanga.kvack.org (Postfix)
	id 628236B0731; Tue, 24 Nov 2026 09:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600EA6B0733; Tue, 24 Nov 2026 09:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE7F6B0734; Tue, 24 Nov 2026 09:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE096B0731
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:49:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E637A0C84
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:49:35 +0000 (UTC)
X-FDA: 85470296310.30.78B5AF2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5CBAD1C0008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:49:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fcSVGhck;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795531773;
	b=tBmrKIpTus1/t/+CkyqnLxdyYhI28tAFyATTtn9QINqC7cYroUoAmqrDibbZ8YruVi0fAT
	nUb+RpHZA0kVhN4ww3t4etyh3G+1WQu04rB5CAOrp89N6uF2W2FJzXHVUULq7BJcANDBDF
	7cIJbUJ9nR/+sGIcFTOXPH7L0d8Fyd0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795531773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Liq722qa1oZCB1bf61DGQU/yCePJsouxsSertUBO8Fo=;
	b=3BoIO1djr35BH4LY0dd4nOIMLZTA1HkRlKSHp01wowX5f++HTPItT7nVZ7uIhT8rcrJTOG
	uLBxI9NqASRy5qxnS0ziRYditHTtVN3CUmGkr3/7zDTtXzxBmP2Q4RYkvnx7RddDY5hkrB
	4IijRtbDrfGibB8Pg6MHXas1pnsVL6E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fcSVGhck;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Liq722qa1oZCB1bf61DGQU/yCePJsouxsSertUBO8Fo=; b=fcSVGhckVln1ICsiaCxOynWGAm
	Y7ZkI5a9bALJIN4mYtqT6aLPSUmzQz4K+D0dVB0SzTsEeCEmBlKAZVezeVhv2ALtmkj47OhxXUmbx
	VFvAfyu9Q+AXrfMaz/20gdBJAVVk//BDBoRiSSoRYts0qXy8S0eKmPAQtwOx2ub/CkeV5MdrV9LCU
	gaiiroTGC0rBy/7HePaMlm/emOU2Mlv8Bk569tNk5rWLQBC3bH6JOdpOSuGzNabUHQX3s19oGOU/3
	5W+xN5DE+5wAEhNjLLcHW/OOCMdnUgKnpVWgfscCsowZS/5EH+ICqDTBrIHuDoQ22kJO9/ps79Nwc
	YqBCMnIA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVrpb-00000006oUw-16wp;
	Tue, 24 Nov 2026 14:49:15 +0000
Date: Tue, 24 Nov 2026 09:49:12 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/userfaultfd: prevent poison marker loss
Message-ID: <rll5o4nigyd345qjzjrpyud2jqbrhmztzmrgzt2xxcrjjg6qjd@meuxtqqbih2c>
References: <20261116-b4-uffd_marker_loss-v2-1-0fe9c5d1b43a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-b4-uffd_marker_loss-v2-1-0fe9c5d1b43a@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CBAD1C0008
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: zq3nboq81k9m6u9iqk6xg1swtn4939e7
X-HE-Tag: 1795531773-614641
X-HE-Meta: U2FsdGVkX1/nmasZ84qNqeT2/iMn1pX/iEEDCPYftA5UIOczD8aY9uWhuvizTYf8RWNyhjLF+GO2ZsyXf+AWPl62VBy3NMXBMuDopZasgeH58t+mezgfNCdVnlHrMQ3K0JKOfOaEpT/DI3HQX+Tg+On6I+yWt8p1PuHH0idT3UEmweJfoDpUds2AisXPj8C276LTH/5Tv2bY0Q38xbG1WXnPwS1wLZdTFfOD2lWkCq8VhPShFPFoFF4dymEcMZYS68+sR91tt3LtIaDxZcjMRlkoCJ+ZRIiFRQbbY2WegQeHsU+yjHwhWJRSdX3YJXt+9OyhdaHfM0A2O8dcxfNM4m/tZNFFMfpbDEidrztPdoUEIdisNLnWJIEQjXgFSDHi+VPypIf+h/HN6rUlpzA+33VcWX0HBvr6Ke8EjoCVEoE2OmoKrU93Me8yoQ7vV8d1qOhWRQ2XanivxmjL0um+X7kK/AB8Mbw4YBDn1m0aExE66FVuMJLWI75iotXZ/KnNW88wEWmQgxbguWmNI20cKKSwZ9l/CxL7zqJBFZgASrphedcCleS2aoZVtYWHJqmHZWy37kk7tFJiYnkaDqLVszVaItx+5o/z3ZTSkskJJgq07XqXGKSdy2v7ms41oSPmBWcJQRA1SMq/7y7XdB5xkjbEHPVr1PzvMJDcAtccn3G6FMXZRd36ZyV6AEDtW8bpfdduqsugwTZKaQrn5SzfgannjwlryVEFOIRGqu0l4pxywp36aP0lBz2mNSIGlUNqKbN3FZGHXguJdm5iPwRIYjyRtotfrOEoMquEAhbIZ1mYx84wP5F1nneVbV7smemYhku8LJ1oYWltzcA3Qw6XqSPWSaDnOGHltKDNcsNGHLFeEF7URMnnyeOBDPIjxHN5HtGvlTE1i66JTCAGYgYm4yo0/8/50JnqV6ZuhewSn69Q5mPXGSbpNtKmt3QDDxXohRgKyspX2HEDDB7UGdt
 G9/WUOEw
 WVW5XowHOCwV7zE7tQ3r40lkQZ+Gnr92rOw7wrHo5sV4qqRB/smIjGbKbFyaq+nFWBuGInKfD/dml2XNA6P4LhzGgCMrpB+oBJWrgO65THdYtddylxm9yDD3wDu93U0TtD3n51yOSVZFzlUeYr1JkTy+RqgfDuc66UE6LD9MtQ+vc8aHvIIonSjexr1IKLxKGHIkz2w7On5Fykf/PDvBNWjAI1kbSpD2RbLY/Fmlnvgpl2lw1JuJgZ/eYD+ddg6+rQUSeMtIejZfi/rgGoGallk5Saz4hhsffC+7EVnWndXGpH7rs5r3NOWvxhwRQQUFePj75cO/TG2dXc349Pgwe545mldlRB99HWv9EI2nMCL5YMI80KgZN+3uSCiBZvtsu3S/ZoXHn+d/5dBv5Hf5ee6pQBm1c5Z0HTy2GZym2mDUT+8pm5nWkh7UI3urFF2W/RxR//G80i6WiN8UzB8mIomjGQPNjEDiiKUbPpvxc+kPGEjz+wmn2LaU1R3S4C/4x8FKqDkVcLT7SYbeljwI3Ot1631MsO6YcsTqHpSyL9JmvRXEldWTrVHGDLjLMtaK0Ck0ebReJGjPnV07RpBAx+JCP8H5fIGdytD6BFm6vMe+0Y9CYiK9E4NoDUrV+MvOoa/pHnZtTS8B0oUYnCDWK6Q586w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/16 04:17PM, David Hildenbrand (Arm) wrote:
> Unregistering userfaultfd leaves poison markers in the page tables.
> However, once unregistered, hugetlb PMD tables can be shared again.
> 
> Further, shmem page-table retraction can discard poison markers even
> while registered in missing mode, and fork() can skip copying page
> tables containing poison markers.
> 
> To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
> markers. Preserve it across unregistration, splits, merges and fork(),
> just like we do with guard markers.
> 
> Use the new atomic VMA flag to disable PMD sharing and page-table
> retraction, and to force page-table copying during fork().
> 
> Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
> 64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
> Expose the flag as "up" in smaps.
> 
> Losing poison markers, while unpleasant, is not really fatal, and the
> use case is rather a niche thing. In addition, we rely on the atomic
> VMA flags infrastructure ... so let's not CC stable.
> 
> Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>


Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
> Now that Lorenzo's atomic vma flag fixes are in, we can also use it
> for userfaultfd POISON markers.
> 
> We use a new VM_MAYBE_UFFD_POISON to remember that we had POISON markers
> installed by uffd. We then use that to fix marker handling during fork(),
> during hugetlb PMD table sharing, and during retract_page_tables().
> 
> Once review finished, I will take this through core.git, where it
> depends on a related try_collapse_pte_mapped_thp() cleanup/fix.
> 
> This is not urgent, just something that should be fixed properly.
> 
> [1] https://lore.kernel.org/linux-mm/20261031-fixes_core-v3-18-d6437171ecc3@kernel.org/
> ---
> Changes in v2:
> - Picked up Ack/RB
> - Dropped second cleanup patch for now
> - Use vma_test_single_mask() in userfaultfd_wp()
> - Reshuffle VM_MAYBE_UFFD_POISON, VMA_UFFD_WP etc definitions
> - Link to v1: https://patch.msgid.link/20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org
> ---
>  Documentation/filesystems/proc.rst |  1 +
>  fs/proc/task_mmu.c                 |  3 +++
>  include/linux/mm.h                 | 40 ++++++++++++++++++++++++--------------
>  include/linux/userfaultfd_k.h      |  9 ++++++---
>  include/trace/events/mmflags.h     |  9 ++++++++-
>  mm/Kconfig                         |  1 +
>  mm/khugepaged.c                    |  9 +++++----
>  mm/userfaultfd.c                   |  3 +++
>  tools/testing/vma/include/dup.h    | 20 ++++++++++++++-----
>  9 files changed, 67 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index fa7a468e8edf2..bcbcb41814d96 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -614,6 +614,7 @@ encoded manner. The codes are the following:
>      lf    lock on fault pages
>      dp    always lazily freeable mapping
>      gu    maybe contains guard regions (if not set, definitely doesn't)
> +    up    maybe contains poison markers installed by userfaultfd
>      ==    =============================================================
>  
>  Note that there is no guarantee that every flag and associated mnemonic will
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e3d894ed2b913..d7f9934d0e499 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1106,6 +1106,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  		[ilog2(VM_GROWSDOWN)]	= "gd",
>  		[ilog2(VM_PFNMAP)]	= "pf",
>  		[ilog2(VM_MAYBE_GUARD)]	= "gu",
> +		[ilog2(VM_MAYBE_UFFD_POISON)]	= "up",
>  		[ilog2(VM_LOCKED)]	= "lo",
>  		[ilog2(VM_IO)]		= "io",
>  		[ilog2(VM_SEQ_READ)]	= "sr",
> @@ -1131,7 +1132,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  		[ilog2(VM_NOHUGEPAGE)]	= "nh",
>  		[ilog2(VM_MERGEABLE)]	= "mg",
>  		[ilog2(VM_UFFD_MISSING)]= "um",
> +#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
>  		[ilog2(VM_UFFD_WP)]	= "uw",
> +#endif
>  #ifdef CONFIG_ARM64_MTE
>  		[ilog2(VM_MTE)]		= "mt",
>  		[ilog2(VM_MTE_ALLOWED)]	= "",
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6a34dd3800f56..fa56d9e9f3ebd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -302,7 +302,7 @@ enum {
>  	/* Page-ranges managed without "struct page", just pure PFN */
>  	DECLARE_VMA_BIT(PFNMAP, 10),
>  	DECLARE_VMA_BIT(MAYBE_GUARD, 11),
> -	DECLARE_VMA_BIT(UFFD_WP, 12),	/* wrprotect pages tracking */
> +	DECLARE_VMA_BIT(MAYBE_UFFD_POISON, 12),
>  	DECLARE_VMA_BIT(LOCKED, 13),
>  	DECLARE_VMA_BIT(IO, 14),	/* Memory mapped I/O or similar */
>  	DECLARE_VMA_BIT(SEQ_READ, 15),	/* App will access data sequentially */
> @@ -346,6 +346,7 @@ enum {
>  	DECLARE_VMA_BIT(UFFD_MINOR, 41),
>  	DECLARE_VMA_BIT(SEALED, 42),
>  	DECLARE_VMA_BIT(UFFD_RWP, 43),
> +	DECLARE_VMA_BIT(UFFD_WP, 44),	/* wrprotect pages tracking */
>  	/* Flags that reuse flags above. */
>  	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
>  	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
> @@ -406,7 +407,14 @@ enum {
>  #endif
>  #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
>  #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
> +#define VM_MAYBE_UFFD_POISON	INIT_VM_FLAG(MAYBE_UFFD_POISON)
> +#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
>  #define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
> +#define VMA_UFFD_WP	mk_vma_flags(VMA_UFFD_WP_BIT)
> +#else
> +#define VM_UFFD_WP	VM_NONE
> +#define VMA_UFFD_WP	EMPTY_VMA_FLAGS
> +#endif
>  #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
>  #define VM_IO		INIT_VM_FLAG(IO)
>  #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
> @@ -508,7 +516,6 @@ enum {
>   * whose bitmap cannot hold it.
>   */
>  #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
> -#define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
>  #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
>  #define VMA_UFFD_MINOR		mk_vma_flags(VMA_UFFD_MINOR_BIT)
>  #else
> @@ -602,7 +609,8 @@ enum {
>  #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
>  
>  /* These flags can be updated atomically via VMA/mmap read lock. */
> -#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
> +#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
> +					    VMA_MAYBE_UFFD_POISON_BIT)
>  
>  /* Arch-specific flags to clear when updating VM flags on protection change */
>  #ifndef VM_ARCH_CLEAR
> @@ -620,16 +628,16 @@ enum {
>   *                       merged VMA should be considered soft-dirty also as it
>   *                       operates at a VMA granularity.
>   *
> - * VMA_MAYBE_GUARD_BIT - If a VMA may have guard regions in place it implies
> - *                       that mapped page tables may contain metadata not
> - *                       described by the VMA and thus any merged VMA may also
> - *                       contain this metadata, and thus we must make this flag
> - *                       sticky.
> + * VMA_MAYBE_GUARD_BIT / VMA_MAYBE_UFFD_POISON_BIT - Page tables may contain guard
> + *                       or poison markers not described by the VMA. Any
> + *                       merged VMA may also contain this metadata, so these
> + *                       flags must be sticky.
>   */
>  #ifdef CONFIG_MEM_SOFT_DIRTY
> -#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
> +#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT, \
> +				     VMA_MAYBE_UFFD_POISON_BIT)
>  #else
> -#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
> +#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT, VMA_MAYBE_UFFD_POISON_BIT)
>  #endif
>  
>  /*
> @@ -667,13 +675,15 @@ enum {
>   *                           retrieve from page cache, and skip copying
>   *                           will lose those info.
>   *
> - *          VM_MAYBE_GUARD - Could contain page guard region markers which
> - *                           by design are a property of the page tables
> - *                           only and thus cannot be reconstructed on page
> - *                           fault.
> + *          VM_MAYBE_GUARD - Could contain guard markers which cannot be
> + *                           reconstructed on page fault.
> + *
> + *   VM_MAYBE_UFFD_POISON - Could contain poison markers which cannot be
> + *                           reconstructed on page fault, including after
> + *                           userfaultfd unregister.
>   */
>  #define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
> -			 VM_MAYBE_GUARD)
> +			 VM_MAYBE_GUARD | VM_MAYBE_UFFD_POISON)
>  
>  /*
>   * mapping from the currently active vm_flags protection bits (the
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index dff9a5c9a0dfa..75c3e9270b62a 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -167,11 +167,14 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>  
>  /*
>   * Never enable huge pmd sharing on userfaultfd registered VMAs, because
> - * userfaultfd state can be tracked per VMA or per page table entry.
> + * userfaultfd state can be tracked per VMA or per page table entry. Similarly,
> + * handle poison markers that stick around even after userfaultfd was
> + * unregistered.
>   */
>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>  {
> -	return vma->vm_userfaultfd_ctx.ctx;
> +	return vma->vm_userfaultfd_ctx.ctx ||
> +	       vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT);
>  }
>  
>  /*
> @@ -198,7 +201,7 @@ static inline bool userfaultfd_missing(struct vm_area_struct *vma)
>  
>  static inline bool userfaultfd_wp(struct vm_area_struct *vma)
>  {
> -	return vma_test_any_mask(vma, VMA_UFFD_WP);
> +	return vma_test_single_mask(vma, VMA_UFFD_WP);
>  }
>  
>  static inline bool userfaultfd_minor(struct vm_area_struct *vma)
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index 3c153b3ad8450..942746e4de15b 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -184,6 +184,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
>  #define IF_HAVE_VM_SOFTDIRTY(flag,name)
>  #endif
>  
> +#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
> +# define IF_HAVE_UFFD_WP(flag, name) {flag, name},
> +#else
> +# define IF_HAVE_UFFD_WP(flag, name)
> +#endif
> +
>  #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
>  # define IF_HAVE_UFFD_MINOR(flag, name) {flag, name},
>  #else
> @@ -247,7 +253,8 @@ IF_HAVE_PG_ARCH_3(arch_3)
>  IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
>  	{VM_PFNMAP,			"pfnmap"	},		\
>  	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
> -	{VM_UFFD_WP,			"uffd_wp"	},		\
> +	{VM_MAYBE_UFFD_POISON,		"maybe_uffd_poison"	},		\
> +IF_HAVE_UFFD_WP(VM_UFFD_WP,		"uffd_wp")			\
>  IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
>  	{VM_LOCKED,			"locked"	},		\
>  	{VM_IO,				"io"		},		\
> diff --git a/mm/Kconfig b/mm/Kconfig
> index afff1b25b5438..ad9236933aab3 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1357,6 +1357,7 @@ config ANON_VMA_NAME
>  
>  config HAVE_ARCH_USERFAULTFD_WP
>  	bool
> +	depends on 64BIT
>  	help
>  	  Arch has userfaultfd write protection support
>  
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 42d9eb26d5fab..2a5ee8fc42335 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2107,16 +2107,17 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
>  		return false;
>  
>  	/*
> -	 * If the VMA contains guard regions then we can't collapse it.
> +	 * Preserve guard and poison markers when retracting page tables.
>  	 *
> -	 * This is set atomically on guard marker installation under mmap/VMA
> +	 * These flags are set atomically on marker installation under mmap/VMA
>  	 * read lock, and here we may not hold any VMA or mmap lock at all.
>  	 *
>  	 * This is therefore serialised on the PTE page table lock, which is
> -	 * obtained on guard region installation after the flag is set, so this
> +	 * obtained on marker installation after the flag is set, so this
>  	 * check being performed under this lock excludes races.
>  	 */
> -	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT))
> +	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT) ||
> +	    vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT))
>  		return false;
>  
>  	return true;
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 169f681f9849b..bb6069320b347 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -963,6 +963,9 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  	if (err)
>  		goto out;
>  
> +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
> +		vma_set_atomic_flag(state.vma, VMA_MAYBE_UFFD_POISON_BIT);
> +
>  	/*
>  	 * If this is a HUGETLB vma, pass off to appropriate routine
>  	 */
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index dc4927d26296c..f9bafe4e20158 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -117,7 +117,7 @@ enum {
>  	/* Page-ranges managed without "struct page", just pure PFN */
>  	DECLARE_VMA_BIT(PFNMAP, 10),
>  	DECLARE_VMA_BIT(MAYBE_GUARD, 11),
> -	DECLARE_VMA_BIT(UFFD_WP, 12),	/* wrprotect pages tracking */
> +	DECLARE_VMA_BIT(MAYBE_UFFD_POISON, 12),
>  	DECLARE_VMA_BIT(LOCKED, 13),
>  	DECLARE_VMA_BIT(IO, 14),	/* Memory mapped I/O or similar */
>  	DECLARE_VMA_BIT(SEQ_READ, 15),	/* App will access data sequentially */
> @@ -160,6 +160,7 @@ enum {
>  #endif
>  	DECLARE_VMA_BIT(UFFD_MINOR, 41),
>  	DECLARE_VMA_BIT(SEALED, 42),
> +	DECLARE_VMA_BIT(UFFD_WP, 44),	/* wrprotect pages tracking */
>  	/* Flags that reuse flags above. */
>  	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
>  	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
> @@ -218,7 +219,12 @@ enum {
>  #endif
>  #define VM_PFNMAP	INIT_VM_FLAG(PFNMAP)
>  #define VM_MAYBE_GUARD	INIT_VM_FLAG(MAYBE_GUARD)
> +#define VM_MAYBE_UFFD_POISON	INIT_VM_FLAG(MAYBE_UFFD_POISON)
> +#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
>  #define VM_UFFD_WP	INIT_VM_FLAG(UFFD_WP)
> +#else
> +#define VM_UFFD_WP	VM_NONE
> +#endif
>  #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
>  #define VM_IO		INIT_VM_FLAG(IO)
>  #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
> @@ -367,7 +373,8 @@ enum {
>  #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
>  
>  /* These flags can be updated atomically via VMA/mmap read lock. */
> -#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
> +#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
> +					    VMA_MAYBE_UFFD_POISON_BIT)
>  
>  #define RLIMIT_STACK		3	/* max stack size */
>  #define RLIMIT_MEMLOCK		8	/* max locked-in-memory address space */
> @@ -375,14 +382,17 @@ enum {
>  #define CAP_IPC_LOCK         14
>  
>  #ifdef CONFIG_MEM_SOFT_DIRTY
> -#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
> +#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT, \
> +				      VMA_MAYBE_UFFD_POISON_BIT)
>  #else
> -#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
> +#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT, \
> +				      VMA_MAYBE_UFFD_POISON_BIT)
>  #endif
>  
>  #define VMA_IGNORE_MERGE_FLAGS VMA_STICKY_FLAGS
>  
> -#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
> +#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | \
> +			 VM_MAYBE_GUARD | VM_MAYBE_UFFD_POISON)
>  
>  #define pgprot_val(x)		((x).pgprot)
>  #define __pgprot(x)		((pgprot_t) { (x) } )
> 
> ---
> base-commit: df3c65887715e66e2cba69116924020c37996cd8
> change-id: 20261106-b4-uffd_marker_loss-f0f56ec12ce6
> 
> Best regards,
> --  
> David Hildenbrand (Arm) <david@kernel.org>
> 

