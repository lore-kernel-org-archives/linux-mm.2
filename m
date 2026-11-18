Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B59606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1y2MDfw
Received: by kanga.kvack.org (Postfix)
	id 67F836B05B6; Wed, 18 Nov 2026 00:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657BF6B05B7; Wed, 18 Nov 2026 00:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546396B05B8; Wed, 18 Nov 2026 00:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1256B05B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:09:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D8BFA812C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:54 +0000 (UTC)
X-FDA: 85447062708.26.5C3CEC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9024A0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:09:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1y2MDfw;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794978593;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghFaqqHrnriJElJgqz9O9Vc1cSqEDgRBv8DJ1pP0bDg=;
	b=400SPAaWZ5cF4pq5bazHMmFxYiROfBewKOV3xseG4JZdw4dCLC24cL0pwoF239SB79Um1k
	jwsUs70Rln+vJh7+b94UUQ5odJoaeP7MN//4CGDBnq4+zuyYHOZCQt/ktXRnJSkoTV2OpM
	iqAHejkZP9HUbus2EsIZ4CnWOImhegI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794978593;
	b=iQuSyg7PnPNvcpRqr0S44izzwkDL6zGLEn2ac1PIdJrHO7Mu74q8iy0KA/ehMKpfMOiWBa
	XY/3ExlP9iXqGld+y9V4MToZ5tosmIWdAkSjADMJYmqdbJFj+47ZlUohI2j3lkE9J8qJdS
	9zG8baE3THSiwD7iS+K0Jihdnjejym0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1y2MDfw;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1256060E84;
	Wed, 18 Nov 2026 05:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1561F000C6;
	Wed, 18 Nov 2026 05:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978591;
	bh=ghFaqqHrnriJElJgqz9O9Vc1cSqEDgRBv8DJ1pP0bDg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F1y2MDfwntqzTgEKQnRX4PtKJCdL71HqBycHeN1yvhCLTghs1RtmdchrGfX+/AthP
	 LhRF5TfESSXEoclERPjMYtU3E/Bl9mUYaJkiTzFlWtQI+pT6w3g5Nb5z9h5JzpqxS+
	 n8V9ZIFh5F/gynciQnLHdnejdSQv2V6tjWk89A4KigRYEVo0SsTzym/qN5RXOdl2jh
	 RrlQCuGZaEmRHF/LcwDTdLxzpVb7aR3IIl9FV4zckBuLv/MzlPTHBvKEb22stSLGCQ
	 GoaP5Fw9rQgmHFc5FUP8rmAPipXZVI52hCbSKP7XDkG4CafuJ/oMkC41xIWXF6vPlL
	 z0sSjdfTzauCQ==
