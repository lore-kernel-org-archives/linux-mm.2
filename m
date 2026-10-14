Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393D7CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46236B0088; Wed, 14 Oct 2026 10:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF54C6B0092; Wed, 14 Oct 2026 10:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95DE6B0095; Wed, 14 Oct 2026 10:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A03346B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:05:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 275CE120558
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:05:18 +0000 (UTC)
X-FDA: 85321403916.01.D09B513
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 06D6480017
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:05:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0XvkIx6Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P0oixPkI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0XvkIx6Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P0oixPkI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791986716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jzBRIumIkRQfzVUhv0b17LsLJAndLvzauLlUMqudqo=;
	b=Hx7gdKsvlE33ecwX3+/D8OxyRXHSoYuMB79ygiJdIgipfCwxi5TVmcVwohMipyMtVOyMCi
	NaUWyOaT3I2ipN+5REoxRaS1vRBIqFK2AFJX8C1pu4MLowFycK+b8vwNyUYY5H5z1BAN3O
	+NjGsXajOS0veXb8skTNYwrTzAhphHs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0XvkIx6Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P0oixPkI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0XvkIx6Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P0oixPkI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791986716;
	b=GX+GfM6lHHA4JusMCgyYQNy4MsZCQSIJlGLViHK1p0FRTpVut4ktXxlV+bwzMSLSn82Eao
	1GrXESwa8g/ylfN+06tucGF87rRZH4tyjYAkPHkjeMXEc877C2NwP0T3txyuZESEC3TMK+
	C+KH6DwWw9QZhPsnFLTSt2rT007DnlM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B7CF31FBB7;
	Wed, 14 Oct 2026 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791986714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jzBRIumIkRQfzVUhv0b17LsLJAndLvzauLlUMqudqo=;
	b=0XvkIx6ZsNBk27nnMlmBbhpsARlPLSs0NpDQW1OdCoZlEvkpBwC54O5c8HO89zXv4r0Wq7
	6pv6mvgjrOXNpGCJtc+PwfkpvO88lEU99z82bAupoxafwV9RXr7eLERl1BJwIbon4nnVUn
	tbSeNEue0lx7erI1P59EhziUN1zsSBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791986714;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jzBRIumIkRQfzVUhv0b17LsLJAndLvzauLlUMqudqo=;
	b=P0oixPkIAon4rHjZ8LShiwbrjZxTnqzwWCZVGCVSGljNzBfFZZTySaPpQrPhuFOyybRf0h
	WKgb27CyPPea8VAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791986714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jzBRIumIkRQfzVUhv0b17LsLJAndLvzauLlUMqudqo=;
	b=0XvkIx6ZsNBk27nnMlmBbhpsARlPLSs0NpDQW1OdCoZlEvkpBwC54O5c8HO89zXv4r0Wq7
	6pv6mvgjrOXNpGCJtc+PwfkpvO88lEU99z82bAupoxafwV9RXr7eLERl1BJwIbon4nnVUn
	tbSeNEue0lx7erI1P59EhziUN1zsSBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791986714;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jzBRIumIkRQfzVUhv0b17LsLJAndLvzauLlUMqudqo=;
	b=P0oixPkIAon4rHjZ8LShiwbrjZxTnqzwWCZVGCVSGljNzBfFZZTySaPpQrPhuFOyybRf0h
	WKgb27CyPPea8VAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66BEA133F1;
	Wed, 14 Oct 2026 14:05:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id au8sMReMz2qmZAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 14 Oct 2026 14:05:12 +0000
Date: Wed, 14 Oct 2026 15:05:10 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz, 
	ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
Message-ID: <as-L6bGPpGRiF4-Q@pedro-suse.tail5790ac.ts.net>
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
 <405811f5-ee36-4b3c-80d0-7dc6827ab5d4@linux.alibaba.com>
 <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
