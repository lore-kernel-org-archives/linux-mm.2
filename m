Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABABDCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A956B0092; Thu,  8 Oct 2026 05:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AE26B0093; Thu,  8 Oct 2026 05:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739DD6B0095; Thu,  8 Oct 2026 05:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48BF56B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:24:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC50AA64C7
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:24:55 +0000 (UTC)
X-FDA: 85298924550.28.79AF0F1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 812481A0004
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:24:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791451494;
	b=Qqpj7ocGqA1PDh1svuqrOWZsDAyXxTmFt0yefDQkHqcAa3Ui2AVB0wZLNwQh+CkNNJMXuS
	pxmXnzEZTFgDKN6H9/zfNVJdMzFUsVS5R/C4wCQCiCSB/OIdS46nGS9GPiK5mBLRY7uFqf
	YJ/xwoawphVqbTlqFJfWpVVYEWkhR/8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791451494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w/8lwwG9xTB3qMnRq5HSdP9weJ17TEBJTLSML4Jyj8M=;
	b=4alMvsMnPO6iT9oIpQjBs3+StIGfNTxrp0ckoY9Xl49B8XsnitO3DbYmpjRaIdMcf8KB0w
	6tm6MwsqE8odRK9Ga1Me47DHeSGEDDUraZleXRjnvCRDkMTFLYaan+fVR2rlr90x6ZcEds
	i8o6KedSbR9RGgavmk15i9/9JFsdo9Q=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A92021BEB;
	Thu,  8 Oct 2026 09:24:52 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3CFD13354;
	Thu,  8 Oct 2026 09:24:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 84CsL2Nhx2qNewAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Oct 2026 09:24:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 79CDFA13FC; Thu, 08 Oct 2026 11:24:43 +0200 (CEST)
Date: Thu, 8 Oct 2026 11:24:43 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ayush Ranjan <ayushr@modal.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-ID: <fyswoh7wpxzlbnjjanggjd2jz6yispmeirhwjl3wzi57nacddb@bjkb6kxyfcal>
References: <20260924061708.1645968-1-ayushr@modal.com>
 <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
 <20260925053027.1998394-1-ayushr@modal.com>
 <20260925065013.3682431-1-ayushr@modal.com>
 <20261003033107.1488699-1-ayushr@modal.com>
 <20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Stat-Signature: kzj7rp5n1nhzck459nn4z5kr5fuxfp7m
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 812481A0004
X-HE-Tag: 1791451493-560501
X-HE-Meta: U2FsdGVkX18v0hBfJggq9I44hSCRO0svz0GoRWK22frf8uNParD+nF4lI5BG6Ic7y7PRGRMH0DNdrarKOhj4N85c3854z6vQHelVUZs6M+A4Me/F3Fhnmvvzgr3Xgp6WiXU5pXRWv8Xd68pzlvPsR6ND5/EOg36tRGKUiXCYixEMxwrbbKz4zEuR59Y1WTms5yF/IIH8G5v+/XvLcAhddFlqCZeq+IKkqW7uVap0FL9NSiXwGm7iC9q7pkHJFR7mwnxdfPLajejz5dOqQ6o5FHVhn0I2oLtMz186Rmuj8JGHzc/5gistULzhrxqhZ//qjoEG0FuUF0mkgsG+r01V2P6IYiB6Isgh/VWZ+iDyez2F6rMaiTXzZiPq6gxgU4ESsKpf2rT8n4AvmaPgi4hOq+pSULOXHQd8JHCAjbL8SP8NwyHU+cKPnXB4N1ZcBtZRn6/sAckO4kv1rAcL6Qq6+eqrm8RaEu3AJ1Q2Jevuq/iv+5oXC8VKzYL1+fftfTF6pHa344As3dSMI6xhdRw2xJd12gpkERBCbObWvUpcB515YHHxHD7DPuwiOBF03fSix7pIhqvuEzBEs/nRXi3NQuTUNbu7EkVDf7qZid+8bErEfcnZESzZM8fvvZSrIVz49uxrhMSGOYh72WuSARtXJ2csOEiRl9Ldqudh2dt6lYF9ChcKUj0J/1XpiS0rGOeXf1iDNQ9OaMmVQON+Lrqdiu7KJkUGH76slXUDFbQuikfvE25IwlzcYtE1iPO5fjc9dsM03wXkrGaKjAIXhBGVtGwGX3BLJlGuW7Gx41oaz4VEYfg2cefK6fn3iZKhdHd7M9dJ/plxn+FRQqMRE+E4+zEkrZOnj6Y4J2C0lQ1UGGmsFXf6gNIYsSqMpvuhmNaH5W46xTA335FlaY4tYuyX+tQ25QZP2SNDYsRdz0K9Vh53b14m1e1KALmLHJA06dKeki2WQ94iKTlkf40JFGN
 t5toEgTr
 xRj/TLDcSw18cjOWl6uS6MkLb3IkbuNKc4LaG2PjZt5Y73ZNDe0LbGcRmVtg11d8C3DzYjV/OZLEBn47nkBZyGNce8dPOx61OdvkPqY1gNoBZ5AD8r/K97+y/EA51Xyk495b0d+cqwKXGsWq0oTdmVEefENqzCssMvyRhFZtqFcvteC8b8l/LGbFS8CqEJiWWBX+NiBHDfsNN4FHXlzy6ixK4B3SwONcsGNfU87bGtjgkbanC9GNevEAEN5NdROAOvWw+Pork1fBE0D3+m+YIwldhl/93HixnbfVbQ1eVnYs2UPdzVYzGh3ggTKNBp7PNF3LrwMkFJ5d0/xMIE/Uls3n6OAVgoqJCgHHy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 04-10-26 22:28:31, Andrew Morton wrote:
