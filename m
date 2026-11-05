Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE97606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pPiicJho;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9Kqcw+qz;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=efNmRDr2;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m2k33eDQ
Received: by kanga.kvack.org (Postfix)
	id 3DF856B05B1; Thu,  5 Nov 2026 04:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38FF06B05B3; Thu,  5 Nov 2026 04:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230DA6B05C3; Thu,  5 Nov 2026 04:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAA196B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:00:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8045740990
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:00:23 +0000 (UTC)
X-FDA: 85400469126.12.1F93E63
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id D9BEE4000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:00:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pPiicJho;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9Kqcw+qz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=efNmRDr2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m2k33eDQ;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793869221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIsagIKotcPgPj6dzTPe6YgVAgK0nZu5IM9XWIw5Z5o=;
	b=UDfFYlrzvM290fLQo9ml5QlCiybsIzHEXVxzeu9Xo/nwCpNjHGSu12S771eZUonq4KH6zq
	zYEWmZDgrBPyPg2Ra0PMv2djKs/cjQ/vVY+qmrAejLEwaGuxY1hTRKwiL/d+KriUgXO0l9
	1/IQieiVCIqQjwPu83FrHH5hVjmB7cg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793869221;
	b=iHebtfGq54v9DegJym3wb/rpsb20R9bw17K9YkpreUy9P0lSWjnruFW9G3YNDYgFPyrYdo
	MYB3tWSsB8Oza4/5o8BCPLcWu9EAQwPklGUjlPJA/fiuytESzJOtS2emWbPnAWDhObRGHa
	9NjmdNicKCNErHapcPQQYaaMPPHxatY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pPiicJho;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9Kqcw+qz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=efNmRDr2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m2k33eDQ;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6172D1F889;
	Thu,  5 Nov 2026 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793869219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QIsagIKotcPgPj6dzTPe6YgVAgK0nZu5IM9XWIw5Z5o=;
	b=pPiicJhojEIwIceWV1f/ftfjkucx2QmhidHDahtVO43XngjZzqJPeo8SmB5k2LLYALu3Cb
	xWPoWVm2peTzVvcyAP6OhhFq0tqUO2uoO7E22qBu4qcaYSL7m1g2tqJnBX5PJIUuSP7uci
	5st6yFptOFFBatulKHfV9puMkvy6Uts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793869219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QIsagIKotcPgPj6dzTPe6YgVAgK0nZu5IM9XWIw5Z5o=;
	b=9Kqcw+qzhIxZTEOO8hUXSyza+IeSiMdfrOPGiTk8nOh/z3L18iDz7MhJQXimJK7ndzQ/CO
	Glb/PLWU81mmHQDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793869218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QIsagIKotcPgPj6dzTPe6YgVAgK0nZu5IM9XWIw5Z5o=;
	b=efNmRDr2Y5RqLFlsxxFA+EZ8pIcMYeeXh8UBTUFj4wQ3+AnyinrCeNyepljKTkeyC2sdED
	XPl+fBK9EiS9sT1c87IkoxxHsXfwSkpPUeO2x4yebHi3neRsv81kHQErx0soEq9jJJ+xUu
	+QP5QG9vpsEmLbHzNXfMqL1sZv6rhos=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793869218;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QIsagIKotcPgPj6dzTPe6YgVAgK0nZu5IM9XWIw5Z5o=;
	b=m2k33eDQI1p5ztp6A1hZUFTrUr/N+spQF5khwC13ihBE3SWkfHC9CPXh6Y4NxxeH6xrb0h
	LT9aSwhCAWwwKiDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37E22133F6;
	Thu,  5 Nov 2026 09:00:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4bo+BaJF7GqfTgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 09:00:18 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B6030B653; Thu, 05 Nov 2026 10:00:02 +0100 (CET)
