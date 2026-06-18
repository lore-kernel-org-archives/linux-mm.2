Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1453CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CB86B008C; Thu, 18 Jun 2026 08:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2DA36B0092; Thu, 18 Jun 2026 08:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C776B0095; Thu, 18 Jun 2026 08:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79D576B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:09:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E316A06E6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:52:48 +0000 (UTC)
X-FDA: 84892871616.18.6930D56
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 075C98000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:52:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VpjFI/uc";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nbxlDCTE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VpjFI/uc";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nbxlDCTE;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781783566;
	b=PWZWc1UbVUOMoX2zL3Ximv7P+46KREmH639qtLfh2dwjIf8WOuv4z4HY6W1R5VJaXTBffE
	56KKyC6vs4Mj/kEcmRTuAHQPPj1UkBOwr3KgmeXCvxV/Anv0RHUddJeCa6jlPSbOm4KK8O
	BqQWW9i4KxCyuURBfM7ZQoj3eXMgTHU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VpjFI/uc";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nbxlDCTE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VpjFI/uc";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nbxlDCTE;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781783566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEU8ULJ9WVWauU7Hmy0OmdTpWlCSAnosxhY6LpVUHus=;
	b=UDMA000BhpuR+hocuCOvGEjfcO5ogApSkKmX5kAsnEFfsVcqLAFfKTCIQwUhAmWuc2ibTh
	Q3/mz+6gw0zdqGXduLmm1BGWVl6PlF0Fa5mkJSeQoZhSpDoMyS8FKJ8Rh9txZpyzv0AD9K
	8VlgHanD8czSCF965YFv41wC5u1VeVQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BDBE46D1E8;
	Thu, 18 Jun 2026 11:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781783564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEU8ULJ9WVWauU7Hmy0OmdTpWlCSAnosxhY6LpVUHus=;
	b=VpjFI/uc8sR0nYvsju9jkaLtT2RK5sZnr4hp7AUCNhDl76IzqEwKknksbzgSA6azvuYx3Y
	Ve44xQwtGG+klAS9XFPmlN2hAtJiQXF9ZiZP596YU5x5Vo3/ZUZRIVDnkAZ7JOQBIsr2lf
	QBVUVCh3c3y4hFA4qMLtFiNPaKXUVhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781783564;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEU8ULJ9WVWauU7Hmy0OmdTpWlCSAnosxhY6LpVUHus=;
	b=nbxlDCTELdZzi0P96bLvwm4JTlT0ChzRo6p+J6JcYseNNq24vKxHSwhXu1YUw9EHCdoW6L
	ergWTqrPetzkhuBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781783564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEU8ULJ9WVWauU7Hmy0OmdTpWlCSAnosxhY6LpVUHus=;
	b=VpjFI/uc8sR0nYvsju9jkaLtT2RK5sZnr4hp7AUCNhDl76IzqEwKknksbzgSA6azvuYx3Y
	Ve44xQwtGG+klAS9XFPmlN2hAtJiQXF9ZiZP596YU5x5Vo3/ZUZRIVDnkAZ7JOQBIsr2lf
	QBVUVCh3c3y4hFA4qMLtFiNPaKXUVhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781783564;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kEU8ULJ9WVWauU7Hmy0OmdTpWlCSAnosxhY6LpVUHus=;
	b=nbxlDCTELdZzi0P96bLvwm4JTlT0ChzRo6p+J6JcYseNNq24vKxHSwhXu1YUw9EHCdoW6L
	ergWTqrPetzkhuBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CFEB779A8;
	Thu, 18 Jun 2026 11:52:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n+DXAwzcM2rLfQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Jun 2026 11:52:44 +0000
Date: Thu, 18 Jun 2026 12:52:42 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm: mprotect: use walk_page_range_vma() in
 mprotect_fixup()
