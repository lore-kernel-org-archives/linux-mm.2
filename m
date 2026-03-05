Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17876F3D330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624C76B0089; Thu,  5 Mar 2026 11:40:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE276B0088; Thu,  5 Mar 2026 11:40:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B07A6B0092; Thu,  5 Mar 2026 11:40:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4E56B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:40:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC1E1C104E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:40:08 +0000 (UTC)
X-FDA: 84512571696.13.E60CFB8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 483BC8001C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:40:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qtkO6LqI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oCx4m7fZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qtkO6LqI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oCx4m7fZ;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772728806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=54CN9pRh5wyrwo/7Df8AEC2FucQySqNkz7OjwJuc/SNRNE1nfDDsfQZyN3E3xQnAPJIrNL
	c6gm/uU09VbtaTOB3usfPU96nv9HPhpAVo1/wCoXaMk5ys6R0DncdXMSxTc6Pr4EHkH2gG
	F29iV1LiQ+qdiwACXz5T1n3IYJ8SMFk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qtkO6LqI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oCx4m7fZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qtkO6LqI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oCx4m7fZ;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772728806; a=rsa-sha256;
	cv=none;
	b=npImWMZkbg0Kyi62MKPayYyzGJVnS7aHRTiTBgKYkj/OxWM5KuR7vBA1PWqMltc0Lzc+WA
	YCX+lQpXCGy8c0CiGPvkkwIgtFg0ueGWwNmBIqKuVeOK1wy2hFyMAhpvmWExHbVjVi5Apo
	p7M0rCNeYuJt38CwBiLQfwuZGVIJJbo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CD103F958;
	Thu,  5 Mar 2026 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772728804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=qtkO6LqIVk9Wl1gDJzd8iBzDcwqFDv0BaumZH3AOIR+6AUIy73DAJ4u0VXAC2uZscFXqNl
	Bn3Y+X+mTOkC2dxV5iYll01YewOZEaeESdeCHxI6yMFUQ5K9CQR6XI3Wz2uGF7Kyw5OSLC
	8uxLvhe+jHal7R+gfvECFKOnBNAbvSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772728804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=oCx4m7fZ1RQ9/I5dB35OSD8Yx+UobdVPgvIsAZc+gE64dNgv+TRSBhkxwaF91No7foe5hq
	pB2nT6Pm/6QI8iCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772728804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=qtkO6LqIVk9Wl1gDJzd8iBzDcwqFDv0BaumZH3AOIR+6AUIy73DAJ4u0VXAC2uZscFXqNl
	Bn3Y+X+mTOkC2dxV5iYll01YewOZEaeESdeCHxI6yMFUQ5K9CQR6XI3Wz2uGF7Kyw5OSLC
	8uxLvhe+jHal7R+gfvECFKOnBNAbvSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772728804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=oCx4m7fZ1RQ9/I5dB35OSD8Yx+UobdVPgvIsAZc+gE64dNgv+TRSBhkxwaF91No7foe5hq
	pB2nT6Pm/6QI8iCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 901933EA68;
	Thu,  5 Mar 2026 16:40:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W8ooI+SxqWnBAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 16:40:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EBFFAA0A8D; Thu,  5 Mar 2026 17:39:59 +0100 (CET)
Date: Thu, 5 Mar 2026 17:39:59 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 17/32] fs: Move metadata bhs tracking to a separate struct
Message-ID: <5quave3vkmvgstqggaijh3b5225kfofkri6psl5xsib27gknq2@lzaj6uzs2pqj>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-49-jack@suse.cz>
 <aag2URb_D0h--RKX@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aag2URb_D0h--RKX@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 483BC8001C
