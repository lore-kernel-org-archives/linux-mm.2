Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F50ECCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77AF36B009B; Fri, 16 Oct 2026 04:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B426B009D; Fri, 16 Oct 2026 04:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668956B009E; Fri, 16 Oct 2026 04:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 337906B009B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:57:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4924A025B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:57:49 +0000 (UTC)
X-FDA: 85327886658.15.5D6E41F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8EFC140005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:57:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="h/Wumc78";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=27Sy7gqD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="h/Wumc78";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=27Sy7gqD;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792141067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTHE59qFKdXlGzm4a4lQOx7/fPFo6UGzecCpWrMgCi8=;
	b=X49l4StoTt7oa5YvdRxn/IBwes4t9+7WvY2f3R80xxbuyMLavDLJSKlnK2ehRTWBMDB66o
	KL1akdmHFw6jrO4WQPiFM/hJb6gJ2w0jhJTV7pPZRUJND/FtX4qtA+nR8+l2W4/FURU08g
	1v8r4F1nN+6wTH7kPa5GMMBE7Yy47hM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792141067;
	b=Z0uy3wKmk6vankCvz5dAyPy5DC9tjKjANrmiyygjjvmnlM6NNr7YnKst8Bak/V/L1na5ED
	NTN31nkjvCK9GrcZDdtepX/1XL+zxeOxut6cSQbs0JgkJGEI95GXUSxGLOESdURe5UMNon
	R0WcLTXTSzJx8EvHyW2jNSP66eE517k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="h/Wumc78";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=27Sy7gqD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="h/Wumc78";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=27Sy7gqD;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 393B71F444;
	Fri, 16 Oct 2026 08:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792141066; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hTHE59qFKdXlGzm4a4lQOx7/fPFo6UGzecCpWrMgCi8=;
	b=h/Wumc78Ru80QESHNjTTcEJO785CmYuTkuT125HJa/pU+5kD1btkF6PK76g2g1hxz3AHui
	chRxam58glQPmxc7dcKU7CNkTrDis3Fn3XNaRWggJHkVNhE+hTBEuwVVvaoaxbGabPPCpm
	L0ZdRe/BEMWiNoJTEVEwRCo3Vuhzp9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792141066;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hTHE59qFKdXlGzm4a4lQOx7/fPFo6UGzecCpWrMgCi8=;
	b=27Sy7gqDeqUeA4H8viYb/lq0RsS7KbG2FHNZqTMB10CXpvDPS1qToRmpwFzFq/9bG0v99C
	kAaIhf4Ie7u5TDCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792141066; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hTHE59qFKdXlGzm4a4lQOx7/fPFo6UGzecCpWrMgCi8=;
	b=h/Wumc78Ru80QESHNjTTcEJO785CmYuTkuT125HJa/pU+5kD1btkF6PK76g2g1hxz3AHui
	chRxam58glQPmxc7dcKU7CNkTrDis3Fn3XNaRWggJHkVNhE+hTBEuwVVvaoaxbGabPPCpm
	L0ZdRe/BEMWiNoJTEVEwRCo3Vuhzp9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792141066;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hTHE59qFKdXlGzm4a4lQOx7/fPFo6UGzecCpWrMgCi8=;
	b=27Sy7gqDeqUeA4H8viYb/lq0RsS7KbG2FHNZqTMB10CXpvDPS1qToRmpwFzFq/9bG0v99C
	kAaIhf4Ie7u5TDCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CD841339F;
	Fri, 16 Oct 2026 08:57:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HXRvOwjn0Wo3eAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 16 Oct 2026 08:57:45 +0000
