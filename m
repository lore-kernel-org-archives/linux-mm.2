Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7500A60A2601
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lTf12mwh
Received: by kanga.kvack.org (Postfix)
	id 5F8716B05BB; Fri, 30 Oct 2026 12:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5836E6B05BD; Fri, 30 Oct 2026 12:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A8C6B05BE; Fri, 30 Oct 2026 12:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18B036B05BB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:10:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 501BD40592
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:55 +0000 (UTC)
X-FDA: 85379778750.21.5C6A241
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B1E9C14000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTf12mwh;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376593;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dFc8Ot80oApMbDR2tgbKCiRs0Ur7pPi8cDZxbTcx58=;
	b=0VMIvHjqniU665yuwvKQqL0/Jj0FQ57A8yP+AcuG95+pomb8rZP5kxYHFx9y6+/4lnXgD9
	gGoONbJVRmHZLLttFvto47VJ9QZEIcSeXRCupyiNXDiXAluhBVXtDpgaiMCiTrpma+3WPU
	zYKiUsjN9uluJuF8g00KEW8oel+JYFI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376593;
	b=OdaitDwSZSdNkRg+OCRKwrbqBHz0EkJJi4WC1EZ3xidrRRSJGukTRobvJTSs9dqpERXi+y
	x27kN4hCYv7ec3KUSXH8tg7JqxHReoPLH7J2pkSM1L35iAWi0rLcZmDolXS0u3YSs+UHrT
	2sPNznMoEYHuh1fcuf51NedwG25BaJw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTf12mwh;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B79260617;
	Fri, 30 Oct 2026 16:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6618E1F00A1E;
	Fri, 30 Oct 2026 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376593;
	bh=2dFc8Ot80oApMbDR2tgbKCiRs0Ur7pPi8cDZxbTcx58=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lTf12mwhklBjlUqb3cRkM5KDg5S3wMQNXUK8Ps1PQrb4lDrPs+8SUUbNfVM9k60go
	 sq33nmWdNJP2/ooVyv/A8JtR7SqRH1xaFrIb1wTwPo6tno8R1kmwlWzPOuOQO/Wb36
	 OQY6IWhqk7dvfdBO1gkPftxQ7EYxAYANZe7W/+pTCbn5N4f7GprOcmdd+PU1OuXero
	 I3kdHZd+ycOzNZzOm6wuypLOO/3NkhATjsTlOiNSsaojyULc7J7O95lp2mt2K1FBC9
	 AOyCAtn5x2auHrMhdvw/Z7ZVbCv6dUGswZKj0CubKY1dOwMHIwIGzJXqAoIISsFj0c
	 FMOYsOZHnc1Pw==
Message-ID: <sashiko-outbox-191225@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Karl
 Mehltretter" <kmehltretter@gmail.com>, "Ryusuke Konishi" <konishi.ryusuke@gmail.com>, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:52 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1E9C14000B
X-Stat-Signature: mz7yh7addb4fgsykhhswbgufopduu8qz
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793376593-294588
X-HE-Meta: U2FsdGVkX185SkNG67JpsD5XanR5K38kYq2WEon1kI0ElrnoPyKHvWMcKYR+8fX/nQIkJWm9aBwSNR5cHAXlC8RYFlh2KfBgCFL3lNEOepf0JxppYjlcRNooblaB3cLtSm+2KyMN2JodJMo1Gu8eEyJP81CqRKTpaxN0BdAl13yzKzVNgqfoE1j0hsmc4M/eMmSNeV6DUCYp79fxjZnDJBuzGo2Q7QxuIw2GyggsRJp8tTw48O5ith12NsnRBeiBth6WBogpRw9R6ARg/WWMBCQDgOz6Egzjc+RasHSiK0sZ4+0hvEw6WgLj1Bsv+YxFyq5KYLEfi0m7k5qPxbJJH/bpPtx4TQKJp26wDac43He9KgEtDOcU0yhJrNSUlKR6SL1EXP9y0uSp62ws5wM98Z6BfbQLSkdDWmmdsGAMh24KKPfDoduTo1fm3kDCad9ruOsSioYq5CDqvYLJ8SueOn7F48nIh/Izcae5arMzsDmCXQIKa1Lj2b41GLMjzymGRqCcMIXJeEM0HCRrONznSCOh0wh8JeKmji1r40il4QwOFBN+7GK4wSggVnIDFqrFcVeGMAkiGsoD7pnl8yjtZvzKtehKqrS3H/btYDmRi3ZPT+ev/HpDtxzuEKpNaLR+j74/mcS9hG4gKWh3C1Epngmj1yvNX5/2tw12H9KE+A8Z7oDQQD7hdgH2fLVppB4GHeXAe/SIknQYkfpL5XYyVvUYwJ0zk+xBE9l5OgB2cYGYXQjao8JLw+iEApQpptpeTzSnRYefgyYI656jhfNWPA6vlwBwOK9fTKZ1aZm1u55Sp5RCjTt1hLCFDQ99Z8h4ckhN4//NJwL0tgtIMywgwclI43txfNuIwhJT6GfKJr+tmQ0poH9tFfZkmOYDYfZ6yXISPiEav+S20/1fOPPnLohjGy8Xk9pui1DG62hO0pD/xnLtkDu+2rjZLQnU9HPSyWgWtI56gUxAudLSR6N
 SNGwhlmk
 cA8bXygOXWmw09rPp7oCo/H5vJkvumHxMGamTvdqE0jgD7yxU4LYfcI0aHq5e5W4/BXWcvT+JHl12x1rrXCQO1LBSz9RgNaxU4XBkbKM5cDfktpY3hO64ePE9cxpKFkc+3W8GDXYFMYt+QD7JU3uV5wrC3cLrGybl/W+5eW7naSg0bHfiIDoWkOG81nLClQbJTl0gFn/I6qgt7DfoGDsBks+u+0icMQ7IOyuvlDqzDoTtV8BRyP8+C9ciTAyvEVO96BVJAyhMflwdPbZGcOvnlgaMIxirQ+3a7b1cWKppqnAwZ4tbXaM1rlU6nYRRcgbiwHbmq2hBv7w5MpWO71zJ6l0FMBEqjvDcD7WTvgEMLbsW2hz4mDJjm0ElEv0xBcWm5WECSYP0EsRvlThp4BmrJOA4+UvlcwCp1E9fxoYsuP6YP2pr/6CQ3rYF4hMzHZVCCXF17bebucezmPqw6NpRhIKpyZdUSTXnAFLT2FzzI2eDKjfhZEqrQuJ/FbjmAte0OFFCPezmb1NrT7dkp5gnIXmk429/fE8qBQIfLwebS4RswWAU0Q4k0gxpqDw2XnDYRrXtQpxMKz5dbyJSvcnebUgJ3UWWPSRh5lwKXGzRWu3kADRwtac/7bBv2TkOEf6cz2SMviVdjKvfaNxdnkG0LEYkZg7CeCZgMrFKLFNIJWiTpZ20z+70N6KT4tK2mDXwN9QR+virpHPbobrtLuMsWZVB6w+jPzohJX5HZmm/2E160mE=
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
- [Medium] nilfs2: nilfs_reconfigure() and nilfs_get_tree() bypass sb_emerg=
ency_ro()
--

