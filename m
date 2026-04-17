Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 830E4F99C63
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 20:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EAB86B008C; Fri, 17 Apr 2026 16:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475176B0093; Fri, 17 Apr 2026 16:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CE66B00E9; Fri, 17 Apr 2026 16:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBB96B008C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 16:53:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAB24E3FF5
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:53:33 +0000 (UTC)
X-FDA: 84669248706.17.5D42EED
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id D1924140006
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 20:53:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Eg03xgZr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776459211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWgweBTv8b3MTcGI0y+qlYOhAPey2TLsgfFaPFmrVDo=;
	b=HrRf4EGUxIKF/o/iDYLT/jn82n6YGyo4NWKSMQN40ekAARoJ41W3AU2l/7n9YHOvRAy/IV
	MyCRwK7zK9i0Axxrsyslq+RmSKLjiP7U75Jke4bU2jSAO3nWQg1tytZo5OVpc//Et8sdks
	exu6YRS1OeXX2iUo5qRH4hnkE+R+bNg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Eg03xgZr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776459211; a=rsa-sha256;
	cv=none;
	b=dGWUmfGgJNXlIx4RaLaDGYOeEqdI3Sq6qBScfy5TnN1S/dcxWCP+pMewol0HCdBXWwrkG1
	dodYJHjT+smC4yj2UEuAmu+E1LGzZntG/LAu/Y6uAuRNojg/4uAlJJ6jYpYm2kJhkCuwec
	JnhWUShs7eULtisv1C9t52mnAkWT4UE=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d6b9bca48so13504431cf.2
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776459211; x=1777064011; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWgweBTv8b3MTcGI0y+qlYOhAPey2TLsgfFaPFmrVDo=;
        b=Eg03xgZrL0V2526peJAUXFRBrC8tBl7XqXVf83CG854Lm+6zcF/nZQ5SyhhVlAkHBQ
         0NrC1JDEXw4xfVlR2dlp87L/9otr1ZhuervVfMBqSYGEHnld69DbfReSY9NVmlVcAZPt
         zjVnV7raADBfaQL3wDu11dXf3TusJwACI0q+tMOz/iVUBZgoAXGnXD3sBbygyycYoKyY
         UYDKaJsiglBQRB2tQTn/Y74XAzjXjYNaHwAleOVjGNdAnfgDIeXg0r/OQATE23DaO45r
         dlENG/hmeniXlLXNuGqmcrxeFFzDGiQsPjucL94MEuZDbHhLb8mtsLDAKAPQsxAwmXoB
         8/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776459211; x=1777064011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWgweBTv8b3MTcGI0y+qlYOhAPey2TLsgfFaPFmrVDo=;
        b=SUkDejOAMi/iNjlJm7aeHcNo9+PDyJRGFW/l7KxuVZ94qRBhLxngW3PwA0Dtwun9uk
         hRaUVX3FMAL2t+ZZFZGhNNjNOgn1CRkIzrnbilCz8Z/eDO43k0YRTKuPqtKbfs/qMvsJ
         nyMAyVOBlpZe+oRoeMaiYt2mnyYcz443WwbYsuIkoXXjBiJWjOQNZhZHOtb3dcgQTnEB
         vFXu0hRx+SdrILBB/nNIIwEVA+Bxd8wiDjmIbfg/ZK52j2qmi1B8BV+w4OtTwh7gDQS6
         iNbJEEbvlr3NKrqhbD1b5aTeSXfEYXMBPTc4hPXffOYIr6CYOjKtR5VwETd9+zwIsHFK
         zeuA==
X-Forwarded-Encrypted: i=1; AFNElJ9ZtlJPR9708TMxJCZ+XRXng+t/g7BROYEZyjrOK7lR8WT5UA//PjvSscu1yG8R32mp2pjGmzLlVA==@kvack.org
X-Gm-Message-State: AOJu0Yw7/tOfX3XrfjArOMzps+7Ew3og/GKV/NVxajEzpZ3Py3uxhevw
	kVRrRiXqz2K0UWS9m/evvLLZTdKP+PPeWulbF9ODjHlR6dCX9p7olKl27dJkEA0SNHs=
X-Gm-Gg: AeBDiet5kUm4ePHX2m6e1lVFz4A5ZRpgUtrLuJDDXPRtCPBib41UhFCTQTdFo7DHWGs
	5ekR7rtEFcTMOga/QMdbtos3SKyx97U/QooUZDCX7P76/Bk5QYpURtSr7hp8XsChm/E32WwSX3x
	PPD8vORPm5ycXvUL4ldi1WWT8swdfBUbuZK12pRV4TVUWv21szxCM5R6oTisfwyhD1Sx/Uqbsc5
	BNdjnX8LU3ud0mm6JL1EW1B071XNi/FCFYIZ5mwrzftKh/zBCY+nuOlnsnYEiJ/1bbvtrnR+WzM
	4+Jq1tPavlPJ6ZtMI728iMY7mhKQYkTU2djGhidkd4Xo1VOafoaADf8VrU5KPmC7ifDrMH6mAGH
	l7S7baqvekm2rj6DOvzZDqzhpHKU2ngfdm89ZOpziUhQ7HsundfzEl67bQDY/DwKC+6R2l+MmOl
	pPPXd/2+d96GUNomH5cjFJfoS3S9ty7Bg7TLbHRad8LBaXG/q+xirxcOQ/wPGm
