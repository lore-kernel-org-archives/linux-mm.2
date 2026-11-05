Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6976360A3833
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WjJEPh8p
Received: by kanga.kvack.org (Postfix)
	id 84DEF6B05BA; Thu,  5 Nov 2026 14:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE816B05BB; Thu,  5 Nov 2026 14:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDAC6B05BC; Thu,  5 Nov 2026 14:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7DA6B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:29:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0E0BC0BF2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:29:56 +0000 (UTC)
X-FDA: 85402055592.16.E9165E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id DB9B8A000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:29:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WjJEPh8p;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793906994;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mq2TZRho3g/6dJEkd3aM2nJWP3IUjUSQ0d76Sv96NJo=;
	b=ZgeG2MaJXstqcL7cx3qGMkDvRtnLfObnKJ1ioOLertoqq0tRHLEDQAB6OQi4Z17oHOOJhv
	A0qIBVlfWi+XjCqDX7vGjn7xCyeiw42bnQD6bFEJ2BzkG3/Rdr0C5O3clsiC/0iicKUCcq
	5UQ8QoQNXBedGDpBWS6pw1oEln4BwxM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793906994;
	b=1onr4V9/oTjPFDoYGi9nRLxRGoIgaAff8NOpczv50HhRh/2DAdAu+6Yposb/Zfikm8ec2O
	ZBLjOLZub7msGUpB/AoRA81Q1Fzd+QZIm/OzBobasuAPA2ft3wAyyZ1lVj6nDqmoDWU3Wd
	GgWZDD6ZjYn9VUL39SYqM6RIGQ6jrpw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WjJEPh8p;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81189601CF;
	Thu,  5 Nov 2026 19:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBACC1F000C1;
	Thu,  5 Nov 2026 19:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906994;
	bh=Mq2TZRho3g/6dJEkd3aM2nJWP3IUjUSQ0d76Sv96NJo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WjJEPh8pDtseuVUQk4qwZA9aci3gac063ZokyebNlvHp2beWZHvvSUeYQeiXMVXvr
	 gorR7o8d0SaoLeOi9bKNyUy3h6vHu09hw27HReSQrpP5tbdq5gCz3B6gixX9La77ez
	 A3GDPdSDz2e83FWBMhFysd0uKqafdxTW2wlSO3wrIC47SZJJWU00KVW3tU8R/XZoDc
	 l2HWNRW/SEC3nlzdu96mPwurJuhISd5di7F3WA+6g/riaXNTCLrXNXhDRDwZUn89Ok
	 0Dcu6L25OUIAO131EMpgW4+6XspNy4+EDu3YAgYrAOfY0ko3kC83F2cPBr48QIfDJY
	 xKWD9ZPaIbjkw==
Message-ID: <sashiko-outbox-199895@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 32/51] proc: resume readdir after the last
 name it returned
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-32-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-32-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:29:51 +0000
X-Stat-Signature: 3m8bqmfzhd8noead45rwai9ab6wf8y8j
X-Rspamd-Queue-Id: DB9B8A000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793906994-681748
X-HE-Meta: U2FsdGVkX1+9f8ghkNmZ8M39B40HO5CBPNWsQ+LMwQlWC+zcU+zmfeAjvuYgyU4sZXRuL0lR+2Oh50DW9XhSZjCJzyv6r3dHJK9EhWyn049xVkdICNX6Cxfp4po4tnKX6MXcmNs2IcklxWoGmbNFdx/OiEtM1097wQwhFH4ItygoqMJZoihTacq530Fn7V9B9zFnZte7KRsNJb9T1IV+YbOsJ28TU/XonCn8dQNW6Aqe61NTomYnMYNcFpTDBNbwP4cKjeRYPamTekpQlkfrNUuqBXwET05Z23Gz4/qsWpPykG6ft0tDT/k4Uxyw5IRQqi0Dwswk4s4vrovgThJe9AxDXwRVpKXQ27h0r0OGSHKf4ip4bNZxLatROYOnYbhx3l0Ff5hQ7lNx4T0rqbDDGeYiusAX4rr3gt3Jxanmzq1wj4V3NphbWWyHm9UGD0ETwZ5yASe8V4h7XdXdZc+XxWo8AiIYhSBr653OZVxSpdA/NABiikylJlwyHm6VRude3Z4PCOtaujm1VdY5ONkscdvlu72jgSImZ9q3Mq/Bd64Y3vWMsg1/51TWXX5qINHXaMjGN6xt7zy9jziX/LP5sdw43xzm4xqXoCaDMTV5vkmC1yIeM5RknDASMsOmbBpxsBE4+7R61XdtCz+876z6bP12ODJxk0JhlKe1Y07zGyyV76doi+eV1Bs5Z4AsOVMK0E9QvFLAUTBNTSdFusveDn6lKSR/vZRNCzPN5xjSZIxAGy1zmDz5hdqrL7+NKyNuoEkZftIYBchlIuNWIIQj5IZ2Mz/1uwJRay82idtT63eAyvuvPLiMQvZJ6zG0zoKTsLfeCWxXEn44k1/IwZNJXJa6yPEnHlvYOAaXlngD1UTyXyLimUjTpMZWAHU8noLFha4plRsJYnwZh8nd8C4RFUSeNS/1i8wvtBGk2OFYQqBxe7+BaTtcS/OL6m1jqXdksaEkrsYH8fbs0qnZjGC
 2OUpOHHT
 HzPcvhSSayrUGbrbzFQPvVdx1rJ+Fp5z9lRxSS8S5RaL+T9Fo7SncYr7QdMOnX6jTaO/iBT636m8ENCi1k3vMYsXAFHu1CWwtc+PY/+xWfSmZMCtbbW1+enDnLDoJWiBoxKcuM95NBR46F7FEbEeDUe2RbDhupLbs6gY3llXt3cbboweHVOaZM/wNJfoYogF+q4SHxB3kgZ5eUHlmgmDhz4VhI9LcdDCPClt+Ql8eGNf+lVYWJc33N03YE8Eqd7VJjXpv5mHC411zOUbGwz33vRCPCKyjUVkGGY/ydiBqKsVb4NUj/4RwXkI+5aB9wtSIECFTPBxITvy0Dq5EAkwGNwrvoMAlJ6tkjCpE/xn7C0UyPKSX0ucEub0qjrWKL+p9gbAM5teHaL/g41fp5tzrzcLPdDjPc3hdgYRL+PY7REAjp15Yjn0mEeNbxHOhmol1rcApnnK35YboNrmeSkdTxta7//xkmMi37pCX48FhKudAY7xVXKZYJf4dM4XKz2W9LwjWCpL6ZaJ4FQKYidIPeTc8bD+oG9T2RqWs9hL2GsUJtjfB8lllZ9j/hlORNXm8juEv+ZoB6BkDW/58rytltBm0ZmoGftUzY+LfdRR6LLxFTgnn7y5/zm/HH7tjDrdAmwSsus26oh0DnxBOU7ZC9RcOjxAK2Kcl4fTY
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
- [High] proc: proc_readdir_de() returns 1 at EOF, breaking old_readdir()
--

