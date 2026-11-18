Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682CB606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W7MOs0zo
Received: by kanga.kvack.org (Postfix)
	id 483CE6B05B8; Wed, 18 Nov 2026 00:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B2B6B05B9; Wed, 18 Nov 2026 00:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4E96B05BA; Wed, 18 Nov 2026 00:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EADB56B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:09:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73E871C3C70
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:58 +0000 (UTC)
X-FDA: 85447062876.12.99BE02D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C645E180005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7MOs0zo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794978597;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fG2LciqDSXyz8Yh1zVxRp0Ndjfjn2LOhK7/21wqIDs=;
	b=E952QFnTye84T0O9sY34duen9SJyQYLDQSDRvnIXwuzsDjwZP/X6+I9z+7zbmSLOdWz9JZ
	la3L3f/QyCG9kN6xNzIviOL1L1aer5bEqk7WvKxdm1tC7J5F0IhZs4bVtvWBZAcYV0zc+E
	ppvZz2b9uf2OfazmffXavridhA1nUxk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794978597;
	b=2yNHyBtjem4hD0BYfC0JOf8zthnjIrl37tGIBUYeqQlHnIx9iSllrT4TjkUZ1mq+jUmp1N
	DvPKlQoPdw2QX8JetMjZJpAhdzCYgQ/fEb3fzzk9E6kSIOgKaJn7Utu39qqfjBUgm3SUVZ
	KDX7ArUFdply8gnnefNWomDqDC8Udhg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7MOs0zo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13780435A0;
	Wed, 18 Nov 2026 05:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662061F000C6;
	Wed, 18 Nov 2026 05:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978596;
	bh=0fG2LciqDSXyz8Yh1zVxRp0Ndjfjn2LOhK7/21wqIDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W7MOs0zoU0ucej7mmIVnje7WhebPC7DUYojzna+sm6WBJx6sCSWg4wwm/uqyJNjru
	 DUldrGtT4VVoONFkyGixE0AnU5d2dfQlO0v+Y8sKo26yopdadKKPy0yyjJ/vM+Tep4
	 4y1bBOdtKlX0z73qf8DyhO3+QSHD5erejulUtQfc0lXqNpQDxE2744+kgOJXBzigpH
	 tAKr6dhr0oX/oTC2id/22naPLK8LBHQHwRdGiInmZCE9DSd2Lqv3x2S+htkHK6pQ/Q
	 mLsCHVspDE6zxKxUQkqZr2NygLawn6oWiZxGMk3g3ZDDD3URClZAyP01Y8Bc6hUojQ
	 ibmdRxskgzyFw==
Message-ID: <sashiko-outbox-220144@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 09/13] fs: Support installing rootns mount trees via
 move_mount()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Ben
 Segall" <bsegall@google.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Howells" <dhowells@redhat.com>, "Davidlohr
 Bueso" <dave@stgolabs.net>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K Prateek
 Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Vlastimil Babka" <vbabka@kernel.org>
