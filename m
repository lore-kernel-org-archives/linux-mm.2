Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A255F588C1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18116B0005; Mon, 20 Apr 2026 08:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC87E6B0089; Mon, 20 Apr 2026 08:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7376B008A; Mon, 20 Apr 2026 08:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 899AE6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:26:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C4C3C30C2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:26:15 +0000 (UTC)
X-FDA: 84678856710.24.21786F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A78AC1C0013
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:26:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a3V+dO0a;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776687972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEnx4Wqci8HD50rtl9xFc5lN8Y2Q7lBCoFZ+ZVvl19Q=;
	b=WmUEJWpkpCBayWAR8ex6IWj/ml3mBGSDd8fbqb401oLaq+sp/gEH5MqDNqBbkcLBLkODrn
	tI7QII9NlWR7e2zS1EnggdYaJ5F69FG307E7RU9LIoMwGMufHgP1hGgjx6mh3P0C9SC+kI
	wgQl+Jk3/dmUqOyai3ACvLHPXIezdVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776687972; a=rsa-sha256;
	cv=none;
	b=2cvBRSy5VMJJURrEjb1pb3ac6Bxtihzsowtj3vMDfIqspfRsiBpxswMB6dOjbo8AQ+1Nqv
	2XhElL01LUJv3RL9uVFuAfvtvByke4w7pUSSMULv/0wt6r0nw66II7ysXDj8zarIKgn3B0
	TqhvlcEWIvAgmC/2sbxDyjd4ParEF8g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a3V+dO0a;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3C2260055;
	Mon, 20 Apr 2026 12:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC42C19425;
	Mon, 20 Apr 2026 12:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776687971;
	bh=NPvvru1atvehbvKhZYRYUO9kUPlcfQ6JqexTC3M9d+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a3V+dO0atPZ+DFD4a1/pzLsyobwLowby2FGSQa0w+OnnTR0julvqN4/P77FvZEE+p
	 Jsj7OE9xDAQtlqyKsVRN7NTFV0uwnzf9f2SQBBVGkUkAgocAAtYr/HXlgOueRqCJ2M
	 QYJRxNUmaEHbt7gOath2QNmZWvyj+sSCOUN4IPKxQ41Jp2x4AESd8+B5aUKww1NNr7
	 HOZkkvMc5tLGSkz9KVBjfykRvXQhe3TVtLdlj4WX856vvVMTvNdR/xTRr7CcgiTmjn
	 VaRjksfW6Cx6IMfUSJQ3aM/iEHQYOrC6RCWiGq4XeXDnIHotrhw+DfoAfqUkJWWfHR
	 4tDrb8czhb+oA==
