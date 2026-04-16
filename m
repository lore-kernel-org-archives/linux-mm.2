Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75401F8A16D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 12:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1516B0089; Thu, 16 Apr 2026 08:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61FD6B008A; Thu, 16 Apr 2026 08:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51346B008C; Thu, 16 Apr 2026 08:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B272A6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:34:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EB2D8C618
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:34:24 +0000 (UTC)
X-FDA: 84664362048.13.4F17544
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id F13EF40012
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:34:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2lAvgDJA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TRzt6xZc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2lAvgDJA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TRzt6xZc;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776342862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=EZFL9+WNJJxszbVDcKbyCxJbG5j6QJGuPx6vvC5TPMB0L35Lxy73r7Hn6rgiTFcvjulVNV
	s47rZB/ZTpxOKiCgcosjHeFDsoWbjBCa3zzcS9CREkITIv1UULB6ZpbqEKRafic1igxE1R
	U3JyMd7QS1tkbMTzT8LsXR9XFt6MjCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776342862; a=rsa-sha256;
	cv=none;
	b=UU0lEFkXVNZkbIRyzF78oAC3hL7MBBgXMwa2EWxJZQBXhOWPasZFCBYv2gVU0HfGFYY5Z8
	wYG2NPCyzE2gL+jjclFwaRusho0wJWQfDOwZkIh7sdLsiW1YR5h4By8AUfZ83X8B6KMo6Q
	1OKf0TvnZMoV4/dyFnroIx75LrBQ3LI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2lAvgDJA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TRzt6xZc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2lAvgDJA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TRzt6xZc;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B9866A7EC;
	Thu, 16 Apr 2026 12:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776342860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=2lAvgDJAq/JoBGC7FwG9XFNG6323BkBaYk2YGa6y2Wg8d7U/VoNhv7l/kpUCDLGwn85Xmc
	ENOpKOhp0HqlXQ/YdUQ8Z7Wyz128OW/zrrZvn24GDdtEdjm1ehJppkJn/MjHfMWONGzqvN
	mRUjmYvrDKwjfJeBSaSpOtA3D9fmHZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776342860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=TRzt6xZc9OrfkCBcA7qKq99GsLISMToJjn4dVQlYzcKF8VIjubsyHlqCadtqpUpD8Un4UU
	fqu2kzSHAKnwQcDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776342860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=2lAvgDJAq/JoBGC7FwG9XFNG6323BkBaYk2YGa6y2Wg8d7U/VoNhv7l/kpUCDLGwn85Xmc
	ENOpKOhp0HqlXQ/YdUQ8Z7Wyz128OW/zrrZvn24GDdtEdjm1ehJppkJn/MjHfMWONGzqvN
	mRUjmYvrDKwjfJeBSaSpOtA3D9fmHZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776342860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VfRVQztVxZE1qlczIEiG+Di0cRaEaqEBpXbqpnycMEg=;
	b=TRzt6xZc9OrfkCBcA7qKq99GsLISMToJjn4dVQlYzcKF8VIjubsyHlqCadtqpUpD8Un4UU
	fqu2kzSHAKnwQcDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F409B593A3;
	Thu, 16 Apr 2026 12:34:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DSuOO0vX4GmxIgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Apr 2026 12:34:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B287FA0B67; Thu, 16 Apr 2026 14:34:15 +0200 (CEST)
