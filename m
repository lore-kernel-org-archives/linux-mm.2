Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E37606A880
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8ZTGEn0
Received: by kanga.kvack.org (Postfix)
	id CE7B36B05B2; Sat, 14 Nov 2026 07:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98DB6B05B3; Sat, 14 Nov 2026 07:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3606B05B4; Sat, 14 Nov 2026 07:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 845FD6B05B2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0E621203A6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:27 +0000 (UTC)
X-FDA: 85433589654.22.1C68FAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 541F0140002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d8ZTGEn0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657806;
	b=lBDQ1a7bM7lq50UClhok4wHEXkQp55YyVE5FUrhIeD40tItR2Mq03JNX5C0U+N2/f6bq0l
	xkJ4HPcSQDRcI/ylXi3x940C5A8SWBmQB5MuzWKHZuA9kT2Cjw29HEfdi9O4imCebqni0k
	cBWL3RaG7c8njifvfZ6vYWbQZytZ3JA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657806;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALzGtljZmngZ99TYML6vyT57I3K5d0MlyVrwhGLF07s=;
	b=193YNrF2Svo/8Kd7Bp6WwIjM0DbPSibAqBtOWKLMh+A79jzXxCZvesoGWOv+zVNYNEFOpl
	Nkm3fSjZ/UCKjsWHsu7aQtUm/xJ4OEuCZbnIXgMRXJYKcQuKNSv943Sa8ctfmegLzNyoX3
	sK7z1Ia4QFOye4j4vpC9HZn6NY5fuvc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d8ZTGEn0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7CEB6232A;
	Sat, 14 Nov 2026 12:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89B21F000C4;
	Sat, 14 Nov 2026 12:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657805;
	bh=ALzGtljZmngZ99TYML6vyT57I3K5d0MlyVrwhGLF07s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d8ZTGEn0qxni0o2KqxTpTR9WvaZxwMw6wYgcu+OafMRCtiRzDVAXMU7/wZ74rgbDB
	 1LocND40CPQPdchDfZSgOlZusuV2b2Jm6PmSzxbXe+UtcgCZxhq7Cayx0Jg+WQs+5S
	 Fgn0yDEfY6VuTU6Kbg6xIhCMSNZtGpQHRSHQT7Ov+hnlN+QHxRE11/pIkaAJwpMSC3
	 85ZDbU7OiQ6CVDl/omSbOx09QyAE6AQk8ZxkNWDw19sm6FcfmyGeBCn4P7CMz0EUvA
	 NEqvQjJ0iP60FlMW/wnjotiw8rWjZFrDQALOU/tpxLhx8piKaT0N8cCt57zYhs9fOY
	 bSV/RrIKt+71g==
Message-ID: <sashiko-outbox-214456@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/33] fs: add a generic emergency read-only state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Jan
 Kara" <jack@suse.cz>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-5-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-5-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:24 +0000
X-Rspamd-Queue-Id: 541F0140002
X-Rspamd-Server: rspam12
X-Stat-Signature: fin5yokpapcik14tfsq5mdtda9fg84y8
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794657806-257111
X-HE-Meta: U2FsdGVkX1+wVdkjzxghKNSkjYGYdNC1WoiSc9H3pnnVrFJ6TG9C5wvSclUhTzL+ZUO949oGqfHXKV/RcgfOVpCcvix1jxXBsW0+gmfCAMSX2MrUoemD2QUDzJ9tVBRv610e++1qNUuoWSj1vbDBAzsOzFfOvQlusUd0YK8zRwtCeMfxVK6rTTYR2U0dQe5ywWpb5NpPgdiB9uDznaS7Ce/T/eLWTnpULTHNDhTzUUf+N63+KQRzHsWhzYlBOPcWa6OD6i5TzyLqFGMX3Jj9dKeemW0Zcu+orfITKyHGqSPz7BLN7JrIBuTtACGsKRjyBp9BY07DHiiYfBiaW4Id2LRwSPLfLB1CUFM2pkh0SlqW8zT3ZVTlwK1sgr6Re+M1VESk65KpPPgrmGspP/R0C9Niv5sAymx67PYn9yBAxhuvtQ4SdpE+9OiTBJcorblU+19E/djgXaAjLw1b9EE70remnbQl4jrMkccg1lSzpPFqq5lhQs0v/4SyIYcqVweMzaaBIIk6qRDZf0NKATsGAYPa8UTyPeFxePjPTOGqscY1gyt20Q00IP90enOkVl5hozFr1+FV02YrGT1bggyz8rumJabxF/IiGwtMlQxZt7E1qSp/MTqTo9Lm8Ol9GaeZpThLnG/DbgCLvUqN+tJzZHYLp8d6vcxIDHIWpT0VG2xXxEyx18uLe7t27q3mce5GmRy/N+EjuHqiK55bsS3v0DojQS16pal7U60swhaCJFm92B/Ezl1yK4uaS/0FzI4WXFbdfDmWZYoraASYmp2UABiR2qnOBn2On+2Bg0zPQDGXBF/PyC7yHvHOasXf+ra8MEqrUpQxBJ1JcEsYXnqZwKAV2JQDlWMR3tM+FZzzNzIHHKmLi8dz0Yr1nAONGVoYkZjtZGRGXrYxshbjaXZASr7rHgqda3/s6hANNtr4oG8+1dtjDoaYlclayYHlqjdpMMCK2Xy69pTj7lcld/W
 XZUaYsUC
 3/yXGoePzHe/juxXTXWjwHajFt+8YXR5cSTWOTjp4BlBMr+4goOodOrTQ4A3hU35v/H6ahCMlUDxwi6G7AYUibzadLeaIJ5j9hfjjv+XRBg/APNgjzs2P0gtGgDD2dLQrpVSTJR0mdoG/E7E4tGEEYXCCMIej6E/+w0h+uKJ/HfMzcqy1CsQw19J+krja2rO/JT9k0Tb2mXtNw4NNhL5PImZ9twPNuOFxT5920S+WxxNg/6UmVFyX5/Gn4QLBMl3txdyjlwzbMB60cEiAJ9rudHlNKtHav5eueDW7UAtrly3kaWIqfgpI633pchXITYrVz5pH3z8VJUOOMkumenISm/4k1JzedI/R14gyX4BL5/+M5GNBmF8oGq2GFrp7xIY6VTHy5Op3SMeWSowcYoQ0bV7GpWwank5xpX4F8GRFf3D7VKiRF2vtCIvvsMw7opapyoTUxSjZgMdcQDJO/tJxpQYLjpv6VC8Z18ZoKRKUnahdjQWJOpr/TVdX5zJ0hPI7oRiBv8NFV6It3Awjj9Qibak9EzR3dI+ifXAk4C1SCMa0H0SDrRiAvmmAw5oUwRHJ2qslfYrJc+ovZ0vmyVVpEWxAf4aX7lE4ITkn0gGDslkjOXq5LFMzvmzU1P9U26pWdyg0h1+BK0bMuqHkd4CVAoIxBYGV+herdY1fkx+d7AIiggFk5YznlPIhh8FYhO15LhU2C9gJcgtO9b3MIU73pe2pjHDIXkNunC7SDgIBT7AOOJM=
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
- [Medium] vfs: change_mount_ro_state() skips mnt_make_readonly() on
  sb_emergency_ro()
