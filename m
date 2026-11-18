Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BEAC606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IlOffqxo
Received: by kanga.kvack.org (Postfix)
	id 5E2EB6B0637; Wed, 18 Nov 2026 18:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593126B0638; Wed, 18 Nov 2026 18:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397976B0639; Wed, 18 Nov 2026 18:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2E4A6B0637
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:15:24 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6502D160918
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:24 +0000 (UTC)
X-FDA: 85449798168.12.29E04DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AE8E1100009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:15:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlOffqxo;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043722;
	b=novogk5y0lXxpEWv4RM/Xrfq25yjjv6PAI+PcL4MZ38lkdU0UxgCMGKBgHAM2KAEu/2uNd
	DuuFLoYxShCtMJDoWF+JlOKw9f+h9OmtjJDfs5+rMARGnMaYo3M1IipMRkXZAwt93qIvR9
	IjnQiG8FvUHKlYPy2xyRuiXNXk3rZCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043722;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1eMO0ZdPCEFQ/EmxlhiA7Qy9no17Gyx6XtDtYpbkALU=;
	b=q2nY966LT35KmrPYwj2oThNxKWU78vkgI/Cf6JYYE1E8LvG4mxzWJqnmwDhm7fCPmaZN4e
	MYvXyEGFWGYlhigr4HB2ZOVVdVYbMZsymuu3oHbVGeAqiVCa2wunbTrLQCD0O+vJ3mp6R7
	shqsb0rsZVZUb5Xj/y2O5PZMBS0NpGc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlOffqxo;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7DFB467BF;
	Wed, 18 Nov 2026 23:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC1C1F000C4;
	Wed, 18 Nov 2026 23:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043721;
	bh=1eMO0ZdPCEFQ/EmxlhiA7Qy9no17Gyx6XtDtYpbkALU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IlOffqxoh9JmlfnCMZQpBnMTvs/2KWqdLeuDzQE5j16E6wKe6CjMnw97euijuEAMs
	 i51UHpromUfBlyFvDmqHggTVOdFOOx8P+ANOeuIiZW0rH2w8zuWJH4Po34gqdJdcQp
	 lwQXjqiU2PbgRYwJmb5NoJxnb+ahONiotIHfhPDcpPXDVo4v3IXUTPhJAbdKXT4VAN
	 WWGkcCoimmcOkNuwGvd29BJdm2HSfLZFhQZf3RD9kubWumPQgIQvbQMJcWPMa/KlK5
	 u4dqLgms+pmjCl/TyMf8V/YYNzicPq9LTJfbC+wkg+p4xu+w3ZPFzq+kNxH/UuCcjW
	 Rt4aE1TqbQ/ag==
