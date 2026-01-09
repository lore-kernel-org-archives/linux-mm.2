Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8331AD26D7B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 18:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4866B0005; Fri,  9 Jan 2026 13:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782246B0089; Fri,  9 Jan 2026 13:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659976B008A; Fri,  9 Jan 2026 13:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 548216B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:04:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 010A11A0646
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:04:27 +0000 (UTC)
X-FDA: 84313200216.15.D669347
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D71E20011
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:04:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dFFwszp+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LS50mZS6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WRdQlsj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RUiNhuFm;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767981866; a=rsa-sha256;
	cv=none;
	b=K6qhpDTv95b74D+oEUXmS0Jno+oE08y5sXvx4sChjt+pohNdf37mrbOAESGG6crcri3vhK
	u+PPFdfXu9qflUfmWIBybKQGLp9asGgTWGo9XUmTSMmWhDsIBpCtBkJdj58s0hXAUsw0Nu
	0576tDxtM2Y3ZMF72laVPOjCwMpaoS8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dFFwszp+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LS50mZS6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WRdQlsj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RUiNhuFm;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767981866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vv0VnsmMmyE79Xc5xSQkqZYloaKJ0tliKpSFrNzoeG4=;
	b=YWHoxzGFvVlClUwEyzmuzbkNzC21D0QkTvIVvo07617KYh/fOcsCSm89ljb3Tts30pgPsn
	f+NgarJGm3b7QAbGy7+JVgIH0R8C/RzSeyE1xGf1uQTgG0dWYBC8CLMhEJe4ED5N/iSGMl
	Xmr9+MQ6LiQk+k48foka57R4uFnEBxM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E10995C261;
	Fri,  9 Jan 2026 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767981863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vv0VnsmMmyE79Xc5xSQkqZYloaKJ0tliKpSFrNzoeG4=;
	b=dFFwszp+FeeBGMnTqNxDjRDMI0iYtvejFrZIuKrHuMnkEsjLlb1r56kWYdK+o30CWe5S4p
	XUAgCqxVlLqYzM8tBchLS+3bKyVXEZaf2ljnQAY8Mcu4PGOkpiTYFixHm/eh1IAIp/r8G6
	nHvG8n4FFipT/9iCE+Ua7bekatUpi7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767981863;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vv0VnsmMmyE79Xc5xSQkqZYloaKJ0tliKpSFrNzoeG4=;
	b=LS50mZS614meUqeaxzTmSIFICAEXQ1faiQ4vUFI9tjpWb2KpVXJ7zR2Y+ZoEYO9mJJTYdN
	weAy5CczDTt/jMBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767981861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vv0VnsmMmyE79Xc5xSQkqZYloaKJ0tliKpSFrNzoeG4=;
	b=WRdQlsj+ig0bnQV3MIBnGbZHO3pczt090NXj6O9KtK3bqvcDnrLocPK0YlqLieYIFWMYY6
	xlXOZb2UANazeJj6OZ2c/IMnWarjWJKtyqSGW1M5V9v6USOhYtNTG0ctcgBQTSks0ck0zy
	U1DFBa/WHMUD0/sBvHnwxoNECWv/1qY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767981861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vv0VnsmMmyE79Xc5xSQkqZYloaKJ0tliKpSFrNzoeG4=;
	b=RUiNhuFmgtkm7VWJfpf8arbVB4WP80xkuDpSb+pJc/f385SwYknFlnPPmdQqr2ql+YjlDo
	yTgnWPAVMObYOsAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C60373EA63;
	Fri,  9 Jan 2026 18:04:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OH/4LyVDYWkRAgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 09 Jan 2026 18:04:21 +0000
Message-ID: <4de2c1e7-73f3-4aa9-81ac-4de39f60c95e@suse.cz>
Date: Fri, 9 Jan 2026 19:04:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm/vma: fix anon_vma UAF on mremap() faulted,
 unfaulted merge
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
 <b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o9jaz4os1pkfjtxm6hmmncinncxe6xoi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7D71E20011
