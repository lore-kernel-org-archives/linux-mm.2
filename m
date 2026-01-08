Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12365D1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABF86B0089; Thu,  8 Jan 2026 12:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B9E6B00BC; Thu,  8 Jan 2026 12:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664586B00C2; Thu,  8 Jan 2026 12:29:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53E446B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:29:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21273139656
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:29:16 +0000 (UTC)
X-FDA: 84309482712.16.5CFAB42
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9689A0011
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:29:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q98OikX8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jLiiYj1N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q98OikX8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jLiiYj1N;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767893354; a=rsa-sha256;
	cv=none;
	b=Dlio7hElzSe5m9adryz3pK2idzM2CHP6NPtIznv09CekuOKdmg+ld0BxE6z4fMs+qxHvDo
	PLoTCUZrona8d5SWreTXA2LHGnFd04/TZkTuLrdmYpMshzmL4SOyu2ub70iW4y8ZEGyM0u
	NaGjsKRnTPAhotRfES7jsK+q8cxEsv0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q98OikX8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jLiiYj1N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=q98OikX8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jLiiYj1N;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767893354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=T5ceLH/Vuf/dQJI69T+eZMgTz+7tI3zRjwV3hqHFwWZ9R+zGY/GsHeVPIhTGtXFny74YQR
	8aWSIa6FXYm+1oGcLEZoV8bbse9w32pJmd/+3r0bsu9+DyXWlnD7GuXSTKJI9Z0KLEcyze
	HBKxiRw5JGEIIzTRmbHL36xE9EUmrOQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 58B935CB90;
	Thu,  8 Jan 2026 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=q98OikX8Rlp+tPfB2ZHxVR36nEhJ+HZD3bnqMRpYfLGtKGtaEncX/JNBcjEjloWK4bXk1i
	cIWDAvSVP/sBQXMd6MLI6eFHRSDl9mCxqH52YzdYtVgcoOrPlWPoiERTin9dhH0ik9+24V
	rDIl9wrHXO7t0NpcA3X/w+2/NXnTdMc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=jLiiYj1NB/KC2FKXGW0Rp8Gdggj+tWABL2abRsfkiJij0e8jQKly3ieKviRIh0zE1u83aY
	WzA2A1lxr6mI77CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=q98OikX8Rlp+tPfB2ZHxVR36nEhJ+HZD3bnqMRpYfLGtKGtaEncX/JNBcjEjloWK4bXk1i
	cIWDAvSVP/sBQXMd6MLI6eFHRSDl9mCxqH52YzdYtVgcoOrPlWPoiERTin9dhH0ik9+24V
	rDIl9wrHXO7t0NpcA3X/w+2/NXnTdMc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=jLiiYj1NB/KC2FKXGW0Rp8Gdggj+tWABL2abRsfkiJij0e8jQKly3ieKviRIh0zE1u83aY
	WzA2A1lxr6mI77CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 446973EA63;
	Thu,  8 Jan 2026 17:29:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OEmrEGjpX2kZeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:29:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 008D9A0B23; Thu,  8 Jan 2026 18:29:11 +0100 (CET)
Date: Thu, 8 Jan 2026 18:29:11 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev, 
	linux-doc@vger.kernel.org, v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH 15/24] ocfs2: add setlease file operation