X-Stat-Signature: yb1x6qr7kd5c7p3bcs6tsbzu39pd6mmw
X-Rspam-User: 
X-Rspamd-Queue-Id: 06D6480017
X-Rspamd-Server: rspam08
X-HE-Tag: 1791986715-969663
X-HE-Meta: U2FsdGVkX1/yV8zgWRa89DtQAVA3cCnsJdymK+iYP3h6ys62lamM92rlKLHpmxhTi1IOeOXfebqrnqrD6DCuR973DtH3Y8fqIIjlbv+j/8CCVMDTOIU5Tm9WySUo1om1pSe8bN5r4NXVcQ0JUvf+ID5W5kzjJQgJ+X1hn4hcmhULtlpz4/3hcJuqzTLmJ8CcoRTs53/DGRqzLmpmJD76IH4ab/9dSFQm6ecUUvJzuKrv6A7LUdTNIhH626N5YYFOcdzNM+dN4jAlGvn4+DsH3uBPRTljmkLY+9BnMf9t4M6QlwnQGv6aOa2eZ2kVji2QBSXjSqRrT4KbUO1t6ExnsTrc6WAxo2Cvo9cNQpl2QoPeR+o4RKpaITpnEw8qyGF3Hg0FqButLgzwGYDqqjQRW9kYKA/ghKG9tsHFLrzsLZqCEyTwYCD7DNy+g5ka2uy0ZtyPlIvMK3y6o8ekSoAymMj12xoJCY6Fk+CiIVKZPO3qAYCHHW5Sf8NfupDI60KzlLRhONDWd3ru9Rf0Pn2yctq7ZiIaA5/VPWKjo4B9KTvl6w2wCUHmeiOhAeu6ryInrUxgR8KHRy0/PBmJMkj5grXpTBUYme2uLIMZAJj3Wrkj3AxNb/epOqk16+s/NzKjOMihG8/Lnd94JYN3fszB6OjApZiVEc/BDHx8FkElVRHmP4xlYBWfNKcSme61KVfPS0UVz5f8B/BMz0tJlYGePInbPz0MJrC2YMGX2Ra4/GYoCnh4Ns2u34SoxjFGL1rEgMi2iDUw52MfPs6VdoWrlyRaS5OUkafryFMGGQKI/lPMXiEAYkGzriSS3bIvtnJV0nLAboFmxs5NYjEvVtEEbttaD32SJa2jn68Gz2YpCzUY4zb2LaGbWxMkkFZry6wgm7uKaF/Pm4ZUoCJ3rJ1Cq1NopbyYVjgI1e4DpFguayztm92+4SlGHc0MV6qNvec3FNYnwHtQIhFynMNECSv
 ctAScQ7R
 3BNEBitfi9wJBr6WhgM05X5m8lhjKyDawzs/JYRpSjkUbzVpjBmUA7z3m+tAMtvp75KnRxTHXh1dDRKlpPaP1gdi5Og4o5DQR92+f7i2khxIHui2ZrRMBfjqxQhs96PLUcM0i6Wa0TujhBwNYWSYg6pwJtWrzlX/KOweswv8gtgIyhBbwkN4RsMragKnBGR39rVSmXxR4sV9tsxauZV7Kw44XWUsfjSh5gxSeMaq5V6wrwQqirYDSFEo6Y8RjVw47hWKDQEk+MIDbqO6atB/GXwuCdEPoBjiL/cjn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 03:25:33PM +0200, David Hildenbrand (Arm) wrote:
