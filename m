Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4506E606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A0t8cgYj
Received: by kanga.kvack.org (Postfix)
	id D7ECA6B065D; Thu, 19 Nov 2026 14:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56606B06A6; Thu, 19 Nov 2026 14:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92F26B06D3; Thu, 19 Nov 2026 14:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8719B6B065D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:37:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10F31A8919
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:15 +0000 (UTC)
X-FDA: 85452877230.22.2F2E1CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C957C1C001B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:36:57 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795117017;
	b=ssdzTWTYhp2n85i7LFbqNeM4yZDzjE5VDyOUlIQfbdljCS+HdbAw9/zH3KdifiVnrebvrs
	0tBMFjk4wLhM9uJXjYw4qUSm4xkV6AuEqxOdXqaHTOtD961DH3jrUKdSgnZ29OjCW6Znsp
	TqyPy8wcv2t/HwRrRtMYN/Ujb97Kr6E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795117017;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPCfyQMBDaj1TbPn1uY7ZKnrTLkWSMQ5rKa7r8FopMc=;
	b=N3/+OJr5m9vJWcLDLJhrbwLNafv1R9mCf1jE0TGG3Br9AWFx9wfgzJR1fmqFftO6nlqMah
	xcNDUk0mT75nq4QqPGp3xCoxqvyg4umnlJoAhORui+0qMn7xgugxWDEsLGHBCP5KmXpuBY
	pBM2f4vWOD5GhY5fd+kBjK1FxCn7xZk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0t8cgYj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 586F961D4A;
	Thu, 19 Nov 2026 19:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB0C1F000C7;
	Thu, 19 Nov 2026 19:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117017;
	bh=rPCfyQMBDaj1TbPn1uY7ZKnrTLkWSMQ5rKa7r8FopMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A0t8cgYjumMBWfIdIu4VFg/UwUutlWz9at3G2exj66B9crjo8Wfq2gdk+wFGA/mQX
	 i+B31+b8PpQZ64PmnXlOXLXpYNqXHE55/DvkWgTXbKfiijxzoc6NcplRCbN1NPcF1Q
	 VJDp8TT82yFYzmKo8GQuFpd3Q7ItLZntarvREBVbROUGAG0Ok6gBnBDpNx/ecnA+33
	 grSGtxpgn0T3a6lkDXKoOdy4h+756FLjNAtBiPXFRfbj3Z1QfZouLwSikQnEAtjfep
	 cv+p8DSeZrRvrcksbgjWfefuzhFfTSoBSNea95uwjXhFDqYcyt3jUJUzJBPGyg080w
	 ROuUll094XRgQ==
Message-ID: <sashiko-outbox-223949@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 07/13] fork: Support CLONE_INTO_ROOTNS in
 clone3()
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
In-Reply-To: <20261118193539.240065-8-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <20261118193539.240065-8-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 19:36:54 +0000
X-HE-Tag: 1795117017-490340
X-HE-Meta: U2FsdGVkX1+ps31sFtSxxtslUgiv+3T+74qX0FtbalmlArib1lRaKpnJdGa/5Rs6Yc6I1cOTING0L0RHdcYDa5L7+oNcxT3I22wceiMtVzonwDYy8Pas0cbDAmWQakzjX8paGM7DaGuT0PKwhC1D8LBrADmZIUOsKuwDytxZxkwzVz7WScD25FPtO1PxIpf5TKlNH6J6X56dRznoE4pdoY22jreidHqqBORG3a5uhUH2QKqrX93RTV+9wvcADh/dFxZuGpu0q8O8uk7lY7lhpeUj6df/RT0Oas6e3hmbHAismVIVCWfOnSLc5ckzU6ohw9eANTEUGsuWvrhvc2CMyMkm2hjIGzEhXO7F7CCiZSGGCyry5Pa1HYI5cr0PrIyssfqZTknksCvO5PCHa7UZI2/W4P4hXRd/yXYJrNgzCsQ+iN3PaIenOcH02E8TqtK7/cCeh2ug6YE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] cred: missing dumpability reset across userns without CLONE_VM
  in copy_creds()
- [Medium] fork: missing CAP_SYS_CHROOT check and umask reset to init_fs
  in copy_fs()
- [Medium] nsproxy: shared mm and timens vvar mismatch in
  copy_namespaces()
- [Low] rootns: wrong errno on external PID 1 race during bootstrap in
  copy_process()
--

commit 9762bc2570e709528c82312b63771aa4f8d6c6d8
Author: Jarkko Sakkinen <jarkko@kernel.org>

fork: Support CLONE_INTO_ROOTNS in clone3()

This commit adds CLONE_INTO_ROOTNS and struct clone_args.rootns to spawn a
child process directly into a target root namespace via clone3().

