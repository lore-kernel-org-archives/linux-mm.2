Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49E5606A332
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=HbiPobah;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QBNwugyQ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=HbiPobah;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QBNwugyQ
Received: by kanga.kvack.org (Postfix)
	id 0B20F6B05B5; Fri, 13 Nov 2026 09:54:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C886B05B6; Fri, 13 Nov 2026 09:54:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66D56B05B7; Fri, 13 Nov 2026 09:54:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCAF96B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:54:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58859A01A6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:54:53 +0000 (UTC)
X-FDA: 85430392866.01.104B93F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 289DB80009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:54:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HbiPobah;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QBNwugyQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HbiPobah;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QBNwugyQ;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794581691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLg1wy+Nl3hNJVUViyQU914DrXr8uKXxDSBe+HH3+OI=;
	b=DXFTfo9ZdCx4J5rEhDEmZjsSPqo+gnYItu3whT17ML3DuFF3llrMskI5Xh/h6fq5jMm78Y
	YXJfqtLwOJH9XzqnB7O1Qv7LHtOklKKIeuWUA8LQ99TMXLJ2rWY2g8vpAcKQ+KA4jEdgzb
	Jy2u4QVrmOJPIJRDTu5PTB8o6TkdWJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794581691;
	b=GtYjBY4IWmO8rmZfVYSO63wZOwGKIw9lgNJ31q/b2ZRMtnyoFHE8eO3i0Y6AIBCSBsMKFi
	JBE10MN/D/eoix7GQFB27CjWVAvmYp2CHtibU2e0QaAgXQEBpyFsHw6veJcxCzi3O6PeD8
	rDeXPdP3RFM41iAIHoRWtf7ntcj9d10=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HbiPobah;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QBNwugyQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HbiPobah;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QBNwugyQ;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0100E1F76B;
	Fri, 13 Nov 2026 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794581690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLg1wy+Nl3hNJVUViyQU914DrXr8uKXxDSBe+HH3+OI=;
	b=HbiPobahhoFdy1JualtlCQSG5WiHGbYkeN97T1slq4syz8ydxAAmyFBMnw9wIWMymvWQBA
	OibY1yJc8woYnm917MtaAgfxA3/FGLQWnqOg9S4/Gje0GR/2m8TO3d0XcGyF5ZnSISlDva
	Pm+cC9vb75/3LpW2TrEGkQOayOm27Hw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794581690;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLg1wy+Nl3hNJVUViyQU914DrXr8uKXxDSBe+HH3+OI=;
	b=QBNwugyQn7fvnUpfJc61DDJ3B5ezL3Vu/dwAt7y/gE33yL9lBDupL5AB9JAf8phimNZdBs
	djr90So7chpqQRAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794581690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLg1wy+Nl3hNJVUViyQU914DrXr8uKXxDSBe+HH3+OI=;
	b=HbiPobahhoFdy1JualtlCQSG5WiHGbYkeN97T1slq4syz8ydxAAmyFBMnw9wIWMymvWQBA
	OibY1yJc8woYnm917MtaAgfxA3/FGLQWnqOg9S4/Gje0GR/2m8TO3d0XcGyF5ZnSISlDva
	Pm+cC9vb75/3LpW2TrEGkQOayOm27Hw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794581690;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLg1wy+Nl3hNJVUViyQU914DrXr8uKXxDSBe+HH3+OI=;
	b=QBNwugyQn7fvnUpfJc61DDJ3B5ezL3Vu/dwAt7y/gE33yL9lBDupL5AB9JAf8phimNZdBs
	djr90So7chpqQRAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBF48134C3;
	Fri, 13 Nov 2026 14:54:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hybEI7kk92pSFgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 14:54:49 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 50A352396E; Fri, 13 Nov 2026 15:54:49 +0100 (CET)
Date: Fri, 13 Nov 2026 15:54:49 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH v3 06/33] ext2: don't set SB_RDONLY after filesystem
 errors