In-Reply-To: <20261117050841.3289652-10-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-10-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:09:54 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C645E180005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 53qjq7eco9gwnqbike9f7efhzbhhn8re
X-Rspam-User: 
X-HE-Tag: 1794978596-159946
X-HE-Meta: U2FsdGVkX18GFN5dLsCnUIOchLf2ZfcomCJk9RCkWg45U1NnARTbkWUYh1bcAGdDQDyePcjHuTx/4zLMGBuMO3n5iH4PRrzeppQtJa46UF1L2KAeWZ2k6xxNIpv8Tcqn2b3PHcncMqGB5FKScTzUuLpYlzNvQQM47vggpTC1cfTJQSo6RumOiN8nwqDBzRnBLciI/CMrv0V+Uffgk94ayHvOsI0vP6brZUvUqoVg8ENyFNL7b65i8WlNPNWDQlYDG2EthLbkKHf9liLiMq0QBc+fK2JRvZtUhmYMxhfN5drJAQj8QX18wLusJ5NwBFJ/wNba/qcMbumgociV27V8zYkaeoRRC1+1ilO5E6P4PzBj0cQ8GAg1Nl5knDhGxZcBg82nvaMN+iRa1SjMhzDxaRJjgD946MR+kdhlu1l2fsZG7oODj5OKYAUjm8bwIqz3UPWCXZZ3AlHaZFKpOz7WQorRuh+fmRd+mKEoNRu2jtSlRZvSkMw5vqP6mmxNeA5U1irT5ZIxCjOyRB8PDa8ZwXgHIchw1fmhn7DwMr4jPVLrBaHkyzLcXyrBhO+GBm3Gao++MOqWeDqC5zE+BUMM6FS6T24gyQGSAPDdx1jculFzY/s8KFFUGN03DuhEvRIL73ptl2tJp/BJgSjEkUtphjg1tvzGPghTVaIhvRFIdd5Hy5a8xPAuKxCTTaMd5ng+d8xJVYNOu6JsVBkPQ7g222+N3lIEG7jkLYJLp3FfHfZWqN9jxXM0Vy/b2ex1R0z3lCOf3tnh8vxt+fgVohtXh2OCs3N/EWY03qDzaEEe1WTnEizGrzKO21MjSfXNKuuKhgbPyzwQLi2A5xge8B/ST/Xtee0DeHsQG0e+/yTNCHiSFFLuFA9UFppfX5kQiVmLMO0dB4KBFgLFMGoq4lqCYjL/iu3IpmEGBwfWT7VAYmr1EUTWI53T7n+uPygoE+JDZYSvNDqai6tlS2VOY9O
 +WPRpkhx
 K6mMmaUk/W9NZNRpb+jYHqwE2eS9uw+44DJgaBkP6uCBXu9N5sZWoloRVu9DdXegl1uxkIAMpOvlNvMyfT6AqzzQzAqvkCanQDyvQ1LBgOMsWEf8cNzX6noTz+iokukuOZz9W22+ajR5wwnlLxlSugU0icHSDkfVNQrTM/NpLCgqMDO3vvJOkFIlDkmmu6xCZtknwioV0ypErd1CfJ1dvi07bmp1ITNA3Bqyv62TxZ8GTizMFygP+n6sj1Klh5oBwhxH/JPN4SuoSDuYgbjAvaI/KehC0PKqaOGpUBU0WhnylSjXS6BCyredQ9z96ujp5djJyt6d/6E+YeOrXr7+vj/T4lRALsp0dgskMco6fUM+ewLCS6Zdjz0T7+2pjJM+q/ztWQYztJQZHONaPkU+FSFD7AAjkMEAARrTVZFXtRjiB2uUjqnRIdRXvz6jTehUQ+CT97LVOjiSpJn9PPmaAzUm2LQ+AYsvntqK/2qrdFNZTp4NvT8SKOidVNGHjYpNXUvg96bood+VyXkeZFplmrlWwH3zHDnNZRfHgNYPaWJN8Eb/i0ZOqx9j/9rYNnLopxdVXnLj8cTjTs7yTXfdc25cBdPGllH2EC0KBGQbVOkE5R76qGNGb79wmbEjOSBI6jEMvpSORIODkPTs=
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
- [High] fs: do_move_mount() calls lock_mnt_tree() after
  attach_recursive_mnt()
- [High] fs: relative target paths in move_mount_rootns() bypass is_root
  checks
- [High] fs: TOCTOU race on rootns->state in move_mount_rootns()
  corrupts state
- [High] fs: fsmount() alloc_mnt_ns(fc->user_ns) bypasses submount
  MNT_LOCKED
- [High] fs: check_for_nsfs_mounts() checks caller mnt_ns instead of
  rootns target
--

commit b8cf56b982aa2378115c847c099e10376c22e6b8
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support installing rootns mount trees via move_mount()

