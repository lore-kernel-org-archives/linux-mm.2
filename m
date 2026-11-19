Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89AFE60A260E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XnQRPm/F
Received: by kanga.kvack.org (Postfix)
	id B34E06B06A1; Thu, 19 Nov 2026 14:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE46F6B06D1; Thu, 19 Nov 2026 14:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA216B06DE; Thu, 19 Nov 2026 14:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5896B06A1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:37:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E42AD40BE2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:01 +0000 (UTC)
X-FDA: 85452876642.06.0FC26DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43C0C180020
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:37:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XnQRPm/F";
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795117020;
	b=8It7Dyp7K4ZoLdZ5GrOtHG2I63jSzbBEESGX6NIP/5EaIgxNPafv2XuXeNoBIzOfzIzFY0
	MREt/jsiyvek7o7Nm20N907jgp0FVE2Dwh4WDzHAaB6mLSJUrFwOx7omgdEN7FHC5WlLbr
	Cn5aps00BvEHNu8aCbybQVWgiJuOpOk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XnQRPm/F";
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795117020;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/YfY+oC3S5zb54LFhSRV/k0YjNqqBJZ3NHGLIHdrTg=;
	b=IHsJQpq6ijdvGhc/J714n4IlLPJrKSFZAF3ye9tCVkKNxVCJA3iPrXja8MaExL3L0xTA5f
	Istu8AQ9fJ/QL1YHJbposHjrINfFajXZd01ugyftZPTbRecK4U1wwj/KnUsu+tVVH3fx0c
	EdyqbeQyTITYhg3zLlErUQmohXFEHJw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A60046C60;
	Thu, 19 Nov 2026 19:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2F21F000C4;
	Thu, 19 Nov 2026 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117019;
	bh=y/YfY+oC3S5zb54LFhSRV/k0YjNqqBJZ3NHGLIHdrTg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XnQRPm/F8fnWyHXEJtIk/x41MLHaek0uoWoOBQVBzT6XYjx455oOtd96NJYFUrIWY
	 huLeW7QfxayBwGqbeYDyeF+dbeu6Hi1JIJWxT5SoJ4XkIpvjg49ooy1mkG7xHyjgaC
	 IjSW3Pmr7mOujPocZiK1a3EqCG+seY8966m6/bFyQvaZpE9YyD6eK5BKpq8pxazxrJ
	 8pPTtkkHaaf+D67z5Ryvrx3Bhh51LYk9CsC3JVUmamJPqcOnHT+dw4ZxVzozFVAjpQ
	 4j7z94MFhB2YyRh8kVzwszxM+xDR+Yx2m+aV2rNczlBqYgD/QwyL42dOBVnieK4jPS
	 8H7FUwATL7KbA==
