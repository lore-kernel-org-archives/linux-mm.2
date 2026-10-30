Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E55606A331
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0vb+QKs
Received: by kanga.kvack.org (Postfix)
	id A3DC66B05B9; Fri, 30 Oct 2026 12:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4566B05BA; Fri, 30 Oct 2026 12:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A696B05BB; Fri, 30 Oct 2026 12:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 555B86B05B9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:09:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B4E1407E7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:57 +0000 (UTC)
X-FDA: 85379778834.12.5945C48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4A0531C000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0vb+QKs;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376595;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/NlFSnNcldx9naDXGStLPpiwmKvzlTeOOk/gge3EPI=;
	b=1ARn/dqt5h1KEhKckL0NTfBwDJAXkIERKREtB3UMH2AgCTEkXfIC4U5sGeyiiW6O5vKl5t
	Is3oyoojjgsrUm6uu7KM8Ozz7Dwhz+4BwiVCDMBFkzvYhbk7Uu+k99lxueHNWhoQRfmwVD
	sGGinRYC/RBallDbPyQc5ohDmOSm0vM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376595;
	b=MTYVoxWerWKi/EfGYmX6piM3Yw89ol4dUOOAfmiRLh7s0UVIIG+w/4CZNLXfjBPD9CbSaL
	dvrJmnsj2jPax2kUVClCLrvHdxlFqIzWsSqe4pogxzLIWBXrCxz9Nn3CEp8xGaMpbXg//0
	Jhfu24VUN+zkfAwum2m92AGMlMuaDxM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0vb+QKs;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C546402BA;
	Fri, 30 Oct 2026 16:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFD41F00A17;
	Fri, 30 Oct 2026 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376594;
	bh=G/NlFSnNcldx9naDXGStLPpiwmKvzlTeOOk/gge3EPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0vb+QKsc0IfCurUZLqL1bXCL4/R5byO7UPcHRV5QGGJsKwXncsM9RFyYBy3fzkXd
	 FdIt7I8/c4kyHBMyx+WzDD4cFvakaVRlfmo+h/MfUVXnPumegsa4GttpC83jrDvxx6
	 ZoxohkjJWLK01b6m8c43ZltgssPNu3ZQu8ZOVj7UOiWfUFzg58iw4UIruyslgfhirt
	 YbOnPd6ULjJJiF0dUJLE9TxPkv1KDrpr52th/qSGVq3gfYBkVJjLF0dt/mV0KhRjsk
	 zSHCKLTNZ6vYq1vhtPLSrNcc6x6TN3ldQwLcgkR8qx/xN0+ZAGwc6MYM+mWhG4c8r8
	 6E/+TaSxXOhVw==
Message-ID: <sashiko-outbox-191226@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/34] fat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-7-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-7-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:53 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A0531C000D
X-Stat-Signature: khj416xqmtzfpozm75nu8ax7tk3eecam
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793376595-220810
X-HE-Meta: U2FsdGVkX1/YlZaXmcE4fdQltAgUJCN4xMV1ELNZ+4F2cfrLSK8IkaogK+pjtBtxB8WcROkjMEvW7CukNB+Sl8OdFLh40kxEM4m/slOswr7Rtzi21iqN0rcbgeQTmWqfNQReA3lqTGifrfi8cqcJpNPP9eTxp9Iqbn+s/oUhVKwuQatJNgSuF4vtDAvYoPa48jnT+yd9czlTo4Txt1J9d6aZxJOGHXcIeVqg5XMUMbXRRLvjXg4u7WIE3NGgKYNqH8JHBq1icC+3SgkGEQ2MB1m2rC9+NnGXxXZQwn6X6l5Hwh3xdy18WwFnrvUZH+hN3Aw8SlHvsAb9iuo2SBKlkIEKndK78pmt+gcN5qGnMp6zOvzbT/JqUd2tuMClVmb6FSZdawLRZJfjPSFpyqXqoOyVO+HWFO+zX/TYQ2DxlDG6SSbWkO320YRoPRTbj/y6li3KFsvFlUl6AXPN8ZGMFzdOglHiF1ExFR2aruCiCitfonA/4oT+7t3pFblNwOmxWiu+5s5ig0tyu/ag6Yu3oy1ZGp47iSjIp1Rtns0uFWhyT5IQzsYh6vKlz1/Iig2yK/RpWmCeNMwevIaI9KlcxiwKECyJSbntNCBrjuDg0zETx4KzNQU8m5cQFuZoeNugJy6VP4pl3AOm/sNkQoBbkvL54vj6NNUKBQkbyCPbCyajfW/6mzcYMKtlzJDg5pyg/UB+Dx5tj6MBkOifd6VQdiAfWkectoDXGacSBJtWECkU0Q+qNCUy1NIge0aSsj+ywmbxmNTW2tLb4p7OgaFCctNT3vE3jZ97S7wB1gKUHsd3ubUsDS+6FZ6w3Oqm5aLbyB4J09SW/wcdyUM6m4bE3Lzc9bQUqBv911mjCbcmcPwM8tZSF4wlW3w5vICCGiRz+p+RCqU2VTdbixuI3Cys6p8uCRUhcJPJVgD/e8xBBbPtxWNuA2S9Y5rI6grHiQqz5UsyhwkEmvD9g0JWQ+p
 UqeWSu+O
 UUBFmLjQN99mXVF2pze8dnfMJtLbqbNO1gVUVLyfP4CWuuruhQLsb57zaVjWlvuVnNJdlYh1Y8at11VdylYdqjhTuA4G6f9KINmcIhZCbBr5l+DIiEoEt7fxPF4+/tpWqHZkFZxrKaU/5Ypo/N/ErWVHmkhkfqd6c8757+RQ2EFVmSRsas/wsZzuKAQHQtZWiSIPM09V6JY9JoxYKi68xtp/TYPxA6oyVIisvrQORC4TwAIJ5+Bi0+trmTxnbjqqdiO/sTxW3D8X6lTmbheSTJKRBudJ5aKbGCfMV8k2JvKSswYRqZEbvmlKdoYjDhaIGIOPf1BoychrvlOgjGRdOOv2Cno6dsFfFodxhO2LGxKF8qFrqDrSLkYc0y3BfyDBVyUTJZTgwmhZtYbO4BOPUjVGgUtiAIFHRyuKZqJrr/rTVdGV67/Yz1Hey2o3j/RteVu8Jz73omM+eq9bA44FgHh4whLy2FTQ/hMnrl0pKJjbOEarfaRckeh/D+EcPXIYW1zQNQsR803g0uh4vbgjH7ndKIICvXG3Uwxw5wEtXQHz6XBeNn1x7dFE54yIQezdlMFTq3dGp3+Sjirzr0LSY2X0yuobj7seyiibxJqkE6HiK3f815k+zYnLHL287/YV21a/gr3VSTDgavGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] fat: fat_write_inode() refusal on emergency ro corrupts pending di=
