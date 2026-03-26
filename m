Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FB3E10A88E7
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0966B0005; Thu, 26 Mar 2026 13:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A880A6B0088; Thu, 26 Mar 2026 13:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976CC6B008A; Thu, 26 Mar 2026 13:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 879726B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:07:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C3098C39F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:07:49 +0000 (UTC)
X-FDA: 84588846258.17.2405F59
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id C972040013
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:07:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zg37qVxv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9pi4ixHJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zg37qVxv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9pi4ixHJ;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774544867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7lANbKM3g4gWkcXuxWHlfM6yAtC+tfeO+S+WqbphMc=;
	b=Udhh5QMtLVjzVgZXWjWxcQ6etLl7tJ2HzmQWuibGVoODOz5t5t0crFiG9OYST4fTOz0hKg
	73y7Tv8Itk/Agx3hrNQW+j7nKedALZXSY9U9CN3vrlaiYfPBQxcXHXl423Lps5odrBSAQr
	VCYgcOD8bTDH45aLKArxrgYpUs22mUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774544867; a=rsa-sha256;
	cv=none;
	b=Y6TMLZ2MbG3qxaP8QN1EegC+P4m+45/nl8Lerx+/H0O48iLXBmLIGJHPiALb8MQ2YyCydz
	8q/FuDhDzZ6xxI3gWyf8XfMPwkAk/Gk5aG6yHDkibBZT6uOEqfoPpw7wnWQExayPxJ8+nK
	FYZ/SM1b7vweMTtPfGN2Z35+oE/Jqas=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zg37qVxv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9pi4ixHJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zg37qVxv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9pi4ixHJ;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4E9385BD48;
	Thu, 26 Mar 2026 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774544865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P7lANbKM3g4gWkcXuxWHlfM6yAtC+tfeO+S+WqbphMc=;
	b=zg37qVxvVtf/OJ7JX8OIaigjrNXHi29BPRjAYFARthZXUp5ZdSah9AdpSgQo6pkzCkj4cv
	Ref2actOg80mQ/pvLdXoFvod6xY/vBnT/HAXMsFzke32EoR8Xt8QC6GtMYFyPYAgpxqyMb
	ssbrNyOiVUH0UCWDEhHkjcv/83448Ww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774544865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P7lANbKM3g4gWkcXuxWHlfM6yAtC+tfeO+S+WqbphMc=;
	b=9pi4ixHJIQLgyKwS3Ij0qKf3OuoYB2rPNP7dYX8e049lBw8FGUPdoWR1u73MnA+0y0HXsM
	04is+Nj+IZmiJeBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774544865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P7lANbKM3g4gWkcXuxWHlfM6yAtC+tfeO+S+WqbphMc=;
	b=zg37qVxvVtf/OJ7JX8OIaigjrNXHi29BPRjAYFARthZXUp5ZdSah9AdpSgQo6pkzCkj4cv
	Ref2actOg80mQ/pvLdXoFvod6xY/vBnT/HAXMsFzke32EoR8Xt8QC6GtMYFyPYAgpxqyMb
	ssbrNyOiVUH0UCWDEhHkjcv/83448Ww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774544865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P7lANbKM3g4gWkcXuxWHlfM6yAtC+tfeO+S+WqbphMc=;
	b=9pi4ixHJIQLgyKwS3Ij0qKf3OuoYB2rPNP7dYX8e049lBw8FGUPdoWR1u73MnA+0y0HXsM
	04is+Nj+IZmiJeBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C4BF4A0A3;
	Thu, 26 Mar 2026 17:07:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qkxAD+BnxWkFUgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 26 Mar 2026 17:07:44 +0000
