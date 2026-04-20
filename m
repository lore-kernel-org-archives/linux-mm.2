Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38612F588EA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 15:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131206B0088; Mon, 20 Apr 2026 11:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E22B6B0089; Mon, 20 Apr 2026 11:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3ACA6B008A; Mon, 20 Apr 2026 11:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E462F6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:57:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BD52E56D8
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:57:57 +0000 (UTC)
X-FDA: 84679390194.18.598992E
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id A247CC000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:57:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VSNiZsff;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776700675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbmNztbEwLmjR0RQpM+PbvDofjBnkY5DWnlmbtfJfNk=;
	b=8OI75fYPTgVtSIxVztkZYoGpQjYsCeOpbM6jMdVx2nS455oi7mbdtRksYV9RtnTWjUJY34
	r4P/SoVQLJ9rYZUjHrJZY6ukhrvJE8R+XuqANiU2X5NOvC7IjLVwW4IVYDXZH9nAoVEVub
	cs3bKPInBnNr7N410i0MGQmyA8tsegY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776700675; a=rsa-sha256;
	cv=none;
	b=vRx/w9HR4LSLpRg3Zj6VFrNDch6fW79HYvBbcdBf6AL4zWHXHpVpGWzafbaLcTlqnU/Z9S
	CB0fbW2K9stud5Ttifqn5L0Wm2WQweySreldoU21BkRF2x9y2RJvp4/qMb6wVMG3zS5ir2
	cKdVDzFPY2bOCg+Ed3lfsBPStkBiFkI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VSNiZsff;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a58057d7baso40369216d6.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776700675; x=1777305475; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lbmNztbEwLmjR0RQpM+PbvDofjBnkY5DWnlmbtfJfNk=;
        b=VSNiZsffi+T0JOQpC5zEXFYV19XEoj7bbUTb4CgsoZRBInjau79vH94OJ5KGk6N2W+
         eEtmrtELX0djtPK8j+FvU6s6Qrzt7s3M+SCPgwUDeGNVzyYkPmwmJq7rmTox66T8gw4F
         bu9QaapS0J833BvrM0E5LTOnCeX5KSZFrQx6vT0XbenPsL5kySz3kt4tVYnf6bZqfyJ9
         v3d7GNx7VZnPF8Fs/oOBFwJwbUArq5fHikzK6Wd/a+rn+ydU7FWkkfE1sD/xPydiXtXe
         Ph9q5sfeE4TQF0BbR1BsdeB7Y8Spc007RBE+CxzVnduKkXrNfo1VDahfNWmwX2X8V+Nv
         6mcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776700675; x=1777305475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbmNztbEwLmjR0RQpM+PbvDofjBnkY5DWnlmbtfJfNk=;
        b=GP5DmS7ZcdxMQQyfth/Pmu2moS3fKv1ojgR+kyBrbm6/8D+3n6NpPdWqbCgZBQCYVY
         zFTo7fLmw0Ne2893u24IiH2VBSxHWZilafMNf5fvYKS0qLDB0FHIn/f/Po0SKJ2AMvkf
         ByZ6/soTR67cB9ieHqrtP3all6kUDx8xs+WuuN5vABJInHFZyDMRL3o35Yi43y4NUHAD
         Lmzus2mmit6+rHoEH9FteePT0e8ADdm3Cp+Y/2ce/vxgbTEdlSQNgCL6A119hM87UdLT
         Zh7z4oUK97aQbxwqjnaxyrhcgC+iRq5YFZ0pFEkQSmgOkUkP3bNeOFLBKia1FbpnoyXY
         JCtw==
X-Forwarded-Encrypted: i=1; AFNElJ/ZNhv3UUaFcyC3RhNbYyMEhnNdVGYzxGexw84QQ0PG1PaAM41SyvA/aaseIEdW4IGeti5Exy7ZMQ==@kvack.org
X-Gm-Message-State: AOJu0YwiKSMFZG0EYm/Amos2YCBvg7NDty5phzbxZblyoGts/3i0f2Qs
	OKr2wT13XE3ZJdqCH4zXvC0N21dVRucDp0TfYcWI7UASk9aQIPzIfUDwNxpUeeLj3f4=
