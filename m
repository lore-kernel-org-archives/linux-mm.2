Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C5FDCA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC7B6B0095; Thu,  8 Oct 2026 11:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B39C6B0096; Thu,  8 Oct 2026 11:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9E56B0098; Thu,  8 Oct 2026 11:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 471EE6B0095
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:23:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 369DE1402EF
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:23:08 +0000 (UTC)
X-FDA: 85299827256.08.4BE5538
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6CE22120011
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:23:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="dg/XcnNm";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791472986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fktCSzXnzSArMXx2H5jz1jzKpq1XlCXEdiEKb6zN3UM=;
	b=HI76Jo8IT6bNGDOlI+ehYT7gQ8gp/rH7hBuk8Q/ryxTpwTMO54shX7kLFz22/XQIRPZ4cL
	GUwXpmI6FZcYpZ277EubfR41mTsa60QQR0n80bB4vv72aXVc0ni+4lU5ZNhZC433caqjaE
	v3UCv/sjfKZW8RJssWen03xCCLiOUoE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791472986;
	b=kemo2NjtDd/5B/UX47qm4Bgkm3MzmNOhKh9PF+/10JZX2cp7xQ3AZhN0fwItAmUsjCB4sx
	lNPGTnJwSTtIR2Dyy1qjtnThvqyK969+k/ZDXnJiPHf7c+EiH1jmwEj+97xuXRKb08+ruT
	3dODnpdX75vn8KW7ru+0Xo72eJgh/j4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="dg/XcnNm";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA26F601F9;
	Thu,  8 Oct 2026 15:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F2B1F000FF;
	Thu,  8 Oct 2026 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791472985;
	bh=fktCSzXnzSArMXx2H5jz1jzKpq1XlCXEdiEKb6zN3UM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dg/XcnNmNfHhYyVEaxqh1yGjfpJX4lpMY/htsYBegD+nxiyjtU8PvuCqjYodFdSKU
	 wT9o1xD1Cf0qtnlbQdUruk0andtRTl0WVQ6Z/0U0IKR+ZOL5394V+GaIFktTEZrDuy
	 8GmXQzFAMQm3xb0yqkQDT2nTrDRJe2rWlAH0+8mE=
Date: Thu, 8 Oct 2026 08:23:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Ayush Ranjan <ayushr@modal.com>, Pedro Falcato <pfalcato@suse.de>, Hugh
 Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-Id: <20261008082304.bc6f4bd6c80fe6432abd4fc5@linux-foundation.org>
In-Reply-To: <fyswoh7wpxzlbnjjanggjd2jz6yispmeirhwjl3wzi57nacddb@bjkb6kxyfcal>
References: <20260924061708.1645968-1-ayushr@modal.com>
	<arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
	<20260925053027.1998394-1-ayushr@modal.com>
	<20260925065013.3682431-1-ayushr@modal.com>
	<20261003033107.1488699-1-ayushr@modal.com>
	<20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
	<fyswoh7wpxzlbnjjanggjd2jz6yispmeirhwjl3wzi57nacddb@bjkb6kxyfcal>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6CE22120011
X-Rspam-User: 
X-Stat-Signature: nnkprfu3udyiuexkh7u59e795ggsm7sf
X-HE-Tag: 1791472986-619848
X-HE-Meta: U2FsdGVkX1/9Aba9k13BQTQz+XSdk/7xII5YI6i1DtCpxZkuzMQD1wmpagMzFnlfvTZQOj0eQcj5xUpW0Mvkhni/fYq9PqhJ2psF86Wmb1r12V0c1hAQfINnkrfWbxo3vXDUNA/Tzm4pYtQ7p0D2S6xo93wNY2DqP3UNx000xH3V/h73MO4UO2Pef3I0c/Q0/JvprUbd+fq20toDAy9MOE/RQ61RoljWB8V3q7yLhrJvdAyDmfXuTkdYBGU1jCBZJ16oiK3I/OE3yJSusUKQuFXNFro5eEnyNkDMuZEMUIeTGKoFG1WnPKexV+mvxhYOI1fkLg6iXSY3QYFWmUat3ibOAmxWYo6nIl6/jkiVdIMTkeORBtp15unXL6kAQDEuD+QM0CBfeQYSi3pAwASp1VvfyVCCztYPjTfb3/VtMx7Bg/NljjJW0a+iA72zQeWlLCR7dmVP4xwwDQAMb6Dr3eFSITvxYuvR4BAxqCwA/bJjvOJwcc+pef5GDHeSQu/vMlGHBf+BVgNYnFig2c2HJ565JwMPPoEepfbD8GSeKgsx7e60XEmx4xV6S65jvNleqWSRM5mQBL5B/wYKRjjl6hQ3L9iN0bLqHiU3wyMxQrxB76Q3p+2qR4eHwN1plYeiytxm3qqWfnek4nXuN0FW5F0gMpQ14zl7aSx3cDY3BJqFLyYdKpTF51eoKaYvi+xXWw2n9LHTYkg8eOdx2Qg9w5XvrtIUZFENU4wA4Fv892w8OHzwqf0bAiUokihFISMZ/oVm+iLrKR6wLme16Q9G+fKZcNFiPn65MYTDYqJOIQB5vsNN0ifcUs+M7WkshsqpubF7rKyX2DwU5K7+UEspO4g4dz3mrjFv1qqtZMCbtGmVUhIfZ/xij2AcRpqJKyA6uH86UKPLSjKu0e4RarnadBmeJEY3d/qgLFuL7Sn0fG70gussOC5Blp/FhuvLxyAGQpr+o76w2Fb9yDwJOD+
 4SQHhkCD
 azVxEzBuYB3Cv5DnQOYnY/Z1oxkQZ+XqIqyufWnjm606w+e/bfiFuENMbm5ENq++mFLZ0rqMQQfu/y46I0ze/yI1KCAsCrxaHR18GhWSmTdkt5+ELiB83EIlRrtSaLgAvZA99HblfdoEd+T85mFjOn5wNF5LUPqvHugOWjuoCmNPZXkhfZ+RWijHlU8lyFUGPZQoPm8/AQGaKNVRzdkOXl4Sp2BEr0lFWTxU2HTHYVpAMsyovCbKR+ateGQz521zry/gI7cNFLPJkI6HZgDCR1QycfsRQojJNKaK/dEu3wmJbl3jz2QUpmj+kQl/f2Cje6EdIk7WC6P+XVAz0RoipLLD4cXezwMNhpALz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 8 Oct 2026 11:24:43 +0200 Jan Kara <jack@suse.cz> wrote:

> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: mm: shmem: serialize fault-around against hole punching
> > Date: Sun Oct 4 09:05:31 PM PDT 2026
> > 
> > shmem uses filemap_map_pages() for fault-around.  Unlike shmem_fault(),
> > filemap_map_pages() does not participate in shmem's fallocate exclusion
> > protocol.
> > 
> > During a partial hole punch of a large shmem folio, the folio can be split
> > and the resulting smaller folios can remain temporarily visible in the page
> > cache while shmem_undo_range() restarts its walk.  Fault-around can then map
> > one of those folios again before the hole-punch path removes it.
> > 
> > shmem_undo_range() may subsequently delete that folio from the page cache
> > despite the new userspace mapping.  This can trigger "still mapped when
> > deleted" warnings and leave stale mappings or inconsistent RSS/page-table
> > accounting behind.
> 
> So this part of explanation is either incomplete or wrong in my opinion.
> Yes, shmem_undo_range() calls truncate_inode_partial_folio() which can
> split a large folio. Yes, filemap_map_pages() can map those pages back into
> page tables. But how "shmem_undo_range() may subsequently delete that folio
> from the page cache despite the new userspace mapping" happens is unclear
> to me. After splitting a folio, shmem_undo_range() will restart and find the
> newly split (and mapped) folios and calls truncate_inode_folio() to get rid
> of them. Now truncate_inode_folio() calls truncate_cleanup_folio() which
> does:
> 
>         if (folio_mapped(folio))
>                 unmap_mapping_folio(folio);
> 
> so the mapping is reliably removed under folio lock. Can you perhaps push
> your agents further to explain in more detail how this "still mapped when
> deleted" happens in their opinion?

back to the drawing board...


You're right.  I pushed this further and I no longer think the explanation
in the changelog is sufficient.

filemap_map_pages() takes the folio lock, and shmem_undo_range() also locks
the folio before truncating it.  truncate_inode_folio() then calls
truncate_cleanup_folio() while that lock is held, and
truncate_cleanup_folio() calls unmap_mapping_folio() before
filemap_remove_folio().

So if fault-around maps the folio first, truncation should subsequently
unmap it.  If truncation gets the folio lock first, fault-around cannot map
it before it is removed from the page cache.  I don't see a direct
fault-around-only race which leaves the folio mapped at
filemap_remove_folio().

The earlier fork/copy_page_range() theory did have a way around the folio
lock, since copy_page_range() does not take it.  But Ayush's single-process
reproducer rules that explanation out.

The strongest remaining clue is that the reproducer requires repeated
partial splitting and aggressive khugepaged re-collapse, and the production
splat was on an order-3 folio with nonzero mapcount.  That makes a
split/re-collapse/rmap or mapcount problem look more likely than the simple
fault-around race I described.

So I don't think this patch is ready as-is.  It might suppress the problem by
adding broader serialization, but that would not demonstrate that it fixes
the underlying bug.

A useful next step would be to instrument truncate_cleanup_folio(), e.g. warn
immediately after unmap_mapping_folio() if folio_mapped() is still true.
That should distinguish "unmap failed to remove an existing mapping" from
"some path installed a new mapping afterwards", and narrow this down
considerably.

