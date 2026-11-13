Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78D6606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ioMmpLVr;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9ZDId9b8;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ioMmpLVr;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9ZDId9b8
Received: by kanga.kvack.org (Postfix)
	id D34F26B05B3; Fri, 13 Nov 2026 09:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04786B05B4; Fri, 13 Nov 2026 09:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41A56B05B5; Fri, 13 Nov 2026 09:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADFB6B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:53:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 390FC1602CE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:53:54 +0000 (UTC)
X-FDA: 85430390388.08.EB35341
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id DDFACA000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:53:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ioMmpLVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9ZDId9b8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ioMmpLVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9ZDId9b8;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794581632;
	b=ihFFOvKzvwFOW0THl7yl/W7eh7RVKUgtpYRj7Wp1SdaIJd1i23wuF/2NRDwQLvQt7xEnmP
	5bJ0JiuJhMN+Wl4Sn+xQ11nhNUmKFUQYgh+bCkZiEqGKal7Xa8lrF87JNzU+AKiOH6ukyH
	aX6Hk+7kLdUuXp34z9hVRXbXhbntTIw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794581632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=395YDkxERGkERftBnzeIEZcPQVVqMstX985T2iiyf8A=;
	b=lTB8q0VBaJaNacP/Us4FMn+qTYJeT7zpwtsCjTjh3kGf3hEQLDHPG22TtO+W0rwlWU+s2d
	HwR1q9uLiIJDDxxwJ9c55Cbboj+6xZqe9cUE1N2ck4hRjz7PYihuIv+KY+H/7nySIVVh8u
	L+KASKRkEemedlNTGB8KDBl6Mb7W2RY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ioMmpLVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9ZDId9b8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ioMmpLVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9ZDId9b8;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5FB0421FAC;
	Fri, 13 Nov 2026 14:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794581630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=395YDkxERGkERftBnzeIEZcPQVVqMstX985T2iiyf8A=;
	b=ioMmpLVrVycBwQTgA9eNAfyAsyyURDxmI0Fpb2RpBJ61iKIAJ/x5mT8/Jnn0mFbn1SRP4q
	anRnd1zCml/8FXpIsmG31jBvjpFU+3Belrk3hBl0C8Vs7RQ5C3Jb4qyE1TOJACDnbLkyOR
	ZHp4pK+r/vBBUm5kRz6IJSUnHsKLA5s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794581630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=395YDkxERGkERftBnzeIEZcPQVVqMstX985T2iiyf8A=;
	b=9ZDId9b8i3xRqf/vzV+Qe7ixhSr62gcfP9QE5YMJXMpSIhCGDx5uqBSpMJWsnQhjaZ2AmU
	qi7hnDqlbKzvp6BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794581630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=395YDkxERGkERftBnzeIEZcPQVVqMstX985T2iiyf8A=;
	b=ioMmpLVrVycBwQTgA9eNAfyAsyyURDxmI0Fpb2RpBJ61iKIAJ/x5mT8/Jnn0mFbn1SRP4q
	anRnd1zCml/8FXpIsmG31jBvjpFU+3Belrk3hBl0C8Vs7RQ5C3Jb4qyE1TOJACDnbLkyOR
	ZHp4pK+r/vBBUm5kRz6IJSUnHsKLA5s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794581630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=395YDkxERGkERftBnzeIEZcPQVVqMstX985T2iiyf8A=;
	b=9ZDId9b8i3xRqf/vzV+Qe7ixhSr62gcfP9QE5YMJXMpSIhCGDx5uqBSpMJWsnQhjaZ2AmU
	qi7hnDqlbKzvp6BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38DC6134C3;
	Fri, 13 Nov 2026 14:53:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gu/ZB34k92oEFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 14:53:50 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B81542396C; Fri, 13 Nov 2026 15:53:49 +0100 (CET)
