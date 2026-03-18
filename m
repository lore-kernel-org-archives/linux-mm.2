Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E3110775E4
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 16:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835096B02B3; Wed, 18 Mar 2026 12:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6866B02B4; Wed, 18 Mar 2026 12:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5236B02B5; Wed, 18 Mar 2026 12:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD386B02B3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:43:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8BC31608AE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:43:58 +0000 (UTC)
X-FDA: 84559755756.19.57AC67A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8FDF9100010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:43:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HcU2XUrp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eYScP0Rw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v3WgJK3B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6QnaeyRy;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773852237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yq6umHZrQ3rXklmbUtuDZyytvfdqt87VQPHzx41pFPU=;
	b=YWnYPhn3i1ZyPqlN34KXNEgwPI+x0adZT4g5iTGpQyIgjAmb+zk0rqB48uAcTYtNlINp5P
	LJ0t9sJRXdxp3xQb8bKlCgJCdq3KgEVzNeTUbbwVwybyLHNrnyAcCyzyCSstM7GrzddSqf
	+qs9J1gZeKcKHKIl6Uhxqoef1FSZv3E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773852237; a=rsa-sha256;
	cv=none;
	b=zGaiX6F4OWYB87b59nVuvjNJ5C6jF6yzgm+0U8xktZqUAoQrBDva7L2MlFQfIgIorgVUsv
	qqxyVNgLhCmDCLJj0UeOVp07JBqpObiFSU14NP9xbHe7aohxIYJb5dpQ6Ie8XXwm6LWrvy
	5pqRQ+/50XRPiMgzCPad+GbhDOrD3ms=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HcU2XUrp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eYScP0Rw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v3WgJK3B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6QnaeyRy;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8CCB74D3FC;
	Wed, 18 Mar 2026 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773852234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yq6umHZrQ3rXklmbUtuDZyytvfdqt87VQPHzx41pFPU=;
	b=HcU2XUrp7tTN82bwTT/V/dn7JQb+ud5yJWO2ezKFWJkAtNSnW6FHEvEGlepmICnpF7CcB0
	HmePo7NRMHYrZLW3wSH6E4F5omNGswsGcaluq+GAIPbiazfF7IMK2xsWueV8yhg7F7Uee8
	YZrZ4I7gK5wH/Ez5DjgAO0S8lZ40vNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773852234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yq6umHZrQ3rXklmbUtuDZyytvfdqt87VQPHzx41pFPU=;
	b=eYScP0RwXSrnZsvcBe6RBmZBZx+683ScFXXtoLujDNfldcTonWTY5mdmHzSi8SwyivOsDt
	Yu7rpZwSzZijqeCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773852233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yq6umHZrQ3rXklmbUtuDZyytvfdqt87VQPHzx41pFPU=;
	b=v3WgJK3BkQ3U9xZCGYD3hG5fiC5rsWkrSJ08bx3GRM83sdYyZFuzM1nEjzwVIn0NY6sOXB
	q2nAzHkE6xycu0KyV08n5KKZnVxx3ILn2rw57nW6oWJkLXGLBv9X+NCSdisXBTpYKSJgKm
	xTKaQ3zrmJxpoOQFrwAVNP0erfzjHgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773852233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yq6umHZrQ3rXklmbUtuDZyytvfdqt87VQPHzx41pFPU=;
	b=6QnaeyRyNOyl3U1h9EDt8rDAYrgUmw7AhgCTBE/dzz4BX5VdXOGANHHg68eMsZ/QCzindq
	3+jKuRnYJdZD0iAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E5EF4273C;
	Wed, 18 Mar 2026 16:43:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Um7THknWummKcgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 16:43:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 32AD6A0AFF; Wed, 18 Mar 2026 17:43:53 +0100 (CET)
Date: Wed, 18 Mar 2026 17:43:53 +0100
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, ryan.roberts@arm.com, 
	david@kernel.org, ajd@linux.ibm.com, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org, 
	catalin.marinas@arm.com, dev.jain@arm.com, jack@suse.cz, kees@kernel.org, 
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, 
	rmclure@linux.ibm.com, Al Viro <viro@zeniv.linux.org.uk>, will@kernel.org, 
	willy@infradead.org, ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 2/4] mm: bypass mmap_miss heuristic for VM_EXEC readahead
Message-ID: <wwaqkpuvvrnp4obj6nyebbgqvugjsmelbdkunoiadqtebh4zr7@ckyn5taaz4jy>
References: <20260310145406.3073394-1-usama.arif@linux.dev>
 <20260310145406.3073394-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310145406.3073394-3-usama.arif@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8FDF9100010
