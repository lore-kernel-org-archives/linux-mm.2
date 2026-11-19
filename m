Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4DA606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZSqRwwEJ
Received: by kanga.kvack.org (Postfix)
	id E19D06B06DE; Thu, 19 Nov 2026 14:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1BD6B06E0; Thu, 19 Nov 2026 14:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07216B06E1; Thu, 19 Nov 2026 14:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6926B06DE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:37:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23D181206CD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:04 +0000 (UTC)
X-FDA: 85452876768.01.6D9E0F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 81AE3180025
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSqRwwEJ;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795117022;
	b=mTRn0noR1CZmTHTZoBOHPnu8r1oasr/RJ/hoin3InOPVXdAUnn6g+H/N/F8YiwnLSTJ66/
	HIOCX8IyUh3ZJF5AmqZ4oUB15LJpsXFp6cFpq6Qht6mh353XRZBcuh3s4hHMiDMgH2lIiz
	JQZXjamP7xIrYKuIW31I0MtJtxUEKbA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSqRwwEJ;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795117022;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vseJADEhUVR3qJjeERQiwT718kqYTn+mJBjn439uKzA=;
	b=zECOSDpfSt2stnDvxcRAr380RxJU/luyv5zKxT1/RfvtHcGh/czf7o3y6G/C3I4fnr3huB
	afycgt3txVeYQz3UwX95UNaSPY/ZpHnB4i5IIN6hzBEkOw4jP/VeRp6WDuuIG8QpmOatys
	eRcFFp59DlUnTHs8ayS7Kt373K6UHVE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1552061387;
	Thu, 19 Nov 2026 19:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65F51F000C4;
	Thu, 19 Nov 2026 19:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117021;
	bh=vseJADEhUVR3qJjeERQiwT718kqYTn+mJBjn439uKzA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZSqRwwEJ8v4/msck0OfXw6FUg3Jt3gV/YlSN4DIMq1XeYrk2JkRDgNFgsE1N80bkU
	 rZ21PaBtXNKUfzL3wcF1Hn3VkOVldEg1rSLkmb2Til6VdQG6whARsqq1nEW1FbtF7O
	 EH7xYYae4R3l4EBUCDhqIz/L7jd90PxNi1kl1pDyhPeDEx4+eptmJFLS4MzbbIjLQ+
	 tJQkTgiRl2aYpNTQm+4FtsCQ48SgFtOdmeSCbXndys9b8jnRA6ehlBO5Dw8jTmZxVt
	 FEFY5/q7eEUJf0pNatAa/SbQBcdfa0wxeHAZA2akxGuny2LmNWL+H4vz2PDXX1olJO
	 hLIbMmL71OzlQ==
Message-ID: <sashiko-outbox-223951@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 09/13] fs: Support MOVE_MOUNT_T_MNTNS in
 move_mount()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "David Howells" <dhowells@redhat.com>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>, "Andy
 Lutomirski" <luto@amacapital.net>, "Anna-Maria Behnsen" <anna-maria@linutronix.de>, "Ben
 Segall" <bsegall@google.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Davidlohr Bueso" <dave@stgolabs.net>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Frederic Weisbecker" <frederic@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Jan Kara" <jack@suse.cz>, "John Johansen" <john.johansen@canonical.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Juri Lelli" <juri.lelli@redhat.com>, "Kees Cook" <kees@kernel.org>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Manfred Spraul" <manfred@colorfullife.com>, "Mel
 Gorman" <mgorman@suse.de>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Neal
 Gompa" <neal@gompa.dev>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Peter Zijlstra" <peterz@infradead.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Thomas Gleixner" <tglx@kernel.org>, "Valentin
 Schneider" <vschneid@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261118193539.240065-10-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <20261118193539.240065-10-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 19:36:59 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 81AE3180025