Date: Fri, 16 Oct 2026 09:57:43 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz, ayushr@modal.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: memory: fix truncation removing mapped folios
Message-ID: <atHm7pTzdQKhKptk@pedro-suse.tail5790ac.ts.net>
References: <e2f76ed117b0c22a26b7688fd46a38c9d035336e.1792114445.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2f76ed117b0c22a26b7688fd46a38c9d035336e.1792114445.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8EFC140005
X-Stat-Signature: ajmbofro8mh3u78coj3sgm1g1jjeu5fs
X-HE-Tag: 1792141067-989082
X-HE-Meta: U2FsdGVkX1/gS+Udd+N7pNblSGdAVALrZzenZM2bM15MO5qLdwyo3hVHhicdKGVgYoG9J9/iHOCaZXHei5BEwLUyyRUoZOvI+JmsYlzB4UtT/sCaADZuVLEmxYd622UEYoSmAJwVXhnRUPpTTAkDZIuedrm8nYHs7EpGz/4k7tc4rV9qCQFHuHgtSiqQMCFFoc5q826rYBlQGz4+IoSjxZMbSXtjRRD9dhDzr531Ecyy0Ck729wfPGrnJiZpgY9t3aBzqWNI8JeVYimgHQR0jKAtXj+A9YTnfPkIgro7CsJ2YfhmGsmjmb+YzGnE2u4SyFXakp9XiYY++sCvlEmkUWXwl17Uy4FqbmYNogw7qwV50RfLiUXZWsusa2XQX4xzTu8FcSEwNZG4vvJrNymFgcvfVObYr/KGrsmzPTqzJFroMjgy0PO/0tV0k3TuQhKQWWjZKXq/lPIAgyoaIAjMC8h8U0HQoMf9W4Av3f44G/XWIAr+WI51n1uUui5BNcTEeziLeD3YRzUmWyufrRF9hFRt9ermsnzGd6vZxqvaLRH7hFIUrxF0nBp+38+Xg6ZXyzdB7DU+nVtm8v9GWCw+IrYJHO5K+HAZMojTUbDwa3mgsSJo1A2TgCqmusR5OzoqJlqcG+Hn5B3sx3aln1m2aoAKvSSb56rFsnjTR95p+mIyfxVBiqcjSp1JIDEFLvkw8ev95I7WLjrsJ9+PttDPbNBBu+FNOQsnqh1BuEfHGpU1Bl1ak0XAm/OE/i4Z12lGyJ8XSJjlxw3zAuRIPDdoMbDCEiuYxuwWlDgTILxxTfNfoRx3NS08ML+OR+FObMMz6QPQp9IxtADcdMSv+2YhChA0xoiFP2/K0BjxuVEb0KBfG4bEHHiTfk5fR/0TxoQOagI4lNkPuMC4XRrBrA0zZAs6U0kqAbAnE+KW//eVNlOFWS/CENGeaojFaWt2SUSVIAfFblq2hZInG0GNWbp
 KoqTYzij
 5ikxImih8Py1U8muM8i8drpu3NtKHX01Tz5DiLr9UFx8g8U7uSLscYUoqFdIgr/VzYoz+F4jQPgbhGUY+70z0s6Hbw+VIWKxuZcKQzbG2k4KYv34iNxzG4UV657P2jfFCiwrrl46c6VbHgTCf7JijvV3lE5gJ7iVgH8g4av84b1DJODQ3ML/dHO245u7qzv4wwmZDGLPzVxMFO82oTYrYmU6++G2uCUorJWTcZ20LTvoGeeXCJltpy+JlWdPluAoyoar6JsTBLJwPkW+tXj/pcsJPBN0hKXHfeeQNPo+z4FSTb1KEhHrmtdE9xVpFxwhmt0+/TnCPJ0+0t9Elx9PcFvMte8IfxkRHGzPoIlUHJnB00Vot1PtdCoaD+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 09:48:08AM +0800, Baolin Wang wrote:
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
> to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
> concurrent zapping, so that when we find a pmd_none() while unmapping a folio
> without holding the PTL, the folio's mappings are guaranteed to have been
> removed via tlb_flush_rmaps().
> 
> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
> Reported-by: Ayush Ranjan <ayushr@modal.com>
> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

