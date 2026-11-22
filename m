Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDFC606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nWkOOfqm
Received: by kanga.kvack.org (Postfix)
	id 583516B05B6; Sat, 21 Nov 2026 19:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533A96B05B7; Sat, 21 Nov 2026 19:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423CA6B05B8; Sat, 21 Nov 2026 19:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08C806B05B6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:10:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17565A067E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:59 +0000 (UTC)
X-FDA: 85460824638.25.2A98688
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 892171C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWkOOfqm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306257;
	b=PmtsWECk36xMd/7UCS6nrdtt/SlBvE0d1fRuoEDhKDKLSGlkfVba6uDDRMwlZTPHyXHfJh
	ElGl+tRuUyc6ytyyuVqBVHa58S7EA57DMlFQXHBHjIz26xTCpYCuTKqvqI7+EXCYAZ5VAI
	EEb2HDuoKZzZwSmyjFJ7lqFLUnOSWmk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306257;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3oqHKKaMc4jz8f4vxbyN/0+IPUCihsP+4tQ8YCz0nQ=;
	b=GkYgXbMxz5zCLTsPDT+9RqJmE9YxrtMyclbbXCO8YFXWAxED012DpDyiD9Npzr6LvYVYYy
	LzEht3CShg9BmSnuPPeIDvIWQ1BnAwmTMJOQPkyId/+i75oXb1jYsObaWnSdCYwHaq4739
	86nK3FRj8Re7/HsO2jt9NjjmLvMrJ8w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWkOOfqm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8D1861C79;
	Sun, 22 Nov 2026 00:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C451F000C0;
	Sun, 22 Nov 2026 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795306256;
	bh=s3oqHKKaMc4jz8f4vxbyN/0+IPUCihsP+4tQ8YCz0nQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nWkOOfqmIL5Mm1bLeZK0VEN57SsUekCLltzuBfJSpeyK6F0lQZ6HpdlCmVWT712Sz
	 /SyiNBHQd6GFHU8eUl6RBjmqAiRcNAAlSLQy8Id1wK2PKZzeF0XuQSf0zFZ8AG6+s4
	 ZOMlYzZxGWV5SXTal8klHGwxqglveAKpAWK5OChtT4Lda1E8kv/dnkS07RQytBqU6o
	 jS8pixp6q9yTWiDryQ5qUfrfbFJsR3mT1a1ZtgGa15t8zrTEBxlFHsktHVtemEkfUm
	 SKVOtfJ/3V20orVOjqcZ1gdpkhSwRyUHY4TbZ9Ursv/wNL2yzynIpJWAJJEdhR2vwF
	 rIdRsR6dUf7Dg==
Message-ID: <sashiko-outbox-227541@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 06/25] mount: Support MOVE_MOUNT_T_MNTNS in
 move_mount()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Mikhalitsyn" <alex@amutable.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy
 Lutomirski" <luto@amacapital.net>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "Neal Gompa" <neal@gompa.dev>, "Paul
 Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261121000844.1863324-7-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-7-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 00:10:55 +0000