Message-ID: <sashiko-outbox-223950@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 08/13] fs: Support FSCONFIG_SET_ROOTNS in
 fsconfig()
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
In-Reply-To: <20261118193539.240065-9-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <20261118193539.240065-9-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 19:36:57 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 43C0C180020
X-Stat-Signature: qaguckmfz1wsdbfbcic4qn6ubnks5g77
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795117020-860243
X-HE-Meta: U2FsdGVkX19a9N3RJZni8c2wps0c/kPXpTLnll4zX+7aBQXDYsLfm/m0RWc3JvWiiUXZusniEeZ7PCRZwK1xobl119bfrd6Uba8anMHSlcHiSIMCww3HxFVVXh/OuXriLM+710X/Wh6P/GVr8zie72OP+5bnnAVPjmcTWoVXrSliEijwKRVc48hyRkROGRBmlxglwzmPGF4kHjcsiYfYyWJ2PjRcr/VSz/UyBKYMOsONjhW4YKTeJZDlVaPCw8T0x2sq5hBE7bzCOubjiuen6Inh4vd1fOd4mxjTAula2iWMGVqX0oKGs9LzP0r6zb1ck26jzxEu19OXo+EXzjZzgiua0QyWdOK7SSrdxfEdsX7ewYx8aldPx8i3/2g8BKSPR9I/o+LEwdkmt6xPuncBW1YArQY82Av8QEjVi0lds8jZj8pBoXlKBU09obSq/dBoLA1+q+6guTQsIaT0vJm58XO3AiysZ6+UAk7KiqOrOw2KHYCq6MjNGH/1FJjDaDg1eYixmm5ozzPqhnJzYll6oVBMgCK5iOyR1uYVNEbx0LkFTEW8Vzb8ewgSSiUxr/jyb3oLL8STeQckSVDtfnL7MqbJpyeIJENcva4HeqEK7cgCNcvdMi3AhGBqcM+Np/BN4loxgeeTkSZUB8vSDQFyk4eMqEPRcBlkASRwb4iMCMyBklSJrQgymdnGCLw0HIefq85ymmRBv8n6hPVCxsBck9Gxen9Dk3fJlt0zPfaNNMMQKru+Mx82s4m0PA4K45ygHEJ/hFuOj8p/lh/KjOZ/URpoZayCZ8ytYFn+IPw1CslTV0Ksz3pv6QGWXLUCBe/5rdda37M7f4I/U364Hh5lWTHlg7pQc9/jMK4QYwLP0pHIkAOeCTyzmDm1Wq4KtSOXWOS08AwZkOPzmkwtWVjBpM/SD5qCn/ElhrBRB5ymz026NS7bu+/z4jNPpRhBlUN2deuzog6+Gyq2Gddcv9k
 bTZKjtF3
 5dVd5ADPWzMIh1w5wUENrL/2GmlkXs75u8UgvpfYIsAI2fvDuQq67Gj4hOLuMNoLuk81sew1Zgp5KHTji8tzlkxDYxJWL8XxB1doKPDqSjVzxvfOmPc7KeoItpGTzP9rkUS+jY9q5WG4hd2E5Zl/5H2v8Pe9M9vyVGHZ/yK1jtyV3ezE0MtWh6zknYeLLikE380UbvuiTU/jj8yV6ntLPwJG0vqF8SWlBKlmch7pRk6rL97EbBXAXxN75rwtr65aAnacHlqRfo64YIy1Dnwbeltbrzcvj+zcNFBk7E6Voz49q4cXwqRsW7FVdU4ark52xNobEKFs9mk1mvElOaxxNVVbR1gmjqKfWP7Lql83JvGkbs8Oiq3lx6cyD7cATaiHzKnD3eDg0m7NV4OcqIEH610MaXbChW4YzMuqrUoZDdZbKM7d2DE9h3q7X5SzMTrgmfJPt09vmd3XdK4aLwny65DpZeSHvNC1l/LDbqclVKVB4cnM1YibDZ2hMdGEbEz83WKv2473Rt7RN8ub2aDfdLzksbmQqRkVhv0nZSSHjVIiSsM2bp+moQ6zRErtQ3qRnHxzFDf0KwKerQD+xmST9KC5L3TjSZOtua2I3wc0m6vsgBrDS9xgd4R6mCgit/8JIfEdEa5BJBv136fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [High] fs: unprivileged devpts mount via fsconfig_set_rootns()
  bypasses pty_reserve
- [High] fs: alloc_mnt_ns(fc->user_ns) in fsmount() breaks submount
  MNT_LOCKED
- [Medium] fs: missing FS_CONTEXT_FAILED transition on set_rootns()
  error
- [Medium] fs: fsconfig_set_rootns() loses cpuset context state on
  re-init
- [Medium] fs: may_mount() in fsmount() bypasses fc->user_ns capability
  check
- [Low] fs: missing @init kernel-doc entry in alloc_fs_context()
--

commit fada980b534067d9740aa79ea2751dbe127d6be7
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support FSCONFIG_SET_ROOTNS in fsconfig()

This commit adds FSCONFIG_SET_ROOTNS to bind a newly opened fs_context to
a target rootns before supplying parameters, allowing unprivileged callers
to open FS_USERNS_MOUNT contexts and configure mounts for a rootns where
they hold CAP_SYS_ADMIN.

