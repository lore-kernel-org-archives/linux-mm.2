Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1554A606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z9kpMK2v
Received: by kanga.kvack.org (Postfix)
	id CC1D06B05BC; Sat, 14 Nov 2026 07:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A996B05BD; Sat, 14 Nov 2026 07:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12366B05BE; Sat, 14 Nov 2026 07:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78C2A6B05BC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF1CFA7F08
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:51 +0000 (UTC)
X-FDA: 85433590662.06.8D5E207
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A80740003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9kpMK2v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657830;
	b=O2jkFEsOMTNx7/sI2H7Nt2O7iJpQRXNWbnn0EgfaTUXrK9YrDd8ISFsgFNZBM6bB7o4iX3
	xyNpZ1XltymKStYnc0rJC4o6RctFjPYNeUOLVY0j9N+C1r/K0sGmxfErfLF5WrQA/PaLvO
	wZ1dRw7NxJ7OUAGvdCMb9LOyytk8i5U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657830;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cNpf83TDNUnfk8nTN2RZCY5xNHmz1XB5OVMQtWPcy4=;
	b=G2btaFJavJxnS/OX1E9NrYq7EHZjRcbnOZ2fNx6bV8suzMbJ7GdxqMIFsyIQsVNhnRzlrj
	iHTz8Am5CuvVdgDvlerPP6M2DEz/pd1gJ0Xp7yopQ6HelFNJlwiHBg17d2fQO6jc7jUn4l
	IBxHhUPjXRp4mjWNcZ48DfIYuL003sA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9kpMK2v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 000B56232A;
	Sat, 14 Nov 2026 12:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290A21F000C5;
	Sat, 14 Nov 2026 12:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657829;
	bh=9cNpf83TDNUnfk8nTN2RZCY5xNHmz1XB5OVMQtWPcy4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z9kpMK2vr/pVp2iNWYURY8dh/iimkz0Ia1et9sthC6M1MBJaQsDwXRUSwglxFmELm
	 rhi/1FAU8VuXaPq5wxlYsTBfb32WNnHvUE9n37itucz8C/s1XMJ9ESPaBJA8e6TwT1
	 NvW8CYR487VKk2EBACE2P/YEBYTDjG2kB1y1In6mC73iqAzjeLod4Ks8sUZ/EyClc6
	 5Ium761EssSaBlqaAUvj8BQJa85SJ2kg1xnpmJR+7NnrlwRdI53yHUwpVuPiD/GWDQ
	 K6lJRLJ1caDd+9Eh41NHAPcytnfX30ZhN3D+u5y09MO5qKWyBgi1c3oXulVewl6bgv
	 ToDQcETgKP/Nw==