X-Stat-Signature: qx4axyrofyq3xrbkjus3isacbg39oknw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795117022-161338
X-HE-Meta: U2FsdGVkX1+dJgn2i/QzRu3Y4UnO4qTcbEzsMQ/IpbihtrWIWjA935aHQNY5I/bEPWR756Y4syc6vQP4p2aP4vt1nA9PNKqPC5E4ZLGU6BZo22AxXKmmxUVXxW+99yqEepY6mWRWRcDEvnInUMPkdkezFJuASEqg+GNliiJ9Z0Znz4dZmWSvqnQVfr8plV382alKg4IOuY6z3fpBNx5++Xkx1s44bPDMSoZKPDrBV2JIrr9no3sibz/cHMYBezJiSLEHgESEvoHk4qMyzKCputoblrKmfeSXDOhbBBXnbWc3g1b4EZLmPTvX5gVjq+ZzWfzbMAgQgehQVlngGUvIJ+igung/kuzOOumwE3D7+MBj8BnUP12ayFgmjE/dKdlUgHnOH14pfcNbHepBlQ6vwGvkqSuScsbW0eofqwcBqtIVRVmGww7NwyWRb3go7BG6bJy98+XLt8rZoCVkbqo8UQ/vX3jWaRYuEaT5V0H9gmFaSlkt6yfC6X1Vx4lXsSzHqpbnIRvFwxmLYVTwpHQK49HzRhHSvtBoxJWV4U5rOprNGfhAiZiPInv4BxAsjaPbJWQNCgu/HaRLoj/e5Vd4s56vc/MOl9q9o0QCydwJtgiZacd7lwLHtWcTnxHD9k3Vu/wt+x93SB8TXu4Et7ZtYDd46OjO18FETiP9C5rbc209mGJMQ4a3bjhVfRnwSMFBjByvwDtMrlSxK9oEoC5RTC4wUHUorxvXP1ZUgjbEaUXGuFcolh9opv8d4yXTrpEqiVjur5GbkSvt5iaJwJGrIl88mHMqGv0yt0tUUcflApbb7+T/slirYrPHYRdfWBeRe9EMdbCrcaaSpi6nUjCqYeEJ3m14hMN9EvRyoIk7Zcn40bzJ719hsKnInBKKWmKxhpftR2LSXmPHJT9I97QZefQTeYiGbRLrRAyCL0RMbBIoDadvWz4kMvYjQDHrSHHuHTKP2yHjUO5mWOP4hoR
 M1O0NUp6
 RKKPbe099AqRAw8vXljobi1otMi6NDsNZtYap8LqO4KatXPbAmET//wvBabrJ7VES4csZT4krn/sQPRDLIeF2Z9d+okdh4BrcmPDhHQZ7PWwv3QNen2ZMZ6v2hWskS6X1UfrJq8MqCkxoc653iDNarSP5APBIx/ihQ0nzwjocsbjfTqi+fExhd/C+cRPa6ne+kU0H/0yHGV6U+1XdrufmzNfQPQTGT8xCqnxrhQBQ0kFRLQT8jkAD2wj427V9jPT5u2ShZHkpLh6D4NZ6HQpu5hUqEoWLOqAusRRrHcNNP1K7fFpMVIlVIyBy38tRFAt9vSXFmn4twQLnikWZCB8dN2VyJ3Hm79LNdIrygFyT2SH/CwBWHbT53Wix+3FHLnDG5+IrBogNmmnLMkBkugByCbodOtDpqYb7p5pdGAGYVoLt64/g2ByPQ34Ccouhpqr//eswlCPyAJGQ9KzYr4E+gj2R8ZHOyzdknHtP5c5byXgRcCRayDyeBnM3kYLDUKcRM5H0iQTLFtTPbOdYZQ3xBZbUrouK9GBTOdOq+WysOuGhfYKHjbAGQ3kowzRSoNs+U2rThnEYfzbdmsFYSC9SA73jCkginQPJdDKRrg4t9a6nghYOc+YZA8L+YjiQWBjJHvuKUzS+1dS6w7s=
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
- [High] fs: broken cross-userns mount locking in attach_recursive_mnt()
- [High] fs: relative root-mount alias bypass and unlocked check in
  move_mount_mntns()
