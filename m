Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A1DF8A163
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 12:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548846B0005; Thu, 16 Apr 2026 08:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA356B0089; Thu, 16 Apr 2026 08:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8A46B008A; Thu, 16 Apr 2026 08:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30B9D6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:05:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF74D1B8B1F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:05:43 +0000 (UTC)
X-FDA: 84664289766.26.89FA05D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DC911C0011
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:05:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xfBPxdTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="T4/LdxVK";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xfBPxdTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="T4/LdxVK";
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776341141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=5wOpeNVPz2Jb96HS61ZH+ofcS+Io3MSyCV7NQVQQCCqSybJZ8EGd8aLt12COGFCu6fDP1u
	YgopOrOJamESuoA8LgiBlLwsWoRPop5pyqc09Lhv8wpK4db9/szvsC9T4RWsiomeq0/uUv
	JhY0UD43XPGjMy9JIRdVDuJ/c7/QGMc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xfBPxdTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="T4/LdxVK";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xfBPxdTo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="T4/LdxVK";
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776341141; a=rsa-sha256;
	cv=none;
	b=hdXBLQt+5c6WlMvhcOis3LCb9xbiDuMMC7YDY8ijtvWi6jXXI0dU3d6hS6JdsvWWwhnRkk
	HxXbVlJOFFROguwPCMU4K0osYteAFQ5T++CW0MN9c4aRYaxb9jDziuxahGWS2kg9WMBBko
	sY39n9qTGrB5P3rioUo0mKPlVCUSVxo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 90A296A7F9;
	Thu, 16 Apr 2026 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776341139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=xfBPxdToC5U8ErxBtunsRT59prlS+QPeDJbP8MISpIr85lpV8SNIAxskf3Z2TescqwqKRS
	Mtnx52HZXpkrmMVmR72ez8LpqgrCT+qE7jcgSfOw+7K3PnsjPC1cBwLMpob+aIZ5mpNzJ7
	EbiGqRohc65yUIINs9Bm8BE8S9K0leE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776341139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=T4/LdxVKWKFmDADmBO/WtToF+wVJa/EczIBvCy3ZlXL4Hio4qD/62bOiZV6/MmBly+pEZG
	78MGpUi8qwmm57Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776341139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=xfBPxdToC5U8ErxBtunsRT59prlS+QPeDJbP8MISpIr85lpV8SNIAxskf3Z2TescqwqKRS
	Mtnx52HZXpkrmMVmR72ez8LpqgrCT+qE7jcgSfOw+7K3PnsjPC1cBwLMpob+aIZ5mpNzJ7
	EbiGqRohc65yUIINs9Bm8BE8S9K0leE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776341139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzic6Sec5CbuqHmkHsjg0YroaADL07uS7ZD4kwHtxlc=;
	b=T4/LdxVKWKFmDADmBO/WtToF+wVJa/EczIBvCy3ZlXL4Hio4qD/62bOiZV6/MmBly+pEZG
	78MGpUi8qwmm57Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CF22593A3;
	Thu, 16 Apr 2026 12:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IPOmFpPQ4GlRBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Apr 2026 12:05:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DCB6FA0B67; Thu, 16 Apr 2026 14:05:34 +0200 (CEST)