Message-ID: <sashiko-outbox-214477@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 26/33] btrfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-26-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-26-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:48 +0000
X-Rspamd-Queue-Id: 5A80740003
X-Rspamd-Server: rspam12
X-Stat-Signature: prypwpwenrkoq37ir4emfffpp57mtgob
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794657830-552722
X-HE-Meta: U2FsdGVkX19bLqICPaP6E6z6HCc3zG/5ZFqDAJSi1rYEQxFgypxbALvwS3fcgb/Um+wW01c9fxRyjQUK+t8yfa9hageU2g3JXeJEcQ8xXbHAJHpwoaTmQH3PgzlVvjdtL2pwixNcV0CJbnYf07KtzVQX6FDjEkos4URtQLBszZr+jcBq3gJRnO8+No90V9pN78QkmVspQyHBure0f2xrdaZ9HgfQWh+p1614D4TUW9v+S9v0AWqArlML8fr2mrNSHdhhGM1bG59dboywKT+MIhg8huwnBclX4s/fHM7R+1i28TbyYKccNlQBAQEKTON/yL3tah2z/qAgkE1Km8Yjgj86JnL9i382qxBBEJaglvCxVqXIcIDlAQD7+j9dp+QhxaxQrzbD7Y3c7lQpe/m13SVRylNq2IcJGSesTpoKr9YJEg8OhIJwIRFsjDx/iygdOG8VEOLWYIR4HCON2Z4niFpq9h+R+Qy6eMJan7wszE/tjb409OJEggl1plrqb0MJlO+oUKtYvx9K8xnfNpbxVMl4ZmjXcBf9VtSe1nCyqKodAMu2GWWv13khwQ4oeCtUXEp4cpHVonLLAD/BSjRHM23JyR3iE0LGj5/j4Lq+ifQsQE5wfqwcPw3O2/eUByAXTBEh6o1fULxZ+/YIOM6TZj6iQwmiogqmaCxXTMtbq+aSgboQXv59Dj+DtySIY5LcflECYJBHUcRwTn/Pa7eiKNacbEOZrTaeLbpLonmdOmdIIPwb7r4yp//IInFOXozPDK8iPGHTue963fm+t3EPYho8g9JrQ5Um4XsJD75SSb020qP3RandP+NRBrKk/SjkPyN3ANcmN9O046f63BgoZaQ0mBLiru5pPVk5OJOBgt7EK9b+0b6seQum4pOFdCxlm437RQ61tQy5/WWsixZe3cj3faTqwWi1vPBxJ6YC8oUwlBXKYj+c1qzI+pWdUTc81PCw4zpeaC9vuw52wn4
 uou/Aa/C
 CuHHH+zfe+ahbekXQIQpvnzh31DA7wYyrdokyyuhTfdI7QfJEJm3FUl5uwNFUDWh1FRyDzrUUqax/v+pmhJVjHsISt1Ex18ef6ycsEnWWWwoNPQ3FRS7yAz6LbobhLkZQGIkkYwIRbO+YCtZhnK8nR9PWSo5As29gMiFAt2Zq875GL2UDD8+8W9V4er/0OpmtjZwIlBFxcQ2pRkmDbb7d3Yy74wSacTPmq8e3bp1Ns5I/J62bJuiXT3GwUHbUBw0dj/MIan0F5UieQPyW8kXGu9IRwrmPUYZ5TrHFXnc0sVBBQI9++gAdoOeF0muiOU3DZ5/PvJARSarrRbXwlqxp4peJB3TuUm6tzhh84Uz9CoSRs0eQIWlPsRU8rDNqOpOQMtEVOJK4DlvQ+E5E5oopy4lBk2FjaxZVcfFAb4kVZDXLa4zFoCjeiRUj+YxmltcWS82DWF9njIrKYoEh0+OGPGkapzLtZ0BK55d8woj+hmd4U/NlShSRzawSJY+O2E5HGYmGJx0c38QEQCxC/PXYFZaKP4ECpwLspStMjNx4gDpUF44UhQ4nxf1Wrulu9w7RP6raRWrfrz1OU+r+swGaAsDz+knMH/ZVrF2n7DIwVHk/5fvQltrXmKSWB7X6sFuxd6NwRmabyQzzD7C77Ck8ITKz5BKCQvDX5afH6Y2hzjVdfZLl8s6rM9jMoNeNyD9jC9U8on5bxU18pa342ZfnXaAD43ltUYAkGVFzF+b1hvUgNfur3G4JU5iHA/7BhZgE1g/TWjn0KkdBvLWbLc4k6pAxbb76DMTRt9DW
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
- [Medium] btrfs: btrfs_super_sync_fs() and btrfs_freeze() return 0 on
  shutdown or error
- [Medium] btrfs: race between BTRFS_FS_STATE_RO and
  sb_set_emergency_ro() on fs error
--

commit 3d297b218ce5c34d64ff204c632eaa6ac7a2526b
Author: Christian Brauner <brauner@kernel.org>

btrfs: don't set SB_RDONLY after filesystem errors

This commit stops setting SB_RDONLY in __btrfs_handle_fs_error(), using
BTRFS_FS_STATE_RO and sb_set_emergency_ro() instead, and updates shutdown,
remount, sync_fs, and freeze handling for the new read-only state.

> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 024c3ec7d0583..39fd1a04d25ba 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
[ ... ]
> @@ -1233,15 +1232,12 @@ static inline bool btrfs_is_shutdown(const struct=
 btrfs_fs_info *fs_info)