Message-ID: <sashiko-outbox-220142@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 07/13] rootns: Add rootns_enter() system call
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
In-Reply-To: <20261117050841.3289652-8-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-8-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:09:49 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9024A0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: o8i16kasmbnin9bid71yfz8s7awtjehu
X-HE-Tag: 1794978592-189256
X-HE-Meta: U2FsdGVkX18W2b7oskPe4kTJECSSlBM6fZM+cVTRZHs6iFigIzbvE0BAcY4wx4A0OxGnz5dXK2q6B+o/LfBdFkgrbArhveCqnKO1aTue7S9wrzon1Aeclu4EPSbHekwI6a9TK7l63RCdR3mRB+67MPG5oEVUGYTKxmONCVnX2pz9TQQJ5C30DETmE2Jp4PE1IZYdgHhC8k5tCy+j7MDvbKw9H6PQlyeyokhzvgiw4wRGwckpS7vvn1v6FPy6h6lO6zs4XG4zpTQgSeQDu/VarLM3r77+w5TF0PoTXbVpQRWi285LPqs3GbgzfWco7Za9WJDjeCihqJUsSxRX94b2TLQZ9XTSH+rlW5UeRECCQLZuURxAKV8kPqTasyG2LRTi69ZDTJ9gEs+2SFd7UebKSvMHi3dGHysoR/UQWjRjjg+tNn/451eRPzpp0DNFiZD9h4AKoLJKuszBYbqUP0C5zSytkFBtrSFbXg8OoLGYZas60ahq0bJVbbONfhGCGtQ0GgBEuWvXFUdZzDzt7bxjd52oYit2nwg0Zt+YuO2UhxzzYAIHdEin4L6p93po7EB+VTwCG3UOk+BeA0eid+rt/w7GH7XForUZLiguVnaWbMUYwA8FR8K9YPtuDs0Kn4Sk+5Fj5GSfOHOq30OLoRFhudqVhlILJr14mVX2fSpqMkjdLJhWirVQqlnobOIFUAoxkOA+i0uVNIFusdrk/RbRxwqP3dpld3yLxdHEdr8EWOBzeqHMye1QOhHBd6kDdR63tmoPglC6/iciwUXpI25pujO+K1sj6appyZUgCXEKKESnCQ7+f0ZUHTJwTm9URGNAziKl4Bpoid6HggErFZSsMuQW4eFJgmX8c/8rYnWb167GMLqqa/kR+AiyZiVIB5BLOnhYB+1knehqY9K299TUUr/RMYlOi4LqHo60CsgwCa8/gYoN95uzr77uvqrGAHUQKYhoV/Y9w5+fLo5XL7U
 jwCrKyX1
 TnatFUfLHcFA3USZbpDDnQ8rA0KY4GcLZ0pRybRjAQQk5l2Vz57vZj2PT1Nwbhm7eAnhLpllnKk1c+XLkf+HDxNJpnbbRd0N9XHM/fk8S75kqI/yjpodBRWOMlelqDN3FzfK4G3Le1v1g9twDZp1n34mhl6JkHZ7yTiKvdPbmBpbLB/bsrGNwoXC+imI4L7eKXfWJSB+mEE7ALXxf/lKmyDpNiZrh8UFK6r0qX61XoEKqIEeMzhC+ARLx8SBJSVzBDYp1CBdUuxT+secvRxMpGR/SzsA5cGACqEItjGFGdKTy/jwkCvgUlY4g5sGpOd15FBkzCJB+VA0LPH5G31LGSA14fZeUtn3uNSK6UY7Imt/joGGmHwd5Sv3NtPqE57oNvdvSixXkRwcbvbwtH4279ZS3K4tz8G+jvEMjhtukKoxB76Aomykjp81wXRX//YThtjRwG+C7M4NA7X0rVcBwbkjkAYTvS2LyL36QVyHLZpcvSv0kEivVP/rvO/b19sqE3LMji1ZVZtRnOqrlv4frBqIX+pCS4w6jbx82ZtXoNxWY35VLD6TiPUTrXSV3Cae9RSyz8/LQtGNbyxiR3BmvzoiE8BLRsQZ9O6s42QTmOrG3NA/HEG/euEsJpwHH8LxIv0Zav/u9HGOSeF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [Critical] cred: privilege escalation and NNP bypass in
  may_enter_rootns_creds()
- [High] cred: missing dumpability reset in copy_creds() on rootns entry
- [High] rootns: refcount underflow and UAF of rootns via setns() on
  pid_ns
- [High] rootns: sys_rootns_enter() calls kernel_clone() without arch
  fork wrappers
- [Medium] nsproxy: missing timens_commit() in copy_namespaces() on
  rootns entry
- [Medium] fork: stale rootns->root used in copy_fs() after pivot_root()
- [Medium] rootns: rootns_may_setns() rejects setns() to inherited
  rootns namespaces
--

commit 2b3b027946b3cddbb69540b1d520fd1496bf137c
Author: Jarkko Sakkinen <jarkko@kernel.org>

rootns: Add rootns_enter() system call

This commit introduces the rootns_enter() system call to fork a child
process directly into a configured rootns, along with credential checks
and namespace provenance tracking for setns().

> diff --git a/kernel/cred.c b/kernel/cred.c
> index d01df40a9a386..97d334db7758a 100644
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
> +	if (task_no_new_privs(current) || old->user_ns =3D=3D target->user_ns)
> +		return false;
> +
> +	return ns_capable(target->user_ns->parent, CAP_SYS_ADMIN) &&
> +	       ns_capable(target->user_ns->parent, CAP_SETUID) &&
> +	       ns_capable(target->user_ns->parent, CAP_SETGID);
> +}

[Severity: Critical]
Can a process bypass PR_SET_NO_NEW_PRIVS, regain dropped credentials, or
escape an LSM domain through may_enter_rootns_creds()?

