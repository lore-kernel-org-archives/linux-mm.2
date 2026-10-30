Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F90606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfRb7zlK
Received: by kanga.kvack.org (Postfix)
	id 0A1396B05B7; Fri, 30 Oct 2026 12:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02AE46B05B8; Fri, 30 Oct 2026 12:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C786B05B9; Fri, 30 Oct 2026 12:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B527A6B05B7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:09:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47AD7160453
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:54 +0000 (UTC)
X-FDA: 85379778708.09.0C6EE29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B38AC1C000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfRb7zlK;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376592;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXdDkLDRoQfo0RDcxKVzZBJ1sPUWnSU51HFGyOfej4k=;
	b=xUGHrSKZis02DzHBfO+oyKm+MJMpi1aC5loEBAQLtKnqCGUodd6MNspIyzCIaeWr6PiDfQ
	vbYyCZwZdFEZRov60yHGIqoLs5zFXYD0u4o9/OrlbxuaxC1dGgXksETZesNBsl+uAq2rX+
	q3k2UtNFOA1s+WB1WzOSHoE5gap9MXQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376592;
	b=1OZSGJ7wdP2jbH3Mrm/21iU1CJjIBDpjA+IPSREEhzQnwvhVTz+0BVjFPwhuo+h5JD5q+C
	3GbR0WeX6puSG0omcrkN/8gyUYjX0b97r+SrxubonpnEciep/jpmPJbMRwbwzOQbKJKvKS
	QNy2Vlkxp2RE9XKHp2MGNvL9Jub97xw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfRb7zlK;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F6CA605C6;
	Fri, 30 Oct 2026 16:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CC61F00A17;
	Fri, 30 Oct 2026 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376591;
	bh=bXdDkLDRoQfo0RDcxKVzZBJ1sPUWnSU51HFGyOfej4k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PfRb7zlK3p1uNnvx3Ov4FLVxblzsklQrJh/YO3Z8iV6j3TtkBBmecG96JvE2fAKfF
	 aHF+WdNcgwv90aphI7rsDhbSi/3uRGFpZVhrii67yHqKCzmiznqsEVOOreNgteURKT
	 bqVNkaIW8I97eyHWNS7sFZS5NyCQ2vVyp6NIzc0cpEfayy5QedTUhh2tyK0vxTw1c3
	 gNJiWlfeaGm/+A5ZJezGe3j6Ehy7VJ+JzYU2S7ACEB/B4YoVyqmJzYoP1p2jrxnaTh
	 FuoZCaHWS+XJpdlLrEbv9AX/LK8HQaoOIK1TgrtZpBH7FACtFac79/2/2Lr/wQo7sD
	 UloeYHujID5NA==
Message-ID: <sashiko-outbox-191224@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/34] jfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Karl
 Mehltretter" <kmehltretter@gmail.com>, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-5-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-5-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:51 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B38AC1C000E
