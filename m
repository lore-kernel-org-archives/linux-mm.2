Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93EC3606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l6rtjrD/
Received: by kanga.kvack.org (Postfix)
	id 177446B05F1; Wed, 18 Nov 2026 18:15:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEB96B0638; Wed, 18 Nov 2026 18:15:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E944D6B0639; Wed, 18 Nov 2026 18:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5CD06B0637
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:15:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 210B71408FD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:22 +0000 (UTC)
X-FDA: 85449798084.12.43884B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6C5AB20008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l6rtjrD/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043720;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UgqqzoOwyVS9t15jclCnf/wvXsyI8B5DG+Zmj+8bS0=;
	b=owe+l7SzZx3aZE7Yk90hDwhpSfkxAaKNA9kUusq32LjDyCgNpowYh6/5Mp2qQrVI2epUla
	2IajaSpOo9eyWZJjq+Au7edqIyFBbTQ73O8L4i51qpur7R00BW4+o+cDU+HfeNNGpKal1r
	ZtjB2yn6rL/LQsOMY4rIusUYgH6p1Ls=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l6rtjrD/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043720;
	b=llQITKvCeIMXWRvfkePcPj3aextHzV6r/2AjSijR4Ibdyyo3zlbms3Eh0WifcgcCd3Ozk6
	0DxBeMiRQ0+UAmyahRySIma41W1iS0d3PJRkifsuG9WE1awnkogSRGsnM6ZDm83pFAZKJC
	YwqEJaMHN3gQ5hFC0aC0Vcc0hGyn7cE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92E2B41AAE;
	Wed, 18 Nov 2026 23:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36EB1F000C4;
	Wed, 18 Nov 2026 23:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043719;
	bh=0UgqqzoOwyVS9t15jclCnf/wvXsyI8B5DG+Zmj+8bS0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l6rtjrD/sNF1zdIwQUSlHlBphcfKpLLr4193bBkAHPK8FY68i/X/NfFoBUGNOpPoA
	 LRZQVsoIsRwnMg3sIZTFVhGppe3mCYht1bqttr3Hh38PkHCEzBwNK3H4iHPThgD861
	 h7wo3ALRjMLuVZldJ+lLb168bg0GGE4xToxauIUgu3mT/gHcA2MZnlY3zrlCo0PIoM
	 tr0nMPC5dxQa0ErvFEgseUTfuzwudaq8sQ/ZZ/AxR+IkocvOBLVxw6aER6oqQ3/quo
	 W03kefwR4wQZ1LNVuB736EGIFrbHKq9gLY30K9PPXRlBzuQH6rX2SvNRJhxjkI0gZ4
	 TEUKVe3qGkwIg==
