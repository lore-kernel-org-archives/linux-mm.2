Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 450E7606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acRLK16T
Received: by kanga.kvack.org (Postfix)
	id B3A926B05BF; Sat, 14 Nov 2026 07:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12076B05C0; Sat, 14 Nov 2026 07:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2DC6B05C1; Sat, 14 Nov 2026 07:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 605846B05BF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3A5D1403C5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:55 +0000 (UTC)
X-FDA: 85433590830.27.BB9E7D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C794180003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acRLK16T;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657834;
	b=Oo4n5AIn43GPyRPDBddsW4Vc/NUdPQStj+jXmQxhvo9RqQRoBzSDxEbyuvYgWF82MT2yxn
	DXKLqsXuf+ukLVjSLv3LQQUQjHrfmezD/xmRvh/0Th+KwvENpHK8LkqEUa1Q1IsOcYn8ON
	mivbJacJxlZasaU2pLEC+EsilFLVLrU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acRLK16T;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657834;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9QvBLMsaftQkNF5XqflyzTjEcAymvR21sTq1hGFR9U=;
	b=MHmI8my7hDFuv3C13J1SwScplX8ZwSkKKYJCwZYy8i++mqmmBk1wspdg1hr4403gzpHHGL
	uiAtmFNJHEYe5QnEs51PfT/QFDaoG7QX9Mv/D9r36nYBUm1VfDP6RtJjqCyGMsy071Ztxa
	qhgDXMz/TpJEcECnV1Lq9QOHfSuUfUE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCDF46232A;
	Sat, 14 Nov 2026 12:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DA11F000C5;
	Sat, 14 Nov 2026 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657833;
	bh=h9QvBLMsaftQkNF5XqflyzTjEcAymvR21sTq1hGFR9U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=acRLK16Tv5rVfr5zfeXkCS81IwZynV0Iu0o5OGc2HpX3/05hrjbueaWKLxLlYqLmO
	 z3W+PPmaM3U0hqso0XI+Ooq0RQyvBrwDBT11n9g9KSgX8ZhGVcIxnOI9fIOtTrhxxK
	 HjE1FgbCj1dbiTCHVsQhDOFs56nIgMByBpuhawWcso3hlxTf//5jcUYgwAaZ04rwjz
	 BdkAHdeW3WWvKJw7xI6KV+jY+dZQrvNHw7VEagMRPiDHtBYiWi45s6JmOMZp7SE9XB
	 WqfiGf81GveG6tD+O2sIN9n3nXaeikmtUkJNFdgDSm4yOjub0sItWiIhIB1G/G4u+I
	 3yjoHedFGAoMA==
