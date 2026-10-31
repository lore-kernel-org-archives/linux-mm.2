Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB3D606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 12:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEj64ez0
Received: by kanga.kvack.org (Postfix)
	id 744CC6B05B2; Sat, 31 Oct 2026 08:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713346B05B3; Sat, 31 Oct 2026 08:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602F86B05B4; Sat, 31 Oct 2026 08:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C86B6B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:40:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FC9F12078A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:40:14 +0000 (UTC)
X-FDA: 85382879148.23.CE00087
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11B46A0007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:40:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lEj64ez0;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793450413;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4OvNgn/qhXgfGJrhnLZ2CYxIpK/NMtIsm69e4lDOaLE=;
	b=dvP4pKeOCtBAFhg0b5RZOKwVAaSyprS1Ab5YYotadBX91+jHVwx6F986o2aKAUOwi3fl3M
	DR5/vNhcWzg+Exj7GyDpaN4WjgREXthohNi8IHWgv+0c51NJq3Pum+zoVwTsXjQfPIOefA
	4vQcHOAvODWxSlrXLGa91quMWYhf3VE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lEj64ez0;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793450413;
	b=wsaLebI2+c8mUyRqAmyXbUReXMV/iSj1g+I2wbY1XOSXUxh4ksgW8uGRx4DqNPVYFtRfoX
	XdmP2rJhy6OIn51n/OJ78cKRRJHkumFaNP5i5qFW4agZAKx++RpToE93awyfo3Nt7Xi/wB
	Oi0vVRzMc1LK293YfLuEHnB9Z12vSdM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 79EF56020F;
	Sat, 31 Oct 2026 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF411F000C1;
	Sat, 31 Oct 2026 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793450412;
	bh=4OvNgn/qhXgfGJrhnLZ2CYxIpK/NMtIsm69e4lDOaLE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lEj64ez03g4EaqBeLm4FoEZ45NVj/y3NVmRX5dJZgm2lCzh+HOZdsaCR/54iNFK2j
	 HatGNygT0MGjRPZVNLBFduZzARJlrbFix7P2U2t8h208iQh+9ZR3EbFcGuWqeSK70F
	 dtcOSogZhiOFfyAQ0nsTy0LwkSAd/eJo4jsWqQnjgg3oc4vB8WQONWYPD6F6P6Ekah
	 mVlnJj6ITcGZRaySaNXqRgH4vInXenlqM03whe6VpBP+0kQq+ChfMOgdxob531FpFQ
	 njaf6etQHUe2RLx9AJ5+mkUrss49MtH7Wj2MEpp6U/cFoNqWnAZ/yML7pI6xIduV9r
	 wf0TeNisXqwxA==
Message-ID: <sashiko-outbox-191944@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/3] io_uring: set times inline when the filesystem
 cannot sleep
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TcOpdmVuIENhcg==?= <meven29@gmail.com>, "Jens Axboe" <axboe@kernel.dk>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Hugh Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20261030123945.1704118-4-meven@kde.org>
References: <20261030123945.1704118-1-meven@kde.org>
 <20261030123945.1704118-4-meven@kde.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 12:40:11 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11B46A0007
