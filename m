Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7910AC47BCF
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 09:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07F36B0005; Tue,  6 Jan 2026 04:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF296B0088; Tue,  6 Jan 2026 04:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB626B008A; Tue,  6 Jan 2026 04:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE2A26B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:34:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D0E3B99E2
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:34:06 +0000 (UTC)
X-FDA: 84301027692.06.19CF270
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id C26FD20003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:34:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cf+rn6jm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B7fPsCqp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cf+rn6jm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B7fPsCqp;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767692044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lD+gb9iTwtAOL0+AaRfPVu6+0szSFg5PvynsVOPibio=;
	b=TLnzPglEmo8p1IlU5MqWpP9olLZpHz4u7TH6SH1orBn9mMqwQRm1IBmyn3j5hmb1DDsIzt
	85wX7HRSaRik1Hz71LzIRE+EUFlek5zZndH0naoh3KMUnoRZCx2HGSFfrug9AOYJsSDNdB
	7+pJtZ8Q38GQriwcwW1aRQIlVWFu/Is=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cf+rn6jm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B7fPsCqp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Cf+rn6jm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B7fPsCqp;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767692044; a=rsa-sha256;
	cv=none;
	b=EtVknf3X+l6Kg62bDeaBUWysv0Cg+D5qb7pb1t+F+rQuz++bOuRuCueTkprEAfMqV2N+K3
	z5YZgXL6gx9UFx+tdWaXYnEQTxzwlvv3+7qsVwbSKW8rt5UNFqqNzCWQkJkVIn+yOEW1Fp
	LVvKK7vvCBjKPNs6Qj7khfpMgpnVBzE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A71EA339D0;
	Tue,  6 Jan 2026 09:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767692041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD+gb9iTwtAOL0+AaRfPVu6+0szSFg5PvynsVOPibio=;
	b=Cf+rn6jmcX1v54zQheY+lMcF2mDy52EZG8pxdJNAgv3Sty7rG6uOyfZH87D7kwM/k3uYed
	PMKnfzXhO2fEVVujHEr51L9H7fIKgAkdaTCkRh3aLvQgM/rw2xFJOGnEUkMvyJYcpj+eY5
	8ntv+S3ziU8MrsupBMynI7igz1+oH+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767692041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD+gb9iTwtAOL0+AaRfPVu6+0szSFg5PvynsVOPibio=;
	b=B7fPsCqpcP3/aj1MkEzq4rt0LvLey0WxaVyG6EXbTwzmpxh2CVUnDs6k001S1FozzVWju0
	9AMdTMS4ZsmCmUAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767692041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD+gb9iTwtAOL0+AaRfPVu6+0szSFg5PvynsVOPibio=;
	b=Cf+rn6jmcX1v54zQheY+lMcF2mDy52EZG8pxdJNAgv3Sty7rG6uOyfZH87D7kwM/k3uYed
	PMKnfzXhO2fEVVujHEr51L9H7fIKgAkdaTCkRh3aLvQgM/rw2xFJOGnEUkMvyJYcpj+eY5
	8ntv+S3ziU8MrsupBMynI7igz1+oH+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767692041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD+gb9iTwtAOL0+AaRfPVu6+0szSFg5PvynsVOPibio=;
	b=B7fPsCqpcP3/aj1MkEzq4rt0LvLey0WxaVyG6EXbTwzmpxh2CVUnDs6k001S1FozzVWju0
	9AMdTMS4ZsmCmUAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DD613EA63;
	Tue,  6 Jan 2026 09:34:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YxCHJgnXXGkxbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 06 Jan 2026 09:34:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5EE5FA08E3; Tue,  6 Jan 2026 10:33:46 +0100 (CET)
Date: Tue, 6 Jan 2026 10:33:46 +0100
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, miklos@szeredi.hu, 
	linux-mm@kvack.org, athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, 
	carnil@debian.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