Date: Thu, 16 Apr 2026 14:05:34 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <5l2pnrwodwbey7lwmysjxldqpm2kbyi7kqp5tqg7xozvaoecuh@dcglcdr3ipnz>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5DC911C0011
X-Stat-Signature: py8q8c3wcaeypweeh8h4qkzhd4rmmxt5
X-Rspam-User: 
X-HE-Tag: 1776341141-815545
X-HE-Meta: U2FsdGVkX18j3g+t8R5BDlHAX3WgSOS8Y2ZYD+fcm0F1ouZqXbAg9rKUUAhX8KbQdrX2VL3HmBt6MCAjLsI5TDFLABOKBMKKBD+iPQuZkMdnxBOPIa9dXoBfb/3il/Fg97FGKgUOdPtDc7aXqCH8Fu9q/D/GSKvLix3eUTBxRhnKgzzu7cBHybEAlL+WIUjUIn3o8xzaUnF5eW27vyFe3hjAAuOa/zgl1aBIhKkEPGBeO9UicGUH3SLyjDuBOBR+JiS/zDBeyWF0eGkA3+EAcN9DDZEKsUb/XtQLQTnZjwEK3XI9IDqSd1am6oYYFZzHCWZd+ZgHXuQvGMvyjNsh/mX4YSxOIoQxqRp5dzLtF5rlGIC6wmyTqHYPVLfxwqGsjqL/ocCje4zacNxgPir9hId4nv9UO0l62LgEEXdFRvbEzsNOYHxOQ6YLum6jqWBmRRs2QeSvbl7NA08+dIrEnWPJSDD8HmTeSIKANk6slE1KsKPRWKu94zIGM1RxkYevJ6PNdr58AD4/OxbenwusrCnhlf/OZjlhrskeYVMwf2qcl9m7TU3r7y29LFY7wCrTildb7105s8DiqZSe4mJ2izd5EfH/P6gYeSZtrX2FfK1tvfz6O7RQMKLOzlcOubQU4sQzUI6OCrdgcA5KWuX7v/VyfsSWtFAaoDZNEYxoz7BhzlNRto/v0vIt9SLaEtD86NYkpC8Lv7ijplKLSpeOHhVkTifLkF4TqWML+E6pReD2bGqeMjHQv1QsLzj/a4wBRPhDiqD4d/6B6ml9ZfM59dtNCOH69MVqQSgQ575jxWXpN5ewo+BuXNsdE0uojI/Ck1tjuN7RFRHdIff2mTRdbO5Y/bujd5nB1cah5p1Mhiccs4PxNptnR/JcN40Dpj/JKjT0sE2rwiPy3T70S/LiDNz0Aazr+qPMucUmBfZ21MU4BWagd9yj8TdfdlLrcrMluvEYgXnGZpALAFlK4aw
 qKTyzrPm
 8WqKfZaBntDAzOrqqVUKrcZkSgDtA7jWFX92GuQDrXNkKZTG9/QTV6rEsKfyUXoC4wohbdOPwWl5nEkuj+ZB+N/c72f6CCNMPU3pKVhj2E7XIlq7Jo9ArpsjDgQT0MUlyQcigL3FL7++pfWGdaXyVIoXM2HP/5UDUITPArje/XmtrxLPZd5DxxdOinmQwBvAHQ3WZFCrqqb7hX1g4vVSUlb2nJgjXMccQBqKZ2/Bqq9LGD76dXxojibI5xWu4U3+OpbEZgdKO4h2rXaOd5H32o94CTT4i7nkZnhfqvh+S450HG4f/IjcVJ5xrfttt2+HULec9yUVtymqhctSuKV4d/8cLuVn5MW9ChiBiifPaqUluMZY8uhtQ3hvek7pormwk9ieF7yLCCOcCVe9trM28AFgfu/cEvq0+AytZ6g3PXAGs1WbmzYuw6LcuV1wnMJMqnDLDXcxgHjx2voXlfhYT4/yw5YcMALc5qfL/OtG415exJP8cpHOHYi/n5JkD1+A/ICbCUwnbuYfQ86OULVNZ4qpm7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 00:15:43, Ojaswin Mujoo wrote:
> This adds initial support for performing buffered non-aio
> RWF_WRITETHROUGH write. The rough flow for a writethrough write is as
> follows:
> 
> 1. Acquire inode lock
> 2. initialize writethrough context (wt_ctx) and mark
>    mapping as stable.
> 3. Start the iomap_iter() loop. For each iomap:
>   3.1. Acquire folio and folio_lock.
>   3.2. perform memcpy from user buffer to the folio and mark it
>        dirty
>   3.3. Wait for any current writeback to complete and then call
>        folio_mkclean() to prevent mmap writes from changing it.
>   3.4. Start writeback on the folio
>   3.5. Add the folio range under write to wt_ctx->bvec and folio_unlock()
>   3.6. If bvec is full, submit the current bvecs for IO.
>   3.7. Repeat 3.2 to 3.6 till the whole iomap is processed. Submit
>        the final set of bvecs for IO.
> 4. Repeat step 3 till we have no more data to write.
> 5. Finally, sleep in the syscall thread till all the IOs are
>    completed (refcount == 0). Once that happens, the end io handler will
>    wake us up.
> 6. Upon waking up, call fs ->end_io() callback (which updates inode
>    size), record any errors and return.
> 7. inode_unlock()
> 
> This design gives buffered writethrough the same semantics as dio and
> any error in the IO is directly returned to the caller. The design has
> delibrately open coded the IO submission and completion flow (inspired
> by dio) rather than reusing the dio functions as accomodating buffered
> writethrough logic in dio code was polluting it with too many if else
> conditionals and special cases.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Overall this looks good to me. Just a few smaller things below:

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
			       ^ missing 'how' here