When may_enter_rootns_creds() succeeds, copy_creds() replaces the child's
entire struct cred with dup_creds(rootns->cred).  The early return runs
before the task_no_new_privs(current) check and only compares euid, egid,
and cred_cap_issubset(old, target).  For a ROOTNS_USER namespace where
old->euid is target->user_ns->owner, cred_cap_issubset() returns true
even if old dropped capabilities or set PR_SET_NO_NEW_PRIVS, letting the
child gain full capabilities in target->user_ns.

Even in the same user namespace, the early return does not check real,
saved, or fs UIDs/GIDs, group_info, cap_effective, cap_bset, securebits,
or the LSM security blob.  A process that creates a rootns and later
drops real/saved UIDs, clears supplementary groups, drops bounding set
bits, or restricts itself with Landlock can call rootns_enter() to spawn
a child with the original unrestricted rootns->cred.

In the second branch, CAP_SETUID and CAP_SETGID are checked only against
target->user_ns->parent without checking old->user_ns or verifying that
target's UIDs, GIDs, and supplementary groups are mapped into
target->user_ns->parent.  Conversely, when old->user_ns =3D=3D target->user=
_ns,
a caller holding CAP_SYS_ADMIN, CAP_SETUID, and CAP_SETGID in old->user_ns
is rejected if its euid or egid differs from target.

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

[Severity: High]
Does switching credentials to rootns->cred in copy_creds() leave
p->exec_state->dumpable set to TASK_DUMPABLE_OWNER?

In copy_process(), copy_exec_state() copies current->exec_state->dumpable
into p->exec_state before copy_creds() runs.  Unlike commit_creds(),
copy_creds() does not reset dumpable to suid_dumpable when UIDs, GIDs, or
capabilities change.  When a privileged daemon calls rootns_enter() to
fork into a rootns owned by an unprivileged user, processes inside the
target user namespace pass task_still_dumpable() and can ptrace the child
before execve(), reading the daemon's duplicated memory or stealing its
open file descriptors via pidfd_getfd().

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 99e22b3cd213e..5e23d36b7ac3e 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
[ ... ]
> @@ -1671,6 +1683,10 @@ static int copy_fs(u64 clone_flags, struct task_st=
ruct *tsk,
>  	tsk->real_fs =3D tsk->fs =3D copy_fs_struct(fs);
>  	if (!tsk->fs)
>  		return -ENOMEM;
> +	if (rootns) {
> +		set_fs_root(tsk->fs, &rootns->root);
> +		set_fs_pwd(tsk->fs, &rootns->root);
> +	}
>  	return 0;
>  }

[Severity: Medium]
If a process inside a running rootns changes the root mount with
pivot_root() or overmounts "/", will subsequent rootns_enter() calls get
a stale root path here?

rootns->root holds the initial mount installed by MOVE_MOUNT_T_ROOTNS_ROOT
and is not updated by pivot_root().  Setting tsk->fs root and pwd to
&rootns->root gives newly entering tasks the old root mount instead of
the current root of rootns->ns->mnt_ns.

> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index a76837b3ee332..0c6407757d896 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -169,13 +169,21 @@ struct nsproxy *create_new_namespaces(u64 flags,
>  /*
>   * called from clone.  This now handles copy for nsproxy and all
>   * namespaces therein.
> + *
> + * Namespaces derived from a rootns member inherit the same rootns domai=
n.
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
Does returning early here without calling timens_commit() leave the child
with the parent's VDSO vvar mappings when entering a rootns in a
different time namespace?

copy_mm() runs before copy_namespaces() and duplicates the caller's vvar
PTEs into tsk->mm.  When old_ns->time_ns differs from rootns->ns->time_ns,
skipping timens_commit() leaves the old vvar mappings in place until
execve(), so vDSO clock_gettime() in the child reads the wrong time
namespace offsets.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index f59b2fe9910de..e286c1e753b71 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
[ ... ]
> +static atomic64_t rootns_id =3D ATOMIC64_INIT(0);
> +
> +static void rootns_tag_namespaces(struct rootns *c, const struct nsproxy=
 *old)
> +{
> +	struct nsproxy *ns =3D c->ns;
> +
> +	if (c->cred->user_ns !=3D current_user_ns())
> +		c->cred->user_ns->ns.rootns_id =3D c->id;
> +	from_mnt_ns(ns->mnt_ns)->rootns_id =3D c->id;
> +	ns->pid_ns_for_children->ns.rootns_id =3D c->id;
> +	if (ns->uts_ns !=3D old->uts_ns)
> +		ns->uts_ns->ns.rootns_id =3D c->id;
> +	if (ns->ipc_ns !=3D old->ipc_ns)
> +		ns->ipc_ns->ns.rootns_id =3D c->id;
> +	if (ns->cgroup_ns !=3D old->cgroup_ns)
> +		ns->cgroup_ns->ns.rootns_id =3D c->id;
> +	if (ns->net_ns !=3D old->net_ns)
> +		ns->net_ns->ns.rootns_id =3D c->id;
> +}
> +
> +bool rootns_may_setns(struct rootns *rootns, struct ns_common *ns)
> +{
> +	if (!ns)
> +		return false;
> +	if (!rootns || is_current_namespace(ns))
> +		return true;
> +
> +	return ns->rootns_id =3D=3D rootns->id;
> +}

[Severity: Medium]
Does rootns_may_setns() reject intra-rootns setns() back to a namespace
that the rootns inherited at creation time?

rootns_tag_namespaces() only sets c->id on newly created namespaces, so
any namespace inherited from the creator (such as time_ns, or UTS, IPC,
cgroup, net, or user namespaces omitted from rootns_create() flags) keeps
its previous rootns_id.  If a task inside the rootns unshares one of
those namespace types, is_current_namespace(ns) becomes false for the
rootns's initial namespace and ns->rootns_id !=3D rootns->id, causing
setns() back to PID 1's namespace to fail with -EPERM.

> @@ -249,6 +308,7 @@ static struct rootns *create_rootns(unsigned int flag=
s)
>  	c->ns =3D ns;
>  	ns->rootns =3D c;
>  	ns->pid_ns_for_children->rootns =3D c;
> +	rootns_tag_namespaces(c, current->nsproxy);
>  	nsproxy_ns_active_get(ns);
> =20
>  	return c;

[Severity: High]
Can an external task joining ns->pid_ns_for_children via setns() trigger
a refcount underflow and use-after-free on struct rootns?

create_rootns() sets ns->pid_ns_for_children->rootns =3D c without taking a
reference on c, and marks ns->pid_ns_for_children active in the namespace
tree via nsproxy_ns_active_get(ns).  The reference on c that pairs with
exit_rootns()'s put_rootns(c) is only acquired in copy_rootns() when PID 1
is forked through sys_rootns_enter() in state ROOTNS_FORKING:

kernel/rootns.c:copy_rootns() {
	if (likely(!c || READ_ONCE(c->state) !=3D ROOTNS_FORKING))
		return;

	scoped_guard(spinlock, &c->lock) {
		get_rootns(c);
...
}

Because rootns_may_setns() returns true when task_rootns(current) is NULL,
a process outside any rootns can open ns->pid_ns_for_children from nsfs,
call setns(fd, CLONE_NEWPID), and fork() PID 1 with args->rootns =3D=3D NUL=
L.
copy_rootns() then skips get_rootns(c), but when that child exits,
zap_pid_ns_processes() -> exit_rootns() still calls put_rootns(c),
dropping the rootns fd's reference and freeing c while the fd is still
open (or dereferencing a dangling pid_ns->rootns if the fd was already
closed, since put_rootns() does not clear pid_ns->rootns).

> @@ -455,3 +515,85 @@ SYSCALL_DEFINE2(rootns_kill, int, rootnsfd, int, sig)
[ ... ]
> +SYSCALL_DEFINE1(rootns_enter, int, rootnsfd)
> +{
[ ... ]
> +	args.rootns =3D rootns;
> +	ret =3D kernel_clone(&args);

[Severity: High]
Is calling kernel_clone() directly from a regular C syscall safe on
architectures that require fork/clone entry wrappers?

On alpha, m68k, parisc, mips, arc, nios2, and openrisc, fork and clone
syscalls enter through assembly wrappers that allocate a switch_stack or
save callee-saved registers before calling C code, which copy_thread()
then reads from the stack.  On sparc, the wrapper must flush register
windows via synchronize_user_stack(), and copy_thread() checks whether
UREG_G1 is __NR_clone3 to return 0 in the child instead of the parent's
PID.  Calling kernel_clone() from sys_rootns_enter() bypasses those paths
and corrupts the child's register state or return value on those
architectures.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117050841.3289=
652-1-jarkko@kernel.org?part=3D7

