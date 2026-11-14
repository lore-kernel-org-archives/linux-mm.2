Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDD8606A33D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJXRZ7UC
Received: by kanga.kvack.org (Postfix)
	id AEB4D6B05B9; Sat, 14 Nov 2026 07:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4DA36B05BA; Sat, 14 Nov 2026 07:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964966B05BB; Sat, 14 Nov 2026 07:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7BC6B05B9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00D29A03BC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:40 +0000 (UTC)
X-FDA: 85433590242.26.CB72013
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D11C140011
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:03:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJXRZ7UC;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794657819;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJvTxxxVKFSKaVy4VwipIwjtqqi4NX20dtdLW1nv+Hc=;
	b=fRDmYZFpdedDP8YQWVg0OnX44FknjgRdqadcKAucj7MsRReUba4Rnz28UsEVRf64TQ4EqR
	A6VZPromYDQcNS+HaRxE6NYUw3qUf+Ld2YXux3i811gemG1GGYlT1ROFZUfNlK0pCqxZ/c
	Ui+IwsLhy5VRlX9bjye9vphksf2KTYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794657819;
	b=dpVnESzF3ujHc6BDoe2qTrcTY3tP/wof0tzRfJzBe7JgJhhAJXKQVtkcTK9u2l73JHD3NE
	128q1AwBiWtfNo9gQb8lmovJL9xfjVcxBCNaQtEnq8Q0UqmIx5MBGJLYXxDvP+3i3f7iCP
	S2TA/mdpSkHCtYPRO7R1lTacmH58SJY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJXRZ7UC;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5EDE435E4;
	Sat, 14 Nov 2026 12:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA6C1F000C4;
	Sat, 14 Nov 2026 12:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657818;
	bh=VJvTxxxVKFSKaVy4VwipIwjtqqi4NX20dtdLW1nv+Hc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SJXRZ7UCCdy3QZyo+FxMDY7k8UIUGk6IYo89lBu3JfDwkdzTs3BZnWyGaCc/ULTNn
	 hTClA74WxBneCreuWBl8YFI8tBn7zxnnD9TXVlOMqnV+xQ6uV8PhP1S9SPwJ6ZTpSO
	 5zAHKao9moTQQgbLDO8sbnPffmS1wkAjk8AyR8QA7xbPlYrXri8uKa7QkpNcwLQwID
	 Wxo2z8l+5N6HHOqpdrXitXhs30JB45pi0jnIIoiIE1pk9b1JjFa/5wKPTdMicUZTzV
	 9CQoNePsc39FBbjGyiptDy9bf0aHlUaDlJQsHsyhfRni7RfJyClfhj54WdR0L/qJMM
	 FNvbQxj3FfiCg==
Message-ID: <sashiko-outbox-214468@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/33] ufs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-17-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-17-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:35 +0000
X-Stat-Signature: pfpy3it1r8xaxc9o7br9ezm8n19oif7j
X-Rspamd-Queue-Id: 5D11C140011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794657819-801904
X-HE-Meta: U2FsdGVkX1+PkiXPLK8CFqQbyYyze7vA5qDPyz8OuSExKbt1/7TbRMbIZkr6OojLUw4OZqhOnHaRgXe+HycvZ7BHqvscOE4oEOZyZX9HVQmyXdksHUnAkbRiS7cTdJ72ak+ckkblub0ETDzZlWFWB9fRb9Ld62649E+v3XNhnr6CAhkOBDfhQohBsP9tWgoBQ+3R1WIfv55GXuyFb/OIwm/Fc2TDnISqhEdlRAU6EJoXvc76ssNjq14cR8aIpQVwT7kwfN1a8bYFbV+lwdapYeWYuWqq2upqc5qAqbNEuABJgt76yGOGIgH3aty6pYjiOo06GiLJQBM3Eh17X+o07nEl9gyIT9i+8AZWKAot5//BEILkAYQ4j9RNHIT5kr++icRxQAVF8V7cx6azVs0Y2D/2gc46II5159yINE4EVTbCqigj2USR4j6rCnjP5n/c8MWHpLsvOBuHjBwVXveFNccCF8c+sJ2BThRvLBZbzLtXlhrCuxoUXreT9Cz9GClIsCJDEWbtQlTYcbOElUS4a0QQz3RMoJI1cYlFeJEuE97fK0I4+sBuDCqkeQNd3ZQnLVxLwmQbH5axzlNHjJg/Ngn2aUka9K/yxSaXO1KexhZ2YGsqJV3MAbtGL6oF8+EnKz1wSwndR5D9kOe4tom1HzG+wPwyQy8uune0UhabH1wClbY8GQhz5B4Jpf5DQjEyL1UsMIwXydTOUFOIa+9Eba8iY+kayAimoIo6lTeER5S8l8Sh4eq9/Z0yoo3nCJ8RM/OaOqn29i296HlFyeSZsDA2HZUmAXhC5fZOrTJkq2nUB0fMdyuxasKQldAXKxN8nnSGJyn0okG8OXqnV9ZfZuYyLLThQWsp3cw2XhCcoWPUGCmK0FrTsgdhAa6+f8PuE/dGHBraa4FD8CvwqZWYqX9WFyB22inJe9Eq3k2e69CcD36n0StP3qMAwEXvM0ULrfhp4v+buarXabWpNme
 1fr1Qka/
 qVst9Rnopu+0o3gifIgJYITygR89lztGRJHKHuevqyVEu9l5yDL/QhiluLKQLphsol3v1TWgiC8CQN2Lv0UI1BKavgIUciNm8/jMRuZIPI+OXTbQk2pKtyljeldB9/xDuM8ltxteUgGoV9gbezct79aMjMuo+03L8wDUxLwzHhT4eTlGMDc7br45PfcyttJ38TLscBMXQLHZ9dyTfVYUKW+DrIeKgfc8YRsDWdtwW964MjwvBWUQDs0UcxwH8P21t4nj0R8v+CrwC4mtbTOv8RJSDDePCxeVg6maruuxmCol1HAqI0CZO5yaOxBGhIaJ4WBILho6IodWl5hnmwT2o6cTPYyd+8EVLlyQv6HMyj9vbSUwJIaINA9mtn5jvizUxVermaS16ThOzmTIbptqHtqz3OsullJoxnvbId9RqDIlePF+ldHq9ICe0CjzHmh/wF8JwIXWSosnejdec06urNF4uh3eZ5nzeWJhmmDZ/Vs/WL8i4UQIpNd9SMsVb0e6nXtg38SOI2tgVuGF7XL7UT1GgaTMYg316Q+Ed4amoEs6iqMf2ch3VrQyia08gmvddjgTp4zUTyxNfdRwzaca/ySmGvXJb4FAEJTAr02bc+GuoEMFM+ueEI+1qUDbv0zJ+JOBpc8dm5Vj6HHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ufs: cylinder group leak and SB_RDONLY clear in
  ufs_reconfigure()