> diff --git a/kernel/cred.c b/kernel/cred.c
> index d01df40a9a386..5bc3d455141b5 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
[ ... ]
> @@ -287,6 +294,28 @@ int copy_creds(struct task_struct *p, u64 clone_flag=
s)
>  	if (!new)
>  		return -ENOMEM;
> =20
> +	if (rootns) {
> +		const struct cred *old =3D current_cred();
> +
> +		if (!ns_capable(rootns->user_ns, CAP_SYS_ADMIN)) {
> +			ret =3D -EPERM;
> +			goto error_put;
> +		}
> +		if (new->user_ns !=3D rootns->user_ns) {
> +			ret =3D install_user_ns_cred(new, rootns->user_ns);
> +			if (ret < 0)
> +				goto error_put;
> +		}
> +		if (!cred_cap_issubset(old, new) ||
> +		    ((clone_flags & CLONE_VM) && old->user_ns !=3D new->user_ns)) {
> +			struct task_exec_state *exec_state;
> +
> +			exec_state =3D rcu_dereference_protected(p->exec_state, true);
> +			if (exec_state !=3D &init_task_exec_state)
> +				WRITE_ONCE(exec_state->dumpable, suid_dumpable);
> +		}
> +	}

[Severity: High]
Should exec_state->dumpable be reset whenever old->user_ns !=3D new->user_n=
s,
even when CLONE_VM is not set?

When a dumpable daemon (TASK_DUMPABLE_OWNER) creates a rootns and spawns a
child into it without CLONE_VM, old->euid owns rootns->user_ns, so
cred_cap_issubset(old, new) returns true:

kernel/cred.c:cred_cap_issubset() {
    ...
	for (;subset_ns !=3D &init_user_ns; subset_ns =3D subset_ns->parent) {
		if ((set_ns =3D=3D subset_ns->parent)  &&
		    uid_eq(subset_ns->owner, set->euid))
			return true;
	}
    ...
}