Message-ID: <sashiko-outbox-222161@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 07/13] fork: Support CLONE_INTO_ROOTNS in
 clone3()
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
In-Reply-To: <20261117231352.3816603-8-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <20261117231352.3816603-8-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:15:17 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C5AB20008
X-Stat-Signature: 44ad8w4fycgaw6xm1tun7te4x6bcqb7k
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795043720-470221
X-HE-Meta: U2FsdGVkX1/+v944AV+wXlGyecr3KFPQCIyA+ksObcIwl0E2LezsIb4t227uTaRRd7CVo7jWae+qHEKf0ptFP/OGRAi1JrP4pK9su2wjrRRsKVCdC7BFv6fuQg0h29TJomTi/xZUZ2JBeSa5SWCkOpv4kKHH1P1fNN1RaSVdxDx54Kv8p/v/PysqSy17HEgzokWlHqmHZqUhzZq3eveHr/a2WeJGlyFEgWTWvTSZtexzjUw6+Zod5GrVY1FwErqZRIsLNw39D8yh6GACjNl/jIvCULl3npehFNk/mhBGSPabQdfLt2vVO3stYZk7ZZzP2fP1J3J1ruotYs/eMzVoCNoI08Diq8BEz2ZbhUq6aF//pU0dMEiIv0cHtPqlNkP2zQeEFFFLtMEepzws+Of6IBjC5PsWUJ9BNQKaf58SV938Bnl9ya94hVDKKBkantWW0adr8e1WZ38Cu5tcGc2lPu+6BnAOSKm0W9z4xecJ8NfZOX+hrUqwq90a4MYo8jm+uYkfaSDKufg69tGKpSuh6Ge8RHSBndZOYVgO3ugHxR66VNgd7y9ftvPSb20YrdsOgjLjkK2KBbxDroaDhOEcpffjNwEbPIH9I5cmnCCrX0xF1VL7zfdiwIS9er5muIKtbyGasGqiGqg3zfmM0HC4dr/0yT0ONuz2mJE82zfvZzKFAzH4r+5wh6PaueYsFvo6sVFTgoYTyYXVIAbFywFhtG7uhCU78uadBtomKIIMWkky8vGVzHFdL0BMMAqfbmj0tncu8Eo4YDfv8dXSoIL68WVEEiwz+NbVX0NQKBcvFDjr6TSntnUYcpo9TIpYzpZCl9BXu6Z2NqcluyQK+NsW1q/oXrNFA6BOtv5IwU2tiXKAnuh8PZMXLMqBNyOc4QhhN+0CkBSYzmTBKskXUmCJlc/DfUpoWvvLVZusI8BVp/xg9sDCKzWV0ZtLzzxsiwZW4p51dW8QHwuwoyscx1v
 KTlwGxmD
 2DpD1dxCIDwH/xKmqup2ltEMFh5xEBML2iSwuR3LrICuqbxwMIqZCpiheW4OzaQZnW7VMIAybPLx537fvJtW1fnCi3mc/7vJaumdNcyXb4t7Y34Vnf0b50V4uPAPnFQ7UDUfKrpL6mtDuaNi9OOOZfRKfql/vURdnu+ndECR2ZUrgD3KWLK7RRDkUV6TnNST/o2lor05rAcb9/wF8Lm1u3aFHsaB2iOv8F2C5IG5bz4eflFBrxTr29QrdUEY9hBpz5NMC8Bzq0ljLeCNULupI/fnRk1kvk6dNj+DDxQG4SuPnrM+5IBRWdgL7ecsKXVW0qiF8prgaD8hzbwRknNdO0Ou+eUpvW/OHv71myCLqq572VDMRt9lCUfXLyZGNF7iIaMbuzoKG9oYSNtDgKKM7XiBB4rbGKkJJ3QMeA/CQu6WyJgaGbyv6nModUv2HzOpk289NXlivKLEt/wsKYa3jMapevvf25X3wSoW2ltPE+PstwuXbSiXaOsgePWQf52010lx6dFt3dTecNm3gQlUe7+uiO62qBsPpJi6pDU9oVKJv+wBlzjS5N9Ju5jUNJ8SiPDKCfxF9lmmHjoWQ3117U6kr61aL3QmE0P3kS9uMfF1e6Rz7krY0W7HY68KH1qCUlesXpJfdlX7KA6A=
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
- [Critical] cred: missing dumpability reset and shared mm on
  CLONE_INTO_ROOTNS
- [Critical] cred: privilege escalation and LSM bypass in
  may_enter_rootns_creds()
- [High] rootns: UAF and refcount underflow on pid_ns->rootns without
  CLONE_INTO_ROOTNS
- [Medium] fork: copy_rootns() sets ROOTNS_RUNNING before
  attach_pid(PIDTYPE_PID)
- [Medium] nsproxy: missing timens_commit() and CLONE_VM check in
  copy_namespaces()
--

commit 32f57f44b3303d6e1266e96415fc759ba100f243
Author: Jarkko Sakkinen <jarkko@kernel.org>

fork: Support CLONE_INTO_ROOTNS in clone3()

This commit adds CLONE_INTO_ROOTNS and struct clone_args.rootns to allow
clone3() to spawn a child process directly into an initialized root
namespace.

> diff --git a/kernel/cred.c b/kernel/cred.c
> index d01df40a9a386..afc91eed26563 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c

[ ... ]