Date: Mon, 20 Apr 2026 14:26:05 +0200
From: Christian Brauner <brauner@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260418163358.2304490-4-luca.boccassi@gmail.com>
X-Rspamd-Queue-Id: A78AC1C0013
X-Rspamd-Server: rspam07
X-Stat-Signature: x9gtjyftbbma11oyowaxf6koqe7ht8p5
X-Rspam-User: 
X-HE-Tag: 1776687972-188771
X-HE-Meta: U2FsdGVkX1+yFCA83R8nvkRyOndAeE2E2SvtAusi+YSgdir4igLms3reDG+uhXyjZzoQFXfiNlVoQXupm4Gke5iXrftQQ+iSbOEiJ0nljfxescFbSRUREcy6tNYb4fS4I9X147BQPKfCQDvVUt+vSDhWevTnvNrJLq1Q3xiF9l5k9X7fZB+0jfPdZbqelkYPN5slSNRgsDj/vNCUxwVgNV3yMNGFkQyXCcZGng+VSAOzbekEkF1RQJwVew2V1t0LHWze8zDOAeW2vxpKwgRPIhZzsj/5zEnHZ3FA/8nBunVEWOu6Y2TivtWvrThAcDhY8975AEOutr5tRQTaThKDAiHt/ozKL8cxxo3kvI8QH5prdsrWOmKn36fYkSa2lLJol5RMWdjAu0mcqMK8Ek/odENm00XBwrRvVCrZxbJFFvqq4Rc3TZ0gWEkUk0E6FYpwBFIRj4MHjaW4QrnlsgnQRH4+3xpqbknr6GlTwD62pWYP8mL76eP1o5u4383FMtvKXeiWh3WiLcDMyRt0Qno3ORlJ1l3f0v1x+MEqTza7xgbLnIlcOn3DIy3hCooJOIWxV8yiubKtLXW8u1HteYTcriXsjusfErhKvXa3prA38rQqXIHd2ykGH7CZFqFdLGH3T8+mPbbLpkdw8TBJj9D1BpYjX/lvynfOhOkrSfn1GKUIXtsX8wc6V6tLaq8ZzxjqnXmq66OKQwChYrhB17rIB5DvNpwsb5tkRTKA9Jj0AnRmMI2vkSKA74/zw8Ja1j4II9UloR8Y4n/J7l3QdyosZRhSGhrRp0OebcgDoeIHlRw/878xGKlRvbKEyzwtU1YVkjMJReuOWIYiwn2QJphn9X3wQS+BWBFSw/J8vcMX4izEXCjYXnNLpIcxaYgRojkQeQ5NfIBYQSooS6vWBdUxlF2VfHRvPkYfTlhPxwY/snIFcrf+vdFXMUCBuwRZuACEW7JMudI8gAkwnZpqoed
 Mdpq3FN4
 SBIlQ+cI/eXAdO05YpwYGMTlE1/RdNib/lC8F+2QkgoOl/mu6UOCq7yjYnA1GEnJqBZ5qGbUw10mfpUU3UNPyXDsjhutSQUpab62PbSnbia0iakYYK02dQNjoxuDW6NJU1tB5P6Qiy4tjlBTlhMVxo4nmofDbhgzXU0gfm+ZgKY4UiJ7YfA8K8CJ454YHU253LmbCJmTyRQEO83tzoYA4DvkXGtw/VtO6r7jVjyJl5iD/XvvkjAQ8iIGWfGMl3fBnLwsYhSPFE5pu9gwnDZ3c+FggmYAFBWkMxjqM01xm8mSJC1qDzkBxqd3HRn/jQ4pSk/qzvf9vx8KmqIw2slXRF7f+y/NmwYE124fQpfLqj0xr6+JxDzZcAxVuuBMnX3f3Bu3NZCe/pK3CwgyzDiXuqTxEKBegBUOowSYyxB20cWw9TYoJRY09QH/pE3xiX7i2oW8ypq886MHNiuLfowiSaOtGA+2cTzUZ68aFhFeL30nhrChR2RCo3+0hSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 05:28:20PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> In userspace when managing LUO sessions we want to be able to identify
> a FD as a LUO session, in order to be able to do the special handling
> that they require in order to function as intended on kexec.
> 
> Currently this requires scraping procfs and doing string matching on
> the prefix of the dname, which is not an ideal interface.
> 
> Add a singleton inode type with a magic value, so that we can
> programmatically identify a fd as a LUO session via fstatfs().
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/uapi/linux/magic.h       |  1 +
>  kernel/liveupdate/luo_core.c     | 10 +++-
>  kernel/liveupdate/luo_internal.h |  2 +
>  kernel/liveupdate/luo_session.c  | 89 ++++++++++++++++++++++++++++++--
>  4 files changed, 96 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 4f2da935a76c..4f51005522ff 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -105,5 +105,6 @@
>  #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
>  #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
>  #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
> +#define LUO_SESSION_MAGIC	0x4c554f53	/* "LUOS" */
>  
>  #endif /* __LINUX_MAGIC_H__ */
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index dda7bb57d421..f1a63ebe4fa4 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -197,9 +197,17 @@ static int __init luo_late_startup(void)
>  	if (!liveupdate_enabled())
>  		return 0;
>  
> +	err = luo_session_fs_init();
> +	if (err) {
> +		luo_global.enabled = false;
> +		return err;
> +	}
> +
>  	err = luo_fdt_setup();
> -	if (err)
> +	if (err) {
> +		luo_session_fs_cleanup();
>  		luo_global.enabled = false;
> +	}
>  
>  	return err;
>  }
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 8083d8739b09..d4ac7b4c5882 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -79,6 +79,8 @@ struct luo_session {
>  
>  int luo_session_create(const char *name, struct file **filep);
>  int luo_session_retrieve(const char *name, struct file **filep);
> +int __init luo_session_fs_init(void);
> +void __init luo_session_fs_cleanup(void);
>  int __init luo_session_setup_outgoing(void *fdt);
>  int __init luo_session_setup_incoming(void *fdt);
>  int luo_session_serialize(void);
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 5e316a4c5d71..21cbe99fc819 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -50,7 +50,6 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> -#include <linux/anon_inodes.h>
>  #include <linux/cleanup.h>
>  #include <linux/err.h>
>  #include <linux/errno.h>
> @@ -62,7 +61,10 @@
>  #include <linux/libfdt.h>
>  #include <linux/list.h>
>  #include <linux/liveupdate.h>
> +#include <linux/magic.h>
> +#include <linux/mount.h>
>  #include <linux/mutex.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/rwsem.h>
>  #include <linux/slab.h>
>  #include <linux/unaligned.h>
> @@ -363,18 +365,73 @@ static const struct file_operations luo_session_fops = {
>  	.unlocked_ioctl = luo_session_ioctl,
>  };
>  
> +static struct vfsmount *luo_session_mnt __ro_after_init;
> +static struct inode *luo_session_inode __ro_after_init;
> +
> +/*
> + * Reject all attribute changes on the singleton session inode.
> + * Without this the VFS falls back to simple_setattr(), allowing
> + * fchmod()/fchown() to modify the shared inode.
> + */
> +static int luo_session_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> +			       struct iattr *attr)