Because CLONE_VM is clear, p->exec_state->dumpable remains
TASK_DUMPABLE_OWNER while p->real_cred->user_ns is switched to
rootns->user_ns.  In __ptrace_may_access(), a process in rootns->user_ns
with CAP_SYS_PTRACE passes ptrace_has_cap(tcred->user_ns, mode), and
task_still_dumpable() returns true on TASK_DUMPABLE_OWNER without checking
ptrace_has_cap(exec_state->user_ns, mode).  Until the child changes UID or
calls execve(), an unprivileged container root process can attach via
ptrace or read /proc/<pid>/mem and /proc/<pid>/fd/* while the child still
holds the parent daemon's forked memory, O_CLOEXEC descriptors, and host
UID.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 08fc28ad1eedf..f5b98eea9ce92 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
[ ... ]
> @@ -1649,7 +1672,7 @@ static int copy_fs(u64 clone_flags, struct task_str=
uct *tsk,
>  		if (current->nsproxy->mnt_ns !=3D &init_mnt_ns)
>  			return -EINVAL;
>  		fs =3D userspace_init_fs;
> -	} else if (flags & COPY_FS_IDLE) {
> +	} else if (flags & COPY_FS_IDLE || rootns) {
>  		fs =3D &init_fs;
>  	} else {
>  		fs =3D current->fs;
> @@ -1671,6 +1694,20 @@ static int copy_fs(u64 clone_flags, struct task_st=
ruct *tsk,
>  	tsk->real_fs =3D tsk->fs =3D copy_fs_struct(fs);
>  	if (!tsk->fs)
>  		return -ENOMEM;
> +	if (rootns) {
> +		struct path root __free(path_put) =3D {};
> +		int err;
> +
> +		err =3D mnt_ns_get_root(rootns->ns->mnt_ns, &root);
> +		if (err) {
> +			free_fs_struct(tsk->fs);
> +			tsk->real_fs =3D NULL;
> +			tsk->fs =3D NULL;
> +			return err;
> +		}
> +		set_fs_root(tsk->fs, &root);
> +		set_fs_pwd(tsk->fs, &root);
> +	}
>  	return 0;
>  }

[Severity: Medium]
Does copying init_fs when rootns is set discard current->fs->umask, and
should changing tsk->fs->root require CAP_SYS_CHROOT in rootns->user_ns?

Selecting init_fs causes copy_fs_struct() to initialize tsk->fs->umask from
init_fs.umask (0022) instead of inheriting the parent's umask.  In
addition, unlike mntns_install() on setns(CLONE_NEWNS), neither
rootns_prepare_fork() nor copy_creds() checks ns_capable(rootns->user_ns,
CAP_SYS_CHROOT).  A chrooted process already running in rootns->user_ns
that has dropped CAP_SYS_CHROOT while retaining CAP_SYS_ADMIN can call
clone3(CLONE_INTO_ROOTNS) to spawn a child with fs->root reset to the mount
namespace root and escape its chroot.

[ ... ]

> @@ -2510,6 +2548,12 @@ __latent_entropy struct task_struct *copy_process(
>  		goto bad_fork_core_free;
>  	}
> =20
> +	if (unlikely(clone_args_rootns_bootstrapping(args) &&
> +		     !is_child_reaper(pid))) {
> +		retval =3D -EBUSY;
> +		goto bad_fork_core_free;
> +	}
> +
>  	/* Let kill terminate clone/fork in the middle */
>  	if (fatal_signal_pending(current)) {
>  		retval =3D -EINTR;
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 8a3c6d4e94e2a..ec8b6fac7fbf1 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -166,12 +167,21 @@ struct nsproxy *create_new_namespaces(u64 flags,
>   * called from clone.  This now handles copy for nsproxy and all
>   * namespaces therein.
>   */
> -int copy_namespaces(u64 flags, struct task_struct *tsk)
> +int copy_namespaces(u64 flags, struct task_struct *tsk,
> +		    struct rootns *rootns)
>  {
>  	struct nsproxy *old_ns =3D tsk->nsproxy;
>  	struct user_namespace *user_ns =3D task_cred_xxx(tsk, user_ns);
>  	struct nsproxy *new_ns;
> =20
> +	if (rootns) {
> +		if (old_ns->time_ns !=3D rootns->ns->time_ns)
> +			timens_commit_fork(tsk, rootns->ns->time_ns,
> +					   flags & CLONE_VM);
> +		get_nsproxy(rootns->ns);
> +		tsk->nsproxy =3D rootns->ns;
> +		return 0;
> +	}

[Severity: Medium]
Can switching tsk->nsproxy->time_ns under CLONE_VM | CLONE_VFORK install the
child time namespace's vvar page into the parent's shared mm_struct?

When clone3() is called with CLONE_INTO_ROOTNS | CLONE_VM | CLONE_VFORK and
rootns has a different time namespace, timens_commit_fork() skips
vdso_join_timens() because shared_vm is true, while tsk->nsproxy is switched
immediately to rootns->ns (where time_ns =3D=3D time_ns_for_children).  The
parent and the vfork child now share current->mm while having different
nsproxy->time_ns pointers.

If VDSO_TIME_PAGE_OFFSET in the shared mm's [vvar] VMA has not been faulted
in yet and the child calls a VDSO time function before execve(),
vvar_fault() calls find_timens_vvar_page(), which sees vma->vm_mm =3D=3D
current->mm and maps rootns->ns->time_ns->vvar_page into the shared page
tables.  Because time_ns already equals time_ns_for_children in rootns->ns,
exec_task_namespaces() on the child's later execve() is a no-op, leaving
the parent's mm permanently mapped to the child time namespace's vvar page.
Conversely, if the parent already faulted [vvar] before clone3(), the child
observes the parent's time namespace through VDSO and rootns->ns->time_ns
through syscalls until execve().

Also, calling timens_set_vvar_page() in copy_namespaces() before fallible
steps in copy_process() (such as alloc_pid() and cgroup_can_fork())
permanently sets rootns->ns->time_ns->frozen_offsets =3D true even when the
fork fails.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index 32bb8ef5ed584..cfc33c243dba4 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
[ ... ]
> +int rootns_finish_fork(struct kernel_clone_args *args, struct task_struc=
t *p)
> +{
> +	struct file *file __free(fput) =3D args->rootns_file;
> +	struct rootns *rootns =3D args->rootns;
> +	struct pid_namespace *pid_ns =3D rootns->ns->pid_ns_for_children;
> +	int ret;
> +
> +	args->rootns_file =3D NULL;
> +	args->rootns =3D NULL;
> +	if (!IS_ERR(p))
> +		return 0;
> +
> +	ret =3D PTR_ERR(p);
> +	if (args->rootns_bootstrapping) {
> +		scoped_guard(spinlock, &rootns->lock) {
> +			if (rootns->state =3D=3D ROOTNS_FORKING)
> +				WRITE_ONCE(rootns->state, ROOTNS_INIT);
> +		}
> +		wake_up_all(&rootns->waitq);
> +	} else if (ret =3D=3D -ENOMEM &&
> +		   !(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING)) {
> +		return -ESRCH;
> +	}
> +
> +	return ret;
> +}

[Severity: Low]
Can a bootstrap race with an external fork into pid_ns return -EINVAL or
-ENOMEM instead of the documented -EBUSY or -ESRCH?

If an external process enters pid_ns and allocates PID 1 in alloc_pid()
after rootns_prepare_fork() checks READ_ONCE(pid_ns->child_reaper) but
before setting child_reaper under tasklist_lock, the bootstrapping task's
alloc_pid() allocates nr =3D=3D 2 while child_reaper is still NULL and fails
with -EINVAL, never reaching the !is_child_reaper(pid) check in
copy_process().  Similarly, if that external PID 1 exits and clears
PIDNS_ADDING before the bootstrapping task finishes copy_process(),
copy_process() returns -ENOMEM, and rootns_finish_fork() only translates
-ENOMEM to -ESRCH in the !args->rootns_bootstrapping branch.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118193539.2400=
65-1-jarkko@kernel.org?part=3D7