X-Stat-Signature: j4gw3c9t3aot6cj99h83z5w1uf71e61q
X-Rspam-User: 
X-HE-Tag: 1773852236-792994
X-HE-Meta: U2FsdGVkX18bfQ/ex8WupCkNUZu0jBUSWUtyicoweGVVj+tR5HwKfpYE8xgDlSpdHurXx8lhHIA6SjGZLOXmLYS4ALvpcRUQdJJN5DuDdmLd34br2dHf0fVyXQX16w7qxkupODpOOBQ4Mc1JG9PHoWH7IDJPTdjeMIB4Gni5ArlT9BHV88ch7uC+Lbt43cbsuFWS4Zrl4wy8/JxM2/R5oIsZ+Mz2p2LanhXMm8vQwCk2gVGkDUT4qDz5X7JHG3jA3yixgJ7vSCgHTaK0GPK+A7zKkwGPd1kidyCtOUltqbACNjbFOVnfidDe22eQQDHnWsHEGxDaokFT6djh/STIiVXgDu3hadHfI/qwZhzYXBXr3FsskpmIjY9DW1UM0tjBZaTlyQxVw80bg/8AyybR5YaRIBbEqVvh1PplBOXy6y9nh78VGbq9ruaZAvb2JdnCxPXURwgfLBRCJNH+rqOVXErWAwfgR3JwApMxnGlheWJwszWMIA0JTaqKUjhU0Dm5AXH8vmcdp9uAUInhuGEiBsCVMvruwUKw6D3Vt9mKxzeSbS+4Col/Pg0IB/TepzkyMp4+jKyB6Lq9PoP6QBZImSl93YoW8l95ANVES6snnrjCFokcsIU/nz/Tg0sLDQG5SLEv00hcCxepbHTbJ4cw2NosJwQRFTzU5iqUTyCA8zBM8BGw3k9gBAZpyfGymG5exdg6WvHlBOQymfJ6exwFVZLhMVPBbBWNnZFtE3Z89XSbN9FowRhBLoWwhZMSpoDgIFE/mxW45m83pU6huP6nErRvou8vAoUv58fnmPqpSX2PoY2lX88ssTP220FIflSC8ob7I/3aooKIzcbEV1hBfjV6bT1/RVrdaZn+M3XySIyO/B+xSRAilKLqqTVCxKAP4EzQUAbGGqmYhY9M/2+wVuwhAZZZWv7n9Pmrrae3y2iEXDuLDjcwYlmvg6SsK760POJ12dg2vObNtW2ug45
 Nfl7FS3g
 1PvZHhNKOo539+SHRyQxx4o+Oudq3IUK6QIh5HrlFj9sJLeoKwhmhOQnkUquJdm8Do7yMB2jTIVmEMmyy8hEH6x6yIkoot1OwfIWsNnPBDDwBqU/AM5Uop56gDdNiY+iRWUGG9BMdWT42g/HpPke6owLFo7dQaS278u8vgYPOSPKn1nGn5BAPinaEU6BrMgUWXLC3Ke81DrAwuWJjRxj9JWOL9YteczhNCbES1aVEsXUYijpuzwEDxltChDoaY4ZM2fDb2PIV1Nv7ZYY3q/tr65/6BLEDz7GDWYYp2vh5l2b6UVqcQxIbia0vPLw3PtVkE2yt5j+EZEtcwEHVWEUjjgd3bzsfHOcNQaKMt3JKIcwemAMVUd35FBYmLbuYFYAs+CCNQz2MH/ossFT1z/E7CELjHHZeAvvlWWX/1ooW+6rShjHCQ8gLO3eh8mfKTUuRS0aCyGUxj94IyvruXVSzDmsqNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 10-03-26 07:51:15, Usama Arif wrote:
> The mmap_miss counter in do_sync_mmap_readahead() tracks whether
> readahead is useful for mmap'd file access. It is incremented by 1 on
> every page cache miss in do_sync_mmap_readahead(), and decremented in
> two places:
> 
>   - filemap_map_pages(): decremented by N for each of N pages
>     successfully mapped via fault-around (pages found already in cache,
>     evidence readahead was useful). Only pages not in the workingset
>     count as hits.
> 
>   - do_async_mmap_readahead(): decremented by 1 when a page with
>     PG_readahead is found in cache.
> 
> When the counter exceeds MMAP_LOTSAMISS (100), all readahead is
> disabled, including the targeted VM_EXEC readahead [1] that requests
> arch-preferred folio orders for contpte mapping.
> 
> On arm64 with 64K base pages, both decrement paths are inactive:
> 
>   1. filemap_map_pages() is never called because fault_around_pages
>      (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
>      requires fault_around_pages > 1. With only 1 page in the
>      fault-around window, there is nothing "around" to map.
> 
>   2. do_async_mmap_readahead() never fires for exec mappings because
>      exec readahead sets async_size = 0, so no PG_readahead markers
>      are placed.
> 
> With no decrements, mmap_miss monotonically increases past
> MMAP_LOTSAMISS after 100 page faults, disabling all subsequent
> exec readahead.
> 
> Fix this by moving the VM_EXEC readahead block above the mmap_miss
> check. The exec readahead path is targeted. It reads a single folio at
> the fault location with async_size=0, not speculative prefetch, so the
> mmap_miss heuristic designed to throttle wasteful speculative readahead
> should not gate it. The page would need to be faulted in regardless,
> the only question is at what order.
> 
> [1] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I can see the problem but I'm not sure what you propose is the right fix.
If you move the VM_EXEC logic earlier, you'll effectively disable
VM_HUGEPAGE handling for VM_EXEC vmas which I don't think we want. So
shouldn't we rather disable mmap_miss logic for VM_EXEC vmas like:

	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
		...
	}

								Honza

> ---
>  mm/filemap.c | 72 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 39 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6cd7974d4adab..c064f31ecec5a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3331,6 +3331,37 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		}
>  	}
>  
> +	if (vm_flags & VM_EXEC) {
> +		/*
> +		 * Allow arch to request a preferred minimum folio order for
> +		 * executable memory. This can often be beneficial to
> +		 * performance if (e.g.) arm64 can contpte-map the folio.
> +		 * Executable memory rarely benefits from readahead, due to its
> +		 * random access nature, so set async_size to 0.
> +		 *
> +		 * Limit to the boundaries of the VMA to avoid reading in any
> +		 * pad that might exist between sections, which would be a waste
> +		 * of memory.
> +		 *
> +		 * This is targeted readahead (one folio at the fault location),
> +		 * not speculative prefetch, so bypass the mmap_miss heuristic
> +		 * which would otherwise disable it after MMAP_LOTSAMISS faults.
> +		 */
> +		struct vm_area_struct *vma = vmf->vma;
> +		unsigned long start = vma->vm_pgoff;
> +		unsigned long end = start + vma_pages(vma);
> +		unsigned long ra_end;
> +
> +		ra->order = exec_folio_order();
> +		ra->start = round_down(vmf->pgoff, 1UL << ra->order);
> +		ra->start = max(ra->start, start);
> +		ra_end = round_up(ra->start + ra->ra_pages, 1UL << ra->order);
> +		ra_end = min(ra_end, end);
> +		ra->size = ra_end - ra->start;
> +		ra->async_size = 0;
> +		goto do_readahead;
> +	}
> +
>  	if (!(vm_flags & VM_SEQ_READ)) {
>  		/* Avoid banging the cache line if not needed */
>  		mmap_miss = READ_ONCE(ra->mmap_miss);
> @@ -3361,40 +3392,15 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		return fpin;
>  	}
>  
> -	if (vm_flags & VM_EXEC) {
> -		/*
> -		 * Allow arch to request a preferred minimum folio order for
> -		 * executable memory. This can often be beneficial to
> -		 * performance if (e.g.) arm64 can contpte-map the folio.
> -		 * Executable memory rarely benefits from readahead, due to its
> -		 * random access nature, so set async_size to 0.
> -		 *
> -		 * Limit to the boundaries of the VMA to avoid reading in any
> -		 * pad that might exist between sections, which would be a waste
> -		 * of memory.
> -		 */
> -		struct vm_area_struct *vma = vmf->vma;
> -		unsigned long start = vma->vm_pgoff;
> -		unsigned long end = start + vma_pages(vma);
> -		unsigned long ra_end;
> -
> -		ra->order = exec_folio_order();
> -		ra->start = round_down(vmf->pgoff, 1UL << ra->order);
> -		ra->start = max(ra->start, start);
> -		ra_end = round_up(ra->start + ra->ra_pages, 1UL << ra->order);
> -		ra_end = min(ra_end, end);
> -		ra->size = ra_end - ra->start;
> -		ra->async_size = 0;
> -	} else {
> -		/*
> -		 * mmap read-around
> -		 */
> -		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
> -		ra->size = ra->ra_pages;
> -		ra->async_size = ra->ra_pages / 4;
> -		ra->order = 0;
> -	}
> +	/*
> +	 * mmap read-around
> +	 */
> +	ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
> +	ra->size = ra->ra_pages;
> +	ra->async_size = ra->ra_pages / 4;
> +	ra->order = 0;
>  
> +do_readahead:
>  	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>  	ractl._index = ra->start;
>  	page_cache_ra_order(&ractl, ra);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