X-Received: by 2002:ac8:5788:0:b0:509:68c:634d with SMTP id d75a77b69052e-50e3682797bmr67515491cf.10.1776459210731;
        Fri, 17 Apr 2026 13:53:30 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e392c8575sm19930751cf.3.2026.04.17.13.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 13:53:30 -0700 (PDT)
Date: Fri, 17 Apr 2026 20:53:28 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org, brauner@kernel.org, 
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com
Subject: Re: [PATCH v3] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <547dc4f7xmafywo7jfeuordj5uwaq5lq4zfdupvswxy5yn5osj@v67ia535jnfw>
References: <20260417204039.1827319-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417204039.1827319-1-luca.boccassi@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D1924140006
X-Stat-Signature: 7tncgum1pmy6hzaw45taun51mzp5phpr
X-Rspam-User: 
X-HE-Tag: 1776459211-241797
X-HE-Meta: U2FsdGVkX1+j46roqaBKQvGTq9vvKEYKS289oSIaPzUlTxMnkOU8ujIJM4ozxwgD9/yKG6Dk5+gthqmBzArpH5FCp21y5HSYEtV4ax/jFJa3fDYYxUmr8lotpKnly5goZSLPgGeXc39d3vCfQiz8ttZuLFnGxx+p7bCdPN/Od1W/ZkBacwQTECwFd8GZJUO9gqhadjHkVnd6sHKuAaIKgzuEgrU00wXvQjIA9k9BCxmVwGt5oSgzWjN3BHPs/bViKj+MFdzQf8zQUwgEHfgqRWStCX2nU5H/tkl9dFhcu82XhXzEgxOgF8qHaD5xOuw0BMsXoPRg6xL5SFLBOeDAt22/VRWpX2kMFmwBVinnsQ2Xyvz3kEIutYtgAHw7759INHB3KmKVLNGWNsYfUl5oAcq4Z4+0Z4zBaOFc8UULIEsVxQic8FT4hafWY5nifVPfRAZY3klDkArA7Mi0TA7/5EHG0phMDu4E2Zz9AHIy2frZdXXqa0Mi5QyFKQlcOgjg4Osvq/41eqngROQ41+OJmFnrkObn5iNw4c6Ytnwa1Xhcg3mnS21YKdrSPeffw7H8IZzS8rqMf6PScttBXeXcs1rluEXFT/U5miCjtaZGz+bbH5byKKJOBy7Zg+124Vi/QI4i7qhmzyQo24wjQaxEEIDkmBCtjYiLQ3oTCOOGncC2fikL5HoRiUSAHLTnaPWzmOgCJAfLnpKXDr0PKwXNygx42qIYxUcUHG34tmP576ptkBQHMpwbQrK3uKdPh8wjyWEWk/ZLvaRi5keXhusB1cMfeXBp7/gNxlFzxHa1xjd0S7ZlrMZtGQ8yuOmqjMccr9exnf/fxGZmczjdl0NICojAeptdu85p/FRs3CCMQJNLgCIVNUpLga6ly0TiHOAuhzZW7We3ayRafssE6aKzY3YWGdS4qI6JGk+QmwGoLo8qHMoN2ZtUT1lAq0xUrXlqFBQNCkBNX0lCB9m9zbn
 Y8sbdwXN
 QKwEy96J6ykSDIY/G7LRATCjUIFU2oS17UASwqxZpgE14u0fAUUEneUa3mWgFAWnnj/BsClPgxu8nNOBc0qNOUWNq29dB9kxaAS8C3JhUNyinwDJNSOP00d27zsfCpWR+3OHFqr0ZrvyNAO3pZTqovr0zBOMEzdQuHYauN5ubSUomjC5goCmIeIghBUW75WHwrLoRtHdc+aS48HD3oijNVq2As1ypWpCK0WQp5LYjgD0gN2dAavCjXSptEbyJQD46XtK3zlZlpQSefVaoYMKlgTsDcv518n8lJxEUMQL2Ghl8DAplFzoEvSs5h1EqtVeiwOLyd6B7l8JLpwPS6nlADodIxb8UUhUQAUu9S+b11yfzEc9u2VcyoQY6n76pbwFSIJogUT6trls3BOYmBf9pr+Izg0M+tXgqMF/u6lJ5Xci64biAt9mPSBnchL/T/0zW5CDuH617sz/DrKm/cgZBOZrXOQmG13q8L0FRYjfVrQoIli+dRCXWCFY6WlVCD14sy4ITUqi3U57CfD6h8p6kwMezMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-17 21:40, luca.boccassi@gmail.com wrote:
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
> programmatically identify a fd as a LUO session via fstat().
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> ---
> This was requested by Lennart and Christian when discussing integration
> with systemd for LUO management.
> 
> v2: apply one fix from bot review about cleanup on error path:
>     https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
>     the other comments are invalid: luo is not a kmod, and the write hooks are not set up
> v3: add test case to liveupdate selftest

