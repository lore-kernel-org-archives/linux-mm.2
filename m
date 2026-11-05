Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40619606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=n50o8Nho;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vEObjVwj;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2cOYoXtK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xNpdsHrD
Received: by kanga.kvack.org (Postfix)
	id 4CF7E6B05B0; Thu,  5 Nov 2026 04:22:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458F36B05B1; Thu,  5 Nov 2026 04:22:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FAC6B05B2; Thu,  5 Nov 2026 04:22:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01F6D6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:22:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8AA634099F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:12 +0000 (UTC)
X-FDA: 85400524104.24.C15CFF6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F396100008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:22:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n50o8Nho;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vEObjVwj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2cOYoXtK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xNpdsHrD;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793870530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=xuYmDKlBxoffGC6MW6oJVgJrN7Xw4Dlqo5jp1SyZ+LKpBATDNs0pUdfj6cHM3tigbF7yii
	6wqXRRlk9F5QRu2HTPeZXeG1qMecjID3tLhWmfpQReSqpU+J2qo+rTX6s5LrWhacut3Q8D
	mhOARvMuMU1H/dF7O0AKKTGjytyBMHQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n50o8Nho;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vEObjVwj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2cOYoXtK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xNpdsHrD;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793870530;
	b=Xf/msFeqPh+EBL7/zk5sGHl9EfEb9LEiF2i0d4q1uJnfoJqYNE0P7soy5ei7uBMKszeX/R
	gjRKaOWKZUfg4W4PrKhyVKSPdLKKXrr4jxbDjtvMJJRH3RitXRMfcIecIN7QX6w1xbt7vF
	tsoMs2D0HdQvmD2sum63XiuP7FODmQc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1BB621E6B;
	Thu,  5 Nov 2026 09:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793870529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=n50o8NhoUcr4RCi/B4rIsia/X2BPL0xvAZqFp6JcVaXbZfzT/RTxiBntW4h00kVQGa6Adw
	BoZgFvLF8XedTFomzkc3T1PyMdrQx7jS1R9+mgt1K6CyVCzEcEHQMaqYV1coIn8BosvIE6
	1mdP0qlalo/s/vwRKzpCaU5hyRKm15E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793870529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=vEObjVwj9IoYCWGtblG300EgQss9NlqG2oQadAEYX85TWpmXLFO3Kp4hDBJ5PF1rLfqJsZ
	UQBKm7Amz6f/XsBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793870528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=2cOYoXtKQsnGxKetXHmlYmsgdtzx4dKmzc4TKkHro1fVmuXVkT6aeMOQnia12G6yDV2PP8
	3d1d5nW7OM8023OYjhcxzn4r5MBadUUW/5fKMphJggjyFhvt6zOxv0YmYZBEEwDfWpx6eG
	o2RmagT5J5MIADePkoerRdmpGGEJ0aw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793870528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ORTIcajMvJ+OWgJyNOSohDPENY0WS7vKpG0J7UU3y4=;
	b=xNpdsHrD+svQDtDWU8bkw0RsFYdBqvO0lz4aSu1a0Q9BoRVeC++GKGYW8dvo9pxsLw8pv9
	oK8gPfGxFQDXWCDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C188F134F4;
	Thu,  5 Nov 2026 09:22:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0RUpJ79K7GoMZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 09:22:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 52E39B65F; Thu, 05 Nov 2026 10:22:07 +0100 (CET)