--

commit 444327893c38a5707689f91b2605debf89b46300
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support MOVE_MOUNT_T_MNTNS in move_mount()

This commit adds the MOVE_MOUNT_T_MNTNS flag to move_mount() to allow
attaching detached anonymous mount trees directly into a target mount
namespace identified by an nsfs file descriptor.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index a6c0a31e275ae..2bd973a490d34 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
[ ... ]
> @@ -2639,6 +2648,7 @@ static int attach_recursive_mnt(struct mount *sourc=
e_mnt,
>  	HLIST_HEAD(tree_list);
>  	struct mnt_namespace *ns =3D dest_mnt->mnt_ns;
>  	struct user_namespace *user_ns =3D ns->user_ns;
> +	struct user_namespace *source_user_ns;
>  	struct pinned_mountpoint root =3D {};
>  	struct mountpoint *shorter =3D NULL;
>  	struct mount *child, *p;
> @@ -2662,6 +2672,8 @@ static int attach_recursive_mnt(struct mount *sourc=
e_mnt,
>  		user_ns =3D current->nsproxy->mnt_ns->user_ns;
>  	else
>  		user_ns =3D ns->user_ns;
> +	source_user_ns =3D (!moving && source_mnt->mnt_ns) ?
> +			 source_mnt->mnt_ns->user_ns : user_ns;
> =20
>  	/*
>  	 * Preallocate a mountpoint in case the new mounts need to be
> @@ -2730,6 +2742,12 @@ static int attach_recursive_mnt(struct mount *sour=
ce_mnt,
>  		/* Notice when we are propagating across user namespaces */
>  		if (child->mnt_parent->mnt_ns->user_ns !=3D user_ns)
>  			lock_mnt_tree(child);
> +		if (!is_anon_ns(child->mnt_parent->mnt_ns) &&
> +		    child->mnt_parent->mnt_ns->user_ns !=3D source_user_ns) {
> +			lock_mnt_tree(child);
> +			if (list_empty(&child->mnt_expire))
> +				child->mnt.mnt_flags |=3D MNT_LOCKED;
> +		}
>  		q =3D __lookup_mnt(&child->mnt_parent->mnt,
>  				 child->mnt_mountpoint);
>  		commit_tree(child);

[Severity: High]
Can cross-user-namespace mount locking be bypassed when a detached mount
tree is staged onto an anonymous mount before being attached to a target
mount namespace?

If an anonymous mount tree S owned by a privileged user namespace is
attached via move_mount() onto a subdirectory of an anonymous mount R
owned by a less-privileged user_ns_B (for example, created with
FSCONFIG_SET_ROOTNS or by a task in user_ns_B),
is_anon_ns(child->mnt_parent->mnt_ns) is true, so the new source_user_ns
check is skipped.  If the caller is in user_ns_B, user_ns is also
user_ns_B, so lock_mnt_tree() is not called either.  commit_tree(S) then
moves every mount in S into R->mnt_ns (owned by user_ns_B), so when R is
later attached into a mount namespace owned by user_ns_B,
source_user_ns =3D=3D user_ns_B and S is never locked, allowing tasks in
user_ns_B to unmount masked directories or clear read-only/nosuid/nodev/
noexec flags.

Conversely, when a privileged manager in init_user_ns attaches a submount
owned by user_ns_B onto an anonymous root mount R also owned by user_ns_B
(via FSCONFIG_SET_ROOTNS), is_anon_ns(ns) sets user_ns to init_user_ns
rather than ns->user_ns, so child->mnt_parent->mnt_ns->user_ns !=3D user_ns
spuriously locks the submount.

In addition, tree_list contains all secondary mounts created by
propagate_mnt(), and for normal mounts or automounts source_user_ns equals
user_ns.  Every secondary copy propagated into a non-anonymous mount
namespace in another user namespace therefore hits this block and gets
MNT_LOCKED set on its root even when q =3D=3D NULL (nothing was covered at
the mountpoint), preventing unprivileged users or shrink_submounts() from
unmounting uncovered propagated mounts.  And because source_user_ns is
computed unconditionally for all !moving mounts, regular move_mount()
without MOVE_MOUNT_T_MNTNS also locks detached trees intentionally handed
over across user namespaces via SCM_RIGHTS or inheritance, regressing
33aadc7c7205 ("namespace: handle mount locking for automounts correctly").

[ ... ]

> @@ -4751,6 +4778,127 @@ static inline int vfs_move_mount(const struct pat=
h *from_path,
[ ... ]
> +static int move_mount_mntns(int from_dfd, const char __user *from_pathna=
me,
> +			    int to_dfd, const char __user *to_pathname,
> +			    unsigned int flags, enum mnt_tree_flags_t mflags)
> +{
[ ... ]
> +		lflags =3D 0;
> +		if (flags & MOVE_MOUNT_T_SYMLINKS)
> +			lflags |=3D LOOKUP_FOLLOW;
> +		if (flags & MOVE_MOUNT_T_AUTOMOUNTS)
> +			lflags |=3D LOOKUP_AUTOMOUNT;
> +		ret =3D filename_lookup(AT_FDCWD, to_name, lflags, &to_path,
> +				      &mntns_root);
> +		if (ret)
> +			return ret;
> +		if (real_mount(to_path.mnt)->mnt_ns !=3D target_mnt_ns ||
> +		    to_path.mnt =3D=3D &target_mnt_ns->root->mnt)
> +			return -EINVAL;
> +		if (real_mount(to_path.mnt)->mnt_parent =3D=3D target_mnt_ns->root &&
> +		    to_path.dentry =3D=3D to_path.mnt->mnt_root)
> +			return (flags & MOVE_MOUNT_BENEATH) ? -EINVAL : -EBUSY;
> +	}
> +
> +	ret =3D lookup_move_mount_from(from_dfd, from_pathname, flags,
> +				     &from_path);
> +	if (ret)
> +		return ret;
> +
> +	return vfs_move_mount(&from_path, &to_path, mflags | MNT_TREE_MNTNS);
> +}

[Severity: High]
Does the root-mount alias check in move_mount_mntns() miss any target
mount namespace where more than one mount is stacked on
target_mnt_ns->root?

mnt_ns_get_root() follows the entire overmount chain on
target_mnt_ns->root (nullfs) to the topmost live root mount in
mntns_root.  Whenever two or more mounts are stacked on
target_mnt_ns->root (for example nullfs -> rootfs -> real_root in a
cloned namespace, or a root that has been overmounted), the live root
mount's mnt_parent is the intermediate mount rather than
target_mnt_ns->root.  A relative path such as "." or "subdir/.." then
resolves to mntns_root with mnt_parent !=3D target_mnt_ns->root, bypassing
this check and allowing the caller to overmount the namespace root or
mount beneath it with MOVE_MOUNT_BENEATH.

Also, filename_lookup() does not enforce LOOKUP_IS_SCOPED (or recheck
reachability from mntns_root under lock), so following a procfs magic link
inside target_mnt_ns can escape to a mount outside or beneath mntns_root.
Finally, these checks inspect to_path.mnt->mnt_ns and mnt_parent without
holding namespace_sem or mount_lock, and do_move_mount() only revalidates
MNT_TREE_MNTNS_INIT after locking the mountpoint; if a resolved submount
is concurrently pivoted to the root of target_mnt_ns before
do_lock_mount() acquires namespace_lock(), MOVE_MOUNT_BENEATH will attach
the new mount directly onto target_mnt_ns->root beneath the namespace
root.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118193539.2400=
65-1-jarkko@kernel.org?part=3D9

