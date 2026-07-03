Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85214C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6346B00E7; Fri,  3 Jul 2026 09:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A74B6B00EA; Fri,  3 Jul 2026 09:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495BD6B00EC; Fri,  3 Jul 2026 09:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF9B6B00E7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:54:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 968EA1A0129
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:54:50 +0000 (UTC)
X-FDA: 84947611140.07.D65D4E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0932D14000E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:54:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Un1KjgIk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783086889;
	b=kDuVS3vZBdTz3OBCh0/LSlvDFIt4vfRYjxQAPJkOUm8GXmbBBCFd/j2TBgf7vp83RVXXsx
	AJgDgNbieqbkcKncLzxvlnubH3aCOW9yh55VBdNU8Itv6GRWZzLX3KCaNOHYu8GcrFzbMu
	Z44wmmuF9IV9bEFrZtqNuwjHnTSnBx4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783086889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7lXeUh6QUNy9Z3dsTupqf3hFsqiT1T6e75ZkSXnH6k=;
	b=fzTxtjobGJ8aBcIhYcGOmwMH9qY7c+l3gXb8PNZnnsfHkD3Jl2k09B8xa7eZw9yYCeX50S
	VDB53DZldLJZ/HZrstqkw9NzVF5Cb1RRlKyvscEn8C4dxpxT9mMqkDZsf1BN7QRSMGxsrY
	eye0GmJNPqmHfudJWO3B40026NGeJ+g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Un1KjgIk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CDE160051;
	Fri,  3 Jul 2026 13:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65891F000E9;
	Fri,  3 Jul 2026 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783086888;
	bh=J7lXeUh6QUNy9Z3dsTupqf3hFsqiT1T6e75ZkSXnH6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Un1KjgIkbys6cN/Ii43o3pl8ddXkKk6LxBp1QYwYHVqAumvwlkRdXioMPGIN73xeO
	 0xk4NWKagLR/ZCxwnwzAc9l/4JEU6U6ODbg4IgW3LPAjFRC1bwK9Oo3RkCQIbtqo70
	 BaiHodMnXNQjWymSuQbrfD/LEMSd+0awXY8eztt5DK3e36nZ01Lq0GYK3ETzo4dRpe
	 O/ogiFKynuZcJMJwJY8qEx/r70lwjCf7kVWcKreUbYBDIbY2fp2zmMEtxwIEIj7fCs
	 34e0oGkdAAfjBshDpXVqlbYjplyBtc8Jt0vwD7THDyxyrACXBBSoktmOYJHngsoo6U
	 1tHF48iLRtTgQ==
Date: Fri, 3 Jul 2026 14:54:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, 
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>, 
	vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] userfaultfd: prevent registration of special VMAs
Message-ID: <ake8LUosdwCdleHe@lucifer>
References: <20260618095017.2553004-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618095017.2553004-1-rppt@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: im6y43ubxmyyhmc64jop9c85m998xjz1
X-Rspamd-Queue-Id: 0932D14000E
X-HE-Tag: 1783086888-651177
X-HE-Meta: U2FsdGVkX18enaNY/wXe5JLPUhh4BACsH2zGRpdleSZyPHWWzlbJsRzy+Rzn7twzbTVUzaWwC8BIMD7brSIGv+HqkQ4MBAV5nvKMRO+DN4V3gzmNRV1LJJp0tgU86Y5cjlVDo2zziCJFTLPCwPbTeE0JDc6LIw3B387oWoynBtWDLvtD0MmGf1QW2egO2mNCDxtANny3zTdRSEEYlq1cGAcfuNPhGEYlYV1TKEMMkjR6oLDq8rUZ0x/G+cgh2MtxZ/iAaAkj4iH5p0zTdSHpy8JMoMF8Qkaasfm/s+ZwvMu/5s8ytaNCQjF6HJYlamq/ngmkTfTDoVDfv3m5Jr1I1nie944JPmTSRzVj5JZVfkhnBRssyRxAjduQP3/4ivn4LqURO79k7OyacW8h9M5oikPdtKRx3UgnpPEKKPnQMVX8WGn4ZLTL7bD8GnFrTTXEFDveaKzIY47soFpTHvyj8ojqgRHHeTzFb5Ndkhi5ufIE3pWxbzDwTdAhB2Z59rycR69ovKaXm8+jPvOE9jgBu0fOxRlTqTFS9kmeTYXWTwiCUwnN/eppWWOJCoTW3T/fxf3tg04J4DZklCU95Sp4fDulHbG/jnOx0hAT6r2H5gafvx6r0bmrckoD740yuHHMkVjBv0Tsq+PCN3WkOqY6XoFksvU5tHO2F0EE/CkDf1AZPsXcdSoh69a5M4ph3F7M7rDHL7N9wYOA/+g5qyD1FtFG+Q7vUQH+I1yKUXsG+NtuytM+g6wvFYmkUIlBBKn1L/h2bePfnZ5L3fMf5G1TaMWbgmxN0fBhsftCK/SNbbVKWQ1R8qdqS9It9juJ8ma2tcsM2lbm/yIbrC8vj6MgrUaCe+PWokHRCdi6mhi2b9nOv045cb71st4VRWMqsz6USc25bzXdXH18ziSqCEa7/UoUFtk8XwBL3o897ixUs77GRYwV0gp3D5SJm3am2iSmRjoMZtHba3Nu1oTPOO3
 31uHnpMe
 2aCeNV7O5l4dOr1mZycmeGbwLDa13iFwvlYhdfzVFEsW32wA/k+suCRbU1JJB0yRErW6OpYf6ojO9cb2YUq+X2B7cusKsms2jodA1jeOhgGTY4/3lNsMWceZMJOsYHVBUuZBkEaQpu+0G5crJJ1PWdHeLWwmIXeRnURATWerCmGMeeiyOBH81iW5N6nk5EyQARH3RK6IQlja7GkSZQQlM8JVidlaKEERQZhO40pPoAwZwzvujZUfpTn3oVT/T8bgfWtoMKzV7/J04S4SvgJpmyj4T/V8NBsbAg7LcRKLnUMD3Ssk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 12:50:17PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Vova Tokarev says:
>
>   userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
>   access, you can register on the shadow stack, discard a page ... and
>   inject a page with chosen return addresses via UFFDIO_COPY.
>
> Update vma_can_userfault() to reject VM_SHADOW_STACK.
>
> While on it, also reject VM_SPECIAL so that if a driver would implement
> vm_uffd_ops, it wouldn't be possible to register special VMAs with
> userfaultfd.
>
> Since VM_SPECIAL includes VM_DONTEXPAND which is set but hugetlb,
> exclude hugetlb VMAs from the check for VM_SPECIAL.
>
> Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
> Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

I'm working on a series to take care of the issues discussed at [0].

[0]:https://lore.kernel.org/all/20260618183442.BBCD71F000E9@smtp.kernel.org

> ---
>
> v2 changes:
> * reject all VM_SPECIAL except hugetlb
>
> v1: https://lore.kernel.org/all/20260617194059.2529406-1-rppt@kernel.org
>
>  mm/userfaultfd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 246af12bf801..c3adedaaf7d5 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2111,7 +2111,10 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  {
>  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>
> -	if (vma->vm_flags & VM_DROPPABLE)
> +	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
> +		return false;
> +
> +	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
>  		return false;
>
>  	vm_flags &= __VM_UFFD_FLAGS;
>
> base-commit: e3d8707358ea76b78bdec9928937bb9a797f2c8f
> --
> 2.53.0
>
>

Cheers, Lorenzo

