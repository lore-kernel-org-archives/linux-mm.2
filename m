Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FAA606A335
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaRMq2m2
Received: by kanga.kvack.org (Postfix)
	id 3325B6B00EF; Mon, 16 Nov 2026 09:39:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3226B05B0; Mon, 16 Nov 2026 09:39:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB866B05B2; Mon, 16 Nov 2026 09:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9AF6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:39:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B07C740112
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:39:19 +0000 (UTC)
X-FDA: 85441240038.30.9DBCF7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 299C140006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:39:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EaRMq2m2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794839958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaV0Mc91b6CKg4KWF+urKTxUfs1lgeRdWbePAyfuXo0=;
	b=a/lHD/LtIgqM+IgjVV9i06mNAOTH791hW6Wc5o3+xD5kp0YjBiqvX0ZneMdRhUcY3fFZTM
	MAvjYCX2jDOqfVuCn1abHRqY213DWgKC34JgQzlEhmNczecl++CH4+B0ClEWzQmNGyw1gH
	9wyUhKlEbfB62AjBzUa7wCOafmysuL8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EaRMq2m2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794839958;
	b=r1wqwh+Z/9sWA+1vGMiAZlCWXYjWj9UI/onryVQEb9A1LrIxfYhtodn1cNSfVuxBDA+fON
	GzZ8zWJ/7SkGLcPwfDkYINusk3PBK75zbNnIwXxTVMveJnW4nq6xqdzQbPcq3es+9n9VDb
	uNwzV6VqWyqI4QI0RCl9woYHB13GYss=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A609862CB7;
	Mon, 16 Nov 2026 14:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5801F000C4;
	Mon, 16 Nov 2026 14:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794839957;
	bh=zaV0Mc91b6CKg4KWF+urKTxUfs1lgeRdWbePAyfuXo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EaRMq2m2x8jWy+QEyQwyoS2VonziEIMIjWzpXQWDwpLWOJn/6DOF5tMKcwGpB0Noa
	 cKc4RmY6MsAZk6g0G6xWmKeYYu9ZA6RsEvHqXJqUyy8jKT5WpjCn5oeN2i6DS8vOep
	 muS1n3gDgb24Jja8D0CiDdJ2RO9rLtoNho73cQAfnTYaDcYnHjRY/J6jRPrRbutbZN
	 dC0GpBwgWC0Erd+9bfYNTNQmIS4CrcDZzbMh2tgBZerpm7IxNBI077/33U3a/R02Nn
	 eD3cCvMsJM7eXAUgC+LCTBg/bIu1wDOyOhz/kyqtqfANErgbwxe/2W65Nuy4ZauM63
	 HcuuRoxdJuRIw==
Date: Mon, 16 Nov 2026 14:39:07 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
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
Subject: Re: [PATCH 1/2] mm/userfaultfd: prevent poison marker loss
Message-ID: <avsVP96p3EeK4TBZ@gremlin>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
 <avij463DZ_tSwgKy@gremlin>
 <02e6240c-78ac-48a2-8bf8-36a2327e9de8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02e6240c-78ac-48a2-8bf8-36a2327e9de8@kernel.org>
X-Rspamd-Queue-Id: 299C140006
X-Rspam-User: 
X-Stat-Signature: ytw1aq3ugq5kzwgr77djxxibtbkfiugf
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794839957-351989
X-HE-Meta: U2FsdGVkX18DVaxey8Lh/bnMEjMGenWicuaFdvrSyTKDjxr36hjbFK9Y5XZJK/hS7bA+66dCCsuxb8q9TUe+YtJhoBH0wo1g4Zct40x7b/Pqoi3QFKN0iEjLvRqMxUGkloZFdGdNSIHNusHzG/iqFsE+zeQ05jl1041pi3GXMgHbLOS9OEyHXvT3lrpveDsp5koUDNUMWlZmbQ9zNSv5vuH7/S0LW7JwH4B5hI6KHGhNvm3hBhmTltbqEWn6WR2YehnKO1MASdwzvEQ4ypcFUb3KCazryAEpMdKOQve3sEPSIFYU68DPkAqQg3hYMTQLSJQ2i3guTXfpxwqyeWdj63x1jWZkHPt7rb1F0SH9hQIhbSEWhOV/ORgM4Y20zzhC6FJK41TdlXqv3NMn05sb1vqXGLsFLZZiJMWT7SiK/4v9SNze/e/9nxvJGsmYcBM7Nynqihm61p0JEXtPo2NbnRXfjpYA/jM6O2uWTJQ3sDhcjdvvzvRcw0koBOXC14at+Nj0StqLziPIC/+Im+CRa/X/b6jYXvl/+vfgQjam+RolDfXr5aSWEiAYgl2eDoE1fT7qdUhka6IUc6n5GT651+b48hoGY5NL6u94xzdPVollbiOC3/EQxCg0KbVf6m/14aJvPlaUct4SU7mt/5U9d8H8ZOlieUodGbNoh2LkmQaL+lxNXq60KTMwSsv8y7e4Kb6s/5EwY/yJlttCO1KcuPkG8IY+8k5BjVUFK9yEMFHOTl7zXxQtypcxGKJXnFdJ/5Bp0QNDIiPOF3ZwdBnuCcVygUhwIcTsqvmEmi2cVj1mqQKTrB2PC6Tvm5fIbLBqG3G//Bi1336Kw5m2RmnrDX1okDWmehtGa65Oa+ygk+l0Jluyyga9F6anULzNFJDyBUCxuUyPEroRs3jOnnaKPuUwSFyCOjtYCN+5iPZc4U5DA+Qo/RxA8bJ1Tq20UtLI+y+fuGdWZyQB4qcjeBv
 O6Hj7U3R
 aW8bAQNBZCZTuIutu2wBHubgi9hZZOAxczaMBodcHVsIe5DHyK5DnYd6Da/o8PlSr58kxLrJ9gSoqsm9NwktjHxYSbb9R+A6Cj3iZ4IuQuzFfGG5Xhjw8306/JgXlKrZtlLvHSt2fuN4F/puKfnIFJy/BTMpcfVAosTRUIHKCLYn9n8BvMr7JCQcmxcqE+x+EUYvZ8leORNt+8d5Zswb/bCT7RhwXegCBGjaETbIhsiF9WwJULEmuMnFcqNvGRJNCXcla
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:26:33PM +0100, David Hildenbrand (Arm) wrote:
> On 11/14/26 19:40, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Nov 07, 2026 at 12:51:05AM +0100, David Hildenbrand (Arm) wrote:
> >> Unregistering userfaultfd leaves poison markers in the page tables.
> >> However, once unregistered, hugetlb PMD tables can be shared again.
> >>
> >> Further, shmem page-table retraction can discard poison markers even
> >> while registered in missing mode, and fork() can skip copying page
> >> tables containing poison markers.
> >>
> >> To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
> >> markers. Preserve it across unregistration, splits, merges and fork(),
> >> just like we do with guard markers.
> >>
> >> Use the new atomic VMA flag to disable PMD sharing and page-table
> >> retraction, and to force page-table copying during fork().
> >>
> >> Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
> >> 64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
> >> Expose the flag as "up" in smaps.
> >>
> >> Losing poison markers, while unpleasant, is not really fatal, and the
> >> use case is rather a niche thing. In addition, we rely on the atomic
> >> VMA flags infrastructure ... so let's not CC stable.
> >>
> >> Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
> >> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> >
> > Are we looking to cc: stable or this something for newer kernels only?
>
> Per above:
>
> "Losing poison markers, while unpleasant, is not really fatal, and the
> use case is rather a niche thing. In addition, we rely on the atomic
> VMA flags infrastructure ... so let's not CC stable."
>
> We cannot really backport to the pre MADV_GUARD fixes that handle the atomic flag correctly.