Date: Thu, 5 Nov 2026 10:00:02 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 03/34] fs: add a generic emergency read-only state
Message-ID: <gm5ays7o5ps2gcokxw6giymwwalixk6dychwlqfgx4brjohfth@cyrrjbycqjnj>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-3-2f44f64f0b66@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-3-2f44f64f0b66@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qn5p1gwfxm4ncaptb35q1hhymnwh1ecy
X-Rspamd-Queue-Id: D9BEE4000B
X-Rspam-User: 
X-HE-Tag: 1793869220-218952
X-HE-Meta: U2FsdGVkX1/hGRj5w8QFgzoEUPxRRDaMAEMAt/hreWUPnuBkhLIgpTWk8txpwi4H47ThVv9pXrFOA9SktuCEiUDD7VlEO4BhS8nbkS3sIsNAg79LeF3TELHPE8Q5UpViFyhQcj8CEglXj+Cc8cqe4xXINWIzkGTrNGyrJtA+ymsvzxaQg1qzn8Ks4ab87spc5doiW320gy7QQdAkLrgfGtWVEIdZz90slnMJnnJy9q26QPFutP3YldZy/e2kdmQGBZlfmOSe20Kkp1r7OIHqc2h6b64EYxN/rWh7CX6tkK3MNoFe0OP65WyQfUKoc2yf1RV/CDXsCM/h0wB75lv898UAi4D9NagjW+zUcoKIAhGaztFU6o7Q71a30V2ICdVVGgR7LOYVQmi92BIrZUNS+rWIY9ZgcSmm0Kiw6oDUEcAzetHTSZ8mCAggdnR2obyx95d3AphrJt21mBDF8kPQherY7TCUDqUhbJTpSnoiIlTB62FvLnAEriEUGPDE7sTvGpf+UPzqdBcruvUpxkS/HPLM657obNfJEaWDjNSmG8ivf+OnKF7L6kWebQ4Vm9EbPBRIT674mgIbEPnJiiDYXo2uSJw+PFh9xQ1qPj8t6MR9JpOQHEGefgzjYHlE3ck1va8Jlonno81WIc4jYW2ZLHABHwYMstoMUrOwQApIK2lhCtDMnp5+2WKajKB7SxsTT4B7KP3w58TqYpHzk5/hzwAfU5gsxgjZdwuzxHjNGzHNOfFXJ323gtVUOOwFFGQcSi7t5TuEOPSp/Gs1ObntS5b7s2aDDOX70msG+hd832kacWos8txiMYX4smLMqbcmKTXFUjdXfrurOKICWWBwMyhgvpqbgyELcKYM/B6GE77DnZn0gL7HiW4X5Sde3L29dJwx1K8c9AweLaNe+JYErephoJyCMpQugc5LIf2IkOiYYpiMnzP2qcABrUIbvnZ+8bHTSXTyaqGOXv0l7pv
 JNF5tDiP
 p1BVRkXYQw7S93J6F+mHip6Yf9FCQRIkOqMsMEkYwccP0ziqDOOD3Dj1CYRd0ULkU4RovteQ6cu8EvpB/uA0c00G1M3rWSDe9/YEoBYFjQhwwHpR+dBUBng4ER4B1KpyzkHWRn2m0qLCOJPIEs2tVtyx96sEohLO7WKvew0G7A/1Ey/3P5V1KeD/Oi8JI9+6xDmi8U3tqHB6q/Sp3eWKAQK0eX0lijyU8XeWZEuUFi3OEI0y9wYk4wux1Ia7ZeCzSmiGE7HFQdgR1mrFbzrPIE1SvQbDTaDd44HB6HcRh99ZhNVgZSm7Sr7mpxtUVSsWbBiBU4VaObUKPJblx8pgqJJC+ZKjodDEWb3T86YcbF5VUzZMNUA4ojMTdV2eS1w0pF6aXDW30V9s0yqB4AmXqFQN78Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 29-10-26 17:06:54, Christian Brauner wrote:
> ext4 and f2fs don't set SB_RDONLY after errors anymore and refuse
> modifications themselves. Doing that in all the other filesystems means
> the same checks in ->open, ->setattr, ->fsync, the directory and quota
> operations and ->reconfigure everywhere. Jan suggested a flag in the
> superblock instead so the VFS can do it once (cf. [1]).
> 
> So add sb->s_state with SB_STATE_EMERGENCY_RO. It's only ever set and
> never cleared and SB_RDONLY stays untouched. A filesystem calls
> sb_set_emergency_ro() where it used to set SB_RDONLY and the VFS refuses
> modifications wherever sb_rdonly() would:
> 
> - __mnt_is_readonly() and sb_permission()
> - notify_change(), rw_verify_area(), remap_verify_area(),
>   vfs_fallocate(), vfs_fsync_range() and do_page_mkwrite() for files
>   opened before the error
> - reconfigure_super() going read-write
> - the dquot code and quotactl(2)

