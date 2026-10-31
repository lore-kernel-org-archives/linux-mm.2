Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4057606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 12:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h28KDO23
Received: by kanga.kvack.org (Postfix)
	id C447E6B05B1; Sat, 31 Oct 2026 08:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF53D6B05B2; Sat, 31 Oct 2026 08:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BF96B05B3; Sat, 31 Oct 2026 08:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBDD6B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:40:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CF96120919
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:40:14 +0000 (UTC)
X-FDA: 85382879148.18.6C1BCD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63782C000A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:40:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h28KDO23;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793450412;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAwFa1jm90LlccnAb6jymw87t0QqRMUMDVAtIGNtriY=;
	b=fCldCoJmRAx8JiatdFNUhSzkScvdsbB/HQJ6D6DsqfgdSMQ0Y/LO+BtbkDx1vpPmCFB1FP
	mb9QV/QEN9hkcbdxEk5Daw3ZtoGV9KTVz147lPoCh+RSTWgvmCbgcTrTDVgvTQx2kuACwQ
	CKNXQSWsv/ewVAERC2Xxuy7i/srNReM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h28KDO23;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793450412;
	b=eZeEy45F5ez0PW5xMhrMZu2SqtFWW2tguTllksJWbwGQzoSbfH/BaXOnq0p3+E+AP0bwrn
	Ron23/UcqvQAoCgXdQWAWqOiwPaXO0INdug2BTkkbwr1TLOlT9K7u5pEJFb4oQC7pdK1el
	itplP72JlC3fq4fa4JyJWKOyLPTTMZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DDAD42DF0;
	Sat, 31 Oct 2026 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9BD1F000C1;
	Sat, 31 Oct 2026 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793450411;
	bh=wAwFa1jm90LlccnAb6jymw87t0QqRMUMDVAtIGNtriY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h28KDO23sywy+uilQcqhjQBy2A3Ew4D3kmBm1yYKcrFiWKxQx2KgkKqCz70MN1Vun
	 eyzSbKc8dTlUrM2+EplAg+vDMjgax3GDk8vWMMk07FqpHAvP4+Pwly9lm/lhpBoXNd
	 7+h2ZgS0iE7LfDU9lS5LZIwaJ0HGE66M0YAMmnk3TE6zsLrz/dYYHLonmjDhw1bx09
	 6gSlZjhgX5b8EkJKC6xdui1r0NpDdQrAjXQixIbUzs8zGsrDNeK04Qwr9739yUb1xa
	 gAXENi6viaq/zawNk5YppZ4WXX+faEg+6s24VW5hUW69w4iqwwGXfydpBO+AMYqL9F
	 BVlWYPSwq554g==
Message-ID: <sashiko-outbox-191943@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/3] io_uring: add support for utimensat
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TcOpdmVuIENhcg==?= <meven29@gmail.com>, "Jens Axboe" <axboe@kernel.dk>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Hugh Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20261030123945.1704118-3-meven@kde.org>
References: <20261030123945.1704118-1-meven@kde.org>
 <20261030123945.1704118-3-meven@kde.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 12:40:10 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63782C000A
