Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4815F606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fD/NaCGx
Received: by kanga.kvack.org (Postfix)
	id 332D36B05B1; Wed, 28 Oct 2026 04:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30AF46B05B2; Wed, 28 Oct 2026 04:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248356B05BB; Wed, 28 Oct 2026 04:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E69BF6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:46:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7778E160BFE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:46:33 +0000 (UTC)
X-FDA: 85371403866.04.9498AA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD8841C0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:46:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fD/NaCGx";
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793177191;
	b=qw7fviiqNAg8OLtby4NpwWkf3yS7h8+H1abx7RSTSs+qlos5VQtxw07VrNAIRaucDPqSe7
	dLvFL1bJ1wizygGE8nFl7MWw8FmX4X9Ns8GsO459aLV4QRFvSn7XCqV19ADj0hk3T96CAg
	2uHzX325JK42Wmecp3ibdjnvIDtkRyQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fD/NaCGx";
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793177191;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syKKADMyplobMGqibHGWdeKiAGGflNX1cl1V6TROdFw=;
	b=fumnTI1Bq7tcbIKbv7SpCIpg+z2AkgGYxChOrRhwT+/Pp4Wi4eE22y94nmtPvZqzVKSUuw
	XifhhWoY5jZrflUHPuw4chiqS9+vSLKSDcpwQWCT05LchlUzZR8hzwhs7iA1olNkxLKb8h
	ECEglwZG4YWQYCGryYuD4ov++TF7MY0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E732F4367A;
	Wed, 28 Oct 2026 08:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABB11F01829;
	Wed, 28 Oct 2026 08:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793177190;
	bh=syKKADMyplobMGqibHGWdeKiAGGflNX1cl1V6TROdFw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fD/NaCGx3WGLV5YPrnhnhPw4oumIuUUD8dINqujH4Jy2qdXlP+A49qI0xl71OwtOJ
	 g5SmXjS/G5OpZmtOgwEgHqm89XgzYNMZyCA4W+l0Mbmo4zsp3wcuJJ5n2ig7tqPoUb
	 JURNu2WYtycwGEc3w0Xpb1SPRMyFEkACmF62e38UnrXOTUXTSihGVE4En2YXgtvr2Z
	 aT0mES8wpgN4HJGcZhjPWDGISXH1rh9+Zl5MhGA6W1gJKgMT6diqcIyDyYbMuKIg4p
	 QpsasePUWTEC53/eQ/okzQ13923ZCX8FUIorOpTu03ynMNcgAeecHiewdm24YV/N3u
	 HTyvQ2K3vqLEA==
Message-ID: <sashiko-outbox-187635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/3] pidfd: Add task path ioctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Linxuan" <me@black-desk.cn>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Kees Cook" <kees@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "John Johansen" <john.johansen@canonical.com>, "Georgia
 Garcia" <georgia.garcia@canonical.com>, "Paul Moore" <paul@paul-moore.com>, "James
 Morris" <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-mm@kvack.org, apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org
In-Reply-To: <20261027-pidfd-get-paths-v4-3-e2a6a47e3c95@black-desk.cn>
References: <20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn>
 <20261027-pidfd-get-paths-v4-3-e2a6a47e3c95@black-desk.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 08:46:29 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: AD8841C0006
X-Stat-Signature: 1w3c3ua91zkk8w99n7h9q8gh8357yszt
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793177191-488601
X-HE-Meta: U2FsdGVkX1/6pJYq6Fcn2XncVm20nAi/84HJdmQqhymPYJSUOBUUM8x0VWPkBb6u9w0v8qBHPhK2MqtLjITrpkK84asmTRtBwSIraWFU2ysU/ITj4X4YC60us5WboxdmKN6aIts1ItUcBlvxlMA5TG8ovQgEESUHZzU1smF8F2sFs5At/+ZMOydYuEP5I0YRhv5z2xvJqKFdyPjul9HjTCl/ej5ot91vcnE68AMeus5E/4TNi1K4YQDT7uxDlWOFEbLXjJmA7d9E1e5E+UhU28Lv4kBDwPR4ojkBf2nL1UmoyeJl/9ZxWKBzK7FZNFkxzQKx+57wk8YSYnS5VJE89p/5Z60oHibIDe/7BBM9gCdvIG/Ua6a8LI33iIHhQkEdNxHwtp9VXIJkEFOkYJbV3U9/NlYD40uAT+ox1Hh8e12d/0f/pnreygZ0y55krcIWCxBr1k9oSaXMM5cYCu7KwE8OPK2x3SXumN2uVH7V/DPsVVUgGHKfvoSbquY0oekdMbcYtDOeoCNDTmJ8TL6gkXf5bLpvBU8GFKfqO1yPQnPs0E7Zo9K2ga1vVtrnUNEfV4b1A2URaOEX2Y3AT+qVD692WVHWSOhCYHnIMgZjuRoIToc+5xzMAqqOlf1t87Vr9uCUZ0UzNbTJDCw/vs1Ae33iu1pzvSXkNr2mcrGjZai2mCHdp4HNNhnuwjtAih/5w/dziBzHoMlFz3KIKpeDd4IbCXYXUOXIUavWm2xYrSTuoKw4z5F7bB9GtCj3O93xgr8ujH32ap3Xc6K8+MZ99yU9QfDeJA763WzfsyFRieOJKTcg+LbtTazy/vCjs49hKHnNChSEMGHll2U83tupR+F5U9GMI0qdD2hVJOaCQDGs848Da7UhKf7QCpBSDHsYum/cbAeDd/UOlFEc4MkpTEZNlhfHY/0XNlqL2tI3jd8055ZM/Tn4B4ZmUiP3z5zcBUrc++MgOKat3cahRvy
 XvqqTciw
 HVAYe4XfVhcUNv7NIZiAVgRTD7ct56TS8NfduSI1PtnWKUnuYPuMWpaib2ymmVOm5PqEqAs0eJRjKGRj3VQ5hQ80gicUJ5WGqREfdZ2iiqR7m0/UKn1iFj4QAQzBYzLU85+xw9h7oFBFCkr4Y7+CLKuhyfCgLv5z08RhKSl84zhwp8ob8Ll2JZqvwXdLPGxk0f6xmpWOhtFd6hdUhdwvln8eiJtOVd2ONh2gtEiwvGOWae5uVHJiNnEWVd3YwFnjDb7HKcckKmxByJknWHUHvzIiTh9KQyF37t599zbiV6O8uy8BvQvpvKx3M8H6xNrX1urkGhRcVo3po+4+C4gGe8y/W/l1ETbpVuUkFDS9gH/+ScKerBoEoAcj8sg9d4YrNMASSOUso2Oh2uPeqDPJFUkyN7u6k+0YsswVxUo1bunFVN1z4zFOLTFjEqYrAngYQ+bAAGSA60aIrwH/ikte5e0dQB26nqG8iGB2kXpVPxFPGjb84Hr7LCUr+OLGJyUMItkpmV+/O/P8fWPL1gYGGGEgFfGgGrA5GEm1cix655W60+HSePH6GN2D3JnIulmPtCKeU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] pidfd: missing d_weak_revalidate() check in pidfd_ioctl() task p=