> @@ -251,6 +255,25 @@ struct cred *prepare_exec_creds(void)
>  	return new;
>  }
> =20
> +static bool cred_cap_issubset(const struct cred *set,
> +			      const struct cred *subset);
> +
> +static bool may_enter_rootns_creds(const struct cred *old,
> +				   const struct cred *target)
> +{
> +	if (cred_cap_issubset(old, target) &&
> +	    uid_eq(old->euid, target->euid) &&
> +	    gid_eq(old->egid, target->egid))
> +		return true;
> +
> +	if (old->user_ns =3D=3D target->user_ns)
> +		return false;
> +
> +	return ns_capable(target->user_ns->parent, CAP_SYS_ADMIN) &&
> +	       ns_capable(target->user_ns->parent, CAP_SETUID) &&
> +	       ns_capable(target->user_ns->parent, CAP_SETGID);
> +}

[Severity: Critical]
Can a caller escalate privileges or bypass LSM restrictions when
copy_creds() replaces the child's credentials with dup_creds(rootns->cred)?

dup_creds(rootns->cred) copies all fields of struct cred from rootns->cred,
including uid, suid, fsuid, gid, sgid, fsgid, group_info, cap_bset,
cap_effective, cap_inheritable, cap_ambient, and security (passing
rootns->cred as old to security_prepare_creds()).

In the first branch of may_enter_rootns_creds(), only cap_permitted, euid,
and egid are checked.  A process that creates or inherits a rootns fd and
then drops its real/saved UIDs or GIDs, clears supplementary groups with
setgroups(), drops capabilities from cap_bset or cap_effective, sets
no_new_privs, or confines itself with an LSM such as Landlock still passes
this check and spawns a child with the original unconfined rootns->cred.

In the second branch, when old->user_ns !=3D target->user_ns, only
ns_capable() on target->user_ns->parent is checked, without verifying
cred_cap_issubset(old, target) or checking that target's UIDs, GIDs, and
group_info are mapped into target->user_ns->parent.  If a process with
GLOBAL_ROOT_UID enters a child user namespace whose parent is owned by an
unprivileged user and calls rootns_create(0), the unprivileged owner of
target->user_ns->parent can clone into that rootns and gain
GLOBAL_ROOT_UID.

Conversely, when old->user_ns =3D=3D target->user_ns and old->euid !=3D
target->euid, the early return rejects callers even when they hold
CAP_SYS_ADMIN, CAP_SETUID, and CAP_SETGID in target->user_ns.

> @@ -260,7 +283,8 @@ struct cred *prepare_exec_creds(void)
>   * The new process gets the current process's subjective credentials as =
its
>   * objective and subjective credentials
>   */
> -int copy_creds(struct task_struct *p, u64 clone_flags)
> +int copy_creds(struct task_struct *p, u64 clone_flags,
> +	       struct rootns *rootns)
>  {
>  	struct cred *new;
>  	int ret;
> @@ -283,7 +307,13 @@ int copy_creds(struct task_struct *p, u64 clone_flag=
s)
>  		return 0;
>  	}
> =20
> -	new =3D prepare_creds();
> +	if (rootns) {
> +		if (!may_enter_rootns_creds(current_cred(), rootns->cred))
> +			return -EPERM;
> +		new =3D dup_creds(rootns->cred);
> +	} else {
> +		new =3D prepare_creds();
> +	}
>  	if (!new)
>  		return -ENOMEM;

[Severity: Critical]
Does switching p to rootns->cred leave p->exec_state->dumpable set to
TASK_DUMPABLE_OWNER and allow sharing current->mm across privilege
boundaries?

In copy_process(), copy_exec_state() runs before copy_creds() and copies
current->exec_state (or refcount-shares it when CLONE_VM | CLONE_VFORK is
used).  Unlike commit_creds(), copy_creds() does not reset dumpability to
suid_dumpable when UIDs, GIDs, or capabilities change between
current_cred() and rootns->cred:

kernel/ptrace.c:task_still_dumpable() {
	...
	exec_state =3D task_exec_state_rcu(task);
	if (READ_ONCE(exec_state->dumpable) =3D=3D TASK_DUMPABLE_OWNER)
		return true;
	return ptrace_has_cap(exec_state->user_ns, mode);
}