X-Gm-Gg: AeBDiesAA22uCkL9GkONgVm1hHaTsTryDDwETHVE3RAJNOQ7U6Qu6PwvbTIdPkAlZE5
	4uBdMX9jCNMvGHJ3U6tlvsEiIX992Jc+oBaSIkaqQfJMNgtSSN2h0Y3PUcvw3+tx48YI5mC66JA
	QRr5FlH1Sgk5BhgNbAZz+5IhOgrFD9z9qh/t4ZWYUH/Y0dt+iV82g9hSJSqxvD1VRUfQti2BTNF
	BOA+QdTL9ZScE1xbfnXm81MhTL53n/RprfWEv745EBetfk59fPCb0S8larM6nSAq53IocqoJ+6w
	jEK2ZzBRAPzEM5y7T5ZJJFlcLr7Mn0YsAK7/D1HsKo8ugiajQDVT75+mKtWesEzVUpqj67JvxOn
	m8rZx5wupVAYmyGTnMMP57sAzddYZp1yxFFubxEHXDYp+el0EipbO82bzVYB9S/8R7h1lqP3fKO
	XYXFzU1jF+m9nqk/zmXE+bNs7X5xZTkZ2JBXZMSol7bF9wpGpbWVMx+3r4Dpzf
X-Received: by 2002:a05:6214:4602:b0:89c:4f7f:8479 with SMTP id 6a1803df08f44-8b027ff9872mr248267446d6.6.1776700674494;
        Mon, 20 Apr 2026 08:57:54 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac7d4e6sm79178796d6.20.2026.04.20.08.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 08:57:54 -0700 (PDT)
Date: Mon, 20 Apr 2026 15:57:53 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, luca.boccassi@gmail.com, 
	kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, rppt@kernel.org, 
	pratyush@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <fkz5u3nhgdm5k5qc77rioxon5gaxdgu7uuedqtixjq5evqrkzr@g23edpj4vmyo>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com>
 <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
 <xpi24rt5ek2m2wkhv6celu75hgtgte2x4jhfkjar4gi22r7bdh@ilbxbhfxmm2v>
 <20260420-buchung-panne-57e262f5057f@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420-buchung-panne-57e262f5057f@brauner>
