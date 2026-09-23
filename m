Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8DC4C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3906B008C; Wed, 23 Sep 2026 13:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA40F6B0092; Wed, 23 Sep 2026 13:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA466B0093; Wed, 23 Sep 2026 13:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6186B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:47:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F8251A080A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:47:02 +0000 (UTC)
X-FDA: 85245757884.14.F67B447
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 602FE40004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:47:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZN5RbPdk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790185620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lumxCHSfeWvkTjSL62YAFITk4CTnl2QQ4sojIU6xQcM=;
	b=MHUZQ8Gd5ZHuiLkL0F6K66vqZaRc0kVIWMWSFfqt8jyQpErxiZLYEbBgXA9z4cwMsmNhcb
	kd27rRkEIQgO5r49hqsAGMopQRqwgG89EuQW5UYcjKQkPeko04cfCscxOmMP+3yc0KX2wt
	T7E/qR67o6tO8Gd6BXUImTiprLi9i1M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZN5RbPdk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790185620;
	b=gzyMe8OXMmcnqgVBZzi9hFEbkh27zEda1/joXWnJRVVXMGam8wp4CklskC6GA778MGhU7u
	qdov5tz1Zydo4s2kUZkOYgxG2ieeLyfTfg3HU3zhUKIyrTTLZ3IgPuJlDdgnVy19VxMhr1
	8G+T112Gp9eWp1RCMqxEK1Iu1ckoP3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 922E5401D3;
	Wed, 23 Sep 2026 17:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F9D1F000FF;
	Wed, 23 Sep 2026 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790185619;
	bh=lumxCHSfeWvkTjSL62YAFITk4CTnl2QQ4sojIU6xQcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZN5RbPdkzmv7OkLuqlbDa+AhkQM07KBgjT1HVrvWkqecfImZMSDootdgSQEfoaZ49
	 liAWYiZvU178eXhSqpQmxHnm+Cy9xSACjxNpY+MzA8BRWa7PAq4K8IWb6jTn6n+JGU
	 jJRMbr1a7dxlSiEaiHS6BUFA9Tdt0ucnD+2Rsqu1eMbGN8HeaDCN8on3yrtB2LJOAE
	 3h59FsevGR6GRGVkAip/WuSz7prKgp0EAKoAp+qcOvW6Hp7/Q9FkcQvYH/SUGDD/Zd
	 2LF3KbxL1afRsHoUQLuIzNvsn1gHhul+ZihnliDRQrMd0L/lxb4wJdlTNtlmcHjw2+
	 kBECXBRG3o+xQ==
Date: Wed, 23 Sep 2026 18:46:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: predicate setting mmap_prepare VMA fields on new
 vma alloc
