Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081D260A3833
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=To6Sp7pJ
Received: by kanga.kvack.org (Postfix)
	id 15E456B0695; Fri, 13 Nov 2026 05:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136786B0698; Fri, 13 Nov 2026 05:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2696B0699; Fri, 13 Nov 2026 05:15:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C45296B0695
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:15:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BBFE1404E5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:15:20 +0000 (UTC)
X-FDA: 85429688400.14.4BF14D6
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 557FF1A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:15:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=To6Sp7pJ;
	spf=pass (imf19.hostedemail.com: domain of alex@amutable.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
	b=OSvJcNq0k4mfuA+F6fo4Al/QUENYQDxOaDf81HbAydtjfVnVWoksqoGO2kPeqCryTFPcnr
	a3o6iKBeEM1vvAEsw+FzTrLwtyxllTUrdaNaaeAtJtroNG3JIuGQTkOytKeH+HMS+MR9oj
	rPjyYhYS8Q6zU34fruP3u3IZ/0oQgFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564918;
	b=tCl5l+skLNNRvALxepQhT3ox2d723hHZWiQP2XuFZc4jo5YMyWFf8UZfP1bs1KreIjdsO6
	XimNYzWfalf4AuCrP7NSrl18s0bk73Pn3DY1D0ZnlmvoBXx6O6kh0ADeLVGA13tiMtWZVh
	8uL6HPLnjw0g20HasTQtzlMPmw3DBZ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=To6Sp7pJ;
	spf=pass (imf19.hostedemail.com: domain of alex@amutable.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so4413375e9.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564917; x=1795169717; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=To6Sp7pJWfu5EjSP/ZMidDvHgKYAJDKHa8YTI1wvCrMX79PVcowsVGMqnuSEgdWpN5
         eSEM7N8BP7QlKiIlerct97YZ5YF8CBeOtXaJRPUkvzQXuLPv9HOUAyObnYvVc7zLxTJP
         Bl2/F40LpzkDMPXuKboLPlDhtXvh5cSjnllTQF+zEdwDdszXOqy68EiLlWCwQ05desAb
         kDxkHwyADsNY3glN+g+NJHeSUMlABLUxfg7IGp1jJsbsT58dcDQVPG0hj95bgAIl/qAB
         0IHnpUQ3p+nvA6t3TPizSsQFc48VE8Z6PzmFF8XOb3eLg6FZGuE7w7FWGxZS42inDl6c
         KKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564917; x=1795169717;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=ON8JNF8FGjsDQX0yf3FqRsX4DeTNuT3xLEOp5chb7LbFFtkCO+ZsGLY6hak1/HyuA1
         8yXz35r/5yw8oxvwjIEGeMuRHA/wX+FzfaBHC1GFUaia6lqZ+N753nvTdPu1M80Hopwk
         kw94ZhR83DsFYOxTuDW8dPEeGrZIT9N+7RyUQIqUuArwl7i2BJobJoJgDJnWXXhyJmos
         eXvwn69bE2x7E4eby5DwFnEtRF5brIwMWIcNbk8KoHzGtQq7r+AyzbKSYe/4jPxa0JTF
         iDvyAh1iNRvCNuc1NJVgVQ/JpI8YCJSvrg7lFP2VtMTzN8MjH1MEo+vMJmkQ6g2Lo5J3
         7Yig==
X-Forwarded-Encrypted: i=1; AL+hErF0q1WMdOs40mK9MTIZS4uhpTSOCE9IBfqusn94IeqPrV1DD6LUyntnFzLccP2pNa4SZUj4ReLnkA==@kvack.org
X-Gm-Message-State: APuU4Z/DtRxARRTVe3xywSmeCjvfUxOALufdEj+0nYLI8xnQpKmh+3W3
	pUciBIk+IZPpR784LHMd6q1oC9suXnMnfdV895wdWkDO6DDal37USBxz4EjMypyqbcJF
X-Gm-Gg: AYBFou0tArjlr9Nxit8qN5cIBk1Kay2CqpuGftgGgryBenao95S6jl8Mk9dHumPhgRm
	viG5chM8cVINqdUOQCEEXS3DDGa0EcLpucC9e7Yon/Xk9Y6fYIatzTfWpbpShyF7fE3Qtbt5M0h
	RfGLHan79A/g0hAP+7MWVh9f1JL0imp7Jv2826YGbC+S0lyOs+oKTP6AY+IOL+QezAXnnzWrMQT
	6AqDVs0rXK19fX1IoYyJiR8Oa7tRtuR/waw5p2fWqOO5M8tIA571p1QV3H3bgjj3mpkmaFUzHLO
	xdcOUkJK7fUWlE2Iy4lKn46KzJWzknNmcXLzGwZeTxJdVjShLbK2dsErPaGeEXYRVw1sFkjcSKz
	RzgjGuzZLLbgVweN/EBK/AOe5rjIWKWgYpi/c8N9Dkfy6bLmCJXUDQvJZRA8KcSjIU3cf7/sd/9
	sbgpWBp3a0RmRK5c6muXSKPnORmEeAan8oeYpdlBFfax1TuKSGyls/NsvriphdovhkYz3CXeMTB
	qoJDUvNBGptbpNzlNxcAKS/g+oAH9APEd01rsxIKz3XxvL4LVdV+Mh3wjuJ/HlZa/zDampdftfr
	46K4CPGGOeWw5wFoimbpFKyWe7QGbn6fFVy869NUSmKRKwQH7Hjnq+geZDKyUO8=
X-Received: by 2002:a05:600c:4f84:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4bb5599ade1mr43492835e9.0.1794564916955;
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56680ea9sm31982365e9.0.2026.11.13.02.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Message-ID: <e2edfa06d185acd86b46945622b6eb6dff97b307.camel@amutable.com>
Subject: Re: [PATCH RFC 33/41] fs: add file_is_pseudo()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:15:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: j4qbm1x594ajhzeam9fnfzygworjamtf
X-Rspamd-Queue-Id: 557FF1A0002
X-Rspam-User: 
X-HE-Tag: 1794564918-853087
X-HE-Meta: U2FsdGVkX19riVhj3QCjUU6Mx8B86GENkDHhOB0yezlcKSV1VRcX8YyiB5pKscTtQrHRkvPMT36LT3RHUOumO1ABUUv8Rlm10Gm/tT9WN46pY6SFcD19fCnu6wGQhMeZKEUTcHyzKvD7Vcf4PO6B7hzWKsAn6+F1VQQvhdMpCumWq8YDwu4wtJyuYJwxaJUTNqUJ1IKl76hQmoYTJLzK3lAu1/P4jPkIWsiwP38HhXV5SBob91DW+kOORTfur5TBOkQEPxBtV8/lXVx82pDITR7k4QSOm1BKVLB3d4qeEH6FF/bxghKYDC6BpZ3oiy77hHzm/Q9+F2a1nrsLXZa8IqN6HpFP9fh23sbVeBMgmKcwuyh7ypo6TLOWIICKRw8PxL6K+uIYe27o+iB2ik1ItrsYZCPWEf3Iob4MIWbVmIgFIdl+63jzCJRPURZyKFBT7S7SdUkY+Q90gtwuFfQRNge5gY+jPtG1EQJHf/K5kfj8gyZ/UpAMbTscO4TYgdgdyjtTjxn1NkqdurH0N5IJ4NBmmrtWKVqnaxKtFFeTy/3m1410jv1QblftQbp8rxa/S6XEArIbZskYscKTI7LQPKUqon5MMh4CW5N9Y1kbgFm1y7r9QOi3Kn0rSqvEBm8JAI4wTpHZYQn2bdO9Oav55aiqYZUqrmp/sFhexm2RUuAnbJexQ8AoxQr/YZCkkw3qo8Av4kivgWIMhg9EAWtZEA5w5lUzJQc6r6LJpWKaa6WVewVDUpFH+bM+HjzqrDu8B5fA6ntYJC1yBO6Hwx6bjFClUFTHluv1we7wFf8EuyDJrJec7cAlplmXSsIh4lTt+JQnJSYGxYMlVvu7UelI2in8q98KhM8Gaq4VbPIAAr/pAS0Mo1K1fYyV6QVXtZUfpiaoyIMuDaNoNOB85s2UD00hZ36fTE3k1lReLZOgxl2FkTG9Iuu3q09IDP5SBFdC4P6OvlbXiphAoYSAINL
 wBrziaMc
 4l3hwxsiOM5mpYbp14dEimdLla00z8u0Ce+hCcPbmXiAgxDHMjS0fPJD1CvDgojsp7stkmF5JS+Ovon94uC+3EU0bDoF2YbIFbLuV4FPB1YuPUUaXWfpsUgsUGdOGd5sot2555rIpbGeABns71B+AgfUkPUISPNsx30TaZ/BfB2Vg9mG+RsMpP82NGfOqE/FJHuF7NFwC2NeY4Ln0iCq14u69ow4hnC0kIbBUEexoe2eIuHHxG53h91/jdVnm5TxvL7G6E8d+597sWgFqos+xMLSzqZXnIbb+A1AtxLkwIwUfTXnRtSigqCEo4MEY9GSOl8yoCz/hGqOQ4lVQ2Gp2ILx8Y6dybwcW7LpHmd/op3wIQcDUvkBN6hf2/+dE5tqBhOpDJyzd5wo2900EGBUa6l7C5b/bimYPjaRpOrMbC7VtM8IS4dwikhFXANgnscHjYZ27qizjJjPza1cIAyKDAF4yT7C7reulEgq0e4i4sueFWfK6pdZxiWwH7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Add a helper to check whether a file is a regular file on a pseudo
> filesystem. Only regular files count. Device nodes on pseudo
> filesystems
> such as devpts, binderfs or the block devices on bdevfs are what they
> are.
>=20
> Look at the inode that actually provides the data via d_real_inode().
> overlayfs accepts sysfs, cgroup2, debugfs, tracefs, configfs and
> securityfs as lower layers and reads of such an overlayfs file are
> served by the file on the pseudo filesystem. Checking the overlayfs
> inode would miss that.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0include/linux/fs.h | 12 ++++++++++++
> =C2=A01 file changed, 12 insertions(+)
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..407ffb6342ec 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,18 @@ static inline const struct inode
> *file_user_inode(const struct file *f)
> =C2=A0	return file_inode(f);
> =C2=A0}
> =C2=A0
> +/*
> + * Regular files on pseudo filesystems are kernel interfaces and
> must not be
> + * used as storage. Look through stacking filesystems at the inode
> that
> + * provides the data.
> + */
> +static inline bool file_is_pseudo(const struct file *file)
> +{
> +	const struct inode *inode =3D d_real_inode(file-
> >f_path.dentry);
> +
> +	return S_ISREG(inode->i_mode) && (inode->i_sb->s_iflags &
> SB_I_PSEUDO);
> +}
> +
> =C2=A0static inline struct file *file_clone_open(struct file *file)
> =C2=A0{
> =C2=A0	return dentry_open(&file->f_path, file->f_flags, file-
> >f_cred);

