Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D857606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lytczblw
Received: by kanga.kvack.org (Postfix)
	id 97B336B05BA; Sat, 21 Nov 2026 19:11:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953336B05BB; Sat, 21 Nov 2026 19:11:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FCC6B05BC; Sat, 21 Nov 2026 19:11:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 511216B05BA
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:11:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A9ED12061A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:11:02 +0000 (UTC)
X-FDA: 85460824764.27.FCB3F9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 181F11C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:11:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lytczblw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306261;
	b=levkvCxgyBPEvndKyOtepedVSCCebxC/kJOnUabGvXM/ZPiZCnxOx5ge1LkajXbSU/e4zi
	ZPE1yUNcZ4dw/xW6fUulGYwyvDcKzOgJIRlQOvg+4WwIqChvDV/3ewdEilsrc8R/3d+HY7
	E6USZWkX+DLTM1Kj3bTjT2qaj9fve8U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306261;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJnzJ1/4fleHoLG1FgU2nPuff2XTKEAtpi6kFgEvrTI=;
	b=11ZNM/McZhv4EOWosaawJOGPVX5EaIdgHPYJiik5nbxzkuaFTOwPOMnmp4/2kEhaoYc8c3
	+B3sun5ZfhFge6gjDiTxFlWMyVCZGF2XMDGZz/3JZsPS5kuuDPi+cYBSKkvXUpctDNhXnQ
	WI93Gf+t2NeRLrGRmNcQtEDKcUL3eEA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lytczblw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A829618DC;
	Sun, 22 Nov 2026 00:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4B81F000C4;
	Sun, 22 Nov 2026 00:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795306260;
	bh=mJnzJ1/4fleHoLG1FgU2nPuff2XTKEAtpi6kFgEvrTI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lytczblw7VPLLPzLQ2VWXouheglnC1Jn8pzaJeH2QnyvHLYUvW1QVfVNNFn7cEhgU
	 nFN5K4Odc9zHnq54Tnz0zs7L6Si0eDV0BvmLti3Xz1EoMqwjO4C+oirtMXgmA7TyA3
	 dOGSDJtKYDhGxuXeKMI++8Lh98qTzlrtLkBksZIFwq7Gl8qQYSkt/tCrX+SJS0lZdL
	 4G4uUwvYUZTed5aQiW+yLhOa+GZNDQ3jeiKyJRAnjvPf/Man5uefi27rffR7jcLIVo
	 vNJ1tZJASO177H4m/nWZxiKxzgl3EqM9nUJYWDIeoxkigKwginxdyMU6kyp2eiuq7K
	 BC3Uhvy1Qnb8Q==
Message-ID: <sashiko-outbox-227552@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 17/25] fs: Support FSCONFIG_SET_ROOTNS in
 fsconfig()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Mikhalitsyn" <alex@amutable.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy
 Lutomirski" <luto@amacapital.net>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "Neal Gompa" <neal@gompa.dev>, "Paul
 Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261121000844.1863324-18-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-18-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 00:10:59 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 181F11C0005