commit 6510b1c4f87c45306294a13ba8447b50990db356
Author: Christian Brauner <brauner@kernel.org>

proc: resume readdir after the last name it returned

This commit records the name of the last emitted directory entry in a
cursor stored in file->private_data so that subsequent readdir calls can
resume after that entry by name rather than by numeric index. It also
continues after an entry's name if the entry is removed while being
emitted, and returns 1 when no entries remain at the start of
proc_readdir_de().

> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 9e59796349e15..588999058e66d 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c

[ ... ]

> @@ -290,23 +346,26 @@ struct dentry *proc_lookup(struct inode *dir, struc=
t dentry *dentry,
>  int proc_readdir_de(struct file *file, struct dir_context *ctx,
>  		    struct proc_dir_entry *de)
>  {
> +	struct proc_dir_cursor *cursor =3D file->private_data;
> +	struct proc_dir_entry *dir =3D de;
>  	int i;
> =20
>  	if (!dir_emit_dots(file, ctx))
>  		return 0;
> =20
> -	i =3D ctx->pos - 2;
>  	read_lock(&proc_subdir_lock);
> -	de =3D pde_subdir_first(de);
> -	for (;;) {
> -		if (!de) {
> -			read_unlock(&proc_subdir_lock);
> -			return 0;
> -		}
> -		if (!i)
> -			break;
> -		de =3D pde_subdir_next(de);
> -		i--;
> +	if (cursor && cursor->pos =3D=3D ctx->pos) {
> +		/* Resume after the last entry emitted, wherever it is now. */
> +		de =3D pde_subdir_after(dir, cursor->name, cursor->len);
> +	} else {
> +		/* Moved by a seek, count from the start like always. */
> +		de =3D pde_subdir_first(dir);
> +		for (i =3D ctx->pos - 2; de && i; i--)
> +			de =3D pde_subdir_next(de);
> +	}
> +	if (!de) {
> +		read_unlock(&proc_subdir_lock);
> +		return 1;
>  	}

[Severity: High]
Does returning 1 here when !de cause old_readdir() and compat_old_readdir()
to return 1 instead of 0 at end-of-directory on non-root /proc directories?

While proc_root_readdir() checks for a positive return value from
proc_readdir_de() to advance to the PID entries, proc_readdir() (for
proc_dir_operations) and proc_tgid_net_readdir() (for proc_net_operations)
return the result of proc_readdir_de() directly as their .iterate_shared
return value:

fs/proc/generic.c:proc_readdir() {
	...
	return proc_readdir_de(file, ctx, PDE(inode));
}

fs/proc/proc_net.c:proc_tgid_net_readdir() {
	...
	ret =3D proc_readdir_de(file, ctx, net->proc_net);
	put_net(net);
	return ret;
}

Previously, proc_readdir_de() only returned 1 after completing the do-while
loop (where dir_emit() had succeeded at least once and set buf.result =3D 1
in fillonedir()), and returned 0 when !de at the start of the call.

In fs/readdir.c, old_readdir() and compat_old_readdir() do:

	error =3D iterate_dir(fd_file(f), &buf.ctx);
	if (buf.result)
		error =3D buf.result;

	return error;

When old_readdir() or compat_old_readdir() is called at EOF (ctx->pos >=3D 2
and !de), dir_emit_dots() returns true without invoking ctx->actor, so
buf.result remains 0 and iterate_dir() returns 1 from proc_readdir_de().
Wouldn't old_readdir() and compat_old_readdir() then return 1 to userspace
without writing to the dirent buffer or advancing file->f_pos, causing
callers to read uninitialized or stale dirent memory in an infinite loop?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D32