Maybe it would be good to mention here that anything that goes through
mnt_want_write_file() or mnt_get_write_access() is treated by these changes
as well (due to the __mnt_is_readonly() change).

> /proc/mounts, statmount() and statfs() report the superblock as
> read-only. "emergency_ro" isn't shown as a mount option because remount
> helpers pass the shown options back.
> 
> The filesystem still has to refuse what doesn't go through the VFS: its
> allocators, its journal, deleting unlinked inodes and its own writeback.
> ext4 refuses all writeback in that state but jfs has to commit the
> allocations that were under way or evict BUG()s. The VFS can't decide
> that.
> 
> [1]: https://lore.kernel.org/r/my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyocp3yxbnj@aphfqdiej2hs
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/filesystems/porting.rst | 16 ++++++++++++++++
>  fs/attr.c                             |  4 ++++
>  fs/namei.c                            |  3 ++-
>  fs/namespace.c                        |  6 +++++-
>  fs/open.c                             |  4 ++++
>  fs/proc_namespace.c                   |  2 +-
>  fs/quota/dquot.c                      | 23 +++++++++++++++++------
>  fs/quota/quota.c                      | 13 +++++++++++++
>  fs/read_write.c                       |  5 +++++
>  fs/remap_range.c                      |  4 ++++
>  fs/statfs.c                           |  9 +++++++--
>  fs/super.c                            |  4 ++++
>  fs/sync.c                             |  4 ++++
>  include/linux/fs/super.h              | 17 +++++++++++++++++
>  include/linux/fs/super_types.h        | 19 +++++++++++++++++++
>  mm/memory.c                           |  6 ++++++
>  16 files changed, 128 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index c38f5df755bb..fc7161ee64df 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1422,3 +1422,19 @@ helpers take a const struct mnt_idmap *. mnt_idmap() and file_mnt_idmap()
>  return one. The idmapping is immutable so nothing should have modified it
>  anyway. References are taken and dropped via mnt_idmap_get() and
>  mnt_idmap_put() as before, both accept a const pointer.
> +
> +---
> +
> +**recommended**
> +
> +Filesystems that set SB_RDONLY on the superblock after an error
> +(errors=remount-ro) must not do that anymore. SB_RDONLY only changes under
> +sb->s_umount through reconfigure_super() and freeze_super() and thaw_super()
> +rely on that. Call sb_set_emergency_ro() instead. The VFS then refuses
> +modifications with EROFS, refuses a remount to read-write and shows the
> +superblock as read-only. The filesystem still has to refuse what
> +reaches it without passing through the VFS: its own allocation and journal
> +paths, the deletion of unlinked inodes in ->evict_inode() and its own
> +writeback through ->write_inode(), ->writepages() and ->sync_fs(). Test
> +sb_emergency_ro() for that. A remount to read-only must not write anything
> +in that state either, in particular it must not mark the filesystem clean.
> diff --git a/fs/attr.c b/fs/attr.c
> index 9706d370f34a..cb1205f345e7 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -435,6 +435,10 @@ int notify_change(const struct mnt_idmap *idmap, struct dentry *dentry,
>  
>  	WARN_ON_ONCE(!inode_is_locked(inode));
>  
> +	/* An error made the filesystem read-only. */
> +	if (sb_emergency_ro(inode->i_sb))
> +		return -EROFS;
> +
>  	error = may_setattr(idmap, inode, ia_valid);
>  	if (error)
>  		return error;
> diff --git a/fs/namei.c b/fs/namei.c
> index 96c65940391a..8ccb4be06390 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -607,7 +607,8 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
>  		umode_t mode = inode->i_mode;
>  
>  		/* Nobody gets write access to a read-only fs. */
> -		if (sb_rdonly(sb) && (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
> +		if ((sb_rdonly(sb) || sb_emergency_ro(sb)) &&
> +		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
>  			return -EROFS;
>  	}
>  	return 0;
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 9f6ec35c7b9c..512f012645e1 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -396,7 +396,8 @@ static struct mount *alloc_vfsmnt(const char *name)
>   */
>  bool __mnt_is_readonly(const struct vfsmount *mnt)
>  {
> -	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb);
> +	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb) ||
> +	       sb_emergency_ro(mnt->mnt_sb);
>  }
>  EXPORT_SYMBOL_GPL(__mnt_is_readonly);
>  
> @@ -5492,6 +5493,9 @@ static void statmount_sb_basic(struct kstatmount *s)
>  	s->sm.sb_dev_minor = MINOR(sb->s_dev);
>  	s->sm.sb_magic = sb->s_magic;
>  	s->sm.sb_flags = sb->s_flags & (SB_RDONLY|SB_SYNCHRONOUS|SB_DIRSYNC|SB_LAZYTIME);
> +	/* An error made the filesystem read-only, SB_RDONLY stays clear. */
> +	if (sb_emergency_ro(sb))
> +		s->sm.sb_flags |= SB_RDONLY;
>  }
>  
>  static void statmount_mnt_parent(struct kstatmount *s, const struct mount *m)
> diff --git a/fs/open.c b/fs/open.c
> index e43f02ff64ac..ba913e382732 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -324,6 +324,10 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
>  		return -ENODEV;
>  
> +	/* An error made the filesystem read-only. */
> +	if (S_ISREG(inode->i_mode) && sb_emergency_ro(inode->i_sb))
> +		return -EROFS;
> +
>  	/* Check for wraparound */
>  	if (check_add_overflow(offset, len, &sum))
>  		return -EFBIG;
> diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
> index 036356c0a55b..fb81da47bb25 100644
> --- a/fs/proc_namespace.c
> +++ b/fs/proc_namespace.c
> @@ -179,7 +179,7 @@ static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
>  	} else {
>  		mangle(m, r->mnt_devname);
>  	}
> -	seq_puts(m, sb_rdonly(sb) ? " ro" : " rw");
> +	seq_puts(m, sb_rdonly(sb) || sb_emergency_ro(sb) ? " ro" : " rw");
>  	err = show_sb_opts(m, sb);
>  	if (err)
>  		goto out;
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 3ad19d7e472f..f469e6e18e4c 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -495,6 +495,11 @@ int dquot_acquire(struct dquot *dquot)
>  	set_bit(DQ_READ_B, &dquot->dq_flags);
>  	/* Instantiate dquot if needed */
>  	if (!dquot_active(dquot) && !dquot->dq_off) {
> +		/* An error made the filesystem read-only. */
> +		if (sb_emergency_ro(dquot->dq_sb)) {
> +			ret = -EROFS;
> +			goto out_iolock;
> +		}
>  		ret = dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot);
>  		/* Write the info if needed */
>  		if (info_dirty(&dqopt->info[dquot->dq_id.type])) {
> @@ -536,10 +541,12 @@ int dquot_commit(struct dquot *dquot)
>  		goto out_lock;
>  	/* Inactive dquot can be only if there was error during read/init
>  	 * => we have better not writing it */
> -	if (dquot_active(dquot))
> -		ret = dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot);
> -	else
> +	if (!dquot_active(dquot))
>  		ret = -EIO;
> +	else if (sb_emergency_ro(dquot->dq_sb))
> +		ret = -EROFS;
> +	else
> +		ret = dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot);
>  out_lock:
>  	memalloc_nofs_restore(memalloc);
>  	mutex_unlock(&dquot->dq_lock);
> @@ -561,7 +568,8 @@ int dquot_release(struct dquot *dquot)
>  	/* Check whether we are not racing with some other dqget() */
>  	if (dquot_is_busy(dquot))
>  		goto out_dqlock;
> -	if (dqopt->ops[dquot->dq_id.type]->release_dqblk) {
> +	if (dqopt->ops[dquot->dq_id.type]->release_dqblk &&
> +	    !sb_emergency_ro(dquot->dq_sb)) {
>  		ret = dqopt->ops[dquot->dq_id.type]->release_dqblk(dquot);
>  		/* Write the info */
>  		if (info_dirty(&dqopt->info[dquot->dq_id.type])) {
> @@ -2148,6 +2156,9 @@ int dquot_commit_info(struct super_block *sb, int type)
>  {
>  	struct quota_info *dqopt = sb_dqopt(sb);
>  
> +	/* An error made the filesystem read-only. */
> +	if (sb_emergency_ro(sb))
> +		return -EROFS;
>  	return dqopt->ops[type]->write_file_info(sb, type);
>  }
>  EXPORT_SYMBOL(dquot_commit_info);
> @@ -2271,7 +2282,7 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
>  		 * Now all dquots should be invalidated, all writes done so we
>  		 * should be only users of the info. No locks needed.
>  		 */
> -		if (info_dirty(&dqopt->info[cnt]))
> +		if (info_dirty(&dqopt->info[cnt]) && !sb_emergency_ro(sb))
>  			sb->dq_op->write_info(sb, cnt);
>  		if (dqopt->ops[cnt]->free_file_info)
>  			dqopt->ops[cnt]->free_file_info(sb, cnt);
> @@ -2288,7 +2299,7 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
>  
>  	/* Sync the superblock so that buffers with quota data are written to
>  	 * disk (and so userspace sees correct data afterwards). */
> -	if (sb->s_op->sync_fs)
> +	if (sb->s_op->sync_fs && !sb_emergency_ro(sb))
>  		sb->s_op->sync_fs(sb, 1);
>  	sync_blockdev(sb->s_bdev);
>  	/* Now the quota files are just ordinary files and we can set the
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 33bacd707580..b488fb1f9cc4 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -783,6 +783,19 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
>  	if (ret < 0)
>  		return ret;
>  
> +	/* An error made the filesystem read-only. */
> +	if (sb_emergency_ro(sb)) {
> +		switch (cmd) {
> +		case Q_QUOTAON:
> +		case Q_SETINFO:
> +		case Q_SETQUOTA:
> +		case Q_XQUOTAON:
> +		case Q_XQUOTARM:
> +		case Q_XSETQLIM:
> +			return -EROFS;
> +		}
> +	}
> +
>  	switch (cmd) {
>  	case Q_QUOTAON:
>  		return quota_quotaon(sb, type, id, path);
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 4da846a2bf17..1ce412439211 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -472,6 +472,11 @@ int rw_verify_area(int read_write, struct file *file, const loff_t *ppos, size_t
>  		}
>  	}
>  
> +	/* An error made the filesystem read-only. */
> +	if (read_write == WRITE && S_ISREG(file_inode(file)->i_mode) &&
> +	    sb_emergency_ro(file_inode(file)->i_sb))
> +		return -EROFS;
> +
>  	ret = security_file_permission(file, mask);
>  	if (ret)
>  		return ret;
> diff --git a/fs/remap_range.c b/fs/remap_range.c
> index 6eb7d845de5d..22639af7b6aa 100644
> --- a/fs/remap_range.c
> +++ b/fs/remap_range.c
> @@ -111,6 +111,10 @@ int remap_verify_area(struct file *file, loff_t pos, loff_t len, bool write)
>  	if (unlikely(check_add_overflow(pos, len, &tmp)))
>  		return -EINVAL;
>  
> +	/* An error made the filesystem read-only. */
> +	if (write && sb_emergency_ro(file_inode(file)->i_sb))
> +		return -EROFS;
> +
>  	ret = security_file_permission(file, mask);
>  	if (ret)
>  		return ret;
> diff --git a/fs/statfs.c b/fs/statfs.c
> index 377bcef7a561..05a90d5a3310 100644
> --- a/fs/statfs.c
> +++ b/fs/statfs.c
> @@ -48,8 +48,13 @@ static int flags_by_sb(int s_flags)
>  
>  static int calculate_f_flags(struct vfsmount *mnt)
>  {
> -	return ST_VALID | flags_by_mnt(mnt->mnt_flags) |
> -		flags_by_sb(mnt->mnt_sb->s_flags);
> +	int flags = ST_VALID | flags_by_mnt(mnt->mnt_flags) |
> +		    flags_by_sb(mnt->mnt_sb->s_flags);
> +
> +	/* An error made the filesystem read-only, SB_RDONLY stays clear. */
> +	if (sb_emergency_ro(mnt->mnt_sb))
> +		flags |= ST_RDONLY;
> +	return flags;
>  }
>  
>  static int statfs_by_dentry(struct dentry *dentry, struct kstatfs *buf)
> diff --git a/fs/super.c b/fs/super.c
> index a1dc4de1b657..0855c96b95b5 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1091,6 +1091,10 @@ int reconfigure_super(struct fs_context *fc)
>  		remount_ro = (fc->sb_flags & SB_RDONLY) && !sb_rdonly(sb);
>  	}
>  
> +	/* An error made the filesystem read-only until it is unmounted. */
> +	if (remount_rw && sb_emergency_ro(sb))
> +		return -EROFS;
> +
>  	if (remount_ro) {
>  		if (!hlist_empty(&sb->s_pins)) {
>  			super_unlock_excl(sb);
> diff --git a/fs/sync.c b/fs/sync.c
> index 4a84dd837b86..da1b35bd4445 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -181,6 +181,10 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
>  
>  	if (!file->f_op->fsync)
>  		return -EINVAL;
> +	/* Nothing is written back after an error, don't claim it is. */
> +	if (!special_file(file_inode(file)->i_mode) &&
> +	    sb_emergency_ro(file_inode(file)->i_sb))
> +		return -EROFS;
>  	if (!datasync)
>  		sync_lazytime(inode);
>  	return file->f_op->fsync(file, start, end, datasync);
> diff --git a/include/linux/fs/super.h b/include/linux/fs/super.h
> index 733d439f01ed..0fa6eaa93d44 100644
> --- a/include/linux/fs/super.h
> +++ b/include/linux/fs/super.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_FS_SUPER_H
>  #define _LINUX_FS_SUPER_H
>  
> +#include <linux/bitops.h>
>  #include <linux/fs/super_types.h>
>  #include <linux/unicode.h>
>  
> @@ -187,6 +188,22 @@ static inline bool sb_rdonly(const struct super_block *sb)
>  	return sb->s_flags & SB_RDONLY;
>  }
>  
> +/*
> + * An error made the filesystem read-only. Check this wherever sb_rdonly()
> + * gates a write but never where it describes the mount, e.g. in freeze_super()
> + * and thaw_super(). It can get set while the superblock is frozen.
> + */
> +static inline bool sb_emergency_ro(const struct super_block *sb)
> +{
> +	return test_bit(SB_STATE_EMERGENCY_RO, &sb->s_state);
> +}
> +
> +/* True for the caller that set the state. */
> +static inline bool sb_set_emergency_ro(struct super_block *sb)
> +{
> +	return !test_and_set_bit(SB_STATE_EMERGENCY_RO, &sb->s_state);
> +}
> +
>  static inline bool sb_is_blkdev_sb(struct super_block *sb)
>  {
>  	return IS_ENABLED(CONFIG_BLOCK) && sb == blockdev_superblock;
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
> index ecd96aeb1cee..b444a03788f1 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -238,6 +238,9 @@ struct super_block {
>  	/* Read-only state of the superblock is being changed */
>  	int					s_readonly_remount;
>  
> +	/* SB_STATE_* bits, set with set_bit() and never cleared */
> +	unsigned long				s_state;
> +
>  	/* per-sb errseq_t for reporting writeback errors via syncfs */
>  	errseq_t s_wb_err;
>  
> @@ -353,4 +356,20 @@ struct super_block {
>  #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
>  #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
>  
> +/*
> + * sb->s_state bits. Set with set_bit() from any context without s_umount and
> + * never cleared, so they can be tested without any ordering against the
> + * setter. Unlike SB_RDONLY which only changes under s_umount in
> + * reconfigure_super().
> + */
> +enum {
> +	/*
> +	 * An error made the filesystem read-only. The VFS refuses modifications
> +	 * with EROFS and a remount to read-write until umount. The filesystem
> +	 * still has to refuse what doesn't pass through the VFS, including its
> +	 * own writeback, see sb_emergency_ro().
> +	 */
> +	SB_STATE_EMERGENCY_RO,
> +};
> +
>  #endif /* _LINUX_FS_SUPER_TYPES_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index 0fb676dd2bd6..96ab2096abfc 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3876,6 +3876,12 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)
>  	    IS_SWAPFILE(vmf->vma->vm_file->f_mapping->host))
>  		return VM_FAULT_SIGBUS;
>  
> +	/* An error made the filesystem read-only. */
> +	if (vmf->vma->vm_file &&
> +	    S_ISREG(file_inode(vmf->vma->vm_file)->i_mode) &&
> +	    sb_emergency_ro(file_inode(vmf->vma->vm_file)->i_sb))
> +		return VM_FAULT_SIGBUS;
> +
>  	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
>  	/* Restore original flags so that caller is not surprised */
>  	vmf->flags = old_flags;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

