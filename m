Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34280CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4865B6B0095; Tue, 13 Oct 2026 06:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436EF6B0096; Tue, 13 Oct 2026 06:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D436B009D; Tue, 13 Oct 2026 06:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 077016B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:24:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AA8C1C439A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:24:24 +0000 (UTC)
X-FDA: 85317218448.11.EED7470
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E98F160005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:24:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h26yLnY2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AO4B44qH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=srLXcw6u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D4zxZd1k;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791887062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0ZM+dv93LM/1manblR0kAOPbmB0f1yirbC7X2E9OwQ=;
	b=SivgsqDkWpOANlBk3iZDXk5WX+THIaSCXmXQVOEIlce5Z7B5sM87nJVZxoZoGy5aIRi+GK
	mMPEIFtWz2tHsbThKFlE4TmfunccuyPIc6WTmCsSoiQf5a5YrFSl3MIo5la/4ghY1hnR5f
	DIrR8qtKxZka3aJb9YSVSg4cJXRuzoI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791887062;
	b=ubLEF0IHr/5J6P1zQGM86e6C3z499YID2HxOKWuEmQPgstI9/Bd5Y5C3dkSFVsYOpdbmbN
	FRCDaEjx7H+L08WmHUK2C78AmEhRVkl0AxxiLdin852aVQ1rWYz/vpBRLxmnWY7sNlRhKV
	Lgr3GZOR0l3cCOtXoQgjf0kD41BKFvE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h26yLnY2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AO4B44qH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=srLXcw6u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D4zxZd1k;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D66F121F40;
	Tue, 13 Oct 2026 10:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791887061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E0ZM+dv93LM/1manblR0kAOPbmB0f1yirbC7X2E9OwQ=;
	b=h26yLnY2pB46aC1kCvpYvK84GpQY2fr+wAIaCzYhmmla+hBBKKBqUwbI7m3QGGlXAzpIwq
	PK4lzNuOpVSDyp2A/Lduxha+Jp5iFe40y1RUVnuv5xKIwdlRl31p9+hPMtT34ZL1arO7M5
	Jd8Dobb6n5tZ0SPoe0ymF1B2pNoTdBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791887061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E0ZM+dv93LM/1manblR0kAOPbmB0f1yirbC7X2E9OwQ=;
	b=AO4B44qHte1/CYj9esv2X3tCBnNcO0RaAmpCqa8/K6axP6XJKTIcO2J1UsfJUF6bYV/VmU
	9+VhFpdgekpvKGCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791887060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E0ZM+dv93LM/1manblR0kAOPbmB0f1yirbC7X2E9OwQ=;
	b=srLXcw6u+ci93ILb95A8hpj6oCi2PypBoz8xpuSYDHk+ycBFzy7WAeN+VlyDM1M2kVt1z7
	8EEeZgd51zDbfsPLWVk7M4ZLKalea7oZKZKccyGiLxhkFu3AI1+qHUzOS+fLU4QpiZlWSm
	zNibU8X7TdaZ/f39tebQT7ylsS+qIvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791887060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E0ZM+dv93LM/1manblR0kAOPbmB0f1yirbC7X2E9OwQ=;
	b=D4zxZd1kRwjJknytL9V8LKmYE5UUsiBC/0bzU7jxQrtktp26Q07hwZ/Vlim8jZrsC6Mcau
	fzhat25oS/A7GODA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2E4513432;
	Tue, 13 Oct 2026 10:24:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 87bTI9MGzmoiJAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 13 Oct 2026 10:24:19 +0000
