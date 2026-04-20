Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8C9F588E3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 15:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0687F6B0005; Mon, 20 Apr 2026 11:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019746B0088; Mon, 20 Apr 2026 11:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71156B0089; Mon, 20 Apr 2026 11:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6A3F6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:28:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F36AE580C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:28:51 +0000 (UTC)
X-FDA: 84679316862.14.780D1F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9F21C1C0010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:28:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C34LCzRj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776698929; a=rsa-sha256;
	cv=none;
	b=hAAQ0OBtTb4YkdrV/4ynNhRcZf4AB5McNaQtB4gdAcCG/8Us3f7V9rGGy5hEEiwF0pnxIX
	rwxJWoSv2VzhOe6EdT8BWqxXRn/lFDHZ4Ykk6+7ykNB6EdyebGQOxBlPASrReeKCT8qJNi
	xLXGyBYGdYulumvXdRLwx42NvU/u4lc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C34LCzRj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776698929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+myhflj6fF13qIqARD9Qyawzys1fthIrz0XFSKXR2I=;
	b=utfqza5k6la2fbl8gRUSbZ6UNASqrIGEYWSgLOqvQKRx3OD8xmLA0yTLuDNPYwYDKzLhGc
	bnY+Dpkvz/j0W4E3Fjf7kKFq2MkFBj1gF+Kq0x1Yu2fPuhTsJV1o9DQlpS+ua+i51JV24j
	DiKwbFz/iaC5GxSkM+eEq8OCVz4qqa8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CAFD43CE5;
	Mon, 20 Apr 2026 15:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8F5C19425;
	Mon, 20 Apr 2026 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776698928;
	bh=uz7u2SSPzHvDHBudR7/78lE3R/RjjFMG9L6YXh1YC0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C34LCzRj60d9Jp5nYsn1U/5jCbE9UM2MCQM/1ahVgAdJ/yl/3NlHc4dlVYisy8zE3
	 Gkeni7MWu0r8YMsR6K+3Oua0cdjZd72TQv9E4qhAK5GecNZApZPsg5D9EKaqQR8SFE
	 bXZAqdi3iILzW9tGE/5nk8YEtfJRsrvckui/SzMQPqFqNBQCcXxsPoc4maZaGaRKx3
	 db1Xn+p1/SAMistvrBcEPYkEACfdA7fD1VVBIkWqWBVtqnCaBwEgb4HcrKFV7d/HdF
	 Ku4A16N1LpO82CBku3oOk5XbnENfsX6199ler+iAmkRJAX2GNmED3FzprMs70t67FZ
	 1jnbLN3nWe+0Q==
Date: Mon, 20 Apr 2026 17:28:41 +0200
From: Christian Brauner <brauner@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: luca.boccassi@gmail.com, kexec@lists.infradead.org, linux-mm@kvack.org, 
	graf@amazon.com, rppt@kernel.org, pratyush@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <20260420-buchung-panne-57e262f5057f@brauner>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com>
 <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
 <xpi24rt5ek2m2wkhv6celu75hgtgte2x4jhfkjar4gi22r7bdh@ilbxbhfxmm2v>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <xpi24rt5ek2m2wkhv6celu75hgtgte2x4jhfkjar4gi22r7bdh@ilbxbhfxmm2v>
