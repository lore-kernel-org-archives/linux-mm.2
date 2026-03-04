Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5BBEF8FE6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128D86B0093; Wed,  4 Mar 2026 08:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5096B0092; Wed,  4 Mar 2026 08:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23376B0089; Wed,  4 Mar 2026 08:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4BDD6B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:38:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97099593E1
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:38:45 +0000 (UTC)
X-FDA: 84508485810.27.47D6C97
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4FC9A180003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:38:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YXBdusYh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G5B6X/oe";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YXBdusYh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G5B6X/oe";
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Htf16GFqRL+ZQDdkzons7SZg5zvlwxDcC+pn7DlQzPs=;
	b=uvtz+5S5g5ZFVddrtHCkdFPXoaMzEVJ5Kih1kC/WMbBbSHr+cpCcKpIAr01cyaDVJxtB2E
	nwHL/Le40kviuyosK92mUzc/lZOV2AgwhOy/i2BH254SCLUECBnMb1iWjPNuGwZXrRyzI/
	ZElK/pNQypW+sod6keXIMCMBuaMgkR0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YXBdusYh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G5B6X/oe";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YXBdusYh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G5B6X/oe";
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631523; a=rsa-sha256;
	cv=none;
	b=E6dCaGYqts+OWrra9EFzEz9WaXZZNkPJFNKfhs5FUpMypnvLS75BJV2spJus70Q96rMG96
	pXvGifensKfKfflAAG47oMzyAMzIMqZhRoCmil19EZJcGhcaom3mm0ZdsL3kIlMr/VhBU1
	09UmDlS7WYwP0O1zUOHvn/p47K8QK0s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6E2915BDF8;
	Wed,  4 Mar 2026 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772631521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Htf16GFqRL+ZQDdkzons7SZg5zvlwxDcC+pn7DlQzPs=;
	b=YXBdusYhDCVl7yyvEyjdr5j5bDvYTuTVIsZP4koIeDM4IZcNQfjeTS7pp0D/C1zhTRrgO6
	JQgHUBxJJe32FzyahUwyj/Y6uNrmW4h7MFyCSUfyDWq0MaqZipaCF/5GpHWuwjGBHH8dU2
	yE1PHgGsenZXHnJj1ir3exLg7qc18z4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772631521;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Htf16GFqRL+ZQDdkzons7SZg5zvlwxDcC+pn7DlQzPs=;
	b=G5B6X/oeQ2T7M3AbyuuwHb+mdgYrzVfR7GKx9l7WtxMlVk+uvrAoUeqllKpnvStM1w97y9
	nFuH7oVdlBVIw8Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772631521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Htf16GFqRL+ZQDdkzons7SZg5zvlwxDcC+pn7DlQzPs=;
	b=YXBdusYhDCVl7yyvEyjdr5j5bDvYTuTVIsZP4koIeDM4IZcNQfjeTS7pp0D/C1zhTRrgO6
	JQgHUBxJJe32FzyahUwyj/Y6uNrmW4h7MFyCSUfyDWq0MaqZipaCF/5GpHWuwjGBHH8dU2
	yE1PHgGsenZXHnJj1ir3exLg7qc18z4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772631521;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Htf16GFqRL+ZQDdkzons7SZg5zvlwxDcC+pn7DlQzPs=;
	b=G5B6X/oeQ2T7M3AbyuuwHb+mdgYrzVfR7GKx9l7WtxMlVk+uvrAoUeqllKpnvStM1w97y9
	nFuH7oVdlBVIw8Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 636013EA69;
	Wed,  4 Mar 2026 13:38:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lDo9GOE1qGmpWwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Mar 2026 13:38:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1FE0FA0A1B; Wed,  4 Mar 2026 14:38:41 +0100 (CET)
Date: Wed, 4 Mar 2026 14:38:41 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 18/32] fs: Provide operation for fetching
 mapping_metadata_bhs
Message-ID: <4ji4ihp7tzhxr35t2vgnswfskrjnsuo4eys4klblnor2b663pp@x3khuzh7cxhv>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-50-jack@suse.cz>
 <aagxU5f1AI3y0wrw@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aagxU5f1AI3y0wrw@infradead.org>