X-Stat-Signature: yym69szbh9tijxcmn4b7y9bsaz5xrr9i
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793450412-308744
X-HE-Meta: U2FsdGVkX18qMB1C/DIbovm1TvyYtpK2snxuSFdQeSh5dj8hvkOXdGdQIKvTMvEwlzmLF5ggMv5aNfig57I3gjobTu7O/qHZ1NJLRsqqQvphBDP+O+jzmA86suNvU8LeTqKWYhlBMW5doC+5Lqnuometi0r4251bUpFsiUAo4LhUtnCpPDkkUnyOi9pxUDAB98x4Fd6wYaCMmr9nnffmmwJIUyvt2b7R9fBHJf+F3csCptnFYCESZ4fdavWiyM/BqXxtrKQ3BOB3fHTxoRiqCdK7EpipGb8nQLkzi7XHFPIB/QhoLLyWyRWvKYOz0hNGXzDQ2DjDBWWCBExpY01BMSQEZHwcP/ET94TVHMxYPy03/pRJxBYWt3vkVCFQrm86WQjfn712AvElK9oYK1035xIamT5Xl6br2Eibma3fh3+wKqb6j+/arjvHyVM5FlXQTkK8Gr1PXk9Ychgp9uHy+f7SqlFtxA3mX4FRpRthCS5fjlg35Rv1DGRde8zMTsvjJvlVjt2ta3fMgcNPsjR98apsTvLa6FOnoKe8imhpbKehJwC59kohnYonGFqmLPrSwMHfUm1enWrotBYjUyU5TVQUfimIYUZ0ZsRDAKjRRAPnSF4UvOpdXBadYm3G2uqxXo/h8k2pDpCFPBLvtcD8XGkGNYA324hYlEoOEKdCtOFA3eYRYjnzkDPgKicO+8TYtPezjbbS+JK4TvejgtJtEDHAEEeGzMU6/XQEaB3RiJ+AvaPCMKmGTNyS4lv3AYaa+dIgmPJ3Y9Up2I/KQqRpFmTefvAlyTbHhfLqQStwvsmKp1HUWkV01On/g6HOsv9MPD7VQ+aI/iMCeNBmMhhFhTPrRmXqVUK5usYjRpSVyfj8jOIzpXAXxA7x4Qnjy05f8hy8gY/z1NOqbuCqdBszSJgvqfJYCX1RZJRuIFXe04HfoO4+HaqnpsccHd/YgMsOvYPWYVX3E3Xknr6suzY
 0I2Y7Yr6
 sQ7LhUXb1l/U1Nkp5M8+Kz4y6LqilTBcAqoWb2UMQKMGZsiPLufb707FEyU8hjdRCxznWuOzp2eGc2Y7rM6pxYyCgfyLMpFDiOZSjdH5O6lWnmVy1b3+6s6CuZnKevARgLo74wDqqYi8jyF4L9yo5wEQK8zXkPJbIPGiE9YEgpAHWSl1Wax4dK6fds7M4M10/+1e6Y+uk2Qcsqa8CTr80bqCx0IoYBI4YNbChI9VN52c7LNcbKNEj5VyiW1E0IR6RGy+A78M7QkShb9/FAqDiOYkjfG+nJd9L7EFhTW4x6LWOSXxBv2+7pea9KPjkPXvpN0jBejIK6sdp9k4OruZw6WarupccV21pU94mRCSm3pOotviu1QFN6fpGdl3/onGKEg9geMOP/Hm/LsGzI07Vsg7z1Tyf/zBSebOvOukSh4aj2Vus6YXpw7HfL2QzmpxrdEtcrOtJpbV+j0vleYkF25GfQyrh29MMLZGvYgJlMxUZU2OK8rJbEsGNuT3TlikZxAvnW+EfLCq7wjTYVJzsDVK7BPphOgXfFqh0UoVAMm1FeZ5z62iVUT5srGe36WbSP9mZDPLd6a8mnH3i8slN6HnxZwRynJmzUMRkRL4lTHtkH9yiMb6OyCiL2EJ/bN8X2UxizI4cbmXQHMjaOaCH7rA6sQ==
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
- [Medium] io_uring: missing flags check and wrong NULL path handling in io=
_utimensat()
--

commit 8d82d4a2e30073e0345719074be6f5140b1c8829
Author: M=C3=A9ven Car <meven29@gmail.com>

io_uring: add support for utimensat

This commit adds the IORING_OP_UTIMENSAT opcode to io_uring to support
updating file timestamps asynchronously via io-wq. It copies the path and
timespec arguments during submission prep and invokes filename_utimensat()
when issued.

