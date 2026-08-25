Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50317C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B716B0095; Tue, 25 Aug 2026 04:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3566B0096; Tue, 25 Aug 2026 04:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2506B0099; Tue, 25 Aug 2026 04:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00B696B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:26:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BFFAC02E5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:26:08 +0000 (UTC)
X-FDA: 85139109216.06.6576C6F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3DD3F4000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:26:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=us4Z6weh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6YnH89Py;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xWsSSuj5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nG04rm6S;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787646366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=rg/XjF4aH/77aIlA7dHIyosimke5XaxrJ3REwIh8oA/67OIUnGN9/zoNH2SdDVlqxIrMlK
	h2uTAo2iaOtoCIF9k6zW1VSbqLrMaHf/lgu962o4mZiOkKVow3wk4nG63y5XSL4e20vZcp
	KyuUdQ+2bPRPB/K2Rzowp2gPkp7lwfs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=us4Z6weh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6YnH89Py;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xWsSSuj5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nG04rm6S;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787646366;
	b=Lqh27/MYoEWlDEDb55wTj5XbNYRg5u6YToZtB5VYnpABnc/2qPkISa6yowEXu0My4RknoY
	PTrv2Lf4g6nSHEu8Gf1+04XYKl/D7cValAstqIcybAkk+0RjnzVjZbqCy/VbKP1Tmlan0J
	gdZLP11hXkLlhr+p1cwHdQhCgM3W65k=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8BE3D1F769;
	Tue, 25 Aug 2026 08:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787646360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=us4Z6wehV1zJOnbgd+wLk9dBc+b+Lhebd9tctl1a2i+5C6CyWPxBUWszlO2YAgz2nDFbZE
	G8CeCsqerh5u5vDwtMKc1LS3COE0W1yPONHrVmq6CY5MFSbG4Z/j/Bv+i7Si0LU3pPh0PI
	4jQqwV8n11YnnzMC6lmOWXBnA3yW4Cc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787646360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=6YnH89PyKzHmLHbEeuuzJ7xzmi/U+DZXYKVdLuHwXpY6O+Z2kXZfZkhKeB1+QH4lKD6pVv
	FlYvKSNgMy1h5yDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787646356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=xWsSSuj52XuRC9BXOjAbr92F5naYxlTePRPxt5kOvq4/soZrDGT2WWdmMVenPCjY3rdLJx
	DZXPYQCqbsCU8K5h/57YnVVNLKCbBo5LbuP2Lr3XBwMC7el0J/PtUEsCx+rVCvEKsMF5MP
	T/W95s2v1+eJGjsH6RRSoSsVD+gBcIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787646356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1kJ796bUabjdL5phaBza1F1D/Go+uEZ00Mj5JL+fNM=;
	b=nG04rm6SXjrdYR3jrQs8AQX1hxMpXe0h2YmFm8+pQxihuqd+rNZIXM4h0kS3OXUssyBBTZ
	RKh24vuJnrhUWUBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA8CC13331;
	Tue, 25 Aug 2026 08:25:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hBxAJpNRjWoYDAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Aug 2026 08:25:55 +0000
Date: Tue, 25 Aug 2026 09:25:53 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>, 
	David Howells <dhowells@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao1Lo6TKhPcqV42B@pedro-suse>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DD3F4000C