> On Sat,  3 Oct 2026 03:31:03 +0000 Ayush Ranjan <ayushr@modal.com> wrote:
> > Gentle ping on this. The reproducer in my previous mail [1] triggers
> > "Bad page cache ... still mapped when deleted" on 6.18.46 within a
> > couple of minutes on a 128-CPU bare-metal box, with no fork() and no
> > gVisor involved.
> > 
> > We continue to hit this in production at low frequency, so I am happy
> > to test patches or collect more data if that would help.
> > 
> 
> fwiw I made gpt and gemini argue about this for a while and ended up
> with the below.

Worth a try I guess. Let's see :)

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm: shmem: serialize fault-around against hole punching
> Date: Sun Oct 4 09:05:31 PM PDT 2026
> 
> shmem uses filemap_map_pages() for fault-around.  Unlike shmem_fault(),
> filemap_map_pages() does not participate in shmem's fallocate exclusion
> protocol.
> 
> During a partial hole punch of a large shmem folio, the folio can be split
> and the resulting smaller folios can remain temporarily visible in the page
> cache while shmem_undo_range() restarts its walk.  Fault-around can then map
> one of those folios again before the hole-punch path removes it.
> 
> shmem_undo_range() may subsequently delete that folio from the page cache
> despite the new userspace mapping.  This can trigger "still mapped when
> deleted" warnings and leave stale mappings or inconsistent RSS/page-table
> accounting behind.

So this part of explanation is either incomplete or wrong in my opinion.
Yes, shmem_undo_range() calls truncate_inode_partial_folio() which can
split a large folio. Yes, filemap_map_pages() can map those pages back into
page tables. But how "shmem_undo_range() may subsequently delete that folio
from the page cache despite the new userspace mapping" happens is unclear
to me. After splitting a folio, shmem_undo_range() will restart and find the
newly split (and mapped) folios and calls truncate_inode_folio() to get rid
of them. Now truncate_inode_folio() calls truncate_cleanup_folio() which
does:

        if (folio_mapped(folio))
                unmap_mapping_folio(folio);