X-Stat-Signature: 96ycyjahk57tz6ku6udzbdxfkytry8xk
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 892171C0005
X-HE-Tag: 1795306257-929274
X-HE-Meta: U2FsdGVkX197r4Nzzo9SWaPmB3Grmm6X9QwRD12Tnj9UM11uMAac5R4/fKnFt3uWrn+rguLsJlngMEuViXFYcnkF1oR5+EL4diwM/cjbC/rQEaKOTwe5+cm0XYy2zmMiQZSJGhKG9XuwmwjW+ZoECc6uVX+68Ww0xuP91oTRLlk/Gvt7h6dBY7585Jz0oZYR8xj9KeDWqPvyBK72S23JVrT/xk/cJCxfdjKIoqyJeo2dWeHAjUAYLLnlx5vUlYYJKiP/vvi83x45IzjQYSlKT/Hm5fSAwM4dpUPaMHVQXxyIATXTbGCcJs3HPKv0qU/p9FPV5v+RXB2k737aQfWoJAy3NtRLMfYVwl6gnkMc7KetBU0/vXl3iu9maoAf8MVvxM8zismnUMpFqStlJZrJo+v303pkk8d6U1btyoDzos9ZGSdLyPUVLzYwOMip7/dEC/3VHZp7fR2iQIZ6QDaiTvQQ8eYY8msCICsu6TJ+ducyeIO3Yhm1XLLcaxx+RlDJBJzDzMco+9RX5vi08UhQ5A4wUEG17dfaZG0u81fj0MhRA4MblZVuHHlSlDKvuHjCGJ/eFHrXjJldXM5ggnHAda6X2ZX7LZp9qTM6XraDcEMzM8KU62vuPAssoRSWufYiJ5d6cFlGp+XRbds0TVTb10vf8NyL/orBjc/ZaDVlkDxCDpC2phnjeBexZ707A8/XKwGDhh8dq6ImkOx0RIc5NTSwrXFx9z6q7HQKsxIz8lVjoplOTGRPp6I/XDfYdbOn2KTcuQ+hjqGpAEpCT0NZFLPCQ5TpNpCGwMY4CETV/cuI3b/02xEiPpgsHJIjCFj+QG0a0XD0i3F6BPYjaFsPOPCZo3Lj7GGJRMZWoxodt6nwWYKmmna+5jh5b8Z5955UZtK/FavMX4eNLjQqmEH2rTPx5a7Kc41lU6pFrG0OhomLQDZ282rt7za7MuEMRtq5EVGEL5tczlmg4VtyS8R
 W4TtIbPv
 Vj6fAm9aGUlx7KLiQfT54aDZI2mNUMF+mWRdb0z5H0E/Oqg8PHMBhLC+RVW+Q7tUuQJr6jpIbqfdHiAE0B+aJ4z1HKm5smqp+CTviVJAkYeyA5xyt7sumntcGOh+p3hVWrN3gwIwg68GTTUjnn2qwf6Gr7Wpy4vEacymjCqs6q0dRX+nwsLrbXc0ZIZlSsu2Z9+Qt6aw2SPOvGyGUjuObzvxvuW7z3XF8BV4moh5ixoGWflOUVm2zjesIfPuY34Ih+p5BQ7gP5boaE5U9yAh5VVNUQDWcPUt8zslz39mMX0KfD0wgYgLZOgvF0pGXCWZxBULltCBuEKOxXn46oXBdcfJGm3A9cH+Q44P1DwSSoCmD7RndaFu5DnBuNw0smkKBfEKwgGNNf9MMpKz98XAVsOFZhNZ4j1DO4bL3fvxB3oAbtqg/felOspixaGpk6ZTZrBNwJxFxjjyvmUEW2vVuvfEk1MJEb5IOx6SaAC+IEaSoMWj7p8DvMj7Ty9BkImYcvflhM8rV2dOxzTOTkbCTiO5MpQu2FMXghzIZ4XkFquLRaRa1fX/hl+sxlLhuOsuegURt4XDXifrH8nN/y5h3CH8YyfvBzaKG1rMqKQH6SfaMxN/HOc8ByDpgJSf/jrEdYDOCH4Z8DbAH0Ib1kLNKc1xDn4ZKSRDMJI7tqnWe3SMdCCyJcRgwX7U1kRgK0jvEImFJF0z8QEVehNMdb2he1AArWnqaPq7GnU7cjQYAL8Ck66rXYP11BotmActBMgyXJsWNvfngmzKv7qwb0tJwcQ52FgTjepLarMaIvgZeh9W5PQBBOm+J/ZGwMV6Yr/R0Dyb6kBNGXuWWreUA1faJW9tURg4khP2l2gj5wqpgYpC7VQw=
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
- [High] fs: namespace: broken cross-userns locking in
  attach_recursive_mnt()