> diff --git a/fs/fs_context.c b/fs/fs_context.c
> index a50584df97bea..542dede2f8643 100644
> --- a/fs/fs_context.c
> +++ b/fs/fs_context.c
> @@ -259,7 +259,8 @@ static struct fs_context *alloc_fs_context(struct fil=
e_system_type *fs_type,
>  				      struct dentry *reference,
>  				      unsigned int sb_flags,
>  				      unsigned int sb_flags_mask,
> -				      enum fs_context_purpose purpose)
> +				      enum fs_context_purpose purpose,
> +				      bool init)
>  {

[Severity: Low]
The kernel-doc comment above alloc_fs_context() is missing an @init entry
for the new parameter.

[ ... ]

> diff --git a/fs/fsopen.c b/fs/fsopen.c
> index 70024870fefa2..3e36270baadb3 100644
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c
> @@ -41,6 +46,76 @@ static inline const char *fetch_message_locked(struct =
fc_log *log, size_t len,
>  	return p;
>  }
> =20
> +/**
> + * DOC: FSCONFIG_SET_ROOTNS
> + *
> + * ``fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, rootnsfd)`` binds a=
 newly
> + * opened filesystem context to ``rootnsfd`` once before any parameters =
are
> + * supplied (subsequent calls fail with ``-EBUSY``).
> + *
> + * The caller must hold ``CAP_SYS_ADMIN`` in the target ``rootns`` user
> + * namespace, allowing unprivileged callers to configure ``FS_USERNS_MOU=
NT``
> + * filesystems without entering the user namespace first.
> + *
> + * The context is initialized against the ``rootns`` network namespace,
> + * ``fc->user_ns`` is delegated to the ``rootns`` user namespace for
> + * ``FS_USERNS_MOUNT`` and ``FS_USERNS_DELEGATABLE`` filesystems when the
> + * mounter ``fsuid``/``fsgid`` map into it or the caller lacks
> + * ``CAP_SYS_ADMIN`` in its own user namespace, and ``proc`` and ``mqueu=
e``
> + * contexts bind to the target ``rootns`` PID and IPC namespaces.
> + */
> +static int fsconfig_set_rootns(struct fs_context *fc, struct fs_paramete=
r *param)
> +{
> +	struct user_namespace *user_ns;
> +	struct rootns *c;
> +	int ret;
> +
> +	if (!is_rootns_file(param->file))
> +		return -EINVAL;
> +
> +	c =3D param->file->private_data;
> +	user_ns =3D c->user_ns;
> +	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (fc->need_free && fc->ops && fc->ops->free)
> +		fc->ops->free(fc);
> +	fc->need_free =3D false;
> +	fc->fs_private =3D NULL;
> +	fc->s_fs_info =3D NULL;
> +	fc->ops =3D NULL;
> +	fc->sb_flags =3D 0;
> +	fc->global =3D false;
> +	security_free_mnt_opts(&fc->security);
> +
> +	put_net(fc->net_ns);
> +	fc->net_ns =3D get_net(c->ns->net_ns);
> +	put_user_ns(fc->user_ns);
> +	if ((fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE))=
 &&
> +	    ((kuid_has_mapping(user_ns, fc->cred->fsuid) &&
> +	      kgid_has_mapping(user_ns, fc->cred->fsgid)) ||
> +	     !ns_capable(fc->cred->user_ns, CAP_SYS_ADMIN)))
> +		fc->user_ns =3D get_user_ns(user_ns);
> +	else
> +		fc->user_ns =3D get_user_ns(fc->cred->user_ns);
> +
> +	ret =3D fc->fs_type->init_fs_context(fc);

[Severity: Medium]
Does re-calling fc->fs_type->init_fs_context(fc) here lose the cpuset
configuration when fsopen("cpuset", 0) was opened by a caller with
may_mount() =3D=3D true?

During the initial fs_context_for_mount() in fsopen(),
cpuset_init_fs_context() configures cpuset_fs_context_ops,
ctx->subsys_mask, and CGRP_ROOT_NOPREFIX, and then replaces fc->fs_type
with &cgroup_fs_type:

kernel/cgroup/cgroup.c:cpuset_init_fs_context() {
    ...
	get_filesystem(&cgroup_fs_type);
	put_filesystem(fc->fs_type);
	fc->fs_type =3D &cgroup_fs_type;
    ...
}

When fsconfig_set_rootns() frees the initial context and calls
fc->fs_type->init_fs_context(fc) again, it invokes
cgroup_init_fs_context() instead of cpuset_init_fs_context(), leaving
ctx->subsys_mask as 0 and fc->ops as &cgroup1_fs_context_ops so cpuset
parameter parsing or superblock creation fails.

> +	if (ret < 0) {
> +		fc->phase =3D FS_CONTEXT_FAILED;
> +		return ret;
> +	}
> +	fc->need_free =3D true;
> +
> +	if (fc->ops->set_rootns) {
> +		ret =3D fc->ops->set_rootns(fc, c);
> +		if (ret < 0)
> +			return ret;
> +	}

[Severity: Medium]
Should fc->phase be set to FS_CONTEXT_FAILED when fc->ops->set_rootns()
fails?

By the time set_rootns() runs, the prior filesystem-private state has been
freed, fc->net_ns and fc->user_ns have been overwritten, and
init_fs_context() has re-run in the fsconfig() caller's task context.  If
proc_set_rootns() returns -EINVAL, leaving fc->phase in
FS_CONTEXT_CREATE_NS (or FS_CONTEXT_AWAITING_NS) with fc->rootns_bound
still false leaves a partially mutated context usable for subsequent
parameter parsing, superblock creation, or repeated FSCONFIG_SET_ROOTNS
calls.

[ ... ]

> @@ -137,17 +214,23 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_na=
me, unsigned int, flags)
> =20
>  	audit_log_fsopen(fs_name);
> =20
> -	fs_type =3D get_fs_type(fs_name);
> +	fs_type =3D priv ? get_fs_type(fs_name) : get_fs_type_noload(fs_name);
>  	kfree(fs_name);
>  	if (!fs_type)
> -		return -ENODEV;
> +		return priv ? -ENODEV : -EPERM;
> =20
> -	fc =3D fs_context_for_mount(fs_type, 0);
> +	if (!priv && !(fs_type->fs_flags & FS_USERNS_MOUNT)) {
> +		put_filesystem(fs_type);
> +		return -EPERM;
> +	}
> +
> +	fc =3D priv ? fs_context_for_mount(fs_type, 0) :
> +		    fs_context_for_unpriv_mount(fs_type);