X-Rspam-User: 
X-HE-Tag: 1767981865-411569
X-HE-Meta: U2FsdGVkX18Imx1AYeDjGz16rmNtBbIk9ymeJ6nlRmFEuEiudEuX/jJdFJQcJV9tjHlm+w3E13C/eva+Y2nn3RHPDRLvLjlU0yPPlzKuaPY6aTNSdL4bh4WtpxHnkkDMIJs0eFzPo4FvLk1iQ6G+Dpl119G/PzJS17jkIUz9wf6FSR/zNAC+ygrbQBIg7q8vznGTr4U8XQTHNnY2f5pD13RFuG6UAFvpJ3G/JtSbIAxp3cqwZdU6YSsiAhrhmt9rfSyk78gD3lmaGFQIvOkGRh69/QK5+l17cSrRE98H5oNOWAnp/K47HwdsJEDAfzmtihxbMcEaySEENHMLH85VZfVtYoxq/xDdkz74mj4gH0vrT3lGwhC11+L/sFeldaqLTSOvNDQ17tAhghfD/VbbXzq10do7dYMR2ghUeRZ0RwAskTYsCmzYc3hSdDVz8Tn3c2OE16NskJRhXqMQn1UJif3uR2HGx40lCyeJgrWUPfXdwr94WRECAKLdWQp3a3BOheDWCr8ekVTc7cGU3FOJwjIdGlf0ZmRjMGpBhZs2oCLYWFPIZhfusk9GHCelfhvIPX5+ucDtTqDkhS/FM+0szk0Spz2J92JtLRejZqeCrN8ix82Tk/sJWhmV7i6mLeu7tWUz49klsBL0hVt0V9p3nqRJWkxkO2q71MtB5AXybXRo45ncU8ys4FwBX/Ki1pF8mz2/RcEpfvv4pQBlnkqAJP/gSu6be7vsX0lOp7+49S1/NSHyZdSPFVQi2TbOqbUD9YBNi9AZmzcGVTnwl3h7MuMsuUr0xnxHi2dGhuGn67K5ZXGSYYjJcK45/txpup1Yx6AD2gWYCzze5LokVOCN3TpDdTfcYiKknJIOZCrmVFeNyoSFzt5yrRSBM8r1aEUgX2Nb7htOYC6JxGOc6nu9llI8kOwDeRNT7YK5lE6jQvPJHRIamTVOVGH/WWuYbmr+Xpot2TMdwpVlBwCrLVB
 hOwfL692
 Wl938wOneSkIXZvBOLA2/Sq72TU5T7uSwoLyd7sbxATr+Ie6ysM/8skPlWi681pmp8qlSbviDcyH1zRaBN+gqxPJXies2hQ+44q6VGGDrapd9YREJdWyPehjIe/11KbEJu518qtHci7wsgnGlE649o4VtQIGOrcOap+bikTyc8I0ztY4liv3951fjzOZMLs4xj8ZNmbIRkiU0RDUhcMsCg+Q7oJHkzs8UqJ+x14CLQmRoxErbjDKk7P7ZzVSnukk05YLJMz3dYs/L8CCE2hCr6bPiQ7LNbfxGhINfU8r+niWQWzxr0G8jzl51qEEBpJ/UwHUddmAOPq1tBtkKnUBn17p9YxTQTJ2M5NZ6a4FszElnluExXI7usHQM7Pnvyrf8927XmeTbzTzVt0nE1h694NiBC7tfOiI0lrAKg/jFV7038BqibrzNAtvmOOpX3JHNGrC8YonIz0eaCygVUbGw8euVeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 21:11, Lorenzo Stoakes wrote:
> This bug was discovered via a syzbot report, which this patch resolves.
> 
> We further make a change to update the mergeable anon_vma check to assert
> the copied-from anon_vma did not have CoW parents, as otherwise
> dup_anon_vma() might incorrectly propagate CoW ancestors from the next VMA
> in case 4 despite the anon_vma's being identical for both VMAs.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> Cc: stable@kernel.org

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Nit below:

