Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C871C606A331
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oz9Ftrt2
Received: by kanga.kvack.org (Postfix)
	id F21C86B05BE; Fri, 30 Oct 2026 12:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E827B6B05C0; Fri, 30 Oct 2026 12:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25426B05C1; Fri, 30 Oct 2026 12:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4D26B05BE
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:10:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2096E140736
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:05 +0000 (UTC)
X-FDA: 85379779170.24.58F0BF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 87DCD40009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:10:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oz9Ftrt2;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376603;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W80RP8FoHcI+JtK0co8C0FcIxUgtBISIXczR1g6Mk8A=;
	b=wI9VEnzsZL9QJ1RaJP706WudDgyz/pNN9WOZB6pWmifg/qu6CYD7yYKukKnj6eSDKDnMmQ
	GtCDRHZSHQRFdd/v/7TP9s/53DSR9QCo/zkItQ5uiH/4uynMi4y3Yz4E1mRAr+wisbABQ0
	GWs4/29ONxpBCFJuY8d1gJepx0cMZeA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oz9Ftrt2;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376603;
	b=3epFcy30NSXw9jnm7Y8l1QTStR7rbRwaajAA2jRrW99kicqeU1DhQOrm64YvPzkywveacN
	RpnMzZ6IopomDmlHTmoFyqKryCAaIhQulYGhi3ltWYRrdNxaklxXZ40hT5/DoQLxNI10w4
	IwMcJSyDte6KTs4cRQ2xDaPew/XRnv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 236E2608FB;
	Fri, 30 Oct 2026 16:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA371F0093A;
	Fri, 30 Oct 2026 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376602;
	bh=W80RP8FoHcI+JtK0co8C0FcIxUgtBISIXczR1g6Mk8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oz9Ftrt2DCKtVYEclvb2IsRVsVZY0+KLOxvclWtXQMyQkAc2/gr9d/pToHs7+DGSD
	 6QaBUMlIR5kFTl7XlSBE0o+nfLKzimy+hsd+qtIDOI3ThoAk0HUt8Cfmofb/3I8cBd
	 S7bFfYj5Zw6JrrYKw24Sqze4VYer6x/zxNqvyM+9iXMdiX7lC7YYr47CzmRa0ldb0x
	 NLewi3zJ9/UYqMrg1QDri/X9tBEtDWCxZzMDZVqY+u6+5vV5z8CCgm3DqM2A8OMwHV
	 nH6lkHTv4tiKlb9q69Y3HR7qFyZJs3b5eL/s+fHMxOiIiLPNmDEamztcGjWBJAjK3u
	 ic88NhQqJjWdA==
Message-ID: <sashiko-outbox-191235@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/34] hpfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-16-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-16-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:01 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87DCD40009
X-Stat-Signature: fyf67wh7a6e7dzz49jrpfwd93buxdj5z
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793376603-281176
X-HE-Meta: U2FsdGVkX1/0aOuuH+Gc3FThESGWdf/2WQ85kJvv5SrayxCQPHaNSf226JT7NFIQHugLKUTAtngRXuteV74tT3RZMQ1Ji3Ce+A2Cv/vAGua47QaFMru3bN0CiwtDV5Qvlh4ODrIOhZreyL6vx2HQTGOHnSYcyunQFWBmbO+Zle4MIf1MSrWPFWPH/oHTL3vlr0bVMi7Ax7HAqjoybQ7gixlL38tDeabwbODy5f1nuzBKU0M0N+eirGl/hFk3ncAn+xNKII7UFaiLnPzy5ODIGtWssNKFbF0G85HR588uR6o510E7Kn6FnruII8WKzctFV2S2Exl8WrmdNEbNHfiXf5L6eZQO7mGlQ4rTzO0J0LkyshJWEypYJ+Du5vIImfBrw6fnN1K4wSRADS7dB4KFnNQ6Sg3urdEh3yMIxd8O2/zAVKipVx7ysqYzjuV6jWt924aY9+nFeN4R+idhdYtHDCpEqoc96VorQk0nNuQu4DQKahQdfpBjUhCWsD7cuzI0fnuCAAkgVPAvx7h3NfsEbScLqU8WCLq/kcIwlUSnuLTZdHGbWntARLIaB5jHTsdwjL5nDuG9ineTrpUCFveupiPm+7F0sg8paWt9BzXraiTfOOlJItT92YrUbbNMG0uVH7ulpbBoOPNgvBiJn9hBPfitB3EfXCaiiHoFuNABqfcgUpioyNqeGaNfZJZ+Dj+1ZVPxRSMyYTrhz2PYMUqeYg0ujwIHNhXXi6q3NTYr3MFyUy6l1T+2cFhiCEKC9OJAaKe1ii5QGaEvCAN73lQy3Jm5yqgGu+jjFoMqu8BgjaTExn4lzpFl9x+pxARcIoYEh/+M2AY0Ybrs2EV3+VOEEQTyCXn2laMo/G2Smufz3z8CEkWIpXjb6FJjF0ByogFZ7Soey8SNsa2S5rsYYyfRoaHuBmHdkb98n8fZun3jB62NJdwsSp/5+iOnft1dPB1sUaMtX/QSHW/pvvKej2v
 9mko0eC9
 azpfPGLmJREIW059zhEM3fwqmWf3zEZlFjVgkTYy+3ZN5V+14SSeTVotwaF5ekpLjhtvIRSmKOQ6VEVty7C+sZ4vONpuugBwBWOxtXOb0Rp88oj7R0BZ9TmboX+6HLsMQZaPRDJ0ZLb+yZVxmGfOxuPYlNnd4l83/0c19X+xRKoyLN6QqA8jcwn0naKWrnOkxGK/cMXwPzGVIsP7VQHw2QiyY6B1/c+gepsbVzhJa4MBD5C0R4w16mrh7hRDQU5jwvyPyZUCmdZY8nsehmga8RPmewNJBGIIs0GYeVeP6rJiI4ZOAIqn5vIe7XaVwdo9ugfwZ+a4fifjJzxHBnNJd4ECZfcRXygUgJ7+vNuY6098FnQhsfCm5jjLWDLcxoaopOXYsdR1j5A3GSB/Wmpp7TPGVfOknPXSSNmxx7SW5X29zThKFzpJ5qXrg5ozBqf1ldPaOvExj2uvRxazn0zPlhLwKixzN/UM/xLYRh23foRqBWs3tFyEemkfpURP9zgUeCgsCb61fcD86CFgknBQ2S7OlHdb9JGOheH7DV4u8fLlEsGWFbhhmbhGxvbRHLSl9q/A89eTHgio/T6LOA6+MlUt1wdqijKdmwCFI4aELIR3VceUgVaLRYIJNm/maAe3Y+TcX
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
- [Medium] hpfs: remount rw after error succeeds and writes spare block in =
mark_dirty()
--

