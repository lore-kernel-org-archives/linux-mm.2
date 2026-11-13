Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75148606A89F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSMFgLfD
Received: by kanga.kvack.org (Postfix)
	id 0DD376B05B3; Fri, 13 Nov 2026 15:38:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F7F6B05B4; Fri, 13 Nov 2026 15:38:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6F36B05B5; Fri, 13 Nov 2026 15:38:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3AAD6B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:38:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E3FD120298
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:37:59 +0000 (UTC)
X-FDA: 85431257478.02.4372197
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E274180003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:37:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSMFgLfD;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794602277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvlalDGclbf9jbvk6fxMo0zLcUfRP1nU9XgrjQZVQsU=;
	b=aTRfcr6v339bWfYfSOT8A1CeRKG+wFLLg5H/lWPET2WyRZ5VpkDDknLNDx6vzTrzxQLOQG
	AXSWjyvtWfoZLM/1AjH3W3y1jXAvX9xqC0O5JSU6MVoB1EV1kL2sIA5pIAu1OLO7mmKEgs
	fefFU210uRGw/430Lp+vkjwHnJQH6Aw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794602277;
	b=7hksdkAI720MqM6XIgPaKLk/xKgy2NV+924dYANOFnvG4ZB+G1W+GJfU5EJfsKfRfnHb4F
	2oD8WyeLewAwAAqLK/gx2b8opQ5iOXZCaDE8FyyjIPSJeKIDbAASBPG1AXrWqRCC5A37D+
	O6uiIag88GxmLuOxvhdR4d42gDbc7Qo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSMFgLfD;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBE9B42B1A;
	Fri, 13 Nov 2026 20:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49121F000C4;
	Fri, 13 Nov 2026 20:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794602276;
	bh=AvlalDGclbf9jbvk6fxMo0zLcUfRP1nU9XgrjQZVQsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fSMFgLfDA/Ou58ytoSDg+1mflt1C7sWfR/W+ACkbe1dn9am4k5kJZgDhqDYpp0Nt0
	 EaI5rLObsWfuzFn5sTkAdXrZTPZEOpgzZMmRyDRvvWgX5LUQ7U5rqM0s/9Lhy2n2iO
	 YWKyKRkJOYrhOtqCRb2/2i02fzf4vW8jb0PlxlNLpBkgx09vD8+B+Wt97/Ys9H+6+l
	 fX145SXiGWNPCodaqf//AhojDtXtDD6IR3aLabRjw+Ztxi0EdDViMwKG/qjkIKS5XJ
	 PU9Sx0DZki7JpzFZRqIWWzYvt8C9VphFjKVogQHq88kV0ThjxG70bvz0ukpSgbufbj
	 ChhdqKcPkXVrQ==
Date: Fri, 13 Nov 2026 20:37:49 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, akpm@linux-foundation.org, david@kernel.org, peterx@redhat.com, 
	imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 5/9] mm/mprotect: add MM_CP_PERM_UPGRADE