Message-ID: <sashiko-outbox-214481@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 30/33] ubifs: don't set SB_RDONLY after errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:52 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2C794180003
X-Stat-Signature: i14kqk5s63wqups6tuiiu63k989xrxbn
X-Rspam-User: 
X-HE-Tag: 1794657833-383965
X-HE-Meta: U2FsdGVkX1+dg1MlsV7oVIbuCMRXe+d0TdRvGvdPoFfjQXTCTFvQhvuCx12GfLce5BuLceDKH6743uMKXPQ+e69KVhgqU526vQwvKaU8aWIWH2GdCW5zCALRXFLgII+obzsDpIW7nv+t+wZTNkbGdRTcPtR0HloK38amo7u6etly3ANfT2UAc7clDjOghlWfGcGOOw7BI3CTVroOVesA38D3hDxRhZR1W/iTw/1/881rit0cinNrSCyr4k5SNKSaLD7k0vq5fuORRh85oXowj1LF5MCf0izXaMQZNYlkkuGgg3cBYUpNnD3O/gsvZtocRxka+Nzd0tRkN8ms8ptNBzY5fHYtn0Ke9P1ikYPw7EmH0j1oyCfNHW27s4cs6rKlk622Kob/J2isYCJsKWJL5Lmc31iilieXrrL0LtIlP9Gp9vwmNj84zJjLWkkbGxG5KBG2Hj7skT4OOHcIZUQ7YAxymT3d2AWxoKQL5TqjmYpCx7Zj9SoFEGU9x0H+Qs4xUt1Xh2CeegW88w0Lh/10XlPeLomuuKeCc6ZMtC+ewRmTFikxuzr8tHx+rfIUNrY8Up69Lb85F2wPW5s7e/OKLjue4fBqQARtuaJwrzZ/ggxaUFTQ+4KmeZqj086iXVfc2rRg/Uho8mLO/cZXPqLKFaBIbkVgRAmnTcjMSuGmPLoK1nu2IssP6KkNPpum0x0jZLNrlknWQ/ygBQE0P4c1FtwTGnF3d7Icik7BYtYqIsJmCc7FddXRbbAn+PDcGA2wk+hPkOukvcpL+UKVQ/F5KGCQbATLXVgDipPU5WxuwO43wkkMYS19N8uSd557d00Sh8R5x88Lz8D8jFPs7DYOrttoLSV27ft51GJXRQ39e6w+xwgXNJ95kJNeEVuBlKrFcjWmr6rdYzrrafK1/XkbF1KjyWgXQw2O2xWHijncHnnMmtjrud8at0XHBg2DQWwv2YDwjrrnD8Ua2+K0ymf
 20/W7yRZ
 ztir9ICTsSoYarJR54Tuzh74lK1GIBVdSuK4SFds2JLCRLmVtlyMoKDLAizID5S+A3xdIBBrvA0/I6k9irvpdmj9Vit3wIIqxED4YGBdeHoCPlHYLV9ISbeAeM0U6Dy/qeGsG/XDo3dBizEyWXMFteTOnthvs/XNY6J56lTA92EP8ec9owEHA7ur96aIWoUeFnG7KZ/h+HiexpyZZ8dCWWqHHhc5F8Cz0yC7jX7FDK/UO8eUMZ0+5Tufs0rUK4dXi03krivWeJttVcBMzQYx5dYt/LuPekdYS3WxdCZ35AegRM0ypg7IJ4eOm3kk2OVC79XckTsnEN5mBXuF1T5gYuEKtlvcDpbqMzMXAg0jcmM77BS4wlMgAO6yI0ockUcWZF0iysLW1/VNF6hSb4JOyMtgDccSzX2blrjtPqg3zS/ACtF5I12Plc+qh+vsneGtC1WTN8EGAO3MjP3r3aI8BowHpn2y/JnOJ+WSPEtnFxPqAtFNaH8m4N1lDZbPJDhfmZvIBbdxMFngHM/OPxKM/tNFcP8CKUYMPdyZvvKXcgX9hj+FbF9/YWBPxPxwnz8xfkllndOVMRiVg+EEK82szwkOtIKmTJ+PXKGhJ8fVGWp8YOZUU6KTzNZUbLB1eo26uCFSMujuLAfaBc+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] ubifs: false space accounting error in ubifs_remount_ro()
  after error
- [Medium] ubifs: ubifs_fsync() trips !c->ro_mount assert after error
  remount
- [Medium] ubifs: race between in-flight writeback and
  ubifs_remount_ro() after error
--

commit fda6fbd307537dfd99ef75b3610022c5af4a9353
Author: Christian Brauner <brauner@kernel.org>

ubifs: don't set SB_RDONLY after errors

This commit switches ubifs_ro_mode() from setting SB_RDONLY directly on
s_flags to calling sb_set_emergency_ro(), allows remounting read-only after
an error, and drops dirty folios and inodes during writeback once
c->ro_error is set.

> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 38972786817e7..2d71274e89ad0 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
[ ... ]
> @@ -1839,19 +1846,26 @@ static void ubifs_remount_ro(struct ubifs_info *c)
> =20
>  	dbg_save_space_info(c);
> =20
> -	for (i =3D 0; i < c->jhead_cnt; i++) {
> -		err =3D ubifs_wbuf_sync(&c->jheads[i].wbuf);
> +	/* Like ubifs_put_super(), don't write anything after an error. */
> +	if (!c->ro_error) {
> +		for (i =3D 0; i < c->jhead_cnt; i++) {
> +			err =3D ubifs_wbuf_sync(&c->jheads[i].wbuf);
> +			if (err)
> +				ubifs_ro_mode(c, err);
> +		}
> +
> +		c->mst_node->flags &=3D ~cpu_to_le32(UBIFS_MST_DIRTY);
> +		c->mst_node->flags |=3D cpu_to_le32(UBIFS_MST_NO_ORPHS);
> +		c->mst_node->gc_lnum =3D cpu_to_le32(c->gc_lnum);
> +		err =3D ubifs_write_master(c);
>  		if (err)
>  			ubifs_ro_mode(c, err);
> +	} else {
> +		/* Syncing the write-buffers would have canceled them. */
> +		for (i =3D 0; i < c->jhead_cnt; i++)
> +			hrtimer_cancel(&c->jheads[i].wbuf.timer);
>  	}

[Severity: Medium]
Can an in-flight ubifs_fsync() trip the !c->ro_mount assertion in
ubifs_wbuf_sync_nolock() when racing with a read-only remount after an
error?

When c->ro_error is set, skipping ubifs_wbuf_sync() leaves wbuf->used and
wbuf->inodes[] populated while ubifs_remount_ro() sets c->ro_mount =3D 1.
Because vfs_fsync_range() does not hold s_umount or mnt_want_write(), an
fsync() on an inode whose node is already buffered in a wbuf (with no dirty
folios and ui->dirty =3D=3D 0) can interleave with ubifs_remount_ro():

CPU0                              CPU1
ubifs_fsync()
  if (c->ro_mount)
    return 0;
  file_write_and_wait_range()
  ubifs_write_inode() -> 0
                                  ubifs_remount_ro()
                                    hrtimer_cancel(&wbuf->timer)
                                    c->ro_mount =3D 1
  ubifs_sync_wbufs_by_inode()
    ubifs_wbuf_sync_nolock(wbuf)
      ubifs_assert(c, !c->ro_media && !c->ro_mount)
        <-- assertion failure

In ubifs_wbuf_sync_nolock(), the !c->ro_mount assertion runs before the
if (c->ro_error) return -EROFS check, causing a warning and stack dump (or
a panic when mounted with assert=3Dpanic).

> -
> -	c->mst_node->flags &=3D ~cpu_to_le32(UBIFS_MST_DIRTY);
> -	c->mst_node->flags |=3D cpu_to_le32(UBIFS_MST_NO_ORPHS);
> -	c->mst_node->gc_lnum =3D cpu_to_le32(c->gc_lnum);
> -	err =3D ubifs_write_master(c);
> -	if (err)
> -		ubifs_ro_mode(c, err);
> -
>  	vfree(c->orph_buf);
>  	c->orph_buf =3D NULL;
>  	kfree(c->write_reserve_buf);

[Severity: Medium]
Can ubifs_remount_ro() free c->write_reserve_buf and set c->ro_mount =3D 1
while an in-flight do_writepage() is still running?

Once ubifs_ro_mode() calls sb_set_emergency_ro(), sync_filesystem(sb) in
ubifs_reconfigure() returns immediately at sb_rdonly_any(sb) without
calling sync_inodes_sb() or waiting for in-flight writeback.  A writeback
caller that does not take mnt_want_write() or s_umount (such as
sync_file_range()) can pass the unlocked c->ro_error check in
do_writepage() just before an error occurs and then race with
ubifs_remount_ro():

CPU0                              CPU1
do_writepage()
  if (unlikely(c->ro_error))
  ubifs_jnl_write_data()
                                  ubifs_ro_mode()
                                    c->ro_error =3D 1
                                    sb_set_emergency_ro(sb)
                                  ubifs_reconfigure()
                                    sync_filesystem(sb) -> 0
                                    ubifs_remount_ro()
                                      kfree(c->write_reserve_buf)
                                      c->write_reserve_buf =3D NULL
                                      c->ro_mount =3D 1
    mutex_lock(&c->write_reserve_mutex)
    data =3D c->write_reserve_buf
    data->ch.node_type =3D ...
      <-- NULL dereference or use-after-free

Even when kmalloc() succeeds in ubifs_jnl_write_data(), make_reservation()
subsequently calls reserve_space(), tripping
ubifs_assert(c, !c->ro_media && !c->ro_mount).

> @@ -1977,10 +1991,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
>  		if (err)
>  			return err;
>  	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
> -		if (c->ro_error) {
> -			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
> -			return -EROFS;
> -		}
> +		/* After an error ubifs_remount_ro() can't write but still works. */
>  		ubifs_remount_ro(c);
>  	}

[Severity: Medium]
Should ubifs_remount_ro() skip dbg_save_space_info() and
dbg_check_space_info() when c->ro_error is set, as ubifs_put_super() and
the taken_empty_lebs check in ubifs_reconfigure() do?

Because sync_filesystem() is a no-op once sb_set_emergency_ro() is set,
dirty folios and dirty inodes remain pending during ubifs_remount_ro().
dbg_save_space_info() snapshots ubifs_get_free_space_nolock(), which
includes c->bi.data_growth and c->bi.dd_growth.  If a concurrent writeback
or folio release drops a dirty folio via do_writepage() or a dirty inode
via ubifs_write_inode() before dbg_check_space_info() runs at the end of
ubifs_remount_ro(), releasing that page or inode budget changes the
reported free space and causes dbg_check_space_info() to log a false "free
space changed" error and call dump_stack().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D30