This should be split into two patches, also please CC:
linux-kernel@vger.kernel.org

> 
>  include/uapi/linux/magic.h                    |  1 +
>  kernel/liveupdate/luo_core.c                  | 10 ++-
>  kernel/liveupdate/luo_internal.h              |  2 +
>  kernel/liveupdate/luo_session.c               | 73 +++++++++++++++++--
>  .../testing/selftests/liveupdate/liveupdate.c | 40 ++++++++++
>  5 files changed, 120 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 4f2da935a76cc..4f51005522ffe 100644
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
> index dda7bb57d421c..f1a63ebe4fa44 100644
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
> index 8083d8739b093..d4ac7b4c58829 100644
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
> index af9e498206d24..f30151c37bd43 100644
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
> @@ -376,18 +378,58 @@ static const struct file_operations luo_session_fops = {
>  	.unlocked_ioctl = luo_session_ioctl,
>  };
>  
> +static struct vfsmount *luo_session_mnt __ro_after_init;
> +static struct inode *luo_session_inode __ro_after_init;
> +
> +static char *luo_session_dname(struct dentry *dentry, char *buffer, int buflen)
> +{
> +	return dynamic_dname(buffer, buflen, "luo_session:%s",
> +			     dentry->d_name.name);
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
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	fc->s_iflags |= SB_I_NOEXEC;
> +	fc->s_iflags |= SB_I_NODEV;
> +	ctx->dops = &luo_session_dentry_operations;
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
> @@ -662,3 +704,24 @@ void luo_session_resume(void)
>  	up_write(&luo_session_global.outgoing.rwsem);
>  	up_write(&luo_session_global.incoming.rwsem);
>  }
> +
> +int __init luo_session_fs_init(void)
> +{
> +	luo_session_mnt = kern_mount(&luo_session_fs_type);
> +	if (IS_ERR(luo_session_mnt))
> +		return PTR_ERR(luo_session_mnt);
> +
> +	luo_session_inode = alloc_anon_inode(luo_session_mnt->mnt_sb);
> +	if (IS_ERR(luo_session_inode)) {
> +		kern_unmount(luo_session_mnt);
> +		return PTR_ERR(luo_session_inode);
> +	}
> +
> +	return 0;
> +}
> +
> +void __init luo_session_fs_cleanup(void)
> +{
> +	iput(luo_session_inode);
> +	kern_unmount(luo_session_mnt);
> +}
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index bdc1cedc4f944..27b3cbff6c739 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> @@ -22,9 +22,12 @@
>  #include <fcntl.h>
>  #include <string.h>
>  #include <sys/ioctl.h>
> +#include <sys/stat.h>
> +#include <sys/vfs.h>
>  #include <unistd.h>
>  
>  #include <linux/liveupdate.h>
> +#include <linux/magic.h>
>  
>  #include "../kselftest.h"
>  #include "../kselftest_harness.h"
> @@ -416,4 +419,41 @@ TEST_F(liveupdate_device, get_session_name_max_length)
>  	ASSERT_EQ(close(session_fd), 0);
>  }
>  
> +/*
> + * Test Case: Session fstat
> + *
> + * Verifies that fstatfs() on a session file descriptor reports the
> + * LUO_SESSION_MAGIC filesystem type, and that fstat() returns consistent
> + * inode numbers across different sessions (shared singleton inode).
> + */
> +TEST_F(liveupdate_device, session_fstat)
> +{
> +	int session_fd1, session_fd2;
> +	struct statfs sfs;
> +	struct stat st1, st2;

Reverse-christmast-tree order please.

> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd1 = create_session(self->fd1, "fstat-session-1");
> +	ASSERT_GE(session_fd1, 0);
> +
> +	session_fd2 = create_session(self->fd1, "fstat-session-2");
> +	ASSERT_GE(session_fd2, 0);
> +
> +	/* Verify the filesystem type is LUO_SESSION_MAGIC */
> +	ASSERT_EQ(fstatfs(session_fd1, &sfs), 0);
> +	EXPECT_EQ(sfs.f_type, LUO_SESSION_MAGIC);
> +
> +	/* Verify both sessions share the same inode number */
> +	ASSERT_EQ(fstat(session_fd1, &st1), 0);
> +	ASSERT_EQ(fstat(session_fd2, &st2), 0);
> +	EXPECT_EQ(st1.st_ino, st2.st_ino);
> +
> +	ASSERT_EQ(close(session_fd1), 0);
> +	ASSERT_EQ(close(session_fd2), 0);
> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.47.3
> 