X-Stat-Signature: dapmhdw74r4ne5c44me4aa7bihp4sssw
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793376592-876172
X-HE-Meta: U2FsdGVkX1/aZpxrnKd8EGMFNRztNiKi28nv3PW9yEMGHBtERhOSfaipE9Z8jyp+mr2PCWhZWy7URr/Vk0NsCH9tTSl/7hxR6mxrX7TWhRhODus5K3bceLdMUTwYAmt54Of4G9XV+Ld4CO1LODRZuqmAvX2flRYeXrN93iNwk4wAFdwg7DQesTs6yghxEOo60h6yKr5wQ3SVho6oPRNajcQZthPThCB62xAcLehngqmFsgHH/h3A+RAxra9dwASpmr10AjwQF5YKRJSLlzSgRWhpUEY7r+zGMB6JF/ko2iDg6n/LLWAl6gtqwrZDrI/GWss2jS8XiJsPkRWmRWhf4D8K7EYigyIJfExUpSN0FGSXvFapR3dUKxpEYIAVE7hEFmvjpro004Xok6CK5GMeOHQofnru0lqM6TXoHZ7YXj1YegjXooGFkwJiQtNbfxAN4WP2EEt8AOMjLBUKabMFvUsz+PkmqqTEBpcVvxCXfHbYo7lfDIV6I0/z6WWGQGE9/uCyTmC4cHct8BZoLmL7YWSPzosPJy1hOX4S18jW21Ft3lU8UpzbWkQn3I5SIwPulxvsEB6oKMxNM1XgvDkIzBL1vzZUnE/Y2moTyKQafBMHaVax06kLV2VQKs8A8Q9NTjnD9Ymp99OAZxiIvPt5rpSNEluK3tpONZWlIySoyn6+pN9yJmV/AO2xLBMg4HjmeIvvxPUK3SUwDfwxMVcDsr9mGOuddszIdTnGQ8vOrAec5AH6r3IboJI4K2hUafwpmFP4P21CkrvSnKwBaL4qft3pP/u9uBArrVVHnlPZDoOVS33OxpcCzv3xzfsGf6b1FJ9Zwz5O3hCVW6EX/hbj0dbBj7FLohMaWX4FEME9qmwKhJ7GU0EFDTtHdLs5w/OdSyRImPgMDaDsneCEywBQH1IBnnAX1UnSFyAE1msCcBw08iX3U7yb4U9kpuVt3+gvUFLb6CDoUcNBErBydCm
 3pA8DR2Q
 OK3nsea88UT8HuCsT1ahiHctY8xr2OfYNSehAuGx5xNym6vBNbXLZMT8iZMAJ9aZ4SIFqkhhl8YDUmiH7SqYBd/U9DF0zZRTFiHIl4sUXqCbCuQMymPQFnmnW+MmjWKdVn/OI3whtX5RaXMZ6ReRRz9/yn5MaVvad/uLfmiUScllWAopjzFe1ScqD5ZxxYeXcZqmGYLrpGi3Ga84+nGispYpFVNLSUUE14X1ysygNoIRwaZUq5HF/VA+Tx6U2KvqHNfDyQOvcGpitVrNi1mRiZuJ0ahCChNPtUH++ZLsOZ0zRC3wYUJVdgDYsTYxEgYYQg7HihGTNTEUkzbKs+fDxVWbNqavVPYD5u4UWCj2nbfObdO5FWNAsXczZ/75BCFceeTpqY9+DTLiCDRtWY4eEfaciKiZVEwT9820Z6QSnzjwCBffOMEX0WQleEQJndTeWrpO9IfIkJzE2uFZi4z+Z98BrDFu1meBLX626a1iuQNYqpYJY5YpSGTUZVwK4UPIWtirUR32hUIA1J/YlBaO0lT0s8e7Nmbq1Vx4mGkkH9xqdBZJOueLcbZzkKf3knhQ13E5lvF+z/t2VLR82rjaIL88ITMlZEGFPHqKgtBrgbXzYu37zJx/99AttobjFkocUuWLnA+oN4gp6epfavp49y82uH2tGhYa6SWCO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] jfs: jfs_reconfigure() allows rw remount and mutates sbi->flag in =
emergency_ro
- [High] jfs: uncommitted anon tlocks on error in extRecord() and extAlloc()
- [High] jfs: updateSuper() clobbers FM_DIRTY in jfs_unfreeze() under JFS_N=
OINTEGRITY
- [High] jfs: race between jfs_reconfigure() and in-flight allocations trig=
gers BUG_ON
- [Medium] jfs: jfs_reconfigure() does not recheck sb_emergency_ro() after =
sync
--

commit 2a162200f78051c6110938dcdd3b265d4583997b
Author: Christian Brauner <brauner@kernel.org>

jfs: don't set SB_RDONLY after filesystem errors

This commit replaces direct setting of SB_RDONLY in jfs_handle_error() with
sb_set_emergency_ro() so that errors occurring while frozen do not cause
thaw_super() to skip jfs_unfreeze(). It also tracks log shutdown state in
JFS_FLAGS_LOG_SHUTDOWN and adds sb_emergency_ro() checks across JFS
allocation, metadata modification, freeze, sync, and remount paths.

Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com

> diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
> index 46529bcc8297e..ba55e0bbecd24 100644
> --- a/fs/jfs/jfs_extent.c
> +++ b/fs/jfs/jfs_extent.c
[ ... ]
> @@ -270,6 +276,10 @@ int extRecord(struct inode *ip, xad_t * xp)
>  	/* update the extent */
>  	rc =3D xtUpdate(0, ip, xp);
> =20
> +	/* get the anonymous tlocks committed, like extAlloc() does */
> +	if (!rc)
> +		mark_inode_dirty(ip);
> +
>  	mutex_unlock(&JFS_IP(ip)->commit_mutex);
>  	return rc;
>  }

[Severity: High]
What happens in extRecord() and extAlloc() if xtUpdate(), xtExtend(), or
xtInsert() fails after acquiring an anonymous tlock?

In xtUpdate() and xtExtend(), BT_MARK_DIRTY(mp, ip) runs before txLock(0, i=
p,
mp, ...):

fs/jfs/jfs_xtree.c:xtUpdate() {
	...
	BT_MARK_DIRTY(mp, ip);
	/*
	 * acquire tlock of the leaf page containing original entry
	 */
	if (!test_cflag(COMMIT_Nolink, ip)) {
		tlck =3D txLock(tid, ip, mp, tlckXTREE | tlckGROW);
		xtlck =3D (struct xtlock *) & tlck->lock;
	}
	...
	if ((xoff > nxoff) ||
	    (nxoff + nxlen > xoff + xlen)) {
		XT_PUTPAGE(mp);
		jfs_error(ip->i_sb,
			  "nXAD in not completely contained within XAD\n");
		return -EIO;
	}
	...
}

If mp is not the root xtree page, BT_MARK_DIRTY() does not call
mark_inode_dirty(ip). If mp is the root xtree page and sb_emergency_ro() was
already set concurrently, BT_MARK_DIRTY() calls jfs_dirty_inode() while
JFS_IP(ip)->atlhead is still 0, so jfs_dirty_inode() returns early without
setting COMMIT_Dirty.

Immediately afterward, txLock(0, ip, ...) attaches an anonymous tlock to
JFS_IP(ip)->atlhead and queues JFS_IP(ip)->anon_inode_list onto
TxAnchor.anon_list. Similarly, in extAlloc(), xtExtend() and xtInsert() (via
xtSplitUp() -> xtSplitPage() or xtSplitRoot()) call txLock(0, ip, ...) befo=
re
subsequent metapage reads or extent checks can fail and call jfs_error() ->
sb_set_emergency_ro().

When xtUpdate(), xtExtend(), or xtInsert() returns a non-zero rc, extRecord=
()
skips mark_inode_dirty(ip) because of the !rc check, and extAlloc() returns
early before mark_inode_dirty(ip):

fs/jfs/jfs_extent.c:extAlloc() {
	...
	if (xaddr && xaddr =3D=3D nxaddr)
		rc =3D xtExtend(0, ip, xoff, (int) nxlen, 0);
	else
		rc =3D xtInsert(0, ip, xflag, xoff, (int) nxlen, &nxaddr, 0);

	if (rc) {
		dbFree(ip, nxaddr, nxlen);
		dquot_free_block(ip, nxlen);
		mutex_unlock(&JFS_IP(ip)->commit_mutex);
		return (rc);
	}
	...
	mark_inode_dirty(ip);
}

With COMMIT_Dirty never set on ip (and jfs_freeze() skipping txQuiesce() on=
ce
sb_emergency_ro() is set), could evicting the inode trigger
BUG_ON(!list_empty(&ji->anon_inode_list)) in jfs_evict_inode()?

> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 8180d83d33fed..bbaba14821e64 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
[ ... ]
> @@ -367,6 +368,11 @@ static int jfs_reconfigure(struct fs_context *fc)
>  	int flag =3D ctx->flag;
>  	int ret;
> =20
> +	/* Don't resize based on a block map we don't trust after an error. */
> +	if (ctx->resize && sb_emergency_ro(sb))
> +		return -EROFS;
> +
> +	/* After an error this only commits what was queued before it. */
>  	sync_filesystem(sb);
> =20
>  	/* Transfer results of parsing to the sbi */