X-Rspamd-Action: no action
X-Stat-Signature: 5x5feugt8txpri83p5brdi35z8dwgkxx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FC9A180003
X-HE-Tag: 1772631523-429780
X-HE-Meta: U2FsdGVkX19GQezTY8w4r27DXdIil1VrShMGcrFm78qwvoUgs7bLkoVQmE0govcye+LlA0cSMN62Obi9gdWUf5L/VbuuG/v4rVCd6nEG0DNZQf3+WIUzNLlrqAGmY/09eSUgUXKOacgN6eLTCn9CyZi7OEdZR+gSCfpD4Z14952zDELYp+A2GbGx9sgnqab7/XhtORrIpqnigQlR3lRkCifWBEhoXiEi+p3q+eeFZ+Fg5JYNhulI3r81EWEMPWi1DTg/prXuKA/4X0x5Ff+RvA8ki0+dQtwDnYw7gyIXH1rUuKqaOtYvp+VuozRS6xFankmz0oxnTii8HzlqX90SpY3ORcVCGCbQ9bZFbL6GHlewQj0kZs2wzDF6/OliceyyhpLR1iQymOlfWSjUEI9Dy01iw9tPaDnewqQqy5fq/21w5rxfs/Xinq+7X+d/ERELn7hq6w6svxnl9d4lyI2Ysswc70ca2wO9e8Hx2hDFtj0fK4tERxxfiik1C41EcsQf6LZl/6DJIvXvNZhNTpzrjQDI3rNtt5o/OTBrjhp0EmyHH2SMJFM7TTPw/ZJ9XVaS3h14GNNuSBx9A2KGIhOCTEN33XggKlHWbgGHbvUdhVwJ2DfgL52AzsiYD9NcY/dNGN16XPe5rooG/pb8oaZfOyso8D+2LGVlxKxnGQwBwScxmdFYvS1DI2XkpMTJq2gjFSbrOwkzzR0Jh0Ok4ykwWFhDzSpUyDzVOHCqpe++smQ7yMFep4c3lNm/35PMJBgmVeEhtWfmvFVvEZAREfynWl5Frl5LphJLbyWXTE8jvgtX4F3c46Kkl2Iahj6VJa+5yP/foUV5K2MzW4CdQK6exvTzwOvp4yyHUS7ABLTfDAxbKfZC95lXOQRJ1ge2H88O2duY8lDqALcmYmRr6xlnTC1Fo/x+/o0L5SCzbI+rSeKNqh90cZNIbo8idklWNNdIItGcxxyLuZx1R0fvbEX
 V32vq1js
 TmqW+HBRu7gnTsnKCQw6jqz6T4TgXdIfMETl2BocUo1ygQacu6BklU6BaHnAG8iPUSwIlPJhTsAxLtngafC6IRmlIlmdjs3SHH7D9WaYVxd/sJ9WAqqzdBTXKQpO7Y3UY6tn7f0vjzTxv2UG4R0jZaTHmbK4eepX5HXHziq1ooLk/zfcPAIZ4ki1B4Ds9OuK1pxkiF9MfeCiWFZvmlOjqXDJM9S7Ybb0msIa+YXroXqVc8HrB3OEWO/2MfhU5TmjeUHR1ex72z/x6NJYBV1ttWzWibT3EukGklcsuVK5wvrL4jEmCxQYOpXm/o9g8rMtupn7FfYQNXAQLfwY1qMu/UmYjqSKt1xvi/GDdocebNrVs3Vq0c3cTzrclghpn61ASIj+Ko5IGL1LvJ+aIrMvCvpf3V4aG6CGoWK6mKrgwXSgu0S0rZjADZlI8ULnHWWY5iFg4Ne+eNyf3J4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 05:19:15, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 11:34:07AM +0100, Jan Kara wrote:
> > When we move mapping_metadata_bhs to fs-private part of an inode the
> > generic code will need a way to get to this struct from general struct
> > inode. Add inode operation for this similarly to operation for grabbing
> > offset_ctx.
> 
> Do we even need this?  With your previous cleanups almost all of the
> places that need the buffers list are called more or less directly
> from the file systems.  Can we take it all the way and just pass the
> mapping_metadata_bhs to those functions?

I was looking into that. Passing these to sync_mapping_buffers(),
invalidate_inode_buffers() is easy. Passing to mark_buffer_dirty_inode() is
relatively tedious but doable. Where it gets difficult are calls like
bforget() and most importantly try_to_free_buffers() on bdev mapping where
you currently have no way to get to the mmb struct... We do have
b_assoc_map pointer in buffer_head which we could switch to point to mmb
instead but IO error handling on bhs needs to get to the mapping from bh so
we'd then have to add address_space pointer to mmb for these uses. All in
all it's doable but I've decided it isn't really worth it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