commit ff163f1297bca8964f03776869c3a8bc9e3c38ba
Author: Christian Brauner <brauner@kernel.org>

nilfs2: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY in __nilfs_error() with
sb_set_emergency_ro() and introduces nilfs_sb_rdonly() to guard write paths
after filesystem errors without taking s_umount.

Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com

> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 2e3b591c117c9..edb7d379ecbdf 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -137,12 +137,13 @@ void __nilfs_error(struct super_block *sb, const ch=
ar *function,
> =20
>  	va_end(args);
> =20
> -	if (!sb_rdonly(sb)) {
> +	if (!nilfs_sb_rdonly(sb)) {
>  		nilfs_set_error(sb);
> =20
>  		if (nilfs_test_opt(nilfs, ERRORS_RO)) {
>  			printk(KERN_CRIT "Remounting filesystem read-only\n");
> -			sb->s_flags |=3D SB_RDONLY;
> +			/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
> +			sb_set_emergency_ro(sb);
>  		}
>  	}

[ ... ]

> @@ -1141,6 +1146,10 @@ static int nilfs_reconfigure(struct fs_context *fc)
>  	if (fc->sb_flags & SB_RDONLY) {
>  		sb->s_flags |=3D SB_RDONLY;
> =20
> +		/* After an error nothing may be written, just go read-only. */
> +		if (sb_emergency_ro(sb))
> +			goto out;
> +
>  		/*
>  		 * Remounting a valid RW partition RDONLY, so set
>  		 * the RDONLY flag and then mark the partition as valid again.
> @@ -1152,6 +1161,12 @@ static int nilfs_reconfigure(struct fs_context *fc)
>  		__u64 features;
>  		struct nilfs_root *root;
> =20
> +		/* The VFS doesn't refuse this when nilfs_get_tree() calls us. */
> +		if (sb_emergency_ro(sb)) {
> +			err =3D -EROFS;
> +			goto ignore_opts;
> +		}
> +

[Severity: Medium]
Can this sb_emergency_ro(sb) check in the else branch of nilfs_reconfigure()
be bypassed after an error on a read-write mount?

When __nilfs_error() calls sb_set_emergency_ro(sb) on a read-write mount,
SB_RDONLY is not set in sb->s_flags, so sb_rdonly(sb) remains false.

In nilfs_reconfigure(), right before the if (fc->sb_flags & SB_RDONLY) bloc=
k:

	if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
		goto out;

When a read-write mount or remount is requested (!(fc->sb_flags & SB_RDONLY=
))
on a superblock where sb_emergency_ro(sb) is true and sb_rdonly(sb) is still
false (for example, via nilfs_get_tree() -> nilfs_reconfigure() when the
superblock was kept alive by a snapshot after the corrupted read-write mount
was unmounted, or via reconfigure_super() -> nilfs_reconfigure() on a direct
remount,rw without an intermediate remount,ro), this comparison evaluates
false =3D=3D false and jumps straight to out, overwriting nilfs->ns_mount_o=
pt and
returning 0 instead of -EROFS.

Also, in nilfs_get_tree(), when nilfs_tree_is_busy(s->s_root) is true:

	} else if (!ctx->cno) {
		if (nilfs_tree_is_busy(s->s_root)) {
			if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
				nilfs_err(s,
					  "the device already has a %s mount.",
					  sb_rdonly(s) ? "read-only" : "read/write");
				err =3D -EBUSY;
				goto failed_super;
			}

Because s->s_flags does not have SB_RDONLY set after sb_set_emergency_ro(s),
doesn't this treat the emergency read-only superblock as read/write, reject=
ing
a secondary read-only mount with -EBUSY while allowing a secondary read-wri=
te
mount?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D6