Don't duplicate, please. Use the generic helper instead:

int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
		       struct iattr *attr)

> +{
> +	return -EOPNOTSUPP;



> +}
> +
> +static const struct inode_operations luo_session_inode_operations = {
> +	.setattr	= luo_session_setattr,
> +};
> +
> +static char *luo_session_dname(struct dentry *dentry, char *buffer, int buflen)
> +{
> +	return dynamic_dname(buffer, buflen, "luo_session:%s",
> +			     dentry->d_name.name);

Use the luo_session:[%s] which is the canonical format for this
(ignoring historcal abberations).

> +}
> +
> +static const struct dentry_operations luo_session_dentry_operations = {
> +	.d_dname	= luo_session_dname,
> +};
> +
> +static int luo_session_init_fs_context(struct fs_context *fc)
> +{
> +	struct pseudo_fs_context *ctx;
> +
> +	ctx = init_pseudo(fc, LUO_SESSION_MAGIC);

I'd just call that LUO_FS_MAGIC.

> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	fc->s_iflags |= SB_I_NOEXEC;
> +	fc->s_iflags |= SB_I_NODEV;

        ctx->s_d_flags |= DCACHE_DONTCACHE;

static const struct super_operations luo_session_sops = {
        .drop_inode     = inode_just_drop,
        .statfs         = simple_statfs,
};


> +	ctx->dops = &luo_session_dentry_operations;

        ctx->ops = &luo_session_sops;

> +	return 0;
> +}
> +
> +static struct file_system_type luo_session_fs_type = {
> +	.name = "luo_session",
> +	.init_fs_context = luo_session_init_fs_context,
> +	.kill_sb = kill_anon_super,
> +};
> +
>  /* Create a "struct file" for session */
>  static int luo_session_getfile(struct luo_session *session, struct file **filep)

Luo is going full anti-pattern here. This whole return via a function
argument completely messes up the later codepths. We don't do manual
get_unused_fd_flags() flags and then file in new code, and then fail
in-between:

        argp->fd = get_unused_fd_flags(O_CLOEXEC);
        if (argp->fd < 0)
                return argp->fd;

        err = luo_session_create(argp->name, &file);
        if (err)
                goto err_put_fd;

        err = luo_ucmd_respond(ucmd, sizeof(*argp));
        if (err)
                goto err_put_file;

        fd_install(argp->fd, file);

Restructure the code so it just becomes:

struct file *luo_session_create(argp->name);

static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
{
        struct liveupdate_ioctl_create_session *argp = ucmd->cmd;

        return FD_ADD(O_CLOEXEC, luo_session_create(argp->name));
}

and get rid of all this state and error handling. Please fix this.

>  {
> -	char name_buf[128];
> +	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH + 1];
>  	struct file *file;
>  
>  	lockdep_assert_held(&session->mutex);
> -	snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
> -	file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
> -	if (IS_ERR(file))
> +
> +	ihold(luo_session_inode);