X-Stat-Signature: zrzkyhyi7ykf6cb9ugotafiffdwqu17i
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793450412-120077
X-HE-Meta: U2FsdGVkX1/h3YOUMzLrNqkHvPV6Foud12ypUhcR75dOUtxLXIg/TSM5kRH03i9PmBoznpJTwywcqS00PEgzWDo0AspGyJyva3J1SVF+MlnbtJJ/gwBpgkac/EA9+EWLY0HAZqIl1kdosp51JRha+QQhvZvYkPG/BUTF70VOtlX09Y2lB1qp4Nlkyz7uOZXaXjbXGwkZsyDqqKafyeaS7ot0ubs0ysMfAiX1E4vov1P84WwOc/vl5zZhbAFZuPJz9XeYyO2e16krexpJcFtRcUT18LuVTO73oOVDheP028uKZNn65y8tOulZXxTkCoAAPNR8sOvynW1JsipPJSIlnCFWg5lqIxlkvNfoNb7MIivVcdu2klmtKdEw1twvLLgX9iVcxUugi5cUft972hTUPyLO/3oFSDX3XraK8HUFefyPUxfsyvuwIdLdIDAFBTM0dvqQAH65Xfo3ZvIUD/J6deQ4ePMqW0krirVdQ9TkNcSacHhC2oSy0bPxO5fBtRqgKyVCxswptw2FQCmtDV1vwyjm/TN3TJTRhwV0dzPKRYk4DMYuPr19ZhxleSPAlR0TlVwG65g31+IRBx8EYM8rq81aADFYUsxa5mXpt1lAQU4X29b4V3mwRh5q25Nss1DUUEUWf6T1cC6ACwG4nyq0HJF9VdCwELH8LjNAndxCn3NkKe+ykEBh6quxgJIaziuAF5rJnEG/Qe9+Rc4RuUqRHDncqZB3iaR9Twy3l73wMooXwRKyaAPPztFXc5ZRbcxoej+bVIXah4at+74+36f39LbyXk8QAswzrt7NqR2Dt1EW2OYkM4VYtHS+PCo329uAu+A6vRziruTwrGKidW2saOsg86GXfultG0zfRJNZ9H3EgwCoxatxgJ6l46/10HibmGW2piqT7L1obGBCBUU84+n9KEWiOizsYblOrKgBRtBgBJVVz/WlOEV4IbYTRu6rIWwqFXhQdh0eMdpKzgS
 L5wzHJ2/
 pObSqpRcGFlwaigA3uHk92DAzLVTNg9qSpT/zbCm2ebdCUlRfLCgawvkqSJrm3jr5408rk+pjSHsWIgD6rx74xoJwoB6YmgPJyTQtl+i5avDgxizPAGsayRPYnEIiKp84fNX7ZeP+G7tUBE3E8IZ+8YPuYUmRDl5AJ8YQblK1vUpiNBA4ovonHifYovCXNuhzbFqqhnE5kLLLHOH8lBOIZNfkaWKKXYXevyTBku5iYbmEV0gnCuNO31EtkMf/t2f7YG/oZFmYg7eSiFHFecY+Jo4Vx/YLLNp0Na5zSM05XqDzGSrKpKiCYf4gjKrrx9fA1Ja3H8zhUpzp8mPzngk/KOCuNNqqI8+7H1GRlbLaWGSQqYkPO1gmQptGyUGTwY0MGu5nYyd0+o1HMXk+GGBOiJ77rqQ/sEO0JBlyfXcsK7VtrMx+APFHtSxHRWXu3Yrlg5E9Yam2SYMOcXTVq/ROYsggEIvHtU11bs+DaP3VnACt7npGFgMZiudf53+jVRMIeRFKoo0r7ybeVXJjIDsesb/YQfaLWhe0TSlR7y0nqRgQlYcSJrLcDcNOt8g7PCQG59ZuOJtV8irWU/GJj8qmoXOaP36gXq2N2rJvpj8mCmYt1Tab7//4u4puHs+tfPHnFiOE5Srh0Wl/6zPs4yCqdDV0QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] fs: utimes: direct di_inode access and iput() in __vfs_utimes() =
under nowait
- [Medium] fs: utimes: blocking lookup and audit before FS_SETATTR_TIMES_NO=
WAIT check
- [Medium] io_uring: fs: missing flags=3D=3D0 check for NULL path in io_uti=
mensat_prep()
--

commit 1030cd9e18d185bfa4d7791c093821be89bb0205
Author: M=C3=A9ven Car <meven29@gmail.com>

io_uring: set times inline when the filesystem cannot sleep

This commit adds non-blocking inline execution support for
IORING_OP_UTIMENSAT when the target filesystem sets FS_SETATTR_TIMES_NOWAIT
(enabled for tmpfs), falling back to io-wq on -EAGAIN.

