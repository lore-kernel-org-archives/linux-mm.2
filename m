Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E94A109C059
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B516B0089; Wed, 25 Mar 2026 15:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952016B008A; Wed, 25 Mar 2026 15:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861FC6B008C; Wed, 25 Mar 2026 15:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 77B366B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:00:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02E2F1A0AD1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:00:54 +0000 (UTC)
X-FDA: 84585502470.12.25EC023
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 65758120002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:00:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnsR0lbn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XjWOqJW1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnsR0lbn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XjWOqJW1;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=CfceUMxgPWUzquP+4gmlt+2Wn0WRKTga6yjjlUVPLCKzUlu6rM+FLvv7V1ACZOPboJyM3l
	0DyTKcKudtpoWGSmZkPaOe7zpfnJh8cc+KFAB+Wl8xxJDnqVc9tTCL7itfN98qzU4GkFxQ
	ZONOmudH/IIJzOYZJINmE1Co5jqsOvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465252; a=rsa-sha256;
	cv=none;
	b=KV3eMtwk6e5lS4mCoa0EnYqokUzwF1HzUJwn6/3R6HRHYe4VzFvLvye6qa9+8dFc5Qkfhr
	Xu2T5/6LHI1Pa77p4sD+d/3WvrZ1KgI0nq4AB2ZbsVmFd7u2tEGEX2By/NGmyU2KcuXv0q
	CNbLSZwlixttThlP/it6uy+wqV6+1Sc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnsR0lbn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XjWOqJW1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnsR0lbn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XjWOqJW1;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE1574D25B;
	Wed, 25 Mar 2026 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774465250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=pnsR0lbnogWDDvWWHJaZzoB1nD/ry2v6mA2qDgaMq74hwNvkm1mpDtNRhLpjQ4tTDhynep
	lLNzOKpBD3cmQnFSNdgQ7yOODIma8pCS4vTPTbM0gRPUqGDyZ1poXXLvZ6zCLuK9bKi19Q
	Ze8Ia03faCzlwGzPLOKircNffb2KZmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774465250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=XjWOqJW1HANyX+2k8BQ1Z3LcemmfpqeilUlFb8XOnE1EzFWnDH6LBfGw5o1ex7vO6WVEHQ
	xAHkyQK+4qrTggCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774465250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=pnsR0lbnogWDDvWWHJaZzoB1nD/ry2v6mA2qDgaMq74hwNvkm1mpDtNRhLpjQ4tTDhynep
	lLNzOKpBD3cmQnFSNdgQ7yOODIma8pCS4vTPTbM0gRPUqGDyZ1poXXLvZ6zCLuK9bKi19Q
	Ze8Ia03faCzlwGzPLOKircNffb2KZmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774465250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=XjWOqJW1HANyX+2k8BQ1Z3LcemmfpqeilUlFb8XOnE1EzFWnDH6LBfGw5o1ex7vO6WVEHQ
	xAHkyQK+4qrTggCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B02BC44558;
	Wed, 25 Mar 2026 19:00:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +7L2KuIwxGkBYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Mar 2026 19:00:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6F330A085A; Wed, 25 Mar 2026 20:00:42 +0100 (CET)
Date: Wed, 25 Mar 2026 20:00:42 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/41] fs: Provide functions for handling
 mapping_metadata_bhs directly
Message-ID: <f7e57f3wfmzkh7wcsq662q5igqnxza4ryfk4uzm5kba5f5stfg@be4tpgtp5nga>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-72-jack@suse.cz>
 <acImXDl7MTsmVK_U@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acImXDl7MTsmVK_U@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: zgpnkg69f7gsawro8wpnukb3mm3ep9gm