--

commit 74ae0b488300551c347e9b244e2d68e31f9a48cf
Author: Jarkko Sakkinen <jarkko@kernel.org>

mount: Support MOVE_MOUNT_T_MNTNS in move_mount()

This commit adds the MOVE_MOUNT_T_MNTNS flag to move_mount() to allow
attaching detached anonymous mount trees directly into a target mount
namespace specified by an nsfs file descriptor.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index b2dc84c0d0d66..b65f1fdd92811 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -2641,6 +2652,7 @@ static int attach_recursive_mnt(struct mount *sourc=
e_mnt,
>  	struct user_namespace *user_ns =3D ns->user_ns;
>  	struct pinned_mountpoint root =3D {};
>  	struct mountpoint *shorter =3D NULL;
> +	struct mnt_namespace *src_ns;
>  	struct mount *child, *p;
>  	struct mount *top;
>  	struct hlist_node *n;
> @@ -2662,6 +2674,9 @@ static int attach_recursive_mnt(struct mount *sourc=
e_mnt,
>  		user_ns =3D current->nsproxy->mnt_ns->user_ns;
>  	else
>  		user_ns =3D ns->user_ns;
> +	src_ns =3D moving ? NULL : source_mnt->mnt_ns;
> +	if (move_mntns && src_ns)
> +		user_ns =3D src_ns->user_ns;
> =20
>  	/*
>  	 * Preallocate a mountpoint in case the new mounts need to be
> @@ -2728,8 +2743,12 @@ static int attach_recursive_mnt(struct mount *sour=
ce_mnt,
>  		struct mount *q;
>  		hlist_del_init(&child->mnt_hash);
>  		/* Notice when we are propagating across user namespaces */
> -		if (child->mnt_parent->mnt_ns->user_ns !=3D user_ns)
> +		if (child->mnt_parent->mnt_ns->user_ns !=3D user_ns) {
>  			lock_mnt_tree(child);
> +			if ((move_mntns || is_anon_ns(ns)) &&
> +			    list_empty(&child->mnt_expire))
> +				child->mnt.mnt_flags |=3D MNT_LOCKED;
> +		}
>  		q =3D __lookup_mnt(&child->mnt_parent->mnt,
>  				 child->mnt_mountpoint);
>  		commit_tree(child);

[Severity: High]
Does overwriting user_ns with src_ns->user_ns break cross-user-namespace
mount locking when source_mnt is attached via MOVE_MOUNT_T_MNTNS?

move_mount_mntns() checks CAP_SYS_ADMIN in target_mnt_ns->user_ns
(ns->user_ns), not src_ns->user_ns.  When src_ns->user_ns differs from
ns->user_ns (for example, an anonymous mount created in a less-privileged
user namespace U2 is attached by a manager into a mount namespace owned by
U1) and dest_mnt propagates to a slave mount in a namespace owned by U2,
child->mnt_parent->mnt_ns->user_ns =3D=3D user_ns (both U2).
lock_mnt_tree(child) is then skipped on the copy propagated from U1 into
U2, leaving MNT_READONLY, MNT_NOSUID, MNT_NODEV, MNT_NOEXEC, and submounts
unlocked in U2.

In the same case, for the primary mount (child =3D=3D source_mnt) attached
into target_mnt_ns, child->mnt_parent->mnt_ns->user_ns (U1) !=3D user_ns
(U2) is true, which locks source_mnt with MNT_LOCKED inside the privileged
target_mnt_ns itself.  Also, checking move_mntns unconditionally for all
entries in tree_list sets MNT_LOCKED on the root of every cross-userns
propagated copy (child !=3D source_mnt), preventing slave namespaces from
unmounting propagated mounts that did not cover an existing locked mount.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121000844.1863=
324-1-jarkko@kernel.org?part=3D6

