Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8AD606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=inNheHXO
Received: by kanga.kvack.org (Postfix)
	id 582D26B05C3; Fri, 30 Oct 2026 12:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50EA96B05C4; Fri, 30 Oct 2026 12:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388206B05C5; Fri, 30 Oct 2026 12:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04E1C6B05C3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:10:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74438A07D5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:13 +0000 (UTC)
X-FDA: 85379779506.25.4B389D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id DCD164000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=inNheHXO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376611;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZcJMAN1WEDLBmcVjJji36pJ2+2BOXRKD4UYVao+MNcs=;
	b=ItHGdPqJymw/wgJtwF5ETyh+WNFIhlPwpsHOqgWhuNkdOOUn7S+pdPPeHkz2lMdQ9ccYJp
	PR+5QZPSJI0GOl/rOzYSSmHZpLgIc5AqVNRPS1Kc2IYgzcT74rkWKmI3BsWbHlrllKOC0a
	zS2TAMCrepyXVBCiRRGx6rzl4sGtwW4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=inNheHXO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376611;
	b=b4kY7/U7oxt34zzY8VrHvuftXYwOx1Qg4zFkSo1fpH5MKdi4hFqsSfSZqMTMxeO08YEldY
	4I0sU7XH14FdoefkYTFVqwHJOVSYcCsxwt7HjfK3cExZI/5db77RDOZ4gbaqK5Jc8gBtYL
	TA+NSrlOnlBGr0eR6Lyutc3pJpAP2EI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A88060252;
	Fri, 30 Oct 2026 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A886B1F000C1;
	Fri, 30 Oct 2026 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376611;
	bh=ZcJMAN1WEDLBmcVjJji36pJ2+2BOXRKD4UYVao+MNcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=inNheHXOvVuPpHySy1lgcss7FWDCqOqwgssaDeZy9QPl79AuL9KANuK9zqFV1kA8l
	 lb255VmAdzCOcsye6+bh+3F9QS9Uo7C5fgIvWX+bsZqIZY/HG604zNHiXseXSd5w4R
	 OF1cCcUS5kuB++LDmGFqHz9AcEbvGAtJUn9bQwnJJuXhAG5vfSPWPAOs4a/koPZajE
	 W/B/1AB/GRiz1Rpu4/t8LOYAWZTQVnu2TK3ow7Hws4sPjw/X7PL5E4cacLLptD51TQ
	 ht4YStHkctUhWLuZsMU7+20PtS4GJ3NZIYmwcqCHsvsblL2TQgAFiY+qpb4kWXnhLe
	 UiYsV25nzIsJQ==