X-Rspamd-Queue-Id: 65758120002
X-Rspam-User: 
X-HE-Tag: 1774465252-411002
X-HE-Meta: U2FsdGVkX18qYFSHLzRye0NTHx3Bf2zoQQPu605TnBDajQojIALskldZcS8XJ7+tH6cmVD3XK4uFDnj8aWQkmIAh3abLexKttS1R/1pykpQ7Sp7obEIUfMR0GhiDw9V+XT8mdFiF8l5rOOinvKKkii5ibRDaQslDo13iBACjfssX0+6NfPUSc+DNLMYZ/hkeG+SWgQt7Ou6chn1pZADIbQfAwPEyleYOUl12F+5wnMOby3uwBmyJowKUUAoBdcubAw2xkyzickAU3+oBoCNb2vAtU4c6W0k201fdaA/nUnVgGukKqj7GHszAGLa8SdbSeZanYSnjm3TW8BTACM5wCcyAhzDgjmCArQAPkDwiI9q+xXADSdApZ0DFvmu0S5Ys5barbxlZCRJbtfxnXy1y9nVBfU8XB6R+bSAHX1N2uVvFDrmlIaJ5toS9ojYV+rSdu5yvtzB2d0kju2PZik27jZku6gmCGA0ctBGDJ74MfjgBeMrdEc7Zp2KaIl8+GIuUO/hwcySkx8I8p0riIx7h/CS5YUhNY/cB7aZq71LUcUbmsHiyGoUJSXfOzMXrGP+Q2P9AXxCpT3ikqWcIZ/sR00SyULi4/NrBoKTI+OgF2pBwQQCwWqOFiXjBhbHbkq1A9D5+jhMn2gTloip7viHRw17HOdE6o3qtk8u6D5AXzE0fKC8vSxgrsiX/fpr0usxGx2Y7pcvu/8NmE8liKl26cCkNUZnE4Wlk3V1YnCyJQvgnrsLuM+OVKvLtIdkLFczFIpQQyUVz9CDp8oJshd9HJH3dmMchP5/pp0IHh8nsFDx/7za5E2VH5yCx3kfD9RHfvgbYTbXH8+6D0W+qD9JsJgiTfILp8hpa+n1z8ZdeFbh5wvFrytD6D15sjSxug3nqouFjxgPTadRi/kazIrnawbQu1fD5fOzSlAzyW0nkT9dL7fficP/Mtjhf77Dbx7Sl5RaOyATqc43BGgJ+SSk
 oRiT6wKr
 vgvWhqe3AFOtRv/dlsscgctjJmLFf5yBJq0uk0vtsetj6YBu6AN5Ke1Qji9Yew4zgEw0GN0S3e/lYS3Q3YiYMbq93wS5j99g4QDCaKGFHWQgY4/CeJIO6olDzBuCSvQHag9cfTJ+Y8JDoZ/yY0EivAMmWXrStLo/hWJ6FQr+4T9vbubdW8wugydkpE5ybC4vpWpd//niyzxpQeqeS+Rbs2+S5x3NQ7xJPFw2IJXPIxujOhKBbf0AGIRtgGL3y/KSGZo+66gYsI2gJz/Amq9aAcyautd1v5JfaONotwfC40z1TW8zww/TKZ7s+OuePSDKDOYOMIny4pKoEiS4vaDmD/luUcqIRPOkrmyNurDGY30VPAiFmEdPHWE0pvREweO9sddIomz3l/Jsgcs94otF/OxYrMRxd+zYgmXSTbafboePFtGqWTKQoHgtXcuXMzm0Igi/VDG7Jli/rwm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 23-03-26 22:51:24, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:26PM +0100, Jan Kara wrote:
> > As part of transition toward moving mapping_metadata_bhs to fs-private
> > part of the inode, provide functions for operations on this list
> > directly instead of going through the inode / mapping.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
...
> > @@ -553,9 +547,8 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
> >   * buffer stays on our list until IO completes (at which point it can be
> >   * reaped).
> >   */
> > -int sync_mapping_buffers(struct address_space *mapping)
> > +int mmb_sync_buffers(struct mapping_metadata_bhs *mmb)
> 
> mmb and buffers in the same name feels a bit redundant.
> 
> mmc_sync_all?  mapping_sync_buffers?

I've called this just mmb_sync() and I've also shortened
mmb_invalidate_buffers() to mmb_invalidate().

> 
> > +int generic_mmb_fsync_noflush(struct file *file,
> > +			      struct mapping_metadata_bhs *mmb,
> > +			      loff_t start, loff_t end, bool datasync)
> 
> mmb_fsync?  mapping_buffers_fsync?

This I've called mmb_fsync().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

