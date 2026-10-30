Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DB2606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D/AqvhRZ
Received: by kanga.kvack.org (Postfix)
	id 81BD96B05C2; Fri, 30 Oct 2026 12:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F076B05C3; Fri, 30 Oct 2026 12:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646F06B05C4; Fri, 30 Oct 2026 12:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE9C6B05C2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:10:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FAD2160453
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:12 +0000 (UTC)
X-FDA: 85379779464.16.7220151
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06BEB140011
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/AqvhRZ";
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376611;
	b=2QNJPlBckzQMxU2unVYCc5akf61mTYcamxPv2kTvg6XjRhDgn+3ZQaHCEouLiiMwFHkZ8T
	IhsKkH7LyAHnyfs3xZQkPzwIJjKk/X6hudJ2UGQovaAXspaCKS6jvCxulTZV23mVHUsTwx
	F43SgDbaFkZA2UbDtl2jNhDf8+AWCd8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/AqvhRZ";
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376611;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlBJcG/mHzd+bSxyJ7Hr/XNLqvI/KNeShi4TWVGpRMA=;
	b=tJCgay5aJbok0wdWubpPvjG59LSk+oJ6H7K7QgzR3O8b7kHBjSm9R+mcD0OjzLTG/PzrHU
	RCOUV4GgZt9Jg/ELUo3a+br0/ShFzu5Ghvr0SIO5fkY37IojjeR2IkR2Gu6OTFPmeAj0kb
	As0finyfgYKxpz8F1SzDgXDVXYRDeLw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 548494229B;
	Fri, 30 Oct 2026 16:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966A51F0093A;
	Fri, 30 Oct 2026 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376610;
	bh=BlBJcG/mHzd+bSxyJ7Hr/XNLqvI/KNeShi4TWVGpRMA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D/AqvhRZy53z7cDhKwZsVvsyi75Y3cw4TMDVGVoQyGakjk6/Hsm81UrhNUKh8lpK8
	 9OBUprIEhacNJzUARTORbGE8nzZsXavQX5moSmXeTaHTkZg0biGi+Jqq1vzQ8hIp4Q
	 bZlIsaZimYR4kXUhi/DFZdAeGfQyf7aGvF73AiCDRIfGSsxgPHES329JutGW2yHMQ8
	 KW1CL+7VGZz7YAhF+HvmS3M2JC3WSkhoL0cTp/XUbv0QHMXiYciLVrdqjqlmmgFBfx
	 asrcDTboC/2rlsxegb+2YSDO8Mpp5zJoUWSQ9JVOWz/a8Y25DSqzSsW/oCD+/WLFCZ
	 r5eLPGGx33uZA==
Message-ID: <sashiko-outbox-191244@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 25/34] gfs2: wait for a pending withdraw before
 remounting read-only
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-25-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-25-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:09 +0000
X-Stat-Signature: h3cmnayxsxf36hrdf97tgfja5owhzxeq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06BEB140011
X-Rspam-User: 
X-HE-Tag: 1793376610-894553
X-HE-Meta: U2FsdGVkX19ok/wuowyGFB1P1lNcJvjWpsXqrejrlhhxH+eTf+gHA6abVQZOsR5eO61z2kLJHu8n31AbWaoQt0elcgfjIaGlGsoV3slbfeIhEciC10QwG9eT9bJWdHZVQB5uBQyzn0VquIH8njzs+VlwV1eRqfQZNSipRqzJ1rkA8aGhI+i52IOMh/4BsegkNOSyMkJxJOiHnKpwJxNRBfq8sl1s3Btbj0Sc2Npwfnw9KY6NJ/D1cRg3849fAGQY7a6VmGWgncySxwph77aLkAKT7EWKi2XKhLDmjA0rGnKS/lP1rkqx6nrs4dJCNQ+qfZv2kGZdPdkchv6M2QTUD7G8MRv+kXrs9zwTGVyshM5TEceYtGwPoUHWmNrY7T5sQEWUVEIvrn7JfWDILVRupdN+Itpqux916AOASgzGaHm7WqMDjo6TnF3kSNwNuAIGDM1rFUizy8FjSdv3uSc2Fu8KTeDRsyEH1/8fW+QlKZjHxkVkf9PCp6AUjr6gUnZVizZnlSSmw9Nlf5DX58rC/fe3cKTFR62fPE1rD0BSpFk57ZeNwhtV+dO0Fpc8D+io/FpuRmtjOhITQx0WOLGqA48PQ6Y5rEVkS60XqzO2BaWFSXB5TMAv8SLXVesmPsXBzeJZkOa8TGxBkLh31N3ijBwAnAc80o6nHomvh7ZRP7bnkdbCV3pnhfe5yLMN8xLWQFVif4gnq0DeUrJp8BO8PiHCsLiW5/BI9fCr+pb4UZoilSpD94zYfKIHtLjAbK/qdArDKfpkJSCnGSlmA8dT5YsOM5oQHubbV2n4PyzK+/f+yRuHBVqfX8yRyUcBbpKxIIWsqhDw+su5DPxUn247/PvOnzJMxo9aJlq6dvL+tH2vKA++sYeCdMa8KsodBuNwzbdieBWGbwhmbuI58Nm8/P+skRUrbvmlHoDZYPh/g3WEvGINUvV4lWvY9NK2BUeEOtMuz1BJATehxBeIkE1
 5JkIJD1f
 jSzDWZGKwMO1d2LYnHJauOdWYF5+HBwZFgJ6XtQP58mB5fc5jgE/JmavabppECSJdP0NgQPwMJp1PoVWPF1vOIqJfXDFwYg9RGTPlf35neZcIGTV9F7eGTZBBeUBcygTv9wUfEJHSlfFbStlXorGh2DBIp1vBRNPRa7Buow4R4NRLoMMECWWq/ASMCVNzl/J7C2tj/vViF+Tcd9jPxlroyBaOkCy9YQcQHZ1vmhj9BPghW1oEc5Xf5DPqUOgzKCToXQRReLjVTFgpEye3a4uw3qhBK5MH76QYyVPr8ZKi0U+10aw/u2WrPptWIAmM4XKsjWlrjitPj8UnkbzPz2OFu+eTg06oVB5aKKSxTMsZct0jTZpkSciqBvWkU7aXwp7t8l65WjOrYad3fm2kPNkXD9rJc8n1iyc12KHxrgxS+IyI///rpWMs0jCBapYTBRjrLt4NSRcWoituXCRyNWkuT5CEwLCg0aBMd4ZjVYZ4BHtVtj4g8AS7W/Q44fqS7SM6tE5F+04Lpt2aZTE+Ty1JsVQqIPU1L3QFizow7weqlqR8TFXjWCPgM8GFhiwy5mb5EdC+K+xWHi0nWPO1xOrmtL1Qpg==
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
- [High] gfs2: hang in gfs2_make_fs_ro() if withdraw occurs before SB_BORN
--