> @@ -1117,46 +1146,52 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>  int vma_expand(struct vma_merge_struct *vmg)
>  {
>  	struct vm_area_struct *anon_dup = NULL;
> -	bool remove_next = false;
>  	struct vm_area_struct *target = vmg->target;
>  	struct vm_area_struct *next = vmg->next;
> +	bool remove_next = false;
>  	vm_flags_t sticky_flags;
> -
> -	sticky_flags = vmg->vm_flags & VM_STICKY;
> -	sticky_flags |= target->vm_flags & VM_STICKY;
> -
> -	VM_WARN_ON_VMG(!target, vmg);
> +	int ret = 0;
>  
>  	mmap_assert_write_locked(vmg->mm);
> -
>  	vma_start_write(target);
> -	if (next && (target != next) && (vmg->end == next->vm_end)) {
> -		int ret;
>  
> -		sticky_flags |= next->vm_flags & VM_STICKY;
> +	if (next && target != next && vmg->end == next->vm_end)
>  		remove_next = true;
> -		/* This should already have been checked by this point. */
> -		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> -		vma_start_write(next);
> -		/*
> -		 * In this case we don't report OOM, so vmg->give_up_on_mm is
> -		 * safe.
> -		 */
> -		ret = dup_anon_vma(target, next, &anon_dup);
> -		if (ret)
> -			return ret;
> -	}
>  
> +	/* We must have a target. */
> +	VM_WARN_ON_VMG(!target, vmg);
> +	/* This should have already been checked by this point. */
> +	VM_WARN_ON_VMG(remove_next && !can_merge_remove_vma(next), vmg);
>  	/* Not merging but overwriting any part of next is not handled. */
>  	VM_WARN_ON_VMG(next && !remove_next &&
>  		       next != target && vmg->end > next->vm_start, vmg);
> -	/* Only handles expanding */
> +	/* Only handles expanding. */
>  	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
>  		       target->vm_end > vmg->end, vmg);
>  
> +	sticky_flags = vmg->vm_flags & VM_STICKY;
> +	sticky_flags |= target->vm_flags & VM_STICKY;
>  	if (remove_next)
> -		vmg->__remove_next = true;
> +		sticky_flags |= next->vm_flags & VM_STICKY;
>  
> +	/*
> +	 * If we are removing the next VMA or copying from a VMA
> +	 * (e.g. mremap()'ing), we must propagate anon_vma state.
> +	 *
> +	 * Note that, by convention, callers ignore OOM for this case, so
> +	 * we don't need to account for vmg->give_up_on_mm here.

It's called "give_up_on_oom". It was already wrong so this comment move
would be a chance to fix it. I think Andrew can just edit locally?

> +	 */
> +	if (remove_next)
> +		ret = dup_anon_vma(target, next, &anon_dup);
> +	if (!ret && vmg->copied_from)
> +		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
> +	if (ret)
> +		return ret;
> +
> +	if (remove_next) {
> +		vma_start_write(next);
> +		vmg->__remove_next = true;
> +	}
>  	if (commit_merge(vmg))
>  		goto nomem;
>  
> @@ -1828,10 +1863,9 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>  	if (new_vma && new_vma->vm_start < addr + len)
>  		return NULL;	/* should never get here */
>  
> -	vmg.middle = NULL; /* New VMA range. */
>  	vmg.pgoff = pgoff;
>  	vmg.next = vma_iter_next_rewind(&vmi, NULL);
> -	new_vma = vma_merge_new_range(&vmg);
> +	new_vma = vma_merge_copied_range(&vmg);
>  
>  	if (new_vma) {
>  		/*
> diff --git a/mm/vma.h b/mm/vma.h
> index e4c7bd79de5f..d51efd9da113 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -106,6 +106,9 @@ struct vma_merge_struct {
>  	struct anon_vma_name *anon_name;
>  	enum vma_merge_state state;
>  
> +	/* If copied from (i.e. mremap()'d) the VMA from which we are copying. */
> +	struct vm_area_struct *copied_from;
> +
>  	/* Flags which callers can use to modify merge behaviour: */
>  
>  	/*