[Severity: Medium]
If a filesystem error occurs while sync_filesystem(sb) is flushing dirty pa=
ges
or inodes during a resize remount (or concurrently while sync_filesystem(sb)
is running), jfs_handle_error() now sets sb_set_emergency_ro(sb) instead of
SB_RDONLY.

When execution reaches the ctx->resize block in jfs_reconfigure():

fs/jfs/super.c:jfs_reconfigure() {
	...
	if (ctx->resize) {
		if (sb_rdonly(sb)) {
			pr_err("JFS: resize requires volume to be mounted read-write\n");
			return -EROFS;
		}
		...
		rc =3D jfs_extendfs(sb, ctx->newLVSize, 0);
}

sb_rdonly(sb) is still false, so won't jfs_extendfs() proceed on a filesyst=
em
that just entered emergency read-only mode during sync_filesystem(sb)?

> @@ -415,6 +421,9 @@ static int jfs_reconfigure(struct fs_context *fc)
>  		return ret;
>  	}
>  	if (!sb_rdonly(sb) && readonly) {
> +		/* After an error nothing may be written, umount closes the log. */
> +		if (sb_emergency_ro(sb))
> +			return 0;
>  		rc =3D dquot_suspend(sb, -1);
>  		if (rc < 0)
>  			return rc;

[Severity: High]
What happens if userspace requests a read-write remount (for example, mount=
 -o
remount,rw) after a runtime filesystem error without having remounted
read-only first?

Because jfs_handle_error() calls sb_set_emergency_ro(sb) without setting
SB_RDONLY, sb_rdonly(sb) remains false. In reconfigure_super():

fs/super.c:reconfigure_super() {
	...
		remount_rw =3D !(fc->sb_flags & SB_RDONLY) && sb_rdonly(sb);
		remount_ro =3D (fc->sb_flags & SB_RDONLY) && !sb_rdonly(sb);
	}

	/* An error made the filesystem read-only until it is unmounted. */
	if (remount_rw && sb_emergency_ro(sb))
		return -EROFS;
}

remount_rw is false, so reconfigure_super() calls into jfs_reconfigure() wi=
th
!sb_rdonly(sb) && !readonly.

In jfs_reconfigure(), JFS_SBI(sb)->flag =3D ctx->flag is executed unconditi=
onally
right after sync_filesystem(sb) (which also makes the later
(JFS_SBI(sb)->flag & JFS_NOINTEGRITY) !=3D (flag & JFS_NOINTEGRITY) check c=
ompare
flag against itself), and then jfs_reconfigure() falls through and returns 0
instead of -EROFS.

Furthermore, if a remount (either ro or rw) includes the nointegrity option
after an error, JFS_SBI(sb)->flag gains JFS_NOINTEGRITY while sbi->p_state =
is
still 0 (FM_CLEAN). When jfs_umount() later calls updateSuper(sb, FM_CLEAN):

fs/jfs/jfs_mount.c:updateSuper() {
	...
	if (sbi->flag & JFS_NOINTEGRITY) {
		if (state =3D=3D FM_DIRTY) {
			sbi->p_state =3D state;
			return 0;
		} else if (state =3D=3D FM_MOUNT) {
			sbi->p_state =3D sbi->state;
			state =3D FM_DIRTY;
		} else if (state =3D=3D FM_CLEAN) {
			state =3D sbi->p_state;
		} else
			jfs_err("updateSuper: bad state");
	} else if (sbi->state =3D=3D FM_DIRTY)
		return 0;
}

won't updateSuper() take the JFS_NOINTEGRITY branch instead of returning ea=
rly
at sbi->state =3D=3D FM_DIRTY, and overwrite the on-disk FM_DIRTY error sta=
te with
FM_CLEAN?

[Severity: High]
Can a read-only remount in jfs_reconfigure() also race with an in-flight
extAlloc() or extRecord() that passed the sb_emergency_ro(ip->i_sb) check j=
ust
before an error occurred?