commit 1e8d846622af872ec2aab29caf0990fcc20ac2f2
Author: Christian Brauner <brauner@kernel.org>

hpfs: don't set SB_RDONLY after filesystem errors

This commit updates hpfs_error() to call sb_set_emergency_ro() instead of
setting SB_RDONLY directly once SB_BORN is set, avoiding a hang in
thaw_super() when an error occurs while the filesystem is frozen. It also
updates hpfs_trim_fs(), hpfs_lookup(), hpfs_map_dnode(), and unmark_dirty()
to check sb_emergency_ro().

> diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
> index 8fbdbf0806276..ab89e624cd517 100644
> --- a/fs/hpfs/super.c
> +++ b/fs/hpfs/super.c
[ ... ]
> @@ -81,7 +81,14 @@ void hpfs_error(struct super_block *s, const char *fmt=
, ...)
>  			else {
>  				pr_cont("; remounting read-only\n");
>  				mark_dirty(s, 0);
> -				s->s_flags |=3D SB_RDONLY;
> +				/*
> +				 * Before SB_BORN the mounter holds s_umount,
> +				 * later see sb_set_emergency_ro().
> +				 */
> +				if (s->s_flags & SB_BORN)
> +					sb_set_emergency_ro(s);
> +				else
> +					s->s_flags |=3D SB_RDONLY;

[Severity: Medium]
When a runtime error occurs on a read-write mount after SB_BORN is set,
hpfs_error() calls sb_set_emergency_ro(s) without setting SB_RDONLY in
s->s_flags, leaving sb_rdonly(s) false.

If userspace then attempts to remount read-write (or reconfigures mount
options without SB_RDONLY), reconfigure_super() in fs/super.c checks:

	remount_rw =3D !(fc->sb_flags & SB_RDONLY) && sb_rdonly(sb);
	remount_ro =3D (fc->sb_flags & SB_RDONLY) && !sb_rdonly(sb);
    ...
	if (remount_rw && sb_emergency_ro(sb))
		return -EROFS;

Because sb_rdonly(sb) is false, remount_rw evaluates to false and bypasses
the -EROFS check. reconfigure_super() then proceeds into hpfs_reconfigure()
in fs/hpfs/super.c:

	if (!(fc->sb_flags & SB_RDONLY)) mark_dirty(s, 1);

	hpfs_unlock(s);
	return 0;

And mark_dirty() in fs/hpfs/super.c checks:

	if (hpfs_sb(s)->sb_chkdsk && (remount || !sb_rdonly(s))) {
		struct buffer_head *bh;
		struct hpfs_spare_block *sb;
		if ((sb =3D hpfs_map_sector(s, 17, &bh, 0))) {
			sb->dirty =3D 1;
			sb->old_wrote =3D 0;
			mark_buffer_dirty(bh);
			sync_dirty_buffer(bh);
			brelse(bh);
		}
	}

Unlike unmark_dirty(), neither hpfs_reconfigure() nor mark_dirty() checks
sb_emergency_ro(s).

Does this allow a read-write remount or reconfigure after an error to
succeed and synchronously write the spare block at sector 17 via
mark_dirty()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D16