X-Rspamd-Queue-Id: 9F21C1C0010
X-Rspamd-Server: rspam12
X-Stat-Signature: ebn9w395nsho95ntyr6dbgb3y8y5d575
X-Rspam-User: 
X-HE-Tag: 1776698929-722358
X-HE-Meta: U2FsdGVkX18s4vnuvxsnFw8Rz/1xQ7hpjkoFIQCpk6hewdOvhKLOZn08bI822E3CI8C1KPQpWm48EMj2KyjHN31HAhHu7Bm0RwjHfabhABQCKDndFCLcDKRoEQq+Z7HG5FD4xbM0HykFKOo3dfqvgGxzc6lAq6uSZrgVa/Al3BlmWG6jXsiEdFJhOLhUcRUrGvBTBpf5ZFUNxMirQWnWY8cF5stPLGN2lzrKTtE5Fx2lx/UNRCRk5gsfOxK+K7JF50dGJZXAe5bRDSkWXWoJg83W1i8OboWRxiEe6wfmvkpBnCiRBrz4NiZOQRAx/SvNg0W/khx8MApA1tREVC9/ecg6LDAyc6iQVmDppqR4rT4/YkKCejkXLfD/BwfCxqTS79mS3iHCBAP47loQUZKD7ujdCECfs6uwkbjAhiXEhUjoNH9rJSETdZ6ENMkOc8MHRvJBgvY4FOFFeS2K/TJlijr/mcrE5GBYjxsndK7bYe6fmDDmU9yb+RbGa0IRMPmrHLiN68W7X01AFq+ATPaPW2pq6UOyn3VB4bkhi1ghUvYoOatJVDP7kh4nPvT3deLyiFcbrNH+Au/u79YGz063g5+W1SH0qLckxxRHKHwXRfG3bPKIG5r2AU9vDjJ5mhPZ7arFE3NGEQ7HG26cyWPk0LcSvDc25TjDrxXZskHziKKZM4BhoLr5Byvtr9njIYNwun78SOAdSZm7NaOFB6OClLtTxDEcvH7NJhMDGjyC9LYNq1TU2uoDMjWJH/X2wkAUBVLN18aATt9TtAPA66rK7vFG2DgW2MglK5JYuYt9cqmtmagdI13YQAPm88lwpV/KHkJYLwvR6ab6EFx6T4mgqV1OGi1cq2zCEzchmdGeXEYHvzUCz6NRxXlWeccO+xuoO3hVBNyBdubQ73X9uzakJFSFFJqRFd9BdA/MHNxjmB5oe5JJxXOouNXjjQa0/rY4Kz6vmw5f+d04+KNY8hi
 50QgzscH
 Nc6ERbrRHB3GRBQS3DFETgG1ArZMS1euf7ClMLyGC8mDttP++KvGH24jlZXE2x2WmnFAljzQAb+wusAoiYGUZDGZAmSZuJFm+6/gfAjAbVfPef4G+BjQ3vjVvUz1sxDwy2ZrAHOxJBCqXy5ynxgV3Sm72u8y3C8DLtt9rqRczaivGIbpRcTADQOX12we/E0fbu2nuee/0XpHt4A5FVkauP8pUYv7CQ67yUl1prVjePiLNiz61FxXFWpTFOL19bTTj5oWktRzH3NaDtDthvF5EurLjSDT4tVzIj6GEG//AX/4LcDcDfv+XGz44eJXLRCKuKQL8TdbeoUjMk9CSId2lIrYtKeigrQlBVYDlz2LtH2LRrtvm+/lZouovWI0iuQMcKNGtlmO585crd1WTKMGX2LzQs/ZXzeOmB495ijU2+wlu5tPjaUym03HwOaccZmaHg4P6TorU4ewZhRbrqP9a8ezmFASGevUcakTBcBOz+kEXk2ASrrU3lxQBUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 02:55:56PM +0000, Pasha Tatashin wrote:
> On 04-20 14:26, Christian Brauner wrote:
> > On Sat, Apr 18, 2026 at 05:28:20PM +0100, luca.boccassi@gmail.com wrote:
> > > From: Luca Boccassi <luca.boccassi@gmail.com>
> > > 
> > > In userspace when managing LUO sessions we want to be able to identify
> > > a FD as a LUO session, in order to be able to do the special handling
> > > that they require in order to function as intended on kexec.
> > > 
> > > Currently this requires scraping procfs and doing string matching on
> > > the prefix of the dname, which is not an ideal interface.
> > > 
> > > Add a singleton inode type with a magic value, so that we can
> > > programmatically identify a fd as a LUO session via fstatfs().
> > > 
> > > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > ---
> > >  include/uapi/linux/magic.h       |  1 +
> > >  kernel/liveupdate/luo_core.c     | 10 +++-
> > >  kernel/liveupdate/luo_internal.h |  2 +
> > >  kernel/liveupdate/luo_session.c  | 89 ++++++++++++++++++++++++++++++--
> > >  4 files changed, 96 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > > index 4f2da935a76c..4f51005522ff 100644
> > > --- a/include/uapi/linux/magic.h
> > > +++ b/include/uapi/linux/magic.h
> > > @@ -105,5 +105,6 @@
> > >  #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
> > >  #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
> > >  #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
> > > +#define LUO_SESSION_MAGIC	0x4c554f53	/* "LUOS" */
> > >  
> > >  #endif /* __LINUX_MAGIC_H__ */
> > > diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> > > index dda7bb57d421..f1a63ebe4fa4 100644
> > > --- a/kernel/liveupdate/luo_core.c
> > > +++ b/kernel/liveupdate/luo_core.c
> > > @@ -197,9 +197,17 @@ static int __init luo_late_startup(void)
> > >  	if (!liveupdate_enabled())
> > >  		return 0;
> > >  
> > > +	err = luo_session_fs_init();
> > > +	if (err) {
> > > +		luo_global.enabled = false;
> > > +		return err;
> > > +	}
> > > +
> > >  	err = luo_fdt_setup();
> > > -	if (err)
> > > +	if (err) {
> > > +		luo_session_fs_cleanup();
> > >  		luo_global.enabled = false;
> > > +	}
> > >  
> > >  	return err;
> > >  }
> > > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> > > index 8083d8739b09..d4ac7b4c5882 100644
> > > --- a/kernel/liveupdate/luo_internal.h
> > > +++ b/kernel/liveupdate/luo_internal.h
> > > @@ -79,6 +79,8 @@ struct luo_session {
> > >  
> > >  int luo_session_create(const char *name, struct file **filep);
> > >  int luo_session_retrieve(const char *name, struct file **filep);
> > > +int __init luo_session_fs_init(void);
> > > +void __init luo_session_fs_cleanup(void);
> > >  int __init luo_session_setup_outgoing(void *fdt);
> > >  int __init luo_session_setup_incoming(void *fdt);
> > >  int luo_session_serialize(void);
> > > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> > > index 5e316a4c5d71..21cbe99fc819 100644
> > > --- a/kernel/liveupdate/luo_session.c
> > > +++ b/kernel/liveupdate/luo_session.c
> > > @@ -50,7 +50,6 @@
> > >  
> > >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > >  
> > > -#include <linux/anon_inodes.h>
> > >  #include <linux/cleanup.h>
> > >  #include <linux/err.h>
> > >  #include <linux/errno.h>
> > > @@ -62,7 +61,10 @@
> > >  #include <linux/libfdt.h>
> > >  #include <linux/list.h>
> > >  #include <linux/liveupdate.h>
> > > +#include <linux/magic.h>
> > > +#include <linux/mount.h>
> > >  #include <linux/mutex.h>
> > > +#include <linux/pseudo_fs.h>
> > >  #include <linux/rwsem.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/unaligned.h>
> > > @@ -363,18 +365,73 @@ static const struct file_operations luo_session_fops = {
> > >  	.unlocked_ioctl = luo_session_ioctl,
> > >  };
> > >  
> > > +static struct vfsmount *luo_session_mnt __ro_after_init;
> > > +static struct inode *luo_session_inode __ro_after_init;
> > > +
> > > +/*
> > > + * Reject all attribute changes on the singleton session inode.
> > > + * Without this the VFS falls back to simple_setattr(), allowing
> > > + * fchmod()/fchown() to modify the shared inode.
> > > + */
> > > +static int luo_session_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> > > +			       struct iattr *attr)
> > 
> > Don't duplicate, please. Use the generic helper instead:
> > 
> > int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> > 		       struct iattr *attr)
> > 
> > > +{
> > > +	return -EOPNOTSUPP;
> > 
> > 
> > 
> > > +}
> > > +
> > > +static const struct inode_operations luo_session_inode_operations = {
> > > +	.setattr	= luo_session_setattr,
> > > +};
> > > +
> > > +static char *luo_session_dname(struct dentry *dentry, char *buffer, int buflen)
> > > +{
> > > +	return dynamic_dname(buffer, buflen, "luo_session:%s",
> > > +			     dentry->d_name.name);
> > 
> > Use the luo_session:[%s] which is the canonical format for this
> > (ignoring historcal abberations).
> > 
> > > +}
> > > +
> > > +static const struct dentry_operations luo_session_dentry_operations = {
> > > +	.d_dname	= luo_session_dname,
> > > +};
> > > +
> > > +static int luo_session_init_fs_context(struct fs_context *fc)
> > > +{
> > > +	struct pseudo_fs_context *ctx;
> > > +
> > > +	ctx = init_pseudo(fc, LUO_SESSION_MAGIC);
> > 
> > I'd just call that LUO_FS_MAGIC.
> > 
> > > +	if (!ctx)
> > > +		return -ENOMEM;
> > > +
> > > +	fc->s_iflags |= SB_I_NOEXEC;
> > > +	fc->s_iflags |= SB_I_NODEV;
> > 
> >         ctx->s_d_flags |= DCACHE_DONTCACHE;
> > 
> > static const struct super_operations luo_session_sops = {
> >         .drop_inode     = inode_just_drop,
> >         .statfs         = simple_statfs,
> > };
> > 
> > 
> > > +	ctx->dops = &luo_session_dentry_operations;
> > 
> >         ctx->ops = &luo_session_sops;
> > 
> > > +	return 0;
> > > +}
> > > +
> > > +static struct file_system_type luo_session_fs_type = {
> > > +	.name = "luo_session",
> > > +	.init_fs_context = luo_session_init_fs_context,
> > > +	.kill_sb = kill_anon_super,
> > > +};
> > > +
> > >  /* Create a "struct file" for session */
> > >  static int luo_session_getfile(struct luo_session *session, struct file **filep)
> > 
> > Luo is going full anti-pattern here. This whole return via a function
> > argument completely messes up the later codepths. We don't do manual
> > get_unused_fd_flags() flags and then file in new code, and then fail
> > in-between:
> > 
> >         argp->fd = get_unused_fd_flags(O_CLOEXEC);
> >         if (argp->fd < 0)
> >                 return argp->fd;
> > 
> >         err = luo_session_create(argp->name, &file);
> >         if (err)
> >                 goto err_put_fd;
> > 
> >         err = luo_ucmd_respond(ucmd, sizeof(*argp));
> >         if (err)
> >                 goto err_put_file;
> > 
> >         fd_install(argp->fd, file);
> > 
> > Restructure the code so it just becomes:
> > 
> > struct file *luo_session_create(argp->name);
> > 
> > static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
> > {
> >         struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
> > 
> >         return FD_ADD(O_CLOEXEC, luo_session_create(argp->name));
> > }
> > 
> > and get rid of all this state and error handling. Please fix this.
> 
> We cannot do it this way because we must use copy_to_user() to return fd 
> via ioctl(), and since copy_to_user() may fail, we must do it prior to 
> fd_install().
> 
> Unless there is a specific VFS macro you'd prefer for this 
> delayed-install pattern, I do not see any other way to do this but 
> maintain the get_unused_fd_flags() -> copy_to_user() -> fd_install() to 
> prevent the fd being leaked into the process's table.