Date: Thu, 16 Apr 2026 14:34:15 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: F13EF40012
X-Rspamd-Server: rspam07
X-Stat-Signature: uzy6t4t3c8jmfnzh3higbmgq3bu6mgyt
X-Rspam-User: 
X-HE-Tag: 1776342861-735062
X-HE-Meta: U2FsdGVkX19w4tVrq7R/4jKv/yAk5xzRY2z2dDHyeNV+h+gP8cGuYQrnYAjFj1imuOPJNE+iJQf8R63kTpmqXMPB0GcmP40otK8eCYil6QCAZo/9z++tu9PyzMCpKWlPCvkyibfNh9VBydypyiQgcKKPqwhr3nUB5W9cE7F99ED5pbWZWQr+jyFSYwU9V2/CQcAG/buXlxPKGUEmJLynWn4FSQIa3QZ0sxyY2B0NmQEHKM5R8V2wweDI0O3pM/vWJdL0ez3RTWp2AODjvje+iYoL3RSA306fy+wZmwVG7NnuKi/eesHueNsHLfGssJFs3625wRFoDSH6/veNXLLSqOfWHVheYPk/ojKBg6qyxW/dzllUr4CLb3oeS51yANSK45qMg95GtCaNUNrij976IFpG4xtoLG7yXHN2MoPim+xE8KOJ0EC3q37kVK/iGoVprLW+B2xLupm8lA6t6caQ2jZu0J7g+stZvf+lZgTbngrEn4Nq1UX4PJIhC70gUTtAovLdJHgQ8EKZONmwnSmiTFkGHraTm8q3U7hSFPbOQ8IJLYzUUgGG7jxLVKuV0ZzTZHb9FoXcvZkZUlYJCRa+kZ+n+sIvDEFipBQ3A4rdPBYyu0sIQthGjYrxi95jOLLbQqztUcQk/54JsTRfP1O5piS00VBiw6rrnSl3Jz8dxbKcjD88Zen+WEmbERx99mpzDUSR+AbIYuyFmjUJq0keib58Nhhfya/b7PTwHV8XxqyzL/6oYOvFTAZpykQE7kMKlQwtlpPluZhBp3oO2EPL7Y2o3ZVRd7V5P2wm2LduyQ0hUybZQfNwzTzzMb0/ZQ2ZFniMMzDZUZtwJp7MCkphWKc+g68C3b8/7gfJhSzQZonCO/pcWb4y7VZyFAyds2ai3pythcYyCaZ+WlA98HBjdLlV0fopD9E0viFZ6MQyenEVKqfQv6TdyKa65dPbCFOKqfHvHWMiku3+znKK0Ck
 zopWwY1D
 iSv5vvmBrnNr1SGRAa7ptq1CgccTaTyXccMTK6Pz3C88+SDo8dQpOq/9RTFTciR9H5FXmPffeqUFg/J5FdaLgdI3Tt/aYjABn8m19sD1xDQfyDnEeQ/x/uDlXdPmagiE8dU9QmY81ZOfySeKrPtl441JA+KWhSWRaJmFN4jwBIw3QOmMUbbQdmm3WV+4b91dHPZcZJK37y9BAfEP7A5tGN8pX0OpphidQS94tOT9VZ/4FYm1VBUkp5W2/TcxjuBd38sikr8BDYTvat/IKR95vceQfexsu28EXIA4zZLykQ5Jl7ZRFveNKsRtLTIq3lfc32nwLFxMTnPUfaTA8FBkgLQKgEMwuhHyXatZgXBctDfHtgx9S3Z1lSr13PEqhKt7o3ZzdQKd+KKhmWgmRA7fix96o/tMk3oIVp+4DYv/oGE9Twy8td65ANhlzb3R6I9Y1q0F0L7g6vbdNUeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some more thoughs... :)

> @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
>  	return __iomap_write_end(iter->inode, pos, len, copied, folio);
>  }
>  
> +static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
> +{
> +	struct kiocb *iocb	= wt_ctx->iocb;
> +	struct inode *inode	= wt_ctx->inode;
> +	ssize_t ret		= wt_ctx->error;
> +
> +	if (wt_ctx->dops && wt_ctx->dops->end_io) {
> +		int err = wt_ctx->dops->end_io(iocb, wt_ctx->written,
> +						wt_ctx->error,
> +						wt_ctx->flags);

It's a bit odd to use only ->end_io from dops also because we don't really
use direct IO submission path. So perhaps you can have just an end_io
handler pointer in iomap_writethrough_ops similarly as you have a
submission one?

> +		if (err)
> +			ret = err;
> +	}
> +
> +	mapping_clear_stable_writes(inode->i_mapping);
> +
> +	if (!ret) {
> +		ret = wt_ctx->written;
> +		iocb->ki_pos = wt_ctx->pos + ret;
> +	}
> +
> +	kfree(wt_ctx);
> +	return ret;
> +}

...