Message-ID: <sashiko-outbox-222162@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 08/13] fs: Support FSCONFIG_SET_ROOTNS in
 fsconfig()
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
In-Reply-To: <20261117231352.3816603-9-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <20261117231352.3816603-9-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:15:19 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AE8E1100009
X-Rspam-User:
X-Stat-Signature: jop9dx8g7gi716oxsfdcox1jf4hnsarp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795043722-562851
X-HE-Meta: U2FsdGVkX18tHuStdxN0UKLZuVuxmM9iGH76C9lovtfR8TQekN12ZX37aIolkWu/TktYXwZTQ41jm+5R9w7XlihZPCisxlvYrbZSZ75K5b0gZ5Ui8o3AME1MvjUTpXh0Dc+JMqFJORH/OX8we8lc18G6lT2BGOeIK6ZYe3nn3t/F8uTxpt6it6Mna7+i8Tkyt7LrG2By7kyWDE/gwLpto4Q45SfFk5/905e8t8yaKNy1ak+zs5NiaaAv/6ScIy6wwXm916l6bwBV8jGuB/uBfRDSfyBuWIYhkIg48rYd9aeUpZYmQOmcH2SNjAzIXWoe61+wqDPsLOuCnTbjtr/pEPts5IYWunvtLTU0OvloHl5+xwsb/asAfE9f8Lf/fHxFm2/q2Mr9Ek60GPmeB0zMTxdZh0o5K9iqHKtCGWHyTVj1ftyGL70RiGzUi6vKianV43KMmMJx80e3RQ5pYd97HO/7knWFFj3Jgmx7alL8RkOq0Cb5I3e1d22YhLBL9QPmA06h7KCiK0y8KRJaGy9zxcHYMA54X6Tn3V+vWt5QpxVnjyvORPubL64iyk37p68ZADS+WKkVebzubyDToBLTImU1Nxg62BZUUxqVJxfU62xSmsinloidgG0gZwH+MRfmIZne8MwH3IRchJ5rxl20Ini8xa7jDp2AG03DvjXOE5XgQ0p14oJrs23oDGLg45VE6XGEyCo0VX3WwTd+7U2BEL776oN0pEJh3xfg10zl+ZVoxM7UVrcuBd2UgAorqvSy1YhsawlXYxIFmKL/ooKwz8iw2zkAgCO+UXXAClLJvY74Bn/3+7g8spRKQ4D96RB6E5j7x80POW6imkJVXBr6fOsyLy2+Adk7jgKAkjGTzl0t0T8c3+rLSTOd2MmmxJT21rm7bdv4rUDU+0tRSQm/1si4RmQSkR4LcYIEQW9n0424SAAOHjldY5lVDpssROacDCs021z2FUbNfA0YNZc
 BiNAQRIv
 Lz3yenouofiqEfsPxnRcm1SDT/ubDDfuGky3mYW/jf6Oe72BvQQjswN1Kd8e7spvQJiSfLuurl+HCoQ2M04gGvghnmPQPR15zrGvZD8YhpsunlhmHKgQXu7HIlfwSSh4yvZSuKKr6H3GAKqmOLlf93KNdxrZ1qXkZg/IH8faXSfDM46hx1WlvI3YTvw/8z19D9oXwUVAakUCCdDJMzJJJPysbdvxrDfLOwyOE3xRb+ZqDUW0QxDtU1OArZ9NzmFgVngK3OkNF/HwGIYLPODYT8+VRPWt2Ona9OTxKtGkXTEn8Uv1rPaXcLFHJxyDchRU72VRt57gcRs16vgpls+PVCgAF8Y4hV+FQt6C06fEFK3mHTibkx7ddmoFFrtjJiYvjwtstvJmCRxFuguSCvj4CeBmup42xqPVk5BU9MXau9cNJjOh9hzthLjzlIbxapHN99BRHKJHesQ0S2l2IV9MPRkGfJNQJXTMiLaRfgjFnpEDg8w0zQdp9PN4JAtbFQMrtXICJ4TOCmjeeVBOwZYAAxyLLKic0IV72K26KX51UrvcbunfVDAOKUIfP45gfUDvvmCzRgUIrHL+nlFwLBCQKV8tUJev6Sv1OZAzxKNyVbGiGS3A2/l0Vw6EDCQdw8dgSBUve4sj+fSmw0nerBf/Vw3cpZRy/ClpQDz6mwormFrQULSDsUM5Po2koKQJ5BtrcovrNuQCSGDvz95l6Jr13fRcfft5G4JLoyfcBZkDqqbQengX5VMDwWDfFzgyKK6fIda0CqXnloXATOenQiAhNwA8Y3bROmmkVhI2c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Critical] fs: fsconfig_set_rootns() replaces fc->net_ns after
  init_fs_context()
- [High] fs: proc: missing pidns_is_ancestor() check in
  proc_set_rootns()
- [High] fs: broken fc->user_ns delegation in fsconfig_set_rootns()
- [Medium] fs: missing net_ns and ipc_ns capability checks in
  fsconfig_set_rootns()
--

commit 5cbef69c784337269ad86c164ca92e045e18c429
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support FSCONFIG_SET_ROOTNS in fsconfig()

This commit adds the FSCONFIG_SET_ROOTNS command to fsconfig() so a newly
opened fs_context can be bound to a target root namespace before parsing
parameters.