ath opens
--

commit ce70068de308fcb3a1353124233724116074eb7b
Author: Chen Linxuan <me@black-desk.cn>

pidfd: Add task path ioctls

This commit adds the PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT ioctls
to return close-on-exec O_PATH file descriptors referencing a target task's
executable, current working directory, and root directory.

> diff --git a/fs/pidfs.c b/fs/pidfs.c
> index b70ec50f64da9..1e5b0dcb99756 100644
> --- a/fs/pidfs.c
> +++ b/fs/pidfs.c

[ ... ]

> @@ -707,6 +733,18 @@ static long pidfd_ioctl(struct file *file, unsigned =
int cmd, unsigned long arg)
>  	if (_IOC_NR(cmd) =3D=3D _IOC_NR(PIDFD_GET_INFO))
>  		return pidfd_info(file, cmd, arg);
> =20
> +	switch (cmd) {
> +	case PIDFD_GET_EXE:
> +	case PIDFD_GET_CWD:
> +	case PIDFD_GET_ROOT:
> +		error =3D pidfd_get_task_path(pidfd_pid(file), cmd, arg, &path);
> +		if (error)
> +			return error;
> +
> +		return FD_ADD(O_CLOEXEC,
> +			      dentry_open(&path, O_PATH, current_cred()));
> +	}

[Severity: Medium]
Should pidfd_ioctl() check DCACHE_OP_WEAK_REVALIDATE and invoke
d_weak_revalidate() on path.dentry before calling dentry_open()?

When a task's root, cwd, or exe is opened through /proc/<pid>/{root,cwd,exe=
},
proc_pid_get_link() jumps to the target path via nd_jump_link(), setting
ND_JUMPED in struct nameidata. Before do_o_path() calls vfs_open(),
path_lookupat() calls complete_walk() in fs/namei.c:

	if (likely(!(nd->state & ND_JUMPED)))
		return 0;

	if (likely(!(dentry->d_flags & DCACHE_OP_WEAK_REVALIDATE)))
		return 0;

	status =3D dentry->d_op->d_weak_revalidate(dentry, nd->flags);

Because pidfd_ioctl() passes &path directly to
dentry_open() -> vfs_open() -> do_dentry_open() with O_PATH,
d_weak_revalidate() is never called.

In particular, failfs relies on failfs_d_weak_revalidate() in fs/failfs.c to
prevent a task's root or cwd in failfs from being opened with O_PATH:

static int failfs_d_weak_revalidate(struct dentry *dentry, unsigned int fla=
gs)
{
	/*
	 * The root is only ever reached as a path-walk terminal by jumping
	 * to it: as "/" when it is the caller's root, or through a
	 * /proc/<pid>/{root,cwd} magic link. ->permission() already fails
	 * every walk of a component, but a jump lands on the root without
	 * one. Refuse here too so the root cannot be pinned by an O_PATH
	 * open or encoded into a file handle.
	 */
	return -EOPNOTSUPP;
}

If a task sets its working directory or root to failfs via
fchdir(FD_FAILFS_ROOT) or fchroot(FD_FAILFS_ROOT, 0), calling
ioctl(pidfd, PIDFD_GET_CWD, 0) or ioctl(pidfd, PIDFD_GET_ROOT, 0) bypasses
failfs_d_weak_revalidate() and returns an O_PATH file descriptor pinning
failfs_root_path, in addition to skipping weak revalidation on filesystems
such as NFS, 9p, and overlayfs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-pidfd-get-=
paths-v4-0-e2a6a47e3c95@black-desk.cn?part=3D3

