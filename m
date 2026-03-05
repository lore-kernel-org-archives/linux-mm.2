Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70074F3D31C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B216B0088; Thu,  5 Mar 2026 11:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F106B0089; Thu,  5 Mar 2026 11:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97126B008C; Thu,  5 Mar 2026 11:14:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A87C96B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:14:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34CC0896AF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:14:34 +0000 (UTC)
X-FDA: 84512507268.30.C7C1840
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id A9AB540003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:14:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BX07VcXQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iTTEwP25;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uqUBFlXp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vyuVI/Go";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772727272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvnM65cjCXEooSKUwaNOtAoF/LC/L9IWrl0xNgJk6rE=;
	b=AXfDnCk9tCSeebNqgMmP3BWmyHILAkWIYUDLTdKTfQOVxT59uT61Xq9/qDw68oVznzrhqu
	45dmhIygGU8xGZbu4XxtJ8myezIj7MvJ33o1xlEaV7sp83z5VwtcFld6Apqt3sYv3nLaa/
	NYTrvoNVp/4hwG5sScxlDDrsMGiyZbw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772727272; a=rsa-sha256;
	cv=none;
	b=EXPNfTrdMXMt2b6sCS5XjcKMNnvaOFnxmzhJixvNJ73/T7TmhJSywhi94yByx7tCqe4ddV
	g9p4IjCtrDz1oHTgirKsMvm/4YbT4XA2W4LTEmi7LtQ5laDKFLtXWA0eIwGKcBm5kRF/Yi
	C/aHU6/TETpaOzw/RZqGUJMN2rbPr9w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BX07VcXQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iTTEwP25;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uqUBFlXp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vyuVI/Go";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D9C915BD12;
	Thu,  5 Mar 2026 16:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772727270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvnM65cjCXEooSKUwaNOtAoF/LC/L9IWrl0xNgJk6rE=;
	b=BX07VcXQwIZia0P5p6GHpM0EBtFKfaQ0jZth/SeLcpxbZg4uKczTEFvpbR7NxZNkC6sdA/
	fQyIOS5NjgXOulUYJi4RevwylAgdYI4plQt+g9ffh/YvmIRVBkNgtcqz8++JBFdolvtC3c
	kz6qYGc/1duGHqhQwzujfHFSlMWj2aQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772727270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvnM65cjCXEooSKUwaNOtAoF/LC/L9IWrl0xNgJk6rE=;
	b=iTTEwP251IQRkOtNKGf/p9TInPboBn8Peui7YryghXi84naTlDiF5G0VpdyUh3oJhQBEhW
	veDxweUCZmcA5gDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772727269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvnM65cjCXEooSKUwaNOtAoF/LC/L9IWrl0xNgJk6rE=;
	b=uqUBFlXpXgHJndfqPcoLTbVduSC85vpkNvKot2CXfFblycPQqQ7hzzUIMTERHcX/4NBJrk
	ZpZbGhcW3GnOkFCua0+/vBj+6ZqbS2iHwCalgQBzU4I0U/goAVU32Aah1n54xNbVJcGjcK
	tzNWOAMZiRK/Y/vPwuF1VXBqu6mRB14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772727269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fvnM65cjCXEooSKUwaNOtAoF/LC/L9IWrl0xNgJk6rE=;
	b=vyuVI/Go313y9pxS59lcKV1WYtDbwbPylzegtcr+eJVgX72n9ERc7r/ZLgQVKw6o/Xe9T7
	5Z2aj77Xtq51jSAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C52203EA68;
	Thu,  5 Mar 2026 16:14:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g5wTMOWrqWnLZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 16:14:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7D08DA0A8D; Thu,  5 Mar 2026 17:14:29 +0100 (CET)
Date: Thu, 5 Mar 2026 17:14:29 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 16/32] fs: Fold fsync_buffers_list() into
 sync_mapping_buffers()
Message-ID: <ezoc54wmvpxlhlfvl65vmexyla63qo2vfpchbr3yr5tmuguhwc@d4kanjecvky6>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-48-jack@suse.cz>
 <20260304-bildmaterial-deckname-1995a115de52@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-bildmaterial-deckname-1995a115de52@brauner>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: j8xo5zu3njadk891uz5w94mh3adjzeyq
