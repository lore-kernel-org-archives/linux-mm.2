Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD908606A333
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5b0v7Xr
Received: by kanga.kvack.org (Postfix)
	id 40D296B05B3; Sat, 14 Nov 2026 07:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3972B6B05B4; Sat, 14 Nov 2026 07:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ACA56B05B5; Sat, 14 Nov 2026 07:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0463D6B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 807811A03B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:31 +0000 (UTC)
X-FDA: 85433589822.29.1857C3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D7E3340009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5b0v7Xr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657810;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oge5gHl+Ji7nKy/eL+dZMpu8kpivAdHNITu7sKlcjQc=;
	b=4udXFkhmHpulpT9j6BQosGU8QeNmXeReRZFsyw1GqurKMUx9iZgJ74/PS9ppBFeQwBZ+a+
	ZonAkkr69ZNUrwcfpOr9DJ4ZHNIm4qUZjdnPdTVmw+kn25bAvzudbTueZ3GELvqJguGITL
	7vOv08UzaPnzFpOckrvXO066MMThxNY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5b0v7Xr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657810;
	b=BKKnM7gCXt9b+/ujdkZgkoJSHrZAGh2StiwjhExDwuhRvx4glmPtATnltC6VeBIYOU3CvB
	EzpCu8NK46ITVe9cj8GM2WwO2EYaNov126Zxr6KVVOszeHfO7fljUlxr1N7iQzNiCsRMaQ
	HITR08xnjTTZakjNSvUC1r/h3KdZlqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E997626C1;
	Sat, 14 Nov 2026 12:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2781F000C5;
	Sat, 14 Nov 2026 12:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657809;
	bh=oge5gHl+Ji7nKy/eL+dZMpu8kpivAdHNITu7sKlcjQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O5b0v7XrzA1WELCmu12+3CEzgi7O2PA8wGWyXzNM6/DMm+jeSwo7oaNtTiwWqL9Sj
	 3gPK042ci68YlqI+D+3g0OaUg+cutVM9FqYrbRFcuHLaesVhmnq25vU/sNxGRAhl04
	 lHz0EGke2a+V5t/bAXS+qhZG7iJ4YwHUvUQpE9xRz7XS8V7QPJ0pGzJkjCB4lIFZsl
	 eTaJfqrZs41T2hNOMdzBWNdHHvd2P8ZNfSec5Wn6PxaFZqKE069wvpqaCaAwQ7Zfef
	 6SVzrh26YuobiR6IehubHAymqiV5REZJzZb4qBUlYCjtdsY7Rt+Ut+g8VLdhtdgAH+
	 Ox8ubwhXVfuug==
Message-ID: <sashiko-outbox-214460@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/33] fat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-9-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-9-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:28 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7E3340009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: td5qaxhgmmb9x5bxrpmcp8o1c5rnqhwo
X-HE-Tag: 1794657809-204447
X-HE-Meta: U2FsdGVkX18ItHdZBjCnpoNG4N98JDIEXTxBnzN73DBfVmWWGgm3A0lBoTbwbV5EqO+e4ICmRaTR47bfjGE7GAXl4IAhC56rPAGx8PgJ40JSaa4GeFk+wXhB8WBGnze0HePnGosxLN9qQS+HQjiVadMgCrnj9bGfEuNRF6hSx4ZNyRCi9D+iNoOi+Dif4i56+2RBjaXsQlQiQ8tmpmmdFFasY4Cu3T3eT65fumpIxoIVfWV9GNOUe6UvzlyublRMClx4xAmM2fj8CWfxlIB+aHLWVmEaOxaCHidZ8QIOfHFZADBnJbHmYkcfjkwuUI29Fhwq5rwUzSgtwrMPJ1kRAwPr/oeW+ySw15cprZObuOu4oo7vaeiOUJCJf2rUlvmANJ9k6a3wzMmqoI/faN7s2J8ueFtCk5SkfIZMbO7aAE1gzIJXNpztlddT86uOtJZLXv0olk9GXVbVlM+jHtRGmkaBl9GmrJLi1YMMtPrUSEdXCkcElist1KDeNTz8iKXd5liIjHEsvI6QA0U3qKqbUwEDQuRgmdEcXfp7WuZAc7MjLT91Ws15DwZ6P4jnOYWrp6S2yqqNW+ndvH5V/Jpvio8gS1ClcI9hq0d98tI0BvJ2gmbomKLf3FeXRgMVmpNf6LUNJzysMcMeNSh4vvfikuRy8B7MFwU58bgtxoI5fXpOn7un45IS/pouK0PEQIbqddIdCqECbG3KBNd8SsX6K7liwHvzCaWj+Zjg7tEpGRPuhteDIkYLxp1SVEPEf5C7TCg7gvTkYN/2nWCTG2SlQp7tBVo7mhzgV6/kB1bdjo/zVB+CnctgqHUVymZH4PqG4eOkhwt1WyfIe8uVeb7c9x2LN5fieSqGmTHKV8VZnwfyc8BOKKo4nl6ReAUePNDDDppGWONOg1y12GUAangftBTKpIax4A+Yxvmvu9Cs+DdKc4+Ash1fivixOWQz5CNqOAfxMEaYb76aBsw9dP0
 aeGpiPM0
 olVEDpPLs1l6hLtc4fsf51+76NWhs+EcBojzvZLUWwpv/e8b74/Z7+vfuMu64SKwsiG71t2fBCN5d/SgAX1y0oAwmCp5KhUD262NbBujJP3MXWYdbICTerV+ExHrmoa44PyIoIzhDooDaRdDoWMVAMJnxU20jaiJBv/RHUxrfIlzdH/MhL2/xWw0vrtgpIYe5doYbM6zFIVHJUfPGyEXrmFQDHSAO+lAVoKoLprClMoHuZBUxyOGXEbXY2wP0MhFOIOV7D5kqGd0lt28OojdUD8E1E+y7Z2S14fURYGRhCHE9YHCsb0xyJ8uFfWXf6kJKYpcijKhWGt3mt8otjOP0lQDSCP+OzveTY5HbuMHXuLIawY5hDu6GZ7IvAmynqECmwL5hMYmPf746DFT/jt45WEMvTpdPWcvxiTIx7Eg09RLmGfRuJMfQ+gcu7ATBuYVrPkYq012aQBBznUoZZi0enBOGI4Glq9/4nRRE4gJDqdMcG9aCEf9IuR+DH2c+FYBUPq0PJPHfzPP6z8ECajugb2uciOjrBLKcTThPLaifW2uqE751vXQYnPdDbZ3OoKVk/Xjt0viMEY18VAOldE/h1b16haH7W+2vvMFKjZNW9pnFzCcHm110/PRT90hhJqgD+K/R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] fat: fat_free() zeroes i_start on disk when
  fat_free_clusters() returns -EROFS
