Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A2DC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55E5F6B0093; Fri,  8 Aug 2025 10:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5359E6B0095; Fri,  8 Aug 2025 10:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4245C6B0096; Fri,  8 Aug 2025 10:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33EAF6B0093
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:19:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE02D16022E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:19:13 +0000 (UTC)
X-FDA: 83753797386.23.5F3C896
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6123114000F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:19:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yTD960BM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WynrgH2g;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yTD960BM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WynrgH2g;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754662751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GRMQSPxhTZ+osWx629SSW9svJoXEBjayeIwedE8efI=;
	b=jbkvgEJuZBFbF6jep9PLOthYCV4kXeK0U+Vg+VF9mYRZ21rpp8Z5tnWLtAN2s9KPNAMmvp
	AsppBgXNOWBX/DoiapFuUuXY3i89HNUXLhq5pEDVqY6/kgj7h3DV1VaGtHTBSrC+rephsv
	54/wt4y+Y8ZesdmZUZ9J1guKxlMW+mQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754662751; a=rsa-sha256;
	cv=none;
	b=Lny90G0l7EniRCcG75LfQPazqJtORJ2cVtiM7nxZmLHrwDx71bVpZmWEmIFHfVWdJi/a3p
	XVTVuZsYYZ1oRtwlS4NHHzvuQl025O8sql9FPNYxVoxk0+aZLyIjrsK3NjjpCleAitjven
	ulyK9u+AodGKIeq+G4IiuROCTUq5pAo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yTD960BM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WynrgH2g;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yTD960BM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WynrgH2g;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A7983225DD;
	Fri,  8 Aug 2025 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754662749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1GRMQSPxhTZ+osWx629SSW9svJoXEBjayeIwedE8efI=;
	b=yTD960BMWvZFl65pKovXWnG9Sr86Zaq7tPpCLYrHqUOyEPLjyBsOrQBfa50FDk3GSzyX92
	dA4DTboTrPktvecX+PtxwGslST1rMYjBi1KI9btKiKS1hEokNpbB3dJisd8pb48VlfZEJ1
	+8kQxkZeBWaRREEso9j2GRpqrgFd8j8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754662749;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1GRMQSPxhTZ+osWx629SSW9svJoXEBjayeIwedE8efI=;
	b=WynrgH2g+K8FPi5dEzooNNv9te2KjW3x8Ytg5C/Hhy+kSvnwe3xEfu8tgFhxYFRKG6fKxY
	kPh8XokrUUjbEQCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754662749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1GRMQSPxhTZ+osWx629SSW9svJoXEBjayeIwedE8efI=;
	b=yTD960BMWvZFl65pKovXWnG9Sr86Zaq7tPpCLYrHqUOyEPLjyBsOrQBfa50FDk3GSzyX92
	dA4DTboTrPktvecX+PtxwGslST1rMYjBi1KI9btKiKS1hEokNpbB3dJisd8pb48VlfZEJ1
	+8kQxkZeBWaRREEso9j2GRpqrgFd8j8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754662749;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1GRMQSPxhTZ+osWx629SSW9svJoXEBjayeIwedE8efI=;
	b=WynrgH2g+K8FPi5dEzooNNv9te2KjW3x8Ytg5C/Hhy+kSvnwe3xEfu8tgFhxYFRKG6fKxY
	kPh8XokrUUjbEQCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8CED31392A;
	Fri,  8 Aug 2025 14:19:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FdIAIl0HlmghMgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Aug 2025 14:19:09 +0000
Message-ID: <571c0a24-6bdf-47cd-b336-efff34f48010@suse.cz>
Date: Fri, 8 Aug 2025 16:19:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 2/3] mm/mremap: catch invalid multi VMA moves earlier
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
 <2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6123114000F