> diff --git a/io_uring/fs.c b/io_uring/fs.c
> index 26ea841a22e70..85e0a1cb6b479 100644
> --- a/io_uring/fs.c
> +++ b/io_uring/fs.c
> @@ -304,3 +304,102 @@ void io_link_cleanup(struct io_kiocb *req)
>  	dismiss_delayed_filename(&sl->oldpath);
>  	dismiss_delayed_filename(&sl->newpath);
>  }
> +
> +/* Internal flags, above the AT_ flags of the SQE */
> +#define IO_UTIMENSAT_NOOP	BIT(30)	/* both times UTIME_OMIT */
> +#define IO_UTIMENSAT_NO_PATH	BIT(31)	/* NULL path: the dfd itself */
> +
> +struct io_utimensat {
> +	struct file			*file;
> +	int				dfd;
> +	unsigned int			flags;
> +	struct delayed_filename		filename;
> +	/* NULL sets both times to the current time */
> +	struct timespec64		*times;
> +	struct timespec64		ts[2];
> +};
> +
> +int io_utimensat_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe)
> +{
> +	struct io_utimensat *ut =3D io_kiocb_to_cmd(req, struct io_utimensat);
> +	struct __kernel_timespec __user *uts;
> +	const char __user *fname;
> +	int err;
> +
> +	if (sqe->len || sqe->buf_index || sqe->splice_fd_in || sqe->addr3 ||
> +	    sqe->__pad2[0])
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	ut->dfd =3D READ_ONCE(sqe->fd);
> +	ut->flags =3D READ_ONCE(sqe->utimes_flags);
> +	if (ut->flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
> +		return -EINVAL;
> +
> +	uts =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +	ut->times =3D NULL;
> +	if (uts) {
> +		if (get_timespec64(&ut->ts[0], &uts[0]) ||
> +		    get_timespec64(&ut->ts[1], &uts[1]))
> +			return -EFAULT;
> +		ut->times =3D ut->ts;
> +		if (ut->ts[0].tv_nsec =3D=3D UTIME_OMIT &&
> +		    ut->ts[1].tv_nsec =3D=3D UTIME_OMIT) {
> +			ut->flags |=3D IO_UTIMENSAT_NOOP;
> +			return 0;
> +		}
> +	}
> +
> +	fname =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	if (!fname) {
> +		if (ut->dfd =3D=3D AT_FDCWD)
> +			return -EFAULT;
> +		ut->flags |=3D IO_UTIMENSAT_NO_PATH;
> +		goto out;
> +	}
> +	err =3D delayed_getname_uflags(&ut->filename, fname, ut->flags);
> +	if (unlikely(err))
> +		return err;
> +	req->flags |=3D REQ_F_NEED_CLEANUP;
> +out:
> +	req->flags |=3D REQ_F_FORCE_ASYNC;
> +	return 0;
> +}
> +
> +static int __io_utimensat(struct io_utimensat *ut, struct filename *name)
> +{
> +	int flags =3D ut->flags & (AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
> +
> +	return filename_utimensat(ut->dfd, name, ut->times, flags);
> +}
> +
> +int io_utimensat(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_utimensat *ut =3D io_kiocb_to_cmd(req, struct io_utimensat);
> +	int ret =3D 0;
> +
> +	WARN_ON_ONCE((issue_flags & IO_URING_F_NONBLOCK) &&
> +		     !(ut->flags & IO_UTIMENSAT_NOOP));
> +
> +	if (ut->flags & IO_UTIMENSAT_NO_PATH) {
> +		CLASS(filename_kernel, name)("");
> +		ret =3D __io_utimensat(ut, name);

[Severity: Medium]
When sqe->addr is NULL (the IO_UTIMENSAT_NO_PATH case), should
io_utimensat_prep() and io_utimensat() follow do_utimes_fd() instead of
allocating an empty filename and routing through filename_utimensat()?

In fs/utimes.c, do_utimes() dispatches a NULL filename (with dfd !=3D AT_FD=
CWD)
to do_utimes_fd():

fs/utimes.c:do_utimes_fd() {
	if (flags)
		return -EINVAL;

	CLASS(fd, f)(fd);
	if (fd_empty(f))
		return -EBADF;
	return vfs_utimes(&fd_file(f)->f_path, times);
}

Routing IO_UTIMENSAT_NO_PATH through getname_kernel("") -> __io_utimensat()=
 ->
filename_utimensat() -> filename_lookup() differs from utimensat(2) in seve=
ral
ways:

1. In io_utimensat_prep(), non-zero sqe->utimes_flags (AT_SYMLINK_NOFOLLOW =
or
AT_EMPTY_PATH) are accepted when fname is NULL, whereas do_utimes_fd() reje=
cts
any non-zero flags with -EINVAL.

2. In filename_lookup() -> path_lookupat(), an empty string returns from
link_path_walk() with nd->last_type =3D=3D LAST_ROOT without calling step_i=
nto(),
so LOOKUP_FOLLOW is not applied to dfd itself. If sqe->fd is an O_PATH |
O_NOFOLLOW descriptor referring to a symlink and sqe->addr is NULL, this
modifies the symlink itself even when AT_SYMLINK_NOFOLLOW is not set.

3. In path_lookupat(), path_init() sets ND_JUMPED and complete_walk() invok=
es
d_op->d_weak_revalidate() on filesystems such as NFS and 9p. If sqe->fd ref=
ers
to an open file that has been unlinked, d_weak_revalidate() fails and
filename_utimensat() returns -ESTALE (after an extra server round-trip),
whereas do_utimes_fd() calls vfs_utimes() directly on fd_file(f)->f_path and
succeeds.

4. Every IO_UTIMENSAT_NO_PATH call allocates a 4KB struct filename from
names_cachep and records a synthetic empty filename in audit_getname().

Also, the commit message states:

"Unlike the syscall, a NULL path or AT_EMPTY_PATH also works on an O_PATH
descriptor."

Doesn't the utimensat(2) syscall already support AT_EMPTY_PATH with a non-N=
ULL
empty path on an O_PATH descriptor via do_utimes_path() ->
filename_utimensat() -> filename_lookup(), while only rejecting O_PATH on a
NULL path in do_utimes_fd()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030123945.1704=
118-1-meven@kde.org?part=3D2