Message-ID: <sashiko-outbox-191245@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 26/34] gfs2: don't set SB_RDONLY on withdraw
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-26-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-26-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:10 +0000
X-Rspamd-Queue-Id: DCD164000B
X-Rspam-User: 
X-Stat-Signature: 153ko6eue4kcesk7k1ekbgaswj7dkosh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793376611-55233
X-HE-Meta: U2FsdGVkX1934Qlbq889TIE7LZbm+2dqviP5Zv4C5WfdUEy2keO33lUBUrx9pvYvqfvjDNaIuOhBHuAxLf73OjzdfYJxriyHN6ng78RGwCIs/LQHP+Q/LDTLwhNueaZlEK3EO4N+UKseyy8jlIzqmb+bKB9eIrlH4Y95xIw61LalcxZN5Li6UmwWmye5kkik+qTNUYh/VaS6GUAPr+d/qkWwvtotEZCWLZBR8M0XRq0vPU/91WoUeQQhi7qzSW9eecMyOSCldjHfeB+jVfLEvk5WENu7FLMBepT9GNYM2xoWCXP2JFSMSOXOaoQM3kiDCaK+wQKgC3w7KIbyAWN9/pKygfHmhoMZygE3vg7DTQHZJRkApWaUpPRsb6giai3SJKycyRQbGyYlpiEBaNnVYwsTlD9TYbRpnMtMg2IWgDI2pdgYd+ed8is2VhTBru0Sx2SMpKJneZ5W9YF611wPdD/ZnT1jw0IZ8YxLS8IXfvoJ2yhhkbAjTZQlMywAyA/4xHioM9tSzu5bd8emJLceejP7txzkJ18uni2jiNIB5smgKclpB8F5A6AsIrogam67DWXGa8OSinnaZOS7W77SJepMzR3yC3u3ptigRmS+jB2/89X13rvqIAZxW0ki/i6nIKADpiGbkRAmzZH9bkL1dHzSIEOZwLgwwX91lSOQirvgXOEG4YxWzKl6eKEMDdzEPDCvPqubv1Vi6Cf8iEOlp7NjzVU2n7BuPdIhRxDLNyN8tg3nMqfFQEB/PAx7JMPotnIug3kzd3xHb8WG/r+kh0tjVtkE+WRDbO6XgLDABnisMiPO27t81yCkho/dao0vmpmMIiNRHJxo2udoS50J+Bcqmi00k2+qkc59ksG7DRf97iDpl3zQjc+56Lu+JR5Llp3uFwM0yB2lxDnBfuR2kWF7vMqLb0kYzMXcLg7M/zqjm7i9ae0hJWsRWVwQKG2YZmnXKjnhsN+vRtT/pgj
 OU792coL
 khR0CH7Y4v6//2D4GQD3CwyAMBMnzIVeKF02tMmKZUsoY3eVg+zuUP8p96dBspgeoNIThfKUoMGKl7gLsQ5l8AIRPtU7Ila1lbSvbkmkcmZnxAYWmKKfRE83cLny1JRHYYK0YMQWdZFtAaHczz1hVhSukMr7CR69pgzIteizIJEYU68JP1PCeB3CZISNLm98Dkrv5kQEsoxXfWNNSw3uMW4uCg+PpBczh7cjtn+3VVAvS/FlRYYHSribBNrI5CCAm76YkTrI7qQU7WnSscRZMFFWzfU/nWdluek9qFYZR1TaO5axOoDZU6Po+5lXipjXnjoXCuAgWKPl2bvoXc8nH0rAgJcrUdOUTzFuQ+4rg4W98rUE1uvFklBlAps0iWM1niFBYp/70QEJEVeBF7dzsEqeyP8M7UYQY2Ad9QEut87UlaTC+wUKTAzpUZZULmtmBiMEx9yAiJYc1sgw/XnMBx0GS+co0tgMkSk/Qgkw3u3mFZCglbG/rUlkOhoiw5ZGb0D4BQP31tE2thTiwJ4eALR7G1jJqFbQgCbESjkajYwCC6gtbFdAWgJQPaWtM2IfsqqgT5BGJVqmHpP2JffCcZXdPc+46RQ307hZVAf1tbeNaehN+h8X6bGvlZxCGQaIL17bFIoszhq40Ttg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] gfs2: missing withdraw check in gfs2_aspace_writepages() after=
 SB_RDONLY drop
- [High] gfs2: double freeze glock acquisition in gfs2_freeze_super() error=
 path
- [High] gfs2: gfs2_freeze_fs() allows freezing withdrawn fs after journal =
clear
--

commit 492245d825d0faf64cbdfa5077542cb35552bb3d
Author: Christian Brauner <brauner@kernel.org>

gfs2: don't set SB_RDONLY on withdraw

This commit stops setting SB_RDONLY in do_withdraw() so that thawing and
unmounting a withdrawn filesystem do not leave s_writers rwsems locked due
to a read-only superblock. It updates inode eviction, quota sync, inode
writeback, and freeze/thaw handling to check gfs2_withdrawn() directly.

> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index f61c309368ef1..82f9d90f35788 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -455,6 +455,9 @@ static int gfs2_write_inode(struct inode *inode, stru=
ct writeback_control *wbc)
>  	int ret =3D 0;
>  	bool flush_all =3D (wbc->sync_mode =3D=3D WB_SYNC_ALL || gfs2_is_jdata(=
ip));
> =20
> +	if (gfs2_withdrawn(sdp))
> +		return -EIO;