so the mapping is reliably removed under folio lock. Can you perhaps push
your agents further to explain in more detail how this "still mapped when
deleted" happens in their opinion?

								Honza

> The race dates back to d7c1755179b8 ("mm: implement ->map_pages for
> shmem/tmpfs"), which enabled generic fault-around for shmem without making
> it participate in shmem's hole-punch exclusion protocol.
> 
> Serialize shmem fault-around against the hole-punch unmap/truncate sequence
> with mapping->invalidate_lock.  The hole-punch side holds the lock
> exclusively while unmapping and removing pages.
> 
> do_fault_around() invokes ->map_pages() under rcu_read_lock(), so the
> fault-around side cannot block on invalidate_lock.  Use the shared trylock
> instead.  If the trylock fails, skip fault-around and let the normal shmem
> fault path handle the fault.  Otherwise hold the shared lock while
> filemap_map_pages() installs mappings.
> 
> This preserves fault-around in the uncontended case while ensuring that
> pages in a punched range cannot be remapped between unmap_mapping_range()
> and shmem_truncate_range().
> 
> Fixes: d7c1755179b8 ("mm: implement ->map_pages for shmem/tmpfs")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/shmem.c |   27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> --- a/mm/shmem.c~a
> +++ a/mm/shmem.c
> @@ -2938,6 +2938,27 @@ static vm_fault_t shmem_fault(struct vm_
>  	return ret;
>  }
>  
> +/*
> + * A hole punch can temporarily leave split folios visible in the page cache
> + * after it has unmapped the range.  Do not let fault-around map them again
> + * before shmem_truncate_range() removes them.  ->map_pages() runs under
> + * rcu_read_lock(), so this exclusion must be non-blocking.
> + */
> +static vm_fault_t shmem_map_pages(struct vm_fault *vmf,
> +				  pgoff_t start_pgoff, pgoff_t end_pgoff)
> +{
> +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> +	vm_fault_t ret;
> +
> +	if (!filemap_invalidate_trylock_shared(mapping))
> +		return 0;
> +
> +	ret = filemap_map_pages(vmf, start_pgoff, end_pgoff);
> +	filemap_invalidate_unlock_shared(mapping);
> +
> +	return ret;
> +}
> +
>  unsigned long shmem_get_unmapped_area(struct file *file,
>  				      unsigned long uaddr, unsigned long len,
>  				      unsigned long pgoff, unsigned long flags)
> @@ -3865,10 +3886,12 @@ static long shmem_fallocate(struct file
>  		WRITE_ONCE(inode->i_private, &shmem_falloc);
>  		spin_unlock(&inode->i_lock);
>  
> +		filemap_invalidate_lock(mapping);
>  		if ((u64)unmap_end > (u64)unmap_start)
>  			unmap_mapping_range(mapping, unmap_start,
>  					    1 + unmap_end - unmap_start, 0);
>  		shmem_truncate_range(inode, offset, offset + len - 1);
> +		filemap_invalidate_unlock(mapping);
>  		/* No need to unmap again: hole-punching leaves COWed pages */
>  
>  		spin_lock(&inode->i_lock);
> @@ -5467,7 +5490,7 @@ static const struct super_operations shm
>  
>  static const struct vm_operations_struct shmem_vm_ops = {
>  	.fault		= shmem_fault,
> -	.map_pages	= filemap_map_pages,
> +	.map_pages	= shmem_map_pages,
>  #ifdef CONFIG_NUMA
>  	.set_policy     = shmem_set_policy,
>  	.get_policy     = shmem_get_policy,
> @@ -5479,7 +5502,7 @@ static const struct vm_operations_struct
>  
>  static const struct vm_operations_struct shmem_anon_vm_ops = {
>  	.fault		= shmem_fault,
> -	.map_pages	= filemap_map_pages,
> +	.map_pages	= shmem_map_pages,
>  #ifdef CONFIG_NUMA
>  	.set_policy     = shmem_set_policy,
>  	.get_policy     = shmem_get_policy,
> _
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