Message-ID: <ajPbpLBqYc8uTyUJ@pedro-suse>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618092845.3905740-3-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 075C98000C
X-Stat-Signature: y8efdm3gtyrs8fhyw6eoit9r57hofau6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781783565-928267
X-HE-Meta: U2FsdGVkX19QhhwvzJoHHx4n1XpE9QjM48miMvx2nz7cffB4r8Bco5Soq1WHgdtD3LoNR75lfOpzD0F5iRWhKADE18eL+anst8gDGBWF8wV0mCpp3gMV8rY1Zl0o+emRbGWS4xEUCbB4uRsx6xF5lpTCWUt77f5sqlxwwhuZOwP7lLgVonUg9mz8PXPEd7CkZXYXvpoRa6wfHgwUt4cjxctu0tQK0ymb/Sq4OcY5I8LFPReVp6+Quf1xhrgx5IKi0A4aO4ZWvkNCC/9bm3z2DV2ME6QbCBaCCb2GBaieB3g0VrB7ITxPOQx0M+biezQGy8TZNPGiuXUxXrila8xHZtxPZEBqm6fGtKyjw43w+IlMj50lV5XzxULfiyBh1pocOfq81v/+AIdwKxtThSdTNCrnr2g7qM8xSPz9iG1bwc5xZmXHIM+Kht5CApTr7qFQvMpPpy4/Zb+nCGFpdf6HJ0SmQx4//7xBYkRzPFQN2NXMLiuGf/1NeWw5oMtcbxgoz3vbkjwYgJO3rRaWNuS1QE0GQrxTnlsxkEFX9TLqjnSS8bi4wNyJe9O8w6yy5tGFNPImX1M86HDJlzufhxAvl5KyxoOnhuniB3OywZnytXWgxviTQEaCs1vx8HahPfVygTBIlTzW/XEKqTJqL3P1PzvFdrjzhzc7iZuWXxs7WybRkFfFjxuqWchVYfdyzqNHHwUDNF6vZV39Ib+uPa37jBe2CSFeH1jp7jdVTtu22G/vZcCWXmsTu+wm8r2+X3P44Fmk5tmrIxsVMv0VsURKZwXbtQCvA+PuyUAMKNfk/AMaDlptzOxRpKjEaTczhT9Fs+xUtuSRb3kSFVIDWooswmz8sfvbyHK/4oVf/DI1QLPgxyG/jIuMwSNT4Uip+oQllqiNi+2xPymIzVFo6EBQjoc6efaZGcwGbzLTKFZy725CiHBxB5xh3R3ncPFw/l1Hk3AebtTFa0FPL2pDW49
 XpoqZoBO
 pb0lc2j2qqaIHTf6dfavsI2XnAkBvIKrhO/fiHm2E+uzHtqpmExbMQKv4lV+NxTrYol8XPMR24CMTWw3WQsA97VKAj7jY7b3kw7PrZSgPCQANxChGq4MVKYV9CuJnqmmWdFLLlbKPGIetjshZOcGr2wUyyJmS0bSboDrn8TN56K1LWTqIRGn6QYrcY8ukYINhxNfyKGyxoWdX0aA5lOiXB6syjMyqwNr8LKjlDA2gugpMo6D06FlypQFQvP9tt/4pmFS7+YwwNR2cqZQz0mD3JrkF7HRrG+1PghYSx9DOGYLmWNe56dTaWpnRkoPN49kVW2nIymqP+PRfvS7kQpcgRwAownYzf7J3lxl4rZrVd609DruYTz/Y5bDCuRgGwxy1CBv1hcUO+kwe4VM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 05:28:43PM +0800, Kefeng Wang wrote:
> In mprotect_fixup(), the PROT_NONE PFN permission check uses
> walk_page_range() to walk the page table. Fortunately, the caller
> always passes start/end that falls within a single VMA, the
> do_mprotect_pkey() iterates per-VMA via for_each_vma_range(),
> and setup_arg_pages() passes the whole VMA.
> 
> Note, walk_page_test() isn't called in walk_page_range_vma(),
> however, prot_none_test() in prot_none_walk_ops always return 0,
> so it's safe to replace walk_page_range() with walk_page_range_vma()
> to eliminate an unnecessary find_vma() lookup, also remove
> unneeded prot_none_test() too.

Again, I strongly prefer walk_page_range_vma() to be consistent with
walk_page_range() and others. But the change itself (apart from that)
is fairly uncontroversial, LGTM.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mprotect.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028c..b1595450e241 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -708,16 +708,9 @@ static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>  		0 : -EACCES;
>  }
>  
> -static int prot_none_test(unsigned long addr, unsigned long next,
> -			  struct mm_walk *walk)
> -{
> -	return 0;
> -}
> -
>  static const struct mm_walk_ops prot_none_walk_ops = {
>  	.pte_entry		= prot_none_pte_entry,
>  	.hugetlb_entry		= prot_none_hugetlb_entry,
> -	.test_walk		= prot_none_test,
>  	.walk_lock		= PGWALK_WRLOCK,
>  };
>  
> @@ -753,7 +746,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
>  		pgprot_t new_pgprot = vm_get_page_prot(newflags);
>  
> -		error = walk_page_range(current->mm, start, end,
> +		error = walk_page_range_vma(vma, start, end,
>  				&prot_none_walk_ops, &new_pgprot);
>  		if (error)
>  			return error;
> -- 
> 2.27.0
> 
> 
> 

-- 
Pedro