Message-ID: <avdw0O4rWi4WrTvy@gremlin>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-7-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261112142039.907090-7-clopez@suse.de>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9E274180003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sajr6kq3r1hphc6akoih8ohaxipkbdbk
X-Rspam-User: 
X-HE-Tag: 1794602277-830142
X-HE-Meta: U2FsdGVkX1/EXU+1C66ezMwV9ijhNYTzu3eGWJCHC6dkK9bLwws0iSy8rK0i/JUL3LA1f5BGHzNzoyHmfwmf0SunwzLKl99YLXYVkbrUjpG2EnFPAErg+kBihVq2S2FoRqkrSfT7kGcXr2plbiG+c114GxuX9+LHJXAuTISPpiUMUy9ZTruQOsslrV/cjjqEPCsbRgLGZ5L5bF97OrzStNogfKQgBe6TDnx/AFSdWZ/MIRxODUxYhxJXYoO4qf+/rLjUkPtGUpB5fHp0732T1L+iTuAdJtgzbgx55rwg6eAp5n87DfXYs0wlc1Qf2jBRhtPMnxXRA0Iz4bK9fmhoaLvyg7rmXxK/G0IGlbpUzCmWAfI0/MUCJ+V5myOoYgZyVVMXNr+4EQS2BTn7yl1QSjKkT05gSLjs4mFq2KkLrp5GNOIVuEKyjoJnE0jwFDDQc0NgJ2SYMBOyLvzUhN0mVOvjUzKV60SbIrznCHEc1AJYJixfBa4I0i2xcYnKU3GlOcb+6vsFgS2fSe/cdpUAZs8pchNrx4pXZ7cDF0LXGG2RiE6QcOW5Uqy4eR/2r8CdT+vpAIGUjCmyBxkSy2Dyd2KLjfrK/o602ndDokU6fYhwqEbWmNTC1yWYGwn0FI1WE6xlnMbfu3hcGgap8Cr7lepDu0VhA+EbNtL+yPvjUNVabVggnIzkxZqwRUDff49fN4U4XdVvzmmqdd6Tr5ALkCEpMAsweeNJs7NCA98MxsERqpptuLp0Op6istyT7i9SngRw1HWfKpWKxDgm2jCTNJ+1mHP8PlUp3Tjb2h/0s/aLOIKKzBqWsmDzjXNgH0Mr8ma2es+d0x7/HjBwIchMxYuUo6E7ExiezYPTX3024YPM65jPTrdF4SlUXdLTjO4+dKaK8YRvxiK0+MOmLMTEeQl3a7FGv/t4K5WhYdw1kpKjW0OOZJUMna8c1UlgIJIlZ9AO1tWWrdxzuSDS8BC
 jhdu2YcL
 ZJ6iwIcZVZjbpnhByEo5QIttjjYzTW8NDEGqnKBAVgyaTxMvghLaqIVHEr7wJVRmsJ316/vK8DxSRPDAoklRZkiM3T7JcPYKIk/YV0gXXt/Nsz8jHxIAVe+AKbED/OyETPJ2cxp/V5zX+sF3wW97ZX0kqOkbwXXJqBOCdl5vg5bJvYC61FxerNKQjx6EYxWXtBOl222eXPVHfKsqGS7iiEbp7BDNrV5Oiw0vv+sO+icifb1/AnnG6AIsopzpwREKEADZb9c01mjGheLeSPHJVXDuPHwBqzbVyHnuYgUPMhvT3PjNK9XkiLQfgcnOEmJBQ9dkwooMPEZLtEi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 03:20:34PM +0100, Carlos López wrote:
> Add a change_protection() flag for changes that only add permissions,
> so that MMU notifier users can keep their mappings and fault in the new
> permissions later. mprotect() sets it when the new VMA flags only add
> read, write or execute permissions, or VM_ACCOUNT, which does not affect
> the page tables. Any other change, such as a different protection key,
> is not an upgrade.

I'm struggling to comprehend what this means.

'Add a flag for changes that only add 'permissions' (not defined) so that 'MMU
notifier users' can keep mappings and 'fault' in 'the new permissions' later.

The rest of the message just states what the code does but speaks about it as if
it was already what happened.

This needs to be completely rewritten...!

>
> Signed-off-by: Carlos López <clopez@suse.de>
> ---
>  include/linux/mm.h |  2 ++
>  mm/mprotect.c      | 13 +++++++++++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6af3b7008f1a..001829a61405 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3585,6 +3585,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>  #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
>  #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
>  					    MM_CP_UFFD_RWP_RESOLVE)
> +/* Whether this change only upgrades/adds permissions */
> +#define  MM_CP_PERM_UPGRADE                (1UL << 6)

What are 'permissions' exactly?

>
>  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t pte);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 84bcfe0281d3..8c0fcd10f5a3 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -767,6 +767,17 @@ static const struct mm_walk_ops prot_none_walk_ops = {
>  	.walk_lock		= PGWALK_WRLOCK,
>  };
>
> +static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
> +				      vma_flags_t new_vma_flags)

No comment, random abbreviation (but just one word). Not ideal.

> +{
> +	vm_flags_t old = vma_flags_to_legacy(old_vma_flags);
> +	vm_flags_t new = vma_flags_to_legacy(new_vma_flags);

This is beyond appalling and a complete abuse of the VMA flags API.

You seem to have decided that you won't try to learn how the API works, so
instead you'll just write deprecated code that I have to find time to come and
fix up later I guess?

And we're at v3...!

> +	/* VM_ACCOUNT does not affect page tables */

What does this mean? And why are you referring to a deprecated constant?

> +	vm_flags_t mask = VM_READ | VM_WRITE | VM_EXEC | VM_ACCOUNT;
> +
> +	return new == (old | (new & mask));

Ordinarily I'd try to help you use the new API, but the very fact you'd send
it like this dissuades me :/

> +}
> +
>  int
>  mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	       struct vm_area_struct *vma, struct vm_area_struct **pprev,
> @@ -847,6 +858,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	vma_overwrite_flags(vma, new_vma_flags);
>  	if (vma_wants_manual_pte_write_upgrade(vma))
>  		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
> +	if (vma_flags_is_perm_upgrade(old_vma_flags, new_vma_flags))
> +		mm_cp_flags |= MM_CP_PERM_UPGRADE;
>  	vma_set_page_prot(vma);
>
>  	change_protection(tlb, vma, start, end, mm_cp_flags);
> --
> 2.51.0
>

--
Cheers, Lorenzo

