Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D2FF588E3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280F76B0005; Mon, 20 Apr 2026 10:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232346B0088; Mon, 20 Apr 2026 10:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1216D6B0089; Mon, 20 Apr 2026 10:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0060A6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:56:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92E34E5426
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:56:01 +0000 (UTC)
X-FDA: 84679234122.07.6288163
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id B025214000E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:55:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yoo0Bpvc;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776696959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/2qYMFwJjwqGwHltRGn7Jh51mB0n8KEJgoVpDxZIHs=;
	b=x40cQ4Wh1dRKvNXmomG++hhpk5TPyaFy5mAXHUb3k9br9TrQWLfdzPweG78DtPtRnfStAw
	/qOB4YqtO+AdN34V8D5UpNqlxQrqtHBJQHhifmVZYC+8iew+kMR7EULBLKmKObL7phPTE0
	LgTh/6cV/Tuj+lD02l7iVrAI0WrcJ5U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yoo0Bpvc;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776696959; a=rsa-sha256;
	cv=none;
	b=sPy+sETgK5l76+hqgnZXXAY8jm1LZr8hjHAYJ0w9jnwCJfYtmf0AKlff8HqwGDhChb1eMi
	SCDbFlKmoe0RZSt95o3+NYEU1cT/4yz2jXiYc30LxYG+wXEIdXjRJF0G8wbKxEk5LKlet0
	xMuCg5x5F6wSctuCS29byS41zdqoqdQ=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8d65f4073bfso445243985a.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776696959; x=1777301759; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L/2qYMFwJjwqGwHltRGn7Jh51mB0n8KEJgoVpDxZIHs=;
        b=Yoo0Bpvc53F9H8R5gB1eDeoiBH1HuWP7wVAKIJR+CbIR34WdmaFQxk9zBmt0kTsYyN
         ZJ5vIpOSDEbfe44prK66PwO9cT1mhfQB2j1ooGSS1dVWktu+swW3olLaOFAdfPJVf75p
         U3ZAlj4MPhqkoXUUHGQEw8Q4iFVzus4+PlEPymv0mMOdy0Q6LPcoRqFZzq24BuPX6JRg
         gyUW6C6I7MGWlb+OEMHC7E7/FfP/OKsnjAeUEcpg7ZSEKNGbSYblx5/0t0Yu256cneGb
         2HEXf6PdlN1cng5FUE+JXoAPAwcWbqDvRL2e0yEwlH2moqbxBNinwSeN1maAaNnRINR7
         IUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776696959; x=1777301759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/2qYMFwJjwqGwHltRGn7Jh51mB0n8KEJgoVpDxZIHs=;
        b=hkoxTcmF91kCXYpcgToUH/nSdgx4OiGjZ6nYWu3cnD1k5ejSWnqjQef4ahs/XDW2r+
         9hNlHwaDY7alq2hOnlpRJnGTZN0Z6pIN+KrXjOb7kptkSqVxaG15v8QgIOy6HzFFQLOT
         PvoHy6iE5/ere2qFOLlm9amBlQzbk2B4hK5eRE+n5obFhLN20wH6y1Ek422EnYq1mLym
         6PZBHdtAnBoJtZGxPd90J/9X/ebs2/pD7gXj1nXvQCrYJaJa+0k7hLFF3EFdE5Y0sVZs
         o279HBzWd39xN4MDpaXnSeEmfPDDVVEj2zzXm1KSg2qoQ7sDkZjYUUdPpMXouOV89l4/
         RQWg==
X-Forwarded-Encrypted: i=1; AFNElJ/0KmgEGMfFGgsiUb6Uov5CRpAAJQo64ZNCT9AhUNN5IheMzxkbtpawL9CzqgovRHVTOOxEVkQsDg==@kvack.org
X-Gm-Message-State: AOJu0Yw9er4fJPq+MFdP72S+ziPso8VWpZfSG5qS95cmkYcbTZ5/KzNt
	diZyIYRTJIoo14SujY1BOABiubD72kEWl50AppPvBXo7XTUbuYfdoLo/bLNSJcoIBI8=