X-Stat-Signature: 91t3hncgzn3dtu76r9b1bmj44h3zofsd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795306260-449408
X-HE-Meta: U2FsdGVkX1/Bf6NdWF2Ezw+I82pwVedwFmMcDrZqlerQzzwpJwhOliFY35Rhssh3pCpMvnvHf8jV4hHQRxz5GNFHUCGTvj/5dBXtXkcTR7K2EodOPdzaXx9Gv+l4SvnFrW2rk5U5WY+8Bj2Tnhho4a70+4MKYb05/l5UyFSjsImJ1uS+HHRM2dDcQor8g/qS/e1hkFOEiejMo1UUQ43ISJtHoKmqyg3bs+uqcLgdYvzkmw9YhJDEj/dPWfx3mBBbjg8fwk+YRcAJm3Q9SBshSgSBMUGilGcrlnspFTxCaa1Ux6UhsLkM45PMG4o/4HhMVL+oSoxA23gRNGab2nXWLseoT2Tx6KYBXYguEcz9lR0U5HRJi1MCydMefXPeJm/LQXEbVgK3I9c6esYYOE+GdZcY6rBOw5xYQG7oF4aHSz/LxlX14/LmgUcBX1GjI6inPwc5TCsivpNIcMhcHTZuMTXLtE3aAN7nPr8Mb02W2lZY9AnDMuDfm0b2lQ01MBL4aWmnJyrXFCox4mI3paTqENdfTr6xOrzddlfS7NuJnK69gsHLEmfV9p7gW7YFLzkk0kospKoG7mk463ck/8gJa4+xQuPiaAmNhIFHqF1JQSAkA+n2ti534JV7U4R8NaRMbR1yds+9nRTOvn5sYPdeeSDCJmbWEiD567dufw/s3/a80lHuwG8vDiAlYOao8g7jyYIzfBIPW8HFULc3bVIrpOFlIuVX4ra/Vyc+ub56VmctjUgAc7REJ1xcp11sH95Q0Ne5y6mhHhewYI4AEUpOIijcdK//3wfxocAiIT95+p46Sci0Ocdfxt3tWP11Qgei8kUy7x1m3+TPcFyEIalY335AiV1MYnxi3HmHdMkhu0GUnsUP77cVpY+AUwJSKthse5yUxjLFNS+mhoKeLtuBDsKmqKgCCS8kP7cPhq09+quxbJ1ozNc8BNh8dl/pjtFjkI57d+o7XQf+gSJiM9F
 vScnnGGW
 ujn9zXlo2Rusjhw64LTkXTUXW4CwxIqqpramkQyJOyhpI4XzP9KbOofaEG4MNI8dTBCOAwlsf8jV/+MRGWZpGll6Sdz4zEzOa4wegy6ozYK6j/vguBKITNJDj9Wv28ElDqK/LqcDSG544UkxBK3gyZb2gb/S/qwzbNossEEI8W6gcqiyLRrFWALcowaqTMLHBtJhFehQ2xcrRweUaZY1Qw3sS5LYkd8dJV3E9BZlMOTXDRWTKvedPRyQzujb52cRneDYtY+NyMulguirAl1W7l0QCPZGoCcP+I/dOp5FtYtlloXf5yU4MKgOTf10pS4orUAp7z9QSCrj3j0j+7Tbese0iTSaL7kGaR2FFaGhDlHMv5boUnhmAMhtNIIFQGgelSKRKkcNFZ+hs6EPkGQM/oy6WWw1b+XPmwencqTiBBQMw3kN5TW8v9w+OIZomi+1iVbGbgQPfZ0lZHZFM3g99WXEtRwVfLE5zBElMR/Pzp/Fcjsl6WpfVObws0druqTWZN1hzfhzheAgY69f8Tw78B67XFPImnOnPdPsieItBNXKWeM/F9PD1F5fCtMqP6LUuHVRWMYmTRhe2gmlAvUdwrzuOF4SNHDCiVg76tJ4VpW6fX5ea08+ofj16LrdSHYEHt0FZ5TfKRkwaAiTW+4ruKUk+uuUoWz0GM5XLEgRuKQSqMdqkHeJ9R6f2qdqwANM5tuLRZJU6Ddqr7eztlvwovi56/1rap4MNf9OLfTn4iQOb29EJ5rcYp5+UDp36f3B6U7uR9ha6EWAIh7wpFIslK0HxauHHpTn6iPRFHWahXLANUSg6fnXLwhfht57dfidAie5xxkjmdVRdu1I86Rio8aZoFxMar1bC+X/o+EpjjTKwgoU=
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
- [High] fs: incomplete namespace binding validation in
  fsconfig_set_rootns()
- [Medium] fs: stale fsopen() credentials retained in fc->cred by
  fsconfig_set_rootns()
--

commit f8ec195808901fb7269d7229635728d247b672b9
Author: Jarkko Sakkinen <jarkko@kernel.org>

fs: Support FSCONFIG_SET_ROOTNS in fsconfig()