When a dumpable privileged daemon spawns a child into a less-privileged
rootns, unprivileged tasks in that rootns matching rootns->cred can attach
via ptrace() or access /proc/<pid>/mem and /proc/<pid>/fd/* before the
child calls execve().  Because clone3_args_valid() also allows CLONE_VM |
CLONE_VFORK with CLONE_INTO_ROOTNS, the child shares current->mm with the
parent daemon, allowing tasks in the target rootns to modify the parent
daemon's live memory.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 99e22b3cd213e..978605de8428e 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c

[ ... ]

> @@ -2566,7 +2583,7 @@ __latent_entropy struct task_struct *copy_process(
>  			attach_pid(p, PIDTYPE_TGID);
>  			attach_pid(p, PIDTYPE_PGID);
>  			attach_pid(p, PIDTYPE_SID);
> -			copy_rootns(p, NULL);
> +			copy_rootns(p, clone_args_rootns(args));
>  			__this_cpu_inc(process_counts);
>  		} else {
>  			current->signal->nr_threads++;

[Severity: High]
Can forking into a rootns PID namespace via setns(CLONE_NEWPID) without
CLONE_INTO_ROOTNS cause a refcount underflow or use-after-free on struct
rootns?

create_rootns() sets ns->pid_ns_for_children->rootns =3D c without taking a
reference on c and activates the namespace in ns_tree, while put_rootns()
frees c without clearing pid_ns_for_children->rootns.  A caller with
CAP_SYS_ADMIN can open an nsfs fd for pid_ns_for_children via
open_by_handle_at(FD_NSFS_ROOT, ...), call setns(pidns_fd, CLONE_NEWPID),
and fork() PID 1 without CLONE_INTO_ROOTNS.  Because clone_args_rootns() is
NULL, copy_rootns() returns early without calling get_rootns(c), but when
that PID 1 exits, zap_pid_ns_processes() -> exit_rootns() still
dereferences pid_ns->rootns and calls put_rootns(c):

kernel/rootns.c:copy_rootns() {
	if (likely(!c || READ_ONCE(c->state) !=3D ROOTNS_FORKING))
		return;

	scoped_guard(spinlock, &c->lock) {
		get_rootns(c);
		WRITE_ONCE(c->init_pid, get_task_pid(tsk, PIDTYPE_TGID));
		WRITE_ONCE(c->state, ROOTNS_RUNNING);
	}
	wake_up_all(&c->waitq);
}

If the rootns fd was already closed, exit_rootns() dereferences freed
memory; if the rootns fd is still open, exit_rootns() drops the fd's
reference and frees c prematurely.

[Severity: Medium]
Can a concurrent rootns_kill() or close() with ROOTNS_KILL_ON_CLOSE miss
the init task because copy_rootns() transitions rootns->state to
ROOTNS_RUNNING before attach_pid(p, PIDTYPE_PID)?

CPU0                              CPU1
copy_process()
  attach_pid(p, PIDTYPE_TGID)
  copy_rootns(p, ...)
    c->init_pid =3D ...
    c->state =3D ROOTNS_RUNNING
                                  SYSCALL_DEFINE2(rootns_kill, ...)
                                    rootns_kill_members()
                                      kill_pid(pid, sig, 0)
                                        pid_task(pid, PIDTYPE_PID)
                                        --> NULL (-ESRCH)
  attach_pid(p, PIDTYPE_PID)

Neither __rootns_kill() nor rootns_kill_members() takes tasklist_lock, so a
signal sent in this window sees ROOTNS_RUNNING and PIDTYPE_TGID attached,
but kill_pid() looks up PIDTYPE_PID and fails with -ESRCH.  Calling
copy_rootns() after attach_pid(p, PIDTYPE_PID) avoids this window.

> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 8a3c6d4e94e2a..78a1e1fb2cfd7 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -166,12 +167,18 @@ struct nsproxy *create_new_namespaces(u64 flags,
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
> +		get_nsproxy(rootns->ns);
> +		tsk->nsproxy =3D rootns->ns;
> +		return 0;
> +	}

[Severity: Medium]
Does returning early here skip time namespace VDSO setup when rootns->ns
has a different time namespace from the caller?

In copy_process(), copy_mm() duplicates current->mm (including any faulted
[vvar] mappings for old_ns->time_ns) before copy_namespaces() runs.
Returning early without calling timens_commit() or timens_on_fork() leaves
the child's [vvar] mapping pointing at the parent's time namespace until
execve(), and when CLONE_VM | CLONE_VFORK is used, allows tasks sharing an
mm_struct to have different time namespaces.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117231352.3816=
603-1-jarkko@kernel.org?part=3D7

