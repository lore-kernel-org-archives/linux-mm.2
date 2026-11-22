Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019F0606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iYDuuwsM
Received: by kanga.kvack.org (Postfix)
	id 1006D6B05B2; Sun, 22 Nov 2026 15:02:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9406B05B3; Sun, 22 Nov 2026 15:02:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30F06B05B4; Sun, 22 Nov 2026 15:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1A366B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:02:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DAA81406D4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:02:40 +0000 (UTC)
X-FDA: 85463827680.10.788CA1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 68CF81A0003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:02:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iYDuuwsM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795377758;
	b=DUsLsjXxXRttH8c7WLD25QnNGkH7etPB5JZBKKT6qF5korSk9ntxAa4q0Pdkgdz/mYITbc
	YFmc/lzlAKZewGatdGJp7UJI1YBSxN+5kICiPwVAYkddgUAJJpA+hORzcNTldUsz0XFMeR
	FY5UzM5wUsJ+azo5K7wQaG7erKekkPU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795377758;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JaJjkwdjsuthCIR31B8yCOpvVbzH1az3i0dKy7BlJwI=;
	b=aQPU0DujNHh7RcMXJrLjhcZ9iAeMymY2LbwQaoqkee5Scs0vTc28oHW9QaVFmf8iaLSxa9
	xnSWbQATv7MoOGvV9Bc3uWpe1Kgft9/u/+IO6XQuBc3aLIqaeU0xH6KlvrxwBNGwEkEowR
	w8LxMV9+Xtq2KwyVsu6JiZLqb+loOdY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iYDuuwsM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92636405AE;
	Sun, 22 Nov 2026 20:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8511F000C4;
	Sun, 22 Nov 2026 20:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795377757;
	bh=JaJjkwdjsuthCIR31B8yCOpvVbzH1az3i0dKy7BlJwI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iYDuuwsMu6QqZhpSArwN97LlxRt4YeKDxUs+o2Nn5r3yIABQmHIMyV9K7e2yRsVfo
	 GN+H3WMaZJPYo2jFkVt7t1+dqhDMSPmXyW5X3osUTUJJqCMADnu1rOypIhaA4nwziG
	 /ugW+Y1lfibrU2igij3QthyRHY4X1VfrX2cSrdhF4Z/SgM4hjm+BnlwnPL6pr/EyIn
	 NRPsMgqa3uiX5Gamvq+LHrUhCcc75fLKA5XT/RmX0qNBDYCI0yaGG9omsHWngRL5ro
	 dq7RtmddyliPPihPBmWojLUn04dom2+QoWcDzTQzttPVN0zKtLR6L0hNC7AgVgKOzL
	 j2CvGCoaL6XZg==
Message-ID: <sashiko-outbox-228306@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 06/26] mount: Support MOVE_MOUNT_T_MNTNS in
 move_mount()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Aleksa
 Sarai" <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski" <luto@amacapital.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Eric Biggers" <ebiggers@kernel.org>, "Giuseppe
 Scrivano" <giuseppe@scrivano.org>, "Hugh Dickins" <hughd@google.com>, "Jan
 Kara" <jack@suse.cz>, "Jeff Layton" <jlayton@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP Singh" <kpsingh@kernel.org>, "Lennart
 Poettering" <lennart@poettering.net>, "Neal Gompa" <neal@gompa.dev>, "Oleg
 Nesterov" <oleg@redhat.com>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Zygmunt Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261122193539.3334213-7-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <20261122193539.3334213-7-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 20:02:32 +0000