Consider an in-flight allocation running concurrently with reconfigure_supe=
r()
-> jfs_reconfigure() (either during a forced remount such as
emergency_remount() where sb_prepare_remount_readonly() is skipped, or via
background writeback in do_writepages() -> jfs_writepages() ->
mpage_write_folio() -> jfs_get_block() after writeback_iter() clears
PAGECACHE_TAG_DIRTY and before folio_start_writeback() sets
PAGECACHE_TAG_WRITEBACK):

1. extAlloc() or extRecord() passes sb_emergency_ro(ip->i_sb) before
   sb_set_emergency_ro(sb) is set.
2. jfs_reconfigure() runs sync_filesystem(sb) and returns 0 at the
   sb_emergency_ro(sb) check, and reconfigure_super() sets SB_RDONLY on
   sb->s_flags.
3. extAlloc() or extRecord() finishes acquiring its anonymous tlock (setting
   ji->atlhead and adding ji->anon_inode_list to TxAnchor.anon_list) and ca=
lls
   mark_inode_dirty(ip) -> jfs_dirty_inode(ip), which sees ji->atlhead !=3D=
 0 and
   sets COMMIT_Dirty.
4. During unmount, generic_shutdown_super() calls sync_filesystem(sb), which
   immediately returns 0 because sb_rdonly(sb) is now true.
   generic_shutdown_super() then calls evict_inodes(sb) before
   jfs_put_super().

Wouldn't jfs_evict_inode() hit BUG_ON(!list_empty(&ji->anon_inode_list))
because nothing commits the inode after jfs_reconfigure() sets SB_RDONLY?

[ ... ]
> @@ -616,15 +635,19 @@ static int jfs_unfreeze(struct super_block *sb)
>  	struct jfs_log *log =3D sbi->log;
>  	int rc =3D 0;
> =20
> -	if (!sb_rdonly(sb)) {
> +	/* Undo what jfs_freeze() did, also if an error happened meanwhile. */
> +	if (test_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags)) {
>  		rc =3D updateSuper(sb, FM_MOUNT);
>  		if (rc) {
>  			jfs_error(sb, "updateSuper failed\n");
>  			goto out;
>  		}

[Severity: High]
If the filesystem was mounted with JFS_NOINTEGRITY and an error occurs whil=
e it
is frozen, does calling updateSuper(sb, FM_MOUNT) in jfs_unfreeze() clobber=
 the
FM_DIRTY state?

When jfs_freeze() runs on a JFS_NOINTEGRITY mount, updateSuper(sb, FM_CLEAN)
writes FM_CLEAN and sets sbi->state =3D FM_CLEAN. If a filesystem error hap=
pens
while frozen, jfs_handle_error() calls updateSuper(sb, FM_DIRTY):

fs/jfs/jfs_mount.c:updateSuper() {
	...
	if (sbi->flag & JFS_NOINTEGRITY) {
		if (state =3D=3D FM_DIRTY) {
			sbi->p_state =3D state;
			return 0;
		} else if (state =3D=3D FM_MOUNT) {
			sbi->p_state =3D sbi->state;
			state =3D FM_DIRTY;
		} else if (state =3D=3D FM_CLEAN) {
			state =3D sbi->p_state;
		}
		...
	}
	...
	sbi->state =3D state;
}

Under JFS_NOINTEGRITY, updateSuper(sb, FM_DIRTY) records FM_DIRTY in
sbi->p_state and returns 0, leaving sbi->state as FM_CLEAN.

When jfs_unfreeze() then calls updateSuper(sb, FM_MOUNT), the state =3D=3D =
FM_MOUNT
branch sets sbi->p_state =3D sbi->state (FM_CLEAN), overwriting the FM_DIRT=
Y in
sbi->p_state. When jfs_umount() later calls updateSuper(sb, FM_CLEAN), won'=
t it
write sbi->p_state (FM_CLEAN) to disk, leaving the corrupted filesystem mar=
ked
clean?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D5