Message-ID: <wsdk673ps54ncvmj7xvgzghgcf7y27uw4w7ahrgbytdy6tdxg3@ldvmi2yk3lm7>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-6-0be92bb73709@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-6-0be92bb73709@kernel.org>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 289DB80009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zixmztoi4t11uj6hdzcb1mmtybrfwd8j
X-Rspam-User: 
X-HE-Tag: 1794581691-644240
X-HE-Meta: U2FsdGVkX19EmaBCvyp2Kb9ntX8eRcI8yQKUvT1+z9oHzL2mn3ERTBsg3TPRTrMbXl9JhQY0gPgD4EHE/uS8iwSK0o2yRySUgm2SuiJnYQaA1vZYh6svKsx4ryJnCI+Al13xMGsK/QkWZODp5ES+reAjMxt10lfFin4cFfCfBExu3VxLT8DTbWDwlFE7oOKhLFGgEC2RRaDCIvuONn1cnwT8eTSKKcnnGm9uTmE2r9h0VQrIXa8Oa2BKKRBSOk7b2HqPT7F+kamauQThbr7bN4VNTB51sdzNvL2NuVan8tB/JgGWH7SFm6kE2dR2RW4jBYJzguQvNhrkcr9NtY84Udw04al1pAdg4gUr00zd513184ftOq0IimXSEnkY1xFXFmxLVAleFKlgUzJ2PL4aVjqo8eZ+6P1qp/xicYqTrmxW9xAbpFflx3maq5FiDoRHVNHkvcJRMvrf3ic+QUxmkFoRoeelT2v+Kilkg27fVOqo+wN/4ffHjmOJQb5KM4Qt+V1fnL+H1Ap78pWDpFGl/6AlXQb9vM7jAbAL2/j8Ap2XndmpS5R5yZIUWH6hVes+QAM8E9jFAmvsT/c42m5fUkZYZRwdto6WtZcSed19otUq+Bi1tfP8IYkAeF1wLPv+a0XsYMFoibwvdBvMCHTvF84gNf/4zHlZ3gsyYHdOWpWRMulVHkpIXxSRbIB4+fPd9Jx53tcQW1cw9FxBZ+HFhjJN2t8DJn1QPH7MGu95RSO4F9XUatbvqH3uHnW2w3DaJC06sMBtIUff8dpOHk5juGtL5P2ynrxBVjN9Hx6yMYU8D4Mpe3Tsh3BWHEYQ55024cB8rMtocVtG+vjSO1QOb9aIRo2HFuyg0coLT92QA1oaLMMm/gJ5zgk0ahGglYMLWP07AQzLdBpenQ9eXaUQ4VvH8N9BWo3MYjAuNAuvbWp3uJb1SGbNoJ70KRUYuBvuo44YNFf8AMRuP9IWdQl
 zYZCENu9
 Xkfo6PwZfgk4aNJd2v0UftF3n604RtJvjkzinUy4GH40GKv3SBfo6ZPwSCaGTDxd14/hRFRiamcjOgKc6nyVnheXIBt8MfS+fMlDfUH/ZutTYg2c6ypjYcxEQgXWiUVLhbgZHNShsqImksmtkSKK7qC7hgYdJfwb349+rEPUzwVW52rWfbIFxHWN0dmXf8Elq5S1w8+nD2+W4C/1xWqD5cQIHH4G+PU0qHC/8RuLTFwTrOCJ+3VllZbf+grqYI/4QdrBYGRckx+R+EokpfV7GaEmhTibFSI0iJGbiJQN8dZt9TaRaHnj8hgXovurY4qih5M8DliV0BKKj35VRkowVKp+3NP2P3wMenpDGaINktG+K3pVvAY/D3S+7Oo4VMD/mV8YGZO+6LeOD2pVXvsXPpumJXWqLKp6kNd05L+4P404EHXFsq+x40brqVzQ4G3a3P+vlblqEi/HcHP4U48NbKqrQUyYuvqcFE37P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 13-11-26 12:59:02, Christian Brauner wrote:
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
> modifications. ext2 still refuses allocations and ext2_xattr_set()
> itself, ecryptfs calls the latter without write access on the lower
> mount. Unlinked inodes are left to e2fsck. ext2_write_inode() keeps
> working because writeback still writes data, bitmaps, indirect and
> directory blocks after the error and they'd be lost without the inode.
> A thaw after an error while frozen still writes the superblock but
> EXT2_ERROR_FS stays set in it.
> 
> After a remount to read-only a remount to read-write fails until umount.
> A plain remount to read-write right after the error succeeds but the
> filesystem stays read-only. Writes through file descriptors opened
> before the error fail with EROFS.
> 
> [1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7pzcrlu33@p7zzlgp2ehjf
> 
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/balloc.c |  5 +++++
>  fs/ext2/ialloc.c |  2 ++
>  fs/ext2/inode.c  |  4 +++-
>  fs/ext2/super.c  | 13 ++++++++-----
>  fs/ext2/xattr.c  |  2 ++
>  5 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 80acc1e193871..77f2ed5a76a28 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -1236,6 +1236,11 @@ ext2_fsblk_t ext2_new_blocks(struct inode *inode, ext2_fsblk_t goal,
>  	*errp = -ENOSPC;
>  	sb = inode->i_sb;
>  
> +	if (sb_emergency_ro(sb)) {
> +		*errp = -EROFS;
> +		return 0;
> +	}
> +
>  	/*
>  	 * Check quota for allocation of this block.
>  	 */
> diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
> index bf21b57cf98cd..2741ecd2b94fc 100644
> --- a/fs/ext2/ialloc.c
> +++ b/fs/ext2/ialloc.c
> @@ -433,6 +433,8 @@ struct inode *ext2_new_inode(struct inode *dir, umode_t mode,
>  	int err;
>  
>  	sb = dir->i_sb;
> +	if (sb_emergency_ro(sb))
> +		return ERR_PTR(-EROFS);
>  	inode = new_inode(sb);
>  	if (!inode)
>  		return ERR_PTR(-ENOMEM);
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 12ac4cfe15003..dd28637c60737 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -71,7 +71,9 @@ void ext2_evict_inode(struct inode * inode)
>  	struct ext2_block_alloc_info *rsv;
>  	int want_delete = 0;
>  
> -	if (!inode->i_nlink && !is_bad_inode(inode)) {
> +	/* After an error made us read-only the inode is left to e2fsck. */
> +	if (!inode->i_nlink && !is_bad_inode(inode) &&
> +	    !sb_emergency_ro(inode->i_sb)) {
>  		want_delete = 1;
>  		dquot_initialize(inode);
>  	} else {
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index fb217ef2d69f0..10d5165459749 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -53,7 +53,7 @@ void ext2_error(struct super_block *sb, const char *function,
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
>  	struct ext2_super_block *es = sbi->s_es;
>  
> -	if (!sb_rdonly(sb)) {
> +	if (!sb_rdonly_any(sb)) {
>  		spin_lock(&sbi->s_lock);
>  		sbi->s_mount_state |= EXT2_ERROR_FS;
>  		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
> @@ -73,11 +73,11 @@ void ext2_error(struct super_block *sb, const char *function,
>  
>  	if (test_opt(sb, ERRORS_PANIC))
>  		panic("EXT2-fs: panic from previous error\n");
> -	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO)) {
> +	/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
> +	if (!sb_rdonly(sb) && test_opt(sb, ERRORS_RO) &&
> +	    sb_set_emergency_ro(sb))
>  		ext2_msg(sb, KERN_CRIT,
>  			     "error: remounting filesystem read-only");
> -		sb->s_flags |= SB_RDONLY;
> -	}
>  }
>  
>  static void ext2_msg_fc(struct fs_context *fc, const char *prefix,
> @@ -179,7 +179,7 @@ static void ext2_put_super (struct super_block * sb)
>  	ext2_xattr_destroy_cache(sbi->s_ea_block_cache);
>  	sbi->s_ea_block_cache = NULL;
>  
> -	if (!sb_rdonly(sb)) {
> +	if (!sb_rdonly_any(sb)) {
>  		struct ext2_super_block *es = sbi->s_es;
>  
>  		spin_lock(&sbi->s_lock);
> @@ -1360,6 +1360,9 @@ static int ext2_reconfigure(struct fs_context *fc)
>  	if ((bool)(flags & SB_RDONLY) == sb_rdonly(sb))
>  		goto out_set;
>  	if (flags & SB_RDONLY) {
> +		/* After an error nothing may be written, just go read-only. */
> +		if (sb_emergency_ro(sb))
> +			goto out_set;
>  		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
>  		    !(sbi->s_mount_state & EXT2_VALID_FS))
>  			goto out_set;
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 8f608930a48c6..12dfffff189cb 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -429,6 +429,8 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
>  	ea_idebug(inode, "name=%d.%s, value=%p, value_len=%ld",
>  		  name_index, name, value, (long)value_len);
>  
> +	if (sb_emergency_ro(sb))
> +		return -EROFS;
>  	if (value == NULL)
>  		value_len = 0;
>  	if (name == NULL)
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

