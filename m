Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3040E606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OAFSyaxy
Received: by kanga.kvack.org (Postfix)
	id BD59D6B063A; Wed, 18 Nov 2026 18:15:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65476B063B; Wed, 18 Nov 2026 18:15:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964946B063C; Wed, 18 Nov 2026 18:15:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 666226B063A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:15:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0168808BF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:26 +0000 (UTC)
X-FDA: 85449798252.11.C24A8E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B19980009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OAFSyaxy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043725;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6t5wzxGOfXIEIcg9fBtQNa9zbQEafj93QzKo1t697E=;
	b=GBFORJMVRI5cDNs9+9lNkvY5MBA6H8F8VzKyxDm6yQLqBiEeES4I/9ntg8+n0PTNTkoJtj
	YV3FfxaHTZGZdNvShIxaUmRS4SDcuZzLT60DqNb71WAuStu/8DHC3YCwCqEkgiqFU/lpnq
	vEbQfsZOQgEwvJhvgHt5eMe2gUIRjBs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OAFSyaxy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043725;
	b=lBqg/EYCXXDEclGGrW0OpO27MBSDFi1bFs7phreeptO7xLaCgwSzIFodB5+jtozm7x/7eQ
	Xaktfb/mZyB4cDTcdNOPYawWCjPPKmXsliozz6jBaQDJoSHI1cULtkPwnKk4O4f7bqPEg2
	XMYDZSqVAmYCOGt/viqCShuY9hHDfHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BF24641E9;
	Wed, 18 Nov 2026 23:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438451F000C4;
	Wed, 18 Nov 2026 23:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043724;
	bh=E6t5wzxGOfXIEIcg9fBtQNa9zbQEafj93QzKo1t697E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OAFSyaxy70917NfmntbnUfCA5v823EBkhpm3W6SMckBMFSWzMrGo50v41ADUlwco0
	 y3ozvbxwNM4VPEyMnw0QL6s992f1pqqtg0DqyHJ4eJNL8y/awT6i8yXY4HCRzY6H6D
	 y7QyV522gVQPgb7InHSI1Ndw4ARFzTLCJQ992dstcP+q0wz0OjLts0xFVALoi2mGXB
	 X3AHifrBD3iCXwXyoEk8q/lGi6+/XXUzTg39RLh5zkLkh6RzdLeS+scjEqEFj5mgrK
	 MSaRMQ+relb/P3TnB9uDtzgG6mC5RkLEOXJaQq7q77+ygKDjlIRrRvQoMeldPipST9
	 llnQHCR6zNjNQ==
Message-ID: <sashiko-outbox-222163@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 09/13] fs: Support installing rootns mount trees
 via move_mount()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Andy
 Lutomirski" <luto@amacapital.net>, "Ben Segall" <bsegall@google.com>, "Christian
 Brauner" <brauner@kernel.org>, "David Hildenbrand" <david@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Davidlohr Bueso" <dave@stgolabs.net>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ingo Molnar" <mingo@redhat.com>, "Jan
 Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "John Johansen" <john.johansen@canonical.com>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K Prateek
 Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261117231352.3816603-10-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <20261117231352.3816603-10-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:15:21 +0000