Message-ID: <arQQXfnt7cw-tRzR@gremlin>
References: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
X-Stat-Signature: d8uaga49ahqb53wexejwdkisd4eskox6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 602FE40004
X-HE-Tag: 1790185620-984349
X-HE-Meta: U2FsdGVkX1+L7y9+GCzJFHHP5JGisHz1qVKpUAA6Dhx9SkR4Glx0mFoEDEeSV5IUKQb5jinQylU34g/8PDEBeJjUjmwx3rj6C6Aucb6s80gE1QyCSOvm8teouvbNiOfrLP+w1mkvY/CyWIzZqy164voCctQ0qcwmuwf9b3GVLGIpuJx3STE7RAsDBhVq5enNHj6glKpFaFUV6KnWZDlOnNF4Z7d5EvJBjk/kla53vv2t2B3XLW3BFZs40EK0wKZXrUPiX5OR/ycboN6Yblnu/KdTnrTchJb0o/RGpMjmxlUD068GIroNCXTkqKZJdHJ5uxyJZiZNonmmGPZriH5GRhi84l0ZgZlbSmvezavaVPEKhlPzb3vMOV1HkmFENJXrP3l1Z4H3YaiesCiRu3nFfPaU25d9eWyYhWDk2NgPwtIbTSxRVzOKnqarDA7wLVQMRGoybda/4GLPUFUvNB5CUN/GHtDcUPaeJTKz5vyfmSr6fV/6imbensU6rgJfIx0hXlxewKo203Oe87sJQFn9+VQkz5N6BwAiLfVZuhO5VVl6p5mrf4mfb1MCQoDltuOZs50x18hkHmgx1LWDAOrW7KGmIspxpwFMR/QBDRz/Ac6fwdLXkdP8zjO72JgNQN+Wjh0+CTmOXNs7qZ5F4l9Rbi59XvmOXPnr821q9fFFc7O4YOJWJzKojjq8YNXmlm3o4vPu5VS2julmIFVr7D35T+5t3ShUqJuSJOysFRXlIgfK2HBHwogx0hiAPv97yFL07RuEeR1jO/j0ZW8+shqosorrOwjKTNwmujMJz9r5PhE2VNIueLW/foagfTPA3RGeH2HdQXxO3+hMHQKivb+EfnfWEAvStXPPCmh4lXsyti0YOJ5xQLNVu6bRvJV619HrzgmyUnblVFevqQ8mmk/GQ5K0PK3au8lmklpm3uv4j1e5ddUY5tTKO3Nc3+VBO9agAGaYupElXEOom8Z3dbb
 kUIUFvC8
 JadN19hw2e70dShXVrUpjiPESe3pCJdfojXc92QnGF94vNYdU/kUohYYdyogvdV4mf4VoVGpRieoW9gk/YrBowkP1hX2B99GgSfNumer+PqkWC/pvCqo4GouBLHz82iV89d7RDa8PHt6LTITanePcoq1UJ4EcMbVz3mTtEXwJmAVIURVTJIF7YoIjagmeF0N5znJ6kre58dx0LUs0juF6xrWgEXkc2y+Ky+Vgwwv85Qc5SxcZsl1wtIFVr6IyMls0qJeZ4SzhphNEicDlqGdIXSGMLaqHg60uxVry//uz9miKdcC/hYBA+z93WccWK8CCqub3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 06:45:41PM +0100, Lorenzo Stoakes (ARM) wrote:
> It only makes sense to manipulate VMA fields if a new VMA was allocated,
> rather than merged.
>
> VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> keeps its own, which is also what the legacy f_op->mmap path does since it
> never touches an existing VMA.
>
> Currently, these fields will get overwritten by whatever state is
> established in the mmap_prepare hook, and if the VMA was merged,
> vm_ops->mapped will not have been called, so this could destructively clear
> existing state without replacing it with anything valid.
>
> There is an implicit requirement that vm_private_data and vm_ops are
> fungible across VMAs which means that losing the 'new' state is
> fine.
>
> However in this case the 'old' state is being overwritten by potentially
> invalid 'new' state, so this must be rectified.
>
> Additionally constify have_mmap_prepare while here.
>
> All existing in-tree users either derive state for the tree or are
> unmergeable due to VMA flags, so this has no direct impact.

Instantly noticed a typo when I hit send (ugh).

'derive state for the tree' should be 'derive state from the file'. It's late :)

>
> Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Note that this is cc: stable to account for any possible back-ports that could
> break it (unlikely) or out-of-tree modules which might be affected.
> ---
>  mm/vma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 9f0a0acf694a..6cde67883fb0 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2849,7 +2849,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  {
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma = NULL;
> -	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
> +	const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
>  	VMA_ITERATOR(vmi, mm, addr);
>  	const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
>  	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
> @@ -2892,7 +2892,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  		allocated_new = true;
>  	}
>
> -	if (have_mmap_prepare)
> +	if (have_mmap_prepare && allocated_new)
>  		set_vma_user_defined_fields(vma, &map);
>
>  	__mmap_complete(&map, vma);
>
> ---
> base-commit: fe2ec83746e501645709761605c2464a44fd2929
> change-id: 20260923-fix-mmap-prepare-overwrite-6304d112a4c7
>
> Best regards,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

--
Cheers, Lorenzo