- [Low] quota: do_quotactl() misses sb_emergency_ro() in Q_XQUOTASYNC
  and Q_SYNC
--

commit aa167d356b416c1c40da72fb215b9d988cb411bc
Author: Christian Brauner <brauner@kernel.org>

fs: add a generic emergency read-only state

This commit adds an SB_STATE_EMERGENCY_RO superblock state flag and
updates VFS paths to reject modifications with -EROFS when a filesystem
switches to emergency read-only mode without setting SB_RDONLY.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index 9f6ec35c7b9cd..55fa09818ef90 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -396,7 +396,7 @@ static struct mount *alloc_vfsmnt(const char *name)
>   */
>  bool __mnt_is_readonly(const struct vfsmount *mnt)
>  {
> -	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb);
> +	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly_any(mnt->mnt_sb);
>  }
>  EXPORT_SYMBOL_GPL(__mnt_is_readonly);

[Severity: Medium]
Does changing __mnt_is_readonly() to check sb_rdonly_any() cause
change_mount_ro_state() to skip mnt_make_readonly() when sb_emergency_ro()
is set?

fs/namespace.c:change_mount_ro_state() {
	bool readonly_request =3D (mnt_flags & MNT_READONLY);

	if (readonly_request =3D=3D __mnt_is_readonly(&mnt->mnt))
		return 0;

	if (readonly_request)
		return mnt_make_readonly(mnt);
    ...
}

When a read-write mount has open writable files or active writers and the
filesystem enters SB_STATE_EMERGENCY_RO, a mount(2) call with
MS_REMOUNT | MS_BIND | MS_RDONLY (do_reconfigure_mnt()) sees
__mnt_is_readonly() =3D=3D true, skips mnt_make_readonly(), and sets
MNT_READONLY via set_mount_attributes() without calling
mnt_hold_writers().  If reconfigure_super() is later called to remount the
superblock read-only, sb_prepare_remount_readonly() skips mounts that
already have MNT_READONLY set and transitions the superblock to SB_RDONLY
while active writers remain on that mount.

[ ... ]

> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 33bacd7075800..b488fb1f9cc44 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -783,6 +783,19 @@ static int do_quotactl(struct super_block *sb, int t=
ype, int cmd, qid_t id,
>  	if (ret < 0)
>  		return ret;
> =20
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

[Severity: Low]
Should Q_XQUOTASYNC and Q_SYNC also be rejected here when
sb_emergency_ro(sb) is set (and quota_sync_one() guarded by
!sb_rdonly_any(sb))?

In do_quotactl(), Q_XQUOTASYNC still checks sb_rdonly(sb) instead of
sb_rdonly_any(sb), returning 0 rather than -EROFS in emergency read-only
mode:

fs/quota/quota.c:do_quotactl() {
    ...
	case Q_XQUOTASYNC:
		if (sb_rdonly(sb))
			return -EROFS;
		/* XFS quotas are fully coherent now, making this call a noop */
		return 0;
    ...
}

Q_SYNC and quota_sync_one() also call ->quota_sync() directly, relying on
dquot_quota_sync() rather than do_quotactl() to reject emergency read-only
superblocks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D5

