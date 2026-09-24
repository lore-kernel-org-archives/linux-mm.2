Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C655BC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79946B0088; Thu, 24 Sep 2026 03:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29DF6B008A; Thu, 24 Sep 2026 03:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919256B008C; Thu, 24 Sep 2026 03:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1B96B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:19:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0017E1A027D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:19:32 +0000 (UTC)
X-FDA: 85247805384.13.508F761
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 438ED1C0006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:19:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b4iXV3Na;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790234371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRGpzjaTceiGt52QZ0R/rEbnbWW0z7ilUt0hAEkQ7UI=;
	b=jSFTNJzkiyBWyh7pbqA3utMPPCEWVwSrcGPbuLhfUv2dk/98dAa9UBvNmpfvzvbbm4pJrJ
	OabfxMvACEv2/3OjQiRwmTdrkD1dkI7R/9IyFebEak3T3z9mW6eW3+K4LW88Urkat9OYVv
	fqM03pToRlyxBwV0VOYQU78kxNlOOsg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b4iXV3Na;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790234371;
	b=sCWqWhFfROEdW+pE1Nzpmy1JDhJsZNAqUxxjb3gXz+WG8ez3nnjyhvJoTP4YoPzUMUvHQ2
	t9YTOdyACysdKL5vPUNVCJmq+63zamezVNOmz+8Vwh+22e+EUkask/Sse+6QSV12ToOkIH
	FEdpZeWg/etBpLqRlglgPVJybd3mnS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6B42601FF;
	Thu, 24 Sep 2026 07:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2501F000FF;
	Thu, 24 Sep 2026 07:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790234370;
	bh=HRGpzjaTceiGt52QZ0R/rEbnbWW0z7ilUt0hAEkQ7UI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b4iXV3NabyOxUcBPZ8lgAovkC6m2VuuSKldwe0olRSxe98ajOQgDN/wubgMNxfblC
	 DG06jdpCLXpNrYvcVcI+dZZACChVDXYmK7wITwUltHVKHWlavEfGXflk3uqbZcq2eS
	 HTrLyut3xvn0gueitiwmIZtGd5Sou6IvK0NSRcicaAWLu3orguL3ENfH7fe9PEMWWm
	 /lEADdsAFofMOWo3QvSz/XvZYt4zJXRTDfbXoj1xDlxk0nkfggUgxJTriNLZ5sKQY9
	 BbminPUgyo9WdKHRQ69iA7zv3YRLyCg46fUZdpwDV6AIzV/yzuzwgZYJehpnaLi0Az
	 dngTMEtU1HIog==
Message-ID: <a4bf1f96-787d-4c1e-9bef-52ab2be570ae@kernel.org>
Date: Thu, 24 Sep 2026 09:19:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: predicate setting mmap_prepare VMA fields on new
 vma alloc
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 438ED1C0006
X-Stat-Signature: 93rnreixopuadjjxdgjresibqa4fyb7o
X-Rspam-User: 
X-HE-Tag: 1790234371-208570
X-HE-Meta: U2FsdGVkX191UIeDiHtslZdn1xvtuzZmFsnX/1iOlpv5rxRkF95zmDlRwPIFjXO+7RmOl9s271vQRTK/WCdQm2JlUKZnIHkOyuRbVzM2VhajrSGvDKazrJieMi/vZFyAJJiD7WwI+dDzo9futHKzqdJoMr6VPzg7fgLmMg/q7KI02g6VMRYxX2WTwz20+CJref3H7YgJTwWX0xBrB45qa9XCOZV/rY3CQzCOfD3R8EV0XxE3bdkSLAmkrD+k7lUncgWR2n/9tnOISVzFTXb4GXo3o7TQikK4Azpz9RxY8LEjoVEJvacWDUsGlWpbxqgexZhEiSs5HlHPnswZpEy1dT5YoJlHHAU5oorWsfSWnJU5Mprm5GVPZLJUvmsR8ZqAPpp+ekVOzJf1II8tIy6BK8PjO6yzuKaZhaKwdUrF+2z+gJoIZzmT0zIcOxbXU/j9G/hx8xeVZ5hncSafeBkvwGE5PL6E0DdHI9dmOOYvwHtknGERo32JvVqz3RCBdF/hIwNn2UyiV+pzyHzj5qY0xR1hrt2WyvZ+gyx83GaSKIlM9tqUk24Xi+/LZed12h6HJbZHLt7TqfvtvrSmOHpgBo3E+tRYL+QeKrMdk/ZmnpvCW/pCSka6lGMkOek7Id3hzqTgUEri049CZgBSGPCJuYygY3nVRY3hJbjFCCSL7J1hr3TRP308UM2df8Lxn4Ai973L/6z8GwG0/IEDBZHaqsAV8c3A3pCQ3RYQ7JS1vDXlQNN4XaW0ecc4XDM8oLOdohWCddPJGxxMdKKatFn8aO4upYmMoXSgguqJIGG8+T2iZUkWCLnWBDiCsGBreO5UpFErJg1UhSa8/qvAoBjsVHgs5obv0gEaCAstshCkv5zL8hl9cz15iRq4WjQLS6qeugCgtC3b2SJBUWijrFs0nF1v2bJ8c8mpQAxgmm6VtxClFGL3y7Ai6m9wKgdRMTlUr2gZh8mfA6MKYNPmqaU
 eb0AWopr
 SrjDNhylrOqITIkdESkwsN2SC9FMQSKh39Qj71pGkWf28qHJeLe+OMaBxgRZ18eVo23Kus7Xsow7cgcQMFFnMsittRGm3LbtvRCTF3KDeJ91gBCYptxMV+ZMUmEve4ln6NV5CDhSJrrs8m71h8KaTd+9x3s/AA/B1p/Kci0qYwp8pmJbpIWCCIduWFy4eKGUfz4eXj+DhqAA921CDorZK990VVW2mgmGhaiVJGQWhBk6tCFmJINaJxy+X+vnUqeGYIG4gsDeTRFqcIvWT04a2ZcG68pGJaekx1rjnntyUCpE+P6ZBgjczuY2rzsDmv3CQKc9IVM9/Pzs0qsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 19:45, Lorenzo Stoakes (ARM) wrote:
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
> 
> Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Note that this is cc: stable to account for any possible back-ports that could
> break it (unlikely)

Does it mean that patches are on the way to mainline that will break it, but
it's unlikely they will be backported? Or there are no such patches yet?
Just curious... if it's the first case then with the amount of random stuff
that goes to stable these days, I'd rather assume they could be backported
at some point :)

or out-of-tree modules which might be affected.

That is never a concern, and even suggesting it can bring hch's wrath ;)

Anyway,

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


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