[Severity: High]
Does allowing an unprivileged caller in the initial mount namespace to
open and configure a devpts context via FSCONFIG_SET_ROOTNS bypass
pty_reserve?

devpts has FS_USERNS_MOUNT set, and devpts_init_fs_context() grants access
to the reserved PTY pool solely based on whether current is in the initial
mount namespace:

fs/devpts/inode.c:devpts_init_fs_context() {
    ...
	if (fc->purpose =3D=3D FS_CONTEXT_FOR_MOUNT &&
	    current->nsproxy->mnt_ns =3D=3D init_task.nsproxy->mnt_ns)
		fsi->mount_opts.reserve =3D true;
    ...
}

Previously, fsopen() required may_mount(), forcing unprivileged callers to
unshare a mount namespace first.  With this regression, an unprivileged
user in init_task.nsproxy->mnt_ns can open devpts, bind it to a userns via
FSCONFIG_SET_ROOTNS (which runs devpts_init_fs_context() while still in
the initial mount namespace, setting fsi->mount_opts.reserve =3D true), and
allocate PTYs from the host emergency reserve up to pty_limit.

[ ... ]

> diff --git a/fs/namespace.c b/fs/namespace.c
> index 781380945d784..a6c0a31e275ae 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -4658,6 +4659,16 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int,=
 flags,
>  	if (ret)
>  		return ret;
> =20
> +	if (!(flags & FSMOUNT_NAMESPACE)) {
> +		if (fc->rootns_bound) {
> +			if (!ns_capable(fc->user_ns, CAP_SYS_ADMIN) &&
> +			    !may_mount())
> +				return -EPERM;
> +		} else if (!may_mount()) {
> +			return -EPERM;
> +		}
> +	}

[Severity: Medium]
When fc->rootns_bound is true, can a caller lacking CAP_SYS_ADMIN in
fc->user_ns bypass the fc->user_ns capability check by satisfying
may_mount() in its own unprivileged mount namespace (or by passing
FSMOUNT_NAMESPACE)?

Because alloc_mnt_ns() below unconditionally uses fc->user_ns whenever
fc->rootns_bound is true, a task that passes this check via may_mount() in
an unrelated user namespace still allocates the anonymous mount namespace
in fc->user_ns and charges UCOUNT_MNT_NAMESPACES against fc->user_ns.

> +
>  	/* There must be a valid superblock or we can't mount it */
>  	ret =3D -EINVAL;
>  	if (!fc->root)
> @@ -4699,7 +4710,8 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, =
flags,
>  		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
>  			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
> =20
> -	ns =3D alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
> +	ns =3D alloc_mnt_ns(fc->rootns_bound ? fc->user_ns :
> +			  current->nsproxy->mnt_ns->user_ns, true);

[Severity: High]
Does allocating fsmount()'s anonymous mount namespace in fc->user_ns leave
host submounts without MNT_LOCKED when an external manager in init_user_ns
assembles a mount tree for an unprivileged rootns?

When a manager in init_user_ns creates a rootns-bound anonymous root mount
(so dest_mnt->mnt_ns is anonymous with user_ns =3D=3D fc->user_ns) and atta=
ches
a host submount from init_user_ns onto it via move_mount(),
attach_recursive_mnt() compares child->mnt_parent->mnt_ns->user_ns
(fc->user_ns) against current->nsproxy->mnt_ns->user_ns (&init_user_ns):

fs/namespace.c:attach_recursive_mnt() {
    ...
	if (is_anon_ns(ns))
		user_ns =3D current->nsproxy->mnt_ns->user_ns;
	else
		user_ns =3D ns->user_ns;
    ...
		/* Notice when we are propagating across user namespaces */
		if (child->mnt_parent->mnt_ns->user_ns !=3D user_ns)
			lock_mnt_tree(child);
    ...
}

lock_mnt_tree(child) only sets MNT_LOCKED on descendants p !=3D child,
leaving child itself unlocked, and commit_tree(child) then moves child into
the anonymous mount namespace owned by fc->user_ns.  When the assembled
anonymous tree is later moved into the target mount namespace (also owned
by fc->user_ns), the user namespaces match, so attach_recursive_mnt() does
not lock the tree and unprivileged users in the target namespace can
unmount the host submount to expose the underlying directory.  Conversely,
attaching a submount that was also created with FSCONFIG_SET_ROOTNS for
fc->user_ns onto the anonymous root mount sees
child->mnt_parent->mnt_ns->user_ns !=3D user_ns and spuriously runs
lock_mnt_tree().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118193539.2400=
65-1-jarkko@kernel.org?part=3D8