This commit adds FSCONFIG_SET_ROOTNS and the ->set_rootns() fs_context
operation so callers with CAP_SYS_ADMIN in a target rootns user namespace
can bind a newly opened fs_context to that rootns before supplying mount
parameters.

> diff --git a/fs/fsopen.c b/fs/fsopen.c
> index 70024870fefa2..e0d65f6018a7e 100644
> --- a/fs/fsopen.c
> +++ b/fs/fsopen.c
[ ... ]
> +static int fsconfig_set_rootns(struct fs_context *fc, struct fs_paramete=
r *param)
> +{
[ ... ]
> +	put_net(fc->net_ns);
> +	fc->net_ns =3D get_net(c->ns->net_ns);
> +	put_user_ns(fc->user_ns);
> +	fc->user_ns =3D get_user_ns(user_ns);

[Severity: Medium]
Should fsconfig_set_rootns() also replace fc->cred with get_current_cred()?

alloc_fs_context() sets fc->cred at fsopen() time, when an unprivileged
FS_CONTEXT_AWAITING_NS context has not yet been authorized against any
target namespace.  If the fscontext fd is passed to another task or
credentials change before FSCONFIG_SET_ROOTNS, consumers such as
dentry_open(..., fc->cred) in fsmount() and proc_fill_super()
(fs_info->mounter_cred) will use the fsopen() caller's credentials rather
than the credentials that authorized FSCONFIG_SET_ROOTNS.

> +
> +	fc->rootns_bound =3D true;
> +	fc->rootns_mnt_id =3D c->ns->mnt_ns->ns.ns_id;
> +
> +	ret =3D fc->fs_type->init_fs_context(fc);
> +	if (ret < 0) {
> +		fc->rootns_bound =3D false;
> +		fc->phase =3D FS_CONTEXT_FAILED;
> +		return ret;
> +	}
> +	fc->need_free =3D true;
> +
> +	if (fc->ops->set_rootns) {
> +		ret =3D fc->ops->set_rootns(fc, c);
> +		if (ret < 0) {
> +			fc->rootns_bound =3D false;
> +			fc->phase =3D FS_CONTEXT_FAILED;
> +			return ret;
> +		}
> +	}
> +	if (fc->user_ns !=3D user_ns) {
> +		fc->rootns_bound =3D false;
> +		fc->phase =3D FS_CONTEXT_FAILED;
> +		return -EOPNOTSUPP;
> +	}

[Severity: High]
Is checking fc->user_ns !=3D user_ns enough to verify that the filesystem
supports binding to the target rootns?

binder_fs_type sets FS_USERNS_MOUNT, and binderfs_init_fs_context() neither
changes fc->user_ns nor implements ->set_rootns(), so fsconfig_set_rootns()
succeeds with fc->user_ns set to c->user_ns.  When FSCONFIG_CMD_CREATE then
runs binderfs_fill_super(), it captures the caller's current IPC namespace
instead of c->ns->ipc_ns:

drivers/android/binder/rust_binderfs.c:binderfs_fill_super() {
    ...
	info->ipc_ns =3D get_ipc_ns(current->nsproxy->ipc_ns);
    ...
}

drivers/android/binder/rust_binderfs.c:binderfs_binder_device_create() {
    ...
	bool use_reserve =3D (info->ipc_ns =3D=3D &init_ipc_ns);
    ...
}

An unprivileged caller in init_ipc_ns that binds a binderfs context to an
unprivileged rootns gets a superblock owned by c->user_ns with
info->ipc_ns =3D=3D &init_ipc_ns, allowing it to bypass
BINDERFS_MAX_MINOR_CAPPED and allocate from the minor pool reserved for the
initial IPC namespace.

Similarly, sysfs_init_fs_context() and cgroup_init_fs_context() capture
current's net or cgroup namespace and overwrite fc->user_ns with that
namespace's owning user_ns without implementing ->set_rootns(); if
current's net or cgroup namespace happens to be owned by c->user_ns,
fc->user_ns =3D=3D user_ns holds and the context silently binds to current's
namespace instead of c->ns.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121000844.1863=
324-1-jarkko@kernel.org?part=3D17