X-Stat-Signature: 9zxxq4stdaxnmy8k9jbwgknk1todaedk
X-Rspam-User: 
X-HE-Tag: 1787646366-631799
X-HE-Meta: U2FsdGVkX1/fzrWqVoGsg29JEhm+1+XmULrEzT0PrfPrBJOKDzfddcU/fDM0WM1eS+79/7ek0fVuq7NKWD4tIszjAZWVQUn29d40K4Qk2rbfos5TvMUWj0sVHPWeBko5uEw52OeQ8PG4NR1LyEuOb/ckzV7kpr+YEE0NJa2WifgMvyL/zaxVanSof0HKXj0kSSNKRJx+YIghIKuvXD12krEA4E0s6CW8wFvY8JHYL2DXCYXFpCTqhvFz4otuD3Hf1N/2+2m7JRZJ7Q6txkICYmqaBuQbRIdZ6DMYZqDeEhS0MvGcAiroIdLCO43GSfB2dw5utrEmPq1TLJNiTExzE3cS5z8BYBSs5mfmwNfeqA50N6aMYjJ4gYGWrTEfoS3lBkr3D/jhSj+nka9N80ki6BxKDtiMlyg35zHTR28OCUA7epK7L31x8fKsOWVlcLu6WilLSK0tkU6/17SfHBBpKcSh+HClsZ7IOev7a7OF8pWknLAcPakqIoQTLuKhYt3Pe+KXF0/aC28B9+ZFfOynNHxJwUYyMtlMftr09KHK5aCWT6zhR0zlSyzatuPzArr2sGf3SNnaU24PTziDuBLIS4RKKKPbU2ehnLiPaayVLFCEHVdB0Mck8zS52/cKbjCNZmtnaiO/ZdnOnMajPqxyJ2E9kydRyflPwyaMf/euBnmZEpqj9TLRuMLeanVIX+DubjQlz1JQSc9SIL9lrDiTaJdxYxPo77TC/TEkpPZJg2x+RvegytKw9uPsHh9KHo8Y23my5263DDjloPeyvUC2W5Enq5PYRYGVviBFJCnrEEBVSpTChl7OFwHyBg7r7V+L5WlBY9QraQyCPyWGW/XJ7pUEmnqdpcmI675qKInyGMlP6y4EApz9UccFV5UXJzbCW6eVC/26l01QWVKh49gmnVKF/12wnf+mEGzFYX5PSpTsyduB1ucc8FAJfBtuCgmYOD9w0MLVJ593bxrjgPl
 AVguZhvZ
 HGFXkmqFEUIxX3hE4kJ9FX773w3ScNN1khWrOef5MSYdLt0zySf4q+FxqRMWADuWECapl3rwBGyJVk85MLBVBAz1j3POyzqmIFHqnIEYK9kGalz5p3L5XFhYRXPZ65eSbJ+MI7z8KdfgiNHwwARJymNO7VoFA5Q2lp3chMdeQDCfGO2E75363XifdhqcTppURXqZb9ob61W1oe2524Ckhc8JtUcWhx8C8GLtFBUalj7ioexZqTc1TTzBeh1rGkVliiuGpC+4eT9GcnY68eieCYVWBHM2hZESrjVvBasDh7gP3kjYtRBSnXrADlj7WmT8Exgtzf9w090u31oTGBoBnumGwWs5jXEY7y+Gt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.
> 
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
> 
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.
> 
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.
> 
> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> 
> My proposal is this:
> 
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is

I don't think you can do this for stable writes. It's probably ok for
!stable writes filesystem stacks, as long as the filesystem & writeback
can handle making no progress at all. But since stable writes' writeback
can't race with "writes", I don't think you can Just Do It as long as the
folio is DMA pinned.

Perhaps we should give up trying to writeback these folios, and start
writeback right after they're unpinned? at least on the stable case.

>    marked as dirty.
>  - The MM behaves similarly; we do not clear the writeback flag for
>    folio_maybe_dma_pinned().

This sounds like a problem. You don't want users expecting writeback to make
progress to suddenly stall on e.g folio_wait_writeback() indefinitely.

> 
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
> 
> I'm probably missing some stuff here.  Let me know.

I don't quite understand what your plan for getting rid of dirty_folio,
et al is. page_mkwrite has the fatal flaw of being directly tied to VM
page faults; I don't think it's the ideal interface for notifying filesystems.
It's also the case that page_mkwrite can trivially sleep, and GUP calls it under
the PTE lock. So how can we replace that? Would callers need to manually dirty
folios after GUP, in process context?

-- 
Pedro