Date: Tue, 13 Oct 2026 11:24:18 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz, ayushr@modal.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
Message-ID: <as4FIaQlxb_nqyX9@pedro-suse.tail5790ac.ts.net>
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E98F160005
X-Stat-Signature: caomxuce5bykki4pf6pbhstfndw37n4e
X-HE-Tag: 1791887062-632818
X-HE-Meta: U2FsdGVkX19t68542Hqd+NeI2BCbvQn2Z1H9WfFqvzsFDZODLx5YxHC8+di0y8AUmobQ+5UEQVZhZ7K5jn3lJ/I2sGA7HNMN2gcfKQndy3VVNx9/R5B+K4NXNZ3ic0hdW75J9VGHFpMFamFaov/zDjwm8fM+p72ZJHw0m6ptSGfrKf/2u82ELBvli6LJ0HW3lDxAmKKhkrHc+wPaRhZ/S6fte3OLASHrjmVOxEC1wEOE5EEVkBXIuLQ4UuORdirGfJ4i/C3RQHjF0oxKFDs50quNkW5Z98Y0asYd8PBpM2hb5Fazb9pUPnCWC9h5jmtgxD+ZEHntWmtBqPfN56uIfZ+cPw7Wt33hVQYhJiHJ9uYpIAcIacT0QQxXafceCeEOSkNNssHcajx1weR2XXlFVCans3/jRHpS71hSZ5Gm3EnWnsdeS4dgHsP5Yg8SNa/36Uzia+Foixn1nc6ik6GxiOcbMskwKcSzHYf1FFfZkbycEEI9liP23p8Z9GuKdVm8/rG91p6nWFJssCC3kDjvvmNEL0dVs1UXbwUNW0GVT0JGFLL9WjQF2fdSRgSw+hoXHq68QwuYoyZ2/pWWCMpJdF0X+CvJnSMdJyNYwp4JphYs9WJR3MH3Ednysyy/89AzMaaC+/SGgbo4HGFlBMd5kmU5iVbKQ2KD8XM8jSaw7zc8BHPHTebjmp8eQo76gGPld6Hxx7ZQYdAFuXbTz/sFkTiTgcj3K9ZFVbiS9AjWLHx2RBjA5h2yowykHrCLiik8ClChTETP39XMu41sPpkvl0U9QfAn1ednwyH6hAr42WlJPiiXg2BrdNmfVHdA+ZmtBhGyAmnOYk8ef7WHZcErmP4StPlxqNEU6ulNMviUpzOpDweSWn4n/U0TzD2c8DKRmkPm31sp1B+SG6keKe1xBIPuOOT69lxdn7IdWZ/JR0/Q3Jjh88XalrYuwyoVA5HZvZp7+K6GWyGir5XnUyo
 ZqHf/Iw3
 3YEBe8Sr/VvN5RbgNLM4xjs6tu6imJejcdCjX7ktaeIHcrv5go+vaZ/73rnzEARJEKVLP4E9wEpmYYGd08j9mfXTVfeBptSmA/VCarrvicLD0lkyMmV7c9geOduMvo2vorkrVX4vkqas9wiMaRD4Tqlj9q/3uPt99+ULoa78AUlREf3Os7e0+iWxtrCFwd8rhNVNbsgAtw4P1iKqfaq4tnKrRBCp4YbSIb0TV3gix6TMZ8NXkoYBEFmuI1hz3zp18sFwRai9E1rIFnesZiGT9MsvdV02pZpOJQX301bkn6aHduH8aBL/BfRVtqMQ9xCIpMl/mK9IajUog5yfHy8ZzxA6qRzrysf46oifrq0baffVQWKxhe36B82srIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 03:22:18PM +0800, Baolin Wang wrote:
> Ayush reported an issue that shmem/tmpfs folios are still mapped when
> truncating them on production:
> "
> BUG: Bad page cache in process ...  pfn:...
> page dumped because: still mapped when deleted
> "
> 
> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
> branch, and I got the following crash info. From the dump message, we can
> see that truncate_inode_folio() is really trying to remove mapped folios,
> which is incorrect.
> 
> "
> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
> index:0x3880 pfn:0x191647
> [  189.171995] memcg:ffff0000cc073d40
> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
> .......
> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
> [  189.172026] ------------[ cut here ]------------
> [  189.172027] kernel BUG at mm/filemap.c:155!
> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> .......
> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
> 7.3.0-rc4+ #277 PREEMPT(lazy)
> .......
> [  189.183986] Call trace:
> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
> [  189.184391]  __filemap_remove_folio+0x34/0x160
> [  189.184633]  filemap_remove_folio+0x4c/0xb0
> [  189.184859]  truncate_inode_folio+0x34/0x58
> [  189.185087]  shmem_undo_range+0x220/0x658
> [  189.185308]  shmem_fallocate+0x2f0/0x470
> [  189.185527]  vfs_fallocate+0x128/0x328
> ......
> [  189.187078]  el0t_64_sync+0x184/0x188
> "
> 
> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
> MADV_DONTNEED synchronously releases the pagetable page before calling
> tlb_flush_rmaps(), this could cause another thread's truncation to skip
> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
> as non-zero. A possible race scenario is as follows:
> 
> CPU 0                           CPU 1
> shmem_fallocate                 madvise_dontneed_single_vma
>   unmap_mapping_range            .......
>   ......
>   (filemap_map_pages() remap folios)
> 				  zap_pte_range
>   truncate_inode_folio		    zap_empty_pte_table(pmd clear)
>     unmap_mapping_folio
>     ......
>       zap_pmd_range (saw pmd none, skip)
> 
>   filemap_remove_folio
>     BUG_ON(folio_mapped)
>                                     tlb_flush_rmaps(remove rmaps)
> 
> To fix this issue, we should move the pmd clear operation (via zap_empty_pte_table())
> to after tlb_flush_rmaps() and add smp_wmb()/smp_rmb() memory barriers, so that
> when we find a pmd_none() while unmapping a folio without holding the PTL, the
> folio's mappings are guaranteed to have been removed via tlb_flush_rmaps().
> 
> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
> Reported-by: Ayush Ranjan <ayushr@modal.com>
> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Mostly LGTM, thanks!

> ---
> Changes from v1:
>  - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
> ---
>  mm/memory.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6a8e7772b8d6..c3a1faf580c8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  		}
>  	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
>  
> +	add_mm_rss_vec(mm, rss);
> +	lazy_mmu_mode_disable();
> +
> +	/* Do the actual TLB flush before dropping ptl */
> +	if (force_flush) {
> +		tlb_flush_mmu_tlbonly(tlb);
> +		tlb_flush_rmaps(tlb, vma);
> +	}
> +
>  	/*
>  	 * Fast path: try to hold the pmd lock and unmap the PTE page.
>  	 *
> @@ -2044,16 +2053,13 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  	 * to ensure they are still none, thereby preventing the pte entries
>  	 * from being repopulated by another thread.
>  	 */
> -	if (can_reclaim_pt && direct_reclaim && addr == end)
> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
> +		/*
> +		 * The rmap changes need to be observed before PTEs get zapped.
> +		 * Pairs with smp_rmb() in zap_pmd_range().
> +		 */

I'd amend this comment to something like:
		/*
		 * rmap changes need to be observed before page tables get zapped.
		 * Pairs with smp_rmb() in zap_pmd_range().
		 */
> +		smp_wmb();
>  		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
> -
> -	add_mm_rss_vec(mm, rss);
> -	lazy_mmu_mode_disable();
> -
> -	/* Do the actual TLB flush before dropping ptl */
> -	if (force_flush) {
> -		tlb_flush_mmu_tlbonly(tlb);
> -		tlb_flush_rmaps(tlb, vma);
>  	}
>  	pte_unmap_unlock(start_pte, ptl);
>  
> @@ -2108,6 +2114,11 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
>  			sync_with_folio_pmd_zap(tlb->mm, pmd);
>  		}
>  		if (pmd_none(*pmd)) {
> +			/*
> +			 * Order this PMD read before the folio's mapcount read.
> +			 * Pairs with smp_wmb() in zap_pte_range().
> +			 */

and this one to something like:
			/*
			 * Order this PMD read before any (possible) mapcount/rmap read.
			 * This isn't a problem in most cases, due to us synchronizing on
			 * the PTE lock, but such doesn't happen when PTE tables are zapped.
			 * Pairs with smp_wmb() in zap_pte_range().
			 */
> +			smp_rmb();
>  			addr = next;
>  			continue;
>  		}

Also, as a note, I would suggest we hold off on this fix until the merge window.
I don't think it's that urgent, and it seems like there is a possibility of a
nicer, cleaner fix. That and we need to audit pmd_none() sites for other
possible smp_rmb()'s...

-- 
Pedro