X-Gm-Gg: AeBDieuDZH1YGlEEhPi3fibmP7WVJptHGB+Hu74aepUza1pYA6Ui/4D/DhzZKxazOdI
	ByuhxHWO8Jh7fi3aFWTkPpqSacEFMMHtJFio610x2czjy8VYSyy0qJETMegx3pfGMQ8ke9MLdGr
	aYHCFs8Z71Wd9XxlDJJRXMizAjPOmDdsID+1J4L11KwKfuTOZHnH2ctQTNnuzXSv12jNDJqfyKE
	TEx0DfZ5rqtrLjS40FqbX6Ej7LD51vpHt7sZrF5PbxMc9KrVPHVu46JisqO1b4AQ0GEdAjAG9B1
	fKT4TTTjwpdYI1dIjW4QbePxmgwHaA3jkO6XIS15o0C1X/kcjp+1Ddq0n8KoWDvta/DUtGEpQJn
	g5ORz0VUaJYeTteZ2lkD8Wzv3SjpgkXohluTE72YEXqQEyZ8iKgb9D59maCw6UvgxvXOqxNuIwb
	IvTWZY9Tsz1V9UFgBlTG9+u6t2ha6moWP6a8Z9ZxEqWcqvTNcAys0e5cyiOtm3Ku55ALuPU7U=
X-Received: by 2002:a05:620a:4014:b0:8d0:a0e:c7f6 with SMTP id af79cd13be357-8e7913c1f71mr1915472885a.38.1776696958490;
        Mon, 20 Apr 2026 07:55:58 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe9800sm816998685a.5.2026.04.20.07.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:55:58 -0700 (PDT)
Date: Mon, 20 Apr 2026 14:55:56 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Christian Brauner <brauner@kernel.org>
Cc: luca.boccassi@gmail.com, kexec@lists.infradead.org, linux-mm@kvack.org, 
	graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <xpi24rt5ek2m2wkhv6celu75hgtgte2x4jhfkjar4gi22r7bdh@ilbxbhfxmm2v>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com>
 <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
X-Stat-Signature: xuicxw1h9wud198f356ds9kh1ziidz6y
X-Rspamd-Queue-Id: B025214000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776696959-363982
X-HE-Meta: U2FsdGVkX19gVfweLlKbCdXvOXN3u+qKEK7yCo6WsyUiNE5fW44gvVRZLjR2P2EFcYI60wbtlsjf377Jt/mqiBAs9lQhDywEfFViJIBp4iEXFx/zo1in9mSN/ME4KPUF/XylBV2XLx1M8KasOQGsPniez4W4Oqs9xvhlsjTJaYQuXyoU1+8VVF7iMYMa1vcuJL9oafcJSdcV0XVEIL0Hg/C13fcdXbVKWMHFpPhHbUtAodYZhze6AIdnqc9/aCoglbOgTb+y46G2vn5MZL4as9D8Thg+Jc4MvRrNwYXAYGH8P9JvRujhp3yk7ih5bqWqPNRmUxAmSLQ2Dk76xlak1wvzld9RW4RDPRdX8L+HCfk8a1Im2Vmy4A+ucUeY74vmYlR2KvAiaWUv6y8u7Vaot8cM1NnKp6Ivbe7hU/FW3VoCaj55APdChphv9uFPCh6mt03uhpxO6sbJjsFd8RUl1tHO569EVcMuWG+KyHfOm4soo+wSgkB47GVdnlXRGVh253LmS9JJK6i8avNtHEMBUVmbxzIhzpVn7pSRRm+MsVY/1BeuuJQdkK7TPfl8Md+PDUHRCmsu5G/nFoI31tKf2o+Fz1SsmRLUsv3qgqbBPwEhaDe+TqtUD3Bb6aB9bb+MaCzi8DhqPK4h6IW37UhFmxUJFATTyrnD6g2suxK4fwf9POLnOfkh3uXzPMAXs++p0leoIooxtOoJwI078bCgjMnlV9wx631SJFnpm8jwZBUkVuTFyUAIftcQDmP8BvAjTxKqJ8r1x0YvhTLlyqnb0cu1T2V/1F7Q+iPSCMRt8pwjnx9nxh+J6BZjndV/YniRn2zxLrwVchbE4T7JDR3sf5F44Npnc0CIv7RabnErtKMD1BU60284EWmxj7UVo/B3WRYqNxBTS0l3mYyZzIE9fBCAZ4kTLRbe/dp1bGwI4BJ7+NcB81M/Z+/pU36BoYQW8J2dgNnak9ePZjkNZh4
 GVEfna9w
 nVnsMYL80u46P7bMuZaMJh/jOMKKFmC+8464/1cA5BT9LWRd8L5Mo+ahDelPI8KEEMSYWfF9kJMO5xcVNL8Ii5rbmUXrUzHahZUORfYT1iRKEBF4TipjhFpYwuKIyUOGZ19k3YwZ6Z09cTvMVLOPSlmW74JkBTryEtYpZ0VHKdHJdpCo7bimHbuCEYwlFZhmZeihRa+dax8313yxmCdsBiPPMFiBB80nqPXMfvudtrdrQwyxhtRA4FZrhBjG6DK8TNt4u5eeUSeVR+CDiZyaTYIklf/eQfZh0F/0IghAzNKOmMbZFblU6asWyI1/xGr1F9zXdU/9Z2+TxcgXYQBEvIDhnZOWiXfK+l0GybzXCgTQC5vQnK3JsU0K90Egg78xa6ak4MxjH/KF7buWezz7Jfuo3JxjWtoOeMmKv3eYh4hvP4ZMoX4rTSyuI64aG78rTOznU2JriKdaZI7YcGSPuKg09AbGhI43wYjPbzm4g2s7LkSe3dSU2y1aoSG4Zu9+mv4lG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-20 14:26, Christian Brauner wrote:
> On Sat, Apr 18, 2026 at 05:28:20PM +0100, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> > 
> > In userspace when managing LUO sessions we want to be able to identify
> > a FD as a LUO session, in order to be able to do the special handling
> > that they require in order to function as intended on kexec.
> > 
> > Currently this requires scraping procfs and doing string matching on
> > the prefix of the dname, which is not an ideal interface.
> > 
> > Add a singleton inode type with a magic value, so that we can
> > programmatically identify a fd as a LUO session via fstatfs().
> > 
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/uapi/linux/magic.h       |  1 +
> >  kernel/liveupdate/luo_core.c     | 10 +++-
> >  kernel/liveupdate/luo_internal.h |  2 +
> >  kernel/liveupdate/luo_session.c  | 89 ++++++++++++++++++++++++++++++--
> >  4 files changed, 96 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > index 4f2da935a76c..4f51005522ff 100644
> > --- a/include/uapi/linux/magic.h
> > +++ b/include/uapi/linux/magic.h
> > @@ -105,5 +105,6 @@
> >  #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
> >  #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
> >  #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
> > +#define LUO_SESSION_MAGIC	0x4c554f53	/* "LUOS" */
> >  
> >  #endif /* __LINUX_MAGIC_H__ */
> > diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> > index dda7bb57d421..f1a63ebe4fa4 100644
> > --- a/kernel/liveupdate/luo_core.c
> > +++ b/kernel/liveupdate/luo_core.c
> > @@ -197,9 +197,17 @@ static int __init luo_late_startup(void)
> >  	if (!liveupdate_enabled())
> >  		return 0;
> >  
> > +	err = luo_session_fs_init();
> > +	if (err) {
> > +		luo_global.enabled = false;
> > +		return err;
> > +	}
> > +
> >  	err = luo_fdt_setup();
> > -	if (err)
> > +	if (err) {
> > +		luo_session_fs_cleanup();
> >  		luo_global.enabled = false;
> > +	}
> >  
> >  	return err;
> >  }
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> > index 8083d8739b09..d4ac7b4c5882 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -79,6 +79,8 @@ struct luo_session {
> >  
> >  int luo_session_create(const char *name, struct file **filep);
> >  int luo_session_retrieve(const char *name, struct file **filep);
> > +int __init luo_session_fs_init(void);
> > +void __init luo_session_fs_cleanup(void);
> >  int __init luo_session_setup_outgoing(void *fdt);
> >  int __init luo_session_setup_incoming(void *fdt);
> >  int luo_session_serialize(void);
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> > index 5e316a4c5d71..21cbe99fc819 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -50,7 +50,6 @@
> >  
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >  
> > -#include <linux/anon_inodes.h>
> >  #include <linux/cleanup.h>
> >  #include <linux/err.h>
> >  #include <linux/errno.h>
> > @@ -62,7 +61,10 @@
> >  #include <linux/libfdt.h>
> >  #include <linux/list.h>
> >  #include <linux/liveupdate.h>
> > +#include <linux/magic.h>
> > +#include <linux/mount.h>
> >  #include <linux/mutex.h>
> > +#include <linux/pseudo_fs.h>
> >  #include <linux/rwsem.h>
> >  #include <linux/slab.h>
> >  #include <linux/unaligned.h>
> > @@ -363,18 +365,73 @@ static const struct file_operations luo_session_fops = {
> >  	.unlocked_ioctl = luo_session_ioctl,
> >  };
> >  
> > +static struct vfsmount *luo_session_mnt __ro_after_init;
> > +static struct inode *luo_session_inode __ro_after_init;
> > +
> > +/*
> > + * Reject all attribute changes on the singleton session inode.
> > + * Without this the VFS falls back to simple_setattr(), allowing
> > + * fchmod()/fchown() to modify the shared inode.
> > + */
> > +static int luo_session_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> > +			       struct iattr *attr)
> 
> Don't duplicate, please. Use the generic helper instead:
> 
> int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> 		       struct iattr *attr)
> 
> > +{
> > +	return -EOPNOTSUPP;
> 
> 
> 
> > +}
> > +
> > +static const struct inode_operations luo_session_inode_operations = {
> > +	.setattr	= luo_session_setattr,
> > +};
> > +
> > +static char *luo_session_dname(struct dentry *dentry, char *buffer, int buflen)
> > +{
> > +	return dynamic_dname(buffer, buflen, "luo_session:%s",
> > +			     dentry->d_name.name);
> 
> Use the luo_session:[%s] which is the canonical format for this
> (ignoring historcal abberations).
> 
> > +}
> > +
> > +static const struct dentry_operations luo_session_dentry_operations = {
> > +	.d_dname	= luo_session_dname,
> > +};
> > +
> > +static int luo_session_init_fs_context(struct fs_context *fc)
> > +{
> > +	struct pseudo_fs_context *ctx;
> > +
> > +	ctx = init_pseudo(fc, LUO_SESSION_MAGIC);
> 
> I'd just call that LUO_FS_MAGIC.
> 
> > +	if (!ctx)
> > +		return -ENOMEM;
> > +
> > +	fc->s_iflags |= SB_I_NOEXEC;
> > +	fc->s_iflags |= SB_I_NODEV;
> 
>         ctx->s_d_flags |= DCACHE_DONTCACHE;
> 
> static const struct super_operations luo_session_sops = {
>         .drop_inode     = inode_just_drop,
>         .statfs         = simple_statfs,
> };
> 
> 
> > +	ctx->dops = &luo_session_dentry_operations;
> 
>         ctx->ops = &luo_session_sops;
> 
> > +	return 0;
> > +}
> > +
> > +static struct file_system_type luo_session_fs_type = {
> > +	.name = "luo_session",
> > +	.init_fs_context = luo_session_init_fs_context,
> > +	.kill_sb = kill_anon_super,
> > +};
> > +
> >  /* Create a "struct file" for session */
> >  static int luo_session_getfile(struct luo_session *session, struct file **filep)
> 
> Luo is going full anti-pattern here. This whole return via a function
> argument completely messes up the later codepths. We don't do manual
> get_unused_fd_flags() flags and then file in new code, and then fail
> in-between:
> 
>         argp->fd = get_unused_fd_flags(O_CLOEXEC);
>         if (argp->fd < 0)
>                 return argp->fd;
> 
>         err = luo_session_create(argp->name, &file);
>         if (err)
>                 goto err_put_fd;
> 
>         err = luo_ucmd_respond(ucmd, sizeof(*argp));
>         if (err)
>                 goto err_put_file;
> 
>         fd_install(argp->fd, file);
> 
> Restructure the code so it just becomes:
> 
> struct file *luo_session_create(argp->name);
> 
> static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
> {
>         struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
> 
>         return FD_ADD(O_CLOEXEC, luo_session_create(argp->name));
> }
> 
> and get rid of all this state and error handling. Please fix this.