X-Rspamd-Queue-Id: 4B19980009
X-Stat-Signature: h7h9juhfs3yb13jtr64a6m137i7i43ib
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795043725-103611
X-HE-Meta: U2FsdGVkX1/7KSzTwX3xVkYIPKP9p0WZ1M4qiRPdFfaDLOg9SCoKuEoa43eTczUhFFYcocAwcZba+FhUCDW8DL5M6zfNzWgiIxOKfwUAmCiAmT6vprBy2gJH8tOyvD0SJDhzlvzKOjC5Fsz2sNhmvIao4zBC+/5hJ82wHria9OqZLxxYxTj5OsW95wewpPvAe0S8QlUlP+Nt8BtrTOPvHYD3tL4oE9gOz/M39rslJh+b0DTk036uHERJNmdYZbAY1t64J/IEV1ztf3uZ6KQ/pFMvYjaPmhhQnItogUBXCXtUdT/4Bft66CB1DeJbfSFjU7r3N5A+5m8d2jsJV8pQuVZmw0iuQK4joUPzQyR4Ylk8VwRFS9WLGPbYlKKycKY4kCpUOW0FgkIdXyYQbO/Fcc3zPdZPehUCr/Zd+Qad8qtRGG3C4+iucrUJkBn5+4wDQi9HdFbJKC0tHD+DXhevP5ZwGIQXtfWM49r9qWtbySkxK/X7exXKP/m3QbdXQ2x9iC1ti6RryLpBbtbIBVsDhXAO7nofRVzLR9KSYbBhiH5q4msXCLSKyCXf5NE8Y6P6w6YcJGq3zBUVf+xD9DDKiBX9Wyer7galO3rNr04JT7NstwwYxoP4hvMo7mrr6AF6WrU2gpm4v1LkKMU5CrqezCl05dubIALPAmoGP1DoNL9pnHvcibfiCYR2dJ8LlKbh1ineJGeWGkGQwK6BYa1wm9qtR+2gz2XRpHU8oA8nmOvrElIuISdcP9EeHgIoZY5QH662Mj7qt8pVo1Zxxr0DPmQY5Eo/BkKBuQ7HlGkZy74w6eqTknKk8mEiPb2IdH/4od2/fATftDH0faOrwYeQc1+eu6RrLFhJG2L72huCwNpmyc4UJeYMVQ0ae4Hspuq9CPerWtx+S8V18p2h3AwgwL8t0OMQWHnLgffP9cb89hG0xUbf1Typ1hKH3dM2yrMDfK3qkJhKrOn3tBMebY2
 qreYbAcE
 pP2IcCI09lULvCKfHXm5jAijbqFXnGD8uwhKGfqBMdvRWXOFa4s2P9b1sfVJKihGK7//szQ/pR7XRUMwWk+CpyHvYTne3eBkzwtcOYQ3zQJSfrlkKZ4Nkj7aQOicx/Z2TfRyX8vXZ9RWED4/PxXPW40K3LektKHTU4jGdQ/V+CAcN/1cIUiTxMRMT8Zy0seKpQ7MQcfaHD+EhmGROM8rXjBhIAK/bAKz5+PrP0dBGfZYExciQfUUEr5JRTEQI2KCd7tGUsZ90d8lLhwWt57as2aornDTWIVM1cHWy9qTOBN6Kl23XY1ZeErrtC/vYohhJx6qZWvBCAPZgZS/lzjfXyj7w54PcFcg8mtEe6eAu64nN9s54XNaG7vXZ9jjFJ41Ibky3kgdcbhSEy8/+bSzbfBm6Lfz8gR83ipCpGuvSNrLHbB+0HEfnJN3P7cun0C1NbqTXFmackpS96VI7GuHyHwrWLfTe+HeN9v7LFrKDZirCcXP8EbCulsEYULPeomO0VdLh+28m/bWmciBN1eGpBOMCTaSlqOPx8wxTHUFmgj0q9M9XvxfqMYDu2dts5zvASwN3HOoPVCUxMS/C4AhD4DeExu4fh8iBJQh7j359jprONv9sNAgv9OQKJvoff0bzQV/iMUKX6qhHmdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] fs: check_for_nsfs_mounts() checks caller mnt_ns instead of
  rootns target
- [High] fs: do_move_mount() calls lock_mnt_tree() after
  attach_recursive_mnt()
- [High] fs: relative target paths in move_mount_rootns() bypass is_root
  checks
- [High] fs: TOCTOU race on rootns->state in move_mount_rootns()
  corrupts state
- [High] fs: fsmount() alloc_mnt_ns(fc->user_ns) bypasses submount
  MNT_LOCKED
--