Date: Fri, 13 Nov 2026 15:53:49 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 05/33] fs: add a generic emergency read-only state
Message-ID: <wpmkheecl35h56u4zadxrg67ysjowyahmcgjgftch3l2yxwkso@4vq74eptdmmd>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-5-0be92bb73709@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-5-0be92bb73709@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Rspamd-Queue-Id: DDFACA000B
X-Rspamd-Server: rspam12
X-Stat-Signature: e8hszbyfa631sqqdcksc5ykmn6scapxt
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794581631-361029
X-HE-Meta: U2FsdGVkX18v5T7nTOTXbxahpn8WSkr27y+mJTZoCWwpR2GZ2FZzrJpqw1ArR9OBDAuL5gWKbSmFsTCqkxXre36O0KBCIFuvXLy2R8K28S9Lmvs2ChmwP7scPWpN4fUIeUyAI1mkyKTmJQcC15w71HXW2V+tEyHY+bvAuG+XE+1RpkL51Z/EuJhaHgairkC+lzypH3WGp1zOYxfQRFbZbSVYFpRwvXqKfohm7gSP3vrWCdSmnUSIJ0Lif8I5xeke+uxGs94MjRRE5aZitlT576/OhbmN0+7lHMX4eVDd578tbOY/LpNknh+UUxU9rRzFaW5mFI3AJC15KHAd/cIUl2z94ZomuXo0m1J9QlRqjABJJ5bErmyH6CmYwo3HPd0FZAbMGTcMFgkgur4G2yfD53q+ZuAbUVQcZTe2I2ILO1ERCVxd5riqVY6dAAwWhWVCng6rMekHW7qyO+ybDHMknrkNmMG5ioTXy9pY7V+JPNVxxiDVt6nKHBLloSK+z3ptR9jhOIEoO8wI+ArLWntTCjJKmly6ilSAW97QLlfN+wtqTCzmotpMsNU2aFJQE5tW9ZcIK3+5YeB1qJAQ32IDs/Q9FdRbxOlzttjGD+dOCUwq7gsyHxUksVhdBIKS8s8FF/Mk1PGbGnN8QV5F/GZGZnG52L8rowHrSB8DzyA/CkFbNsG1GNF5sohEwt5yI0MkRbiFsQcmhEZWqcaB9Wnv5xPiNAyN1QPBJe+ZQ26wd8Z4Qfj8yraF8sekXjjzQLcdIOUEQmrVNQLWUJyALNQHUiAl/xGxywBaQsk/V/dyF9kdguE4amXrOm7C+WHPtsdRzMO1y3r7LozYu4aHpE/hufJGadRa3EPs1CyOldqqW5zMKE7EEHv48yL8Mf+0nSh7Kq/8iYehLQzZ6+/WPYLAP2t+dLwOe0UkIi83CWtiXU8rD3EvcVLJwbPL4cD5/PWCP2krErOGMowm4e/gCmY
 jKwgy+Iz
 0glYZBeocCCO72oRD36RsCC1OeKyB/b/Ty0zzVtp91TKysTdjzcdw5o2phKGYt/7raYFnLmwDX2lqvmjMP1uoesD7y7WAjUfTWVDTzJKqqmBE0Sh45/rSopI3sNac+F7fnxt+Q1L/XP+WtLTtg0yHEyr0jSd4zWNBL7zqdAjGZoEcDPzzrOnDbGrXjbvDpUO6WdEyHyUOecVKV7KCFNXSDFW89k590RFYXCemmKZCWNJs+43Cu21JAZMYEkatLfoOzi0+kikAMyQRu/A8zK7IDxxtfmkYMOEcpSoSX3yawtGgAH45iGvZCvxwas1vYinMbvOlw07f79IYo4Qr1aHgiSh0Sxqbck3NY3K+toA7i+COTNYR2wFBxAcNcAmpa607N1IpJgAPlLw1McU12YD56JvfIE4ppEAyAnZTk49ZJ+gurYJLBFu8VwI09/lfMo16dOQl5dG3bHVNhBgGxs+kd1pazVaGF8v1rwliWNVVt3WHgfJKJqTt1KoYulccCF23i0xMOqe7xq6HWjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 13-11-26 12:59:01, Christian Brauner wrote:
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
> - __mnt_is_readonly() and sb_permission(), so everything that takes
>   write access through mnt_want_write(), mnt_want_write_file() or
>   mnt_get_write_access()
> - notify_change(), rw_verify_area(), remap_verify_area(),
>   vfs_fallocate(), vfs_fsync_range() and do_page_mkwrite() for files
>   opened before the error
> - reconfigure_super() going read-write
> - the dquot code and quotactl(2)
> - sync_filesystem() and the per-superblock passes of sync(2)
> 
> sb_rdonly_any() is true for a read-only mount and for the emergency
> state so nobody has to open-code the pair.
> 
> So umount and the ->reconfigure() implementations that sync first don't
> write such a superblock anymore either. syncfs(2) and Q_SYNC fail with
> EROFS so userspace learns that nothing was written. Jan suggested that
> (cf. [2]).
> 
> freeze_super() refuses a new freeze with EROFS. Nothing is synced
> anymore so the flusher would keep writing to the frozen filesystem.
> Joining a freeze that's already in effect still works and thaw_super()
> is unchanged so an error while frozen is undone cleanly. FIFREEZE and dm
> suspend with lockfs fail on an errored filesystem now, like they already
> did for ext4.
> 
> /proc/mounts, statmount() and statfs() report the superblock as
> read-only. "emergency_ro" isn't shown as a mount option because remount
> helpers pass the shown options back.
> 
> The filesystem still has to refuse what doesn't go through the VFS: its
> allocators, its journal and deleting unlinked inodes. Writeback isn't
> stopped. The flusher, sync_bdevs() in sync(2) and sync_blockdev() in
> kill_block_super() keep writing, so the filesystem decides what its
> writeback still writes. Without a journal refusing only part of it
> leaves the disk inconsistent. ext4 refuses data writeback in that state,
> jfs commits the allocations writeback hasn't committed yet. The VFS
> can't decide that.
> 
> [1]: https://lore.kernel.org/r/my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyocp3yxbnj@aphfqdiej2hs
> [2]: https://lore.kernel.org/r/5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Just one nit below. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 33bacd7075800..b488fb1f9cc44 100644
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

I'd use existing quotactl_cmd_write() helper for this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