[Severity: Critical]
Does checking gfs2_withdrawn(sdp) only in gfs2_write_inode() allow dirty
resource group metadata buffers in sdp->sd_inode->i_mapping to be written to
disk after a withdraw now that do_withdraw() no longer sets SB_RDONLY?

Resource group metadata buffers are allocated in gfs2_aspace(sdp)
(sdp->sd_inode->i_mapping), which uses gfs2_rgrp_aops with
gfs2_aspace_writepages() in fs/gfs2/meta_io.c as its .writepages callback:

fs/gfs2/meta_io.c:gfs2_aspace_writepages() {
	while ((folio =3D writeback_iter(mapping, wbc, folio, &error)))
		gfs2_aspace_write_folio(folio, wbc);
}

When a transaction modifying resource group blocks commits in gfs2_unpin(),
mark_buffer_dirty(bh) marks the folio dirty in sdp->sd_inode->i_mapping and
sets I_DIRTY_PAGES on sdp->sd_inode. If the filesystem then withdraws,
do_withdraw() drains the AIL via gfs2_ail_drain() without clearing BH_Dirty
or the folio dirty state, and gfs2_withdraw_glocks() -> withdraw_glock() in
fs/gfs2/glock.c calls request_demote() without queueing gl->gl_work, leaving
cached resource group glocks with no active holders undemoted and their
dirty buffers in sdp->sd_inode->i_mapping uninvalidated until
gfs2_put_super().

Previously, setting SB_RDONLY in do_withdraw() caused sync_filesystem() and
sync_inodes_one_sb() to return early. Without SB_RDONLY, sync_filesystem()
during sync, remount-ro in gfs2_reconfigure(), or umount in
generic_shutdown_super() runs:

  __writeback_single_inode(sdp->sd_inode, &wbc)
    -> do_writepages(sdp->sd_inode->i_mapping, wbc)
      -> gfs2_aspace_writepages()
        -> gfs2_aspace_write_folio()

which submits writes for those dirty resource group buffers to the block
device without reaching gfs2_write_inode(). Should gfs2_aspace_writepages()
also check gfs2_withdrawn(sdp)?