We cannot do it this way because we must use copy_to_user() to return fd 
via ioctl(), and since copy_to_user() may fail, we must do it prior to 
fd_install().

Unless there is a specific VFS macro you'd prefer for this 
delayed-install pattern, I do not see any other way to do this but 
maintain the get_unused_fd_flags() -> copy_to_user() -> fd_install() to 
prevent the fd being leaked into the process's table.

> 
> >  {
> > -	char name_buf[128];
> > +	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH + 1];
> >  	struct file *file;
> >  
> >  	lockdep_assert_held(&session->mutex);
> > -	snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
> > -	file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
> > -	if (IS_ERR(file))
> > +
> > +	ihold(luo_session_inode);
> 
> Right, you're now sharing the same inode among all luo sessions. So
> you've gained the ability to recognize luo inodes via fstatfs() but you
> still can't compare two luo session file descriptors for equality using
> stat() which is a major win and if you're doing this work anyway, let's

Luca, is there a specific use case in userspace where we need to compare 
LUO sessions for equality?

Christian's proposed solution of using unique inodes provides a standard 
VFS interface, but it introduces some memory overhead and, more 
importantly, a performance overhead due to the extra metadata 
allocations required during the performance-critical kexec blackout 
window.

I do not mind adding it, but I want to verify if this equality check is 
actually needed for your userspace agents, once we extend this, there is 
no way back.