X-Stat-Signature: pxajr4eozznqtksqff84nuaqmcywy8sz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772728806-150250
X-HE-Meta: U2FsdGVkX1+DZ+nqdX6ew+wNjpjuyPeCK/jG95OcdrU1N3yZPJutk8BgD+DSp65pqhnD91hUqcf70GNFtb5Pp8f5bzlAOe7TUJvU1aoFXWRbLv94wJlb57PqhMHE0vSU2BzoFbJOOrXXTycP2C22y8pUS03HmcLDlXSc5R9SpwXQNDYPeLvuT2F0GEXjzctVQMCJfXNqgMoAC4FeqFkK3BS/AJqmT2AsvEsv5EifSPtkiJZp4ZiMNX/JlnG1kw+mKlVHXfQNaSOV5Ag1q2AoBpwSYObUF7IMTxI/GvLzZyqhr5tEaVA9NFPhabgIRQCI1UiDdq0n4Rn8t6ghiCjSUNAreSW3KVg4RypSzoJltN86AR5RW7tjyfJuGkRmfpGVxc2L5WHW68RWv3ijXyNhehzzbeLZm9FsEPJdHgjx+dYfG9/84lec5JKR7PhBTbI5EFusC6VuF+8dLlasUq5ODtupSQ5rWhuNdtAazxr0xMg8vQN1EHKd2GSmf1u5XRxph0Mzz2NuNRWX5foSZpiQpUVhWfOvb15pLhJJ/b2rJ/LWi+wAmKq65xn4MZ+9XrdveT1cUxCNVvlO8timn8E6jn9LhItSZ/LBkZfJTFAZFGb65YJVYubi33v8s0XGlXEVzCamU+nLlcRfE2nlDNgUTWmRcoZ6pKw+DGSvHHrep5cDUwr3tu/X9gppKgg/mfkotPoxw6GEDO7VRcTFJsop2PVOcUH+0j4zGpEGiGsAZ2OkPx+QxfbTmcwvcDvusaRXq5Z+vBDrz9gmwt69IyCPZEPL1XAcu4JKdHw8JnsV61/vj/xgKW8wlQcYCNb07nYHlgi2SMcvHPlgF9tzT8g2ONoIKhJTAL/wy9OIsy6+BuKvImPPcUPIHSYZmqFXlxqXZmVLItBmTzrMRUvLkDW8o33pqdVNcs5M1BWiyej/k/3UQWycu9D0sjS+2OE3MrEWLGeNQXk2VZVtdyUosdu
 ho4By998
 iR291TA+jAExI2fg5WQ9O2GQsRo6IfaC0rTA6yx7xLJv03SpQITPQ4vuPVYnz2fpi+OkwtsZWqPLgN7vX9VRcCcstcigGr+39dbZJ4wGq9CSyAvBhqvjz2c0SwZRE8VTY8kJY3A3KqSPmD7ZKl2v855Nu3LUIEEIru2PXxgy2dQpkwz3F1JgM6RjD1N9qtOI5Jje2F1SBsfzLVhTNvRzzo2KONIN08w2+IuSWZDo1thVYYWagOsyGz8URZbHzjD5XW9dcoJ1h96gj5m1+cUJNZoJghpur2ss0VRrUoI9EhbPV5LfLr5GostLl3soBImPvud0GYx0uPx24obnJMRhUGGVSDBNrZ4XpZeZWDuMm7kIRelI9S6ePqxFzmD6fUpwS9McuzTyXRmbRA/8p0sULRzQ3dj87XVxFLg5v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 05:40:33, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 11:34:06AM +0100, Jan Kara wrote:
> > +static void remove_assoc_queue(struct buffer_head *bh)
> > +{
> > +	struct address_space *mapping;
> > +	struct mapping_metadata_bhs *mmb;
> > +
> > +	/*
> > +	 * The locking dance is ugly here. We need to acquire lock
> > +	 * protecting metadata bh list while possibly racing with bh
> > +	 * being removed from the list or moved to a different one.  We
> > +	 * use RCU to pin mapping_metadata_bhs in memory to
> > +	 * opportunistically acquire the lock and then recheck the bh
> > +	 * didn't move under us.
> > +	 */
> 
> Should the buffer_head simply have a pointer to the metadata bh list,
> as that would avoid all this and keep a lot of the references to the
> list self-contained?

Yes, after some thinking that should be doable if we then add pointer to
address_space to struct mapping_metadata_bhs. I'll try how the patches are
going to look like.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