The usercopy happens in luo_ucmd_respond it's perfectly fine if that
fails. FD_ADD() handles all that. It reserves an fd, it opens the file
and if that somehow fails it cleans up both the preallocated fd and the
file (And if you need to do more stuff in between there's: FD_PREPARE()
+ fd_publish()).

What I meant is:

	static struct file *luo_session_open(struct luo_ucmd *ucmd)
	{
		struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
	
		err = luo_ucmd_respond(ucmd, sizeof(*argp));
		if (err)
			return err;
	
		return luo_session_create(argp->name);
	}
	
	
	static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
	{
		return FD_ADD(O_CLOEXEC, luo_session_open(ucmd);
	}

I'm not sure why you'd want file first then usercopy but if you need
that then:

	static struct file *luo_session_open(struct luo_ucmd *ucmd)
	{
		struct file *file __free(fput) = NULL;
		struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
		int err;
	
		file = luo_ucmd_respond(ucmd, sizeof(*argp));
		if (IS_ERR(file))
			return file;
	
		err = luo_session_create(argp->name);
		if (err)
			return ERR_CAST(err);
	
		return no_free_ptr(file);
	}
	
	static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
	{
		return FD_ADD(O_CLOEXEC, luo_session_open(ucmd);
	}

> 
> > 
> > >  {
> > > -	char name_buf[128];
> > > +	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH + 1];
> > >  	struct file *file;
> > >  
> > >  	lockdep_assert_held(&session->mutex);
> > > -	snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
> > > -	file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
> > > -	if (IS_ERR(file))
> > > +
> > > +	ihold(luo_session_inode);
> > 
> > Right, you're now sharing the same inode among all luo sessions. So
> > you've gained the ability to recognize luo inodes via fstatfs() but you
> > still can't compare two luo session file descriptors for equality using
> > stat() which is a major win and if you're doing this work anyway, let's
> 
> Luca, is there a specific use case in userspace where we need to compare 
> LUO sessions for equality?
> 
> Christian's proposed solution of using unique inodes provides a standard 
> VFS interface, but it introduces some memory overhead and, more 
> importantly, a performance overhead due to the extra metadata 
> allocations required during the performance-critical kexec blackout 
> window.

I'm excited to be convinced that the memory and performance overhead
matters for luo file descriptors in any shape or form. Userspace manages
processes using file descriptors via pidfs - systemd exclusively so. So
even if luo session fds are created at the same rate and amount like
processes you can rest assured that it will be fine.

Let me turn the argument around: You are adding a full-fledged
filesystem to the kernel for the sole purpose of providing a separate
filesystem type. Why are you bloating the whole kernel for this? Use
the anonymous inode api that allocates a separate inode, use your own
inode operations and then add an ioctl on top of luo if that's all you
need. If this is a proper fs, please do it properly and with foresight.

This whole patchset is based on an idea of mine and I don't need to see
it twisted into oblivion otherwise I'll just do it myself and properly.

I definitely want to be able to compare luo session by fd sooner or
later and retroactively bolting this on with the next hack because you
have userspace depend on the single inode stuff is not going to fly.

You also need to have LSM filtering on what may be persisted and LUO in
general. All of that falls out for free _trivially_ if you modify the
code to what I did. It is incredibly easy to do. To me this is ducking
behind questionable arguments to get something merged as quickly as
possible.