> just go the extra step. You can mostly mirror pidfs and it's not
> difficult:
> 
> // unique inode numbers for the lifetime of the system instead of using
> // the shared ino allocator that can overflow
> 
> DEFINE_COOKIE(luo_session_cookie);
> 
> static u64 luo_alloc_ino(void)
> {
>         u64 ino;
> 
>         preempt_disable();
>         ino = gen_cookie_next(&luo_ino_cookie);
>         preempt_enable();
> 
>         VFS_WARN_ON_ONCE(ino < 1);
>         return ino;
> }
> 
> static struct inode *luo_new_inode()
> {
> 	inode = new_inode_pseudo(sb);
> 
> 	inode->i_flags	|= S_IMMUTABLE;
> 	inode->i_mode	|= S_IRWXU;
> 	inode->i_flags	|= S_PRIVATE | S_ANON_INODE;
> 	simple_inode_init_ts(inode);
> 
> 	inode->i_op	= &luo_session_inode_operations;
> 	// Make sure to leave inode->i_fop unset so it luo fds cannot be reopened via procfs
> 
> 	// Unique 64-bit inode. On 32-bit this will obviously be
> 	// truncated but a) LUO doesn't support 32-bit b) let's declare
> 	// anyone that wants LUO on 32-bit insane c) who uses more than
> 	// 32-bit worth of luo sessions d) if that's really something
> 	// you want to address you can do so later doing the same thing
> 	// I did for pidfs (see there for context).
>         inode->i_ino	= luo_alloc_ino();
>         inode->i_generation = pidfs_gen(pid->ino);
> 
> 	simple_inode_init_ts(inode);
> 	return inode;
> }
> 
> Now you can do
> 
> stat(fd_luo1, &st1);
> stat(fd_luo2, &st2);
> 
> if (st1.st_dev == st2.st_dev && st1.st_ino == st2.st_ino)
> 		return true; // same luo session
> 
> Sooner or later you will want this. Let's do it correctly, right now.
> 
> A bigger design question for the LUO people:
> 
> How do the lifetimes of the luo session and the luo fd relate to each
> other? The way the code is structured it looks like the luo session
> thing that you currently store in the file:
> 
>         file->private_data = session;
> 
> outlives the file? Why?
> 
> Imho, two things should change in addition to the switch to the tiny fs:
> 
> (1) The lifetime of the luo session object should be tied to the
>     lifetime of the session file descriptor so that when the last file
>     descriptor for that luo session is closed the @session thing gets
>     cleaned up. I assume that's the case anyway?
> 
> (2) Instead of stashing the session in file->private_data store it in
>     inode->private_data. This has various advantages:
> 
>     * You can stash other information in file->private_data.
>     * You can at some point have multiple files referring to the same
>       inode/luo session.
> 
> > +
> > +	snprintf(name_buf, sizeof(name_buf), "%s", session->name);
> > +	file = alloc_file_pseudo(luo_session_inode, luo_session_mnt, name_buf,
> > +				 O_RDWR, &luo_session_fops);
> > +	if (IS_ERR(file)) {
> > +		iput(luo_session_inode);
> >  		return PTR_ERR(file);
> > +	}
> >  
> > +	file->private_data = session;
> >  	*filep = file;
> >  
> >  	return 0;
> > @@ -653,3 +710,25 @@ void luo_session_resume(void)
> >  	up_write(&luo_session_global.outgoing.rwsem);
> >  	up_write(&luo_session_global.incoming.rwsem);
> >  }
> > +
> > +int __init luo_session_fs_init(void)
> > +{
> > +	luo_session_mnt = kern_mount(&luo_session_fs_type);
> > +	if (IS_ERR(luo_session_mnt))
> 
> panic()
> 
> > +		return PTR_ERR(luo_session_mnt);
> > +
> > +	luo_session_inode = alloc_anon_inode(luo_session_mnt->mnt_sb);
> > +	if (IS_ERR(luo_session_inode)) {
> > +		kern_unmount(luo_session_mnt);
> > +		return PTR_ERR(luo_session_inode);
> > +	}
> > +	luo_session_inode->i_op = &luo_session_inode_operations;
> 
> Kill all of this now that you allocate inodes on-demand.
> 
> > +
> > +	return 0;
> > +}
> > +
> > +void __init luo_session_fs_cleanup(void)
> > +{
> > +	iput(luo_session_inode);
> > +	kern_unmount(luo_session_mnt);
> > +}
> > -- 
> > 2.47.3
> > 