X-Rspamd-Queue-Id: A9AB540003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772727271-348240
X-HE-Meta: U2FsdGVkX19MfMFMg8YYgB0ppWJO/cBRIt+Tgh39xzCLI3EXcej0GqugNdKzre+AFANU3adzKl06HN/GrqGwmXaW5r0GkiIBLX8gNCTGwufSCj9tBFs26SDKTZ7s2Q7gm/CF/2RABZbkS811wa4OpajKCK9Y/I/s3Wf/lvflJQQQxJL9iRnucN3AuUDAFqMTJIKtVGvlPJ5+Sh7ZnzfA0x3P6xSkR5QBNVZjx7sBRCxNEG9jm750XnYn8FwJlznAGLwCN5A8E8kmoWbtPOpSszhZdUjFWuyQKlMwD7XNhSbZ7dFJvOKZaOugbvmom+tKrugXZxLGJkf+7a4IhkexSbNhBuQNqVz0j6u10R2nq6FU0iHz5DMJc4nzbnMRCGr+Fh6KcaeDkwJJ+ueAL3dBT2j0kemRH7iww1wIpoXLhWZaljXdzVE6JtZVtOvQZgrxzIK8rVWy6vfr2wP0AEDbXQO9X2DqBTRfiG1QVNeqU0RQJrSDZW1ntyN09y644PlhIFhf0Rn2hG9pcsG0pw71Bl5jX5XQw1/64QF8VQWiLaKh5eXcvtEstpf9aVRE4jhBT2E7temId68AdejzJduwJtG++na88KT5UKOykUTEL0IIpgWCTsUw3O9KY1YXL2QxIeYWNS9QFzHI+9Osw64J8FgtIk3k7QaNtSilgmARi8z2de2kiixiQYoPimDDOFh8DXXXxHFAlUW2z+1D9nkyu8GGWSJGDbgnMeYHy8GK3v8pcIc3YgWRCsD9LN7kxywFnMPqdJhrVC0lPAr0iG1qGihvaUAFzwYOqQEo7NsTcWASTAqucJ6uNVenUaz4Ucsdlzn7LH2JlMrtv2QFT800z7MsvRgvttl37BkJWjWJz7++NG+Fsz990/KsETD2g2rl9Ix3XZwhPJ7rFXCs9i4BlpNUpn0TEI4H8PQb2bLGtgIJhvbU4Byhms1wLclMBcvEfQ3QWVMjQ8E0HTkGMVj
 pQMe5LGI
 H61DzvtL/rYD+ra3/oYVcTTLGtLSuCzDKtBjWVu5xNyMY1xWJqEe7vj4R11feUI9Czgh8jqrIqh7lr6CmaOvmbYG9Or11OFbchY2XJYfJT3mPeItJLHYfW49TGOKPOgp71P16C3p1Ur/rBF+IwUpRKTTggGIVmI/g07CE/iQAc/5niJ18EPLRBwD/JTf/yTDzo7dguLAtCMJIEbKSnEmmPddXwpf/kBge07okV3rjI6uoFBq784LcP+wFtVW4vffwpQ2MIH2Mp7N2yHjvbIA7Dz4RnH4MomvDS41Sr6B4VZLW0mSdZyMsVRZB4Iz1IkalNBFPxrNoxNEzj82POxiIRAPL/wnjSSc5EkekIj3E3/vEY9JZKw2iMoq/3ZB22pSJyZLJS5z6MdsockP6DqlarmPQnsMH90dgG5gIXnmm3GFXSm7+ctQ+ANWbOlHxvkxL1gTAvzxdPMvXP0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 14:38:47, Christian Brauner wrote:
> On Tue, Mar 03, 2026 at 11:34:05AM +0100, Jan Kara wrote:
> > There's only single caller of fsync_buffers_list() so untangle the code
> > a bit by folding fsync_buffers_list() into sync_mapping_buffers(). Also
> > merge the comments and update them to reflect current state of code.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/buffer.c | 180 +++++++++++++++++++++++-----------------------------
> >  1 file changed, 80 insertions(+), 100 deletions(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 1c0e7c81a38b..18012afb8289 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -54,7 +54,6 @@
> >  
> >  #include "internal.h"
> >  
> > -static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
> >  static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
> >  			  enum rw_hint hint, struct writeback_control *wbc);
> >  
> > @@ -531,22 +530,96 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
> >   * @mapping: the mapping which wants those buffers written
> >   *
> >   * Starts I/O against the buffers at mapping->i_private_list, and waits upon
> > - * that I/O.
> > + * that I/O. Basically, this is a convenience function for fsync().  @mapping
> > + * is a file or directory which needs those buffers to be written for a
> > + * successful fsync().
> >   *
> > - * Basically, this is a convenience function for fsync().
> > - * @mapping is a file or directory which needs those buffers to be written for
> > - * a successful fsync().
> > + * We have conflicting pressures: we want to make sure that all
> > + * initially dirty buffers get waited on, but that any subsequently
> > + * dirtied buffers don't.  After all, we don't want fsync to last
> > + * forever if somebody is actively writing to the file.
> > + *
> > + * Do this in two main stages: first we copy dirty buffers to a
> > + * temporary inode list, queueing the writes as we go. Then we clean
> > + * up, waiting for those writes to complete. mark_buffer_dirty_inode()
> > + * doesn't touch b_assoc_buffers list if b_assoc_map is not NULL so we
> > + * are sure the buffer stays on our list until IO completes (at which point
> > + * it can be reaped).
> >   */
> >  int sync_mapping_buffers(struct address_space *mapping)
> >  {
> >  	struct address_space *buffer_mapping =
> >  				mapping->host->i_sb->s_bdev->bd_mapping;
> > +	struct buffer_head *bh;
> > +	int err = 0;
> > +	struct blk_plug plug;
> > +	LIST_HEAD(tmp);
> >  
> >  	if (list_empty(&mapping->i_private_list))
> >  		return 0;
> >  
> > -	return fsync_buffers_list(&buffer_mapping->i_private_lock,
> > -					&mapping->i_private_list);
> > +	blk_start_plug(&plug);
> > +
> > +	spin_lock(&buffer_mapping->i_private_lock);
> > +	while (!list_empty(&mapping->i_private_list)) {
> > +		bh = BH_ENTRY(list->next);
> 
> 
> Stray "list" reference? Shouldn't this be
> BH_ENTRY(mapping->i_private_list.next)?

Indeed. It is just a temporary breakage in the series but still. Fixed.
Thanks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