Message-ID: <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251215030043.1431306-2-joannelkoong@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Stat-Signature: 6nzskoqahsrcucm89mfk4ihodh65md6e
X-Rspam-User: 
X-Rspamd-Queue-Id: C26FD20003
X-HE-Tag: 1767692043-226841
X-HE-Meta: U2FsdGVkX1/h87O1dO0eHAfZIV4F2cAf3lmtO1dxL0eAYsiQlg18G2dvZz3HPNkbuQlvK2BtXaNYpHOLLCOkKMfa4WiakJfsNbS4A61G49YNUcFzoqUi0H90sfCb+x8ezA34ldpWX/tYr1mcauqFq4O1zJS6uT6JPWH29ZyMlcmW2BSkszqJ6fy4izN58Bf34JNHFUm6FgWIepfjga0A1Cy0BRtkz8Sl44ghUFOUTpr/lq7GC6ti1i/X2CHFdRlRFo41CJ7OyI8UqQoHGPTz56MVtlrLq3w4ktLrmOC//OgTrvBV/wKDjxmIBMsF55ddBqvylr6LFShSsyfx9lqZxuqMExiEk+rxHeLuZ4ipVWkDDC8p1ElRvKPHPPdM7TAepafTHQbC8wBd55I/M1gqPVIkE8qchZK7lwpmbzmcOHoJwxtO78Al1oLChx0PyRUtZybv96WlnA5a+FwLTVf9creceMh3MQSSLlWOiSHNMLLbn8XjhoFcYQH+8fdSKpmXtd4ahGQ0xtvk5QJNYafuwxy/jTSdaF7AxfsDr9rd1vJlEmJPluF+DSko2ZBofm9UvHlgDEI33/1Tydj4mphj0/a5mtAMDA9jAcf/pQaNBu7kolAPXRT+7VQefGaYxAMjv4vLlufrHelMYZBfluYheJt7NY2QHIIoOzDLR6++/CRU7LQ7wnUiTqmEq0TwLQksBs1CQcN2EPuJpPZsXbfCmRnnTJoVBojdNC4SmFR2hoQsrc47ztKeLcc5eUeRHaDMtJqL2/WObXgZlJGb2t7aHEllITFB3vjfoXrb9kD5y2yPQWsAbgeNb6mGpzLQxcyZZXrvejxQ9WWdmYwkMxqN75lMjUJ3btEurAUZfOG4kSOVzyLBl772k2jFH4KSPjp4cnpkTamvPyL0b1sNBqrdYEU6IufSxjAHJj9WzzT559QqCuOPcVHpxm1oGs67v7c6wAh5BYBmwVdgiRfvh/k
 rm2IF8nn
 bZXzoLgczTbjpMW8NAyMefu+EZDnk3wI8M/BlOxe3KIRKXPCwnXVXnQBka3yaZ0F0y96nUrbtW0H9V5xJJZIwfa2NWNfrJj0nB3IAMXGh3wXVRubQCEQS3Dqsz7owCvq7dI7IZxKcus59J8BXg33hT3jJGN6HjfBs+iGZZPviCAVE6XS7uUH9nK7XbOVB06/A+z1u2OQzNidDfK5i94xR4tnbBIT9FtFR/JKMjklMxKg73NAvezxv+NhqrD5e9Vbst7xxgBBTryGTUxZduhyXbiwz9Gf1c+i/h/fuu52zHUnHnQjjyX6mRSlfWw2oR/8ekWs7cEWusNEhvFxOGOA9IGM1fxqWK4XIvBmzpeOQ/V3p08EAYjSdT4/zjvVfr6c8F9MIlVT1mOFPQ0EdbMWQMjrS6xr+DJRj1kiTHlqhv03f21RLSwrnyfXA0W7C97SmCLnx/BMVUEeeSlOVh7hoffWXrsNAX3X4kYD/raD4aGSq4q+PPCs938MBqSWboSAWrC4UfwLBnzWhuQjcVwdqi45k0UTOzoeFXykoD58yUnTS+fSTbW5YToxKJNWCP40IJ294
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Thanks to Andrew for CCing me on patch commit]

On Sun 14-12-25 19:00:43, Joanne Koong wrote:
> Skip waiting on writeback for inodes that belong to mappings that do not
> have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
> mapping flag).
> 
> This restores fuse back to prior behavior where syncs are no-ops. This
> is needed because otherwise, if a system is running a faulty fuse
> server that does not reply to issued write requests, this will cause
> wait_sb_inodes() to wait forever.
> 
> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

OK, but the difference 0c58a97f919c introduced goes much further than just
wait_sb_inodes(). Before 0c58a97f919c also filemap_fdatawait() (and all the
other variants waiting for folio_writeback() to clear) returned immediately
because folio writeback was done as soon as we've copied the content into
the temporary page. Now they will block waiting for the server to finish
the IO. So e.g. fsync() will block waiting for the server in
file_write_and_wait_range() now, instead of blocking in fuse_fsync_common()
-> fuse_simple_request(). Similarly e.g. truncate(2) will now block waiting
for the server so that folio_writeback can be cleared.

So I understand your patch fixes the regression with suspend blocking but I
don't have a high confidence we are not just starting a whack-a-mole game
catching all the places that previously hiddenly depended on
folio_writeback getting cleared without any involvement of untrusted fuse
server and now this changed. So do we have some higher-level idea what is /
is not guaranteed with stuck fuse server?

								Honza

> ---
>  fs/fs-writeback.c       |  3 ++-
>  fs/fuse/file.c          |  4 +++-
>  include/linux/pagemap.h | 11 +++++++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 6800886c4d10..ab2e279ed3c2 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_block *sb)
>  		 * do not have the mapping lock. Skip it here, wb completion
>  		 * will remove it.
>  		 */
> -		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> +		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> +		    mapping_no_data_integrity(mapping))
>  			continue;
>  
>  		spin_unlock_irq(&sb->s_inode_wblist_lock);
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 01bc894e9c2b..3b2a171e652f 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -3200,8 +3200,10 @@ void fuse_init_file_inode(struct inode *inode, unsigned int flags)
>  
>  	inode->i_fop = &fuse_file_operations;
>  	inode->i_data.a_ops = &fuse_file_aops;
> -	if (fc->writeback_cache)
> +	if (fc->writeback_cache) {
>  		mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_data);
> +		mapping_set_no_data_integrity(&inode->i_data);
> +	}
>  
>  	INIT_LIST_HEAD(&fi->write_files);
>  	INIT_LIST_HEAD(&fi->queued_writes);
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 31a848485ad9..ec442af3f886 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -210,6 +210,7 @@ enum mapping_flags {
>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>  	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>  				   account usage to user cgroups */
> +	AS_NO_DATA_INTEGRITY = 11, /* no data integrity guarantees */
>  	/* Bits 16-25 are used for FOLIO_ORDER */
>  	AS_FOLIO_ORDER_BITS = 5,
>  	AS_FOLIO_ORDER_MIN = 16,
> @@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
>  	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>  
> +static inline void mapping_set_no_data_integrity(struct address_space *mapping)
> +{
> +	set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_data_integrity(const struct address_space *mapping)
> +{
> +	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> +}
> +
>  static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
>  {
>  	return mapping->gfp_mask;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