> diff --git a/fs/fsopen.c b/fs/fsopen.c
> index 70024870fefa2..ca3234c8c4e47 100644
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c
[ ... ]
> +static int fsconfig_set_rootns(struct fs_context *fc, struct fs_paramete=
r *param)
> +{
> +	struct user_namespace *user_ns;
> +	struct rootns *c;
> +
> +	if (!is_rootns_file(param->file))
> +		return -EINVAL;
> +
> +	c =3D param->file->private_data;
> +	user_ns =3D c->cred->user_ns;
> +	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
> +		return -EPERM;

[Severity: Medium]
Does checking CAP_SYS_ADMIN only against c->cred->user_ns allow rebinding
fc->net_ns or mqueue's ctx->ipc_ns to an ancestor namespace where the
caller lacks privileges?

In create_rootns(), when ROOTNS_USER is passed without ROOTNS_NET or
ROOTNS_IPC, c->ns->net_ns and c->ns->ipc_ns are inherited from
current->nsproxy and remain owned by an ancestor user namespace.  A caller
in an isolated network or IPC namespace that holds CAP_SYS_ADMIN in
c->cred->user_ns can then use a rootns fd to switch fc->net_ns or
ctx->ipc_ns back to that ancestor namespace without holding CAP_SYS_ADMIN
in c->ns->net_ns->user_ns or c->ns->ipc_ns->user_ns.

> +
> +	put_net(fc->net_ns);
> +	fc->net_ns =3D get_net(c->ns->net_ns);

[Severity: Critical]
Can replacing and dropping fc->net_ns here after init_fs_context() has
already run cause a use-after-free in filesystems that cache per-net state
during fsopen()?

During fsopen(), alloc_fs_context() calls fc->fs_type->init_fs_context(fc)
with the caller's current fc->net_ns.  In kAFS, afs_init_fs_context()
stores an unreferenced pointer into that netns:

fs/afs/super.c:afs_init_fs_context() {
	...
	ctx->net =3D afs_net(fc->net_ns);

	/* Default to the workstation cell. */
	cell =3D afs_find_cell(ctx->net, NULL, 0, afs_cell_trace_use_fc);
	if (IS_ERR(cell))
		cell =3D NULL;
	ctx->cell =3D cell;
	...
}

When fsconfig_set_rootns() calls put_net(fc->net_ns), the initial netns
can be freed once the caller exits it, leaving ctx->net dangling when a
subsequent fsconfig() call parses "source" via afs_parse_source() ->
afs_lookup_cell(ctx->net, ...).  If ctx->cell was non-NULL, it instead
holds a cell reference on the old netns and hangs afs_cell_purge() in
wait_var_event(&net->cells_outstanding) on netns exit.

Other filesystems also derive state from fc->net_ns during
init_fs_context() that becomes inconsistent after fc->net_ns changes:
nfsd_init_fs_context() and rpc_init_fs_context() set fc->user_ns from the
initial fc->net_ns->user_ns (and nfsd_fill_super() writes
nn->nfsd_client_dir into current->nsproxy->net_ns while keying the
superblock to fc->net_ns), while nfs_init_fs_context() sets
NFS_MOUNT_NETUNREACH_FATAL from fc->net_ns !=3D &init_net.

> +	if (!fc->global &&
> +	    (fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE))=
 &&
> +	    kuid_has_mapping(user_ns, fc->cred->fsuid) &&
> +	    kgid_has_mapping(user_ns, fc->cred->fsgid)) {
> +		put_user_ns(fc->user_ns);
> +		fc->user_ns =3D get_user_ns(user_ns);
> +	}

[Severity: High]
Does delegating fc->user_ns this way work for unentered ROOTNS_USER root
namespaces or for FS_USERNS_MOUNT filesystems?

For an unentered ROOTNS_USER rootns, create_user_ns() leaves uid_map and
gid_map empty until a process exists in the namespace, and
rootns_prepare_fork() rejects fork with -ENOENT while the rootns is in
ROOTNS_EMPTY before "/" is mounted.  Because kuid_has_mapping() and
kgid_has_mapping() are false, fsconfig_set_rootns() silently leaves
fc->user_ns unchanged while returning 0, so a privileged manager creates
an init_user_ns superblock (without SB_I_NODEV) and an unprivileged caller
later fails mount_capable(fc) with -EPERM.  Meanwhile, mqueue_set_rootns()
unconditionally overwrites fc->user_ns with ctx->ipc_ns->user_ns, so
mqueue_get_inode() assigns unmapped current_fsuid()/current_fsgid() values
to the root inode.

Conversely, when uid_map and gid_map are populated and fc->user_ns is
switched to a target userns different from current_user_ns(),
FS_USERNS_MOUNT filesystems that require fc->user_ns =3D=3D current_user_ns=
()
(such as ovl_fill_super(), ovl_parse_param(), and bm_fill_super()) reject
the mount with -EINVAL:

fs/overlayfs/super.c:ovl_fill_super() {
	...
	/* The fscontext fd may have been passed to another user namespace. */
	if (fc->user_ns !=3D current_user_ns())
		goto out_err;
	...
}

> +	if (fc->ops->set_rootns)
> +		fc->ops->set_rootns(fc, c);
> +	fc->phase =3D FS_CONTEXT_CREATE_PARAMS;
> +	return 0;
> +}
[ ... ]
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 7fbbe92bf73a7..5976029ad3f80 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
[ ... ]
> @@ -323,6 +325,16 @@ static int proc_get_tree(struct fs_context *fc)
>  	return get_tree_nodev(fc, proc_fill_super);
>  }
> =20
> +static void proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
> +{
> +	struct proc_fs_context *ctx =3D fc->fs_private;
> +
> +	put_pid_ns(ctx->pid_ns);
> +	ctx->pid_ns =3D get_pid_ns(rootns->ns->pid_ns_for_children);
> +	put_user_ns(fc->user_ns);
> +	fc->user_ns =3D get_user_ns(ctx->pid_ns->user_ns);
> +}

[Severity: High]
Should proc_set_rootns() verify that rootns->ns->pid_ns_for_children is a
descendant of task_active_pid_ns(current)?

Both proc_parse_pidns_param() and rootns_prepare_fork() enforce
pidns_is_ancestor(target, task_active_pid_ns(current)).  Without that
check here (and a return value from ->set_rootns()), a process confined to
a child or sibling PID namespace within the same user namespace can use a
rootns fd to mount procfs for an ancestor or sibling PID namespace outside
its active PID namespace hierarchy.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117231352.3816=
603-1-jarkko@kernel.org?part=3D8