X-Stat-Signature: np1huw8nupxo19jxrfnouiji9iakreib
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754662751-17732
X-HE-Meta: U2FsdGVkX1/bAo9SntWT44UPX/BD8b1QpBFvGtLC98CkWGeIj91ZRc+Y7wriUdjseJvk8fth+6qcyprMaLUoMSV/tVQzycBDwAkemy55K0c1p7TXPDJ9zKbmsVbHKGP6+G7vPoUU5zASQdkf6D0/56LtNZd7wJnqB3RbybItdTq9lJ34pY9LMgyyBAM5bIECtAGa6QmX7JItQXgl7SxUwNnd5iKUmWGYQxrX8RkTskOL9ADdY7BRJZ4xBceXH2nY4171V5/C+N9QWVMu8bAhMa/0J3lQT3ezWWFGpuRnKczGjNKsLj9MynWoEDo7iKTMyMkHOhtQ2+ST7u6iU/8tyueynGCT4i66lbXhrtOQIFumSY1aDqO/iPtO2J4mfIKuhA4H2O9fSz0bmcVvCt4x3ULv/wE/CIyeqMsNO7YGEtZLz6jVvGjVr2milGmnoQJ1yqyA+D1A6KWdtTtGDsQuIfJ2R4SMcW8gtHdN0dAJix4TtIm2BniuxVzPpCgdm4rg2gjvSgpdIKVqnEaqb0TIGG+kJo6L/R8hP2uX4dAKhE68pBxWjjaJMQ+s4q2+Ei9hx0XxbW1VDEEp1phf+sF4CxgpmPTUsnQ8yt9tJWkHlejFfL88RokOL1xo39ojSsBdfHBjkcj+JKDjrN+5UgzAIcfchTFaDVR7zCGgE9K5rHga4s0H52HJ9t5SNJb/de8G+enJ9iIAayUO/rdBp4uF64xqu7XmZUCdhO9dCE7JGAjtVpDGyPJVz33o8eLMrx24XT2HRFMpxlzsWAyRv3Bv82W2a0VZuhDAzTksLg5mJOahIcJ01cLyMKNM6vmYNSrsxW51L4aE9WgZoqwfpyafIZG7SQKhsF3XVkZZqoOruv2TR+WMg3oPf8o0TJmv1e77NM2xPqeq6qEi8S3rZ3zDhrNLCx/L5eBzIP4Vg6k2hUWACfdkHFzx81BB36l2Q5q5ZOz2QvHNoLuW1tiqgHv
 NGgxhEly
 yi0tE9ly+njf1dRwLr2vaMZzDStPcyBYwLQ6ucl6nr6LUZjxSGpt1SkiKXBJwgUuaUj8db61qnAOHDn2AMlZkDYec/DAWCh4AWy40A9dPPBqNhIzbsliTNWo6xinWdqD34icGKvDnHSS4TgWmWfYC8f6j3NSZM/FlqQDKuCCFdpLar2Z4k4rSiH1pn2SrppvGc+wL56p2705Wfcc/eytPBpANiwGERTeZN1eDcwkruPsnuVEhgl+JYZwaAKTG3I0BPzuFf3tdCtQdRlWbcGGdBBStV38t8LdWNnAn6kyDCMYlDea/CE0gbRvbIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/25 13:11, Lorenzo Stoakes wrote:
> In remap_move() we must account for both a single VMA case, where we are
> permitted to move a single VMA regardless of multi-VMA move eligiblity, and
> multiple VMAs which, of course, must be eligible for such an operation.
> 
> We determine this via vma_multi_allowed().
> 
> Currently, if the first VMA is not eligible, but others are, we will move
> the first then return an error. This is not ideal, as we are performing an
> operation which we don't need to do which has an impact on the memory
> mapping.
> 
> We can very easily determine if this is a multi VMA move prior to the move
> of the first VMA, by checking vma->vm_end vs. the specified end address.
> 
> Therefore this patch does so, and as a result eliminates unnecessary logic
> around tracking whether the first VMA was permitted or not.
> 
> This is most useful for cases where a user attempts to erroneously move
> mutliple VMAs which are not eligible for non-transient reasons - for
> instance, UFFD-armed VMAs, or file-backed VMAs backed by a file system or
> driver which specifies a custom f_op->get_unmapped_area.
> 
> In the less likely instance of a failure due to transient issues such as
> out of memory or mapping limits being hit, the issue is already likely
> fatal and so the fact the operation may be partially complete is
> acceptable.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/mremap.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 46f9f3160dff..f61a9ea0b244 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1816,10 +1816,11 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  	unsigned long start = vrm->addr;
>  	unsigned long end = vrm->addr + vrm->old_len;
>  	unsigned long new_addr = vrm->new_addr;
> -	bool allowed = true, seen_vma = false;
>  	unsigned long target_addr = new_addr;
>  	unsigned long res = -EFAULT;
>  	unsigned long last_end;
> +	bool seen_vma = false;
> +
>  	VMA_ITERATOR(vmi, current->mm, start);
>  
>  	/*
> @@ -1833,9 +1834,6 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  		unsigned long len = min(end, vma->vm_end) - addr;
>  		unsigned long offset, res_vma;
>  
> -		if (!allowed)
> -			return -EFAULT;
> -
>  		/* No gap permitted at the start of the range. */
>  		if (!seen_vma && start < vma->vm_start)
>  			return -EFAULT;
> @@ -1863,9 +1861,14 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  		vrm->new_addr = target_addr + offset;
>  		vrm->old_len = vrm->new_len = len;
>  
> -		allowed = vma_multi_allowed(vma);
> -		if (seen_vma && !allowed)
> -			return -EFAULT;
> +		if (!vma_multi_allowed(vma)) {
> +			/* This is not the first VMA, abort immediately. */
> +			if (seen_vma)
> +				return -EFAULT;
> +			/* This is the first, but there are more, abort. */
> +			if (vma->vm_end < end)
> +				return -EFAULT;

Hm there can just also be a gap, and we permit gaps at the end (unlike at
the start), right?

So we might be denying a multi vma mremap for !vma_multi_allowed() reasons
even if it's a single vma and a gap.

AFAICS this is not regressing the behavior prior to d23cb648e365
("mm/mremap: permit mremap() move of multiple VMAs") as such mremap() would
be denied anyway by the "/* We can't remap across vm area boundaries */"
check in check_prep_vma().

So the question is just if we want this odd corner case to behave like this,
and if yes then be more explicit about it perhaps.

> +		}
>  
>  		res_vma = check_prep_vma(vrm);
>  		if (!res_vma)
> @@ -1874,7 +1877,8 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  			return res_vma;
>  
>  		if (!seen_vma) {
> -			VM_WARN_ON_ONCE(allowed && res_vma != new_addr);
> +			VM_WARN_ON_ONCE(vma_multi_allowed(vma) &&
> +					res_vma != new_addr);
>  			res = res_vma;
>  		}
>  