Date: Thu, 5 Nov 2026 10:22:07 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH v2 04/34] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-4-2f44f64f0b66@kernel.org>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4F396100008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c8b36468jhm649eiafqbqrszy87dbj6c
X-HE-Tag: 1793870530-228844
X-HE-Meta: U2FsdGVkX18VIzXJfZ4eB0rcQBiNLnZ1XeW0VBKVMYIozeFOQaIGlLTM4P7Od/WIwBomrH+FhqSb/cpDaSxpRLWRtT2EDp2zzz01bLbMB5qxlo8OAzssNupKmqc9za0QqVQBSz95JfM8HiqpODRTB19MNHp0Vi7Ziqkk91PmKfzePEPsCffKaKFtwhZpw2flcrhGqsviGqFEbf+7TUCdkb+3WarXnrwOtLZpfwDEbDid6vvs1TK/HgxDwV09hXxMbBADUjLc/uE3dgpZRQGnjuX3Hzygg2CPpr+9bAEncVwsNcWYVLim5uq08qGkg/F1+WwI4YlOxWgwuPbTyBSS2R2NSfL4x8uIyDZKcxu1IPZfFnMBV1j4ZBOVY0MGKuRTlOt9QXnDSdS2Tu/dVhFA9HoZfqgOGppTA7/inXly0QyLR/Yelcf2Jol0SS0d8uAr+FAgLDEaPdJjjsUvEFyrzovoEoWB9uq7Jj7ghRbKxhdDTVP8J+xUbiH8NWisZp/6hbjPYDhO+TiLd4N719wwc7klPmewLewDeKNCutosy4nw5UPsoawqlpe9P3SFJUwr7mhDcQeHHSZZDBivk1mx7vsVsnZjBXoEh/OFMAMEV1kHnS3SxIGb62scXB3Vlpn4+G6/t98nxnp1OWKjUheo7hwjN22V2IG6nICbnmC/z7jvBp/oMIooaZfkKMLrjFzpliwYfl2wBT2r10UaEhlrEKuBQTDAx88NqkpAG5B8lUJM+8IBJ70nMVh8SMU0FjVCsw32yf9d69wgnXFYSmqTd7Sw5rd93DIQvv8E+cuqURc6f6NauqlXjVz58M8ztIaA/10EM2LTWPwHaIB70JyRHTeWN+wUjdSV3w8OzFG6kQguNuKQ/cJmq2d5RWgCa46RWmJcAb/99iOL3XmCxflOXxvEJTr/T3EQ+zt50iWDhaMT4M8Pj5JNw8NVR7nuOerm9LdoLiSMjHy1f41yBZ0
 LJe5X/32
 r34T+PZRYCPK9irg78IMHHUsVpz7rv05KnUAzKaBLeNQYrDfgoB9/YVn1W9+Kwp1tB3aQImkhQ4hlq2r9z1itcg/vDTix6BTXCyoAvdCsciUdNcRCZ28hQp0fDoStJHVBjiOTwIh85OXk9dXXgtoIq8vV4EPF8Cng+lxv1LXb/z3n+1qCkrgKWji930vqhdh2KzPkm4IpBl/6DcFUjp9RyxwxxU9o0qEb4Iy4RtbWYz3wrGHcD5PnP8gEBULC3zLGHymmc/SsMBXO6fQL/GXu2FYAnFiDXXGiayKKEPA95DPN0j91c6BKDUDJ3787/6HPW+Svo15aGVn+L0iHuLyxhp3OXTmbOpvwFgV3jNkhqC62LtaU5zSa/1jABM+QlXbkYMtySOgqWkgeffF/J5Yqq7lUWpDvMYH3OJp6U+brMb/7s2gz4FBGWFqaNSKyZLCoax/mMj+mwYh8RjSMn3j27N4ifGGIMvXFrq5G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 29-10-26 17:06:55, Christian Brauner wrote:
> With errors=remount-ro ext2_error() sets SB_RDONLY from whatever context
> hit the error and without holding s_umount. That races with everyone
> else changing sb->s_flags and it breaks freezing. If it happens while
> the filesystem is frozen thaw_super() sees a read-only superblock and
> leaves the s_writers rwsems locked so every writer hangs. A lookup in a
> corrupted directory is enough. Karl proposed teaching thaw_super() about
> it but Jan preferred fixing the filesystems (cf. [1]) like ext4 and f2fs
> already did.
> 
> So call sb_set_emergency_ro() instead and let the VFS refuse
> modifications. ext2 still refuses allocations, ext2_write_inode(),
> ext2_sync_fs() and ext2_xattr_set() itself. The superblock isn't written
> after the error is recorded and unlinked inodes are left to e2fsck.
> ext2_handle_dirsync() treats EROFS as success in that state because the
> entry was already changed.
> 
> A remount to read-write fails until umount and writes through file
> descriptors opened before the error fail with EROFS.
> 
> [1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf
> 
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Nothing critical but couple of points for discussion:

> @@ -1287,6 +1287,10 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
>  	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
>  
> +	/* Nothing may be written after an error made us read-only. */
> +	if (sb_emergency_ro(sb))
> +		return 0;
> +

So shouldn't we just modify the sb_rdonly() check in sync_filesystem() to
use also sb_emergency_ro() and don't bother with modifying individual
filesystems?

> @@ -1307,6 +1311,9 @@ static int ext2_freeze(struct super_block *sb)
>  {
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
>  
> +	if (sb_emergency_ro(sb))
> +		return 0;
> +

Also if we have the check in sync_filesystem(), then freeze_super() is
generally going to fail so this check could trigger only if
sb_emergency_ro() was set after sync_filesystem() ran and before we called
->freeze_fs(). Since sb_emergency_ro() checking is pretty much guaranteed
to be racy (it is just a best effort framework to limit damage), we
probably don't have to bother with checking in ->freeze_fs() handlers.

> @@ -1349,7 +1356,9 @@ static int ext2_reconfigure(struct fs_context *fc)
>  	int flags = fc->sb_flags;
>  	int err;
>  
> -	sync_filesystem(sb);
> +	/* Nothing may be written after an error made us read-only. */
> +	if (!sb_emergency_ro(sb))
> +		sync_filesystem(sb);

If there's a check in sync_filesystem(), this change can go away.

> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 8f608930a48c..12dfffff189c 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -429,6 +429,8 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
>  	ea_idebug(inode, "name=%d.%s, value=%p, value_len=%ld",
>  		  name_index, name, value, (long)value_len);
>  
> +	if (sb_emergency_ro(sb))
> +		return -EROFS;

Is this really needed? All the xattr operations go through mnt_want_write()
/ mnt_want_write_file() so this should be caught in VFS...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