X-Rspamd-Queue-Id: A247CC000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 7mb9s7z91e9r5b1eimfqpofkqbyj91jw
X-Rspam-User: 
X-HE-Tag: 1776700675-27480
X-HE-Meta: U2FsdGVkX1/5LlNyilKaRIts52/4NRhBE/EmtpbsbYpVTYdnR01HVwRsgaXZh4Jq4yXf9lJDC4RpBlaKQPKeqvCmR16ZxtQ3fOAax30gNdhqVsyFPwpGOlb40i0xBRorMWDwI414RXjOHJRbDfOfhj1F1/V5DNgY24piCUG9B2czW2wbp7HV1dnztw9iXucyJhPxNkQYif7aP7/XwJ8bicKQqHKbIBrEM0NDIYEvPQLBktKXxofPVSIKpN250eSmKIbfPPRGZEYy1ZJidg45NTFilEVoLO5902ObZDhj2iZ9m/5RFJR2eySn6itTdat3kmTf1RWS1zMq9iTdeDmoABj3byz25WJdwob/lLwpyk3tdnfmoWAst6rVOnwxgH1NOJe3SFvJLRAkuUha1Y2cuK52TSFvhHRemfWjRS9UFwXhXcdxnXkXRWYiTA1eaGX721WNE63tv3r58SEG0VMZ1Hwbope8wIvYqY3L1RMitbl76KhhwElEmXHEsOel1yz8IebNuwhLhblgTayol0Lw43oKPaK0F2Sh2aaoadV8EqeKzet+6I1dsPl7bskjdo7iudRqeneYl1wjM4pv2Q/LpFfpxjtwo25I+78k/ub5KMH01IghqyvyD8o5Nfrh5BSs/bMzjzx3pETzcI0CURxnjDGCeRjc111mDOBJ3+VsJyaFS0DZgGt5NVGmmGiI+ij9n6RSVwnsUjeGN7e2KFI7T/1JFgDI0IdlEtTn0Czt5BeRtcSlOiB9UfpN1oRnRKMYNLcsKc8YUIP1ZRLGPJ7vVPqtd7WVHwt8HgFsdH9b6wwVHpQoKrtEQu1NYMENevmAkizUoDH5pBoij02aG4yhWHv9t7lECAAVktAQFiqobNk7xiWGnm3VXrNQ6vzRnhJVdgnS2LgDkh42ws9Y5//yFu/JpW9Izn2Xqo0o+iw/knjytTJgrs6OBLSJvNp725KEWokPLFd48faL5OFEf9D
 zsYJgVeg
 ZlzckGIGd/tjMENJYXGIQZMTSJYtOPaoMMDwuCtKEV9ihs9xdugNACRkIpAmViP8WC2zpXfxLz0PJYuvEF+rm79uJecuXVFvYRBTk6EEfXaGn0NwK1KQEW/yEsNP5jujXRBsTHQgeTyvYfo8V5COEeEAqNSpHDW0gRt6NuPU5jniTo7PaOCzCPySrMrR2H+TmzPDpnh4s2k9VeCIhm0LQo7WvcvHtZx196cAc1mlQ1Wx21JsL6nODsGzRZZvd1jjLPNCCc79EcvA1yrs8a53ER3KMP4Y8jMy0c1gcfPgAozvCi/qw7qDJcRuyncZYZD8v22hBTswlQrbdJGdeWb0l1cJq61/nnOHK2BcNwXWQ1eDM92OZMT74X/hpVObGYN4BFPJhssuT57CRGyExBjuLHr/8NzwbPGyueK8VZYayTK+hWz356DnMGvrMr/wTNbmm8kRHJSk9X82kVaVkaAZeiJn04xw078bLtxdJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-20 17:28, Christian Brauner wrote:
> On Mon, Apr 20, 2026 at 02:55:56PM +0000, Pasha Tatashin wrote:
> > On 04-20 14:26, Christian Brauner wrote:
> > > On Sat, Apr 18, 2026 at 05:28:20PM +0100, luca.boccassi@gmail.com wrote:
> > > > From: Luca Boccassi <luca.boccassi@gmail.com>
> > > > 
> > > > In userspace when managing LUO sessions we want to be able to identify
> > > > a FD as a LUO session, in order to be able to do the special handling
> > > > that they require in order to function as intended on kexec.
> > > > 
> > > > Currently this requires scraping procfs and doing string matching on
> > > > the prefix of the dname, which is not an ideal interface.
> > > > 
> > > > Add a singleton inode type with a magic value, so that we can
> > > > programmatically identify a fd as a LUO session via fstatfs().
> > > > 
> > > > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > > > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > > ---
> > > >  include/uapi/linux/magic.h       |  1 +
> > > >  kernel/liveupdate/luo_core.c     | 10 +++-
> > > >  kernel/liveupdate/luo_internal.h |  2 +
> > > >  kernel/liveupdate/luo_session.c  | 89 ++++++++++++++++++++++++++++++--
> > > >  4 files changed, 96 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> > > > index 4f2da935a76c..4f51005522ff 100644
> > > > --- a/include/uapi/linux/magic.h
> > > > +++ b/include/uapi/linux/magic.h
> > > > @@ -105,5 +105,6 @@
> > > >  #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
> > > >  #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
> > > >  #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
> > > > +#define LUO_SESSION_MAGIC	0x4c554f53	/* "LUOS" */
> > > >  
> > > >  #endif /* __LINUX_MAGIC_H__ */
> > > > diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> > > > index dda7bb57d421..f1a63ebe4fa4 100644
> > > > --- a/kernel/liveupdate/luo_core.c
> > > > +++ b/kernel/liveupdate/luo_core.c
> > > > @@ -197,9 +197,17 @@ static int __init luo_late_startup(void)
> > > >  	if (!liveupdate_enabled())
> > > >  		return 0;
> > > >  
> > > > +	err = luo_session_fs_init();
> > > > +	if (err) {
> > > > +		luo_global.enabled = false;
> > > > +		return err;
> > > > +	}
> > > > +
> > > >  	err = luo_fdt_setup();
> > > > -	if (err)
> > > > +	if (err) {
> > > > +		luo_session_fs_cleanup();
> > > >  		luo_global.enabled = false;
> > > > +	}
> > > >  
> > > >  	return err;
> > > >  }
> > > > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> > > > index 8083d8739b09..d4ac7b4c5882 100644
> > > > --- a/kernel/liveupdate/luo_internal.h
> > > > +++ b/kernel/liveupdate/luo_internal.h
> > > > @@ -79,6 +79,8 @@ struct luo_session {
> > > >  
> > > >  int luo_session_create(const char *name, struct file **filep);
> > > >  int luo_session_retrieve(const char *name, struct file **filep);
> > > > +int __init luo_session_fs_init(void);
> > > > +void __init luo_session_fs_cleanup(void);
> > > >  int __init luo_session_setup_outgoing(void *fdt);
> > > >  int __init luo_session_setup_incoming(void *fdt);
> > > >  int luo_session_serialize(void);
> > > > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> > > > index 5e316a4c5d71..21cbe99fc819 100644
> > > > --- a/kernel/liveupdate/luo_session.c
> > > > +++ b/kernel/liveupdate/luo_session.c
> > > > @@ -50,7 +50,6 @@
> > > >  
> > > >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > >  
> > > > -#include <linux/anon_inodes.h>
> > > >  #include <linux/cleanup.h>
> > > >  #include <linux/err.h>
> > > >  #include <linux/errno.h>
> > > > @@ -62,7 +61,10 @@
> > > >  #include <linux/libfdt.h>
> > > >  #include <linux/list.h>
> > > >  #include <linux/liveupdate.h>
> > > > +#include <linux/magic.h>
> > > > +#include <linux/mount.h>
> > > >  #include <linux/mutex.h>
> > > > +#include <linux/pseudo_fs.h>
> > > >  #include <linux/rwsem.h>
> > > >  #include <linux/slab.h>
> > > >  #include <linux/unaligned.h>
> > > > @@ -363,18 +365,73 @@ static const struct file_operations luo_session_fops = {
> > > >  	.unlocked_ioctl = luo_session_ioctl,
> > > >  };
> > > >  
> > > > +static struct vfsmount *luo_session_mnt __ro_after_init;
> > > > +static struct inode *luo_session_inode __ro_after_init;
> > > > +
> > > > +/*
> > > > + * Reject all attribute changes on the singleton session inode.
> > > > + * Without this the VFS falls back to simple_setattr(), allowing
> > > > + * fchmod()/fchown() to modify the shared inode.
> > > > + */
> > > > +static int luo_session_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> > > > +			       struct iattr *attr)
> > > 
> > > Don't duplicate, please. Use the generic helper instead:
> > > 
> > > int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> > > 		       struct iattr *attr)
> > > 
> > > > +{
> > > > +	return -EOPNOTSUPP;
> > > 
> > > 
> > > 
> > > > +}
> > > > +
> > > > +static const struct inode_operations luo_session_inode_operations = {
> > > > +	.setattr	= luo_session_setattr,
> > > > +};
> > > > +
> > > > +static char *luo_session_dname(struct dentry *dentry, char *buffer, int buflen)
> > > > +{
> > > > +	return dynamic_dname(buffer, buflen, "luo_session:%s",
> > > > +			     dentry->d_name.name);
> > > 
> > > Use the luo_session:[%s] which is the canonical format for this
> > > (ignoring historcal abberations).
> > > 
> > > > +}
> > > > +
> > > > +static const struct dentry_operations luo_session_dentry_operations = {
> > > > +	.d_dname	= luo_session_dname,
> > > > +};
> > > > +
> > > > +static int luo_session_init_fs_context(struct fs_context *fc)
> > > > +{
> > > > +	struct pseudo_fs_context *ctx;
> > > > +
> > > > +	ctx = init_pseudo(fc, LUO_SESSION_MAGIC);
> > > 
> > > I'd just call that LUO_FS_MAGIC.
> > > 
> > > > +	if (!ctx)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	fc->s_iflags |= SB_I_NOEXEC;
> > > > +	fc->s_iflags |= SB_I_NODEV;
> > > 
> > >         ctx->s_d_flags |= DCACHE_DONTCACHE;
> > > 
> > > static const struct super_operations luo_session_sops = {
> > >         .drop_inode     = inode_just_drop,
> > >         .statfs         = simple_statfs,
> > > };
> > > 
> > > 
> > > > +	ctx->dops = &luo_session_dentry_operations;
> > > 
> > >         ctx->ops = &luo_session_sops;
> > > 
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static struct file_system_type luo_session_fs_type = {
> > > > +	.name = "luo_session",
> > > > +	.init_fs_context = luo_session_init_fs_context,
> > > > +	.kill_sb = kill_anon_super,
> > > > +};
> > > > +
> > > >  /* Create a "struct file" for session */
> > > >  static int luo_session_getfile(struct luo_session *session, struct file **filep)
> > > 
> > > Luo is going full anti-pattern here. This whole return via a function
> > > argument completely messes up the later codepths. We don't do manual
> > > get_unused_fd_flags() flags and then file in new code, and then fail
> > > in-between:
> > > 
> > >         argp->fd = get_unused_fd_flags(O_CLOEXEC);
> > >         if (argp->fd < 0)
> > >                 return argp->fd;
> > > 
> > >         err = luo_session_create(argp->name, &file);
> > >         if (err)
> > >                 goto err_put_fd;
> > > 
> > >         err = luo_ucmd_respond(ucmd, sizeof(*argp));
> > >         if (err)
> > >                 goto err_put_file;
> > > 
> > >         fd_install(argp->fd, file);
> > > 
> > > Restructure the code so it just becomes:
> > > 
> > > struct file *luo_session_create(argp->name);
> > > 
> > > static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
> > > {
> > >         struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
> > > 
> > >         return FD_ADD(O_CLOEXEC, luo_session_create(argp->name));
> > > }
> > > 
> > > and get rid of all this state and error handling. Please fix this.
> > 
> > We cannot do it this way because we must use copy_to_user() to return fd 
> > via ioctl(), and since copy_to_user() may fail, we must do it prior to 
> > fd_install().
> > 
> > Unless there is a specific VFS macro you'd prefer for this 
> > delayed-install pattern, I do not see any other way to do this but 
> > maintain the get_unused_fd_flags() -> copy_to_user() -> fd_install() to 
> > prevent the fd being leaked into the process's table.
> 
> The usercopy happens in luo_ucmd_respond it's perfectly fine if that
> fails. FD_ADD() handles all that. It reserves an fd, it opens the file
> and if that somehow fails it cleans up both the preallocated fd and the
> file (And if you need to do more stuff in between there's: FD_PREPARE()
> + fd_publish()).
> 
> What I meant is:
> 
> 	static struct file *luo_session_open(struct luo_ucmd *ucmd)
> 	{
> 		struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
> 	
> 		err = luo_ucmd_respond(ucmd, sizeof(*argp));

The fd is returned in 'argp->fd', not via ioctl() return value. so this 
response won't contain the fd number that will be returned to usersapce.

This is similar to how it is done in iommufd for example, see 

iommufd_fault_alloc()
	cmd->out_fault_fd = fdno;
	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
	fd_install(fdno, fault->common.filep); 
	return rc

Pasha