> +ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
> +				      const struct iomap_writethrough_ops *wt_ops,
> +				      void *private)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	struct iomap_iter iter = {
> +		.inode		= inode,
> +		.pos		= iocb->ki_pos,
> +		.len		= iov_iter_count(i),
> +		.flags		= IOMAP_WRITE | IOMAP_WRITETHROUGH,
> +		.private	= private,
> +	};
> +	struct iomap_writethrough_ctx *wt_ctx;
> +	unsigned int max_bvecs;
> +	ssize_t ret;
> +
> +
> +	/*
> +	 * For now we don't support any other flag with WRITETHROUGH
> +	 */
> +	if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
> +		return -EINVAL;
> +	if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_DONTCACHE))
> +		return -EINVAL;
> +	if (iocb_is_dsync(iocb))
> +		/* D_SYNC support not implemented yet */
> +		return -EOPNOTSUPP;
> +	if (!is_sync_kiocb(iocb))
> +		/* aio support not implemented yet */
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * +1 to max bvecs to account for unaligned write spanning multiple
> +	 * folios
> +	 */
> +	max_bvecs = DIV_ROUND_UP(
> +		iov_iter_count(i),
> +		PAGE_SIZE << mapping_min_folio_order(inode->i_mapping)) + 1;

Can this overflow? iov_iter_count() returns size_t which is ulong.

> +
> +	if (max_bvecs > BIO_MAX_VECS)
> +		max_bvecs = BIO_MAX_VECS;
> +	if (!max_bvecs)
> +		max_bvecs = 1;

I don't think 0 is possible here since we do +1 in max_bvecs computation
above.

> +
> +	wt_ctx = kzalloc(struct_size(wt_ctx, bvec, max_bvecs), GFP_NOFS);
> +	if (!wt_ctx)
> +		return -ENOMEM;
> +
> +	wt_ctx->iocb = iocb;
> +	wt_ctx->inode = inode;
> +	wt_ctx->dops = wt_ops->dops;
> +	wt_ctx->pos = iocb->ki_pos;
> +	wt_ctx->new_i_size = i_size_read(inode);
> +	wt_ctx->max_bvecs = max_bvecs;
> +	atomic_set(&wt_ctx->ref, 1);
> +	wt_ctx->waiter = current;
> +
> +	mapping_set_stable_writes(inode->i_mapping);
> +

We should check if mapping is already marked as requiring stable pages
avoid messing with (in particular clearing) the flag in that case.

> +	while ((ret = iomap_iter(&iter, wt_ops->ops)) > 0) {
> +		WARN_ON(iter.iomap.type != IOMAP_UNWRITTEN &&
> +			iter.iomap.type != IOMAP_MAPPED);
> +		iter.status = iomap_writethrough_iter(wt_ctx, &iter, i, wt_ops);
> +	}
> +	if (ret < 0)
> +		cmpxchg(&wt_ctx->error, 0, ret);
> +
> +	if (!atomic_dec_and_test(&wt_ctx->ref)) {
> +		for (;;) {
> +			set_current_state(TASK_UNINTERRUPTIBLE);
> +			if (!READ_ONCE(wt_ctx->waiter))
> +				break;
> +			blk_io_schedule();
> +		}
> +		__set_current_state(TASK_RUNNING);
> +	}
> +
> +	return iomap_writethrough_complete(wt_ctx);
> +}

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