> +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> +				   struct iomap_iter *iter, struct iov_iter *i,
> +				   const struct iomap_writethrough_ops *wt_ops)
> +
> +{
> +	ssize_t total_written = 0;
> +	int status = 0;
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	size_t chunk = mapping_max_folio_size(mapping);
> +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> +	unsigned int bs = i_blocksize(iter->inode);
> +
> +	/* copied over based on DIO handles these flags */
> +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> +	if (iter->iomap.flags & IOMAP_F_SHARED)
> +		wt_ctx->flags |= IOMAP_DIO_COW;
> +
> +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> +		return -EINVAL;
> +
> +	do {
> +		struct folio *folio;
> +		size_t offset;		/* Offset into folio */
> +		u64 bytes;		/* Bytes to write to folio */
> +		size_t copied;		/* Bytes copied from user */
> +		u64 written;		/* Bytes have been written */
> +		loff_t pos;
> +		size_t off_aligned, len_aligned;
> +
> +		bytes = iov_iter_count(i);
> +retry:
> +		offset = iter->pos & (chunk - 1);
> +		bytes = min(chunk - offset, bytes);
> +		status = balance_dirty_pages_ratelimited_flags(mapping,
> +							       bdp_flags);
> +		if (unlikely(status))
> +			break;
> +
> +		/*
> +		 * If completions already occurred and reported errors, give up
> +		 * now and don't bother submitting more bios.
> +		 */
> +		if (unlikely(data_race(wt_ctx->error))) {
> +			wt_ctx->nr_bvecs = 0;
> +			break;
> +		}
> +
> +		if (bytes > iomap_length(iter))
> +			bytes = iomap_length(iter);
> +
> +		/*
> +		 * Bring in the user page that we'll copy from _first_.
> +		 * Otherwise there's a nasty deadlock on copying from the
> +		 * same page as we're writing to, without it being marked
> +		 * up-to-date.
> +		 *
> +		 * For async buffered writes the assumption is that the user
> +		 * page has already been faulted in. This can be optimized by
> +		 * faulting the user page.
> +		 */
> +		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
> +			status = -EFAULT;
> +			break;
> +		}
> +
> +		status = iomap_write_begin(iter, wt_ops->write_ops, &folio,
> +					   &offset, &bytes);
> +		if (unlikely(status)) {
> +			iomap_write_failed(iter->inode, iter->pos, bytes);
> +			break;
> +		}
> +		if (iter->iomap.flags & IOMAP_F_STALE)
> +			break;
> +
> +		pos = iter->pos;
> +
> +		if (mapping_writably_mapped(mapping))
> +			flush_dcache_folio(folio);
> +
> +		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
> +		written = iomap_write_end(iter, bytes, copied, folio) ?
> +			  copied : 0;
> +
> +		if (!written)
> +			goto put_folio;
> +
> +		off_aligned = round_down(offset, bs);
> +		len_aligned = round_up(offset + written, bs) - off_aligned;
> +
> +		iomap_folio_prepare_writethrough(folio, off_aligned,
> +						 len_aligned);
> +
> +		if (!wt_ctx->nr_bvecs)
> +			wt_ctx->bio_pos = round_down(pos, bs);
> +
> +		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
> +			       len_aligned, off_aligned);

Shouldn't we zero out the tail of the folio if we are submitting partial
folio for write?

> +		wt_ctx->nr_bvecs++;
> +		wt_ctx->written += written;
> +
> +		if (pos + written > wt_ctx->new_i_size)
> +			wt_ctx->new_i_size = pos + written;

I'm probably missing something here but where is i_size update handled? I
don't see new_i_size used anywhere? Also why is it OK to not call
pagecache_isize_extended() but that goes with the i_size update...

> +
> +		if (wt_ctx->nr_bvecs == wt_ctx->max_bvecs)
> +			iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops);
> +
> +put_folio:
> +		__iomap_put_folio(iter, wt_ops->write_ops, written, folio);
> +
> +		cond_resched();
> +		if (unlikely(written == 0)) {
> +			iomap_write_failed(iter->inode, pos, bytes);
> +			iov_iter_revert(i, copied);
> +
> +			if (chunk > PAGE_SIZE)
> +				chunk /= 2;
> +			if (copied) {
> +				bytes = copied;
> +				goto retry;
> +			}
> +		} else {
> +			total_written += written;
> +			iomap_iter_advance(iter, written);
> +		}
> +	} while (iov_iter_count(i) && iomap_length(iter));

Overall the differences of this function from iomap_write_iter() seem
relatively small so maybe it would be possible to just extend
iomap_write_iter() to support writethrough IO as well? Basically once we've
copied data into the folio and called iomap_write_end() we can have "if
writethrough, call function to prepare & submit the folio for IO".

> +
> +	if (wt_ctx->nr_bvecs)
> +		iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops);
> +
> +	return total_written ? 0 : status;
> +}
> +

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