> On 10/13/26 11:36, Baolin Wang wrote:
> > 
> > 
> > On 10/12/26 6:23 PM, David Hildenbrand (Arm) wrote:
> >> On 10/10/26 09:22, Baolin Wang wrote:
> >>> Ayush reported an issue that shmem/tmpfs folios are still mapped when
> >>> truncating them on production:
> >>> "
> >>> BUG: Bad page cache in process ...  pfn:...
> >>> page dumped because: still mapped when deleted
> >>> "
> >>>
> >>> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
> >>> branch, and I got the following crash info. From the dump message, we can
> >>> see that truncate_inode_folio() is really trying to remove mapped folios,
> >>> which is incorrect.
> >>>
> >>> "
> >>> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
> >>> index:0x3880 pfn:0x191647
> >>> [  189.171995] memcg:ffff0000cc073d40
> >>> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
> >>> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
> >>> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
> >>> .......
> >>> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
> >>> [  189.172026] ------------[ cut here ]------------
> >>> [  189.172027] kernel BUG at mm/filemap.c:155!
> >>> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> >>> .......
> >>> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
> >>> 7.3.0-rc4+ #277 PREEMPT(lazy)
> >>> .......
> >>> [  189.183986] Call trace:
> >>> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
> >>> [  189.184391]  __filemap_remove_folio+0x34/0x160
> >>> [  189.184633]  filemap_remove_folio+0x4c/0xb0
> >>> [  189.184859]  truncate_inode_folio+0x34/0x58
> >>> [  189.185087]  shmem_undo_range+0x220/0x658
> >>> [  189.185308]  shmem_fallocate+0x2f0/0x470
> >>> [  189.185527]  vfs_fallocate+0x128/0x328
> >>> ......
> >>> [  189.187078]  el0t_64_sync+0x184/0x188
> >>> "
> >>>
> >>> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
> >>> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
> >>> MADV_DONTNEED synchronously releases the pagetable page before calling
> >>> tlb_flush_rmaps(), this could cause another thread's truncation to skip
> >>> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
> >>> as non-zero. A possible race scenario is as follows:
> >>>
> >>> CPU 0                           CPU 1
> >>> shmem_fallocate                 madvise_dontneed_single_vma
> >>>    unmap_mapping_range            .......
> >>>    ......
> >>>    (filemap_map_pages() remap folios)
> >>>                   zap_pte_range
> >>>    truncate_inode_folio            zap_empty_pte_table(pmd clear)
> >>>      unmap_mapping_folio
> >>>      ......
> >>>        zap_pmd_range (saw pmd none, skip)
> >>>
> >>>    filemap_remove_folio
> >>>      BUG_ON(folio_mapped)
> >>
> >> That reminds me of sync_with_folio_pmd_zap() usage in page_vma_mapped_walk().
> >>
> >> Isn't that the better approach?
> > 
> > I had considered this approach before, but it is not feasible. IIUC, the
> > sync_with_folio_pmd_zap() is used to address the race with zap_huge_pmd(), and
> > both the PMD clear and the folio mapcount decrement are performed under the PMD
> > lock in zap_huge_pmd().
> 
> Just to be clear, I am thinking about something like the following on the
> zap_pmd_range() side:
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c94..a8820ad7e2f21 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -584,14 +584,15 @@ void free_pgtables(struct mmu_gather *tlb, struct
> unmap_desc *desc);
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
> 
>  /**
> - * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
> + * sync_with_folio_pmd_zap - sync with concurrent zapping of folios
>   * @mm: The mm_struct.
>   * @pmdp: Pointer to the pmd that was found to be pmd_none().
>   *
>   * When we find a pmd_none() while unmapping a folio without holding the PTL,
> - * zap_huge_pmd() may have cleared the PMD but not yet modified the folio to
> - * indicate that it's unmapped. Skipping the PMD without synchronization could
> - * make folio unmapping code assume that unmapping failed.
> + * zap_huge_pmd() or zap_empty_pte_table() may have cleared the PMD but not
> + * yet modified the mapped folios to indicate they are unmapped. Skipping the
> + * PMD without synchronization could make folio unmapping code assume that
> + * unmapping failed.
>   *
>   * Wait for concurrent zapping to complete by grabbing the PTL.
>   */
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3de..c585f5eb255c9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2139,9 +2139,7 @@ static inline unsigned long zap_pmd_range(struct
> mmu_gather *tlb,
>                                 continue;
>                         }
>                         /* fall through */
> -               } else if (details && details->single_folio &&
> -                          folio_test_pmd_mappable(details->single_folio) &&
> -                          next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
> +               } else if (details && details->single_folio && pmd_none(*pmd)) {
>                         sync_with_folio_pmd_zap(tlb->mm, pmd);
>                 }
>                 if (pmd_none(*pmd)) {
> 
> > 
> > However, the race here is different: tlb_flush_rmaps() is under the PTE lock,
> > while zap_empty_pte_table() is under the PMD lock, and reordering between the
> > two functions is also possible. That is, the folio mapcount operation could
> > execute after the acquire barrier (spin_lock()) of zap_empty_pte_table(),
> > allowing a reader on CPU 0 to incorrectly observe that the PMD is none while
> > mapcount > 0.
> 
> I think we really just have to make sure to flush rmaps before zapping the PMD.
> Then it's really just the same thing we had before with sync_with_folio_pmd_zap().

Hmm, could we viably replace sync_with_folio_pmd_zap() with the memory barriers
instead? Seems lighter-weight and functionally equivalent?

-- 
Pedro