> diff --git a/fs/utimes.c b/fs/utimes.c
> index 8072f05ac8dcc..f70ad9003fa9e 100644
> --- a/fs/utimes.c
> +++ b/fs/utimes.c
> @@ -18,7 +18,9 @@ static bool nsec_valid(long nsec)
>  	return nsec >=3D 0 && nsec <=3D 999999999;
>  }
> =20
> -int vfs_utimes(const struct path *path, struct timespec64 *times)
> +/* With @nowait, returns -EAGAIN instead of sleeping */
> +static int __vfs_utimes(const struct path *path, struct timespec64 *time=
s,
> +			bool nowait)
>  {

[ ... ]

> @@ -63,24 +73,40 @@ int vfs_utimes(const struct path *path, struct timesp=
ec64 *times)
>  		newattrs.ia_valid |=3D ATTR_TOUCH;
>  	}
>  retry_deleg:
> -	inode_lock(inode);
> +	if (!nowait) {
> +		inode_lock(inode);
> +	} else if (!inode_trylock(inode)) {
> +		error =3D -EAGAIN;
> +		goto drop;
> +	}
>  	error =3D notify_change(mnt_idmap(path->mnt), path->dentry, &newattrs,
>  			      &delegated_inode);
>  	inode_unlock(inode);
>  	if (is_delegated(&delegated_inode)) {
> +		if (nowait) {
> +			iput(delegated_inode.di_inode);
> +			delegated_inode.di_inode =3D NULL;
> +			error =3D -EAGAIN;
> +			goto drop;
> +		}

[Severity: Medium]
Does this break the build when CONFIG_FILE_LOCKING is disabled? In
include/linux/filelock.h, struct delegated_inode only defines di_inode under
CONFIG_FILE_LOCKING, and is an empty struct otherwise:

include/linux/filelock.h:
    #else /* !CONFIG_FILE_LOCKING */
    struct delegated_inode { };

    static inline bool is_delegated(struct delegated_inode *di)
    {
            return false;
    }

Because fs/utimes.c is built unconditionally, referencing
delegated_inode.di_inode in __vfs_utimes() will fail to compile when
CONFIG_FILE_LOCKING=3Dn.

Also, when CONFIG_FILE_LOCKING=3Dy, calling iput(delegated_inode.di_inode) =
on
the nowait path invokes might_sleep() and can sleep if the file was
concurrently unlinked after inode_unlock(inode).

If __vfs_utimes() passes nowait ? NULL : &delegated_inode to notify_change()
instead, try_break_deleg() will initiate the non-blocking break and return
-EWOULDBLOCK (-EAGAIN) without taking an extra inode reference or populating
delegated_inode:

include/linux/filelock.h:try_break_deleg()
    ret =3D break_deleg(inode, flags | LEASE_BREAK_NONBLOCK);
    if (ret =3D=3D -EWOULDBLOCK && di) {
            di->di_inode =3D inode;
            ihold(inode);
    }
    return ret;

Would passing NULL for delegated_inode when nowait is true avoid both the
di_inode access and the iput() call here?

>  		error =3D break_deleg_wait(&delegated_inode);
>  		if (!error)
>  			goto retry_deleg;
>  	}
> -
> +drop:
>  	mnt_drop_write(path->mnt);
>  out:
>  	return error;
>  }
> +
> +int vfs_utimes(const struct path *path, struct timespec64 *times)
> +{
> +	return __vfs_utimes(path, times, false);
> +}
>  EXPORT_SYMBOL_GPL(vfs_utimes);
> =20
>  int filename_utimensat(int dfd, struct filename *name,
> -		       struct timespec64 *times, int flags)
> +		       struct timespec64 *times, int flags, bool nowait)
>  {
>  	struct path path;
>  	int lookup_flags =3D 0, error;
> @@ -90,13 +116,17 @@ int filename_utimensat(int dfd, struct filename *nam=
e,
> =20
>  	if (!(flags & AT_SYMLINK_NOFOLLOW))
>  		lookup_flags |=3D LOOKUP_FOLLOW;
> +	if (nowait)
> +		lookup_flags |=3D LOOKUP_CACHED;
> =20
>  retry:
>  	error =3D filename_lookup(dfd, name, lookup_flags, &path, NULL);
>  	if (error)
>  		return error;
> -	error =3D vfs_utimes(&path, times);
> +	error =3D __vfs_utimes(&path, times, nowait);
>  	path_put(&path);

[Severity: Medium]
Can filename_lookup() sleep or perform duplicate work on the nowait path
before __vfs_utimes() checks FS_SETATTR_TIMES_NOWAIT?

Inside filename_lookup() -> path_lookupat() -> complete_walk(), LOOKUP_CACH=
ED
is cleared before try_to_unlazy(), and if ND_JUMPED is set (such as for emp=
ty
paths, '..', '/', mountpoint crossings, or trailing symlinks) on a filesyst=
em
with DCACHE_OP_WEAK_REVALIDATE (e.g. NFS, 9p, or overlayfs),
d_op->d_weak_revalidate() is called in blocking mode without LOOKUP_RCU or
LOOKUP_CACHED:

fs/namei.c:complete_walk()
    nd->flags &=3D ~LOOKUP_CACHED;
    if (!try_to_unlazy(nd))
            return -ECHILD;
    ...
    if (likely(!(nd->state & ND_JUMPED)))
            return 0;

    if (likely(!(dentry->d_flags & DCACHE_OP_WEAK_REVALIDATE)))
            return 0;

    status =3D dentry->d_op->d_weak_revalidate(dentry, nd->flags);

In addition, when path_lookupat() succeeds on a cached dentry of any
filesystem lacking FS_SETATTR_TIMES_NOWAIT (such as ext4, xfs, or btrfs),
filename_lookup() calls audit_inode() before __vfs_utimes() rejects the
filesystem with -EAGAIN. When auditing is active, audit_inode() ->
audit_copy_fcaps() -> get_vfs_caps_from_disk() can sleep reading xattrs from
disk, records a duplicate audit entry, and bumps name->refcnt (forcing
putname_to_delayed() to allocate a second struct filename), while path_put()
also runs on the inline submission path.

> diff --git a/io_uring/fs.c b/io_uring/fs.c
> index 85e0a1cb6b479..79f6f39ce267a 100644
> --- a/io_uring/fs.c
> +++ b/io_uring/fs.c
> @@ -356,38 +356,44 @@ int io_utimensat_prep(struct io_kiocb *req, const s=
truct io_uring_sqe *sqe)
>  		if (ut->dfd =3D=3D AT_FDCWD)
>  			return -EFAULT;
>  		ut->flags |=3D IO_UTIMENSAT_NO_PATH;
> -		goto out;
> +		return 0;
>  	}

[Severity: Medium]
When fname is NULL and ut->dfd !=3D AT_FDCWD, should io_utimensat_prep() re=
ject
non-zero ut->flags with -EINVAL to match do_utimes_fd() in fs/utimes.c?

In fs/utimes.c, a NULL filename with a valid fd is routed to do_utimes_fd(),
which enforces:

fs/utimes.c:do_utimes_fd()
    if (flags)
            return -EINVAL;

whereas io_utimensat_prep() allows AT_SYMLINK_NOFOLLOW or AT_EMPTY_PATH when
sqe->addr is NULL and passes them through __io_utimensat() to
filename_utimensat(). Also, since IO_UTIMENSAT_NO_PATH operates directly on
ut->dfd, could io_utimensat() use fdget()/CLASS(fd) and __vfs_utimes() like
do_utimes_fd() instead of allocating a struct filename via
CLASS(filename_kernel, name)("") and doing a path lookup on Both the inline
and io-wq attempts?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030123945.1704=
118-1-meven@kde.org?part=3D3