True!

>
> We could easily backport to stable kernels that have it.
>
> Thoughts?

Yeah, I think it's fine not to cc: stable on the basis of the above, but if we
do we can limit to ones that have that fix.

OTOH this is adding an entirely new thing (new atomic VMA flag etc.) that
probably isn't best suited to a stable backport anyway.

So I am fine with it not being cc-stable at all, thanks!

>
>
> [...]
>
> >>  #define VM_LOCKED	INIT_VM_FLAG(LOCKED)
> >>  #define VM_IO		INIT_VM_FLAG(IO)
> >>  #define VM_SEQ_READ	INIT_VM_FLAG(SEQ_READ)
> >> @@ -502,13 +508,17 @@ enum {
> >>  #endif
> >>
> >>  /*
> >> - * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
> >> - * gated on the same configs as their VM_* flags above -- both of which imply
> >> + * vma_flags_t masks for the userfaultfd VMA flags. The three high-bit modes are
> >> + * gated on the same configs as their VM_* flags above -- all of which imply
> >>   * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
> >>   * whose bitmap cannot hold it.
> >>   */
> >>  #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
> >> +#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
> >>  #define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
> >> +#else
> >> +#define VMA_UFFD_WP		EMPTY_VMA_FLAGS
> >> +#endif
> >
> > Could you just move these up to the block above to match the convention here?
> >
>
> Did you have the following change on top of my changes in mind?

Yes LGTM thanks!

>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6cd9d86f7adac..fa56d9e9f3ebd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -410,8 +410,10 @@ enum {
>  #define VM_MAYBE_UFFD_POISON   INIT_VM_FLAG(MAYBE_UFFD_POISON)
>  #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
>  #define VM_UFFD_WP     INIT_VM_FLAG(UFFD_WP)
> +#define VMA_UFFD_WP    mk_vma_flags(VMA_UFFD_WP_BIT)
>  #else
>  #define VM_UFFD_WP     VM_NONE
> +#define VMA_UFFD_WP    EMPTY_VMA_FLAGS
>  #endif
>  #define VM_LOCKED      INIT_VM_FLAG(LOCKED)
>  #define VM_IO          INIT_VM_FLAG(IO)
> @@ -508,17 +510,12 @@ enum {
>  #endif
>
>  /*
> - * vma_flags_t masks for the userfaultfd VMA flags. The three high-bit modes are
> - * gated on the same configs as their VM_* flags above -- all of which imply
> + * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
> + * gated on the same configs as their VM_* flags above -- both of which imply
>   * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
>   * whose bitmap cannot hold it.
>   */
>  #define VMA_UFFD_MISSING       mk_vma_flags(VMA_UFFD_MISSING_BIT)
> -#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
> -#define VMA_UFFD_WP            mk_vma_flags(VMA_UFFD_WP_BIT)
> -#else
> -#define VMA_UFFD_WP            EMPTY_VMA_FLAGS
> -#endif
>  #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
>  #define VMA_UFFD_MINOR         mk_vma_flags(VMA_UFFD_MINOR_BIT)
>  #else
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index b8b7cc2f00388..75c3e9270b62a 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -201,7 +201,7 @@ static inline bool userfaultfd_missing(struct vm_area_struct *vma)
>
>  static inline bool userfaultfd_wp(struct vm_area_struct *vma)
>  {
> -       return vma_test_any_mask(vma, VMA_UFFD_WP);
> +       return vma_test_single_mask(vma, VMA_UFFD_WP);
>  }
>
>  static inline bool userfaultfd_minor(struct vm_area_struct *vma)
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