X-Stat-Signature: 14gtx6e87199716jqfyrpops1onpyg85
X-Rspamd-Queue-Id: 68CF81A0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795377758-423208
X-HE-Meta: U2FsdGVkX18kPtNSKj+DXcDWA6tKMfHSn2kSGzECVkcC4+C2aDb/+7KEJkp67EXlWCxMVba15yTIzp9lsL0XE/MsRaAxviGReSnA7x+b3s4UYhUdlc02KWMPiNrBS8HNGFHrW11aXLe5BNh7+fii5xGWaOZTMWJPzYlxhAJjisP7QsGK56XkHHTvE1ItNHD+E30z6adWi8rj1JAOFQBJQDcpzHFKBQygf6VxvOo3s8L1JGv5tdNNZKwHg2WChzWQvKW/jB54nwSa+0u0qJQQE8xyjfpGElgEkX2Ms1thEsyX9obHKqj4rZ7o8SMLCFt/NYQDKj2MzpbfxpOLBx899Os1ipOLwY6L6acaAHUXcqEE7wRjzDrpwpyZXaEq5asrhO6FXaulSYtvytxqAy7a7mY3JNnlLGvphCBZzAF1yDapG3CeHUg4uxixlnDL5CWA7+NJiB+jx9CHCsuuexsIEQH+9Hy6TZVqLTB3AIlO4GVRqWvsp1bXNsZFrw1H4GIC9gTn5qpVjL6wfQM29yOlGTNGF/sPgiwS3+zlyFnduGEWGmnQtLeG9Lawtz2iesKqE0Jg6bocWwhg8i8juUE32Fxoc8lfhB7ZsUNnpneysWSgOtppfOXNrchRvZ4N8VpH4xlKxTRu9FAGKIRGbe/aG/ykfywLokw8yVBonP+5ypHEWYfdIzwXkGELKHq9b0vbxm2UpcLA8tkzF+DUUFPhhrmvFhntHyjekKv6jRUF1XD/V+praMBdoxTrnhhEiWfBgonreDE6gSDyFmJfO4+JgOo6oZmSp3PWd9bnD2qQFVIjtJMm4uAgWrGM2L9yxllWfnt86Dk3Ms5yvJKrjKklGodMbq17hVIuQmwhTgmM5FMQDPIGsXf9FC79wcpM7cJ1EUeVGzdEBXvbp8tGQ8uB0stt+FlyWCyuoe8Z6c+/gRt68gmilxmnRT1VWzzQRcYARFVuRO9j6AWUtzhBGEw
 oeD3GZou
 lsJauggAUJ6msyHXJ4p1eqSQG0oaCsdayvupbX6AjfO2ivZFP2RB8r8z7P/Z9lwBvTYkQ4p4DCjB7Ylq+mpuUYVtXIOLyO0JdpA1lq1qa+QGy428r4CXwbf0NZHlM/wIABJ3YJ0+qZyBBk3zz/f07x4AzWGkGK8NQno5C5GDGVx4No2NR1ic8JQnziImAsvn7ixQXmSgdfQW1wVJRwQhw6ulokP3pRx2GGbpoCC6Osq/SAqxxVtX1f87NFteSwwhv59hkOnmxMLHFDAHVgRkKeAPeMzOwCEjHpXO0/7X2/ueatDVVDIvjaNbHIzyDFaSMprpg0yU5av8TGtrzVw1FE5490KcLftLqadf/NOEuZbPkKOz4pWO9l9rFSAgJlFO7JPTwxY17WuPMp0hpglDgkBi5ZNvoe4g8V4mcN9n+uQxeS/6zXdfhUZ09as5SjA5fphBZToxTqou9Yl85wqtsMQe1tYX9mmufPaSYLOjeT+4amciPmFUE/drHqSH0kG7PC1ITxbItYJH6fR7pCnmOCX9zp4YyzvejMYLjtJk/WNh+yLMl56hBgc8eMUOyf7i0Qz1wQXHwlBGWBM+tXkh/dmF4jCloab6to7zp6t9F5Xke9Hrw6bdkmSzGjSelxUJXF9tmvo+j6VqgsIn8akiMeyE1xGnlu+hFcdVQUvcTeT712/4KD1uLxiGOoNrxFf3kr/T97LzvINyLeCW8fE8omuK9uSfOr12ZmWTJxT7SxOfQU2nqJh/j8x3Hb8jKTkKD8LcrhQIjzCU9rm5QTdbIcY59HNGzczB/WL/5yAwhVf0rmnLMe6jgWKCAxtqEV0iJaN2RsW6dSg5q5wCsD4jRKMtfoo+HXFjmuqayb+8gFRmiIzM=
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
- [High] fs: propagate_mnt() before lock_mnt_tree() in
  attach_recursive_mnt()
