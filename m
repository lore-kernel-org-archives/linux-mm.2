Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E34F588E0
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2C96B0005; Mon, 20 Apr 2026 10:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A076B0088; Mon, 20 Apr 2026 10:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090A26B0089; Mon, 20 Apr 2026 10:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC9AA6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:37:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8508B1A0771
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:37:26 +0000 (UTC)
X-FDA: 84679187292.23.20D2F78
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id EB09F80010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:37:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q4yNSEiY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5v8NFJL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q4yNSEiY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5v8NFJL;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776695844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tq/qTYhc7J99BTb81QiREOxnOQu2KPLsbOcnX3tU/Ak=;
	b=8T6nmSDxPwz65zn39B6pLd2d9BT5MJm3VmPhBxfZWX4+PCUz8dLHY1SpIqNqOvEkBO8hIg
	ArDQBJ61DsNVx7Bp+ypcRthiAFdGmyJ+sQRd0XGy6TCqf7PtESxA0LuYKHZcmlQo5yfW0x
	W8mgYEaaq9VvSW2nIDX6lyrBp8NPBFM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q4yNSEiY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5v8NFJL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q4yNSEiY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n5v8NFJL;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776695844; a=rsa-sha256;
	cv=none;
	b=RXdiX5/vGuQFI82diSnV5e8hMvfETurHTpcZe7rPgN2O2ZsT+K72zVDiCeL55Ty3oc8V+o
	nrFUiMomgPDbiUxLxVkrTOPZmCdPU9LJtoZc4E7sGr9r88dJo79Cs3xTrCxa3HOMo1T7aC
	CBFajuqN3npyyzXYSU0va3xZgv0Sh2s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 200656A7E4;
	Mon, 20 Apr 2026 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776695842; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq/qTYhc7J99BTb81QiREOxnOQu2KPLsbOcnX3tU/Ak=;
	b=q4yNSEiYxtVmWifg6hkkuZBbAxQk27Jc36P0w2PLFNCP8pYAMjBTF2l5r7vu2IX49Q4cMf
	jQBNFW7JFQEEEB2t6JzB5XuinTQa/mOexKYPEP0t8vePcuhFfietDkstN27e++1RhvWjj1
	goZlzvLFNTovxg75Aws3kRXECcEWjz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776695842;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq/qTYhc7J99BTb81QiREOxnOQu2KPLsbOcnX3tU/Ak=;
	b=n5v8NFJLalpN8aCtps8nQjNn143pFUK+sg3nUDFXYvbeADZElBnF0+aUCJ+bWjuP41iE0j
	zsQgp/5upyIs6GCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776695842; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq/qTYhc7J99BTb81QiREOxnOQu2KPLsbOcnX3tU/Ak=;
	b=q4yNSEiYxtVmWifg6hkkuZBbAxQk27Jc36P0w2PLFNCP8pYAMjBTF2l5r7vu2IX49Q4cMf
	jQBNFW7JFQEEEB2t6JzB5XuinTQa/mOexKYPEP0t8vePcuhFfietDkstN27e++1RhvWjj1
	goZlzvLFNTovxg75Aws3kRXECcEWjz4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776695842;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq/qTYhc7J99BTb81QiREOxnOQu2KPLsbOcnX3tU/Ak=;
	b=n5v8NFJLalpN8aCtps8nQjNn143pFUK+sg3nUDFXYvbeADZElBnF0+aUCJ+bWjuP41iE0j
	zsQgp/5upyIs6GCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91B8D593AF;
	Mon, 20 Apr 2026 14:37:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sbiKIyE65mmecgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Apr 2026 14:37:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7B668A0BEE; Mon, 20 Apr 2026 13:28:18 +0200 (CEST)
Date: Mon, 20 Apr 2026 13:28:18 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	hch@lst.de, ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <laegs2jt5ifqmfmdlsl7gsrc64z4nrnwbxazewbr7jk27emdej@l6vhj7pjh3dy>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
 <aeKNHi8GloNgch7X@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeKNHi8GloNgch7X@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Rspamd-Action: no action