This commit adds MOVE_MOUNT_T_ROOTNS_ROOT to move_mount() to allow
installing detached anonymous mount trees into a target rootns via its
control file descriptor, and allocates fsmount() anonymous mount
namespaces in fc->user_ns.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index aecd05ac01705..5376d0230899a 100644
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
[ ... ]
> @@ -3845,7 +3855,16 @@ static int do_move_mount(const struct path *old_pa=
th,
>  	if (mount_is_ancestor(old, mp.parent))
>  		return -ELOOP;

[Severity: High]
Just above this line, do_move_mount() calls check_for_nsfs_mounts(old),
which checks mnt_ns_loop():

fs/namespace.c:mnt_ns_loop() {
    ...
	return current->nsproxy->mnt_ns->ns.ns_id >=3D mnt_ns->ns.ns_id;
}

When MNT_TREE_ROOTNS is set, the destination mount namespace is
mp.parent->mnt_ns rather than current->nsproxy->mnt_ns.  Can a caller in an
older mount namespace clone an nsfs mount of rootns_mnt_ns with
open_tree(OPEN_TREE_CLONE) and attach it into rootns_mnt_ns via
MOVE_MOUNT_T_ROOTNS_ROOT?  Because current->nsproxy->mnt_ns->ns.ns_id is
smaller than rootns_mnt_ns->ns.ns_id, mnt_ns_loop() returns false, creating
an unbreakable reference cycle between rootns_mnt_ns and its nsfs inode
that permanently leaks the mount namespace and all mounts inside it.

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
Does calling lock_mnt_tree(old) after attach_recursive_mnt(old, &mp) happen
too late?

Inside attach_recursive_mnt(), when an existing mount q is present at the
destination (for example with MOVE_MOUNT_BENEATH or overmounting), q is
reparented onto topmost_overmount(old) via mnt_change_mountpoint() and has
MNT_LOCKED cleared on it so it remains unmountable.  Running
lock_mnt_tree(old) afterwards walks into q and all of its descendants
(since p !=3D old), setting MNT_LOCKED and MNT_LOCK_* on preexisting mounts
in the target rootns and preventing q from being unmounted.

In addition, if mp.parent is a shared mount, propagate_mnt() clones old
before lock_mnt_tree(old) runs.  Because attach_recursive_mnt() sets
user_ns =3D ns->user_ns (the target rootns user_ns rather than
old->mnt_ns->user_ns), child->mnt_parent->mnt_ns->user_ns !=3D user_ns is
false for peer and slave mounts in the target user_ns, leaving all
propagated copies unlocked without MNT_LOCKED or MNT_LOCK_* flags.
Finally, attach_recursive_mnt() commits old and drops mount_lock before
mount_writer is re-acquired here, briefly exposing the unlocked tree in
rootns_mnt_ns.

> @@ -4699,7 +4718,7 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, =
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
Can allocating the anonymous mount namespace in fc->user_ns leave host
submounts unlocked when a multi-mount tree is installed into an
unprivileged rootns?

When a process in init_user_ns configures a context with
FSCONFIG_SET_ROOTNS for a ROOTNS_USER rootns (user_ns_B), fc->user_ns is
user_ns_B, so fsmount() creates a root mount M_root with
M_root->mnt_ns->user_ns =3D=3D user_ns_B.  If the caller then attaches a ho=
st
submount M_sub from init_user_ns (such as a read-only bind mount or a
masking mount) onto M_root via move_mount(), attach_recursive_mnt() moves
M_sub into M_root->mnt_ns and calls lock_mnt_tree(M_sub):

fs/namespace.c:lock_mnt_tree() {
    ...
		if (list_empty(&p->mnt_expire) && p !=3D mnt)
			flags |=3D MNT_LOCKED;
    ...
}

That only sets MNT_LOCKED on descendants p !=3D M_sub, leaving M_sub itself
without MNT_LOCKED.  When M_root is subsequently installed into the rootns
via MOVE_MOUNT_T_ROOTNS_ROOT, old->mnt_ns->user_ns =3D=3D
mp.parent->mnt_ns->user_ns (both are user_ns_B), so lock_tree is false and
lock_mnt_tree(M_root) is never called.  Tasks in user_ns_B can then unmount
M_sub and expose the underlying directory.

Conversely, if the caller attaches a submount that was also created with
FSCONFIG_SET_ROOTNS onto M_root, attach_recursive_mnt() sets user_ns to
current->nsproxy->mnt_ns->user_ns (because is_anon_ns(M_root->mnt_ns) is
true) and spuriously locks the submount; and if an anonymous mount with
old->mnt_ns->user_ns !=3D mp.parent->mnt_ns->user_ns is attached via normal
move_mount() without MOVE_MOUNT_T_ROOTNS_ROOT, neither do_move_mount() nor
attach_recursive_mnt() locks the tree.

[ ... ]

> +static int move_mount_rootns(int from_dfd, const char __user *from_pathn=
ame,
> +			     int to_dfd, const char __user *to_pathname,
> +			     unsigned int flags, enum mnt_tree_flags_t mflags)
> +{
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
Can relative target paths such as ".", "subdir/..", or relative symlinks
to "/" bypass the is_root checks here?

Because is_root only tests for the literal string "/", passing "." enters
the else branch, where filename_lookup(..., &rootns->root) resolves to_path
to rootns->root itself:

1. With MOVE_MOUNT_BENEATH, this bypasses the MOVE_MOUNT_BENEATH check in
   the is_root branch, mounts from_path beneath rootns->root directly onto
   the nullfs root, and clears MNT_LOCKED on rootns->root in
   attach_recursive_mnt(), allowing an unprivileged rootns owner to unmount
   a cross-userns locked root mount.

2. Without MOVE_MOUNT_BENEATH, vfs_move_mount() runs without
   MNT_TREE_ROOTNS_INIT and overmounts rootns->root without updating
   rootns->root (and similarly on initial "/" installation if from_path
   already has overmounts on its root dentry, rootns->root =3D from_path
   stores the bottom mount rather than topmost_overmount()), leaving
   subsequent rootns_enter() tasks and relative lookups trapped in the
   shadowed lower mount.

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
Can a race on rootns->state when is_root is true overwrite rootns->root and
reset a running or dead rootns back to ROOTNS_READY?

CPU0                                  CPU1
move_mount_rootns(..., "/")           move_mount_rootns(..., "/")
  READ_ONCE(rootns->state)
    =3D=3D ROOTNS_EMPTY
                                        READ_ONCE(rootns->state)
                                          =3D=3D ROOTNS_EMPTY
                                        lookup_move_mount_from()
  vfs_move_mount() -> attaches M1
  rootns->root =3D M1
  rootns->state =3D ROOTNS_READY
rootns_enter()
  rootns->state =3D ROOTNS_RUNNING
  umount2("/", MNT_DETACH)
    (detaches M1 from nullfs)
                                        vfs_move_mount()
                                          mp.parent =3D=3D new_path->mnt
                                          attaches M2 onto nullfs
                                        rootns->root =3D M2
                                        rootns->state =3D ROOTNS_READY  <--=
 resets state

Because do_move_mount() with MNT_TREE_ROOTNS_INIT only checks whether
rootns_mnt_ns->root currently has an overmount (mp.parent !=3D
real_mount(new_path->mnt)), detaching M1 allows CPU1 to succeed.  CPU1 then
overwrites rootns->root without calling path_put() on M1 (and while
concurrent readers in filename_lookup() or copy_fs() may be reading
rootns->root without rootns->lock), and resets rootns->state to
ROOTNS_READY.  A subsequent rootns_enter() will then bootstrap a second
init process in copy_rootns(), overwriting c->init_pid without put_pid()
and taking a second get_rootns(c) reference that exit_rootns() never drops.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117050841.3289=
652-1-jarkko@kernel.org?part=3D9