--

commit eaf412f5390fa6f1c30001040b118660141a9bd6
Author: Christian Brauner <brauner@kernel.org>

ufs: don't set SB_RDONLY after filesystem errors

This commit switches ufs_error() and ufs_panic() from setting SB_RDONLY to
calling sb_set_emergency_ro(), and keeps cylinder group structures allocated
across read-only remounts after an error so inode eviction can still use
them.

> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> index 3569ac92b065b..d82cf73360a79 100644
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c

[ ... ]

> @@ -1265,14 +1281,20 @@ static int ufs_reconfigure(struct fs_context *fc)
>  	 * fs was mouted as rw, remounting ro
>  	 */
>  	if (fc->sb_flags & SB_RDONLY) {
> -		ufs_put_super_internal(sb);
> -		usb1->fs_time =3D ufs_get_seconds(sb);
> -		if ((flags & UFS_ST_MASK) =3D=3D UFS_ST_SUN
> -		  || (flags & UFS_ST_MASK) =3D=3D UFS_ST_SUNOS
> -		  || (flags & UFS_ST_MASK) =3D=3D UFS_ST_SUNx86)=20
> -			ufs_set_fs_state(sb, usb1, usb3,
> -				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
> -		ubh_mark_buffer_dirty (USPI_UBH(uspi));
> +		/*
> +		 * After an error leave the superblock alone and keep the
> +		 * cylinder groups, evict still needs them.
> +		 */
> +		if (!sb_emergency_ro(sb)) {
> +			ufs_put_super_internal(sb);
> +			usb1->fs_time =3D ufs_get_seconds(sb);
> +			if ((flags & UFS_ST_MASK) =3D=3D UFS_ST_SUN
> +			  || (flags & UFS_ST_MASK) =3D=3D UFS_ST_SUNOS
> +			  || (flags & UFS_ST_MASK) =3D=3D UFS_ST_SUNx86)
> +				ufs_set_fs_state(sb, usb1, usb3,
> +					UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
> +			ubh_mark_buffer_dirty (USPI_UBH(uspi));
> +		}
>  		sb->s_flags |=3D SB_RDONLY;
>  	} else {
>  	/*

[Severity: Medium]
Can reconfiguring via fspick() after an error and a read-only remount
leak the retained cylinder group structures and clear SB_RDONLY?

When a read-write mount hits an error and is then remounted read-only,
this branch skips ufs_put_super_internal() so sbi->s_csp, sbi->s_ucg, and
sbi->s_ucpi stay allocated while SB_RDONLY is set on sb->s_flags.

If userspace then reconfigures the mount via fspick() and fsconfig()
without specifying ro or rw (for example, changing onerror=3D), fc->sb_flags
and fc->sb_flags_mask are both 0.  reconfigure_super() only rejects
sb_emergency_ro(sb) when SB_RDONLY is in fc->sb_flags_mask, and
ufs_reconfigure() checks (bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(=
sb)
without consulting fc->sb_flags_mask.  Execution then falls into the else
branch, where ufs_read_cylinder_structures() overwrites the existing
sbi->s_csp, sbi->s_ucg, and sbi->s_ucpi pointers (leaking memory and
buffer_heads) and clears SB_RDONLY from sb->s_flags.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D17