>  static inline void btrfs_force_shutdown(struct btrfs_fs_info *fs_info)
>  {
>  	/*
> -	 * Here we do not want to use handle_fs_error(), which will mark the fs
> -	 * read-only.
> -	 * Some call sites like shutdown ioctl will mark the fs shutdown when
> -	 * the fs is frozen. But thaw path will handle RO and RW fs
> -	 * differently.
> -	 *
> -	 * So here we only mark the fs error without flipping it RO.
> +	 * A shutdown isn't an error, so don't use btrfs_handle_fs_error().
> +	 * BTRFS_FS_STATE_RO doesn't touch SB_RDONLY, so it's fine while the
> +	 * filesystem is frozen, e.g. for the shutdown ioctl.
>  	 */
>  	WRITE_ONCE(fs_info->fs_error, -EIO);
> +	set_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
>  	if (!test_and_set_bit(BTRFS_FS_STATE_EMERGENCY_SHUTDOWN, &fs_info->fs_s=
tate)) {
>  		btrfs_crit(fs_info, "emergency shutdown");
>  		fserror_report_shutdown(fs_info->sb, GFP_KERNEL);
[ ... ]
> diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
> index cedca40508315..3a768e2ac1ccf 100644
> --- a/fs/btrfs/messages.c
> +++ b/fs/btrfs/messages.c
> @@ -173,8 +173,12 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *f=
s_info, const char *function
> =20
>  	btrfs_discard_stop(fs_info);
> =20
> -	/* Handle error by forcing the filesystem readonly. */
> -	btrfs_set_sb_rdonly(sb);
> +	/*
> +	 * Handle error by forcing the filesystem readonly. SB_RDONLY needs
> +	 * s_umount, see sb_set_emergency_ro().
> +	 */
> +	set_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
> +	sb_set_emergency_ro(sb);
>  	btrfs_info(fs_info, "forced readonly");

[Severity: Medium]
Can setting BTRFS_FS_STATE_RO before sb_set_emergency_ro(sb) let concurrent
callers observe btrfs_fs_rdonly() =3D=3D true while sb_emergency_ro(sb) is =
still
false?

set_bit() is a relaxed atomic operation and __btrfs_handle_fs_error() retur=
ns
early when btrfs_fs_rdonly(fs_info) is already set:

CPU0                                  CPU1
__btrfs_handle_fs_error()
  set_bit(BTRFS_FS_STATE_RO, ...)
                                      ksys_syncfs()
                                        sync_filesystem(sb)
                                          btrfs_super_sync_fs(sb, 1)
                                            if (btrfs_fs_rdonly(...))
                                              return 0;
                                        if (sb_emergency_ro(sb))
                                          /* still false, returns 0 */
  sb_set_emergency_ro(sb)

During this window, syncfs(2) and freeze_super() can see btrfs_fs_rdonly() =
=3D=3D
true in btrfs_super_sync_fs() and sb_emergency_ro(sb) =3D=3D false in the V=
FS, so
they return 0 without syncing instead of failing with -EROFS.  Similarly, a
second thread entering __btrfs_handle_fs_error() sees btrfs_fs_rdonly(fs_in=
fo)
and returns early to its caller before CPU0 sets SB_STATE_EMERGENCY_RO, so a
subsequent btrfs_ioctl_shutdown() or VFS call on CPU1 can still observe
sb_emergency_ro(sb) =3D=3D false.

> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b424cc836bd4a..ff61ec9ebfa79 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1041,6 +1041,18 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  	return btrfs_commit_transaction(trans);
>  }
> =20
> +/*
> + * Nothing can be committed after an error, don't fail syncfs(2) and fre=
ezing.
> + * BTRFS_IOC_SYNC calls btrfs_sync_fs() directly and still gets the erro=
r.
> + */
> +static int btrfs_super_sync_fs(struct super_block *sb, int wait)
> +{
> +	if (btrfs_fs_rdonly(btrfs_sb(sb)))
> +		return 0;
> +
> +	return btrfs_sync_fs(sb, wait);
> +}
[ ... ]
> @@ -2308,6 +2326,9 @@ static int btrfs_freeze(struct super_block *sb)
>  	struct btrfs_fs_info *fs_info =3D btrfs_sb(sb);
> =20
>  	set_bit(BTRFS_FS_FROZEN, &fs_info->flags);
> +	/* Nothing can be committed after an error. */
> +	if (btrfs_fs_rdonly(fs_info))
> +		return 0;
>  	/*
>  	 * We don't need a barrier here, we'll wait for any transaction that
>  	 * could be in progress on other threads (and do delayed iputs that

[Severity: Medium]
Does returning 0 when btrfs_fs_rdonly() is true cause syncfs(2) and
freeze_super() to succeed without flushing after a forced shutdown?

btrfs_force_shutdown() now sets BTRFS_FS_STATE_RO without calling
sb_set_emergency_ro(sb).  After BTRFS_IOC_SHUTDOWN with
BTRFS_SHUTDOWN_FLAGS_NOLOGFLUSH (or btrfs_shutdown()), dirty data and
transactions were not flushed, yet sb_emergency_ro(sb) and sb_rdonly(sb) are
both false.  Calling syncfs(2) or FIFREEZE then reaches btrfs_super_sync_fs=
()
and btrfs_freeze(), which see btrfs_fs_rdonly() =3D=3D true and return 0 in=
stead
of failing as btrfs_sync_fs() and btrfs_commit_current_transaction() did via
BTRFS_FS_ERROR(fs_info).

In addition, if an in-flight transaction aborts while freeze_super() is
waiting in sb_wait_write(sb, SB_FREEZE_FS) (after freeze_super() already
checked sb_emergency_ro(sb)), btrfs_freeze() now returns 0 and lets the fre=
eze
succeed on an errored filesystem.  The comment above btrfs_super_sync_fs()
also says not to fail syncfs(2) and freezing after an error, whereas the VFS
fails both with -EROFS when sb_emergency_ro(sb) is set.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D26