X-Stat-Signature: xodqg9r9eq9seoim4bcqjawhjzfzwoiz
X-Rspamd-Queue-Id: EB09F80010
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776695843-173803
X-HE-Meta: U2FsdGVkX1/FqSonNHBT8XpPDPheJ4gK64a224gsmsMr/4PeUmDwPJ+IR+23/4gSypCv4ec6of2Qlps7/W8929jnpQ/1hiS//NSgw9kA5oOJfNCaVJoulez2uBV664UYW1fnMjGcOpvfDT+mdZCITjSeo4+3x7QT86+8c39WfYFsrz8wEhOCcDW8/YLDjaGNsyXnHXOEK/yIQKped9EFj5Bqk8aFlPpJbGt59Jv3Z0Pi3DJlv+QDS5w3nDRxMpjW8wnMfyTzNEInHeVztZ/+FLfJ8w4buxsf78v5WrwbFPiqzT/GpJ4DLg3HKu0OSQJiGJS8BbS04S9N1fl7sO04LoOk3JwJW2hMaSNCCh2/LVICcoqtAOAakvVPvj54Ex17PNT/GWGF/oLHslqGkOgR7AH4gfp8Zun5NelIT1I3MmofmZ/V2NM9N8OxvT9q1hGmXaSXhjSpeRZpthIOU+sPijn3oRPOEkNv/4GOdEz0Jt77dOowzXqaob+YmQqOM1Tr54JQoGPVq6cxnT9H+6EM1a6z/nT6VxwHLpvEk5KfvxcYRRnM+yRaGYU2Mmf4rsjRT9266zOqUA3tPCB1Rv7RXbsnq95q4NpwuI1N0nzIkICeZ1R/E1xWrT8Ka6tDd1qY2zLurOrw6fWseCyrXJbHsorWg2gXejyf8Y32UI+hNodlZPq7xQOObH5yWcG3DNn0UlPXwozqvSgNqAITKW6/kLca37D48lOxzXs2gGOXlOFStheOM4O4Cb30iT8ihWy1eM7QZ81oO/1QUxlyvrI5mqlU3i/wNU7mswxegoA7hXoEFttTCutGb00To6z9TZ6+MRk7v+kGTx8paitDEKOCah/qXfvrCz8lM39ERmRle04lEGobHdQW6AMVcetC395wap6PoOHB9ivdpBydqund6St78MGP2WGUWL5JVd3hiTWo0G327JOEX7wFqjH3KzV7ZeP87cBEQ4BB4hndlTo
 9x+8jAel
 53PaHGjYTL0/do0vXu0fMiuhLNlQIquTUORoWcUGUi6b4l5BGHdDH1ZmZoCL8CF6u8XNlcY76W70Cbh993uUQjAxyWgW3bXUTtavRLdApMk1Gq1L0AGNa0ASrEbflDb46cCLVSzJZMuSX26n/5WJd3L+CRGMYTR7yPR5ap93p5B8hBDSpTfmH1YFM7IsB/kbwAoTq/6MCezwpMaPS1XbXQwq7VH0eRgAawvdvndtZ7K0LDjXlghTPiOHR0SGM9ALbmz35CnpGovxGiTBbad7hSIZO3xDEszW3wYzqmw9r5AOOa1Iwta4kAn1864O8wuZL03G5+MMxfzSZ6Rr17vOyZC0pwUjbkqmEtPo9Ip2JolHnUOm8eofummeGaQqR+Br8IcnVwerCct6SFfJ7D7Vu1c/5sy9ToeV2QElBxM4O6HuUoLCYqcoHTlCpn+5fWKGD0Inz/8DgfmroaR33GEdvL12JPq+Sj0s1i9CP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 18-04-26 01:12:22, Ojaswin Mujoo wrote:
> On Thu, Apr 16, 2026 at 02:34:15PM +0200, Jan Kara wrote:
> > > @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
> > > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > > +				   struct iomap_iter *iter, struct iov_iter *i,
> > > +				   const struct iomap_writethrough_ops *wt_ops)
> > > +
> > > +{
> > > +	ssize_t total_written = 0;
> > > +	int status = 0;
> > > +	struct address_space *mapping = iter->inode->i_mapping;
> > > +	size_t chunk = mapping_max_folio_size(mapping);
> > > +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> > > +	unsigned int bs = i_blocksize(iter->inode);
> > > +
> > > +	/* copied over based on DIO handles these flags */
> > > +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> > > +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> > > +	if (iter->iomap.flags & IOMAP_F_SHARED)
> > > +		wt_ctx->flags |= IOMAP_DIO_COW;
> > > +
> > > +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> > > +		return -EINVAL;
> > > +
> > > +	do {
> > > +		struct folio *folio;
> > > +		size_t offset;		/* Offset into folio */
> > > +		u64 bytes;		/* Bytes to write to folio */
> > > +		size_t copied;		/* Bytes copied from user */
> > > +		u64 written;		/* Bytes have been written */
> > > +		loff_t pos;
> > > +		size_t off_aligned, len_aligned;
> > > +
> > > +		bytes = iov_iter_count(i);
> > > +retry:
> > > +		offset = iter->pos & (chunk - 1);
> > > +		bytes = min(chunk - offset, bytes);
> > > +		status = balance_dirty_pages_ratelimited_flags(mapping,
> > > +							       bdp_flags);
> > > +		if (unlikely(status))
> > > +			break;
> > > +
> > > +		/*
> > > +		 * If completions already occurred and reported errors, give up
> > > +		 * now and don't bother submitting more bios.
> > > +		 */
> > > +		if (unlikely(data_race(wt_ctx->error))) {
> > > +			wt_ctx->nr_bvecs = 0;
> > > +			break;
> > > +		}
> > > +
> > > +		if (bytes > iomap_length(iter))
> > > +			bytes = iomap_length(iter);
> > > +
> > > +		/*
> > > +		 * Bring in the user page that we'll copy from _first_.
> > > +		 * Otherwise there's a nasty deadlock on copying from the
> > > +		 * same page as we're writing to, without it being marked
> > > +		 * up-to-date.
> > > +		 *
> > > +		 * For async buffered writes the assumption is that the user
> > > +		 * page has already been faulted in. This can be optimized by
> > > +		 * faulting the user page.
> > > +		 */
> > > +		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
> > > +			status = -EFAULT;
> > > +			break;
> > > +		}
> > > +
> > > +		status = iomap_write_begin(iter, wt_ops->write_ops, &folio,
> > > +					   &offset, &bytes);
> > > +		if (unlikely(status)) {
> > > +			iomap_write_failed(iter->inode, iter->pos, bytes);
> > > +			break;
> > > +		}
> > > +		if (iter->iomap.flags & IOMAP_F_STALE)
> > > +			break;
> > > +
> > > +		pos = iter->pos;
> > > +
> > > +		if (mapping_writably_mapped(mapping))
> > > +			flush_dcache_folio(folio);
> > > +
> > > +		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
> > > +		written = iomap_write_end(iter, bytes, copied, folio) ?
> > > +			  copied : 0;
> > > +
> > > +		if (!written)
> > > +			goto put_folio;
> > > +
> > > +		off_aligned = round_down(offset, bs);
> > > +		len_aligned = round_up(offset + written, bs) - off_aligned;
> > > +
> > > +		iomap_folio_prepare_writethrough(folio, off_aligned,
> > > +						 len_aligned);
> > > +
> > > +		if (!wt_ctx->nr_bvecs)
> > > +			wt_ctx->bio_pos = round_down(pos, bs);
> > > +
> > > +		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
> > > +			       len_aligned, off_aligned);
> > 
> > Shouldn't we zero out the tail of the folio if we are submitting partial
> > folio for write?
> 
> Hmm, so for the folio range we zeroout if needed in
> __iomap_write_begin(). I think that should take care of this right? 