commit f0ccb5459fd227ad26c0bf5f42a1937aaa266930
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support installing rootns mount trees via move_mount()

This commit adds MOVE_MOUNT_T_ROOTNS_ROOT to allow attaching detached
anonymous mount trees into a rootns mount namespace via its file descriptor,
and allocates fsmount() anonymous mount namespaces in fc->user_ns.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index 010ed5d68d229..2dfb5e01d40f0 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -3792,7 +3796,13 @@ static int do_move_mount(const struct path *old_pa=
th,
>  	if (IS_ERR(mp.parent))
>  		return PTR_ERR(mp.parent);
> =20
> -	if (check_mnt(old)) {
> +	if (flags & MNT_TREE_ROOTNS) {
> +		if (!anon_ns_root(old) || old->mnt_ns =3D=3D mp.parent->mnt_ns)
> +			return -EINVAL;
> +		if ((flags & MNT_TREE_ROOTNS_INIT) &&
> +		    mp.parent !=3D real_mount(new_path->mnt))
> +			return -EBUSY;
> +	} else if (check_mnt(old)) {

[Severity: High]
Can moving an nsfs mount into a rootns with MNT_TREE_ROOTNS create an
unbreakable mount namespace reference cycle?

Later in do_move_mount(), check_for_nsfs_mounts(old) calls mnt_ns_loop(),
which checks against current->nsproxy->mnt_ns rather than the destination
mp.parent->mnt_ns:

fs/namespace.c:mnt_ns_loop() {
    ...
	mnt_ns =3D to_mnt_ns(get_proc_ns(d_inode(dentry)));
	return current->nsproxy->mnt_ns->ns.ns_id >=3D mnt_ns->ns.ns_id;
}

Because the target rootns mount namespace was created after the caller's
mount namespace, current->nsproxy->mnt_ns->ns.ns_id is smaller than
rootns_mnt_ns->ns.ns_id.  If the caller clones an nsfs mount referring to
rootns_mnt_ns via open_tree(OPEN_TREE_CLONE) and moves it into rootns_mnt_ns
with MOVE_MOUNT_T_ROOTNS_ROOT, mnt_ns_loop() returns false.  The mounted
nsfs dentry then pins rootns_mnt_ns while rootns_mnt_ns pins the mount,
permanently leaking the mount namespace and all mounts inside it.

Passing mp.parent->mnt_ns to check_for_nsfs_mounts() and mnt_ns_loop() would
check against the actual destination namespace.

> @@ -3845,7 +3855,16 @@ static int do_move_mount(const struct path *old_pa=
th,
>  	if (mount_is_ancestor(old, mp.parent))
>  		return -ELOOP;
> =20
> -	return attach_recursive_mnt(old, &mp);
> +	lock_tree =3D (flags & MNT_TREE_ROOTNS) &&
> +		    old->mnt_ns->user_ns !=3D mp.parent->mnt_ns->user_ns;
> +	err =3D attach_recursive_mnt(old, &mp);
> +	if (!err && lock_tree) {
> +		scoped_guard(mount_writer) {
> +			lock_mnt_tree(old);
> +			old->mnt.mnt_flags |=3D MNT_LOCKED;
> +		}
> +	}
> +	return err;
>  }

[Severity: High]
Does calling lock_mnt_tree(old) after attach_recursive_mnt(old, &mp)
mishandle overmounted subtrees, shared mount propagation, and concurrent
readers?

Inside attach_recursive_mnt(), any existing mount q at the target mountpoint
(for example when MOVE_MOUNT_BENEATH or overmounting is used) is reparented
onto topmost_overmount(old) via mnt_change_mountpoint(r, mp, q), and
MNT_LOCKED is cleared on q so it remains unmountable.  Running
lock_mnt_tree(old) afterwards walks into q and all of q's descendants via
next_mnt(p, old), setting MNT_LOCKED and MNT_LOCK_* on pre-existing mounts
in the rootns and preventing q from being unmounted.

In addition, if mp.parent is a shared mount in the rootns,
attach_recursive_mnt() clones old for propagation before lock_mnt_tree(old)
runs.  Because attach_recursive_mnt() sets user_ns =3D ns->user_ns (the tar=
get
rootns user_ns rather than old->mnt_ns->user_ns), the cross-userns check
child->mnt_parent->mnt_ns->user_ns !=3D user_ns is false for peers in the
target user_ns, leaving propagated copies unlocked.  Finally, dropping
mount_lock in unlock_mount_hash() before re-acquiring mount_writer leaves a
window where old is already visible in the rootns without MNT_LOCKED or
MNT_LOCK_* set.

> @@ -4701,7 +4720,7 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, =
flags,
>  		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
>  			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
> =20
> -	ns =3D alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
> +	ns =3D alloc_mnt_ns(fc->user_ns, true);
>  	if (IS_ERR(ns))
>  		return PTR_ERR(ns);
>  	mnt =3D real_mount(new_path.mnt);

[Severity: High]
Does allocating the anonymous mount namespace in fc->user_ns allow
submounts from a parent user namespace to be installed into an unprivileged
rootns without MNT_LOCKED?

When a process in a parent user namespace configures a superblock for an
unprivileged rootns via FSCONFIG_SET_ROOTNS, fc->user_ns is set to the
target rootns user_ns, so fsmount() creates a root mount M_root with
M_root->mnt_ns->user_ns equal to the rootns user_ns.  If the process then
attaches a host mount M_sub (for example, a read-only bind mount or masking
mount from init_user_ns) onto M_root via move_mount(), attach_recursive_mnt=
()
calls lock_mnt_tree(M_sub), which only sets MNT_LOCKED on descendants p !=3D
M_sub and leaves M_sub itself without MNT_LOCKED.

When M_root is subsequently moved into the rootns with
MOVE_MOUNT_T_ROOTNS_ROOT, do_move_mount() sees M_root->mnt_ns->user_ns =3D=
=3D
mp.parent->mnt_ns->user_ns and skips lock_mnt_tree(M_root).  As a result,
M_sub is never marked MNT_LOCKED in the rootns, allowing an unprivileged
user in the rootns to unmount M_sub and expose the underlying directory.
Conversely, attaching another FSCONFIG_SET_ROOTNS mount onto M_root via
normal move_mount() causes attach_recursive_mnt() to compare against
current->nsproxy->mnt_ns->user_ns (because M_root->mnt_ns is anonymous) and
spuriously lock the same-userns submount.

> @@ -4741,6 +4760,129 @@ static inline int vfs_move_mount(const struct pat=
h *from_path,

[ ... ]

> +	rootns_mnt_ns =3D rootns->ns->mnt_ns;
> +	is_root =3D to_name->name[0] =3D=3D '/' && to_name->name[1] =3D=3D '\0';
> +	if (is_root) {
> +		if (flags & MOVE_MOUNT_BENEATH)
> +			return -EINVAL;
> +		if (READ_ONCE(rootns->state) !=3D ROOTNS_EMPTY)
> +			return -EBUSY;
> +
> +		to_path.mnt =3D mntget(&rootns_mnt_ns->root->mnt);
> +		to_path.dentry =3D dget(rootns_mnt_ns->root->mnt.mnt_root);
> +		mflags |=3D MNT_TREE_ROOTNS_INIT;
> +	} else {
> +		if (to_name->name[0] =3D=3D '/')
> +			return -EINVAL;
> +
> +		scoped_guard(spinlock, &rootns->lock) {
> +			if (rootns->state =3D=3D ROOTNS_EMPTY)
> +				return -ENOENT;
> +		}
> +
> +		lflags =3D 0;
> +		if (flags & MOVE_MOUNT_T_SYMLINKS)
> +			lflags |=3D LOOKUP_FOLLOW;
> +		if (flags & MOVE_MOUNT_T_AUTOMOUNTS)
> +			lflags |=3D LOOKUP_AUTOMOUNT;
> +		ret =3D filename_lookup(AT_FDCWD, to_name, lflags, &to_path,
> +				      &rootns->root);
> +		if (ret)
> +			return ret;
> +		if (real_mount(to_path.mnt)->mnt_ns !=3D rootns_mnt_ns)
> +			return -EINVAL;
> +	}

[Severity: High]
Can relative target paths such as "." or "subdir/.." resolve to_path to
rootns->root and bypass the is_root checks?

Because is_root only tests for the literal string "/", passing "." after
root installation enters the else branch and resolves to_path to
rootns->root:

1. If MOVE_MOUNT_BENEATH is set with to_pathname =3D ".", the MOVE_MOUNT_BE=
NEATH
   check in the is_root branch is bypassed.  do_lock_mount() selects the
   underlying nullfs root as mp.parent and mounts the new tree beneath
   rootns->root, clearing MNT_LOCKED on rootns->root in
   attach_recursive_mnt() so an unprivileged rootns user can unmount a
   locked cross-userns root mount.

2. Without MOVE_MOUNT_BENEATH, to_pathname =3D "." overmounts rootns->root
   without updating rootns->root (and similarly on initial "/" installation
   if from_path already has overmounts stacked on its root dentry).  Because
   copy_fs() and preset-root lookups in path_init() do not traverse
   overmounts on rootns->root, subsequent CLONE_INTO_ROOTNS processes and
   move_mount_rootns() lookups stay in the shadowed lower mount.

> +
> +	ret =3D lookup_move_mount_from(from_dfd, from_pathname, flags,
> +				     &from_path);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D vfs_move_mount(&from_path, &to_path, mflags | MNT_TREE_ROOTNS);
> +	if (!ret && is_root) {
> +		scoped_guard(spinlock, &rootns->lock) {
> +			path_get(&from_path);
> +			rootns->root =3D from_path;
> +			WRITE_ONCE(rootns->state, ROOTNS_READY);
> +		}
> +	}
> +
> +	return ret;
> +}

[Severity: High]
Can concurrent "/" installations race on rootns->state, leaking the previous
rootns->root and resetting a running or dead rootns back to ROOTNS_READY?

When is_root is true, rootns->state =3D=3D ROOTNS_EMPTY is only checked bef=
ore
lookup_move_mount_from() and before namespace_lock() is taken, while
MNT_TREE_ROOTNS_INIT in do_move_mount() only checks whether
rootns_mnt_ns->root currently has an overmount:

CPU0                                  CPU1
move_mount_rootns(..., "/")           move_mount_rootns(..., "/")
  READ_ONCE(rootns->state) =3D=3D
    ROOTNS_EMPTY
                                        READ_ONCE(rootns->state) =3D=3D
                                          ROOTNS_EMPTY
                                        lookup_move_mount_from()
  vfs_move_mount() -> attaches M1
  rootns->root =3D M1
  rootns->state =3D ROOTNS_READY
  ...
  clone3(CLONE_INTO_ROOTNS)
    rootns->state =3D ROOTNS_RUNNING
  umount2("/", MNT_DETACH)
    detaches M1 from nullfs
                                        vfs_move_mount() -> attaches M2
                                        spin_lock(&rootns->lock)
                                        rootns->root =3D M2  <-- leaks M1 p=
ath
                                        rootns->state =3D ROOTNS_READY
                                          <-- resets state from RUNNING

Overwriting rootns->root without path_put() leaks M1's vfsmount and dentry
references and races with lockless readers of rootns->root in
filename_lookup() and copy_fs().  Resetting rootns->state to ROOTNS_READY
also allows a second clone3(CLONE_INTO_ROOTNS) to run the init bootstrap pa=
th
in copy_rootns(), overwriting rootns->init_pid without put_pid() and taking
an extra get_rootns() reference that exit_rootns() never drops.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117231352.3816=
603-1-jarkko@kernel.org?part=3D9