r entries
--

commit 57e06a99b59c945df35624d543f51f3cdc78897d
Author: Christian Brauner <brauner@kernel.org>

fat: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY in __fat_fs_error() after SB_BORN wi=
th
sb_set_emergency_ro() so that thaw_super() does not leave s_writers locked =
if
an error occurs while the filesystem is frozen. It also adds
sb_emergency_ro() checks across FAT operations to reject further
modifications.

> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index d85c8fbdcca46..afd73dc4ba9a8 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c

[ ... ]

> @@ -954,6 +963,9 @@ static int fat_write_inode(struct inode *inode, struc=
t writeback_control *wbc)
>  {
>  	int err;
> =20
> +	if (unlikely(sb_emergency_ro(inode->i_sb)))
> +		return -EROFS;
> +
>  	if (inode->i_ino =3D=3D MSDOS_FSINFO_INO) {
>  		struct super_block *sb =3D inode->i_sb;
> =20
> @@ -1949,6 +1961,9 @@ int fat_flush_inodes(struct super_block *sb, struct=
 inode *i1, struct inode *i2)
>  		ret =3D writeback_inode(i2);
>  	if (!ret)
>  		ret =3D sync_blockdev_nowait(sb->s_bdev);
> +	/* The change is done, an error made us read-only in the meantime. */
> +	if (ret =3D=3D -EROFS && sb_emergency_ro(sb))
> +		ret =3D 0;
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(fat_flush_inodes);

[Severity: High]
Can rejecting fat_write_inode() when sb_emergency_ro() is set corrupt
on-disk directory entries when dirty block device buffer_heads are still
flushed to disk?

In FAT, an inode's starting cluster (i_logstart) and size (i_size) are stor=
ed
inside its msdos_dir_entry in sb->s_bdev buffer_heads and are only written =
to
that buffer_head by fat_write_inode() -> __fat_write_inode():

    raw_entry =3D &((struct msdos_dir_entry *) (bh->b_data))[offset];
    if (S_ISDIR(inode->i_mode))
        raw_entry->size =3D 0;
    else
        raw_entry->size =3D cpu_to_le32(inode->i_size);
    raw_entry->attr =3D fat_make_attrs(inode);
    fat_set_start(raw_entry, MSDOS_I(inode)->i_logstart);

During vfat_rename() and do_msdos_rename(), vfat_add_entry() or
msdos_add_entry() creates the target directory entry in new_dir's buffer_he=
ad
with cluster =3D 0 and size =3D 0 and marks that buffer_head dirty:

    err =3D msdos_add_entry(new_dir, new_name, is_dir, is_hid, 0,
                  &ts, &sinfo);
    if (err)
        goto out;
    new_i_pos =3D sinfo.i_pos;
    ...
    fat_detach(old_inode);
    fat_attach(old_inode, new_i_pos);
    ...
    mark_inode_dirty(old_inode);
    ...
    err =3D fat_remove_entries(old_dir, &old_sinfo);

Similarly, when a newly created file allocates its first cluster in
fat_chain_add() and updates i_size in fat_write_end(), the FAT and directory
buffer_heads are dirtied in sb->s_bdev while the directory entry still has
start =3D 0 and size =3D 0 until __fat_write_inode() updates it.

If fat_fs_error() sets sb_emergency_ro(sb) either during the operation (for
example, fat_add_entries() hitting "Odd directory size" or fat_chain_add()
hitting "clusters badly computed", both of which call fat_fs_error() and
still return 0) or before background inode writeback runs, fat_write_inode()
will now return -EROFS without updating the directory entry's start cluster
and size.

However, the dirty directory and FAT buffer_heads in sb->s_bdev are still
written out by bdev writeback, mmb_sync() in fat_evict_inode(), and
sync_blockdev() on unmount. Wouldn't that flush the deleted old directory
entry along with a new directory entry containing start =3D 0 and size =3D =
0,
losing the file or directory contents and orphaning its cluster chain?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D7