Message-ID: <ou554m23k22d2mswmhwxyhrhfnrhz6socc2jx7p2ef3w7zb56f@noumdopgdg5f>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-15-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-15-ea4dec9b67fa@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D9689A0011
X-Stat-Signature: kuj3f4w3g48ai4xbce49q5d8iikhjjrj
X-Rspam-User: 
X-HE-Tag: 1767893353-332291
X-HE-Meta: U2FsdGVkX183XV4LvSLiW5p/1PqXaYn11UF8pnakhfwaWneH5nAJc/EcP2V/zeQZJZNFLzaBaq8jh7NeZLsnzBysgxy0stJ0gpUgjZ7jnsh4PxjbN7YokBQW51AAxHcfjlLa2nIJ4A2tMqNm1DZ8FFoRKhZ6ISCxMu6HFhTdgicStFobD7WPzN5sXNpxmJL6Es2pBR4ydF4cpubzCNiGaFI96p91fsGRYYrCbUga8oQ3A/yWDaCtp1YYNcoWp/6OPpkB/F+OIQEpke0gc8TjCjs3jBM5j2eEkWj2y0a2CMNEIQ2N9YdT5GG01aOZETKVvpOg2rns2bYkuZMCf4GyQnfScuaCW9rZdA+V2E5gHDbErmZSmsjFzH8k7Yw2v2sBrUZ6BUWW4n8V8L3XwE2EAq+X+niap3dFFw5PkEzo8vLUpm9KbVSz8+gHRR1FNShNKc5CduD17mi4HkyazIniJl73iVArgHhrjqcOl1FKyLmtZdgmkaWRsJl23g3mc3Y2z4TAEVGIMhiHeESsmO2MLUIqSWs1ge4l4O8t1dZZaEPlb3x/MbTGQ7Mel9mTeaYGPWi8ooBSwjFi4M0/C7jt0FwsJ5gJSaX8fzOyOzcGx3NiqsfwliXKZZFkGeXfaihnfrdOIm8kPeK9i8ctK80tXWHWSuhzw4okI86N7+mewnHX9lGaCitNaeczt3OBSr19PbgpIWBQ1pwfip1SE7S5c4CHZKeEbUZauuop6kAXs3FqIOvz9Z5BnDQk3jAQUZADXv1+OMvdZdWDBSotWlo/MT5yxn16Ib96QIlGJZlJr9cu8069HUw9oZ1m6bJIQPvlfJwotzhzFb3V/naZgWfhxqNTvNcFr4BgTIztLo/fw2xKemvEMT8OaDaDq18eRYTlbpkM4tVzhNsgCeAXqcSV5qw3xq967MTgoE2X4RfvLNGWcOuz6byCEA3TW0GKevFJZqcYTo3iU1hgJbJdQP0
 +oiH0atS
 0BFC7icfz2tpoCQIpCVeoU1HvZnUDfSuwmF1yLDqFuCAuVAm+2M5kAR9uijXLwlrTc+gkuYGwhRZgWvIGeDV0DaRq7C0IVqVXf3PCYpeMjKZHSlmd7riatDZIxKUMmbpAfNBVOiE32cUofDmmKB6tPsN7IMOUt/X9E/3cRfDfPmhJPAq7VVoA+GLIhSwUzVtevw3DA9H3zYNNPGLHd6dTa2l5VvfkaMWchDF2yAa/6UI6K0LHwklr0zCCzeGqRfgDPDcC3HmJ+jQw/1bxdYqX0jKgYKgohUh4+hsdaKg0tmkvJPOysgRy6qXTupnSoV3CY4ia6bFJ2E7iH1Qk6XFsHRaSJXxrq47nIaM76rqLEWnW7i35n834ie2CY3nWdmpthHiqGTvEG62iHW195UgDu3kxoLV3bPjGYBYuLb9wrDBJ0d+tH2v3dVuU8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 12:13:10, Jeff Layton wrote:
> Add the setlease file_operation to ocfs2_fops, ocfs2_dops,
> ocfs2_fops_no_plocks, and ocfs2_dops_no_plocks, pointing to
> generic_setlease.  A future patch will change the default behavior to
> reject lease attempts with -EINVAL when there is no setlease file
> operation defined. Add generic_setlease to retain the ability to set
> leases on this filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 732c61599159ccb1f8fbcbb44e848f78678221d9..ed961a854983d5e7abe935e160e3029c48e6fca4 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -19,6 +19,7 @@
>  #include <linux/mount.h>
>  #include <linux/writeback.h>
>  #include <linux/falloc.h>
> +#include <linux/filelock.h>
>  #include <linux/quotaops.h>
>  #include <linux/blkdev.h>
>  #include <linux/backing-dev.h>
> @@ -2823,6 +2824,7 @@ const struct file_operations ocfs2_fops = {
>  	.fallocate	= ocfs2_fallocate,
>  	.remap_file_range = ocfs2_remap_file_range,
>  	.fop_flags	= FOP_ASYNC_LOCK,
> +	.setlease	= generic_setlease,
>  };
>  
>  WRAP_DIR_ITER(ocfs2_readdir) // FIXME!
> @@ -2840,6 +2842,7 @@ const struct file_operations ocfs2_dops = {
>  	.lock		= ocfs2_lock,
>  	.flock		= ocfs2_flock,
>  	.fop_flags	= FOP_ASYNC_LOCK,
> +	.setlease	= generic_setlease,
>  };
>  
>  /*
> @@ -2871,6 +2874,7 @@ const struct file_operations ocfs2_fops_no_plocks = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= ocfs2_fallocate,
>  	.remap_file_range = ocfs2_remap_file_range,
> +	.setlease	= generic_setlease,
>  };
>  
>  const struct file_operations ocfs2_dops_no_plocks = {
> @@ -2885,4 +2889,5 @@ const struct file_operations ocfs2_dops_no_plocks = {
>  	.compat_ioctl   = ocfs2_compat_ioctl,
>  #endif
>  	.flock		= ocfs2_flock,
> +	.setlease	= generic_setlease,
>  };
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