Date: Thu, 26 Mar 2026 17:07:42 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com, 
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	baolin.wang@linux.alibaba.com, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: use invalidate_lock to fix hole-punch race
Message-ID: <jm5rmcwiauy2fn6fvj6cjowiu2dudjndhhlcd2tm275ibmos5i@dwxwchbs24ko>
References: <20260326162611.693539-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260326162611.693539-1-gourry@gourry.net>
X-Rspamd-Server: rspam12
X-Stat-Signature: 3mzk81efonhtchcur16ip33kcx5tcnro
X-Rspamd-Queue-Id: C972040013
X-Rspam-User: 
X-HE-Tag: 1774544866-14355
X-HE-Meta: U2FsdGVkX1836O5tKUEeu9RNiXoShPLdfLssX/W20g2sQlISBNKx7mXMSC6ThEblW9zNCeVC1NBa+y5clPzd77pa6J92F0OvbUQU+q0o9l36ulpXPdfpMMqu81yi5LrYjgpQsIoRWAzay9X3ID3g1tZDXqu6sObeyk/0RWI4IZnRcfAiTzYchJ6VCoPhN3P3A5ECZ2tSNGvrfTjqqYkTlKNcJcHqmNIY4KCbUmpwhGa8OnD0mwttLAAl/ANagcEmC6JySolEkfJz/7LACRUFWPm4nW/V8cvT/7b/OsuwdQmUaujAY2PhY5HWugHQrsmSgiYJNGMW4etqCw1QzdBuzqc2gmTXknScd0K/LOv+4VJ9RDKGHuH+5WhoQyKCEOzZp3Wpb15XbRot/94WoatldzPKLEgiVza3KNJt3tBoDbfqJt2taFToAB1HxM1iO8RbgD5oEGFdGVp5lMwiWgSbalnvyRurHV5tjgcHOPzJ37N/2Nmps7ks169v96LzFoLhqQk6xz4HqhfhfHow2RR2KpZO3XInr3XzYfW5IB26cBCjFoZwehZwGardfv4hzzTiGrYIHpmMHRiCf1vxODqGW5qJUdlX8ES0fituBsmwgHkfdIEteA+o+jkIN863trjPw1WNAlYMmnwlvD203i0etAIIfcZ1pzQ4kpQCyCu30fy/EDU4PkJw2tWlEeDRGa6N7OF4NWnAaUGXhIeTW7760uv6tmK3mNypBQeYMJXoX7uk42INOsL8WKRzBRCVSltu3Wa3t7IVkCQieURoXJmh7tit6E1dEiX3dbc54uAjNmFAkrrj1AXuamRS2eg/C3+hwpznFbZh5cKl7oaxG8zS33wuHRqGOM+oy+ydLwo5CyRfIypnZTrtGBISqAcWn7rP75za3nQFZZRCToM7sr6R+lpqtXUeDcWHgB6RJTXoGFQOJmH1UBcy1AwFtLLzyq2dvRCgbGeB7CoryuEbYDu
 J5kErrU8
 kUJRC83ZN3zdNVmPN+nSOTW5Iy1A8cIZvrxB3zUXPnvJaRv81uAn8dxErcxBQ/Qegkap+U5AkQXaGhE9hYhYQ/3t50s9VR14qhBBAnA4ylmBhStw35GwhIE7ZrKv+E9Q0KoI9MZ2pqbNj6R/9qoC5EsSMMzcysL3SojY0vImmudUH2lG9xMf7Y87k4hwqsjQhtE0ysYHMXUIkeiMqRbhFVozzk7wTyJKvYfISPMeATGeGpNeZi8Hir+K4yk7iOuJjy4fyG+LQ/Y2VwSCUPpPXwR8B6U4M2J5OgyhVh8PKdxA86wav7NeTNAMg6UYzeFM7oGwsmrB/z7SBC1+Dk1Gfq2yx1wK8UjjD04YUVFI4QLIczEz0zH045KfpHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:26:11AM -0500, Gregory Price wrote:
> Inflating a VM's balloon while vhost-user-net fork+exec's a helper
> triggers "still mapped when deleted" on the memfd backing guest RAM:
> 
>   BUG: Bad page cache in process __balloon  pfn:6520704
>   page dumped because: still mapped when deleted
>   ...
>   shmem_undo_range+0x3fa/0x570
>   shmem_fallocate+0x366/0x4d0
>   vfs_fallocate+0x13c/0x310
> 
> This BUG also resulted in guests seeing stale mappings backed by a
> zeroed page, causing guest kernel panics.  I was unable to trace that
> specific interaction, but it appears to be related to THP splitting.
> 
> Two races allow PTEs to be re-installed for a folio that fallocate
> is about to remove from page cache:

Hmm, I don't see how your patch fixes anything.

> 
> Race 1 — fault-around (filemap_map_pages):
> 
>   fallocate              fault-around           fork
>   --------               ------------           ----
>   set i_private
>   unmap_mapping_range()
>   # zaps PTEs
>                        filemap_map_pages()
>                         # re-maps folio!
>                                               dup_mmap()
>                                               # child VMA
>                                               # in tree
>   shmem_undo_range()
>     lock folio
>     unmap_mapping_folio()
	spin_lock(ptl);
>     # child VMA:
>     #   no PTE, skip
	spin_unlock(ptl);
>                                             copy_page_range()
                                               spin_lock(dst_ptl);
					       spin_lock(src_ptl);
						/* does not copy PTE. either
						 * we find a zapped PTE, or unmap_mapping_folio()
						 * finds two mappings instead of one. */
>						# copies PTE
>     # parent VMA:
>     #   zaps PTE
>   filemap_remove_folio()
>     # mapcount=1, BUG!
> 
> filemap_map_pages() is called directly as .map_pages, bypassing
> shmem_fault()'s i_private synchronization.
> 
> Race 2 — shmem_fault TOCTOU:
> 
>   fallocate                   shmem_fault
>   --------                    -----------
>                             check i_private → NULL
>   set i_private
>   unmap_mapping_range()
>   # zaps PTEs
>                             shmem_get_folio_gfp()
>                               # finds folio in cache
>                             finish_fault()
>                               # installs PTE
>   shmem_undo_range()
>     truncate_inode_folio()
	truncate_inode_folio() zaps the PTEs, thus mapcount = 0.
	shmem folio is locked by both truncate and shmem_fault().
>       # mapcount=1, BUG!
> 
> Fix both races with invalidate_lock.
> 

I don't see what you're seeing? Note that both map_pages and fault()
take the folio lock (map_pages does a trylock) to exclude against truncate
as well.

-- 
Pedro