commit 4dbc43efc316d1e6209f721b5c7c0e13b2e81f95
Author: Christian Brauner <brauner@kernel.org>

gfs2: wait for a pending withdraw before remounting read-only

This commit fixes a race between asynchronous filesystem withdraw and
read-only remount by synchronizing SDF_JOURNAL_LIVE under sd_log_flush_lock=
 in
gfs2_make_fs_rw(), waking waiters when do_withdraw() clears SDF_JOURNAL_LIV=
E,
and waiting for SDF_JOURNAL_LIVE to clear in gfs2_make_fs_ro() before calli=
ng
gfs2_quota_cleanup().

> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index 04bb4cf787d4d..f61c309368ef1 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -146,12 +146,21 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
>  	}
> =20
>  	error =3D gfs2_quota_init(sdp);
> -	if (!error && gfs2_withdrawn(sdp)) {
> -		gfs2_quota_cleanup(sdp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Check for a withdraw under the lock do_withdraw() holds while it
> +	 * takes a live journal down, so one of them sees the other.
> +	 */
> +	down_write(&sdp->sd_log_flush_lock);
> +	if (gfs2_withdrawn(sdp))
>  		error =3D -EIO;
> -	}
> -	if (!error)
> +	else
>  		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> +	up_write(&sdp->sd_log_flush_lock);
> +	if (error)
> +		gfs2_quota_cleanup(sdp);
>  	return error;
>  }
> =20
> @@ -567,6 +576,9 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
>  				   HZ * 5);
>  		gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
>  	}
> +	/* A withdraw that do_withdraw() didn't finish yet leaves it live. */
> +	if (!test_bit(SDF_NORECOVERY, &sdp->sd_flags))
> +		wait_on_bit(&sdp->sd_flags, SDF_JOURNAL_LIVE, TASK_UNINTERRUPTIBLE);

[Severity: High]
Can wait_on_bit() in gfs2_make_fs_ro() hang forever in TASK_UNINTERRUPTIBLE
if a withdraw happens after gfs2_make_fs_rw() sets SDF_JOURNAL_LIVE during
mount, but before vfs_get_tree() sets SB_BORN?

During a read-write mount, vfs_get_tree() calls gfs2_get_tree() ->
get_tree_bdev_flags() -> gfs2_fill_super() before setting SB_BORN on
sb->s_flags. Inside gfs2_fill_super(), sysfs and the daemon threads are
started before gfs2_make_fs_rw() is called:

fs/gfs2/ops_fstype.c:gfs2_fill_super() {
	...
	if (!sb_rdonly(sb))
		error =3D gfs2_make_fs_rw(sdp);

	if (error) {
		gfs2_freeze_unlock(sdp);
		fs_err(sdp, "can't make FS RW: %d\n", error);
		goto fail_per_node;
	}
	gfs2_glock_dq_uninit(&mount_gh);
	gfs2_online_uevent(sdp);
	return 0;
}

Once gfs2_make_fs_rw() sets SDF_JOURNAL_LIVE under sd_log_flush_lock, there
is still a window before vfs_get_tree() sets SB_BORN where gfs2_logd,
gfs2_quotad, glock workqueues, or sysfs can trigger gfs2_withdraw().

In gfs2_withdraw(), SDF_WITHDRAWN is set, and then it returns early without
queuing sd_withdraw_work because SB_BORN is not yet set:

fs/gfs2/util.c:gfs2_withdraw() {
	...
		if (test_and_set_bit(SDF_WITHDRAWN, &sdp->sd_flags))
			return;

		dump_stack();
		/*
		 * There is no need to withdraw when the superblock hasn't been
		 * fully initialized, yet.
		 */
		if (!(sdp->sd_vfs->s_flags & SB_BORN))
			return;
		fs_err(sdp, "about to withdraw this file system\n");
		schedule_work(&sdp->sd_withdraw_work);
	...
}

Because SDF_WITHDRAWN is already set, no later gfs2_withdraw() call can
queue sd_withdraw_work, and gfs2_fill_super() returns 0 with both
SDF_WITHDRAWN and SDF_JOURNAL_LIVE set while do_withdraw() never runs.

If the filesystem is subsequently remounted read-only via
gfs2_reconfigure() -> gfs2_make_fs_ro(), gfs2_log_flush() bails out early on
the withdrawn filesystem without clearing SDF_JOURNAL_LIVE, leaving
wait_on_bit() in gfs2_make_fs_ro() sleeping forever while holding
sb->s_umount.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D25