--

commit 1a941bfde892dcdbb8ea855a00043b140fa232a3
Author: Jarkko Sakkinen <jarkko@kernel.org>

mount: Support MOVE_MOUNT_T_MNTNS in move_mount()

This commit adds MOVE_MOUNT_T_MNTNS to move_mount() so that detached
anonymous mount trees can be attached directly into a target mount
namespace specified by an nsfs file descriptor.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index 1bb9f90a65239..93dd11da7e734 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
[ ... ]
> @@ -2725,11 +2738,22 @@ static int attach_recursive_mnt(struct mount *sou=
rce_mnt,
>  	hlist_add_head(&source_mnt->mnt_hash, &tree_list);
> =20
>  	hlist_for_each_entry_safe(child, n, &tree_list, mnt_hash) {
> +		struct user_namespace *child_user_ns =3D
> +			child->mnt_parent->mnt_ns->user_ns;
> +		bool cross_child_src =3D cross_src &&
> +				       !in_userns(child_user_ns, src_user_ns);
>  		struct mount *q;
> +
>  		hlist_del_init(&child->mnt_hash);
> -		/* Notice when we are propagating across user namespaces */
> -		if (child->mnt_parent->mnt_ns->user_ns !=3D user_ns)
> +		/*
> +		 * Notice when we are propagating or attaching a foreign
> +		 * source tree across user namespaces.
> +		 */
> +		if (child_user_ns !=3D user_ns || cross_child_src) {
>  			lock_mnt_tree(child);
> +			if (cross_child_src && list_empty(&child->mnt_expire))
> +				child->mnt.mnt_flags |=3D MNT_LOCKED;
> +		}

[Severity: High]
Does running lock_mnt_tree() after propagate_mnt() allow copy_tree() to
strip covering nsfs submounts from propagated copies when attaching a
tree across user namespaces with MOVE_MOUNT_T_MNTNS?

Earlier in attach_recursive_mnt(), when dest_mnt is shared,
propagate_mnt() clones source_mnt via copy_tree() without
CL_COPY_MNT_NS_FILE:

fs/namespace.c:copy_tree() {
    ...
			if (!(flag & CL_COPY_MNT_NS_FILE) &&
			    is_mnt_ns_file(src_mnt->mnt.mnt_root)) {
				if (src_mnt->mnt.mnt_flags & MNT_LOCKED) {
					/* Both a mount namespace file and locked. */
					dst_mnt =3D ERR_PTR(-EPERM);
					goto out;
				}
				src_mnt =3D skip_mnt_tree(src_mnt);
				continue;
			}
    ...
}

When a manager in an ancestor user namespace (src_user_ns) clones a tree
containing an unlocked nsfs submount via open_tree(OPEN_TREE_CLONE |
AT_RECURSIVE) and attaches it into a less privileged target_mnt_ns onto a
mount that an admin in target_mnt_ns->user_ns has made MS_SHARED,
source_mnt's submounts do not have MNT_LOCKED set yet when
propagate_mnt() runs.  Instead of failing with -EPERM, copy_tree() skips
the nsfs submount on the peer or slave copies, revealing whatever was
masked beneath it in target_mnt_ns.

Locking source_mnt before calling propagate_mnt() when cross_src is true
would ensure copy_tree() sees MNT_LOCKED on the submounts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122193539.3334=
213-1-jarkko@kernel.org?part=3D6