- [Medium] fat: directory modifications proceed after fat__get_entry()
  sets emergency RO
--

commit 7ce00aaef1e345a2ca01443ccff3c19884d9bcc3
Author: Christian Brauner <brauner@kernel.org>

fat: don't set SB_RDONLY after filesystem errors

This commit switches __fat_fs_error() from setting SB_RDONLY on a mounted
superblock to calling sb_set_emergency_ro(), and adds sb_emergency_ro()
checks across FAT write, allocation, and state paths.

> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 35bdb62944a2e..553034bcbed40 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -1329,6 +1329,9 @@ int fat_add_entries(struct inode *dir, void *slots,=
 int nr_slots,
>  	loff_t pos;
>  	bool saw_eod;
> =20
> +	if (unlikely(sb_emergency_ro(sb)))
> +		return -EROFS;
> +
>  	sinfo->nr_slots =3D nr_slots;
> =20
>  	/* First stage: search free directory entries */

[Severity: Medium]
Can fat_add_entries() and fat_dir_empty() still modify directory buffers
after a FAT error in fat__get_entry() sets SB_STATE_EMERGENCY_RO?

In fat__get_entry(), a fat_bmap() error calls fat_fs_error(), sets
sb_emergency_ro(sb), and returns -1 just like normal EOF.  In
fat_add_entries(), if the fat_get_entry() loop hits a FAT error on a later
cluster after collecting some free slots (0 < free_slots < nr_slots), it
falls through to found:, writes the partial slots into bhs[], fails in
fat_add_new_entries() -> fat_alloc_clusters() with -EROFS, and then
overwrites the original slots (including 0x00 end-of-directory markers)
with DELETED_FLAG in __fat_remove_entries().

Similarly, in fat_dir_empty(), a -1 return from fat_get_short_entry() after
a FAT error makes a corrupted non-empty directory appear empty (return 0),
and because neither fat_dir_empty() nor fat_remove_entries() checks
sb_emergency_ro(sb), rmdir and rename proceed to delete the directory entry
on disk after the filesystem has entered emergency read-only mode.

> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
> index 2d10a815a5797..9e4bb0140320f 100644
> --- a/fs/fat/fatent.c
> +++ b/fs/fat/fatent.c

[ ... ]

> @@ -620,6 +626,9 @@ int fat_free_clusters(struct inode *inode, int cluste=
r)
>  	int i, err, nr_bhs;
>  	int first_cl =3D cluster, dirty_fsinfo =3D 0;
> =20
> +	if (unlikely(sb_emergency_ro(sb)))
> +		return -EROFS;
> +
>  	nr_bhs =3D 0;
>  	fatent_init(&fatent);
>  	lock_fat(sbi);

[Severity: Medium]
Does returning -EROFS from fat_free_clusters() without guarding fat_free()
cause fat_free() to zero i_start on disk while leaving the cluster chain
allocated in the FAT?

When cont_write_begin() fails due to a FAT error that sets
sb_emergency_ro(sb) (for example on a 0-byte file with fallocated clusters,
or after allocating the first cluster of a multi-cluster write),
fat_write_begin() calls fat_write_failed() -> fat_truncate_blocks(inode, 0)
-> fat_free(inode, 0):

fs/fat/file.c:fat_free() {
    ...
	if (!skip) {
		MSDOS_I(inode)->i_start =3D 0;
		MSDOS_I(inode)->i_logstart =3D 0;
	}
	MSDOS_I(inode)->i_attrs |=3D ATTR_ARCH;
	fat_truncate_time(inode, NULL, FAT_UPDATE_CMTIME);
	mark_inode_dirty(inode);
    ...
	inode->i_blocks =3D skip << (MSDOS_SB(sb)->cluster_bits - 9);

	/* Freeing the remained cluster chain */
	return fat_free_clusters(inode, free_start);
}

Because fat_free() clears i_start and marks the inode dirty before
fat_free_clusters() returns -EROFS, and fat_write_inode() stays active in
emergency read-only mode, writeback writes start =3D 0 to the directory ent=
ry
on disk and orphans the allocated clusters in the FAT.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D9