Right, you're now sharing the same inode among all luo sessions. So
you've gained the ability to recognize luo inodes via fstatfs() but you
still can't compare two luo session file descriptors for equality using
stat() which is a major win and if you're doing this work anyway, let's
just go the extra step. You can mostly mirror pidfs and it's not
difficult:

// unique inode numbers for the lifetime of the system instead of using
// the shared ino allocator that can overflow

DEFINE_COOKIE(luo_session_cookie);

static u64 luo_alloc_ino(void)
{
        u64 ino;

        preempt_disable();
        ino = gen_cookie_next(&luo_ino_cookie);
        preempt_enable();

        VFS_WARN_ON_ONCE(ino < 1);
        return ino;
}

static struct inode *luo_new_inode()
{
	inode = new_inode_pseudo(sb);

	inode->i_flags	|= S_IMMUTABLE;
	inode->i_mode	|= S_IRWXU;
	inode->i_flags	|= S_PRIVATE | S_ANON_INODE;
	simple_inode_init_ts(inode);

	inode->i_op	= &luo_session_inode_operations;
	// Make sure to leave inode->i_fop unset so it luo fds cannot be reopened via procfs

	// Unique 64-bit inode. On 32-bit this will obviously be
	// truncated but a) LUO doesn't support 32-bit b) let's declare
	// anyone that wants LUO on 32-bit insane c) who uses more than
	// 32-bit worth of luo sessions d) if that's really something
	// you want to address you can do so later doing the same thing
	// I did for pidfs (see there for context).
        inode->i_ino	= luo_alloc_ino();
        inode->i_generation = pidfs_gen(pid->ino);

	simple_inode_init_ts(inode);
	return inode;
}

Now you can do

stat(fd_luo1, &st1);
stat(fd_luo2, &st2);

if (st1.st_dev == st2.st_dev && st1.st_ino == st2.st_ino)
		return true; // same luo session

Sooner or later you will want this. Let's do it correctly, right now.

A bigger design question for the LUO people:

How do the lifetimes of the luo session and the luo fd relate to each
other? The way the code is structured it looks like the luo session
thing that you currently store in the file:

        file->private_data = session;

outlives the file? Why?

Imho, two things should change in addition to the switch to the tiny fs:

(1) The lifetime of the luo session object should be tied to the
    lifetime of the session file descriptor so that when the last file
    descriptor for that luo session is closed the @session thing gets
    cleaned up. I assume that's the case anyway?

(2) Instead of stashing the session in file->private_data store it in
    inode->private_data. This has various advantages:

    * You can stash other information in file->private_data.
    * You can at some point have multiple files referring to the same
      inode/luo session.

> +
> +	snprintf(name_buf, sizeof(name_buf), "%s", session->name);
> +	file = alloc_file_pseudo(luo_session_inode, luo_session_mnt, name_buf,
> +				 O_RDWR, &luo_session_fops);
> +	if (IS_ERR(file)) {
> +		iput(luo_session_inode);
>  		return PTR_ERR(file);
> +	}
>  
> +	file->private_data = session;
>  	*filep = file;
>  
>  	return 0;
> @@ -653,3 +710,25 @@ void luo_session_resume(void)
>  	up_write(&luo_session_global.outgoing.rwsem);
>  	up_write(&luo_session_global.incoming.rwsem);
>  }
> +
> +int __init luo_session_fs_init(void)
> +{
> +	luo_session_mnt = kern_mount(&luo_session_fs_type);
> +	if (IS_ERR(luo_session_mnt))

panic()

> +		return PTR_ERR(luo_session_mnt);
> +
> +	luo_session_inode = alloc_anon_inode(luo_session_mnt->mnt_sb);
> +	if (IS_ERR(luo_session_inode)) {
> +		kern_unmount(luo_session_mnt);
> +		return PTR_ERR(luo_session_inode);
> +	}
> +	luo_session_inode->i_op = &luo_session_inode_operations;

Kill all of this now that you allocate inodes on-demand.

> +
> +	return 0;
> +}
> +
> +void __init luo_session_fs_cleanup(void)
> +{
> +	iput(luo_session_inode);
> +	kern_unmount(luo_session_mnt);
> +}
> -- 
> 2.47.3
> 