Yeah, right, that seems to do it.

> > > +		wt_ctx->nr_bvecs++;
> > > +		wt_ctx->written += written;
> > > +
> > > +		if (pos + written > wt_ctx->new_i_size)
> > > +			wt_ctx->new_i_size = pos + written;
> > 
> > I'm probably missing something here but where is i_size update handled? I
> > don't see new_i_size used anywhere? 
> 
> So the i_size update happens in endio(), similar to dio. We initially
> had the update in iomap_writethrough_iter in v1 however based on Dave's
> feedback [1], moved it to the endio. The idea is for writethrough
> semantics to be closer to dio hence we either update isize when we
> succeffuly write, or return an error to user without update isize.
> 
> [1] https://lore.kernel.org/linux-fsdevel/aa--rBKQG7ck5nuM@dread/
> 
> > Also why is it OK to not call pagecache_isize_extended() but that goes
> > with the i_size update...
> 
> As for pagecache_isize_extended(), (this might be a bit tangential from
> your comment but) after this email, I started diggin a bit more into why
> it is needed.  As per my understanding, it tackles 2 things:
> 
> Problem 1. mkclean's the old EOF folio so that the FS can fault again. This
> allows us to allocate new blocks which previously might not be allocated
> if bs < ps.
> 
> Problem 2. Since mmap writes can dirty data beyond EOF, we zero the range from
> old EOF to end of that folio so that readers dont read junk data after
> isize extension.

Correct.

> Another thing I noticed is that most users of
> iomap_file_buffered_write() do their own eof zeroing in the FS layer
> (eg, xfs_file_write_zero_eof(), ext4's new changes,
> ntfs_extend_initialized_size() etc). 
> I think this FS level zerooing should take care of mkcleaning the eof
> folio (problem 1), as they call iomap_zero_range() which would flush the
> eof range anyways. So am I right in assuming that for FSes that do their
> own zeroing, 1. is already taken care of?

Well, I don't see anything that would writeprotect the old tail page in
iomap_zero_range(). I think iomap_zero_range() calls are there mostly to
address 2. Not only due to mmap but also possibly to clear whatever junk
there can be in the blocks after EOF.

> As for 2, I think after the EOF zeroing of the FS, there might be a
> window before iomap_write_iter() where an mmap writer can still dirty
> EOF blocks, hence the pagecache_isize_extended() would be needed here.
> But doesn't that then make the eof zeroing in the FS layer redundant? Am
> I missing something here?

Hmm, I agree the zeroing looks duplicit (for some users of
pagecache_isize_extended()). And yes, doing the zeroing from
xfs_file_write_zero_eof() is somewhat racy (mmap writer can still come and
write non-zeros before we update i_size) but I'd have hard time to argue it
really practically matters - you are racing mmap writes with buffered
writes so any kind of write atomicity guarantees are not there. 

> Regardless, for our case I think we will also need to do the
> pagecache_isize_extended(), mainly to take care of problem 2, but where
> exactly should we do it now?  We currently change the isize in endio()
> but for aio, it can run outside inode or folio lock. I think this
> function needs to be called under inode lock(). Hmm.. its a bit late here so
> I'll revisit this tomorrow with a fresh mind :)

I think mainly to take care of problem 1... You are correct about
inode_lock but since we are updating i_size, we should be better holding
it, shouldn't we?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