> @@ -686,7 +689,8 @@ static int gfs2_do_thaw(struct gfs2_sbd *sdp, enum fr=
eeze_holder who, const void
>  	int error;
> =20
>  	error =3D gfs2_freeze_lock_shared(sdp);
> -	if (error)
> +	/* A withdrawn filesystem can't get the freeze glock back, thaw anyway.=
 */
> +	if (error && !gfs2_withdrawn(sdp))
>  		goto fail;
>  	error =3D thaw_super(sb, who, freeze_owner);
>  	if (!error)
> @@ -751,6 +755,11 @@ static int gfs2_freeze_super(struct super_block *sb,=
 enum freeze_holder who,
>  		mutex_unlock(&sdp->sd_freeze_mutex);
>  		return -EBUSY;
>  	}
> +	/* A withdrawn filesystem can't take the freeze glock anymore. */
> +	if (gfs2_withdrawn(sdp)) {
> +		mutex_unlock(&sdp->sd_freeze_mutex);
> +		return -EIO;
> +	}
> =20
>  	for (;;) {

[Severity: High]
Can a withdrawn filesystem still be frozen once do_withdraw() clears
SDF_JOURNAL_LIVE?

Without SB_RDONLY set by do_withdraw(), VFS freeze_super() on a withdrawn
filesystem no longer takes the sb_rdonly(sb) shortcut and instead locks the
s_writers rwsems, calls sync_filesystem(sb), and invokes
sb->s_op->freeze_fs(sb), which is gfs2_freeze_fs() in fs/gfs2/super.c:

fs/gfs2/super.c:gfs2_freeze_fs() {
	if (test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
		gfs2_log_flush(sdp, NULL, GFS2_LOG_HEAD_FLUSH_FREEZE |
			       GFS2_LFC_FREEZE_GO_SYNC);
		if (gfs2_withdrawn(sdp))
			return -EIO;
	}
	return 0;
}

Because do_withdraw() in fs/gfs2/util.c clears SDF_JOURNAL_LIVE,
gfs2_freeze_fs() skips the if-block and returns 0 instead of -EIO.

If a freeze is triggered via freeze_store() in fs/gfs2/sys.c or
gfs2_freeze_func() in fs/gfs2/super.c (which call VFS freeze_super()
directly rather than gfs2_freeze_super()), or if a withdraw completes during
the msleep(1000) retry loop in gfs2_freeze_super() after the initial
gfs2_withdrawn(sdp) check above, won't freeze_super() succeed on the
withdrawn filesystem and leave s_writers locked? Should gfs2_freeze_fs()
check gfs2_withdrawn(sdp) outside the SDF_JOURNAL_LIVE check?

> @@ -767,6 +776,13 @@ static int gfs2_freeze_super(struct super_block *sb,=
 enum freeze_holder who,
>  			break;
>  		}
> =20
> +		/* Withdrawn meanwhile, don't take the freeze glock again. */
> +		if (gfs2_withdrawn(sdp)) {
> +			(void)thaw_super(sb, who, freeze_owner);
> +			error =3D -EIO;
> +			goto out;
> +		}
> +
>  		(void)gfs2_do_thaw(sdp, who, freeze_owner);

[Severity: High]
When gfs2_lock_fs_check_clean(sdp) fails in gfs2_freeze_super(), doesn't
calling gfs2_do_thaw() below re-initialize sdp->sd_freeze_gh while it is
already queued and holding sdp->sd_freeze_gl in LM_ST_SHARED mode?

Looking at gfs2_lock_fs_check_clean() in fs/gfs2/super.c, if it fails before
gfs2_freeze_unlock(sdp) it never drops the shared freeze glock, and if it
fails after gfs2_freeze_unlock(sdp) (for example, returning -EBUSY when a
journal is dirty or failing during a concurrent withdraw) it jumps to
relock_shared:

fs/gfs2/super.c:gfs2_lock_fs_check_clean() {
	...
	gfs2_freeze_unlock(sdp);

relock_shared:
	error2 =3D gfs2_freeze_lock_shared(sdp);
	gfs2_assert_withdraw(sdp, !error2);

out:
	while (!list_empty(&list)) {
	...
	return error;
}

When gfs2_lock_fs_check_clean() returns a non-zero error to
gfs2_freeze_super() without the filesystem having withdrawn,
sdp->sd_freeze_gh is already holding sdp->sd_freeze_gl in LM_ST_SHARED mode.
Calling gfs2_do_thaw(sdp, who, freeze_owner) then calls
gfs2_freeze_lock_shared(sdp) -> gfs2_glock_nq_init() a second time on
sdp->sd_freeze_gh:

  gfs2_do_thaw()
    -> gfs2_freeze_lock_shared()
      -> gfs2_glock_nq_init(sdp->sd_freeze_gl, ..., &sdp->sd_freeze_gh)
        -> __gfs2_holder_init()

In __gfs2_holder_init() in fs/gfs2/glock.c, INIT_LIST_HEAD(&gh->gh_list)
overwrites sdp->sd_freeze_gh.gh_list while it is still linked on
sdp->sd_freeze_gl->gl_holders, corrupting gl_holders, leaking the glock and
pid references, and triggering the recursive holder check in add_to_queue()
(or if a withdraw races between the gfs2_withdrawn(sdp) check in
gfs2_freeze_super() and gfs2_freeze_lock_shared() in gfs2_do_thaw(),
gfs2_holder_uninit() clears gh_gl =3D NULL while leaving the corrupted list
entry on gl_holders, and gfs2_do_thaw() now ignores the error).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D26

